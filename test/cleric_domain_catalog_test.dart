import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/cleric_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('universal always-prepared subclass spells', () {
    test('accumulates spell grants up to the requested class level', () {
      final subclass = clericKnowledgeDomainDefinition;

      expect(subclass.alwaysPreparedSpellIdsAtLevel(0), isEmpty);
      expect(
        subclass.alwaysPreparedSpellIdsAtLevel(1),
        {
          SpellIds.command,
          SpellIds.identify,
        },
      );
      expect(subclass.alwaysPreparedSpellIdsAtLevel(4), hasLength(4));
      expect(subclass.alwaysPreparedSpellIdsAtLevel(9), hasLength(10));
      expect(subclass.alwaysPreparedSpellIdsAtLevel(20), hasLength(10));
    });
  });

  group('Knowledge Domain', () {
    final domain = clericKnowledgeDomainDefinition;

    test('is registered at Cleric level 1', () {
      final cleric = phbClassDefinitions[ClassIds.cleric]!;

      expect(cleric.subclassSelectionLevel, 1);
      expect(
          cleric.subclasses.keys,
          containsAll({
            ClericSubclassIds.knowledge,
            ClericSubclassIds.life,
          }));
      expect(cleric.subclasses[ClericSubclassIds.knowledge], same(domain));
      expect(domain.classId, ClassIds.cleric);
      expect(domain.homebrew, isFalse);
      expect(domain.supplemental, isFalse);
    });

    test('has the complete PHB feature progression', () {
      expect(
        domain.featuresByLevel,
        {
          1: ['blessings_of_knowledge'],
          2: ['knowledge_of_the_ages'],
          6: ['read_thoughts'],
          8: ['potent_spellcasting_knowledge'],
          17: ['visions_of_the_past'],
        },
      );

      final granted =
          domain.featuresByLevel.values.expand((ids) => ids).toSet();
      expect(domain.featureDefinitions.keys.toSet(), granted);
    });

    test('Blessings of Knowledge exposes both permanent choices', () {
      final feature = domain.featureDefinitions['blessings_of_knowledge']!;
      final choices = {
        for (final choice in feature.choices) choice.id: choice,
      };

      expect(choices.keys, {
        'knowledge_domain_languages',
        'knowledge_domain_skills',
      });

      final languages = choices['knowledge_domain_languages']!;
      expect(languages.type, CharacterChoiceType.language);
      expect(languages.minimumSelections, 2);
      expect(languages.maximumSelections, 2);
      expect(languages.optionIds, characterLanguageIds);
      expect(languages.requireNewAcquisition, isTrue);

      final skills = choices['knowledge_domain_skills']!;
      expect(skills.type, CharacterChoiceType.skill);
      expect(skills.minimumSelections, 2);
      expect(skills.maximumSelections, 2);
      expect(
        skills.optionIds.toSet(),
        {
          'arcana',
          'history',
          'nature',
          'religion',
        },
      );
      expect(feature.ruleTags, contains('double_proficiency'));
    });

    test('contains all ten domain spells at their PHB levels', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.command, SpellIds.identify},
          3: {SpellIds.augury, SpellIds.suggestion},
          5: {SpellIds.nondetection, SpellIds.speakWithDead},
          7: {SpellIds.arcaneEye, SpellIds.confusion},
          9: {SpellIds.legendLore, SpellIds.scrying},
        },
      );

      expect(
        domain
            .alwaysPreparedSpellIdsAtLevel(20)
            .every(spellDefinitions.containsKey),
        isTrue,
      );
    });

    test('both Channel Divinity features consume the Cleric resource', () {
      expect(
        domain.featureDefinitions['knowledge_of_the_ages']!.resourceId,
        'channel_divinity',
      );
      expect(
        domain.featureDefinitions['read_thoughts']!.resourceId,
        'channel_divinity',
      );
      expect(
        domain.featureDefinitions['read_thoughts']!.spellIds,
        {SpellIds.suggestion},
      );
    });
  });

  group('Life Domain', () {
    final domain = clericLifeDomainDefinition;

    test('is registered and has the complete feature progression', () {
      final cleric = phbClassDefinitions[ClassIds.cleric]!;

      expect(cleric.subclasses[ClericSubclassIds.life], same(domain));
      expect(
        domain.featuresByLevel,
        {
          1: ['bonus_proficiency_life', 'disciple_of_life'],
          2: ['preserve_life'],
          6: ['blessed_healer'],
          8: ['divine_strike_life'],
          17: ['supreme_healing'],
        },
      );

      final granted =
          domain.featuresByLevel.values.expand((ids) => ids).toSet();
      expect(domain.featureDefinitions.keys.toSet(), granted);
    });

    test('grants heavy armor proficiency', () {
      expect(
        domain.featureDefinitions['bonus_proficiency_life']!.effects
            .armorProficiencies,
        {'heavy_armor'},
      );
    });

    test('contains all ten domain spells at their PHB levels', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.bless, SpellIds.cureWounds},
          3: {SpellIds.lesserRestoration, SpellIds.spiritualWeapon},
          5: {SpellIds.beaconOfHope, SpellIds.revivify},
          7: {SpellIds.deathWard, SpellIds.guardianOfFaith},
          9: {SpellIds.massCureWounds, SpellIds.raiseDead},
        },
      );

      expect(domain.alwaysPreparedSpellIdsAtLevel(8), hasLength(8));
      expect(domain.alwaysPreparedSpellIdsAtLevel(20), hasLength(10));
      expect(
        domain
            .alwaysPreparedSpellIdsAtLevel(20)
            .every(spellDefinitions.containsKey),
        isTrue,
      );
    });

    test('Preserve Life consumes Channel Divinity', () {
      final feature = domain.featureDefinitions['preserve_life']!;

      expect(feature.resourceId, 'channel_divinity');
      expect(feature.ruleTags, contains('five_times_cleric_level'));
      expect(feature.ruleTags, contains('half_hit_points_limit'));
    });

    test('healing and Divine Strike rules remain structured', () {
      expect(
        domain.featureDefinitions['disciple_of_life']!.ruleTags,
        contains('healing_bonus_2_plus_spell_level'),
      );
      expect(
        domain.featureDefinitions['blessed_healer']!.ruleTags,
        contains('healing_bonus_2_plus_spell_level'),
      );
      expect(
        domain.featureDefinitions['divine_strike_life']!.ruleTags,
        containsAll({
          'radiant_damage',
          'damage_1d8',
          'damage_2d8_at_14',
        }),
      );
      expect(
        domain.featureDefinitions['supreme_healing']!.ruleTags,
        contains('maximum_healing_dice'),
      );
    });
  });
}
