import 'package:jaspr/dom.dart';

// =============================================================================
// Omar Adel — Personal Portfolio design tokens.
//
// This theme is driven by the PostHog design system (see DESIGN.md): a warm
// cream canvas, olive-near-black ink, an IBM Plex Sans type ladder, a single
// saturated yellow-orange CTA, flat hairline-bordered cards with 4-6px radii,
// no drop shadows, uppercase eyebrows, and an 80px section rhythm on desktop.
//
// Every color is a CSS custom property so a single [data-theme] switch on the
// <html> element retints the whole site. Light (PostHog cream) is the default;
// the dark palette is derived from the same hue family.
// =============================================================================

// --- Variable-backed color refs (emit `var(--x)`) ---------------------------
const Color cCanvas = Color.variable('--canvas');
const Color cInk = Color.variable('--ink');
const Color cBody = Color.variable('--body');
const Color cCharcoal = Color.variable('--charcoal');
const Color cMute = Color.variable('--mute');
const Color cAsh = Color.variable('--ash');
const Color cStone = Color.variable('--stone');
const Color cSoft = Color.variable('--soft');
const Color cCard = Color.variable('--card');
const Color cDoc = Color.variable('--doc');
const Color cDark = Color.variable('--dark');
const Color cPrimary = Color.variable('--primary');
const Color cPrimaryPressed = Color.variable('--primary-pressed');
const Color cPrimaryActive = Color.variable('--primary-active');
const Color cOnPrimary = Color.variable('--on-primary');
const Color cOnDark = Color.variable('--on-dark');
const Color cHairline = Color.variable('--hairline');
const Color cHairlineSoft = Color.variable('--hairline-soft');
const Color cLinkBlue = Color.variable('--link-blue');
const Color cLinkTeal = Color.variable('--link-teal');
const Color cFocus = Color.variable('--focus');

// Accent (semantic) families.
const Color cAccentBlue = Color.variable('--accent-blue');
const Color cAccentBlueSoft = Color.variable('--accent-blue-soft');
const Color cAccentGreen = Color.variable('--accent-green');
const Color cAccentGreenSoft = Color.variable('--accent-green-soft');
const Color cAccentRed = Color.variable('--accent-red');
const Color cAccentRedSoft = Color.variable('--accent-red-soft');
const Color cAccentPurple = Color.variable('--accent-purple');
const Color cAccentPurpleSoft = Color.variable('--accent-purple-soft');

// --- Typography --------------------------------------------------------------
const String _plex = 'IBM Plex Sans';
const String _mono = 'IBM Plex Mono';
const FontFamily fSans = FontFamily(_plex);
const FontFamily fSansFallback = FontFamilies.sansSerif;
const FontFamily fMono = FontFamily(_mono);
const FontFamily fSansStack = FontFamily.list([FontFamily(_plex), FontFamilies.sansSerif]);
const FontFamily fMonoStack = FontFamily.list([FontFamily(_mono), FontFamilies.monospace]);

// --- Spacing / radius (fixed, theme-independent) ----------------------------
const double spaceXs = 4;
const double spaceSm = 8;
const double spaceMd = 12;
const double spaceLg = 16;
const double spaceXl = 24;
const double space2xl = 32;
const double space3xl = 48;
const double space4xl = 64;
const double spaceSection = 80;

const double radiusXs = 2;
const double radiusSm = 4;
const double radiusMd = 6;
const double radiusLg = 8;
const double radiusFull = 9999;

// --- Breakpoints --------------------------------------------------------------
const double bpMobile = 480;
const double bpTablet = 768;
const double bpDesktop = 1024;
const double bpLarge = 1280;

// --- External data / constants --------------------------------------------------
const String githubUrl = 'https://github.com/OmarAdel10';
const String linkedinUrl = 'https://www.linkedin.com/in/omaradel10';
const String emailUrl = 'mailto:omaradel1.dev@gmail.com';
const String emailAddress = 'omaradel1.dev@gmail.com';
// Pre-filled mailto template (opens the default mail app).
const String mailtoUrl =
    'mailto:omaradel1.dev@gmail.com?subject=Project%20inquiry%20%E2%80%93%20portfolio'
    '&body=Hi%20Omar%2C%0A%0A'
    'I%20came%20across%20your%20portfolio%20and%20would%20like%20to%20discuss%20a%20potential%20project.%0A%0A';
const String phoneNumber = '+20 155 221 0048';
const String phoneUrl = 'tel:+201552210048';
const String whatsappUrl = 'https://wa.me/201552210048';

