import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class Expertise extends StatelessComponent {
  const Expertise({super.key});

  @override
  Component build(BuildContext context) {
    final skills = [
      _Skill(
        title: 'Software Development',
        description:
            'Experienced in both functional and object-oriented programming: Dart, Python, C++, JavaScript and TypeScript.',
        icon: '💻',
      ),
      _Skill(
        title: 'Front-end & Web Development',
        description:
            'Passionate about UI/UX. Building responsive, accessible interfaces with HTML, CSS, JavaScript and modern web frameworks.',
        icon: '🎨',
      ),
      _Skill(
        title: 'Flutter & Mobile Development',
        description:
            'Skilled in building cross-platform mobile apps for Android and iOS with the Flutter framework and Dart.',
        icon: '📱',
      ),
    ];

    return section(classes: 'expertise section', id: 'expertise', [
      div(classes: 'container', [
        div(classes: 'section-head', [
          span(classes: 'eyebrow', [Component.text('Expertise')]),
          h2(classes: 'section-title', [Component.text('My Expertise')]),
          p(classes: 'section-subtitle', [Component.text('Technologies and areas I specialize in')]),
        ]),
        div(classes: 'skills-grid', [
          for (final s in skills) _buildSkillCard(s),
        ]),
      ]),
    ]);
  }

  Component _buildSkillCard(_Skill s) {
    return div(classes: 'skill-card card', [
      div(classes: 'skill-icon', [Component.text(s.icon)]),
      h3(classes: 'skill-title', [Component.text(s.title)]),
      p(classes: 'skill-description', [Component.text(s.description)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.expertise', [
      css('.skills-grid', [
        css('&').styles(
          display: Display.grid,
          gridTemplate: GridTemplate(columns: GridTracks([
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
          ])),
          gap: Gap.all(20.px),
        ),
      ]),
      css('.skill-card').styles(
        padding: Padding.all(28.px),
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      css('.skill-icon').styles(
        width: 52.px,
        height: 52.px,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        fontSize: 26.px,
        backgroundColor: cSoft,
        border: Border.all(color: cHairlineSoft, width: 1.px),
        radius: .all(.circular(radiusMd.px)),
        margin: .only(bottom: 20.px),
      ),
      css('.skill-title').styles(
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 10.px),
      ),
      css('.skill-description').styles(
        fontSize: 15.px,
        lineHeight: 1.6.em,
        color: cBody,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 720.px), [
      css('.expertise .skills-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
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