import 'character_data.dart';
import 'class_data.dart';

class ClassIds {
  static const barbarian = 'barbarian';
  static const bard = 'bard';
  static const cleric = 'cleric';
  static const druid = 'druid';
  static const fighter = 'fighter';
  static const monk = 'monk';
  static const paladin = 'paladin';
  static const ranger = 'ranger';
  static const rogue = 'rogue';
  static const sorcerer = 'sorcerer';
  static const warlock = 'warlock';
  static const wizard = 'wizard';
}

const phbClassIds = <String>{
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
};

enum ClassSpellcastingProgression {
  none,
  full,
  half,
  third,
  pact,
}

enum ClassResourceRecovery {
  shortRest,
  longRest,
  dawn,
  special,
}

enum ClassProficiencyChoiceType {
  skill,
  tool,
  weapon,
  armor,
  language,
}

class ClassProficiencyChoiceDefinition {
  final String id;
  final String label;
  final ClassProficiencyChoiceType type;
  final Set<String> optionIds;
  final int selections;
  final bool requireNewAcquisition;

  const ClassProficiencyChoiceDefinition({
    required this.id,
    required this.label,
    required this.type,
    required this.optionIds,
    required this.selections,
    this.requireNewAcquisition = true,
  }) : assert(selections > 0);
}

class ClassProficiencyDefinition {
  final Set<String> armor;
  final Set<String> weapons;
  final Set<String> tools;
  final Set<String> savingThrows;
  final Set<String> skillOptions;
  final int skillChoices;

  /// Scelte di competenza strutturate.
  ///
  /// `skillOptions` e `skillChoices` restano disponibili durante la
  /// migrazione delle vecchie schermate.
  final List<ClassProficiencyChoiceDefinition> choices;

  const ClassProficiencyDefinition({
    this.armor = const {},
    this.weapons = const {},
    this.tools = const {},
    this.savingThrows = const {},
    this.skillOptions = const {},
    this.skillChoices = 0,
    this.choices = const [],
  }) : assert(skillChoices >= 0);
}

class ClassEquipmentGrant {
  final String catalogId;
  final String itemId;
  final int quantity;

  const ClassEquipmentGrant({
    required this.catalogId,
    required this.itemId,
    this.quantity = 1,
  }) : assert(quantity > 0);
}

/// Una singola alternativa può concedere più oggetti insieme.
///
/// Esempio: armatura di cuoio, arco lungo e 20 frecce.
class ClassEquipmentAlternative {
  final String id;
  final String label;
  final List<ClassEquipmentGrant> grants;

  /// Competenze necessarie per selezionare questa alternativa.
  ///
  /// Esempi: arma da guerra o armatura pesante concessa dal dominio.
  final Set<String> requiredProficiencyIds;

  const ClassEquipmentAlternative({
    required this.id,
    required this.label,
    required this.grants,
    this.requiredProficiencyIds = const {},
  });
}

/// Gruppo di alternative tra cui il giocatore deve effettuare una scelta.
class ClassEquipmentChoice {
  final String id;
  final String label;
  final List<ClassEquipmentAlternative> alternatives;
  final int selections;

  const ClassEquipmentChoice({
    required this.id,
    required this.label,
    required this.alternatives,
    this.selections = 1,
  }) : assert(selections > 0);
}

class ClassResourceDefinition {
  final String id;
  final String name;
  final int minimumLevel;
  final ClassResourceRecovery recovery;

  /// Valore massimo ai livelli in cui cambia.
  ///
  /// `maximumAtLevel` conserva l’ultimo valore disponibile fino al
  /// successivo livello presente nella tabella.
  final Map<int, int> maximumByLevel;

  /// Livello dal quale la risorsa non possiede più un limite massimo.
  ///
  /// Il valore numerico progressivo rimane disponibile come riferimento,
  /// mentre [isUnlimitedAtLevel] identifica lo stato illimitato.
  final int? unlimitedFromLevel;

  /// Caratteristica che determina il massimo della risorsa.
  ///
  /// Esempio: l’Ispirazione Bardica usa il modificatore di Carisma.
  final String? maximumAbility;

  /// Minimo applicato alle risorse basate su una caratteristica.
  final int minimumMaximum;

  /// Cambiamenti del tipo di recupero durante la progressione.
  final Map<int, ClassResourceRecovery> recoveryByLevel;

