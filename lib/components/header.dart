import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import 'cupertino_icon.dart';

/// Sticky top navigation. The floating pill is centred on the page (logo |
/// nav | theme toggle), so the header reads as a balanced header rather than
/// a left-aligned island.
class Header extends StatefulComponent {
  const Header({super.key});

  @override
  State<Header> createState() => HeaderState();

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
      ),
      css('&[data-hidden="true"]').styles(
        raw: const {
          'transform': 'translateY(-150%)',
        },
      ),

      // The wrapper is the page container; the pill inside it hugs its
      // content and hangs off the container's left edge.
      css('.header-inner').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.spaceBetween,
        gap: Gap.all(28.px),
        padding: .only(top: 6.px, right: 8.px, bottom: 6.px, left: 20.px),
        minHeight: 48.px,
        backgroundColor: cCanvas,
        border: Border.all(color: cHairline, width: 1.px),
        radius: .all(.circular(radiusFull.px)),
        margin: .symmetric(horizontal: Unit.auto),
        raw: const {
          'width': 'fit-content',
          'max-width': 'calc(100% - 40px)',
          'box-shadow': '0 10px 30px rgba(0,0,0,0.18)',
          'pointer-events': 'auto',
        },
      ),

      css('.logo').styles(
        textDecoration: .none,
        color: cInk,
        fontFamily: fSansStack,
        fontSize: 15.px,
        fontWeight: FontWeight.w700,
        letterSpacing: (-0.4).px,
        whiteSpace: .noWrap,
      ),
      css('.logo:hover').styles(textDecoration: .none),

      css('.header-nav').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
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
    ]),

    css('html[data-theme="dark"] .site-header .header-inner').styles(
      raw: const {'box-shadow': '0 10px 30px rgba(0, 0, 0, 0.35)'},
    ),

    // The header is two things at once: an intro item (it fades in on the
    // page-load beat) and scroll-aware chrome (it slides away on the way
    // down). Two transitions with two different clocks — the intro fade
    // carries the stagger delay, the hide/show transform must not. The
    // `html.js-enabled` prefix also outranks the global `.intro-item`
    // transition, so the two never fight over the same property.
    css('html.js-enabled .site-header').styles(
      raw: const {
        'transition-property': 'opacity, transform',
        'transition-duration': 'var(--dur-panel), 300ms',
        'transition-timing-function': 'var(--ease-out), var(--ease-out)',
        'transition-delay': 'calc(var(--i, 0) * 110ms), 0ms',
      },
    ),

    // Below the desktop breakpoint the pill floats centred again — a
    // left-aligned pill on a narrow screen reads as broken.
    css.media(MediaQuery.all(maxWidth: 1023.px), [
      css('.site-header .header-inner').styles(
        margin: .symmetric(horizontal: Unit.auto),
        raw: const {'max-width': 'calc(100% - 32px)'},
      ),
    ]),

    // Tablet: max-width 899px — still a single row, just tighter
    css.media(MediaQuery.all(maxWidth: 899.px), [
      css('.site-header .header-inner').styles(
        gap: Gap.all(16.px),
        padding: .only(top: 6.px, right: 6.px, bottom: 6.px, left: 16.px),
        raw: const {'max-width': 'calc(100% - 24px)'},
      ),
      css('.site-header .header-nav').styles(gap: Gap.all(2.px)),
      css('.site-header .nav-link').styles(
        padding: .symmetric(vertical: 8.px, horizontal: 12.px),
      ),
      css('.site-header .logo').styles(fontSize: 14.px),
    ]),

    // Phone: max-width 519px — the wordmark alone; the footer carries the
    // section links at this size.
    css.media(MediaQuery.all(maxWidth: 519.px), [
      css('.site-header .header-inner').styles(
        padding: .only(top: 6.px, right: 16.px, bottom: 6.px, left: 20.px),
        gap: Gap.all(8.px),
        radius: .all(.circular(26.px)),
      ),
      css('.site-header .logo').styles(fontSize: 13.px),
      css('.site-header .header-nav').styles(display: Display.none),
    ]),

    // Small phone: max-width 359px — slightly smaller
    css.media(MediaQuery.all(maxWidth: 359.px), [
      css('.site-header .header-inner').styles(
        padding: .only(top: 4.px, right: 8.px, bottom: 4.px, left: 8.px),
      ),
      css('.site-header .logo').styles(fontSize: 12.px),
    ]),

    // Theme toggle — quiet icon button inside the pill.
    css('.theme-toggle').styles(
      display: .inlineFlex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      width: 36.px,
      height: 36.px,
      backgroundColor: Colors.transparent,
      border: Border.all(color: cHairline, width: 1.px),
      radius: .all(.circular(radiusFull.px)),
      color: cInk,
      raw: const {'cursor': 'pointer'},
    ),
    css('.theme-toggle:hover').styles(
      backgroundColor: cSoft,
      border: Border.all(color: cPrimary, width: 1.px),
    ),
  ];
}

class HeaderState extends State<Header> {
  double _lastScrollY = 0;
  bool _isHeaderHidden = false;
  String _activeId = '';
  late bool _dark;

  static const _storageKey = 'portfolio-theme';

