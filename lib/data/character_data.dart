import 'class_data.dart';
import 'choice_data.dart';

/// ID canonici delle abilità di D&D 5e.
///
/// Gli ID coincidono per ora con i nomi italiani già utilizzati dal runtime,
/// così da mantenere compatibilità con background e personaggi esistenti.
const List<String> characterSkillIds = [
  'Acrobazia',
  'Addestrare Animali',
  'Arcano',
  'Atletica',
  'Furtività',
  'Indagare',
  'Inganno',
  'Intimidire',
  'Intuizione',
  'Medicina',
  'Natura',
  'Percezione',
  'Persuasione',
  'Rapidità di Mano',
  'Religione',
  'Sopravvivenza',
  'Storia',
  'Intrattenere',
];

/// ID canonici delle categorie di strumenti.
///
/// Il catalogo potrà essere raffinato con definizioni dedicate nel
/// popolamento dell'equipaggiamento; questi ID costituiscono il dominio
/// condiviso da talenti, background, classi e creator.
const List<String> characterToolIds = [
  'alchemists_supplies',
  'brewers_supplies',
  'calligraphers_supplies',
  'carpenters_tools',
  'cartographers_tools',
  'cobblers_tools',
  'cooks_utensils',
  'glassblowers_tools',
  'jewelers_tools',
  'leatherworkers_tools',
  'masons_tools',
  'painters_supplies',
  'potters_tools',
  'smiths_tools',
  'tinkers_tools',
  'weavers_tools',
  'woodcarvers_tools',
  'disguise_kit',
  'forgery_kit',
  'herbalism_kit',
  'navigators_tools',
  'poisoners_kit',
  'thieves_tools',
  'gaming_set',
  'musical_instrument',
];

/// Lingue standard disponibili alle choice generiche.
///
/// Il catalogo usa gli stessi valori testuali già presenti negli effetti
/// razziali. Le lingue speciali o concesse da contenuti futuri potranno
/// essere aggiunte senza modificare il motore delle choice.
const List<String> characterLanguageIds = [
  'Comune',
  'Nanico',
  'Elfico',
  'Gigante',
  'Gnomesco',
  'Goblin',
  'Halfling',
  'Orchesco',
  'Abissale',
  'Celestiale',
  'Draconico',
  'Gergo delle Profondità',
  'Infernale',
  'Primordiale',
  'Silvano',
  'Sottocomune',
];

enum CharacterChoiceType {
  ability,
  skill,
  language,
  tool,
  weapon,
  armor,
  equipment,
  feat,
  spell,
  cantrip,
  subclass,
  other,
}

/// Modificatore permanente a una caratteristica.
///
/// `amount` rappresenta esclusivamente un bonus numerico supportato
/// dalla regola che lo concede. Le scelte variabili vengono modellate
/// separatamente tramite CharacterChoiceDefinition.
class AbilityBonusDefinition {
  final String ability;
  final int amount;

  const AbilityBonusDefinition({
    required this.ability,
    required this.amount,
  });
}

/// Una scelta richiesta da razza, classe, background, talento o altra regola.
class CharacterChoiceOptionDefinition {
  final String id;
  final String label;
  final CharacterEffects effects;

  const CharacterChoiceOptionDefinition({
    required this.id,
    required this.label,
    this.effects = const CharacterEffects(),
  });
}

/// Opzione strutturata di una scelta.
///
/// A differenza di optionIds, può applicare effetti propri quando viene
/// selezionata. Questo permette di modellare, per esempio, la discendenza
/// draconica senza hardcoding nel runtime.

class CharacterChoiceDefinition {
  final String id;
  final String label;
  final CharacterChoiceType type;
  final String? catalogId;
  final int minimumSelections;
  final int maximumSelections;

  /// ID ammessi. Vuoto quando il dominio viene risolto da un altro dataset.
  final List<String> optionIds;

  /// Opzioni che possiedono effetti strutturati propri.
  ///
  /// optionIds rimane disponibile per i domini semplici.
  final List<CharacterChoiceOptionDefinition> options;

  final List<CharacterChoiceConstraint> constraints;

  /// Impedisce di scegliere due volte lo stesso elemento.
  final bool unique;

