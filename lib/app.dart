import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'components/header.dart';
import 'components/hero.dart';
import 'components/expertise.dart';
import 'components/featured_project.dart';
import 'components/all_projects.dart';
import 'components/experience.dart';
import 'components/testimonials.dart';
import 'components/contact.dart';
import 'components/footer.dart';

// The main component of your application.
//
// By using the @client annotation this component is automatically compiled to
// JavaScript and mounted on the client. It is pre-rendered on the server and
// hydrated on the client.
@client
class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Component build(BuildContext context) {
    return div(classes: 'app', [
      const Header(),
      div(classes: 'main-content', [
        const Hero(),
        const Expertise(),
        const FeaturedProject(),
        const AllProjects(),
        const Experience(),
        const Testimonials(),
        const Contact(),
      ]),
      const Footer(),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.app').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      minHeight: 100.vh,
    ),
    css('.main-content').styles(
      width: 100.percent,
      flex: Flex.grow(1),
    ),
  ];
}