/// CSS custom properties that define the **light** (PostHog cream) theme.
const Map<String, String> lightVars = {
  '--canvas': '#eeefe9',
  '--soft': '#e5e7e0',
  '--card': '#ffffff',
  '--doc': '#fcfcfa',
  '--dark': '#23251d',
  '--ink': '#23251d',
  '--body': '#4d4f46',
  '--charcoal': '#33342d',
  '--mute': '#6c6e63',
  '--ash': '#9b9c92',
  '--stone': '#b6b7af',
  '--hairline': '#bfc1b7',
  '--hairline-soft': '#dcdfd2',
  '--primary': '#f7a501',
  '--primary-pressed': '#dd9001',
  '--primary-active': '#b17816',
  '--on-primary': '#23251d',
  '--on-dark': '#ffffff',
  '--link-blue': '#1d4ed8',
  '--link-teal': '#1078a3',
  '--accent-blue': '#2c84e0',
  '--accent-blue-soft': '#dceaf6',
  '--accent-green': '#2c8c66',
  '--accent-green-soft': '#d9eddf',
  '--accent-red': '#cd4239',
  '--accent-red-soft': '#f7d6d3',
  '--accent-purple': '#7c44a6',
  '--accent-purple-soft': '#e7d8ee',
  '--focus': 'rgba(59,130,246,0.5)',
};

/// CSS custom properties that define the **dark** theme, derived from the
/// PostHog hue family (warm olive-charcoal surfaces, cream text, the same
/// yellow-orange CTA kept as the single saturated chromatic moment).
const Map<String, String> darkVars = {
  '--canvas': '#1a1b17',
  '--soft': '#24261f',
  '--card': '#21231c',
  '--doc': '#1e201a',
  '--dark': '#0f100c',
  '--ink': '#e9eae2',
  '--body': '#b3b5a7',
  '--charcoal': '#d2d4c8',
  '--mute': '#8b8d7f',
  '--ash': '#6e7063',
  '--stone': '#53554a',
  '--hairline': '#3a3c30',
  '--hairline-soft': '#2c2e25',
  '--primary': '#f7a501',
  '--primary-pressed': '#dd9001',
  '--primary-active': '#f0b93e',
  '--on-primary': '#23251d',
  '--on-dark': '#e9eae2',
  '--link-blue': '#7aa7f7',
  '--link-teal': '#54c3e0',
  '--accent-blue': '#6ba5f0',
  '--accent-blue-soft': '#24334b',
  '--accent-green': '#6fc69a',
  '--accent-green-soft': '#25312a',
  '--accent-red': '#e07a6f',
  '--accent-red-soft': '#3d2a28',
  '--accent-purple': '#b78fe0',
  '--accent-purple-soft': '#322740',
  '--focus': 'rgba(96,165,250,0.5)',
};

