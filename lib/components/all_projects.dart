import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../data/projects.dart';
import '../models/project.dart';
import '../components/project_card.dart';

class AllProjects extends StatefulComponent {
  const AllProjects({super.key});

  @override
  State<AllProjects> createState() => _AllProjectsState();

  @css
  static List<StyleRule> get styles => [
    css('.all-projects', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
        backgroundColor: Color('#111111'),
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
      
      css('.projects-filters', [
        css('&').styles(
          display: Display.flex,
          flexWrap: FlexWrap.wrap,
          justifyContent: JustifyContent.center,
          padding: .only(bottom: 48.px),
        ),
        
        css('.filter-group').styles(
          display: Display.flex,
          flexDirection: FlexDirection.column,
          minWidth: 200.px,
        ),
        
        css('.filter-label').styles(
          fontSize: 0.875.rem,
          fontWeight: FontWeight.w500,
          color: Color('#CCCCCC'),
          margin: .only(bottom: 8.px),
        ),
        
        css('.filter-select, .filter-input').styles(
          padding: .symmetric(vertical: 10.px, horizontal: 16.px),
          backgroundColor: Color('#1A1A1A'),
          border: Border.all(color: Color('#333333'), width: 1.px),
          radius: .all(.circular(8.px)),
          color: Color('#FFFFFF'),
          fontSize: 0.9375.rem,
          fontFamily: FontFamily('Inter'),
        ),
        
        css('.filter-select:focus, .filter-input:focus').styles(
          border: Border.all(color: Color('#0175C2'), width: 1.px),
        ),
      ]),
      
      css('.projects-grid').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.center,
      ),
      
      css('.empty-state').styles(
        textAlign: TextAlign.center,
        padding: .symmetric(vertical: 64.px),
        color: Color('#888888'),
        fontSize: 1.125.rem,
      ),
    ]),
  ];
}

class _AllProjectsState extends State<AllProjects> {
  String _selectedLanguage = 'All';
  String _searchQuery = '';

  List<Project> get _filteredProjects {
    var projects = additionalProjects;
    
    if (_selectedLanguage != 'All') {
      projects = projects.where((p) => p.language == _selectedLanguage).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      projects = projects.where((p) => 
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query) ||
        p.topics.any((t) => t.toLowerCase().contains(query))
      ).toList();
    }
    
    return projects;
  }

  List<String> get _languages {
    final langs = <String>{'All'};
    for (final p in additionalProjects) {
      langs.add(p.language);
    }
    return langs.toList()..sort();
  }

  @override
  Component build(BuildContext context) {
    return section(classes: 'all-projects', id: 'all-projects', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('All Projects')]),
          p(classes: 'section-subtitle', [
            text('Complete portfolio of projects'),
          ]),
        ]),
        
        // Filters
        div(classes: 'projects-filters', [
          // Language filter
          div(classes: 'filter-group', [
            label(classes: 'filter-label', [text('Language')]),
            select(
              classes: 'filter-select',
              value: _selectedLanguage,
              onChange: (value) => setState(() => _selectedLanguage = value as String),
              [
                for (final lang in _languages)
                  option(value: lang, [text(lang)]),
              ],
            ),
          ]),
          
          // Search
          div(classes: 'filter-group', [
            label(classes: 'filter-label', [text('Search')]),
            input(
              classes: 'filter-input',
              type: InputType.text,
              attributes: {'placeholder': 'Search projects...'},
              onInput: (value) => setState(() => _searchQuery = value as String),
            ),
          ]),
        ]),
        
        // Projects grid
        div(classes: 'projects-grid', [
          for (final project in _filteredProjects)
            ProjectCard(project: project, isFeatured: false),
        ]),
        
        // Empty state
        if (_filteredProjects.isEmpty)
          div(classes: 'empty-state', [
            text('No projects found matching your criteria.'),
          ]),
      ]),
    ]);
  }
}