import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const creatureIds = {
    BestiaryBeastIds.goat,
    BestiaryBeastIds.giantGoat,
    BestiaryBeastIds.ridingHorse,
    BestiaryBeastIds.warhorse,
    BestiaryBeastIds.draftHorse,
    BestiaryBeastIds.seahorse,
    BestiaryBeastIds.giantSeahorse,
  };

  final creatures = {
    for (final id in creatureIds) id: phbBestiaryBeastDefinitions[id]!,
  };

  test('seven beasts from manual pages 320 and 321 are registered', () {
    expect(creatures.keys.toSet(), creatureIds);
    expect(
      phbBestiaryDefinitions.keys,
      containsAll(creatureIds),
    );
    expect(
      phbBestiaryDefinitions.length,
      greaterThanOrEqualTo(13),
    );
  });

  test('all seven creatures retain exact manual provenance', () {
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
      {320, 321},
    );

    for (final creature in creatures.values) {
      expect(creature.origin, BestiaryContentOrigin.official);
      expect(creature.type, CreatureType.beast);
      expect(creature.homebrew, isFalse);
      expect(creature.supplemental, isFalse);
    }
  });

  test('goats preserve Sure-Footed and charge rules', () {
    final goat = creatures[BestiaryBeastIds.goat]!;
    final giantGoat = creatures[BestiaryBeastIds.giantGoat]!;

    expect(goat.name, 'Capra');
    expect(goat.challengeRating, 0);
    expect(goat.experiencePoints, 10);
    expect(goat.hitPoints.formula, '1d8');
    expect(goat.movementFor(CreatureMovementType.walking), 12);

    expect(giantGoat.name, 'Capra Gigante');
    expect(giantGoat.challengeRating, 0.5);
    expect(giantGoat.experiencePoints, 100);
    expect(giantGoat.hitPoints.formula, '3d10 + 3');
    expect(giantGoat.armorClass.description, 'armatura naturale');

    for (final creature in [goat, giantGoat]) {
      final traitIds = creature.traits.map((trait) => trait.id).toSet();
      expect(traitIds, containsAll({'charge', 'sure_footed'}));

      final headbutt = creature.actionFor('headbutt')!;
      expect(headbutt.attack, isNotNull);
      expect(headbutt.effects.single.tags, contains('prone_on_failure'));
    }

    expect(
      goat
          .actionFor('headbutt')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      10,
    );
    expect(
      giantGoat
          .actionFor('headbutt')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      13,
    );
  });

  test('all three horses preserve exact combat statistics', () {
    final riding = creatures[BestiaryBeastIds.ridingHorse]!;
    final warhorse = creatures[BestiaryBeastIds.warhorse]!;
    final draft = creatures[BestiaryBeastIds.draftHorse]!;

    expect(riding.name, 'Cavallo da Galoppo');
    expect(riding.hitPoints.formula, '2d10 + 2');
    expect(riding.movementFor(CreatureMovementType.walking), 18);
    expect(riding.challengeRating, 0.25);
    expect(riding.actionFor('hooves')!.attack!.attackBonus, 5);
    expect(
      riding.actionFor('hooves')!.attack!.damages.single.formula,
      '2d4 + 3',
    );

    expect(warhorse.name, 'Cavallo da Guerra');
    expect(warhorse.hitPoints.formula, '3d10 + 3');
    expect(warhorse.movementFor(CreatureMovementType.walking), 18);
    expect(warhorse.challengeRating, 0.5);
    expect(warhorse.actionFor('hooves')!.attack!.attackBonus, 6);
    expect(
      warhorse.actionFor('hooves')!.attack!.damages.single.formula,
      '2d6 + 4',
    );

    final trampling = warhorse.actionFor('hooves')!.effects.single;
    expect(trampling.referenceIds, {'hooves'});
    expect(trampling.numericValues['strengthSavingThrowDc'], 14);
    expect(trampling.numericValues['bonusHoovesAttacksOnFailedSave'], 1);

    expect(draft.name, 'Cavallo da Tiro');
    expect(draft.hitPoints.formula, '3d10 + 3');
    expect(draft.movementFor(CreatureMovementType.walking), 12);
    expect(draft.challengeRating, 0.25);
    expect(draft.actionFor('hooves')!.attack!.attackBonus, 6);
    expect(
      draft.actionFor('hooves')!.attack!.damages.single.formula,
      '2d4 + 4',
    );
  });

  test('Warhorse barding preserves every armor class', () {
    final warhorse = creatures[BestiaryBeastIds.warhorse]!;

    expect(
      warhorse.armorClasses.map((armor) => armor.value).toSet(),
      {11, 12, 13, 14, 15, 16, 17, 18},
    );
    expect(warhorse.variants, hasLength(1));
    expect(warhorse.variants.single.id, 'warhorse_barding');
    expect(
      warhorse.variants.single.addedTags,
      {'barding'},
    );
  });

  test('seahorses preserve aquatic movement and breathing', () {
    final seahorse = creatures[BestiaryBeastIds.seahorse]!;
    final giant = creatures[BestiaryBeastIds.giantSeahorse]!;

    expect(seahorse.name, 'Cavalluccio Marino');
    expect(seahorse.size, CreatureSize.tiny);
    expect(seahorse.hitPoints.formula, '1d4 - 1');
    expect(seahorse.movementFor(CreatureMovementType.walking), 0);
    expect(seahorse.movementFor(CreatureMovementType.swimming), 6);
    expect(seahorse.actions, isEmpty);
    expect(
      seahorse.traits.single.tags,
      containsAll({'water_breathing', 'underwater_only'}),
    );

    expect(giant.name, 'Cavalluccio Marino Gigante');
    expect(giant.size, CreatureSize.large);
    expect(giant.hitPoints.formula, '3d10');
    expect(giant.movementFor(CreatureMovementType.walking), 0);
    expect(giant.movementFor(CreatureMovementType.swimming), 12);
    expect(giant.challengeRating, 0.5);
    expect(
      giant
          .actionFor('headbutt')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      11,
    );
    expect(
      giant
          .actionFor('headbutt')!
          .effects
          .single
          .numericValues['extraAverageDamage'],
      7,
    );
  });

  test('all damaging actions retain their average and dice formula', () {
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

  test('Wild Shape filters swimming forms until movement is unlocked', () {
    final withoutSwimming = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      allowsSwimmingSpeed: false,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      withoutSwimming,
      {
        BestiaryBeastIds.goat,
        BestiaryBeastIds.ridingHorse,
        BestiaryBeastIds.draftHorse,
      },
    );

    final withSwimming = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).map((creature) => creature.id).toSet();

    expect(
      withSwimming,
      {
        BestiaryBeastIds.goat,
        BestiaryBeastIds.ridingHorse,
        BestiaryBeastIds.draftHorse,
        BestiaryBeastIds.seahorse,
      },
    );
  });

  test('Beast Master applies challenge and size restrictions', () {
    final companions = eligibleBeastCompanionsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).map((creature) => creature.id).toSet();

    expect(
      companions,
      {
        BestiaryBeastIds.goat,
        BestiaryBeastIds.seahorse,
      },
    );
  });

  test('all class and multiattack references remain auditable', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
