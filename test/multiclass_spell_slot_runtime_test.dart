import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 12,
  'COS': 14,
  'INT': 16,
  'SAG': 14,
  'CAR': 16,
};

HeroData createHero({
  required Map<String, int> classes,
  Map<String, int> slots = const {},
  int pactSlots = -1,
}) =>
    HeroData(
      name: 'Slot runtime',
      baseScores: scores,
      level: classes.values.fold(0, (a, b) => a + b),
      classId: classes.keys.first,
      classLevels: classes,
      spellSlots: slots,
      pactSpellSlots: pactSlots,
    );

void main() {
  group('Runtime slot multiclasse', () {
    test('riposo breve recupera solo gli slot del Patto', () {
      final hero = createHero(
        classes: {
          ClassIds.wizard: 3,
          ClassIds.warlock: 3,
        },
        slots: const {'1': 1, '2': 0},
        pactSlots: 0,
      );

      restoreHeroPactSpellSlots(hero);

      expect(hero.spellSlots, {'1': 1, '2': 0});
      expect(hero.pactSpellSlots, 2);
    });

    test('riposo lungo recupera tutti gli slot', () {
      final hero = createHero(
        classes: {
          ClassIds.wizard: 3,
          ClassIds.warlock: 3,
        },
        slots: const {'1': 0, '2': 0},
        pactSlots: 0,
      );

      restoreAllHeroSpellSlots(hero);

      expect(hero.spellSlots, {'1': 4, '2': 2});
      expect(hero.pactSpellSlots, 2);
    });

    test('Warlock puro conserva soltanto gli slot del Patto', () {
      final hero = createHero(
        classes: {ClassIds.warlock: 5},
        slots: const {'3': 2},
      );

      restoreAllHeroSpellSlots(hero);

      expect(hero.spellSlots, isEmpty);
      expect(hero.pactSpellSlots, 2);
      expect(pactSlotLevelForHero(hero), 3);
    });

    test('senza Warlock gli slot del Patto sono zero', () {
      final hero = createHero(
        classes: {ClassIds.wizard: 5},
        pactSlots: 4,
      );

      restoreAllHeroSpellSlots(hero);

      expect(hero.pactSpellSlots, 0);
      expect(pactSlotMaximumForHero(hero), 0);
    });
  });
}
