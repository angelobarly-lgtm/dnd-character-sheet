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

HeroData createCaster({
  Map<String, int> slots = const {},
  int pactSlots = 2,
}) =>
    HeroData(
      name: 'Lancio multiclasse',
      baseScores: scores,
      level: 6,
      classId: ClassIds.wizard,
      classLevels: const {
        ClassIds.wizard: 3,
        ClassIds.warlock: 3,
      },
      spellSlots: slots,
      pactSpellSlots: pactSlots,
    );

void main() {
  group('Lancio con slot multiclasse', () {
    test('mostra gli slot ordinari utilizzabili', () {
      final hero = createCaster(
        slots: const {'1': 2, '2': 1},
      );

      expect(
        availableNormalSpellSlotLevels(
          hero,
          minimumLevel: 1,
        ),
        [1, 2],
      );

      expect(
        availableNormalSpellSlotLevels(
          hero,
          minimumLevel: 2,
        ),
        [2],
      );
    });

    test('slot del Patto può lanciare fino al proprio livello', () {
      final hero = createCaster();

      expect(
        canUsePactSlotForSpell(hero, spellLevel: 1),
        isTrue,
      );
      expect(
        canUsePactSlotForSpell(hero, spellLevel: 2),
        isTrue,
      );
      expect(
        canUsePactSlotForSpell(hero, spellLevel: 3),
        isFalse,
      );
    });

    test('consumare slot ordinario non modifica quelli del Patto', () {
      final hero = createCaster(
        slots: const {'1': 2, '2': 1},
      );

      expect(
        spendNormalSpellSlot(hero, slotLevel: 1),
        isTrue,
      );
      expect(hero.spellSlots['1'], 1);
      expect(hero.pactSpellSlots, 2);
    });

    test('consumare slot del Patto non modifica quelli ordinari', () {
      final hero = createCaster(
        slots: const {'1': 2, '2': 1},
      );

      expect(spendPactSpellSlot(hero), isTrue);
      expect(hero.pactSpellSlots, 1);
      expect(hero.spellSlots, {'1': 2, '2': 1});
    });

    test('uno slot esaurito non può essere consumato ancora', () {
      final hero = createCaster(
        slots: const {'1': 0, '2': 0},
        pactSlots: 0,
      );

      expect(
        spendNormalSpellSlot(hero, slotLevel: 1),
        isFalse,
      );
      expect(spendPactSpellSlot(hero), isFalse);
    });
  });
}
