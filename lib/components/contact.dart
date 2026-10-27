import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'cupertino_icon.dart';

/// The closing call to action. Centred register: one headline, one primary
/// action, and the remaining channels as a quiet mono list instead of a row
/// of identical pills. The mascot lives in the footer now, so this block
/// stays typographic.
class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'contact section section--centered', id: 'contact', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Available for work')]),
          h2(classes: 'section-title', [Component.text('Tell me what you are building')]),
          p(classes: 'section-subtitle', [
            Component.text(
              'Send an email, or reach out on whichever channel suits you. I read every message.',
            ),
          ]),
        ]),

        div(classes: 'contact-cta reveal', [
          a(href: mailtoUrl, classes: 'btn btn-warm contact-cta-btn email-fallback', [
            const CupertinoIcon(
              icon: CupertinoIconName.envelopeFill,
              color: CupertinoIconColor.onPrimary,
              size: CupertinoIconSize.sm,
            ),
            Component.text('Send an email'),
          ]),
        ]),

        div(classes: 'contact-links reveal', [
          _link('GitHub', 'github.com/OmarAdel10', githubUrl),
          _link('LinkedIn', 'linkedin.com/in/omaradel10', linkedinUrl),
          _link('WhatsApp', 'wa.me/201552210048', whatsappUrl),
          _link('Phone', phoneNumber, phoneUrl, external: false),
        ]),
      ]),
    ]);
  }

  Component _link(String label, String value, String href, {bool external = true}) {
    return a(
      href: href,
      classes: 'contact-link',
      target: external ? Target.blank : null,
      attributes: external ? {'rel': 'noopener noreferrer'} : const {},
      [
        span(classes: 'contact-link-label', [Component.text(label)]),
        span(classes: 'contact-link-value', [Component.text(value)]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact', [
      css('.contact-cta').styles(
        display: Display.flex,
        justifyContent: JustifyContent.center,
        margin: .only(bottom: 48.px),
      ),

      // The channel list is the mono second voice: label on the left, the
      // address on the right, hairline rules doing the separating.
      css('.contact-links').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        maxWidth: 520.px,
        margin: .only(left: .auto, right: .auto),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
      css('.contact-link').styles(
        display: Display.flex,
        alignItems: AlignItems.baseline,
        justifyContent: JustifyContent.spaceBetween,
        gap: Gap.all(24.px),
        padding: .symmetric(vertical: 16.px),
        border: Border.only(
          bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        textDecoration: .none,
      ),
      css('.contact-link-label').styles(
        color: cMute,
        fontWeight: FontWeight.w500,
        whiteSpace: .noWrap,
      ),
      css('.contact-link-value').styles(
        color: cInk,
        textAlign: TextAlign.right,
        raw: const {
          'transition': 'color var(--dur-micro) var(--ease-out)',
        },
      ),
      css('.contact-link:hover .contact-link-value').styles(
        color: cInk,
        raw: const {
          'text-decoration': 'underline',
          'text-decoration-color': 'var(--primary)',
          'text-underline-offset': '4px',
        },
      ),
      css('.contact-link:hover .contact-link-label').styles(color: cBody),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.contact .contact-link').styles(
        gap: Gap.all(16.px),
        padding: .symmetric(vertical: 12.px),
      ),
      css('.contact .contact-link-value').styles(fontSize: fontMicro.px),
    ]),
  ];
}
