import 'package:dnd_character_sheet/data/class_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:dnd_character_sheet/widgets/glossary_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Iterable<TextSpan> _nestedTextSpans(InlineSpan span) sync* {
  if (span is! TextSpan) return;

  yield span;

  for (final child in span.children ?? const <InlineSpan>[]) {
    yield* _nestedTextSpans(child);
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home exposes the mobile glossary index', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('open_glossary_button')),
      findsOneWidget,
    );
    expect(find.text('APRI IL GLOSSARIO'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('open_glossary_button')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlossaryIndexPage), findsOneWidget);
    expect(find.text('Glossario'), findsOneWidget);
    expect(
      find.byKey(const Key('glossary_search_field')),
      findsOneWidget,
    );
  });

  testWidgets('rule summaries automatically expose blue glossary links',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RuleDescriptionView.legacy(
            description: RuleDescription(
              summary: 'La Scurovisione consente di vedere nell’oscurità.',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(GlossaryLinkedText), findsOneWidget);

    final richText = tester.widget<RichText>(
      find.byType(RichText).last,
    );

    final linked = _nestedTextSpans(richText.text).firstWhere(
      (span) => span.recognizer is TapGestureRecognizer,
    );

    expect(linked.text, 'Scurovisione');
    expect(linked.style?.color, isNotNull);
    expect(linked.style?.decoration, TextDecoration.underline);

    (linked.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();

    expect(find.byType(GlossaryEntryPage), findsOneWidget);
    expect(find.text('Scurovisione'), findsWidgets);
    expect(find.text('REGOLA IN BREVE'), findsOneWidget);
  });

  testWidgets('expanded rule details also expose glossary links',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RuleDescriptionView.legacy(
            initiallyExpanded: true,
            description: RuleDescription(
              summary: 'Una regola di esempio.',
              details: 'La Resistenza ai Danni riduce gli effetti del danno.',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final linkedTexts = tester
        .widgetList<GlossaryLinkedText>(
          find.byType(GlossaryLinkedText),
        )
        .map((widget) => widget.text)
        .toList();

    expect(
      linkedTexts,
      contains(
        'La Resistenza ai Danni riduce gli effetti del danno.',
      ),
    );

    final recognizers = find
        .byType(RichText)
        .evaluate()
        .map((element) => element.widget)
        .whereType<RichText>()
        .expand((widget) => _nestedTextSpans(widget.text))
        .where(
          (span) => span.recognizer is TapGestureRecognizer,
        )
        .toList();

    expect(
      recognizers.map((span) => span.text),
      contains('Resistenza ai Danni'),
    );
  });

  testWidgets('manual glossary chips still open the new full page',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RuleDescriptionView.legacy(
            initiallyExpanded: true,
            description: RuleDescription(
              summary: 'Capacità difensiva.',
              glossaryRefs: [
                GlossaryRef(
                  'darkvision',
                  'Scurovisione',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GLOSSARIO'), findsOneWidget);
    expect(find.text('Scurovisione'), findsOneWidget);

    await tester.tap(find.text('Scurovisione'));
    await tester.pumpAndSettle();

    expect(find.byType(GlossaryEntryPage), findsOneWidget);
    expect(find.text('REGOLA IN BREVE'), findsOneWidget);
  });
}
