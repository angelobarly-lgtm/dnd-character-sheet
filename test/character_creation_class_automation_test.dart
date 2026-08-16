import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all PHB classes initialize level-one resources correctly', () {
    expect(phbClassDefinitions, hasLength(12));

    for (final definition in phbClassDefinitions.values) {
      final resources = buildClassResourcesAtLevel(
        classDefinition: definition,
        level: 1,
        abilityModifiers: const {
          'FOR': 0,
          'DES': 0,
          'COS': 0,
          'INT': 0,
          'SAG': 0,
          'CAR': 0,
        },
      );

      for (final resource in definition.resources) {
        if (resource.minimumLevel > 1 || resource.isUnlimitedAtLevel(1)) {
          expect(resources.containsKey(resource.id), isFalse);
          continue;
        }

        expect(resources, contains(resource.id));
        expect(
          resources[resource.id],
          resource.maximumAtLevel(
            1,
            abilityModifiers: const {
              'FOR': 0,
              'DES': 0,
              'COS': 0,
              'INT': 0,
              'SAG': 0,
              'CAR': 0,
            },
          ),
        );
      }
    }
  });

  test('all PHB classes initialize level-one spell slots correctly', () {
    for (final definition in phbClassDefinitions.values) {
      final actual = buildSpellSlotsAtLevel(
        classDefinition: definition,
        level: 1,
      );

      final expectedSlots =
          definition.spellcasting?.slotsAtLevel(1) ?? const <int>[];

      final expected = {
        for (var index = 0; index < expectedSlots.length; index++)
          if (expectedSlots[index] > 0) '${index + 1}': expectedSlots[index],
      };

      expect(
        actual,
        expected,
        reason: definition.name,
      );
    }
  });

  test('level-one spell choices fit every official class list', () {
    for (final definition in phbClassDefinitions.values) {
      final spellcasting = definition.spellcasting;
      if (spellcasting == null || spellcasting.minimumLevel > 1) {
        continue;
      }

      final classSpells = spellcasting.spellIds
          .map((id) => spellDefinitions[id])
          .whereType<SpellDefinition>()
          .toList();

      final cantrips = classSpells.where((spell) => spell.level == 0).length;
      final firstLevel = classSpells.where((spell) => spell.level == 1).length;

      expect(
        cantrips,
        greaterThanOrEqualTo(
          spellcasting.cantripsKnownAtLevel(1),
        ),
        reason: '${definition.name}: trucchetti',
      );

      expect(
        firstLevel,
        greaterThanOrEqualTo(
          spellcasting.spellsKnownAtLevel(1),
        ),
        reason: '${definition.name}: incantesimi conosciuti',
      );

      final spellbook = definition.spellbook;
      if (spellbook != null) {
        final eligibleBookSpells = classSpells
            .where(
              (spell) =>
                  spell.level > 0 && spell.level <= spellbook.initialSpellLevel,
            )
            .length;

        expect(
          eligibleBookSpells,
          greaterThanOrEqualTo(spellbook.initialSpells),
          reason: '${definition.name}: libro iniziale',
        );
      }

      if (spellcasting.preparesSpells) {
        final prepared = spellcasting.preparedSpellsAtLevel(
          1,
          abilityModifiers: const {
            'FOR': 0,
            'DES': 0,
            'COS': 0,
            'INT': 0,
            'SAG': 0,
            'CAR': 0,
          },
        );

        expect(
          firstLevel,
          greaterThanOrEqualTo(prepared),
          reason: '${definition.name}: preparazione',
        );
      }
    }
  });

  test('legacy saves keep Monk and empty universal choices', () {
    final hero = HeroData.fromJson({
      'name': 'Legacy',
      'baseScores': {
        'FOR': 10,
        'DES': 10,
        'COS': 10,
        'INT': 10,
        'SAG': 10,
        'CAR': 10,
      },
    });

    expect(hero.classId, 'monk');
    expect(hero.classChoices, isEmpty);
  });
}
