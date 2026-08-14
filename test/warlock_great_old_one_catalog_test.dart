import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;
  final greatOldOne = warlock.subclasses[WarlockSubclassIds.greatOldOne]!;

  test('Great Old One is registered as PHB 2014 content', () {
    expect(greatOldOne, same(warlockGreatOldOneDefinition));
    expect(greatOldOne.id, WarlockSubclassIds.greatOldOne);
    expect(greatOldOne.name, 'Il Grande Antico');
    expect(greatOldOne.classId, ClassIds.warlock);
    expect(greatOldOne.content.ownerId, ClassIds.warlock);
    expect(
      greatOldOne.content.source.name,
      'Manuale del Giocatore 2014',
    );
    expect(greatOldOne.content.source.reference, 'p. 118');
    expect(greatOldOne.homebrew, isFalse);
    expect(greatOldOne.supplemental, isFalse);
  });

  test('all three PHB patrons are now registered', () {
    expect(
      warlock.subclasses.keys.toSet(),
      phbWarlockSubclassIds,
    );
  });

  test('expanded spell list contains the ten manual spells', () {
    expect(
      greatOldOne.expandedSpellIdsByLevel,
      phbWarlockGreatOldOneExpandedSpellIdsByLevel,
    );
    expect(greatOldOne.expandedSpellIdsByLevel, hasLength(5));
    expect(greatOldOne.alwaysPreparedSpellIdsByLevel, isEmpty);

    expect(
      greatOldOne.expandedSpellIdsAtLevel(1),
      {'dissonant_whispers', 'tashas_hideous_laughter'},
    );
    expect(greatOldOne.expandedSpellIdsAtLevel(3), hasLength(4));
    expect(greatOldOne.expandedSpellIdsAtLevel(7), hasLength(8));
    expect(greatOldOne.expandedSpellIdsAtLevel(20), hasLength(10));

    const spellLevelByWarlockLevel = <int, int>{
      1: 1,
      3: 2,
      5: 3,
      7: 4,
      9: 5,
    };

    for (final entry in greatOldOne.expandedSpellIdsByLevel.entries) {
      expect(entry.value, hasLength(2));

      for (final spellId in entry.value) {
        expect(spellDefinitions, contains(spellId));
        expect(
          spellDefinitions[spellId]!.level,
          spellLevelByWarlockLevel[entry.key],
        );
      }
    }

    final automaticallyGranted = greatOldOne.featureDefinitions.values
        .expand((feature) => feature.effects.grantedSpellIds)
        .toSet();

    expect(automaticallyGranted, isEmpty);
  });

  test('Great Old One grants features at levels 1, 6, 10 and 14', () {
    expect(
      greatOldOne.featuresByLevel,
      {
        1: [WarlockGreatOldOneFeatureIds.awakenedMind],
        6: [WarlockGreatOldOneFeatureIds.entropicWard],
        10: [WarlockGreatOldOneFeatureIds.thoughtShield],
        14: [WarlockGreatOldOneFeatureIds.createThrall],
      },
    );

    expect(greatOldOne.featureDefinitions, hasLength(4));
  });

  test('Awakened Mind preserves range and language rules', () {
    final feature = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.awakenedMind]!;
    final effect = feature.effects.ruleEffects.single;

    expect(feature.resourceId, isNull);
    expect(effect.target, 'visible_creature_within_meters');
    expect(effect.value, 9);
    expect(effect.condition, contains('no_shared_language_required'));
    expect(effect.condition, contains('at_least_one_language'));
  });

  test('Entropic Ward applies both halves and recovers correctly', () {
    final feature = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.entropicWard]!;

    expect(
      feature.resourceId,
      WarlockGreatOldOneResourceIds.entropicWard,
    );
    expect(feature.effects.ruleEffects, hasLength(2));
    expect(
      feature.effects.ruleEffects.map((effect) => effect.type).toSet(),
      {
        CharacterRuleEffectType.disadvantage,
        CharacterRuleEffectType.advantage,
      },
    );

    final advantage = feature.effects.ruleEffects.singleWhere(
      (effect) => effect.type == CharacterRuleEffectType.advantage,
    );

    expect(
      advantage.target,
      'next_attack_roll_against_same_creature',
    );
    expect(
      advantage.condition,
      contains('triggering_attack_misses'),
    );
    expect(
      advantage.condition,
      contains('end_of_warlock_next_turn'),
    );

    final resource = greatOldOne.resources.single;

    expect(
      resource.id,
      WarlockGreatOldOneResourceIds.entropicWard,
    );
    expect(resource.minimumLevel, 6);
    expect(resource.recovery, ClassResourceRecovery.shortRest);
    expect(resource.maximumAtLevel(20), 1);
  });

  test('Thought Shield protects thoughts and reflects psychic damage', () {
    final feature = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.thoughtShield]!;

    expect(feature.resourceId, isNull);
    expect(feature.effects.damageResistances, {'psychic'});
    expect(feature.effects.ruleEffects, hasLength(2));

    final privacy = feature.effects.ruleEffects.singleWhere(
      (effect) => effect.target == 'thought_reading',
    );

    expect(
      privacy.condition,
      contains('without_warlock_consent'),
    );

    final reflection = feature.effects.ruleEffects.singleWhere(
      (effect) => effect.target == 'creature_dealing_psychic_damage_to_warlock',
    );

    expect(reflection.referenceIds, ['psychic']);
    expect(
      reflection.condition,
      contains('equal_to_damage_dealt'),
    );
  });

  test('Create Thrall preserves charm and planar telepathy', () {
    final feature = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.createThrall]!;

    expect(feature.resourceId, isNull);
    expect(feature.effects.ruleEffects, hasLength(2));

    final charm = feature.effects.ruleEffects.singleWhere(
      (effect) => effect.target == 'incapacitated_humanoid_touched',
    );

    expect(charm.referenceIds, ['remove_curse']);
    expect(charm.condition, contains('feature_used_again'));

    final telepathy = feature.effects.ruleEffects.singleWhere(
      (effect) => effect.target == 'current_charmed_thrall',
    );

    expect(telepathy.condition, contains('same_plane'));
  });

  test('every feature and resource link resolves', () {
    final granted = greatOldOne.featuresByLevel.values
        .expand((features) => features)
        .toSet();

    expect(granted, hasLength(4));
    expect(
      granted,
      greatOldOne.featureDefinitions.keys.toSet(),
    );

    final resourceIds =
        greatOldOne.resources.map((resource) => resource.id).toSet();

    for (final entry in greatOldOne.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(
        entry.value.content.ownerId,
        ClassIds.warlock,
      );
      expect(
        entry.value.content.source.name,
        'Manuale del Giocatore 2014',
      );

      final resourceId = entry.value.resourceId;

      if (resourceId != null) {
        expect(resourceIds, contains(resourceId));
      }
    }
  });
}
