import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const creatureIds = {
    BestiaryBeastIds.giantLizard,
    BestiaryBeastIds.wolf,
    BestiaryBeastIds.direWolf,
    BestiaryBeastIds.mammoth,
    BestiaryBeastIds.mastiff,
    BestiaryBeastIds.giantCentipede,
    BestiaryBeastIds.mule,
    BestiaryBeastIds.killerWhale,
    BestiaryBeastIds.brownBear,
    BestiaryBeastIds.blackBear,
    BestiaryBeastIds.polarBear,
    BestiaryBeastIds.panther,
    BestiaryBeastIds.octopus,
    BestiaryBeastIds.giantOctopus,
    BestiaryBeastIds.bat,
    BestiaryBeastIds.giantBat,
    BestiaryBeastIds.pony,
    BestiaryBeastIds.quipper,
    BestiaryBeastIds.spider,
    BestiaryBeastIds.giantSpider,
    BestiaryBeastIds.giantWolfSpider,
    BestiaryBeastIds.frog,
    BestiaryBeastIds.giantFrog,
    BestiaryBeastIds.rhinoceros,
    BestiaryBeastIds.giantToad,
    BestiaryBeastIds.giantFireBeetle,
    BestiaryBeastIds.jackal,
    BestiaryBeastIds.swarmOfRavens,
    BestiaryBeastIds.swarmOfInsects,
    BestiaryBeastIds.swarmOfBats,
  };

  final creatures = {
    for (final id in creatureIds) id: phbBestiaryBeastDefinitions[id]!,
  };

  final expected = <String, List<Object>>{
    BestiaryBeastIds.giantLizard: [
      'Lucertola Gigante',
      327,
      CreatureSize.large,
      12,
      '3d10 + 3',
      0.25,
      50
    ],
    BestiaryBeastIds.wolf: [
      'Lupo',
      327,
      CreatureSize.medium,
      13,
      '2d8 + 2',
      0.25,
      50
    ],
    BestiaryBeastIds.direWolf: [
      'Lupo Feroce',
      327,
      CreatureSize.large,
      14,
      '5d10 + 10',
      1.0,
      200
    ],
    BestiaryBeastIds.mammoth: [
      'Mammut',
      328,
      CreatureSize.huge,
      13,
      '11d12 + 55',
      6.0,
      2300
    ],
    BestiaryBeastIds.mastiff: [
      'Mastino',
      328,
      CreatureSize.medium,
      12,
      '1d8 + 1',
      0.125,
      25
    ],
    BestiaryBeastIds.giantCentipede: [
      'Millepiedi Gigante',
      329,
      CreatureSize.small,
      13,
      '1d6 + 1',
      0.25,
      50
    ],
    BestiaryBeastIds.mule: [
      'Mulo',
      329,
      CreatureSize.medium,
      10,
      '2d8 + 2',
      0.125,
      25
    ],
    BestiaryBeastIds.killerWhale: [
      'Orca Assassina',
      329,
      CreatureSize.huge,
      12,
      '12d12 + 12',
      3.0,
      700
    ],
    BestiaryBeastIds.brownBear: [
      'Orso Bruno',
      329,
      CreatureSize.large,
      11,
      '4d10 + 12',
      1.0,
      200
    ],
    BestiaryBeastIds.blackBear: [
      'Orso Nero',
      330,
      CreatureSize.medium,
      11,
      '3d8 + 6',
      0.5,
      100
    ],
    BestiaryBeastIds.polarBear: [
      'Orso Polare',
      330,
      CreatureSize.large,
      12,
      '5d10 + 15',
      2.0,
      450
    ],
    BestiaryBeastIds.panther: [
      'Pantera',
      330,
      CreatureSize.medium,
      12,
      '3d8',
      0.25,
      50
    ],
    BestiaryBeastIds.octopus: [
      'Piovra',
      330,
      CreatureSize.small,
      12,
      '1d6',
      0.0,
      10
    ],
    BestiaryBeastIds.giantOctopus: [
      'Piovra Gigante',
      331,
      CreatureSize.large,
      11,
      '8d10 + 8',
      1.0,
      200
    ],
    BestiaryBeastIds.bat: [
      'Pipistrello',
      331,
      CreatureSize.tiny,
      12,
      '1d4 - 1',
      0.0,
      10
    ],
    BestiaryBeastIds.giantBat: [
      'Pipistrello Gigante',
      331,
      CreatureSize.large,
      13,
      '4d10',
      0.25,
      50
    ],
    BestiaryBeastIds.pony: [
      'Pony',
      331,
      CreatureSize.medium,
      10,
      '2d8 + 2',
      0.125,
      25
    ],
    BestiaryBeastIds.quipper: [
      'Quipper',
      332,
      CreatureSize.tiny,
      13,
      '1d4 - 1',
      0.0,
      10
    ],
    BestiaryBeastIds.spider: [
      'Ragno',
      332,
      CreatureSize.tiny,
      12,
      '1d4 - 1',
      0.0,
      10
    ],
    BestiaryBeastIds.giantSpider: [
      'Ragno Gigante',
      332,
      CreatureSize.large,
      14,
      '4d10 + 4',
      1.0,
      200
    ],
    BestiaryBeastIds.giantWolfSpider: [
      'Ragno Lupo Gigante',
      333,
      CreatureSize.medium,
      13,
      '2d8 + 2',
      0.25,
      50
    ],
    BestiaryBeastIds.frog: [
      'Rana',
      334,
      CreatureSize.tiny,
      11,
      '1d4 - 1',
      0.0,
      0
    ],
    BestiaryBeastIds.giantFrog: [
      'Rana Gigante',
      334,
      CreatureSize.medium,
      11,
      '4d8',
      0.25,
      50
    ],
    BestiaryBeastIds.rhinoceros: [
      'Rinoceronte',
      334,
      CreatureSize.large,
      11,
      '6d10 + 12',
      2.0,
      450
    ],
    BestiaryBeastIds.giantToad: [
      'Rospo Gigante',
      334,
      CreatureSize.large,
      11,
      '6d10 + 6',
      1.0,
      200
    ],
    BestiaryBeastIds.giantFireBeetle: [
      'Scarabeo di Fuoco Gigante',
      335,
      CreatureSize.small,
      13,
      '1d6 + 1',
      0.0,
      10
    ],
    BestiaryBeastIds.jackal: [
      'Sciacallo',
      335,
      CreatureSize.small,
      12,
      '1d6',
      0.0,
      10
    ],
    BestiaryBeastIds.swarmOfRavens: [
      'Sciame di Corvi',
      335,
      CreatureSize.medium,
      12,
      '7d8 - 7',
      0.25,
      50
    ],
    BestiaryBeastIds.swarmOfInsects: [
      'Sciame di Insetti',
      335,
      CreatureSize.medium,
      12,
      '5d8',
      0.5,
      100
    ],
    BestiaryBeastIds.swarmOfBats: [
      'Sciame di Pipistrelli',
      336,
      CreatureSize.medium,
      12,
      '5d8',
      0.25,
      50
    ],
  };

  test('thirty official creatures are registered', () {
    expect(creatures.keys.toSet(), creatureIds);
    expect(phbBestiaryDefinitions.keys, containsAll(creatureIds));
    expect(phbBestiaryDefinitions.length, greaterThanOrEqualTo(65));
  });

  test('all thirty identities and statistics match the manual', () {
    for (final entry in expected.entries) {
      final creature = creatures[entry.key]!;
      final row = entry.value;

      expect(creature.name, row[0], reason: entry.key);
      expect(creature.source.pageStart, row[1], reason: entry.key);
      expect(creature.size, row[2], reason: entry.key);
      expect(creature.armorClass.value, row[3], reason: entry.key);
      expect(creature.hitPoints.formula, row[4], reason: entry.key);
      expect(creature.challengeRating, row[5], reason: entry.key);
      expect(creature.experiencePoints, row[6], reason: entry.key);
      expect(creature.source.book, 'Manuale dei Mostri');
      expect(creature.source.edition, '2014');
      expect(creature.type, CreatureType.beast);
      expect(creature.origin, BestiaryContentOrigin.official);
    }
  });

  test('wolves and Mastiff preserve prone saves', () {
    expect(
      creatures[BestiaryBeastIds.wolf]!
          .actionFor('bite')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      11,
    );
    expect(
      creatures[BestiaryBeastIds.direWolf]!
          .actionFor('bite')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      13,
    );
    expect(
      creatures[BestiaryBeastIds.mastiff]!
          .actionFor('bite')!
          .effects
          .single
          .numericValues['strengthSavingThrowDc'],
      11,
    );
  });

  test('poison attacks preserve saves and secondary damage', () {
    final centipede =
        creatures[BestiaryBeastIds.giantCentipede]!.actionFor('bite')!;
    expect(centipede.attack!.damages, hasLength(2));
    expect(centipede.attack!.damages[1].formula, '3d6');
    expect(
      centipede.effects.single.numericValues['constitutionSavingThrowDc'],
      11,
    );

    final spider = creatures[BestiaryBeastIds.spider]!.actionFor('bite')!;
    expect(spider.attack!.damages[1].formula, '1d4');
    expect(
      spider.effects.single.numericValues['constitutionSavingThrowDc'],
      9,
    );

    final giantSpider =
        creatures[BestiaryBeastIds.giantSpider]!.actionFor('bite')!;
    expect(giantSpider.attack!.damages[1].formula, '2d8');
    expect(
      giantSpider.effects.single.tags,
      contains('half_damage_on_success'),
    );

    final wolfSpider =
        creatures[BestiaryBeastIds.giantWolfSpider]!.actionFor('bite')!;
    expect(wolfSpider.attack!.damages[1].formula, '2d6');
  });

  test('multiattacks reference valid attacks', () {
    for (final id in {
      BestiaryBeastIds.brownBear,
      BestiaryBeastIds.blackBear,
      BestiaryBeastIds.polarBear,
    }) {
      expect(
        creatures[id]!.multiattacks.single.referencedActionIds,
        {'bite', 'claws'},
      );
    }

    for (final creature in phbBestiaryDefinitions.values) {
      expect(
        creature.unresolvedMultiattackActionIds,
        isEmpty,
        reason: creature.id,
      );
    }
  });

  test('octopuses preserve grapples and ink clouds', () {
    final octopus = creatures[BestiaryBeastIds.octopus]!;
    final giant = creatures[BestiaryBeastIds.giantOctopus]!;

    expect(
      octopus.actionFor('tentacles')!.effects.single.numericValues['escapeDc'],
      10,
    );
    expect(
      octopus
          .actionFor('ink_cloud')!
          .effects
          .single
          .numericValues['radiusMeters'],
      1.5,
    );

    expect(
      giant.actionFor('tentacles')!.effects.single.numericValues['escapeDc'],
      16,
    );
    expect(giant.actionFor('tentacles')!.attack!.reachMeters, 4.5);
    expect(
      giant
          .actionFor('ink_cloud')!
          .effects
          .single
          .numericValues['radiusMeters'],
      6,
    );
  });

  test('spider web is non-damaging but structurally complete', () {
    final web = creatures[BestiaryBeastIds.giantSpider]!.actionFor('web')!;

    expect(web.recharge, '5-6');
    expect(web.attack!.type, CreatureAttackType.rangedWeapon);
    expect(web.attack!.normalRangeMeters, 9);
    expect(web.attack!.longRangeMeters, 18);
    expect(web.attack!.hasDamage, isFalse);
    expect(
      web.effects.single.numericValues,
      containsPair('escapeStrengthCheckDc', 12),
    );
  });

  test('frog and toad swallowing rules are structured', () {
    final frog = creatures[BestiaryBeastIds.giantFrog]!.actionFor('swallow')!;
    final toad = creatures[BestiaryBeastIds.giantToad]!.actionFor('swallow')!;

    expect(
      frog.effects.single.numericValues['acidAverageDamagePerTurn'],
      5,
    );
    expect(
      frog.effects.single.numericValues['acidDamageDiceCount'],
      2,
    );
    expect(
      toad.effects.single.numericValues['acidAverageDamagePerTurn'],
      10,
    );
    expect(
      toad.effects.single.numericValues['acidDamageDiceCount'],
      3,
    );

    final toadBite = creatures[BestiaryBeastIds.giantToad]!.actionFor('bite')!;
    expect(toadBite.attack!.damages, hasLength(2));
    expect(toadBite.attack!.damages[1].damageType, 'veleno');
  });

  test('all three swarms preserve swarm defenses', () {
    for (final id in {
      BestiaryBeastIds.swarmOfRavens,
      BestiaryBeastIds.swarmOfInsects,
      BestiaryBeastIds.swarmOfBats,
    }) {
      final swarm = creatures[id]!;
      expect(swarm.isSwarm, isTrue);
      expect(swarm.swarmOfSize, CreatureSize.tiny);
      expect(swarm.damageResistances, _expectedSwarmResistances);
      expect(swarm.conditionImmunities, _expectedSwarmImmunities);
      expect(
        swarm.traits.map((trait) => trait.id),
        contains('swarm'),
      );
      expect(
        swarm.actions.single.effects.single.tags,
        contains('reduced_damage_at_half_hit_points'),
      );
    }
  });

  test('insect swarm preserves all four manual variants', () {
    final swarm = creatures[BestiaryBeastIds.swarmOfInsects]!;

    expect(
      swarm.variants.map((variant) => variant.id).toSet(),
      {
        'swarm_of_centipedes',
        'swarm_of_spiders',
        'swarm_of_beetles',
        'swarm_of_wasps',
      },
    );
  });

  test('Wild Shape excludes swarms and respects movement', () {
    final forms = eligibleWildShapeFormsFrom(
      creatures.values,
      maximumChallengeRating: 1,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).toList();

    expect(forms.every((creature) => !creature.isSwarm), isTrue);
    expect(
      forms.map((creature) => creature.id),
      isNot(contains(BestiaryBeastIds.swarmOfRavens)),
    );
    expect(
      forms.map((creature) => creature.id),
      isNot(contains(BestiaryBeastIds.swarmOfInsects)),
    );
    expect(
      forms.map((creature) => creature.id),
      isNot(contains(BestiaryBeastIds.swarmOfBats)),
    );
  });

  test('Beast Master excludes swarms and oversized creatures', () {
    final companions = eligibleBeastCompanionsFrom(
      creatures.values,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).toList();

    expect(companions.every((creature) => !creature.isSwarm), isTrue);
    expect(
      companions.map((creature) => creature.id),
      containsAll({
        BestiaryBeastIds.wolf,
        BestiaryBeastIds.mastiff,
        BestiaryBeastIds.giantCentipede,
        BestiaryBeastIds.mule,
        BestiaryBeastIds.panther,
        BestiaryBeastIds.bat,
        BestiaryBeastIds.pony,
        BestiaryBeastIds.quipper,
        BestiaryBeastIds.spider,
        BestiaryBeastIds.giantWolfSpider,
        BestiaryBeastIds.frog,
        BestiaryBeastIds.giantFrog,
        BestiaryBeastIds.giantFireBeetle,
        BestiaryBeastIds.jackal,
      }),
    );
  });
}

const _expectedSwarmResistances = {
  'contundente',
  'perforante',
  'tagliente',
};

const _expectedSwarmImmunities = {
  'affascinato',
  'afferrato',
  'paralizzato',
  'pietrificato',
  'prono',
  'spaventato',
  'stordito',
  'trattenuto',
};
