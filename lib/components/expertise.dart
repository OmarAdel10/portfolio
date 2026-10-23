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
        color: CupertinoIconColor.blue,
      ),
      _Skill(
        title: 'Backend, Cloud & Payments',
        description:
            '.NET Core and Python services, Turso and Cloud Firestore databases, Cloudflare Workers gateways, and payment-terminal SDK integrations that reconcile invoices automatically.',
        icon: CupertinoIconName.cloudFill,
        color: CupertinoIconColor.green,
      ),
      _Skill(
        title: 'AI & Agentic Tooling',
        description:
            'Deep learning and offline speech-to-text models, plus agent-driven development with Claude Code, Codex, and Gemini CLI workflows that ship faster without cutting corners.',
        icon: CupertinoIconName.sparkles,
        color: CupertinoIconColor.purple,
      ),
    ];

    return section(classes: 'expertise section', id: 'expertise', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          span(classes: 'eyebrow', [Component.text('Expertise')]),
          h2(classes: 'section-title', [Component.text('My Expertise')]),
          p(classes: 'section-subtitle', [Component.text('Technologies and areas I specialize in')]),
        ]),
        div(classes: 'skills-grid', [
          for (var i = 0; i < skills.length; i++) _buildSkillCard(skills[i], i),
        ]),
      ]),
    ]);
  }

  Component _buildSkillCard(_Skill s, int i) {
    return div(
      classes: 'skill-card card reveal',
      attributes: {'data-stagger-index': i.toString()},
      [
        div(classes: 'skill-icon', [
          CupertinoIcon(icon: s.icon, color: s.color, size: CupertinoIconSize.lg),
        ]),
        h3(classes: 'skill-title', [Component.text(s.title)]),
        p(classes: 'skill-description', [Component.text(s.description)]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.expertise', [
      css('.skills-grid', [
        css('&').styles(
          display: Display.grid,
          gridTemplate: GridTemplate(
            columns: GridTracks([
              GridTrack(TrackSize.fr(1)),
              GridTrack(TrackSize.fr(1)),
              GridTrack(TrackSize.fr(1)),
            ]),
          ),
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
  final CupertinoIconName icon;
  final CupertinoIconColor color;

  const _Skill({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
