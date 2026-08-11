import 'class_data.dart';
import 'choice_data.dart';

/// Scuole canoniche della magia.
///
/// È distinta da SpellVisualSchool perché questa enum appartiene al
/// dominio meccanico; la variante visuale resta responsabilità della UI.
enum SpellSchool {
  abjuration,
  conjuration,
  divination,
  enchantment,
  evocation,
  illusion,
  necromancy,
  transmutation,
}

/// Tipo fondamentale del tempo di lancio.
enum SpellCastingTimeType {
  action,
  bonusAction,
  reaction,
  minute,
  hour,
  special,
}

/// Evento runtime che può permettere il lancio di un incantesimo
/// con tempo di lancio Reazione.
enum SpellReactionEvent {
  hitByAttack,
  targetedBySpell,
  damaged,
  creatureMoves,
  creatureFalls,
  special,
}

/// Condizione strutturata che abilita una reazione.
///
/// `spellIds` restringe il trigger a specifici incantesimi quando
/// necessario. Un insieme vuoto significa che non esiste tale filtro.
class SpellReactionTrigger {
  final SpellReactionEvent event;
  final Set<String> spellIds;

  const SpellReactionTrigger({
    required this.event,
    this.spellIds = const {},
  });
}

/// Tempo necessario per lanciare un incantesimo.
///
/// `amount` permette di rappresentare valori come 1 azione,
/// 10 minuti o 1 ora senza codificare il numero dentro una stringa.
///
/// `reactionTrigger` viene usato soltanto per le reazioni.
class SpellCastingTime {
  final SpellCastingTimeType type;
  final int amount;

  /// Descrizione leggibile del trigger, conforme alla voce dello spell.
  final String reactionTrigger;

  /// Trigger runtime utilizzabili dal motore.
  ///
  /// Possono essere più di uno: Scudo, per esempio, reagisce sia a un
  /// attacco che colpisce sia a uno specifico incantesimo.
  final List<SpellReactionTrigger> reactionTriggers;

  const SpellCastingTime({
    required this.type,
    this.amount = 1,
    this.reactionTrigger = '',
    this.reactionTriggers = const [],
  }) : assert(amount > 0);
}

/// Tipo fondamentale della gittata.
enum SpellRangeType {
  self,
  touch,
  distance,
  sight,
  unlimited,
  special,
}

/// Gittata dell'incantesimo.
///
/// Le distanze dell'app sono espresse in metri, coerentemente con il resto
/// del modello attuale.
class SpellRange {
  final SpellRangeType type;
  final double distanceMeters;

  const SpellRange({
    required this.type,
    this.distanceMeters = 0,
  }) : assert(distanceMeters >= 0);
}

/// Forma di un'eventuale area d'effetto.
enum SpellAreaShape {
  cone,
  cube,
  cylinder,
  line,
  sphere,
  radius,
  special,
}

/// Origine geometrica dell'area.
enum SpellAreaOrigin {
  caster,
  targetPoint,
  target,
  special,
}

/// Area geometrica prodotta dall'incantesimo.
///
/// Non tutti i campi sono significativi per tutte le forme:
/// - cone: sizeMeters
/// - cube: sizeMeters
/// - line: lengthMeters + widthMeters
/// - sphere/radius: radiusMeters
/// - cylinder: radiusMeters + heightMeters

/// Evento che può attivare un effetto prodotto da un'area persistente.
enum SpellAreaTriggerEvent {
  /// Quando l'area viene creata.
  areaAppears,

  /// Quando una creatura entra nell'area per la prima volta
  /// durante un turno.
  entersAreaFirstTimeOnTurn,

  /// Quando una creatura inizia il proprio turno nell'area.
  startsTurnInArea,

  /// Quando una creatura termina il proprio turno nell'area.
  endsTurnInArea,

  special,
}

/// Modalità con cui viene modificata la velocità.
enum SpellMovementModifierType {
  multiplier,
  fixedBonus,
  fixedPenalty,
  setValue,
  special,
}

/// Modificatore di movimento prodotto da un incantesimo.

/// Configurazione geometrica di una parete.
enum SpellWallShape {
  line,
  ring,
  panels,
  hemisphere,
  special,
}

/// Proprietà geometriche di una parete evocata.
class SpellWallDefinition {
  /// Forma generale della parete.
  final SpellWallShape shape;

  /// Lunghezza totale.
  final double lengthMeters;

  /// Altezza.
  final double heightMeters;

  /// Spessore.
  final double thicknessMeters;

  /// La parete può essere creata ad anello.
  final bool supportsRing;

  const SpellWallDefinition({
    required this.shape,
    this.lengthMeters = 0,
    this.heightMeters = 0,
    this.thicknessMeters = 0,
    this.supportsRing = false,
  });
}

class SpellMovementModifier {
  final SpellMovementModifierType type;

  /// Usato da multiplier.
  ///
  /// 0.5 = velocità dimezzata
  /// 2.0 = velocità raddoppiata
  final double multiplier;

  /// Usato dagli altri tipi.
  final double meters;

  const SpellMovementModifier({
    required this.type,
    this.multiplier = 1,
    this.meters = 0,
  });
}

/// Effetto applicato quando si verifica uno degli eventi di un'area
/// persistente.
///
/// Il danno è separato dal normale `SpellDefinition.damage`, perché
/// quest'ultimo descrive la risoluzione immediata del lancio mentre
/// questo effetto può attivarsi ripetutamente durante la durata.
class SpellAreaTriggeredEffect {
  final Set<SpellAreaTriggerEvent> triggers;
  final SpellDamage? damage;
  final SpellSavingThrow? savingThrow;

  /// Modificatore di velocità applicato alle creature interessate.
  final SpellMovementModifier? movementModifier;

  const SpellAreaTriggeredEffect({
    required this.triggers,
    this.damage,
    this.savingThrow,
    this.movementModifier,
  });
}

/// Interazione prodotta da un incantesimo sugli oggetti presenti
/// nella sua area.
enum SpellAreaObjectInteractionType {
  ignite,
  damage,
  destroy,
  move,
  special,
}

/// Condizioni che limitano quali oggetti subiscono un'interazione.
enum SpellAreaObjectCondition {
  flammable,
  notWorn,
  notCarried,
  special,
}

/// Effetti ambientali e geometrici associati all'area.
///
/// Queste proprietà sono separate dalla geometria di [SpellArea]:
/// due spell con la stessa sfera possono infatti propagarsi e
/// interagire con l'ambiente in modi differenti.

