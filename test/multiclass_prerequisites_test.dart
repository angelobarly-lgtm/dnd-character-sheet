import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/multiclass_data.dart';
import 'package:flutter_test/flutter_test.dart';

CharacterEligibilityState state({
  int strength = 10,
  int dexterity = 10,
  int constitution = 10,
  int intelligence = 10,
  int wisdom = 10,
  int charisma = 10,
}) {
  return CharacterEligibilityState(
    abilityScores: {
      'FOR': strength,
      'DES': dexterity,
      'COS': constitution,
      'INT': intelligence,
      'SAG': wisdom,
      'CAR': charisma,
    },
  );
}

void main() {
  test('tabella PHB 2014 contiene tutte le dodici classi', () {
    expect(
      phb2014MulticlassPrerequisites.keys,
      containsAll(<String>{
        ClassIds.barbarian,
        ClassIds.bard,
        ClassIds.cleric,
        ClassIds.druid,
        ClassIds.fighter,
        ClassIds.monk,
        ClassIds.paladin,
        ClassIds.ranger,
        ClassIds.rogue,
        ClassIds.sorcerer,
        ClassIds.warlock,
        ClassIds.wizard,
      }),
    );
    expect(phb2014MulticlassPrerequisites, hasLength(12));
  });

  test('Guerriero accetta Forza 13 oppure Destrezza 13', () {
    final withStrength = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.cleric],
      targetClassId: ClassIds.fighter,
      state: state(strength: 13, wisdom: 13),
    );

    final withDexterity = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.cleric],
      targetClassId: ClassIds.fighter,
      state: state(dexterity: 13, wisdom: 13),
    );

    final withoutEither = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.cleric],
      targetClassId: ClassIds.fighter,
      state: state(strength: 12, dexterity: 12, wisdom: 13),
    );

    expect(withStrength.canSelect, isTrue);
    expect(withDexterity.canSelect, isTrue);
    expect(withoutEither.canSelect, isFalse);
  });

  test('Monaco mostra separatamente Destrezza e Saggezza', () {
    final result = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.fighter],
      targetClassId: ClassIds.monk,
      state: state(strength: 13, dexterity: 14, wisdom: 10),
    );

    final monk = result.forClass(ClassIds.monk)!;

    expect(monk.eligibility.requirements, hasLength(2));
    expect(monk.eligibility.requirements[0].satisfied, isTrue);
    expect(monk.eligibility.requirements[1].satisfied, isFalse);
    expect(result.canSelect, isFalse);
  });

  test('devono essere soddisfatte classe attuale e nuova classe', () {
    final currentPassesTargetFails = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.barbarian],
      targetClassId: ClassIds.rogue,
      state: state(strength: 14, dexterity: 10),
    );

    expect(
      currentPassesTargetFails
          .forClass(ClassIds.barbarian)!
          .eligibility
          .canSelect,
      isTrue,
    );
    expect(
      currentPassesTargetFails.forClass(ClassIds.rogue)!.eligibility.canSelect,
      isFalse,
    );
    expect(currentPassesTargetFails.canSelect, isFalse);

    final currentFailsTargetPasses = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.monk],
      targetClassId: ClassIds.cleric,
      state: state(dexterity: 10, wisdom: 14),
    );

    expect(
      currentFailsTargetPasses.forClass(ClassIds.monk)!.eligibility.canSelect,
      isFalse,
    );
    expect(
      currentFailsTargetPasses.forClass(ClassIds.cleric)!.eligibility.canSelect,
      isTrue,
    );
    expect(currentFailsTargetPasses.canSelect, isFalse);
  });

  test('Paladino e Ranger mantengono entrambi i requisiti', () {
    expect(
      multiclassRequirementsFor(ClassIds.paladin),
      hasLength(2),
    );
    expect(
      multiclassRequirementsFor(ClassIds.ranger),
      hasLength(2),
    );

    final paladin = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.fighter],
      targetClassId: ClassIds.paladin,
      state: state(strength: 13, dexterity: 13, charisma: 12),
    );

    final ranger = evaluateMulticlassEligibility(
      existingClassIds: const [ClassIds.fighter],
      targetClassId: ClassIds.ranger,
      state: state(strength: 13, dexterity: 13, wisdom: 12),
    );

    expect(paladin.canSelect, isFalse);
    expect(ranger.canSelect, isFalse);
  });
}
