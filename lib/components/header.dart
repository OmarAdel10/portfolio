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
  bool _isMenuOpen = false;
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

  void _toggleMenu() {
    setState(() => _isMenuOpen = !_isMenuOpen);
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
          div(classes: 'mobile-actions', [
            button(
              classes: 'theme-toggle mobile-theme-toggle',
              onClick: _toggleTheme,
              attributes: {'aria-label': _dark ? 'Switch to light theme' : 'Switch to dark theme'},
              [
                CupertinoIcon(
                  icon: _dark ? CupertinoIconName.sunMax : CupertinoIconName.moon,
                  color: CupertinoIconColor.primary,
                ),
              ],
            ),
            // Mobile hamburger / close button
            button(
              classes: 'mobile-toggle',
              onClick: _toggleMenu,
              attributes: {
                'aria-expanded': _isMenuOpen.toString(),
                'aria-label': _isMenuOpen ? 'Close menu' : 'Open menu',
              },
              [
                CupertinoIcon(
                  icon: _isMenuOpen ? CupertinoIconName.xmark : CupertinoIconName.bars,
                  color: CupertinoIconColor.primary,
                ),
              ],
            ),
          ]),
          // Desktop nav
          nav(classes: 'header-nav', [
            for (final (index, item) in _navItems.indexed) ...[
              if (index > 0) span(classes: 'nav-divider', []),
              a(
                href: '#${item.id}',
                classes: 'nav-link ${_activeId == item.id ? 'active' : ''}',
                events: {
                  'click': (_) => setState(() => _activeId = item.id),
                },
                [Component.text(item.label)],
              ),
            ],
          ]),
          div(classes: 'desktop-actions', [
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
        // Mobile drawer
        if (_isMenuOpen)
          div(classes: 'mobile-drawer', [
            div(classes: 'container mobile-drawer-inner', [
              for (final item in _navItems)
                a(
                  href: '#${item.id}',
                  classes: 'drawer-link ${_activeId == item.id ? 'active' : ''}',
                  events: {
                    'click': (_) {
                      setState(() => _activeId = item.id);
                      if (_isMenuOpen) setState(() => _isMenuOpen = false);
                    },
                  },
                  [Component.text(item.label)],
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
        padding: .only(top: 10.px),
        transition: Transition(
          'transform',
          duration: Duration(milliseconds: 300),
          curve: Curve.easeOut,
        ),
      ),
      css('[data-hidden="true"]').styles(
        raw: const {
          'transform': 'translateY(-100%)',
        },
      ),

      css('.header-inner').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.spaceBetween,
        minHeight: 56.px,
        padding: .symmetric(horizontal: 20.px, vertical: 10.px),
        width: 100.percent,
        maxWidth: 1200.px,
        margin: .symmetric(horizontal: Unit.auto),
        backgroundColor: cCanvas,
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(20.px)),
      ),

      css('.logo').styles(
        textDecoration: .none,
        color: cInk,
        fontFamily: fSansStack,
        fontSize: 18.px,
        fontWeight: FontWeight.w700,
        letterSpacing: (-0.4).px,
      ),
      css('.logo:hover').styles(textDecoration: .none),

      css('.header-nav').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        flex: Flex.grow(1),
        justifyContent: .center,
        gap: Gap.all(2.px),
      ),

      css('.nav-divider').styles(
        width: 1.px,
        height: 18.px,
        backgroundColor: cHairlineSoft,
        margin: .symmetric(horizontal: 4.px),
      ),

      css('.nav-link').styles(
        color: cBody,
        fontSize: 14.px,
        fontWeight: FontWeight.w600,
        padding: .symmetric(vertical: 8.px, horizontal: 12.px),
        textDecoration: .none,
        position: Position.relative(),
        radius: .all(.circular(radiusFull.px)),
      ),
      css('.nav-link:hover').styles(
        color: cInk,
        backgroundColor: cSoft,
        textDecoration: .none,
      ),
      css('.nav-link::after').styles(
        raw: const {
          'content': '""',
          'position': 'absolute',
          'bottom': '-4px',
          'left': '50%',
          'width': '0',
          'height': '2px',
          'backgroundColor': 'var(--primary)',
          'transition': 'all 0.3s ease',
          'transform': 'translateX(-50%)',
        },
      ),
      css('.nav-link:hover::after').styles(
        raw: const {
          'width': '100%',
        },
      ),

      css('.nav-link.active').styles(
        color: cInk,
        raw: const {
          'background-color': 'rgba(247, 165, 1, 0.14)',
        },
      ),
      css('.nav-link.active::after').styles(raw: const {'width': '0'}),

      css('.desktop-actions').styles(
        display: .inlineFlex,
        alignItems: .center,
      ),

      css('.theme-toggle').styles(
        display: .inlineFlex,
        alignItems: .center,
        justifyContent: .center,
        width: 34.px,
        height: 34.px,
        margin: .symmetric(horizontal: 4.px),
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent, width: 1.px),
        radius: .all(.circular(radiusSm.px)),
        fontSize: 16.px,
        lineHeight: 1.em,
      ),
      css('.theme-toggle:hover').styles(
        backgroundColor: cSoft,
      ),

      css('.nav-cta').styles(
        color: cOnPrimary,
        backgroundColor: cPrimary,
        padding: .symmetric(vertical: 9.px, horizontal: 16.px),
        radius: .all(.circular(radiusFull.px)),
        fontSize: 14.px,
        fontWeight: FontWeight.w700,
        textDecoration: .none,
        whiteSpace: .noWrap,
      ),
      css('.nav-cta:hover').styles(
        backgroundColor: cPrimaryPressed,
        color: cOnPrimary,
        textDecoration: .none,
      ),

      // Mobile button (hidden on desktop)
      css('.mobile-toggle').styles(
        display: Display.none,
        alignItems: AlignItems.center,
        justifyContent: .center,
        width: 40.px,
        height: 40.px,
        backgroundColor: Colors.transparent,
        border: Border.none,
        radius: .all(.circular(radiusSm.px)),
        flexDirection: FlexDirection.column,
      ),
      css('.mobile-actions').styles(
        display: Display.none,
        alignItems: AlignItems.center,
        gap: Gap.all(4.px),
      ),
      css('.hamburger').styles(
        display: .block,
        width: 20.px,
        height: 2.px,
        backgroundColor: cInk,
        margin: .symmetric(vertical: 2.px),
      ),
      css('.x-mark').styles(
        fontSize: 24.px,
        lineHeight: 1.em,
        color: cInk,
      ),

      css('.mobile-drawer').styles(
        backgroundColor: cCanvas,
        border: Border.only(
          top: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
        padding: .only(bottom: 24.px),
      ),
      css('.mobile-drawer-inner').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(4.px),
        padding: .symmetric(vertical: 12.px),
      ),
      css('.drawer-link').styles(
        color: cInk,
        fontSize: 17.px,
        fontWeight: FontWeight.w600,
        padding: .symmetric(vertical: 12.px, horizontal: 12.px),
        textDecoration: .none,
        radius: .all(.circular(radiusFull.px)),
      ),
      css('.drawer-link:hover').styles(
        backgroundColor: cSoft,
        textDecoration: .none,
      ),
      css('.drawer-link.active').styles(
        raw: const {
          'background-color': 'rgba(247, 165, 1, 0.14)',
        },
      ),
    ]),

    // Tablet / mobile
    // Tablet breakpoint (max-width: 768px)
    css.media(MediaQuery.all(maxWidth: 768.px), [
      css('.site-header .header-inner').styles(
        width: 92.percent,
        padding: .symmetric(horizontal: 14.px),
        minHeight: 52.px,
        radius: .all(.circular(18.px)),
      ),
      css('.site-header .header-nav').styles(display: Display.none),
      css('.site-header .mobile-actions').styles(display: Display.flex),
      css('.site-header .mobile-toggle').styles(display: Display.flex),
      css('.site-header .desktop-actions').styles(display: Display.none),
      css('.logo').styles(fontSize: 17.px),
      css('.theme-toggle').styles(
        width: 44.px,
        height: 44.px,
      ),
      css('.mobile-toggle').styles(
        width: 44.px,
        height: 44.px,
      ),
    ]),

    // Mobile breakpoint (max-width: 480px)
    css.media(MediaQuery.all(maxWidth: 480.px), [
      css('.site-header .header-inner').styles(
        width: 96.percent,
        padding: .symmetric(horizontal: 12.px, vertical: 8.px),
        minHeight: 50.px,
        radius: .all(.circular(16.px)),
      ),
      css('.site-header .header-nav').styles(display: Display.none),
      css('.site-header .mobile-actions').styles(display: Display.flex),
      css('.site-header .mobile-toggle').styles(display: Display.flex),
      css('.site-header .desktop-actions').styles(display: Display.none),
      css('.logo').styles(fontSize: 15.px),
      css('.theme-toggle').styles(
        width: 40.px,
        height: 40.px,
      ),
      css('.mobile-toggle').styles(
        width: 40.px,
        height: 40.px,
      ),
      css('.mobile-drawer-inner').styles(
        padding: .symmetric(vertical: 10.px),
      ),
      css('.drawer-link').styles(
        fontSize: 16.px,
        padding: .symmetric(vertical: 10.px, horizontal: 12.px),
      ),
    ]),
  ];
}
