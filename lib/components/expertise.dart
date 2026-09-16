import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Expertise extends StatelessComponent {
  const Expertise({super.key});

  @override
  Component build(BuildContext context) {
    final skills = [
      _Skill(
        title: 'Software Development',
        description: 'Experienced in both functional and OOP: Dart, Python, Java, JavaScript, TypeScript.',
        icon: '💻',
      ),
      _Skill(
        title: 'Frontend Development',
        description: 'Passionate about UI/UX. Over 5 years of experience in HTML, CSS, JS, React and NextJS frameworks.',
        icon: '🎨',
      ),
      _Skill(
        title: 'Mobile Development',
        description: 'Cross-platform mobile apps using Flutter SDK with focus on performance and native feel.',
        icon: '📱',
      ),
      _Skill(
        title: 'DevOps & Cloud',
        description: 'CI/CD pipelines, containerization, cloud deployment on AWS/GCP, monitoring and scaling.',
        icon: '☁️',
      ),
    ];

    return section(classes: 'expertise', id: 'expertise', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('My Expertise')]),
          p(classes: 'section-subtitle', [
            text('Technologies and areas I specialize in'),
          ]),
        ]),
        div(classes: 'skills-grid', skills.map((s) => _buildSkillCard(s)).toList()),
      ]),
    ]);
  }

  Component _buildSkillCard(_Skill skill) {
    return div(classes: 'skill-card', [
      div(classes: 'skill-icon', [text(skill.icon)]),
      h3(classes: 'skill-title', [text(skill.title)]),
      p(classes: 'skill-description', [text(skill.description)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.expertise', [
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
      
      css('.skills-grid', [
        css('&').styles(
          display: .flex,
          flexWrap: .wrap,
          justifyContent: .center,
        ),
      ]),
      
      css('.skill-card', [
        css('&').styles(
          padding: .symmetric(vertical: 32.px, horizontal: 32.px),
          backgroundColor: Color('#1A1A1A'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          width: 300.px,
        ),
        
        css('.skill-icon').styles(
          fontSize: 2.5.rem,
          padding: .symmetric(vertical: 20.px),
          display: .block,
        ),
        
        css('.skill-title').styles(
          fontSize: 1.25.rem,
          fontWeight: .w600,
          color: Color('#FFFFFF'),
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
          padding: .only(bottom: 12.px),
        ),
        
        css('.skill-description').styles(
          fontSize: 1.rem,
          lineHeight: 1.6.em,
          color: Color('#888888'),
        ),
      ]),
    ]),
  ];
}

class _Skill {
  final String title;
  final String description;
  final String icon;
  
  const _Skill({
    required this.title,
    required this.description,
    required this.icon,
  });
}