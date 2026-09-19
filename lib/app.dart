import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'components/header.dart';
import 'components/hero.dart';
import 'components/expertise.dart';
import 'components/featured_projects.dart';
import 'components/all_projects.dart';
import 'components/testimonials.dart';
import 'components/contact.dart';
import 'components/footer.dart';

// The main component of your application.
//
// By using the @client annotation this component will be automatically compiled to javascript and mounted
// on the client. Therefore:
// - this file and any imported file must be compilable for both server and client environments.
// - this component and any child components will be built once on the server during pre-rendering and then
//   again on the client during normal rendering.
@client
class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    // Run code depending on the rendering environment.
    if (kIsWeb) {
      print("Hello client");
    } else {
      print("Hello server");
    }
  }

  @override
  Component build(BuildContext context) {
    return div([
      const Header(),
      div(classes: 'main-content', [
        const Hero(),
        const Expertise(),
        const FeaturedProjects(),
        const AllProjects(),
        const Testimonials(),
        const Contact(),
      ]),
      const Footer(),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.main-content').styles(
      width: 100.percent,
    ),
  ];
}