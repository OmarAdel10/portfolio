import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// TODO(owner): Replace the sample testimonials below with real ones from actual
// clients or colleagues before deploying. Quotes are neutral placeholders so no
// real person is misquoted as endorsing work.
class Testimonials extends StatelessComponent {
  const Testimonials({super.key});

  @override
  Component build(BuildContext context) {
    final testimonials = [
      _Testimonial(
        quote:
            'Worked with Omar on a cross-platform product and was impressed by the speed and attention to detail. Clear communicator and a reliable engineer.',
        author: 'Client Name',
        role: 'Founder, Company',
        avatar: 'CN',
      ),
      _Testimonial(
        quote:
            'Omar brings strong technical judgment and a genuine care for the user experience. A great collaborator on every project we shipped together.',
        author: 'Colleague Name',
        role: 'Product Manager, Agency',
        avatar: 'CL',
      ),
      _Testimonial(
        quote:
            'Responsive, organized, and thoughtful under pressure. Would happily work with Omar again on a future engagement.',
        author: 'Client Name',
        role: 'CTO, Startup',
        avatar: 'CT',
      ),
    ];

    return section(classes: 'testimonials section', id: 'testimonials', [
      div(classes: 'container', [
        div(classes: 'section-head', [
          span(classes: 'eyebrow', [Component.text('Testimonials')]),
          h2(classes: 'section-title', [Component.text('What People Say')]),
          p(classes: 'section-subtitle', [Component.text('Feedback from clients and colleagues')]),
        ]),
        div(classes: 'testimonials-grid', [
          for (final t in testimonials) _buildCard(t),
        ]),
      ]),
    ]);
  }

  Component _buildCard(_Testimonial t) {
    return div(classes: 'testimonial-card card', [
      div(classes: 'quote-mark', [Component.text('“')]),
      p(classes: 'testimonial-quote', [Component.text(t.quote)]),
      div(classes: 'testimonial-author', [
        div(classes: 'author-avatar', [Component.text(t.avatar)]),
        div(classes: 'author-info', [
          h4(classes: 'author-name', [Component.text(t.author)]),
          p(classes: 'author-role', [Component.text(t.role)]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.testimonials', [
      css('.testimonials-grid').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(columns: GridTracks([
          GridTrack(TrackSize.fr(1)),
          GridTrack(TrackSize.fr(1)),
          GridTrack(TrackSize.fr(1)),
        ])),
        gap: Gap.all(20.px),
      ),
      css('.testimonial-card').styles(
        padding: Padding.all(28.px),
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      css('.quote-mark').styles(
        fontSize: 44.px,
        lineHeight: 1.em,
        color: cPrimary,
        margin: .only(bottom: 10.px),
      ),
      css('.testimonial-quote').styles(
        fontSize: 15.5.px,
        lineHeight: 1.65.em,
        color: cBody,
        margin: .only(bottom: 22.px),
        flex: Flex.grow(1),
      ),
      css('.testimonial-author').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(14.px),
        padding: .only(top: 18.px),
        border: Border.only(top: BorderSide.solid(color: cHairlineSoft, width: 1.px)),
      ),
      css('.author-avatar').styles(
        width: 46.px,
        height: 46.px,
        radius: .all(.circular(radiusFull.px)),
        backgroundColor: cSoft,
        border: Border.all(color: cHairline, width: 1.px),
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        fontSize: 14.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        flex: Flex(shrink: 0),
      ),
      css('.author-name').styles(
        fontSize: 16.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 2.px),
      ),
      css('.author-role').styles(
        fontSize: 13.5.px,
        color: cMute,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 900.px), [
      css('.testimonials .testimonials-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
    ]),
  ];
}

class _Testimonial {
  final String quote;
  final String author;
  final String role;
  final String avatar;

  const _Testimonial({
    required this.quote,
    required this.author,
    required this.role,
    required this.avatar,
  });
}