import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;

  test('the universal registry contains all twelve PHB classes', () {
    expect(
      phbClassDefinitions.keys.toSet(),
      {
        ClassIds.barbarian,
        ClassIds.bard,
        ClassIds.cleric,
        ClassIds.druid,
        ClassIds.fighter,
        ClassIds.monk,
        ClassIds.paladin,
        ClassIds.ranger,
        ClassIds.rogue,
        ClassIds.sorcerer,
        ClassIds.warlock,
        ClassIds.wizard,
      },
    );
  });

  test('Warlock identity and proficiencies match the PHB 2014', () {
    expect(warlock, same(warlockClassDefinition));
    expect(warlock.id, ClassIds.warlock);
    expect(warlock.name, 'Warlock');
    expect(warlock.hitDie, 8);
    expect(warlock.subclassSelectionLevel, 1);
    expect(warlock.homebrew, isFalse);
    expect(warlock.content.ownerId, ClassIds.warlock);
    expect(warlock.content.source.name, 'Manuale del Giocatore 2014');
    expect(warlock.proficiencies.armor, {'light_armor'});
    expect(warlock.proficiencies.weapons, {'simple_weapons'});
    expect(warlock.proficiencies.tools, isEmpty);
    expect(warlock.proficiencies.savingThrows, {'SAG', 'CAR'});
    expect(warlock.proficiencies.skillChoices, 2);
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
  });

  test('base progression grants every PHB feature at the right level', () {
    expect(
      warlock.featuresByLevel,
      {
        1: [
          WarlockFeatureIds.otherworldlyPatron,
          WarlockFeatureIds.pactMagic,
        ],
        2: [WarlockFeatureIds.eldritchInvocations],
        3: [WarlockFeatureIds.pactBoon],
        4: [WarlockFeatureIds.abilityScoreImprovement],
        8: [WarlockFeatureIds.abilityScoreImprovement],
        11: [WarlockFeatureIds.mysticArcanum6],
        12: [WarlockFeatureIds.abilityScoreImprovement],
        13: [WarlockFeatureIds.mysticArcanum7],
        15: [WarlockFeatureIds.mysticArcanum8],
        16: [WarlockFeatureIds.abilityScoreImprovement],
        17: [WarlockFeatureIds.mysticArcanum9],
        19: [WarlockFeatureIds.abilityScoreImprovement],
        20: [WarlockFeatureIds.eldritchMaster],
      },
    );

    final granted =
        warlock.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, warlock.featureDefinitions.keys.toSet());
  });

  test('Pact Magic reproduces the full level 1-20 table', () {
    final magic = warlock.spellcasting!;

    const expectedSlots = <int, List<int>>{
      1: [1],
      2: [2],
      3: [0, 2],
      4: [0, 2],
      5: [0, 0, 2],
      6: [0, 0, 2],
      7: [0, 0, 0, 2],
      8: [0, 0, 0, 2],
      9: [0, 0, 0, 0, 2],
      10: [0, 0, 0, 0, 2],
      11: [0, 0, 0, 0, 3],
      12: [0, 0, 0, 0, 3],
      13: [0, 0, 0, 0, 3],
      14: [0, 0, 0, 0, 3],
      15: [0, 0, 0, 0, 3],
      16: [0, 0, 0, 0, 3],
      17: [0, 0, 0, 0, 4],
      18: [0, 0, 0, 0, 4],
      19: [0, 0, 0, 0, 4],
      20: [0, 0, 0, 0, 4],
    };

    const expectedSlotLevels = <int, int>{
      1: 1,
      3: 2,
      5: 3,
      7: 4,
      9: 5,
    };

    const expectedCantrips = <int, int>{
      1: 2,
      4: 3,
      10: 4,
    };

    const expectedSpellsKnown = <int, int>{
      1: 2,
      2: 3,
      3: 4,
      4: 5,
      5: 6,
      6: 7,
      7: 8,
      8: 9,
      9: 10,
      10: 10,
      11: 11,
      12: 11,
      13: 12,
      14: 12,
      15: 13,
      16: 13,
      17: 14,
      18: 14,
      19: 15,
      20: 15,
    };

    expect(magic.progression, ClassSpellcastingProgression.pact);
    expect(magic.ability, 'CAR');
    expect(magic.minimumLevel, 1);
    expect(magic.preparesSpells, isFalse);
    expect(magic.ritualCasting, isFalse);
    expect(magic.spellIds, hasLength(74));
    expect(magic.spellIds, phbWarlockSpellIds);
    expect(magic.slotsByClassLevel, expectedSlots);
    expect(magic.pactSlotLevelByClassLevel, expectedSlotLevels);
    expect(magic.cantripsKnownByLevel, expectedCantrips);
    expect(magic.spellsKnownByLevel, expectedSpellsKnown);

    for (var level = 1; level <= 20; level++) {
      expect(magic.slotsAtLevel(level), expectedSlots[level]);
    }

    expect(magic.pactSlotLevelAtLevel(20), 5);
    expect(magic.cantripsKnownAtLevel(20), 4);
    expect(magic.spellsKnownAtLevel(20), 15);
  });

  test('all Warlock spell references resolve to the canonical catalog', () {
    final referencedSpellIds = <String>{
      ...warlock.spellcasting!.spellIds,
    };

    for (final featureId in {
      WarlockFeatureIds.mysticArcanum6,
      WarlockFeatureIds.mysticArcanum7,
      WarlockFeatureIds.mysticArcanum8,
      WarlockFeatureIds.mysticArcanum9,
    }) {
      referencedSpellIds.addAll(
        warlock.featureDefinitions[featureId]!.choices.single.optionIds,
      );
    }

    final pactChoice =
        warlock.featureDefinitions[WarlockFeatureIds.pactBoon]!.choices.single;

    for (final option in pactChoice.options) {
      referencedSpellIds.addAll(option.effects.grantedSpellIds);
    }

    referencedSpellIds.addAll(
      phbWarlockEldritchInvocationDefinitions.values
          .where((invocation) => invocation.spellId != null)
          .map((invocation) => invocation.spellId!),
    );

    for (final patron in warlock.subclasses.values) {
      referencedSpellIds.addAll(
        patron.expandedSpellIdsByLevel.values.expand((ids) => ids),
      );
      referencedSpellIds.addAll(
        patron.featureDefinitions.values
            .expand((feature) => feature.effects.grantedSpellIds),
      );
    }

    expect(
      referencedSpellIds.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('class resources preserve PHB maxima and recoveries', () {
    expect(warlock.resources, hasLength(6));

    final resources = {
      for (final resource in warlock.resources) resource.id: resource,
    };

    expect(resources.keys, {
      WarlockResourceIds.pactMagicSlots,
      WarlockResourceIds.mysticArcanum6,
      WarlockResourceIds.mysticArcanum7,
      WarlockResourceIds.mysticArcanum8,
      WarlockResourceIds.mysticArcanum9,
      WarlockResourceIds.eldritchMaster,
    });

    final pactSlots = resources[WarlockResourceIds.pactMagicSlots]!;
    expect(pactSlots.recovery, ClassResourceRecovery.shortRest);
    expect(pactSlots.maximumAtLevel(1), 1);
    expect(pactSlots.maximumAtLevel(2), 2);
    expect(pactSlots.maximumAtLevel(11), 3);
    expect(pactSlots.maximumAtLevel(17), 4);

    for (final id in {
      WarlockResourceIds.mysticArcanum6,
      WarlockResourceIds.mysticArcanum7,
      WarlockResourceIds.mysticArcanum8,
      WarlockResourceIds.mysticArcanum9,
      WarlockResourceIds.eldritchMaster,
    }) {
      expect(resources[id]!.recovery, ClassResourceRecovery.longRest);
      expect(resources[id]!.maximumAtLevel(20), 1);
    }

    final resourceIds = resources.keys.toSet();

    for (final feature in warlock.featureDefinitions.values) {
      if (feature.resourceId != null) {
        expect(resourceIds, contains(feature.resourceId));
      }
    }
  });

  test('Dono del Patto contains the three complete PHB options', () {
    final choice =
        warlock.featureDefinitions[WarlockFeatureIds.pactBoon]!.choices.single;

    expect(choice.optionIds.toSet(), phbWarlockPactBoonIds);
    expect(
      choice.options.map((option) => option.id).toSet(),
      phbWarlockPactBoonIds,
    );

    final chain = choice.options.singleWhere(
      (option) => option.id == WarlockPactBoonIds.chain,
    );
    final familiarForms = chain.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_chain_special_forms',
    );

    expect(chain.effects.grantedSpellIds, ['find_familiar']);
    expect(
      familiarForms.referenceIds.toSet(),
      phbWarlockPactOfChainSpecialFamiliarIds,
    );

    final blade = choice.options.singleWhere(
      (option) => option.id == WarlockPactBoonIds.blade,
    );
    expect(blade.effects.choices.single.optionIds, hasLength(28));

    final tome = choice.options.singleWhere(
      (option) => option.id == WarlockPactBoonIds.tome,
    );
    expect(tome.effects.choices.single.minimumSelections, 3);
    expect(tome.effects.choices.single.maximumSelections, 3);
    expect(
      tome.effects.choices.single.optionIds.toSet(),
      spellDefinitions.values
          .where((spell) => spell.level == 0)
          .map((spell) => spell.id)
          .toSet(),
    );
  });

  test('all thirty-two PHB Eldritch Invocations are linked', () {
    final invocations = phbWarlockEldritchInvocationDefinitions;
    final feature =
        warlock.featureDefinitions[WarlockFeatureIds.eldritchInvocations]!;
    final choice = feature.choices.single;

    expect(invocations, hasLength(32));
    expect(phbWarlockEldritchInvocationIds, hasLength(32));
    expect(
      choice.catalogId,
      CharacterChoiceCatalogIds.eldritchInvocations,
    );
    expect(choice.minimumSelections, 2);
    expect(choice.maximumSelections, 8);
    expect(choice.unique, isTrue);
    expect(choice.optionIds.toSet(), invocations.keys.toSet());

    final contentIds = <String>{};

    for (final entry in invocations.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.warlock);
      expect(
        entry.value.content.source.name,
        'Manuale del Giocatore 2014',
      );
      expect(entry.value.minimumWarlockLevel, inInclusiveRange(2, 15));
      expect(contentIds.add(entry.value.content.id), isTrue);

      if (entry.value.requiredPactBoonId != null) {
        expect(
          phbWarlockPactBoonIds,
          contains(entry.value.requiredPactBoonId),
        );
      }

      if (entry.value.requiredSpellId != null) {
        expect(
          spellDefinitions,
          contains(entry.value.requiredSpellId),
        );
      }
    }

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
        18,
      ),
      '8',
    );
  });

  test('all three patrons have complete PHB spell and feature tables', () {
    expect(warlock.subclasses.keys.toSet(), phbWarlockSubclassIds);
    expect(warlock.subclasses, hasLength(3));

    final expectedExpandedSpells = <String, Map<int, Set<String>>>{
      WarlockSubclassIds.archfey: phbWarlockArchfeyExpandedSpellIdsByLevel,
      WarlockSubclassIds.fiend: phbWarlockFiendExpandedSpellIdsByLevel,
      WarlockSubclassIds.greatOldOne:
          phbWarlockGreatOldOneExpandedSpellIdsByLevel,
    };

    for (final entry in warlock.subclasses.entries) {
      final patron = entry.value;

      expect(patron.id, entry.key);
      expect(patron.classId, ClassIds.warlock);
      expect(patron.content.ownerId, ClassIds.warlock);
      expect(
        patron.content.source.name,
        'Manuale del Giocatore 2014',
      );
      expect(patron.homebrew, isFalse);
      expect(patron.supplemental, isFalse);
      expect(patron.featuresByLevel.keys.toSet(), {1, 6, 10, 14});
      expect(patron.featureDefinitions, hasLength(4));
      expect(
        patron.featuresByLevel.values.expand((features) => features).toSet(),
        patron.featureDefinitions.keys.toSet(),
      );
      expect(
        patron.expandedSpellIdsByLevel,
        expectedExpandedSpells[entry.key],
      );
      expect(
        patron.expandedSpellIdsByLevel.values.expand((ids) => ids).toSet(),
        hasLength(10),
      );
      expect(patron.expandedSpellIdsAtLevel(20), hasLength(10));
      expect(patron.alwaysPreparedSpellIdsByLevel, isEmpty);

      final automaticallyGranted = patron.featureDefinitions.values
          .expand((feature) => feature.effects.grantedSpellIds)
          .toSet();

      expect(automaticallyGranted, isEmpty);

      final resourceIds =
          patron.resources.map((resource) => resource.id).toSet();

      for (final feature in patron.featureDefinitions.values) {
        expect(feature.content.ownerId, ClassIds.warlock);

        if (feature.resourceId != null) {
          expect(resourceIds, contains(feature.resourceId));
        }
      }
    }
  });

  test('patron-specific signature rules remain structured', () {
    final archfey = warlock.subclasses[WarlockSubclassIds.archfey]!;
    final fiend = warlock.subclasses[WarlockSubclassIds.fiend]!;
    final greatOldOne = warlock.subclasses[WarlockSubclassIds.greatOldOne]!;

    expect(
      archfey.featureDefinitions[WarlockArchfeyFeatureIds.feyPresence]!.effects
          .ruleEffects.single.value,
      3,
    );

    expect(
      archfey.featureDefinitions[WarlockArchfeyFeatureIds.mistyEscape]!.effects
          .ruleEffects.single.value,
      18,
    );

    final resilience = fiend
        .featureDefinitions[WarlockFiendFeatureIds.fiendishResilience]!
        .choices
        .single;

    expect(resilience.options, hasLength(13));
    expect(
      resilience.options.map((option) => option.id).toSet(),
      phbWarlockFiendishResilienceDamageTypeLabels.keys.toSet(),
    );

    final awakenedMind = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.awakenedMind]!
        .effects
        .ruleEffects
        .single;

    expect(awakenedMind.value, 9);
    expect(
      awakenedMind.condition,
      contains('no_shared_language_required'),
    );

    final thoughtShield = greatOldOne
        .featureDefinitions[WarlockGreatOldOneFeatureIds.thoughtShield]!;

    expect(thoughtShield.effects.damageResistances, {'psychic'});
  });

  test('all Warlock-owned IDs and effect IDs are stable and unique', () {
    final contentIds = <String>{};
    final effectIds = <String>[];

    for (final entry in warlock.featureDefinitions.entries) {
      expect(contentIds.add(entry.value.content.id), isTrue);
      effectIds.addAll(
        entry.value.effects.ruleEffects.map((effect) => effect.id),
      );
    }

    for (final patron in warlock.subclasses.values) {
      expect(contentIds.add(patron.content.id), isTrue);

      for (final entry in patron.featureDefinitions.entries) {
        expect(contentIds.add(entry.value.content.id), isTrue);
        effectIds.addAll(
          entry.value.effects.ruleEffects.map((effect) => effect.id),
        );
      }
    }

    for (final invocation in phbWarlockEldritchInvocationDefinitions.values) {
      expect(contentIds.add(invocation.content.id), isTrue);
      effectIds.addAll(
        invocation.effects.ruleEffects.map((effect) => effect.id),
      );
    }

    final pactChoice =
        warlock.featureDefinitions[WarlockFeatureIds.pactBoon]!.choices.single;

    effectIds.addAll(
      pactChoice.options
          .expand((option) => option.effects.ruleEffects)
          .map((effect) => effect.id),
    );

    expect(effectIds.every((id) => id.isNotEmpty), isTrue);
    expect(effectIds.toSet(), hasLength(effectIds.length));
  });
}
