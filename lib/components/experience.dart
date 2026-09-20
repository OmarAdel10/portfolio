import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// TODO(owner): Replace the placeholder role entries below with your real
// professional history before deploying. They follow tamalsen.dev's structure
// (title, company, location, period, description, technology chips).
class Experience extends StatelessComponent {
  const Experience({super.key});

  @override
  Component build(BuildContext context) {
    final experiences = [
      _Experience(
        title: 'Full Stack Developer',
        company: 'Company Name',
        location: 'Remote',
        period: '2022 – Present',
        description:
            'Designing and shipping scalable web and mobile applications across the stack, with a focus on clean architecture, responsive UI, and developer experience.',
        technologies: ['Dart', 'Flutter', 'Python', 'TypeScript', 'Firebase'],
      ),
      _Experience(
        title: 'Mobile Developer',
        company: 'Agency Name',
        location: 'Remote',
        period: '2020 – 2022',
        description:
            'Built and maintained cross-platform mobile apps for Android and iOS with Flutter, collaborating closely with design and product teams.',
        technologies: ['Flutter', 'Dart', 'Swift', 'REST', 'Git'],
      ),
      _Experience(
        title: 'Junior Front-end Developer',
        company: 'Startup Name',
        location: 'Remote',
        period: '2018 – 2020',
        description:
            'Implemented responsive, accessible interfaces with modern HTML, CSS, and JavaScript, contributing to a rapid product development cycle.',
        technologies: ['HTML', 'CSS', 'JavaScript', 'React'],
      ),
    ];

    return section(classes: 'experience section', id: 'experience', [
      div(classes: 'container', [
        div(classes: 'section-head', [
          span(classes: 'eyebrow', [Component.text('Experience')]),
          h2(classes: 'section-title', [Component.text('Professional Experience')]),
          p(classes: 'section-subtitle', [Component.text('A snapshot of my professional journey')]),
        ]),

        div(classes: 'experience-list', [
          for (final exp in experiences) _buildCard(exp),
        ]),
      ]),
    ]);
  }

  Component _buildCard(_Experience exp) {
    return div(classes: 'experience-card card', [
      div(classes: 'experience-head', [
        div(classes: 'experience-meta', [
          h3(classes: 'experience-title', [Component.text(exp.title)]),
          p(classes: 'experience-company', [
            Component.text(exp.company),
            Component.text(' · '),
            Component.text(exp.location),
          ]),
        ]),
        span(classes: 'experience-period', [Component.text(exp.period)]),
      ]),
      p(classes: 'experience-desc', [Component.text(exp.description)]),
      div(classes: 'experience-tech', [
        for (final tech in exp.technologies) span(classes: 'tag tag-outline', [Component.text(tech)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience', [
      css('.experience-list').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(20.px),
        maxWidth: 900.px,
        margin: .only(left: .auto, right: .auto),
      ),
      css('.experience-card').styles(
        padding: Padding.all(28.px),
      ),
      css('.experience-head').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.start,
        gap: Gap.all(10.px),
        margin: .only(bottom: 12.px),
      ),
      css('.experience-title').styles(
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 4.px),
      ),
      css('.experience-company').styles(
        fontSize: 15.px,
        color: cMute,
      ),
      css('.experience-period').styles(
        fontSize: 13.px,
        fontWeight: FontWeight.w600,
        color: cMute,
        padding: .symmetric(vertical: 4.px, horizontal: 10.px),
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusFull.px)),
        backgroundColor: cSoft,
        whiteSpace: .noWrap,
      ),
      css('.experience-desc').styles(
        fontSize: 15.px,
        lineHeight: 1.65.em,
        color: cBody,
        margin: .only(bottom: 16.px),
      ),
      css('.experience-tech').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
      ),
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

  const _Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.period,
    required this.description,
    required this.technologies,
  });
}