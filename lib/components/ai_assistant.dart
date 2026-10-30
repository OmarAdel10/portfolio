import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../data/nono_corpus.dart';
import 'hero.dart';
import 'logo.dart';

/// Conversational Nono assistant placeholder UI.
///
/// Keyboard shortcut: Ctrl+/ (or Cmd+/) — or Ctrl+\ (or Cmd+\) — to open;
/// Esc to close.
/// No backend integration yet — UI only placeholder to reserve space and convey
/// future intent.
///
/// The floating button renders the layered mascot logo, which stays mostly
/// still at rest, blinks at random 3–9s gaps, plays a short attention
/// sequence every 90–120s, falls asleep after ~1.5–2 minutes without user
/// interaction, and — if nobody wakes it — startles awake by itself after
/// ~2–2.5 minutes asleep (see `.logo-fab` styles in theme.dart).

/// One chat message rendered in the Nono modal.
class _Message {
  final String role; // 'user' | 'assistant'
  final String text;
  final List<String> sources;
  final bool isStreaming;
  _Message({
    required this.role,
    required this.text,
    this.sources = const [],
    this.isStreaming = false,
  });
}

/// A [Sink<String>] that accumulates decoded text so we can tell how much of
/// the UTF-8 stream has been decoded across `Utf8Decoder` chunked conversion.
class _StringSink implements Sink<String> {
  final _buffer = StringBuffer();
  @override
  void add(String data) => _buffer.write(data);
  @override
  void close() {}
  String get value => _buffer.toString();
}

class AIAssistant extends StatefulComponent {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => AIAssistantState();
}

class AIAssistantState extends State<AIAssistant> {
  bool _isOpen = false;
  bool _isAnimating = false;
  bool _isSleeping = false;
  bool _isBlinking = false;
  bool _isSurprised = false;

  Timer? _attentionTimer;
  Timer? _attentionEndTimer;
  Timer? _idleTimer;
  Timer? _blinkTimer;
  Timer? _blinkEndTimer;
  Timer? _selfWakeTimer;
  Timer? _surpriseEndTimer;
  web.EventListener? _keyListener;

  final _random = math.Random();

  // ── Chat state ─────────────────────────────────────────────────────────
  final List<_Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _inputValue = '';
  String _sseBuffer = '';
  web.ReadableStreamDefaultReader? _reader;
  Sink<List<int>>? _byteSink;
  int _utf8DecodedLength = 0;

  /// How often the mascot plays its attention sequence (90–120s, randomized
  /// so it feels organic rather than metronomic).
  static const _attentionMin = Duration(seconds: 90);
  static const _attentionSpan = Duration(seconds: 30);

  /// First attention sequence fires soon after load so the character is
  /// visibly alive without a long wait; later ones use the randomized span.
  static const _firstAttentionDelay = Duration(seconds: 25);

  /// How long the attention sequence lasts — must match the `1.2s` animation
  /// durations in theme.dart.
  static const _attentionDuration = Duration(milliseconds: 1200);

  /// Idle time before the mascot falls asleep: a random 1.5–2 min gap so it
  /// feels organic. Only *user* interaction resets this — the mascot's own
  /// attention sequences must not keep it awake (they fire every 90–120s,
  /// which would otherwise always outrun the idle timer and make sleep
  /// unreachable).
  static const _idleMin = Duration(seconds: 90);
  static const _idleSpan = Duration(seconds: 30);

  /// Blink cadence: each gap is randomized between 3s and 9s so the blink
  /// never feels metronomic.
  static const _blinkMin = Duration(seconds: 3);
  static const _blinkSpan = Duration(seconds: 6);

  /// How long one blink lasts — must match the `0.18s` animation in theme.dart.
  static const _blinkDuration = Duration(milliseconds: 180);

  /// Asleep this long with no visitor and it wakes itself up, startled
  /// (2–2.5 min, randomized).
  static const _sleepBeforeSelfWake = Duration(seconds: 120);
  static const _sleepBeforeSelfWakeSpan = Duration(seconds: 30);

  /// How long the surprised reaction lasts (3–5s, randomized) before it
  /// settles back to normal.
  static const _surpriseMin = Duration(seconds: 3);
  static const _surpriseSpan = Duration(seconds: 2);

