import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/rogue_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rogue = phbClassDefinitions[ClassIds.rogue]!;
  final thief = rogue.subclasses[RogueSubclassIds.thief]!;

  test('Thief is registered as a PHB Rogue archetype', () {
    expect(rogue.subclasses, contains(RogueSubclassIds.thief));
    expect(thief.id, RogueSubclassIds.thief);
    expect(thief.name, 'Furfante');
    expect(thief.classId, ClassIds.rogue);
    expect(thief.homebrew, isFalse);
    expect(thief.supplemental, isFalse);
    expect(thief.content.source.isEmpty, isFalse);
    expect(thief.content.ownerId, ClassIds.rogue);
  });

  test('Thief progression grants all five PHB features', () {
    expect(
      thief.featuresByLevel,
      {
        3: [
          ThiefFeatureIds.fastHands,
          ThiefFeatureIds.secondStoryWork,
        ],
        9: [
          ThiefFeatureIds.supremeSneak,
        ],
        13: [
          ThiefFeatureIds.useMagicDevice,
        ],
        17: [
          ThiefFeatureIds.thievesReflexes,
        ],
      },
    );

    final granted =
        thief.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(5));
    expect(
      granted,
      thief.featureDefinitions.keys.toSet(),
    );
  });

  test('Fast Hands expands Cunning Action with the three PHB uses', () {
    final feature = thief.featureDefinitions[ThiefFeatureIds.fastHands]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.conditional);
    expect(effect.target, 'cunning_action_options');
    expect(
      effect.referenceIds,
      containsAll({
        'sleight_of_hand',
        'thieves_tools',
        'use_an_object',
      }),
    );
    expect(
      effect.condition,
      'use_as_bonus_action_through_cunning_action',
    );
    expect(feature.ruleTags, contains('bonus_action'));
  });

  test('Second-Story Work structures climbing and metric jump distance', () {
    final feature = thief.featureDefinitions[ThiefFeatureIds.secondStoryWork]!;
    final effects = feature.effects.ruleEffects;

    final climbing = effects.singleWhere(
      (effect) => effect.target == 'climbing_movement_cost',
    );
    final jumping = effects.singleWhere(
      (effect) => effect.target == 'running_jump_distance_meters',
    );

    expect(climbing.type, CharacterRuleEffectType.movement);
    expect(climbing.value, 1);
    expect(
      climbing.condition,
      'climbing_does_not_cost_extra_movement',
    );

    expect(jumping.type, CharacterRuleEffectType.movement);
    expect(jumping.value, 0.3);
    expect(
      jumping.condition,
      'add_value_for_each_point_of_dexterity_modifier',
    );
  });

  test('Supreme Sneak requires movement not above half speed', () {
    final feature = thief.featureDefinitions[ThiefFeatureIds.supremeSneak]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.advantage);
    expect(effect.target, 'dexterity_stealth_checks');
    expect(
      effect.condition,
      'movement_not_greater_than_half_speed_during_same_turn',
    );
  });

  test('Use Magic Device ignores class race and level requirements', () {
    final feature = thief.featureDefinitions[ThiefFeatureIds.useMagicDevice]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.conditional);
    expect(effect.target, 'magic_item_use_requirements');
    expect(
      effect.referenceIds.toSet(),
      {
        'class_requirement',
        'race_requirement',
        'level_requirement',
      },
    );
    expect(
      effect.condition,
      'ignore_class_race_and_level_requirements',
    );
  });

  test('Thief Reflexes grants the structured second first-round turn', () {
    final feature = thief.featureDefinitions[ThiefFeatureIds.thievesReflexes]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.conditional);
    expect(effect.target, 'turns_during_first_combat_round');
    expect(effect.value, 2);
    expect(
      effect.condition,
      'not_surprised_second_turn_at_initiative_minus_10',
    );
  });

  test('Every Thief feature has coherent identity and source data', () {
    for (final entry in thief.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, RogueSubclassIds.thief);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
      expect(feature.ruleTags, contains('subclass_feature'));
      expect(feature.ruleTags, contains('rogue'));
      expect(feature.ruleTags, contains('thief'));
    }
  });

  test('Thief adds no spellcasting or consumable resource', () {
    expect(thief.spellcasting, isNull);
    expect(thief.resources, isEmpty);
    expect(thief.options, isEmpty);
  });
}
