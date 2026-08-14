import 'package:dnd_character_sheet/data/ammunition_data.dart';
import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;

  test('Warlock is registered as PHB 2014 content', () {
    expect(warlock, same(warlockClassDefinition));
    expect(phbClassDefinitionFor(ClassIds.warlock), same(warlock));
    expect(warlock.id, ClassIds.warlock);
    expect(warlock.name, 'Warlock');
    expect(warlock.hitDie, 8);
    expect(warlock.subclassSelectionLevel, 1);
    expect(warlock.homebrew, isFalse);
    expect(warlock.content.source.name, 'Manuale del Giocatore 2014');
  });

  test('Warlock has the canonical PHB proficiencies', () {
    expect(warlock.proficiencies.armor, {'light_armor'});
    expect(warlock.proficiencies.weapons, {'simple_weapons'});
    expect(warlock.proficiencies.tools, isEmpty);
    expect(warlock.proficiencies.savingThrows, {'SAG', 'CAR'});
    expect(
      warlock.proficiencies.skillOptions,
      {
        'arcana',
        'investigation',
        'deception',
        'intimidation',
        'nature',
        'religion',
        'history',
      },
    );
    expect(warlock.proficiencies.skillChoices, 2);

    final skillChoice = warlock.proficiencies.choices.single;
    expect(skillChoice.selections, 2);
    expect(skillChoice.optionIds, warlock.proficiencies.skillOptions);
  });

  test('Warlock starting equipment preserves every PHB choice', () {
    expect(warlock.startingEquipmentChoices, hasLength(4));
    expect(warlock.fixedStartingEquipment, hasLength(2));

    final primary = warlock.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'warlock_primary_weapon',
    );
    expect(primary.alternatives, hasLength(2));

    final crossbow = primary.alternatives.singleWhere(
      (alternative) => alternative.id == 'warlock_light_crossbow',
    );
    expect(
      crossbow.grants.map((grant) => grant.itemId).toSet(),
      {'light_crossbow', AmmunitionIds.crossbowBolts},
    );
    expect(
      crossbow.grants
          .singleWhere(
            (grant) => grant.itemId == AmmunitionIds.crossbowBolts,
          )
          .quantity,
      20,
    );

    final expectedSimpleWeapons = weaponDefinitions.values
        .where((weapon) => weapon.category == WeaponCategory.simple)
        .map((weapon) => weapon.id)
        .toSet();

    final simplePrimary = primary.alternatives.singleWhere(
      (alternative) => alternative.id == 'warlock_simple_weapon',
    );
    expect(
      simplePrimary.itemChoices.single.optionIds,
      expectedSimpleWeapons,
    );

    final focus = warlock.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'warlock_spellcasting_focus',
    );
    expect(focus.alternatives, hasLength(2));
    expect(
      focus.alternatives.first.grants.single.itemId,
      FocusIds.componentPouch,
    );
    expect(
      focus.alternatives.last.itemChoices.single.optionIds,
      {
        FocusIds.crystal,
        FocusIds.orb,
        FocusIds.rod,
        FocusIds.staff,
        FocusIds.wand,
      },
    );

    final pack = warlock.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'warlock_starting_pack',
    );
    expect(
      pack.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      {'scholar_pack', 'dungeoneer_pack'},
    );

    final additionalWeapon = warlock.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'warlock_additional_simple_weapon',
    );
    expect(
      additionalWeapon.alternatives.single.itemChoices.single.optionIds,
      expectedSimpleWeapons,
    );

    expect(
      warlock.fixedStartingEquipment.map((grant) => grant.itemId).toSet(),
      {ArmorIds.leather, 'dagger'},
    );
    expect(
      warlock.fixedStartingEquipment
          .singleWhere((grant) => grant.itemId == 'dagger')
          .quantity,
      2,
    );
  });

  test('Pact Magic has the complete PHB progression', () {
    final magic = warlock.spellcasting!;

    expect(magic.progression, ClassSpellcastingProgression.pact);
    expect(magic.ability, 'CAR');
    expect(magic.minimumLevel, 1);
    expect(magic.preparesSpells, isFalse);
    expect(magic.ritualCasting, isFalse);
    expect(magic.spellIds, hasLength(74));
    expect(
      magic.spellIds.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );

    expect(magic.cantripsKnownAtLevel(1), 2);
    expect(magic.cantripsKnownAtLevel(4), 3);
    expect(magic.cantripsKnownAtLevel(10), 4);
    expect(magic.cantripsKnownAtLevel(20), 4);

    expect(magic.spellsKnownAtLevel(1), 2);
    expect(magic.spellsKnownAtLevel(5), 6);
    expect(magic.spellsKnownAtLevel(10), 10);
    expect(magic.spellsKnownAtLevel(11), 11);
    expect(magic.spellsKnownAtLevel(20), 15);

    expect(magic.slotsAtLevel(1), [1]);
    expect(magic.slotsAtLevel(3), [0, 2]);
    expect(magic.slotsAtLevel(5), [0, 0, 2]);
    expect(magic.slotsAtLevel(9), [0, 0, 0, 0, 2]);
    expect(magic.slotsAtLevel(11), [0, 0, 0, 0, 3]);
    expect(magic.slotsAtLevel(17), [0, 0, 0, 0, 4]);

    expect(magic.pactSlotLevelAtLevel(1), 1);
    expect(magic.pactSlotLevelAtLevel(3), 2);
    expect(magic.pactSlotLevelAtLevel(5), 3);
    expect(magic.pactSlotLevelAtLevel(7), 4);
    expect(magic.pactSlotLevelAtLevel(9), 5);
    expect(magic.pactSlotLevelAtLevel(20), 5);
  });

  test('Pact Magic slots recover on a short rest', () {
    final slots = warlock.resources.singleWhere(
      (resource) => resource.id == WarlockResourceIds.pactMagicSlots,
    );

    expect(slots.recovery, ClassResourceRecovery.shortRest);
    expect(slots.maximumAtLevel(1), 1);
    expect(slots.maximumAtLevel(2), 2);
    expect(slots.maximumAtLevel(10), 2);
    expect(slots.maximumAtLevel(11), 3);
    expect(slots.maximumAtLevel(17), 4);
    expect(slots.maximumAtLevel(20), 4);
  });

  test('Eldritch Invocations known progress from two to eight', () {
    expect(
      warlock.progressionValue(
        WarlockProgressionIds.invocationsKnown,
        1,
      ),
      isNull,
    );
    expect(
      warlock.progressionValue(
        WarlockProgressionIds.invocationsKnown,
        2,
      ),
      '2',
    );
    expect(
      warlock.progressionValue(
        WarlockProgressionIds.invocationsKnown,
        9,
      ),
      '5',
    );
    expect(
      warlock.progressionValue(
        WarlockProgressionIds.invocationsKnown,
        18,
      ),
      '8',
    );
    expect(
      warlock.progressionValue(
        WarlockProgressionIds.invocationsKnown,
        20,
      ),
      '8',
    );
  });

  test('Pact Boon preserves all three PHB choices', () {
    final feature = warlock.featureDefinitions[WarlockFeatureIds.pactBoon]!;
    final choice = feature.choices.single;

    expect(choice.type, CharacterChoiceType.other);
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.optionIds.toSet(), phbWarlockPactBoonIds);
  });

  test('Mystic Arcanum grants one exact-level spell at each tier', () {
    final expected = <String, (int, Set<String>)>{
      WarlockFeatureIds.mysticArcanum6: (
        6,
        phbWarlockMysticArcanum6SpellIds.toSet(),
      ),
      WarlockFeatureIds.mysticArcanum7: (
        7,
        phbWarlockMysticArcanum7SpellIds.toSet(),
      ),
      WarlockFeatureIds.mysticArcanum8: (
        8,
        phbWarlockMysticArcanum8SpellIds.toSet(),
      ),
      WarlockFeatureIds.mysticArcanum9: (
        9,
        phbWarlockMysticArcanum9SpellIds.toSet(),
      ),
    };

    for (final entry in expected.entries) {
      final feature = warlock.featureDefinitions[entry.key]!;
      final choice = feature.choices.single;

      expect(choice.minimumSelections, 1);
      expect(choice.maximumSelections, 1);
      expect(choice.type, CharacterChoiceType.spell);
      expect(choice.optionIds.toSet(), entry.value.$2);

      for (final spellId in choice.optionIds) {
        expect(spellDefinitions[spellId]?.level, entry.value.$1);
        expect(
          spellDefinitions[spellId]?.classIds,
          contains(ClassIds.warlock),
        );
      }
    }
  });

  test('every granted Warlock feature and resource link resolves', () {
    final granted =
        warlock.featuresByLevel.values.expand((features) => features).toSet();
    final defined = warlock.featureDefinitions.keys.toSet();

    expect(granted.difference(defined), isEmpty);
    expect(defined.difference(granted), isEmpty);

    final resourceIds =
        warlock.resources.map((resource) => resource.id).toSet();

    for (final entry in warlock.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.warlock);
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

  test('Warlock base class is ready for all three PHB patrons', () {
    expect(warlock.featuresAtLevel(1), hasLength(2));
    expect(
      warlock.featuresAtLevel(2),
      [WarlockFeatureIds.eldritchInvocations],
    );
    expect(warlock.featuresAtLevel(3), [WarlockFeatureIds.pactBoon]);
    expect(
      warlock.featuresAtLevel(11),
      [WarlockFeatureIds.mysticArcanum6],
    );
    expect(
      warlock.featuresAtLevel(20),
      [WarlockFeatureIds.eldritchMaster],
    );
    expect(
      warlock.subclasses.keys,
      containsAll({
        WarlockSubclassIds.archfey,
        WarlockSubclassIds.fiend,
        WarlockSubclassIds.greatOldOne,
      }),
    );
  });
}
