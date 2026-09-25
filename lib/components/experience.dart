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
        title: 'BSc in Computer Science',
        company: 'New Mansoura University',
        location: 'Egypt',
        period: '2023 – 2027',
        description:
            'Relevant coursework in Computer Networks, Machine Learning, Artificial Neural Networks, Cloud Computing, Data Warehousing, Digital Logic Design, Deep Learning, and Databases.',
        technologies: ['Computer Networks', 'Machine Learning', 'Deep Learning', 'Cloud Computing', 'Databases'],
      ),
      _Experience(
        title: 'Professional Training · Flutter & Dart Development',
        company: 'Route IT Academy',
        location: 'Specialization',
        period: 'Certification',
        description:
            'Intensive training on building production-ready Flutter applications — Dart fundamentals, state management, API integration, and cross-platform deployment.',
        technologies: ['Flutter', 'Dart', 'State Management', 'REST'],
      ),
      _Experience(
        title: 'Mastering Clean Architecture & SOLID Principles',
        company: 'Usama Elgendy',
        location: 'Architecture',
        period: 'Certification',
        description:
            'Deep-dive into layered, testable application architecture — SOLID principles, dependency injection, and Clean Architecture patterns applied to real mobile codebases.',
        technologies: ['Clean Architecture', 'SOLID', 'DI', 'Testing'],
      ),
    ];

    return section(classes: 'experience section', id: 'experience', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Education')]),
          h2(classes: 'section-title', [Component.text('Education & Training')]),
          p(classes: 'section-subtitle', [Component.text('Computer science foundation and hands-on professional certification')]),
        ]),

        div(classes: 'experience-list', [
          for (final exp in experiences) _buildCard(exp),
        ]),
      ]),
    ]);
  }

  Component _buildCard(_Experience exp) {
    return div(classes: 'experience-card card reveal', [
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