import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/sorcerer_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sorcerer = phbClassDefinitions[ClassIds.sorcerer]!;
  final draconic = sorcerer.subclasses[SorcererSubclassIds.draconicBloodline]!;

  test('Draconic Bloodline identity and source match PHB 2014', () {
    expect(draconic.id, SorcererSubclassIds.draconicBloodline);
    expect(draconic.name, 'Discendenza Draconica');
    expect(draconic.classId, ClassIds.sorcerer);
    expect(draconic.content.ownerId, ClassIds.sorcerer);
    expect(draconic.content.source.name, 'Manuale del Giocatore 2014');
    expect(draconic.content.source.reference, 'pp. 110-111');
    expect(draconic.homebrew, isFalse);
    expect(draconic.supplemental, isFalse);
  });

  test('all ten Draconic Ancestry damage mappings match the manual', () {
    expect(phbSorcererDraconicAncestryDefinitions, hasLength(10));
    expect(
      {
        for (final entry in phbSorcererDraconicAncestryDefinitions.entries)
          entry.key: entry.value.damageType,
      },
      {
        'black': 'acid',
        'blue': 'lightning',
        'brass': 'fire',
        'bronze': 'lightning',
        'copper': 'acid',
        'gold': 'fire',
        'green': 'poison',
        'red': 'fire',
        'silver': 'cold',
        'white': 'cold',
      },
    );
    expect(phbSorcererDraconicAncestryOptions, hasLength(10));
    expect(
      phbSorcererDraconicAncestryOptions.map((option) => option.id).toSet(),
      phbSorcererDraconicAncestryDefinitions.keys.toSet(),
    );
  });

  test('Draconic Ancestry is one persistent choice and grants Draconic', () {
    final feature = draconic
        .featureDefinitions[SorcererDraconicFeatureIds.draconicAncestry]!;
    final choice = feature.choices.single;
    expect(choice.id, 'sorcerer_draconic_ancestry_choice');
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.unique, isTrue);
    expect(choice.options, hasLength(10));
    expect(feature.effects.languages, {'Draconico'});

    final expertise = feature.effects.ruleEffects.single;
    expect(expertise.target, 'charisma_checks_interacting_with_dragons');
    expect(expertise.value, 2);
    expect(expertise.condition, 'double_proficiency_bonus_when_proficient');
  });

  test('Draconic Resilience stores class-level HP and unarmored AC', () {
    final feature = draconic
        .featureDefinitions[SorcererDraconicFeatureIds.draconicResilience]!;
    final effects = {
      for (final effect in feature.effects.ruleEffects) effect.id: effect,
    };
    expect(effects, hasLength(2));
    expect(effects['draconic_resilience_hit_points']?.value, 1);
    expect(
      effects['draconic_resilience_hit_points']?.condition,
      'per_sorcerer_level',
    );
    expect(effects['draconic_resilience_armor_class']?.value, 13);
    expect(
      effects['draconic_resilience_armor_class']?.condition,
      'base_thirteen_plus_dexterity_modifier_without_armor',
    );
  });

  test('Elemental Affinity has damage bonus and one-point resistance', () {
    final feature = draconic
        .featureDefinitions[SorcererDraconicFeatureIds.elementalAffinity]!;
    expect(feature.resourceId, SorcererResourceIds.sorceryPoints);
    expect(feature.effects.ruleEffects.single.type,
        CharacterRuleEffectType.damageBonus);
    expect(
      feature.effects.ruleEffects.single.condition,
      contains('selected_draconic_ancestry'),
    );

    final usage = draconic.resourceUsages.singleWhere(
      (usage) =>
          usage.id == SorcererDraconicUsageIds.elementalAffinityResistance,
    );
    expect(usage.minimumLevel, 6);
    expect(usage.baseResourceCost, 1);
    expect(usage.activation, ClassFeatureActivation.whenCasting);
    expect(usage.resourceId, SorcererResourceIds.sorceryPoints);
    expect(usage.effects.ruleEffects.single.condition, contains('one_hour'));
  });

  test('Dragon Wings use a bonus action and current walking speed', () {
    final feature =
        draconic.featureDefinitions[SorcererDraconicFeatureIds.dragonWings]!;
    final effects = {
      for (final effect in feature.effects.ruleEffects) effect.id: effect,
    };
    expect(
      effects['dragon_wings_activation']?.condition,
      contains('bonus_action'),
    );
    expect(
      effects['dragon_wings_flying_speed']?.type,
      CharacterRuleEffectType.movement,
    );
    expect(
      effects['dragon_wings_flying_speed']?.condition,
      contains('current_walking_speed'),
    );
  });

  test('Draconic Presence costs five points and has the full aura rules', () {
    final usage = draconic.resourceUsages.singleWhere(
      (usage) => usage.id == SorcererDraconicUsageIds.draconicPresence,
    );
    expect(usage.minimumLevel, 18);
    expect(usage.baseResourceCost, 5);
    expect(usage.activation, ClassFeatureActivation.action);
    expect(usage.resourceId, SorcererResourceIds.sorceryPoints);

    final aura = usage.effects.ruleEffects.single;
    expect(aura.value, 18);
    expect(aura.condition, contains('charmed'));
    expect(aura.condition, contains('frightened'));
    expect(aura.condition, contains('concentration_one_minute'));
    expect(aura.condition, contains('immunity_twenty_four_hours'));
  });

  test('Draconic Bloodline grants exactly five features at 1, 6, 14, 18', () {
    expect(draconic.featuresByLevel.keys.toSet(), {1, 6, 14, 18});
    expect(draconic.featuresByLevel[1], hasLength(2));
    final granted =
        draconic.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(5));
    expect(granted, draconic.featureDefinitions.keys.toSet());
    for (final entry in draconic.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.sorcerer);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Sorcerer registry contains Draconic Bloodline incrementally', () {
    expect(
      sorcerer.subclasses.keys,
      contains(SorcererSubclassIds.draconicBloodline),
    );
    expect(
      sorcerer.subclasses.keys.toSet().difference(phbSorcererSubclassIds),
      isEmpty,
    );
  });
}
