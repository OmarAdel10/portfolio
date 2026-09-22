import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../models/project.dart';

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
          span([Component.text('→')]),
        ]),
        if (project.homepage != null && project.homepage!.isNotEmpty)
          a(href: project.homepage!, classes: 'btn btn-tertiary', [Component.text('Live Demo →')]),
      ]),
    ]);
  }

  Component _buildLogo() {
    if (project.logoUrl != null) {
      // Theme-aware logos: show light logo in light mode, dark logo in dark mode
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
    return Component.text(_getLanguageIcon(project.language));
  }

  String _getLanguageIcon(String language) {
    const icons = {
      'C++': '⚙️',
      'HTML/CSS/JS': '🌐',
      'HTML': '🌐',
      'Python': '🐍',
      'Dart': '🎯',
      'TypeScript': '🦖',
      'Swift': '🍎',
      'JavaScript': '📜',
      'CSS': '🎨',
    };
    return icons[language] ?? '📦';
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
        // Fixed light tile: product logos are designed for a light surface, so
        // this contrasts correctly in both the light and dark themes.
        // backgroundColor: Colors.white,
        backgroundColor: cHairlineSoft,
        border: Border.all(color: cHairlineSoft, width: 1.px),
        radius: .all(.circular(radiusSm.px)),
        margin: .only(bottom: 16.px),
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
          // Visible in light theme, hidden in dark
          // The CSS variable --canvas is light in light mode, dark in dark mode
          // We use media query in CSS instead for cleaner handling
        },
      ),
      css('.pcard-logo-dark').styles(
        raw: const {
          // Visible in dark theme, hidden in light
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
