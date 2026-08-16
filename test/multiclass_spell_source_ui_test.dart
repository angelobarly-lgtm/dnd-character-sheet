import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 12,
  'COS': 14,
  'INT': 16,
  'SAG': 14,
  'CAR': 10,
};

HeroData createHero() => HeroData(
      name: 'Classi magiche UI',
      baseScores: scores,
      level: 5,
      classId: ClassIds.wizard,
      classLevels: const {
        ClassIds.wizard: 3,
        ClassIds.cleric: 2,
      },
    );

void main() {
  testWidgets(
    'dialogo mostra tutte le classi magiche e le statistiche corrette',
    (tester) async {
      final hero = createHero();
      String? selectedClass;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                key: const Key('open_spell_class_dialog'),
                onPressed: () async {
                  selectedClass = await showDialog<String>(
                    context: context,
                    builder: (_) => SpellcastingClassDialog(hero: hero),
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(
          const Key('open_spell_class_dialog'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mago'), findsOneWidget);
      expect(find.text('Chierico'), findsOneWidget);
      expect(
        find.textContaining('INT · livello classe 3'),
        findsOneWidget,
      );
      expect(
        find.textContaining('SAG · livello classe 2'),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(
          const Key('spellcasting_class_cleric'),
        ),
      );
      await tester.pumpAndSettle();

      expect(selectedClass, ClassIds.cleric);
    },
  );
}
