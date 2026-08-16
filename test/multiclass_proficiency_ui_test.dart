import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 12,
  'INT': 13,
  'SAG': 13,
  'CAR': 13,
};

HeroData createHero({
  List<String> skills = const [],
}) =>
    HeroData(
      name: 'Test competenze',
      classId: ClassIds.fighter,
      level: 1,
      baseScores: scores,
      skillProficiencies: skills,
    );

void main() {
  testWidgets(
    'Ladro permette di scegliere una abilità',
    (tester) async {
      Map<String, List<String>>? result;
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                key: const Key('open_choices'),
                onPressed: () async {
                  result = await showMulticlassProficiencyDialog(
                    context: context,
                    hero: hero,
                    classId: ClassIds.rogue,
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('open_choices')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('multiclass_skill_choice_stealth'),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(
          const Key('multiclass_confirm_proficiencies'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        result?['multiclass_rogue_skills'],
        ['stealth'],
      );
    },
  );

  testWidgets(
    'Bardo richiede abilità e strumento',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showMulticlassProficiencyDialog(
                    context: context,
                    hero: hero,
                    classId: ClassIds.bard,
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('APRI'));
      await tester.pumpAndSettle();

      FilledButton confirmButton() => tester.widget<FilledButton>(
            find.byKey(
              const Key(
                'multiclass_confirm_proficiencies',
              ),
            ),
          );

      expect(confirmButton().onPressed, isNull);

      await tester.tap(
        find.byKey(
          const Key('multiclass_skill_choice_arcana'),
        ),
      );
      await tester.pump();

      expect(confirmButton().onPressed, isNull);

      final tools = find.byWidgetPredicate(
        (widget) =>
            widget is FilterChip &&
            widget.key?.toString().contains('multiclass_tool_choice_') == true,
      );

      expect(tools, findsWidgets);
      await tester.tap(tools.first);
      await tester.pump();

      expect(confirmButton().onPressed, isNotNull);
    },
  );

  testWidgets(
    'abilità già posseduta viene esclusa',
    (tester) async {
      final hero = createHero(
        skills: const ['Furtività'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showMulticlassProficiencyDialog(
                    context: context,
                    hero: hero,
                    classId: ClassIds.rogue,
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('APRI'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('multiclass_skill_choice_stealth'),
        ),
        findsNothing,
      );
    },
  );
}
