import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'cupertino_icon.dart';
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
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Selected work')]),
          h2(classes: 'section-title', [Component.text('Featured Project')]),
          p(classes: 'section-subtitle', [
            Component.text(
              'One project in detail: the app, the services behind it, and where the two meet.',
            ),
          ]),
        ]),

        div(
          classes: 'fp-card card reveal',
          attributes: {'data-stagger-index': '0'},
          [
            div(classes: 'fp-media', [
              if (project.logoUrl case final logo?)
                div(classes: 'fp-logo-wrap', [
                  img(src: logo, alt: project.name, classes: 'fp-logo'),
                ])
              else
                div(classes: 'fp-media-glyph', [
                  CupertinoIcon(
                    icon: CupertinoIconName.photoFill,
                    color: CupertinoIconColor.primary,
                    size: CupertinoIconSize.xl,
                  ),
                ]),
            ]),
            div(classes: 'fp-body', [
              h3(classes: 'fp-title', [Component.text(project.name.replaceAll(' · ', ' '))]),
              p(classes: 'fp-desc', [Component.text(project.description)]),
              p(classes: 'fp-stack', [Component.text(project.stackLabel)]),
              div(classes: 'fp-links', [
                a(href: project.url, classes: 'fp-github-link', target: Target.blank, [
                  Component.text('GitHub'),
                ]),
              ]),
            ]),
          ],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured-project', [
      css('.fp-card').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(2)),
            GridTrack(TrackSize.fr(3)),
          ]),
        ),
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
        border: Border.only(
          right: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        padding: Padding.all(24.px),
      ),
      css('.fp-media-glyph').styles(
        fontSize: 64.px,
      ),
      css('.fp-logo-wrap').styles(
        width: 168.px,
        height: 168.px,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        padding: Padding.all(24.px),
        backgroundColor: Colors.white,
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusMd.px)),
      ),
      css('.fp-logo').styles(
        raw: const {
          'width': '100%',
          'height': '100%',
          'object-fit': 'contain',
          'object-position': 'center',
        },
      ),

      css('.fp-body').styles(
        padding: Padding.all(32.px),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(16.px),
      ),
      css('.fp-title').styles(
        fontSize: fontTitleLg.px,
        fontWeight: FontWeight.w800,
        letterSpacing: (-0.5).px,
        color: cInk,
      ),
      css('.fp-desc').styles(
        fontSize: fontBodySm.px,
        lineHeight: 1.6.em,
        color: cBody,
      ),
      css('.fp-stack').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
      ),
      css('.fp-links').styles(
        padding: .only(top: 12.px),
      ),
      css('.fp-github-link').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        textDecoration: .none,
        padding: .only(bottom: 2.px),
        raw: const {
          'border-bottom': '1px solid var(--hairline)',
          'transition':
              'color var(--dur-micro) var(--ease-out), '
              'border-color var(--dur-micro) var(--ease-out)',
        },
      ),
      css('.fp-github-link:hover').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {'border-bottom-color': 'var(--primary)'},
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 860.px), [
      css('.featured-project .fp-card').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.featured-project .fp-media').styles(
        border: Border.only(
          bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        minHeight: 200.px,
      ),
      css('.featured-project .fp-body').styles(padding: Padding.all(24.px)),
    ]),
  ];
}