/// Modalità con cui un'area decide quali creature ignorare.
enum SpellAreaExclusionType {
  none,

  /// Creature scelte dall'incantatore quando l'incantesimo viene lanciato.
  chosenOnCast,

  special,
}

/// Regole di esclusione applicate a un'area persistente.
class SpellAreaExclusion {
  final SpellAreaExclusionType type;

  const SpellAreaExclusion({
    this.type = SpellAreaExclusionType.none,
  });
}

class SpellAreaInteraction {
  /// L'effetto dell'area può propagarsi oltre gli angoli.
  final bool spreadsAroundCorners;

  /// Tipo di interazione applicata agli oggetti nell'area.
  final SpellAreaObjectInteractionType? objectInteraction;

  /// Condizioni che un oggetto deve soddisfare per essere coinvolto.
  final Set<SpellAreaObjectCondition> objectConditions;

  const SpellAreaInteraction({
    this.spreadsAroundCorners = false,
    this.objectInteraction,
    this.objectConditions = const {},
  });
}

class SpellArea {
  final SpellAreaShape shape;
  final SpellAreaOrigin origin;

  final double sizeMeters;
  final double radiusMeters;
  final double lengthMeters;
  final double widthMeters;
  final double heightMeters;

  const SpellArea({
    required this.shape,
    required this.origin,
    this.sizeMeters = 0,
    this.radiusMeters = 0,
    this.lengthMeters = 0,
    this.widthMeters = 0,
    this.heightMeters = 0,
  })  : assert(sizeMeters >= 0),
        assert(radiusMeters >= 0),
        assert(lengthMeters >= 0),
        assert(widthMeters >= 0),
        assert(heightMeters >= 0);
}

/// Componenti verbali, somatiche e materiali.
class SpellMaterialComponent {
  /// Descrizione della componente richiesta dal manuale.
  final String description;

  /// Valore minimo richiesto, espresso in monete d'oro.
  ///
  /// Null indica che non è specificato un valore monetario.
  final int? minimumCostGp;

  /// Indica che questa componente viene consumata dal lancio.
  final bool consumed;

  const SpellMaterialComponent({
    required this.description,
    this.minimumCostGp,
    this.consumed = false,
  }) : assert(minimumCostGp == null || minimumCostGp >= 0);
}

class SpellComponents {
  final bool verbal;
  final bool somatic;

  /// Componenti materiali richieste.
  ///
  /// Una lista vuota significa che l'incantesimo non possiede M.
  final List<SpellMaterialComponent> materials;

  const SpellComponents({
    this.verbal = false,
    this.somatic = false,
    this.materials = const [],
  });

  bool get material => materials.isNotEmpty;

  /// Un focus o una borsa delle componenti può sostituire soltanto
  /// componenti materiali prive di costo specificato e non consumate.
  bool get hasNonSubstitutableMaterial => materials.any(
        (component) => component.minimumCostGp != null || component.consumed,
      );
}

/// Unità fondamentale della durata.
enum SpellDurationType {
  instantaneous,
  round,
  minute,
  hour,
  day,
  untilDispelled,
  permanent,
  special,
}

/// Durata dell'incantesimo.
///
/// La concentrazione è una proprietà separata perché "fino a 1 minuto,
/// concentrazione" è meccanicamente diversa da una semplice durata.
class SpellDuration {
  final SpellDurationType type;
  final int amount;
  final bool concentration;

  const SpellDuration({
    required this.type,
    this.amount = 1,
    this.concentration = false,
  }) : assert(amount > 0);
}

/// Tipo generale di bersaglio.
///
/// I casi estremamente specifici restano descritti nel testo della regola
/// senza costringere il motore a conoscere ogni possibile incantesimo.
enum SpellTargetType {
  self,
  creature,
  creatures,
  willingCreature,
  object,
  point,
  area,
  special,
}

class SpellTarget {
  /// Tipi di bersaglio ammessi.
  ///
  /// Una collezione permette di rappresentare fedelmente casi come
  /// "una creatura o un oggetto" senza degradarli a `special`.
  final Set<SpellTargetType> types;

  /// Numero massimo di bersagli quando è staticamente determinabile.
  /// null indica che dipende dalla regola dell'incantesimo.
  final int? maximumTargets;

  /// Distanza massima reciproca tra i bersagli selezionati.
  ///
  /// Null indica che l'incantesimo non impone questo tipo di vincolo.
  final double? maximumDistanceBetweenTargetsMeters;

  const SpellTarget({
    required this.types,
    this.maximumTargets,
    this.maximumDistanceBetweenTargetsMeters,
  })  : assert(maximumTargets == null || maximumTargets > 0),
        assert(
          maximumDistanceBetweenTargetsMeters == null ||
              maximumDistanceBetweenTargetsMeters >= 0,
        );
}

/// Caratteristica usata per un tiro salvezza.
enum SpellSavingThrowAbility {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma,
}

/// Risultato generale di un tiro salvezza riuscito.
enum SpellSaveSuccess {
  none,
  halfDamage,
  negates,
  partial,
  special,
}

class SpellSavingThrow {
  final SpellSavingThrowAbility ability;
  final SpellSaveSuccess onSuccess;

  const SpellSavingThrow({
    required this.ability,
    required this.onSuccess,
  });
}

/// Tipo di tiro per colpire richiesto dall'incantesimo.
enum SpellAttackType {
  melee,
  ranged,
}

/// Tipi di danno canonici.
///
/// Il catalogo degli incantesimi non deve dipendere da stringhe visuali
/// per rappresentare la meccanica.
enum SpellDamageType {
  acid,
  bludgeoning,
  cold,
  fire,
  force,
  lightning,
  necrotic,
  piercing,
  poison,
  psychic,
  radiant,
  slashing,
  thunder,
}

/// Un singolo pacchetto di danno.
///
/// `dice` usa la notazione canonica dell'app, per esempio "1d10".
class SpellDamage {
  final String dice;
  final SpellDamageType type;

  const SpellDamage({
    required this.dice,
    required this.type,
  });
}

/// Modalità con cui cresce un effetto dell'incantesimo.
enum SpellScalingType {
  characterLevel,
  slotLevel,
}

