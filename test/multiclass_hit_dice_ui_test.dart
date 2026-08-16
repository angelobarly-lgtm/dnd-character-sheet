import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 13,
  'COS': 14,
  'INT': 14,
  'SAG': 10,
  'CAR': 10,
};

HeroData createHero() => HeroData(
      name: 'Dadi Vita UI',
      baseScores: scores,
      level: 3,
      classId: ClassIds.fighter,
      classLevels: const {
        ClassIds.fighter: 2,
        ClassIds.wizard: 1,
      },
    );

void main() {
  testWidgets(
    'dialogo permette di scegliere Dadi Vita di classi diverse',
    (tester) async {
      final hero = createHero();
      Map<String, int>? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                key: const Key('open_hit_dice_dialog'),
                onPressed: () async {
                  result = await showDialog<Map<String, int>>(
                    context: context,
                    builder: (_) => MulticlassHitDiceDialog(hero: hero),
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('open_hit_dice_dialog')),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Guerriero · 2d10 disponibili'),
        findsOneWidget,
      );
      expect(
        find.text('Mago · 1d6 disponibili'),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const Key('hit_die_add_fighter')),
      );
      await tester.tap(
        find.byKey(const Key('hit_die_add_wizard')),
      );
      await tester.pump();

      expect(find.text('TIRA 2 DADI VITA'), findsOneWidget);

      await tester.tap(
        find.byKey(
          const Key('confirm_multiclass_hit_dice'),
        ),
      );
      await tester.pumpAndSettle();

      expect(result, {
        ClassIds.fighter: 1,
        ClassIds.wizard: 1,
      });
    },
  );

  testWidgets(
    'dialogo disabilita i Dadi Vita già esauriti',
    (tester) async {
      final hero = HeroData(
        name: 'Dadi esauriti',
        baseScores: scores,
        level: 3,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 2,
          ClassIds.wizard: 1,
        },
        hitDiceUsedByClass: const {
          ClassIds.wizard: 1,
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MulticlassHitDiceDialog(hero: hero),
        ),
      );

      final wizardButton = tester.widget<IconButton>(
        find.byKey(const Key('hit_die_add_wizard')),
      );

      expect(wizardButton.onPressed, isNull);
    },
  );
}
