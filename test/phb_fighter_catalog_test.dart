import 'package:dnd_character_sheet/data/battle_master_maneuver_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/fighter_class_data.dart';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fighter = fighterClassDefinition;
  final champion = fighter.subclasses[FighterSubclassIds.champion]!;
  final battleMaster = fighter.subclasses[FighterSubclassIds.battleMaster]!;
  final eldritchKnight = fighter.subclasses[FighterSubclassIds.eldritchKnight]!;

  test('universal registry contains the canonical PHB Fighter', () {
    expect(
      phbClassDefinitions[ClassIds.fighter],
      same(fighterClassDefinition),
    );
    expect(
      phbClassDefinitionFor(ClassIds.fighter),
      same(fighterClassDefinition),
    );
    expect(fighter.id, ClassIds.fighter);
    expect(fighter.name, 'Guerriero');
    expect(fighter.hitDie, 10);
    expect(fighter.homebrew, isFalse);
    expect(fighter.content.source.isEmpty, isFalse);
  });

  test('Fighter base and archetype milestones cover all twenty levels', () {
    const baseFeatureLevels = {
      1,
      2,
      3,
      4,
      5,
      6,
      8,
      9,
      11,
      12,
      13,
      14,
      16,
      17,
      19,
      20,
    };
    const archetypeOnlyLevels = {
      7,
      10,
      15,
      18,
    };

    expect(fighter.featuresByLevel.keys.toSet(), baseFeatureLevels);
    expect(
      {...baseFeatureLevels, ...archetypeOnlyLevels},
      {for (var level = 1; level <= 20; level++) level},
    );

    for (final level in baseFeatureLevels) {
      expect(
        fighter.featuresAtLevel(level),
        isNotEmpty,
        reason: 'Nessun privilegio base al livello $level',
      );
    }

    for (final level in archetypeOnlyLevels) {
      expect(
        fighter.featuresAtLevel(level),
        isEmpty,
        reason: 'Il livello $level deve appartenere agli archetipi marziali',
      );

      for (final subclass in fighter.subclasses.values) {
        expect(
          subclass.featuresByLevel[level],
          isNotEmpty,
          reason:
              '${subclass.name} non possiede un privilegio al livello $level',
        );
      }
    }

    expect(fighter.subclassSelectionLevel, 3);
    expect(fighter.proficiencies.savingThrows, {'FOR', 'COS'});
    expect(fighter.proficiencies.skillChoices, 2);
    expect(fighter.startingEquipmentChoices, isNotEmpty);
  });

  test('all Fighter base features have registered definitions', () {
    final granted =
        fighter.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(fighter.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in fighter.featureDefinitions.entries) {
      final feature = entry.value;

      expect(feature.id, entry.key);
      expect(feature.content.id, entry.key);
      expect(feature.content.ownerId, ClassIds.fighter);
      expect(feature.content.name.trim(), isNotEmpty);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.ruleTags, isNotEmpty);
    }
  });

  test('Fighter uses only the six PHB fighting styles', () {
    expect(phbFighterFightingStyleIds, hasLength(6));
    expect(
      phbFighterFightingStyleIds,
      {
        FightingStyleIds.archery,
        FightingStyleIds.defense,
        FightingStyleIds.dueling,
        FightingStyleIds.greatWeaponFighting,
        FightingStyleIds.protection,
        FightingStyleIds.twoWeaponFighting,
      },
    );

    for (final styleId in phbFighterFightingStyleIds) {
      final style = fightingStyleDefinitions[styleId];

      expect(
        style,
        isNotNull,
        reason: 'Stile di combattimento mancante: $styleId',
      );
      expect(style!.id, styleId);
      expect(style.name.trim(), isNotEmpty);
      expect(style.description.trim(), isNotEmpty);
    }
  });

  test('all three PHB martial archetypes are registered', () {
    expect(
      fighter.subclasses.keys.toSet(),
      {
        FighterSubclassIds.champion,
        FighterSubclassIds.battleMaster,
        FighterSubclassIds.eldritchKnight,
      },
    );

    expect(fighter.phbSubclasses, hasLength(3));
    expect(fighter.supplementalSubclasses, isEmpty);

    for (final subclass in fighter.subclasses.values) {
      expect(subclass.classId, ClassIds.fighter);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
      expect(subclass.content.source.isEmpty, isFalse);
      expect(subclass.content.ownerId, ClassIds.fighter);
    }
  });

  test('every granted subclass feature is registered and documented', () {
    for (final subclass in fighter.subclasses.values) {
      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();

      expect(
        granted.difference(
          subclass.featureDefinitions.keys.toSet(),
        ),
        isEmpty,
        reason: 'Privilegi senza definizione in ${subclass.name}',
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final feature = entry.value;

        expect(feature.id, entry.key);
        expect(feature.content.id, entry.key);
        expect(feature.content.ownerId, subclass.id);
        expect(feature.content.name.trim(), isNotEmpty);
        expect(
          feature.content.description.summary.trim(),
          isNotEmpty,
        );
        expect(feature.content.source.isEmpty, isFalse);
        expect(feature.ruleTags, isNotEmpty);
      }
    }
  });

  test('Champion has complete levels and structured critical ranges', () {
    expect(
      champion.featuresByLevel.keys.toSet(),
      {3, 7, 10, 15, 18},
    );
    expect(champion.resources, isEmpty);
    expect(champion.spellcasting, isNull);
    expect(champion.options, isEmpty);

    final criticalRanges = champion.featureDefinitions.values
        .expand((feature) => feature.effects.ruleEffects)
        .where((effect) => effect.type == CharacterRuleEffectType.criticalRange)
        .map((effect) => effect.value)
        .toSet();

    expect(criticalRanges, {19, 18});
  });

  test('Battle Master catalog and progression are coherent', () {
    expect(battleMasterManeuverDefinitions, hasLength(16));
    expect(battleMaster.options, hasLength(16));
    expect(battleMaster.spellcasting, isNull);

    expect(
      battleMaster.options.map((option) => option.id).toSet(),
      battleMasterManeuverDefinitions.keys.toSet(),
    );

    expect(
      battleMaster.progressionValue(
        BattleMasterProgressionIds.superiorityDie,
        3,
      ),
      'd8',
    );
    expect(
      battleMaster.progressionValue(
        BattleMasterProgressionIds.superiorityDie,
        10,
      ),
      'd10',
    );
    expect(
      battleMaster.progressionValue(
        BattleMasterProgressionIds.superiorityDie,
        18,
      ),
      'd12',
    );

    final resource = battleMaster.resources.single;

    expect(resource.id, BattleMasterResourceIds.superiorityDice);
    expect(resource.maximumAtLevel(3), 4);
    expect(resource.maximumAtLevel(7), 5);
    expect(resource.maximumAtLevel(15), 6);

    final progression = battleMaster.optionProgression!;

    expect(progression.selectionsAtLevel(3), 3);
    expect(progression.selectionsAtLevel(7), 5);
    expect(progression.selectionsAtLevel(10), 7);
    expect(progression.selectionsAtLevel(15), 9);
    expect(progression.replacementLevels, {7, 10, 15});
  });

  test('all Battle Master maneuvers have structured mechanics', () {
    for (final entry in battleMasterManeuverDefinitions.entries) {
      final maneuver = entry.value;

      expect(maneuver.id, entry.key);
      expect(maneuver.name.trim(), isNotEmpty);
      expect(maneuver.description.trim(), isNotEmpty);
      expect(maneuver.triggers, isNotEmpty);
      expect(maneuver.ruleTags, isNotEmpty);

      if (maneuver.savingThrowAbility != null) {
        expect(
          {'FOR', 'SAG'},
          contains(maneuver.savingThrowAbility),
        );
      }
    }
  });

  test('Eldritch Knight has complete third-caster progression', () {
    final spellcasting = eldritchKnight.spellcasting!;

    expect(
      eldritchKnight.featuresByLevel.keys.toSet(),
      {3, 7, 10, 15, 18},
    );
    expect(
      spellcasting.progression,
      ClassSpellcastingProgression.third,
    );
    expect(spellcasting.ability, 'INT');
    expect(spellcasting.minimumLevel, 3);
    expect(spellcasting.cantripsKnownAtLevel(3), 2);
    expect(spellcasting.cantripsKnownAtLevel(10), 3);
    expect(spellcasting.spellsKnownAtLevel(3), 3);
    expect(spellcasting.spellsKnownAtLevel(20), 13);
    expect(spellcasting.slotsAtLevel(3), [2]);
    expect(spellcasting.slotsAtLevel(20), [4, 3, 3, 1]);

    for (var level = 3; level <= 20; level++) {
      expect(
        spellcasting.spellsKnownFromPoolsAtLevel(level),
        spellcasting.spellsKnownAtLevel(level),
        reason: 'Gruppi magici incoerenti al livello $level',
      );
    }
  });

  test('Eldritch Knight references only canonical Wizard spells', () {
    final spellcasting = eldritchKnight.spellcasting!;
    final wizardSpellIds = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.wizard))
        .map((spell) => spell.id)
        .toSet();

    expect(wizardSpellIds, hasLength(215));
    expect(spellcasting.spellIds, wizardSpellIds);

    for (final spellId in spellcasting.spellIds) {
      final spell = spellDefinitions[spellId];

      expect(
        spell,
        isNotNull,
        reason: 'Incantesimo inesistente: $spellId',
      );
      expect(spell!.classIds, contains(ClassIds.wizard));
    }
  });

  test('Eldritch Knight school restrictions preserve four exceptions', () {
    final pools = {
      for (final pool in eldritchKnight.spellcasting!.learningPools)
        pool.id: pool,
    };

    expect(pools, hasLength(2));

    final restricted =
        pools[EldritchKnightSpellPoolIds.abjurationAndEvocation]!;
    final unrestricted = pools[EldritchKnightSpellPoolIds.unrestricted]!;

    expect(
      restricted.allowedSchoolIds,
      {'abjuration', 'evocation'},
    );
    expect(unrestricted.allowedSchoolIds, isEmpty);

    expect(restricted.knownAtLevel(20), 9);
    expect(unrestricted.knownAtLevel(3), 1);
    expect(unrestricted.knownAtLevel(8), 2);
    expect(unrestricted.knownAtLevel(14), 3);
    expect(unrestricted.knownAtLevel(20), 4);

    expect(
      restricted.knownAtLevel(20) + unrestricted.knownAtLevel(20),
      13,
    );
  });

  test('all class and subclass resources are structurally coherent', () {
    final resources = [
      ...fighter.resources,
      for (final subclass in fighter.subclasses.values) ...subclass.resources,
    ];

    expect(resources, isNotEmpty);

    for (final resource in resources) {
      expect(resource.id.trim(), isNotEmpty);
      expect(resource.name.trim(), isNotEmpty);
      expect(resource.minimumLevel, greaterThan(0));
      expect(
        resource.maximumAtLevel(resource.minimumLevel),
        greaterThan(0),
      );
    }
  });

  test('all progression values contain valid level entries', () {
    final progressions = [
      ...fighter.progressionValues,
      for (final subclass in fighter.subclasses.values)
        ...subclass.progressionValues,
    ];

    expect(progressions, isNotEmpty);

    for (final progression in progressions) {
      expect(progression.id.trim(), isNotEmpty);
      expect(progression.name.trim(), isNotEmpty);
      expect(progression.valuesByLevel, isNotEmpty);

      for (final entry in progression.valuesByLevel.entries) {
        expect(entry.key, inInclusiveRange(1, 20));
        expect(entry.value.trim(), isNotEmpty);
        expect(
          progression.valueAtLevel(entry.key),
          entry.value,
        );
      }
    }
  });
}
