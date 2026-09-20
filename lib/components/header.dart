import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

/// Sticky top navigation with a light/dark theme toggle.
class Header extends StatefulComponent {
  const Header({super.key});

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  bool _isMenuOpen = false;
  late bool _dark;

  static const _storageKey = 'portfolio-theme';

  @override
  void initState() {
    super.initState();
    // Server-side pre-render never touches the browser; the no-flash head
    // script has already set `data-theme` from storage by the time the client
    // hydrates, so this just syncs the toggle's icon state.
    if (kIsWeb) {
      _dark = web.document.documentElement?.getAttribute('data-theme') == 'dark';
    } else {
      _dark = false;
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

  void _closeMenu() {
    if (_isMenuOpen) setState(() => _isMenuOpen = false);
  }

  @override
  Component build(BuildContext context) {
    return header(classes: 'site-header', [
      div(classes: 'container header-inner', [
        a(href: '#top', classes: 'logo', [Component.text('Omar Adel')]),
        // Mobile hamburger / close button
        button(
          classes: 'mobile-toggle',
          onClick: _toggleMenu,
          attributes: {
            'aria-expanded': _isMenuOpen.toString(),
            'aria-label': _isMenuOpen ? 'Close menu' : 'Open menu',
          },
          [
            if (_isMenuOpen)
              span(classes: 'x-mark', [Component.text('×')])
            else ...[
              span(classes: 'hamburger', []),
              span(classes: 'hamburger', []),
              span(classes: 'hamburger', []),
            ],
          ],
        ),
        // Desktop nav
        nav(classes: 'header-nav', [
          a(href: '#expertise', classes: 'nav-link', [Component.text('Expertise')]),
          a(href: '#projects', classes: 'nav-link', [Component.text('Projects')]),
          a(href: '#experience', classes: 'nav-link', [Component.text('Experience')]),
          a(href: '#testimonials', classes: 'nav-link', [Component.text('Testimonials')]),
          a(href: '#contact', classes: 'nav-link', [Component.text('Contact')]),
          button(
            classes: 'theme-toggle',
            onClick: _toggleTheme,
            attributes: {'aria-label': _dark ? 'Switch to light theme' : 'Switch to dark theme'},
            [Component.text(_dark ? '☀️' : '🌙')],
          ),
          a(href: '#contact', classes: 'nav-cta', [Component.text('Get in touch')]),
        ]),
      ]),
      // Mobile drawer
      if (_isMenuOpen)
        div(classes: 'mobile-drawer', [
          div(classes: 'container mobile-drawer-inner', [
            a(href: '#expertise', classes: 'drawer-link', onClick: _closeMenu, [Component.text('Expertise')]),
            a(href: '#projects', classes: 'drawer-link', onClick: _closeMenu, [Component.text('Projects')]),
            a(href: '#experience', classes: 'drawer-link', onClick: _closeMenu, [Component.text('Experience')]),
            a(href: '#testimonials', classes: 'drawer-link', onClick: _closeMenu, [Component.text('Testimonials')]),
            a(href: '#contact', classes: 'drawer-link', onClick: _closeMenu, [Component.text('Contact')]),
            a(href: '#contact', classes: 'btn btn-primary drawer-cta', onClick: _closeMenu, [
              Component.text('Get in touch'),
            ]),
          ]),
        ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-header', [
      css('&').styles(
        position: Position.sticky(top: 0.px),
        zIndex: ZIndex(1000),
        backgroundColor: cCanvas,
        border: Border.only(bottom: BorderSide.solid(color: cHairline, width: 1.px)),
      ),

      css('.header-inner').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.spaceBetween,
        height: 60.px,
      ),

      css('.logo').styles(
        textDecoration: .none,
        color: cInk,
        fontFamily: fSansStack,
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        letterSpacing: (-0.4).px,
      ),
      css('.logo:hover').styles(textDecoration: .none),

      css('.header-nav').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(6.px),
      ),

      css('.nav-link').styles(
        color: cBody,
        fontSize: 15.px,
        fontWeight: FontWeight.w600,
        padding: .symmetric(vertical: 8.px, horizontal: 12.px),
        radius: .all(.circular(radiusSm.px)),
        textDecoration: .none,
      ),
      css('.nav-link:hover').styles(
        color: cInk,
        backgroundColor: cSoft,
        textDecoration: .none,
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
        justifyContent: JustifyContent.center,
        width: 40.px,
        height: 40.px,
        backgroundColor: Colors.transparent,
        border: Border.none,
        radius: .all(.circular(radiusSm.px)),
        flexDirection: FlexDirection.column,
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
        border: Border.only(top: BorderSide.solid(color: cHairlineSoft, width: 1.px)),
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
        radius: .all(.circular(radiusSm.px)),
        textDecoration: .none,
      ),
      css('.drawer-link:hover').styles(
        backgroundColor: cSoft,
        textDecoration: .none,
      ),
      css('.drawer-cta').styles(margin: .only(top: 8.px)),
    ]),

    // Tablet / mobile
    css.media(MediaQuery.all(maxWidth: 900.px), [
      css('.site-header .header-nav').styles(display: Display.none),
      css('.site-header .mobile-toggle').styles(display: Display.flex),
      css('.site-header .header-inner').styles(height: 56.px),
    ]),
  ];
}