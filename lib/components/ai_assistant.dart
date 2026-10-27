import 'dart:async';
import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
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

  final _random = Random();

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

  void _toggle() {
    _onInteraction();
    setState(() => _isOpen = !_isOpen);
  }

  void _close() {
    if (_isOpen) setState(() => _isOpen = false);
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
              div(classes: 'ai-prompt-chips', [
                for (final chip in [
                  'What technologies do you use?',
                  'Show me your Flutter projects',
                  'Tell me about your AI integrations',
                  'How do you approach clean architecture?',
                ])
                  button(
                    classes: 'ai-prompt-chip',
                    onClick: () {},
                    [Component.text(chip)],
                  ),
              ]),
              div(classes: 'ai-input-area', [
                input(
                  classes: 'ai-input',
                  attributes: {
                    'placeholder': 'Ask about Nono…',
                    'aria-label': 'Nono assistant input',
                  },
                ),
                button(
                  classes: 'ai-send-btn',
                  onClick: () {},
                  [Component.text('Send')],
                ),
              ]),
              div(classes: 'ai-hint', [
                Component.text('Shortcuts: Ctrl+/ or Ctrl+\\ to open · Esc to close'),
              ]),
            ]),
          ]),
        ]),

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
      raw: const {'inset': '0', 'background-color': 'rgba(35, 37, 29, 0.4)'},
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
      raw: const {'overflow-y': 'auto'},
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
