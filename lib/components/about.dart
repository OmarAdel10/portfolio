import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// The bio that used to live in the hero. It gets real type here — 16px on a
/// 60-character measure — next to a compact mono fact list.
class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'about section', id: 'about', [
      div(classes: 'container', [
        div(classes: 'section-head reveal', [
          h2(classes: 'section-title', [Component.text('About')]),
          p(classes: 'section-subtitle', [
            Component.text('What I build, and how I work'),
          ]),
        ]),
        div(classes: 'about-layout', [
          div(classes: 'about-body reveal', [
            p(classes: 'about-p', [
              Component.text(
                'Most of my projects cross the seam between the app and the system behind it — an offline-first Flutter front end, .NET or Python services, a database at the edge, and payments that have to reconcile. The interesting problems live where those pieces disagree.',
              ),
            ]),
            p(classes: 'about-p', [
              Component.text(
                'I use AI daily in my workflow — Claude Code, Codex, Gemini CLI — as a force multiplier for the parts I\'ve already thought through. Obsessed with the details that make an app feel ',
              ),
              em([Component.text('right')]),
              Component.text(
                ': micro-interactions, consistent spacing, animations that don\'t get in the way. The kind of polish you only notice when it\'s missing.',
              ),
            ]),
            p(classes: 'about-p', [
              Component.text(
                'Night person. Mornings are for other people. I procrastinate like it\'s a discipline, then learn an entire semester\'s worth of material in one night when the deadline hits — works every time.',
              ),
            ]),
            p(classes: 'about-p', [
              Component.text(
                'Mostly at my desk, studying, shipping, breaking things on purpose to understand them. But the friends I do have? We make it count when we hang out.',
              ),
            ]),
          ]),
          aside(classes: 'about-facts reveal', [
            _fact('Role', 'Software Engineer'),
            _fact('Stack', 'Flutter, .NET, Python, TypeScript'),
            _fact('Currently', 'Sharpening the craft, one side project at a time'),
          ]),
        ]),
      ]),
    ]);
  }

  Component _fact(String label, String value) {
    return div(classes: 'about-fact', [
      span(classes: 'about-fact-label', [Component.text(label)]),
      span(classes: 'about-fact-value', [Component.text(value)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about', [
      // Two anchors on one row: the bio starts on the left spine, the fact
      // list ends on the container's right edge — the same edge every other
      // section closes on. The whitespace between them is deliberate.
      css('.about-layout').styles(
        display: Display.grid,
        gap: Gap.all(48.px),
        alignItems: AlignItems.start,
        raw: const {
          'grid-template-columns': '60ch 280px',
          'justify-content': 'space-between',
        },
      ),
      // A 60-character measure: long enough to hold a full clause, short
      // enough that the eye never loses the start of the next line.
      css('.about-body').styles(
        raw: const {'max-width': '60ch'},
      ),
      css('.about-p').styles(
        fontSize: fontBody.px,
        lineHeight: 1.6.em,
        color: cBody,
        margin: .only(bottom: 16.px),
      ),
      css('.about-p:last-child').styles(
        margin: .only(bottom: 0.px),
      ),
      // The fact list is the mono second voice: labels are data, values are
      // prose, and the hairline rules between them do the separating.
      css('.about-facts').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        border: Border.only(
          top: BorderSide.solid(color: cHairline, width: 1.px),
        ),
      ),
      css('.about-fact').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(4.px),
        padding: Padding.symmetric(vertical: 16.px),
        border: Border.only(
          bottom: BorderSide.solid(color: cHairline, width: 1.px),
        ),
      ),
      css('.about-fact-label').styles(
        fontFamily: fMonoStack,
        fontSize: fontMicro.px,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.08.em,
        textTransform: .upperCase,
        color: cMute,
      ),
      css('.about-fact-value').styles(
        fontSize: fontBodySm.px,
        lineHeight: 1.5.em,
        color: cInk,
      ),
    ]),
    css.media(MediaQuery.all(maxWidth: 900.px), [
      css('.about .about-layout').styles(
        gap: Gap.all(32.px),
        raw: const {
          'grid-template-columns': 'minmax(0, 1fr)',
        },
      ),
    ]),
  ];
}
