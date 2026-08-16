import 'dart:math';

import 'package:dnd_character_sheet/data/background_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const testScores = <String, int>{
  'FOR': 16,
  'DES': 12,
  'COS': 14,
  'INT': 10,
  'SAG': 14,
  'CAR': 8,
};

void main() {
  test('bonus competenza segue tutte le fasce PHB 2014', () {
    const expected = <int, int>{
      1: 2,
      4: 2,
      5: 3,
      8: 3,
      9: 4,
      12: 4,
      13: 5,
      16: 5,
      17: 6,
      20: 6,
    };

    for (final entry in expected.entries) {
      expect(
        V06Rules.proficiencyBonus(entry.key),
        entry.value,
        reason: 'Livello ${entry.key}',
      );
    }
  });

  test('modificatori negativi dispari usano arrotondamento corretto', () {
    expect(V06Rules.abilityMod(9), -1);
    expect(V06Rules.abilityMod(7), -2);
    expect(V06Rules.abilityMod(3), -4);
    expect(V06Rules.abilityMod(10), 0);
    expect(V06Rules.abilityMod(16), 3);
  });

  test('tutti i background assegnano le MO iniziali corrette', () {
    const expected = <String, int>{
      BackgroundIds.acolyte: 15,
      BackgroundIds.guildArtisan: 15,
      BackgroundIds.guildMerchant: 15,
      BackgroundIds.charlatan: 15,
      BackgroundIds.criminal: 15,
      BackgroundIds.spy: 15,
      BackgroundIds.hermit: 5,
      BackgroundIds.folkHero: 10,
      BackgroundIds.outlander: 10,
      BackgroundIds.entertainer: 15,
      BackgroundIds.gladiator: 15,
      BackgroundIds.sailor: 10,
      BackgroundIds.pirate: 10,
      BackgroundIds.urchin: 10,
      BackgroundIds.noble: 25,
      BackgroundIds.knight: 25,
      BackgroundIds.sage: 10,
      BackgroundIds.soldier: 10,
    };

    expect(backgroundDefinitions, hasLength(expected.length));

    for (final entry in expected.entries) {
      final background = backgroundDefinitions[entry.key];

      expect(background, isNotNull);
      expect(
        background!.startingCoins['MO'],
        entry.value,
        reason: background.name,
      );
    }
  });

  test('ID abilità delle classi diventano competenze italiane', () {
    final fighter = HeroData(
      name: 'Guerriero',
      classId: ClassIds.fighter,
      baseScores: testScores,
      classChoices: const {
        'fighter_fighter_skills': [
          'acrobatics',
          'perception',
        ],
      },
    );

    expect(
      fighter.effectiveSkillProficiencies,
      containsAll([
        'Acrobazia',
        'Percezione',
      ]),
    );

    expect(
      fighter.effectiveSkillProficiencies,
      isNot(contains('acrobatics')),
    );
  });

  test('armi complete usano FOR DES dado e competenza corretti', () {
    final fighter = HeroData(
      name: 'Guerriero',
      classId: ClassIds.fighter,
      level: 5,
      baseScores: testScores,
    );

    expect(weaponDisplayNameFor('greatsword'), 'Spadone');
    expect(weaponDamageDiceFor(fighter, 'greatsword'), '2d6');
    expect(weaponDamageTypeFor('greatsword'), 'Tagliente');
    expect(weaponAbilityFor(fighter, 'greatsword'), 'FOR');
    expect(weaponIsProficientFor(fighter, 'greatsword'), isTrue);
    expect(weaponAttackBonusFor(fighter, 'greatsword'), 6);

    expect(weaponAbilityFor(fighter, 'longbow'), 'DES');
    expect(weaponDamageDiceFor(fighter, 'longbow'), '1d8');
    expect(weaponAttackBonusFor(fighter, 'longbow'), 4);
  });

  test('armi accurate scelgono il valore migliore tra FOR e DES', () {
    final rogue = HeroData(
      name: 'Ladro',
      classId: ClassIds.rogue,
      level: 5,
      baseScores: const {
        'FOR': 10,
        'DES': 16,
        'COS': 12,
        'INT': 14,
        'SAG': 10,
        'CAR': 12,
      },
    );

    expect(weaponAbilityFor(rogue, 'rapier'), 'DES');
    expect(weaponDamageDiceFor(rogue, 'rapier'), '1d8');
    expect(weaponIsProficientFor(rogue, 'rapier'), isTrue);
    expect(weaponAttackBonusFor(rogue, 'rapier'), 6);
  });

  test('armi non competenti non ricevono il bonus competenza', () {
    final wizard = HeroData(
      name: 'Mago',
      classId: ClassIds.wizard,
      level: 5,
      baseScores: testScores,
    );

    expect(weaponIsProficientFor(wizard, 'greatsword'), isFalse);
    expect(weaponAttackBonusFor(wizard, 'greatsword'), 3);

    expect(weaponIsProficientFor(wizard, 'dagger'), isTrue);
    expect(weaponAttackBonusFor(wizard, 'dagger'), 6);
  });

  test('dado Arti Marziali si applica soltanto al Monaco', () {
    final monk = HeroData(
      name: 'Monaco',
      classId: ClassIds.monk,
      level: 11,
      baseScores: const {
        'FOR': 10,
        'DES': 16,
        'COS': 14,
        'INT': 10,
        'SAG': 16,
        'CAR': 8,
      },
    );

    expect(weaponAbilityFor(monk, 'quarterstaff'), 'DES');
    expect(weaponDamageDiceFor(monk, 'quarterstaff'), '1d8');
    expect(weaponDamageDiceFor(monk, 'Colpo senz’armi'), '1d8');

    final fighter = HeroData(
      name: 'Guerriero',
      classId: ClassIds.fighter,
      level: 20,
      baseScores: testScores,
    );

    expect(weaponDamageDiceFor(fighter, 'dagger'), '1d4');
    expect(weaponAbilityFor(fighter, 'Colpo senz’armi'), 'FOR');
    expect(weaponIsProficientFor(fighter, 'Colpo senz’armi'), isTrue);
    expect(weaponDamageDiceFor(fighter, 'Colpo senz’armi'), '1d4');
  });

  test('motore danni tira espressioni singole multiple e fisse', () {
    final random = Random(42);

    expect(rollDamageExpression('1', random), 1);

    for (var index = 0; index < 20; index++) {
      expect(
        rollDamageExpression('1d8', random),
        inInclusiveRange(1, 8),
      );

      expect(
        rollDamageExpression('2d6', random),
        inInclusiveRange(2, 12),
      );
    }
  });
}
