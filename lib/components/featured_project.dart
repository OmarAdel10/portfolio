import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class FeaturedProject extends StatelessComponent {
  const FeaturedProject({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'featured-project', id: 'projects', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('Featured Project')]),
          p(classes: 'section-subtitle', [
            text('A selection of my recent work'),
          ]),
        ]),
        
        div(classes: 'project-card', [
          div(classes: 'project-content', [
            div(classes: 'project-meta', [
              span(classes: 'project-tag', [text('Full Stack')]),
              span(classes: 'project-year', [text('2024')]),
            ]),
            h3(classes: 'project-title', [text('Tryotel App')]),
            p(classes: 'project-description', [
              text('A comprehensive travel and event booking platform with telemedicine integration. '),
              text('Built with React, Next.js, and Flutter for cross-platform mobile apps.'),
            ]),
            div(classes: 'project-tech', [
              _buildTechTag('React'),
              _buildTechTag('Next.js'),
              _buildTechTag('Flutter'),
              _buildTechTag('TypeScript'),
              _buildTechTag('Tailwind'),
              _buildTechTag('PostgreSQL'),
            ]),
            a(href: '#', classes: 'btn btn-primary project-link', [
              text('View Project'),
              span(classes: 'arrow', [text('→')]),
            ]),
          ]),
          
          div(classes: 'project-media', [
            div(classes: 'media-placeholder', [
              text('Project Preview'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _buildTechTag(String tech) {
    return span(classes: 'tech-tag', [text(tech)]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.featured-project', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
      ),
      
      css('.section-header', [
        css('&').styles(
          textAlign: .center,
          maxWidth: 600.px,
          margin: .zero,
          padding: .only(bottom: 48.px),
        ),
        
        css('.section-title').styles(
          fontSize: 2.5.rem,
          fontWeight: .w600,
          color: Color('#FFFFFF'),
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
        ),
        
        css('.section-subtitle').styles(
          fontSize: 1.125.rem,
          color: Color('#888888'),
        ),
      ]),
      
      css('.project-card', [
        css('&').styles(
          backgroundColor: Color('#111111'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          padding: .symmetric(vertical: 48.px, horizontal: 48.px),
        ),
        
        css('.project-content').styles(
          maxWidth: 600.px,
        ),
        
        css('.project-meta').styles(
          display: .flex,
          padding: .only(bottom: 16.px),
        ),
        
        css('.project-tag').styles(
          fontSize: 0.75.rem,
          fontWeight: .w500,
          color: Color('#FFFFFF'),
          backgroundColor: Color('#FFFFFF15'),
          padding: .symmetric(vertical: 4.px, horizontal: 12.px),
          radius: .all(.circular(9999.px)),
        ),
        
        css('.project-year').styles(
          fontSize: 0.875.rem,
          color: Color('#888888'),
        ),
        
        css('.project-title').styles(
          fontSize: 2.rem,
          fontWeight: .w600,
          color: Color('#FFFFFF'),
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
          padding: .only(bottom: 16.px),
        ),
        
        css('.project-description').styles(
          fontSize: 1.125.rem,
          color: Color('#888888'),
          padding: .only(bottom: 24.px),
          maxWidth: 500.px,
        ),
        
        css('.project-tech').styles(
          display: .flex,
          flexWrap: .wrap,
          padding: .only(bottom: 24.px),
        ),
        
        css('.tech-tag').styles(
          fontSize: 0.75.rem,
          fontWeight: .w500,
          color: Color('#CCCCCC'),
          backgroundColor: Color('#FFFFFF10'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          padding: .symmetric(vertical: 4.px, horizontal: 12.px),
          radius: .all(.circular(4.px)),
        ),
        
        css('.project-link').styles(
          display: .inlineFlex,
          alignItems: .center,
        ),
        
        css('.project-media').styles(
          maxWidth: 600.px,
        ),
        
        css('.media-placeholder', [
          css('&').styles(
            backgroundColor: Color('#1A1A1A'),
            border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
            radius: .all(.circular(12.px)),
            display: .flex,
            alignItems: .center,
            justifyContent: .center,
            color: Color('#555555'),
            fontSize: 1.25.rem,
            minHeight: 300.px,
          ),
        ]),
      ]),
    ]),
  ];
}