import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/multiclass_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 12,
  'DES': 13,
  'COS': 12,
  'INT': 12,
  'SAG': 9,
  'CAR': 10,
};

HeroData createHero({
  String classId = ClassIds.monk,
  int level = 3,
  Map<String, int>? classLevels,
  Map<String, int> scores = baseScores,
}) {
  return HeroData(
    name: 'Test multiclasse',
    classId: classId,
    level: level,
    classLevels: classLevels ?? {classId: level},
    baseScores: scores,
  );
}

Future<void> selectClass(
  WidgetTester tester,
  String classId, {
  required bool newClass,
}) async {
  final classTile = find.byKey(
    Key('multiclass_class_$classId'),
  );

  await tester.ensureVisible(classTile);
  await tester.pumpAndSettle();
  await tester.tap(classTile);
  await tester.pump();

  final details = newClass
      ? find.byKey(
          const Key('multiclass_eligibility_summary'),
        )
      : find.byKey(
          const Key('multiclass_existing_class_message'),
        );

  await tester.scrollUntilVisible(
    details,
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> tapConfirm(WidgetTester tester) async {
  final confirm = find.byKey(
    const Key('multiclass_confirm_class'),
  );

  await tester.scrollUntilVisible(
    confirm,
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(confirm);
  await tester.pumpAndSettle();
}

void main() {
  test('ASI dipende dal livello della singola classe', () {
    for (final classId in phb2014AsiClassLevels.keys) {
      expect(classReceivesAsiAtLevel(classId, 4), isTrue);
      expect(classReceivesAsiAtLevel(classId, 8), isTrue);
    }

    expect(
      classReceivesAsiAtLevel(ClassIds.fighter, 6),
      isTrue,
    );
    expect(
      classReceivesAsiAtLevel(ClassIds.fighter, 14),
      isTrue,
    );
    expect(
      classReceivesAsiAtLevel(ClassIds.rogue, 10),
      isTrue,
    );

    expect(
      classReceivesAsiAtLevel(ClassIds.wizard, 6),
      isFalse,
    );
    expect(
      classReceivesAsiAtLevel(ClassIds.rogue, 14),
      isFalse,
    );
  });

  testWidgets(
    'requisiti della classe attuale e nuova sono verdi o rossi separatamente',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(
          home: MulticlassLevelUpPage(hero: hero),
        ),
      );

      await selectClass(
        tester,
        ClassIds.rogue,
        newClass: true,
      );

      expect(
        find.text('Alcuni requisiti non sono soddisfatti'),
        findsOneWidget,
      );

      final monkCard = find.byKey(
        const Key('multiclass_requirements_monk'),
      );
      final rogueCard = find.byKey(
        const Key('multiclass_requirements_rogue'),
      );

      expect(monkCard, findsOneWidget);
      expect(rogueCard, findsOneWidget);

      expect(
        find.descendant(
          of: monkCard,
          matching: find.byIcon(Icons.check_circle),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: monkCard,
          matching: find.byIcon(Icons.cancel),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: rogueCard,
          matching: find.byIcon(Icons.check_circle),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'nuova classe non valida resta bloccata',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(
          home: MulticlassLevelUpPage(hero: hero),
        ),
      );

      await selectClass(
        tester,
        ClassIds.rogue,
        newClass: true,
      );
      await tapConfirm(tester);

      expect(
        find.text(
          'Non possiedi tutti i requisiti per il multiclasse.',
        ),
        findsOneWidget,
      );
      expect(
        find.byType(MulticlassLevelUpPage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'classe nuova valida viene restituita dalla pagina',
    (tester) async {
      final hero = createHero(
        classId: ClassIds.fighter,
        scores: const {
          'FOR': 12,
          'DES': 13,
          'COS': 12,
          'INT': 12,
          'SAG': 10,
          'CAR': 10,
        },
      );

      String? selectedClass;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                key: const Key('open_multiclass_page'),
                onPressed: () async {
                  selectedClass = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MulticlassLevelUpPage(hero: hero),
                    ),
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('open_multiclass_page')),
      );
      await tester.pumpAndSettle();

      await selectClass(
        tester,
        ClassIds.wizard,
        newClass: true,
      );

      expect(
        find.text('Tutti i requisiti sono soddisfatti'),
        findsOneWidget,
      );

      await tapConfirm(tester);

      expect(selectedClass, ClassIds.wizard);
    },
  );

  testWidgets(
    'classe già posseduta può avanzare senza requisiti multiclasse',
    (tester) async {
      final hero = createHero();

      String? selectedClass;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                key: const Key('open_existing_class_page'),
                onPressed: () async {
                  selectedClass = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MulticlassLevelUpPage(hero: hero),
                    ),
                  );
                },
                child: const Text('APRI'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('open_existing_class_page')),
      );
      await tester.pumpAndSettle();

      await selectClass(
        tester,
        ClassIds.monk,
        newClass: false,
      );

      expect(
        find.byKey(
          const Key('multiclass_existing_class_message'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('multiclass_eligibility_summary'),
        ),
        findsNothing,
      );

      await tapConfirm(tester);

      expect(selectedClass, ClassIds.monk);
    },
  );
}
