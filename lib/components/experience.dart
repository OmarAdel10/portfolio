import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Experience extends StatelessComponent {
  const Experience({super.key});

  @override
  Component build(BuildContext context) {
    final experiences = [
      _Experience(
        title: 'Senior Lead Software Engineer',
        company: 'Saimon Global Ltd',
        location: 'Dhaka, Bangladesh',
        period: '2019 - 2024',
        description: 'Led a frontend team to design and develop robust B2C and B2B Travel Tech solutions, utilizing React/Next.js for web applications and Flutter SDK for cross-platform mobile apps, with a focus on responsive design, scalability, and enhanced user experience.',
        technologies: ['JavaScript', 'TypeScript', 'Dart', 'React', 'Next.js', 'Flutter'],
        url: 'https://saimonglobal.com',
      ),
      _Experience(
        title: 'Web Developer',
        company: 'influenceTHIS Canada',
        location: 'Remote (Toronto, Canada)',
        period: '2018 - 2019',
        description: 'Developed the UI and UX eco-system for a conference event platform using modular component structures with JS, SCSS, Gulp on Node.',
        technologies: ['JavaScript', 'Gulp', 'SCSS', 'Node.js'],
        url: 'https://influencethis.ca',
      ),
      _Experience(
        title: 'Top Rated Web Developer',
        company: 'Upwork Inc.',
        location: 'Remote',
        period: '2017 - Present',
        description: 'Top-Rated developer on Upwork specializing in Front-end (React, WordPress) technologies with a 100% job success rate and client satisfaction rating (based on 150+ Jobs, 2500+ hours).',
        technologies: ['JavaScript', 'PHP', 'HTML', 'CSS', 'Figma'],
        url: 'https://upwork.com',
      ),
    ];

    return section(classes: 'experience', id: 'experience', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('Experience')]),
          p(classes: 'section-subtitle', [
            text('My professional journey'),
          ]),
        ]),
        
        div(classes: 'experience-timeline', [
          for (final exp in experiences) _buildExperienceCard(exp),
        ]),
      ]),
    ]);
  }

  Component _buildExperienceCard(_Experience exp) {
    return div(classes: 'experience-card', [
      div(classes: 'experience-header', [
        div(classes: 'experience-title-row', [
          div(classes: 'experience-title-group', [
            h3(classes: 'experience-title', [text(exp.title)]),
            p(classes: 'experience-company', [
              text(exp.company),
              text(' · '),
              text(exp.period),
            ]),
          ]),
          a(href: exp.url, classes: 'experience-link', [text(exp.url.replaceAll('https://', ''))]),
        ]),
        p(classes: 'experience-location', [text(exp.location)]),
      ]),
      
      p(classes: 'experience-description', [text(exp.description)]),
      
      div(classes: 'experience-tech', 
        exp.technologies.map((tech) => span(classes: 'tech-tag', [text(tech)])).toList()
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
        backgroundColor: Color('#111111'),
      ),
      
      css('.section-header', [
        css('&').styles(
          textAlign: .center,
          maxWidth: 600.px,
          margin: .zero,
          padding: .symmetric(vertical: 48.px),
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
      
      css('.experience-timeline', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
        ),
      ]),
      
      css('.experience-card', [
        css('&').styles(
          backgroundColor: Color('#1A1A1A'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          padding: .symmetric(vertical: 32.px, horizontal: 32.px),
        ),
        
        css('.experience-header', [
          css('&').styles(
            display: .flex,
            flexDirection: .column,
            padding: .only(bottom: 20.px),
            border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          ),
          
          css('.experience-title-row', [
            css('&').styles(
              display: .flex,
              justifyContent: .spaceBetween,
              flexWrap: .wrap,
            ),
            
            css('.experience-title-group').styles(
              width: 100.percent,
            ),
            
            css('.experience-title').styles(
              fontSize: 1.25.rem,
              fontWeight: .w600,
              color: Color('#FFFFFF'),
              fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
              padding: .only(bottom: 4.px),
            ),
            
            css('.experience-company').styles(
              fontSize: 1.rem,
              color: Color('#888888'),
            ),
            
            css('.experience-link').styles(
              fontSize: 0.875.rem,
              color: Color('#888888'),
            ),
            
            css('.experience-link:hover').styles(
              color: Color('#FFFFFF'),
            ),
          ]),
          
          css('.experience-location').styles(
            fontSize: 0.875.rem,
            color: Color('#666666'),
          ),
        ]),
        
        css('.experience-description').styles(
          fontSize: 1.rem,
          color: Color('#CCCCCC'),
          padding: .symmetric(vertical: 20.px),
        ),
        
        css('.experience-tech', [
          css('&').styles(
            display: .flex,
            flexWrap: .wrap,
          ),
        ]),
        
        css('.tech-tag', [
          css('&').styles(
            fontSize: 0.75.rem,
            fontWeight: .w500,
            color: Color('#CCCCCC'),
            backgroundColor: Color('#FFFFFF10'),
            border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
            padding: .symmetric(vertical: 4.px, horizontal: 12.px),
            radius: .all(.circular(4.px)),
          ),
        ]),
      ]),
    ]),
  ];
}

class _Experience {
  final String title;
  final String company;
  final String location;
  final String period;
  final String description;
  final List<String> technologies;
  final String url;
  
  const _Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.period,
    required this.description,
    required this.technologies,
    required this.url,
  });
}