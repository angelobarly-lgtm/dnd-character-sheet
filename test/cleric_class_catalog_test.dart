import 'package:dnd_character_sheet/data/ammunition_data.dart';
import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/cleric_class_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cleric = phbClassDefinitions[ClassIds.cleric]!;

  test('Cleric is registered with its PHB core identity', () {
    expect(cleric.id, ClassIds.cleric);
    expect(cleric.name, 'Chierico');
    expect(cleric.hitDie, 8);
    expect(cleric.subclassSelectionLevel, 1);
    expect(cleric.homebrew, isFalse);
  });

  test('Cleric proficiencies and skills match the PHB', () {
    expect(
      cleric.proficiencies.armor,
      {
        'light_armor',
        'medium_armor',
        'shield',
      },
    );
    expect(cleric.proficiencies.weapons, {'simple_weapons'});
    expect(cleric.proficiencies.savingThrows, {'SAG', 'CAR'});
    expect(cleric.proficiencies.skillOptions, hasLength(5));
    expect(cleric.proficiencies.skillChoices, 2);
  });

  test('conditional starting equipment is represented explicitly', () {
    final primary = cleric.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'cleric_primary_weapon',
    );
    final armor = cleric.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'cleric_starting_armor',
    );

    final warhammer = primary.alternatives.singleWhere(
      (alternative) => alternative.id == 'cleric_warhammer',
    );
    final chainMail = armor.alternatives.singleWhere(
      (alternative) => alternative.id == 'cleric_chain_mail',
    );

    expect(
      warhammer.requiredProficiencyIds,
      {'martial_weapons'},
    );
    expect(
      chainMail.requiredProficiencyIds,
      {'heavy_armor'},
    );
  });

  test('all Cleric starting equipment resolves to catalogs', () {
    for (final choice in cleric.startingEquipmentChoices) {
      for (final alternative in choice.alternatives) {
        for (final grant in alternative.grants) {
          switch (grant.catalogId) {
            case 'weapon':
              expect(weaponDefinitions, contains(grant.itemId));
            case 'armor':
              expect(armorDefinitions, contains(grant.itemId));
            case 'ammunition':
              expect(ammunitionDefinitions, contains(grant.itemId));
            case 'equipment_pack':
              expect(
                equipmentPackDefinitions,
                contains(grant.itemId),
              );
            case 'focus':
              expect(focusDefinitions, contains(grant.itemId));
            default:
              fail('Catalogo non riconosciuto: ${grant.catalogId}');
          }
        }
      }
    }

    expect(cleric.fixedStartingEquipment, hasLength(1));
    expect(
      armorDefinitions,
      contains(cleric.fixedStartingEquipment.single.itemId),
    );
  });

  test('Cleric holy symbol choice contains every holy focus', () {
    final choice = cleric.startingEquipmentChoices.singleWhere(
      (entry) => entry.id == 'cleric_holy_symbol',
    );

    final expected = focusDefinitions.values
        .where((focus) => focus.category == FocusCategory.holy)
        .map((focus) => focus.id)
        .toSet();

    final actual = choice.alternatives
        .expand((alternative) => alternative.grants)
        .map((grant) => grant.itemId)
        .toSet();

    expect(actual, expected);
    expect(actual, isNotEmpty);
  });

  test('Channel Divinity progression is complete', () {
    final channel = cleric.resources.singleWhere(
      (resource) => resource.id == 'channel_divinity',
    );

    expect(channel.maximumAtLevel(1), 0);
    expect(channel.maximumAtLevel(2), 1);
    expect(channel.maximumAtLevel(6), 2);
    expect(channel.maximumAtLevel(17), 2);
    expect(channel.maximumAtLevel(18), 3);
    expect(channel.maximumAtLevel(20), 3);
    expect(channel.recovery, ClassResourceRecovery.shortRest);
  });

  test('Destroy Undead progression matches the PHB table', () {
    expect(cleric.progressionValue('destroy_undead_cr', 4), isNull);
    expect(cleric.progressionValue('destroy_undead_cr', 5), '1/2');
    expect(cleric.progressionValue('destroy_undead_cr', 8), '1');
    expect(cleric.progressionValue('destroy_undead_cr', 11), '2');
    expect(cleric.progressionValue('destroy_undead_cr', 14), '3');
    expect(cleric.progressionValue('destroy_undead_cr', 17), '4');
    expect(cleric.progressionValue('destroy_undead_cr', 20), '4');
  });

  test('Cleric prepares spells using Wisdom and class level', () {
    final magic = cleric.spellcasting!;

    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'SAG');
    expect(magic.preparesSpells, isTrue);
    expect(magic.ritualCasting, isTrue);

    expect(
      magic.preparedSpellsAtLevel(
        1,
        abilityModifiers: {'SAG': 3},
      ),
      4,
    );
    expect(
      magic.preparedSpellsAtLevel(
        10,
        abilityModifiers: {'SAG': 5},
      ),
      15,
    );
  });

  test('Cleric spell list comes from the canonical registry', () {
    final expected = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.cleric))
        .map((spell) => spell.id)
        .toSet();

    expect(cleric.spellcasting!.spellIds, expected);
    expect(expected, hasLength(105));
  });

  test('Cleric has the complete full-caster slot progression', () {
    final magic = cleric.spellcasting!;

    expect(magic.cantripsKnownAtLevel(1), 3);
    expect(magic.cantripsKnownAtLevel(4), 4);
    expect(magic.cantripsKnownAtLevel(10), 5);

    expect(magic.slotsAtLevel(1), [2]);
    expect(magic.slotsAtLevel(10), [4, 3, 3, 3, 2]);
    expect(
      magic.slotsAtLevel(20),
      [4, 3, 3, 3, 3, 2, 2, 1, 1],
    );
  });

  test('Every granted Cleric feature has a definition', () {
    final granted =
        cleric.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(8));
    expect(
      granted.difference(cleric.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in cleric.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.cleric);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Cleric base progression reaches level 20', () {
    expect(cleric.featuresAtLevel(1), contains('divine_domain'));
    expect(cleric.featuresAtLevel(2), contains('channel_divinity'));
    expect(cleric.featuresAtLevel(5), contains('destroy_undead'));
    expect(
      cleric.featuresAtLevel(20),
      ['divine_intervention_improvement'],
    );
    expect(
      cleric.subclasses.keys,
      containsAll({
        ClericSubclassIds.knowledge,
        ClericSubclassIds.life,
      }),
    );
  });
}
