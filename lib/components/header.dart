import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../constants/theme.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    return header(classes: 'header', [
      div(classes: 'container header-content', [
        a(href: '#', classes: 'logo', [text('Your Name')]),
        nav(classes: 'nav', [
          a(href: '#about', classes: 'nav-link', [text('About')]),
          a(href: '#expertise', classes: 'nav-link', [text('Expertise')]),
          a(href: '#projects', classes: 'nav-link', [text('Projects')]),
          a(href: '#experience', classes: 'nav-link', [text('Experience')]),
          a(href: '#testimonials', classes: 'nav-link', [text('Testimonials')]),
          a(href: '#contact', classes: 'nav-link btn btn-secondary', [text('Contact')]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.header').styles(
      width: 100.percent,
      padding: .symmetric(vertical: spaceMd.px),
    ),
    
    css('.header-content').styles(
      display: .flex,
      alignItems: .center,
      justifyContent: .spaceBetween,
    ),
    
    css('.logo').styles(
      textDecoration: .none,
      color: accentColor,
      fontWeight: .w700,
      fontSize: 1.5.rem,
      fontFamily: .list([fontSecondary, fontFallback]),
    ),
    
    css('.nav').styles(
      display: .flex,
      alignItems: .center,
      padding: .zero,
    ),
    
    css('.nav-link').styles(
      color: mutedColor,
      fontSize: 0.875.rem,
      fontWeight: .w500,
      padding: .symmetric(vertical: spaceSm.px, horizontal: spaceMd.px),
    ),
    
    css('.nav-link:hover').styles(
      color: accentColor,
    ),
    
    css('.nav-link.btn').styles(
      padding: .symmetric(vertical: 8.px, horizontal: 16.px),
    ),
  ];
}