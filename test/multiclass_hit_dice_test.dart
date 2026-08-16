import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 13,
  'COS': 14,
  'INT': 14,
  'SAG': 10,
  'CAR': 10,
};

HeroData createHero({
  Map<String, int> used = const {},
  int legacyUsed = 0,
}) =>
    HeroData(
      name: 'Dadi Vita multiclasse',
      baseScores: scores,
      level: 3,
      classId: ClassIds.fighter,
      classLevels: const {
        ClassIds.fighter: 2,
        ClassIds.wizard: 1,
      },
      hitDiceUsed: legacyUsed,
      hitDiceUsedByClass: used,
    );

void main() {
  group('Dadi Vita multiclasse', () {
    test('ogni classe conserva quantità e dado corretti', () {
      final hero = createHero();

      expect(hero.hitDiceAvailableForClass(ClassIds.fighter), 2);
      expect(hero.hitDiceAvailableForClass(ClassIds.wizard), 1);
      expect(hero.hitDieForClass(ClassIds.fighter), 10);
      expect(hero.hitDieForClass(ClassIds.wizard), 6);
      expect(hero.hitDiceAvailable, 3);
      expect(hero.hitDicePoolLabel, '2d10 · 1d6');
      expect(hero.availableHitDiceBySize, {10: 2, 6: 1});
    });

    test('spesa resta separata per classe', () {
      final hero = createHero();

      hero.spendHitDice(ClassIds.fighter, 1);
      hero.spendHitDice(ClassIds.wizard, 1);

      expect(hero.hitDiceUsedForClass(ClassIds.fighter), 1);
      expect(hero.hitDiceUsedForClass(ClassIds.wizard), 1);
      expect(hero.hitDiceAvailableForClass(ClassIds.fighter), 1);
      expect(hero.hitDiceAvailableForClass(ClassIds.wizard), 0);
      expect(hero.hitDiceUsed, 2);
      expect(hero.hitDicePoolLabel, '1d10 · 0d6');
    });

    test('non è possibile spendere più dadi del disponibile', () {
      final hero = createHero();

      expect(
        () => hero.spendHitDice(ClassIds.wizard, 2),
        throwsStateError,
      );
    });

    test('recupero rispetta il limite e aggiorna il totale legacy', () {
      final hero = createHero(
        used: const {
          ClassIds.fighter: 2,
          ClassIds.wizard: 1,
        },
      );

      final recovered = hero.recoverHitDice(1);

      expect(recovered, 1);
      expect(hero.hitDiceUsed, 2);
      expect(hero.hitDiceUsedForClass(ClassIds.fighter), 1);
      expect(hero.hitDiceUsedForClass(ClassIds.wizard), 1);
    });

    test('JSON conserva i dadi spesi per classe', () {
      final hero = createHero(
        used: const {
          ClassIds.fighter: 1,
          ClassIds.wizard: 1,
        },
      );

      final restored = HeroData.fromJson(hero.toJson());

      expect(
        restored.effectiveHitDiceUsedByClass,
        {
          ClassIds.fighter: 1,
          ClassIds.wizard: 1,
        },
      );
      expect(restored.hitDiceUsed, 2);
    });

    test('salvataggio legacy assegna i dadi spesi alla classe primaria', () {
      final hero = createHero(legacyUsed: 2);

      expect(
        hero.effectiveHitDiceUsedByClass,
        {ClassIds.fighter: 2},
      );

      final restored = HeroData.fromJson(hero.toJson());

      expect(
        restored.effectiveHitDiceUsedByClass,
        {ClassIds.fighter: 2},
      );
    });
  });
}
