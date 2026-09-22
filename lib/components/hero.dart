import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', id: 'top', [
      div(classes: 'container hero-inner', [
        div(classes: 'hero-avatar-wrap', [
          div(classes: 'hero-avatar-ring', [
            img(
              src: '/images/avatar.png',
              alt: 'Omar Adel',
              classes: 'hero-avatar',
            ),
          ]),
        ]),
        span(classes: 'eyebrow hero-eyebrow', [Component.text('Hello, I am')]),
        h1(classes: 'hero-name', [Component.text('Omar Adel')]),
        p(classes: 'hero-role', [Component.text('Software Engineer · Flutter, C# .NET & AI Tooling')]),
        p(classes: 'hero-desc', [
          Component.text(
            'I design and build polished cross-platform apps and the systems behind them — Flutter and C# .NET on the front, Python, edge databases, and practical AI integrations under the hood. Focused on clean architecture, great developer experience, and shipping products that feel premium.',
          ),
        ]),
        div(classes: 'hero-cta', [
          a(href: '#projects-work', classes: 'btn btn-primary', [Component.text('View Projects')]),
          a(href: '#contact', classes: 'btn btn-secondary', [Component.text('Get in Touch')]),
          // a(href: githubUrl, classes: 'btn btn-tertiary', [Component.text('GitHub →')]),
        ]),
        div(classes: 'hero-featured', [
          span(classes: 'featured-label', [Component.text('Building with')]),
          // div(classes: 'featured-logos', [
          //   _logo('Flutter'),
          //   _logo('Dart'),
          //   _logo('C# .NET'),
          //   _logo('Python'),
          //   _logo('TypeScript'),
          //   _logo('Firebase'),
          //   _logo('RESTful APIs'),
          // ]),
        ]),
      ]),
    ]);
  }

  // Component _logo(String name) => span(classes: 'featured-logo', [Component.text(name)]);

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        padding: Padding.symmetric(vertical: 45.px),
        display: Display.flex,
        alignItems: AlignItems.center,
        backgroundColor: cCanvas,
      ),

      css('.hero-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
        maxWidth: 840.px,
      ),

      // Animated avatar (Notion-style: rounded, hairline ring, gentle float)
      css('.hero-avatar-wrap').styles(
        margin: .only(bottom: 24.px),
      ),
      css('.hero-avatar-ring').styles(
        width: 148.px,
        height: 148.px,
        position: Position.relative(),
        padding: Padding.all(5.px),
        radius: .all(.circular(radiusFull.px)),
        backgroundColor: cCard,
        border: Border.all(color: cHairline, width: 1.px),
      ),
      css('.hero-avatar-ring').styles(
        raw: const {
          'box-shadow': '0 12px 34px -10px rgba(35, 37, 29, 0.18), 0 2px 10px -4px rgba(35, 37, 29, 0.10)',
          'animation': 'heroAvatarFloat 6.2s ease-in-out infinite',
        },
      ),
      css('.hero-avatar').styles(
        raw: const {
          'width': '100%',
          'height': '100%',
          'border-radius': '50%',
          'display': 'block',
        },
      ),
      css('.hero-avatar-ring::after').styles(
        raw: const {
          'position': 'absolute',
          'inset': '-6px',
          'content': '""',
          'border-radius': '50%',
          'border': '2px solid var(--primary)',
          'opacity': '0.28',
          'transform': 'scale(1)',
          'animation': 'heroRingPulse 3.2s ease-in-out infinite',
        },
      ),

      css('.hero-eyebrow').styles(
        margin: .only(bottom: 14.px),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 680),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 0),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.hero-name').styles(
        fontSize: 60.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-1.2).px,
        lineHeight: 1.05.em,
        color: cInk,
        margin: .only(bottom: 16.px),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 720),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 80),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.hero-role').styles(
        fontSize: 21.px,
        fontWeight: FontWeight.w600,
        color: cCharcoal,
        margin: .only(bottom: 18.px),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 720),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 160),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.hero-desc').styles(
        fontSize: 17.px,
        lineHeight: 1.6.em,
        color: cMute,
        maxWidth: 700.px,
        margin: .only(bottom: 30.px),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 720),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 240),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.hero-cta').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        gap: Gap.all(12.px),
        margin: .only(bottom: 40.px),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 720),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 320),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.hero-featured').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        width: 100.percent,
        padding: .only(top: 24.px),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        animation: Animation(
          name: 'heroRise',
          duration: Duration(milliseconds: 720),
          curve: Curve.easeOut,
          delay: Duration(milliseconds: 400),
          fillMode: AnimationFillMode.backwards,
        ),
      ),

      css('.featured-label').styles(
        fontSize: 13.px,
        fontWeight: FontWeight.w700,
        textTransform: .upperCase,
        letterSpacing: 0.08.em,
        color: cAsh,
        margin: .only(bottom: 0.px),
      ),

      // css('.featured-logos').styles(
      //   display: Display.flex,
      //   flexWrap: FlexWrap.wrap,
      //   justifyContent: JustifyContent.center,
      //   gap: Gap.all(12.px),
      // ),

      // css('.featured-logo').styles(
      //   padding: .symmetric(vertical: 8.px, horizontal: 18.px),
      //   radius: .all(.circular(radiusFull.px)),
      //   border: Border.all(color: cHairline, width: 1.px),
      //   backgroundColor: cCard,
      //   color: cMute,
      //   fontSize: 14.px,
      //   fontWeight: FontWeight.w600,
      //   whiteSpace: .noWrap,
      //   transition: Transition(
      //     'color',
      //     duration: Duration(milliseconds: 180),
      //     curve: Curve.easeOut,
      //   ),
      // ),
      // css('.featured-logo:hover').styles(
      //   color: cInk,
      //   border: Border.all(color: cPrimary, width: 1.px),
      // ),
    ]),

    // Responsive
    css.media(MediaQuery.all(maxWidth: 768.px), [
      css('.hero').styles(padding: .symmetric(vertical: 52.px)),
      css('.hero .hero-name').styles(fontSize: 44.px),
      css('.hero .hero-role').styles(fontSize: 19.px),
      css('.hero .hero-desc').styles(fontSize: 16.px),
      css('.hero .hero-cta').styles(gap: Gap.all(10.px)),
      css('.hero .hero-avatar-ring').styles(width: 124.px, height: 124.px),
    ]),
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.hero .hero-name').styles(fontSize: 36.px),
      css('.hero .hero-role').styles(fontSize: 17.px),
      css('.hero .hero-cta .btn').styles(width: 100.percent, justifyContent: .center),
      css('.hero .featured-logo').styles(
        padding: .symmetric(vertical: 7.px, horizontal: 14.px),
      ),
      css('.hero .hero-avatar-ring').styles(width: 108.px, height: 108.px),
    ]),
  ];
}
