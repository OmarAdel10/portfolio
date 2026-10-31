/// Canonical public address of the deployed portfolio.
///
/// The site is served by Cloudflare Pages at `omaradel.pages.dev`. This
/// constant is the single source of truth for that address — every reference
/// (structured data, Open Graph, Twitter cards, the canonical link, and the
/// "Ask Nono" corpus) points here, so the domain can never drift between
/// them again.
///
/// Note: the header wordmark renders the display name "OmarAdel.dev". That
/// is a brand label, not a URL, and is deliberately left alone.
const String productionUrl = 'https://omaradel.pages.dev';
