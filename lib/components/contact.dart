import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'contact', id: 'contact', [
      div(classes: 'container', [
        div(classes: 'section-header', [
          h2(classes: 'section-title', [text('Get In Touch')]),
          p(classes: 'section-subtitle', [
            text('Have a project in mind? Let\'s talk about it.'),
          ]),
        ]),
        
        div(classes: 'contact-content', [
          div(classes: 'contact-info', [
            h3(classes: 'contact-title', [text('Let\'s work together')]),
            p(classes: 'contact-description', [
              text('I\'m always open to discussing new projects, creative ideas, or opportunities to be part of your vision. Feel free to reach out through any of the channels below.'),
            ]),
            
            div(classes: 'contact-links', [
              _buildContactLink('Email', 'you@example.com', 'mailto:you@example.com'),
              _buildContactLink('GitHub', 'github.com/yourname', 'https://github.com/yourname'),
              _buildContactLink('LinkedIn', 'linkedin.com/in/yourname', 'https://linkedin.com/in/yourname'),
              _buildContactLink('Twitter', '@yourname', 'https://twitter.com/yourname'),
            ]),
          ]),
          
          div(classes: 'contact-form-wrapper', [
            form(classes: 'contact-form', [
              div(classes: 'form-group', [
                label(classes: 'form-label', [text('Name')]),
                input(
                  type: InputType.text, 
                  attributes: {'placeholder': 'Your Name', 'required': 'true'},
                  classes: 'form-input',
                ),
              ]),
              div(classes: 'form-group', [
                label(classes: 'form-label', [text('Email')]),
                input(
                  type: InputType.email, 
                  attributes: {'placeholder': 'your@email.com', 'required': 'true'},
                  classes: 'form-input',
                ),
              ]),
              div(classes: 'form-group', [
                label(classes: 'form-label', [text('Message')]),
                textarea(
                  [],
                  placeholder: 'Your message...',
                  required: true,
                  classes: 'form-textarea',
                ),
              ]),
              button(type: ButtonType.submit, classes: 'btn btn-primary form-submit', [text('Send Message')]),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _buildContactLink(String label, String value, String href) {
    return a(href: href, classes: 'contact-link', [
      span(classes: 'contact-link-label', [text(label)]),
      span(classes: 'contact-link-value', [text(value)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact', [
      css('&').styles(
        padding: .symmetric(vertical: 64.px),
        backgroundColor: Color('#111111'),
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
      
      css('.contact-content', [
        css('&').styles(
          display: .flex,
          flexWrap: .wrap,
          justifyContent: .spaceBetween,
        ),
      ]),
      
      css('.contact-info', [
        css('&').styles(
          width: 100.percent,
          maxWidth: 400.px,
        ),
      ]),
      
      css('.contact-title').styles(
        fontSize: 1.5.rem,
        fontWeight: .w600,
        color: Color('#FFFFFF'),
        fontFamily: .list([FontFamily('Space Grotesk'), FontFamilies.sansSerif]),
        padding: .only(bottom: 16.px),
      ),
      
      css('.contact-description').styles(
        fontSize: 1.125.rem,
        color: Color('#888888'),
        padding: .only(bottom: 32.px),
        maxWidth: 400.px,
      ),
      
      css('.contact-links', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
        ),
      ]),
      
      css('.contact-link', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          padding: .symmetric(vertical: 16.px, horizontal: 16.px),
          backgroundColor: Color('#1A1A1A'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          color: Color('#CCCCCC'),
          fontSize: 1.rem,
        ),
        css('&:hover').styles(
          border: .symmetric(vertical: .solid(color: Color('#FFFFFF33'), width: 1.px)),
          color: Color('#FFFFFF'),
        ),
      ]),
      
      css('.contact-link-label').styles(
        fontWeight: .w500,
        color: Color('#888888'),
        minWidth: 80.px,
      ),
      
      css('.contact-link-value').styles(
        color: Color('#CCCCCC'),
      ),
      
      css('.contact-form-wrapper', [
        css('&').styles(
          width: 100.percent,
          maxWidth: 500.px,
        ),
      ]),
      
      css('.contact-form', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
          backgroundColor: Color('#1A1A1A'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          padding: .symmetric(vertical: 32.px, horizontal: 32.px),
        ),
      ]),
      
      css('.form-group', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
        ),
      ]),
      
      css('.form-label').styles(
        fontSize: 0.875.rem,
        fontWeight: .w500,
        color: Color('#CCCCCC'),
        padding: .only(bottom: 8.px),
      ),
      
      css('.form-input, .form-textarea', [
        css('&').styles(
          padding: .symmetric(vertical: 16.px, horizontal: 16.px),
          backgroundColor: Color('#111111'),
          border: .symmetric(vertical: .solid(color: Color('#333333'), width: 1.px)),
          color: Color('#FFFFFF'),
          fontSize: 1.rem,
          fontFamily: .list([FontFamily('Inter'), FontFamilies.sansSerif]),
        ),
      ]),
      
      css('.form-textarea', [
        css('&').styles(
          minHeight: 150.px,
        ),
      ]),
      
      css('.form-submit', [
        css('&').styles(
          padding: .symmetric(vertical: 16.px, horizontal: 32.px),
          fontSize: 1.rem,
          fontWeight: .w500,
          width: 100.percent,
        ),
      ]),
    ]),
  ];
}