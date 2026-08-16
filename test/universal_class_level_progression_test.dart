import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

HeroData heroFor(String classId, {int level = 1}) => HeroData(
      name: 'Progressione',
      classId: classId,
      level: level,
      baseScores: const {
        'FOR': 10,
        'DES': 16,
        'COS': 14,
        'INT': 16,
        'SAG': 16,
        'CAR': 16,
      },
    );

void main() {
  test('all twelve classes synchronize resources safely', () {
    for (final definition in phbClassDefinitions.values) {
      final hero = heroFor(definition.id);
      hero.classResources = buildClassResourcesAtLevel(
        classDefinition: definition,
        level: 1,
      );

      hero.level = 2;

      expect(
        () => synchronizeHeroClassProgression(
          hero,
          oldLevel: 1,
        ),
        returnsNormally,
        reason: definition.name,
      );

      for (final resource in definition.resources) {
        if (resource.minimumLevel == 2 && !resource.isUnlimitedAtLevel(2)) {
          expect(
            hero.classResources,
            contains(resource.id),
            reason: '${definition.name}: ${resource.id}',
          );
        }
      }
    }
  });

  test('new slot capacity is added without restoring spent slots', () {
    final wizard = phbClassDefinitions.values.firstWhere(
      (definition) =>
          definition.spellcasting?.progression ==
          ClassSpellcastingProgression.full,
    );

    final hero = heroFor(wizard.id)
      ..spellSlots = {'1': 1}
      ..level = 2;

    final oldMaximum = wizard.spellcasting!.slotsAtLevel(1).first;
    final newMaximum = wizard.spellcasting!.slotsAtLevel(2).first;

    synchronizeHeroClassProgression(hero, oldLevel: 1);

    expect(
      hero.spellSlots['1'],
      1 + (newMaximum - oldMaximum),
    );
  });

  test('subclass always-prepared spells are added automatically', () {
    for (final definition in phbClassDefinitions.values) {
      for (final subclass in definition.subclasses.values) {
        final spells = subclass.alwaysPreparedSpellIdsAtLevel(2);
        if (spells.isEmpty) continue;

        final hero = heroFor(definition.id)
          ..subclass = subclass.id
          ..level = 2;

        synchronizeHeroClassProgression(hero, oldLevel: 1);

        expect(hero.preparedSpellIds, containsAll(spells));
        return;
      }
    }
  });
}
