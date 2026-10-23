import 'package:jaspr/dom.dart';

import '../components/cupertino_icon.dart';

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
  '--primary-rgb': '247,165,1',
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
  '--cursor-fill': '#111111',
  '--cursor-edge': '#ffffff',
  // Mascot logo theming (dark lines + cream face in both themes; the dark
  // theme maps them through its own --ink/--canvas, which resolve to the
  // same visual pairing).
  '--mascot-ink': 'var(--ink)',
  '--mascot-paper': 'var(--canvas)',
  // Hair rim color: only used by the dark-theme rule below, where the ink
  // (== canvas) would otherwise vanish against the dark page background.
  '--mascot-hair-edge': 'var(--ink)',
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
  '--primary-rgb': '247,165,1',
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
  '--cursor-fill': '#ffffff',
  '--cursor-edge': '#111111',
  // Dark theme keeps the mascot readable: cream face, dark lines.
  '--mascot-ink': 'var(--canvas)',
  '--mascot-paper': 'var(--ink)',
  // Lighter rim so the hair silhouette reads against the dark canvas.
  '--mascot-hair-edge': 'var(--ash)',
};

List<StyleRule> get _cupertinoIconStyles => [
  css('.cupertino-icon').styles(
    raw: const {
      'display': 'inline-block',
      'background-color': 'currentColor',
      '-webkit-mask-repeat': 'no-repeat',
      'mask-repeat': 'no-repeat',
      '-webkit-mask-position': 'center',
      'mask-position': 'center',
      '-webkit-mask-size': 'contain',
      'mask-size': 'contain',
    },
  ),
  css('.cupertino-icon--sm').styles(width: 16.px, height: 16.px),
  css('.cupertino-icon--md').styles(width: 20.px, height: 20.px),
  css('.cupertino-icon--lg').styles(width: 28.px, height: 28.px),
  css('.cupertino-icon--xl').styles(width: 64.px, height: 64.px),
  for (final iconColor in CupertinoIconColor.values)
    if (iconColor.variableName case final colorVariable?)
      css('.cupertino-icon-color--${iconColor.name}').styles(
        color: Color.variable(colorVariable),
      ),
  for (final icon in CupertinoIconName.values)
    css('.cupertino-icon--${icon.slug}').styles(
      raw: {
        '-webkit-mask-image': 'url("${icon.path}")',
        'mask-image': 'url("${icon.path}")',
      },
    ),
];

