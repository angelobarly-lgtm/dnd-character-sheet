import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/cleric_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Light Domain', () {
    final domain = clericLightDomainDefinition;

    test('is registered with the complete PHB progression', () {
      final cleric = phbClassDefinitions[ClassIds.cleric]!;

      expect(cleric.subclasses[ClericSubclassIds.light], same(domain));
      expect(
        domain.featuresByLevel,
        {
          1: ['bonus_cantrip_light', 'warding_flare'],
          2: ['radiance_of_the_dawn'],
          6: ['improved_flare'],
          8: ['potent_spellcasting_light'],
          17: ['corona_of_light'],
        },
      );

      final granted =
          domain.featuresByLevel.values.expand((ids) => ids).toSet();

      expect(domain.featureDefinitions.keys.toSet(), granted);
    });

    test('grants Light without consuming a normal cantrip choice', () {
      final feature = domain.featureDefinitions['bonus_cantrip_light']!;

      expect(feature.spellIds, {SpellIds.light});
      expect(feature.effects.grantedCantripIds, [SpellIds.light]);
      expect(
        feature.ruleTags,
        contains('does_not_count_against_cantrips_known'),
      );
    });

    test('Warding Flare has a subclass-specific Wisdom resource', () {
      expect(domain.resources, hasLength(1));

      final resource = domain.resources.single;

      expect(resource.id, 'light_warding_flare');
      expect(resource.name, 'Interdizione Luminosa');
      expect(resource.minimumLevel, 1);
      expect(resource.recovery, ClassResourceRecovery.longRest);
      expect(resource.maximumAbility, 'SAG');
      expect(resource.minimumMaximum, 1);
      expect(
        resource.maximumAtLevel(
          1,
          abilityModifiers: {'SAG': 4},
        ),
        4,
      );
      expect(
        resource.maximumAtLevel(
          1,
          abilityModifiers: {'SAG': -1},
        ),
        1,
      );

      expect(
        domain.featureDefinitions['warding_flare']!.resourceId,
        resource.id,
      );
      expect(
        domain.featureDefinitions['improved_flare']!.resourceId,
        resource.id,
      );
    });

    test('Radiance of the Dawn consumes Channel Divinity', () {
      final feature = domain.featureDefinitions['radiance_of_the_dawn']!;

      expect(feature.resourceId, 'channel_divinity');
      expect(
        feature.ruleTags,
        containsAll({
          'radiant_damage',
          'damage_2d10_plus_cleric_level',
          'magical_darkness',
        }),
      );
    });

    test('contains all ten PHB domain spells', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.burningHands, SpellIds.faerieFire},
          3: {SpellIds.flamingSphere, SpellIds.scorchingRay},
          5: {SpellIds.daylight, SpellIds.fireball},
          7: {SpellIds.guardianOfFaith, SpellIds.wallOfFire},
          9: {SpellIds.flameStrike, SpellIds.scrying},
        },
      );

      final spells = domain.alwaysPreparedSpellIdsAtLevel(20);

      expect(spells, hasLength(10));
      expect(spells.every(spellDefinitions.containsKey), isTrue);
    });
  });

  group('Nature Domain', () {
    final domain = clericNatureDomainDefinition;

    test('is registered with the complete PHB progression', () {
      final cleric = phbClassDefinitions[ClassIds.cleric]!;

      expect(cleric.subclasses[ClericSubclassIds.nature], same(domain));
      expect(
        domain.featuresByLevel,
        {
          1: ['acolyte_of_nature', 'bonus_proficiency_nature'],
          2: ['charm_animals_and_plants'],
          6: ['dampen_elements'],
          8: ['divine_strike_nature'],
          17: ['master_of_nature'],
        },
      );

      final granted =
          domain.featuresByLevel.values.expand((ids) => ids).toSet();

      expect(domain.featureDefinitions.keys.toSet(), granted);
    });

    test('Acolyte of Nature exposes the cantrip and skill choices', () {
      final feature = domain.featureDefinitions['acolyte_of_nature']!;
      final choices = {
        for (final choice in feature.choices) choice.id: choice,
      };

      final cantrip = choices['nature_domain_druid_cantrip']!;
      expect(cantrip.type, CharacterChoiceType.cantrip);
      expect(cantrip.optionIds, isNotEmpty);
      expect(
        cantrip.optionIds.every(
          (id) =>
              spellDefinitions[id]!.level == 0 &&
              spellDefinitions[id]!.classIds.contains(ClassIds.druid),
        ),
        isTrue,
      );

      final skill = choices['nature_domain_skill']!;
      expect(skill.type, CharacterChoiceType.skill);
      expect(
        skill.optionIds.toSet(),
        {
          'animal_handling',
          'nature',
          'survival',
        },
      );
      expect(skill.requireNewAcquisition, isTrue);
    });

    test('grants heavy armor proficiency', () {
      expect(
        domain.featureDefinitions['bonus_proficiency_nature']!.effects
            .armorProficiencies,
        {'heavy_armor'},
      );
    });

    test('Channel Divinity and elemental protection stay structured', () {
      final channel = domain.featureDefinitions['charm_animals_and_plants']!;
      final protection = domain.featureDefinitions['dampen_elements']!;

      expect(channel.resourceId, 'channel_divinity');
      expect(
        channel.ruleTags,
        containsAll({'beast', 'plant', 'charmed'}),
      );
      expect(
        protection.ruleTags,
        containsAll({
          'temporary_damage_resistance',
          'acid',
          'cold',
          'fire',
          'lightning',
          'thunder',
        }),
      );
    });

    test('contains all ten PHB domain spells', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.animalFriendship, SpellIds.speakWithAnimals},
          3: {SpellIds.barkskin, SpellIds.spikeGrowth},
          5: {SpellIds.plantGrowth, SpellIds.windWall},
          7: {SpellIds.dominateBeast, SpellIds.graspingVine},
          9: {SpellIds.insectPlague, SpellIds.treeStride},
        },
      );

      final spells = domain.alwaysPreparedSpellIdsAtLevel(20);

      expect(spells, hasLength(10));
      expect(spells.every(spellDefinitions.containsKey), isTrue);
    });
  });

  test('Cleric registry contains all domains completed so far', () {
    final cleric = phbClassDefinitions[ClassIds.cleric]!;

    expect(
      cleric.subclasses.keys,
      containsAll({
        ClericSubclassIds.knowledge,
        ClericSubclassIds.light,
        ClericSubclassIds.nature,
        ClericSubclassIds.life,
      }),
    );
  });
}
