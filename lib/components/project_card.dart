import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../models/project.dart';

class ProjectCard extends StatelessComponent {
  final Project project;
  final bool isFeatured;
  
  const ProjectCard({required this.project, this.isFeatured = false, super.key});
  
  @override
  Component build(BuildContext context) {
    return article(classes: 'project-card ${isFeatured ? 'featured' : ''}', [
      // Thumbnail/preview area
      div(classes: 'project-thumbnail', [
        if (project.thumbnailUrl != null)
          img(src: project.thumbnailUrl!, alt: project.name, classes: 'project-image')
        else
          div(classes: 'project-placeholder', [
            span(classes: 'placeholder-icon', [text(_getLanguageIcon(project.language))]),
          ]),
        // Language badge
        span(classes: 'project-language-badge', [
          text(project.language),
        ]),
      ]),
      
      // Content
      div(classes: 'project-content', [
        h3(classes: 'project-title', [text(project.name)]),
        p(classes: 'project-description', [text(project.description)]),
        
        // Tech tags
        div(classes: 'project-tags', [
          for (final topic in project.topics.take(5))
            span(classes: 'project-tag', [text(topic)]),
        ]),
        
        // Links
        div(classes: 'project-links', [
          a(href: project.url, classes: 'btn btn-secondary', [
            text('View on GitHub'),
            span(classes: 'link-icon', [text('→')]),
          ]),
          if (project.homepage != null)
            a(href: project.homepage!, classes: 'btn btn-primary', [
              text('Live Demo'),
              span(classes: 'link-icon', [text('→')]),
            ]),
        ]),
      ]),
    ]);
  }
  
  String _getLanguageIcon(String language) {
    const icons = {
      'C++': '⚙',
      'HTML': '🌐',
      'Python': '🐍',
      'Dart': '🎯',
      'TypeScript': '📘',
      'Swift': '🍎',
      'JavaScript': '📜',
      'CSS': '🎨',
    };
    return icons[language] ?? '📦';
  }
  
  String _getLanguageColor(String language) {
    const colors = {
      'C++': '#00599C',
      'HTML': '#E34F26',
      'Python': '#3776AB',
      'Dart': '#0175C2',
      'TypeScript': '#3178C6',
      'Swift': '#FA7343',
      'JavaScript': '#F7DF1E',
      'CSS': '#1572B6',
    };
    return colors[language] ?? '#666666';
  }

  @css
  static List<StyleRule> get styles => [
    css('.project-card', [
      css('&').styles(
        backgroundColor: Color('#1A1A1A'),
        border: Border.all(color: Color('#333333'), width: 1.px),
        radius: .all(.circular(16.px)),
        overflow: Overflow.hidden,
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      css('&:hover').styles(
        border: Border.all(color: Color('#FFFFFF33'), width: 1.px),
      ),
      css('&.featured').styles(
        // Featured cards get slight emphasis
      ),
    ]),
    
    css('.project-thumbnail', [
      css('&').styles(
        minHeight: 200.px,
        backgroundColor: Color('#111111'),
        overflow: Overflow.hidden,
      ),
    ]),
    
    css('.project-image', [
      css('&').styles(
        width: 100.percent,
        height: 100.percent,
      ),
    ]),
    
    css('.project-placeholder', [
      css('&').styles(
        width: 100.percent,
        height: 100.percent,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        fontSize: 4.rem,
      ),
    ]),
    
    css('.project-language-badge', [
      css('&').styles(
        padding: .symmetric(vertical: 4.px, horizontal: 10.px),
        radius: .all(.circular(9999.px)),
        fontSize: 0.7.rem,
        fontWeight: FontWeight.w600,
        color: Color('#FFFFFF'),
        letterSpacing: 0.05.em,
        backgroundColor: Color(_getLanguageColorStatic('Dart')),
      ),
    ]),
    
    css('.project-content', [
      css('&').styles(
        padding: .symmetric(vertical: 24.px, horizontal: 24.px),
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
    ]),
    
    css('.project-title', [
      css('&').styles(
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w600,
        color: Color('#FFFFFF'),
        fontFamily: FontFamily('Space Grotesk'),
        margin: .zero,
      ),
    ]),
    
    css('.project-description', [
      css('&').styles(
        fontSize: 0.9375.rem,
        lineHeight: 1.6.em,
        color: Color('#CCCCCC'),
        margin: .zero,
      ),
    ]),
    
    css('.project-tags', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
      ),
    ]),
    
    css('.project-tag', [
      css('&').styles(
        fontSize: 0.7.rem,
        fontWeight: FontWeight.w500,
        color: Color('#CCCCCC'),
        backgroundColor: Color('#FFFFFF10'),
        border: Border.all(color: Color('#333333'), width: 1.px),
        padding: .symmetric(vertical: 4.px, horizontal: 10.px),
        radius: .all(.circular(4.px)),
      ),
      css('&:not(:last-child)').styles(
        margin: .only(right: 8.px, bottom: 8.px),
      ),
    ]),
    
    css('.project-links', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        padding: .only(top: 8.px),
      ),
    ]),
    
    css('.link-icon', [
      css('&').styles(
        margin: .only(left: 4.px),
      ),
    ]),
    
    css('.btn', [
      css('&:hover .link-icon').styles(
        // Animation handled via CSS
      ),
    ]),
  ];
}

// Static version for CSS
String _getLanguageColorStatic(String language) {
  const colors = {
    'C++': '#00599C',
    'HTML': '#E34F26',
    'Python': '#3776AB',
    'Dart': '#0175C2',
    'TypeScript': '#3178C6',
    'Swift': '#FA7343',
    'JavaScript': '#F7DF1E',
    'CSS': '#1572B6',
  };
  return colors[language] ?? '#666666';
}