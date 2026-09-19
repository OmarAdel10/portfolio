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
            text('© 2024 Omar Adel. All rights reserved.'),
          ]),
          div(classes: 'footer-links', [
            a(href: 'https://github.com/OmarAdel10', classes: 'footer-link', [
              text('GitHub'),
              span(classes: 'footer-stat', [text('32 repos')]),
            ]),
            a(href: 'https://linkedin.com/in/omaradel10', classes: 'footer-link', [text('LinkedIn')]),
            a(href: 'mailto:omaradel10.dev@gmail.com', classes: 'footer-link', [text('Email')]),
          ]),
        ]),
        div(classes: 'footer-stats', [
          span(classes: 'stat-item', [
            span(classes: 'stat-value', [text('32')]),
            span(classes: 'stat-label', [text('Repositories')]),
          ]),
          span(classes: 'stat-item', [
            span(classes: 'stat-value', [text('5+')]),
            span(classes: 'stat-label', [text('Languages')]),
          ]),
          span(classes: 'stat-item', [
            span(classes: 'stat-value', [text('10+')]),
            span(classes: 'stat-label', [text('Projects')]),
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
        border: Border.all(color: Color('#333333'), width: 1.px),
      ),
      
      css('.footer-content').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        flexWrap: FlexWrap.wrap,
        padding: .only(bottom: 24.px),
        border: Border.all(color: Color('#333333'), width: 1.px),
      ),
      
      css('.footer-copyright').styles(
        fontSize: 0.875.rem,
        color: Color('#666666'),
      ),
      
      css('.footer-links').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
      ),
      
      css('.footer-link').styles(
        fontSize: 0.875.rem,
        color: Color('#888888'),
        display: Display.flex,
        alignItems: AlignItems.center,
        margin: .symmetric(horizontal: 12.px),
      ),
      
      css('.footer-link:hover').styles(
        color: Color('#FFFFFF'),
      ),
      
      css('.footer-stat').styles(
        fontSize: 0.75.rem,
        color: Color('#0175C2'),
        backgroundColor: Color('#0175C220'),
        padding: .symmetric(vertical: 2.px, horizontal: 8.px),
        radius: .all(.circular(9999.px)),
        margin: .only(left: 8.px),
      ),
      
      css('.footer-stats').styles(
        display: Display.flex,
        justifyContent: JustifyContent.center,
        flexWrap: FlexWrap.wrap,
      ),
      
      css('.stat-item').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        margin: .symmetric(horizontal: 24.px),
      ),
      
      css('.stat-value').styles(
        fontSize: 1.5.rem,
        fontWeight: FontWeight.w700,
        color: Color('#FFFFFF'),
        fontFamily: FontFamily('Space Grotesk'),
      ),
      
      css('.stat-label').styles(
        fontSize: 0.875.rem,
        color: Color('#888888'),
        margin: .only(top: 4.px),
      ),
    ]),
  ];
}