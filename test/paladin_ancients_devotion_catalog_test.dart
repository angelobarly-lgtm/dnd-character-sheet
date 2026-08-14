import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/paladin_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final paladin = phbClassDefinitions[ClassIds.paladin]!;
  final ancients = paladin.subclasses[PaladinSubclassIds.ancients]!;
  final devotion = paladin.subclasses[PaladinSubclassIds.devotion]!;

  const expectedAncientsSpells = <String>{
    'ensnaring_strike',
    'speak_with_animals',
    'moonbeam',
    'misty_step',
    'plant_growth',
    'protection_from_energy',
    'ice_storm',
    'stoneskin',
    'commune_with_nature',
    'tree_stride',
  };

  const expectedDevotionSpells = <String>{
    'protection_from_evil_and_good',
    'sanctuary',
    'lesser_restoration',
    'zone_of_truth',
    'beacon_of_hope',
    'dispel_magic',
    'freedom_of_movement',
    'guardian_of_faith',
    'commune',
    'flame_strike',
  };

  test('Ancients and Devotion are registered incrementally', () {
    expect(
      paladin.subclasses.keys,
      containsAll({
        PaladinSubclassIds.ancients,
        PaladinSubclassIds.devotion,
      }),
    );
    expect(ancients.name, 'Giuramento degli Antichi');
    expect(devotion.name, 'Giuramento di Devozione');
    expect(ancients.classId, ClassIds.paladin);
    expect(devotion.classId, ClassIds.paladin);
    expect(ancients.homebrew, isFalse);
    expect(devotion.homebrew, isFalse);
  });

  test('both oaths use the canonical Paladin milestones', () {
    for (final oath in [ancients, devotion]) {
      expect(oath.featuresByLevel.keys.toSet(), {3, 7, 15, 20});

      final granted =
          oath.featuresByLevel.values.expand((features) => features).toSet();

      expect(granted, hasLength(5));
      expect(
        granted.difference(oath.featureDefinitions.keys.toSet()),
        isEmpty,
      );

      for (final entry in oath.featureDefinitions.entries) {
        expect(entry.value.content.id, entry.key);
        expect(entry.value.content.ownerId, oath.id);
        expect(entry.value.content.source.isEmpty, isFalse);
      }
    }
  });

  test('Oath spells are always prepared at the correct levels', () {
    expect(ancients.alwaysPreparedSpellIdsAtLevel(2), isEmpty);
    expect(
      ancients.alwaysPreparedSpellIdsAtLevel(3),
      {
        'ensnaring_strike',
        'speak_with_animals',
      },
    );
    expect(
      ancients.alwaysPreparedSpellIdsAtLevel(17),
      expectedAncientsSpells,
    );

    expect(devotion.alwaysPreparedSpellIdsAtLevel(2), isEmpty);
    expect(
      devotion.alwaysPreparedSpellIdsAtLevel(3),
      {
        'protection_from_evil_and_good',
        'sanctuary',
      },
    );
    expect(
      devotion.alwaysPreparedSpellIdsAtLevel(17),
      expectedDevotionSpells,
    );

    final allOathSpells = {
      ...expectedAncientsSpells,
      ...expectedDevotionSpells,
    };

    expect(
      allOathSpells.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final oath in [ancients, devotion]) {
      expect(oath.alwaysPreparedSpellIdsAtLevel(3), hasLength(2));
      expect(oath.alwaysPreparedSpellIdsAtLevel(5), hasLength(4));
      expect(oath.alwaysPreparedSpellIdsAtLevel(9), hasLength(6));
      expect(oath.alwaysPreparedSpellIdsAtLevel(13), hasLength(8));
      expect(oath.alwaysPreparedSpellIdsAtLevel(17), hasLength(10));
    }
  });

  test('all four Channel Divinity options use the base resource', () {
    const featureIds = {
      PaladinAncientsFeatureIds.naturesWrath,
      PaladinAncientsFeatureIds.turnTheFaithless,
      PaladinDevotionFeatureIds.sacredWeapon,
      PaladinDevotionFeatureIds.turnTheUnholy,
    };

    final definitions = {
      ...ancients.featureDefinitions,
      ...devotion.featureDefinitions,
    };

    for (final featureId in featureIds) {
      expect(
        definitions[featureId]!.resourceId,
        PaladinResourceIds.channelDivinity,
      );
      expect(
        definitions[featureId]!.ruleTags,
        contains('channel_divinity'),
      );
    }

    expect(
      paladin.resources.any(
        (resource) => resource.id == PaladinResourceIds.channelDivinity,
      ),
      isTrue,
    );
  });

  test('Oath of the Ancients features are structurally complete', () {
    final wrath = ancients
        .featureDefinitions[PaladinAncientsFeatureIds.naturesWrath]!
        .effects
        .ruleEffects
        .single;
    expect(wrath.type, CharacterRuleEffectType.conditional);
    expect(wrath.value, 3);
    expect(wrath.target, contains('restrained'));

    final turn = ancients
        .featureDefinitions[PaladinAncientsFeatureIds.turnTheFaithless]!
        .effects
        .ruleEffects
        .single;
    expect(turn.value, 9);
    expect(turn.target, contains('fey'));

    final aura = ancients
        .featureDefinitions[PaladinAncientsFeatureIds.auraOfWarding]!
        .effects
        .ruleEffects
        .single;
    expect(
      aura.referenceIds,
      contains(PaladinProgressionIds.auraRadiusMeters),
    );
    expect(aura.target, contains('spell_damage_resistance'));

    final sentinel = ancients.resources.singleWhere(
      (resource) => resource.id == PaladinOathResourceIds.undyingSentinel,
    );
    expect(sentinel.maximumAtLevel(14), 0);
    expect(sentinel.maximumAtLevel(15), 1);
    expect(sentinel.recovery, ClassResourceRecovery.longRest);

    final champion = ancients.resources.singleWhere(
      (resource) => resource.id == PaladinOathResourceIds.elderChampion,
    );
    expect(champion.maximumAtLevel(19), 0);
    expect(champion.maximumAtLevel(20), 1);

    final championEffects = ancients
        .featureDefinitions[PaladinAncientsFeatureIds.elderChampion]!
        .effects
        .ruleEffects;
    expect(championEffects, hasLength(4));
    expect(
      championEffects.any(
        (effect) => effect.type == CharacterRuleEffectType.spellcasting,
      ),
      isTrue,
    );
    expect(
      championEffects.any(
        (effect) => effect.type == CharacterRuleEffectType.disadvantage,
      ),
      isTrue,
    );
  });

  test('Oath of Devotion features are structurally complete', () {
    final sacredWeaponEffects = devotion
        .featureDefinitions[PaladinDevotionFeatureIds.sacredWeapon]!
        .effects
        .ruleEffects;

    expect(
      sacredWeaponEffects.any(
        (effect) => effect.type == CharacterRuleEffectType.attackBonus,
      ),
      isTrue,
    );
    expect(
      sacredWeaponEffects.any((effect) => effect.value == 6),
      isTrue,
    );

    final turn = devotion
        .featureDefinitions[PaladinDevotionFeatureIds.turnTheUnholy]!
        .effects
        .ruleEffects
        .single;
    expect(turn.value, 9);
    expect(turn.target, contains('undead'));

    final aura = devotion
        .featureDefinitions[PaladinDevotionFeatureIds.auraOfDevotion]!
        .effects
        .ruleEffects
        .single;
    expect(
      aura.referenceIds,
      contains(PaladinProgressionIds.auraRadiusMeters),
    );
    expect(aura.target, contains('charmed_immunity'));

    final purity =
        devotion.featureDefinitions[PaladinDevotionFeatureIds.purityOfSpirit]!;
    expect(
      purity.spellIds,
      {'protection_from_evil_and_good'},
    );
    expect(
      purity.effects.grantedSpellIds,
      contains('protection_from_evil_and_good'),
    );

    final nimbus = devotion.resources.singleWhere(
      (resource) => resource.id == PaladinOathResourceIds.holyNimbus,
    );
    expect(nimbus.maximumAtLevel(19), 0);
    expect(nimbus.maximumAtLevel(20), 1);
    expect(nimbus.recovery, ClassResourceRecovery.longRest);

    final nimbusEffects = devotion
        .featureDefinitions[PaladinDevotionFeatureIds.holyNimbus]!
        .effects
        .ruleEffects;
    expect(nimbusEffects, hasLength(3));
    expect(
      nimbusEffects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.damageBonus &&
            effect.value == 10,
      ),
      isTrue,
    );
    expect(
      nimbusEffects.any(
        (effect) => effect.type == CharacterRuleEffectType.advantage,
      ),
      isTrue,
    );
  });

  test('subclass auras reuse the Paladin progressive radius', () {
    expect(
      paladin.progressionValue(
        PaladinProgressionIds.auraRadiusMeters,
        7,
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

    final auraEffects = [
      ancients.featureDefinitions[PaladinAncientsFeatureIds.auraOfWarding]!
          .effects.ruleEffects.single,
      devotion.featureDefinitions[PaladinDevotionFeatureIds.auraOfDevotion]!
          .effects.ruleEffects.single,
    ];

    for (final effect in auraEffects) {
      expect(
        effect.referenceIds,
        contains(PaladinProgressionIds.auraRadiusMeters),
      );
    }
  });
}
