/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

// Imports the [App] component.
import 'app.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

/// Applies the saved theme before first paint so the site never flashes from
/// light to dark. The default (no saved value) is the light PostHog theme.
const String _themeInitJs = "(function(){try{var t=localStorage.getItem('portfolio-theme');"
    "if(t==='dark'){document.documentElement.setAttribute('data-theme','dark');}}catch(e){}})();";

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  runApp(Document(
    title: 'Omar Adel — Software Engineer & App Developer',
    lang: 'en',
    meta: {
      'description':
          'Personal portfolio of Omar Adel — software engineer specializing in Flutter mobile apps, responsive web front-ends, and practical AI tooling.',
      'theme-color': '#eeefe9',
      'og:title': 'Omar Adel — Software Engineer & App Developer',
      'og:type': 'website',
      'og:url': 'https://github.com/OmarAdel10',
    },
    head: [
      script(content: _themeInitJs),
    ],
    body: const App(),
  ));
}