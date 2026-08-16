import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:dnd_character_sheet/widgets/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const uiScores = <String, int>{
  'FOR': 16,
  'DES': 12,
  'COS': 14,
  'INT': 10,
  'SAG': 14,
  'CAR': 8,
};

HeroData createFighter() => HeroData(
      name: 'Guerriero UI',
      classId: ClassIds.fighter,
      level: 5,
      baseScores: uiScores,
      equippedWeapon: 'greatsword',
      inventory: const [
        {
          'id': 'greatsword',
          'name': 'Spadone',
          'catalogId': 'weapon',
          'quantity': 1,
          'equipped': true,
        },
      ],
      classChoices: const {
        'fighter_fighter_skills': [
          'acrobatics',
          'perception',
        ],
      },
    );

void main() {
  testWidgets(
    'portamonete modifica cinque tagli senza conversione',
    (tester) async {
      Map<String, int>? savedCoins;

      await tester.pumpWidget(
        MaterialApp(
          home: ShopPage(
            coins: const {
              'MR': 1,
              'MA': 2,
              'ME': 3,
              'MO': 10,
              'MP': 5,
            },
            inventory: const [],
            onChanged: (coins, inventory) async {
              savedCoins = Map<String, int>.from(coins);
            },
          ),
        ),
      );

      await tester.tap(find.text('MODIFICA'));
      await tester.pumpAndSettle();

      final fields = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );

      expect(fields, findsNWidgets(5));

      await tester.enterText(fields.at(3), '42');
      await tester.tap(find.text('SALVA'));
      await tester.pumpAndSettle();

      expect(savedCoins, isNotNull);
      expect(savedCoins!['MR'], 1);
      expect(savedCoins!['MA'], 2);
      expect(savedCoins!['ME'], 3);
      expect(savedCoins!['MO'], 42);
      expect(savedCoins!['MP'], 5);
    },
  );

  testWidgets(
    'Guerriero mostra salvezza e abilità corrette',
    (tester) async {
      final fighter = createFighter();

      await tester.pumpWidget(
        MaterialApp(
          home: SheetPage(hero: fighter),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('official_saves_skills_section')),
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.text('TIRI SALVEZZA E ABILITÀ'),
      );
      await tester.pumpAndSettle();

      final strengthSave = find.byKey(
        const Key('official_save_FOR'),
      );
      final dexteritySave = find.byKey(
        const Key('official_save_DES'),
      );
      final acrobatics = find.byKey(
        const Key('official_skill_acrobatics'),
      );
      final perception = find.byKey(
        const Key('official_skill_perception'),
      );

      expect(strengthSave, findsOneWidget);
      expect(dexteritySave, findsOneWidget);
      expect(acrobatics, findsOneWidget);
      expect(perception, findsOneWidget);

      expect(
        find.descendant(
          of: strengthSave,
          matching: find.byIcon(Icons.circle),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: dexteritySave,
          matching: find.byIcon(Icons.circle_outlined),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: acrobatics,
          matching: find.byIcon(Icons.circle),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: perception,
          matching: find.byIcon(Icons.circle),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'click sullo Spadone tira attacco e danno 2d6',
    (tester) async {
      final fighter = createFighter();

      await tester.pumpWidget(
        MaterialApp(
          home: SheetPage(hero: fighter),
        ),
      );
      await tester.pumpAndSettle();

      final attack = find.byKey(
        const Key('official_primary_attack'),
      );

      await tester.scrollUntilVisible(
        attack,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Spadone'), findsOneWidget);
      expect(
        find.textContaining('2d6+3 Tagliente · FOR'),
        findsOneWidget,
      );

      await tester.tap(attack);
      await tester.pumpAndSettle();

      expect(find.text('NORMALE'), findsOneWidget);

      await tester.tap(find.text('NORMALE'));
      await tester.pumpAndSettle();

      expect(
        find.text('Attacco · Spadone · FOR'),
        findsOneWidget,
      );
      expect(find.textContaining('TOTALE'), findsOneWidget);

      await tester.tap(find.text('CHIUDI'));
      await tester.pumpAndSettle();

      expect(find.text('Danno · Spadone'), findsOneWidget);
      expect(find.textContaining('🎲 2d6 →'), findsOneWidget);
      expect(find.textContaining('DANNI '), findsOneWidget);

      await tester.tap(find.text('CHIUDI'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
