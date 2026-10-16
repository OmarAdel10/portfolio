import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// Conversational Nono assistant placeholder UI.
///
/// Keyboard shortcut: Ctrl+/ (or Cmd+/) to open.
/// No backend integration yet — UI only placeholder to reserve space and convey
/// future intent.
class AIAssistant extends StatefulComponent {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant> {
  bool _isOpen = false;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  void _close() {
    if (_isOpen) setState(() => _isOpen = false);
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'ai-assistant', [
      // Floating action button
      button(
        classes: 'ai-fab',
        onClick: _toggle,
        attributes: {
          'aria-label': _isOpen ? 'Close Nono assistant' : 'Open Nono assistant',
          'aria-expanded': _isOpen.toString(),
        },
        [
          Component.text('Ask Nono'),
        ],
      ),

      // Modal (hidden when closed)
      if (_isOpen)
        div(classes: 'ai-modal-overlay', onClick: _close, [
          div(classes: 'ai-modal', [
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
                Component.text('Keyboard shortcut: Ctrl+/ (or Cmd+/) to open'),
              ]),
            ]),
          ]),
        ]),

      // Backdrop to close modal on outside click
      if (_isOpen)
        div(classes: 'ai-backdrop', onClick: _close),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.ai-assistant', [
      css('&').styles(
        position: Position.fixed(),
        bottom: 24.px,
        right: 24.px,
        zIndex: ZIndex(9999),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
      ),

      css('.ai-fab').styles(
        backgroundColor: cPrimary,
        color: cOnPrimary,
        border: Border.none,
        radius: .all(.circular(radiusFull.px)),
        padding: .symmetric(vertical: 12.px, horizontal: 20.px),
        fontSize: 14.px,
        fontWeight: FontWeight.w700,
        cursor: .pointer,
        boxShadow: '0 4px 12px -4px rgba(35, 37, 29, 0.25)',
        transition: Transition(
          'transform',
          duration: Duration(milliseconds: 200),
          curve: Curve.easeOut,
        ),
      ),
      css('.ai-fab:hover').styles(
        raw: const {'transform': 'scale(1.05)'},
      ),
      css('.ai-fab:focus-visible').styles(
        raw: const {'outline': '2px solid var(--primary)', 'outline-offset': '2px'},
      ),

      css('.ai-modal-overlay').styles(
        position: Position.fixed(),
        inset: '0',
        backgroundColor: 'rgba(35, 37, 29, 0.4)',
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        zIndex: ZIndex(10000),
        padding: Padding.all(24.px),
        animation: Animation(
          name: 'aiFadeIn',
          duration: Duration(milliseconds: 250),
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
        boxShadow: '0 24px 48px -16px rgba(35, 37, 29, 0.35)',
        animation: Animation(
          name: 'aiSlideUp',
          duration: Duration(milliseconds: 250),
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
        margin: 0.px,
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
        overflowY: Overflow.auto,
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
          duration: Duration(milliseconds: 150),
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
        outline: '2px solid var(--primary)',
        outlineOffset: '-1px',
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

      css('.ai-backdrop').styles(
        position: Position.fixed(),
        inset: '0',
        zIndex: ZIndex(9998),
      ),
    ]),

    css('@keyframes aiFadeIn', {
      '0%': Styles(raw: {'opacity': '0'}),
      '100%': Styles(raw: {'opacity': '1'}),
    }),
    css('@keyframes aiSlideUp', {
      '0%': Styles(raw: {'transform': 'translateY(20px)', 'opacity': '0'}),
      '100%': Styles(raw: {'transform': 'translateY(0)', 'opacity': '1'}),
    }),
  ];
}
