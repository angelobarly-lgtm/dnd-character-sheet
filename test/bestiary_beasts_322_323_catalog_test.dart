import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const creatureIds = {
    BestiaryBeastIds.boar,
    BestiaryBeastIds.giantBoar,
    BestiaryBeastIds.crocodile,
    BestiaryBeastIds.giantCrocodile,
    BestiaryBeastIds.raven,
    BestiaryBeastIds.deer,
    BestiaryBeastIds.elephant,
  };

  final creatures = {
    for (final id in creatureIds) id: phbBestiaryBeastDefinitions[id]!,
  };

  test('seven beasts from manual pages 322 and 323 are registered', () {
    expect(creatures.keys.toSet(), creatureIds);
    expect(phbBestiaryDefinitions.keys, containsAll(creatureIds));
    expect(
      phbBestiaryDefinitions.length,
      greaterThanOrEqualTo(20),
    );
  });

  test('all creatures retain exact manual provenance', () {
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
      {322, 323},
    );

    for (final creature in creatures.values) {
      expect(creature.origin, BestiaryContentOrigin.official);
      expect(creature.type, CreatureType.beast);
      expect(creature.homebrew, isFalse);
      expect(creature.supplemental, isFalse);
    }
  });

  test('boars preserve charge and Relentless rules', () {
    final boar = creatures[BestiaryBeastIds.boar]!;
    final giant = creatures[BestiaryBeastIds.giantBoar]!;

    expect(boar.name, 'Cinghiale');
    expect(boar.armorClass.value, 11);
    expect(boar.hitPoints.formula, '2d8 + 2');
    expect(boar.challengeRating, 0.25);
    expect(boar.experiencePoints, 50);

    expect(giant.name, 'Cinghiale Gigante');
    expect(giant.armorClass.value, 12);
    expect(giant.hitPoints.formula, '5d10 + 15');
    expect(giant.challengeRating, 2);
    expect(giant.experiencePoints, 450);

    for (final creature in [boar, giant]) {
      expect(
        creature.traits.map((trait) => trait.id).toSet(),
        containsAll({'charge', 'relentless'}),
      );
      expect(creature.actionFor('tusks'), isNotNull);
      expect(
        creature.actionFor('tusks')!.effects.single.tags,
        contains('prone_on_failure'),
      );
    }

    expect(
      boar
          .actionFor('tusks')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      11,
    );
    expect(
      giant
          .actionFor('tusks')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      13,
    );
    expect(
      boar.traits.singleWhere((trait) => trait.id == 'relentless').tags,
      contains('maximum_triggering_damage_7'),
    );
    expect(
      giant.traits.singleWhere((trait) => trait.id == 'relentless').tags,
      contains('maximum_triggering_damage_10'),
    );
  });

  test('Crocodile preserves swimming, breath and grapple rules', () {
    final crocodile = creatures[BestiaryBeastIds.crocodile]!;

    expect(crocodile.name, 'Coccodrillo');
    expect(crocodile.size, CreatureSize.large);
    expect(crocodile.hitPoints.formula, '3d10 + 3');
    expect(crocodile.movementFor(CreatureMovementType.walking), 6);
    expect(crocodile.movementFor(CreatureMovementType.swimming), 9);
    expect(crocodile.skillBonuses['stealth'], 2);
    expect(crocodile.challengeRating, 0.5);

    final bite = crocodile.actionFor('bite')!;
    expect(bite.attack!.attackBonus, 4);
    expect(bite.attack!.damages.single.formula, '1d10 + 2');
    expect(bite.effects.single.numericValues['escapeDc'], 12);
    expect(
      bite.effects.single.tags,
      containsAll({
        'grappled',
        'restrained_while_grappled',
        'cannot_bite_another_target',
      }),
    );

    expect(
      crocodile.traits.single.tags,
      contains('duration_15_minutes'),
    );
  });

  test('Giant Crocodile preserves attacks and multiattack', () {
    final crocodile = creatures[BestiaryBeastIds.giantCrocodile]!;

    expect(crocodile.name, 'Coccodrillo Gigante');
    expect(crocodile.size, CreatureSize.huge);
    expect(crocodile.armorClass.value, 14);
    expect(crocodile.hitPoints.formula, '9d12 + 27');
    expect(crocodile.movementFor(CreatureMovementType.walking), 9);
    expect(crocodile.movementFor(CreatureMovementType.swimming), 15);
    expect(crocodile.skillBonuses['stealth'], 5);
    expect(crocodile.challengeRating, 5);
    expect(crocodile.experiencePoints, 1800);

    final bite = crocodile.actionFor('bite')!;
    expect(bite.attack!.attackBonus, 8);
    expect(bite.attack!.damages.single.formula, '3d10 + 5');
    expect(bite.effects.single.numericValues['escapeDc'], 16);

    final tail = crocodile.actionFor('tail')!;
    expect(tail.attack!.reachMeters, 3);
    expect(tail.attack!.damages.single.formula, '2d8 + 5');
    expect(
      tail.effects.single.numericValues['strengthSavingThrowDc'],
      16,
    );
    expect(
      tail.effects.single.tags,
      contains('target_not_grappled_by_attacker'),
    );

    expect(
      crocodile.multiattacks.single.referencedActionIds,
      {'bite', 'tail'},
    );
    expect(crocodile.unresolvedMultiattackActionIds, isEmpty);
    expect(
      crocodile.traits.single.tags,
      contains('duration_30_minutes'),
    );
  });

  test('Raven preserves flight, Mimicry and fixed damage', () {
    final raven = creatures[BestiaryBeastIds.raven]!;

    expect(raven.name, 'Corvo');
    expect(raven.size, CreatureSize.tiny);
    expect(raven.armorClass.value, 12);
    expect(raven.hitPoints.formula, '1d4 - 1');
    expect(raven.movementFor(CreatureMovementType.walking), 3);
    expect(raven.movementFor(CreatureMovementType.flying), 15);
    expect(raven.skillBonuses['perception'], 3);
    expect(raven.passivePerception, 13);
    expect(raven.challengeRating, 0);
    expect(raven.experiencePoints, 10);

    final mimicry = raven.traits.single;
    expect(mimicry.id, 'mimicry');
    expect(mimicry.tags, contains('wisdom_insight_check_dc_10'));

    final damage = raven.actionFor('beak')!.attack!.damages.single;
    expect(damage.average, 1);
    expect(damage.formula, '1');
  });

  test('Deer preserves its complete manual statistics', () {
    final deer = creatures[BestiaryBeastIds.deer]!;

    expect(deer.name, 'Daino');
    expect(deer.size, CreatureSize.medium);
    expect(deer.armorClass.value, 13);
    expect(deer.hitPoints.formula, '1d8');
    expect(deer.abilities.dexterity, 16);
    expect(deer.abilities.wisdom, 14);
    expect(deer.movementFor(CreatureMovementType.walking), 15);
    expect(deer.passivePerception, 12);
    expect(deer.challengeRating, 0);
    expect(deer.experiencePoints, 10);
    expect(
      deer.actionFor('bite')!.attack!.damages.single.formula,
      '1d4',
    );
  });

  test('Elephant preserves charge and conditional stomp', () {
    final elephant = creatures[BestiaryBeastIds.elephant]!;

    expect(elephant.name, 'Elefante');
    expect(elephant.size, CreatureSize.huge);
    expect(elephant.armorClass.value, 12);
    expect(elephant.hitPoints.formula, '8d12 + 24');
    expect(elephant.abilities.strength, 22);
    expect(elephant.movementFor(CreatureMovementType.walking), 12);
    expect(elephant.challengeRating, 4);
    expect(elephant.experiencePoints, 1100);

    final gore = elephant.actionFor('gore')!;
    expect(gore.attack!.attackBonus, 8);
    expect(gore.attack!.damages.single.formula, '3d8 + 6');
    expect(
      gore.effects.single.numericValues['strengthSavingThrowDc'],
      12,
    );
    expect(gore.effects.single.referenceIds, {'stomp'});

    final stomp = elephant.actionFor('stomp')!;
    expect(stomp.attack!.damages.single.formula, '3d10 + 6');
    expect(
      stomp.effects.single.tags,
      contains('requires_prone_target'),
    );
  });

  test('all damaging actions retain exact average and formula', () {
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
      }
    }
  });

  test('Wild Shape respects challenge and movement restrictions', () {
    final walkingOnly = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: false,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      walkingOnly,
      {
        BestiaryBeastIds.boar,
        BestiaryBeastIds.deer,
      },
    );

    final swimmingUnlocked = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      swimmingUnlocked,
      {
        BestiaryBeastIds.boar,
        BestiaryBeastIds.crocodile,
        BestiaryBeastIds.deer,
      },
    );

    final allMovementUnlocked = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      allMovementUnlocked,
      {
        BestiaryBeastIds.boar,
        BestiaryBeastIds.crocodile,
        BestiaryBeastIds.raven,
        BestiaryBeastIds.deer,
      },
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
        BestiaryBeastIds.boar,
        BestiaryBeastIds.raven,
        BestiaryBeastIds.deer,
      },
    );
  });

  test('all references remain structurally valid', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
