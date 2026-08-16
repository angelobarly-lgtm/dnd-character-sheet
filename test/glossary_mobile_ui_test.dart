import 'package:dnd_character_sheet/data/glossary_registry_data.dart';
import 'package:dnd_character_sheet/widgets/glossary_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _fixtureEntries = {
  'advantage': GlossaryEntry(
    id: 'advantage',
    name: 'Vantaggio',
    aliases: {'vantaggi'},
    category: GlossaryCategory.regola,
    summary: 'Tira due d20 e utilizza il risultato più alto.',
    details:
        'Il Vantaggio non si somma più volte. Se sono presenti anche fonti '
        'di Svantaggio, le due regole si annullano.',
    sections: [
      GlossarySectionDefinition(
        id: 'example',
        title: 'Esempio',
        type: GlossarySectionType.example,
        content: 'Con Vantaggio, un risultato di 8 e uno di 15 producono 15.',
        numericValues: {'dice': 2},
      ),
    ],
    relatedIds: ['disadvantage'],
    sources: [
      GlossarySourceDefinition(
        book: 'Manuale del Giocatore',
        edition: '2014',
        reference: 'Vantaggio e Svantaggio',
        pageStart: 173,
      ),
    ],
  ),
  'disadvantage': GlossaryEntry(
    id: 'disadvantage',
    name: 'Svantaggio',
    category: GlossaryCategory.regola,
    summary: 'Tira due d20 e utilizza il risultato più basso.',
    relatedIds: ['advantage'],
  ),
};

void main() {
  testWidgets('linked glossary terms are blue and tappable', (tester) async {
    GlossaryEntry? opened;

    Iterable<TextSpan> nestedTextSpans(InlineSpan span) sync* {
      if (span is! TextSpan) return;

      yield span;

      for (final child in span.children ?? const <InlineSpan>[]) {
        yield* nestedTextSpans(child);
      }
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlossaryLinkedText(
            text: 'Vantaggio',
            entries: _fixtureEntries,
            onOpenEntry: (entry) {
              opened = entry;
            },
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(
      find.byType(RichText).last,
    );

    final linked = nestedTextSpans(richText.text).firstWhere(
      (span) => span.recognizer is TapGestureRecognizer,
    );

    expect(linked.text, 'Vantaggio');
    expect(linked.style?.color, isNotNull);
    expect(linked.style?.decoration, TextDecoration.underline);
    expect(linked.recognizer, isA<TapGestureRecognizer>());

    (linked.recognizer! as TapGestureRecognizer).onTap!();

    expect(opened?.id, 'advantage');
  });

  testWidgets('entry page keeps summary visible and details collapsed',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GlossaryEntryPage(
          entry: _fixtureEntries['advantage']!,
          entries: _fixtureEntries,
        ),
      ),
    );

    expect(find.text('Vantaggio'), findsWidgets);
    expect(find.text('REGOLA IN BREVE'), findsOneWidget);
    expect(
      find.text('Tira due d20 e utilizza il risultato più alto.'),
      findsOneWidget,
    );
    expect(find.text('Regola completa'), findsOneWidget);
    expect(find.text('Esempio'), findsOneWidget);
    expect(find.text('Voci correlate (1)'), findsOneWidget);
    expect(find.text('Fonti (1)'), findsOneWidget);

    expect(
      find.textContaining('Il Vantaggio non si somma'),
      findsNothing,
    );

    await tester.tap(find.text('Regola completa'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Il Vantaggio non si somma'),
      findsOneWidget,
    );
  });

  testWidgets('index search finds entries without opening letter sections',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GlossaryIndexPage(entries: _fixtureEntries),
      ),
    );

    expect(find.text('Glossario'), findsOneWidget);
    expect(find.text('2 voci'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('glossary_search_field')),
      'risultato più basso',
    );
    await tester.pumpAndSettle();

    expect(find.text('1 voce'), findsOneWidget);
    expect(find.text('Svantaggio'), findsOneWidget);
    expect(
      find.text('Tira due d20 e utilizza il risultato più basso.'),
      findsOneWidget,
    );
  });

  testWidgets('related entries preserve normal mobile back navigation',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GlossaryEntryPage(
          entry: _fixtureEntries['advantage']!,
          entries: _fixtureEntries,
        ),
      ),
    );

    await tester.tap(find.text('Voci correlate (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Svantaggio'));
    await tester.pumpAndSettle();

    expect(find.byType(GlossaryEntryPage), findsOneWidget);
    expect(find.text('Svantaggio'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Vantaggio'), findsWidgets);
  });

  testWidgets('source section is collapsed and mobile friendly',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GlossaryEntryPage(
          entry: _fixtureEntries['advantage']!,
          entries: _fixtureEntries,
        ),
      ),
    );

    expect(find.text('Manuale del Giocatore · 2014'), findsNothing);

    await tester.tap(find.text('Fonti (1)'));
    await tester.pumpAndSettle();

    expect(
      find.text('Manuale del Giocatore · 2014'),
      findsOneWidget,
    );
    expect(
      find.textContaining('p. 173'),
      findsOneWidget,
    );
  });
}
