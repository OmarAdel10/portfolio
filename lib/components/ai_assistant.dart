import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'hero.dart';

/// Conversational Nono assistant placeholder UI.
///
/// Keyboard shortcut: Ctrl+/ (or Cmd+/) to open.
/// No backend integration yet — UI only placeholder to reserve space and convey
/// future intent.
class AIAssistant extends StatefulComponent {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => AIAssistantState();
}

class AIAssistantState extends State<AIAssistant> {
  bool _isOpen = false;

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  void _close() {
    if (_isOpen) setState(() => _isOpen = false);
  }

  @override
  void initState() {
    super.initState();
    // Register the toggle callback so the Hero "Ask Nono" button can open this panel.
    onToggleNono = _toggle;
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'ai-assistant', [
      // Illustrated ChatBot avatar button (replaces normal text button)
      button(
        classes: 'ai-fab chatbot-avatar-btn',
        onClick: _toggle,
        attributes: {
          'aria-label': _isOpen ? 'Close Nono assistant' : 'Open Nono assistant',
          'aria-expanded': _isOpen.toString(),
        },
        [
          span(classes: 'chatbot-avatar', [Component.text('🤖')]),
        ],
      ),

      // Modal (hidden when closed)
      if (_isOpen)
        div(classes: 'ai-modal-overlay', [
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
      if (_isOpen) div(classes: 'ai-backdrop', []),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.ai-assistant', [
      css('&').styles(
        position: Position.fixed(),
        raw: const {'bottom': '24px', 'right': '24px'},
        zIndex: ZIndex(9999),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
      ),

      // ChatBot avatar button styling
      css('.ai-fab.chatbot-avatar-btn').styles(
        backgroundColor: Colors.transparent,
        border: Border.none,
        padding: .zero,
        margin: .zero,
        width: 56.px,
        height: 56.px,
        cursor: .pointer,
        display: .inlineFlex,
        alignItems: AlignItems.center,
        justifyContent: .center,
        raw: const {
          'box-shadow': 'none',
          'animation': 'none',
        },
      ),
      css('.ai-fab.chatbot-avatar-btn:hover').styles(
        raw: const {
          'transform': 'none',
        },
      ),
      css('.ai-fab.chatbot-avatar-btn:focus-visible').styles(
        raw: const {
          'outline': 'none',
        },
      ),

      css('.chatbot-avatar').styles(
        raw: const {
          'width': '56px',
          'height': '56px',
          'border-radius': '50%',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'background': 'var(--primary)',
          'color': 'var(--on-primary)',
          'font-size': '24px',
          'font-weight': '700',
          'border': '3px solid var(--canvas)',
          'box-shadow': '0 8px 24px -8px rgba(35, 37, 29, 0.25)',
          'animation': 'chatbotFloat 4s ease-in-out infinite, chatbotPulse 2.5s ease-in-out infinite',
          'cursor': 'pointer',
          'transition': 'all 0.3s ease',
        },
      ),
      css('.chatbot-avatar:hover').styles(
        raw: const {
          'transform': 'scale(1.15)',
          'border-color': 'var(--on-primary)',
          'box-shadow': '0 12px 32px -10px rgba(35, 37, 29, 0.35)',
        },
      ),

      css('.ai-fab:hover').styles(
        raw: const {'transform': 'scale(1.05)'},
      ),
      css('.ai-fab:focus-visible').styles(
        raw: const {'outline': '2px solid var(--primary)', 'outline-offset': '2px'},
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
        raw: const {'box-shadow': '0 24px 48px -16px rgba(35, 37, 29, 0.35)'},
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

      css('.ai-backdrop').styles(
        position: Position.fixed(),
        raw: const {'inset': '0'},
        zIndex: ZIndex(9998),
      ),
    ]),

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
