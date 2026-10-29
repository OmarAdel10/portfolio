import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'cupertino_icon.dart';
import '../constants/theme.dart';

/// How I work. This is the reflective half of the page, so it takes the
/// centred register: the quotes read as pull-quotes and the credit sits
/// beneath each one in mono. No numbered markers — principles are not a
/// sequence, so the numbers would have encoded a hierarchy that isn't there.
class Testimonials extends StatelessComponent {
  const Testimonials({super.key});

  @override
  Component build(BuildContext context) {
    final principles = [
      _Principle(
        icon: CupertinoIconName.lockShieldFill,
        quote:
            'I treat every project like my own product — from architecture trade-offs down to the last pixel and the final deployment.',
        title: 'Own the outcome',
      ),
      _Principle(
        icon: CupertinoIconName.bolt,
        quote:
            'I reach for boring, reliable technology and clean boundaries over cleverness. Simple systems are the ones that actually ship and scale.',
        title: 'Simple over clever',
      ),
      _Principle(
        icon: CupertinoIconName.chatBubble2Fill,
        quote:
            'Clear updates, early risk calls, and decisions you can follow. I believe honest communication is half the craft.',
        title: 'A teammate, not a vendor',
      ),
    ];

    return section(classes: 'testimonials section section--centered', id: 'testimonials', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          h2(classes: 'section-title', [Component.text('How I work')]),
          p(classes: 'section-subtitle', [
            Component.text('Three principles that shape how I build and collaborate'),
          ]),
        ]),
        div(classes: 'testimonials-list', [
          for (var i = 0; i < principles.length; i++) _buildQuote(principles[i], i),
        ]),
      ]),
    ]);
  }

  Component _buildQuote(_Principle principle, int index) {
    return figure(
      classes: 'pullquote reveal',
      attributes: {'data-stagger-index': '$index'},
      [
        blockquote(classes: 'pullquote-text', [Component.text(principle.quote)]),
        figcaption(classes: 'pullquote-credit', [
          span(classes: 'pullquote-icon', [
            CupertinoIcon(
              icon: principle.icon,
              color: CupertinoIconColor.current,
              size: CupertinoIconSize.sm,
            ),
          ]),
          span(classes: 'pullquote-name', [Component.text(principle.title)]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.testimonials', [
      css('.testimonials-list').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        maxWidth: 720.px,
        margin: .only(left: .auto, right: .auto),
      ),
      // Hairline rules separate the quotes: the section announces itself
      // instead of stacking three floating blocks.
      css('.pullquote').styles(
        padding: Padding.symmetric(vertical: 48.px),
        border: Border.only(
          bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
      css('.pullquote:first-child').styles(
        padding: .only(top: 0.px, bottom: 48.px),
      ),
      css('.pullquote:last-child').styles(
        border: Border.none,
      ),
      css('.pullquote-text').styles(
        fontSize: fontTitleLg.px,
        fontWeight: FontWeight.w500,
        lineHeight: 1.35.em,
        letterSpacing: (-0.4).px,
        color: cInk,
        textAlign: TextAlign.center,
        margin: .only(bottom: 24.px),
      ),
      css('.pullquote-credit').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.all(8.px),
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
      ),
      css('.pullquote-icon').styles(
        display: .inlineFlex,
        color: cInk,
      ),
      css('.pullquote-name').styles(
        color: cInk,
        fontWeight: FontWeight.w500,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 640.px), [
      css('.testimonials .pullquote').styles(
        padding: Padding.symmetric(vertical: 32.px),
      ),
      css('.testimonials .pullquote-text').styles(
        fontSize: fontTitleMd.px,
        lineHeight: 1.45.em,
      ),
    ]),
  ];
}

class _Principle {
  final CupertinoIconName icon;
  final String quote;
  final String title;

  const _Principle({
    required this.icon,
    required this.quote,
    required this.title,
  });
}
