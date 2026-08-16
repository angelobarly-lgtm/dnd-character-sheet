import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('official details page edits Kael physical data', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final hero = HeroData(
      name: 'Kael',
      baseScores: const {
        'FOR': 10,
        'DES': 16,
        'COS': 14,
        'INT': 12,
        'SAG': 16,
        'CAR': 8,
      },
    );

    await tester.pumpWidget(
      MaterialApp(home: SheetPage(hero: hero)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dettagli'));
    await tester.pumpAndSettle();

    expect(find.text('DETTAGLI DEL PERSONAGGIO · 5E 2014'), findsOneWidget);
    expect(find.text('Età'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Età'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Età'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '28');
    await tester.tap(find.text('SALVA'));
    await tester.pumpAndSettle();

    expect(hero.age, '28');
    expect(find.text('28'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
