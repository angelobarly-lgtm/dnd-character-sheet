import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/fighter_class_data.dart';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final champion = championSubclassDefinition;

  test('Champion is registered as a PHB Fighter archetype', () {
    expect(champion.id, FighterSubclassIds.champion);
    expect(champion.name, 'Campione');
    expect(champion.classId, 'fighter');
    expect(champion.homebrew, isFalse);
    expect(champion.supplemental, isFalse);
    expect(champion.content.source.isEmpty, isFalse);

    expect(
      fighterClassDefinition.subclasses[FighterSubclassIds.champion],
      same(champion),
    );
  });

  test('Champion progression contains all five PHB features', () {
    expect(
      champion.featuresByLevel,
      {
        3: [ChampionFeatureIds.improvedCritical],
        7: [ChampionFeatureIds.remarkableAthlete],
        10: [ChampionFeatureIds.additionalFightingStyle],
        15: [ChampionFeatureIds.superiorCritical],
        18: [ChampionFeatureIds.survivor],
      },
    );

    final granted =
        champion.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, champion.featureDefinitions.keys.toSet());
    expect(granted, hasLength(5));

    for (final entry in champion.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, FighterSubclassIds.champion);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
    }
  });

  test('Improved and Superior Critical use structured critical ranges', () {
    final improved = champion
        .featureDefinitions[ChampionFeatureIds.improvedCritical]!
        .effects
        .ruleEffects
        .single;

    expect(improved.type, CharacterRuleEffectType.criticalRange);
    expect(improved.target, 'weapon_attack_critical_range');
    expect(improved.value, 19);
    expect(improved.condition, 'weapon_attack');

    final superior = champion
        .featureDefinitions[ChampionFeatureIds.superiorCritical]!
        .effects
        .ruleEffects
        .single;

    expect(superior.type, CharacterRuleEffectType.criticalRange);
    expect(superior.target, 'weapon_attack_critical_range');
    expect(superior.value, 18);
    expect(superior.condition, 'weapon_attack');
  });

  test('Remarkable Athlete models both checks and running long jump', () {
    final effects = champion
        .featureDefinitions[ChampionFeatureIds.remarkableAthlete]!
        .effects
        .ruleEffects;

    expect(effects, hasLength(2));

    expect(
      effects.any(
        (effect) =>
            effect.target == 'strength_dexterity_constitution_ability_checks' &&
            effect.condition ==
                'add_half_proficiency_rounded_up_when_not_proficient',
      ),
      isTrue,
    );

    expect(
      effects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.movement &&
            effect.target == 'running_long_jump_distance_meters' &&
            effect.condition == 'add_0_3_meters_per_strength_modifier',
      ),
      isTrue,
    );
  });

  test('Additional Fighting Style offers only the six PHB styles', () {
    final feature = champion
        .featureDefinitions[ChampionFeatureIds.additionalFightingStyle]!;
    final choice = feature.choices.single;

    expect(choice.id, 'champion_additional_fighting_style');
    expect(choice.requireNewAcquisition, isTrue);
    expect(choice.options, hasLength(6));
    expect(
      choice.options.map((option) => option.id).toSet(),
      phbFighterFightingStyleIds,
    );
  });

  test('Survivor stores its healing formula and activation condition', () {
    final effect = champion.featureDefinitions[ChampionFeatureIds.survivor]!
        .effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.conditional);
    expect(effect.target, 'hit_point_recovery_at_start_of_turn');
    expect(effect.value, 5);
    expect(
      effect.condition,
      'current_hp_above_zero_and_not_above_half_maximum_plus_constitution_modifier',
    );
  });

  test('Champion does not introduce consumable resources', () {
    expect(champion.resources, isEmpty);

    for (final feature in champion.featureDefinitions.values) {
      expect(feature.resourceId, isNull);
    }
  });
}
