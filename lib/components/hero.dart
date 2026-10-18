import 'dart:async';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

void Function()? onToggleNono;

void _openCV() {
  web.window.open("https://example.com/cv.pdf", "_blank");
}

enum _Phase { waiting, avatarIn, cursorIn, travel, press, sweep, pill, drift, done }

class Hero extends StatefulComponent {
  const Hero({super.key});
  @override
  State<Hero> createState() => HeroState();
}

class HeroState extends State<Hero> {
  _Phase _phase = _Phase.waiting;
  bool _passedCursor = false;
  bool _passedSelected = false;
  bool _passedPill = false;
  Timer? _phaseTimer;
  Timer? _typingTimer;
  Timer? _glitchTimer;
  int _glitchSeed = 0;

  // Intro reveal/typing state.
  bool _avatarVisible = false;
  String _eyebrowText = '';
  String _nameText = '';
  static const String _eyebrowFull = 'Hello, I am';
  static const String _nameFull = 'Omar Adel';

  // Cursor (overlay arrow) state — always rendered, driven by inline styles.
  String _cursorTransform = 'translate(calc(6vw - 5.3px), calc(8vh - 0.8px))';
  double _cursorOpacity = 0;
  String _cursorTransition = 'none';

  // Selection state.
  double _highlight = 0;
  String _highlightTransition = 'none';
  String _endLeft = '0%';
  bool _handlesVisible = false;
  String _handleTransition = 'none';