  /// Se true, una scelta già posseduta dal personaggio non è valida.
  ///
  /// Utile per competenze concesse da talenti, classi e background:
  /// l'opzione resta visibile nella UI, ma non può essere conteggiata
  /// come nuova acquisizione.
  final bool requireNewAcquisition;

  /// Richiede che l’elemento sia già posseduto dal personaggio.
  ///
  /// Serve, per esempio, a Maestria, che può essere applicata soltanto
  /// a competenze già acquisite.
  final bool requireExistingAcquisition;

  /// Livello massimo degli incantesimi selezionabili.
  ///
  /// Null indica che la scelta non applica questo limite.
  final int? maximumSpellLevel;

  const CharacterChoiceDefinition({
    required this.id,
    required this.label,
    required this.type,
    this.catalogId,
    this.minimumSelections = 1,
    this.maximumSelections = 1,
    this.optionIds = const [],
    this.options = const [],
    this.constraints = const [],
    this.unique = true,
    this.requireNewAcquisition = false,
    this.requireExistingAcquisition = false,
    this.maximumSpellLevel,
  })  : assert(
          !requireNewAcquisition || !requireExistingAcquisition,
        ),
        assert(
          maximumSpellLevel == null ||
              (maximumSpellLevel >= 0 && maximumSpellLevel <= 9),
        );
}

/// Effetti strutturati condivisi da razze, background, talenti e altre fonti.
///
/// Le descrizioni regolamentari rimangono in RuleContent.
/// Qui vengono rappresentati soltanto gli effetti che il runtime deve
/// effettivamente poter applicare.

/// Scelte effettuate dal giocatore per una specifica fonte.
///
/// Le chiavi corrispondono agli ID di CharacterChoiceDefinition.
/// Ogni scelta può produrre uno o più ID selezionati.
class CharacterChoiceState {
  final Map<String, List<String>> selections;

  const CharacterChoiceState({
    this.selections = const {},
  });

  List<String> selectedFor(String choiceId) => selections[choiceId] ?? const [];

  String? singleFor(String choiceId) {
    final values = selectedFor(choiceId);
    return values.isEmpty ? null : values.first;
  }
}

/// Risultato della risoluzione razziale.
///
/// Contiene gli effetti finali già combinati e i grant di progressione
/// disponibili al livello corrente.

/// Problema riscontrato durante la validazione di una scelta.
class CharacterChoiceIssue {
  final String choiceId;
  final String message;

  const CharacterChoiceIssue({
    required this.choiceId,
    required this.message,
  });
}

/// Risultato della validazione delle scelte.
///
/// Una scelta non ancora compilata viene indicata come incompleta.
/// Una selezione impossibile o fuori dai limiti viene invece indicata
/// come invalida.
class CharacterChoiceValidationResult {
  final List<String> incompleteChoiceIds;
  final List<CharacterChoiceIssue> issues;

  const CharacterChoiceValidationResult({
    this.incompleteChoiceIds = const [],
    this.issues = const [],
  });

  bool get isComplete => incompleteChoiceIds.isEmpty;
  bool get isValid => issues.isEmpty;
  bool get canFinalize => isComplete && isValid;
}

class ResolvedRaceEffects {
  final CharacterEffects effects;
  final List<RacialProgressionGrant> progressionGrants;
  final CharacterChoiceValidationResult choiceValidation;

  const ResolvedRaceEffects({
    required this.effects,
    this.progressionGrants = const [],
    this.choiceValidation = const CharacterChoiceValidationResult(),
  });
}

enum CharacterRuleEffectType {
  advantage,
  disadvantage,
  attackBonus,
  damageBonus,
  criticalRange,
  reachBonus,
  passiveScoreBonus,
  spellcasting,
  resource,
  movement,
  reaction,
  conditional,
}

/// Effetto meccanico strutturato che non può essere aggregato
/// correttamente come semplice bonus numerico.
///
/// `target` identifica ciò a cui si applica la regola.
/// `value` contiene l'eventuale valore numerico.
/// `referenceIds` collega spell, feature, armi o altri contenuti.
/// `condition` descrive la condizione meccanica in forma stabile,
/// senza introdurre logica specifica del talento dentro HeroData.
class CharacterRuleEffect {
  final String id;
  final CharacterRuleEffectType type;
  final String target;
  final double? value;
  final List<String> referenceIds;
  final String? condition;

