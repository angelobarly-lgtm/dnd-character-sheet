import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/multiclass_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 13,
  'DES': 13,
  'COS': 14,
  'INT': 16,
  'SAG': 16,
  'CAR': 16,
};

HeroData heroWithClasses(
  Map<String, int> classLevels, {
  Map<String, String> subclasses = const {},
  Map<String, int> spellSlots = const {},
  int pactSpellSlots = -1,
}) {
  return HeroData(
    name: 'Incantatore multiclasse',
    baseScores: baseScores,
    level: classLevels.values.fold(0, (a, b) => a + b),
    classId: classLevels.keys.first,
    classLevels: classLevels,
    classSubclasses: subclasses,
    spellSlots: spellSlots,
    pactSpellSlots: pactSpellSlots,
  );
}

void main() {
  group('Slot multiclasse PHB 2014', () {
    test('Mago 3 e Chierico 2 usano la tabella da incantatore 5', () {
      final hero = heroWithClasses({
        ClassIds.wizard: 3,
        ClassIds.cleric: 2,
      });

      expect(
        multiclassSpellcasterLevel(
          classLevels: hero.effectiveClassLevels,
        ),
        5,
      );
      expect(maximumSpellSlotsForHero(hero), [4, 3, 2]);
    });

    test('Paladino 5 e Ranger 3 contribuiscono per metà arrotondata', () {
      final hero = heroWithClasses({
        ClassIds.paladin: 5,
        ClassIds.ranger: 3,
      });

      expect(
        multiclassSpellcasterLevel(
          classLevels: hero.effectiveClassLevels,
        ),
        3,
      );
      expect(maximumSpellSlotsForHero(hero), [4, 2]);
    });

    test('Cavaliere Mistico e Mago sommano un terzo e livello pieno', () {
      final hero = heroWithClasses(
        {
          ClassIds.fighter: 6,
          ClassIds.wizard: 2,
        },
        subclasses: const {
          ClassIds.fighter: 'eldritch_knight',
        },
      );

      expect(
        multiclassSpellcasterLevel(
          classLevels: hero.effectiveClassLevels,
          classSubclasses: heroSpellcastingSubclasses(hero),
        ),
        4,
      );
      expect(maximumSpellSlotsForHero(hero), [4, 3]);
    });

    test('una sola classe magica conserva la propria progressione', () {
      final hero = heroWithClasses({
        ClassIds.paladin: 5,
        ClassIds.fighter: 2,
      });

      expect(maximumSpellSlotsForHero(hero), [4, 2]);
    });

    test('Warlock mantiene separati slot ordinari e slot del Patto', () {
      final hero = heroWithClasses({
        ClassIds.wizard: 2,
        ClassIds.warlock: 3,
      });

      expect(maximumSpellSlotsForHero(hero), [3]);
      expect(pactSlotMaximumForHero(hero), 2);
      expect(pactSlotLevelForHero(hero), 2);
    });

    test('aumento capacità non ripristina gli slot già consumati', () {
      final hero = heroWithClasses(
        {ClassIds.wizard: 2},
        spellSlots: const {'1': 2},
      );

      final oldMaximum = maximumSpellSlotsForHero(hero);
      final oldPactMaximum = pactSlotMaximumForHero(hero);

      hero.classLevels = {ClassIds.wizard: 3};
      hero.level = 3;

      synchronizeCombinedSpellSlots(
        hero,
        oldMaximumSlots: oldMaximum,
        oldPactMaximum: oldPactMaximum,
      );

      expect(hero.spellSlots, {'1': 3, '2': 2});
    });

    test('aumento Warlock preserva gli slot del Patto consumati', () {
      final hero = heroWithClasses(
        {ClassIds.warlock: 2},
        pactSpellSlots: 1,
      );

      final oldMaximum = maximumSpellSlotsForHero(hero);
      final oldPactMaximum = pactSlotMaximumForHero(hero);

      hero.classLevels = {ClassIds.warlock: 3};
      hero.level = 3;

      synchronizeCombinedSpellSlots(
        hero,
        oldMaximumSlots: oldMaximum,
        oldPactMaximum: oldPactMaximum,
      );

      expect(hero.pactSpellSlots, 1);
      expect(pactSlotMaximumForHero(hero), 2);
      expect(pactSlotLevelForHero(hero), 2);
    });

    test('JSON conserva gli slot del Patto e carica i vecchi salvataggi', () {
      final hero = heroWithClasses(
        {
          ClassIds.wizard: 2,
          ClassIds.warlock: 3,
        },
        spellSlots: const {'1': 2},
        pactSpellSlots: 1,
      );

      final restored = HeroData.fromJson(hero.toJson());
      expect(restored.pactSpellSlots, 1);

      final legacyJson = Map<String, dynamic>.from(hero.toJson())
        ..remove('pactSpellSlots');

      final legacy = HeroData.fromJson(legacyJson);
      expect(legacy.currentPactSpellSlots, 2);
    });
  });
}
