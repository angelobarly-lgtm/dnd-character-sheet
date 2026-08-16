import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const normalScores = <String, int>{
  'FOR': 10,
  'DES': 14,
  'COS': 14,
  'INT': 14,
  'SAG': 12,
  'CAR': 10,
};

HeroData createHero({
  String classId = ClassIds.fighter,
  String? raceId,
  Map<String, List<String>> raceChoices = const {},
  List<FeatAcquisition> featAcquisitions = const [],
  Map<String, int> scores = normalScores,
}) {
  return HeroData(
    name: 'Test ASI',
    classId: classId,
    level: 4,
    raceId: raceId,
    raceChoices: raceChoices,
    baseScores: scores,
    featAcquisitions: featAcquisitions,
  );
}

Future<void> openFeatMode(WidgetTester tester) async {
  await tester.tap(find.text('Scegli un talento'));
  await tester.pump();
}

Future<void> selectFeat(
  WidgetTester tester,
  String featId,
) async {
  final finder = find.byKey(Key('asi_feat_$featId'));

  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();

  final details = find.byKey(const Key('asi_feat_details'));

  await tester.scrollUntilVisible(
    details,
    450,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> confirmSelection(WidgetTester tester) async {
  final finder = find.byKey(const Key('asi_confirm_selection'));

  await tester.scrollUntilVisible(
    finder,
    450,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  testWidgets(
    'ogni razza conserva i talenti precedenti e ne acquisisce altri con ASI',
    (tester) async {
      final hero = createHero(
        raceId: HumanVariantIds.variant,
        raceChoices: const {
          'human_variant_feat': [FeatIds.alert],
        },
      );

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);
      await selectFeat(tester, FeatIds.mobile);
      await confirmSelection(tester);

      expect(hero.resolvedFeatIds, contains(FeatIds.alert));
      expect(hero.resolvedFeatIds, contains(FeatIds.mobile));
      expect(hero.featAcquisitions, hasLength(1));
      expect(hero.featAcquisitions.single.source, 'asi');
      expect(hero.featAcquisitions.single.acquiredAtLevel, 4);
    },
  );

  testWidgets(
    'un requisito mancante è rosso e impedisce acquisizione',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);
      await selectFeat(tester, FeatIds.grappler);

      expect(
        find.text('Requisiti non soddisfatti'),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('asi_feat_details')),
          matching: find.byIcon(Icons.cancel),
        ),
        findsWidgets,
      );

      await confirmSelection(tester);

      expect(hero.featAcquisitions, isEmpty);
      expect(
        find.text(
          'Non possiedi tutti i requisiti per questo talento.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'un requisito posseduto è mostrato in verde',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);
      await selectFeat(tester, FeatIds.heavyArmorMaster);

      expect(find.text('Requisiti soddisfatti'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('asi_feat_details')),
          matching: find.byIcon(Icons.check_circle),
        ),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'talento senza prerequisiti non mostra indicatori verdi o rossi',
    (tester) async {
      final hero = createHero();

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);
      await selectFeat(tester, FeatIds.lucky);

      expect(find.text('Requisiti soddisfatti'), findsNothing);
      expect(find.text('Requisiti non soddisfatti'), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('asi_feat_details')),
          matching: find.byIcon(Icons.check_circle),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('asi_feat_details')),
          matching: find.byIcon(Icons.cancel),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'talento normale già posseduto è disabilitato',
    (tester) async {
      final hero = createHero(
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'mobile_l4',
            featId: FeatIds.mobile,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);

      final finder = find.byKey(
        Key('asi_feat_${FeatIds.mobile}'),
      );

      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();

      final tile = tester.widget<RadioListTile<String>>(finder);

      expect(tile.enabled, isFalse);
      expect(find.text('Già acquisito'), findsOneWidget);
    },
  );

  testWidgets(
    'Esperto Elementale salva la scelta nella singola acquisizione',
    (tester) async {
      final hero = createHero(classId: ClassIds.wizard);

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      await openFeatMode(tester);
      await selectFeat(tester, FeatIds.elementalAdept);

      final acidChoice = find.byKey(
        const Key(
          'asi_feat_choice_elemental_adept_damage_type_acid',
        ),
      );

      await tester.scrollUntilVisible(
        acidChoice,
        350,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(acidChoice);
      await tester.pump();

      await confirmSelection(tester);

      expect(hero.featAcquisitions, hasLength(1));
      expect(
        hero.featAcquisitions.single.selections['elemental_adept_damage_type'],
        ['acid'],
      );
    },
  );

  testWidgets(
    'aumento di caratteristica ASI non supera 20',
    (tester) async {
      final hero = createHero(
        scores: const {
          'FOR': 19,
          'DES': 14,
          'COS': 14,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
      );

      await tester.pumpWidget(
        MaterialApp(home: AsiPage(hero: hero)),
      );

      final dropdown = find.byType(DropdownButtonFormField<String>).first;

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('FOR ·').last);
      await tester.pump();

      await confirmSelection(tester);

      expect(hero.baseScores['FOR'], 20);
    },
  );
}
