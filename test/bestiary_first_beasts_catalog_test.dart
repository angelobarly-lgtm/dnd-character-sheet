import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const firstCreatureIds = {
    BestiaryBeastIds.giantEagle,
    BestiaryBeastIds.vulture,
    BestiaryBeastIds.giantVulture,
    BestiaryBeastIds.baboon,
    BestiaryBeastIds.axeBeak,
    BestiaryBeastIds.camel,
  };

  final creatures = {
    for (final id in firstCreatureIds) id: phbBestiaryBeastDefinitions[id]!,
  };

  test('first six official beasts are registered', () {
    expect(creatures.keys.toSet(), firstCreatureIds);
    expect(
      phbBestiaryDefinitions.keys,
      containsAll(firstCreatureIds),
    );
    expect(
      phbBestiaryDefinitions.keys,
      containsAll(creatures.keys),
    );
  });

  test('all first beasts retain exact manual provenance', () {
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
      {318, 319},
    );

    for (final creature in creatures.values) {
      expect(creature.origin, BestiaryContentOrigin.official);
      expect(creature.type, CreatureType.beast);
      expect(creature.homebrew, isFalse);
      expect(creature.supplemental, isFalse);
      expect(creature.isSwarm, isFalse);
    }
  });

  test('Giant Eagle has complete movement and combat statistics', () {
    final eagle = creatures[BestiaryBeastIds.giantEagle]!;

    expect(eagle.name, 'Aquila Gigante');
    expect(eagle.size, CreatureSize.large);
    expect(eagle.alignment, 'neutrale buono');
    expect(eagle.armorClass.value, 13);
    expect(eagle.hitPoints.average, 26);
    expect(eagle.hitPoints.formula, '4d10 + 4');
    expect(eagle.abilities.strength, 16);
    expect(eagle.abilities.dexterity, 17);
    expect(eagle.skillBonuses['perception'], 4);
    expect(eagle.passivePerception, 14);
    expect(
      eagle.movementFor(CreatureMovementType.walking),
      3,
    );
    expect(
      eagle.movementFor(CreatureMovementType.flying),
      24,
    );
    expect(eagle.challengeRating, 1);
    expect(eagle.experiencePoints, 200);
  });

  test('multiattacks reference existing actions', () {
    for (final creature in creatures.values) {
      expect(
        creature.unresolvedMultiattackActionIds,
        isEmpty,
        reason: creature.id,
      );
    }

    final eagle = creatures[BestiaryBeastIds.giantEagle]!;
    final vulture = creatures[BestiaryBeastIds.giantVulture]!;

    expect(
      eagle.multiattacks.single.referencedActionIds,
      {'beak', 'talons'},
    );
    expect(
      vulture.multiattacks.single.referencedActionIds,
      {'beak', 'talons'},
    );
  });

  test('all damaging actions preserve average and dice formula', () {
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
          expect(damage.formula, isNotEmpty);
        }
      }
    }
  });

  test('Wild Shape applies challenge and movement restrictions', () {
    final levelTwoForms = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      allowsSwimmingSpeed: false,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      levelTwoForms,
      {
        BestiaryBeastIds.baboon,
        BestiaryBeastIds.axeBeak,
        BestiaryBeastIds.camel,
      },
    );

    final unrestrictedMovementForms = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      unrestrictedMovementForms,
      creatures.keys.toSet(),
    );
  });

  test('Beast Master filtering applies size and challenge limits', () {
    final companions = eligibleBeastCompanionsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).map((creature) => creature.id).toSet();

    expect(
      companions,
      {
        BestiaryBeastIds.vulture,
        BestiaryBeastIds.baboon,
      },
    );
  });

  test('class-specific unresolved references remain explicit', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
