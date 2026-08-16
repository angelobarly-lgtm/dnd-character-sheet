import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kaelScores = <String, int>{
  'FOR': 10,
  'DES': 16,
  'COS': 14,
  'INT': 12,
  'SAG': 16,
  'CAR': 8,
};

HeroData createKael() {
  final hero = HeroData(
    name: 'Kael',
    baseScores: kaelScores,
    level: 5,
    hpRolls: const [7, 6, 7, 6],
    currentHp: 24,
    tempHp: 3,
    ki: 4,
    playerName: 'Giocatore',
    alignment: 'Legale Buono',
    experiencePoints: 6500,
    personalityTraits: 'Riflette prima di agire.',
    ideals: 'Conoscenza.',
    bonds: 'Il monastero.',
    flaws: 'Eccessivamente prudente.',
    skillProficiencies: const ['Acrobazia', 'Percezione'],
  );

  return hero;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'official 2014 sheet fits a mobile screen',
    (tester) async {
      final hero = createKael();

      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(home: SheetPage(hero: hero)),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('official_character_sheet')),
        findsOneWidget,
      );
      expect(find.text('DUNGEONS & DRAGONS'), findsOneWidget);
      expect(
        find.text('SCHEDA DEL PERSONAGGIO · 5E 2014'),
        findsOneWidget,
      );
      expect(find.text('KAEL'), findsOneWidget);
      expect(find.text('Monaco 5'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(const Key('official_hit_points_panel')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('PUNTI FERITA'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hit points remain directly editable',
    (tester) async {
      final hero = createKael();

      await tester.pumpWidget(
        MaterialApp(home: SheetPage(hero: hero)),
      );
      await tester.pumpAndSettle();

      expect(hero.currentHp, 24);

      await tester.scrollUntilVisible(
        find.byKey(const Key('official_hp_minus')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('official_hp_minus')),
      );
      await tester.pumpAndSettle();

      expect(hero.currentHp, 23);

      await tester.tap(
        find.byKey(const Key('official_hp_plus')),
      );
      await tester.pumpAndSettle();

      expect(hero.currentHp, 24);
    },
  );

  testWidgets(
    'death saving throw circles remain tappable',
    (tester) async {
      final hero = createKael();

      await tester.pumpWidget(
        MaterialApp(home: SheetPage(hero: hero)),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('official_death_success_2')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('official_death_success_2')),
      );
      await tester.pumpAndSettle();

      expect(hero.deathSuccess, 2);

      await tester.tap(
        find.byKey(const Key('official_death_failure_1')),
      );
      await tester.pumpAndSettle();

      expect(hero.deathFail, 1);
    },
  );

  testWidgets(
    'long secondary sections are collapsed on mobile',
    (tester) async {
      final hero = createKael();

      await tester.pumpWidget(
        MaterialApp(home: SheetPage(hero: hero)),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('official_saves_skills_section')),
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('official_saves_skills_section')),
        findsOneWidget,
      );
      expect(find.text('Acrobazia'), findsNothing);

      await tester.tap(find.text('TIRI SALVEZZA E ABILITÀ'));
      await tester.pumpAndSettle();

      expect(find.text('Acrobazia'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
