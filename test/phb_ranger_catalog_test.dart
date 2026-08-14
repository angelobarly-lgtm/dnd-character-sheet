import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/ranger_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ranger = phbClassDefinitions[ClassIds.ranger]!;
  final hunter = ranger.subclasses[RangerSubclassIds.hunter]!;
  final beastMaster = ranger.subclasses[RangerSubclassIds.beastMaster]!;

  test('PHB Ranger is registered with canonical identity and source', () {
    expect(phbClassDefinitionFor(ClassIds.ranger), same(ranger));
    expect(ranger.id, ClassIds.ranger);
    expect(ranger.name, 'Ranger');
    expect(ranger.hitDie, 10);
    expect(ranger.subclassSelectionLevel, 3);
    expect(ranger.homebrew, isFalse);
    expect(ranger.content.source.name, 'Manuale del Giocatore 2014');
    expect(ranger.content.source.reference, 'pp. 102-105');
  });

  test('base progression exactly matches every PHB Ranger milestone', () {
    expect(
      ranger.featuresByLevel,
      {
        1: [
          RangerFeatureIds.favoredEnemy,
          RangerFeatureIds.naturalExplorer,
        ],
        2: [
          RangerFeatureIds.fightingStyle,
          RangerFeatureIds.spellcasting,
        ],
        3: [
          RangerFeatureIds.rangerArchetype,
          RangerFeatureIds.primevalAwareness,
        ],
        4: [RangerFeatureIds.abilityScoreImprovement],
        5: [RangerFeatureIds.extraAttack],
        6: [
          RangerFeatureIds.favoredEnemyImprovement6,
          RangerFeatureIds.naturalExplorerImprovement6,
        ],
        8: [
          RangerFeatureIds.abilityScoreImprovement,
          RangerFeatureIds.landStride,
        ],
        10: [
          RangerFeatureIds.naturalExplorerImprovement10,
          RangerFeatureIds.hideInPlainSight,
        ],
        12: [RangerFeatureIds.abilityScoreImprovement],
        14: [
          RangerFeatureIds.favoredEnemyImprovement14,
          RangerFeatureIds.vanish,
        ],
        16: [RangerFeatureIds.abilityScoreImprovement],
        18: [RangerFeatureIds.feralSenses],
        19: [RangerFeatureIds.abilityScoreImprovement],
        20: [RangerFeatureIds.foeSlayer],
      },
    );

    final granted =
        ranger.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(17));
    expect(ranger.featureDefinitions.keys.toSet(), granted);

    for (final entry in ranger.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.ranger);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('proficiencies and starting equipment match the manual', () {
    expect(
      ranger.proficiencies.armor,
      {'light_armor', 'medium_armor', 'shield'},
    );
    expect(
      ranger.proficiencies.weapons,
      {'simple_weapons', 'martial_weapons'},
    );
    expect(ranger.proficiencies.savingThrows, {'FOR', 'DES'});
    expect(ranger.proficiencies.skillChoices, 3);
    expect(ranger.proficiencies.skillOptions, hasLength(8));

    expect(
      ranger.startingEquipmentChoices.map((choice) => choice.id).toSet(),
      {
        'ranger_starting_armor',
        'ranger_melee_weapons',
        'ranger_starting_pack',
      },
    );
    expect(
      ranger.fixedStartingEquipment
          .map(
              (grant) => '${grant.catalogId}:${grant.itemId}:${grant.quantity}')
          .toSet(),
      {'weapon:longbow:1', 'ammunition:arrows:20'},
    );

    final armor = ranger.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'ranger_starting_armor',
    );
    expect(
      armor.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      {'scale_mail', 'leather'},
    );

    final weapons = ranger.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'ranger_melee_weapons',
    );
    final simple = weapons.alternatives.singleWhere(
      (alternative) => alternative.id == 'ranger_two_simple_melee_weapons',
    );
    expect(simple.itemChoices.single.selections, 2);
    expect(simple.itemChoices.single.allowDuplicates, isTrue);
    expect(simple.itemChoices.single.optionIds, hasLength(10));
  });

  test('Favored Enemy and Natural Explorer grow at the correct levels', () {
    expect(phbRangerFavoredEnemyOptions, hasLength(14));
    expect(
      phbRangerFavoredEnemyOptions.map((option) => option.id).toSet(),
      {
        'aberration',
        'beast',
        'celestial',
        'construct',
        'dragon',
        'elemental',
        'fey',
        'giant',
        'fiend',
        'ooze',
        'monstrosity',
        'undead',
        'plant',
        'two_humanoid_races',
      },
    );
    expect(phbRangerTerrainOptions, hasLength(8));

    for (final id in {
      RangerFeatureIds.favoredEnemy,
      RangerFeatureIds.favoredEnemyImprovement6,
      RangerFeatureIds.favoredEnemyImprovement14,
    }) {
      final feature = ranger.featureDefinitions[id]!;
      expect(feature.choices, hasLength(3));
      expect(feature.choices.first.requireNewAcquisition, isTrue);
      expect(feature.choices[1].maximumSelections, 2);
      expect(feature.choices[2].maximumSelections, 1);
    }

    for (final id in {
      RangerFeatureIds.naturalExplorer,
      RangerFeatureIds.naturalExplorerImprovement6,
      RangerFeatureIds.naturalExplorerImprovement10,
    }) {
      final feature = ranger.featureDefinitions[id]!;
      expect(feature.choices, hasLength(1));
      expect(feature.choices.single.options, hasLength(8));
      expect(feature.choices.single.requireNewAcquisition, isTrue);
    }
  });

  test('Ranger spell slots and spells known match all twenty table rows', () {
    final magic = ranger.spellcasting!;
    expect(magic.progression, ClassSpellcastingProgression.half);
    expect(magic.ability, 'SAG');
    expect(magic.minimumLevel, 2);
    expect(magic.ritualCasting, isFalse);
    expect(magic.preparesSpells, isFalse);

    const expectedSlots = <int, List<int>>{
      1: [0, 0, 0, 0, 0],
      2: [2, 0, 0, 0, 0],
      3: [3, 0, 0, 0, 0],
      4: [3, 0, 0, 0, 0],
      5: [4, 2, 0, 0, 0],
      6: [4, 2, 0, 0, 0],
      7: [4, 3, 0, 0, 0],
      8: [4, 3, 0, 0, 0],
      9: [4, 3, 2, 0, 0],
      10: [4, 3, 2, 0, 0],
      11: [4, 3, 3, 0, 0],
      12: [4, 3, 3, 0, 0],
      13: [4, 3, 3, 1, 0],
      14: [4, 3, 3, 1, 0],
      15: [4, 3, 3, 2, 0],
      16: [4, 3, 3, 2, 0],
      17: [4, 3, 3, 3, 1],
      18: [4, 3, 3, 3, 1],
      19: [4, 3, 3, 3, 2],
      20: [4, 3, 3, 3, 2],
    };
    const expectedKnown = <int, int>{
      1: 0,
      2: 2,
      3: 3,
      4: 3,
      5: 4,
      6: 4,
      7: 5,
      8: 5,
      9: 6,
      10: 6,
      11: 7,
      12: 7,
      13: 8,
      14: 8,
      15: 9,
      16: 9,
      17: 10,
      18: 10,
      19: 11,
      20: 11,
    };

    for (var level = 1; level <= 20; level++) {
      expect(
        magic.slotsAtLevel(level),
        expectedSlots[level],
        reason: 'slot del Ranger errati al livello $level',
      );
      expect(
        magic.spellsKnownAtLevel(level),
        expectedKnown[level],
        reason: 'incantesimi conosciuti errati al livello $level',
      );
    }
  });

  test('all forty-six Ranger spells are canonical and correctly distributed',
      () {
    expect(phbRangerSpellIds, hasLength(46));
    expect(
        phbRangerSpellIds.difference(spellDefinitions.keys.toSet()), isEmpty);

    final canonical = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.ranger))
        .map((spell) => spell.id)
        .toSet();
    expect(phbRangerSpellIds, canonical);

    final spellsByLevel = <int, int>{};
    for (final id in phbRangerSpellIds) {
      final level = spellDefinitions[id]!.level;
      spellsByLevel[level] = (spellsByLevel[level] ?? 0) + 1;
    }
    expect(spellsByLevel, {1: 13, 2: 13, 3: 11, 4: 5, 5: 4});
  });

  test('complex base features preserve their limiting manual clauses', () {
    final naturalExplorer =
        ranger.featureDefinitions[RangerFeatureIds.naturalExplorer]!;
    expect(
      naturalExplorer.content.description.details,
      allOf(
        contains('almeno un’ora'),
        contains('non può smarrirsi'),
        contains('doppio del cibo'),
        contains('numero esatto'),
      ),
    );

    final awareness =
        ranger.featureDefinitions[RangerFeatureIds.primevalAwareness]!;
    expect(
      awareness.content.description.details,
      allOf(
        contains('1 minuto per livello'),
        contains('1,5 km'),
        contains('9 km'),
        contains('né il numero né l’ubicazione'),
      ),
    );

    final camouflage =
        ranger.featureDefinitions[RangerFeatureIds.hideInPlainSight]!;
    expect(camouflage.effects.ruleEffects.single.value, 10);
    expect(
      camouflage.effects.ruleEffects.single.condition,
      contains('movement_action_or_reaction'),
    );

    final senses = ranger.featureDefinitions[RangerFeatureIds.feralSenses]!;
    expect(senses.effects.ruleEffects, hasLength(2));
    expect(senses.content.description.details, contains('9 metri'));

    final slayer = ranger.featureDefinitions[RangerFeatureIds.foeSlayer]!;
    expect(
      slayer.content.description.details,
      allOf(
        contains('una volta per turno'),
        contains('Saggezza'),
        contains('prima che gli effetti'),
      ),
    );
  });

  test('the four PHB fighting styles exclude later supplemental styles', () {
    expect(
      phbRangerFightingStyleIds,
      {'archery', 'defense', 'dueling', 'two_weapon_fighting'},
    );
    final feature = ranger.featureDefinitions[RangerFeatureIds.fightingStyle]!;
    expect(
      feature.choices.single.options.map((option) => option.id).toSet(),
      phbRangerFightingStyleIds,
    );
  });

  test('both and only both PHB Ranger archetypes are registered', () {
    expect(
      ranger.subclasses.keys.toSet(),
      {RangerSubclassIds.hunter, RangerSubclassIds.beastMaster},
    );
    expect(
      ranger.phbSubclasses.map((subclass) => subclass.id).toSet(),
      phbRangerSubclassIds,
    );

    for (final subclass in ranger.subclasses.values) {
      expect(subclass.classId, ClassIds.ranger);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
      expect(subclass.content.source.name, 'Manuale del Giocatore 2014');
      expect(subclass.content.source.reference, 'pp. 105-106');
      expect(subclass.featuresByLevel.keys.toSet(), {3, 7, 11, 15});

      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();
      expect(subclass.featureDefinitions.keys.toSet(), granted);
    }
  });

  test('Hunter exposes four choices and exactly eleven PHB options', () {
    expect(hunter.featureDefinitions, hasLength(4));
    expect(rangerHunterPreyOptions, hasLength(3));
    expect(rangerHunterDefensiveTacticsOptions, hasLength(3));
    expect(rangerHunterMultiattackOptions, hasLength(2));
    expect(rangerHunterSuperiorDefenseOptions, hasLength(3));

    final ids = {
      ...rangerHunterPreyOptions.map((option) => option.id),
      ...rangerHunterDefensiveTacticsOptions.map((option) => option.id),
      ...rangerHunterMultiattackOptions.map((option) => option.id),
      ...rangerHunterSuperiorDefenseOptions.map((option) => option.id),
    };
    expect(ids, hasLength(11));

    for (final feature in hunter.featureDefinitions.values) {
      expect(feature.choices, hasLength(1));
      expect(feature.choices.single.minimumSelections, 1);
      expect(feature.choices.single.maximumSelections, 1);
    }
  });

  test('Beast Master companion is structured and linked to its feature', () {
    expect(beastMaster.featureDefinitions, hasLength(4));
    expect(beastMaster.companions, hasLength(1));

    final companion = beastMaster.companions.single;
    expect(companion.id, RangerCompanionIds.animalCompanion);
    expect(companion.featureId, RangerBeastMasterFeatureIds.rangerCompanion);
    expect(companion.allowedCreatureTypes, {'beast'});
    expect(companion.maximumChallengeRating, 0.25);
    expect(companion.maximumSize, ClassCompanionSize.medium);
    expect(companion.hitPointMinimumClassLevelMultiplier, 4);
    expect(companion.commands, hasLength(3));
    expect(companion.attacksPerAttackCommandAtLevel(10), 1);
    expect(companion.attacksPerAttackCommandAtLevel(11), 2);
    expect(companion.sharedSelfSpellMinimumLevel, 15);
    expect(companion.sharedSpellMaximumDistanceMeters, 9);

    expect(
      ranger.companionFor(
        companion.id,
        subclassId: RangerSubclassIds.beastMaster,
      ),
      same(companion),
    );
  });

  test('all Ranger editorial records have stable IDs and manual sources', () {
    final contents = [
      ranger.content,
      ...ranger.featureDefinitions.values.map((feature) => feature.content),
      ...ranger.subclasses.values.map((subclass) => subclass.content),
      ...ranger.subclasses.values.expand(
        (subclass) => subclass.featureDefinitions.values
            .map((feature) => feature.content),
      ),
    ];

    expect(contents.map((content) => content.id).toSet(),
        hasLength(contents.length));
    for (final content in contents) {
      expect(content.id, isNotEmpty);
      expect(content.name, isNotEmpty);
      expect(content.description.summary, isNotEmpty);
      expect(content.description.details, isNotEmpty);
      expect(content.source.name, 'Manuale del Giocatore 2014');
      expect(content.source.reference, isNotEmpty);
      expect(content.ownerId, isNotNull);
      expect(content.ownerId, isNotEmpty);
    }
  });
}
