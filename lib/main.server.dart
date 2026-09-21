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

/// Marks JS as enabled and reveals `.reveal` elements as they scroll into view.
/// Reveal state is set with inline styles (not classes) so Jaspr re-renders
/// never wipe it. A MutationObserver rescan means hydration swapping DOM nodes
/// can't strand an element hidden. Skipped when the user prefers reduced motion.
const String _motionJs = "(function(){"
    "var d=document.documentElement;d.classList.add('js-enabled');"
    "if(window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches)return;"
    "var revealed=[];"
    "function revealVisible(){"
    "var sheet='opacity .65s cubic-bezier(0.22,0.61,0.36,1), transform .65s cubic-bezier(0.22,0.61,0.36,1)';"
    "var els=[].slice.call(document.querySelectorAll('.reveal'));"
    "var vh=window.innerHeight||document.documentElement.clientHeight;"
    "for(var i=0;i<els.length;i++){var el=els[i];if(revealed.indexOf(el)>=0)continue;var r=el.getBoundingClientRect();"
    "if(r.top<vh*0.94&&r.bottom>0){el.style.transition=sheet;el.style.opacity='1';el.style.transform='translateY(0)';revealed.push(el);}}}"
    "window.addEventListener('scroll',revealVisible,{passive:true});"
    "window.addEventListener('resize',revealVisible);"
    "var mut=new MutationObserver(revealVisible);mut.observe(document.documentElement,{childList:true,subtree:true});"
    "revealVisible();setTimeout(revealVisible,500);setTimeout(revealVisible,1500);"
    "})();";

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
      script(content: _motionJs),
    ],
    body: const App(),
  ));
}