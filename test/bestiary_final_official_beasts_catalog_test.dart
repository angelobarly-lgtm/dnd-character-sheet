import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final creatures = phbBestiaryBeastDefinitions;

  const finalIds = {
    BestiaryBeastIds.swarmOfQuippers,
    BestiaryBeastIds.swarmOfPoisonousSnakes,
    BestiaryBeastIds.swarmOfRats,
    BestiaryBeastIds.scorpion,
    BestiaryBeastIds.giantScorpion,
    BestiaryBeastIds.constrictorSnake,
    BestiaryBeastIds.giantConstrictorSnake,
    BestiaryBeastIds.poisonousSnake,
    BestiaryBeastIds.giantPoisonousSnake,
    BestiaryBeastIds.flyingSnake,
    BestiaryBeastIds.hunterShark,
    BestiaryBeastIds.giantShark,
    BestiaryBeastIds.reefShark,
    BestiaryBeastIds.badger,
    BestiaryBeastIds.giantBadger,
    BestiaryBeastIds.tiger,
    BestiaryBeastIds.saberToothedTiger,
    BestiaryBeastIds.rat,
    BestiaryBeastIds.giantRat,
    BestiaryBeastIds.giantWasp,
    BestiaryBeastIds.elk,
    BestiaryBeastIds.giantElk,
    BestiaryBeastIds.eagle,
    BestiaryBeastIds.allosaurus,
    BestiaryBeastIds.ankylosaurus,
    BestiaryBeastIds.plesiosaurus,
    BestiaryBeastIds.pteranodon,
    BestiaryBeastIds.triceratops,
    BestiaryBeastIds.tyrannosaurusRex,
  };

  test('the final manual block contains exactly twenty-nine beasts', () {
    expect(phbBestiaryFinalBeastDefinitions, hasLength(29));
    expect(
      phbBestiaryFinalBeastDefinitions.map((creature) => creature.id).toSet(),
      finalIds,
    );
  });

  test('the 2014 Monster Manual beast catalog contains ninety-four entries',
      () {
    expect(creatures, hasLength(94));
    expect(creatures.keys.toSet(), containsAll(finalIds));
    expect(
        creatures.values.map((creature) => creature.id).toSet(), hasLength(94));
  });

  test(
      'all final creatures retain official source and complete core statistics',
      () {
    for (final id in finalIds) {
      final creature = creatures[id]!;
      expect(creature.source.book, 'Manuale dei Mostri', reason: id);
      expect(creature.source.edition, '2014', reason: id);
      expect(creature.hitPoints.average, greaterThan(0), reason: id);
      expect(creature.hitPoints.diceCount, greaterThan(0), reason: id);
      expect(creature.movements, isNotEmpty, reason: id);
      expect(creature.actions, isNotEmpty, reason: id);
      expect(creature.experiencePoints, greaterThan(0), reason: id);
      expect(creature.proficiencyBonus, 2, reason: id);
    }
  });

  test('the three final swarms preserve swarm defenses', () {
    for (final id in {
      BestiaryBeastIds.swarmOfQuippers,
      BestiaryBeastIds.swarmOfPoisonousSnakes,
      BestiaryBeastIds.swarmOfRats,
    }) {
      final swarm = creatures[id]!;
      expect(swarm.isSwarm, isTrue, reason: id);
      expect(
        swarm.damageResistances,
        containsAll({'contundente', 'perforante', 'tagliente'}),
        reason: id,
      );
      expect(swarm.conditionImmunities, hasLength(8), reason: id);
    }
  });

  test('poisonous creatures preserve their multiple damage components', () {
    for (final id in {
      BestiaryBeastIds.scorpion,
      BestiaryBeastIds.giantScorpion,
      BestiaryBeastIds.poisonousSnake,
      BestiaryBeastIds.giantPoisonousSnake,
      BestiaryBeastIds.flyingSnake,
      BestiaryBeastIds.giantWasp,
      BestiaryBeastIds.swarmOfPoisonousSnakes,
    }) {
      final attack = creatures[id]!.actions.last.attack!;
      expect(
        attack.damages.map((damage) => damage.damageType),
        contains('veleno'),
        reason: id,
      );
    }
  });

  test('giant rat and ankylosaurus preserve their official variants', () {
    final rat = creatures[BestiaryBeastIds.giantRat]!;
    final ankylosaurus = creatures[BestiaryBeastIds.ankylosaurus]!;

    expect(
      rat.variants.map((variant) => variant.id),
      contains('diseased_giant_rat'),
    );
    expect(
      ankylosaurus.variants.map((variant) => variant.id),
      contains('spiked_tail'),
    );
  });

  test('all dinosaur stat blocks match their challenge ratings', () {
    expect(creatures[BestiaryBeastIds.allosaurus]!.challengeRating, 2);
    expect(creatures[BestiaryBeastIds.ankylosaurus]!.challengeRating, 3);
    expect(creatures[BestiaryBeastIds.plesiosaurus]!.challengeRating, 2);
    expect(creatures[BestiaryBeastIds.pteranodon]!.challengeRating, 0.25);
    expect(creatures[BestiaryBeastIds.triceratops]!.challengeRating, 5);
    expect(creatures[BestiaryBeastIds.tyrannosaurusRex]!.challengeRating, 8);
  });

  test('special dinosaur movement and combat rules remain structured', () {
    final plesiosaurus = creatures[BestiaryBeastIds.plesiosaurus]!;
    final pteranodon = creatures[BestiaryBeastIds.pteranodon]!;
    final tyrannosaurus = creatures[BestiaryBeastIds.tyrannosaurusRex]!;

    expect(
      plesiosaurus.movementFor(CreatureMovementType.swimming),
      12,
    );
    expect(
      pteranodon.movementFor(CreatureMovementType.flying),
      18,
    );
    expect(
      tyrannosaurus.multiattacks.single.referencedActionIds,
      {'bite', 'tail'},
    );
    expect(
      tyrannosaurus.actions
          .singleWhere((action) => action.id == 'bite')
          .effects
          .single
          .numericValues['escapeDc'],
      17,
    );
  });

  test('every final multiattack references existing actions', () {
    for (final creature in phbBestiaryFinalBeastDefinitions) {
      expect(
        creature.unresolvedMultiattackActionIds,
        isEmpty,
        reason: creature.id,
      );
    }
  });

  test('Wild Shape accepts individual beasts and excludes swarms', () {
    const finalSwarmIds = {
      BestiaryBeastIds.swarmOfQuippers,
      BestiaryBeastIds.swarmOfPoisonousSnakes,
      BestiaryBeastIds.swarmOfRats,
    };
    final individualFinalIds = finalIds.difference(finalSwarmIds);

    final wildShapeIds = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 8,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(wildShapeIds, containsAll(individualFinalIds));
    expect(wildShapeIds.intersection(finalSwarmIds), isEmpty);

    final companionIds = eligibleBeastCompanionsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).map((creature) => creature.id).toSet();

    expect(
      companionIds,
      containsAll({
        BestiaryBeastIds.poisonousSnake,
        BestiaryBeastIds.giantPoisonousSnake,
        BestiaryBeastIds.flyingSnake,
        BestiaryBeastIds.badger,
        BestiaryBeastIds.giantBadger,
        BestiaryBeastIds.rat,
        BestiaryBeastIds.giantRat,
        BestiaryBeastIds.eagle,
        BestiaryBeastIds.pteranodon,
      }),
    );
  });
}
