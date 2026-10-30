/**
 * Ask Nono — Cloudflare Worker proxy.
 *
 * POST /ask-nono  { query, context }
 *   -> builds a RAG prompt grounded in Omar's portfolio content
 *   -> calls Cloudflare Workers AI (streaming)
 *   -> streams the answer back as text/event-stream SSE
 *
 * No API key lives in the client bundle: Workers AI is invoked through the
 * Worker's AI binding (configured in wrangler.toml).
 */

const ALLOWED_ORIGINS = new Set([
  'https://omaradel.pages.dev',
  'http://localhost:5173', // Jaspr dev server
  'http://localhost:8080',
]);

// Every Cloudflare Pages deployment of this project — production, the
// `development` branch, and per-branch / per-commit previews — is served
// from a `*.omaradel.pages.dev` host. The host names of previews are
// generated at deploy time, so they cannot be listed individually.
const PAGES_ORIGIN_SUFFIX = '.omaradel.pages.dev';

/**
 * True when the origin may talk to this Worker.
 *
 * The Pages suffix match is safe because `pages.dev` subdomains are only
 * creatable from the Cloudflare account that owns this project.
 */
function isAllowedOrigin(origin) {
  if (ALLOWED_ORIGINS.has(origin)) return true;
  try {
    const { protocol, hostname } = new URL(origin);
    return (
      protocol === 'https:' &&
      hostname.endsWith(PAGES_ORIGIN_SUFFIX)
    );
  } catch (_) {
    return false;
  }
}

// ── Rate limiting (fixed window per client IP) ───────────────────────────
const RATE_LIMIT_WINDOW_MS = 60 * 1000; // 1 minute
const RATE_LIMIT_MAX_REQUESTS = 20; // max requests per window per IP
const rateLimitStore = new Map(); // ip -> { count, resetAt }

function checkRateLimit(ip) {
  const now = Date.now();
  const entry = rateLimitStore.get(ip);
  if (!entry || now > entry.resetAt) {
    rateLimitStore.set(ip, { count: 1, resetAt: now + RATE_LIMIT_WINDOW_MS });
    return true;
  }
  if (entry.count >= RATE_LIMIT_MAX_REQUESTS) {
    return false;
  }
  entry.count++;
  return true;
}

function corsHeaders(origin) {
  const allow = isAllowedOrigin(origin) ? origin : 'https://omaradel.pages.dev';
  return {
    'Access-Control-Allow-Origin': allow,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
  };
}

/**
 * Turns the Workers AI streaming response into plain text deltas.
 *
 * `env.AI.run(model, { stream: true })` hands back the model's own
 * server-sent-event stream, so the frames arrive as raw bytes and have to be
 * decoded and parsed here — reading `chunk.response` directly yields nothing
 * and the visitor gets an empty answer. Some runtimes yield pre-parsed
 * objects instead, so both shapes are accepted.
 *
 * Yields the text of every frame. Upstream error frames are thrown as Errors
 * so the caller can report them instead of silently truncating the answer.
 */
async function* aiTextDeltas(aiResponse) {
  const decoder = new TextDecoder();
  let buffer = '';

  function* parseFrame(frame) {
    for (const line of frame.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed) continue;
      const payload = trimmed.startsWith('data:')
        ? trimmed.slice(5).trim()
        : trimmed;
      if (!payload || payload === '[DONE]') continue;
      let obj;
      try {
        obj = JSON.parse(payload);
      } catch (_) {
        continue; // Ignore malformed frames.
      }
      if (obj && obj.error) {
        throw new Error(
          typeof obj.error === 'string' ? obj.error : JSON.stringify(obj.error),
        );
      }
      const delta = obj.response ?? obj.delta ?? obj.text;
      if (typeof delta === 'string' && delta.length > 0) yield delta;
    }
  }

  for await (const chunk of aiResponse) {
    // Parsed-object shape: { response: "..." }.
    if (chunk && typeof chunk === 'object' && !(chunk instanceof Uint8Array)) {
      if (chunk.error) {
        throw new Error(
          typeof chunk.error === 'string'
            ? chunk.error
            : JSON.stringify(chunk.error),
        );
      }
      const delta = chunk.response ?? chunk.delta ?? chunk.text;
      if (typeof delta === 'string' && delta.length > 0) yield delta;
      continue;
    }

    // Raw-byte / string shape: the model's SSE frames.
    let text;
    if (typeof chunk === 'string') {
      text = chunk;
    } else if (chunk instanceof Uint8Array) {
      text = decoder.decode(chunk, { stream: true });
    } else {
      continue;
    }

    buffer += text;
    let idx;
    while ((idx = buffer.indexOf('\n\n')) !== -1) {
      const frame = buffer.slice(0, idx);
      buffer = buffer.slice(idx + 2);
      yield* parseFrame(frame);
    }
  }

  // Flush a trailing frame that never got its blank-line terminator.
  const tail = buffer.trim();
  if (tail) yield* parseFrame(tail);
}

