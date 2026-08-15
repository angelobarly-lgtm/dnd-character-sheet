enum CreatureSize {
  tiny,
  small,
  medium,
  large,
  huge,
  gargantuan,
}

enum CreatureType {
  aberration,
  beast,
  celestial,
  construct,
  dragon,
  elemental,
  fey,
  fiend,
  giant,
  humanoid,
  monstrosity,
  ooze,
  plant,
  undead,
}

enum CreatureMovementType {
  walking,
  burrowing,
  climbing,
  flying,
  swimming,
}

enum CreatureSenseType {
  blindsight,
  darkvision,
  tremorsense,
  truesight,
}

enum CreatureActionType {
  action,
  bonusAction,
  reaction,
  legendaryAction,
  lairAction,
}

enum CreatureAttackType {
  meleeWeapon,
  rangedWeapon,
  meleeSpell,
  rangedSpell,
}

enum BestiaryContentOrigin {
  official,
  supplemental,
  homebrew,
}

enum CreatureEnvironment {
  arctic,
  coastal,
  desert,
  forest,
  grassland,
  hill,
  mountain,
  swamp,
  underdark,
  underwater,
  urban,
  dungeon,
  extraplanar,
}

enum CreatureDamageResponseType {
  vulnerability,
  resistance,
  immunity,
}

enum CreatureCommunicationType {
  language,
  telepathy,
  understandsOnly,
}

class BestiarySourceDefinition {
  final String book;
  final String edition;
  final String reference;
  final int? pageStart;
  final int? pageEnd;
  final String? section;

  const BestiarySourceDefinition({
    required this.book,
    required this.edition,
    required this.reference,
    this.pageStart,
    this.pageEnd,
    this.section,
  })  : assert(pageStart == null || pageStart > 0),
        assert(pageEnd == null || pageEnd > 0),
        assert(
          pageStart == null || pageEnd == null || pageEnd >= pageStart,
        );

  String get pageLabel {
    if (pageStart == null) {
      return reference;
    }
    if (pageEnd == null || pageEnd == pageStart) {
      return 'p. $pageStart';
    }
    return 'pp. $pageStart-$pageEnd';
  }
}

class CreatureAbilityScores {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const CreatureAbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  int scoreFor(String ability) {
    return switch (ability) {
      'FOR' => strength,
      'DES' => dexterity,
      'COS' => constitution,
      'INT' => intelligence,
      'SAG' => wisdom,
      'CAR' => charisma,
      _ => throw ArgumentError.value(
          ability,
          'ability',
          'Caratteristica non riconosciuta',
        ),
    };
  }

  int modifierFor(String ability) => ((scoreFor(ability) - 10) / 2).floor();
}

class CreatureArmorClassDefinition {
  final int value;
  final String? description;

  const CreatureArmorClassDefinition({
    required this.value,
    this.description,
  });
}

class CreatureHitPointsDefinition {
  final int average;
  final int diceCount;
  final int dieSize;
  final int modifier;

  const CreatureHitPointsDefinition({
    required this.average,
    required this.diceCount,
    required this.dieSize,
    this.modifier = 0,
  })  : assert(average > 0),
        assert(diceCount > 0),
        assert(dieSize > 0);

  String get formula {
    if (modifier == 0) {
      return '${diceCount}d$dieSize';
    }
    final sign = modifier > 0 ? '+' : '-';
    return '${diceCount}d$dieSize $sign ${modifier.abs()}';
  }
}

class CreatureMovementDefinition {
  final CreatureMovementType type;
  final double meters;
  final bool hover;
  final String? condition;

  const CreatureMovementDefinition({
    required this.type,
    required this.meters,
    this.hover = false,
    this.condition,
  }) : assert(meters >= 0);
}

class CreatureSenseDefinition {
  final CreatureSenseType type;
  final double meters;

  const CreatureSenseDefinition({
    required this.type,
    required this.meters,
  }) : assert(meters >= 0);
}

class CreatureDamageDefinition {
  final String damageType;
  final int? average;
  final int diceCount;
  final int dieSize;
  final int modifier;
  final String? condition;

  const CreatureDamageDefinition({
    required this.damageType,
    this.average,
    required this.diceCount,
    required this.dieSize,
    this.modifier = 0,
    this.condition,
  })  : assert(average == null || average >= 0),
        assert(diceCount >= 0),
        assert(dieSize >= 0);

