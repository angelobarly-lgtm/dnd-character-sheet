import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'nuova scheda mostra CA Iniziativa Velocità e Percezione passiva',
    (tester) async {
      final hero = HeroData(
        name: 'Guerriero riepilogo',
        classId: ClassIds.fighter,
        raceId: RaceIds.tiefling,
        level: 5,
        baseScores: const {
          'FOR': 13,
          'DES': 14,
          'COS': 14,
          'INT': 10,
          'SAG': 14,
          'CAR': 10,
        },
        skillProficiencies: const ['Percezione'],
        inventory: const [
          {
            'id': 'chain_mail',
            'name': 'Cotta di maglia',
            'catalogId': 'armor',
            'quantity': 1,
            'equipped': true,
          },
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SheetPage(hero: hero),
        ),
      );
      await tester.pumpAndSettle();

      const acKey = Key('official_ac_value');
      const initiativeKey = Key('official_initiative_value');
      const speedKey = Key('official_speed_value');
      const passiveKey = Key('official_passive_perception_value');

      // La Percezione passiva si trova sopra il riepilogo di combattimento.
      await tester.scrollUntilVisible(
        find.byKey(passiveKey),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(passiveKey), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(passiveKey)).data, '15');

      // CA, Iniziativa e Velocità si trovano nel blocco immediatamente sotto.
      await tester.scrollUntilVisible(
        find.byKey(acKey),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(acKey), findsOneWidget);
      expect(find.byKey(initiativeKey), findsOneWidget);
      expect(find.byKey(speedKey), findsOneWidget);

      expect(tester.widget<Text>(find.byKey(acKey)).data, '16');
      expect(tester.widget<Text>(find.byKey(initiativeKey)).data, '+2');
      expect(tester.widget<Text>(find.byKey(speedKey)).data, '9.0');
    },
  );
}
