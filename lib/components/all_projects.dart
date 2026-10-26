import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../data/projects.dart';
import '../models/project.dart';
import 'project_card.dart';

class AllProjects extends StatefulComponent {
  const AllProjects({super.key});

  @override
  State<AllProjects> createState() => _AllProjectsState();

  @css
  static List<StyleRule> get styles => [
    css('.all-projects', [
      css('.projects-toolbar').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.start,
        gap: Gap.all(16.px),
        margin: .only(bottom: 32.px),
      ),
      css('.project-pills').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
      ),
      // Amber marks exactly one thing: the active filter chip.
      css('.all-projects .pill').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
      ),
      css('.all-projects .pill-active').styles(
        backgroundColor: cPrimary,
        color: cOnPrimary,
      ),
      css('.all-projects .pill-active:hover').styles(
        backgroundColor: cPrimaryPressed,
        color: cOnPrimary,
      ),
      css('.projects-grid').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
          ]),
        ),
        gap: Gap.all(20.px),
      ),
      css('.empty-state').styles(
        textAlign: TextAlign.center,
        color: cMute,
        fontSize: fontBody.px,
        padding: Padding.all(48.px),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 1000.px), [
      css('.all-projects .projects-grid').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
          ]),
        ),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.all-projects .projects-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
    ]),
  ];
}

class _AllProjectsState extends State<AllProjects> {
  String _category = 'All';

  List<Project> get _filtered {
    if (_category == 'All') return allProjects;
    return allProjects.where((proj) => proj.category == _category).toList();
  }

  @override
  Component build(BuildContext context) {
    final filtered = _filtered;
    return section(classes: 'all-projects section', id: 'projects-work', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [
            Component.text('${filtered.length} ${filtered.length == 1 ? 'project' : 'projects'}'),
          ]),
          h2(classes: 'section-title', [Component.text('My Work')]),
          p(classes: 'section-subtitle', [
            Component.text('Selected projects across app development, backend services, and AI tooling.'),
          ]),
        ]),

        div(classes: 'projects-toolbar', [
          div(classes: 'project-pills', [
            for (final cat in projectCategories)
              button(
                classes: 'pill ${_category == cat ? 'pill-active' : ''}',
                attributes: {'aria-pressed': _category == cat ? 'true' : 'false'},
                onClick: () => setState(() => _category = cat),
                [Component.text(cat)],
              ),
          ]),
        ]),

        div(classes: 'projects-grid', [
          for (final project in filtered) ProjectCard(project: project),
        ]),

        if (filtered.isEmpty) div(classes: 'empty-state', [Component.text('No projects in this category yet.')]),
      ]),
    ]);
  }
}
