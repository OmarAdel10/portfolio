import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      div(classes: 'container', [
        div(classes: 'footer-grid', [
          div(classes: 'footer-brand', [
            a(href: '#top', classes: 'footer-logo', [Component.text('Omar Adel')]),
            p(classes: 'footer-tagline', [
              Component.text('Software Engineer · Flutter, C# .NET & AI Tooling'),
            ]),
            // div(classes: 'footer-socials', [
            //   a(href: githubUrl, classes: 'social-badge', [Component.text('GitHub')]),
            //   a(href: linkedinUrl, classes: 'social-badge', [Component.text('LinkedIn')]),
            //   a(href: 'javascript:void(0)', classes: 'social-badge email-fallback', [Component.text('Email')]),
            // ]),
          ]),
          _column('Explore', [
            ('Expertise', '#expertise'),
            ('Projects', '#projects'),
            ('Experience', '#experience'),
            ('Contact', '#contact'),
          ]),
          _column('Projects', [
            ('Mobile', '#projects-work'),
            ('Apps', '#projects-work'),
            ('AI / Data', '#projects-work'),
            ('Tools', '#projects-work'),
          ]),
          _column('Connect', [
            ('GitHub', githubUrl),
            ('LinkedIn', linkedinUrl),
            ('WhatsApp', whatsappUrl),
            ('Email Address', 'javascript:void(0)'), // email-fallback handler
          ]),
        ]),
        div(classes: 'footer-bottom', [
          span(classes: 'footer-copy', [Component.text('© $_year Omar Adel. All rights reserved.')]),
          span(classes: 'footer-made', [Component.text('Built with Jaspr')]),
        ]),
      ]),
    ]);
  }

  String get _year => '${DateTime.now().year}';

  Component _column(String title, List<(String, String)> links) {
    return div(classes: 'footer-col', [
      h4(classes: 'footer-col-title', [Component.text(title)]),
      div(classes: 'footer-col-links', [
        for (final (label, href) in links) a(href: href, classes: 'footer-link', [Component.text(label)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        backgroundColor: cCanvas,
        border: Border.only(
          top: BorderSide.solid(color: cHairline, width: 1.px),
        ),
        padding: Padding.symmetric(vertical: 40.px),
        margin: .only(top: 24.px),
      ),
      css('.footer-grid').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(3)),
            GridTrack(TrackSize.fr(1.5)),
            GridTrack(TrackSize.fr(1.5)),
            GridTrack(TrackSize.fr(1.5)),
          ]),
        ),
        gap: Gap.all(28.px),
        padding: .only(bottom: 28.px),
        border: Border.only(
          bottom: BorderSide.solid(color: cHairlineSoft, width: 1.px),
        ),
      ),
      css('.footer-logo').styles(
        fontSize: 20.px,
        fontWeight: FontWeight.w700,
        color: cInk,
        textDecoration: .none,
        fontFamily: fSansStack,
      ),
      css('.footer-logo:hover').styles(textDecoration: .none),
      css('.footer-tagline').styles(
        fontSize: 14.px,
        color: cMute,
        lineHeight: 1.6.em,
        margin: .symmetric(vertical: 12.px),
        maxWidth: 300.px,
      ),
      css('.footer-socials').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(8.px),
        margin: .only(top: 6.px),
      ),
      css('.social-badge').styles(
        display: .inlineFlex,
        alignItems: .center,
        fontSize: 13.px,
        fontWeight: FontWeight.w600,
        color: cBody,
        backgroundColor: cSoft,
        padding: .symmetric(vertical: 6.px, horizontal: 12.px),
        radius: .all(.circular(radiusFull.px)),
        textDecoration: .none,
      ),
      css('.social-badge:hover').styles(
        color: cInk,
        textDecoration: .none,
      ),
      css('.footer-col-title').styles(
        fontSize: 12.px,
        fontWeight: FontWeight.w700,
        textTransform: .upperCase,
        letterSpacing: 0.08.em,
        color: cAsh,
        margin: .only(bottom: 14.px),
      ),
      css('.footer-col-links').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(10.px),
      ),
      css('.footer-link').styles(
        fontSize: 14.5.px,
        color: cBody,
        textDecoration: .none,
      ),
      css('.footer-link:hover').styles(
        color: cInk,
        textDecoration: .none,
      ),
      css('.footer-bottom').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        gap: Gap.all(12.px),
        padding: .only(top: 20.px),
        fontSize: 13.5.px,
        color: cAsh,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 900.px), [
      css('.site-footer .footer-grid').styles(
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack(TrackSize.fr(1)),
            GridTrack(TrackSize.fr(1)),
          ]),
        ),
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 560.px), [
      css('.site-footer .footer-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
    ]),
  ];
}
