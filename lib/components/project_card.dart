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
        span(classes: 'project-language-badge', style: 'background-color: ${_getLanguageColor(project.language)}', [
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
          a(href: project.url, target: '_blank', rel: 'noopener noreferrer', classes: 'btn btn-secondary', [
            text('View on GitHub'),
            span(classes: 'link-icon', [text('→')]),
          ]),
          if (project.homepage != null)
            a(href: project.homepage!, target: '_blank', rel: 'noopener noreferrer', classes: 'btn btn-primary', [
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
        borderRadius: 16.px,
        overflow: Overflow.hidden,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        transition: 'transform 300ms ease, box-shadow 300ms ease, border-color 300ms ease',
      ),
      css('&:hover').styles(
        transform: 'translateY(-8px)',
        boxShadow: '0 24px 48px rgba(0,0,0,0.4)',
        borderColor: Color('#FFFFFF33'),
      ),
      css('&.featured').styles(
        // Featured cards get slight emphasis
      ),
    ]),
    
    css('.project-thumbnail', [
      css('&').styles(
        position: Position.relative,
        aspectRatio: AspectRatio.auto,
        minHeight: 200.px,
        backgroundColor: Color('#111111'),
        overflow: Overflow.hidden,
      ),
    ]),
    
    css('.project-image', [
      css('&').styles(
        width: 100.percent,
        height: 100.percent,
        objectFit: ObjectFit.cover,
        transition: 'transform 500ms ease',
      ),
      css('&:hover').styles(
        transform: 'scale(1.05)',
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
        position: Position.absolute,
        top: 12.px,
        right: 12.px,
        padding: Padding.symmetric(vertical: 4.px, horizontal: 10.px),
        borderRadius: 9999.px,
        fontSize: 0.7.rem,
        fontWeight: FontWeight.w600,
        color: Color('#FFFFFF'),
        textTransform: TextTransform.uppercase,
        letterSpacing: 0.05.em,
      ),
    ]),
    
    css('.project-content', [
      css('&').styles(
        padding: 24.px,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        flex: '1',
        gap: 16.px,
      ),
    ]),
    
    css('.project-title', [
      css('&').styles(
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w600,
        color: Color('#FFFFFF'),
        fontFamily: FontFamily('Space Grotesk').withFallback(FontFamilies.sansSerif),
        margin: Margin.zero,
      ),
    ]),
    
    css('.project-description', [
      css('&').styles(
        fontSize: 0.9375.rem,
        lineHeight: 1.6,
        color: Color('#CCCCCC'),
        margin: Margin.zero,
      ),
    ]),
    
    css('.project-tags', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: 8.px,
      ),
    ]),
    
    css('.project-tag', [
      css('&').styles(
        fontSize: 0.7.rem,
        fontWeight: FontWeight.w500,
        color: Color('#CCCCCC'),
        backgroundColor: Color('#FFFFFF10'),
        border: Border.all(color: Color('#333333'), width: 1.px),
        padding: Padding.symmetric(vertical: 4.px, horizontal: 10.px),
        borderRadius: 4.px,
        textTransform: TextTransform.capitalize,
      ),
    ]),
    
    css('.project-links', [
      css('&').styles(
        display: Display.flex,
        gap: 12.px,
        flexWrap: FlexWrap.wrap,
        padding: Padding.only(top: 8.px),
      ),
    ]),
    
    css('.link-icon', [
      css('&').styles(
        transition: 'transform 200ms ease',
        marginLeft: 4.px,
      ),
    ]),
    
    css('.btn:hover .link-icon', [
      css('&').styles(
        transform: 'translateX(4px)',
      ),
    ]),
  ];
}