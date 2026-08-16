import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('spell detail casts the spell and consumes its slot',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    final hero = HeroData(
      name: 'Mago di prova',
      classId: ClassIds.wizard,
      baseScores: const {
        'FOR': 8,
        'DES': 14,
        'COS': 14,
        'INT': 16,
        'SAG': 12,
        'CAR': 10,
      },
      knownSpellIds: const ['magic_missile'],
    );

    final spellName = spellDefinitions['magic_missile']!.content.name;

    await tester.pumpWidget(
      MaterialApp(home: SheetPage(hero: hero)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Magia'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('INCANTESIMI DI LIVELLO 1'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('INCANTESIMI DI LIVELLO 1'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(spellName),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(spellName));
    await tester.pumpAndSettle();

    expect(find.text('LANCIA INCANTESIMO'), findsOneWidget);

    await tester.ensureVisible(find.text('LANCIA INCANTESIMO'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LANCIA INCANTESIMO'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Slot di livello 1'));
    await tester.pumpAndSettle();

    expect(hero.spellSlots['1'], 1);
    expect(tester.takeException(), isNull);
  });
}