  const CharacterRuleEffect({
    required this.id,
    required this.type,
    required this.target,
    this.value,
    this.referenceIds = const [],
    this.condition,
  });
}

class CharacterEffects {
  final List<AbilityBonusDefinition> abilityBonuses;

  final Set<String> skillProficiencies;
  final Set<String> savingThrowProficiencies;
  final Set<String> weaponProficiencies;
  final Set<String> armorProficiencies;
  final Set<String> toolProficiencies;
  final Set<String> languages;

  /// Resistenze ai tipi di danno.
  ///
  /// Gli ID saranno condivisi con il futuro catalogo dei tipi di danno.
  final Set<String> damageResistances;

  /// ID delle condizioni contro cui una regola concede vantaggio
  /// ai tiri salvezza.
  final Set<String> savingThrowAdvantageAgainst;

  /// ID delle condizioni contro cui il personaggio è immune.
  final Set<String> conditionImmunities;

  /// Portata della scurovisione in metri.
  /// Null indica che questo effetto non concede scurovisione.
  final double? darkvisionRange;

  /// Eventuale sostituzione della velocità base.
  ///
  /// Serve per effetti che stabiliscono direttamente una velocità
  /// differente da quella della razza base.
  final double? walkingSpeedOverride;

  /// Bonus permanente ai PF massimi per ogni livello del personaggio.
  final int hitPointsPerLevelBonus;

  /// Bonus permanente alla Classe Armatura.
  final int armorClassBonus;

  /// Bonus permanente all'iniziativa.
  final int initiativeBonus;

  /// Bonus additivo alla velocità base, in metri.
  final double walkingSpeedBonus;

  final List<String> grantedFeatureIds;
  final List<String> grantedFeatIds;
  final List<String> grantedSpellIds;
  final List<String> grantedCantripIds;
  final List<String> grantedEquipmentIds;

  final List<CharacterRuleEffect> ruleEffects;

  final List<CharacterChoiceDefinition> choices;

  const CharacterEffects({
    this.abilityBonuses = const [],
    this.skillProficiencies = const {},
    this.savingThrowProficiencies = const {},
    this.weaponProficiencies = const {},
    this.armorProficiencies = const {},
    this.toolProficiencies = const {},
    this.languages = const {},
    this.damageResistances = const {},
    this.savingThrowAdvantageAgainst = const {},
    this.conditionImmunities = const {},
    this.darkvisionRange,
    this.walkingSpeedOverride,
    this.hitPointsPerLevelBonus = 0,
    this.armorClassBonus = 0,
    this.initiativeBonus = 0,
    this.walkingSpeedBonus = 0,
    this.grantedFeatureIds = const [],
    this.grantedFeatIds = const [],
    this.grantedSpellIds = const [],
    this.grantedCantripIds = const [],
    this.grantedEquipmentIds = const [],
    this.ruleEffects = const [],
    this.choices = const [],
  });
}

/// Tipo di capacità concessa durante una progressione razziale.
enum RacialGrantType {
  feature,
  cantrip,
  spell,
}

/// Contenuto che diventa disponibile raggiungendo un determinato livello.
///
/// `minimumLevel` è il livello totale del personaggio, perché le capacità
/// razziali non dipendono dal livello in una specifica classe.
class RacialProgressionGrant {
  final int minimumLevel;
  final RacialGrantType type;
  final String contentId;

  /// Numero di utilizzi concessi dalla capacità, quando applicabile.
  /// Null significa che il numero di utilizzi non è definito qui.
  final int? uses;

  /// Tipo di recupero della capacità, per esempio `long_rest`.
  final String? recharge;

  /// Caratteristica da usare per la capacità magica, quando prevista.
  final String? ability;

  const RacialProgressionGrant({
    required this.minimumLevel,
    required this.type,
    required this.contentId,
    this.uses,
    this.recharge,
    this.ability,
  });
}

/// Progressione associata a una razza o sottorazza.
class RacialProgressionDefinition {
  final List<RacialProgressionGrant> grants;

  const RacialProgressionDefinition({
    this.grants = const [],
  });

  List<RacialProgressionGrant> availableAtLevel(int level) {
    return grants
        .where((grant) => grant.minimumLevel <= level)
        .toList(growable: false);
  }
}