/// Uno step esplicito di scaling.
///
/// Esempio per un trucchetto:
/// threshold 5 -> damageDice "2d10".
///
/// Esempio per uno spell:
/// threshold 2 -> additionalDice "1d6" per ogni livello di slot oltre
/// quello base, usando scalingType == slotLevel.
class SpellScalingStep {
  final int threshold;
  final String damageDice;
  final String additionalDice;

  const SpellScalingStep({
    required this.threshold,
    this.damageDice = '',
    this.additionalDice = '',
  }) : assert(threshold > 0);
}

class SpellScaling {
  final SpellScalingType type;
  final List<SpellScalingStep> steps;

  const SpellScaling({
    required this.type,
    this.steps = const [],
  });
}

/// Modalità con cui un singolo proiettile risolve il proprio impatto.
enum SpellProjectileHitMode {
  automatic,
  spellAttack,
  savingThrow,
  special,
}

/// Effetto composto da più proiettili o impatti discreti.
///
/// Il danno appartiene al singolo proiettile, non all'intero spell.
/// In questo modo il motore conserva numero di impatti, distribuzione
/// dei bersagli e scaling senza appiattire tutto in un unico tiro.
class SpellProjectileEffect {
  /// Numero base di proiettili creati al livello base dello spell.
  final int baseProjectileCount;

  /// Modalità di risoluzione di ciascun proiettile.
  final SpellProjectileHitMode hitMode;

  /// Danno inflitto da ogni singolo proiettile.
  final SpellDamage damagePerProjectile;

  /// Più proiettili possono essere assegnati allo stesso bersaglio.
  final bool allowSameTarget;

  /// I proiettili possono essere distribuiti tra bersagli differenti.
  final bool allowDifferentTargets;

  /// Tutti gli impatti avvengono simultaneamente.
  final bool simultaneous;

  /// Numero di proiettili aggiunti per ogni livello di slot oltre
  /// il livello base dello spell.
  ///
  /// 0 indica assenza di questo tipo di scaling.
  final int additionalProjectilesPerSlotLevel;

  const SpellProjectileEffect({
    required this.baseProjectileCount,
    required this.hitMode,
    required this.damagePerProjectile,
    this.allowSameTarget = true,
    this.allowDifferentTargets = false,
    this.simultaneous = false,
    this.additionalProjectilesPerSlotLevel = 0,
  })  : assert(baseProjectileCount > 0),
        assert(additionalProjectilesPerSlotLevel >= 0);
}

/// Risorsa d'azione necessaria per riattivare un effetto di uno spell.
enum SpellRepeatActionType {
  action,
  bonusAction,
  reaction,
  special,
}

/// Condizione che termina anticipatamente un effetto mantenuto.
enum SpellMaintainedEffectEndCondition {
  casterUsesActionForSomethingElse,
  targetLeavesSpellRange,
  targetHasTotalCoverFromCaster,
  special,
}

/// Effetto che può essere attivato nuovamente mentre lo spell permane.
///
/// È distinto dal danno iniziale: alcuni incantesimi applicano infatti
/// scaling o modalità di risoluzione diverse tra il lancio iniziale e
/// le attivazioni dei turni successivi.
class SpellRepeatableEffect {
  final SpellRepeatActionType actionType;

  /// Danno prodotto da ogni attivazione successiva.
  final SpellDamage? damage;

  /// L'attivazione applica automaticamente l'effetto al bersaglio
  /// senza un nuovo tiro per colpire o tiro salvezza.
  final bool automatic;

  /// L'effetto rimane vincolato al bersaglio originale.
  final bool sameTarget;

  /// Condizioni che interrompono anticipatamente il legame.
  final Set<SpellMaintainedEffectEndCondition> endConditions;

  const SpellRepeatableEffect({
    required this.actionType,
    this.damage,
    this.automatic = false,
    this.sameTarget = false,
    this.endConditions = const {},
  });
}

/// Momento fino al quale resta attivo un effetto difensivo.
///
/// Questo dominio è separato da SpellDuration perché alcuni effetti
/// descrivono esplicitamente il proprio confine temporale rispetto ai
/// turni del combattimento.
enum SpellDefensiveEffectExpiry {
  spellDuration,
  startOfCastersNextTurn,
  endOfCastersNextTurn,
  special,
}

/// Effetto difensivo meccanico prodotto da un incantesimo.
///
/// I campi sono opzionali perché la stessa struttura deve poter
/// rappresentare bonus alla CA, protezioni contro specifici spell
/// e altre difese senza creare un tipo dedicato per ogni incantesimo.

/// Limita la sorgente dei danni ai quali si applica una resistenza.
enum SpellDamageSourceRestriction {
  /// Qualsiasi sorgente di danno.
  any,

  /// Qualsiasi attacco con arma.
  weaponAttack,

  /// Attacco in mischia con arma.
  meleeWeaponAttack,

  /// Attacco a distanza con arma.
  rangedWeaponAttack,

  /// Attacco con arma non magica.
  nonMagicalWeaponAttack,

  /// Attacco con arma magica.
  magicalWeaponAttack,

  /// Danni provenienti da un incantesimo.
  spell,
}

/// Una resistenza a uno o più tipi di danno.
class SpellDamageResistance {
  /// Tipi di danno coperti dalla resistenza.
  final Set<SpellDamageType> damageTypes;

  /// Eventuale restrizione sulla sorgente del danno.
  final SpellDamageSourceRestriction sourceRestriction;

  const SpellDamageResistance({
    required this.damageTypes,
    this.sourceRestriction = SpellDamageSourceRestriction.any,
  });
}

class SpellDefensiveEffect {
  /// Bonus alla Classe Armatura.
  final int? armorClassBonus;

  /// Il bonus alla CA si applica anche all'attacco che ha innescato
  /// il lancio della reazione.
  final bool appliesToTriggeringAttack;

  /// Incantesimi dai quali il bersaglio non subisce danni.
  final Set<String> preventsDamageFromSpellIds;

  /// Resistenze ai danni concesse dall'effetto.
  final List<SpellDamageResistance> resistances;

  /// Termine temporale specifico dell'effetto.
  final SpellDefensiveEffectExpiry expiry;

  const SpellDefensiveEffect({
    this.armorClassBonus,
    this.appliesToTriggeringAttack = false,
    this.preventsDamageFromSpellIds = const {},
    this.resistances = const [],
    this.expiry = SpellDefensiveEffectExpiry.spellDuration,
  });
}

