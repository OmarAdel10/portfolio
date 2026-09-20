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
        justifyContent: JustifyContent.spaceBetween,
        gap: Gap.all(16.px),
        margin: .only(bottom: 28.px),
      ),
      css('.project-pills').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
      ),
      css('.search-box').styles(
        position: Position.relative(),
        minWidth: 220.px,
      ),
      css('.search-input').styles(
        width: 100.percent,
        height: 40.px,
        padding: .symmetric(horizontal: 40.px),
        fontSize: 15.px,
        fontFamily: fSansStack,
        color: cInk,
        backgroundColor: cCard,
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusFull.px)),
      ),
      css('.search-input:focus').styles(
        outline: Outline(color: cFocus, style: OutlineStyle.solid, width: OutlineWidth(2.px), offset: 1.px),
        border: Border.all(color: cLinkBlue, width: 1.px),
      ),
      css('.search-icon').styles(
        position: Position.absolute(top: 10.px, left: 14.px),
        fontSize: 14.px,
        color: cMute,
        pointerEvents: PointerEvents.none,
      ),
      css('.projects-grid').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(columns: GridTracks([
          GridTrack(TrackSize.fr(1)),
          GridTrack(TrackSize.fr(1)),
          GridTrack(TrackSize.fr(1)),
        ])),
        gap: Gap.all(20.px),
      ),
      css('.empty-state').styles(
        textAlign: TextAlign.center,
        color: cMute,
        fontSize: 16.px,
        padding: Padding.all(48.px),
      ),
      css('.projects-count').styles(
        fontSize: 14.px,
        color: cMute,
        whiteSpace: .noWrap,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 1000.px), [
      css('.all-projects .projects-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([
          GridTrack(TrackSize.fr(1)),
          GridTrack(TrackSize.fr(1)),
        ])),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 700.px), [
      css('.all-projects .projects-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.all-projects .projects-toolbar').styles(
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.stretch,
      ),
      css('.all-projects .search-box').styles(minWidth: 0.px),
    ]),
  ];
}

class _AllProjectsState extends State<AllProjects> {
  String _category = 'All';
  String _query = '';

  List<Project> get _filtered {
    var projects = allProjects;
    if (_category != 'All') {
      projects = projects.where((proj) => proj.category == _category).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      projects = projects
          .where((proj) =>
              proj.name.toLowerCase().contains(q) ||
              proj.description.toLowerCase().contains(q) ||
              proj.topics.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }
    return projects;
  }

  @override
  Component build(BuildContext context) {
    final filtered = _filtered;
    return section(classes: 'all-projects section', id: 'projects-work', [
      div(classes: 'container', [
        div(classes: 'section-head', [
          span(classes: 'eyebrow', [Component.text('Portfolio')]),
          h2(classes: 'section-title', [Component.text('My Work')]),
          p(classes: 'section-subtitle', [
            Component.text('A selection of projects across mobile, web, and AI. Deployed with Flutter, React, Python, and more.'),
          ]),
        ]),

        div(classes: 'projects-toolbar', [
          div(classes: 'project-pills', [
            for (final cat in projectCategories)
              button(
                classes: 'pill ${_category == cat ? 'pill-active' : ''}',
                onClick: () => setState(() => _category = cat),
                [Component.text(cat)],
              ),
          ]),
          div(classes: 'search-box', [
            span(classes: 'search-icon', [Component.text('🔍')]),
            input(
              classes: 'search-input',
              type: InputType.search,
              attributes: {'placeholder': 'Search projects…'},
              onInput: (value) => setState(() => _query = value as String),
            ),
          ]),
        ]),

        div(classes: 'projects-count', [
          Component.text('${filtered.length} ${filtered.length == 1 ? 'project' : 'projects'}'),
        ]),

        div(classes: 'projects-grid', [
          for (final project in filtered)
            ProjectCard(project: project, isFeatured: false),
        ]),

        if (filtered.isEmpty)
          div(classes: 'empty-state', [Component.text('No projects found matching your criteria.')]),
      ]),
    ]);
  }
}