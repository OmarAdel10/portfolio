import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import 'cupertino_icon.dart';
import '../constants/theme.dart';

/// Sticky top navigation with scroll-aware hide/show and animated nav links.
class Header extends StatefulComponent {
  const Header({super.key});

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  late bool _dark;
  double _lastScrollY = 0;
  bool _isHeaderHidden = false;
  String _activeId = 'top';

  static const _storageKey = 'portfolio-theme';
  static const _navItems = <({String id, String label})>[
    (id: 'top', label: 'Home'),
    (id: 'projects-work', label: 'My Work'),
    (id: 'expertise', label: 'Expertise'),
    (id: 'contact', label: 'Get In Touch'),
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _dark = web.document.documentElement?.getAttribute('data-theme') == 'dark';
      final hash = web.window.location.hash.replaceFirst('#', '');
      if (_navItems.any((item) => item.id == hash)) {
        _activeId = hash;
      }
    } else {
      _dark = false;
    }
    if (kIsWeb) {
      web.document.documentElement?.onScroll.listen((_) {
        final currentY = web.document.documentElement?.scrollTop ?? 0;
        final isScrollingDown = currentY > _lastScrollY;
        final shouldHide = isScrollingDown && currentY > 100;
        if (_isHeaderHidden != shouldHide) {
          setState(() => _isHeaderHidden = shouldHide);
        }
        _lastScrollY = currentY;
        _updateActiveSection(currentY);
      });
    }
  }

  void _updateActiveSection(double scrollY) {
    var activeId = 'top';
    for (final item in _navItems.skip(1)) {
      final element = web.document.querySelector('#${item.id}');
      if (element == null) continue;
      if (element.getBoundingClientRect().top <= 120) {
        activeId = item.id;
      }
    }
    if (_activeId != activeId) {
      setState(() => _activeId = activeId);
    }
  }

  void _toggleTheme() {
    _dark = !_dark;
    final theme = _dark ? 'dark' : 'light';
    if (kIsWeb) {
      web.document.documentElement?.setAttribute('data-theme', theme);
      try {
        web.window.localStorage.setItem(_storageKey, theme);
      } catch (_) {
        // localStorage may be unavailable (private mode); theme still applies.
      }
    }
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    return header(
      classes: 'site-header intro-item',
      styles: Styles(raw: {'--i': '10'}),
      attributes: {
        if (_isHeaderHidden) 'data-hidden': 'true',
      },
      [
        div(classes: 'container header-inner', [
          a(href: '#top', classes: 'logo', [Component.text('OmarAdel.dev')]),
          nav(classes: 'header-nav', [
            for (final item in _navItems)
              a(
                href: '#${item.id}',
                classes: 'nav-link ${_activeId == item.id ? 'active' : ''}',
                events: {
                  'click': (_) => setState(() => _activeId = item.id),
                },
                [Component.text(item.label)],
              ),
          ]),
          div(classes: 'header-actions', [
            button(
              classes: 'theme-toggle',
              onClick: _toggleTheme,
              attributes: {'aria-label': _dark ? 'Switch to light theme' : 'Switch to dark theme'},
              [
                CupertinoIcon(
                  icon: _dark ? CupertinoIconName.sunMax : CupertinoIconName.moon,
                  color: CupertinoIconColor.primary,
                ),
              ],
            ),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header', [
      css('&').styles(
        position: Position.sticky(top: 0.px),
        zIndex: ZIndex(1000),
        backgroundColor: Colors.transparent,
        raw: const {
          'padding-top': 'max(16px, env(safe-area-inset-top))',
          'pointer-events': 'none',
        },
        transition: Transition(
          'transform',
          duration: Duration(milliseconds: 300),
          curve: Curve.easeOut,
        ),
      ),
      css('&[data-hidden="true"]').styles(
        raw: const {
          'transform': 'translateY(-150%)',
        },
      ),

      css('.header-inner').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: .center,
        gap: Gap.all(28.px),
        padding: .only(top: 6.px, right: 8.px, bottom: 6.px, left: 20.px),
        minHeight: 48.px,
        backgroundColor: cCanvas,
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusFull.px)),
        margin: .symmetric(horizontal: Unit.auto),
        raw: const {
          'width': 'fit-content',
          'max-width': 'calc(100% - 32px)',
          'box-shadow': '0 10px 30px rgba(0,0,0,0.18)',
          'pointer-events': 'auto',
          'box-sizing': 'border-box',
        },
      ),

      css('.logo').styles(
        textDecoration: .none,
        color: cInk,
        fontFamily: fSansStack,
        fontSize: 15.px,
        fontWeight: FontWeight.w700,
        letterSpacing: (-0.4).px,
      ),
      css('.logo:hover').styles(textDecoration: .none),

      css('.header-nav').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: .center,
        gap: Gap.all(4.px),
      ),

      css('.nav-link').styles(
        color: cBody,
        fontSize: 14.px,
        fontWeight: FontWeight.w500,
        padding: .symmetric(vertical: 8.px, horizontal: 16.px),
        textDecoration: .none,
        whiteSpace: .noWrap,
        radius: .all(.circular(radiusFull.px)),
      ),
      css('.nav-link:hover').styles(
        color: cInk,
        backgroundColor: cSoft,
        textDecoration: .none,
      ),

      css('.nav-link.active').styles(
        color: cInk,
        fontWeight: FontWeight.w600,
        raw: const {
          'background-color': 'rgba(247, 165, 1, 0.14)',
        },
      ),

      css('.theme-toggle').styles(
        display: .inlineFlex,
        alignItems: .center,
        justifyContent: .center,
        width: 36.px,
        height: 36.px,
        margin: .zero,
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent, width: 1.px),
        radius: .all(.circular(radiusFull.px)),
        fontSize: 16.px,
        lineHeight: 1.em,
      ),
      css('.theme-toggle:hover').styles(
        backgroundColor: cSoft,
      ),
    ]),

    css('html[data-theme="dark"] .site-header .header-inner').styles(
      raw: const {'box-shadow': '0 10px 30px rgba(247, 165, 1, 0.15)'},
    ),

    // Tablet: max-width 899px — still a single row, just tighter
    css.media(MediaQuery.all(maxWidth: 899.px), [
      css('.site-header .header-inner').styles(
        gap: Gap.all(16.px),
        padding: .only(top: 6.px, right: 6.px, bottom: 6.px, left: 16.px),
        raw: const {'max-width': 'calc(100% - 24px)'},
      ),
      css('.site-header .header-nav').styles(gap: Gap.all(2.px)),
      css('.site-header .nav-link').styles(
        fontSize: 13.px,
        padding: .symmetric(vertical: 8.px, horizontal: 12.px),
      ),
      css('.site-header .logo').styles(fontSize: 14.px),
    ]),

    // Phone: max-width 519px — logo + theme toggle only, nav hidden
    css.media(MediaQuery.all(maxWidth: 519.px), [
      css('.site-header .header-inner').styles(
        padding: .only(top: 6.px, right: 16.px, bottom: 6.px, left: 20.px),
        gap: Gap.all(50.px),
        justifyContent: JustifyContent.spaceBetween,
        radius: .all(.circular(26.px)),
      ),
      css('.site-header .logo').styles(fontSize: 13.px),
      css('.site-header .header-nav').styles(display: Display.none),
      css('.site-header .theme-toggle').styles(
        width: 32.px,
        height: 32.px,
      ),
    ]),

    // Small phone: max-width 359px — logo + theme toggle only, slightly smaller
    css.media(MediaQuery.all(maxWidth: 359.px), [
      css('.site-header .header-inner').styles(
        padding: .only(top: 4.px, right: 8.px, bottom: 4.px, left: 8.px),
        gap: Gap.all(4.px),
      ),
      css('.site-header .logo').styles(fontSize: 12.px),
      css('.site-header .theme-toggle').styles(width: 28.px, height: 28.px),
    ]),
  ];
}
