import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../constants/theme.dart';

class Header extends StatefulComponent {
  const Header({super.key});

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() => _isMenuOpen = !_isMenuOpen);
  }

  void _closeMenu() {
    setState(() => _isMenuOpen = false);
  }

  @override
  Component build(BuildContext context) {
    return header(classes: 'header', [
      div(classes: 'container header-content', [
        a(href: '#', classes: 'logo', [text('Omar Adel')]),
        // Mobile menu button
        button(
          classes: 'mobile-menu-btn',
          onClick: _toggleMenu,
          attributes: {'aria-expanded': _isMenuOpen.toString(), 'aria-label': _isMenuOpen ? 'Close menu' : 'Open menu'},
          [
            span(classes: 'hamburger', []),
            span(classes: 'hamburger', []),
            span(classes: 'hamburger', []),
          ],
        ),
        // Navigation
        nav(classes: 'nav ${_isMenuOpen ? 'open' : ''}', [
          a(href: '#about', classes: 'nav-link', onClick: _closeMenu, [text('About')]),
          a(href: '#expertise', classes: 'nav-link', onClick: _closeMenu, [text('Expertise')]),
          a(href: '#projects', classes: 'nav-link', onClick: _closeMenu, [text('Projects')]),
          a(href: '#testimonials', classes: 'nav-link', onClick: _closeMenu, [text('Testimonials')]),
          a(href: '#contact', classes: 'nav-link btn btn-secondary', onClick: _closeMenu, [text('Contact')]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.header', [
      css('&').styles(
        width: 100.percent,
        padding: .symmetric(vertical: 16.px),
        backgroundColor: Color('#0A0A0A'),
        border: Border.all(color: Color('#333333'), width: 1.px),
      ),
      
      css('.header-content').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.spaceBetween,
      ),
      
      css('.logo').styles(
        textDecoration: .none,
        color: accentColor,
        fontWeight: FontWeight.w700,
        fontSize: 1.5.rem,
        fontFamily: FontFamily('Space Grotesk'),
      ),
      
      css('.nav').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        padding: .zero,
      ),
      
      css('.nav-link').styles(
        color: mutedColor,
        fontSize: 0.875.rem,
        fontWeight: FontWeight.w500,
        padding: .symmetric(vertical: 8.px, horizontal: 16.px),
        radius: .all(.circular(8.px)),
        margin: .symmetric(horizontal: 4.px),
      ),
      
      css('.nav-link:hover').styles(
        color: accentColor,
        backgroundColor: Color('#FFFFFF10'),
      ),
      
      css('.nav-link.btn').styles(
        padding: .symmetric(vertical: 8.px, horizontal: 16.px),
      ),
      
      // Mobile menu button
      css('.mobile-menu-btn').styles(
        display: Display.none,
        backgroundColor: Colors.transparent,
        border: Border.none,
        cursor: .pointer,
        padding: .symmetric(vertical: 8.px, horizontal: 8.px),
      ),
      
      css('.hamburger').styles(
        display: Display.block,
        width: 24.px,
        height: 2.px,
        backgroundColor: accentColor,
        margin: .symmetric(vertical: 4.px),
      ),
      
      // Mobile styles
      css('@media (max-width: 768px)', [
        css('.mobile-menu-btn').styles(
          display: Display.block,
        ),
        
        css('.nav').styles(
          display: Display.none,
          flexDirection: FlexDirection.column,
          width: 100.percent,
          padding: .symmetric(vertical: 16.px),
        ),
        
        css('.nav.open').styles(
          display: Display.flex,
        ),
        
        css('.nav-link').styles(
          width: 100.percent,
          textAlign: TextAlign.center,
          padding: .symmetric(vertical: 16.px, horizontal: 16.px),
          margin: .zero,
          radius: .all(.circular(0.px)),
        ),
        
        css('.nav-link:not(:last-child)').styles(
          border: Border.all(color: Color('#333333'), width: 1.px),
        ),
      ]),
    ]),
  ];
}