  /// The scroll listener as a JS function reference.
  ///
  /// `removeEventListener` matches on identity, and `_onScroll.toJS` allocates
  /// a fresh JS function on every call — so the converted reference has to be
  /// kept in a field, or `dispose` would silently leave the listener attached.
  web.EventListener? _scrollListener;

  // `id` is where the link goes; `anchor` is where the chapter opens. They
  // differ for Work: the link lands on the full project grid, but the work
  // chapter actually starts one screen earlier, at the featured project.
  static const _navItems = <({String id, String label, String anchor})>[
    (id: 'projects-work', label: 'Work', anchor: 'projects'),
    (id: 'expertise', label: 'Expertise', anchor: 'expertise'),
    (id: 'experience', label: 'Education', anchor: 'experience'),
    (id: 'contact', label: 'Contact', anchor: 'contact'),
  ];

  @override
  void initState() {
    super.initState();
    // Server render has no document; default to light and let the client
    // correct it below.
    _dark = false;
    if (kIsWeb) {
      final hash = web.window.location.hash.replaceFirst('#', '');
      if (_navItems.any((item) => item.id == hash)) {
        _activeId = hash;
      }
      // The scroll event fires on the window, not on <html>: Chrome never
      // dispatches it to the document element, so listening there leaves the
      // header frozen.
      _scrollListener = _onScroll.toJS;
      web.window.addEventListener('scroll', _scrollListener);

      // Read the persisted theme so the toggle starts in the right state.
      _dark = web.document.documentElement?.getAttribute('data-theme') == 'dark';
    }
  }

  @override
  void dispose() {
    if (_scrollListener != null) {
      web.window.removeEventListener('scroll', _scrollListener);
      _scrollListener = null;
    }
    super.dispose();
  }

  /// Flips `data-theme` on `<html>` and persists the choice to localStorage,
  /// mirroring what the footer used to own.
  void _toggleTheme() {
    _dark = !_dark;
    final theme = _dark ? 'dark' : 'light';
    if (kIsWeb) {
      web.document.documentElement?.setAttribute('data-theme', theme);
      try {
        web.window.localStorage.setItem(_storageKey, theme);
      } catch (_) {
        // localStorage may be unavailable (private mode); the theme still applies.
      }
    }
    setState(() {});
  }

  void _onScroll(web.Event _) {
    final currentY = web.window.scrollY;
    final isScrollingDown = currentY > _lastScrollY;
    final shouldHide = isScrollingDown && currentY > 100;
    if (_isHeaderHidden != shouldHide) {
      setState(() => _isHeaderHidden = shouldHide);
    }
    _lastScrollY = currentY;
    _updateActiveSection(currentY);
  }

  /// Which section owns the reading position right now. The chapters are not
  /// in nav order — the scene's expertise panel sits above everything else —
  /// so each one gets a document-space activation point and the last point
  /// that has been passed wins.
  void _updateActiveSection(double scrollY) {
    var activeId = '';
    var activeTop = double.negativeInfinity;
    for (final item in _navItems) {
      final top = _activationTop(item.anchor);
      if (top <= scrollY + 140 && top > activeTop) {
        activeTop = top;
        activeId = item.id;
      }
    }
    if (_activeId != activeId) {
      setState(() => _activeId = activeId);
    }
  }

  /// The document-space y at which a chapter becomes the active one.
  double _activationTop(String anchor) {
    final pageY = web.window.scrollY;
    if (anchor == 'expertise') {
      final element = web.document.querySelector('#expertise');
      if (element == null) return double.infinity;
      // While the scene is pinned the panel's own box never moves, so its top
      // says nothing. Use the scene instead: the chapter opens when the
      // scrub starts bringing the panel in.
      final pinned = true;
      if (pinned) {
        final scene = web.document.querySelector('.scene');
        if (scene != null) {
          final rect = scene.getBoundingClientRect();
          final span = rect.height - web.window.innerHeight;
          return rect.top + pageY + (span > 0 ? span * 0.3 : 0);
        }
      }
      return element.getBoundingClientRect().top + pageY;
    }
    final element = web.document.querySelector('#$anchor');
    if (element == null) return double.infinity;
    return element.getBoundingClientRect().top + pageY;
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
        div(classes: 'container header-wrap', [
          div(classes: 'header-inner', [
            a(href: '#top', classes: 'logo', [Component.text('OmarAdel.dev')]),
            nav(
              classes: 'header-nav',
              attributes: {'aria-label': 'Primary'},
              [
                for (final item in _navItems)
                  a(
                    href: '#${item.id}',
                    classes: 'nav-link ${_activeId == item.id ? 'active' : ''}',
                    attributes: _activeId == item.id ? {'aria-current': 'page'} : const {},
                    events: {
                      'click': (_) => setState(() => _activeId = item.id),
                    },
                    [Component.text(item.label)],
                  ),
              ],
            ),
            button(
              classes: 'theme-toggle',
              onClick: _toggleTheme,
              attributes: {
                'aria-label': _dark ? 'Switch to light theme' : 'Switch to dark theme',
              },
              [
                CupertinoIcon(
                  icon: _dark ? CupertinoIconName.sunMax : CupertinoIconName.moon,
                  color: CupertinoIconColor.current,
                  size: CupertinoIconSize.md,
                ),
              ],
            ),
          ]),
        ]),
      ],
    );
  }
}
