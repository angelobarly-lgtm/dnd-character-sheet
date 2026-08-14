import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/rogue_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rogue = phbClassDefinitions[ClassIds.rogue]!;
  final arcaneTrickster = rogue.subclasses[RogueSubclassIds.arcaneTrickster]!;
  final spellcasting = arcaneTrickster.spellcasting!;

  test('Arcane Trickster is registered as a PHB Rogue archetype', () {
    expect(
      rogue.subclasses,
      contains(RogueSubclassIds.arcaneTrickster),
    );
    expect(arcaneTrickster.name, 'Mistificatore Arcano');
    expect(arcaneTrickster.classId, ClassIds.rogue);
    expect(arcaneTrickster.homebrew, isFalse);
    expect(arcaneTrickster.supplemental, isFalse);
    expect(arcaneTrickster.content.ownerId, ClassIds.rogue);
    expect(arcaneTrickster.content.source.isEmpty, isFalse);
  });

  test('Arcane Trickster grants all five PHB features', () {
    expect(
      arcaneTrickster.featuresByLevel,
      {
        3: [
          ArcaneTricksterFeatureIds.spellcasting,
          ArcaneTricksterFeatureIds.mageHandLegerdemain,
        ],
        9: [
          ArcaneTricksterFeatureIds.magicalAmbush,
        ],
        13: [
          ArcaneTricksterFeatureIds.versatileTrickster,
        ],
        17: [
          ArcaneTricksterFeatureIds.spellThief,
        ],
      },
    );

    final granted = arcaneTrickster.featuresByLevel.values
        .expand((features) => features)
        .toSet();

    expect(granted, hasLength(5));
    expect(
      granted,
      arcaneTrickster.featureDefinitions.keys.toSet(),
    );
  });

  test('Arcane Trickster uses Intelligence and third-caster slots', () {
    expect(
      spellcasting.progression,
      ClassSpellcastingProgression.third,
    );
    expect(spellcasting.ability, 'INT');
    expect(spellcasting.minimumLevel, 3);

    expect(spellcasting.slotsAtLevel(3), [2]);
    expect(spellcasting.slotsAtLevel(7), [4, 2]);
    expect(spellcasting.slotsAtLevel(13), [4, 3, 2]);
    expect(spellcasting.slotsAtLevel(19), [4, 3, 3, 1]);
    expect(spellcasting.slotsAtLevel(20), [4, 3, 3, 1]);
  });

  test('Cantrips and spells known follow the PHB table', () {
    expect(spellcasting.cantripsKnownAtLevel(2), 0);
    expect(spellcasting.cantripsKnownAtLevel(3), 3);
    expect(spellcasting.cantripsKnownAtLevel(9), 3);
    expect(spellcasting.cantripsKnownAtLevel(10), 4);
    expect(spellcasting.cantripsKnownAtLevel(20), 4);

    expect(spellcasting.spellsKnownAtLevel(3), 3);
    expect(spellcasting.spellsKnownAtLevel(8), 6);
    expect(spellcasting.spellsKnownAtLevel(14), 10);
    expect(spellcasting.spellsKnownAtLevel(20), 13);
  });

  test('Mage Hand is mandatory and linked to both related features', () {
    expect(spellDefinitions, contains(SpellIds.mageHand));
    expect(spellcasting.spellIds, contains(SpellIds.mageHand));

    final castingFeature = arcaneTrickster
        .featureDefinitions[ArcaneTricksterFeatureIds.spellcasting]!;
    final legerdemain = arcaneTrickster
        .featureDefinitions[ArcaneTricksterFeatureIds.mageHandLegerdemain]!;

    expect(castingFeature.spellIds, contains(SpellIds.mageHand));
    expect(legerdemain.spellIds, contains(SpellIds.mageHand));

    expect(
      legerdemain.effects.ruleEffects.map((effect) => effect.target),
      containsAll({
        'mage_hand_visibility',
        'mage_hand_additional_uses',
        'control_mage_hand',
      }),
    );
  });

  test('All linked spells belong to the canonical Wizard list', () {
    expect(arcaneTricksterWizardSpellIds, isNotEmpty);
    expect(
      arcaneTricksterWizardSpellIds,
      spellcasting.spellIds,
    );

    for (final id in spellcasting.spellIds) {
      final spell = spellDefinitions[id];

      expect(
        spell,
        isNotNull,
        reason: 'Incantesimo inesistente: $id',
      );
      expect(
        spell!.classIds,
        contains(ClassIds.wizard),
        reason: 'Incantesimo non appartenente al Mago: $id',
      );
    }
  });

  test('Spell learning pools enforce Enchantment and Illusion', () {
    expect(spellcasting.learningPools, hasLength(2));

    final restricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == ArcaneTricksterSpellPoolIds.enchantmentAndIllusion,
    );
    final unrestricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == ArcaneTricksterSpellPoolIds.unrestricted,
    );

    expect(
      restricted.allowedSchoolIds,
      {
        'enchantment',
        'illusion',
      },
    );
    expect(restricted.allowsSchool('enchantment'), isTrue);
    expect(restricted.allowsSchool('illusion'), isTrue);
    expect(restricted.allowsSchool('evocation'), isFalse);

    expect(restricted.knownAtLevel(3), 2);
    expect(restricted.knownAtLevel(19), 9);

    expect(unrestricted.allowedSchoolIds, isEmpty);
    expect(unrestricted.allowsSchool('evocation'), isTrue);
    expect(unrestricted.knownAtLevel(3), 1);
    expect(unrestricted.knownAtLevel(20), 4);

    expect(spellcasting.spellsKnownFromPoolsAtLevel(3), 3);
    expect(spellcasting.spellsKnownFromPoolsAtLevel(20), 13);
  });

  test('Magical Ambush imposes disadvantage while hidden', () {
    final feature = arcaneTrickster
        .featureDefinitions[ArcaneTricksterFeatureIds.magicalAmbush]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.disadvantage);
    expect(effect.target, 'saving_throws_against_rogue_spell');
    expect(
      effect.condition,
      'rogue_hidden_from_target_when_spell_is_cast_during_same_turn',
    );
  });

  test('Versatile Trickster uses Mage Hand within 1.5 meters', () {
    final feature = arcaneTrickster
        .featureDefinitions[ArcaneTricksterFeatureIds.versatileTrickster]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.type, CharacterRuleEffectType.advantage);
    expect(effect.value, 1.5);
    expect(effect.referenceIds, contains(SpellIds.mageHand));
    expect(
      effect.condition,
      'bonus_action_target_within_1_5_meters_of_mage_hand_until_end_of_turn',
    );
  });

  test('Spell Thief is a once-per-long-rest level 17 resource', () {
    final resource = arcaneTrickster.resources.single;
    final feature = arcaneTrickster
        .featureDefinitions[ArcaneTricksterFeatureIds.spellThief]!;

    expect(resource.id, ArcaneTricksterResourceIds.spellThief);
    expect(resource.name, 'Ladro di Incantesimi');
    expect(resource.minimumLevel, 17);
    expect(
      resource.recovery,
      ClassResourceRecovery.longRest,
    );
    expect(resource.maximumAtLevel(16), 0);
    expect(resource.maximumAtLevel(17), 1);
    expect(resource.maximumAtLevel(20), 1);

    expect(
      feature.resourceId,
      ArcaneTricksterResourceIds.spellThief,
    );

    final effects = feature.effects.ruleEffects;

    expect(
      effects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.reaction &&
            effect.target == 'spell_targeting_or_including_rogue',
      ),
      isTrue,
    );

    final duration = effects.singleWhere(
      (effect) => effect.target == 'stolen_spell_duration_hours',
    );

    expect(duration.value, 8);
    expect(
      duration.condition,
      'spell_level_at_least_one_and_not_above_rogue_casting_limit',
    );
  });

  test('Every Arcane Trickster feature has coherent identity', () {
    for (final entry in arcaneTrickster.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(
        feature.content.ownerId,
        RogueSubclassIds.arcaneTrickster,
      );
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
      expect(feature.ruleTags, contains('subclass_feature'));
      expect(feature.ruleTags, contains('rogue'));
      expect(feature.ruleTags, contains('arcane_trickster'));
    }
  });
}
