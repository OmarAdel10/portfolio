import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', [
      div(classes: 'container', [
        div(classes: 'hero-content', [
          div(classes: 'hero-badge', [
            span(classes: 'badge-dot', []),
            text('Available for freelance & open source'),
          ]),
          h1(classes: 'hero-name', [text('Omar Adel 10')]),
          h2(classes: 'hero-title', [
            text('Full Stack Developer'),
            br(),
            text('Mobile • Web • AI • Open Source'),
          ]),
          p(classes: 'hero-description', [
            text('Building scalable applications with Flutter, Python, and modern web technologies. '),
            text('Passionate about clean architecture, developer experience, and open source.'),
          ]),
          div(classes: 'hero-cta', [
            a(href: '#projects', classes: 'btn btn-primary', [text('View Projects')]),
            a(href: '#contact', classes: 'btn btn-secondary', [text('Get In Touch')]),
            a(href: 'https://github.com/OmarAdel10', classes: 'btn btn-ghost', [text('GitHub')]),
          ]),
          div(classes: 'hero-featured', [
            text('FEATURED IN'),
            div(classes: 'featured-logos', [
              _buildLogo('Flutter'),
              _buildLogo('Dart'),
              _buildLogo('Python'),
              _buildLogo('TypeScript'),
              _buildLogo('Open Source'),
            ]),
          ]),
          div(classes: 'hero-social', [
            a(href: 'https://github.com/OmarAdel10', classes: 'social-link', [text('GitHub')]),
            a(href: 'https://linkedin.com/in/omaradel10', classes: 'social-link', [text('LinkedIn')]),
            a(href: 'mailto:omaradel10.dev@gmail.com', classes: 'social-link', [text('Email')]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _buildLogo(String name) {
    return span(classes: 'featured-logo', [text(name)]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        minHeight: 100.vh,
        display: Display.flex,
        alignItems: AlignItems.center,
        padding: Padding.symmetric(vertical: 64.px),
      ),
      css('.hero-content').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
      ),
      css('.hero-name').styles(
        fontSize: 4.rem,
        fontWeight: FontWeight.w700,
        color: Color('#FFFFFF'),
        fontFamily: FontFamily('Space Grotesk'),
        margin: Margin.only(bottom: 8.px),
      ),
      css('.hero-title').styles(
        fontSize: 2.rem,
        color: Color('#888888'),
        margin: Margin.only(bottom: 16.px),
      ),
      css('.hero-description').styles(
        fontSize: 1.125.rem,
        color: Color('#AAAAAA'),
        maxWidth: 600.px,
        margin: Margin.only(bottom: 24.px),
      ),
      css('.hero-cta').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        margin: Margin.only(top: 16.px, bottom: 24.px),
      ),
      css('.hero-featured').styles(
        margin: Margin.symmetric(vertical: 24.px),
      ),
      css('.hero-social').styles(
        display: Display.flex,
        justifyContent: JustifyContent.center,
        padding: Padding.only(top: 24.px),
        border: Border.all(color: Color('#333333'), width: 1.px),
      ),
    ]),
  ];
}