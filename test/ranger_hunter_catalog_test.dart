import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/ranger_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ranger = phbClassDefinitions[ClassIds.ranger]!;
  final hunter = ranger.subclasses[RangerSubclassIds.hunter]!;

  test('Hunter is registered as a PHB Ranger archetype', () {
    expect(hunter.id, RangerSubclassIds.hunter);
    expect(hunter.name, 'Cacciatore');
    expect(hunter.classId, ClassIds.ranger);
    expect(hunter.homebrew, isFalse);
    expect(hunter.supplemental, isFalse);
    expect(hunter.content.source.name, 'Manuale del Giocatore 2014');
    expect(hunter.content.source.reference, 'pp. 105-106');
  });

  test('Hunter progression uses all four PHB milestones', () {
    expect(hunter.featuresByLevel.keys.toSet(), {3, 7, 11, 15});
    expect(
      hunter.featuresByLevel,
      {
        3: [RangerHunterFeatureIds.huntersPrey],
        7: [RangerHunterFeatureIds.defensiveTactics],
        11: [RangerHunterFeatureIds.multiattack],
        15: [RangerHunterFeatureIds.superiorHunterDefense],
      },
    );

    final granted =
        hunter.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(4));
    expect(
      granted.difference(hunter.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in hunter.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, RangerSubclassIds.hunter);
      expect(entry.value.content.source.isEmpty, isFalse);
      expect(entry.value.choices, hasLength(1));
    }
  });

  test('Hunters Prey contains all three manual options', () {
    expect(
      rangerHunterPreyOptions.map((option) => option.id).toSet(),
      {'horde_breaker', 'colossus_slayer', 'giant_killer'},
    );

    final horde = rangerHunterPreyOptions.singleWhere(
      (option) => option.id == 'horde_breaker',
    );
    final hordeEffect = horde.effects.ruleEffects.single;
    expect(hordeEffect.value, 1.5);
    expect(hordeEffect.condition, contains('once_per_turn'));
    expect(hordeEffect.condition, contains('different_creature'));

    final colossus = rangerHunterPreyOptions.singleWhere(
      (option) => option.id == 'colossus_slayer',
    );
    expect(
      colossus.effects.ruleEffects.single.condition,
      allOf(contains('below_hit_point_maximum'), contains('extra_1d8')),
    );

    final giant = rangerHunterPreyOptions.singleWhere(
      (option) => option.id == 'giant_killer',
    );
    expect(
      giant.effects.ruleEffects.single.type,
      CharacterRuleEffectType.reaction,
    );
    expect(giant.effects.ruleEffects.single.value, 1.5);
  });

  test('Defensive Tactics contains all three manual options', () {
    expect(
      rangerHunterDefensiveTacticsOptions.map((option) => option.id).toSet(),
      {'multiattack_defense', 'escape_the_horde', 'steel_will'},
    );

    final multiattack = rangerHunterDefensiveTacticsOptions.singleWhere(
      (option) => option.id == 'multiattack_defense',
    );
    final multiattackEffect = multiattack.effects.ruleEffects.single;
    expect(multiattackEffect.value, 4);
    expect(multiattackEffect.target, contains('same_creature'));
    expect(
      multiattackEffect.condition,
      allOf(contains('after_creature_hits_ranger'), contains('current_turn')),
    );

    final escape = rangerHunterDefensiveTacticsOptions.singleWhere(
      (option) => option.id == 'escape_the_horde',
    );
    expect(
      escape.effects.ruleEffects.single.type,
      CharacterRuleEffectType.disadvantage,
    );

    final will = rangerHunterDefensiveTacticsOptions.singleWhere(
      (option) => option.id == 'steel_will',
    );
    expect(
      will.effects.ruleEffects.single.type,
      CharacterRuleEffectType.advantage,
    );
    expect(will.effects.ruleEffects.single.target, contains('frightened'));
  });

  test('Multiattack contains Whirlwind Attack and Volley', () {
    expect(
      rangerHunterMultiattackOptions.map((option) => option.id).toSet(),
      {'whirlwind_attack', 'volley'},
    );

    final whirlwind = rangerHunterMultiattackOptions.singleWhere(
      (option) => option.id == 'whirlwind_attack',
    );
    expect(whirlwind.effects.ruleEffects.single.value, 1.5);
    expect(
      whirlwind.effects.ruleEffects.single.condition,
      contains('separate_attack_roll'),
    );

    final volley = rangerHunterMultiattackOptions.singleWhere(
      (option) => option.id == 'volley',
    );
    expect(volley.effects.ruleEffects.single.value, 3);
    expect(
      volley.effects.ruleEffects.single.condition,
      allOf(contains('ammunition_each'), contains('visible_point')),
    );
  });

  test('Superior Hunter Defense contains all three manual options', () {
    expect(
      rangerHunterSuperiorDefenseOptions.map((option) => option.id).toSet(),
      {'evasion', 'stand_against_the_tide', 'uncanny_dodge'},
    );

    final evasion = rangerHunterSuperiorDefenseOptions.singleWhere(
      (option) => option.id == 'evasion',
    );
    expect(
      evasion.effects.ruleEffects.single.condition,
      allOf(contains('success_zero_damage'), contains('failure_half_damage')),
    );

    final tide = rangerHunterSuperiorDefenseOptions.singleWhere(
      (option) => option.id == 'stand_against_the_tide',
    );
    expect(
      tide.effects.ruleEffects.single.type,
      CharacterRuleEffectType.reaction,
    );
    expect(
      tide.effects.ruleEffects.single.condition,
      contains('not_attacker'),
    );

    final dodge = rangerHunterSuperiorDefenseOptions.singleWhere(
      (option) => option.id == 'uncanny_dodge',
    );
    expect(dodge.effects.ruleEffects.single.value, 0.5);
    expect(
      dodge.effects.ruleEffects.single.condition,
      contains('visible_attacker'),
    );
  });

  test('Hunter exposes exactly eleven mutually exclusive options', () {
    final allOptions = {
      ...rangerHunterPreyOptions.map((option) => option.id),
      ...rangerHunterDefensiveTacticsOptions.map((option) => option.id),
      ...rangerHunterMultiattackOptions.map((option) => option.id),
      ...rangerHunterSuperiorDefenseOptions.map((option) => option.id),
    };
    expect(allOptions, hasLength(11));

    for (final feature in hunter.featureDefinitions.values) {
      final choice = feature.choices.single;
      expect(choice.minimumSelections, 1);
      expect(choice.maximumSelections, 1);
      expect(choice.unique, isTrue);
      expect(choice.requireNewAcquisition, isTrue);
    }
  });
}
