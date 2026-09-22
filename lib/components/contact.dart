import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'contact section', id: 'contact', [
      div(classes: 'container', [
        div(classes: 'contact-card card reveal', [
          span(classes: 'eyebrow', [Component.text('Get in touch')]),
          h2(classes: 'contact-title', [Component.text('Available for select freelance opportunities')]),
          p(classes: 'contact-desc', [
            Component.text(
                'Have an exciting project you need help with? Send me an email or reach out via any of the channels below.'),
          ]),
          // a(href: 'javascript:void(0)', classes: 'contact-email email-fallback', [Component.text(emailAddress)]),
          div(classes: 'contact-links', [
            a(href: githubUrl, classes: 'contact-link', [
              span(classes: 'contact-link-icon', [Component.text('⌘')]),
              span(classes: 'contact-link-label', [Component.text('GitHub')]),
              span(classes: 'contact-link-value', [Component.text('github.com/OmarAdel10')]),
            ]),
            a(href: linkedinUrl, classes: 'contact-link', [
              span(classes: 'contact-link-icon', [Component.text('in')]),
              span(classes: 'contact-link-label', [Component.text('LinkedIn')]),
              span(classes: 'contact-link-value', [Component.text('linkedin.com/in/omaradel10')]),
            ]),
            a(href: 'javascript:void(0)', classes: 'contact-link email-fallback', [
              span(classes: 'contact-link-icon', [Component.text('✉')]),
              span(classes: 'contact-link-label', [Component.text('Email')]),
              span(classes: 'contact-link-value', [Component.text(emailAddress)]),
            ]),
            a(href: whatsappUrl, classes: 'contact-link', [
              span(classes: 'contact-link-icon', [Component.text('✆')]),
              span(classes: 'contact-link-label', [Component.text('WhatsApp')]),
              span(classes: 'contact-link-value', [Component.text(phoneNumber)]),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact', [
      css('.contact-card').styles(
        maxWidth: 760.px,
        margin: .only(left: .auto, right: .auto),
        padding: Padding.all(40.px),
        textAlign: TextAlign.center,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
      ),
      css('.contact-title').styles(
        fontSize: 30.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-0.5).px,
        color: cInk,
        maxWidth: 560.px,
        margin: .only(bottom: 14.px),
      ),
      css('.contact-desc').styles(
        fontSize: 16.px,
        lineHeight: 1.6.em,
        color: cMute,
        maxWidth: 520.px,
        margin: .only(bottom: 24.px),
      ),
      css('.contact-email').styles(
        display: .inlineBlock,
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        color: cLinkTeal,
        textDecoration: .none,
        margin: .only(bottom: 28.px),
      ),
      css('.contact-email:hover').styles(textDecoration: TextDecoration(line: TextDecorationLine.underline)),
      css('.contact-links').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        gap: Gap.all(12.px),
        width: 100.percent,
      ),
      css('.contact-link').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(10.px),
        padding: .symmetric(vertical: 12.px, horizontal: 16.px),
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusMd.px)),
        backgroundColor: cCard,
        textDecoration: .none,
        color: cInk,
      ),
      css('.contact-link:hover').styles(
        border: Border.all(color: cPrimary, width: 1.px),
        textDecoration: .none,
      ),
      css('.contact-link-icon').styles(
        width: 24.px,
        height: 24.px,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        fontSize: 13.px,
        fontWeight: FontWeight.w700,
        color: cOnPrimary,
        backgroundColor: cPrimary,
        radius: .all(.circular(radiusSm.px)),
      ),
      css('.contact-link-label').styles(
        fontSize: 14.px,
        fontWeight: FontWeight.w700,
        color: cInk,
      ),
      css('.contact-link-value').styles(
        fontSize: 13.5.px,
        color: cMute,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.contact .contact-card').styles(padding: Padding.all(26.px)),
      css('.contact .contact-title').styles(fontSize: 25.px),
      css('.contact .contact-link').styles(
        width: 100.percent,
        justifyContent: JustifyContent.start,
      ),
    ]),
  ];
}