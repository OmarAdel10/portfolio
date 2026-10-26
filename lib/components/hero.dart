import 'dart:async';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

void Function()? onToggleNono;

void _openCV() {
  // `noopener` keeps the new tab from reaching back through `window.opener`.
  web.window.open(cvUrl, "_blank", "noopener,noreferrer");
}

enum _Phase { waiting, avatarIn, cursorIn, travel, press, sweep, pill, drift, done }

/// The intro choreography's own clock.
///
/// These are *script beats*, not interface feedback: the cursor travels to
/// the name, presses, sweeps the highlight across it and drifts away. They
/// deliberately sit outside the four motion tokens, which govern hover,
/// press and arrival states. The one-off beats are named here so the
/// sequence reads as a score instead of a pile of magic numbers.
class _Intro {
  const _Intro._();

  // Beat lengths, in milliseconds.
  static const int holdMs = 200;
  static const int avatarInMs = 550;
  static const int cursorInMs = 250;
  static const int travelMs = 1050;
  static const int pressMs = 140;
  static const int sweepMs = 720;
  static const int pillMs = 380;
  static const int driftMs = 560;
  static const int settleMs = 1500;
  static const int typingMs = 90;
  static const int glitchMs = 3000;
  static const int pollMs = 100;

  // The sweep holds the name for a beat before the actions land.
  static const int actionsDelayMs = 300;

  // The drift fades a touch faster than it travels.
  static const int driftMoveMs = 500;
  static const int driftFadeMs = 350;

  // Two easing curves, one per gesture.
  static const String travelEase = 'cubic-bezier(.22,.8,.2,1)';
  static const String sweepEase = 'cubic-bezier(.45,0,.2,1)';
}

class Hero extends StatefulComponent {
  const Hero({super.key});
  @override
  State<Hero> createState() => HeroState();
}

class HeroState extends State<Hero> {
  _Phase _phase = _Phase.waiting;
  Timer? _phaseTimer;
  Timer? _typingTimer;
  Timer? _glitchTimer;
  Timer? _scrollPoll;
  int _glitchSeed = 0;

  // Intro reveal/typing state.
  //
  // The strings start at their full value so the server-rendered document
  // contains the real name and role — a no-JS reader and a crawler get a
  // complete hero. The client-side intro then blanks them and types them
  // again; the `phase-*` classes below keep the pre-intro copy out of the
  // way while JavaScript is driving the sequence.
  bool _avatarVisible = false;
  bool _eyebrowStarted = false;
  bool _nameStarted = false;
  String _eyebrowText = _eyebrowFull;
  String _nameText = _nameFull;
  static const String _eyebrowFull = 'Software Engineer';
  static const String _nameFull = 'Omar Adel';

  /// The positioning line that replaces the old paragraph-length bio.
  static const String _positioning =
      'Cross-platform apps, the backend and cloud behind them, and the AI tooling that speeds it up.';