/// Forma geometrica utilizzata da una capacità ad area.
enum EffectAreaShape {
  line,
  cone,
}

/// Dati strutturati dell'Arma a Soffio di una discendenza dragonide.
///
/// Il danno e la CD effettivi verranno calcolati dal runtime usando
/// questi dati e il livello del personaggio.
class DragonBreathDefinition {
  final String ancestryId;
  final String damageType;
  final EffectAreaShape shape;

  /// Lunghezza dell'area in metri.
  final double range;

  /// Caratteristica usata dal bersaglio per il tiro salvezza.
  final String savingThrowAbility;

  const DragonBreathDefinition({
    required this.ancestryId,
    required this.damageType,
    required this.shape,
    required this.range,
    required this.savingThrowAbility,
  });
}

class SubraceDefinition {
  final String id;
  final String name;
  final String raceId;
  final RuleContent content;
  final CharacterEffects effects;

  const SubraceDefinition({
    required this.id,
    required this.name,
    required this.raceId,
    required this.content,
    this.effects = const CharacterEffects(),
  });
}

class RaceDefinition {
  final String id;
  final String name;
  final RuleContent content;

  /// Velocità base in metri, coerente con la UI attuale.
  final double speed;

  final String size;
  final CharacterEffects effects;
  final Map<String, SubraceDefinition> subraces;

  /// Consente una definizione creata dal giocatore senza confonderla
  /// con il catalogo ufficiale.
  final bool homebrew;

  const RaceDefinition({
    required this.id,
    required this.name,
    required this.content,
    required this.speed,
    required this.size,
    this.effects = const CharacterEffects(),
    this.subraces = const {},
    this.homebrew = false,
  });
}

/// Privilegio narrativo e meccanico concesso da un background.
class BackgroundFeatureDefinition {
  final String id;
  final RuleContent content;

  /// Tag stabili utilizzabili dal runtime per riconoscere gli effetti
  /// che non possono essere rappresentati come semplici bonus numerici.
  final Set<String> ruleTags;

  const BackgroundFeatureDefinition({
    required this.id,
    required this.content,
    this.ruleTags = const {},
  });
}

/// Una voce di una tabella casuale associata a un background.
///
/// Un intervallo permette di rappresentare sia risultati singoli sia
/// gruppi di risultati senza duplicare lo stesso testo.
class BackgroundTableEntry {
  final int minimumRoll;
  final int maximumRoll;
  final String label;

  /// Allineamento eventualmente associato a un ideale.
  final String? alignment;

  const BackgroundTableEntry({
    required this.minimumRoll,
    required this.maximumRoll,
    required this.label,
    this.alignment,
  })  : assert(minimumRoll > 0),
        assert(maximumRoll >= minimumRoll);

  bool matches(int roll) => roll >= minimumRoll && roll <= maximumRoll;
}

/// Tabella tirabile appartenente a un background.
///
/// Può rappresentare specializzazioni, eventi determinanti, truffe,
/// attività professionali o qualsiasi altra scelta prevista dal PHB.
class BackgroundTableDefinition {
  final String id;
  final String name;
  final int dieSides;
  final List<BackgroundTableEntry> entries;

  const BackgroundTableDefinition({
    required this.id,
    required this.name,
    required this.dieSides,
    required this.entries,
  }) : assert(dieSides > 0);

  BackgroundTableEntry? entryForRoll(int roll) {
    if (roll < 1 || roll > dieSides) return null;

    for (final entry in entries) {
      if (entry.matches(roll)) return entry;
    }

    return null;
  }
}

/// Tabelle suggerite per definire la personalità del personaggio.
class BackgroundSuggestedCharacteristics {
  final BackgroundTableDefinition? personalityTraits;
  final BackgroundTableDefinition? ideals;
  final BackgroundTableDefinition? bonds;
  final BackgroundTableDefinition? flaws;

  const BackgroundSuggestedCharacteristics({
    this.personalityTraits,
    this.ideals,
    this.bonds,
    this.flaws,
  });

  bool get isComplete =>
      personalityTraits != null &&
      ideals != null &&
      bonds != null &&
      flaws != null;
}

/// Oggetto concesso dalla dotazione iniziale di un background.
class BackgroundEquipmentGrant {
  final String itemId;

