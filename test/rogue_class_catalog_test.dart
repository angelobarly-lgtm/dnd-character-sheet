import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/rogue_class_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rogue = rogueClassDefinition;

  test('Rogue is registered in the universal class catalog', () {
    expect(phbClassDefinitions[ClassIds.rogue], same(rogue));
    expect(phbClassDefinitionFor(ClassIds.rogue), same(rogue));
    expect(rogue.id, ClassIds.rogue);
    expect(rogue.name, 'Ladro');
    expect(rogue.hitDie, 8);
    expect(rogue.homebrew, isFalse);
    expect(rogue.content.source.isEmpty, isFalse);
  });

  test('Rogue proficiencies match the PHB', () {
    expect(rogue.proficiencies.armor, {'light_armor'});
    expect(
      rogue.proficiencies.weapons,
      {
        'simple_weapons',
        'hand_crossbow',
        'longsword',
        'rapier',
        'shortsword',
      },
    );
    expect(
      rogue.proficiencies.tools,
      {ToolIds.thievesTools},
    );
    expect(rogue.proficiencies.savingThrows, {'DES', 'INT'});
    expect(rogue.proficiencies.skillChoices, 4);
    expect(rogue.proficiencies.skillOptions, hasLength(11));

    final choice = rogue.proficiencies.choices.single;

    expect(choice.selections, 4);
    expect(choice.optionIds, rogue.proficiencies.skillOptions);
  });

  test('Rogue starting equipment matches all PHB alternatives', () {
    expect(rogue.startingEquipmentChoices, hasLength(3));

    final choices = {
      for (final choice in rogue.startingEquipmentChoices) choice.id: choice,
    };

    expect(
      choices['rogue_primary_weapon']!
          .alternatives
          .map((alternative) => alternative.id)
          .toSet(),
      {
        'rogue_rapier',
        'rogue_shortsword_primary',
      },
    );

    final ranged = choices['rogue_secondary_weapon']!.alternatives.singleWhere(
          (alternative) => alternative.id == 'rogue_shortbow',
        );
    final rangedGrants = {
      for (final grant in ranged.grants)
        '${grant.catalogId}:${grant.itemId}': grant.quantity,
    };

    expect(
      rangedGrants,
      {
        'weapon:shortbow': 1,
        'equipment:${EquipmentIds.quiver}': 1,
        'ammunition:arrows': 20,
      },
    );

    expect(
      choices['rogue_pack']!
          .alternatives
          .map((alternative) => alternative.grants.single.itemId)
          .toSet(),
      {
        EquipmentPackIds.burglar,
        EquipmentPackIds.dungeoneer,
        EquipmentPackIds.explorer,
      },
    );

    final fixed = {
      for (final grant in rogue.fixedStartingEquipment)
        '${grant.catalogId}:${grant.itemId}': grant.quantity,
    };

    expect(
      fixed,
      {
        'armor:${ArmorIds.leather}': 1,
        'weapon:dagger': 2,
        'tool:${ToolIds.thievesTools}': 1,
      },
    );
  });

  test('Rogue base progression reserves levels 9 13 and 17', () {
    const baseLevels = {
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      10,
      11,
      12,
      14,
      15,
      16,
      18,
      19,
      20,
    };

    expect(rogue.featuresByLevel.keys.toSet(), baseLevels);
    expect(rogue.featuresAtLevel(9), isEmpty);
    expect(rogue.featuresAtLevel(13), isEmpty);
    expect(rogue.featuresAtLevel(17), isEmpty);
    expect(rogue.subclassSelectionLevel, 3);
    expect(
      rogue.subclasses,
      contains(RogueSubclassIds.thief),
    );
  });

  test('Sneak Attack progresses from 1d6 to 10d6', () {
    const expected = {
      1: '1d6',
      3: '2d6',
      5: '3d6',
      7: '4d6',
      9: '5d6',
      11: '6d6',
      13: '7d6',
      15: '8d6',
      17: '9d6',
      19: '10d6',
    };

    for (final entry in expected.entries) {
      expect(
        rogue.progressionValue(
          RogueProgressionIds.sneakAttackDice,
          entry.key,
        ),
        entry.value,
      );
    }

    expect(
      rogue.progressionValue(
        RogueProgressionIds.sneakAttackDice,
        20,
      ),
      '10d6',
    );
  });

  test('Expertise choices use existing skill or tool proficiencies', () {
    final expertise =
        rogue.featureDefinitions[RogueFeatureIds.expertise]!.choices.single;
    final improvement = rogue
        .featureDefinitions[RogueFeatureIds.expertiseImprovement]!
        .choices
        .single;

    for (final choice in [expertise, improvement]) {
      expect(choice.type, CharacterChoiceType.other);
      expect(choice.minimumSelections, 2);
      expect(choice.maximumSelections, 2);
      expect(choice.requireExistingAcquisition, isTrue);
      expect(choice.options, hasLength(12));
      expect(
        choice.options.map((option) => option.id),
        contains(ToolIds.thievesTools),
      );
    }

    expect(expertise.id, 'rogue_expertise_level_1');
    expect(improvement.id, 'rogue_expertise_level_6');
  });

  test('Cunning Action provides all three bonus actions', () {
    final feature = rogue.featureDefinitions[RogueFeatureIds.cunningAction]!;
    final targets =
        feature.effects.ruleEffects.map((effect) => effect.target).toSet();

    expect(targets, {'dash', 'disengage', 'hide'});

    for (final effect in feature.effects.ruleEffects) {
      expect(effect.condition, 'bonus_action_on_own_turn');
    }
  });

  test('Uncanny Dodge and Evasion are structured separately', () {
    final uncanny = rogue.featureDefinitions[RogueFeatureIds.uncannyDodge]!
        .effects.ruleEffects.single;
    final evasion =
        rogue.featureDefinitions[RogueFeatureIds.evasion]!.effects.ruleEffects;

    expect(uncanny.type, CharacterRuleEffectType.reaction);
    expect(uncanny.value, 0.5);
    expect(evasion, hasLength(2));
    expect(
      evasion.map((effect) => effect.value).toSet(),
      {0, 0.5},
    );
  });

  test('Slippery Mind grants Wisdom saving throw proficiency', () {
    final feature = rogue.featureDefinitions[RogueFeatureIds.slipperyMind]!;

    expect(feature.effects.savingThrowProficiencies, {'SAG'});
  });

  test('Stroke of Luck is a recoverable class resource', () {
    final resource = rogue.resources.single;

    expect(resource.id, RogueResourceIds.strokeOfLuck);
    expect(resource.minimumLevel, 20);
    expect(resource.recovery, ClassResourceRecovery.shortRest);
    expect(resource.maximumAtLevel(19), 0);
    expect(resource.maximumAtLevel(20), 1);

    final feature = rogue.featureDefinitions[RogueFeatureIds.strokeOfLuck]!;

    expect(feature.resourceId, RogueResourceIds.strokeOfLuck);
    expect(feature.effects.ruleEffects, hasLength(2));
  });

  test('every granted Rogue feature has a definition', () {
    final granted =
        rogue.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(rogue.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in rogue.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, ClassIds.rogue);
      expect(feature.content.name.trim(), isNotEmpty);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.ruleTags, isNotEmpty);
    }
  });
}
