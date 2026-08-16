import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 13,
  'COS': 14,
  'INT': 14,
  'SAG': 10,
  'CAR': 10,
};

Future<void> scrollTo(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.scrollUntilVisible(
    finder,
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> selectWizard(
  WidgetTester tester,
) async {
  final wizard = find.byKey(
    const Key('multiclass_class_wizard'),
  );

  await scrollTo(tester, wizard);
  await tester.tap(wizard);
  await tester.pumpAndSettle();

  final summary = find.byKey(
    const Key('multiclass_eligibility_summary'),
  );

  await scrollTo(tester, summary);

  expect(
    find.text('Tutti i requisiti sono soddisfatti'),
    findsOneWidget,
  );

  final confirm = find.byKey(
    const Key('multiclass_confirm_class'),
  );

  await scrollTo(tester, confirm);
  await tester.tap(confirm);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'level-up completo aggiunge una nuova classe e aggiorna tutta la scheda',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final hero = HeroData(
        name: 'Guerriero Mago',
        baseScores: scores,
        level: 2,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 2,
        },
        currentHp: 20,
        spellSlots: const {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SheetPage(hero: hero),
        ),
      );
      await tester.pumpAndSettle();

      final restSection = find.byKey(
        const Key('official_rest_section'),
      );

      await scrollTo(tester, restSection);
      await tester.tap(restSection);
      await tester.pumpAndSettle();

      final levelUpButton = find.text('SALI AL LIVELLO 3');
      await scrollTo(tester, levelUpButton);
      await tester.tap(levelUpButton);
      await tester.pumpAndSettle();

      expect(
        find.byType(MulticlassLevelUpPage),
        findsOneWidget,
      );

      await selectWizard(tester);

      expect(find.byType(HpDialog), findsOneWidget);
      expect(find.text('VALORE MEDIO DEL d6'), findsOneWidget);
      expect(find.text('USA VALORE MEDIO +4'), findsOneWidget);

      await tester.tap(find.text('USA VALORE MEDIO +4'));
      await tester.pumpAndSettle();

      expect(find.text('Mago 1'), findsWidgets);
      expect(
        find.textContaining('Avanzamento completato.'),
        findsOneWidget,
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(hero.level, 3);
      expect(hero.classLevel(ClassIds.fighter), 2);
      expect(hero.classLevel(ClassIds.wizard), 1);
      expect(hero.totalClassLevels, 3);
      expect(hero.classLevelsMatchCharacterLevel, isTrue);
      expect(hero.resolvedClassLevelLabel, 'Guerriero 2 · Mago 1');

      expect(hero.hpRolls, hasLength(1));
      expect(hero.hpRolls.single, 6);

      expect(
        hero.resolvedClassFeatures.any(
          (feature) => feature.ownerClassId == ClassIds.fighter,
        ),
        isTrue,
      );
      expect(
        hero.resolvedClassFeatures.any(
          (feature) => feature.ownerClassId == ClassIds.wizard,
        ),
        isTrue,
      );

      expect(maximumSpellSlotsForHero(hero), [2]);
      expect(hero.spellSlots, {'1': 2});
      expect(hero.pactSpellSlots, 0);

      List<HeroData> savedHeroes = const [];

      await tester.runAsync(() async {
        savedHeroes = await Store.loadAll();
      });

      expect(savedHeroes, isNotEmpty);

      final restored = savedHeroes.firstWhere(
        (saved) => saved.name == hero.name,
      );

      expect(restored.level, 3);
      expect(restored.classLevel(ClassIds.fighter), 2);
      expect(restored.classLevel(ClassIds.wizard), 1);
      expect(restored.resolvedClassLevelLabel, 'Guerriero 2 · Mago 1');
    },
  );
}
