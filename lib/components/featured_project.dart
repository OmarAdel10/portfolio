import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/projects.dart';

class FeaturedProject extends StatelessComponent {
  const FeaturedProject({super.key});

  @override
  Component build(BuildContext context) {
    final project = featuredProject ?? (allProjects.isNotEmpty ? allProjects.first : null);
    if (project == null) {
      // No projects yet; render nothing.
      return div([]);
    }

    return section(classes: 'featured-project section', id: 'projects', [
      div(classes: 'container', [
        div(classes: 'section-head', [
          span(classes: 'eyebrow', [Component.text('Project')]),
          h2(classes: 'section-title', [Component.text('Featured Project')]),
          p(classes: 'section-subtitle', [Component.text('A selection of my recent work')]),
        ]),

        div(classes: 'fp-card card', [
          div(classes: 'fp-media', [
            span(classes: 'fp-media-badge', [Component.text(project.language)]),
            div(classes: 'fp-media-glyph', [Component.text('🖼️')]),
          ]),
          div(classes: 'fp-body', [
            span(classes: 'tag', [Component.text('Featured')]),
            h3(classes: 'fp-title', [Component.text(project.name)]),
            p(classes: 'fp-desc', [Component.text(project.description)]),
            div(classes: 'fp-tags', [
              for (final topic in project.topics)
                span(classes: 'tag tag-outline', [Component.text(topic)]),
            ]),
            div(classes: 'fp-links', [
              a(href: project.url, classes: 'btn btn-secondary', [Component.text('View on GitHub →')]),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured-project', [
      css('.fp-card').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(columns: GridTracks([
          GridTrack(TrackSize.fr(2)),
          GridTrack(TrackSize.fr(3)),
        ])),
        overflow: Overflow.hidden,
      ),

      css('.fp-media').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        flexDirection: FlexDirection.column,
        gap: Gap.all(12.px),
        minHeight: 300.px,
        backgroundColor: cSoft,
        border: Border.only(right: BorderSide.solid(color: cHairlineSoft, width: 1.px)),
        padding: Padding.all(24.px),
        position: Position.relative(),
      ),
      css('.fp-media-badge').styles(
        position: Position.absolute(top: 16.px, left: 16.px),
        fontSize: 12.px,
        fontWeight: FontWeight.w600,
        textTransform: .upperCase,
        letterSpacing: 0.05.em,
        color: cMute,
        backgroundColor: cCard,
        border: Border.all(color: cHairline, width: 1.px),
        padding: .symmetric(vertical: 4.px, horizontal: 10.px),
        radius: .all(.circular(radiusFull.px)),
      ),
      css('.fp-media-glyph').styles(
        fontSize: 64.px,
      ),

      css('.fp-body').styles(
        padding: Padding.all(32.px),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(14.px),
      ),
      css('.fp-title').styles(
        fontSize: 28.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-0.5).px,
        color: cInk,
      ),
      css('.fp-desc').styles(
        fontSize: 15.5.px,
        lineHeight: 1.65.em,
        color: cBody,
      ),
      css('.fp-tags').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
      ),
      css('.fp-links').styles(
        padding: .only(top: 10.px),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 860.px), [
      css('.featured-project .fp-card').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.featured-project .fp-media').styles(
        border: Border.only(bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px)),
        minHeight: 200.px,
      ),
      css('.featured-project .fp-body').styles(padding: Padding.all(24.px)),
    ]),
  ];
}