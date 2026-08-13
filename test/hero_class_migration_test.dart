import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 10,
  'DES': 16,
  'COS': 14,
  'INT': 10,
  'SAG': 16,
  'CAR': 8,
};

void main() {
  test('legacy saves migrate to monk without losing ki', () {
    final hero = HeroData.fromJson({
      'name': 'Monaco legacy',
      'baseScores': baseScores,
      'level': 5,
      'ki': 4,
    });

    expect(hero.classId, ClassIds.monk);
    expect(hero.resolvedClassName, 'Monaco');
    expect(hero.classResourceValue('ki'), 4);

    final json = hero.toJson();

    expect(json['classId'], ClassIds.monk);
    expect((json['classResources'] as Map)['ki'], 4);
  });

  test('new saves preserve a generic class and its resources', () {
    final hero = HeroData(
      name: 'Guerriero',
      baseScores: baseScores,
      classId: ClassIds.fighter,
      classResources: const {
        'second_wind': 1,
        'action_surge': 1,
      },
    );

    final restored = HeroData.fromJson(hero.toJson());

    expect(restored.classId, ClassIds.fighter);
    expect(restored.classResourceValue('second_wind'), 1);
    expect(restored.classResourceValue('action_surge'), 1);
  });

  test('generic resource editing preserves unrelated resources', () {
    final hero = HeroData(
      name: 'Bardo',
      baseScores: baseScores,
      classId: ClassIds.bard,
      classResources: const {
        'bardic_inspiration': 2,
        'other_resource': 1,
      },
    );

    hero.setClassResourceValue('bardic_inspiration', 4);

    expect(hero.classResourceValue('bardic_inspiration'), 4);
    expect(hero.classResourceValue('other_resource'), 1);
  });

  test('ki remains synchronized during the transition', () {
    final hero = HeroData(
      name: 'Monaco',
      baseScores: baseScores,
      classId: ClassIds.monk,
      ki: 3,
    );

    hero.setClassResourceValue('ki', 7);

    expect(hero.ki, 7);
    expect(hero.classResourceValue('ki'), 7);
    expect((hero.toJson()['classResources'] as Map)['ki'], 7);
  });

  test('negative class resources are rejected', () {
    final hero = HeroData(
      name: 'Personaggio',
      baseScores: baseScores,
    );

    expect(
      () => hero.setClassResourceValue('ki', -1),
      throwsArgumentError,
    );
  });
}
