import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const elementalIds = {
    BestiaryCreatureIds.airElemental,
    BestiaryCreatureIds.earthElemental,
    BestiaryCreatureIds.fireElemental,
    BestiaryCreatureIds.waterElemental,
  };

  const modronIds = {
    BestiaryCreatureIds.monodrone,
    BestiaryCreatureIds.duodrone,
    BestiaryCreatureIds.tridrone,
    BestiaryCreatureIds.quadrone,
    BestiaryCreatureIds.pentadrone,
  };

  test('four PHB-required elementals and five modrons are registered', () {
    const expectedIds = {
      BestiaryCreatureIds.airElemental,
      BestiaryCreatureIds.earthElemental,
      BestiaryCreatureIds.fireElemental,
      BestiaryCreatureIds.waterElemental,
      BestiaryCreatureIds.monodrone,
      BestiaryCreatureIds.duodrone,
      BestiaryCreatureIds.tridrone,
      BestiaryCreatureIds.quadrone,
      BestiaryCreatureIds.pentadrone,
    };

    expect(
      phbBestiaryClassReferenceDefinitions.keys,
      containsAll(expectedIds),
    );

    for (final id in expectedIds) {
      expect(
        phbBestiaryClassReferenceDefinitions[id],
        isNotNull,
        reason: id,
      );
    }
  });

  test('elementals preserve their exact challenge and movement statistics', () {
    for (final id in elementalIds) {
      final elemental = phbBestiaryDefinitions[id]!;
      expect(elemental.type, CreatureType.elemental);
      expect(elemental.challengeRating, 5, reason: id);
      expect(elemental.experiencePoints, 1800, reason: id);
      expect(elemental.source.pageStart, 124, reason: id);
      expect(elemental.source.pageEnd, 125, reason: id);
      expect(elemental.unresolvedMultiattackActionIds, isEmpty, reason: id);
    }

    expect(
      phbBestiaryDefinitions[BestiaryCreatureIds.airElemental]!
          .movementFor(CreatureMovementType.flying),
      27,
    );
    expect(
      phbBestiaryDefinitions[BestiaryCreatureIds.earthElemental]!
          .movementFor(CreatureMovementType.burrowing),
      9,
    );
    expect(
      phbBestiaryDefinitions[BestiaryCreatureIds.waterElemental]!
          .movementFor(CreatureMovementType.swimming),
      27,
    );
  });

  test('elemental special actions preserve saves, recharge and effects', () {
    final whirlwind = phbBestiaryDefinitions[BestiaryCreatureIds.airElemental]!
        .actionFor('whirlwind')!;
    final whelm = phbBestiaryDefinitions[BestiaryCreatureIds.waterElemental]!
        .actionFor('whelm')!;

    expect(whirlwind.recharge, '4-6');
    expect(whirlwind.savingThrow?.difficultyClass, 13);
    expect(whirlwind.effects.single.numericValues['distanceMeters'], 6);

    expect(whelm.recharge, '4-6');
    expect(whelm.savingThrow?.difficultyClass, 15);
    expect(whelm.effects.single.numericValues['escapeDc'], 14);
  });

  test('generic Modron is a group and never a fabricated stat block', () {
    final group =
        phbBestiaryCreatureGroupDefinitions[BestiaryCreatureIds.modron]!;

    expect(group.creatureIds, modronIds);
    expect(phbBestiaryDefinitions.containsKey(BestiaryCreatureIds.modron),
        isFalse);
    expect(group.creatureIds.every(phbBestiaryDefinitions.containsKey), isTrue);
  });

  test('all five modron ranks match the 2014 manual', () {
    final expected = {
      BestiaryCreatureIds.monodrone: (0.125, 5, 15),
      BestiaryCreatureIds.duodrone: (0.25, 11, 15),
      BestiaryCreatureIds.tridrone: (0.5, 16, 15),
      BestiaryCreatureIds.quadrone: (1.0, 22, 16),
      BestiaryCreatureIds.pentadrone: (2.0, 32, 16),
    };

    for (final entry in expected.entries) {
      final creature = phbBestiaryDefinitions[entry.key]!;
      expect(creature.type, CreatureType.construct, reason: entry.key);
      expect(creature.challengeRating, entry.value.$1, reason: entry.key);
      expect(creature.hitPoints.average, entry.value.$2, reason: entry.key);
      expect(creature.armorClass.value, entry.value.$3, reason: entry.key);
      expect(creature.senses.single.type, CreatureSenseType.truesight);
      expect(creature.senses.single.meters, 36);
      expect(creature.variants.single.id, 'rogue_modron');
      expect(creature.unresolvedMultiattackActionIds, isEmpty);
    }
  });

  test('Pentadrone exposes five attacks and Paralysis Gas', () {
    final pentadrone = phbBestiaryDefinitions[BestiaryCreatureIds.pentadrone]!;

    expect(
      pentadrone.multiattacks.single.referencedActionIds,
      {'arm'},
    );
    expect(
      pentadrone.multiattacks.single.options.single.actionUses['arm'],
      5,
    );

    final gas = pentadrone.actionFor('paralysis_gas')!;
    expect(gas.recharge, '5-6');
    expect(gas.savingThrow?.ability, 'COS');
    expect(gas.savingThrow?.difficultyClass, 11);
    expect(gas.effects.single.condition, 'paralizzato');
  });

  test('all class references are resolved after the final creature block', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