  String get formula {
    final dice = diceCount == 0 ? '' : '${diceCount}d$dieSize';
    if (modifier == 0) {
      return dice.isEmpty ? '0' : dice;
    }
    if (dice.isEmpty) {
      return '$modifier';
    }
    final sign = modifier > 0 ? '+' : '-';
    return '$dice $sign ${modifier.abs()}';
  }
}

class CreatureSavingThrowDefinition {
  final String ability;
  final int difficultyClass;
  final String? success;
  final String? failure;

  const CreatureSavingThrowDefinition({
    required this.ability,
    required this.difficultyClass,
    this.success,
    this.failure,
  }) : assert(difficultyClass > 0);
}

class CreatureAttackDefinition {
  final CreatureAttackType type;
  final int attackBonus;
  final double? reachMeters;
  final double? normalRangeMeters;
  final double? longRangeMeters;
  final String target;
  final List<CreatureDamageDefinition> damages;

  const CreatureAttackDefinition({
    required this.type,
    required this.attackBonus,
    this.reachMeters,
    this.normalRangeMeters,
    this.longRangeMeters,
    required this.target,
    required this.damages,
  });

  bool get hasDamage => damages.isNotEmpty;
}

class CreatureRuleDefinition {
  final String id;
  final String name;
  final String description;
  final Set<String> tags;
  final String? recharge;
  final int? uses;
  final List<CreatureEffectDefinition> effects;
  final CreatureAttackDefinition? attack;
  final CreatureSavingThrowDefinition? savingThrow;

  const CreatureRuleDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.tags = const {},
    this.recharge,
    this.uses,
    this.effects = const [],
    this.attack,
    this.savingThrow,
  }) : assert(uses == null || uses >= 0);
}

class CreatureActionDefinition {
  final String id;
  final String name;
  final CreatureActionType type;
  final String description;
  final int legendaryActionCost;
  final Set<String> tags;
  final String? recharge;
  final int? uses;
  final List<CreatureEffectDefinition> effects;
  final CreatureAttackDefinition? attack;
  final CreatureSavingThrowDefinition? savingThrow;

  const CreatureActionDefinition({
    required this.id,
    required this.name,
    this.type = CreatureActionType.action,
    required this.description,
    this.legendaryActionCost = 0,
    this.tags = const {},
    this.recharge,
    this.uses,
    this.effects = const [],
    this.attack,
    this.savingThrow,
  })  : assert(legendaryActionCost >= 0),
        assert(uses == null || uses >= 0);
}

class CreatureSpellcastingDefinition {
  final String ability;
  final int? spellSaveDifficultyClass;
  final int? spellAttackBonus;
  final int? casterLevel;
  final Set<String> atWillSpellIds;
  final Map<int, Set<String>> spellIdsByLevel;
  final Map<int, int> slotsByLevel;
  final Map<String, int> limitedUsesBySpellId;
  final bool innate;
  final bool requiresComponents;

  const CreatureSpellcastingDefinition({
    required this.ability,
    this.spellSaveDifficultyClass,
    this.spellAttackBonus,
    this.casterLevel,
    this.atWillSpellIds = const {},
    this.spellIdsByLevel = const {},
    this.slotsByLevel = const {},
    this.limitedUsesBySpellId = const {},
    this.innate = false,
    this.requiresComponents = true,
  });

  Set<String> get allSpellIds => {
        ...atWillSpellIds,
        ...spellIdsByLevel.values.expand((ids) => ids),
        ...limitedUsesBySpellId.keys,
      };
}

class CreatureCommunicationDefinition {
  final CreatureCommunicationType type;
  final String value;
  final double? rangeMeters;
  final String? condition;

  const CreatureCommunicationDefinition({
    required this.type,
    required this.value,
    this.rangeMeters,
    this.condition,
  }) : assert(rangeMeters == null || rangeMeters >= 0);
}

class CreatureDamageInteractionDefinition {
  final CreatureDamageResponseType response;
  final Set<String> damageTypes;
  final String? condition;
  final Set<String> bypassedBy;

  const CreatureDamageInteractionDefinition({
    required this.response,
    required this.damageTypes,
    this.condition,
    this.bypassedBy = const {},
  });
}

