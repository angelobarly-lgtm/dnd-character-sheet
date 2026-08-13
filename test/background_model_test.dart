import 'dart:io';

import 'package:dnd_character_sheet/data/background_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testTable = BackgroundTableDefinition(
    id: 'test_table',
    name: 'Tabella di prova',
    dieSides: 6,
    entries: [
      BackgroundTableEntry(
        minimumRoll: 1,
        maximumRoll: 2,
        label: 'Primo risultato',
      ),
      BackgroundTableEntry(
        minimumRoll: 3,
        maximumRoll: 6,
        label: 'Secondo risultato',
      ),
    ],
  );

  test('background table resolves single values and ranges', () {
    expect(testTable.entryForRoll(1)?.label, 'Primo risultato');
    expect(testTable.entryForRoll(2)?.label, 'Primo risultato');
    expect(testTable.entryForRoll(3)?.label, 'Secondo risultato');
    expect(testTable.entryForRoll(6)?.label, 'Secondo risultato');
    expect(testTable.entryForRoll(0), isNull);
    expect(testTable.entryForRoll(7), isNull);
  });

  test('suggested characteristics report their completeness', () {
    const empty = BackgroundSuggestedCharacteristics();
    const complete = BackgroundSuggestedCharacteristics(
      personalityTraits: testTable,
      ideals: testTable,
      bonds: testTable,
      flaws: testTable,
    );

    expect(empty.isComplete, isFalse);
    expect(complete.isComplete, isTrue);
  });

  test('PHB background ids are unique and complete', () {
    final text = File('lib/data/background_data.dart').readAsStringSync();

    final idRegex = RegExp(
      r"static\s+const\s+(\w+)\s*=\s*'([^']+)';",
    );

    final matches = idRegex.allMatches(text).toList();
    final names = matches.map((match) => match.group(1)!).toList();
    final values = matches.map((match) => match.group(2)!).toList();

    expect(names.length, 18);
    expect(values.length, 18);
    expect(names.toSet().length, 18);
    expect(values.toSet().length, 18);
  });

  test('acolyte background is structurally complete', () {
    final acolyte = backgroundDefinitions[BackgroundIds.acolyte];

    expect(acolyte, isNotNull);

    final background = acolyte!;

    expect(background.id, BackgroundIds.acolyte);
    expect(background.name, 'Accolito');
    expect(background.isVariant, isFalse);
    expect(background.parentBackgroundId, isNull);

    expect(
      background.effects.skillProficiencies,
      {
        'Intuizione',
        'Religione',
      },
    );

    final choices = {
      for (final choice in background.effects.choices) choice.id: choice,
    };

    expect(choices.length, 3);

    final languages = choices['acolyte_languages'];
    expect(languages, isNotNull);
    expect(languages!.type, CharacterChoiceType.language);
    expect(languages.minimumSelections, 2);
    expect(languages.maximumSelections, 2);
    expect(languages.requireNewAcquisition, isTrue);
    expect(languages.optionIds, characterLanguageIds);

    final holySymbol = choices['acolyte_holy_symbol'];
    expect(holySymbol, isNotNull);
    expect(holySymbol!.catalogId, 'focus');
    expect(holySymbol.optionIds.length, 3);

    final prayerItem = choices['acolyte_prayer_item'];
    expect(prayerItem, isNotNull);
    expect(prayerItem!.catalogId, 'equipment');
    expect(
      prayerItem.optionIds,
      {
        EquipmentIds.prayerBook,
        EquipmentIds.prayerWheel,
      },
    );

    expect(background.feature, isNotNull);
    expect(background.feature!.id, 'shelter_of_the_faithful');
    expect(background.feature!.ruleTags, isNotEmpty);

    final characteristics = background.suggestedCharacteristics;
    expect(characteristics.isComplete, isTrue);

    final tables = [
      characteristics.personalityTraits!,
      characteristics.ideals!,
      characteristics.bonds!,
      characteristics.flaws!,
    ];

    expect(tables[0].dieSides, 8);
    expect(tables[0].entries.length, 8);

    for (final table in tables.skip(1)) {
      expect(table.dieSides, 6);
      expect(table.entries.length, 6);
    }

    for (final table in tables) {
      for (var roll = 1; roll <= table.dieSides; roll++) {
        final matchingEntries =
            table.entries.where((entry) => entry.matches(roll)).toList();

        expect(
          matchingEntries.length,
          1,
          reason: '${table.id}: il risultato $roll deve avere una sola voce',
        );

        expect(table.entryForRoll(roll), isNotNull);
      }
    }

    expect(background.startingCoins, {'MO': 15});

    final equipment = {
      for (final item in background.startingEquipment)
        item.itemId: item.quantity,
    };

    expect(
      equipment,
      {
        EquipmentIds.incense: 5,
        EquipmentIds.robes: 1,
        EquipmentIds.commonClothes: 1,
        EquipmentIds.pouch: 1,
      },
    );

    expect(
      equipmentDefinitions.containsKey(EquipmentIds.prayerBook),
      isTrue,
    );
    expect(
      equipmentDefinitions.containsKey(EquipmentIds.prayerWheel),
      isTrue,
    );
  });

  test('completed PHB background blocks are structurally valid', () {
    expect(
      backgroundDefinitions.keys.toSet(),
      {
        BackgroundIds.acolyte,
        BackgroundIds.guildArtisan,
        BackgroundIds.guildMerchant,
        BackgroundIds.charlatan,
        BackgroundIds.criminal,
        BackgroundIds.spy,
        BackgroundIds.hermit,
      },
    );

    expect(mainBackgroundDefinitions.length, 5);

    final merchant = backgroundDefinitions[BackgroundIds.guildMerchant];
    expect(merchant, isNotNull);
    expect(merchant!.isVariant, isTrue);
    expect(
      merchant.parentBackgroundId,
      BackgroundIds.guildArtisan,
    );

    expect(
      backgroundVariantsFor(BackgroundIds.guildArtisan)
          .map((background) => background.id)
          .toSet(),
      {
        BackgroundIds.guildMerchant,
      },
    );

    for (final background in backgroundDefinitions.values) {
      expect(background.id, isNotEmpty);
      expect(background.name, isNotEmpty);
      expect(background.content.id, background.id);
      expect(background.content.name, background.name);
      expect(background.feature, isNotNull);
      expect(background.suggestedCharacteristics.isComplete, isTrue);

      final tables = [
        background.suggestedCharacteristics.personalityTraits!,
        background.suggestedCharacteristics.ideals!,
        background.suggestedCharacteristics.bonds!,
        background.suggestedCharacteristics.flaws!,
        ...background.tables,
      ];

      for (final table in tables) {
        for (var roll = 1; roll <= table.dieSides; roll++) {
          final matches =
              table.entries.where((entry) => entry.matches(roll)).length;

          expect(
            matches,
            1,
            reason: '${background.id}/${table.id}: risultato $roll non univoco',
          );
        }
      }

      if (background.isVariant) {
        expect(
          backgroundDefinitions.containsKey(
            background.parentBackgroundId,
          ),
          isTrue,
        );
      }
    }

    final artisan = backgroundDefinitions[BackgroundIds.guildArtisan]!;
    expect(artisan.tables.single.dieSides, 20);
    expect(artisan.effects.skillProficiencies, {
      'Intuizione',
      'Persuasione',
    });

    final charlatan = backgroundDefinitions[BackgroundIds.charlatan]!;
    expect(charlatan.effects.skillProficiencies, {
      'Inganno',
      'Rapidità di Mano',
    });
    expect(
      charlatan.effects.toolProficiencies,
      {
        'forgery_kit',
        'disguise_kit',
      },
    );
    expect(charlatan.tables.single.dieSides, 6);
  });
  test('criminal spy and hermit backgrounds are structurally valid', () {
    final criminal = backgroundDefinitions[BackgroundIds.criminal];
    final spy = backgroundDefinitions[BackgroundIds.spy];
    final hermit = backgroundDefinitions[BackgroundIds.hermit];

    expect(criminal, isNotNull);
    expect(spy, isNotNull);
    expect(hermit, isNotNull);

    expect(criminal!.isVariant, isFalse);
    expect(criminal.parentBackgroundId, isNull);
    expect(
      criminal.effects.skillProficiencies,
      {
        'Furtività',
        'Inganno',
      },
    );
    expect(
      criminal.effects.toolProficiencies,
      {
        ToolIds.thievesTools,
      },
    );
    expect(criminal.feature!.id, 'criminal_contact');
    expect(criminal.tables.single.dieSides, 8);
    expect(criminal.tables.single.entries.length, 8);

    final criminalGamingChoice = criminal.effects.choices.single;
    expect(criminalGamingChoice.id, 'criminal_gaming_set');
    expect(
      criminalGamingChoice.options.map((option) => option.id).toSet(),
      {
        ToolIds.diceSet,
        ToolIds.dragonchessSet,
        ToolIds.playingCardSet,
        ToolIds.threeDragonAnteSet,
      },
    );

    expect(spy!.isVariant, isTrue);
    expect(spy.parentBackgroundId, BackgroundIds.criminal);
    expect(spy.feature!.id, 'criminal_contact');
    expect(
      backgroundVariantsFor(BackgroundIds.criminal)
          .map((background) => background.id)
          .toSet(),
      {
        BackgroundIds.spy,
      },
    );

    expect(hermit!.isVariant, isFalse);
    expect(
      hermit.effects.skillProficiencies,
      {
        'Medicina',
        'Religione',
      },
    );
    expect(
      hermit.effects.toolProficiencies,
      {
        ToolIds.herbalismKit,
      },
    );
    expect(hermit.effects.choices.single.type, CharacterChoiceType.language);
    expect(hermit.feature!.id, 'discovery');
    expect(hermit.tables.single.dieSides, 8);
    expect(hermit.tables.single.entries.length, 8);
    expect(hermit.startingCoins, {'MO': 5});

    final hermitEquipment = {
      for (final item in hermit.startingEquipment) item.itemId: item.catalogId,
    };

    expect(
      hermitEquipment,
      {
        EquipmentIds.scrollCase: 'equipment',
        EquipmentIds.blanket: 'equipment',
        EquipmentIds.commonClothes: 'equipment',
        ToolIds.herbalismKit: 'tool',
      },
    );

    expect(
      equipmentDefinitions.containsKey(EquipmentIds.scrollCase),
      isTrue,
    );
  });
}