/// Categoria generale di un effetto persistente creato da un incantesimo.
enum SpellPersistentEffectType {
  summonedCreature,
  createdCreature,
  createdObject,
  magicalLink,
  zone,
  special,
}

/// Tipo di creatura che un effetto può imporre alla creatura evocata.
///
/// `original` mantiene il tipo normale della forma scelta.
enum SpellCreatureTypeOverride {
  original,
  celestial,
  fey,
  fiend,
}

/// Definizione strutturata di una creatura persistente collegata
/// all'incantesimo.
///
/// Gli ID delle forme puntano al futuro catalogo canonico delle creature.
/// In questo modo lo spell non duplica blocchi statistiche.
class SpellCreatureEffect {
  /// Forme disponibili quando il lanciatore deve sceglierne una.
  final Set<String> formIds;

  /// Tipi che possono sostituire il tipo normale della forma.
  final Set<SpellCreatureTypeOverride> allowedTypeOverrides;

  /// Numero massimo di creature contemporaneamente legate a questo effetto.
  final int maximumActive;

  /// La creatura possiede una propria iniziativa e un proprio turno.
  final bool independentInitiative;

  /// La creatura obbedisce ai comandi dell'incantatore.
  final bool obeysCaster;

  /// Può effettuare attacchi normalmente.
  final bool canAttack;

  /// Scompare quando raggiunge 0 punti ferita.
  final bool disappearsAtZeroHp;

  const SpellCreatureEffect({
    this.formIds = const {},
    this.allowedTypeOverrides = const {
      SpellCreatureTypeOverride.original,
    },
    this.maximumActive = 1,
    this.independentInitiative = false,
    this.obeysCaster = false,
    this.canAttack = true,
    this.disappearsAtZeroHp = false,
  }) : assert(maximumActive > 0);
}

/// Capacità persistenti concesse dal legame creato dallo spell.
///
/// Sono separate dalla creatura evocata perché lo stesso modello potrà
/// rappresentare legami magici che non coinvolgono una summon.
class SpellLinkEffect {
  final double? telepathyRangeMeters;
  final bool shareSenses;
  final bool temporaryDismissal;
  final bool permanentDismissal;
  final double? reappearRangeMeters;

  /// Permette alla creatura collegata di trasmettere spell a contatto.
  final bool deliverTouchSpells;

  /// Distanza massima dal lanciatore per trasmettere lo spell.
  final double? touchSpellDeliveryRangeMeters;

  /// La trasmissione richiede la reazione della creatura collegata.
  final bool touchSpellDeliveryUsesReaction;

  const SpellLinkEffect({
    this.telepathyRangeMeters,
    this.shareSenses = false,
    this.temporaryDismissal = false,
    this.permanentDismissal = false,
    this.reappearRangeMeters,
    this.deliverTouchSpells = false,
    this.touchSpellDeliveryRangeMeters,
    this.touchSpellDeliveryUsesReaction = false,
  })  : assert(
          telepathyRangeMeters == null || telepathyRangeMeters >= 0,
        ),
        assert(
          reappearRangeMeters == null || reappearRangeMeters >= 0,
        ),
        assert(
          touchSpellDeliveryRangeMeters == null ||
              touchSpellDeliveryRangeMeters >= 0,
        );
}

class SpellPersistentEffect {
  final String id;
  final SpellPersistentEffectType type;
  final SpellCreatureEffect? creature;
  final SpellLinkEffect? link;

  /// Regole persistenti non ancora generalizzate dal motore.
  ///
  /// Non sostituisce la descrizione completa dello spell: serve a
  /// conservare in modo esplicito eventuali proprietà runtime residue
  /// mentre il dominio viene esteso.
  final Set<String> ruleTags;

  const SpellPersistentEffect({
    required this.id,
    required this.type,
    this.creature,
    this.link,
    this.ruleTags = const {},
  });
}

/// Definizione canonica di un incantesimo.
///
/// I trucchetti sono normali SpellDefinition con `level == 0`.
class SpellDefinition {
  final String id;
  final RuleContent content;

  /// 0 = trucchetto, 1-9 = livello dell'incantesimo.
  final int level;

  final SpellSchool school;
  final SpellCastingTime castingTime;
  final SpellRange range;
  final SpellArea? area;

  /// Interazioni ambientali o geometriche specifiche dell'area.
  final SpellAreaInteraction? areaInteraction;

  /// Regole di esclusione delle creature interessate dall'area.
  final SpellAreaExclusion? areaExclusion;

  /// Parete persistente evocata dall'incantesimo.
  final SpellWallDefinition? wall;

  final SpellComponents components;
  final SpellDuration duration;
  final SpellTarget target;

  final bool ritual;

  final SpellAttackType? attackType;
  final SpellSavingThrow? savingThrow;

  final List<SpellDamage> damage;
  final SpellScaling? scaling;

  /// Effetti attivati dalla presenza o dal movimento delle creature
  /// all'interno di un'area persistente.
  final List<SpellAreaTriggeredEffect> areaTriggeredEffects;

  /// Effetti costituiti da proiettili o impatti discreti.
  final List<SpellProjectileEffect> projectileEffects;

  /// Effetti riattivabili nei turni successivi durante la durata.
  final List<SpellRepeatableEffect> repeatableEffects;

  /// Effetti difensivi applicabili direttamente dal motore.
  final List<SpellDefensiveEffect> defensiveEffects;

  /// Effetti che continuano a esistere oltre la risoluzione immediata
  /// del lancio.
  final List<SpellPersistentEffect> persistentEffects;

  /// Classi che possiedono normalmente l'incantesimo nella propria lista.
  /// Gli ID sono canonici e non etichette UI.
  final Set<String> classIds;

  const SpellDefinition({
    required this.id,
    required this.content,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.target,
    this.area,
    this.areaInteraction,
    this.areaExclusion,
    this.wall,
    this.ritual = false,
    this.attackType,
    this.savingThrow,
    this.damage = const [],
    this.scaling,
    this.areaTriggeredEffects = const [],
    this.projectileEffects = const [],
    this.repeatableEffects = const [],
    this.defensiveEffects = const [],
    this.persistentEffects = const [],
    this.classIds = const {},
  }) : assert(level >= 0 && level <= 9);
}

/// Registry canonico degli incantesimi.
///
/// Verrà popolato progressivamente. Tenere un unico registry permette a
/// razze, classi, talenti e altri sistemi di riferirsi allo stesso ID.
abstract final class SpellIds {
  static const minorIllusion = 'minor_illusion';
  static const fireBolt = 'fire_bolt';
  static const acidSplash = 'acid_splash';
  static const gustOfWind = 'gust_of_wind';
  static const identify = 'identify';
  static const findFamiliar = 'find_familiar';