  /// The stack line — mono, comma separated, no middle dots.
  static const String _stack = 'Flutter, .NET, AI, mobile, web, desktop';

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
      _phaseTimer = Timer(Duration(milliseconds: _Intro.holdMs), _beginIntro);
      _startScrollWatch();
    }
  }

  /// The first real scroll skips the intro. The scene scrub takes over
  /// immediately, so the page never feels stuck behind an animation.
  void _startScrollWatch() {
    _scrollPoll?.cancel();
    _scrollPoll = Timer.periodic(Duration(milliseconds: _Intro.pollMs), (timer) {
      if (_phase == _Phase.done) {
        timer.cancel();
        _scrollPoll = null;
        return;
      }
      if (web.window.scrollY > 16) {
        timer.cancel();
        _scrollPoll = null;
        _skipToFinal();
      }
    });
  }

  void _startGlitchLoop() {
    _scheduleNextGlitch();
  }

  void _scheduleNextGlitch() {
    final intervalMs = _Intro.glitchMs + _randomHashCode();
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
    _scrollPoll?.cancel();
    super.dispose();
  }

  void _askNono() {
    onToggleNono?.call();
  }

  // ---------- Intro phases ----------

  void _startTyping({
    required String fullText,
    required void Function(String) setValue,
    required void Function() onStart,
    required void Function() onDone,
  }) {
    var index = 0;
    _typingTimer?.cancel();
    // `onStart` blanks the text and flips the phase class in the same frame,
    // so the full server-rendered string never flashes before the typing.
    onStart();
    _typingTimer = Timer.periodic(Duration(milliseconds: _Intro.typingMs), (timer) {
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
    _phaseTimer = Timer(Duration(milliseconds: _Intro.avatarInMs), _startEyebrow);
  }

  void _startEyebrow() {
    if (_phase == _Phase.done) return;
    _startTyping(
      fullText: _eyebrowFull,
      setValue: (value) => setState(() => _eyebrowText = value),
      onStart: () => setState(() {
        _eyebrowText = '';
        _eyebrowStarted = true;
      }),
      onDone: _startName,
    );
  }

  void _startName() {
    if (_phase == _Phase.done) return;
    _startTyping(
      fullText: _nameFull,
      setValue: (value) => setState(() => _nameText = value),
      onStart: () => setState(() {
        _nameText = '';
        _nameStarted = true;
      }),
      onDone: _startCursorIn,
    );
  }

  void _startCursorIn() {
    if (_phase == _Phase.done) return;
    // Phase: cursor fades in at the top-left of the viewport.
    setState(() {
      _phase = _Phase.cursorIn;
      _cursorOpacity = 1;
      _cursorTransition = 'opacity var(--dur-control) var(--ease-out)';
    });
    _phaseTimer = Timer(Duration(milliseconds: _Intro.cursorInMs), _startTravel);
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
    if (_phase == _Phase.done) return;
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.travel;
      _cursorTransform = 'translate(${(m.left - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px)';
      _cursorTransition = 'transform ${_Intro.travelMs}ms ${_Intro.travelEase}';
    });
    _phaseTimer = Timer(Duration(milliseconds: _Intro.travelMs), _press);
  }

  void _press() {
    if (_phase == _Phase.done) return;
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.press;
      _cursorTransform =
          'translate(${(m.left - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px) scale(0.9)';
      _cursorTransition = 'transform var(--dur-micro) var(--ease-out)';
      _handlesVisible = true;
      _handleTransition = 'opacity var(--dur-micro) var(--ease-out)';
    });
    _phaseTimer = Timer(Duration(milliseconds: _Intro.pressMs), _startSweep);
  }

  void _startSweep() {
    if (_phase == _Phase.done) return;
    final m = _measureName();
    if (m == null) {
      _skipToFinal();
      return;
    }
    setState(() {
      _phase = _Phase.sweep;
      _cursorTransform =
          'translate(${(m.right - 5.3).toStringAsFixed(1)}px, ${(m.centerY - 0.8).toStringAsFixed(1)}px)';
      _cursorTransition = 'transform ${_Intro.sweepMs}ms ${_Intro.sweepEase}';
      _highlight = 1;
      _highlightTransition = 'transform ${_Intro.sweepMs}ms ${_Intro.sweepEase}';
      _endLeft = '100%';
      _handleTransition =
          'left ${_Intro.sweepMs}ms ${_Intro.sweepEase}, '
          'opacity var(--dur-micro) var(--ease-out)';
    });
    _phaseTimer = Timer(Duration(milliseconds: _Intro.sweepMs), _revealPill);
  }

  void _revealPill() {
    if (_phase == _Phase.done) return;
    // One orchestrated beat: the stack line, the positioning line and the
    // two actions land together, staggered by their CSS transition delays.
    setState(() {
      _phase = _Phase.pill;
      _pillVisible = true;
    });
    // Releasing the hold here is what lifts the intro copy. The actions
    // carry their own delay, so the three land as one sequence.
    _removeIntroHold();
    _phaseTimer = Timer(Duration(milliseconds: _Intro.pillMs), _startDrift);
  }

  void _startDrift() {
    if (_phase == _Phase.done) return;
    final m = _measureName();
    if (m == null) {
      _finish();
      return;
    }
    setState(() {
      _phase = _Phase.drift;
      _cursorTransform =
          'translate(${(m.right - 5.3 + 48).toStringAsFixed(1)}px, ${(m.centerY - 0.8 + 40).toStringAsFixed(1)}px)';
      _cursorTransition =
          'transform ${_Intro.driftMoveMs}ms ease-out, '
          'opacity ${_Intro.driftFadeMs}ms ease-out';
      _cursorOpacity = 0;
    });
    _phaseTimer = Timer(Duration(milliseconds: _Intro.driftMs), _finish);
  }

  void _finish() {
    if (_phase == _Phase.done) return;
    setState(() {
      _phase = _Phase.done;
      // The selection knobs were part of the sweep. Once the sweep is over
      // they retire and only the soft amber wash on the name remains.
      _handlesVisible = false;
      _handleTransition = 'opacity var(--dur-control) var(--ease-out)';
    });
    _scrollPoll?.cancel();
    _scrollPoll = null;
    _removeIntroHold();
    // Start the avatar glitch only after the complete page reveal has settled.
    _phaseTimer = Timer(Duration(milliseconds: _Intro.settleMs), _startGlitchLoop);
  }

  /// Jump straight to the finished hero: cancel everything in flight and
  /// paint the end state. The first real scroll calls this, and so do the
  /// reduced-motion and coarse-pointer paths.
  void _skipToFinal() {
    // Cancel the pending timers *before* painting the end state. Otherwise
    // a phase timer that is already queued fires afterwards and replays the
    // whole choreography on top of the finished hero.
    _phaseTimer?.cancel();
    _phaseTimer = null;
    _typingTimer?.cancel();
    _typingTimer = null;
    _scrollPoll?.cancel();
    _scrollPoll = null;

    setState(() {
      _phase = _Phase.done;
      _avatarVisible = true;
      _eyebrowStarted = true;
      _nameStarted = true;
      _eyebrowText = _eyebrowFull;
      _nameText = _nameFull;
      _highlight = 1;
      _endLeft = '100%';
      // The knobs belong to the sweep; a skipped intro never shows them.
      _handlesVisible = false;
      _pillVisible = true;
      _cursorOpacity = 0;
      _cursorTransition = 'none';
      _highlightTransition = 'none';
      _handleTransition = 'none';
    });
    _removeIntroHold();
    _phaseTimer = Timer(Duration(milliseconds: _Intro.settleMs), _startGlitchLoop);
  }

  void _removeIntroHold() {
    try {
      web.document.documentElement?.classList.remove('intro-hold');
    } catch (_) {}
  }

  // ---------- Build ----------

  @override
  Component build(BuildContext context) {
    // The phase classes drive the intro from CSS, not from inline styles, so
    // the server-rendered document can carry the full hero without the
    // client having to hand-correct it.
    final heroClasses = StringBuffer('hero');
    if (_avatarVisible) heroClasses.write(' phase-avatar-in');
    if (_eyebrowStarted) heroClasses.write(' phase-eyebrow');
    if (_nameStarted) heroClasses.write(' phase-name');
    if (_pillVisible) heroClasses.write(' phase-pill');
    final glitchActive = _glitchSeed % 2 == 1;

    return section(
      classes: heroClasses.toString(),
      id: 'top',
      [
        // Animated overlay cursor. It is a sibling of .hero-inner rather
        // than a child, so the scene's recede transform on .hero-inner can
        // never trap its fixed positioning inside a transformed box.
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
        div(classes: 'container hero-inner', [
          // Avatar — static, glitch/signal pulse overlay only.
          div(
            classes: 'hero-avatar-wrap',
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
          // Positioning line — replaces the old 994-char bio.
          p(
            classes: 'hero-desc intro-item',
            styles: Styles(raw: {'--i': '0'}),
            [Component.text(_positioning)],
          ),
          // Stack line — the mono second voice.
          p(
            classes: 'hero-role intro-item',
            styles: Styles(raw: {'--i': '1'}),
            [Component.text(_stack)],
          ),
          // Actions — one primary (Open CV) and one outline (Ask Nono).
          // Always mounted, space reserved, revealed as a single beat.
          div(
            classes: 'hero-actions',
            [
              button(
                attributes: {'type': 'button'},
                classes: 'btn hero-btn hero-btn-primary',
                onClick: _openCV,
                [
                  span(classes: 'hero-btn-ico', [
                    RawText(
                      '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><polyline points="9 15 12 18 15 15"/></svg>',
                    ),
                  ]),
                  span(classes: 'hero-btn-label', [Component.text('Open CV')]),
                ],
              ),
              button(
                attributes: {'type': 'button'},
                classes: 'btn hero-btn hero-btn-ghost',
                onClick: _askNono,
                [
                  span(classes: 'hero-btn-ico', [
                    RawText(
                      '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>',
                    ),
                  ]),
                  span(classes: 'hero-btn-label', [Component.text('Ask Nono')]),
                ],
              ),
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
        padding: Padding.symmetric(vertical: 48.px),
        display: Display.flex,
        alignItems: AlignItems.center,
        backgroundColor: cCanvas,
        overflow: .hidden,
      ),
      css('.hero-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.start,
        textAlign: TextAlign.left,
        position: Position.relative(),
      ),
      // Avatar.
      css('.hero-avatar-wrap').styles(
        margin: .only(bottom: 24.px),
        display: Display.flex,
        justifyContent: JustifyContent.start,
        position: Position.relative(),
        width: 112.px,
        height: 112.px,
        raw: const {
          'transition': 'opacity var(--dur-panel) var(--ease-out), transform var(--dur-panel) var(--ease-out)',
        },
      ),
      css('.hero-avatar-glitch').styles(
        width: 112.px,
        height: 112.px,
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
          'display': 'inline-block',
        },
        margin: .only(bottom: 16.px),
        fontSize: fontMicro.px,
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
        fontSize: fontDisplay.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-1.4).px,
        lineHeight: 1.05.em,
        color: cInk,
        margin: .only(bottom: 16.px),
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
      // Actions — primary (amber) + outline (ghost).
      css('.hero-actions').styles(
        raw: const {
          'display': 'flex',
          'flex-wrap': 'wrap',
          'align-items': 'center',
          'gap': '12px',
        },
        margin: .only(top: 28.px, bottom: 0.px),
      ),
      css('.hero-btn').styles(
        raw: const {
          'font-family': 'inherit',
          'cursor': 'pointer',
        },
      ),
      css('.hero-btn-ico').styles(
        raw: const {
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '16px',
          'height': '16px',
        },
      ),
      css('.hero-btn-label').styles(
        raw: const {
          'white-space': 'nowrap',
        },
      ),
      // The hero buttons reuse the site-wide `.btn` metrics — one button
      // system, two weights. The compound selector outranks `.btn` so the
      // palette rules win regardless of stylesheet order.
      css('.hero .hero-btn-primary').styles(
        raw: const {
          'background': 'var(--primary)',
          'border-color': 'var(--primary)',
          'color': 'var(--on-primary)',
        },
      ),
      css('.hero .hero-btn-primary:hover').styles(
        raw: const {
          'background': 'var(--primary-pressed)',
          'border-color': 'var(--primary-pressed)',
        },
      ),
      css('.hero .hero-btn-ghost').styles(
        raw: const {
          'background': 'transparent',
          'border-color': 'var(--hairline)',
          'color': 'var(--ink)',
        },
      ),
      css('.hero .hero-btn-ghost:hover').styles(
        raw: const {
          'background': 'var(--soft)',
          'border-color': 'var(--ink)',
        },
      ),
      // Positioning line + mono stack.
      css('.hero-desc').styles(
        fontSize: fontBody.px,
        lineHeight: 1.6.em,
        color: cBody,
        maxWidth: 600.px,
        margin: .only(bottom: 12.px),
      ),
      css('.hero-role').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        fontWeight: FontWeight.w500,
        lineHeight: 1.5.em,
        color: cMute,
        margin: .only(bottom: 0.px),
      ),
    ]),

    // ---------- The intro, driven from CSS ----------
    // The server-rendered hero is complete: the name, the role, the portrait
    // and both actions are all in the document. These rules only apply once
    // JavaScript is present, and they hold the copy back until the intro
    // reaches it — so a no-JS reader gets the finished hero and a crawler
    // gets the real name.
    css('html.js-enabled .hero .hero-avatar-wrap').styles(
      raw: const {
        'opacity': '0',
        'transform': 'translateY(10px)',
      },
    ),
    css('html.js-enabled .hero.phase-avatar-in .hero-avatar-wrap').styles(
      raw: const {
        'opacity': '1',
        'transform': 'translateY(0)',
      },
    ),
    css('html.js-enabled .hero .hero-eyebrow').styles(
      raw: const {'visibility': 'hidden'},
    ),
    css('html.js-enabled .hero.phase-eyebrow .hero-eyebrow').styles(
      raw: const {'visibility': 'visible'},
    ),
    css('html.js-enabled .hero .name-text').styles(
      raw: const {'visibility': 'hidden'},
    ),
    css('html.js-enabled .hero.phase-name .name-text').styles(
      raw: const {'visibility': 'visible'},
    ),
    css('html.js-enabled .hero .hero-actions').styles(
      raw: {
        'opacity': '0',
        'visibility': 'hidden',
        'filter': 'blur(6px)',
        'transform': 'translateY(8px)',
        'transition':
            'opacity var(--dur-panel) var(--ease-out), filter var(--dur-panel) var(--ease-out), transform var(--dur-panel) var(--ease-out)',
        // The actions land one beat after the sweep releases the name.
        'transition-delay': '${_Intro.actionsDelayMs}ms',
      },
    ),
    css('html.js-enabled .hero.phase-pill .hero-actions').styles(
      raw: const {
        'opacity': '1',
        'visibility': 'visible',
        'filter': 'blur(0px)',
        'transform': 'translateY(0)',
      },
    ),
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
    // Responsive. The type ladder does not bend for width: a long title
    // wraps, it does not shrink off the scale.
    css.media(MediaQuery.all(maxWidth: 768.px), [
      css('.hero').styles(padding: .symmetric(vertical: 48.px)),
      css('.hero .hero-avatar-wrap').styles(width: 124.px, height: 124.px),
      css('.hero .hero-avatar-glitch').styles(width: 124.px, height: 124.px),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.hero .hero-avatar-wrap').styles(width: 108.px, height: 108.px),
      css('.hero .hero-avatar-glitch').styles(width: 108.px, height: 108.px),
    ]),
  ];
}