  const ClassResourceDefinition({
    required this.id,
    required this.name,
    required this.minimumLevel,
    required this.recovery,
    required this.maximumByLevel,
    this.unlimitedFromLevel,
    this.maximumAbility,
    this.minimumMaximum = 0,
    this.recoveryByLevel = const {},
  })  : assert(minimumLevel > 0),
        assert(unlimitedFromLevel == null || unlimitedFromLevel > 0),
        assert(minimumMaximum >= 0);

  bool isUnlimitedAtLevel(int level) =>
      unlimitedFromLevel != null && level >= unlimitedFromLevel!;

  ClassResourceRecovery recoveryAtLevel(int level) {
    var result = recovery;

    for (final entry in recoveryByLevel.entries) {
      if (entry.key <= level) result = entry.value;
    }

    return result;
  }

  int maximumAtLevel(
    int level, {
    Map<String, int> abilityModifiers = const {},
  }) {
    if (level < minimumLevel) return 0;

    if (maximumAbility != null) {
      final abilityMaximum = abilityModifiers[maximumAbility] ?? minimumMaximum;

      return abilityMaximum < minimumMaximum ? minimumMaximum : abilityMaximum;
    }

    var maximum = 0;

    for (final entry in maximumByLevel.entries) {
      if (entry.key <= level && entry.value >= 0) {
        maximum = entry.value;
      }
    }

    return maximum;
  }
}

class ClassSpellcastingDefinition {
  final ClassSpellcastingProgression progression;
  final String ability;
  final int minimumLevel;
  final bool ritualCasting;
  final bool preparesSpells;

  /// Slot per livello dell’incantesimo, indicizzati dal livello di classe.
  final Map<int, List<int>> slotsByClassLevel;

  final Map<int, int> cantripsKnownByLevel;
  final Map<int, int> spellsKnownByLevel;

  /// Incantesimi appartenenti alla lista della classe.
  final Set<String> spellIds;

  /// Divisore applicato al livello di classe nel calcolo degli
  /// incantesimi preparati.
  ///
  /// 1 per Chierico, Druido e Mago; 2 per Paladino.
  final int preparedSpellLevelDivisor;

  /// Numero minimo di incantesimi preparabili.
  final int minimumPreparedSpells;

  /// Livello degli slot del Patto Magico per ogni livello di classe.
  final Map<int, int> pactSlotLevelByClassLevel;

  const ClassSpellcastingDefinition({
    required this.progression,
    required this.ability,
    required this.minimumLevel,
    this.ritualCasting = false,
    this.preparesSpells = false,
    this.slotsByClassLevel = const {},
    this.cantripsKnownByLevel = const {},
    this.spellsKnownByLevel = const {},
    this.spellIds = const {},
    this.preparedSpellLevelDivisor = 1,
    this.minimumPreparedSpells = 1,
    this.pactSlotLevelByClassLevel = const {},
  })  : assert(minimumLevel > 0),
        assert(preparedSpellLevelDivisor > 0),
        assert(minimumPreparedSpells >= 0);

  List<int> slotsAtLevel(int level) =>
      List<int>.unmodifiable(slotsByClassLevel[level] ?? const []);

  int _progressiveValue(Map<int, int> values, int level) {
    var result = 0;

    for (final entry in values.entries) {
      if (entry.key <= level) result = entry.value;
    }

    return result;
  }

  int cantripsKnownAtLevel(int level) =>
      _progressiveValue(cantripsKnownByLevel, level);

  int spellsKnownAtLevel(int level) =>
      _progressiveValue(spellsKnownByLevel, level);

  int pactSlotLevelAtLevel(int level) =>
      _progressiveValue(pactSlotLevelByClassLevel, level);

  int preparedSpellsAtLevel(
    int level, {
    Map<String, int> abilityModifiers = const {},
  }) {
    if (!preparesSpells || level < minimumLevel) return 0;

    final classContribution = level ~/ preparedSpellLevelDivisor;
    final abilityContribution = abilityModifiers[ability] ?? 0;
    final total = classContribution + abilityContribution;

    return total < minimumPreparedSpells ? minimumPreparedSpells : total;
  }
}

class CharacterClassFeatureDefinition {
  final String id;
  final RuleContent content;
  final Set<String> ruleTags;
  final String? resourceId;

  /// Incantesimi concessi o lanciabili direttamente dal privilegio.
  ///
  /// Gli ID fanno riferimento al catalogo universale degli incantesimi.
  final Set<String> spellIds;

  /// Scelte richieste direttamente dal privilegio.
  ///
  /// Esempi: Maestria, Segreti Magici e competenze bonus.
  final List<CharacterChoiceDefinition> choices;

