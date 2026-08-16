import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 12,
  'INT': 10,
  'SAG': 14,
  'CAR': 10,
};

void main() {
  test('Ki e dado marziale usano solo livelli da Monaco', () {
    final hero = HeroData(
      name: 'Guerriero Monaco',
      classId: ClassIds.fighter,
      level: 8,
      classLevels: const {
        ClassIds.fighter: 3,
        ClassIds.monk: 5,
      },
      baseScores: scores,
    );

    expect(hero.maxKi, 5);
    expect(hero.martialDie, 'd6');
  });

  test('classe secondaria usa una chiave risorsa separata', () {
    final hero = HeroData(
      name: 'Risorse',
      classId: ClassIds.fighter,
      level: 5,
      classLevels: const {
        ClassIds.fighter: 3,
        ClassIds.monk: 2,
      },
      baseScores: scores,
    );

    hero.setClassResourceValueForClass(
      ClassIds.monk,
      'ki',
      2,
    );

    expect(hero.classResources['${ClassIds.monk}:ki'], 2);
    expect(
      hero.classResourceValueForClass(ClassIds.monk, 'ki'),
      2,
    );
    expect(hero.ki, 0);
  });

  test('Monaco principale conserva il campo ki legacy', () {
    final hero = HeroData(
      name: 'Monaco',
      classId: ClassIds.monk,
      level: 4,
      baseScores: scores,
    );

    hero.setClassResourceValueForClass(
      ClassIds.monk,
      'ki',
      3,
    );

    expect(hero.classResources['ki'], 3);
    expect(hero.ki, 3);
    expect(hero.classResourceValue('ki'), 3);
  });

  test('acquisizione ASI conserva la classe sorgente', () {
    const acquisition = FeatAcquisition(
      instanceId: 'fighter_asi_6',
      featId: FeatIds.alert,
      source: 'asi',
      sourceClassId: ClassIds.fighter,
      acquiredAtLevel: 8,
    );

    final restored = FeatAcquisition.fromJson(
      acquisition.toJson(),
    );

    expect(restored.sourceClassId, ClassIds.fighter);
    expect(restored.acquiredAtLevel, 8);
  });

  test('vecchie acquisizioni senza classe restano valide', () {
    final restored = FeatAcquisition.fromJson({
      'instanceId': 'legacy',
      'featId': FeatIds.mobile,
      'source': 'asi',
      'acquiredAtLevel': 4,
      'selections': <String, List<String>>{},
    });

    expect(restored.sourceClassId, isNull);
    expect(restored.featId, FeatIds.mobile);
  });

  test('sincronizzazione inizializza risorsa di classe secondaria', () {
    final hero = HeroData(
      name: 'Monaco secondario',
      classId: ClassIds.fighter,
      level: 3,
      classLevels: const {
        ClassIds.fighter: 1,
        ClassIds.monk: 2,
      },
      baseScores: scores,
    );

    synchronizeHeroClassProgression(
      hero,
      oldLevel: 1,
      progressionClassId: ClassIds.monk,
      newLevel: 2,
      synchronizeSpellSlots: false,
    );

    expect(
      hero.classResourceValueForClass(
        ClassIds.monk,
        'ki',
      ),
      2,
    );
    expect(hero.ki, 0);
  });
}
