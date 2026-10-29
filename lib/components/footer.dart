import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// The closing block. It follows the centred register like the contact
/// section above it: the mascot signs off, and the page ends on a legal
/// line instead of a wall of link columns.
class Footer extends StatefulComponent {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        backgroundColor: cCanvas,
        border: Border.only(
          top: BorderSide.solid(color: cHairline, width: 1.px),
        ),
        padding: Padding.fromLTRB(Unit.zero, 64.px, Unit.zero, 40.px),
        margin: .only(top: 24.px),
      ),
      css('.footer-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
        gap: Gap.all(16.px),
        maxWidth: 720.px,
        margin: .only(left: .auto, right: .auto),
      ),

      // The mascot signs the page off — the one playful moment in the
      // closing block.
      css('.footer-mascot').styles(
        width: 64.px,
        height: 64.px,
        radius: .all(.circular(radiusFull.px)),
        backgroundColor: cCard,
        border: Border.all(color: cHairline, width: 1.px),
        overflow: .hidden,
        margin: .only(bottom: 4.px),
        raw: const {
          'transform': 'rotate(-6deg)',
          'animation': 'mascotWiggle 6.5s ease-in-out infinite',
        },
      ),
      css('.footer-mascot img').styles(
        raw: const {
          'width': '100%',
          'height': '100%',
          'border-radius': '50%',
          'display': 'block',
        },
      ),

      css('.footer-logo').styles(
        fontSize: fontTitleMd.px,
        fontWeight: FontWeight.w700,
        letterSpacing: (-0.3).px,
        color: cInk,
        textDecoration: .none,
      ),
      css('.footer-logo:hover').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {
          'text-decoration': 'underline',
          'text-decoration-color': 'var(--primary)',
          'text-underline-offset': '4px',
        },
      ),
      css('.footer-tagline').styles(
        fontSize: fontBodySm.px,
        color: cMute,
        lineHeight: 1.6.em,
        maxWidth: 380.px,
      ),

      css('.footer-nav').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
        gap: Gap.all(24.px),
        margin: .only(top: 8.px),
      ),
      css('.footer-nav-link').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        textDecoration: .none,
        raw: const {'transition': 'color var(--dur-micro) var(--ease-out)'},
      ),
      css('.footer-nav-link:hover').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {
          'text-decoration': 'underline',
          'text-decoration-color': 'var(--primary)',
          'text-underline-offset': '4px',
        },
      ),

      css('.footer-controls').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(16.px),
        margin: .only(top: 8.px),
      ),
      css('.footer-made').styles(
        fontFamily: fMonoStack,
        fontSize: fontMicro.px,
        color: cMute,
      ),

      css('.footer-bottom').styles(
        width: 100.percent,
        margin: .only(top: 32.px),
        padding: .only(top: 24.px),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        fontSize: fontMicro.px,
        color: cMute,
      ),
    ]),
    // The header hides its nav on phones, so the footer's mono row only
    // appears there: the page never shows the same navigation twice.
    css.media(MediaQuery.all(minWidth: 520.px), [
      css('.site-footer .footer-nav').styles(display: Display.none),
    ]),

    // The mascot assistant is fixed to the bottom-right corner. On a phone
    // the centred legal line runs underneath it, so the footer reserves the
    // FAB's band (120px tall, 24px off the corner) before its last line.
    css.media(MediaQuery.all(maxWidth: 519.px), [
      css('.site-footer').styles(
        padding: Padding.fromLTRB(Unit.zero, 64.px, Unit.zero, 160.px),
      ),
    ]),
  ];
}

class _FooterState extends State<Footer> {
  final String _year = '${DateTime.now().year}';

  // The header nav is hidden on phones, so the footer carries the same four
  // anchors as a quiet mono row — that keeps the page navigable on small
  // screens without repeating the header's chrome on desktop.
  static const _navItems = <({String id, String label})>[
    (id: 'projects-work', label: 'Work'),
    (id: 'expertise', label: 'Expertise'),
    (id: 'experience', label: 'Education'),
    (id: 'contact', label: 'Contact'),
  ];

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      div(classes: 'container', [
        div(classes: 'footer-inner', [
          div(classes: 'footer-mascot', [
            img(src: '/images/avatar.png', alt: ''),
          ]),
          a(href: '#top', classes: 'footer-logo', [Component.text('Omar Adel')]),
          p(classes: 'footer-tagline', [
            Component.text('Software engineer working across mobile, backend and cloud.'),
          ]),
          nav(
            classes: 'footer-nav',
            attributes: {'aria-label': 'Footer'},
            [
              for (final item in _navItems)
                a(href: '#${item.id}', classes: 'footer-nav-link', [Component.text(item.label)]),
            ],
          ),
          div(classes: 'footer-controls', [
            span(classes: 'footer-made', [Component.text('Built with Jaspr')]),
          ]),
          div(classes: 'footer-bottom', [
            span(classes: 'footer-copy', [
              Component.text('© $_year Omar Adel. All rights reserved.'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }
}
