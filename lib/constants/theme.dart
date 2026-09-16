import 'package:jaspr/dom.dart';

// Color palette matching tamalsen.dev design
const Color primaryColor = Color('#0A0A0A');
const Color secondaryColor = Color('#1A1A1A');
const Color accentColor = Color('#FFFFFF');
const Color mutedColor = Color('#888888');
const Color borderColor = Color('#333333');
const Color cardBgColor = Color('#111111');

// Typography
const FontFamily fontPrimary = FontFamily('Inter');
const FontFamily fontSecondary = FontFamily('Space Grotesk');
const FontFamily fontFallback = FontFamilies.sansSerif;

// Spacing
const double spaceXs = 4;
const double spaceSm = 8;
const double spaceMd = 16;
const double spaceLg = 24;
const double spaceXl = 32;
const double space2xl = 48;
const double space3xl = 64;

// Border radius
const double radiusSm = 4;
const double radiusMd = 8;
const double radiusLg = 16;
const double radiusFull = 9999;

// Breakpoints
const double bpMobile = 480;
const double bpTablet = 768;
const double bpDesktop = 1024;
const double bpLarge = 1280;

@css
List<StyleRule> get styles => [
  css.import('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap'),
  
  css('*').styles(
    boxSizing: .borderBox,
    margin: .zero,
    padding: .zero,
  ),
  
  css('html').styles(
    fontSize: 16.px,
  ),
  
  css('body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    backgroundColor: primaryColor,
    color: accentColor,
    fontFamily: .list([fontPrimary, fontFallback]),
    lineHeight: 1.6.em,
  ),
  
  css('a').styles(
    color: accentColor,
    textDecoration: .none,
  ),
  
  css('a:hover').styles(
    color: mutedColor,
  ),
  
  css('img').styles(
    maxWidth: 100.percent,
    height: .auto,
    display: .block,
  ),
  
  css('h1, h2, h3, h4, h5, h6').styles(
    fontFamily: .list([fontSecondary, fontFallback]),
    fontWeight: .w600,
    lineHeight: 1.2.em,
  ),
  
  css('h1').styles(fontSize: 3.5.rem, fontWeight: .w700),
  css('h2').styles(fontSize: 2.5.rem, fontWeight: .w600),
  css('h3').styles(fontSize: 1.75.rem, fontWeight: .w600),
  css('h4').styles(fontSize: 1.25.rem, fontWeight: .w600),
  css('h5').styles(fontSize: 1.rem, fontWeight: .w500),
  css('h6').styles(fontSize: 0.875.rem, fontWeight: .w500),
  
  css('p').styles(fontSize: 1.rem, color: mutedColor),
  
  // Utility classes
  css('.container').styles(
    width: 100.percent,
    maxWidth: 1200.px,
    margin: .zero,
    padding: .symmetric(horizontal: spaceLg.px),
  ),
  
  css('.section').styles(
    padding: .symmetric(vertical: space3xl.px),
  ),
  
  css('.section-title').styles(
    fontSize: 2.rem,
    fontWeight: .w600,
    padding: .only(bottom: spaceXl.px),
    textAlign: .center,
  ),
  
  // Button styles
  css('.btn').styles(
    display: .inlineFlex,
    alignItems: .center,
    justifyContent: .center,
    padding: .symmetric(vertical: 12.px, horizontal: 24.px),
    fontSize: 1.rem,
    fontWeight: .w500,
    border: .none,
    cursor: .pointer,
    textDecoration: .none,
  ),
  
  css('.btn-primary').styles(
    backgroundColor: accentColor,
    color: primaryColor,
  ),
  
  css('.btn-primary:hover').styles(
    backgroundColor: Color('#CCCCCC'),
  ),
  
  css('.btn-secondary').styles(
    backgroundColor: Colors.transparent,
    color: accentColor,
    border: .symmetric(vertical: .solid(color: borderColor, width: 1.px)),
  ),
  
  css('.btn-secondary:hover').styles(
    border: .symmetric(vertical: .solid(color: accentColor, width: 1.px)),
    backgroundColor: Color('#FFFFFF10'),
  ),
  
  // Scrollbar styling
  css('::-webkit-scrollbar').styles(width: 8.px, height: 8.px),
  css('::-webkit-scrollbar-track').styles(backgroundColor: primaryColor),
  css('::-webkit-scrollbar-thumb').styles(
    backgroundColor: borderColor,
    radius: .all(.circular(radiusFull.px)),
  ),
  css('::-webkit-scrollbar-thumb:hover').styles(backgroundColor: mutedColor),
];