  /// Effetti permanenti applicati direttamente dal privilegio.
  ///
  /// Consente, per esempio, di concedere competenze in armature,
  /// armi, strumenti o abilità senza hardcoding nel runtime.
  final CharacterEffects effects;

  const CharacterClassFeatureDefinition({
    required this.id,
    required this.content,
    this.ruleTags = const {},
    this.resourceId,
    this.spellIds = const {},
    this.choices = const [],
    this.effects = const CharacterEffects(),
  });
}

class CharacterSubclassDefinition {
  final String id;
  final String name;
  final String classId;
  final RuleContent content;
  final Map<int, List<String>> featuresByLevel;
  final Map<String, CharacterClassFeatureDefinition> featureDefinitions;

  /// Incantesimi di sottoclasse sempre preparati, indicizzati dal livello
  /// minimo della classe in cui diventano disponibili.
  final Map<int, Set<String>> alwaysPreparedSpellIdsByLevel;

  /// Risorse consumabili concesse esclusivamente dalla sottoclasse.
  ///
  /// Esempi: Interdizione Luminosa del Dominio della Luce e Prete
  /// della Guerra del Dominio della Guerra.
  final List<ClassResourceDefinition> resources;

  /// Recuperi degli slot concessi dalla sottoclasse.
  final List<ClassSpellSlotRecoveryDefinition> spellSlotRecoveries;

  /// Trasformazioni concesse o modificate dalla sottoclasse.
  final List<ClassTransformationDefinition> transformations;

  final bool homebrew;
  final bool supplemental;

  const CharacterSubclassDefinition({
    required this.id,
    required this.name,
    required this.classId,
    required this.content,
    required this.featuresByLevel,
    required this.featureDefinitions,
    this.alwaysPreparedSpellIdsByLevel = const {},
    this.resources = const [],
    this.spellSlotRecoveries = const [],
    this.transformations = const [],
    this.options = const [],
    this.optionProgression,
    this.homebrew = false,
    this.supplemental = false,
  });

  Set<String> alwaysPreparedSpellIdsAtLevel(int level) {
    final result = <String>{};

    for (final entry in alwaysPreparedSpellIdsByLevel.entries) {
      if (entry.key <= level) {
        result.addAll(entry.value);
      }
    }

    return Set<String>.unmodifiable(result);
  }

  final List<SubclassOptionDefinition> options;
  final SubclassOptionProgression? optionProgression;
}

class ClassSpellSlotRecoveryDefinition {
  final String id;
  final String name;
  final int minimumLevel;
  final String resourceId;
  final int classLevelDivisor;
  final bool roundUp;
  final int maximumSlotLevel;
  final bool requiresShortRest;

  const ClassSpellSlotRecoveryDefinition({
    required this.id,
    required this.name,
    required this.minimumLevel,
    required this.resourceId,
    required this.classLevelDivisor,
    this.roundUp = false,
    required this.maximumSlotLevel,
    this.requiresShortRest = false,
  })  : assert(minimumLevel > 0),
        assert(classLevelDivisor > 0),
        assert(maximumSlotLevel > 0);

  int maximumCombinedSlotLevelsAtLevel(int level) {
    if (level < minimumLevel) return 0;

    if (roundUp) {
      return (level + classLevelDivisor - 1) ~/ classLevelDivisor;
    }

    return level ~/ classLevelDivisor;
  }

  bool canRecoverSlotLevel(int slotLevel) =>
      slotLevel > 0 && slotLevel <= maximumSlotLevel;
}

enum ClassTransformationAction {
  action,
  bonusAction,
}

class ClassTransformationDefinition {
  final String id;
  final String name;
  final int minimumLevel;
  final String resourceId;
  final int resourceCost;
  final ClassTransformationAction action;
  final int durationHoursLevelDivisor;
  final Map<int, double> maximumChallengeRatingByLevel;
  final int? swimmingSpeedMinimumLevel;
  final int? flyingSpeedMinimumLevel;
  final int? spellcastingMinimumLevel;
  final Set<String> allowedCreatureTypes;
  final Set<String> fixedFormIds;
  final bool retainsMentalAbilityScores;
  final bool retainsAlignmentAndPersonality;

