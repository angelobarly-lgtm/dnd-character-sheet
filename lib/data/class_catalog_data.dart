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

class ClassEquipmentItemChoice {
  final String id;
  final String label;
  final String catalogId;
  final Set<String> optionIds;
  final int selections;

  /// Permette di scegliere più volte lo stesso oggetto.
  ///
  /// Serve, per esempio, alla dotazione del Guerriero che consente
  /// di scegliere due armi da guerra anche dello stesso tipo.
  final bool allowDuplicates;

  const ClassEquipmentItemChoice({
    required this.id,
    required this.label,
    required this.catalogId,
    required this.optionIds,
    this.selections = 1,
    this.allowDuplicates = false,
  }) : assert(selections > 0);
}

/// Una singola alternativa può concedere più oggetti insieme.
///
/// Esempio: armatura di cuoio, arco lungo e 20 frecce.
class ClassEquipmentAlternative {
  final String id;
  final String label;
  final List<ClassEquipmentGrant> grants;

  /// Oggetti che devono essere scelti all’interno dell’alternativa.
  final List<ClassEquipmentItemChoice> itemChoices;

  /// Competenze necessarie per selezionare questa alternativa.
  ///
  /// Esempi: arma da guerra o armatura pesante concessa dal dominio.
  final Set<String> requiredProficiencyIds;

  const ClassEquipmentAlternative({
    required this.id,
    required this.label,
    required this.grants,
    this.itemChoices = const [],
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

  /// Valore fisso aggiunto alla formula del massimo.
  ///
  /// Permette di rappresentare formule come 1 + modificatore di Carisma.
  final int baseMaximum;

  /// Contributo del livello di classe al massimo della risorsa.
  final int classLevelMultiplier;

  /// Modificatore di caratteristica aggiunto al massimo della risorsa.
  ///
  /// È distinto da [maximumAbility], che determina direttamente
  /// il numero di utilizzi di una risorsa.
  final String? additionalMaximumAbility;

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
    this.baseMaximum = 0,
    this.classLevelMultiplier = 0,
    this.additionalMaximumAbility,
    this.recoveryByLevel = const {},
  })  : assert(minimumLevel > 0),
        assert(unlimitedFromLevel == null || unlimitedFromLevel > 0),
        assert(minimumMaximum >= 0),
        assert(baseMaximum >= 0),
        assert(classLevelMultiplier >= 0);

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
      final abilityModifier = abilityModifiers[maximumAbility] ?? 0;
      final abilityMaximum = baseMaximum + abilityModifier;

      return abilityMaximum < minimumMaximum ? minimumMaximum : abilityMaximum;
    }

    var maximum = baseMaximum;

    for (final entry in maximumByLevel.entries) {
      if (entry.key <= level && entry.value >= 0) {
        maximum = baseMaximum + entry.value;
      }
    }

    maximum += level * classLevelMultiplier;

    if (additionalMaximumAbility != null) {
      maximum += abilityModifiers[additionalMaximumAbility] ?? 0;
    }

    return maximum < minimumMaximum ? minimumMaximum : maximum;
  }
}

/// Gruppo di incantesimi conosciuti soggetto a regole comuni.
///
/// Permette di rappresentare classi come Cavaliere Mistico e
/// Mistificatore Arcano, che conoscono alcuni incantesimi vincolati
/// a determinate scuole e altri completamente liberi.
class ClassSpellLearningPoolDefinition {
  final String id;
  final String name;

  /// Scuole ammesse, espresse con gli ID canonici di SpellSchool.
  ///
  /// Un insieme vuoto indica che sono ammesse tutte le scuole.
  final Set<String> allowedSchoolIds;

  /// Numero totale di incantesimi appartenenti al gruppo ai livelli
  /// in cui il valore cambia.
  final Map<int, int> knownByLevel;

  /// Conserva il vincolo del gruppo quando un incantesimo viene
  /// sostituito salendo di livello.
  final bool preservePoolOnReplacement;

  const ClassSpellLearningPoolDefinition({
    required this.id,
    required this.name,
    this.allowedSchoolIds = const {},
    required this.knownByLevel,
    this.preservePoolOnReplacement = true,
  });

  int knownAtLevel(int level) {
    var result = 0;

    for (final entry in knownByLevel.entries) {
      if (entry.key <= level) result = entry.value;
    }

    return result;
  }

  bool allowsSchool(String schoolId) =>
      allowedSchoolIds.isEmpty || allowedSchoolIds.contains(schoolId);
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

  /// Gruppi di incantesimi conosciuti sottoposti a vincoli differenti.
  final List<ClassSpellLearningPoolDefinition> learningPools;

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
    this.learningPools = const [],
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

  int spellsKnownFromPoolsAtLevel(int level) => learningPools.fold<int>(
        0,
        (total, pool) => total + pool.knownAtLevel(level),
      );

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

/// Libro degli incantesimi posseduto da una classe.
///
/// Conserva le regole statiche del libro. Gli incantesimi effettivamente
/// scelti dal personaggio appartengono allo stato persistente del personaggio.
/// Modifica ai tempi e ai costi di copiatura per una scuola di magia.
class ClassSpellbookCopyAdjustmentDefinition {
  final String id;
  final String schoolId;
  final int timeNumerator;
  final int timeDenominator;
  final int costNumerator;
  final int costDenominator;