/** System instruction grounding Nono in Omar's published content only. */
const SYSTEM_PROMPT = `You are Nono, Omar Adel's portfolio assistant.

Answer using ONLY the context below, which is drawn from Omar Adel's published portfolio (About, Expertise, Projects, Experience, Contact, How I work). Never invent projects, skills, experience, or contact details.

Rules:
- Cite the section you used, e.g. "According to the Projects section…".
- If the context does not cover the question, say what you do know from the context and name the topics you can cover (Omar's projects, his stack, his experience, how to contact him). Never reply that you have "no context" or "no information" — the context is always present.
- Never output placeholders or template text such as "[insert link]", "[contact information]", or "[your name]". If a detail is missing, say plainly that it is not listed.
- For a greeting, or any question without a specific subject, reply in two or three sentences: introduce yourself as Nono, say who Omar is and what he builds, and offer a few things you can tell the visitor about.
- Keep answers concise. Stay on topic: Omar Adel and his work only.`;

/**
 * Context used when the request arrives without any retrieved content.
 *
 * That happens for a stale cached client bundle, or for a direct API call.
 * Without it the model has nothing to ground a reply on and answers "I don't
 * have any context" — which reads as a broken assistant rather than a scoped
 * one. Keep this in sync with the About and Contact sections of the corpus
 * (lib/data/nono_corpus.dart), which is the authoritative source.
 */
const FALLBACK_CONTEXT =
  'Omar Adel is a Software Engineer who builds cross-platform apps with ' +
  'Flutter and .NET, plus Python and TypeScript services. Portfolio ' +
  'sections available: About, Expertise, Projects, Experience, Contact, ' +
  'How I work.';

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const origin = request.headers.get('Origin') || '';

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders(origin) });
    }

    // Only POST /ask-nono
    if (request.method !== 'POST' || url.pathname !== '/ask-nono') {
      return new Response(JSON.stringify({ error: 'Not found' }), {
        status: 404,
        headers: {
          ...corsHeaders(origin),
          'Content-Type': 'application/json',
        },
      });
    }

    // Guard: AI binding must be configured
    if (!env || !env.AI) {
      return new Response(
        JSON.stringify({ error: 'AI binding not configured' }),
        {
          status: 500,
          headers: {
            ...corsHeaders(origin),
            'Content-Type': 'application/json',
          },
        },
      );
    }

    // Rate limit check (fixed window per client IP)
    const clientIP = request.headers.get('CF-Connecting-IP') || 'unknown';
    if (!checkRateLimit(clientIP)) {
      return new Response(
        JSON.stringify({ error: 'Rate limit exceeded. Try again later.' }),
        {
          status: 429,
          headers: {
            ...corsHeaders(origin),
            'Content-Type': 'application/json',
          },
        },
      );
    }

    try {
      const { query, context } = await request.json();

      if (!query || typeof query !== 'string') {
        return new Response(JSON.stringify({ error: 'Missing query' }), {
          status: 400,
          headers: {
            ...corsHeaders(origin),
            'Content-Type': 'application/json',
          },
        });
      }

      // Build the RAG user message: retrieved context + visitor's question.
      // An empty context falls back to a minimal grounding blurb, so the model
      // always has something to answer from instead of refusing outright.
      const retrieved =
        typeof context === 'string' && context.trim() ? context.trim() : '';
      const userMessage =
        `Context from Omar's portfolio:\n${retrieved || FALLBACK_CONTEXT}\n\n---\n\nVisitor question: ${query}`;

      const model = env.MODEL || '@cf/meta/llama-3.2-3b-instruct';

      // Call Workers AI with streaming enabled.
      // The streaming binding returns the model's own SSE stream, so the
      // frames have to be parsed — see `aiTextDeltas`.
      const aiResponse = await env.AI.run(model, {
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: userMessage },
        ],
        stream: true,
      });

      // `?debug=1` returns the upstream Workers AI stream verbatim, so the
      // exact frame format can be inspected with curl. Rate limited like any
      // other request.
      //
      // Only active when the `DEBUG=1` Worker var is set — enabled for
      // staging, so production never exposes the raw upstream stream.
      if (url.searchParams.get('debug') === '1' && env.DEBUG === '1') {
        return new Response(aiResponse, {
          status: 200,
          headers: {
            ...corsHeaders(origin),
            'Content-Type': 'text/event-stream',
            'Cache-Control': 'no-cache, no-transform',
          },
        });
      }

      // Stream the AI response back to the client as SSE.
      const stream = new TransformStream();
      const writer = stream.writable.getWriter();
      const encoder = new TextEncoder();

      const producer = (async () => {
        try {
          for await (const delta of aiTextDeltas(aiResponse)) {
            await writer.write(
              encoder.encode(`data: ${JSON.stringify({ text: delta })}\n\n`),
            );
          }
          await writer.write(encoder.encode('data: [DONE]\n\n'));
        } catch (err) {
          // Tell the visitor what went wrong instead of leaving the answer
          // silently truncated.
          try {
            await writer.write(
              encoder.encode(
                `data: ${JSON.stringify({
                  error: String(err.message || err),
                })}\n\n`,
              ),
            );
            await writer.close();
          } catch (_) {
            try {
              await writer.abort(err);
            } catch (_) {
              // ignore abort errors
            }
          }
        } finally {
          try {
            await writer.close();
          } catch (_) {
            // ignore close errors
          }
        }
      })();

      // Keep the Worker alive while the stream producer runs.
      ctx.waitUntil(producer);

      return new Response(stream.readable, {
        status: 200,
        headers: {
          ...corsHeaders(origin),
          'Content-Type': 'text/event-stream',
          'Cache-Control': 'no-cache, no-transform',
          'Connection': 'keep-alive',
        },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: String(err.message || err) }), {
        status: 500,
        headers: {
          ...corsHeaders(origin),
          'Content-Type': 'application/json',
        },
      });
    }
  },
};
