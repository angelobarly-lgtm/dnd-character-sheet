import 'character_data.dart';
import 'class_registry_data.dart';

const List<int> standardAsiClassLevels = [
  4,
  8,
  12,
  16,
  19,
];

const Map<String, List<int>> phb2014AsiClassLevels = {
  ClassIds.barbarian: standardAsiClassLevels,
  ClassIds.bard: standardAsiClassLevels,
  ClassIds.cleric: standardAsiClassLevels,
  ClassIds.druid: standardAsiClassLevels,
  ClassIds.fighter: [4, 6, 8, 12, 14, 16, 19],
  ClassIds.monk: standardAsiClassLevels,
  ClassIds.paladin: standardAsiClassLevels,
  ClassIds.ranger: standardAsiClassLevels,
  ClassIds.rogue: [4, 8, 10, 12, 16, 19],
  ClassIds.sorcerer: standardAsiClassLevels,
  ClassIds.warlock: standardAsiClassLevels,
  ClassIds.wizard: standardAsiClassLevels,
};

bool classReceivesAsiAtLevel(
  String classId,
  int classLevel,
) =>
    (phb2014AsiClassLevels[classId] ?? const []).contains(classLevel);

const Map<int, List<int>> phb2014MulticlassSpellSlots = {
  1: [2],
  2: [3],
  3: [4, 2],
  4: [4, 3],
  5: [4, 3, 2],
  6: [4, 3, 3],
  7: [4, 3, 3, 1],
  8: [4, 3, 3, 2],
  9: [4, 3, 3, 3, 1],
  10: [4, 3, 3, 3, 2],
  11: [4, 3, 3, 3, 2, 1],
  12: [4, 3, 3, 3, 2, 1],
  13: [4, 3, 3, 3, 2, 1, 1],
  14: [4, 3, 3, 3, 2, 1, 1],
  15: [4, 3, 3, 3, 2, 1, 1, 1],
  16: [4, 3, 3, 3, 2, 1, 1, 1],
  17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
  18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
  19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
  20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
};

bool classContributesToCombinedSpellSlots({
  required String classId,
  required int classLevel,
  String? subclassId,
}) {
  if (classLevel <= 0 || classId == ClassIds.warlock) {
    return false;
  }

  if (const {
    ClassIds.bard,
    ClassIds.cleric,
    ClassIds.druid,
    ClassIds.sorcerer,
    ClassIds.wizard,
  }.contains(classId)) {
    return true;
  }

  if (const {
    ClassIds.paladin,
    ClassIds.ranger,
  }.contains(classId)) {
    return classLevel >= 2;
  }

  if (classId == ClassIds.fighter) {
    return classLevel >= 3 && subclassId == 'eldritch_knight';
  }

  if (classId == ClassIds.rogue) {
    return classLevel >= 3 && subclassId == 'arcane_trickster';
  }

  return false;
}

int classSpellcasterLevelContribution({
  required String classId,
  required int classLevel,
  String? subclassId,
}) {
  if (!classContributesToCombinedSpellSlots(
    classId: classId,
    classLevel: classLevel,
    subclassId: subclassId,
  )) {
    return 0;
  }

  if (const {
    ClassIds.paladin,
    ClassIds.ranger,
  }.contains(classId)) {
    return classLevel ~/ 2;
  }

  if (classId == ClassIds.fighter || classId == ClassIds.rogue) {
    return classLevel ~/ 3;
  }

  return classLevel;
}

int multiclassSpellcasterLevel({
  required Map<String, int> classLevels,
  Map<String, String> classSubclasses = const {},
}) {
  return classLevels.entries.fold<int>(
    0,
    (total, entry) =>
        total +
        classSpellcasterLevelContribution(
          classId: entry.key,
          classLevel: entry.value,
          subclassId: classSubclasses[entry.key],
        ),
  );
}

int combinedSpellcastingClassCount({
  required Map<String, int> classLevels,
  Map<String, String> classSubclasses = const {},
}) {
  return classLevels.entries.where((entry) {
    return classContributesToCombinedSpellSlots(
      classId: entry.key,
      classLevel: entry.value,
      subclassId: classSubclasses[entry.key],
    );
  }).length;
}

List<int> multiclassSpellSlotsAtLevel(int casterLevel) {
  return List<int>.unmodifiable(
    phb2014MulticlassSpellSlots[casterLevel.clamp(0, 20).toInt()] ?? const [],
  );
}

Set<String> multiclassArmorProficienciesFor(
  String classId,
) {
  return switch (classId) {
    ClassIds.barbarian => const {'shield'},
    ClassIds.bard => const {'light_armor'},
    ClassIds.cleric => const {
        'light_armor',
        'medium_armor',
        'shield',
      },
    ClassIds.druid => const {
        'light_armor',
        'medium_armor',
        'shield',
      },
    ClassIds.fighter => const {
        'light_armor',
        'medium_armor',
        'shield',
      },
    ClassIds.monk => const {},
    ClassIds.paladin => const {
        'light_armor',
        'medium_armor',
        'shield',
      },
    ClassIds.ranger => const {
        'light_armor',
        'medium_armor',
        'shield',
      },
    ClassIds.rogue => const {'light_armor'},
    ClassIds.sorcerer => const {},
    ClassIds.warlock => const {'light_armor'},
    ClassIds.wizard => const {},
    _ => const {},
  };
}

