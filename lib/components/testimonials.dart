import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Testimonials extends StatelessComponent {
  const Testimonials({super.key});

  @override
  Component build(BuildContext context) {
    final testimonials = [
      _Testimonial(
        quote: 'Since 2018 has been responsible for the development of our website which has been instrumental to the growth of our company. Even while working remotely he\'s been highly responsive, organized and strategic in his thinking.',
        author: 'Mark Greenspan',
        role: 'Founder at influenceTHIS Canada',
        avatar: 'MG',
      ),
      _Testimonial(
        quote: 'Is AMAZING! If you have any doubt about hiring him, ask me – I am really impressed by this guy!',
        author: 'Wilfried Hajek',
        role: 'Agile Coach | Speaker | Trainer',
        avatar: 'WH',
      ),
      _Testimonial(
        quote: 'Is one of the best professionals that we have known in web development skills. Between his skills you can find good communication and accuracy with the planning in complex projects.',
        author: 'Jonathan Castro',
        role: 'CEO & Founder at The Cliff',
        avatar: 'JC',
      ),
    ];

    return section(classes: 'testimonials', id: 'testimonials', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('Testimonials')]),
          p(classes: 'section-subtitle', [
            text('What clients and colleagues say'),
          ]),
        ]),
        
        div(classes: 'testimonials-grid', [
          for (final t in testimonials) _buildTestimonialCard(t),
        ]),
      ]),
    ]);
  }

  Component _buildTestimonialCard(_Testimonial t) {
    return div(classes: 'testimonial-card', [
      div(classes: 'testimonial-quote', [
        text('"${t.quote}"'),
      ]),
      div(classes: 'testimonial-author', [
        div(classes: 'author-avatar', [text(t.avatar)]),
        div(classes: 'author-info', [
          h4(classes: 'author-name', [text(t.author)]),
          p(classes: 'author-role', [text(t.role)]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.testimonials', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
      ),
      
      css('.section-header', [
        css('&').styles(
          textAlign: .center,
          maxWidth: 600.px,
          margin: .zero,
          padding: .only(bottom: 48.px),
        ),
        
        css('.section-title').styles(
          fontSize: 2.5.rem,
          fontWeight: .w600,
          color: Color('#FFFFFF'),
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
        ),
        
        css('.section-subtitle').styles(
          fontSize: 1.125.rem,
          color: Color('#888888'),
        ),
      ]),
      
      css('.testimonials-grid', [
        css('&').styles(
          display: .flex,
          flexWrap: .wrap,
          justifyContent: .center,
        ),
      ]),
      
      css('.testimonial-card', [
        css('&').styles(
          backgroundColor: Color('#111111'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          padding: .symmetric(vertical: 32.px, horizontal: 32.px),
          width: 350.px,
        ),
        
        css('.testimonial-quote').styles(
          fontSize: 1.125.rem,
          color: Color('#CCCCCC'),
          padding: .only(bottom: 24.px),
        ),
        
        css('.testimonial-author', [
          css('&').styles(
            display: .flex,
          ),
        ]),
        
        css('.author-avatar', [
          css('&').styles(
            width: 48.px,
            height: 48.px,
            radius: .all(.circular(9999.px)),
            backgroundColor: Color('#FFFFFF15'),
            display: .flex,
            alignItems: .center,
            justifyContent: .center,
            fontSize: 1.rem,
            fontWeight: .w600,
            color: Color('#FFFFFF'),
          ),
        ]),
        
        css('.author-info', [
          css('&').styles(
            display: .flex,
            flexDirection: .column,
          ),
        ]),
        
        css('.author-name').styles(
          fontSize: 1.rem,
          fontWeight: .w600,
          color: Color('#FFFFFF'),
          fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
        ),
        
        css('.author-role').styles(
          fontSize: 0.875.rem,
          color: Color('#888888'),
        ),
      ]),
    ]),
  ];
}

class _Testimonial {
  final String quote;
  final String author;
  final String role;
  final String avatar;
  
  const _Testimonial({
    required this.quote,
    required this.author,
    required this.role,
    required this.avatar,
  });
}