  // Pill state.
  bool _pillVisible = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Short empty-screen delay; all later phases keep their original spacing.
      _phaseTimer = Timer(const Duration(milliseconds: 200), _beginIntro);
    }
  }

  void _startGlitchLoop() {
    _scheduleNextGlitch();
  }

  void _scheduleNextGlitch() {
    final intervalMs = 3000 + _randomHashCode();
    _glitchTimer = Timer(Duration(milliseconds: intervalMs), () {
      setState(() => _glitchSeed++);
      _scheduleNextGlitch();
    });
  }

  int _randomHashCode() {
    // Deterministic-enough jitter without dart:math import noise.
    final base = DateTime.now().millisecondsSinceEpoch;
    return 3000 + (base % 4000);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _typingTimer?.cancel();
    _glitchTimer?.cancel();
    super.dispose();
  }

  void _askNono() {
    onToggleNono?.call();
  }

  // ---------- Intro phases ----------

  void _startTyping({
    required String fullText,
    required void Function(String) setValue,
    required void Function() onDone,
  }) {
    var index = 0;
    setValue('');
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      index++;
      if (index >= fullText.length) {
        timer.cancel();
        _typingTimer = null;
        setValue(fullText);
        onDone();
        return;
      }
      setValue(fullText.substring(0, index));
    });
  }

  void _beginIntro() {
    final reduce = web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    final coarse = web.window.matchMedia('(pointer: coarse)').matches;
    if (reduce || coarse) {
      _skipToFinal();
      return;
    }

    // Phase 1: the avatar fades in with a slight rise.
    setState(() {
      _phase = _Phase.avatarIn;
      _avatarVisible = true;
    });
    _phaseTimer = Timer(const Duration(milliseconds: 550), _startEyebrow);
  }

  void _startEyebrow() {
    _startTyping(
      fullText: _eyebrowFull,
      setValue: (value) => setState(() => _eyebrowText = value),
      onDone: _startName,
    );
  }

  void _startName() {
    _startTyping(
      fullText: _nameFull,
      setValue: (value) => setState(() => _nameText = value),
      onDone: _startCursorIn,
    );
  }

  void _startCursorIn() {
    // Phase: cursor fades in at the top-left of the viewport.
    setState(() {
      _phase = _Phase.cursorIn;
      _passedCursor = true;
      _cursorOpacity = 1;
      _cursorTransition = 'opacity 200ms ease-out';
    });
    _phaseTimer = Timer(const Duration(milliseconds: 250), _startTravel);
  }

  ({double left, double right, double centerY})? _measureName() {
    final el = web.document.querySelector('.name-sel');
    if (el == null) return null;
    final r = el.getBoundingClientRect();
    if (r.height <= 0) return null;
    final vh = web.window.innerHeight;
    if (r.bottom < 0 || r.top > vh) return null;
    return (
      left: r.left.toDouble(),
      right: r.right.toDouble(),
      centerY: (r.top + r.height / 2).toDouble(),
    );
  }

  void _startTravel() {
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.travel;
      _cursorTransform = 'translate(${(m.left - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px)';
      _cursorTransition = 'transform 1000ms cubic-bezier(.22,.8,.2,1)';
    });
    _phaseTimer = Timer(const Duration(milliseconds: 1050), _press);
  }

  void _press() {
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.press;
      _cursorTransform =
          'translate(${(m.left - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px) scale(0.9)';
      _cursorTransition = 'transform 120ms ease-out';
      _handlesVisible = true;
      _handleTransition = 'opacity 150ms ease-out';
    });
    _phaseTimer = Timer(const Duration(milliseconds: 140), _startSweep);
  }

  void _startSweep() {
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.sweep;
      _passedSelected = true;
      _cursorTransform =
          'translate(${(m.right - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px)';
      _cursorTransition = 'transform 700ms cubic-bezier(.45,0,.2,1)';
      _highlight = 1;
      _highlightTransition = 'transform 700ms cubic-bezier(.45,0,.2,1)';
      _endLeft = '100%';
      _handleTransition = 'left 700ms cubic-bezier(.45,0,.2,1), opacity 150ms ease-out';
    });
    _phaseTimer = Timer(const Duration(milliseconds: 720), _revealPill);
  }

  void _revealPill() {
    setState(() {
      _phase = _Phase.pill;
      _passedPill = true;
      _pillVisible = true;
    });
    _phaseTimer = Timer(const Duration(milliseconds: 380), _startDrift);
  }

  void _startDrift() {
    final m = _measureName();
    if (m == null) {
      _finish();
      return;
    }
    setState(() {
      _phase = _Phase.drift;
      _cursorTransform =
          'translate(${(m.right - 5.3 + 48).toStringAsFixed(1)}px, ${(m.centerY - 0.8 + 40).toStringAsFixed(1)}px)';
      _cursorTransition = 'transform 500ms ease-out, opacity 350ms ease-out';
      _cursorOpacity = 0;
    });
    _phaseTimer = Timer(const Duration(milliseconds: 560), _finish);
  }

  void _finish() {
    setState(() => _phase = _Phase.done);
    _removeIntroHold();
    // Start the avatar glitch only after the complete page reveal has settled.
    _phaseTimer = Timer(const Duration(milliseconds: 1500), _startGlitchLoop);
  }

  void _skipToFinal() {
    setState(() {
      _phase = _Phase.done;
      _avatarVisible = true;
      _eyebrowText = _eyebrowFull;
      _nameText = _nameFull;
      _passedCursor = true;
      _passedSelected = true;
      _passedPill = true;
      _highlight = 1;
      _endLeft = '100%';
      _handlesVisible = true;
      _pillVisible = true;
      _cursorOpacity = 0;
      _cursorTransition = 'none';
      _highlightTransition = 'none';
      _handleTransition = 'none';
    });
    _removeIntroHold();
    _phaseTimer = Timer(const Duration(milliseconds: 1500), _startGlitchLoop);
  }

  void _removeIntroHold() {
    try {
      web.document.documentElement?.classList.remove('intro-hold');
    } catch (_) {}
  }

  // ---------- Build ----------

  @override
  Component build(BuildContext context) {
    final heroClasses = StringBuffer('hero');
    if (_passedCursor) heroClasses.write(' phase-cursor');
    if (_passedSelected) heroClasses.write(' phase-selected');
    if (_passedPill) heroClasses.write(' phase-pill');
    if (_phase == _Phase.done) heroClasses.write(' phase-done');
    final glitchActive = _glitchSeed % 2 == 1;

    return section(
      classes: heroClasses.toString(),
      id: 'top',
      [
        div(classes: 'container hero-inner', [
          // Animated overlay cursor (direct child so position:fixed works).
          div(
            classes: 'anim-cursor',
            styles: Styles(
              raw: {
                'transform': _cursorTransform,
                'opacity': '$_cursorOpacity',
                'transition': _cursorTransition,
              },
            ),
            [
              span(classes: 'anim-cursor-fill', []),
            ],
          ),
          // Avatar — static, glitch/signal pulse overlay only.
          div(
            classes: 'hero-avatar-wrap',
            styles: Styles(
              raw: {
                'opacity': _avatarVisible ? '1' : '0',
                'transform': _avatarVisible ? 'translateY(0)' : 'translateY(10px)',
                'transition': 'opacity 500ms ease-out, transform 500ms ease-out',
              },
            ),
            [
              div(
                classes: 'hero-avatar-glitch ${glitchActive ? 'glitch-active' : ''}',
                [
                  img(
                    src: '/images/avatar.jpg',
                    alt: 'Portrait of Omar Adel',
                    classes: 'hero-avatar',
                  ),
                  div(classes: 'glitch-grid', []),
                  if (glitchActive) div(classes: 'glitch-scanline', []),
                  if (glitchActive) div(classes: 'glitch-rgb', []),
                ],
              ),
            ],
          ),
          // Eyebrow (always mounted; typed after the avatar reveal).
          span(
            classes: 'hero-eyebrow',
            [Component.text(_eyebrowText)],
          ),
          // Name — ALWAYS mounted, never swapped.
          h1(classes: 'hero-name', [
            span(classes: 'name-sel', [
              span(
                classes: 'name-highlight',
                styles: Styles(
                  raw: {
                    'transform': 'scaleX($_highlight)',
                    'transition': _highlightTransition,
                  },
                ),
                [],
              ),
              span(classes: 'name-text', [Component.text(_nameText)]),
              span(
                classes: 'sel-handle sel-start',
                styles: Styles(
                  raw: {
                    'opacity': _handlesVisible ? '1' : '0',
                    'transition': _handleTransition,
                  },
                ),
                [span(classes: 'sel-knob', [])],
              ),
              span(
                classes: 'sel-handle sel-end',
                styles: Styles(
                  raw: {
                    'left': _endLeft,
                    'opacity': _handlesVisible ? '1' : '0',
                    'transition': _handleTransition,
                  },
                ),
                [span(classes: 'sel-knob', [])],
              ),
            ]),
          ]),
          // Dark pill (Open CV | Ask Nono) — always mounted, space reserved.
          div(classes: 'hero-pill-wrap', [
            div(
              classes: 'hero-pill',
              styles: Styles(
                raw: {
                  'opacity': _pillVisible ? '1' : '0',
                  'visibility': _pillVisible ? 'visible' : 'hidden',
                  'filter': _pillVisible ? 'blur(0px)' : 'blur(8px)',
                  'transform': _pillVisible ? 'scale(1)' : 'scale(.96) translateY(-4px)',
                  'transition': 'opacity 350ms ease-out, filter 350ms ease-out, transform 350ms ease-out',
                },
              ),
              [
                button(
                  attributes: {'type': 'button'},
                  classes: 'pill-btn',
                  onClick: _openCV,
                  [
                    span(classes: 'pill-ico', [
                      RawText(
                        '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><polyline points="9 15 12 18 15 15"/></svg>',
                      ),
                    ]),
                    span(classes: 'pill-label', [Component.text('Open CV')]),
                  ],
                ),
                span(classes: 'pill-divider', []),
                button(
                  attributes: {'type': 'button'},
                  classes: 'pill-btn',
                  onClick: _askNono,
                  [
                    span(classes: 'pill-ico', [
                      RawText(
                        '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>',
                      ),
                    ]),
                    span(classes: 'pill-label', [Component.text('Ask Nono')]),
                  ],
                ),
              ],
            ),
          ]),
          // Rest of hero — staggered intro reveal.
          p(
            classes: 'hero-role intro-item',
            styles: Styles(raw: {'--i': '3'}),
            [
              Component.text('Software Engineer · Flutter, C# .NET & AI Tooling'),
            ],
          ),
          p(
            classes: 'hero-desc intro-item',
            styles: Styles(raw: {'--i': '4'}),
            [
              Component.text(
                'I design and build polished cross-platform apps and the systems behind them — Flutter and C# .NET on the front, Python, edge databases, and practical AI integrations under the hood. Focused on clean architecture, great developer experience, and shipping products that feel premium.',
              ),
            ],
          ),
          div(
            classes: 'hero-cta intro-item',
            styles: Styles(raw: {'--i': '5'}),
            [
              a(href: '#contact', classes: 'btn btn-secondary', [Component.text('Get in Touch')]),
              a(href: '#projects-work', classes: 'btn btn-primary', [Component.text('View Projects')]),
            ],
          ),
          div(
            classes: 'hero-featured intro-item',
            styles: Styles(raw: {'--i': '6'}),
            [
              span(classes: 'featured-label', [Component.text('Building with')]),
            ],
          ),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        padding: Padding.symmetric(vertical: 45.px),
        display: Display.flex,
        alignItems: AlignItems.center,
        backgroundColor: cCanvas,
        overflow: .hidden,
      ),
      css('.hero-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
        maxWidth: 840.px,
        position: Position.relative(),
      ),
      // Avatar.
      css('.hero-avatar-wrap').styles(
        margin: .only(bottom: 24.px),
        display: Display.flex,
        justifyContent: .center,
        position: Position.relative(),
        width: 148.px,
        height: 148.px,
      ),
      css('.hero-avatar-glitch').styles(
        width: 148.px,
        height: 148.px,
        position: Position.relative(),
        radius: .all(.circular(radiusFull.px)),
        overflow: .hidden,
        border: Border.all(color: cHairline, width: 1.px),
        raw: const {
          'box-shadow': '0 12px 34px -10px rgba(35, 37, 29, 0.18), 0 2px 10px -4px rgba(35, 37, 29, 0.10)',
        },
      ),
      css('.hero-avatar').styles(
        raw: const {
          'width': '100%',
          'height': '100%',
          'border-radius': '50%',
          'display': 'block',
        },
      ),
      // Glitch layers.
      css('.glitch-grid').styles(
        raw: const {
          'position': 'absolute',
          'inset': '0',
          'background-image':
              'linear-gradient(var(--hairline) 1px, transparent 1px), linear-gradient(90deg, var(--hairline) 1px, transparent 1px)',
          'background-size': '20px 20px',
          'opacity': '0.06',
          'animation': 'glitchGridSweep 8s linear infinite',
          'pointer-events': 'none',
          'z-index': '1',
        },
      ),
      css('.glitch-scanline').styles(
        raw: const {
          'position': 'absolute',
          'inset': '0',
          'background-image': 'linear-gradient(transparent, rgba(var(--primary-rgb), 0.15) 50%, transparent)',
          'background-size': '100% 3px',
          'background-position': '0 -100%',
          'animation': 'glitchScanline 0.15s steps(1) 1',
          'animation-fill-mode': 'forwards',
          'pointer-events': 'none',
          'z-index': '2',
        },
      ),
      css('.glitch-rgb').styles(
        raw: const {
          'position': 'absolute',
          'inset': '0',
          'background-image': 'url("/images/avatar.jpg")',
          'background-size': 'cover',
          'background-position': 'center',
          'border-radius': '50%',
          'opacity': '0',
          'animation': 'glitchRGB 0.15s steps(1) 1',
          'animation-fill-mode': 'forwards',
          'pointer-events': 'none',
          'z-index': '3',
          'mask-image': 'linear-gradient(to bottom, black 40%, transparent 40%, transparent 60%, black 60%)',
          'mask-size': '100% 20%',
          'mask-position': '0 0',
        },
      ),
      css('.hero-avatar-glitch.glitch-active .glitch-scanline').styles(
        raw: const {
          'animation': 'glitchScanline 0.15s steps(1) 1',
          'animation-fill-mode': 'forwards',
        },
      ),
      css('.hero-avatar-glitch.glitch-active .glitch-rgb').styles(
        raw: const {
          'animation': 'glitchRGB 0.15s steps(1) 1',
          'animation-fill-mode': 'forwards',
        },
      ),
      // Eyebrow.
      css('.hero-eyebrow').styles(
        raw: const {
          'min-height': '1.4em',
        },
        margin: .only(bottom: 14.px),
        fontSize: 14.px,
        fontWeight: FontWeight.w700,
        textTransform: .upperCase,
        letterSpacing: 0.08.em,
        color: cMute,
      ),
      // Name + selection overlay.
      css('.hero-name').styles(
        raw: const {
          'min-height': '1.05em',
        },
        fontSize: 60.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-1.2).px,
        lineHeight: 1.05.em,
        color: cInk,
        margin: .only(bottom: 10.px),
      ),
      css('.name-sel').styles(
        raw: const {
          'position': 'relative',
          'display': 'inline-block',
        },
      ),
      css('.name-highlight').styles(
        raw: const {
          'position': 'absolute',
          'top': '-2px',
          'bottom': '-2px',
          'left': '0',
          'width': '100%',
          'transform-origin': 'left',
          'transform': 'scaleX(0)',
          'border-radius': '2px',
          'background': 'rgba(var(--primary-rgb), 0.28)',
          'z-index': '0',
          'pointer-events': 'none',
        },
      ),
      css('.name-text').styles(
        raw: const {
          'position': 'relative',
          'z-index': '1',
        },
      ),
      css('.sel-handle').styles(
        raw: const {
          'position': 'absolute',
          'top': '-2px',
          'bottom': '-2px',
          'width': '2px',
          'background': 'var(--primary)',
          'transform': 'translateX(-50%)',
          'opacity': '0',
          'z-index': '2',
          'pointer-events': 'none',
        },
      ),
      css('.sel-handle.sel-start').styles(raw: const {'left': '0'}),
      css('.sel-handle.sel-end').styles(raw: const {'left': '0'}),
      css('.sel-knob').styles(
        raw: const {
          'position': 'absolute',
          'left': '50%',
          'width': '16px',
          'height': '16px',
          'border-radius': '50%',
          'background': 'var(--primary)',
          'transform': 'translateX(-50%)',
        },
      ),
      css('.sel-start .sel-knob').styles(raw: const {'top': '-8px'}),
      css('.sel-end .sel-knob').styles(raw: const {'bottom': '-8px'}),
      // Dark pill (Open CV | Ask Nono).
      css('.hero-pill-wrap').styles(
        display: Display.flex,
        justifyContent: .center,
        margin: .only(top: 8.px, bottom: 26.px),
      ),
      css('.hero-pill').styles(
        raw: const {
          'display': 'inline-flex',
          'align-items': 'center',
          'height': '44px',
          'padding': '0 14px',
          'border-radius': '999px',
          'background': 'rgba(38, 38, 40, 0.94)',
          'backdrop-filter': 'blur(12px)',
          '-webkit-backdrop-filter': 'blur(12px)',
          'border': '1px solid rgba(255, 255, 255, 0.08)',
          'box-shadow': '0 8px 24px rgba(0, 0, 0, 0.35)',
          'opacity': '0',
          'visibility': 'hidden',
          'filter': 'blur(8px)',
          'transform': 'scale(.96) translateY(-4px)',
        },
      ),
      css('.pill-btn').styles(
        raw: const {
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '8px',
          'background': 'transparent',
          'border': 'none',
          'color': '#ffffff',
          'font-family': 'inherit',
          'font-size': '14px',
          'font-weight': '500',
          'padding': '0 6px',
          'cursor': 'pointer',
          'transition': 'opacity 150ms ease-out',
        },
      ),
      css('.pill-btn:hover').styles(raw: const {'opacity': '0.85'}),
      css('.pill-ico').styles(
        raw: const {
          'display': 'inline-flex',
          'width': '16px',
          'height': '16px',
        },
      ),
      css('.pill-divider').styles(
        raw: const {
          'width': '1px',
          'height': '20px',
          'background': 'rgba(255, 255, 255, 0.14)',
          'margin': '0 8px',
        },
      ),
      // Role / description / CTAs.
      css('.hero-role').styles(
        fontSize: 21.px,
        fontWeight: FontWeight.w600,
        color: cCharcoal,
        margin: .only(bottom: 18.px),
      ),
      css('.hero-desc').styles(
        fontSize: 17.px,
        lineHeight: 1.6.em,
        color: cMute,
        maxWidth: 700.px,
        margin: .only(bottom: 30.px),
      ),
      css('.hero-cta').styles(
        display: Display.flex,
        justifyContent: .center,
        gap: Gap.all(12.px),
        margin: .only(bottom: 40.px),
      ),
      css('.hero-featured').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        width: 100.percent,
        padding: .only(top: 24.px),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
      css('.featured-label').styles(
        fontSize: 13.px,
        fontWeight: FontWeight.w700,
        textTransform: .upperCase,
        letterSpacing: 0.08.em,
        color: cAsh,
      ),
    ]),
    // Animated overlay cursor (theme-aware via mask).
    css('.anim-cursor').styles(
      raw: const {
        'position': 'fixed',
        'left': '0',
        'top': '0',
        'width': '30px',
        'height': '30px',
        'pointer-events': 'none',
        'z-index': '9999',
        'opacity': '0',
        'will-change': 'transform',
        'filter':
            'drop-shadow(0 0 0.75px var(--cursor-edge)) drop-shadow(0 0 0.75px var(--cursor-edge)) drop-shadow(0 2px 3px rgba(0, 0, 0, 0.35))',
      },
    ),
    css('.anim-cursor-fill').styles(
      raw: const {
        'display': 'block',
        'width': '100%',
        'height': '100%',
        'background-color': 'var(--cursor-fill)',
        '-webkit-mask': 'url(/images/cursor.png) center / contain no-repeat',
        'mask': 'url(/images/cursor.png) center / contain no-repeat',
      },
    ),
    // Keyframes.
    css.keyframes('glitchGridSweep', {
      '0%': Styles(raw: {'background-position': '0 0, 0 0'}),
      '100%': Styles(raw: {'background-position': '100px 100px, 100px 100px'}),
    }),
    css.keyframes('glitchScanline', {
      '0%': Styles(raw: {'background-position': '0 -100%'}),
      '100%': Styles(raw: {'background-position': '0 100%'}),
    }),
    css.keyframes('glitchRGB', {
      '0%': Styles(raw: {'transform': 'translate(0, 0)', 'opacity': '0.3'}),
      '50%': Styles(raw: {'transform': 'translate(4px, -2px)', 'opacity': '0.6'}),
      '100%': Styles(raw: {'transform': 'translate(0, 0)', 'opacity': '0'}),
    }),
    // Responsive.
    css.media(MediaQuery.all(maxWidth: 768.px), [
      css('.hero').styles(padding: .symmetric(vertical: 52.px)),
      css('.hero .hero-name').styles(fontSize: 44.px),
      css('.hero .hero-role').styles(fontSize: 19.px),
      css('.hero .hero-desc').styles(fontSize: 16.px),
      css('.hero .hero-avatar-wrap').styles(width: 124.px, height: 124.px),
      css('.hero .hero-avatar-glitch').styles(width: 124.px, height: 124.px),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.hero .hero-name').styles(fontSize: 36.px),
      css('.hero .hero-role').styles(fontSize: 17.px),
      css('.hero .hero-cta .btn').styles(
        width: 100.percent,
        justifyContent: .center,
      ),
      css('.hero .hero-avatar-wrap').styles(width: 108.px, height: 108.px),
      css('.hero .hero-avatar-glitch').styles(width: 108.px, height: 108.px),
    ]),
  ];
}
