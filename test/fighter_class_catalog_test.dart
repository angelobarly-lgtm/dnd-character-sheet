import 'package:dnd_character_sheet/data/ammunition_data.dart';
import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/fighter_class_data.dart';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fighter = fighterClassDefinition;

  test('Fighter base identity and proficiencies match the PHB', () {
    expect(fighter.id, ClassIds.fighter);
    expect(fighter.name, 'Guerriero');
    expect(fighter.hitDie, 10);
    expect(fighter.subclassSelectionLevel, 3);
    expect(fighter.content.source.isEmpty, isFalse);

    expect(
      fighter.proficiencies.armor,
      {
        'light_armor',
        'medium_armor',
        'heavy_armor',
        'shield',
      },
    );
    expect(
      fighter.proficiencies.weapons,
      {
        'simple_weapons',
        'martial_weapons',
      },
    );
    expect(fighter.proficiencies.savingThrows, {'FOR', 'COS'});
    expect(fighter.proficiencies.skillChoices, 2);
    expect(fighter.proficiencies.skillOptions, hasLength(8));

    final skills = fighter.proficiencies.choices.single;
    expect(skills.id, 'fighter_skills');
    expect(skills.selections, 2);
    expect(skills.optionIds, fighter.proficiencies.skillOptions);
  });

  test('Fighter receives exactly the six PHB Fighting Styles', () {
    final feature = fighter.featureDefinitions['fighting_style']!;
    final choice = feature.choices.single;

    expect(choice.id, 'fighter_fighting_style');
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.requireNewAcquisition, isTrue);
    expect(choice.options, hasLength(6));

    expect(
      choice.options.map((option) => option.id).toSet(),
      phbFighterFightingStyleIds,
    );

    expect(
      choice.options.map((option) => option.id).toSet().intersection({
        FightingStyleIds.blindFighting,
        FightingStyleIds.interception,
        FightingStyleIds.superiorTechnique,
        FightingStyleIds.thrownWeaponFighting,
        FightingStyleIds.unarmedFighting,
      }),
      isEmpty,
    );

    for (final option in choice.options) {
      expect(option.label.trim(), isNotEmpty);
      expect(fightingStyleDefinitions.containsKey(option.id), isTrue);
    }
  });

  test('variable starting equipment selections are structured', () {
    expect(fighter.startingEquipmentChoices, hasLength(4));

    final choices = {
      for (final choice in fighter.startingEquipmentChoices) choice.id: choice,
    };

    expect(
      choices.keys,
      {
        'fighter_armor',
        'fighter_martial_loadout',
        'fighter_ranged_loadout',
        'fighter_pack',
      },
    );

    final martial = choices['fighter_martial_loadout']!;
    final weaponAndShield = martial.alternatives.singleWhere(
      (alternative) => alternative.id == 'fighter_martial_weapon_and_shield',
    );
    final twoWeapons = martial.alternatives.singleWhere(
      (alternative) => alternative.id == 'fighter_two_martial_weapons',
    );

    final expectedMartialIds = weaponDefinitions.values
        .where((weapon) => weapon.category == WeaponCategory.martial)
        .map((weapon) => weapon.id)
        .toSet();

    expect(weaponAndShield.itemChoices, hasLength(1));
    expect(
      weaponAndShield.itemChoices.single.optionIds,
      expectedMartialIds,
    );
    expect(weaponAndShield.itemChoices.single.selections, 1);
    expect(weaponAndShield.itemChoices.single.allowDuplicates, isFalse);
    expect(
      weaponAndShield.grants.single.itemId,
      ArmorIds.shield,
    );

    expect(twoWeapons.itemChoices, hasLength(1));
    expect(twoWeapons.itemChoices.single.optionIds, expectedMartialIds);
    expect(twoWeapons.itemChoices.single.selections, 2);
    expect(twoWeapons.itemChoices.single.allowDuplicates, isTrue);
  });

  test('all fixed starting equipment references existing catalogs', () {
    bool catalogContains(String catalogId, String itemId) {
      switch (catalogId) {
        case 'weapon':
          return weaponDefinitions.containsKey(itemId);
        case 'armor':
          return armorDefinitions.containsKey(itemId);
        case 'ammunition':
          return ammunitionDefinitions.containsKey(itemId);
        case 'equipment_pack':
          return equipmentPackDefinitions.containsKey(itemId);
      }

      return false;
    }

    for (final choice in fighter.startingEquipmentChoices) {
      for (final alternative in choice.alternatives) {
        for (final grant in alternative.grants) {
          expect(
            catalogContains(grant.catalogId, grant.itemId),
            isTrue,
            reason: 'Riferimento mancante: ${grant.catalogId}:${grant.itemId}',
          );
          expect(grant.quantity, greaterThan(0));
        }

        for (final itemChoice in alternative.itemChoices) {
          expect(itemChoice.optionIds, isNotEmpty);

          for (final itemId in itemChoice.optionIds) {
            expect(
              catalogContains(itemChoice.catalogId, itemId),
              isTrue,
              reason: 'Opzione mancante: ${itemChoice.catalogId}:$itemId',
            );
          }
        }
      }
    }

    final armor = fighter.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'fighter_armor',
    );
    final leather = armor.alternatives.singleWhere(
      (alternative) => alternative.id == 'fighter_leather_longbow',
    );

    expect(
      leather.grants.singleWhere((grant) => grant.itemId == 'arrows').quantity,
      20,
    );

    final ranged = fighter.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'fighter_ranged_loadout',
    );
    final crossbow = ranged.alternatives.singleWhere(
      (alternative) => alternative.id == 'fighter_light_crossbow',
    );

    expect(
      crossbow.grants
          .singleWhere((grant) => grant.itemId == 'crossbow_bolts')
          .quantity,
      20,
    );
  });

  test('Fighter base progression covers levels 1 through 20', () {
    expect(
      fighter.featuresAtLevel(1),
      ['fighting_style', 'second_wind'],
    );
    expect(fighter.featuresAtLevel(2), ['action_surge']);
    expect(fighter.featuresAtLevel(3), ['martial_archetype']);
    expect(fighter.featuresAtLevel(5), ['extra_attack']);
    expect(fighter.featuresAtLevel(9), ['indomitable']);
    expect(fighter.featuresAtLevel(11), ['extra_attack_improvement']);
    expect(
      fighter.featuresAtLevel(17),
      ['action_surge_improvement', 'indomitable_improvement'],
    );
    expect(fighter.featuresAtLevel(20), ['extra_attack_mastery']);

    final abilityScoreLevels = fighter.featuresByLevel.entries
        .where(
          (entry) => entry.value.contains('ability_score_improvement'),
        )
        .map((entry) => entry.key)
        .toSet();

    expect(abilityScoreLevels, {4, 6, 8, 12, 14, 16, 19});

    expect(
      fighter.progressionValue('attacks_per_attack_action', 1),
      '1',
    );
    expect(
      fighter.progressionValue('attacks_per_attack_action', 5),
      '2',
    );
    expect(
      fighter.progressionValue('attacks_per_attack_action', 11),
      '3',
    );
    expect(
      fighter.progressionValue('attacks_per_attack_action', 20),
      '4',
    );
  });

  test('Fighter resources use their official names and recovery rules', () {
    final resources = {
      for (final resource in fighter.resources) resource.id: resource,
    };

    expect(
      resources.keys,
      {
        'second_wind',
        'action_surge',
        'indomitable',
      },
    );

    final secondWind = resources['second_wind']!;
    expect(secondWind.name, 'Recuperare Energie');
    expect(secondWind.maximumAtLevel(1), 1);
    expect(secondWind.recovery, ClassResourceRecovery.shortRest);

    final actionSurge = resources['action_surge']!;
    expect(actionSurge.name, 'Azione Impetuosa');
    expect(actionSurge.maximumAtLevel(2), 1);
    expect(actionSurge.maximumAtLevel(16), 1);
    expect(actionSurge.maximumAtLevel(17), 2);
    expect(actionSurge.recovery, ClassResourceRecovery.shortRest);

    final indomitable = resources['indomitable']!;
    expect(indomitable.name, 'Indomito');
    expect(indomitable.maximumAtLevel(8), 0);
    expect(indomitable.maximumAtLevel(9), 1);
    expect(indomitable.maximumAtLevel(13), 2);
    expect(indomitable.maximumAtLevel(17), 3);
    expect(indomitable.recovery, ClassResourceRecovery.longRest);
  });

  test('every granted Fighter feature is registered coherently', () {
    final granted =
        fighter.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, fighter.featureDefinitions.keys.toSet());
    expect(granted, hasLength(11));

    final resourceIds =
        fighter.resources.map((resource) => resource.id).toSet();

    for (final entry in fighter.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, ClassIds.fighter);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);

      if (feature.resourceId != null) {
        expect(
          resourceIds,
          contains(feature.resourceId),
          reason: 'Risorsa mancante per ${entry.key}',
        );
      }
    }
  });

  test('universal class registry contains the Fighter', () {
    expect(phbClassDefinitions[ClassIds.fighter], same(fighter));
    expect(
      phbClassDefinitions.keys,
      containsAll({
        ClassIds.barbarian,
        ClassIds.bard,
        ClassIds.cleric,
        ClassIds.druid,
        ClassIds.fighter,
        ClassIds.monk,
      }),
    );
  });
}
