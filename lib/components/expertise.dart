import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'cupertino_icon.dart';
import '../constants/theme.dart';

class Expertise extends StatelessComponent {
  const Expertise({super.key});

  @override
  Component build(BuildContext context) {
    final skills = [
      _Skill(
        title: 'Cross-Platform App Development',
        description:
            'Offline-first Flutter apps for Android, iOS, Windows, and Linux — BLoC/HydratedBLOC state, Firebase, Shorebird updates, SQLite, and local speech recognition built into the flow.',
        icon: CupertinoIconName.devicePhonePortrait,
      ),
      _Skill(
        title: 'Backend, Cloud & Payments',
        description:
            '.NET Core and Python services, Turso and Cloud Firestore databases, Cloudflare Workers gateways, and payment-terminal SDK integrations that reconcile invoices automatically.',
        icon: CupertinoIconName.cloudFill,
      ),
      _Skill(
        title: 'AI & Agentic Tooling',
        description:
            'Deep learning and offline speech-to-text models, plus agent-driven development with Claude Code, Codex, and Gemini CLI workflows that ship faster without cutting corners.',
        icon: CupertinoIconName.sparkles,
      ),
    ];

    return section(classes: 'expertise section', id: 'expertise', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          h2(classes: 'section-title', [Component.text('Expertise')]),
          p(classes: 'section-subtitle', [
            Component.text('Three areas I work in end to end'),
          ]),
        ]),
        div(classes: 'skills-grid', [
          for (var i = 0; i < skills.length; i++) _buildSkillCard(skills[i], i),
        ]),
      ]),
    ]);
  }

  /// A hairline-ruled column, not a card: the rule above the column is the
  /// only chrome, so the panel reads as a table of practice rather than a
  /// tile grid.
  Component _buildSkillCard(_Skill s, int i) {
    return div(
      classes: 'skill-card reveal',
      attributes: {'data-stagger-index': i.toString()},
      [
        div(classes: 'skill-icon', [
          CupertinoIcon(
            icon: s.icon,
            color: CupertinoIconColor.current,
            size: CupertinoIconSize.lg,
          ),
        ]),
        h3(classes: 'skill-title', [Component.text(s.title)]),
        p(classes: 'skill-description', [Component.text(s.description)]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.expertise', [
      css('.skills-grid').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
          ]),
        ),
        gap: Gap.all(24.px),
        alignItems: AlignItems.start,
      ),
      css('.skill-card').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        raw: const {
          'border-top': '1px solid var(--hairline)',
          'padding-top': '24px',
        },
      ),
      // Monochrome ink — amber stays the single chromatic accent on the page.
      css('.skill-icon').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.start,
        margin: .only(bottom: 20.px),
        raw: const {
          'color': 'var(--ink)',
        },
      ),
      css('.skill-icon .cupertino-icon').styles(
        raw: const {
          'width': '44px',
          'height': '44px',
        },
      ),
      css('.skill-title').styles(
        fontSize: fontTitleSm.px,
        fontWeight: FontWeight.w700,
        lineHeight: 1.35.em,
        color: cInk,
        margin: .only(bottom: 10.px),
      ),
      css('.skill-description').styles(
        fontSize: fontBodySm.px,
        lineHeight: 1.55.em,
        color: cBody,
      ),
    ]),
    // Below the scene breakpoint the page is a normal stacked document, so
    // the three columns fold to one there too — the panel must read the same
    // whether it is scrubbed into the stage or scrolled past.
    css.media(MediaQuery.all(maxWidth: 899.px), [
      css('.expertise .skills-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        gap: Gap.all(32.px),
      ),
    ]),
  ];
}

class _Skill {
  final String title;
  final String description;
  final CupertinoIconName icon;

  const _Skill({
    required this.title,
    required this.description,
    required this.icon,
  });
}
