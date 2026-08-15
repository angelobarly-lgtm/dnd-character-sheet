import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const creatureIds = {
    BestiaryBeastIds.weasel,
    BestiaryBeastIds.giantWeasel,
    BestiaryBeastIds.hawk,
    BestiaryBeastIds.bloodHawk,
    BestiaryBeastIds.cat,
    BestiaryBeastIds.ape,
    BestiaryBeastIds.giantApe,
    BestiaryBeastIds.crab,
    BestiaryBeastIds.giantCrab,
    BestiaryBeastIds.owl,
    BestiaryBeastIds.giantOwl,
    BestiaryBeastIds.hyena,
    BestiaryBeastIds.giantHyena,
    BestiaryBeastIds.lion,
    BestiaryBeastIds.lizard,
  };

  final creatures = {
    for (final id in creatureIds) id: phbBestiaryBeastDefinitions[id]!,
  };

  test('fifteen beasts from pages 324-327 are registered', () {
    expect(creatures.keys.toSet(), creatureIds);
    expect(phbBestiaryDefinitions.keys, containsAll(creatureIds));
    expect(phbBestiaryDefinitions.length, greaterThanOrEqualTo(35));
  });

  test('all fifteen creatures preserve manual provenance', () {
    expect(
      creatures.values.map((creature) => creature.source.book).toSet(),
      {'Manuale dei Mostri'},
    );
    expect(
      creatures.values.map((creature) => creature.source.edition).toSet(),
      {'2014'},
    );
    expect(
      creatures.values.map((creature) => creature.source.pageStart).toSet(),
      {324, 325, 326, 327},
    );

    for (final creature in creatures.values) {
      expect(creature.type, CreatureType.beast);
      expect(creature.origin, BestiaryContentOrigin.official);
      expect(creature.homebrew, isFalse);
      expect(creature.supplemental, isFalse);
    }
  });

  test('weasels preserve senses, skills and attacks', () {
    final weasel = creatures[BestiaryBeastIds.weasel]!;
    final giant = creatures[BestiaryBeastIds.giantWeasel]!;

    expect(weasel.name, 'Faina');
    expect(weasel.hitPoints.formula, '1d4 - 1');
    expect(weasel.skillBonuses, {'stealth': 5, 'perception': 3});
    expect(weasel.actionFor('bite')!.attack!.damages.single.formula, '1');

    expect(giant.name, 'Faina Gigante');
    expect(giant.hitPoints.formula, '2d8');
    expect(giant.challengeRating, 0.125);
    expect(
      giant.senses.single.type,
      CreatureSenseType.darkvision,
    );
    expect(giant.senses.single.meters, 18);
    expect(
      giant.actionFor('bite')!.attack!.damages.single.formula,
      '1d4 + 3',
    );
  });

  test('hawks preserve flight, sight and Pack Tactics', () {
    final hawk = creatures[BestiaryBeastIds.hawk]!;
    final blood = creatures[BestiaryBeastIds.bloodHawk]!;

    expect(hawk.movementFor(CreatureMovementType.flying), 18);
    expect(hawk.passivePerception, 14);
    expect(hawk.actionFor('talons')!.attack!.damages.single.formula, '1');

    expect(blood.name, 'Falco di Sangue');
    expect(blood.size, CreatureSize.small);
    expect(blood.hitPoints.formula, '2d6');
    expect(blood.challengeRating, 0.125);
    expect(
      blood.traits.map((trait) => trait.id).toSet(),
      {'keen_sight', 'pack_tactics'},
    );
    expect(
      blood.actionFor('beak')!.attack!.damages.single.formula,
      '1d4 + 2',
    );
  });

  test('Cat preserves climbing and Keen Smell', () {
    final cat = creatures[BestiaryBeastIds.cat]!;

    expect(cat.name, 'Gatto');
    expect(cat.movementFor(CreatureMovementType.walking), 12);
    expect(cat.movementFor(CreatureMovementType.climbing), 9);
    expect(cat.skillBonuses, {'stealth': 4, 'perception': 3});
    expect(cat.traits.single.id, 'keen_smell');
    expect(cat.actionFor('claws')!.attack!.damages.single.formula, '1');
  });

  test('apes preserve melee, ranged and multiattack rules', () {
    final ape = creatures[BestiaryBeastIds.ape]!;
    final giant = creatures[BestiaryBeastIds.giantApe]!;

    expect(ape.hitPoints.formula, '3d8 + 6');
    expect(ape.skillBonuses, {'athletics': 5, 'perception': 3});
    expect(ape.multiattacks.single.referencedActionIds, {'fist'});
    expect(ape.actionFor('rock')!.attack!.normalRangeMeters, 7.5);
    expect(ape.actionFor('rock')!.attack!.longRangeMeters, 15);
    expect(
      ape.actionFor('rock')!.attack!.damages.single.formula,
      '1d6 + 3',
    );

    expect(giant.size, CreatureSize.huge);
    expect(giant.hitPoints.formula, '15d12 + 60');
    expect(giant.challengeRating, 7);
    expect(giant.experiencePoints, 2900);
    expect(giant.actionFor('fist')!.attack!.reachMeters, 3);
    expect(
      giant.actionFor('fist')!.attack!.damages.single.formula,
      '3d10 + 6',
    );
    expect(giant.actionFor('rock')!.attack!.normalRangeMeters, 15);
    expect(giant.actionFor('rock')!.attack!.longRangeMeters, 30);
    expect(
      giant.actionFor('rock')!.attack!.damages.single.formula,
      '7d6 + 6',
    );
  });

  test('crabs preserve amphibious senses and grappling', () {
    final crab = creatures[BestiaryBeastIds.crab]!;
    final giant = creatures[BestiaryBeastIds.giantCrab]!;

    for (final creature in [crab, giant]) {
      expect(creature.hasSwimmingSpeed, isTrue);
      expect(creature.senses.single.type, CreatureSenseType.blindsight);
      expect(creature.senses.single.meters, 9);
      expect(creature.traits.single.id, 'amphibious');
    }

    expect(crab.armorClass.value, 11);
    expect(crab.actionFor('claw')!.attack!.damages.single.formula, '1');

    expect(giant.armorClass.value, 15);
    expect(giant.challengeRating, 0.125);
    expect(
      giant.actionFor('claw')!.effects.single.numericValues['escapeDc'],
      11,
    );
    expect(
      giant
          .actionFor('claw')!
          .effects
          .single
          .numericValues['maximumGrappledTargets'],
      2,
    );
  });

  test('owls preserve darkvision, Flyby and communication', () {
    final owl = creatures[BestiaryBeastIds.owl]!;
    final giant = creatures[BestiaryBeastIds.giantOwl]!;

    for (final creature in [owl, giant]) {
      expect(creature.hasFlyingSpeed, isTrue);
      expect(creature.senses.single.type, CreatureSenseType.darkvision);
      expect(creature.senses.single.meters, 36);
      expect(
        creature.traits.map((trait) => trait.id).toSet(),
        {'flyby', 'keen_hearing_and_sight'},
      );
    }

    expect(owl.movementFor(CreatureMovementType.walking), 1.5);
    expect(owl.movementFor(CreatureMovementType.flying), 18);
    expect(owl.actionFor('talons')!.attack!.damages.single.formula, '1');

    expect(giant.alignment, 'neutrale');
    expect(giant.passivePerception, 15);
    expect(giant.languages, {'giant_owl'});
    expect(giant.communications, hasLength(3));
    expect(
      giant.actionFor('talons')!.attack!.damages.single.formula,
      '2d6 + 1',
    );
  });

  test('hyenas preserve Pack Tactics and Rampage', () {
    final hyena = creatures[BestiaryBeastIds.hyena]!;
    final giant = creatures[BestiaryBeastIds.giantHyena]!;

    expect(hyena.hitPoints.formula, '1d8 + 1');
    expect(hyena.traits.single.id, 'pack_tactics');
    expect(
      hyena.actionFor('bite')!.attack!.damages.single.formula,
      '1d6',
    );

    expect(giant.hitPoints.formula, '6d10 + 12');
    expect(giant.challengeRating, 1);
    expect(giant.traits.single.id, 'rampage');
    expect(
      giant.traits.single.tags,
      containsAll({
        'bonus_action',
        'move_half_speed',
        'bite_attack',
      }),
    );
    expect(
      giant.actionFor('bite')!.attack!.damages.single.formula,
      '2d6 + 3',
    );
  });

  test('Lion preserves Pounce and Running Leap', () {
    final lion = creatures[BestiaryBeastIds.lion]!;

    expect(lion.hitPoints.formula, '4d10 + 4');
    expect(lion.challengeRating, 1);
    expect(lion.skillBonuses, {'stealth': 6, 'perception': 3});
    expect(
      lion.traits.map((trait) => trait.id).toSet(),
      {'keen_smell', 'pack_tactics', 'pounce', 'running_leap'},
    );

    final claws = lion.actionFor('claws')!;
    expect(claws.attack!.damages.single.formula, '1d6 + 3');
    expect(
      claws.effects.single.numericValues['strengthSavingThrowDc'],
      13,
    );
    expect(claws.effects.single.referenceIds, {'bite'});
    expect(
      lion.actionFor('bite')!.attack!.damages.single.formula,
      '1d8 + 3',
    );
  });

  test('Lizard preserves climbing, darkvision and fixed damage', () {
    final lizard = creatures[BestiaryBeastIds.lizard]!;

    expect(lizard.name, 'Lucertola');
    expect(lizard.size, CreatureSize.tiny);
    expect(lizard.movementFor(CreatureMovementType.walking), 6);
    expect(lizard.movementFor(CreatureMovementType.climbing), 6);
    expect(lizard.senses.single.type, CreatureSenseType.darkvision);
    expect(lizard.senses.single.meters, 9);
    expect(
      lizard.actionFor('bite')!.attack!.damages.single.formula,
      '1',
    );
  });

  test('every attack retains range, average and formula', () {
    for (final creature in creatures.values) {
      for (final action in creature.actions) {
        final attack = action.attack;
        expect(attack, isNotNull, reason: '${creature.id}:${action.id}');

        for (final damage in attack!.damages) {
          expect(
            damage.average,
            isNotNull,
            reason: '${creature.id}:${action.id}',
          );
          expect(
            damage.formula,
            isNotEmpty,
            reason: '${creature.id}:${action.id}',
          );
        }

        if (attack.type == CreatureAttackType.rangedWeapon) {
          expect(attack.normalRangeMeters, isNotNull);
          expect(attack.longRangeMeters, isNotNull);
        }
      }
    }
  });

  test('all multiattacks reference existing actions', () {
    for (final creature in phbBestiaryDefinitions.values) {
      expect(
        creature.unresolvedMultiattackActionIds,
        isEmpty,
        reason: creature.id,
      );
    }
  });

  test('Wild Shape respects challenge and movement restrictions', () {
    final walkingForms = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: false,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      walkingForms,
      {
        BestiaryBeastIds.weasel,
        BestiaryBeastIds.giantWeasel,
        BestiaryBeastIds.cat,
        BestiaryBeastIds.ape,
        BestiaryBeastIds.hyena,
        BestiaryBeastIds.giantHyena,
        BestiaryBeastIds.lion,
        BestiaryBeastIds.lizard,
      },
    );

    final allMovementForms = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      allMovementForms,
      creatureIds.difference({BestiaryBeastIds.giantApe}),
    );
  });

  test('Beast Master respects challenge and size limits', () {
    final companions = eligibleBeastCompanionsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).map((creature) => creature.id).toSet();

    expect(
      companions,
      {
        BestiaryBeastIds.weasel,
        BestiaryBeastIds.giantWeasel,
        BestiaryBeastIds.hawk,
        BestiaryBeastIds.bloodHawk,
        BestiaryBeastIds.cat,
        BestiaryBeastIds.crab,
        BestiaryBeastIds.giantCrab,
        BestiaryBeastIds.owl,
        BestiaryBeastIds.hyena,
        BestiaryBeastIds.lizard,
      },
    );
  });

  test('class references remain explicitly auditable', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
