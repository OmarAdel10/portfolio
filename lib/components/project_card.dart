import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/project.dart';
import 'cupertino_icon.dart';

class ProjectCard extends StatelessComponent {
  final Project project;
  final bool isFeatured;

  const ProjectCard({required this.project, this.isFeatured = false, super.key});

  @override
  Component build(BuildContext context) {
    return article(classes: 'pcard card', [
      // Language / category strip
      div(classes: 'pcard-top', [
        span(classes: 'tag', [Component.text(project.language)]),
        if (isFeatured || project.isFeatured) span(classes: 'tag tag-accent', [Component.text('Featured')]),
      ]),

      div(classes: 'pcard-icon', [
        _buildLogo(),
      ]),

      h3(classes: 'pcard-title', [Component.text(project.name)]),
      p(classes: 'pcard-desc', [Component.text(project.description)]),

      div(classes: 'pcard-tags', [
        for (final topic in project.topics.take(5)) span(classes: 'tag tag-outline', [Component.text(topic)]),
      ]),

      div(classes: 'pcard-links', [
        a(href: project.url, classes: 'btn btn-secondary', [
          Component.text('View on GitHub'),
          CupertinoIcon(
            icon: CupertinoIconName.arrowRight,
            color: CupertinoIconColor.primary,
            size: CupertinoIconSize.sm,
          ),
        ]),
        if (project.homepage != null && project.homepage!.isNotEmpty)
          a(href: project.homepage!, classes: 'btn btn-tertiary', [
            Component.text('Live Demo'),
            CupertinoIcon(
              icon: CupertinoIconName.arrowRight,
              color: CupertinoIconColor.primary,
              size: CupertinoIconSize.sm,
            ),
          ]),
      ]),
    ]);
  }

  Component _buildLogo() {
    if (project.logoUrl != null) {
      if (project.logoUrlLight != null || project.logoUrlDark != null) {
        return div(classes: 'pcard-logo-wrap', [
          if (project.logoUrlLight != null)
            img(src: project.logoUrlLight!, alt: project.name, classes: 'pcard-logo pcard-logo-light'),
          if (project.logoUrlDark != null)
            img(src: project.logoUrlDark!, alt: project.name, classes: 'pcard-logo pcard-logo-dark'),
        ]);
      }
      return img(src: project.logoUrl!, alt: project.name, classes: 'pcard-logo');
    }
    if (project.icon case final projectIcon?) {
      return CupertinoIcon(
        icon: projectIcon,
        color: project.iconColor,
        label: '${project.name} icon',
        size: CupertinoIconSize.lg,
      );
    }

    return CupertinoIcon(
      icon: _getLanguageIcon(project.language),
      color: _getLanguageColor(project.language),
      label: '${project.language} icon',
      size: CupertinoIconSize.lg,
    );
  }

  CupertinoIconName _getLanguageIcon(String language) {
    const icons = <String, CupertinoIconName>{
      'C++': CupertinoIconName.gear,
      'HTML/CSS/JS': CupertinoIconName.globe,
      'HTML': CupertinoIconName.globe,
      'Python': CupertinoIconName.waveform,
      'Dart': CupertinoIconName.bolt,
      'TypeScript': CupertinoIconName.textformatAbc,
      'Swift': CupertinoIconName.chevronLeftSlashChevronRight,
      'JavaScript': CupertinoIconName.textformatAbc,
      'CSS': CupertinoIconName.paintbrushFill,
    };
    return icons[language] ?? CupertinoIconName.archivebox;
  }

  CupertinoIconColor _getLanguageColor(String language) {
    const colors = <String, CupertinoIconColor>{
      'C++': CupertinoIconColor.red,
      'HTML/CSS/JS': CupertinoIconColor.blue,
      'HTML': CupertinoIconColor.blue,
      'Python': CupertinoIconColor.teal,
      'Dart': CupertinoIconColor.green,
      'TypeScript': CupertinoIconColor.purple,
      'Swift': CupertinoIconColor.purple,
      'JavaScript': CupertinoIconColor.purple,
      'CSS': CupertinoIconColor.purple,
    };
    return colors[language] ?? CupertinoIconColor.primary;
  }

  @css
  static List<StyleRule> get styles => [
    css('.pcard', [
      css('&').styles(
        height: 100.percent,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        padding: Padding.all(24.px),
        transition: Transition(
          'transform',
          duration: Duration(milliseconds: 300),
          curve: Curve.easeOut,
        ),
      ),
      css('&:hover').styles(
        raw: const {
          'transform': 'translateY(-8px) rotate(-1deg)',
          'box-shadow': '0 20px 40px -12px rgba(35, 37, 29, 0.25)',
        },
      ),

      css('.pcard-top').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        margin: .only(bottom: 18.px),
      ),

      css('.tag-accent').styles(
        backgroundColor: cPrimary,
        color: cOnPrimary,
      ),

      css('.pcard-icon').styles(
        width: 72.px,
        height: 72.px,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        padding: Padding.all(10.px),
        fontSize: 26.px,
        backgroundColor: cHairlineSoft,
        border: Border.all(color: cHairlineSoft, width: 1.px),
        radius: .all(.circular(radiusSm.px)),
        margin: .only(bottom: 16.px),
        transition: Transition(
          'transform',
          duration: Duration(milliseconds: 300),
          curve: Curve.easeOut,
        ),
      ),
      css('.pcard:hover .pcard-icon').styles(
        raw: const {
          'transform': 'rotate(5deg) scale(1.1)',
        },
      ),

      css('.pcard-logo-wrap').styles(
        raw: const {
          'position': 'relative',
          'width': '100%',
          'height': '100%',
        },
      ),
      css('.pcard-logo').styles(
        raw: const {
          'width': '100%',
          'height': '100%',
          'object-fit': 'contain',
          'object-position': 'center',
        },
      ),
      css('.pcard-logo-light').styles(
        raw: const {
          'display': 'block',
        },
      ),
      css('.pcard-logo-dark').styles(
        raw: const {
          'display': 'none',
        },
      ),

      css('.pcard-title').styles(
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 8.px),
      ),

      css('.pcard-desc').styles(
        fontSize: 14.5.px,
        lineHeight: 1.6.em,
        color: cMute,
        margin: .only(bottom: 18.px),
        flex: Flex.grow(1),
      ),

      css('.pcard-tags').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
        margin: .only(bottom: 20.px),
      ),

      css('.pcard-links').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(10.px),
        alignItems: AlignItems.center,
        padding: .only(top: 16.px),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
    ]),
    // Theme-based logo visibility
    css.media(MediaQuery.raw('(prefers-color-scheme: light)'), [
      css('.pcard-logo-light').styles(raw: const {'display': 'block'}),
      css('.pcard-logo-dark').styles(raw: const {'display': 'none'}),
    ]),
    css.media(MediaQuery.raw('(prefers-color-scheme: dark)'), [
      css('.pcard-logo-light').styles(raw: const {'display': 'none'}),
      css('.pcard-logo-dark').styles(raw: const {'display': 'block'}),
    ]),
    // Also handle manual theme toggle via [data-theme]
    css('html[data-theme="light"] .pcard-logo-light').styles(raw: const {'display': 'block'}),
    css('html[data-theme="light"] .pcard-logo-dark').styles(raw: const {'display': 'none'}),
    css('html[data-theme="dark"] .pcard-logo-light').styles(raw: const {'display': 'none'}),
    css('html[data-theme="dark"] .pcard-logo-dark').styles(raw: const {'display': 'block'}),
  ];
}
