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
            text('Available for freelance projects'),
          ]),
          
          h1(classes: 'hero-name', [text('YOUR NAME')]),
          
          h2(classes: 'hero-title', [
            text('SOFTWARE ENGINEER, '),
            br(),
            text('FRONTEND & APP DEVELOPER.'),
          ]),
          
          p(classes: 'hero-description', [
            text('Building scalable web and mobile applications with modern technologies. '),
            text('Passionate about clean code, great UX, and solving complex problems.'),
          ]),
          
          div(classes: 'hero-cta', [
            a(href: '#contact', classes: 'btn btn-primary', [text('Get In Touch')]),
            a(href: '#projects', classes: 'btn btn-secondary', [text('View Projects')]),
          ]),
          
          div(classes: 'hero-featured', [
            text('AS FEATURED IN'),
            div(classes: 'featured-logos', [
              _buildLogo('Company One'),
              _buildLogo('Company Two'),
              _buildLogo('Company Three'),
              _buildLogo('Company Four'),
              _buildLogo('Company Five'),
              _buildLogo('Company Six'),
            ]),
          ]),
          
          div(classes: 'hero-social', [
            a(href: 'https://github.com', classes: 'social-link', [text('GitHub')]),
            a(href: 'https://linkedin.com', classes: 'social-link', [text('LinkedIn')]),
            a(href: 'https://twitter.com', classes: 'social-link', [text('Twitter')]),
            a(href: 'mailto:you@example.com', classes: 'social-link', [text('Email')]),
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
        display: .flex,
        alignItems: .center,
        padding: .symmetric(vertical: 64.px),
      ),
      
      css('.hero-content', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
        ),
      ]),
      
      css('.hero-badge', [
        css('&').styles(
          display: .inlineFlex,
          alignItems: .center,
          padding: .symmetric(vertical: 4.px, horizontal: 16.px),
          backgroundColor: Color('#FFFFFF10'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          fontSize: 0.875.rem,
          color: Color('#888888'),
        ),
      ]),
      
      css('.badge-dot', [
        css('&').styles(
          width: 8.px,
          height: 8.px,
          backgroundColor: Color('#FFFFFF'),
          margin: .symmetric(horizontal: 8.px),
        ),
      ]),
      
      css('.hero-name', [
        css('&').styles(
          fontSize: 4.rem,
          fontWeight: .w700,
          lineHeight: 1.1.em,
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
          color: Color('#FFFFFF'),
        ),
      ]),
      
      css('.hero-title', [
        css('&').styles(
          fontSize: 1.5.rem,
          fontWeight: .w500,
          color: Color('#888888'),
          lineHeight: 1.4.em,
          maxWidth: 600.px,
        ),
      ]),
      
      css('.hero-description', [
        css('&').styles(
          fontSize: 1.125.rem,
          color: Color('#888888'),
          maxWidth: 600.px,
          padding: .symmetric(vertical: 16.px),
        ),
      ]),
      
      css('.hero-cta', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          padding: .symmetric(vertical: 16.px),
        ),
      ]),
      
      css('.hero-featured', [
        css('&').styles(
          padding: .symmetric(vertical: 10.px),
        ),
      ]),
      
      css('.featured-logos', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          padding: .symmetric(vertical: 10.px),
          opacity: 0.4,
        ),
      ]),
      
      css('.featured-logo', [
        css('&').styles(
          fontSize: 0.875.rem,
          fontWeight: .w500,
          color: Color('#888888'),
          padding: .symmetric(horizontal: 16.px),
        ),
      ]),
      
      css('.hero-social', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          padding: .symmetric(vertical: 10.px),
          maxWidth: 400.px,
        ),
      ]),
      
      css('.social-link', [
        css('&').styles(
          color: Color('#888888'),
          fontSize: 0.875.rem,
          fontWeight: .w500,
          padding: .symmetric(horizontal: 16.px),
        ),
        css('&:hover').styles(
          color: Color('#FFFFFF'),
        ),
      ]),
    ]),
  ];
}