import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/bard_class_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final bard = phbClassDefinitions[ClassIds.bard]!;

  test('PHB Bard base catalog is structurally complete', () {
    expect(bard.id, ClassIds.bard);
    expect(bard.hitDie, 8);
    expect(bard.proficiencies.savingThrows, {'DES', 'CAR'});
    expect(bard.subclassSelectionLevel, 3);
    expect(bard.resources.single.id, 'bardic_inspiration');
    expect(bard.featureDefinitions, hasLength(14));

    final granted =
        bard.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(14));
    expect(
      granted.difference(bard.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('all Bard content has editorial metadata', () {
    expect(bard.content.source.isEmpty, isFalse);
    expect(bard.content.description.summary.trim(), isNotEmpty);
    expect(bard.content.description.details.trim(), isNotEmpty);

    for (final entry in bard.featureDefinitions.entries) {
      final content = entry.value.content;

      expect(content.id, entry.key);
      expect(content.ownerId, ClassIds.bard);
      expect(content.source.isEmpty, isFalse);
      expect(content.description.summary.trim(), isNotEmpty);
      expect(content.description.details.trim(), isNotEmpty);
    }
  });

  test('all Bard proficiency choices resolve correctly', () {
    expect(bard.proficiencies.skillOptions, hasLength(18));

    final skills = bard.proficiencies.choices.singleWhere(
      (choice) => choice.id == 'bard_skills',
    );
    final instruments = bard.proficiencies.choices.singleWhere(
      (choice) => choice.id == 'bard_musical_instruments',
    );

    expect(skills.optionIds, hasLength(18));
    expect(skills.selections, 3);

    expect(instruments.optionIds, hasLength(10));
    expect(instruments.selections, 3);
    expect(
      instruments.optionIds.difference(
        toolDefinitions.keys.toSet(),
      ),
      isEmpty,
    );

    for (final toolId in instruments.optionIds) {
      expect(
        toolDefinitions[toolId]!.category,
        ToolCategory.musical,
      );
    }
  });

  test('all Bard starting equipment resolves to catalogs', () {
    for (final choice in bard.startingEquipmentChoices) {
      expect(choice.alternatives, isNotEmpty);

      for (final alternative in choice.alternatives) {
        expect(alternative.grants, isNotEmpty);

        for (final grant in alternative.grants) {
          switch (grant.catalogId) {
            case 'weapon':
              expect(
                weaponDefinitions,
                contains(grant.itemId),
                reason: 'Arma mancante: ${grant.itemId}',
              );
            case 'tool':
              expect(
                toolDefinitions,
                contains(grant.itemId),
                reason: 'Strumento mancante: ${grant.itemId}',
              );
            case 'equipment_pack':
              expect(
                equipmentPackDefinitions,
                contains(grant.itemId),
                reason: 'Dotazione mancante: ${grant.itemId}',
              );
            default:
              fail('Catalogo non riconosciuto: ${grant.catalogId}');
          }
        }
      }
    }

    for (final grant in bard.fixedStartingEquipment) {
      switch (grant.catalogId) {
        case 'armor':
          expect(armorDefinitions, contains(grant.itemId));
        case 'weapon':
          expect(weaponDefinitions, contains(grant.itemId));
        default:
          fail('Catalogo fisso non riconosciuto: ${grant.catalogId}');
      }
    }
  });

  test('Bardic Inspiration is coherent at every level', () {
    final inspiration = bard.resources.singleWhere(
      (resource) => resource.id == 'bardic_inspiration',
    );

    for (var level = 1; level <= 20; level++) {
      expect(
        inspiration.maximumAtLevel(
          level,
          abilityModifiers: {'CAR': 4},
        ),
        4,
      );

      expect(
        bard.progressionValue(
          'bardic_inspiration_die',
          level,
        ),
        isNotNull,
        reason: 'Dado di Ispirazione assente al livello $level',
      );

      final expectedRecovery = level < 5
          ? ClassResourceRecovery.longRest
          : ClassResourceRecovery.shortRest;

      expect(
        inspiration.recoveryAtLevel(level),
        expectedRecovery,
        reason: 'Recupero errato al livello $level',
      );
    }
  });

  test('Song of Rest progression is complete from level 2', () {
    expect(
      bard.progressionValue('song_of_rest_die', 1),
      isNull,
    );

    for (var level = 2; level <= 20; level++) {
      expect(
        bard.progressionValue('song_of_rest_die', level),
        isNotNull,
        reason: 'Canto di Riposo assente al livello $level',
      );
    }
  });

  test('Bard spell table matches all 20 PHB levels', () {
    final magic = bard.spellcasting!;

    const expectedCantrips = {
      1: 2,
      2: 2,
      3: 2,
      4: 3,
      5: 3,
      6: 3,
      7: 3,
      8: 3,
      9: 3,
      10: 4,
      11: 4,
      12: 4,
      13: 4,
      14: 4,
      15: 4,
      16: 4,
      17: 4,
      18: 4,
      19: 4,
      20: 4,
    };

    const expectedSpells = {
      1: 4,
      2: 5,
      3: 6,
      4: 7,
      5: 8,
      6: 9,
      7: 10,
      8: 11,
      9: 12,
      10: 14,
      11: 15,
      12: 15,
      13: 16,
      14: 18,
      15: 19,
      16: 19,
      17: 20,
      18: 22,
      19: 22,
      20: 22,
    };

    const expectedSlots = {
      1: [2],
      2: [3],
      3: [4, 2],
      4: [4, 3],
      5: [4, 3, 2],
      6: [4, 3, 3],
      7: [4, 3, 3, 1],
      8: [4, 3, 3, 2],
      9: [4, 3, 3, 3, 1],
      10: [4, 3, 3, 3, 2],
      11: [4, 3, 3, 3, 2, 1],
      12: [4, 3, 3, 3, 2, 1],
      13: [4, 3, 3, 3, 2, 1, 1],
      14: [4, 3, 3, 3, 2, 1, 1],
      15: [4, 3, 3, 3, 2, 1, 1, 1],
      16: [4, 3, 3, 3, 2, 1, 1, 1],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    };

    for (var level = 1; level <= 20; level++) {
      expect(
        magic.cantripsKnownAtLevel(level),
        expectedCantrips[level],
        reason: 'Trucchetti errati al livello $level',
      );
      expect(
        magic.spellsKnownAtLevel(level),
        expectedSpells[level],
        reason: 'Incantesimi errati al livello $level',
      );
      expect(
        magic.slotsAtLevel(level),
        expectedSlots[level],
        reason: 'Slot errati al livello $level',
      );
    }
  });

  test('canonical Bard spell list is complete and coherent', () {
    final magic = bard.spellcasting!;
    final expected = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.bard))
        .map((spell) => spell.id)
        .toSet();

    expect(magic.spellIds, expected);
    expect(magic.spellIds, isNotEmpty);

    for (final spellId in magic.spellIds) {
      expect(spellDefinitions, contains(spellId));
      expect(
        spellDefinitions[spellId]!.classIds,
        contains(ClassIds.bard),
      );
    }
  });

  test('Expertise and Magical Secrets choices are coherent', () {
    final expertise3 = bard.featureDefinitions['expertise_3']!.choices.single;
    final expertise10 = bard.featureDefinitions['expertise_10']!.choices.single;

    expect(expertise3.requireExistingAcquisition, isTrue);
    expect(expertise10.requireExistingAcquisition, isTrue);
    expect(expertise3.maximumSelections, 2);
    expect(expertise10.maximumSelections, 2);

    const secretLevels = {
      'magical_secrets_10': 5,
      'magical_secrets_14': 7,
      'magical_secrets_18': 9,
    };

    for (final entry in secretLevels.entries) {
      final choice = bard.featureDefinitions[entry.key]!.choices.single;

      expect(choice.type, CharacterChoiceType.spell);
      expect(choice.minimumSelections, 2);
      expect(choice.maximumSelections, 2);
      expect(choice.maximumSpellLevel, entry.value);
    }
  });

  test('both PHB Bard colleges are complete', () {
    expect(
      bard.phbSubclasses.map((subclass) => subclass.id).toSet(),
      {
        BardSubclassIds.lore,
        BardSubclassIds.valor,
      },
    );
    expect(bard.phbSubclasses, hasLength(2));
    expect(bard.supplementalSubclasses, isEmpty);

    for (final subclass in bard.phbSubclasses) {
      expect(subclass.classId, ClassIds.bard);
      expect(subclass.content.source.isEmpty, isFalse);

      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();

      expect(
        granted.difference(
          subclass.featureDefinitions.keys.toSet(),
        ),
        isEmpty,
        reason: 'Privilegio non registrato in ${subclass.id}',
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final content = entry.value.content;

        expect(content.id, entry.key);
        expect(content.ownerId, subclass.id);
        expect(content.source.isEmpty, isFalse);
      }
    }
  });

  test('Lore and Valor structured benefits are complete', () {
    final lore = bard.subclasses[BardSubclassIds.lore]!;
    final valor = bard.subclasses[BardSubclassIds.valor]!;

    final loreSkills =
        lore.featureDefinitions['bonus_proficiencies_lore']!.choices.single;

    expect(loreSkills.optionIds, hasLength(18));
    expect(loreSkills.maximumSelections, 3);
    expect(loreSkills.requireNewAcquisition, isTrue);

    final additionalSecrets =
        lore.featureDefinitions['additional_magical_secrets']!.choices.single;

    expect(additionalSecrets.maximumSelections, 2);
    expect(additionalSecrets.maximumSpellLevel, 3);

    final valorEffects =
        valor.featureDefinitions['bonus_proficiencies_valor']!.effects;

    expect(
      valorEffects.armorProficiencies,
      {
        'medium_armor',
        'shield',
      },
    );
    expect(
      valorEffects.weaponProficiencies,
      {
        'martial_weapons',
      },
    );
  });

  test('Bard rules contain no imperial measurements', () {
    final descriptions = <String>[
      bard.content.description.summary,
      bard.content.description.details,
      for (final feature in bard.featureDefinitions.values)
        feature.content.description.details,
      for (final subclass in bard.phbSubclasses) ...[
        subclass.content.description.details,
        for (final feature in subclass.featureDefinitions.values)
          feature.content.description.details,
      ],
    ];

    final imperialPattern = RegExp(
      r'\b(feet|foot|ft|mile|miles|lb|lbs|pound|pounds)\b',
      caseSensitive: false,
    );

    expect(
      descriptions.where(imperialPattern.hasMatch),
      isEmpty,
    );
  });

  test('universal registry contains the first three PHB classes', () {
    expect(
      phbClassDefinitions.keys.toSet(),
      containsAll({
        ClassIds.barbarian,
        ClassIds.bard,
        ClassIds.monk,
      }),
    );
  });
}