@css
List<StyleRule> get styles => [
  css.import(
      'https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap'),
  // ---------- Keyframes (premium minimal motion) ----------
  css.keyframes('heroAvatarFloat', {
    '0%': Styles(raw: {'transform': 'translateY(0)'}),
    '50%': Styles(raw: {'transform': 'translateY(-7px)'}),
    '100%': Styles(raw: {'transform': 'translateY(0)'}),
  }),
  css.keyframes('heroRingPulse', {
    '0%': Styles(raw: {'opacity': '0.30', 'transform': 'scale(1)'}),
    '50%': Styles(raw: {'opacity': '0', 'transform': 'scale(1.07)'}),
    '100%': Styles(raw: {'opacity': '0.30', 'transform': 'scale(1)'}),
  }),
  css.keyframes('heroRise', {
    'from': Styles(raw: {'opacity': '0', 'transform': 'translateY(16px)'}),
    'to': Styles(raw: {'opacity': '1', 'transform': 'translateY(0)'}),
  }),
  css.keyframes('fadeUp', {
    'from': Styles(raw: {'opacity': '0', 'transform': 'translateY(20px)'}),
    'to': Styles(raw: {'opacity': '1', 'transform': 'translateY(0)'}),
  }),

  // ---------- Scroll reveal (driven by IntersectionObserver in the head) ----------
  css('html.js-enabled .reveal').styles(raw: const {
    'opacity': '0',
    'transform': 'translateY(22px)',
    'transition': 'opacity 0.65s cubic-bezier(0.22, 0.61, 0.36, 1), transform 0.65s cubic-bezier(0.22, 0.61, 0.36, 1)',
  }),
  css('html.js-enabled .reveal.in').styles(raw: const {
    'opacity': '1',
    'transform': 'translateY(0)',
  }),

  // ---------- Theme variables ----------
  css(':root').styles(raw: lightVars),
  css('html[data-theme="dark"]').styles(raw: darkVars),

  // ---------- Reset & base ----------
  css('*, *::before, *::after').styles(
    boxSizing: .borderBox,
  ),
  css('html').styles(
    fontSize: 16.px,
  ),
  css('html').styles(raw: const {
    'scroll-behavior': 'smooth',
    'scroll-padding-top': '78px',
    '-webkit-text-size-adjust': '100%',
  }),
  css('section[id]').styles(raw: const {
    'scroll-margin-top': '78px',
  }),
  css('body').styles(
    margin: .zero,
    minHeight: 100.vh,
    backgroundColor: cCanvas,
    color: cBody,
    fontFamily: fSansStack,
    fontSize: 16.px,
    lineHeight: 1.5.em,
    transition: Transition.combine([
      Transition('background-color', duration: Duration(milliseconds: 320), curve: Curve.easeOut),
      Transition('color', duration: Duration(milliseconds: 320), curve: Curve.easeOut),
    ]),
  ),
  css('h1, h2, h3, h4, h5, h6').styles(
    margin: .zero,
    fontFamily: fSansStack,
    color: cInk,
    fontWeight: FontWeight.w700,
    lineHeight: 1.35.em,
    letterSpacing: (-0.4).px,
  ),
  css('p').styles(
    margin: .zero,
    color: cBody,
  ),
  css('a').styles(
    color: cLinkTeal,
    textDecoration: .none,
  ),
  css('a:hover').styles(
    textDecoration: TextDecoration(line: TextDecorationLine.underline),
  ),
  css('img').styles(
    maxWidth: 100.percent,
    height: .auto,
    display: .block,
  ),
  css('ul, ol').styles(
    margin: .zero,
    padding: .zero,
    listStyle: .none,
  ),
  css('button').styles(
    fontFamily: fSansStack,
    cursor: .pointer,
  ),
  css('::selection').styles(
    backgroundColor: cPrimary,
    color: cOnPrimary,
  ),
  css(':focus-visible').styles(
    outline: Outline(color: cFocus, style: OutlineStyle.solid, width: OutlineWidth(3.px)),
  ),

  // ---------- Scrollbar ----------
  css('::-webkit-scrollbar').styles(width: 10.px, height: 10.px),
  css('::-webkit-scrollbar-track').styles(backgroundColor: cCanvas),
  css('::-webkit-scrollbar-thumb').styles(
    backgroundColor: cHairline,
    radius: .all(.circular(radiusFull.px)),
    border: Border.all(color: cCanvas, width: 2.px),
  ),
  css('::-webkit-scrollbar-thumb:hover').styles(backgroundColor: cStone),

  // ---------- Shared layout primitives ----------
  css('.container').styles(
    width: 100.percent,
    maxWidth: 1200.px,
    margin: .only(left: .auto, right: .auto),
    padding: .symmetric(horizontal: 24.px),
  ),
  css('.section').styles(
    padding: .symmetric(vertical: spaceSection.px),
  ),

  // ---------- Section header (eyebrow + title + subtitle) ----------
  css('.section-head').styles(
    maxWidth: 720.px,
    margin: .only(left: .auto, right: .auto, bottom: 48.px),
    textAlign: .center,
  ),
  css('.eyebrow').styles(
    display: .inlineBlock,
    textTransform: .upperCase,
    fontSize: 12.px,
    fontWeight: FontWeight.w700,
    lineHeight: 1.33.em,
    letterSpacing: 0.08.em,
    color: cMute,
    margin: .only(bottom: 12.px),
  ),
  css('.section-title').styles(
    fontSize: 34.px,
    fontWeight: FontWeight.w800,
    lineHeight: 1.25.em,
    letterSpacing: (-0.6).px,
    color: cInk,
  ),
  css('.section-subtitle').styles(
    margin: .only(left: .auto, right: .auto, top: 14.px),
    fontSize: 17.px,
    lineHeight: 1.6.em,
    color: cMute,
    maxWidth: 620.px,
    textAlign: TextAlign.center,
  ),

  // ---------- Buttons ----------
  css('.btn').styles(
    display: .inlineFlex,
    alignItems: .center,
    justifyContent: .center,
    gap: Gap.all(8.px),
    fontSize: 14.px,
    fontWeight: FontWeight.w700,
    lineHeight: 1.5.em,
    padding: .symmetric(vertical: 10.px, horizontal: 16.px),
    radius: .all(.circular(radiusMd.px)),
    border: Border.all(color: Colors.transparent, width: 1.px),
    textDecoration: .none,
    whiteSpace: .noWrap,
    transition: Transition.combine([
      Transition('background-color', duration: Duration(milliseconds: 160), curve: Curve.easeOut),
      Transition('color', duration: Duration(milliseconds: 160), curve: Curve.easeOut),
      Transition('border-color', duration: Duration(milliseconds: 160), curve: Curve.easeOut),
      Transition('transform', duration: Duration(milliseconds: 160), curve: Curve.easeOut),
    ]),
  ),
  css('.btn:hover').styles(raw: const {'transform': 'translateY(-1px)'}),
  css('.btn-primary').styles(
    backgroundColor: cPrimary,
    color: cOnPrimary,
  ),
  css('.btn-primary:hover').styles(
    backgroundColor: cPrimaryPressed,
    color: cOnPrimary,
    textDecoration: .none,
  ),
  css('.btn-primary:active').styles(
    backgroundColor: cPrimaryActive,
    color: cOnPrimary,
  ),
  css('.btn-secondary').styles(
    backgroundColor: cSoft,
    color: cInk,
  ),
  css('.btn-secondary:hover').styles(
    backgroundColor: cHairline,
    color: cInk,
    textDecoration: .none,
  ),
  css('.btn-secondary:active').styles(
    backgroundColor: cStone,
    color: cInk,
  ),
  css('.btn-tertiary').styles(
    backgroundColor: Colors.transparent,
    color: cInk,
    padding: .symmetric(vertical: 10.px, horizontal: 12.px),
  ),
  css('.btn-tertiary:hover').styles(
    backgroundColor: cSoft,
    color: cInk,
    textDecoration: .none,
  ),
  css('.btn-tertiary:active').styles(
    backgroundColor: cHairline,
    color: cInk,
  ),

  // ---------- Card vocabulary (PostHog: flat, hairline, 6px) ----------
  css('.card').styles(
    backgroundColor: cCard,
    border: Border.all(color: cHairline, width: 1.px),
    radius: .all(.circular(radiusMd.px)),
    transition: Transition.combine([
      Transition('transform', duration: Duration(milliseconds: 220), curve: Curve.easeOut),
      Transition('border-color', duration: Duration(milliseconds: 220), curve: Curve.easeOut),
      Transition('box-shadow', duration: Duration(milliseconds: 220), curve: Curve.easeOut),
      Transition('background-color', duration: Duration(milliseconds: 220), curve: Curve.easeOut),
    ]),
  ),
  css('.card:hover').styles(raw: const {
    'transform': 'translateY(-3px)',
    'border-color': 'var(--primary)',
  }),

  // ---------- Inline chip / tag ----------
  css('.tag').styles(
    display: .inlineFlex,
    alignItems: .center,
    fontSize: 12.px,
    fontWeight: FontWeight.w600,
    lineHeight: 1.33.em,
    textTransform: .upperCase,
    letterSpacing: 0.04.em,
    color: cBody,
    backgroundColor: cSoft,
    padding: .symmetric(vertical: 3.px, horizontal: 8.px),
    radius: .all(.circular(radiusSm.px)),
  ),
  css('.tag-outline').styles(
    color: cMute,
    backgroundColor: Colors.transparent,
    border: Border.all(color: cHairline, width: 1.px),
  ),

  // ---------- Pill tabs (project filters) ----------
  css('.pill').styles(
    display: .inlineFlex,
    alignItems: .center,
    justifyContent: .center,
    fontSize: 13.px,
    fontWeight: FontWeight.w500,
    lineHeight: 1.em,
    color: cBody,
    backgroundColor: Colors.transparent,
    padding: .symmetric(vertical: 8.px, horizontal: 14.px),
    radius: .all(.circular(radiusFull.px)),
    border: Border.all(color: Colors.transparent, width: 1.px),
    cursor: .pointer,
    transition: Transition.combine([
      Transition('background-color', duration: Duration(milliseconds: 150), curve: Curve.easeOut),
      Transition('color', duration: Duration(milliseconds: 150), curve: Curve.easeOut),
    ]),
  ),
  css('.pill:hover').styles(
    color: cInk,
    backgroundColor: cSoft,
  ),
  css('.pill-active').styles(
    backgroundColor: cInk,
    color: cCanvas,
  ),
  css('.pill-active:hover').styles(
    backgroundColor: cInk,
    color: cCanvas,
  ),

  // ---------- Responsive ----------
  css.media(MediaQuery.all(maxWidth: 768.px), [
    css('.section').styles(
      padding: .symmetric(vertical: 52.px),
    ),
    css('.section-head').styles(
      margin: .only(left: .auto, right: .auto, bottom: 36.px),
    ),
    css('.section-title').styles(fontSize: 28.px),
  ]),
  css.media(MediaQuery.all(maxWidth: 480.px), [
    css('.section').styles(
      padding: .symmetric(vertical: 44.px),
    ),
    css('.container').styles(padding: .symmetric(horizontal: 18.px)),
    css('.section-title').styles(fontSize: 26.px),
  ]),

  // ---------- Marquee ticker ----------
  css.keyframes('marquee', {
    '0%': Styles(raw: {'transform': 'translateX(0)'}),
    '100%': Styles(raw: {'transform': 'translateX(-33.333%)'}),
  }),

  // ---------- Interactive background canvas (dot-matrix constellation) ----------
  css('.app-shell').styles(raw: const {'position': 'relative', 'min-height': '100vh'}),
  css('.bg-canvas').styles(raw: const {
    'position': 'fixed',
    'inset': '0',
    'z-index': '0',
    'pointer-events': 'none',
    'display': 'block',
  }),
  css('.app').styles(raw: const {'position': 'relative', 'z-index': '1'}),

  // ---------- Custom animated cursor ----------
  css('html.has-custom-cursor, html.has-custom-cursor *').styles(raw: const {
    'cursor': 'none',
  }),
  css('.cursor-dot, .cursor-ring').styles(raw: const {
    'position': 'fixed',
    'top': '0',
    'left': '0',
    'pointer-events': 'none',
    'z-index': '9999',
    'opacity': '0',
    'border-radius': '50%',
    'will-change': 'transform',
  }),
  css('html.has-custom-cursor .cursor-dot').styles(raw: const {
    'width': '8px',
    'height': '8px',
    'background': 'var(--primary)',
    'transform': 'translate(-50%, -50%)',
    'opacity': '1',
  }),
  css('html.has-custom-cursor .cursor-ring').styles(raw: const {
    'width': '34px',
    'height': '34px',
    'border': '1.5px solid var(--hairline)',
    'transform': 'translate(-50%, -50%)',
    'opacity': '1',
    'transition': 'width 180ms ease-out, height 180ms ease-out, border-color 180ms ease-out, opacity 200ms ease-out',
  }),
  css('html.has-custom-cursor .cursor-ring.is-hover').styles(raw: const {
    'width': '54px',
    'height': '54px',
    'border-color': 'var(--primary)',
  }),

  // ---------- Marquee ticker ----------
  css('.marquee').styles(raw: const {
    'overflow': 'hidden',
    'white-space': 'nowrap',
    'user-select': 'none',
    'width': '100%',
  }),
  css('.marquee-track').styles(raw: const {
    'display': 'inline-flex',
    'align-items': 'center',
    'animation': 'marquee 34s linear infinite',
    'will-change': 'transform',
  }),
  css('.marquee-track:hover').styles(raw: const {'animation-play-state': 'paused'}),
  css('.marquee-item').styles(raw: const {
    'padding': '0 14px',
    'color': 'var(--mute)',
    'font-size': '15px',
    'font-weight': '600',
    'letter-spacing': '0.02em',
  }),
  css('.marquee-sep').styles(raw: const {'color': 'var(--primary)'}),

  // Respect users who prefer reduced motion.
  css.media(MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
    css('*, *::before, *::after').styles(raw: const {
      'animation-duration': '0.001ms !important',
      'animation-iteration-count': '1 !important',
      'transition-duration': '0.001ms !important',
      'scroll-behavior': 'auto !important',
    }),
    css('html.js-enabled .reveal').styles(raw: const {
      'opacity': '1',
      'transform': 'none',
    }),
    // Keep the native cursor under reduced motion.
    css('html.has-custom-cursor, html.has-custom-cursor *').styles(raw: const {
      'cursor': 'auto',
    }),
    css('.cursor-dot, .cursor-ring').styles(raw: const {
      'display': 'none',
    }),
  ]),
];