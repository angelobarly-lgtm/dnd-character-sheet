import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/multiclass_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 12,
  'INT': 13,
  'SAG': 13,
  'CAR': 13,
};

void main() {
  test('Guerriero multiclasse non concede armatura pesante', () {
    final hero = HeroData(
      name: 'Mago Guerriero',
      classId: ClassIds.wizard,
      level: 2,
      classLevels: const {
        ClassIds.wizard: 1,
        ClassIds.fighter: 1,
      },
      baseScores: scores,
    );

    expect(
      hero.effectiveArmorProficiencies,
      containsAll(<String>{
        'light_armor',
        'medium_armor',
        'shield',
      }),
    );
    expect(
      hero.effectiveArmorProficiencies,
      isNot(contains('heavy_armor')),
    );
    expect(
      hero.effectiveWeaponProficiencies,
      containsAll(<String>{
        'simple_weapons',
        'martial_weapons',
      }),
    );
  });

  test('Barbaro multiclasse concede solo scudi e armi', () {
    expect(
      multiclassArmorProficienciesFor(ClassIds.barbarian),
      {'shield'},
    );
    expect(
      multiclassWeaponProficienciesFor(ClassIds.barbarian),
      {
        'simple_weapons',
        'martial_weapons',
      },
    );
  });

  test('Ladro concede armatura armi strumenti e abilità scelta', () {
    final hero = HeroData(
      name: 'Guerriero Ladro',
      classId: ClassIds.fighter,
      level: 2,
      classLevels: const {
        ClassIds.fighter: 1,
        ClassIds.rogue: 1,
      },
      classChoices: const {
        'multiclass_rogue_skills': ['stealth'],
      },
      baseScores: scores,
    );

    expect(
      hero.effectiveArmorProficiencies,
      contains('light_armor'),
    );
    expect(
      hero.effectiveWeaponProficiencies,
      contains('rapier'),
    );
    expect(
      hero.effectiveToolProficiencies,
      isNotEmpty,
    );
    expect(
      hero.effectiveSkillProficiencies,
      contains('Furtività'),
    );

    expect(
      hero.effectiveSavingThrowProficiencies,
      isNot(contains('INT')),
    );
  });

  test('Bardo richiede una abilità e uno strumento', () {
    expect(multiclassSkillChoicesFor(ClassIds.bard), 1);
    expect(multiclassToolChoicesFor(ClassIds.bard), 1);
    expect(
      multiclassSkillOptionsFor(ClassIds.bard),
      isNotEmpty,
    );
    expect(
      multiclassToolOptionsFor(ClassIds.bard),
      isNotEmpty,
    );
  });

  test('Ranger e Ladro richiedono una abilità', () {
    expect(multiclassSkillChoicesFor(ClassIds.ranger), 1);
    expect(multiclassSkillChoicesFor(ClassIds.rogue), 1);
    expect(multiclassToolChoicesFor(ClassIds.ranger), 0);
    expect(multiclassToolChoicesFor(ClassIds.rogue), 0);
  });
}
