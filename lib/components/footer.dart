import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'footer', [
      div(classes: 'container', [
        div(classes: 'footer-content', [
          p(classes: 'footer-copyright', [
            text('© 2024 Your Name. All rights reserved.'),
          ]),
          div(classes: 'footer-links', [
            a(href: 'https://github.com', classes: 'footer-link', [text('GitHub')]),
            a(href: 'https://linkedin.com', classes: 'footer-link', [text('LinkedIn')]),
            a(href: 'https://twitter.com', classes: 'footer-link', [text('Twitter')]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.footer', [
      css('&').styles(
        padding: .symmetric(vertical: 32.px),
        backgroundColor: Color('#0A0A0A'),
        border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
      ),
      
      css('.footer-content', [
        css('&').styles(
          display: .flex,
          justifyContent: .spaceBetween,
          alignItems: .center,
          flexWrap: .wrap,
        ),
      ]),
      
      css('.footer-copyright').styles(
        fontSize: 0.875.rem,
        color: Color('#666666'),
      ),
      
      css('.footer-links', [
        css('&').styles(
          display: .flex,
        ),
      ]),
      
      css('.footer-link', [
        css('&').styles(
          fontSize: 0.875.rem,
          color: Color('#888888'),
          margin: .symmetric(horizontal: 12.px),
        ),
        css('&:hover').styles(
          color: Color('#FFFFFF'),
        ),
      ]),
    ]),
  ];
}