  /// Catalogo che possiede l'oggetto, per esempio `equipment` o `focus`.
  final String catalogId;

  final int quantity;

  const BackgroundEquipmentGrant({
    required this.itemId,
    this.catalogId = 'equipment',
    this.quantity = 1,
  }) : assert(quantity > 0);
}

class BackgroundDefinition {
  final String id;
  final String name;
  final RuleContent content;
  final CharacterEffects effects;

  /// ID del background principale da cui deriva una variante ufficiale.
  ///
  /// Null identifica un background principale.
  final String? parentBackgroundId;

  /// Privilegio specifico concesso dal background.
  final BackgroundFeatureDefinition? feature;

  /// Tabelle aggiuntive previste dal background, escluse le quattro
  /// tabelle standard delle caratteristiche personali.
  final List<BackgroundTableDefinition> tables;

  final BackgroundSuggestedCharacteristics suggestedCharacteristics;

  /// Monete iniziali espresse con le sigle già usate da HeroData:
  /// MR, MA, ME, MO, MP.
  final Map<String, int> startingCoins;

  final List<String> startingEquipmentPacks;

  /// Oggetti individuali concessi direttamente dal background.
  final List<BackgroundEquipmentGrant> startingEquipment;

  final bool homebrew;

  const BackgroundDefinition({
    required this.id,
    required this.name,
    required this.content,
    this.effects = const CharacterEffects(),
    this.parentBackgroundId,
    this.feature,
    this.tables = const [],
    this.suggestedCharacteristics = const BackgroundSuggestedCharacteristics(),
    this.startingCoins = const {},
    this.startingEquipmentPacks = const [],
    this.startingEquipment = const [],
    this.homebrew = false,
  });

  bool get isVariant => parentBackgroundId != null;
}

/// Famiglia universale di requisito valutabile sul personaggio.
///
/// Il modello non appartiene ai talenti: potrà essere riutilizzato da
/// multiclasse, sottoclassi, equipaggiamento e altri contenuti.
enum CharacterRequirementType {
  minimumAbility,
  race,
  proficiency,
  spellcasting,
  other,
}

/// Requisito universale indipendente dalla UI.
class CharacterRequirement {
  final CharacterRequirementType type;

  /// ID canonico dell'oggetto richiesto.
  ///
  /// Esempi: FOR, dwarf, medium_armor.
  final String value;

  /// Soglia numerica opzionale, per esempio FOR >= 13.
  final int? minimum;

  /// Etichetta opzionale da mostrare all'utente.
  final String? label;

  const CharacterRequirement({
    required this.type,
    required this.value,
    this.minimum,
    this.label,
  });
}

/// Stato del personaggio necessario a valutare i requisiti.
///
/// È intenzionalmente indipendente da HeroData: il motore delle regole
/// può così essere usato anche dal creator prima che il personaggio
/// definitivo venga costruito.
class CharacterEligibilityState {
  final Map<String, int> abilityScores;
  final String? raceId;
  final Set<String> proficiencies;
  final bool canCastSpells;

  /// Flag estensibili per requisiti che non meritano ancora un campo
  /// dedicato nel modello.
  final Set<String> flags;

  const CharacterEligibilityState({
    this.abilityScores = const {},
    this.raceId,
    this.proficiencies = const {},
    this.canCastSpells = false,
    this.flags = const {},
  });
}

/// Risultato di un singolo requisito.
class CharacterRequirementResult {
  final CharacterRequirement requirement;
  final bool satisfied;

  /// Testo breve del requisito.
  final String label;

  /// Dettaglio dello stato corrente, adatto alla UI.
  final String detail;

  const CharacterRequirementResult({
    required this.requirement,
    required this.satisfied,
    required this.label,
    required this.detail,
  });
}

/// Risultato complessivo di una valutazione.
///
/// Un contenuto rimane consultabile anche quando [canSelect] è false:
/// è la conferma della scelta a dover essere impedita dalla UI.
class CharacterEligibilityResult {
  final List<CharacterRequirementResult> requirements;

  const CharacterEligibilityResult({
    this.requirements = const [],
  });

  bool get canSelect => requirements.every((result) => result.satisfied);
}