Set<String> multiclassWeaponProficienciesFor(
  String classId,
) {
  return switch (classId) {
    ClassIds.barbarian ||
    ClassIds.fighter ||
    ClassIds.paladin ||
    ClassIds.ranger =>
      const {
        'simple_weapons',
        'martial_weapons',
      },
    ClassIds.bard => const {'simple_weapons'},
    ClassIds.monk => const {
        'simple_weapons',
        'shortsword',
      },
    ClassIds.rogue => const {
        'simple_weapons',
        'hand_crossbow',
        'longsword',
        'rapier',
        'shortsword',
      },
    ClassIds.warlock => const {'simple_weapons'},
    ClassIds.cleric ||
    ClassIds.druid ||
    ClassIds.sorcerer ||
    ClassIds.wizard =>
      const {},
    _ => const {},
  };
}

Set<String> multiclassToolProficienciesFor(
  String classId,
) {
  if (classId != ClassIds.rogue) return const {};

  return phbClassDefinitionFor(ClassIds.rogue)?.proficiencies.tools ?? const {};
}

int multiclassSkillChoicesFor(String classId) {
  return switch (classId) {
    ClassIds.bard || ClassIds.ranger || ClassIds.rogue => 1,
    _ => 0,
  };
}

Set<String> multiclassSkillOptionsFor(String classId) {
  return phbClassDefinitionFor(classId)?.proficiencies.skillOptions ?? const {};
}

int multiclassToolChoicesFor(String classId) =>
    classId == ClassIds.bard ? 1 : 0;

Set<String> multiclassToolOptionsFor(String classId) {
  if (classId != ClassIds.bard) return const {};

  final definition = phbClassDefinitionFor(classId);
  if (definition == null) return const {};

  for (final choice in definition.proficiencies.choices) {
    if (choice.type == ClassProficiencyChoiceType.tool) {
      return choice.optionIds;
    }
  }

  return const {};
}

bool multiclassRequiresProficiencyChoices(String classId) =>
    multiclassSkillChoicesFor(classId) > 0 ||
    multiclassToolChoicesFor(classId) > 0;

String multiclassSkillChoiceKey(String classId) =>
    'multiclass_${classId}_skills';

String multiclassToolChoiceKey(String classId) => 'multiclass_${classId}_tools';

/// Prerequisiti di multiclasse del Manuale del Giocatore 2014.
///
/// Per entrare in una nuova classe il personaggio deve soddisfare sia i
/// prerequisiti di tutte le classi che già possiede, sia quelli della nuova
/// classe.
const Map<String, List<CharacterRequirement>> phb2014MulticlassPrerequisites = {
  ClassIds.barbarian: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'FOR',
      minimum: 13,
      label: 'Forza 13',
    ),
  ],
  ClassIds.bard: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'CAR',
      minimum: 13,
      label: 'Carisma 13',
    ),
  ],
  ClassIds.cleric: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'SAG',
      minimum: 13,
      label: 'Saggezza 13',
    ),
  ],
  ClassIds.druid: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'SAG',
      minimum: 13,
      label: 'Saggezza 13',
    ),
  ],
  ClassIds.fighter: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'FOR_OR_DES',
      minimum: 13,
      label: 'Forza 13 oppure Destrezza 13',
    ),
  ],
  ClassIds.monk: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'DES',
      minimum: 13,
      label: 'Destrezza 13',
    ),
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'SAG',
      minimum: 13,
      label: 'Saggezza 13',
    ),
  ],
  ClassIds.paladin: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'FOR',
      minimum: 13,
      label: 'Forza 13',
    ),
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'CAR',
      minimum: 13,
      label: 'Carisma 13',
    ),
  ],
  ClassIds.ranger: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'DES',
      minimum: 13,
      label: 'Destrezza 13',
    ),
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'SAG',
      minimum: 13,
      label: 'Saggezza 13',
    ),
  ],
  ClassIds.rogue: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'DES',
      minimum: 13,
      label: 'Destrezza 13',
    ),
  ],
  ClassIds.sorcerer: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'CAR',
      minimum: 13,
      label: 'Carisma 13',
    ),
  ],
  ClassIds.warlock: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'CAR',
      minimum: 13,
      label: 'Carisma 13',
    ),
  ],
  ClassIds.wizard: [
    CharacterRequirement(
      type: CharacterRequirementType.minimumAbility,
      value: 'INT',
      minimum: 13,
      label: 'Intelligenza 13',
    ),
  ],
};

List<CharacterRequirement> multiclassRequirementsFor(
  String classId,
) =>
    phb2014MulticlassPrerequisites[classId] ?? const [];

class MulticlassClassEligibility {
  final String classId;
  final CharacterEligibilityResult eligibility;
  final bool targetClass;

  const MulticlassClassEligibility({
    required this.classId,
    required this.eligibility,
    this.targetClass = false,
  });
}

class MulticlassEligibilityResult {
  final List<MulticlassClassEligibility> classes;

  const MulticlassEligibilityResult({
    this.classes = const [],
  });

  bool get canSelect => classes.every(
        (entry) => entry.eligibility.canSelect,
      );

  MulticlassClassEligibility? forClass(String classId) {
    for (final entry in classes) {
      if (entry.classId == classId) return entry;
    }

    return null;
  }
}

MulticlassEligibilityResult evaluateMulticlassEligibility({
  required Iterable<String> existingClassIds,
  required String targetClassId,
  required CharacterEligibilityState state,
}) {
  final classIds = <String>[
    ...existingClassIds.where(
      (classId) => classId != targetClassId,
    ),
    targetClassId,
  ];

  return MulticlassEligibilityResult(
    classes: [
      for (final classId in classIds)
        MulticlassClassEligibility(
          classId: classId,
          targetClass: classId == targetClassId,
          eligibility: evaluateCharacterEligibility(
            requirements: multiclassRequirementsFor(classId),
            state: state,
          ),
        ),
    ],
  );
}