  // Definition aggiunta nel popolamento successivo.
  static const magicMissile = 'magic_missile';

  static const spiritGuardians = 'spirit_guardians';
  static const cloudOfDaggers = 'cloud_of_daggers';
  static const fireball = 'fireball';
  static const witchBolt = 'witch_bolt';
  static const shield = 'shield';
  static const bladeWard = 'blade_ward';
  static const chillTouch = 'chill_touch';
  static const dancingLights = 'dancing_lights';
  static const druidcraft = 'druidcraft';
  static const eldritchBlast = 'eldritch_blast';
  static const friends = 'friends';
  static const guidance = 'guidance';
  static const light = 'light';
  static const mageHand = 'mage_hand';
  static const mending = 'mending';
  static const message = 'message';
  static const poisonSpray = 'poison_spray';
  static const prestidigitation = 'prestidigitation';
  static const produceFlame = 'produce_flame';
  static const rayOfFrost = 'ray_of_frost';
  static const resistance = 'resistance';
  static const sacredFlame = 'sacred_flame';
  static const shillelagh = 'shillelagh';
  static const shockingGrasp = 'shocking_grasp';
  static const spareTheDying = 'spare_the_dying';
  static const thaumaturgy = 'thaumaturgy';
  static const trueStrike = 'true_strike';
  static const viciousMockery = 'vicious_mockery';
}

