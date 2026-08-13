import 'package:dnd_character_sheet/data/barbarian_class_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final barbarian = phbClassDefinitions[ClassIds.barbarian]!;

  test('Barbarian is registered with its PHB core identity', () {
    expect(barbarian.id, ClassIds.barbarian);
    expect(barbarian.name, 'Barbaro');
    expect(barbarian.hitDie, 12);
    expect(barbarian.subclassSelectionLevel, 3);
    expect(barbarian.homebrew, isFalse);
  });

  test('Barbarian proficiencies and skill choices match the PHB', () {
    expect(
      barbarian.proficiencies.armor,
      {
        'light_armor',
        'medium_armor',
        'shield',
      },
    );
    expect(
      barbarian.proficiencies.weapons,
      {
        'simple_weapons',
        'martial_weapons',
      },
    );
    expect(barbarian.proficiencies.savingThrows, {'FOR', 'COS'});
    expect(barbarian.proficiencies.skillChoices, 2);
    expect(barbarian.proficiencies.skillOptions, hasLength(6));
  });

  test('Barbarian starting equipment resolves to PHB catalogs', () {
    expect(barbarian.startingEquipmentChoices, hasLength(2));
    expect(barbarian.fixedStartingEquipment, hasLength(2));

    for (final choice in barbarian.startingEquipmentChoices) {
      for (final alternative in choice.alternatives) {
        for (final grant in alternative.grants) {
          expect(grant.catalogId, 'weapon');
          expect(weaponDefinitions, contains(grant.itemId));
        }
      }
    }

    final explorerPack = barbarian.fixedStartingEquipment.singleWhere(
      (grant) => grant.catalogId == 'equipment_pack',
    );
    final javelins = barbarian.fixedStartingEquipment.singleWhere(
      (grant) => grant.itemId == 'javelin',
    );

    expect(equipmentPackDefinitions, contains(explorerPack.itemId));
    expect(javelins.quantity, 4);
  });

  test('Barbarian Rage progression is complete and becomes unlimited', () {
    final rage = barbarian.resources.singleWhere(
      (resource) => resource.id == 'rage',
    );

    expect(rage.maximumAtLevel(1), 2);
    expect(rage.maximumAtLevel(3), 3);
    expect(rage.maximumAtLevel(6), 4);
    expect(rage.maximumAtLevel(12), 5);
    expect(rage.maximumAtLevel(17), 6);
    expect(rage.maximumAtLevel(20), 6);

    expect(rage.isUnlimitedAtLevel(19), isFalse);
    expect(rage.isUnlimitedAtLevel(20), isTrue);
    expect(rage.recovery, ClassResourceRecovery.longRest);
  });

  test('Barbarian progressive values match levels 1 through 20', () {
    expect(barbarian.progressionValue('rage_damage', 1), '+2');
    expect(barbarian.progressionValue('rage_damage', 8), '+2');
    expect(barbarian.progressionValue('rage_damage', 9), '+3');
    expect(barbarian.progressionValue('rage_damage', 16), '+4');
    expect(barbarian.progressionValue('rage_damage', 20), '+4');

    expect(
      barbarian.progressionValue('brutal_critical_dice', 8),
      isNull,
    );
    expect(
      barbarian.progressionValue('brutal_critical_dice', 9),
      '1',
    );
    expect(
      barbarian.progressionValue('brutal_critical_dice', 13),
      '2',
    );
    expect(
      barbarian.progressionValue('brutal_critical_dice', 17),
      '3',
    );
  });

  test('Every granted Barbarian feature has a definition', () {
    final granted =
        barbarian.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(14));
    expect(
      granted.difference(
        barbarian.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );

    for (final entry in barbarian.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.barbarian);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Barbarian base progression reaches level 20', () {
    expect(barbarian.featuresAtLevel(1), contains('rage'));
    expect(barbarian.featuresAtLevel(3), contains('primal_path'));
    expect(barbarian.featuresAtLevel(5), contains('extra_attack'));
    expect(barbarian.featuresAtLevel(20), ['primal_champion']);
    expect(barbarian.subclasses.length, 2);
  });

  test('Barbarian rules use metric movement values', () {
    expect(
      barbarianFeatureDefinitions['fast_movement']!.content.description.details,
      contains('3 metri'),
    );
  });
}