  const ClassSpellbookCopyAdjustmentDefinition({
    required this.id,
    required this.schoolId,
    required this.timeNumerator,
    required this.timeDenominator,
    required this.costNumerator,
    required this.costDenominator,
  })  : assert(timeNumerator > 0),
        assert(timeDenominator > 0),
        assert(costNumerator > 0),
        assert(costDenominator > 0);

  double adjustedCopyHours(
    int spellLevel, {
    required int baseHoursPerSpellLevel,
  }) =>
      spellLevel * baseHoursPerSpellLevel * timeNumerator / timeDenominator;

  int adjustedCopyCostGp(
    int spellLevel, {
    required int baseCostGpPerSpellLevel,
  }) =>
      spellLevel * baseCostGpPerSpellLevel * costNumerator ~/ costDenominator;
}

class ClassSpellbookDefinition {
  final String catalogId;
  final String itemId;
  final int initialSpells;
  final int initialSpellLevel;
  final int spellsLearnedPerLevel;
  final int copyTimeHoursPerSpellLevel;
  final int copyCostGpPerSpellLevel;
  final int backupCopyTimeHoursPerSpellLevel;
  final int backupCopyCostGpPerSpellLevel;

  /// I rituali presenti nel libro possono essere lanciati senza prepararli.
  final bool ritualSpellsNeedPreparation;

  const ClassSpellbookDefinition({
    required this.catalogId,
    required this.itemId,
    required this.initialSpells,
    this.initialSpellLevel = 1,
    required this.spellsLearnedPerLevel,
    required this.copyTimeHoursPerSpellLevel,
    required this.copyCostGpPerSpellLevel,
    required this.backupCopyTimeHoursPerSpellLevel,
    required this.backupCopyCostGpPerSpellLevel,
    this.ritualSpellsNeedPreparation = false,
  })  : assert(initialSpells > 0),
        assert(initialSpellLevel > 0),
        assert(spellsLearnedPerLevel >= 0),
        assert(copyTimeHoursPerSpellLevel > 0),
        assert(copyCostGpPerSpellLevel >= 0),
        assert(backupCopyTimeHoursPerSpellLevel > 0),
        assert(backupCopyCostGpPerSpellLevel >= 0);

  int automaticSpellsAtLevel(int level) {
    if (level < 1) return 0;
    return initialSpells + ((level - 1) * spellsLearnedPerLevel);
  }

  int copyTimeHours(int spellLevel, {bool ownNotation = false}) {
    if (spellLevel < 1) return 0;

    final hoursPerLevel = ownNotation
        ? backupCopyTimeHoursPerSpellLevel
        : copyTimeHoursPerSpellLevel;

    return spellLevel * hoursPerLevel;
  }

  int copyCostGp(int spellLevel, {bool ownNotation = false}) {
    if (spellLevel < 1) return 0;

    final costPerLevel =
        ownNotation ? backupCopyCostGpPerSpellLevel : copyCostGpPerSpellLevel;

    return spellLevel * costPerLevel;
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

  /// Progressione magica concessa direttamente dalla sottoclasse.
  ///
  /// Esempi: Cavaliere Mistico e futuro Mistificatore Arcano.
  final ClassSpellcastingDefinition? spellcasting;

  /// Risorse consumabili concesse esclusivamente dalla sottoclasse.
  ///
  /// Esempi: Interdizione Luminosa del Dominio della Luce e Prete
  /// della Guerra del Dominio della Guerra.
  final List<ClassResourceDefinition> resources;

  /// Recuperi degli slot concessi dalla sottoclasse.
  final List<ClassSpellSlotRecoveryDefinition> spellSlotRecoveries;

  /// Trasformazioni concesse o modificate dalla sottoclasse.
  final List<ClassTransformationDefinition> transformations;

  /// Modifiche al costo e al tempo di copiatura del libro.
  final List<ClassSpellbookCopyAdjustmentDefinition> spellbookCopyAdjustments;

  /// Valori progressivi appartenenti esclusivamente alla sottoclasse.
  ///
  /// Esempi: dado di superiorità del Maestro di Battaglia e altri
  /// valori che cambiano con il livello senza appartenere alla classe base.
  final List<ClassProgressionValueDefinition> progressionValues;

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
    this.spellcasting,
    this.resources = const [],
    this.spellSlotRecoveries = const [],
    this.transformations = const [],
    this.spellbookCopyAdjustments = const [],
    this.progressionValues = const [],
    this.options = const [],
    this.optionProgression,
    this.homebrew = false,
    this.supplemental = false,
  });

  String? progressionValue(String id, int level) {
    for (final definition in progressionValues) {
      if (definition.id == id) {
        return definition.valueAtLevel(level);
      }
    }

    return null;
  }

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
  final ClassSpellbookDefinition? spellbook;
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
    this.spellbook,
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
