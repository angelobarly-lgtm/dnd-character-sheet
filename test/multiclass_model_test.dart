import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 12,
  'INT': 14,
  'SAG': 13,
  'CAR': 10,
};

void main() {
  test('salvataggio legacy usa classe principale e livello totale', () {
    final hero = HeroData(
      name: 'Legacy',
      classId: ClassIds.fighter,
      level: 5,
      baseScores: scores,
    );

    expect(
      hero.effectiveClassLevels,
      {ClassIds.fighter: 5},
    );
    expect(hero.primaryClassLevel, 5);
    expect(hero.totalClassLevels, 5);
    expect(hero.isMulticlass, isFalse);
    expect(hero.classLevelsMatchCharacterLevel, isTrue);
  });

  test('personaggio multiclasse conserva livelli separati', () {
    final hero = HeroData(
      name: 'Multiclasse',
      classId: ClassIds.fighter,
      level: 5,
      classLevels: const {
        ClassIds.fighter: 3,
        ClassIds.wizard: 2,
      },
      baseScores: scores,
    );

    expect(hero.classLevel(ClassIds.fighter), 3);
    expect(hero.classLevel(ClassIds.wizard), 2);
    expect(hero.classLevel(ClassIds.rogue), 0);
    expect(hero.totalClassLevels, 5);
    expect(hero.activeClassIds, {
      ClassIds.fighter,
      ClassIds.wizard,
    });
    expect(hero.isMulticlass, isTrue);
    expect(hero.classLevelsMatchCharacterLevel, isTrue);
  });

  test('JSON conserva tutti i livelli di classe', () {
    final original = HeroData(
      name: 'Round trip',
      classId: ClassIds.monk,
      level: 6,
      classLevels: const {
        ClassIds.monk: 4,
        ClassIds.rogue: 2,
      },
      baseScores: scores,
    );

    final restored = HeroData.fromJson(original.toJson());

    expect(restored.level, 6);
    expect(restored.classId, ClassIds.monk);
    expect(restored.classLevels, {
      ClassIds.monk: 4,
      ClassIds.rogue: 2,
    });
    expect(restored.effectiveClassLevels, {
      ClassIds.monk: 4,
      ClassIds.rogue: 2,
    });
    expect(restored.classLevelsMatchCharacterLevel, isTrue);
  });

  test('JSON precedente senza classLevels resta compatibile', () {
    final source = HeroData(
      name: 'Vecchio salvataggio',
      classId: ClassIds.wizard,
      level: 7,
      baseScores: scores,
    );

    final legacyJson = Map<String, dynamic>.from(source.toJson())
      ..remove('classLevels');

    final restored = HeroData.fromJson(legacyJson);

    expect(restored.classLevels, isEmpty);
    expect(
      restored.effectiveClassLevels,
      {ClassIds.wizard: 7},
    );
    expect(restored.primaryClassLevel, 7);
    expect(restored.isMulticlass, isFalse);
  });

  test('incoerenza tra totale e livelli di classe è rilevabile', () {
    final hero = HeroData(
      name: 'Incoerente',
      classId: ClassIds.fighter,
      level: 6,
      classLevels: const {
        ClassIds.fighter: 3,
        ClassIds.wizard: 2,
      },
      baseScores: scores,
    );

    expect(hero.totalClassLevels, 5);
    expect(hero.classLevelsMatchCharacterLevel, isFalse);
  });
}