  // ── Client-side retrieval (keyword / lightweight TF-IDF) ───────────────
  final Map<String, int> _docFreq = {};
  bool _idfReady = false;

  void _ensureIdf() {
    if (_idfReady) return;
    for (final doc in nonoCorpus) {
      for (final term in _tokenize(doc.body).toSet()) {
        _docFreq[term] = (_docFreq[term] ?? 0) + 1;
      }
    }
    _idfReady = true;
  }

  static final Set<String> _stopwords = {
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of',
    'with', 'by', 'from', 'as', 'is', 'are', 'was', 'were', 'be', 'been',
    'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
    'should', 'i', 'you', 'me', 'my', 'your', 'his', 'her', 'its', 'our',
    'their', 'this', 'that', 'these', 'those', 'it', 'not', 'no', 'yes',
    'can', 'about',
  };

  /// Terms that identify Omar himself. Visitors ask "who is he?" and "tell me
  /// about yourself" with words that appear nowhere in the corpus, so these
  /// pronouns and vague words are expanded into the corpus's own vocabulary.
  static const List<String> _identityTerms = [
    'omar',
    'engineer',
    'software',
    'developer',
    'bio',
    'about',
  ];

  /// Query terms expanded with their common equivalents, so a visitor's
  /// everyday wording still reaches the documents that use Omar's own terms —
  /// "who is this developer" has to find the "Software Engineer" bio.
  static const Map<String, List<String>> _synonyms = {
    'developer': ['engineer', 'software', 'omar', 'about'],
    'engineer': ['developer', 'software', 'omar', 'about'],
    'who': _identityTerms,
    'whom': _identityTerms,
    'him': _identityTerms,
    'he': _identityTerms,
    'yourself': _identityTerms,
    'bio': ['about', 'omar', 'background', 'story'],
    'stack': ['tech', 'technology', 'flutter', 'dotnet', 'python', 'typescript'],
    'tech': ['stack', 'technology', 'flutter', 'dotnet'],
    'skills': ['expertise', 'stack', 'flutter', 'dotnet', 'python', 'typescript'],
    'ai': ['artificial', 'intelligence', 'agents', 'claude', 'codex', 'gemini'],
    'contact': ['email', 'reach', 'hire', 'available', 'whatsapp', 'linkedin'],
    'reach': ['contact', 'email', 'available'],
    'hire': ['available', 'work', 'contact'],
    'hiring': ['available', 'hire', 'contact'],
    'job': ['available', 'hire', 'contact', 'role'],
    'work': ['available', 'hire', 'contact'],
    'projects': ['project', 'built', 'apps', 'flutter'],
    'experience': ['experienced', 'background', 'expertise'],
    'resume': ['experience', 'education', 'bsc', 'certification'],
    'cv': ['experience', 'education', 'bsc', 'certification'],
    'flutter': ['dart', 'mobile', 'cross-platform'],
    'backend': ['dotnet', 'python', 'cloud', 'workers'],
  };

  List<String> _tokenize(String text) =>
      text.toLowerCase().split(RegExp(r'\W+')).where((t) {
        if (t.isEmpty) return false;
        return !_stopwords.contains(t);
      }).toList();

  double _idf(String term) {
    final df = _docFreq[term] ?? 0;
    if (nonoCorpus.isEmpty) return 0;
    return math.log(nonoCorpus.length / (df + 1)) + 1;
  }

  /// Returns the top-k corpus documents most relevant to `query`.
  List<NonoDocument> _retrieve(String query, {int topK = 5}) {
    _ensureIdf();
    final qTerms = _tokenize(query);
    if (qTerms.isEmpty) return const [];
    // Widen the query with synonyms before scoring.
    final expanded = <String>[...qTerms];
    for (final t in qTerms) {
      expanded.addAll(_synonyms[t] ?? const []);
    }

    final scored = <NonoDocument, double>{};
    for (final doc in nonoCorpus) {
      final docTerms = _tokenize(doc.body);
      if (docTerms.isEmpty) continue;
      var score = 0.0;
      for (final t in expanded) {
        final tf = docTerms.where((d) => d == t).length / docTerms.length;
        score += tf * _idf(t);
      }
      // Topic-tag boost: query terms that appear in a doc's topic tags.
      // Multi-word tags are split so "software-engineer" matches the query
      // terms "software" and "engineer", and "omar-adel" matches "omar".
      for (final t in expanded) {
        if (doc.topics.any((tag) => tag == t || tag.split('-').contains(t))) {
          score += 0.5;
        }
      }
      if (score > 0) scored[doc] = score;
    }

    final sorted = scored.keys.toList()
      ..sort((a, b) => scored[b]!.compareTo(scored[a]!));
    return sorted.take(topK).toList();
  }