  const ClassTransformationDefinition({
    required this.id,
    required this.name,
    required this.minimumLevel,
    required this.resourceId,
    this.resourceCost = 1,
    this.action = ClassTransformationAction.action,
    required this.durationHoursLevelDivisor,
    required this.maximumChallengeRatingByLevel,
    this.swimmingSpeedMinimumLevel,
    this.flyingSpeedMinimumLevel,
    this.spellcastingMinimumLevel,
    this.allowedCreatureTypes = const {},
    this.fixedFormIds = const {},
    this.retainsMentalAbilityScores = true,
    this.retainsAlignmentAndPersonality = true,
  })  : assert(minimumLevel > 0),
        assert(resourceCost > 0),
        assert(durationHoursLevelDivisor > 0);

  double maximumChallengeRatingAtLevel(int level) {
    if (level < minimumLevel) return 0;

    var result = 0.0;

    for (final entry in maximumChallengeRatingByLevel.entries) {
      if (entry.key <= level) result = entry.value;
    }

    return result;
  }

  int durationHoursAtLevel(int level) {
    if (level < minimumLevel) return 0;
    return level ~/ durationHoursLevelDivisor;
  }

  bool allowsSwimmingSpeedAtLevel(int level) =>
      swimmingSpeedMinimumLevel != null && level >= swimmingSpeedMinimumLevel!;

  bool allowsFlyingSpeedAtLevel(int level) =>
      flyingSpeedMinimumLevel != null && level >= flyingSpeedMinimumLevel!;

  bool allowsSpellcastingAtLevel(int level) =>
      spellcastingMinimumLevel != null && level >= spellcastingMinimumLevel!;
}

class ClassProgressionValueDefinition {
  final String id;
  final String name;

  /// Valori ai livelli in cui cambiano.
  ///
  /// Il tipo String permette di rappresentare numeri, dadi e misure
  /// senza perdere la notazione regolamentare.
  final Map<int, String> valuesByLevel;

  const ClassProgressionValueDefinition({
    required this.id,
    required this.name,
    required this.valuesByLevel,
  });

  String? valueAtLevel(int level) {
    String? result;

    for (final entry in valuesByLevel.entries) {
      if (entry.key <= level) result = entry.value;
    }

    return result;
  }
}

class CharacterClassDefinition {
  final String id;
  final String name;
  final RuleContent content;
  final int hitDie;
  final ClassProficiencyDefinition proficiencies;
  final List<ClassEquipmentChoice> startingEquipmentChoices;
  final List<ClassEquipmentGrant> fixedStartingEquipment;
  final Map<int, List<String>> featuresByLevel;
  final Map<String, CharacterClassFeatureDefinition> featureDefinitions;
  final List<ClassResourceDefinition> resources;
  final List<ClassSpellSlotRecoveryDefinition> spellSlotRecoveries;
  final List<ClassTransformationDefinition> transformations;
  final List<ClassProgressionValueDefinition> progressionValues;
  final ClassSpellcastingDefinition? spellcasting;
  final int subclassSelectionLevel;
  final Map<String, CharacterSubclassDefinition> subclasses;
  final bool homebrew;

  const CharacterClassDefinition({
    required this.id,
    required this.name,
    required this.content,
    required this.hitDie,
    required this.proficiencies,
    required this.featuresByLevel,
    required this.featureDefinitions,
    required this.subclassSelectionLevel,
    this.startingEquipmentChoices = const [],
    this.fixedStartingEquipment = const [],
    this.resources = const [],
    this.spellSlotRecoveries = const [],
    this.transformations = const [],
    this.progressionValues = const [],
    this.spellcasting,
    this.subclasses = const {},
    this.homebrew = false,
  })  : assert(hitDie > 0),
        assert(subclassSelectionLevel > 0);

  List<String> featuresAtLevel(int level) =>
      List<String>.unmodifiable(featuresByLevel[level] ?? const []);

  String? progressionValue(String id, int level) {
    for (final definition in progressionValues) {
      if (definition.id == id) {
        return definition.valueAtLevel(level);
      }
    }

    return null;
  }

  ClassTransformationDefinition? transformationFor(
    String transformationId, {
    String? subclassId,
  }) {
    if (subclassId != null) {
      final subclass = subclasses[subclassId];

      if (subclass != null) {
        for (final transformation in subclass.transformations) {
          if (transformation.id == transformationId) {
            return transformation;
          }
        }
      }
    }

    for (final transformation in transformations) {
      if (transformation.id == transformationId) {
        return transformation;
      }
    }

    return null;
  }

  Iterable<CharacterSubclassDefinition> get phbSubclasses =>
      subclasses.values.where(
        (subclass) => !subclass.homebrew && !subclass.supplemental,
      );

  Iterable<CharacterSubclassDefinition> get supplementalSubclasses =>
      subclasses.values.where((subclass) => subclass.supplemental);
}
