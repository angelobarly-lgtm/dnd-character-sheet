import 'package:dnd_character_sheet/data/battle_master_maneuver_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/data/fighter_class_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final battleMaster =
      fighterClassDefinition.subclasses[FighterSubclassIds.battleMaster]!;

  test('Battle Master is registered with complete PHB progression', () {
    expect(battleMaster.id, FighterSubclassIds.battleMaster);
    expect(battleMaster.name, 'Maestro di Battaglia');
    expect(battleMaster.classId, ClassIds.fighter);
    expect(battleMaster.homebrew, isFalse);
    expect(battleMaster.supplemental, isFalse);
    expect(battleMaster.content.source.isEmpty, isFalse);
    expect(battleMaster.content.ownerId, ClassIds.fighter);

    expect(
      battleMaster.featuresByLevel.keys.toSet(),
      {3, 7, 10, 15, 18},
    );
    expect(
      battleMaster.featuresByLevel[3],
      [
        BattleMasterFeatureIds.combatSuperiority,
        BattleMasterFeatureIds.studentOfWar,
      ],
    );
    expect(
      battleMaster.featuresByLevel[18],
      [BattleMasterFeatureIds.improvedCombatSuperiority],
    );
  });

  test('all 16 PHB maneuvers are translated and structured', () {
    const expectedNames = {
      BattleMasterManeuverIds.commandersStrike: 'Colpo del Comandante',
      BattleMasterManeuverIds.disarmingAttack: 'Attacco Disarmante',
      BattleMasterManeuverIds.distractingStrike: 'Attacco Distraente',
      BattleMasterManeuverIds.evasiveFootwork: 'Scarto Elusivo',
      BattleMasterManeuverIds.feintingAttack: 'Attacco con Finta',
      BattleMasterManeuverIds.goadingAttack: 'Attacco Adescante',
      BattleMasterManeuverIds.lungingAttack: 'Attacco con Affondo',
      BattleMasterManeuverIds.maneuveringAttack: 'Attacco con Manovra',
      BattleMasterManeuverIds.menacingAttack: 'Attacco Minaccioso',
      BattleMasterManeuverIds.parry: 'Parata',
      BattleMasterManeuverIds.precisionAttack: 'Attacco Preciso',
      BattleMasterManeuverIds.pushingAttack: 'Attacco con Spinta',
      BattleMasterManeuverIds.rally: 'Incoraggiamento',
      BattleMasterManeuverIds.riposte: 'Replica',
      BattleMasterManeuverIds.sweepingAttack: 'Attacco con Spazzata',
      BattleMasterManeuverIds.tripAttack: 'Attacco Sbilanciante',
    };

    expect(battleMasterManeuverDefinitions, hasLength(16));
    expect(
      battleMasterManeuverDefinitions.keys.toSet(),
      expectedNames.keys.toSet(),
    );

    for (final entry in battleMasterManeuverDefinitions.entries) {
      final maneuver = entry.value;

      expect(maneuver.id, entry.key);
      expect(maneuver.name, expectedNames[entry.key]);
      expect(maneuver.description.trim(), isNotEmpty);
      expect(maneuver.triggers, isNotEmpty);
      expect(maneuver.ruleTags, isNotEmpty);
    }
  });

  test('maneuver saving throws match the PHB', () {
    final savingThrows = {
      for (final entry in battleMasterManeuverDefinitions.entries)
        if (entry.value.savingThrowAbility != null)
          entry.key: entry.value.savingThrowAbility,
    };

    expect(
      savingThrows,
      {
        BattleMasterManeuverIds.disarmingAttack: 'FOR',
        BattleMasterManeuverIds.goadingAttack: 'SAG',
        BattleMasterManeuverIds.menacingAttack: 'SAG',
        BattleMasterManeuverIds.pushingAttack: 'FOR',
        BattleMasterManeuverIds.tripAttack: 'FOR',
      },
    );
  });

  test('damage maneuvers identify use of the superiority die', () {
    final damageManeuvers = battleMasterManeuverDefinitions.values
        .where((maneuver) => maneuver.addsSuperiorityDieToDamage)
        .map((maneuver) => maneuver.id)
        .toSet();

    expect(
      damageManeuvers,
      {
        BattleMasterManeuverIds.commandersStrike,
        BattleMasterManeuverIds.disarmingAttack,
        BattleMasterManeuverIds.distractingStrike,
        BattleMasterManeuverIds.feintingAttack,
        BattleMasterManeuverIds.goadingAttack,
        BattleMasterManeuverIds.lungingAttack,
        BattleMasterManeuverIds.maneuveringAttack,
        BattleMasterManeuverIds.menacingAttack,
        BattleMasterManeuverIds.pushingAttack,
        BattleMasterManeuverIds.riposte,
        BattleMasterManeuverIds.sweepingAttack,
        BattleMasterManeuverIds.tripAttack,
      },
    );
  });

  test('superiority dice resource progresses from four to six', () {
    final resource = battleMaster.resources.single;

    expect(resource.id, BattleMasterResourceIds.superiorityDice);
    expect(resource.name, 'Dadi di Superiorità');
    expect(resource.minimumLevel, 3);
    expect(resource.recovery, ClassResourceRecovery.shortRest);

    expect(resource.maximumAtLevel(2), 0);
    expect(resource.maximumAtLevel(3), 4);
    expect(resource.maximumAtLevel(6), 4);
    expect(resource.maximumAtLevel(7), 5);
    expect(resource.maximumAtLevel(14), 5);
    expect(resource.maximumAtLevel(15), 6);
    expect(resource.maximumAtLevel(20), 6);
  });

  test('superiority die improves from d8 to d10 and d12', () {
    expect(
      battleMaster.progressionValue(
        BattleMasterProgressionIds.superiorityDie,
        2,
      ),
      isNull,
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
    expect(
      battleMaster.progressionValue(
        BattleMasterProgressionIds.maneuverSaveDc,
        20,
      ),
      '8 + bonus di competenza + modificatore di FOR o DES',
    );
  });

  test('maneuver choices progress from three to nine', () {
    final progression = battleMaster.optionProgression!;

    expect(battleMaster.options, hasLength(16));
    expect(progression.selectionsAtLevel(2), 0);
    expect(progression.selectionsAtLevel(3), 3);
    expect(progression.selectionsAtLevel(7), 5);
    expect(progression.selectionsAtLevel(10), 7);
    expect(progression.selectionsAtLevel(15), 9);
    expect(progression.selectionsAtLevel(20), 9);

    expect(progression.replacementLevels, {7, 10, 15});

    for (final option in battleMaster.options) {
      final maneuver = battleMasterManeuverDefinitions[option.id];

      expect(maneuver, isNotNull);
      expect(option.name, maneuver!.name);
      expect(option.category, 'battle_master_maneuver');
      expect(option.minimumLevel, 3);
      expect(option.cost, 1);
      expect(
        option.resource,
        BattleMasterResourceIds.superiorityDice,
      );
      expect(option.description.summary, maneuver.description);
      expect(option.source.trim(), isNotEmpty);
      expect(option.sourceRef.trim(), isNotEmpty);
    }
  });

  test('Student of War offers all 17 artisan tools', () {
    final feature =
        battleMaster.featureDefinitions[BattleMasterFeatureIds.studentOfWar]!;
    final choice = feature.choices.single;

    final artisanTools = toolDefinitions.values
        .where((tool) => tool.category == ToolCategory.artisan)
        .toList();

    expect(choice.type, CharacterChoiceType.tool);
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.requireNewAcquisition, isTrue);
    expect(choice.options, hasLength(17));
    expect(
      choice.options.map((option) => option.id).toSet(),
      artisanTools.map((tool) => tool.id).toSet(),
    );

    for (final option in choice.options) {
      expect(option.label, toolDefinitions[option.id]!.name);
    }
  });

  test('Know Your Enemy compares two structured characteristics', () {
    final feature =
        battleMaster.featureDefinitions[BattleMasterFeatureIds.knowYourEnemy]!;
    final effect = feature.effects.ruleEffects.single;

    expect(effect.id, 'battle_master_know_your_enemy_comparison');
    expect(effect.type, CharacterRuleEffectType.conditional);
    expect(effect.target, 'relative_characteristics');
    expect(effect.value, 2);
    expect(effect.referenceIds, hasLength(7));
    expect(
      effect.condition,
      'observe_or_interact_for_1_minute_outside_combat',
    );
  });

  test('Relentless restores one superiority die on initiative', () {
    final feature =
        battleMaster.featureDefinitions[BattleMasterFeatureIds.relentless]!;
    final effect = feature.effects.ruleEffects.single;

    expect(
      feature.resourceId,
      BattleMasterResourceIds.superiorityDice,
    );
    expect(effect.type, CharacterRuleEffectType.resource);
    expect(effect.target, BattleMasterResourceIds.superiorityDice);
    expect(effect.value, 1);
    expect(
      effect.condition,
      'roll_initiative_with_no_superiority_dice_remaining',
    );
  });

  test('every granted Battle Master feature is registered', () {
    final granted = battleMaster.featuresByLevel.values
        .expand((features) => features)
        .toSet();

    expect(
      granted.difference(
        battleMaster.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );

    for (final entry in battleMaster.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(
        entry.value.content.ownerId,
        FighterSubclassIds.battleMaster,
      );
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });
}
