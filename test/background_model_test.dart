import 'dart:io';

import 'package:dnd_character_sheet/data/background_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
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
        BackgroundIds.folkHero,
        BackgroundIds.outlander,
        BackgroundIds.entertainer,
        BackgroundIds.gladiator,
        BackgroundIds.sailor,
        BackgroundIds.pirate,
        BackgroundIds.urchin,
        BackgroundIds.noble,
        BackgroundIds.knight,
      },
    );

    expect(mainBackgroundDefinitions.length, 11);

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
  test('folk hero and outlander backgrounds are structurally valid', () {
    final folkHero = backgroundDefinitions[BackgroundIds.folkHero];
    final outlander = backgroundDefinitions[BackgroundIds.outlander];

    expect(folkHero, isNotNull);
    expect(outlander, isNotNull);

    expect(
      folkHero!.effects.skillProficiencies,
      {
        'Addestrare Animali',
        'Sopravvivenza',
      },
    );
    expect(
      folkHero.effects.toolProficiencies,
      {
        ToolIds.landVehicles,
      },
    );
    expect(folkHero.feature!.id, 'rustic_hospitality');
    expect(folkHero.tables.single.dieSides, 10);
    expect(folkHero.tables.single.entries.length, 10);
    expect(folkHero.startingCoins, {'MO': 10});

    final artisanChoice = folkHero.effects.choices.single;
    expect(artisanChoice.id, 'folk_hero_artisan_tools');
    expect(artisanChoice.options.length, 17);

    for (final option in artisanChoice.options) {
      expect(
        option.effects.toolProficiencies,
        contains(option.id),
      );
      expect(
        option.effects.grantedEquipmentIds,
        contains(option.id),
      );
    }

    expect(
      {
        for (final item in folkHero.startingEquipment)
          item.itemId: item.catalogId,
      },
      {
        EquipmentIds.shovel: 'equipment',
        EquipmentIds.ironPot: 'equipment',
        EquipmentIds.commonClothes: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(
      outlander!.effects.skillProficiencies,
      {
        'Atletica',
        'Sopravvivenza',
      },
    );
    expect(outlander.feature!.id, 'wanderer');
    expect(outlander.tables.single.dieSides, 10);
    expect(outlander.tables.single.entries.length, 10);
    expect(outlander.startingCoins, {'MO': 10});

    final outlanderChoices = {
      for (final choice in outlander.effects.choices) choice.id: choice,
    };

    final instrumentChoice = outlanderChoices['outlander_musical_instrument'];
    final languageChoice = outlanderChoices['outlander_language'];

    expect(instrumentChoice, isNotNull);
    expect(instrumentChoice!.options.length, 10);

    for (final option in instrumentChoice.options) {
      expect(
        option.effects.toolProficiencies,
        contains(option.id),
      );
      expect(
        option.effects.grantedEquipmentIds,
        contains(option.id),
      );
    }

    expect(languageChoice, isNotNull);
    expect(languageChoice!.type, CharacterChoiceType.language);
    expect(languageChoice.optionIds, characterLanguageIds);

    expect(
      {
        for (final item in outlander.startingEquipment)
          item.itemId: item.catalogId,
      },
      {
        'quarterstaff': 'weapon',
        EquipmentIds.huntingTrap: 'equipment',
        EquipmentIds.animalTrophy: 'equipment',
        EquipmentIds.travelersClothes: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(weaponDefinitions.containsKey('quarterstaff'), isTrue);
    expect(
      equipmentDefinitions.containsKey(EquipmentIds.animalTrophy),
      isTrue,
    );
  });
  test('entertainer and gladiator backgrounds are structurally valid', () {
    final entertainer = backgroundDefinitions[BackgroundIds.entertainer];
    final gladiator = backgroundDefinitions[BackgroundIds.gladiator];

    expect(entertainer, isNotNull);
    expect(gladiator, isNotNull);

    expect(
      entertainer!.effects.skillProficiencies,
      {
        'Acrobazia',
        'Intrattenere',
      },
    );
    expect(
      entertainer.effects.toolProficiencies,
      {
        ToolIds.disguiseKit,
      },
    );
    expect(entertainer.feature!.id, 'by_popular_demand');
    expect(entertainer.tables.single.dieSides, 10);
    expect(entertainer.tables.single.entries.length, 10);
    expect(entertainer.startingCoins, {'MO': 15});

    final entertainerChoices = {
      for (final choice in entertainer.effects.choices) choice.id: choice,
    };

    final entertainerInstrument =
        entertainerChoices['entertainer_musical_instrument'];
    final entertainerToken = entertainerChoices['entertainer_admirer_token'];

    expect(entertainerInstrument, isNotNull);
    expect(entertainerInstrument!.options.length, 10);

    for (final option in entertainerInstrument.options) {
      expect(
        option.effects.toolProficiencies,
        contains(option.id),
      );
      expect(
        option.effects.grantedEquipmentIds,
        contains(option.id),
      );
    }

    expect(
      entertainerToken!.optionIds.toSet(),
      {
        EquipmentIds.admirerLoveLetter,
        EquipmentIds.admirerLockOfHair,
        EquipmentIds.admirerTrinket,
      },
    );

    expect(
      {
        for (final item in entertainer.startingEquipment)
          item.itemId: item.catalogId,
      },
      {
        EquipmentIds.costume: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(gladiator!.isVariant, isTrue);
    expect(
      gladiator.parentBackgroundId,
      BackgroundIds.entertainer,
    );
    expect(gladiator.feature!.id, 'by_popular_demand');

    expect(
      backgroundVariantsFor(BackgroundIds.entertainer)
          .map((background) => background.id)
          .toSet(),
      {
        BackgroundIds.gladiator,
      },
    );

    final gladiatorChoices = {
      for (final choice in gladiator.effects.choices) choice.id: choice,
    };

    final proficiencyChoice =
        gladiatorChoices['gladiator_musical_instrument_proficiency'];
    final displayEquipment = gladiatorChoices['gladiator_display_equipment'];
    final gladiatorToken = gladiatorChoices['gladiator_admirer_token'];

    expect(proficiencyChoice, isNotNull);
    expect(proficiencyChoice!.options.length, 10);

    for (final option in proficiencyChoice.options) {
      expect(
        option.effects.toolProficiencies,
        contains(option.id),
      );
      expect(option.effects.grantedEquipmentIds, isEmpty);
    }

    expect(displayEquipment, isNotNull);
    expect(displayEquipment!.options.length, 12);
    expect(
      displayEquipment.options.map((option) => option.id).toSet(),
      {
        ToolIds.bagpipes,
        ToolIds.drum,
        ToolIds.dulcimer,
        ToolIds.flute,
        ToolIds.lute,
        ToolIds.lyre,
        ToolIds.horn,
        ToolIds.panFlute,
        ToolIds.shawm,
        ToolIds.viol,
        'trident',
        'net',
      },
    );

    for (final option in displayEquipment.options) {
      expect(
        option.effects.grantedEquipmentIds,
        contains(option.id),
      );
    }

    expect(
      gladiatorToken!.optionIds.toSet(),
      {
        EquipmentIds.admirerLoveLetter,
        EquipmentIds.admirerLockOfHair,
        EquipmentIds.admirerTrinket,
      },
    );

    expect(weaponDefinitions.containsKey('trident'), isTrue);
    expect(weaponDefinitions.containsKey('net'), isTrue);

    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.admirerLoveLetter,
      ),
      isTrue,
    );
    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.admirerLockOfHair,
      ),
      isTrue,
    );
    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.admirerTrinket,
      ),
      isTrue,
    );
  });
  test('sailor and pirate backgrounds are structurally valid', () {
    final sailor = backgroundDefinitions[BackgroundIds.sailor];
    final pirate = backgroundDefinitions[BackgroundIds.pirate];

    expect(sailor, isNotNull);
    expect(pirate, isNotNull);

    expect(
      sailor!.effects.skillProficiencies,
      {
        'Atletica',
        'Percezione',
      },
    );
    expect(
      sailor.effects.toolProficiencies,
      {
        ToolIds.navigatorsTools,
        ToolIds.waterVehicles,
      },
    );
    expect(sailor.feature!.id, 'ships_passage');
    expect(sailor.startingCoins, {'MO': 10});
    expect(sailor.suggestedCharacteristics.isComplete, isTrue);

    final sailorCharm = sailor.effects.choices.single;
    expect(sailorCharm.id, 'sailor_lucky_charm');
    expect(
      sailorCharm.optionIds.toSet(),
      {
        EquipmentIds.sailorsRabbitFoot,
        EquipmentIds.sailorsHoleyStone,
        EquipmentIds.randomTrinket,
      },
    );

    expect(
      {
        for (final item in sailor.startingEquipment)
          item.itemId: item.catalogId,
      },
      {
        'club': 'weapon',
        EquipmentIds.silkRope: 'equipment',
        EquipmentIds.commonClothes: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(weaponDefinitions.containsKey('club'), isTrue);

    expect(pirate!.isVariant, isTrue);
    expect(pirate.parentBackgroundId, BackgroundIds.sailor);
    expect(pirate.feature!.id, 'bad_reputation');
    expect(
      pirate.effects.skillProficiencies,
      sailor.effects.skillProficiencies,
    );
    expect(
      pirate.effects.toolProficiencies,
      sailor.effects.toolProficiencies,
    );

    expect(
      backgroundVariantsFor(BackgroundIds.sailor)
          .map((background) => background.id)
          .toSet(),
      {
        BackgroundIds.pirate,
      },
    );

    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.sailorsRabbitFoot,
      ),
      isTrue,
    );
    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.sailorsHoleyStone,
      ),
      isTrue,
    );
    expect(
      equipmentDefinitions.containsKey(
        EquipmentIds.randomTrinket,
      ),
      isTrue,
    );
  });

  test('urchin noble and knight backgrounds are structurally valid', () {
    final urchin = backgroundDefinitions[BackgroundIds.urchin];
    final noble = backgroundDefinitions[BackgroundIds.noble];
    final knight = backgroundDefinitions[BackgroundIds.knight];

    expect(urchin, isNotNull);
    expect(noble, isNotNull);
    expect(knight, isNotNull);

    expect(
      urchin!.effects.skillProficiencies,
      {
        'Furtività',
        'Rapidità di Mano',
      },
    );
    expect(
      urchin.effects.toolProficiencies,
      {
        ToolIds.disguiseKit,
        ToolIds.thievesTools,
      },
    );
    expect(urchin.feature!.id, 'city_secrets');
    expect(urchin.startingCoins, {'MO': 10});
    expect(urchin.suggestedCharacteristics.isComplete, isTrue);

    expect(
      {
        for (final item in urchin.startingEquipment)
          item.itemId: item.catalogId,
      },
      {
        EquipmentIds.urchinSmallKnife: 'equipment',
        EquipmentIds.homeCityMap: 'equipment',
        EquipmentIds.petMouse: 'equipment',
        EquipmentIds.parentsMemento: 'equipment',
        EquipmentIds.commonClothes: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(noble!.isVariant, isFalse);
    expect(
      noble.effects.skillProficiencies,
      {
        'Persuasione',
        'Storia',
      },
    );
    expect(noble.feature!.id, 'position_of_privilege');
    expect(noble.startingCoins, {'MO': 25});
    expect(noble.suggestedCharacteristics.isComplete, isTrue);

    final nobleChoices = {
      for (final choice in noble.effects.choices) choice.id: choice,
    };

    final gamingSet = nobleChoices['noble_gaming_set'];
    final language = nobleChoices['noble_language'];

    expect(gamingSet, isNotNull);
    expect(
      gamingSet!.options.map((option) => option.id).toSet(),
      {
        ToolIds.diceSet,
        ToolIds.dragonchessSet,
        ToolIds.playingCardSet,
        ToolIds.threeDragonAnteSet,
      },
    );

    for (final option in gamingSet.options) {
      expect(
        option.effects.toolProficiencies,
        contains(option.id),
      );
    }

    expect(language, isNotNull);
    expect(language!.type, CharacterChoiceType.language);
    expect(language.optionIds, characterLanguageIds);
    expect(language.requireNewAcquisition, isTrue);

    expect(
      {
        for (final item in noble.startingEquipment) item.itemId: item.catalogId,
      },
      {
        EquipmentIds.fineClothes: 'equipment',
        EquipmentIds.signetRing: 'equipment',
        EquipmentIds.pedigreeScroll: 'equipment',
        EquipmentIds.pouch: 'equipment',
      },
    );

    expect(knight!.isVariant, isTrue);
    expect(knight.parentBackgroundId, BackgroundIds.noble);
    expect(knight.feature!.id, 'retainers');
    expect(
      knight.effects.skillProficiencies,
      noble.effects.skillProficiencies,
    );
    expect(knight.startingCoins, noble.startingCoins);
    expect(knight.startingEquipment.length, noble.startingEquipment.length);

    expect(
      backgroundVariantsFor(BackgroundIds.noble)
          .map((background) => background.id)
          .toSet(),
      {
        BackgroundIds.knight,
      },
    );

    for (final id in [
      EquipmentIds.urchinSmallKnife,
      EquipmentIds.homeCityMap,
      EquipmentIds.petMouse,
      EquipmentIds.parentsMemento,
      EquipmentIds.pedigreeScroll,
    ]) {
      expect(
        equipmentDefinitions.containsKey(id),
        isTrue,
        reason: 'Definizione di equipaggiamento mancante: $id',
      );
    }
  });
}
