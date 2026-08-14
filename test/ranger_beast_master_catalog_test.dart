import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/ranger_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ranger = phbClassDefinitions[ClassIds.ranger]!;
  final beastMaster = ranger.subclasses[RangerSubclassIds.beastMaster]!;
  const companion = rangerAnimalCompanionDefinition;

  test('Beast Master is registered as a PHB Ranger archetype', () {
    expect(beastMaster.id, RangerSubclassIds.beastMaster);
    expect(beastMaster.name, 'Signore delle Bestie');
    expect(beastMaster.classId, ClassIds.ranger);
    expect(beastMaster.homebrew, isFalse);
    expect(beastMaster.supplemental, isFalse);
    expect(beastMaster.content.source.name, 'Manuale del Giocatore 2014');
    expect(beastMaster.content.source.reference, 'pp. 105-106');
  });

  test('Beast Master progression uses all four PHB milestones', () {
    expect(
      beastMaster.featuresByLevel,
      {
        3: [RangerBeastMasterFeatureIds.rangerCompanion],
        7: [RangerBeastMasterFeatureIds.exceptionalTraining],
        11: [RangerBeastMasterFeatureIds.bestialFury],
        15: [RangerBeastMasterFeatureIds.shareSpells],
      },
    );

    final granted = beastMaster.featuresByLevel.values
        .expand((features) => features)
        .toSet();
    expect(granted, hasLength(4));
    expect(
      granted.difference(beastMaster.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in beastMaster.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, RangerSubclassIds.beastMaster);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('animal companion has the exact PHB eligibility limits', () {
    expect(beastMaster.companions, [companion]);
    expect(companion.id, RangerCompanionIds.animalCompanion);
    expect(companion.featureId, RangerBeastMasterFeatureIds.rangerCompanion);
    expect(companion.minimumLevel, 3);
    expect(companion.creatureCatalogId, 'bestiary');
    expect(companion.allowedCreatureTypes, {'beast'});
    expect(companion.maximumChallengeRating, 0.25);
    expect(companion.maximumSize, ClassCompanionSize.medium);
  });

  test('Ranger proficiency bonus scales every manual companion target', () {
    expect(
      companion.proficiencyBonusTargets,
      {
        ClassCompanionProficiencyBonusTarget.armorClass,
        ClassCompanionProficiencyBonusTarget.attackRolls,
        ClassCompanionProficiencyBonusTarget.damageRolls,
        ClassCompanionProficiencyBonusTarget.proficientSavingThrows,
        ClassCompanionProficiencyBonusTarget.proficientSkillChecks,
      },
    );
    expect(companion.hitPointMinimumClassLevelMultiplier, 4);
    expect(companion.usesHigherOfStatBlockOrMinimumHitPoints, isTrue);
    expect(companion.usesOwnHitDiceDuringShortRest, isTrue);
  });

  test('base commands preserve action economy and available actions', () {
    final movement =
        companion.commandFor(RangerCompanionCommandIds.verbalMovement)!;
    expect(movement.minimumLevel, 3);
    expect(movement.activation, ClassCompanionCommandActivation.noAction);
    expect(movement.actions, {'move'});
    expect(movement.verbal, isTrue);

    final standard =
        companion.commandFor(RangerCompanionCommandIds.standardAction)!;
    expect(standard.minimumLevel, 3);
    expect(standard.activation, ClassCompanionCommandActivation.action);
    expect(
      standard.actions,
      {'attack', 'dash', 'disengage', 'dodge', 'help'},
    );
  });

  test('companion initiative, independence, reactions and travel are exact',
      () {
    expect(companion.sharesOwnerInitiative, isTrue);
    expect(companion.movesOnOwnerTurn, isTrue);
    expect(companion.reactionsRequireCommand, isFalse);
    expect(
      companion.actsIndependentlyWhenOwnerAbsentOrIncapacitated,
      isTrue,
    );
    expect(companion.canTakeAnyActionWhenIndependent, isTrue);
    expect(companion.protectsOwnerWhenIndependent, isTrue);
    expect(companion.soloFavoredTerrainStealthAtNormalPace, isTrue);
  });

  test('Extra Attack interaction begins at Ranger level five', () {
    expect(companion.ownerCanAttackWhileCommandingAtLevel(4), isFalse);
    expect(companion.ownerCanAttackWhileCommandingAtLevel(5), isTrue);
    expect(companion.ownerCanAttackWhileCommandingAtLevel(20), isTrue);
  });

  test('Exceptional Training grants only the four non-attack commands', () {
    final command =
        companion.commandFor(RangerCompanionCommandIds.exceptionalTraining)!;
    expect(command.minimumLevel, 7);
    expect(command.activation, ClassCompanionCommandActivation.bonusAction);
    expect(command.actions, {'dash', 'disengage', 'dodge', 'help'});
    expect(command.actions, isNot(contains('attack')));
    expect(command.requiresCompanionNotAttacking, isTrue);
  });

  test('Bestial Fury grants two attacks or Multiattack at level eleven', () {
    expect(companion.attacksPerAttackCommandAtLevel(3), 1);
    expect(companion.attacksPerAttackCommandAtLevel(10), 1);
    expect(companion.attacksPerAttackCommandAtLevel(11), 2);
    expect(companion.attacksPerAttackCommandAtLevel(20), 2);
    expect(companion.attackCommandAllowsMultiattackAtLevel(10), isFalse);
    expect(companion.attackCommandAllowsMultiattackAtLevel(11), isTrue);
  });

  test('dead companion replacement requires eight hours and a valid beast', () {
    expect(companion.replacementBondHours, 8);
    expect(companion.replacementRequiresNonhostileCreature, isTrue);
    expect(companion.allowedCreatureTypes, contains('beast'));
    expect(companion.maximumChallengeRating, 0.25);
    expect(companion.maximumSize, ClassCompanionSize.medium);
  });

  test('Share Spells begins at level fifteen within nine meters', () {
    expect(companion.sharesSelfTargetedSpellsAtLevel(14), isFalse);
    expect(companion.sharesSelfTargetedSpellsAtLevel(15), isTrue);
    expect(companion.sharedSpellMaximumDistanceMeters, 9);
  });

  test('universal class lookup resolves subclass companions explicitly', () {
    expect(
      ranger.companionFor(
        RangerCompanionIds.animalCompanion,
        subclassId: RangerSubclassIds.beastMaster,
      ),
      same(companion),
    );
    expect(
      ranger.companionFor(RangerCompanionIds.animalCompanion),
      isNull,
    );
    expect(
      ranger.companionFor(
        RangerCompanionIds.animalCompanion,
        subclassId: RangerSubclassIds.hunter,
      ),
      isNull,
    );
  });
}
