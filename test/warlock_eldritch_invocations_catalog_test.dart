import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;
  final invocations = phbWarlockEldritchInvocationDefinitions;

  EldritchInvocationDefinition invocation(String id) => invocations[id]!;

  test('all thirty-two PHB 2014 Eldritch Invocations are registered', () {
    const expectedIds = <String>{
      WarlockEldritchInvocationIds.armorOfShadows,
      WarlockEldritchInvocationIds.otherworldlyLeap,
      WarlockEldritchInvocationIds.chainsOfCarceri,
      WarlockEldritchInvocationIds.agonizingBlast,
      WarlockEldritchInvocationIds.repellingBlast,
      WarlockEldritchInvocationIds.mireTheMind,
      WarlockEldritchInvocationIds.beguilingInfluence,
      WarlockEldritchInvocationIds.thiefOfFiveFates,
      WarlockEldritchInvocationIds.thirstingBlade,
      WarlockEldritchInvocationIds.eldritchSpear,
      WarlockEldritchInvocationIds.bookOfAncientSecrets,
      WarlockEldritchInvocationIds.beastSpeech,
      WarlockEldritchInvocationIds.masterOfMyriadForms,
      WarlockEldritchInvocationIds.maskOfManyFaces,
      WarlockEldritchInvocationIds.eyesOfTheRuneKeeper,
      WarlockEldritchInvocationIds.dreadfulWord,
      WarlockEldritchInvocationIds.ascendantStep,
      WarlockEldritchInvocationIds.signOfIllOmen,
      WarlockEldritchInvocationIds.sculptorOfFlesh,
      WarlockEldritchInvocationIds.minionsOfChaos,
      WarlockEldritchInvocationIds.gazeOfTwoMinds,
      WarlockEldritchInvocationIds.lifedrinker,
      WarlockEldritchInvocationIds.whispersOfTheGrave,
      WarlockEldritchInvocationIds.bewitchingWhispers,
      WarlockEldritchInvocationIds.oneWithShadows,
      WarlockEldritchInvocationIds.fiendishVigor,
      WarlockEldritchInvocationIds.visionsOfDistantRealms,
      WarlockEldritchInvocationIds.mistyVisions,
      WarlockEldritchInvocationIds.devilsSight,
      WarlockEldritchInvocationIds.eldritchSight,
      WarlockEldritchInvocationIds.witchSight,
      WarlockEldritchInvocationIds.voiceOfTheChainMaster,
    };

    expect(invocations, hasLength(32));
    expect(invocations.keys.toSet(), expectedIds);
    expect(phbWarlockEldritchInvocationIds.toSet(), expectedIds);
    expect(
      invocations.values.map((value) => value.name).toSet(),
      hasLength(32),
    );

    for (final entry in invocations.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.warlock);
      expect(
        entry.value.content.source.name,
        'Manuale del Giocatore 2014',
      );
      expect(entry.value.content.source.reference, 'pp. 118-119');
      expect(
        entry.value.content.description.summary.isNotEmpty,
        isTrue,
      );
      expect(
        entry.value.content.description.details.isNotEmpty,
        isTrue,
      );
    }
  });

  test('level prerequisites match the PHB list exactly', () {
    final restricted = {
      for (final value in invocations.values)
        if (value.minimumWarlockLevel > 2) value.id: value.minimumWarlockLevel,
    };

    expect(restricted, {
      WarlockEldritchInvocationIds.mireTheMind: 5,
      WarlockEldritchInvocationIds.thirstingBlade: 5,
      WarlockEldritchInvocationIds.signOfIllOmen: 5,
      WarlockEldritchInvocationIds.oneWithShadows: 5,
      WarlockEldritchInvocationIds.dreadfulWord: 7,
      WarlockEldritchInvocationIds.sculptorOfFlesh: 7,
      WarlockEldritchInvocationIds.bewitchingWhispers: 7,
      WarlockEldritchInvocationIds.otherworldlyLeap: 9,
      WarlockEldritchInvocationIds.ascendantStep: 9,
      WarlockEldritchInvocationIds.minionsOfChaos: 9,
      WarlockEldritchInvocationIds.whispersOfTheGrave: 9,
      WarlockEldritchInvocationIds.lifedrinker: 12,
      WarlockEldritchInvocationIds.chainsOfCarceri: 15,
      WarlockEldritchInvocationIds.masterOfMyriadForms: 15,
      WarlockEldritchInvocationIds.visionsOfDistantRealms: 15,
      WarlockEldritchInvocationIds.witchSight: 15,
    });
  });

  test('Pact Boon and spell prerequisites are separate fields', () {
    final pactRequirements = {
      for (final value in invocations.values)
        if (value.requiredPactBoonId != null)
          value.id: value.requiredPactBoonId,
    };

    expect(pactRequirements, {
      WarlockEldritchInvocationIds.chainsOfCarceri: WarlockPactBoonIds.chain,
      WarlockEldritchInvocationIds.thirstingBlade: WarlockPactBoonIds.blade,
      WarlockEldritchInvocationIds.bookOfAncientSecrets:
          WarlockPactBoonIds.tome,
      WarlockEldritchInvocationIds.lifedrinker: WarlockPactBoonIds.blade,
      WarlockEldritchInvocationIds.voiceOfTheChainMaster:
          WarlockPactBoonIds.chain,
    });

    final spellRequirements = {
      for (final value in invocations.values)
        if (value.requiredSpellId != null) value.id: value.requiredSpellId,
    };

    expect(spellRequirements, {
      WarlockEldritchInvocationIds.agonizingBlast: 'eldritch_blast',
      WarlockEldritchInvocationIds.repellingBlast: 'eldritch_blast',
      WarlockEldritchInvocationIds.eldritchSpear: 'eldritch_blast',
    });
  });

  test('invocation availability resolves every prerequisite', () {
    final chains = invocation(WarlockEldritchInvocationIds.chainsOfCarceri);

    expect(chains.isAvailable(warlockLevel: 14), isFalse);
    expect(
      chains.isAvailable(
        warlockLevel: 15,
        pactBoonId: WarlockPactBoonIds.blade,
      ),
      isFalse,
    );
    expect(
      chains.isAvailable(
        warlockLevel: 15,
        pactBoonId: WarlockPactBoonIds.chain,
      ),
      isTrue,
    );

    final agonizing = invocation(WarlockEldritchInvocationIds.agonizingBlast);

    expect(agonizing.isAvailable(warlockLevel: 2), isFalse);
    expect(
      agonizing.isAvailable(
        warlockLevel: 2,
        knownSpellIds: {'eldritch_blast'},
      ),
      isTrue,
    );
  });

  test('all invocation spell references resolve canonically', () {
    final spellInvocations =
        invocations.values.where((value) => value.spellId != null).toList();

    expect(spellInvocations, hasLength(19));
    expect(
      spellInvocations.where(
        (value) => !spellDefinitions.containsKey(value.spellId),
      ),
      isEmpty,
    );
    expect(spellDefinitions['eldritch_blast'], isNotNull);
  });

  test('at-will and long-rest spell uses remain distinct', () {
    final atWill = invocations.values
        .where((value) => value.castsSpellAtWill)
        .map((value) => value.id)
        .toSet();

    expect(atWill, {
      WarlockEldritchInvocationIds.armorOfShadows,
      WarlockEldritchInvocationIds.otherworldlyLeap,
      WarlockEldritchInvocationIds.chainsOfCarceri,
      WarlockEldritchInvocationIds.beastSpeech,
      WarlockEldritchInvocationIds.masterOfMyriadForms,
      WarlockEldritchInvocationIds.maskOfManyFaces,
      WarlockEldritchInvocationIds.ascendantStep,
      WarlockEldritchInvocationIds.whispersOfTheGrave,
      WarlockEldritchInvocationIds.fiendishVigor,
      WarlockEldritchInvocationIds.visionsOfDistantRealms,
      WarlockEldritchInvocationIds.mistyVisions,
      WarlockEldritchInvocationIds.eldritchSight,
    });

    final longRestWithSlot = invocations.values
        .where((value) => value.spendsPactSlot)
        .map((value) => value.id)
        .toSet();

    expect(longRestWithSlot, {
      WarlockEldritchInvocationIds.mireTheMind,
      WarlockEldritchInvocationIds.thiefOfFiveFates,
      WarlockEldritchInvocationIds.dreadfulWord,
      WarlockEldritchInvocationIds.signOfIllOmen,
      WarlockEldritchInvocationIds.sculptorOfFlesh,
      WarlockEldritchInvocationIds.minionsOfChaos,
      WarlockEldritchInvocationIds.bewitchingWhispers,
    });
  });

  test('Book of Ancient Secrets preserves every ritual rule', () {
    final book = invocation(
      WarlockEldritchInvocationIds.bookOfAncientSecrets,
    ).ritualBook!;

    final canonicalFirstLevelRituals = spellDefinitions.values
        .where((spell) => spell.level == 1 && spell.ritual)
        .map((spell) => spell.id)
        .toSet();

    expect(book.initialRitualCount, 2);
    expect(book.initialSpellLevel, 1);
    expect(book.initialRitualChoice.minimumSelections, 2);
    expect(book.initialRitualChoice.maximumSelections, 2);
    expect(
      book.initialRitualChoice.optionIds.toSet(),
      canonicalFirstLevelRituals,
    );
    expect(book.maximumCopyableSpellLevelAt(3), 2);
    expect(book.maximumCopyableSpellLevelAt(4), 2);
    expect(book.maximumCopyableSpellLevelAt(5), 3);
    expect(book.copyingHoursPerSpellLevel, 2);
    expect(book.copyingGoldPiecesPerSpellLevel, 50);
    expect(book.copiedSpellsAreRitualOnly, isTrue);
    expect(book.canCastKnownWarlockRituals, isTrue);
    expect(book.initialRitualsCountAgainstSpellsKnown, isFalse);
  });

  test('passive invocation mechanics are structured', () {
    final influence =
        invocation(WarlockEldritchInvocationIds.beguilingInfluence);

    expect(
      influence.effects.skillProficiencies,
      {'deception', 'persuasion'},
    );

    final spear = invocation(WarlockEldritchInvocationIds.eldritchSpear);
    expect(spear.effects.ruleEffects.single.value, 90);

    final repelling = invocation(WarlockEldritchInvocationIds.repellingBlast);
    expect(repelling.effects.ruleEffects.single.value, 3);

    final devil = invocation(WarlockEldritchInvocationIds.devilsSight);
    expect(devil.effects.ruleEffects.single.value, 36);

    final witch = invocation(WarlockEldritchInvocationIds.witchSight);
    expect(witch.effects.ruleEffects.single.value, 9);

    final vigor = invocation(WarlockEldritchInvocationIds.fiendishVigor);
    expect(vigor.selfOnly, isTrue);
    expect(vigor.ignoresMaterialComponents, isTrue);
    expect(vigor.spellLevelOverride, 1);
  });

  test('class feature links the catalog and PHB progression', () {
    final feature =
        warlock.featureDefinitions[WarlockFeatureIds.eldritchInvocations]!;
    final choice = feature.choices.single;

    expect(choice.id, WarlockChoiceIds.eldritchInvocations);
    expect(choice.catalogId, CharacterChoiceCatalogIds.eldritchInvocations);
    expect(choice.minimumSelections, 2);
    expect(choice.maximumSelections, 8);
    expect(choice.unique, isTrue);
    expect(choice.optionIds.toSet(), invocations.keys.toSet());

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
}
