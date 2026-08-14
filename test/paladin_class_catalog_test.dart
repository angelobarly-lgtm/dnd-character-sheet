import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:dnd_character_sheet/data/paladin_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final paladin = phbClassDefinitions[ClassIds.paladin]!;

  test('Paladin is registered in the universal class catalog', () {
    expect(paladin, same(paladinClassDefinition));
    expect(phbClassDefinitionFor(ClassIds.paladin), same(paladin));
    expect(paladin.id, ClassIds.paladin);
    expect(paladin.name, 'Paladino');
    expect(paladin.hitDie, 10);
    expect(paladin.subclassSelectionLevel, 3);
    expect(paladin.homebrew, isFalse);
    expect(paladin.content.source.isEmpty, isFalse);
  });

  test('Paladin has the canonical PHB proficiencies', () {
    expect(
      paladin.proficiencies.armor,
      {
        'light_armor',
        'medium_armor',
        'heavy_armor',
        'shield',
      },
    );
    expect(
      paladin.proficiencies.weapons,
      {
        'simple_weapons',
        'martial_weapons',
      },
    );
    expect(paladin.proficiencies.savingThrows, {'SAG', 'CAR'});
    expect(
      paladin.proficiencies.skillOptions,
      {
        'athletics',
        'insight',
        'intimidation',
        'medicine',
        'persuasion',
        'religion',
      },
    );
    expect(paladin.proficiencies.skillChoices, 2);

    final skillChoice = paladin.proficiencies.choices.single;
    expect(skillChoice.id, 'paladin_skills');
    expect(skillChoice.selections, 2);
    expect(skillChoice.optionIds, paladin.proficiencies.skillOptions);
  });

  test('Paladin starting equipment preserves every nested PHB choice', () {
    expect(paladin.startingEquipmentChoices, hasLength(4));
    expect(paladin.fixedStartingEquipment, hasLength(1));
    expect(
      paladin.fixedStartingEquipment.single.itemId,
      ArmorIds.chainMail,
    );

    final martial = paladin.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'paladin_martial_loadout',
    );
    expect(martial.alternatives, hasLength(2));

    final weaponAndShield = martial.alternatives.singleWhere(
      (alternative) => alternative.id == 'paladin_martial_weapon_and_shield',
    );
    expect(
      weaponAndShield.grants.single.itemId,
      ArmorIds.shield,
    );

    final expectedMartialWeapons = weaponDefinitions.values
        .where((weapon) => weapon.category == WeaponCategory.martial)
        .map((weapon) => weapon.id)
        .toSet();

    expect(
      weaponAndShield.itemChoices.single.optionIds,
      expectedMartialWeapons,
    );

    final twoWeapons = martial.alternatives.singleWhere(
      (alternative) => alternative.id == 'paladin_two_martial_weapons',
    );
    expect(twoWeapons.itemChoices.single.selections, 2);
    expect(twoWeapons.itemChoices.single.allowDuplicates, isTrue);
    expect(
      twoWeapons.itemChoices.single.optionIds,
      expectedMartialWeapons,
    );

    final secondary = paladin.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'paladin_secondary_weapon',
    );
    final javelins = secondary.alternatives.singleWhere(
      (alternative) => alternative.id == 'paladin_five_javelins',
    );
    expect(javelins.grants.single.itemId, 'javelin');
    expect(javelins.grants.single.quantity, 5);

    final expectedSimpleMeleeWeapons = weaponDefinitions.values
        .where(
          (weapon) =>
              weapon.category == WeaponCategory.simple &&
              weapon.kind == WeaponKind.melee,
        )
        .map((weapon) => weapon.id)
        .toSet();

    final simpleMelee = secondary.alternatives.singleWhere(
      (alternative) => alternative.id == 'paladin_simple_melee_weapon',
    );
    expect(
      simpleMelee.itemChoices.single.optionIds,
      expectedSimpleMeleeWeapons,
    );

    final holySymbol = paladin.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'paladin_holy_symbol',
    );
    final expectedHolySymbols = focusDefinitions.values
        .where((focus) => focus.category == FocusCategory.holy)
        .map((focus) => focus.id)
        .toSet();
    final grantedHolySymbols = holySymbol.alternatives
        .expand((alternative) => alternative.grants)
        .map((grant) => grant.itemId)
        .toSet();

    expect(expectedHolySymbols, hasLength(3));
    expect(grantedHolySymbols, expectedHolySymbols);
  });

  test('Paladin base progression grants every registered feature', () {
    final granted =
        paladin.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(15));
    expect(
      granted.difference(paladin.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    expect(
      paladin.featuresAtLevel(1),
      [
        PaladinFeatureIds.divineSense,
        PaladinFeatureIds.layOnHands,
      ],
    );
    expect(
      paladin.featuresAtLevel(2),
      [
        PaladinFeatureIds.fightingStyle,
        PaladinFeatureIds.spellcasting,
        PaladinFeatureIds.divineSmite,
      ],
    );
    expect(
      paladin.featuresAtLevel(3),
      containsAll({
        PaladinFeatureIds.divineHealth,
        PaladinFeatureIds.sacredOath,
        PaladinFeatureIds.channelDivinity,
      }),
    );
    expect(
      paladin.featuresAtLevel(18),
      [PaladinFeatureIds.auraImprovements],
    );

    final resourceIds =
        paladin.resources.map((resource) => resource.id).toSet();

    for (final entry in paladin.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.paladin);
      expect(entry.value.content.source.isEmpty, isFalse);

      final resourceId = entry.value.resourceId;
      if (resourceId != null) {
        expect(resourceIds, contains(resourceId));
      }
    }
  });

  test('Paladin resources use their canonical formulas and recovery', () {
    final divineSense = paladin.resources.singleWhere(
      (resource) => resource.id == PaladinResourceIds.divineSense,
    );
    expect(divineSense.recovery, ClassResourceRecovery.longRest);
    expect(
      divineSense.maximumAtLevel(
        1,
        abilityModifiers: const {'CAR': 3},
      ),
      4,
    );
    expect(
      divineSense.maximumAtLevel(
        1,
        abilityModifiers: const {'CAR': -2},
      ),
      1,
    );

    final layOnHands = paladin.resources.singleWhere(
      (resource) => resource.id == PaladinResourceIds.layOnHands,
    );
    expect(layOnHands.maximumAtLevel(1), 5);
    expect(layOnHands.maximumAtLevel(8), 40);
    expect(layOnHands.maximumAtLevel(20), 100);

    final channelDivinity = paladin.resources.singleWhere(
      (resource) => resource.id == PaladinResourceIds.channelDivinity,
    );
    expect(channelDivinity.maximumAtLevel(2), 0);
    expect(channelDivinity.maximumAtLevel(3), 1);
    expect(
      channelDivinity.recoveryAtLevel(20),
      ClassResourceRecovery.shortRest,
    );

    final cleansingTouch = paladin.resources.singleWhere(
      (resource) => resource.id == PaladinResourceIds.cleansingTouch,
    );
    expect(cleansingTouch.maximumAtLevel(13), 0);
    expect(
      cleansingTouch.maximumAtLevel(
        14,
        abilityModifiers: const {'CAR': 4},
      ),
      4,
    );
    expect(
      cleansingTouch.maximumAtLevel(
        14,
        abilityModifiers: const {'CAR': -1},
      ),
      1,
    );
  });

  test('Paladin uses the complete PHB half-caster progression', () {
    final spellcasting = paladin.spellcasting!;

    expect(
      spellcasting.progression,
      ClassSpellcastingProgression.half,
    );
    expect(spellcasting.ability, 'CAR');
    expect(spellcasting.minimumLevel, 2);
    expect(spellcasting.preparesSpells, isTrue);
    expect(spellcasting.ritualCasting, isFalse);
    expect(spellcasting.cantripsKnownAtLevel(20), 0);

    expect(spellcasting.spellIds, hasLength(45));
    expect(
      spellcasting.spellIds.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );

    expect(spellcasting.slotsAtLevel(1), isEmpty);
    expect(spellcasting.slotsAtLevel(2), [2]);
    expect(spellcasting.slotsAtLevel(5), [4, 2]);
    expect(spellcasting.slotsAtLevel(9), [4, 3, 2]);
    expect(spellcasting.slotsAtLevel(13), [4, 3, 3, 1]);
    expect(spellcasting.slotsAtLevel(17), [4, 3, 3, 3, 1]);
    expect(spellcasting.slotsAtLevel(20), [4, 3, 3, 3, 2]);

    expect(
      spellcasting.preparedSpellsAtLevel(
        1,
        abilityModifiers: const {'CAR': 3},
      ),
      0,
    );
    expect(
      spellcasting.preparedSpellsAtLevel(
        2,
        abilityModifiers: const {'CAR': 3},
      ),
      4,
    );
    expect(
      spellcasting.preparedSpellsAtLevel(
        20,
        abilityModifiers: const {'CAR': 5},
      ),
      15,
    );
  });

  test('Paladin fighting style is limited to the four PHB options', () {
    final choice = paladin
        .featureDefinitions[PaladinFeatureIds.fightingStyle]!.choices.single;
    final optionIds = choice.options.map((option) => option.id).toSet();

    expect(optionIds, phbPaladinFightingStyleIds);
    expect(optionIds, hasLength(4));
    expect(
      optionIds.difference(fightingStyleDefinitions.keys.toSet()),
      isEmpty,
    );
    expect(choice.requireNewAcquisition, isTrue);
  });

  test('Paladin auras share a structured progressive radius', () {
    expect(
      paladin.progressionValue(
        PaladinProgressionIds.auraRadiusMeters,
        5,
      ),
      isNull,
    );
    expect(
      paladin.progressionValue(
        PaladinProgressionIds.auraRadiusMeters,
        6,
      ),
      '3',
    );
    expect(
      paladin.progressionValue(
        PaladinProgressionIds.auraRadiusMeters,
        17,
      ),
      '3',
    );
    expect(
      paladin.progressionValue(
        PaladinProgressionIds.auraRadiusMeters,
        18,
      ),
      '9',
    );

    for (final featureId in {
      PaladinFeatureIds.auraOfProtection,
      PaladinFeatureIds.auraOfCourage,
    }) {
      final effect =
          paladin.featureDefinitions[featureId]!.effects.ruleEffects.single;

      expect(effect.type, CharacterRuleEffectType.conditional);
      expect(
        effect.referenceIds,
        contains(PaladinProgressionIds.auraRadiusMeters),
      );
    }
  });

  test('Paladin base remains compatible with incremental oath insertion', () {
    expect(phbPaladinSubclassIds, hasLength(3));
    expect(
      paladin.subclasses.keys.every(phbPaladinSubclassIds.contains),
      isTrue,
    );
  });
}
