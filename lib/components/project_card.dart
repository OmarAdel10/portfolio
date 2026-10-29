import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/project.dart';
import 'cupertino_icon.dart';

class ProjectCard extends StatelessComponent {
  final Project project;

  const ProjectCard({required this.project, super.key});

  @override
  Component build(BuildContext context) {
    return article(classes: 'pcard card', [
      // Language meta (quiet mono, no pill).
      div(classes: 'pcard-top', [
        span(classes: 'pcard-lang', [Component.text(project.language.replaceAll(' · ', ', '))]),
      ]),

      div(classes: 'pcard-icon', [
        _buildLogo(),
      ]),

      h3(classes: 'pcard-title', [
        a(
          href: project.url,
          target: Target.blank,
          attributes: {'rel': 'noopener noreferrer'},
          classes: 'pcard-title-link',
          [
            Component.text(project.name.replaceAll(' · ', ' ')),
          ],
        ),
      ]),
      p(classes: 'pcard-desc', [Component.text(project.description)]),

      p(classes: 'pcard-stack', [
        Component.text(project.stackLabel),
      ]),

      if (project.homepage != null && project.homepage!.isNotEmpty)
        div(classes: 'pcard-links', [
          a(
            href: project.homepage!,
            classes: 'pcard-demo-link',
            target: Target.blank,
            attributes: {'rel': 'noopener noreferrer'},
            [
              Component.text('Live Demo'),
            ],
          ),
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
      ),

      css('.pcard-top').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        margin: .only(bottom: 16.px),
      ),
      css('.pcard-lang').styles(
        fontFamily: fMonoStack,
        fontSize: fontMicro.px,
        color: cMute,
        letterSpacing: 0.02.em,
      ),

      css('.pcard-icon').styles(
        width: 72.px,
        height: 72.px,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        padding: Padding.all(8.px),
        fontSize: 26.px,
        backgroundColor: cHairlineSoft,
        border: Border.all(color: cHairlineSoft, width: 1.px),
        radius: .all(.circular(radiusSm.px)),
        margin: .only(bottom: 16.px),
        raw: const {
          'transition': 'transform var(--dur-control) var(--ease-out)',
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
        fontSize: fontTitleMd.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        margin: .only(bottom: 8.px),
      ),
      css('.pcard-title-link').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {
          'transition': 'color var(--dur-micro) var(--ease-out)',
        },
      ),
      css('.pcard-title-link:hover').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {
          'text-decoration': 'underline',
          'text-decoration-color': 'var(--primary)',
          'text-underline-offset': '4px',
        },
      ),

      css('.pcard-desc').styles(
        fontSize: fontBodySm.px,
        lineHeight: 1.55.em,
        color: cBody,
        margin: .only(bottom: 16.px),
        raw: const {
          'display': '-webkit-box',
          '-webkit-line-clamp': '3',
          '-webkit-box-orient': 'vertical',
          'overflow': 'hidden',
        },
      ),

      css('.pcard-stack').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        margin: .only(top: .auto, bottom: 16.px),
      ),

      css('.pcard-links').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
        alignItems: AlignItems.center,
        padding: .only(top: 16.px),
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
      css('.pcard-demo-link').styles(
        fontFamily: fMonoStack,
        fontSize: fontMeta.px,
        color: cMute,
        textDecoration: .none,
        padding: .only(bottom: 2.px),
        raw: const {
          'border-bottom': '1px solid var(--hairline)',
          'transition':
              'color var(--dur-micro) var(--ease-out), '
              'border-color var(--dur-micro) var(--ease-out)',
        },
      ),
      css('.pcard-demo-link:hover').styles(
        color: cInk,
        textDecoration: .none,
        raw: const {'border-bottom-color': 'var(--primary)'},
      ),
    ]),
    // Logo variants follow the *site* theme, never the OS one: the palette is
    // driven by `data-theme` alone, so a dark-OS visitor on the light site
    // must still get the light logo.
    css('html:not([data-theme]) .pcard-logo-light').styles(raw: const {'display': 'block'}),
    css('html:not([data-theme]) .pcard-logo-dark').styles(raw: const {'display': 'none'}),
    css('html[data-theme="light"] .pcard-logo-light').styles(raw: const {'display': 'block'}),
    css('html[data-theme="light"] .pcard-logo-dark').styles(raw: const {'display': 'none'}),
    css('html[data-theme="dark"] .pcard-logo-light').styles(raw: const {'display': 'none'}),
    css('html[data-theme="dark"] .pcard-logo-dark').styles(raw: const {'display': 'block'}),
  ];
}
