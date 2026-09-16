// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:portfolio/components/contact.dart' as _contact;
import 'package:portfolio/components/experience.dart' as _experience;
import 'package:portfolio/components/expertise.dart' as _expertise;
import 'package:portfolio/components/featured_project.dart'
    as _featured_project;
import 'package:portfolio/components/footer.dart' as _footer;
import 'package:portfolio/components/header.dart' as _header;
import 'package:portfolio/components/hero.dart' as _hero;
import 'package:portfolio/components/testimonials.dart' as _testimonials;
import 'package:portfolio/constants/theme.dart' as _theme;
import 'package:portfolio/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {_app.App: ClientTarget<_app.App>('app')},
  styles: () => [
    ..._theme.styles,
    ..._app.AppState.styles,
    ..._contact.Contact.styles,
    ..._experience.Experience.styles,
    ..._expertise.Expertise.styles,
    ..._featured_project.FeaturedProject.styles,
    ..._footer.Footer.styles,
    ..._header.Header.styles,
    ..._hero.Hero.styles,
    ..._testimonials.Testimonials.styles,
  ],
);