class CreatureEffectDefinition {
  final String id;
  final String target;
  final String? condition;
  final String? duration;
  final Map<String, num> numericValues;
  final Set<String> referenceIds;
  final Set<String> tags;

  const CreatureEffectDefinition({
    required this.id,
    required this.target,
    this.condition,
    this.duration,
    this.numericValues = const {},
    this.referenceIds = const {},
    this.tags = const {},
  });
}

class CreatureMultiattackOptionDefinition {
  final String id;
  final String description;
  final Map<String, int> actionUses;

  const CreatureMultiattackOptionDefinition({
    required this.id,
    required this.description,
    required this.actionUses,
  });
}

class CreatureMultiattackDefinition {
  final String id;
  final String name;
  final String description;
  final List<CreatureMultiattackOptionDefinition> options;

  const CreatureMultiattackDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });

  Set<String> get referencedActionIds =>
      options.expand((option) => option.actionUses.keys).toSet();
}

class CreatureVariantDefinition {
  final String id;
  final String name;
  final String description;
  final BestiarySourceDefinition? source;
  final Set<String> addedTags;
  final Set<String> removedTags;
  final Set<String> replacementRuleIds;

  const CreatureVariantDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.source,
    this.addedTags = const {},
    this.removedTags = const {},
    this.replacementRuleIds = const {},
  });
}

class CreatureRegionalEffectDefinition {
  final String id;
  final String name;
  final String description;
  final double? radiusMeters;
  final String? endingCondition;

  const CreatureRegionalEffectDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.radiusMeters,
    this.endingCondition,
  }) : assert(radiusMeters == null || radiusMeters >= 0);
}

class CreatureLairDefinition {
  final String description;
  final int? initiativeCount;
  final bool initiativeLosesTies;
  final List<CreatureActionDefinition> actions;
  final List<CreatureRegionalEffectDefinition> regionalEffects;

  const CreatureLairDefinition({
    required this.description,
    this.initiativeCount,
    this.initiativeLosesTies = true,
    this.actions = const [],
    this.regionalEffects = const [],
  }) : assert(initiativeCount == null || initiativeCount >= 0);
}

class BestiaryCreatureGroupDefinition {
  final String id;
  final String name;
  final BestiarySourceDefinition source;
  final Set<String> creatureIds;
  final String description;

  const BestiaryCreatureGroupDefinition({
    required this.id,
    required this.name,
    required this.source,
    required this.creatureIds,
    required this.description,
  });

  bool containsCreature(String creatureId) => creatureIds.contains(creatureId);
}

class CreatureDefinition {
  final String id;
  final String name;
  final Set<String> aliases;
  final BestiarySourceDefinition source;
  final List<BestiarySourceDefinition> additionalSources;
  final BestiaryContentOrigin origin;
  final CreatureSize size;
  final CreatureType type;
  final Set<String> subtypes;
  final CreatureSize? swarmOfSize;
  final Set<String> tags;
  final String alignment;
  final CreatureArmorClassDefinition armorClass;
  final List<CreatureArmorClassDefinition> alternativeArmorClasses;
  final CreatureHitPointsDefinition hitPoints;
  final CreatureAbilityScores abilities;
  final List<CreatureMovementDefinition> movements;
  final Map<String, int> savingThrowBonuses;
  final Map<String, int> skillBonuses;
  final Set<String> damageVulnerabilities;
  final Set<String> damageResistances;
  final Set<String> damageImmunities;
  final List<CreatureDamageInteractionDefinition> conditionalDamageInteractions;
  final Set<String> conditionImmunities;
  final List<CreatureSenseDefinition> senses;
  final int passivePerception;
  final Set<String> languages;
  final List<CreatureCommunicationDefinition> communications;
  final Set<CreatureEnvironment> environments;
  final double challengeRating;
  final int experiencePoints;
  final int proficiencyBonus;
  final List<CreatureRuleDefinition> traits;
  final List<CreatureActionDefinition> actions;
  final List<CreatureActionDefinition> bonusActions;
  final List<CreatureActionDefinition> reactions;
  final int legendaryActionUses;
  final List<CreatureActionDefinition> legendaryActions;
  final CreatureLairDefinition? lair;
  final List<CreatureSpellcastingDefinition> spellcasting;
  final List<CreatureMultiattackDefinition> multiattacks;
  final List<CreatureVariantDefinition> variants;
  final String? description;

