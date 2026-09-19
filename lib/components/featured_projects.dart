import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/projects.dart';
import '../components/project_card.dart';

class FeaturedProjects extends StatelessComponent {
  const FeaturedProjects({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'featured-projects', id: 'projects', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('Featured Projects')]),
          p(classes: 'section-subtitle', [
            text('A selection of my recent work'),
          ]),
        ]),
        div(classes: 'projects-grid', [
          for (final project in mainProjects)
            ProjectCard(project: project, isFeatured: true),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured-projects', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
      ),
      
      css('.section-header').styles(
        textAlign: TextAlign.center,
        maxWidth: 600.px,
        margin: .symmetric(horizontal: 0.px),
        padding: .only(bottom: 48.px),
      ),
      
      css('.section-title').styles(
        fontSize: 2.5.rem,
        fontWeight: FontWeight.w600,
        color: Color('#FFFFFF'),
        fontFamily: FontFamily('Space Grotesk'),
      ),
      
      css('.section-subtitle').styles(
        fontSize: 1.125.rem,
        color: Color('#888888'),
        padding: .only(top: 16.px),
      ),
      
      css('.projects-grid').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
      ),
    ]),
  ];
}