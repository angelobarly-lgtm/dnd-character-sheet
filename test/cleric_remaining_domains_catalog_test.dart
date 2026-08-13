import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/cleric_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void expectCompleteDomain(
  CharacterSubclassDefinition domain,
  Map<int, List<String>> expectedProgression,
) {
  expect(domain.featuresByLevel, expectedProgression);

  final granted = domain.featuresByLevel.values.expand((ids) => ids).toSet();

  expect(domain.featureDefinitions.keys.toSet(), granted);
  expect(domain.alwaysPreparedSpellIdsAtLevel(20), hasLength(10));
  expect(
    domain
        .alwaysPreparedSpellIdsAtLevel(20)
        .every(spellDefinitions.containsKey),
    isTrue,
  );
}

void main() {
  group('Tempest Domain', () {
    final domain = clericTempestDomainDefinition;

    test('has the complete PHB progression', () {
      expectCompleteDomain(
        domain,
        {
          1: [
            'bonus_proficiencies_tempest',
            'wrath_of_the_storm',
          ],
          2: ['destructive_wrath'],
          6: ['thunderbolt_strike'],
          8: ['divine_strike_tempest'],
          17: ['stormborn'],
        },
      );
    });

    test('grants martial weapons and heavy armor', () {
      final effects =
          domain.featureDefinitions['bonus_proficiencies_tempest']!.effects;

      expect(effects.weaponProficiencies, {'martial_weapons'});
      expect(effects.armorProficiencies, {'heavy_armor'});
    });

    test('Wrath of the Storm uses Wisdom and a long-rest resource', () {
      final resource = domain.resources.single;

      expect(resource.id, 'tempest_wrath_of_the_storm');
      expect(resource.maximumAbility, 'SAG');
      expect(resource.minimumMaximum, 1);
      expect(resource.recovery, ClassResourceRecovery.longRest);
      expect(
        resource.maximumAtLevel(
          1,
          abilityModifiers: {'SAG': 3},
        ),
        3,
      );
      expect(
        domain.featureDefinitions['wrath_of_the_storm']!.resourceId,
        resource.id,
      );
    });

    test('contains all ten PHB domain spells', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.fogCloud, SpellIds.thunderwave},
          3: {SpellIds.gustOfWind, SpellIds.shatter},
          5: {SpellIds.callLightning, SpellIds.sleetStorm},
          7: {SpellIds.controlWater, SpellIds.iceStorm},
          9: {SpellIds.destructiveWave, SpellIds.insectPlague},
        },
      );
    });
  });

  group('Trickery Domain', () {
    final domain = clericTrickeryDomainDefinition;

    test('has the complete PHB progression', () {
      expectCompleteDomain(
        domain,
        {
          1: ['blessing_of_the_trickster'],
          2: ['invoke_duplicity'],
          6: ['cloak_of_shadows'],
          8: ['divine_strike_trickery'],
          17: ['improved_duplicity'],
        },
      );
    });

    test('both special Channel Divinity options use the shared resource', () {
      expect(
        domain.featureDefinitions['invoke_duplicity']!.resourceId,
        'channel_divinity',
      );
      expect(
        domain.featureDefinitions['cloak_of_shadows']!.resourceId,
        'channel_divinity',
      );
    });

    test('contains all ten PHB domain spells', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.charmPerson, SpellIds.disguiseSelf},
          3: {SpellIds.mirrorImage, SpellIds.passWithoutTrace},
          5: {SpellIds.blink, SpellIds.dispelMagic},
          7: {SpellIds.dimensionDoor, SpellIds.polymorph},
          9: {SpellIds.dominatePerson, SpellIds.modifyMemory},
        },
      );
    });

    test('Improved Duplicity retains the four-duplicate rule', () {
      expect(
        domain.featureDefinitions['improved_duplicity']!.ruleTags,
        contains('four_duplicates'),
      );
    });
  });

  group('War Domain', () {
    final domain = clericWarDomainDefinition;

    test('has the complete PHB progression', () {
      expectCompleteDomain(
        domain,
        {
          1: [
            'bonus_proficiencies_war',
            'war_priest',
          ],
          2: ['guided_strike'],
          6: ['war_gods_blessing'],
          8: ['divine_strike_war'],
          17: ['avatar_of_battle'],
        },
      );
    });

    test('grants martial weapons and heavy armor', () {
      final effects =
          domain.featureDefinitions['bonus_proficiencies_war']!.effects;

      expect(effects.weaponProficiencies, {'martial_weapons'});
      expect(effects.armorProficiencies, {'heavy_armor'});
    });

    test('War Priest uses Wisdom and a long-rest resource', () {
      final resource = domain.resources.single;

      expect(resource.id, 'war_priest');
      expect(resource.maximumAbility, 'SAG');
      expect(resource.minimumMaximum, 1);
      expect(resource.recovery, ClassResourceRecovery.longRest);
      expect(
        resource.maximumAtLevel(
          1,
          abilityModifiers: {'SAG': 4},
        ),
        4,
      );
      expect(
        domain.featureDefinitions['war_priest']!.resourceId,
        resource.id,
      );
    });

    test('contains all ten PHB domain spells', () {
      expect(
        domain.alwaysPreparedSpellIdsByLevel,
        {
          1: {SpellIds.divineFavor, SpellIds.shieldOfFaith},
          3: {SpellIds.magicWeapon, SpellIds.spiritualWeapon},
          5: {SpellIds.crusadersMantle, SpellIds.spiritGuardians},
          7: {SpellIds.freedomOfMovement, SpellIds.stoneskin},
          9: {SpellIds.flameStrike, SpellIds.holdMonster},
        },
      );
    });

    test('both attack bonuses consume Channel Divinity', () {
      expect(
        domain.featureDefinitions['guided_strike']!.resourceId,
        'channel_divinity',
      );
      expect(
        domain.featureDefinitions['war_gods_blessing']!.resourceId,
        'channel_divinity',
      );
      expect(
        domain.featureDefinitions['guided_strike']!.ruleTags,
        contains('bonus_10'),
      );
    });
  });

  test('Cleric registry contains exactly the seven PHB domains', () {
    final cleric = phbClassDefinitions[ClassIds.cleric]!;

    expect(
      cleric.subclasses.keys.toSet(),
      {
        ClericSubclassIds.knowledge,
        ClericSubclassIds.war,
        ClericSubclassIds.trickery,
        ClericSubclassIds.light,
        ClericSubclassIds.nature,
        ClericSubclassIds.tempest,
        ClericSubclassIds.life,
      },
    );

    expect(
      cleric.subclasses.values.every(
        (domain) =>
            !domain.homebrew &&
            !domain.supplemental &&
            domain.classId == ClassIds.cleric,
      ),
      isTrue,
    );
  });
}
