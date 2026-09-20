import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', id: 'top', [
      div(classes: 'container hero-inner', [
        span(classes: 'eyebrow hero-eyebrow', [Component.text('Hello, I am')]),
        h1(classes: 'hero-name', [Component.text('Omar Adel')]),
        p(classes: 'hero-role', [Component.text('Software Engineer · Front-end & App Developer')]),
        p(classes: 'hero-desc', [
          Component.text(
              'I build products people love to use — Flutter mobile apps, responsive web front-ends, and practical AI tooling. Passionate about clean architecture, great developer experience, and open source.'),
        ]),
        div(classes: 'hero-cta', [
          a(href: '#projects', classes: 'btn btn-primary', [Component.text('View Projects')]),
          a(href: '#contact', classes: 'btn btn-secondary', [Component.text('Get in Touch')]),
          a(href: githubUrl, classes: 'btn btn-tertiary', [Component.text('GitHub →')]),
        ]),
        div(classes: 'hero-featured', [
          span(classes: 'featured-label', [Component.text('Featured in')]),
          div(classes: 'featured-logos', [
            _logo('Flutter'),
            _logo('Dart'),
            _logo('Python'),
            _logo('TypeScript'),
            _logo('Swift'),
            _logo('Open Source'),
          ]),
        ]),
      ]),
    ]);
  }

  Component _logo(String name) => span(classes: 'featured-logo', [Component.text(name)]);

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        padding: Padding.symmetric(vertical: 72.px),
        display: Display.flex,
        alignItems: AlignItems.center,
        backgroundColor: cCanvas,
      ),

      css('.hero-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
        maxWidth: 820.px,
      ),

      css('.hero-eyebrow').styles(margin: .only(bottom: 16.px)),

      css('.hero-name').styles(
        fontSize: 60.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-1.2).px,
        lineHeight: 1.05.em,
        color: cInk,
        margin: .only(bottom: 16.px),
      ),

      css('.hero-role').styles(
        fontSize: 22.px,
        fontWeight: FontWeight.w600,
        color: cCharcoal,
        margin: .only(bottom: 18.px),
      ),

      css('.hero-desc').styles(
        fontSize: 17.px,
        lineHeight: 1.6.em,
        color: cMute,
        maxWidth: 660.px,
        margin: .only(bottom: 30.px),
      ),

      css('.hero-cta').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        gap: Gap.all(12.px),
        margin: .only(bottom: 40.px),
      ),

      css('.hero-featured').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        width: 100.percent,
        padding: .only(top: 24.px),
        border: Border.only(top: BorderSide.solid(color: cHairlineSoft, width: 1.px)),
      ),

      css('.featured-label').styles(
        fontSize: 13.px,
        fontWeight: FontWeight.w700,
        textTransform: .upperCase,
        letterSpacing: 0.08.em,
        color: cAsh,
        margin: .only(bottom: 18.px),
      ),

      css('.featured-logos').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        gap: Gap.all(12.px),
      ),

      css('.featured-logo').styles(
        padding: .symmetric(vertical: 8.px, horizontal: 18.px),
        radius: .all(.circular(radiusFull.px)),
        border: Border.all(color: cHairline, width: 1.px),
        backgroundColor: cCard,
        color: cMute,
        fontSize: 14.px,
        fontWeight: FontWeight.w600,
        whiteSpace: .noWrap,
      ),
    ]),

    // Responsive
    css.media(MediaQuery.all(maxWidth: 768.px), [
      css('.hero').styles(padding: .symmetric(vertical: 56.px)),
      css('.hero .hero-name').styles(fontSize: 44.px),
      css('.hero .hero-role').styles(fontSize: 19.px),
      css('.hero .hero-desc').styles(fontSize: 16.px),
      css('.hero .hero-cta').styles(gap: Gap.all(10.px)),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.hero .hero-name').styles(fontSize: 36.px),
      css('.hero .hero-cta .btn').styles(width: 100.percent, justifyContent: .center),
      css('.hero .featured-logo').styles(padding: .symmetric(vertical: 7.px, horizontal: 14.px)),
    ]),
  ];
}