  // ── Networking ─────────────────────────────────────────────────────────
  static const _askNonoEndpoint =
      'https://ask-nono.omaradel.workers.dev/ask-nono';

  /// Send a user message: retrieve context, append messages, POST to Worker.
  Future<void> _send() async {
    if (_isLoading || _inputValue.trim().isEmpty) return;
    final query = _inputValue.trim();

    // Retrieve relevant context from Omar's corpus (client-side, zero network).
    final retrieved = _retrieve(query, topK: 5);

    // The identity and contact documents ride along with every request, so
    // Nono always knows who Omar is and how to reach him — even when the
    // visitor's wording matches no document at all ("hi", "what does he do?").
    // Retrieved documents come last so the most relevant text sits closest
    // to the question.
    final core = nonoCoreDocuments;
    final seen = <String>{};
    final contextDocs = <NonoDocument>[
      for (final doc in [...core, ...retrieved])
        if (seen.add(doc.id)) doc,
    ];
    final context = contextDocs.map((d) => d.body).join('\n\n---\n\n');

    // Cite what the answer leaned on: the retrieved documents when there
    // were any, otherwise the always-present core documents.
    final sources =
        (retrieved.isEmpty ? core : retrieved).map((d) => d.title).toList();

    setState(() {
      _messages.add(_Message(role: 'user', text: query));
      _messages.add(_Message(
        role: 'assistant',
        text: '',
        sources: sources,
        isStreaming: true,
      ));
      _isLoading = true;
      _error = null;
      _inputValue = '';
      _sseBuffer = '';
    });

    final body = jsonEncode({'query': query, 'context': context});

    try {
      final headers = web.Headers();
      headers.set('Content-Type', 'application/json');

      final response = await web.window.fetch(
        _askNonoEndpoint.toJS,
        web.RequestInit(
          method: 'POST',
          headers: headers,
          body: body.toJS,
        ),
      ).toDart;

      if (!response.ok) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = 'Server error (${response.status}).';
        });
        return;
      }

      final bodyStream = response.body;
      if (bodyStream == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = 'Empty response from Nono.';
        });
        return;
      }

      _utf8DecodedLength = 0;
      _reader = bodyStream.getReader() as web.ReadableStreamDefaultReader;
      final textSink = _StringSink();
      _byteSink = utf8.decoder.startChunkedConversion(textSink);

      try {
        while (true) {
          final result = await _reader!.read().toDart;
          if (result.done) break;
          final value = result.value;
          if (value == null) continue;
          final chunkBytes = (value as JSUint8Array).toDart;
          _byteSink!.add(chunkBytes);
          final allDecoded = textSink.value;
          final newText = allDecoded.substring(_utf8DecodedLength);
          _utf8DecodedLength = allDecoded.length;
          if (newText.isNotEmpty && mounted) {
            _processSseChunk(newText);
          }
        }
      } finally {
        _byteSink!.close();
        _byteSink = null;
        _reader!.releaseLock();
        _reader = null;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        final idx = _messages.lastIndexWhere((m) => m.role == 'assistant');
        if (idx >= 0 && _messages[idx].isStreaming) {
          final text = _messages[idx].text;
          _messages[idx] = _Message(
            role: 'assistant',
            text: text,
            sources: _messages[idx].sources,
            isStreaming: false,
          );
          // A finished stream with no text means Nono had nothing to say —
          // say so instead of leaving an empty bubble.
          if (text.trim().isEmpty) {
            _error = 'Nono could not produce an answer. Please try again.';
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _reader = null;
        _byteSink = null;
        _error = 'Error sending message: $e';
      });
    }
  }

  /// Parse incremental SSE data and update the streaming assistant message.
  void _processSseChunk(String chunk) {
    if (!mounted) return;
    _sseBuffer += chunk;
    while (_sseBuffer.contains('\n\n')) {
      final idx = _sseBuffer.indexOf('\n\n');
      final block = _sseBuffer.substring(0, idx);
      _sseBuffer = _sseBuffer.substring(idx + 2);
      String? payload;
      for (final line in block.split('\n')) {
        if (line.startsWith('data: ')) {
          payload = line.substring(6);
        }
      }
      if (payload == null) continue;
      if (payload == '[DONE]') {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          final idx = _messages.lastIndexWhere((m) => m.role == 'assistant');
          if (idx >= 0) {
            _messages[idx] = _Message(
              role: 'assistant',
              text: _messages[idx].text,
              sources: _messages[idx].sources,
              isStreaming: false,
            );
          }
        });
        return;
      }
      try {
        final decoded = jsonDecode(payload) as Map<String, dynamic>;
        final error = decoded['error'] as String?;
        if (error != null && error.isNotEmpty) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _error = error;
          });
          return;
        }
        final delta = decoded['text'] as String?;
        if (delta != null && delta.isNotEmpty) _onStreamDelta(delta);
      } catch (_) {
        // Ignore malformed SSE payloads.
      }
    }
  }

  void _onStreamDelta(String delta) {
    if (!mounted) return;
    final idx = _messages.lastIndexWhere((m) => m.role == 'assistant');
    if (idx < 0) return;
    final last = _messages[idx];
    _messages[idx] = _Message(
      role: 'assistant',
      text: last.text + delta,
      sources: last.sources,
      isStreaming: true,
    );
    setState(() {});
  }

  /// Send a prompt-chip question.
  void _sendChip(String question) {
    setState(() => _inputValue = question);
    _send();
  }

  void _abortXhr() {
    _reader?.cancel();
    _reader = null;
    _byteSink?.close();
    _byteSink = null;
    _utf8DecodedLength = 0;
    _sseBuffer = '';
  }

  void _toggle() {
    _onInteraction();
    setState(() => _isOpen = !_isOpen);
  }

  void _close() {
    if (_isOpen) {
      _abortXhr();
      setState(() => _isOpen = false);
    }
  }

  /// Global keyboard shortcuts: Ctrl+/ or Ctrl+\ (Cmd on Mac) toggles the
  /// assistant; Esc closes it. Ignored while typing in an editable field so
  /// visitors aren't interrupted mid-input.
  void _onKeyDown(web.Event raw) {
    if (raw is! web.KeyboardEvent) return;
    final ke = raw;
    final target = ke.target;
    if (target is web.Element) {
      final tag = target.tagName;
      if (tag == 'INPUT' || tag == 'TEXTAREA') return;
    }
    final hasModifier = ke.ctrlKey || ke.metaKey;
    if (!hasModifier) return;
    if (ke.key == '/' || ke.key == '\\') {
      _toggle();
    } else if (ke.key == 'Escape' && _isOpen) {
      _close();
    }
  }

  /// Any user interaction (hover, click) wakes the mascot and restarts the
  /// idle countdown before it falls asleep again.
  void _onInteraction() {
    if (!mounted) return;
    if (_isSleeping) {
      setState(() => _isSleeping = false);
      // A visitor got here before the self-wake timer did.
      _selfWakeTimer?.cancel();
      _resumeAfterWake();
    }
    _resetIdleTimer();
  }

  /// Restart every life cycle after waking up (visitor wake or self-wake).
  void _resumeAfterWake() {
    _scheduleAttention();
    _scheduleBlink();
    _resetIdleTimer();
  }

  /// Slept too long with nobody around: wake on its own with a startled
  /// reaction, then settle back to normal.
  void _selfWake() {
    if (!mounted || !_isSleeping) return;
    setState(() {
      _isSleeping = false;
      _isSurprised = true;
    });
    final hold = _surpriseMin + _surpriseSpan * _random.nextDouble();
    _surpriseEndTimer = Timer(hold, () {
      if (!mounted) return;
      setState(() => _isSurprised = false);
      _resumeAfterWake();
    });
  }

  void _scheduleAttention({bool first = false}) {
    _attentionTimer?.cancel();
    final delay = first ? _firstAttentionDelay : _attentionMin + _attentionSpan * _random.nextDouble();
    _attentionTimer = Timer(delay, _playAttention);
  }

  void _playAttention() {
    if (!mounted || _isSleeping) return;
    // Note: deliberately does NOT touch the idle timer — the mascot's own
    // animations must not keep it awake.
    setState(() => _isAnimating = true);
    _attentionEndTimer = Timer(_attentionDuration, () {
      if (!mounted) return;
      setState(() => _isAnimating = false);
      _scheduleAttention();
    });
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    final idleFor = _idleMin + _idleSpan * _random.nextDouble();
    _idleTimer = Timer(idleFor, () {
      if (!mounted) return;
      setState(() {
        _isSleeping = true;
        _isAnimating = false;
      });
      // Stay asleep: no more attention sequences until something wakes it.
      _attentionTimer?.cancel();
      // But if nobody shows up, it startles awake on its own after a while.
      final sleepFor = _sleepBeforeSelfWake + _sleepBeforeSelfWakeSpan * _random.nextDouble();
      _selfWakeTimer = Timer(sleepFor, _selfWake);
    });
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final delay = _blinkMin + _blinkSpan * _random.nextDouble();
    _blinkTimer = Timer(delay, _playBlink);
  }

  void _playBlink() {
    if (!mounted || _isSleeping) return;
    if (_isAnimating) {
      // Attention sequence owns the eyelids right now; try again later.
      _scheduleBlink();
      return;
    }
    setState(() => _isBlinking = true);
    _blinkEndTimer = Timer(_blinkDuration, () {
      if (!mounted) return;
      setState(() => _isBlinking = false);
      _scheduleBlink();
    });
  }

  @override
  void initState() {
    super.initState();
    // Register the toggle callback so the Hero "Ask Nono" button can open this panel.
    onToggleNono = _toggle;
    if (kIsWeb) {
      // Timers must never run during SSR: firing one on the server would
      // call setState on a server element ("Scheduling a frame is not
      // supported on the server"). The server render stays at rest — the
      // mascot only comes alive once hydrated on the client.
      _scheduleAttention(first: true);
      _scheduleBlink();
      _resetIdleTimer();
      _keyListener = _onKeyDown.toJS;
      web.window.addEventListener('keydown', _keyListener);
    }
  }

  @override
  void dispose() {
    _abortXhr();
    _attentionTimer?.cancel();
    _attentionEndTimer?.cancel();
    _idleTimer?.cancel();
    _blinkTimer?.cancel();
    _blinkEndTimer?.cancel();
    _selfWakeTimer?.cancel();
    _surpriseEndTimer?.cancel();
    if (_keyListener != null) {
      web.window.removeEventListener('keydown', _keyListener);
      _keyListener = null;
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final fabClasses =
        'ai-fab logo-fab'
        '${_isAnimating ? ' attention' : ''}'
        '${_isSleeping ? ' sleeping' : ''}'
        '${_isSurprised ? ' surprised' : ''}'
        '${_isBlinking ? ' blink' : ''}';

    return div(classes: 'ai-assistant', [
      // Layered mascot logo button (replaces the old emoji avatar)
      button(
        classes: fabClasses,
        onClick: _toggle,
        events: {'mouseenter': (event) => _onInteraction()},
        attributes: {
          'aria-label': _isOpen ? 'Close Nono assistant' : 'Open Nono assistant',
          'aria-expanded': _isOpen.toString(),
        },
        [
          const Logo(size: 48),
        ],
      ),

      // Modal overlay (hidden when closed). Dimmed page behind it doubles as
      // the backdrop; clicking anywhere outside the modal card closes it.
      if (_isOpen)
        div(
          classes: 'ai-modal-overlay',
          events: {'click': (_) => _close()},
          [
            div(
              classes: 'ai-modal',
              // Keep clicks *inside* the card from bubbling to the overlay
              // and re-closing the modal while the visitor is interacting.
              events: {'click': (e) => e.stopPropagation()},
              [
                div(classes: 'ai-modal-header', [
                  h3(classes: 'ai-modal-title', [Component.text('Ask Nono')]),
                  button(
                    classes: 'ai-modal-close',
                    onClick: _close,
                    attributes: {'aria-label': 'Close'},
                    [Component.text('×')],
                  ),
                ]),
                div(classes: 'ai-modal-body', [
                  // Chat message history (empty until the first exchange).
                  if (_messages.isNotEmpty)
                    div(classes: 'ai-messages', [
                      for (final msg in _messages)
                        div(
                          classes: 'ai-message ai-message-${msg.role}',
                          [
                            div(classes: 'ai-message-text', [
                              Component.text(
                                msg.text + (msg.isStreaming ? ' …' : ''),
                              ),
                            ]),
                            if (msg.role == 'assistant' &&
                                msg.sources.isNotEmpty)
                              div(
                                classes: 'ai-sources',
                                [
                                  Component.text(
                                    'Sources: ${msg.sources.join(', ')}',
                                  ),
                                ],
                              ),
                          ],
                        ),
                    ]),
                  // Error banner (shown when the Worker is unreachable).
                  if (_error != null)
                    div(
                      classes: 'ai-error',
                      [Component.text('! $_error')],
                    ),
                  // Suggested starter questions.
                  div(classes: 'ai-prompt-chips', [
                    for (final chip in [
                      'What Flutter projects have you built?',
                      "What's your tech stack?",
                      'Tell me about your AI experience',
                      'How can I contact you?',
                    ])
                      button(
                        classes: 'ai-prompt-chip',
                        onClick: () => _sendChip(chip),
                        [Component.text(chip)],
                      ),
                  ]),
                  // Message input + send.
                  div(classes: 'ai-input-area', [
                    input(
                      classes: 'ai-input',
                      attributes: {
                        'placeholder': 'Ask about Nono…',
                        'aria-label': 'Nono assistant input',
                        'value': _inputValue,
                        if (_isLoading) 'disabled': 'disabled',
                      },
                      events: {
                        'input': (event) {
                          if (event.target is web.HTMLInputElement) {
                            setState(() => _inputValue =
                                (event.target as web.HTMLInputElement).value);
                          }
                        },
                        'keydown': (event) {
                          if (event is web.KeyboardEvent &&
                              event.key == 'Enter' &&
                              !event.shiftKey) {
                            event.preventDefault();
                            _send();
                          }
                        },
                      },
                    ),
                    button(
                      classes: 'ai-send-btn',
                      onClick: _send,
                      attributes: {
                        if (_isLoading) 'disabled': 'disabled',
                      },
                      [Component.text(_isLoading ? 'Sending…' : 'Send')],
                    ),
                  ]),
                  div(classes: 'ai-hint', [
                    Component.text(
                        'Shortcuts: Ctrl+/ or Ctrl+\\ to open · Esc to close'),
                  ]),
                ]),
              ],
            ),
          ],
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.ai-assistant').styles(
      position: Position.fixed(),
      raw: const {'bottom': '24px', 'right': '24px'},
      zIndex: ZIndex(9999),
      display: Display.flex,
      flexDirection: FlexDirection.column,
      alignItems: AlignItems.end,
    ),

    css('.ai-modal-overlay').styles(
      position: Position.fixed(),
      raw: const {'inset': '0', 'background-color': 'rgba(35, 37, 29, 0.4)', 'overscroll-behavior': 'contain', 'touch-action': 'none'},
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      zIndex: ZIndex(10000),
      padding: Padding.all(24.px),
      animation: Animation(
        name: 'aiFadeIn',
        duration: durControl,
        curve: Curve.easeOut,
      ),
    ),

    css('.ai-modal').styles(
      backgroundColor: cCanvas,
      radius: .all(.circular(radiusLg.px)),
      width: 420.px,
      maxWidth: 90.percent,
      maxHeight: 80.percent,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      raw: const {'box-shadow': '0 24px 48px -16px rgba(35, 37, 29, 0.35)'},
      animation: Animation(
        name: 'aiSlideUp',
        duration: durControl,
        curve: Curve.easeOut,
      ),
    ),

    css('.ai-modal-header').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.spaceBetween,
      padding: Padding.all(20.px),
      border: Border.only(
        bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px),
      ),
    ),
    css('.ai-modal-title').styles(
      fontSize: 18.px,
      fontWeight: FontWeight.w700,
      color: cInk,
      margin: .zero,
    ),
    css('.ai-modal-close').styles(
      backgroundColor: Colors.transparent,
      border: Border.none,
      fontSize: 24.px,
      color: cAsh,
      cursor: .pointer,
      padding: Padding.all(4.px),
    ),

    css('.ai-modal-body').styles(
      padding: Padding.all(20.px),
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(16.px),
      raw: const {'overflow-y': 'auto', 'overscroll-behavior': 'contain'},
      maxHeight: 400.px,
    ),

    css('.ai-prompt-chips').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      gap: Gap.all(8.px),
    ),
    css('.ai-prompt-chip').styles(
      backgroundColor: cSoft,
      color: cBody,
      border: Border.all(color: cHairline, width: 1.px),
      radius: .all(.circular(radiusFull.px)),
      padding: .symmetric(vertical: 8.px, horizontal: 14.px),
      fontSize: 13.px,
      fontWeight: FontWeight.w600,
      cursor: .pointer,
      transition: Transition(
        'all',
        duration: durMicro,
        curve: Curve.easeOut,
      ),
    ),
    css('.ai-prompt-chip:hover').styles(
      backgroundColor: cHairlineSoft,
      color: cInk,
    ),

    css('.ai-input-area').styles(
      display: Display.flex,
      gap: Gap.all(8.px),
    ),
    css('.ai-input').styles(
      flex: Flex.grow(1),
      padding: .symmetric(vertical: 10.px, horizontal: 14.px),
      radius: .all(.circular(radiusMd.px)),
      border: Border.all(color: cHairline, width: 1.px),
      backgroundColor: cCanvas,
      color: cInk,
      fontSize: 14.px,
    ),
    css('.ai-input:focus-visible').styles(
      raw: const {'outline': '2px solid var(--primary)', 'outline-offset': '-1px'},
    ),
    css('.ai-send-btn').styles(
      backgroundColor: cPrimary,
      color: cOnPrimary,
      border: Border.none,
      radius: .all(.circular(radiusMd.px)),
      padding: .symmetric(vertical: 10.px, horizontal: 16.px),
      fontSize: 14.px,
      fontWeight: FontWeight.w700,
      cursor: .pointer,
      whiteSpace: .noWrap,
    ),
    css('.ai-send-btn:hover').styles(
      backgroundColor: cPrimaryPressed,
    ),

    css('.ai-hint').styles(
      fontSize: 12.px,
      color: cMute,
      textAlign: TextAlign.center,
    ),

    css('.ai-messages').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(12.px),
      raw: const {'overflow-y': 'auto'},
      maxHeight: 240.px,
      padding: Padding.only(bottom: 8.px),
    ),
    css('.ai-message').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(4.px),
      padding: .symmetric(vertical: 8.px, horizontal: 12.px),
      radius: .all(.circular(radiusMd.px)),
    ),
    css('.ai-message.user').styles(
      alignItems: AlignItems.end,
      raw: const {'background-color': 'var(--primary-soft)'},
    ),
    css('.ai-message.assistant').styles(
      alignItems: AlignItems.start,
      raw: const {'background-color': 'var(--soft)'},
    ),
    css('.ai-message-text').styles(
      fontSize: 14.px,
      lineHeight: 1.5.em,
      color: cInk,
      margin: .zero,
    ),
    css('.ai-sources').styles(
      fontSize: 11.px,
      color: cMute,
      margin: .zero,
    ),
    css('.ai-error').styles(
      fontSize: 12.px,
      color: cAccentRed,
      backgroundColor: cAccentRedSoft,
      padding: Padding.all(8.px),
      radius: .all(.circular(radiusMd.px)),
      margin: .only(bottom: 8.px),
    ),

    css.keyframes('aiFadeIn', {
      '0%': Styles(raw: {'opacity': '0'}),
      '100%': Styles(raw: {'opacity': '1'}),
    }),
    css.keyframes('aiSlideUp', {
      '0%': Styles(raw: {'transform': 'translateY(20px)', 'opacity': '0'}),
      '100%': Styles(raw: {'transform': 'translateY(0)', 'opacity': '1'}),
    }),
  ];
}
