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
    final principles = [
      _Principle(
        quote:
            'I treat every project like my own product — from architecture trade-offs down to the last pixel and the final deployment.',
        title: 'Own the outcome',
        tag: 'Working principle',
        glyph: '01',
      ),
      _Principle(
        quote:
            'I reach for boring, reliable technology and clean boundaries over cleverness. Simple systems are the ones that actually ship and scale.',
        title: 'Simple over clever',
        tag: 'Working principle',
        glyph: '02',
      ),
      _Principle(
        quote:
            'Clear updates, early risk calls, and decisions you can follow. I believe honest communication is half the craft.',
        title: 'A teammate, not a vendor',
        tag: 'Working principle',
        glyph: '03',
      ),
    ];

    return section(classes: 'testimonials section', id: 'testimonials', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Principles')]),
          h2(classes: 'section-title', [Component.text('How I Work')]),
          p(classes: 'section-subtitle', [Component.text('A few principles that shape how I build and collaborate')]),
        ]),
        div(classes: 'testimonials-grid', [
          for (final principle in principles) _buildCard(principle),
        ]),
      ]),
    ]);
  }

  Component _buildCard(_Principle principle) {
    return div(classes: 'testimonial-card card reveal', [
      p(classes: 'testimonial-quote', [Component.text(principle.quote)]),
      div(classes: 'testimonial-author', [
        div(classes: 'author-avatar', [Component.text(principle.glyph)]),
        div(classes: 'author-info', [
          h4(classes: 'author-name', [Component.text(principle.title)]),
          p(classes: 'author-role', [Component.text(principle.tag)]),
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

class _Principle {
  final String quote;
  final String title;
  final String tag;
  final String glyph;

  const _Principle({
    required this.quote,
    required this.title,
    required this.tag,
    required this.glyph,
  });
}