/// Valuta requisiti universali rispetto allo stato corrente.
CharacterEligibilityResult evaluateCharacterEligibility({
  required List<CharacterRequirement> requirements,
  required CharacterEligibilityState state,
}) {
  final results = <CharacterRequirementResult>[];

  for (final requirement in requirements) {
    switch (requirement.type) {
      case CharacterRequirementType.minimumAbility:
        final current = state.abilityScores[requirement.value] ?? 0;
        final minimum = requirement.minimum ?? 0;

        results.add(
          CharacterRequirementResult(
            requirement: requirement,
            satisfied: current >= minimum,
            label: requirement.label ?? '${requirement.value} $minimum',
            detail: 'Attuale: $current · Richiesto: $minimum',
          ),
        );

      case CharacterRequirementType.race:
        final satisfied = state.raceId == requirement.value;

        results.add(
          CharacterRequirementResult(
            requirement: requirement,
            satisfied: satisfied,
            label: requirement.label ?? 'Razza: ${requirement.value}',
            detail: satisfied
                ? 'Requisito razziale soddisfatto'
                : 'Razza richiesta: ${requirement.value}',
          ),
        );

      case CharacterRequirementType.proficiency:
        final satisfied = state.proficiencies.contains(requirement.value);

        results.add(
          CharacterRequirementResult(
            requirement: requirement,
            satisfied: satisfied,
            label: requirement.label ?? 'Competenza: ${requirement.value}',
            detail: satisfied
                ? 'Competenza posseduta'
                : 'Competenza richiesta: ${requirement.value}',
          ),
        );

      case CharacterRequirementType.spellcasting:
        results.add(
          CharacterRequirementResult(
            requirement: requirement,
            satisfied: state.canCastSpells,
            label: requirement.label ?? 'Capacità di lanciare incantesimi',
            detail: state.canCastSpells
                ? 'Requisito di incantatore soddisfatto'
                : 'Richiede la capacità di lanciare incantesimi',
          ),
        );

      case CharacterRequirementType.other:
        final satisfied = state.flags.contains(requirement.value);

        results.add(
          CharacterRequirementResult(
            requirement: requirement,
            satisfied: satisfied,
            label: requirement.label ?? requirement.value,
            detail: satisfied
                ? 'Requisito soddisfatto'
                : 'Requisito non soddisfatto',
          ),
        );
    }
  }

  return CharacterEligibilityResult(
    requirements: results,
  );
}

enum FeatPrerequisiteType {
  minimumAbility,
  race,
  proficiency,
  spellcasting,
  other,
}

class FeatPrerequisite {
  final FeatPrerequisiteType type;

  /// ID della caratteristica, razza, competenza o requisito.
  final String value;

  /// Utilizzato, per esempio, per un punteggio minimo di caratteristica.
  final int? minimum;

  const FeatPrerequisite({
    required this.type,
    required this.value,
    this.minimum,
  });
}

class FeatDefinition {
  final String id;
  final String name;
  final RuleContent content;
  final List<FeatPrerequisite> prerequisites;
  final CharacterEffects effects;
  final bool homebrew;

  const FeatDefinition({
    required this.id,
    required this.name,
    required this.content,
    this.prerequisites = const [],
    this.effects = const CharacterEffects(),
    this.homebrew = false,
  });
}

/// Scelta realmente effettuata dal personaggio.
///
/// Separarla dalla definizione permette di mantenere immutabili i dati
/// regolamentari e serializzare soltanto le decisioni del giocatore.
class CharacterChoiceSelection {
  final String choiceId;
  final List<String> selectedIds;

  const CharacterChoiceSelection({
    required this.choiceId,
    required this.selectedIds,
  });

  Map<String, dynamic> toJson() => {
        'choiceId': choiceId,
        'selectedIds': selectedIds,
      };

  factory CharacterChoiceSelection.fromJson(Map<String, dynamic> json) {
    return CharacterChoiceSelection(
      choiceId: json['choiceId'] as String? ?? '',
      selectedIds: List<String>.from(json['selectedIds'] ?? const []),
    );
  }
}

/// Registro centrale. Verrà popolato progressivamente dalle fonti.
///
/// Tenerlo separato dalla UI evita nuovi `if (race == ...)` dentro HeroData.
const Map<String, RaceDefinition> raceDefinitions = {};

RaceDefinition? raceDefinitionFor(String id) => raceDefinitions[id];