  const CreatureDefinition({
    required this.id,
    required this.name,
    this.aliases = const {},
    required this.source,
    this.additionalSources = const [],
    this.origin = BestiaryContentOrigin.official,
    required this.size,
    required this.type,
    this.subtypes = const {},
    this.swarmOfSize,
    this.tags = const {},
    required this.alignment,
    required this.armorClass,
    this.alternativeArmorClasses = const [],
    required this.hitPoints,
    required this.abilities,
    required this.movements,
    this.savingThrowBonuses = const {},
    this.skillBonuses = const {},
    this.damageVulnerabilities = const {},
    this.damageResistances = const {},
    this.damageImmunities = const {},
    this.conditionalDamageInteractions = const [],
    this.conditionImmunities = const {},
    this.senses = const [],
    required this.passivePerception,
    this.languages = const {},
    this.communications = const [],
    this.environments = const {},
    required this.challengeRating,
    required this.experiencePoints,
    required this.proficiencyBonus,
    this.traits = const [],
    this.actions = const [],
    this.bonusActions = const [],
    this.reactions = const [],
    this.legendaryActionUses = 0,
    this.legendaryActions = const [],
    this.lair,
    this.spellcasting = const [],
    this.multiattacks = const [],
    this.variants = const [],
    this.description,
  })  : assert(challengeRating >= 0),
        assert(experiencePoints >= 0),
        assert(proficiencyBonus >= 0),
        assert(passivePerception >= 0),
        assert(legendaryActionUses >= 0);

  List<CreatureArmorClassDefinition> get armorClasses => [
        armorClass,
        ...alternativeArmorClasses,
      ];

  Iterable<CreatureActionDefinition> get allActions sync* {
    yield* actions;
    yield* bonusActions;
    yield* reactions;
    yield* legendaryActions;
    if (lair != null) {
      yield* lair!.actions;
    }
  }

  CreatureActionDefinition? actionFor(String actionId) {
    for (final action in allActions) {
      if (action.id == actionId) {
        return action;
      }
    }
    return null;
  }

  Set<String> get unresolvedMultiattackActionIds {
    final availableActionIds = allActions.map((action) => action.id).toSet();
    final referencedActionIds = multiattacks
        .expand((multiattack) => multiattack.referencedActionIds)
        .toSet();

    return referencedActionIds.difference(availableActionIds);
  }

  double? movementFor(CreatureMovementType type) {
    for (final movement in movements) {
      if (movement.type == type) {
        return movement.meters;
      }
    }
    return null;
  }

  bool get isSwarm => swarmOfSize != null;

  bool get hasSwimmingSpeed =>
      movementFor(CreatureMovementType.swimming) != null;

  bool get hasFlyingSpeed => movementFor(CreatureMovementType.flying) != null;

  bool get hasSpellcasting => spellcasting.isNotEmpty;

  bool get hasLegendaryActions => legendaryActions.isNotEmpty;

  bool get hasLair => lair != null;

  bool get homebrew => origin == BestiaryContentOrigin.homebrew;

  bool get supplemental => origin == BestiaryContentOrigin.supplemental;
}

abstract final class BestiaryCreatureIds {
  static const airElemental = 'air_elemental';
  static const earthElemental = 'earth_elemental';
  static const fireElemental = 'fire_elemental';
  static const waterElemental = 'water_elemental';

  static const imp = 'imp';
  static const pseudodragon = 'pseudodragon';
  static const quasit = 'quasit';
  static const sprite = 'sprite';

  static const modron = 'modron';
  static const monodrone = 'monodrone';
  static const duodrone = 'duodrone';
  static const tridrone = 'tridrone';
  static const quadrone = 'quadrone';
  static const pentadrone = 'pentadrone';
  static const flumph = 'flumph';
  static const unicorn = 'unicorn';
}

const classRequiredBestiaryCreatureIds = <String>{
  BestiaryCreatureIds.airElemental,
  BestiaryCreatureIds.earthElemental,
  BestiaryCreatureIds.fireElemental,
  BestiaryCreatureIds.waterElemental,
  BestiaryCreatureIds.imp,
  BestiaryCreatureIds.pseudodragon,
  BestiaryCreatureIds.quasit,
  BestiaryCreatureIds.sprite,
  BestiaryCreatureIds.modron,
  BestiaryCreatureIds.flumph,
  BestiaryCreatureIds.unicorn,
};