@css
List<StyleRule> get styles => [
  css.import(
    'https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap',
  ),
  // ---------- Keyframes (premium minimal motion) ----------
  css.keyframes('heroAvatarFloat', {
    '0%': Styles(raw: {'transform': 'translateY(0)'}),
    '50%': Styles(raw: {'transform': 'translateY(-7px)'}),
    '100%': Styles(raw: {'transform': 'translateY(0)'}),
  }),
  css.keyframes('heroRingPulse', {
    '0%': Styles(raw: {'transform': 'scale(1) rotate(0deg)', 'opacity': '0.3'}),
    '25%': Styles(raw: {'transform': 'scale(1.1) rotate(5deg)', 'opacity': '0.35'}),
    '50%': Styles(raw: {'transform': 'scale(1.2) rotate(0deg)', 'opacity': '0.4'}),
    '75%': Styles(raw: {'transform': 'scale(1.1) rotate(-5deg)', 'opacity': '0.35'}),
    '100%': Styles(raw: {'transform': 'scale(1) rotate(0deg)', 'opacity': '0.3'}),
  }),
  css.keyframes('mascotWiggle', {
    '0%, 100%': Styles(raw: {'transform': 'rotate(-8deg)'}),
    '50%': Styles(raw: {'transform': 'rotate(-2deg)'}),
  }),

  // ---------- Scroll reveal (base styles - no JS required, prevents FOUC) ----------
  css('.reveal').styles(
    raw: const {
      'opacity': '0',
      'transform': 'translateY(22px)',
    },
  ),
  // Also hide during Hero intro (when .intro-hold is on html element)
  css('.intro-hold .reveal').styles(
    raw: const {
      'opacity': '0',
      'transform': 'translateY(22px)',
    },
  ),
  // Enhanced transition when JS is enabled
  css('html.js-enabled .reveal').styles(
    raw: const {
      'transition':
          'opacity 0.65s cubic-bezier(0.22, 0.61, 0.36, 1), transform 0.65s cubic-bezier(0.22, 0.61, 0.36, 1)',
    },
  ),
  css('html.js-enabled .reveal.in').styles(
    raw: const {
      'opacity': '1',
      'transform': 'translateY(0)',
    },
  ),

  // ---------- Theme variables ----------
  css(':root').styles(raw: lightVars),
  css('html[data-theme="dark"]').styles(raw: darkVars),

  // ---------- Cupertino icons ----------
  ..._cupertinoIconStyles,

  // ---------- Reset & base ----------
  css('*, *::before, *::after').styles(
    boxSizing: .borderBox,
  ),
  css('html').styles(
    fontSize: 16.px,
  ),
  css('html').styles(
    raw: const {
      'scroll-behavior': 'smooth',
      'scroll-padding-top': '78px',
      '-webkit-text-size-adjust': '100%',
    },
  ),
  css('section[id]').styles(
    raw: const {
      'scroll-margin-top': '78px',
    },
  ),
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
  // ---------- Outline buttons (for secondary CTAs like Ask Nono, Open CV) ----------
  css('.btn-outline').styles(
    backgroundColor: Colors.transparent,
    color: cInk,
    border: Border.all(color: cHairline, width: 1.px),
    padding: .symmetric(vertical: 10.px, horizontal: 16.px),
  ),
  css('.btn-outline:hover').styles(
    backgroundColor: cSoft,
    border: Border.all(color: cPrimary, width: 1.px),
    color: cInk,
    textDecoration: .none,
  ),
  css('.btn-outline:active').styles(
    backgroundColor: cHairline,
    color: cInk,
  ),

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
  css('.card:hover').styles(
    raw: const {
      'transform': 'translateY(-3px)',
      'border-color': 'var(--primary)',
    },
  ),

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
    // Ensure touch targets ≥48×48px on mobile
    css('.btn').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 16.px),
    ),
  ]),
  // ---------- Marquee ticker ----------
  css.keyframes('marquee', {
    '0%': Styles(raw: {'transform': 'translateX(0)'}),
    '100%': Styles(raw: {'transform': 'translateX(-33.333%)'}),
  }),

  // ---------- Interactive background canvas (dot-matrix constellation) ----------
  css('.app-shell').styles(raw: const {'position': 'relative', 'min-height': '100vh'}),
  css('.bg-canvas').styles(
    raw: const {
      'position': 'fixed',
      'inset': '0',
      'z-index': '0',
      'pointer-events': 'none',
      'display': 'block',
    },
  ),
  css('.app').styles(raw: const {'position': 'relative', 'z-index': '1'}),

  // ---------- Custom animated cursor ----------
  css('html.has-custom-cursor, html.has-custom-cursor *').styles(
    raw: const {
      'cursor': 'none',
    },
  ),
  css('.cursor-dot, .cursor-ring').styles(
    raw: const {
      'position': 'fixed',
      'top': '0',
      'left': '0',
      'pointer-events': 'none',
      'z-index': '9999',
      'opacity': '0',
      'border-radius': '50%',
      'will-change': 'transform',
    },
  ),
  css('html.has-custom-cursor .cursor-dot').styles(
    raw: const {
      'width': '8px',
      'height': '8px',
      'background': 'var(--primary)',
      'transform': 'translate(-50%, -50%)',
      'opacity': '1',
    },
  ),
  css('html.has-custom-cursor .cursor-ring').styles(
    raw: const {
      'width': '34px',
      'height': '34px',
      'border': '1.5px solid var(--hairline)',
      'transform': 'translate(-50%, -50%)',
      'opacity': '1',
      'transition': 'width 180ms ease-out, height 180ms ease-out, border-color 180ms ease-out, opacity 200ms ease-out',
    },
  ),
  css('html.has-custom-cursor .cursor-ring.is-hover').styles(
    raw: const {
      'width': '54px',
      'height': '54px',
      'border-color': 'var(--primary)',
    },
  ),

  // ---------- Marquee ticker ----------
  css('.marquee').styles(
    raw: const {
      'overflow': 'hidden',
      'white-space': 'nowrap',
      'user-select': 'none',
      'width': '100%',
    },
  ),
  css('.marquee-track').styles(
    raw: const {
      'display': 'inline-flex',
      'align-items': 'center',
      'animation': 'marquee 34s linear infinite',
      'will-change': 'transform',
    },
  ),
  css('.marquee-track:hover').styles(raw: const {'animation-play-state': 'paused'}),
  css('.marquee-item').styles(
    raw: const {
      'padding': '0 14px',
      'color': 'var(--mute)',
      'font-size': '15px',
      'font-weight': '600',
      'letter-spacing': '0.02em',
    },
  ),
  css('.marquee-sep').styles(raw: const {'color': 'var(--primary)'}),

  // Slow marquee on narrow viewports for readability
  css.media(MediaQuery.all(maxWidth: 768.px), [
    css('.marquee-track').styles(
      raw: const {'animation': 'marquee 52s linear infinite'},
    ),
  ]),

  // Respect users who prefer reduced motion.
  css.media(MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
    css('*, *::before, *::after').styles(
      raw: const {
        'animation-duration': '0.001ms !important',
        'animation-iteration-count': '1 !important',
        'transition-duration': '0.001ms !important',
        'scroll-behavior': 'auto !important',
      },
    ),
    css('html.js-enabled .reveal').styles(
      raw: const {
        'opacity': '1',
        'transform': 'none',
      },
    ),
    // Keep the native cursor under reduced motion.
    css('html.has-custom-cursor, html.has-custom-cursor *').styles(
      raw: const {
        'cursor': 'auto',
      },
    ),
    css('.cursor-dot, .cursor-ring').styles(
      raw: const {
        'display': 'none',
      },
    ),
    // Keep the mascot fully static under reduced motion (no blink, no head
    // droop, no Zzz — the near-zero-duration global rule above would still
    // let the `forwards` sleep animations snap to their end state).
    css(
      '.logo-fab.attention #ear-left, .logo-fab.attention #ear-right, '
      '.logo-fab.attention #hair, .logo-fab.attention #eyelid-left, '
      '.logo-fab.attention #eyelid-right, .logo-fab.attention #head, '
      '.logo-fab.attention #eyebrow-left, .logo-fab.attention #eyebrow-right, '
      '.logo-fab.sleeping #eyelid-left, .logo-fab.sleeping #eyelid-right, '
      '.logo-fab.sleeping #head, .logo-fab.sleeping #ear-left, '
      '.logo-fab.sleeping #ear-right, .logo-fab.sleeping #mascot, '
      '.logo-fab.sleeping::before, .logo-fab.sleeping::after, '
      '.logo-fab.surprised #mascot, .logo-fab.surprised #head, '
      '.logo-fab.blink #eyelid-left, .logo-fab.blink #eyelid-right, '
      '.logo-fab svg',
    ).styles(
      raw: const {
        'animation': 'none !important',
      },
    ),
  ]),

  // ---------- Intro staggered reveal (driven by Hero removing .intro-hold) ----------
  css('.intro-hold .intro-item').styles(
    raw: const {
      'opacity': '0',
      'transform': 'translateY(10px)',
    },
  ),
  css('.intro-item').styles(
    raw: const {
      'transition': 'opacity 500ms ease-out, transform 500ms ease-out',
      'transition-delay': 'calc(var(--i, 0) * 110ms)',
    },
  ),
  css('.intro-hold .cursor-dot, .intro-hold .cursor-ring').styles(
    raw: const {
      'opacity': '0 !important',
    },
  ),

  // ---------- Hero shifts left once the user scrolls (after intro finishes) ----------
  // Only applies when the hero intro is done (hero writes .phase-done), so the
  // shift never interrupts the typing intro. align-items/text-align flip
  // instantly; transform slides smoothly over 0.7s.
  css('html.hero-shifted .hero.phase-done .hero-inner').styles(
    raw: const {
      'align-items': 'flex-start',
      'text-align': 'left',
      'transform': 'translateX(-20%)',
      'transition': 'transform 0.7s cubic-bezier(0.22, 0.61, 0.36, 1)',
    },
  ),
  css('html.scroll-lock').styles(
    raw: const {
      'overflow': 'hidden !important',
    },
  ),
  css('html.scroll-lock body').styles(
    raw: const {
      'overflow': 'hidden !important',
    },
  ),

  // ---------- Mascot logo (Ask Nono floating button) ----------
  // The button (`.logo-fab`) stays still at rest; the AIAssistant state adds
  // `.attention` for a ~1.2s playful sequence every 90–120s, or `.sleeping`
  // after ~2.5 min of no interaction. Part selectors target the inlined
  // layered SVG groups by ID (see lib/components/logo.dart).

  // ===== ATTENTION =====
  css.keyframes('logoEarWiggle', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '15%': Styles(raw: {'transform': 'rotate(-8deg)'}),
    '30%': Styles(raw: {'transform': 'rotate(8deg)'}),
    '45%': Styles(raw: {'transform': 'rotate(-5deg)'}),
    '60%': Styles(raw: {'transform': 'rotate(5deg)'}),
    '75%': Styles(raw: {'transform': 'rotate(-3deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
  }),
  // The right ear wiggles opposite the left, for an asymmetric, playful beat.
  css.keyframes('logoEarWiggleRight', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '15%': Styles(raw: {'transform': 'rotate(8deg)'}),
    '30%': Styles(raw: {'transform': 'rotate(-8deg)'}),
    '45%': Styles(raw: {'transform': 'rotate(5deg)'}),
    '60%': Styles(raw: {'transform': 'rotate(-5deg)'}),
    '75%': Styles(raw: {'transform': 'rotate(3deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
  }),
  css.keyframes('logoHairSway', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '20%': Styles(raw: {'transform': 'rotate(-3deg)'}),
    '40%': Styles(raw: {'transform': 'rotate(3deg)'}),
    '60%': Styles(raw: {'transform': 'rotate(-2deg)'}),
    '80%': Styles(raw: {'transform': 'rotate(2deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
  }),
  css.keyframes('logoEyeBlink', {
    '0%': Styles(raw: {'transform': 'scaleY(1)'}),
    '10%': Styles(raw: {'transform': 'scaleY(0)'}),
    '20%': Styles(raw: {'transform': 'scaleY(1)'}),
    '100%': Styles(raw: {'transform': 'scaleY(1)'}),
  }),
  css.keyframes('logoHeadTilt', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '25%': Styles(raw: {'transform': 'rotate(-4deg)'}),
    '50%': Styles(raw: {'transform': 'rotate(4deg)'}),
    '75%': Styles(raw: {'transform': 'rotate(-2deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
  }),
  css.keyframes('logoBrowRaise', {
    // SVG user units: -30 ≈ 2.5px on screen — a subtle raise you can catch.
    '0%': Styles(raw: {'transform': 'translateY(0)'}),
    '30%': Styles(raw: {'transform': 'translateY(-30px)'}),
    '60%': Styles(raw: {'transform': 'translateY(-15px)'}),
    '100%': Styles(raw: {'transform': 'translateY(0)'}),
  }),

  // ===== SLEEP =====
  css.keyframes('logoHeadNod', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '25%': Styles(raw: {'transform': 'rotate(2deg)'}),
    '50%': Styles(raw: {'transform': 'rotate(-3deg)'}),
    '75%': Styles(raw: {'transform': 'rotate(-1deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(-2deg)'}),
  }),
  css.keyframes('logoEarRelax', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(-10deg)'}),
  }),
  css.keyframes('logoEarRelaxRight', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(10deg)'}),
  }),
  css.keyframes('logoBreathing', {
    '0%': Styles(raw: {'transform': 'scale(1)'}),
    '50%': Styles(raw: {'transform': 'scale(1.01)'}),
    '100%': Styles(raw: {'transform': 'scale(1)'}),
  }),
  // One "Z" drifting up and fading out.
  css.keyframes('logoZzzFloat', {
    '0%': Styles(raw: {'transform': 'translateY(0) scale(0.6)', 'opacity': '0'}),
    '15%': Styles(raw: {'opacity': '1'}),
    '85%': Styles(raw: {'opacity': '1'}),
    '100%': Styles(raw: {'transform': 'translateY(-34px) scale(1.1)', 'opacity': '0'}),
  }),
  // Always-on gentle bob so the mascot feels alive even at rest.
  css.keyframes('logoFloatBob', {
    '0%': Styles(raw: {'transform': 'translateY(0)'}),
    '50%': Styles(raw: {'transform': 'translateY(-8px)'}),
    '100%': Styles(raw: {'transform': 'translateY(0)'}),
  }),
  // One quick blink, played when AIAssistantState adds `.blink` at a random
  // 3–9s cadence (Dart-driven — CSS loops can't do random intervals).
  css.keyframes('logoBlink', {
    '0%': Styles(raw: {'transform': 'scaleY(1)'}),
    '50%': Styles(raw: {'transform': 'scaleY(0.05)'}),
    '100%': Styles(raw: {'transform': 'scaleY(1)'}),
  }),
  css('.logo-fab.blink #eyelid-left, .logo-fab.blink #eyelid-right').styles(
    raw: const {
      'animation': 'logoBlink 0.18s ease-in-out',
      'transform-origin': '50% 20%',
    },
  ),

  // ===== SURPRISE (startled self-wake) =====
  // Quick body jolt: pop up, settle back.
  css.keyframes('logoStartle', {
    '0%': Styles(raw: {'transform': 'scale(1)'}),
    '30%': Styles(raw: {'transform': 'scale(1.07) rotate(-1deg)'}),
    '60%': Styles(raw: {'transform': 'scale(0.98)'}),
    '100%': Styles(raw: {'transform': 'scale(1)'}),
  }),
  // Head snaps up as it startles.
  css.keyframes('logoHeadJolt', {
    '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
    '35%': Styles(raw: {'transform': 'rotate(-4deg)'}),
    '70%': Styles(raw: {'transform': 'rotate(2deg)'}),
    '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
  }),

  // ===== Button shell (transparent floating character) =====
  css('.logo-fab').styles(
    raw: const {
      'width': '120px',
      'height': '120px',
      'display': 'flex',
      'align-items': 'center',
      'justify-content': 'center',
      'background': 'transparent',
      'border': 'none',
      'padding': '0',
      'cursor': 'pointer',
      'transition': 'transform 0.3s ease',
      // Let ears/hair/Zzz exceed the bounds while animating.
      'overflow': 'visible',
      'position': 'relative',
    },
  ),
  css('.logo-fab svg').styles(
    raw: const {
      'width': '112px',
      'height': '112px',
      'display': 'block',
      // Silhouette shadow that follows the character, not a circle. The bob
      // lives on the svg (not the button) so the hover scale on the button
      // isn't overridden by the running animation.
      'filter': 'drop-shadow(0 10px 18px rgba(35, 37, 29, 0.28))',
      'animation': 'logoFloatBob 5.5s ease-in-out infinite',
    },
  ),
  css('.logo-fab:hover').styles(
    raw: const {
      'transform': 'scale(1.06)',
    },
  ),
  css('.logo-fab:active').styles(
    raw: const {'transform': 'scale(0.95)'},
  ),
  css('.logo-fab:focus-visible').styles(
    raw: const {'outline': '2px solid var(--primary)', 'outline-offset': '2px'},
  ),

  // ===== Sleep-only shapes (hidden by default inside the SVG's own style) =====
  // Closed-lid arcs: a soft ink stroke in place of the open eye.
  css(
    '.logo-fab #eye-closed-left path, .logo-fab #eye-closed-right path',
  ).styles(
    raw: const {
      'fill': 'none',
      'stroke': 'var(--mascot-ink)',
      'stroke-width': '9',
      'stroke-linecap': 'round',
    },
  ),
  // Sleep mouth: a small ring (dark outline, face-colored center).
  css('.logo-fab #mouth-sleep ellipse').styles(
    raw: const {
      'fill': 'var(--mascot-paper)',
      'stroke': 'var(--mascot-ink)',
      'stroke-width': '8',
    },
  ),
  // Fade these in/out smoothly when the sleeping class toggles.
  css(
    '.logo-fab #eye-closed-left, .logo-fab #eye-closed-right, '
    '.logo-fab #mouth-sleep',
  ).styles(
    raw: const {
      'transition': 'opacity 1.2s ease',
    },
  ),

  // Dark mode only: the ink (== canvas) would vanish against the dark page
  // background, so the hair gets a thin lighter rim and the whole mascot a
  // faint cream glow. Light mode needs neither — dark ink on light canvas.
  css('html[data-theme="dark"] .logo-fab #hair path').styles(
    raw: const {
      'stroke': 'var(--mascot-hair-edge)',
      // ≈1.1px on screen: the viewBox is ~1420 units shown at 112px, so the
      // SVG's own stroke-width:1 renders at ~0.08px — invisible.
      'stroke-width': '14',
      'stroke-linejoin': 'round',
    },
  ),
  css('html[data-theme="dark"] .logo-fab svg').styles(
    raw: const {
      'filter':
          'drop-shadow(0 10px 18px rgba(35, 37, 29, 0.28)) '
          'drop-shadow(0 0 20px rgba(233, 234, 226, 0.12))',
    },
  ),

  // ===== Attention state (part-level selectors) =====
  css('.logo-fab.attention #ear-left').styles(
    raw: const {
      'animation': 'logoEarWiggle 1.2s ease-in-out',
      'transform-origin': '100% 50%',
    },
  ),
  css('.logo-fab.attention #ear-right').styles(
    raw: const {
      'animation': 'logoEarWiggleRight 1.2s ease-in-out',
      'transform-origin': '0% 50%',
    },
  ),
  css('.logo-fab.attention #hair').styles(
    raw: const {
      'animation': 'logoHairSway 1.2s ease-in-out',
      'transform-origin': '50% 100%',
    },
  ),
  css('.logo-fab.attention #eyelid-left, .logo-fab.attention #eyelid-right').styles(
    raw: const {
      'animation': 'logoEyeBlink 1.2s ease-in-out',
      'transform-origin': '50% 20%',
    },
  ),
  css('.logo-fab.attention #head').styles(
    raw: const {
      'animation': 'logoHeadTilt 1.2s ease-in-out',
    },
  ),
  css('.logo-fab.attention #eyebrow-left, .logo-fab.attention #eyebrow-right').styles(
    raw: const {
      'animation': 'logoBrowRaise 1.2s ease-in-out',
    },
  ),

  // ===== Sleep state =====
  // Eyes: the open eye (pupil + line-work eyelid) fades out and two gentle
  // closed-lid arcs fade in — a real "peacefully closed" look instead of the
  // old squashed-eyelid dot.
  css(
    '.logo-fab.sleeping #pupil-left, .logo-fab.sleeping #pupil-right, '
    '.logo-fab.sleeping #eyelid-left, .logo-fab.sleeping #eyelid-right',
  ).styles(
    raw: const {
      'opacity': '0',
      'transition': 'opacity 1s ease',
    },
  ),
  css(
    '.logo-fab.sleeping #eye-closed-left, .logo-fab.sleeping #eye-closed-right',
  ).styles(
    raw: const {
      'opacity': '1',
      // Arcs fade in just after the eye starts fading out.
      'transition': 'opacity 1.2s ease 0.4s',
    },
  ),
  // Mouth: the smile fades out and a small "o" fades in.
  css('.logo-fab.sleeping #mouth').styles(
    raw: const {
      'opacity': '0',
      'transition': 'opacity 1s ease',
    },
  ),
  css('.logo-fab.sleeping #mouth-sleep').styles(
    raw: const {
      'opacity': '1',
      'transition': 'opacity 1.2s ease 0.4s',
    },
  ),
  css('.logo-fab.sleeping #head').styles(
    raw: const {
      'animation': 'logoHeadNod 4s ease-in-out forwards',
    },
  ),
  css('.logo-fab.sleeping #ear-left').styles(
    raw: const {
      'animation': 'logoEarRelax 2s ease-out forwards',
      'transform-origin': '100% 50%',
    },
  ),
  css('.logo-fab.sleeping #ear-right').styles(
    raw: const {
      'animation': 'logoEarRelaxRight 2s ease-out forwards',
      'transform-origin': '0% 50%',
    },
  ),
  css('.logo-fab.sleeping #mascot').styles(
    raw: const {
      'animation': 'logoBreathing 3s ease-in-out infinite',
    },
  ),

  // ===== Surprise state (startled self-wake) =====
  // Eyes need nothing here: dropping .sleeping snaps them wide open, which
  // is exactly the jolt we want. The sleep "o" mouth doubles as a shock
  // mouth, and the brows shoot up and hold for the whole reaction.
  css('.logo-fab.surprised #mascot').styles(
    raw: const {
      'animation': 'logoStartle 0.6s ease-out',
    },
  ),
  css('.logo-fab.surprised #head').styles(
    raw: const {
      'animation': 'logoHeadJolt 0.5s ease-out',
    },
  ),
  css(
    '.logo-fab.surprised #eyebrow-left, .logo-fab.surprised #eyebrow-right',
  ).styles(
    raw: const {
      // SVG transforms are in user units, not screen px — the viewBox is
      // ~1420 units shown at 112px (scale ≈ 0.08), so -60 units ≈ 5px on
      // screen: a clear shock raise.
      'transform': 'translateY(-60px)',
      'transition': 'transform 0.25s ease-out',
    },
  ),
  css('.logo-fab.surprised #mouth-sleep').styles(
    raw: const {
      'opacity': '1',
    },
  ),
  css('.logo-fab.surprised #mouth').styles(
    raw: const {
      'opacity': '0',
    },
  ),

  // Zzz bubbles: two CSS "Z" glyphs drifting up from the head, staggered.
  // Rendered as text content so they follow --mascot-ink in both themes.
  css('.logo-fab.sleeping::before, .logo-fab.sleeping::after').styles(
    raw: const {
      'content': '"Z"',
      'position': 'absolute',
      'top': '-4px',
      'right': '2px',
      'font-family': 'var(--font-sans, system-ui, sans-serif)',
      'font-size': '13px',
      'font-weight': '700',
      // var(--ink) is the only ink tone that contrasts with the *page*
      // background in both themes (var(--mascot-ink) equals the dark canvas
      // in dark mode, which made the Zzz invisible there).
      'color': 'var(--ink)',
      'pointer-events': 'none',
      'animation': 'logoZzzFloat 3s ease-in-out infinite',
    },
  ),
  css('.logo-fab.sleeping::after').styles(
    raw: const {
      'animation-delay': '1.5s',
      'right': '12px',
      'top': '2px',
      'font-size': '10px',
    },
  ),
];