const Map<String, SpellDefinition> spellDefinitions = {
  SpellIds.spiritGuardians: SpellDefinition(
    id: SpellIds.spiritGuardians,
    content: RuleContent(
      id: SpellIds.spiritGuardians,
      name: 'Guardiani Spirituali',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Spiriti protettori fluttuano attorno all’incantatore.',
        details: 'Quando l’incantesimo viene lanciato l’incantatore sceglie '
            'qualsiasi numero di creature che non saranno influenzate. '
            'La velocità delle altre creature nell’area è dimezzata. '
            'Quando una creatura entra nell’area per la prima volta in '
            'un turno oppure vi inizia il proprio turno deve effettuare '
            'un tiro salvezza su Saggezza. Se fallisce subisce 3d8 danni '
            'radianti oppure necrotici (in base all’allineamento '
            'dell’incantatore); se supera il tiro subisce metà danni. '
            'Usando slot superiori il danno aumenta di 1d8 per ogni '
            'livello dello slot oltre il 3°.',
      ),
      ownerId: SpellIds.spiritGuardians,
    ),
    level: 3,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    area: SpellArea(
      shape: SpellAreaShape.radius,
      origin: SpellAreaOrigin.caster,
      radiusMeters: 4.5,
    ),
    areaExclusion: SpellAreaExclusion(
      type: SpellAreaExclusionType.chosenOnCast,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un simbolo sacro.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    areaTriggeredEffects: [
      SpellAreaTriggeredEffect(
        triggers: {
          SpellAreaTriggerEvent.entersAreaFirstTimeOnTurn,
          SpellAreaTriggerEvent.startsTurnInArea,
        },
        movementModifier: SpellMovementModifier(
          type: SpellMovementModifierType.multiplier,
          multiplier: 0.5,
        ),
        savingThrow: SpellSavingThrow(
          ability: SpellSavingThrowAbility.wisdom,
          onSuccess: SpellSaveSuccess.halfDamage,
        ),
        damage: SpellDamage(
          dice: '3d8',
          type: SpellDamageType.radiant,
        ),
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.slotLevel,
      steps: [
        SpellScalingStep(threshold: 4, additionalDice: '1d8'),
        SpellScalingStep(threshold: 5, additionalDice: '2d8'),
        SpellScalingStep(threshold: 6, additionalDice: '3d8'),
        SpellScalingStep(threshold: 7, additionalDice: '4d8'),
        SpellScalingStep(threshold: 8, additionalDice: '5d8'),
        SpellScalingStep(threshold: 9, additionalDice: '6d8'),
      ],
    ),
    classIds: {
      'cleric',
    },
  ),
  SpellIds.cloudOfDaggers: SpellDefinition(
    id: SpellIds.cloudOfDaggers,
    content: RuleContent(
      id: SpellIds.cloudOfDaggers,
      name: 'Nube di Pugnali',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Una nube di lame roteanti occupa un piccolo volume dello spazio.',
        details: 'L’incantatore riempie un cubo con lato di 1,5 metri di lame '
            'magiche roteanti, centrato su un punto scelto entro gittata. '
            'Una creatura subisce 4d4 danni taglienti quando entra '
            'nell’area per la prima volta in un turno oppure quando '
            'inizia il proprio turno al suo interno. '
            'Usando uno slot di 3° livello o superiore il danno aumenta '
            'di 2d4 per ogni livello dello slot oltre il 2°.',
      ),
      ownerId: SpellIds.cloudOfDaggers,
    ),
    level: 2,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    area: SpellArea(
      shape: SpellAreaShape.cube,
      origin: SpellAreaOrigin.targetPoint,
      sizeMeters: 1.5,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una scheggia di vetro.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    areaTriggeredEffects: [
      SpellAreaTriggeredEffect(
        triggers: {
          SpellAreaTriggerEvent.entersAreaFirstTimeOnTurn,
          SpellAreaTriggerEvent.startsTurnInArea,
        },
        damage: SpellDamage(
          dice: '4d4',
          type: SpellDamageType.slashing,
        ),
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.slotLevel,
      steps: [
        SpellScalingStep(
          threshold: 3,
          additionalDice: '2d4',
        ),
        SpellScalingStep(
          threshold: 4,
          additionalDice: '4d4',
        ),
        SpellScalingStep(
          threshold: 5,
          additionalDice: '6d4',
        ),
        SpellScalingStep(
          threshold: 6,
          additionalDice: '8d4',
        ),
        SpellScalingStep(
          threshold: 7,
          additionalDice: '10d4',
        ),
        SpellScalingStep(
          threshold: 8,
          additionalDice: '12d4',
        ),
        SpellScalingStep(
          threshold: 9,
          additionalDice: '14d4',
        ),
      ],
    ),
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.fireball: SpellDefinition(
    id: SpellIds.fireball,
    content: RuleContent(
      id: SpellIds.fireball,
      name: 'Palla di Fuoco',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Una scia di luce esplode nel punto scelto, investendo '
            'l’area circostante con un’esplosione di fiamme.',
        details: 'L’incantatore sceglie un punto entro gittata. Una scia '
            'di luce parte dal suo indice e raggiunge quel punto, dove '
            'detona generando un’esplosione di fiamme. Ogni creatura '
            'entro una sfera di 6 metri di raggio centrata sul punto '
            'effettua un tiro salvezza su Destrezza. Una creatura che '
            'fallisce subisce 8d6 danni da fuoco; se supera il tiro '
            'salvezza subisce metà dei danni. Il fuoco si diffonde '
            'oltre gli angoli e incendia gli oggetti infiammabili '
            'nell’area che non siano indossati o trasportati. '
            'Usando uno slot di 4° livello o superiore, i danni '
            'aumentano di 1d6 per ogni livello dello slot oltre il 3°.',
      ),
      ownerId: SpellIds.fireball,
    ),
    level: 3,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 45,
    ),
    area: SpellArea(
      shape: SpellAreaShape.sphere,
      origin: SpellAreaOrigin.targetPoint,
      radiusMeters: 6,
    ),
    areaInteraction: SpellAreaInteraction(
      spreadsAroundCorners: true,
      objectInteraction: SpellAreaObjectInteractionType.ignite,
      objectConditions: {
        SpellAreaObjectCondition.flammable,
        SpellAreaObjectCondition.notWorn,
        SpellAreaObjectCondition.notCarried,
      },
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una piccola sfera di sterco di pipistrello e zolfo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.point,
        SpellTargetType.area,
        SpellTargetType.creatures,
      },
    ),
    savingThrow: SpellSavingThrow(
      ability: SpellSavingThrowAbility.dexterity,
      onSuccess: SpellSaveSuccess.halfDamage,
    ),
    damage: [
      SpellDamage(
        dice: '8d6',
        type: SpellDamageType.fire,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.slotLevel,
      steps: [
        SpellScalingStep(
          threshold: 4,
          additionalDice: '1d6',
        ),
        SpellScalingStep(
          threshold: 5,
          additionalDice: '2d6',
        ),
        SpellScalingStep(
          threshold: 6,
          additionalDice: '3d6',
        ),
        SpellScalingStep(
          threshold: 7,
          additionalDice: '4d6',
        ),
        SpellScalingStep(
          threshold: 8,
          additionalDice: '5d6',
        ),
        SpellScalingStep(
          threshold: 9,
          additionalDice: '6d6',
        ),
      ],
    ),
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.witchBolt: SpellDefinition(
    id: SpellIds.witchBolt,
    content: RuleContent(
      id: SpellIds.witchBolt,
      name: 'Dardo Stregato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Un raggio di energia crea una scarica di fulmini prolungata '
            'tra l’incantatore e una creatura.',
        details: 'L’incantatore effettua un attacco a distanza con questo '
            'incantesimo contro una creatura entro gittata. Se colpisce, '
            'il bersaglio subisce 1d12 danni da fulmine. Finché '
            'l’incantesimo permane, durante ogni proprio turno '
            'l’incantatore può usare la propria azione per infliggere '
            'automaticamente 1d12 danni da fulmine allo stesso bersaglio. '
            'L’incantesimo termina se l’incantatore usa la propria azione '
            'per fare qualsiasi altra cosa, se il bersaglio esce dalla '
            'gittata oppure se ottiene copertura totale nei confronti '
            'dell’incantatore. Usando slot superiori aumenta soltanto il '
            'danno dell’attacco iniziale.',
      ),
      ownerId: SpellIds.witchBolt,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un rametto di un albero colpito da un fulmine.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,

    // Danno dell'attacco iniziale.
    damage: [
      SpellDamage(
        dice: '1d12',
        type: SpellDamageType.lightning,
      ),
    ],

    // Lo scaling riguarda esclusivamente il danno iniziale.
    scaling: SpellScaling(
      type: SpellScalingType.slotLevel,
      steps: [
        SpellScalingStep(
          threshold: 2,
          additionalDice: '1d12',
        ),
        SpellScalingStep(
          threshold: 3,
          additionalDice: '2d12',
        ),
        SpellScalingStep(
          threshold: 4,
          additionalDice: '3d12',
        ),
        SpellScalingStep(
          threshold: 5,
          additionalDice: '4d12',
        ),
        SpellScalingStep(
          threshold: 6,
          additionalDice: '5d12',
        ),
        SpellScalingStep(
          threshold: 7,
          additionalDice: '6d12',
        ),
        SpellScalingStep(
          threshold: 8,
          additionalDice: '7d12',
        ),
        SpellScalingStep(
          threshold: 9,
          additionalDice: '8d12',
        ),
      ],
    ),

    // Nei turni successivi non si effettua un nuovo attacco:
    // l'azione infligge automaticamente 1d12 allo stesso bersaglio.
    repeatableEffects: [
      SpellRepeatableEffect(
        actionType: SpellRepeatActionType.action,
        damage: SpellDamage(
          dice: '1d12',
          type: SpellDamageType.lightning,
        ),
        automatic: true,
        sameTarget: true,
        endConditions: {
          SpellMaintainedEffectEndCondition.casterUsesActionForSomethingElse,
          SpellMaintainedEffectEndCondition.targetLeavesSpellRange,
          SpellMaintainedEffectEndCondition.targetHasTotalCoverFromCaster,
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.magicMissile: SpellDefinition(
    id: SpellIds.magicMissile,
    content: RuleContent(
      id: SpellIds.magicMissile,
      name: 'Dardo Incantato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea tre dardi di forza magica che colpiscono automaticamente i bersagli scelti.',
        details: 'L’incantatore crea tre dardi luminosi di forza magica. '
            'Ogni dardo colpisce una creatura scelta dall’incantatore '
            'entro gittata e infligge 1d4 + 1 danni da forza. I dardi '
            'colpiscono simultaneamente e possono essere diretti contro '
            'una sola creatura oppure contro creature differenti. Quando '
            'l’incantesimo viene lanciato usando uno slot di 2° livello '
            'o superiore, crea un dardo aggiuntivo per ogni livello dello '
            'slot oltre il 1°.',
      ),
      ownerId: SpellIds.magicMissile,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 36,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },

      // Non fissiamo maximumTargets a 3:
      // usando slot superiori il numero massimo di creature distinte
      // cresce insieme al numero dei dardi.
      maximumTargets: null,
    ),
    projectileEffects: [
      SpellProjectileEffect(
        baseProjectileCount: 3,
        hitMode: SpellProjectileHitMode.automatic,
        damagePerProjectile: SpellDamage(
          dice: '1d4+1',
          type: SpellDamageType.force,
        ),
        allowSameTarget: true,
        allowDifferentTargets: true,
        simultaneous: true,
        additionalProjectilesPerSlotLevel: 1,
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.shield: SpellDefinition(
    id: SpellIds.shield,
    content: RuleContent(
      id: SpellIds.shield,
      name: 'Scudo',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Una barriera invisibile protegge istantaneamente l’incantatore.',
        details: 'Fino all’inizio del proprio turno successivo, l’incantatore '
            'ottiene un bonus di +5 alla CA. Il bonus si applica anche '
            'all’attacco che ha innescato il lancio dell’incantesimo. '
            'Durante questo periodo l’incantatore non subisce inoltre '
            'danni da Dardo Incantato.',
      ),
      ownerId: SpellIds.shield,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.reaction,
      reactionTrigger:
          'Quando l’incantatore viene colpito da un attacco o viene '
          'bersagliato da Dardo Incantato.',
      reactionTriggers: [
        SpellReactionTrigger(
          event: SpellReactionEvent.hitByAttack,
        ),
        SpellReactionTrigger(
          event: SpellReactionEvent.targetedBySpell,
          spellIds: {
            SpellIds.magicMissile,
          },
        ),
      ],
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.round,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    defensiveEffects: [
      SpellDefensiveEffect(
        armorClassBonus: 5,
        appliesToTriggeringAttack: true,
        preventsDamageFromSpellIds: {
          SpellIds.magicMissile,
        },
        expiry: SpellDefensiveEffectExpiry.startOfCastersNextTurn,
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.findFamiliar: SpellDefinition(
    id: SpellIds.findFamiliar,
    content: RuleContent(
      id: SpellIds.findFamiliar,
      name: 'Trova Famiglio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Ottiene il servizio di uno spirito che assume una forma animale scelta dall’incantatore.',
        details: 'Il famiglio compare in uno spazio libero entro gittata e '
            'possiede le statistiche della forma scelta, ma è un celestiale, '
            'un folletto o un immondo, a scelta dell’incantatore, anziché '
            'una bestia. Agisce indipendentemente, tira la propria iniziativa '
            'e obbedisce ai comandi dell’incantatore; non può attaccare ma '
            'può effettuare normalmente le altre azioni. A 0 punti ferita '
            'scompare senza lasciare una forma fisica e ricompare dopo un '
            'nuovo lancio dell’incantesimo. Entro 30 metri l’incantatore '
            'può comunicare telepaticamente con il famiglio e, usando '
            'un’azione, percepire attraverso i suoi sensi fino all’inizio '
            'del proprio turno successivo, beneficiando dei suoi sensi '
            'speciali ma risultando nel frattempo cieco e sordo rispetto '
            'ai propri sensi. Con un’azione il famiglio può essere congedato '
            'temporaneamente in una sacca dimensionale oppure per sempre; '
            'se congedato temporaneamente può essere richiamato con '
            'un’azione in uno spazio libero entro 9 metri. L’incantatore '
            'non può avere più di un famiglio alla volta. Un nuovo lancio '
            'quando ne possiede già uno può assegnargli una nuova forma. '
            'Quando l’incantatore lancia un incantesimo con gittata a '
            'contatto, il famiglio entro 30 metri può trasmetterlo usando '
            'la propria reazione; se è richiesto un tiro per colpire viene '
            'usato il modificatore di attacco dell’incantatore.',
      ),
      ownerId: SpellIds.findFamiliar,
    ),
    level: 1,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.hour,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 3,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Carbone, incenso ed erbe del valore complessivo di 10 monete d’oro.',
          minimumCostGp: 10,
          consumed: true,
        ),
        SpellMaterialComponent(
          description: 'Un braciere d’ottone in cui bruciare i materiali.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    ritual: true,
    persistentEffects: [
      SpellPersistentEffect(
        id: 'find_familiar_companion',
        type: SpellPersistentEffectType.summonedCreature,
        creature: SpellCreatureEffect(
          allowedTypeOverrides: {
            SpellCreatureTypeOverride.celestial,
            SpellCreatureTypeOverride.fey,
            SpellCreatureTypeOverride.fiend,
          },
          maximumActive: 1,
          independentInitiative: true,
          obeysCaster: true,
          canAttack: false,
          disappearsAtZeroHp: true,
        ),
        link: SpellLinkEffect(
          telepathyRangeMeters: 30,
          shareSenses: true,
          temporaryDismissal: true,
          permanentDismissal: true,
          reappearRangeMeters: 9,
          deliverTouchSpells: true,
          touchSpellDeliveryRangeMeters: 30,
          touchSpellDeliveryUsesReaction: true,
        ),
        ruleTags: {
          'choose_familiar_form',
          'familiar_uses_chosen_form_statistics',
          'share_special_senses',
          'caster_blind_deaf_while_sharing_senses',
          'recast_restores_after_zero_hp',
          'recast_changes_existing_familiar_form',
          'touch_spell_uses_caster_attack_modifier',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.identify: SpellDefinition(
    id: SpellIds.identify,
    content: RuleContent(
      id: SpellIds.identify,
      name: 'Identificare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rivela le proprietà magiche di un oggetto toccato o gli incantesimi che influenzano una creatura.',
        details: 'L’incantatore sceglie un oggetto che deve toccare durante '
            'l’intero lancio. Se si tratta di un oggetto magico o di un '
            'altro oggetto infuso di magia, apprende le sue proprietà e '
            'come usarlo, se richiede sintonia per essere usato e quante '
            'cariche contiene, se ne contiene. Apprende inoltre se '
            'l’oggetto è influenzato da incantesimi e quali sono. Se '
            'l’oggetto è stato creato da un incantesimo, apprende quale '
            'incantesimo lo ha creato. Se invece tocca una creatura '
            'durante il lancio, apprende quali incantesimi la influenzano '
            'attualmente, se ce ne sono.',
      ),
      ownerId: SpellIds.identify,
    ),
    level: 1,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una perla del valore di almeno 100 monete d’oro.',
          minimumCostGp: 100,
        ),
        SpellMaterialComponent(
          description: 'Una piuma di gufo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    ritual: true,
    classIds: {
      'bard',
      'wizard',
    },
  ),
  SpellIds.gustOfWind: SpellDefinition(
    id: SpellIds.gustOfWind,
    content: RuleContent(
      id: SpellIds.gustOfWind,
      name: 'Folata di Vento',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Genera dall’incantatore una forte linea di vento lunga 18 metri e larga 3 metri.',
        details: 'La linea si estende dall’incantatore nella direzione scelta '
            'per tutta la durata. Ogni creatura che inizia il proprio turno '
            'nella linea deve superare un tiro salvezza su Forza oppure '
            'viene spinta di 4,5 metri lontano dall’incantatore, nella '
            'direzione della linea. Una creatura nella linea deve spendere '
            '60 cm di movimento per ogni 30 cm percorsi verso '
            'l’incantatore. La folata disperde gas e vapori ed estingue '
            'candele, torce e simili fiamme non protette nell’area. Le '
            'fiamme protette tremolano e hanno una probabilità del 50% di '
            'spegnersi. In ogni proprio turno prima della fine '
            'dell’incantesimo, l’incantatore può usare un’azione bonus per '
            'cambiare la direzione della linea.',
      ),
      ownerId: SpellIds.gustOfWind,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    area: SpellArea(
      shape: SpellAreaShape.line,
      origin: SpellAreaOrigin.caster,
      lengthMeters: 18,
      widthMeters: 3,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Il seme di un legume.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    savingThrow: SpellSavingThrow(
      ability: SpellSavingThrowAbility.strength,
      onSuccess: SpellSaveSuccess.negates,
    ),
    classIds: {
      'druid',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.acidSplash: SpellDefinition(
    id: SpellIds.acidSplash,
    content: RuleContent(
      id: SpellIds.acidSplash,
      name: 'Fiotto Acido',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Scaglia una bolla di acido contro una o due creature entro gittata.',
        details: 'L’incantatore sceglie una creatura entro gittata oppure due '
            'creature entro gittata situate a non più di 1,5 metri l’una '
            'dall’altra. Ogni bersaglio deve superare un tiro salvezza su '
            'Destrezza, altrimenti subisce 1d6 danni da acido. I danni '
            'aumentano a 2d6 al 5° livello, 3d6 all’11° livello e 4d6 '
            'al 17° livello.',
      ),
      ownerId: SpellIds.acidSplash,
    ),
    level: 0,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 2,
      maximumDistanceBetweenTargetsMeters: 1.5,
    ),
    savingThrow: SpellSavingThrow(
      ability: SpellSavingThrowAbility.dexterity,
      onSuccess: SpellSaveSuccess.negates,
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.acid,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d6',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d6',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d6',
        ),
      ],
    ),
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.fireBolt: SpellDefinition(
    id: SpellIds.fireBolt,
    content: RuleContent(
      id: SpellIds.fireBolt,
      name: 'Dardo di Fuoco',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Scaglia una scintilla di fuoco contro una creatura o un oggetto entro gittata.',
        details: 'L’incantatore effettua un attacco a distanza con questo '
            'incantesimo contro il bersaglio. Se colpisce, il bersaglio '
            'subisce 1d10 danni da fuoco. Un oggetto infiammabile colpito '
            'si incendia se non è indossato o trasportato. I danni '
            'aumentano con il livello dell’incantatore: 2d10 al 5° livello, '
            '3d10 all’11° livello e 4d10 al 17° livello.',
      ),
      ownerId: SpellIds.fireBolt,
    ),
    level: 0,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 36,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '1d10',
        type: SpellDamageType.fire,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d10',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d10',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d10',
        ),
      ],
    ),
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.minorIllusion: SpellDefinition(
    id: SpellIds.minorIllusion,
    content: RuleContent(
      id: SpellIds.minorIllusion,
      name: 'Illusione Minore',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea entro gittata un suono oppure l’immagine illusoria di un oggetto.',
        details: 'L’effetto permane fino alla fine della durata, salvo che '
            'l’incantatore lo interrompa usando un’azione o lanci di nuovo '
            'questo incantesimo. Se viene creato un suono, il suo volume può '
            'andare da un sussurro a un urlo e può riprodurre voci, versi, '
            'rumori o altri suoni scelti dall’incantatore; può essere '
            'continuo oppure manifestarsi in momenti distinti durante la '
            'durata. Se viene creata l’immagine di un oggetto, questa deve '
            'rientrare in un cubo con spigolo di 1,5 metri e non può '
            'produrre suoni, luce, odori o altri effetti sensoriali. '
            'L’interazione fisica rivela l’illusione perché gli oggetti la '
            'attraversano. Una creatura può usare la propria azione per '
            'esaminare il suono o l’immagine ed effettuare una prova di '
            'Intelligenza (Indagare) contro la CD del tiro salvezza '
            'dell’incantesimo; se riconosce l’illusione, questa si attenua '
            'per quella creatura.',
      ),
      ownerId: SpellIds.minorIllusion,
    ),
    level: 0,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un ciuffo di lana.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
};

SpellDefinition? spellDefinitionFor(String id) => spellDefinitions[id];

/// Restituisce tutti gli incantesimi compatibili con i vincoli richiesti.
///
/// Attualmente restituisce tutti gli incantesimi.
/// I filtri verranno implementati nella Fase 8 del runtime.
List<SpellDefinition> spellDefinitionsMatching(
  List<CharacterChoiceConstraint> constraints,
) {
  Iterable<SpellDefinition> result = spellDefinitions.values;

  for (final constraint in constraints) {
    switch (constraint.key) {
      case CharacterChoiceConstraintKeys.spellLevel:
        if (constraint.values.isEmpty) {
          break;
        }

        final level = int.tryParse(constraint.values.first);

        if (level == null) {
          break;
        }

        result = result.where((spell) => spell.level == level);
        break;

      case CharacterChoiceConstraintKeys.ritual:
        result = result.where((spell) => spell.ritual);
        break;

      case CharacterChoiceConstraintKeys.classId:
        if (constraint.values.isEmpty) {
          break;
        }

        result = result.where(
          (spell) => constraint.values.any(
            spell.classIds.contains,
          ),
        );
        break;
    }
  }

  return result.toList();
}

bool isCantripDefinition(SpellDefinition spell) => spell.level == 0;
