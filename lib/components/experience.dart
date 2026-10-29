import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// The education and training chapter. Each row is a two-column entry:
// the period in mono on the left, the detail on the right.
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
            'A computer science degree with a practical bend — from digital logic '
            'and data warehousing up to neural networks and cloud.',
        technologies: [
          'Computer Networks',
          'Machine Learning',
          'Deep Learning',
          'Artificial Neural Networks',
          'Cloud Computing',
          'Data Warehousing',
          'Digital Logic Design',
          'Databases',
        ],
      ),
      _Experience(
        title: 'Flutter & Dart Development',
        company: 'Route IT Academy',
        location: 'Professional Training',
        period: 'Certification',
        description:
            'Intensive training on building production-ready Flutter applications — Dart fundamentals, state management, API integration, and cross-platform deployment.',
        technologies: ['Flutter', 'Dart', 'State Management', 'REST'],
      ),
      _Experience(
        title: 'Clean Architecture & SOLID Principles',
        company: 'Usama Elgendy',
        location: 'Instructor',
        period: 'Certification',
        description:
            'Deep-dive into layered, testable application architecture — SOLID principles, dependency injection, and Clean Architecture patterns applied to real mobile codebases.',
        technologies: ['Clean Architecture', 'SOLID', 'DI', 'Testing'],
      ),
    ];

    return section(classes: 'experience section', id: 'experience', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Background')]),
          h2(classes: 'section-title', [Component.text('Education & Training')]),
          p(classes: 'section-subtitle', [
            Component.text('Computer science foundation and hands-on professional certification'),
          ]),
        ]),

        div(classes: 'experience-list reveal', [
          for (var i = 0; i < experiences.length; i++) _buildRow(experiences[i], i),
        ]),
      ]),
    ]);
  }

  Component _buildRow(_Experience exp, int i) {
    return div(
      classes: 'experience-row reveal',
      attributes: {'data-stagger-index': i.toString()},
      [
        div(classes: 'experience-year', [Component.text(exp.period)]),
        div(classes: 'experience-body', [
          h3(classes: 'experience-title', [Component.text(exp.title)]),
          p(classes: 'experience-company', [
            Component.text('${exp.company}, ${exp.location}'),
          ]),
          p(classes: 'experience-desc', [Component.text(exp.description)]),
          p(classes: 'experience-tech', [
            Component.text(exp.technologies.join(', ')),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience', [
      // The list spans the full content width so the row rules line up with
      // the section-head rule above them.
      css('.experience-list').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      css('.experience-row').styles(
        display: Display.grid,
        gap: Gap.all(24.px),
        padding: Padding.symmetric(vertical: 32.px),
        raw: const {
          'grid-template-columns': '128px minmax(0, 1fr)',
        },
      ),
      css('.experience-row + .experience-row').styles(
        raw: const {'border-top': '1px solid var(--hairline-soft)'},
      ),
      css('.experience-year').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        whiteSpace: .noWrap,
        padding: .only(top: 3.px),
      ),
      css('.experience-title').styles(
        fontSize: fontTitleMd.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 4.px),
      ),
      css('.experience-company').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        margin: .only(bottom: 12.px),
      ),
      css('.experience-desc').styles(
        fontSize: fontBodySm.px,
        lineHeight: 1.65.em,
        color: cBody,
        maxWidth: 640.px,
        margin: .only(bottom: 12.px),
      ),
      css('.experience-tech').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 720.px), [
      css('.experience .experience-row').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(8.px),
        padding: Padding.symmetric(vertical: 24.px),
      ),
      css('.experience .experience-year').styles(padding: .zero),
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
