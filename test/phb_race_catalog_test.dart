import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, int> bonusMap(CharacterEffects effects) => {
      for (final bonus in effects.abilityBonuses) bonus.ability: bonus.amount,
    };

Set<String> choiceIds(CharacterEffects effects) =>
    effects.choices.map((choice) => choice.id).toSet();

Set<String> featureIds(Iterable<CharacterEffects> effects) => {
      for (final effect in effects) ...effect.grantedFeatureIds,
    };

bool sameSet<T>(Set<T> first, Set<T> second) =>
    first.length == second.length && first.containsAll(second);

void main() {
  const expectedRaceIds = {
    RaceIds.dwarf,
    RaceIds.elf,
    RaceIds.halfling,
    RaceIds.human,
    RaceIds.dragonborn,
    RaceIds.gnome,
    RaceIds.halfElf,
    RaceIds.halfOrc,
    RaceIds.tiefling,
  };

  const expectedSubraceIds = {
    SubraceIds.hillDwarf,
    SubraceIds.mountainDwarf,
    SubraceIds.highElf,
    SubraceIds.woodElf,
    SubraceIds.drow,
    SubraceIds.lightfootHalfling,
    SubraceIds.stoutHalfling,
    SubraceIds.forestGnome,
    SubraceIds.rockGnome,
  };

  final allSubraces = <String, SubraceDefinition>{
    ...dwarfSubraces,
    ...elfSubraces,
    ...halflingSubraces,
    ...gnomeSubraces,
  };

  test('PHB catalog contains all 9 races and all 9 subraces', () {
    expect(phbRaceDefinitions.keys.toSet(), expectedRaceIds);
    expect(phbRaceDefinitions.length, 9);

    expect(allSubraces.keys.toSet(), expectedSubraceIds);
    expect(allSubraces.length, 9);

    for (final entry in phbRaceDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.name.trim(), isNotEmpty);
      expect(entry.value.homebrew, isFalse);
      expect(entry.value.speed, greaterThan(0));
      expect({'Media', 'Piccola'}, contains(entry.value.size));
    }

    for (final entry in allSubraces.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.name.trim(), isNotEmpty);
      expect(expectedRaceIds, contains(entry.value.raceId));
    }
  });

  test('subrace registries are attached to the correct parent races', () {
    expect(
      phbRaceDefinitions[RaceIds.dwarf]!.subraces.keys.toSet(),
      dwarfSubraces.keys.toSet(),
    );
    expect(
      phbRaceDefinitions[RaceIds.elf]!.subraces.keys.toSet(),
      elfSubraces.keys.toSet(),
    );
    expect(
      phbRaceDefinitions[RaceIds.halfling]!.subraces.keys.toSet(),
      halflingSubraces.keys.toSet(),
    );
    expect(
      phbRaceDefinitions[RaceIds.gnome]!.subraces.keys.toSet(),
      gnomeSubraces.keys.toSet(),
    );

    expect(
      dwarfSubraces.values.every(
        (subrace) => subrace.raceId == RaceIds.dwarf,
      ),
      isTrue,
    );
    expect(
      elfSubraces.values.every(
        (subrace) => subrace.raceId == RaceIds.elf,
      ),
      isTrue,
    );
    expect(
      halflingSubraces.values.every(
        (subrace) => subrace.raceId == RaceIds.halfling,
      ),
      isTrue,
    );
    expect(
      gnomeSubraces.values.every(
        (subrace) => subrace.raceId == RaceIds.gnome,
      ),
      isTrue,
    );
  });

  test('base race bonuses, speeds, languages and choices match the PHB', () {
    final expected = <String,
        ({
      String name,
      double speed,
      String size,
      Map<String, int> bonuses,
      Set<String> languages,
      double? darkvision,
      Set<String> choices,
    })>{
      RaceIds.dwarf: (
        name: 'Nano',
        speed: 7.5,
        size: 'Media',
        bonuses: {'COS': 2},
        languages: {'common', 'dwarvish'},
        darkvision: 18,
        choices: {'dwarf_artisan_tool'},
      ),
      RaceIds.elf: (
        name: 'Elfo',
        speed: 9,
        size: 'Media',
        bonuses: {'DES': 2},
        languages: {'common', 'elvish'},
        darkvision: 18,
        choices: {},
      ),
      RaceIds.halfling: (
        name: 'Halfling',
        speed: 7.5,
        size: 'Piccola',
        bonuses: {'DES': 2},
        languages: {'common', 'halfling'},
        darkvision: null,
        choices: {},
      ),
      RaceIds.human: (
        name: 'Umano',
        speed: 9,
        size: 'Media',
        bonuses: {
          'FOR': 1,
          'DES': 1,
          'COS': 1,
          'INT': 1,
          'SAG': 1,
          'CAR': 1,
        },
        languages: {'common'},
        darkvision: null,
        choices: {'human_extra_language'},
      ),
      RaceIds.dragonborn: (
        name: 'Dragonide',
        speed: 9,
        size: 'Media',
        bonuses: {'FOR': 2, 'CAR': 1},
        languages: {'common', 'draconic'},
        darkvision: null,
        choices: {'dragonborn_ancestry'},
      ),
      RaceIds.gnome: (
        name: 'Gnomo',
        speed: 7.5,
        size: 'Piccola',
        bonuses: {'INT': 2},
        languages: {'common', 'gnomish'},
        darkvision: 18,
        choices: {},
      ),
      RaceIds.halfElf: (
        name: 'Mezzelfo',
        speed: 9,
        size: 'Media',
        bonuses: {'CAR': 2},
        languages: {'common', 'elvish'},
        darkvision: 18,
        choices: {
          'half_elf_ability_bonuses',
          'half_elf_skills',
          'half_elf_extra_language',
        },
      ),
      RaceIds.halfOrc: (
        name: 'Mezzorco',
        speed: 9,
        size: 'Media',
        bonuses: {'FOR': 2, 'COS': 1},
        languages: {'common', 'orc'},
        darkvision: 18,
        choices: {},
      ),
      RaceIds.tiefling: (
        name: 'Tiefling',
        speed: 9,
        size: 'Media',
        bonuses: {'INT': 1, 'CAR': 2},
        languages: {'common', 'infernal'},
        darkvision: 18,
        choices: {},
      ),
    };

    final errors = <String>[];

    for (final entry in expected.entries) {
      final race = phbRaceDefinitions[entry.key];

      if (race == null) {
        errors.add('${entry.key}: definizione mancante');
        continue;
      }

      if (race.name != entry.value.name) {
        errors.add('${entry.key}: nome=${race.name}');
      }
      if (race.speed != entry.value.speed) {
        errors.add('${entry.key}: velocità=${race.speed}');
      }
      if (race.size != entry.value.size) {
        errors.add('${entry.key}: taglia=${race.size}');
      }
      if (bonusMap(race.effects).toString() != entry.value.bonuses.toString()) {
        errors.add(
          '${entry.key}: bonus=${bonusMap(race.effects)}, '
          'attesi=${entry.value.bonuses}',
        );
      }
      if (!sameSet(race.effects.languages, entry.value.languages)) {
        errors.add(
          '${entry.key}: linguaggi=${race.effects.languages}, '
          'attesi=${entry.value.languages}',
        );
      }
      if (race.effects.darkvisionRange != entry.value.darkvision) {
        errors.add(
          '${entry.key}: scurovisione='
          '${race.effects.darkvisionRange}',
        );
      }
      if (!sameSet(choiceIds(race.effects), entry.value.choices)) {
        errors.add(
          '${entry.key}: scelte=${choiceIds(race.effects)}, '
          'attese=${entry.value.choices}',
        );
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('subrace bonuses and special effects match the PHB', () {
    final expected = <String,
        ({
      Map<String, int> bonuses,
      double? speedOverride,
      double? darkvision,
      int hpPerLevel,
      Set<String> resistances,
      Set<String> armor,
      Set<String> tools,
      Set<String> cantrips,
      Set<String> choices,
    })>{
      SubraceIds.hillDwarf: (
        bonuses: {'SAG': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 1,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.mountainDwarf: (
        bonuses: {'FOR': 2},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {'light_armor', 'medium_armor'},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.highElf: (
        bonuses: {'INT': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {'high_elf_cantrip', 'high_elf_extra_language'},
      ),
      SubraceIds.woodElf: (
        bonuses: {'SAG': 1},
        speedOverride: 10.5,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.drow: (
        bonuses: {'CAR': 1},
        speedOverride: null,
        darkvision: 36,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.lightfootHalfling: (
        bonuses: {'CAR': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.stoutHalfling: (
        bonuses: {'COS': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {'poison'},
        armor: {},
        tools: {},
        cantrips: {},
        choices: {},
      ),
      SubraceIds.forestGnome: (
        bonuses: {'DES': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {},
        cantrips: {'minor_illusion'},
        choices: {},
      ),
      SubraceIds.rockGnome: (
        bonuses: {'COS': 1},
        speedOverride: null,
        darkvision: null,
        hpPerLevel: 0,
        resistances: {},
        armor: {},
        tools: {'tinkers_tools'},
        cantrips: {},
        choices: {},
      ),
    };

    final errors = <String>[];

    for (final entry in expected.entries) {
      final subrace = allSubraces[entry.key];

      if (subrace == null) {
        errors.add('${entry.key}: definizione mancante');
        continue;
      }

      final effects = subrace.effects;

      if (bonusMap(effects).toString() != entry.value.bonuses.toString()) {
        errors.add('${entry.key}: bonus=${bonusMap(effects)}');
      }
      if (effects.walkingSpeedOverride != entry.value.speedOverride) {
        errors.add(
          '${entry.key}: velocità=${effects.walkingSpeedOverride}',
        );
      }
      if (effects.darkvisionRange != entry.value.darkvision) {
        errors.add(
          '${entry.key}: scurovisione=${effects.darkvisionRange}',
        );
      }
      if (effects.hitPointsPerLevelBonus != entry.value.hpPerLevel) {
        errors.add(
          '${entry.key}: PF/livello=${effects.hitPointsPerLevelBonus}',
        );
      }
      if (!sameSet(effects.damageResistances, entry.value.resistances)) {
        errors.add(
          '${entry.key}: resistenze=${effects.damageResistances}',
        );
      }
      if (!sameSet(effects.armorProficiencies, entry.value.armor)) {
        errors.add(
          '${entry.key}: armature=${effects.armorProficiencies}',
        );
      }
      if (!sameSet(effects.toolProficiencies, entry.value.tools)) {
        errors.add(
          '${entry.key}: strumenti=${effects.toolProficiencies}',
        );
      }
      if (!sameSet(effects.grantedCantripIds.toSet(), entry.value.cantrips)) {
        errors.add(
          '${entry.key}: trucchetti=${effects.grantedCantripIds}',
        );
      }
      if (!sameSet(choiceIds(effects), entry.value.choices)) {
        errors.add('${entry.key}: scelte=${choiceIds(effects)}');
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('standard and variant humans are both structurally complete', () {
    final standard = phbRaceDefinitions[RaceIds.human]!;

    expect(standard.id, RaceIds.human);
    expect(bonusMap(standard.effects), {
      'FOR': 1,
      'DES': 1,
      'COS': 1,
      'INT': 1,
      'SAG': 1,
      'CAR': 1,
    });

    expect(humanVariantDefinition.id, HumanVariantIds.variant);
    expect(humanVariantDefinition.name, 'Umano Variante');
    expect(humanVariantDefinition.speed, 9);
    expect(humanVariantDefinition.size, 'Media');
    expect(humanVariantDefinition.homebrew, isFalse);
    expect(humanVariantDefinition.effects.languages, {'common'});
    expect(choiceIds(humanVariantDefinition.effects), {
      'human_variant_abilities',
      'human_variant_skill',
      'human_variant_feat',
      'human_variant_language',
    });
  });

  test('all granted racial features have registered definitions', () {
    final referenced = featureIds([
      ...phbRaceDefinitions.values.map((race) => race.effects),
      ...allSubraces.values.map((subrace) => subrace.effects),
      humanVariantDefinition.effects,
    ]);

    final missing =
        referenced.difference(racialFeatureDefinitions.keys.toSet());

    expect(
      missing,
      isEmpty,
      reason: 'Privilegi razziali senza definizione: '
          '${missing.toList()..sort()}',
    );

    for (final entry in racialFeatureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.name.trim(), isNotEmpty);
    }
  });

  test('all 10 dragon ancestries and breath weapons match the PHB', () {
    const expected = <String,
        ({
      String resistance,
      String damage,
      EffectAreaShape shape,
      double range,
      String save,
    })>{
      DragonAncestryIds.black: (
        resistance: 'acid',
        damage: 'acid',
        shape: EffectAreaShape.line,
        range: 9,
        save: 'DES',
      ),
      DragonAncestryIds.blue: (
        resistance: 'lightning',
        damage: 'lightning',
        shape: EffectAreaShape.line,
        range: 9,
        save: 'DES',
      ),
      DragonAncestryIds.brass: (
        resistance: 'fire',
        damage: 'fire',
        shape: EffectAreaShape.line,
        range: 9,
        save: 'DES',
      ),
      DragonAncestryIds.bronze: (
        resistance: 'lightning',
        damage: 'lightning',
        shape: EffectAreaShape.line,
        range: 9,
        save: 'DES',
      ),
      DragonAncestryIds.copper: (
        resistance: 'acid',
        damage: 'acid',
        shape: EffectAreaShape.line,
        range: 9,
        save: 'DES',
      ),
      DragonAncestryIds.gold: (
        resistance: 'fire',
        damage: 'fire',
        shape: EffectAreaShape.cone,
        range: 4.5,
        save: 'DES',
      ),
      DragonAncestryIds.green: (
        resistance: 'poison',
        damage: 'poison',
        shape: EffectAreaShape.cone,
        range: 4.5,
        save: 'COS',
      ),
      DragonAncestryIds.red: (
        resistance: 'fire',
        damage: 'fire',
        shape: EffectAreaShape.cone,
        range: 4.5,
        save: 'DES',
      ),
      DragonAncestryIds.silver: (
        resistance: 'cold',
        damage: 'cold',
        shape: EffectAreaShape.cone,
        range: 4.5,
        save: 'COS',
      ),
      DragonAncestryIds.white: (
        resistance: 'cold',
        damage: 'cold',
        shape: EffectAreaShape.cone,
        range: 4.5,
        save: 'COS',
      ),
    };

    expect(dragonbornAncestryOptions.length, 10);
    expect(
      dragonbornAncestryOptions.map((option) => option.id).toSet(),
      expected.keys.toSet(),
    );
    expect(dragonBreathDefinitions.keys.toSet(), expected.keys.toSet());

    final errors = <String>[];

    for (final entry in expected.entries) {
      final option = dragonbornAncestryOptions.singleWhere(
        (candidate) => candidate.id == entry.key,
      );
      final breath = dragonBreathDefinitions[entry.key]!;

      if (!sameSet(
          option.effects.damageResistances, {entry.value.resistance})) {
        errors.add(
          '${entry.key}: resistenza='
          '${option.effects.damageResistances}',
        );
      }
      if (breath.ancestryId != entry.key ||
          breath.damageType != entry.value.damage ||
          breath.shape != entry.value.shape ||
          breath.range != entry.value.range ||
          breath.savingThrowAbility != entry.value.save) {
        errors.add('${entry.key}: arma a soffio non corretta');
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('drow and tiefling progressions match levels 1, 3 and 5', () {
    const expected = {
      SubraceIds.drow: [
        '1|cantrip|dancing_lights|null|null|CAR',
        '3|spell|faerie_fire|1|long_rest|CAR',
        '5|spell|darkness|1|long_rest|CAR',
      ],
      RaceIds.tiefling: [
        '1|cantrip|thaumaturgy|null|null|CAR',
        '3|spell|hellish_rebuke|1|long_rest|CAR',
        '5|spell|darkness|1|long_rest|CAR',
      ],
    };

    expect(racialProgressions.keys.toSet(), expected.keys.toSet());

    for (final entry in expected.entries) {
      final actual = racialProgressions[entry.key]!
          .grants
          .map(
            (grant) => '${grant.minimumLevel}|${grant.type.name}|'
                '${grant.contentId}|${grant.uses}|'
                '${grant.recharge}|${grant.ability}',
          )
          .toList();

      expect(actual, entry.value, reason: entry.key);
    }
  });

  test('racial spell and cantrip references exist in the spell catalog', () {
    final referencedSpells = <String>{
      for (final race in phbRaceDefinitions.values)
        ...race.effects.grantedSpellIds,
      for (final race in phbRaceDefinitions.values)
        ...race.effects.grantedCantripIds,
      for (final subrace in allSubraces.values)
        ...subrace.effects.grantedSpellIds,
      for (final subrace in allSubraces.values)
        ...subrace.effects.grantedCantripIds,
      for (final progression in racialProgressions.values)
        for (final grant in progression.grants)
          if (grant.type == RacialGrantType.spell ||
              grant.type == RacialGrantType.cantrip)
            grant.contentId,
    };

    final missing = referencedSpells.difference(spellDefinitions.keys.toSet());

    expect(
      missing,
      isEmpty,
      reason: 'Incantesimi razziali mancanti: '
          '${missing.toList()..sort()}',
    );
  });
}
