import 'package:dnd_character_sheet/data/barbarian_class_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final barbarian = phbClassDefinitions[ClassIds.barbarian]!;

  test('PHB Barbarian base catalog is structurally complete', () {
    expect(barbarian.id, ClassIds.barbarian);
    expect(barbarian.hitDie, 12);
    expect(barbarian.proficiencies.savingThrows, {'FOR', 'COS'});
    expect(barbarian.subclassSelectionLevel, 3);
    expect(barbarian.resources.single.id, 'rage');
    expect(barbarian.featureDefinitions, hasLength(14));

    final granted =
        barbarian.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(14));
    expect(
      granted.difference(
        barbarian.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );
  });

  test('all Barbarian content has editorial metadata', () {
    expect(barbarian.content.source.isEmpty, isFalse);
    expect(
      barbarian.content.description.summary.trim(),
      isNotEmpty,
    );
    expect(
      barbarian.content.description.details.trim(),
      isNotEmpty,
    );

    for (final entry in barbarian.featureDefinitions.entries) {
      final content = entry.value.content;

      expect(content.id, entry.key);
      expect(content.ownerId, ClassIds.barbarian);
      expect(content.source.isEmpty, isFalse);
      expect(content.description.summary.trim(), isNotEmpty);
      expect(content.description.details.trim(), isNotEmpty);
    }
  });

  test('Barbarian starting equipment resolves to PHB catalogs', () {
    for (final choice in barbarian.startingEquipmentChoices) {
      expect(choice.alternatives, isNotEmpty);

      for (final alternative in choice.alternatives) {
        expect(alternative.grants, isNotEmpty);

        for (final grant in alternative.grants) {
          expect(grant.catalogId, 'weapon');
          expect(
            weaponDefinitions,
            contains(grant.itemId),
            reason: 'Arma iniziale mancante: ${grant.itemId}',
          );
          expect(grant.quantity, greaterThan(0));
        }
      }
    }

    for (final grant in barbarian.fixedStartingEquipment) {
      switch (grant.catalogId) {
        case 'weapon':
          expect(weaponDefinitions, contains(grant.itemId));
        case 'equipment_pack':
          expect(
            equipmentPackDefinitions,
            contains(grant.itemId),
          );
        default:
          fail('Catalogo non riconosciuto: ${grant.catalogId}');
      }
    }
  });

  test('Rage and progressive values cover levels 1 through 20', () {
    final rage = barbarian.resources.singleWhere(
      (resource) => resource.id == 'rage',
    );

    for (var level = 1; level <= 20; level++) {
      expect(
        rage.maximumAtLevel(level),
        greaterThan(0),
        reason: 'Ira assente al livello $level',
      );
      expect(
        barbarian.progressionValue('rage_damage', level),
        isNotNull,
        reason: 'Danno dell’Ira assente al livello $level',
      );
    }

    expect(rage.isUnlimitedAtLevel(19), isFalse);
    expect(rage.isUnlimitedAtLevel(20), isTrue);

    for (var level = 9; level <= 20; level++) {
      expect(
        barbarian.progressionValue(
          'brutal_critical_dice',
          level,
        ),
        isNotNull,
        reason: 'Critico Brutale assente al livello $level',
      );
    }
  });

  test('both PHB Primal Paths are structurally complete', () {
    expect(
      barbarian.phbSubclasses.map((subclass) => subclass.id).toSet(),
      {
        BarbarianSubclassIds.berserker,
        BarbarianSubclassIds.totemWarrior,
      },
    );
    expect(barbarian.phbSubclasses, hasLength(2));
    expect(barbarian.supplementalSubclasses, isEmpty);

    for (final subclass in barbarian.phbSubclasses) {
      expect(subclass.classId, ClassIds.barbarian);
      expect(subclass.content.source.isEmpty, isFalse);
      expect(
        subclass.content.description.summary.trim(),
        isNotEmpty,
      );
      expect(
        subclass.content.description.details.trim(),
        isNotEmpty,
      );

      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();

      expect(
        granted.difference(
          subclass.featureDefinitions.keys.toSet(),
        ),
        isEmpty,
        reason: 'Privilegio non registrato in ${subclass.id}',
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final content = entry.value.content;

        expect(content.id, entry.key);
        expect(content.ownerId, subclass.id);
        expect(content.source.isEmpty, isFalse);
      }
    }
  });

  test('Totem Warrior has nine coherent choices', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(totem.options, hasLength(9));
    expect(
      totem.options.map((option) => option.id).toSet(),
      hasLength(9),
    );

    final expectedLevels = {
      'totem_spirit': 3,
      'aspect_of_the_beast': 6,
      'totemic_attunement': 14,
    };

    for (final entry in expectedLevels.entries) {
      final tier = totem.options
          .where((option) => option.category == entry.key)
          .toList();

      expect(tier, hasLength(3));
      expect(
        tier.every(
          (option) => option.minimumLevel == entry.value,
        ),
        isTrue,
      );
    }

    final progression = totem.optionProgression!;

    expect(progression.selectionsAtLevel(3), 1);
    expect(progression.selectionsAtLevel(6), 2);
    expect(progression.selectionsAtLevel(14), 3);
    expect(progression.selectionsAtLevel(20), 3);
  });

  test('Totem ritual features expose canonical spell IDs', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(
      totem.featureDefinitions['spirit_seeker']!.spellIds,
      {
        'beast_sense',
        'speak_with_animals',
      },
    );
    expect(
      totem.featureDefinitions['spirit_walker']!.spellIds,
      {
        'commune_with_nature',
      },
    );

    expect(
      totem.featureDefinitions.values
          .expand((feature) => feature.spellIds)
          .toSet(),
      {
        'beast_sense',
        'speak_with_animals',
        'commune_with_nature',
      },
    );
  });

  test('Barbarian rules contain no imperial measurements', () {
    final descriptions = <String>[
      barbarian.content.description.summary,
      barbarian.content.description.details,
      for (final feature in barbarian.featureDefinitions.values)
        feature.content.description.details,
      for (final subclass in barbarian.phbSubclasses) ...[
        subclass.content.description.details,
        for (final feature in subclass.featureDefinitions.values)
          feature.content.description.details,
        for (final option in subclass.options) option.description.details,
      ],
    ];

    final imperialPattern = RegExp(
      r'\b(feet|foot|ft|mile|miles|lb|lbs|pound|pounds)\b',
      caseSensitive: false,
    );

    expect(
      descriptions.where(imperialPattern.hasMatch),
      isEmpty,
    );
  });

  test('universal class registry now contains Monk and Barbarian', () {
    expect(
      phbClassDefinitions.keys.toSet(),
      {
        ClassIds.barbarian,
        ClassIds.monk,
      },
    );
  });
}
