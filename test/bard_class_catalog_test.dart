import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final bard = phbClassDefinitions[ClassIds.bard]!;

  test('Bard is registered with its PHB core identity', () {
    expect(bard.id, ClassIds.bard);
    expect(bard.name, 'Bardo');
    expect(bard.hitDie, 8);
    expect(bard.subclassSelectionLevel, 3);
    expect(bard.homebrew, isFalse);
  });

  test('Bard proficiencies and choices match the PHB', () {
    expect(bard.proficiencies.armor, {'light_armor'});
    expect(
      bard.proficiencies.weapons,
      {
        'simple_weapons',
        'hand_crossbow',
        'longsword',
        'rapier',
        'shortsword',
      },
    );
    expect(bard.proficiencies.savingThrows, {'DES', 'CAR'});
    expect(bard.proficiencies.skillOptions, hasLength(18));
    expect(bard.proficiencies.skillChoices, 3);

    final instrumentChoice = bard.proficiencies.choices.singleWhere(
      (choice) => choice.id == 'bard_musical_instruments',
    );

    expect(instrumentChoice.optionIds, hasLength(10));
    expect(instrumentChoice.selections, 3);
    expect(
      instrumentChoice.optionIds.difference(
        toolDefinitions.keys.toSet(),
      ),
      isEmpty,
    );
  });

  test('Bard starting equipment resolves to existing catalogs', () {
    for (final choice in bard.startingEquipmentChoices) {
      for (final alternative in choice.alternatives) {
        for (final grant in alternative.grants) {
          switch (grant.catalogId) {
            case 'weapon':
              expect(weaponDefinitions, contains(grant.itemId));
            case 'tool':
              expect(toolDefinitions, contains(grant.itemId));
            case 'equipment_pack':
              expect(
                equipmentPackDefinitions,
                contains(grant.itemId),
              );
            default:
              fail('Catalogo non riconosciuto: ${grant.catalogId}');
          }
        }
      }
    }

    expect(
      armorDefinitions,
      contains(ArmorIds.leather),
    );
    expect(weaponDefinitions, contains('dagger'));
  });

  test('Bardic Inspiration depends on Charisma and changes recovery', () {
    final inspiration = bard.resources.singleWhere(
      (resource) => resource.id == 'bardic_inspiration',
    );

    expect(
      inspiration.maximumAtLevel(
        1,
        abilityModifiers: {'CAR': 5},
      ),
      5,
    );
    expect(
      inspiration.maximumAtLevel(
        1,
        abilityModifiers: {'CAR': -1},
      ),
      1,
    );
    expect(
      inspiration.recoveryAtLevel(4),
      ClassResourceRecovery.longRest,
    );
    expect(
      inspiration.recoveryAtLevel(5),
      ClassResourceRecovery.shortRest,
    );
  });

  test('Bard progressive dice match the PHB table', () {
    expect(
      bard.progressionValue('bardic_inspiration_die', 1),
      'd6',
    );
    expect(
      bard.progressionValue('bardic_inspiration_die', 5),
      'd8',
    );
    expect(
      bard.progressionValue('bardic_inspiration_die', 10),
      'd10',
    );
    expect(
      bard.progressionValue('bardic_inspiration_die', 15),
      'd12',
    );

    expect(bard.progressionValue('song_of_rest_die', 1), isNull);
    expect(bard.progressionValue('song_of_rest_die', 2), 'd6');
    expect(bard.progressionValue('song_of_rest_die', 9), 'd8');
    expect(bard.progressionValue('song_of_rest_die', 13), 'd10');
    expect(bard.progressionValue('song_of_rest_die', 17), 'd12');
  });

  test('Bard has a complete full-caster progression', () {
    final magic = bard.spellcasting!;

    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'CAR');
    expect(magic.minimumLevel, 1);
    expect(magic.ritualCasting, isTrue);
    expect(magic.preparesSpells, isFalse);

    expect(magic.cantripsKnownAtLevel(1), 2);
    expect(magic.cantripsKnownAtLevel(10), 4);
    expect(magic.spellsKnownAtLevel(1), 4);
    expect(magic.spellsKnownAtLevel(10), 14);
    expect(magic.spellsKnownAtLevel(20), 22);

    expect(magic.slotsAtLevel(1), [2]);
    expect(magic.slotsAtLevel(10), [4, 3, 3, 3, 2]);
    expect(
      magic.slotsAtLevel(20),
      [4, 3, 3, 3, 3, 2, 2, 1, 1],
    );
  });

  test('Bard spell list is derived from the canonical registry', () {
    final expected = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.bard))
        .map((spell) => spell.id)
        .toSet();

    expect(bard.spellcasting!.spellIds, expected);
    expect(bard.spellcasting!.spellIds, isNotEmpty);
  });

  test('Expertise and Magical Secrets expose structured choices', () {
    final expertise = bard.featureDefinitions['expertise_3']!.choices.single;
    final secrets =
        bard.featureDefinitions['magical_secrets_10']!.choices.single;

    expect(expertise.minimumSelections, 2);
    expect(expertise.maximumSelections, 2);
    expect(expertise.requireExistingAcquisition, isTrue);

    expect(secrets.type, CharacterChoiceType.spell);
    expect(secrets.minimumSelections, 2);
    expect(secrets.maximumSelections, 2);
    expect(secrets.maximumSpellLevel, 5);
  });

  test('Every granted Bard feature has a definition', () {
    final granted =
        bard.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(14));
    expect(
      granted.difference(bard.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in bard.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.bard);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Bard base progression reaches level 20', () {
    expect(bard.featuresAtLevel(1), contains('spellcasting'));
    expect(bard.featuresAtLevel(3), contains('bard_college'));
    expect(bard.featuresAtLevel(10), contains('magical_secrets_10'));
    expect(bard.featuresAtLevel(20), ['superior_inspiration']);
    expect(bard.subclasses.length, 2);
  });
}
