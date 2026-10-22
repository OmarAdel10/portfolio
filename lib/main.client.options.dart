// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:portfolio/app.dart' deferred as _app;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
/// Loads the deferred `app.dart` library with one retry (~1s) so a transient
/// chunk-load failure (network/404 race during reload) doesn't leave the app
/// unhydrated forever. Rethrows on the second failure so Jaspr's existing
/// logging surfaces it.
Future<void> _loadApp() async {
  try {
    await _app.loadLibrary();
  } catch (_) {
    await Future<void>.delayed(const Duration(seconds: 1));
    await _app.loadLibrary();
  }
}

ClientOptions get defaultClientOptions => ClientOptions(
  clients: {'app': ClientLoader((p) => _app.App(), loader: _loadApp)},
);
