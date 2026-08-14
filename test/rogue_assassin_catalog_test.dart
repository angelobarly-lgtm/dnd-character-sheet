import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/rogue_class_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rogue = phbClassDefinitions[ClassIds.rogue]!;
  final assassin = rogue.subclasses[RogueSubclassIds.assassin]!;

  test('Assassin is registered as a PHB Rogue archetype', () {
    expect(rogue.subclasses, contains(RogueSubclassIds.assassin));
    expect(assassin.id, RogueSubclassIds.assassin);
    expect(assassin.name, 'Assassino');
    expect(assassin.classId, ClassIds.rogue);
    expect(assassin.homebrew, isFalse);
    expect(assassin.supplemental, isFalse);
    expect(assassin.content.ownerId, ClassIds.rogue);
    expect(assassin.content.source.isEmpty, isFalse);
  });

  test('Assassin progression grants all five PHB features', () {
    expect(
      assassin.featuresByLevel,
      {
        3: [
          AssassinFeatureIds.bonusProficiencies,
          AssassinFeatureIds.assassinate,
        ],
        9: [
          AssassinFeatureIds.infiltrationExpertise,
        ],
        13: [
          AssassinFeatureIds.impostor,
        ],
        17: [
          AssassinFeatureIds.deathStrike,
        ],
      },
    );

    final granted =
        assassin.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(5));
    expect(
      granted,
      assassin.featureDefinitions.keys.toSet(),
    );
  });

  test('Bonus Proficiencies grants both canonical PHB kits', () {
    final feature =
        assassin.featureDefinitions[AssassinFeatureIds.bonusProficiencies]!;

    expect(
      feature.effects.toolProficiencies,
      {
        ToolIds.disguiseKit,
        ToolIds.poisonersKit,
      },
    );

    expect(toolDefinitions, contains(ToolIds.disguiseKit));
    expect(toolDefinitions, contains(ToolIds.poisonersKit));
  });

  test('Assassinate structures initiative advantage and surprise criticals',
      () {
    final feature =
        assassin.featureDefinitions[AssassinFeatureIds.assassinate]!;
    final effects = feature.effects.ruleEffects;

    final advantage = effects.singleWhere(
      (effect) => effect.id == 'assassin_assassinate_attack_advantage',
    );
    final critical = effects.singleWhere(
      (effect) => effect.id == 'assassin_assassinate_surprise_critical',
    );

    expect(advantage.type, CharacterRuleEffectType.advantage);
    expect(advantage.target, 'attack_rolls');
    expect(
      advantage.condition,
      'target_has_not_taken_a_turn_in_current_combat',
    );

    expect(critical.type, CharacterRuleEffectType.conditional);
    expect(critical.target, 'hits_against_surprised_creatures');
    expect(
      critical.condition,
      'hit_is_automatically_critical',
    );
  });

  test('Infiltration Expertise records seven days and 25 gp', () {
    final feature =
        assassin.featureDefinitions[AssassinFeatureIds.infiltrationExpertise]!;
    final effects = feature.effects.ruleEffects;

    final preparation = effects.singleWhere(
      (effect) => effect.target == 'false_identity_preparation_days',
    );
    final cost = effects.singleWhere(
      (effect) => effect.target == 'false_identity_creation_cost_gp',
    );
    final credibility = effects.singleWhere(
      (effect) => effect.target == 'false_identity_credibility',
    );

    expect(preparation.value, 7);
    expect(preparation.condition, 'seven_days_of_preparation');

    expect(cost.value, 25);
    expect(
      cost.condition,
      'identity_includes_history_profession_and_affiliations',
    );

    expect(
      credibility.condition,
      'other_creatures_believe_identity_until_given_reason_not_to',
    );
  });

  test('Impostor requires three hours and grants Deception advantage', () {
    final feature = assassin.featureDefinitions[AssassinFeatureIds.impostor]!;
    final effects = feature.effects.ruleEffects;

    final study = effects.singleWhere(
      (effect) => effect.target == 'impersonation_study_hours',
    );
    final deception = effects.singleWhere(
      (effect) => effect.target == 'charisma_deception_checks',
    );

    expect(study.value, 3);
    expect(
      study.condition,
      'study_speech_handwriting_and_mannerisms',
    );

    expect(deception.type, CharacterRuleEffectType.advantage);
    expect(
      deception.condition,
      'prevent_detection_while_impersonating_studied_creature',
    );
  });

  test('Death Strike uses the PHB save formula and doubles damage', () {
    final feature =
        assassin.featureDefinitions[AssassinFeatureIds.deathStrike]!;
    final effects = feature.effects.ruleEffects;

    final savingThrow = effects.singleWhere(
      (effect) => effect.target == 'surprised_target_constitution_saving_throw',
    );
    final damage = effects.singleWhere(
      (effect) => effect.target == 'attack_damage_multiplier',
    );

    expect(
      savingThrow.referenceIds.toSet(),
      {
        'constitution',
        'dexterity',
        'proficiency_bonus',
      },
    );
    expect(
      savingThrow.condition,
      'dc_8_plus_dexterity_modifier_plus_proficiency_bonus',
    );

    expect(damage.value, 2);
    expect(
      damage.condition,
      'target_surprised_and_constitution_saving_throw_failed',
    );
  });

  test('Every Assassin feature has coherent identity and source data', () {
    for (final entry in assassin.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, RogueSubclassIds.assassin);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
      expect(feature.ruleTags, contains('subclass_feature'));
      expect(feature.ruleTags, contains('rogue'));
      expect(feature.ruleTags, contains('assassin'));
    }
  });

  test('Assassin adds no spellcasting or consumable resource', () {
    expect(assassin.spellcasting, isNull);
    expect(assassin.resources, isEmpty);
    expect(assassin.options, isEmpty);
  });
}
