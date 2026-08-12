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
  static const alarm = 'alarm';
  static const animalFriendship = 'animal_friendship';
  static const bane = 'bane';
  static const armorOfAgathys = 'armor_of_agathys';
  static const mageArmor = 'mage_armor';
  static const goodberry = 'goodberry';
  static const bless = 'bless';
  static const armsOfHadar = 'arms_of_hadar';
  static const featherFall = 'feather_fall';
  static const disguiseSelf = 'disguise_self';
  static const charmPerson = 'charm_person';
  static const ensnaringStrike = 'ensnaring_strike';
  static const command = 'command';
  static const comprehendLanguages = 'comprehend_languages';
  static const createOrDestroyWater = 'create_or_destroy_water';
  static const cureWounds = 'cure_wounds';
  static const guidingBolt = 'guiding_bolt';
  static const tensersFloatingDisk = 'tensers_floating_disk';
  static const compelledDuel = 'compelled_duel';
  static const heroism = 'heroism';
  static const divineFavor = 'divine_favor';
  static const chromaticOrb = 'chromatic_orb';
  static const silentImage = 'silent_image';
  static const detectEvilAndGood = 'detect_evil_and_good';
  static const detectMagic = 'detect_magic';
  static const detectPoisonAndDisease = 'detect_poison_and_disease';
  static const inflictWounds = 'inflict_wounds';
  static const hellishRebuke = 'hellish_rebuke';
  static const entangle = 'entangle';
  static const faerieFire = 'faerie_fire';
  static const burningHands = 'burning_hands';
  static const huntersMark = 'hunters_mark';
  static const fogCloud = 'fog_cloud';
  static const thunderwave = 'thunderwave';
  static const speakWithAnimals = 'speak_with_animals';
  static const healingWord = 'healing_word';
  static const longstrider = 'longstrider';
  static const protectionFromEvilAndGood = 'protection_from_evil_and_good';
  static const wrathfulSmite = 'wrathful_smite';
  static const searingSmite = 'searing_smite';
  static const thunderousSmite = 'thunderous_smite';
  static const purifyFoodAndDrink = 'purify_food_and_drink';
  static const hailOfThorns = 'hail_of_thorns';
  static const rayOfSickness = 'ray_of_sickness';
  static const tashasHideousLaughter = 'tashas_hideous_laughter';
  static const expeditiousRetreat = 'expeditious_retreat';
  static const jump = 'jump';
  static const sanctuary = 'sanctuary';
  static const shieldOfFaith = 'shield_of_faith';
  static const illusoryScript = 'illusory_script';
  static const unseenServant = 'unseen_servant';
  static const sleep = 'sleep';
  static const hex = 'hex';
  static const colorSpray = 'color_spray';
  static const dissonantWhispers = 'dissonant_whispers';
  static const grease = 'grease';
  static const falseLife = 'false_life';
  static const aid = 'aid';
  static const phantasmalForce = 'phantasmal_force';
  static const alterSelf = 'alter_self';
  static const animalMessenger = 'animal_messenger';
  static const magicWeapon = 'magic_weapon';
  static const spiritualWeapon = 'spiritual_weapon';
  static const nystulsMagicAura = 'nystuls_magic_aura';
  static const moonbeam = 'moonbeam';
  static const holdPerson = 'hold_person';
  static const magicMouth = 'magic_mouth';
  static const calmEmotions = 'calm_emotions';
  static const enhanceAbility = 'enhance_ability';
  static const blindnessDeafness = 'blindness_deafness';
  static const cordonOfArrows = 'cordon_of_arrows';
  static const crownOfMadness = 'crown_of_madness';
  static const spikeGrowth = 'spike_growth';
  static const enthrall = 'enthrall';
  static const continualFlame = 'continual_flame';
  static const shatter = 'shatter';
  static const melfsAcidArrow = 'melfs_acid_arrow';
  static const mirrorImage = 'mirror_image';
  static const detectThoughts = 'detect_thoughts';
  static const enlargeReduce = 'enlarge_reduce';
  static const invisibility = 'invisibility';
  static const flameBlade = 'flame_blade';
  static const levitate = 'levitate';
  static const locateAnimalsOrPlants = 'locate_animals_or_plants';
  static const locateObject = 'locate_object';
  static const spiderClimb = 'spider_climb';
  static const darkness = 'darkness';
  static const passWithoutTrace = 'pass_without_trace';
  static const mistyStep = 'misty_step';
  static const barkskin = 'barkskin';
  static const beastSense = 'beast_sense';
  static const prayerOfHealing = 'prayer_of_healing';
  static const augury = 'augury';
  static const protectionFromPoison = 'protection_from_poison';
  static const brandingSmite = 'branding_smite';
  static const rayOfEnfeeblement = 'ray_of_enfeeblement';
  static const scorchingRay = 'scorching_ray';
  static const web = 'web';
  static const gentleRepose = 'gentle_repose';
  static const heatMetal = 'heat_metal';
  static const lesserRestoration = 'lesser_restoration';
  static const knock = 'knock';
  static const findTraps = 'find_traps';
  static const darkvision = 'darkvision';
  static const arcaneLock = 'arcane_lock';
  static const flamingSphere = 'flaming_sphere';
  static const blur = 'blur';
  static const silence = 'silence';
  static const suggestion = 'suggestion';
  static const findSteed = 'find_steed';
  static const ropeTrick = 'rope_trick';
  static const seeInvisibility = 'see_invisibility';
  static const wardingBond = 'warding_bond';
  static const zoneOfTruth = 'zone_of_truth';
  static const animateDead = 'animate_dead';
  static const nondetection = 'nondetection';
  static const elementalWeapon = 'elemental_weapon';
  static const auraOfVitality = 'aura_of_vitality';
  static const waterWalk = 'water_walk';
  static const leomundsTinyHut = 'leomunds_tiny_hut';
  static const magicCircle = 'magic_circle';
  static const clairvoyance = 'clairvoyance';
  static const counterspell = 'counterspell';
  static const createFoodAndWater = 'create_food_and_water';
  static const plantGrowth = 'plant_growth';
  static const phantomSteed = 'phantom_steed';
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'magic_missile_automatic_force_darts',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_three_darts_of_magical_force',
          'each_dart_hits_automatically',
          'each_dart_deals_1d4_plus_1_force_damage',
          'darts_can_target_one_or_more_creatures',
          'one_additional_dart_per_slot_level_above_1',
        },
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'identify_item_or_creature_information',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'reveals_magic_item_properties_and_how_to_use_them',
          'reveals_attunement_requirement',
          'reveals_number_of_charges',
          'reveals_spells_affecting_item_or_creature',
          'can_identify_spell_that_created_item',
        },
      ),
    ],
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'gust_of_wind_line_push_and_difficult_movement',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_line_of_strong_wind',
          'creatures_starting_turn_in_line_make_strength_save',
          'failed_save_pushes_creature_4_5_meters_away',
          'movement_toward_caster_costs_extra_movement',
          'disperses_gas_or_vapor',
          'can_change_direction_as_bonus_action',
        },
      ),
    ],
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'minor_illusion_sound_or_image',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_sound_or_image_within_range',
          'image_fits_within_1_5_meter_cube',
          'image_cannot_create_sound_light_smell_or_sensory_effect',
          'physical_interaction_reveals_illusion',
          'investigation_check_can_reveal_illusion',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.bladeWard: SpellDefinition(
    id: SpellIds.bladeWard,
    content: RuleContent(
      id: SpellIds.bladeWard,
      name: 'Interdizione alle Lame',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Traccia un simbolo di interdizione che protegge dagli attacchi con armi.',
        details: 'L’incantatore protende la mano e traccia un simbolo di '
            'interdizione nell’aria. Fino alla fine del suo turno successivo '
            'possiede resistenza ai danni contundenti, perforanti e taglienti '
            'inflitti dagli attacchi con armi.',
      ),
      ownerId: SpellIds.bladeWard,
    ),
    level: 0,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
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
        resistances: [
          SpellDamageResistance(
            damageTypes: {
              SpellDamageType.bludgeoning,
              SpellDamageType.piercing,
              SpellDamageType.slashing,
            },
            sourceRestriction: SpellDamageSourceRestriction.weaponAttack,
          ),
        ],
        expiry: SpellDefensiveEffectExpiry.endOfCastersNextTurn,
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.chillTouch: SpellDefinition(
    id: SpellIds.chillTouch,
    content: RuleContent(
      id: SpellIds.chillTouch,
      name: 'Tocco Gelido',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una mano spettrale che assale una creatura e ostacola la guarigione.',
        details:
            'L’incantatore crea una mano scheletrica e spettrale nello spazio '
            'di una creatura entro gittata ed effettua un attacco a distanza '
            'con incantesimo. Se colpisce, il bersaglio subisce 1d8 danni '
            'necrotici e non può recuperare punti ferita fino all’inizio del '
            'turno successivo dell’incantatore. Se il bersaglio è un non '
            'morto, subisce anche svantaggio ai tiri per colpire contro '
            'l’incantatore fino alla fine del turno successivo '
            'dell’incantatore. I danni aumentano a 2d8 al 5° livello, '
            '3d8 all’11° livello e 4d8 al 17° livello.',
      ),
      ownerId: SpellIds.chillTouch,
    ),
    level: 0,
    school: SpellSchool.necromancy,
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
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.necrotic,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d8',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d8',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d8',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'chill_touch_no_healing_until_next_turn',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_cannot_regain_hit_points_until_start_of_casters_next_turn',
          'undead_target_disadvantage_on_attacks_against_caster',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.dancingLights: SpellDefinition(
    id: SpellIds.dancingLights,
    content: RuleContent(
      id: SpellIds.dancingLights,
      name: 'Luci Danzanti',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Crea fino a quattro luci magiche che illuminano l’area.',
        details:
            'L’incantatore crea fino a quattro luci delle dimensioni di una '
            'torcia entro gittata. Le luci possono apparire come torce, '
            'lanterne o globi luminosi fluttuanti, oppure combinarsi in una '
            'forma luminosa vagamente umanoide. Ogni luce diffonde luce fioca '
            'entro 3 metri. Come azione bonus l’incantatore può muovere le '
            'luci fino a 18 metri, rispettando la gittata e mantenendole entro '
            '6 metri l’una dall’altra.',
      ),
      ownerId: SpellIds.dancingLights,
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
      materials: [
        SpellMaterialComponent(
          description:
              'Un pezzetto di fosforo, di legno stregato o una lucciola.',
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
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'dancing_lights_luminous_objects',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_up_to_four_dim_lights',
          'bonus_action_move_lights',
          'lights_must_remain_within_range_and_within_6_meters_each_other',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.druidcraft: SpellDefinition(
    id: SpellIds.druidcraft,
    content: RuleContent(
      id: SpellIds.druidcraft,
      name: 'Arte Druidica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Produce un piccolo effetto naturale o sensoriale.',
        details:
            'L’incantatore crea uno dei piccoli effetti concessi dalla magia '
            'druidica: predice il tempo atmosferico locale per le successive '
            '24 ore, fa sbocciare o maturare istantaneamente un fiore, un '
            'seme o un baccello, crea un effetto sensoriale naturale '
            'innocuo oppure accende o spegne una candela, una torcia o un '
            'piccolo fuoco da campo.',
      ),
      ownerId: SpellIds.druidcraft,
    ),
    level: 0,
    school: SpellSchool.transmutation,
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
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'druidcraft_minor_nature_effect',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'predict_weather_24_hours',
          'open_or_close_plant',
          'harmless_natural_sensory_effect',
          'light_or_extinguish_small_flame',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.eldritchBlast: SpellDefinition(
    id: SpellIds.eldritchBlast,
    content: RuleContent(
      id: SpellIds.eldritchBlast,
      name: 'Deflagrazione Occulta',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Un raggio di energia crepitante colpisce una creatura entro gittata.',
        details:
            'L’incantatore scaglia un raggio di energia crepitante contro una '
            'creatura entro gittata ed effettua un attacco a distanza con '
            'incantesimo. Se colpisce, il bersaglio subisce 1d10 danni da '
            'forza. L’incantesimo crea più raggi ai livelli superiori: due '
            'raggi al 5° livello, tre all’11° livello e quattro al 17° livello. '
            'Ogni raggio richiede un tiro per colpire separato e può bersagliare '
            'la stessa creatura o creature diverse.',
      ),
      ownerId: SpellIds.eldritchBlast,
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
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '1d10',
        type: SpellDamageType.force,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'eldritch_blast_multiple_beams',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'beam_count_1_base_2_at_5_3_at_11_4_at_17',
          'separate_attack_roll_for_each_beam',
          'beams_can_target_same_or_different_creatures',
        },
      ),
    ],
    classIds: {
      'warlock',
    },
  ),
  SpellIds.friends: SpellDefinition(
    id: SpellIds.friends,
    content: RuleContent(
      id: SpellIds.friends,
      name: 'Amicizia',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Conferisce vantaggio alle prove di Carisma contro una creatura non ostile.',
        details:
            'Per la durata dell’incantesimo l’incantatore dispone di vantaggio '
            'alle prove di Carisma rivolte contro una creatura a sua scelta '
            'che non sia ostile nei suoi confronti. Quando l’incantesimo '
            'termina, la creatura capisce che l’incantatore ha usato la magia '
            'per influenzare il suo umore e potrebbe diventare ostile.',
      ),
      ownerId: SpellIds.friends,
    ),
    level: 0,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una piccola quantità di trucco da applicare al volto.',
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
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'friends_charisma_advantage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'advantage_on_charisma_checks_against_one_nonhostile_creature',
          'target_knows_magic_was_used_when_spell_ends',
          'target_may_become_hostile_after_spell_ends',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.guidance: SpellDefinition(
    id: SpellIds.guidance,
    content: RuleContent(
      id: SpellIds.guidance,
      name: 'Guida',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Concede a una creatura un bonus di 1d4 a una prova di caratteristica.',
        details:
            'L’incantatore tocca una creatura consenziente. Una volta prima '
            'che l’incantesimo termini, il bersaglio può tirare 1d4 e '
            'aggiungere il risultato a una prova di caratteristica a sua '
            'scelta. Può tirare il dado prima o dopo avere effettuato la '
            'prova, poi l’incantesimo termina.',
      ),
      ownerId: SpellIds.guidance,
    ),
    level: 0,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'guidance_ability_check_bonus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_adds_1d4_to_one_ability_check',
          'can_roll_before_or_after_ability_check',
          'spell_ends_after_bonus_is_used',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
    },
  ),
  SpellIds.light: SpellDefinition(
    id: SpellIds.light,
    content: RuleContent(
      id: SpellIds.light,
      name: 'Luce',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Fa risplendere un oggetto e illumina l’area circostante.',
        details:
            'L’incantatore tocca un oggetto non più grande di 3 metri in ogni '
            'dimensione. Finché l’incantesimo non termina, l’oggetto emana luce '
            'intensa entro 6 metri e luce fioca per altri 6 metri. La luce può '
            'essere colorata a scelta dell’incantatore. Coprire completamente '
            'l’oggetto con qualcosa di opaco blocca la luce. L’incantesimo '
            'termina se viene lanciato di nuovo o se l’incantatore lo interrompe '
            'con un’azione. Se l’oggetto è impugnato o posseduto da una creatura '
            'ostile, quella creatura può effettuare un tiro salvezza su '
            'Destrezza per evitare l’incantesimo.',
      ),
      ownerId: SpellIds.light,
    ),
    level: 0,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una lucciola o del muschio fosforescente.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'light_illuminated_object',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'object_sheds_bright_light_6_meters_and_dim_light_6_meters',
          'opaque_cover_blocks_light',
          'hostile_holder_gets_dexterity_save',
          'ends_if_cast_again_or_dismissed_as_action',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.mageHand: SpellDefinition(
    id: SpellIds.mageHand,
    content: RuleContent(
      id: SpellIds.mageHand,
      name: 'Mano Magica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una mano spettrale fluttuante che può manipolare oggetti.',
        details:
            'Una mano spettrale fluttuante appare in un punto entro gittata. '
            'La mano permane per la durata dell’incantesimo o finché '
            'l’incantatore non la congeda con un’azione. La mano svanisce se '
            'si trova a più di 9 metri dall’incantatore o se l’incantesimo '
            'viene lanciato di nuovo. L’incantatore può usare la sua azione '
            'per controllarla, manipolare un oggetto, aprire una porta o un '
            'contenitore non chiuso a chiave, recuperare o riporre un oggetto '
            'da un contenitore aperto o versare il contenuto di una fiala. '
            'La mano non può attaccare, attivare oggetti magici o trasportare '
            'più di 5 kg.',
      ),
      ownerId: SpellIds.mageHand,
    ),
    level: 0,
    school: SpellSchool.conjuration,
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'mage_hand_spectral_hand',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_spectral_hand_within_range',
          'caster_can_control_hand_with_action',
          'hand_cannot_attack_activate_magic_items_or_carry_more_than_5_kg',
          'hand_vanishes_if_more_than_9_meters_from_caster_or_spell_recast',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.mending: SpellDefinition(
    id: SpellIds.mending,
    content: RuleContent(
      id: SpellIds.mending,
      name: 'Riparare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Ripara una singola crepa o uno squarcio in un oggetto.',
        details:
            'Questo incantesimo ripara una singola crepa o uno squarcio in '
            'un oggetto toccato dall’incantatore, purché la rottura non sia '
            'più grande di 30 cm in ogni dimensione. L’incantesimo può '
            'riparare fisicamente un oggetto magico o un costrutto, ma non '
            'può ripristinare la magia di un simile oggetto.',
      ),
      ownerId: SpellIds.mending,
    ),
    level: 0,
    school: SpellSchool.transmutation,
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
          description: 'Due calamite.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'mending_repair_break',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'repairs_single_break_or_tear_up_to_30_cm',
          'can_physically_repair_magic_item_or_construct',
          'does_not_restore_magic',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.message: SpellDefinition(
    id: SpellIds.message,
    content: RuleContent(
      id: SpellIds.message,
      name: 'Messaggio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Invia un sussurro magico a una creatura entro gittata.',
        details:
            'L’incantatore punta l’indice verso una creatura entro gittata e '
            'sussurra un messaggio. Il bersaglio, e soltanto il bersaglio, '
            'sente il messaggio e può rispondere con un sussurro udibile solo '
            'dall’incantatore. L’incantesimo può attraversare ostacoli, ma è '
            'bloccato da silenzio magico, 30 cm di pietra, 2,5 cm di metallo '
            'comune, una sottile lamina di piombo o 90 cm di legno.',
      ),
      ownerId: SpellIds.message,
    ),
    level: 0,
    school: SpellSchool.transmutation,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un frammento di un filo di rame.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.round,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'message_private_whisper',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_hears_message_and_can_reply_privately',
          'can_pass_through_some_barriers',
          'blocked_by_magical_silence_stone_metal_lead_or_wood_limits',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.poisonSpray: SpellDefinition(
    id: SpellIds.poisonSpray,
    content: RuleContent(
      id: SpellIds.poisonSpray,
      name: 'Spruzzo Velenoso',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Proietta veleno contro una creatura vicina.',
        details:
            'L’incantatore allunga la mano verso una creatura entro gittata e '
            'proietta uno sbuffo di gas nocivo dal palmo. La creatura deve '
            'superare un tiro salvezza su Costituzione o subire 1d12 danni da '
            'veleno. I danni aumentano a 2d12 al 5° livello, 3d12 all’11° '
            'livello e 4d12 al 17° livello.',
      ),
      ownerId: SpellIds.poisonSpray,
    ),
    level: 0,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 3,
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
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d12',
        type: SpellDamageType.poison,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d12',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d12',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d12',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'poison_spray_constitution_save',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_makes_constitution_saving_throw',
          'no_damage_on_success',
        },
      ),
    ],
    classIds: {
      'druid',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.prestidigitation: SpellDefinition(
    id: SpellIds.prestidigitation,
    content: RuleContent(
      id: SpellIds.prestidigitation,
      name: 'Prestidigitazione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Produce piccoli effetti magici innocui e temporanei.',
        details:
            'Questo incantesimo è un trucco magico minore. L’incantatore crea '
            'un effetto magico entro gittata: un effetto sensoriale innocuo, '
            'accende o spegne una piccola fiamma, pulisce o sporca un oggetto '
            'non più grande di 30 dm cubi, raffredda, riscalda o insaporisce '
            'materiale non vivente, fa comparire un colore, marchio o simbolo '
            'per 1 ora, oppure crea un piccolo gingillo non magico o immagine '
            'illusoria che dura fino alla fine del turno successivo. Può avere '
            'fino a tre effetti non istantanei attivi alla volta.',
      ),
      ownerId: SpellIds.prestidigitation,
    ),
    level: 0,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 3,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'prestidigitation_minor_magic_effects',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'harmless_sensory_effect',
          'light_or_extinguish_small_flame',
          'clean_or_soil_small_object',
          'chill_warm_or_flavor_nonliving_material',
          'mark_symbol_or_color_for_1_hour',
          'create_small_nonmagical_trinket_or_illusory_image',
          'up_to_three_non_instantaneous_effects_active',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.produceFlame: SpellDefinition(
    id: SpellIds.produceFlame,
    content: RuleContent(
      id: SpellIds.produceFlame,
      name: 'Produrre Fiamma',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una fiamma nella mano che illumina e può essere scagliata.',
        details:
            'Una fiamma tremolante compare nella mano dell’incantatore. La '
            'fiamma resta per la durata, non danneggia l’incantatore o il suo '
            'equipaggiamento e produce luce intensa entro 3 metri e luce fioca '
            'per altri 3 metri. L’incantatore può usare l’azione per scagliare '
            'la fiamma contro una creatura entro 9 metri, effettuando un '
            'attacco a distanza con incantesimo. Se colpisce, il bersaglio '
            'subisce 1d8 danni da fuoco. I danni aumentano a 2d8 al 5° '
            'livello, 3d8 all’11° livello e 4d8 al 17° livello.',
      ),
      ownerId: SpellIds.produceFlame,
    ),
    level: 0,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.fire,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d8',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d8',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d8',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'produce_flame_hand_flame',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'flame_in_casters_hand',
          'bright_light_3_meters_dim_light_3_meters',
          'can_hurl_flame_as_ranged_spell_attack_to_9_meters',
          'spell_ends_when_flame_is_hurled_or_recast',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.rayOfFrost: SpellDefinition(
    id: SpellIds.rayOfFrost,
    content: RuleContent(
      id: SpellIds.rayOfFrost,
      name: 'Raggio di Gelo',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Un raggio gelido danneggia una creatura e ne riduce la velocità.',
        details:
            'Un raggio gelido di luce azzurra e biancastra sfreccia verso una '
            'creatura entro gittata. L’incantatore effettua un attacco a '
            'distanza con incantesimo. Se colpisce, il bersaglio subisce 1d8 '
            'danni da freddo e la sua velocità è ridotta di 3 metri fino '
            'all’inizio del turno successivo dell’incantatore. I danni '
            'aumentano a 2d8 al 5° livello, 3d8 all’11° livello e 4d8 al '
            '17° livello.',
      ),
      ownerId: SpellIds.rayOfFrost,
    ),
    level: 0,
    school: SpellSchool.evocation,
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
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.cold,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d8',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d8',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d8',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'ray_of_frost_speed_reduction',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_speed_reduced_by_3_meters_until_start_of_casters_next_turn',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.resistance: SpellDefinition(
    id: SpellIds.resistance,
    content: RuleContent(
      id: SpellIds.resistance,
      name: 'Resistenza',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Concede a una creatura un bonus di 1d4 a un tiro salvezza.',
        details:
            'L’incantatore tocca una creatura consenziente. Una volta prima '
            'che l’incantesimo termini, il bersaglio può tirare 1d4 e '
            'aggiungere il risultato a un tiro salvezza a sua scelta. Può '
            'tirare il dado prima o dopo avere effettuato il tiro salvezza, '
            'poi l’incantesimo termina.',
      ),
      ownerId: SpellIds.resistance,
    ),
    level: 0,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un mantello in miniatura.',
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
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'resistance_saving_throw_bonus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_adds_1d4_to_one_saving_throw',
          'can_roll_before_or_after_saving_throw',
          'spell_ends_after_bonus_is_used',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
    },
  ),
  SpellIds.sacredFlame: SpellDefinition(
    id: SpellIds.sacredFlame,
    content: RuleContent(
      id: SpellIds.sacredFlame,
      name: 'Fiamma Sacra',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Un bagliore simile a una fiamma colpisce una creatura visibile.',
        details:
            'Un bagliore simile a una fiamma scende fino a una creatura entro '
            'gittata che l’incantatore sia in grado di vedere. Il bersaglio '
            'deve superare un tiro salvezza su Destrezza o subire 1d8 danni '
            'radianti. Il bersaglio non trae beneficio dalla copertura per '
            'questo tiro salvezza. I danni aumentano a 2d8 al 5° livello, '
            '3d8 all’11° livello e 4d8 al 17° livello.',
      ),
      ownerId: SpellIds.sacredFlame,
    ),
    level: 0,
    school: SpellSchool.evocation,
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
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.radiant,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d8',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d8',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d8',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'sacred_flame_dexterity_save_no_cover',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_makes_dexterity_saving_throw',
          'target_gets_no_benefit_from_cover_for_save',
          'no_damage_on_success',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.shillelagh: SpellDefinition(
    id: SpellIds.shillelagh,
    content: RuleContent(
      id: SpellIds.shillelagh,
      name: 'Randello Incantato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Potenzia magicamente un randello o bastone ferrato impugnato.',
        details: 'Il legno di un randello o di un bastone ferrato impugnato '
            'dall’incantatore viene infuso del potere della natura. Per la '
            'durata dell’incantesimo l’incantatore può usare la propria '
            'caratteristica da incantatore invece di Forza per i tiri per '
            'colpire e per i danni degli attacchi in mischia con quell’arma, '
            'il dado dei danni dell’arma diventa un d8 e l’arma diventa '
            'magica. L’incantesimo termina se viene lanciato di nuovo o se '
            'l’incantatore lascia andare l’arma.',
      ),
      ownerId: SpellIds.shillelagh,
    ),
    level: 0,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Vischio, una foglia di trifoglio e un randello o un bastone ferrato.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'shillelagh_empowered_weapon',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'club_or_quarterstaff_becomes_magical',
          'weapon_damage_die_becomes_d8',
          'use_spellcasting_ability_for_attack_and_damage',
          'ends_if_cast_again_or_caster_lets_go_of_weapon',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.shockingGrasp: SpellDefinition(
    id: SpellIds.shockingGrasp,
    content: RuleContent(
      id: SpellIds.shockingGrasp,
      name: 'Stretta Folgorante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Un fulmine scaturisce dalla mano e impedisce reazioni al bersaglio.',
        details:
            'Un fulmine si sprigiona dalla mano dell’incantatore contro una '
            'creatura toccata. L’incantatore effettua un attacco in mischia '
            'con incantesimo, con vantaggio se il bersaglio indossa '
            'un’armatura di metallo. Se colpisce, il bersaglio subisce 1d8 '
            'danni da fulmine e non può effettuare reazioni fino all’inizio '
            'del suo turno successivo. I danni aumentano a 2d8 al 5° livello, '
            '3d8 all’11° livello e 4d8 al 17° livello.',
      ),
      ownerId: SpellIds.shockingGrasp,
    ),
    level: 0,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
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
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.melee,
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.lightning,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d8',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d8',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d8',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'shocking_grasp_no_reactions',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'advantage_if_target_wears_metal_armor',
          'target_cannot_take_reactions_until_start_of_its_next_turn',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.spareTheDying: SpellDefinition(
    id: SpellIds.spareTheDying,
    content: RuleContent(
      id: SpellIds.spareTheDying,
      name: 'Salvare i Morenti',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Stabilizza una creatura vivente a 0 punti ferita.',
        details:
            'L’incantatore tocca una creatura vivente che si trova a 0 punti '
            'ferita. Il bersaglio diventa stabile: non deve continuare a '
            'effettuare tiri salvezza contro morte a meno che non subisca '
            'nuovi danni o un altro effetto lo riporti in pericolo. '
            'L’incantesimo non cura punti ferita, non rende cosciente la '
            'creatura e non le permette di agire; impedisce soltanto che '
            'continui a morire. Non ha effetto sui costrutti o sui non morti.',
      ),
      ownerId: SpellIds.spareTheDying,
    ),
    level: 0,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
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
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'spare_the_dying_stabilize',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'stabilizes_living_creature_at_0_hit_points',
          'no_effect_on_constructs_or_undead',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.thaumaturgy: SpellDefinition(
    id: SpellIds.thaumaturgy,
    content: RuleContent(
      id: SpellIds.thaumaturgy,
      name: 'Taumaturgia',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Genera una piccola manifestazione di potere soprannaturale.',
        details:
            'L’incantatore genera una meraviglia minore entro gittata: la sua '
            'voce può risuonare più forte, le fiamme possono tremolare, '
            'illuminarsi, affievolirsi o cambiare colore, il terreno può '
            'tremare, può creare un suono istantaneo, far aprire o chiudere '
            'di colpo una porta o una finestra non chiusa a chiave, oppure '
            'alterare temporaneamente l’aspetto dei propri occhi. Può avere '
            'fino a tre effetti da 1 minuto attivi alla volta.',
      ),
      ownerId: SpellIds.thaumaturgy,
    ),
    level: 0,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'thaumaturgy_minor_wonder',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'booming_voice',
          'alter_flames',
          'harmless_tremors',
          'instantaneous_sound',
          'open_or_close_unlocked_door_or_window',
          'alter_eye_appearance',
          'up_to_three_one_minute_effects_active',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.trueStrike: SpellDefinition(
    id: SpellIds.trueStrike,
    content: RuleContent(
      id: SpellIds.trueStrike,
      name: 'Colpo Accurato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Concede vantaggio al prossimo attacco contro un bersaglio scelto.',
        details:
            'L’incantatore punta il dito contro un bersaglio entro gittata. '
            'La magia gli conferisce una fugace percezione delle difese del '
            'bersaglio. Nel turno successivo dell’incantatore, il suo primo '
            'tiro per colpire contro quel bersaglio dispone di vantaggio, '
            'purché l’incantesimo non sia terminato.',
      ),
      ownerId: SpellIds.trueStrike,
    ),
    level: 0,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.round,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'true_strike_next_attack_advantage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'first_attack_roll_next_turn_against_target_has_advantage',
          'requires_concentration_until_next_turn',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.viciousMockery: SpellDefinition(
    id: SpellIds.viciousMockery,
    content: RuleContent(
      id: SpellIds.viciousMockery,
      name: 'Beffa Crudele',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Insulti incantati danneggiano la mente e ostacolano il prossimo attacco.',
        details: 'L’incantatore pronuncia una sequenza di insulti mescolati a '
            'sottili ammaliamenti contro una creatura entro gittata che sia '
            'in grado di vedere. Se il bersaglio può udire l’incantatore, deve '
            'superare un tiro salvezza su Saggezza o subire 1d4 danni psichici '
            'e avere svantaggio al prossimo tiro per colpire che effettua '
            'prima della fine del suo turno successivo. I danni aumentano a '
            '2d4 al 5° livello, 3d4 all’11° livello e 4d4 al 17° livello.',
      ),
      ownerId: SpellIds.viciousMockery,
    ),
    level: 0,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d4',
        type: SpellDamageType.psychic,
      ),
    ],
    scaling: SpellScaling(
      type: SpellScalingType.characterLevel,
      steps: [
        SpellScalingStep(
          threshold: 5,
          damageDice: '2d4',
        ),
        SpellScalingStep(
          threshold: 11,
          damageDice: '3d4',
        ),
        SpellScalingStep(
          threshold: 17,
          damageDice: '4d4',
        ),
      ],
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'vicious_mockery_wisdom_save_disadvantage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_must_hear_caster',
          'target_makes_wisdom_saving_throw',
          'disadvantage_on_next_attack_before_end_of_next_turn',
          'no_damage_on_success',
        },
      ),
    ],
    classIds: {
      'bard',
    },
  ),
  SpellIds.alarm: SpellDefinition(
    id: SpellIds.alarm,
    content: RuleContent(
      id: SpellIds.alarm,
      name: 'Allarme',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Predispone un allarme magico su una porta, finestra o piccola area.',
        details:
            'L’incantatore protegge una porta, una finestra o un’area entro '
            'gittata non più grande di un cubo con spigolo di 6 metri. Al '
            'momento del lancio sceglie quali creature non faranno scattare '
            'l’allarme e decide se l’avviso sarà mentale o udibile. Per tutta '
            'la durata, quando una creatura di taglia Minuscola o superiore '
            'tocca l’area protetta o vi entra senza essere esclusa, l’allarme '
            'si attiva. L’allarme mentale avverte l’incantatore nella sua mente '
            'se si trova entro 1,5 km e lo sveglia se sta dormendo. L’allarme '
            'udibile produce il suono di una campana per 10 secondi entro '
            '18 metri dall’area protetta. Può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.alarm,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
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
          description:
              'Una campanella e un frammento di un sottile cavo d’argento.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'alarm_warded_area',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ward_door_window_or_area_up_to_6_meter_cube',
          'caster_designates_excluded_creatures',
          'tiny_or_larger_creature_triggers_alarm',
          'mental_alarm_within_1_5_km_or_audible_bell_within_18_meters',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'ranger',
      'wizard',
    },
  ),
  SpellIds.animalFriendship: SpellDefinition(
    id: SpellIds.animalFriendship,
    content: RuleContent(
      id: SpellIds.animalFriendship,
      name: 'Amicizia con gli Animali',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Convince una bestia che l’incantatore non intende farle del male.',
        details:
            'L’incantatore sceglie una bestia entro gittata che sia in grado '
            'di vedere. La bestia deve vedere e sentire l’incantatore. Se la '
            'sua Intelligenza è pari o superiore a 4, l’incantesimo fallisce. '
            'Altrimenti la bestia effettua un tiro salvezza su Saggezza; se lo '
            'fallisce, è affascinata dall’incantatore per la durata. '
            'L’effetto termina anticipatamente se l’incantatore o uno dei suoi '
            'compagni infligge danni al bersaglio. Usando uno slot di livello '
            'superiore al 1°, l’incantatore può influenzare una bestia '
            'aggiuntiva per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.animalFriendship,
    ),
    level: 1,
    school: SpellSchool.enchantment,
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
          description: 'Un boccone di cibo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 24,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'animal_friendship_charmed_beast',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_beast_that_can_see_and_hear_caster',
          'fails_if_beast_intelligence_4_or_higher',
          'target_makes_wisdom_saving_throw',
          'failed_save_charms_beast',
          'ends_if_caster_or_companions_damage_target',
          'one_additional_beast_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
    },
  ),
  SpellIds.bane: SpellDefinition(
    id: SpellIds.bane,
    content: RuleContent(
      id: SpellIds.bane,
      name: 'Anatema',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Indebolisce fino a tre creature, penalizzando attacchi e tiri salvezza.',
        details:
            'L’incantatore sceglie fino a tre creature entro gittata che sia '
            'in grado di vedere. Ogni bersaglio deve effettuare un tiro '
            'salvezza su Carisma. Quando una creatura fallisce il tiro salvezza, '
            'per tutta la durata dell’incantesimo deve tirare 1d4 e sottrarre '
            'il risultato ogni volta che effettua un tiro per colpire o un tiro '
            'salvezza. L’effetto richiede concentrazione. Usando uno slot di '
            'livello superiore al 1°, l’incantatore può bersagliare una '
            'creatura aggiuntiva per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.bane,
    ),
    level: 1,
    school: SpellSchool.enchantment,
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
          description: 'Una goccia di sangue.',
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
      maximumTargets: 3,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'bane_attack_and_save_penalty',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'up_to_three_visible_creatures',
          'targets_make_charisma_saving_throw',
          'failed_save_subtracts_1d4_from_attack_rolls_and_saving_throws',
          'requires_concentration',
          'one_additional_target_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
    },
  ),
  SpellIds.armorOfAgathys: SpellDefinition(
    id: SpellIds.armorOfAgathys,
    content: RuleContent(
      id: SpellIds.armorOfAgathys,
      name: 'Armatura di Agathys',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Avvolge l’incantatore in gelo protettivo che ferisce chi lo colpisce.',
        details: 'Una forza magica protettiva circonda l’incantatore come una '
            'patina di gelo spettrale che ricopre lui e il suo equipaggiamento. '
            'L’incantatore ottiene 5 punti ferita temporanei per la durata. '
            'Finché possiede quei punti ferita temporanei, una creatura che lo '
            'colpisce con un attacco in mischia subisce 5 danni da freddo. '
            'Usando uno slot di livello superiore al 1°, sia i punti ferita '
            'temporanei sia i danni da freddo aumentano di 5 per ogni livello '
            'di slot superiore.',
      ),
      ownerId: SpellIds.armorOfAgathys,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una coppa d’acqua.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '5',
        type: SpellDamageType.cold,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'armor_of_agathys_temporary_hit_points_and_cold_retribution',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_gains_5_temporary_hit_points',
          'melee_attacker_takes_5_cold_damage_while_temp_hp_remain',
          'temporary_hit_points_and_cold_damage_increase_by_5_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'warlock',
    },
  ),
  SpellIds.mageArmor: SpellDefinition(
    id: SpellIds.mageArmor,
    content: RuleContent(
      id: SpellIds.mageArmor,
      name: 'Armatura Magica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Protegge magicamente una creatura consenziente che non indossa armatura.',
        details:
            'L’incantatore tocca una creatura consenziente che non indossa '
            'un’armatura. Una forza magica protettiva circonda il bersaglio '
            'fino al termine dell’incantesimo. Per la durata, la Classe '
            'Armatura base del bersaglio diventa 13 + il suo modificatore di '
            'Destrezza. L’incantesimo termina anticipatamente se il bersaglio '
            'indossa un’armatura o se l’incantatore lo interrompe usando '
            'un’azione. Non fornisce punti ferita temporanei e non si cumula '
            'con altre formule alternative di calcolo della CA base.',
      ),
      ownerId: SpellIds.mageArmor,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un pezzo di cuoio trattato.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'mage_armor_base_ac',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_must_be_willing_creature_not_wearing_armor',
          'base_ac_becomes_13_plus_dexterity_modifier',
          'ends_if_target_dons_armor',
          'caster_can_dismiss_as_action',
          'does_not_stack_with_other_base_ac_formulas',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.goodberry: SpellDefinition(
    id: SpellIds.goodberry,
    content: RuleContent(
      id: SpellIds.goodberry,
      name: 'Bacche Benefiche',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Crea fino a dieci bacche magiche che curano e nutrono.',
        details:
            'Fino a dieci bacche compaiono nella mano dell’incantatore e sono '
            'pervase di magia. Una creatura può usare la sua azione per '
            'mangiare una bacca. Mangiare una bacca ripristina 1 punto ferita '
            'e fornisce nutrimento sufficiente a sfamare una creatura per un '
            'giorno. Le bacche non curano automaticamente: devono essere '
            'mangiate usando un’azione. Le bacche perdono il loro potere se '
            'non vengono consumate entro 24 ore dal lancio dell’incantesimo.',
      ),
      ownerId: SpellIds.goodberry,
    ),
    level: 1,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un rametto di vischio.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'goodberry_magical_berries',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_up_to_ten_magical_berries',
          'creature_uses_action_to_eat_one_berry',
          'each_berry_restores_1_hit_point',
          'each_berry_provides_one_day_nourishment',
          'berries_lose_power_after_24_hours',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
    },
  ),
  SpellIds.bless: SpellDefinition(
    id: SpellIds.bless,
    content: RuleContent(
      id: SpellIds.bless,
      name: 'Benedizione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Benedice fino a tre creature, migliorando attacchi e tiri salvezza.',
        details:
            'L’incantatore benedice fino a tre creature a sua scelta entro '
            'gittata. Per la durata dell’incantesimo, ogni volta che un '
            'bersaglio effettua un tiro per colpire o un tiro salvezza può '
            'tirare 1d4 e aggiungere il risultato al tiro. L’effetto richiede '
            'concentrazione e si applica solo prima che l’incantesimo termini. '
            'Usando uno slot di livello superiore al 1°, l’incantatore può '
            'bersagliare una creatura aggiuntiva per ogni livello di slot '
            'superiore.',
      ),
      ownerId: SpellIds.bless,
    ),
    level: 1,
    school: SpellSchool.enchantment,
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
          description: 'Uno spruzzo di acqua santa.',
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
      maximumTargets: 3,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'bless_attack_and_save_bonus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'up_to_three_targets',
          'targets_add_1d4_to_attack_rolls_and_saving_throws',
          'requires_concentration',
          'one_additional_target_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.armsOfHadar: SpellDefinition(
    id: SpellIds.armsOfHadar,
    content: RuleContent(
      id: SpellIds.armsOfHadar,
      name: 'Braccia di Hadar',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Tentacoli di energia oscura colpiscono le creature attorno all’incantatore.',
        details:
            'L’incantatore invoca il potere di Hadar, la Fame Oscura. Dalla '
            'sua persona si protendono tentacoli di energia oscura che '
            'tempestano di colpi tutte le creature entro 3 metri da lui. Ogni '
            'creatura nell’area deve effettuare un tiro salvezza su Forza. Se '
            'fallisce, subisce 2d6 danni necrotici e non può effettuare '
            'reazioni fino al suo turno successivo. Se supera il tiro salvezza, '
            'subisce soltanto metà dei danni e non subisce l’effetto sulle '
            'reazioni. Usando uno slot di livello superiore al 1°, i danni '
            'aumentano di 1d6 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.armsOfHadar,
    ),
    level: 1,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
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
    ),
    damage: [
      SpellDamage(
        dice: '2d6',
        type: SpellDamageType.necrotic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'arms_of_hadar_strength_save_no_reactions',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'affects_all_creatures_within_3_meters_of_caster',
          'targets_make_strength_saving_throw',
          'failed_save_deals_2d6_necrotic_and_prevents_reactions',
          'successful_save_takes_half_damage_only',
          'damage_increases_by_1d6_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'warlock',
    },
  ),
  SpellIds.featherFall: SpellDefinition(
    id: SpellIds.featherFall,
    content: RuleContent(
      id: SpellIds.featherFall,
      name: 'Caduta Morbida',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Rallenta la caduta di un massimo di cinque creature vicine.',
        details: 'L’incantatore può lanciare questo incantesimo come reazione '
            'quando lui o una creatura entro 18 metri cade. Sceglie fino a '
            'cinque creature in caduta entro gittata. Per la durata, la '
            'velocità di discesa di ogni bersaglio rallenta fino a 18 metri '
            'per round. Se una creatura atterra prima che l’incantesimo '
            'termini, non subisce danni da caduta, può atterrare in piedi e '
            'l’incantesimo termina per quella creatura. L’effetto non cura '
            'danni già subiti e serve specificamente a modificare una caduta '
            'in corso.',
      ),
      ownerId: SpellIds.featherFall,
    ),
    level: 1,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.reaction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una piccola piuma.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 5,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'feather_fall_slow_falling_creatures',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'reaction_when_caster_or_creature_within_18_meters_falls',
          'targets_up_to_five_falling_creatures',
          'falling_speed_reduced_to_18_meters_per_round',
          'no_falling_damage_if_lands_before_spell_ends',
          'target_can_land_on_feet',
          'spell_ends_for_target_after_landing',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.disguiseSelf: SpellDefinition(
    id: SpellIds.disguiseSelf,
    content: RuleContent(
      id: SpellIds.disguiseSelf,
      name: 'Camuffare Se Stesso',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Cambia illusoriamente l’aspetto dell’incantatore e del suo equipaggiamento.',
        details: 'L’incantatore assume un aspetto diverso per la durata '
            'dell’incantesimo, includendo abiti, armatura, armi e altri '
            'oggetti personali presenti sulla sua persona. Può apparire circa '
            '30 centimetri più alto o più basso, più magro, più grasso o di '
            'corporatura normale, ma non può cambiare il proprio tipo di corpo '
            'e deve mantenere la stessa disposizione basilare degli arti. '
            'I cambiamenti sono illusori e non superano un’ispezione fisica: '
            'oggetti aggiunti dall’illusione non possono essere toccati e un '
            'contatto fisico può rivelare la discrepanza. L’incantatore può '
            'terminare l’incantesimo usando un’azione.',
      ),
      ownerId: SpellIds.disguiseSelf,
    ),
    level: 1,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'disguise_self_illusory_appearance',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'changes_casters_appearance_and_equipment_illusorily',
          'can_appear_30_cm_taller_or_shorter',
          'cannot_change_body_type_or_limb_arrangement',
          'physical_inspection_reveals_illusion',
          'caster_can_dismiss_as_action',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.charmPerson: SpellDefinition(
    id: SpellIds.charmPerson,
    content: RuleContent(
      id: SpellIds.charmPerson,
      name: 'Charme su Persone',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Tenta di affascinare un umanoide rendendolo amichevole verso l’incantatore.',
        details:
            'L’incantatore tenta di affascinare un umanoide entro gittata che '
            'sia in grado di vedere. Il bersaglio effettua un tiro salvezza su '
            'Saggezza e dispone di vantaggio se l’incantatore o i suoi compagni '
            'stanno combattendo contro di lui. Se fallisce, il bersaglio è '
            'affascinato dall’incantatore finché l’incantesimo non termina o '
            'finché l’incantatore o i suoi compagni non lo danneggiano. La '
            'creatura affascinata considera l’incantatore una figura conosciuta '
            'e amichevole. Quando l’incantesimo termina, la creatura capisce di '
            'essere stata affascinata. Usando slot superiori al 1°, può '
            'bersagliare una creatura aggiuntiva per ogni livello di slot '
            'superiore; le creature devono trovarsi entro 9 metri l’una '
            'dall’altra.',
      ),
      ownerId: SpellIds.charmPerson,
    ),
    level: 1,
    school: SpellSchool.enchantment,
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
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'charm_person_wisdom_save_charmed_humanoid',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_humanoid',
          'target_makes_wisdom_saving_throw',
          'target_has_advantage_if_fighting_caster_or_companions',
          'failed_save_charms_target',
          'ends_if_caster_or_companions_damage_target',
          'target_knows_it_was_charmed_when_spell_ends',
          'one_additional_target_per_slot_level_above_1',
          'additional_targets_must_be_within_9_meters_of_each_other',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.ensnaringStrike: SpellDefinition(
    id: SpellIds.ensnaringStrike,
    content: RuleContent(
      id: SpellIds.ensnaringStrike,
      name: 'Colpo Intrappolante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Il prossimo colpo con arma evoca rampicanti che trattengono il bersaglio.',
        details:
            'La prossima volta che l’incantatore colpisce una creatura con un '
            'attacco con un’arma prima che l’incantesimo termini, rampicanti '
            'spinosi appaiono nel punto d’impatto. Il bersaglio effettua un '
            'tiro salvezza su Forza; una creatura di taglia Grande o superiore '
            'dispone di vantaggio. Se fallisce, è trattenuto dai rampicanti '
            'magici fino al termine dell’incantesimo e subisce 1d6 danni '
            'perforanti all’inizio di ogni suo turno. Il bersaglio trattenuto '
            'o un’altra creatura in grado di toccarlo può usare un’azione per '
            'effettuare una prova di Forza contro la CD del tiro salvezza '
            'dell’incantesimo, liberando il bersaglio in caso di successo. Se '
            'il tiro salvezza iniziale riesce, i rampicanti si ritraggono e '
            'avvizziscono. Usando slot superiori al 1°, i danni aumentano di '
            '1d6 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.ensnaringStrike,
    ),
    level: 1,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.piercing,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'ensnaring_strike_restrained_vines',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'next_weapon_hit_before_spell_ends_triggers_vines',
          'target_makes_strength_saving_throw',
          'large_or_larger_target_has_advantage_on_save',
          'failed_save_restrained_by_magical_vines',
          'restrained_target_takes_1d6_piercing_at_start_of_each_turn',
          'target_or_adjacent_creature_can_use_action_strength_check_to_free',
          'damage_increases_by_1d6_per_slot_level_above_1',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'ranger',
    },
  ),
  SpellIds.command: SpellDefinition(
    id: SpellIds.command,
    content: RuleContent(
      id: SpellIds.command,
      name: 'Comando',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Impone a una creatura un comando di una parola per il suo turno successivo.',
        details:
            'L’incantatore rivolge un comando di una parola a una creatura '
            'entro gittata che sia in grado di vedere. Il bersaglio deve '
            'superare un tiro salvezza su Saggezza o obbedire al comando nel '
            'proprio turno successivo. L’incantesimo non ha effetto sui non '
            'morti, su creature che non comprendono il linguaggio '
            'dell’incantatore o se il comando è direttamente dannoso per il '
            'bersaglio. Comandi tipici includono: avvicinarsi '
            'all’incantatore, restare fermo senza muoversi né agire, fuggire '
            'nel modo più rapido possibile, lasciare cadere ciò che si impugna '
            'o gettarsi prono supplicando. Il DM determina gli effetti di '
            'comandi diversi. Se il bersaglio non può eseguire il comando, '
            'l’incantesimo termina. Usando slot superiori al 1°, può '
            'influenzare una creatura aggiuntiva per ogni livello di slot '
            'superiore; le creature devono trovarsi entro 9 metri l’una '
            'dall’altra quando vengono bersagliate.',
      ),
      ownerId: SpellIds.command,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.round,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'command_one_word_order',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_visible_creature_within_18_meters',
          'target_makes_wisdom_saving_throw',
          'failed_save_obeys_one_word_command_next_turn',
          'no_effect_on_undead',
          'no_effect_if_target_does_not_understand_caster_language',
          'no_effect_if_command_is_directly_harmful',
          'examples_approach_drop_flee_grovel_halt',
          'one_additional_target_per_slot_level_above_1',
          'additional_targets_must_be_within_9_meters_of_each_other',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.comprehendLanguages: SpellDefinition(
    id: SpellIds.comprehendLanguages,
    content: RuleContent(
      id: SpellIds.comprehendLanguages,
      name: 'Comprensione dei Linguaggi',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di comprendere il significato letterale dei linguaggi.',
        details: 'Per la durata dell’incantesimo, l’incantatore comprende il '
            'significato letterale di qualsiasi linguaggio parlato che sia in '
            'grado di sentire. Comprende anche ogni linguaggio scritto che sia '
            'in grado di vedere, ma deve toccare la superficie su cui sono '
            'scritte le parole. Serve circa 1 minuto per leggere una pagina di '
            'testo. L’incantesimo non decodifica messaggi segreti, cifrari, '
            'glifi o sigilli arcani che non facciano parte di un linguaggio '
            'scritto. Può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.comprehendLanguages,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un pizzico di fuliggine e di sale.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'comprehend_languages_literal_meaning',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'understands_literal_meaning_of_spoken_languages_heard',
          'understands_written_languages_seen_and_touched',
          'takes_about_1_minute_to_read_one_page',
          'does_not_decode_secret_messages_or_ciphers',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.createOrDestroyWater: SpellDefinition(
    id: SpellIds.createOrDestroyWater,
    content: RuleContent(
      id: SpellIds.createOrDestroyWater,
      name: 'Creare o Distruggere Acqua',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea o distrugge acqua, oppure produce pioggia o dissolve nebbia.',
        details: 'L’incantatore sceglie se creare o distruggere acqua. Creando '
            'acqua, può generare fino a 40 litri di acqua pulita in un '
            'contenitore aperto entro gittata; in alternativa l’acqua cade '
            'come pioggia in un cubo con spigolo di 9 metri entro gittata, '
            'estinguendo le fiamme nell’area. Distruggendo acqua, può '
            'eliminare fino a 40 litri d’acqua in un contenitore aperto entro '
            'gittata; in alternativa può distruggere la nebbia all’interno di '
            'un cubo con spigolo di 9 metri. Usando slot superiori al 1°, la '
            'quantità d’acqua creata o distrutta aumenta di 40 litri, oppure '
            'lo spigolo del cubo aumenta di 1,5 metri, per ogni livello di '
            'slot superiore.',
      ),
      ownerId: SpellIds.createOrDestroyWater,
    ),
    level: 1,
    school: SpellSchool.transmutation,
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
          description:
              'Una goccia d’acqua per creare acqua o alcuni granelli di sabbia per distruggerla.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'create_or_destroy_water',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_up_to_40_liters_clean_water_in_open_container',
          'or_creates_rain_in_9_meter_cube_extinguishing_flames',
          'destroys_up_to_40_liters_water_in_open_container',
          'or_destroys_fog_in_9_meter_cube',
          'adds_40_liters_or_1_5_meter_cube_edge_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
    },
  ),
  SpellIds.cureWounds: SpellDefinition(
    id: SpellIds.cureWounds,
    content: RuleContent(
      id: SpellIds.cureWounds,
      name: 'Cura Ferite',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Cura una creatura toccata dall’incantatore.',
        details:
            'L’incantatore tocca una creatura, che recupera un numero di punti '
            'ferita pari a 1d8 + il modificatore della caratteristica da '
            'incantatore. L’incantesimo ha effetto istantaneo e non richiede '
            'concentrazione. Non ha effetto sui costrutti o sui non morti. '
            'Usando uno slot di livello superiore al 1°, la guarigione aumenta '
            'di 1d8 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.cureWounds,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
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
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'cure_wounds_touch_healing',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature_regains_1d8_plus_spellcasting_modifier_hit_points',
          'no_effect_on_constructs_or_undead',
          'healing_increases_by_1d8_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'paladin',
      'ranger',
    },
  ),
  SpellIds.guidingBolt: SpellDefinition(
    id: SpellIds.guidingBolt,
    content: RuleContent(
      id: SpellIds.guidingBolt,
      name: 'Dardo Tracciante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Colpisce con luce radiosa e facilita il prossimo attacco contro il bersaglio.',
        details:
            'Un lampo di luce sfreccia verso una creatura entro gittata scelta '
            'dall’incantatore. L’incantatore effettua un attacco a distanza '
            'con questo incantesimo contro il bersaglio. Se colpisce, il '
            'bersaglio subisce 4d6 danni radiosi. Inoltre, il successivo tiro '
            'per colpire effettuato contro quel bersaglio entro la fine del '
            'turno successivo dell’incantatore dispone di vantaggio, grazie '
            'all’alone mistico di luce fioca che lo avvolge fino ad allora. '
            'Usando slot superiori al 1°, i danni aumentano di 1d6 per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.guidingBolt,
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
      type: SpellDurationType.round,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '4d6',
        type: SpellDamageType.radiant,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'guiding_bolt_advantage_on_next_attack',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ranged_spell_attack_against_one_creature',
          'hit_deals_4d6_radiant_damage',
          'next_attack_roll_against_target_has_advantage_until_end_of_casters_next_turn',
          'target_glows_with_dim_mystical_light',
          'damage_increases_by_1d6_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.tensersFloatingDisk: SpellDefinition(
    id: SpellIds.tensersFloatingDisk,
    content: RuleContent(
      id: SpellIds.tensersFloatingDisk,
      name: 'Disco Fluttuante di Tenser',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un disco di forza che fluttua e trasporta peso seguendo l’incantatore.',
        details:
            'L’incantatore crea un piano circolare e orizzontale di forza, '
            'del diametro di 90 cm e dello spessore di 2,5 cm, che fluttua a '
            '90 cm dal terreno in uno spazio libero entro gittata che egli sia '
            'in grado di vedere. Il disco dura 1 ora e può sostenere fino a '
            '250 kg; se viene caricato con peso superiore, l’incantesimo '
            'termina e tutto ciò che si trovava sul disco cade a terra. Il '
            'disco resta immobile finché l’incantatore si trova entro 6 metri. '
            'Se l’incantatore si allontana oltre 6 metri, il disco lo segue '
            'per restare entro 6 metri da lui. Può muoversi su terreno '
            'dissestato, scale e pendii, ma non può superare cambi di '
            'elevazione pari o superiori a 3 metri. Se l’incantatore si muove '
            'a più di 30 metri dal disco, l’incantesimo termina. Può essere '
            'lanciato come rituale.',
      ),
      ownerId: SpellIds.tensersFloatingDisk,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.conjuration,
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
          description: 'Una goccia di mercurio.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'tensers_floating_disk_force_platform',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_90_cm_diameter_force_disk_90_cm_above_ground',
          'disk_can_hold_up_to_250_kg',
          'overloading_disk_ends_spell_and_drops_contents',
          'disk_is_stationary_while_caster_within_6_meters',
          'disk_follows_caster_to_remain_within_6_meters',
          'cannot_cross_elevation_change_3_meters_or_more',
          'spell_ends_if_caster_more_than_30_meters_from_disk',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.compelledDuel: SpellDefinition(
    id: SpellIds.compelledDuel,
    content: RuleContent(
      id: SpellIds.compelledDuel,
      name: 'Duello Obbligato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Obbliga una creatura a concentrarsi sull’incantatore in un duello.',
        details:
            'L’incantatore tenta di obbligare una creatura entro gittata e che '
            'sia in grado di vedere a partecipare a un duello. Il bersaglio '
            'deve effettuare un tiro salvezza su Saggezza. Se fallisce, è '
            'spinto dall’imposizione divina dell’incantatore ad avvicinarsi a '
            'lui. Per la durata, il bersaglio subisce svantaggio ai tiri per '
            'colpire contro creature diverse dall’incantatore. Inoltre deve '
            'effettuare un tiro salvezza ogni volta che tenta di muoversi in '
            'uno spazio più lontano di 9 metri dall’incantatore; se lo supera, '
            'quel turno non è limitato nei movimenti. L’incantesimo termina se '
            'l’incantatore attacca un’altra creatura, se lancia un incantesimo '
            'dannoso contro un’altra creatura, se una creatura amichevole '
            'dell’incantatore danneggia il bersaglio o lancia un incantesimo '
            'dannoso su di esso, oppure se l’incantatore termina il turno a più '
            'di 9 metri dal bersaglio.',
      ),
      ownerId: SpellIds.compelledDuel,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'compelled_duel_wisdom_save_duel_focus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'target_visible_creature_within_9_meters',
          'target_makes_wisdom_saving_throw',
          'failed_save_compels_target_toward_caster',
          'target_has_disadvantage_attacking_creatures_other_than_caster',
          'target_must_save_to_move_more_than_9_meters_from_caster',
          'requires_concentration',
          'ends_if_caster_attacks_or_harms_other_creature',
          'ends_if_casters_ally_harms_target',
          'ends_if_caster_ends_turn_more_than_9_meters_from_target',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.heroism: SpellDefinition(
    id: SpellIds.heroism,
    content: RuleContent(
      id: SpellIds.heroism,
      name: 'Eroismo',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Infondere coraggio a una creatura consenziente, proteggendola dalla paura.',
        details: 'L’incantatore tocca una creatura consenziente e la anima con '
            'grande coraggio. Finché l’incantesimo dura, il bersaglio è immune '
            'alla condizione spaventato. Inoltre, all’inizio di ogni suo turno, '
            'ottiene punti ferita temporanei pari al modificatore della '
            'caratteristica da incantatore dell’incantatore. Quando '
            'l’incantesimo termina, il bersaglio perde tutti i punti ferita '
            'temporanei rimanenti forniti da questo incantesimo. Richiede '
            'concentrazione. Usando uno slot di livello superiore al 1°, '
            'l’incantatore può bersagliare una creatura aggiuntiva per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.heroism,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'heroism_fear_immunity_and_temp_hp',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_willing_creature_touched',
          'target_immune_to_frightened_condition',
          'target_gains_temp_hp_equal_to_spellcasting_modifier_at_start_of_each_turn',
          'temp_hp_from_spell_lost_when_spell_ends',
          'requires_concentration',
          'one_additional_target_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'paladin',
    },
  ),
  SpellIds.divineFavor: SpellDefinition(
    id: SpellIds.divineFavor,
    content: RuleContent(
      id: SpellIds.divineFavor,
      name: 'Favore Divino',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Avvolge l’incantatore di luce divina, potenziando i suoi attacchi con arma.',
        details:
            'Intonando una preghiera, l’incantatore viene pervaso da un alone '
            'radioso di luce divina. Finché l’incantesimo non termina, i suoi '
            'attacchi con le armi infliggono 1d4 danni radiosi extra quando '
            'colpiscono. L’effetto richiede concentrazione e si applica solo '
            'agli attacchi con arma dell’incantatore effettuati mentre '
            'l’incantesimo è attivo. Non crea un attacco separato e non cambia '
            'il tipo di danno dell’arma: aggiunge danni radiosi extra al colpo.',
      ),
      ownerId: SpellIds.divineFavor,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'divine_favor_weapon_attack_radiant_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'caster_weapon_attacks_deal_extra_1d4_radiant_damage_on_hit',
          'requires_concentration',
          'does_not_create_separate_attack',
          'does_not_replace_weapon_damage_type',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.chromaticOrb: SpellDefinition(
    id: SpellIds.chromaticOrb,
    content: RuleContent(
      id: SpellIds.chromaticOrb,
      name: 'Globo Cromatico',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Scaglia una sfera elementale scegliendo il tipo di danno.',
        details: 'L’incantatore scaglia una sfera del diametro di circa 10 cm '
            'contro una creatura entro gittata che sia in grado di vedere. '
            'Prima dell’attacco sceglie il tipo di globo tra acido, freddo, '
            'fulmine, fuoco, tuono o veleno. Effettua poi un attacco a distanza '
            'con questo incantesimo contro il bersaglio. Se l’attacco colpisce, '
            'la creatura subisce 3d8 danni del tipo scelto. Usando uno slot di '
            'livello superiore al 1°, i danni aumentano di 1d8 per ogni livello '
            'di slot superiore. Richiede come componente materiale un diamante '
            'del valore minimo indicato.',
      ),
      ownerId: SpellIds.chromaticOrb,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un diamante del valore di almeno 50 mo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    persistentEffects: [
      SpellPersistentEffect(
        id: 'chromatic_orb_chosen_element_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ranged_spell_attack_against_visible_creature',
          'caster_chooses_acid_cold_fire_lightning_poison_or_thunder',
          'hit_deals_3d8_chosen_damage_type',
          'damage_increases_by_1d8_per_slot_level_above_1',
          'requires_diamond_worth_at_least_50_gp',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.silentImage: SpellDefinition(
    id: SpellIds.silentImage,
    content: RuleContent(
      id: SpellIds.silentImage,
      name: 'Immagine Silenziosa',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un’immagine visiva illusoria che può essere spostata con un’azione.',
        details:
            'L’incantatore crea l’immagine di un oggetto, una creatura o un '
            'altro fenomeno visibile non più grande di un cubo con spigolo di '
            '4,5 metri. L’immagine appare in un punto entro gittata e permane '
            'per la durata. È puramente visiva: non produce suoni, odori o '
            'altri effetti sensoriali. L’incantatore può usare la sua azione '
            'per spostare l’immagine in un altro punto entro gittata e può '
            'modificarne l’aspetto affinché il movimento sembri naturale. '
            'Un’interazione fisica rivela che si tratta di un’illusione, perché '
            'gli oggetti la attraversano. Una creatura può esaminare '
            'l’immagine e, se supera la prova prevista contro la CD '
            'dell’incantesimo, la riconosce come illusione.',
      ),
      ownerId: SpellIds.silentImage,
    ),
    level: 1,
    school: SpellSchool.illusion,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un ciuffo di lana.',
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
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'silent_image_visual_illusion',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_visual_illusion_up_to_4_5_meter_cube',
          'illusion_has_no_sound_smell_or_other_sensory_effects',
          'caster_can_use_action_to_move_image_within_range',
          'caster_can_change_appearance_to_make_movement_natural',
          'physical_interaction_reveals_illusion',
          'investigation_check_can_reveal_illusion',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.detectEvilAndGood: SpellDefinition(
    id: SpellIds.detectEvilAndGood,
    content: RuleContent(
      id: SpellIds.detectEvilAndGood,
      name: 'Individuazione del Bene e del Male',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rileva creature sovrannaturali e luoghi o oggetti consacrati o dissacrati.',
        details:
            'Per la durata dell’incantesimo, l’incantatore sa se entro 9 metri '
            'da lui è presente un’aberrazione, un celestiale, un elementale, un '
            'folletto, un immondo o un non morto, e ne conosce la posizione '
            'esatta. Sa anche se entro 9 metri è presente un luogo o un oggetto '
            'consacrato o dissacrato magicamente. L’incantesimo richiede '
            'concentrazione. Può penetrare la maggior parte delle barriere, ma '
            'è bloccato da 30 cm di pietra, 2,5 cm di metallo comune, una '
            'sottile lamina di piombo o 90 cm di legno o terriccio.',
      ),
      ownerId: SpellIds.detectEvilAndGood,
    ),
    level: 1,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'detect_evil_and_good_presence_and_location',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'detects_aberration_celestial_elemental_fey_fiend_or_undead_within_9_meters',
          'reveals_exact_location_of_detected_creature',
          'detects_magically_consecrated_or_desecrated_place_or_object_within_9_meters',
          'blocked_by_30_cm_stone',
          'blocked_by_2_5_cm_common_metal',
          'blocked_by_thin_sheet_of_lead',
          'blocked_by_90_cm_wood_or_dirt',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.detectMagic: SpellDefinition(
    id: SpellIds.detectMagic,
    content: RuleContent(
      id: SpellIds.detectMagic,
      name: 'Individuazione del Magico',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Percepisce la presenza di magia vicina e può rivelarne aura e scuola.',
        details: 'Per la durata dell’incantesimo, l’incantatore percepisce la '
            'presenza della magia entro 9 metri da lui. Se percepisce magia, '
            'può usare la sua azione per vedere una debole aura attorno a ogni '
            'creatura o oggetto visibile nell’area che contenga magia, e '
            'apprende la scuola di magia, se presente. L’effetto richiede '
            'concentrazione e può essere lanciato come rituale. Può penetrare '
            'la maggior parte delle barriere, ma è bloccato da 30 cm di pietra, '
            '2,5 cm di metallo comune, una sottile lamina di piombo o 90 cm di '
            'legno o terriccio.',
      ),
      ownerId: SpellIds.detectMagic,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'detect_magic_aura_and_school',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'detects_presence_of_magic_within_9_meters',
          'caster_can_use_action_to_see_faint_aura_around_visible_magical_creature_or_object',
          'reveals_school_of_magic_if_any',
          'blocked_by_30_cm_stone',
          'blocked_by_2_5_cm_common_metal',
          'blocked_by_thin_sheet_of_lead',
          'blocked_by_90_cm_wood_or_dirt',
          'requires_concentration',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'paladin',
      'ranger',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.detectPoisonAndDisease: SpellDefinition(
    id: SpellIds.detectPoisonAndDisease,
    content: RuleContent(
      id: SpellIds.detectPoisonAndDisease,
      name: 'Individuazione delle Malattie e dei Veleni',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rileva veleni, creature velenose e malattie vicine, identificandone il tipo.',
        details:
            'Per la durata dell’incantesimo, l’incantatore può percepire la '
            'presenza e l’ubicazione di veleni, creature velenose e malattie '
            'situate entro 9 metri da lui. In ciascun caso è anche in grado di '
            'identificare il tipo di veleno, creatura velenosa o malattia. '
            'L’effetto richiede concentrazione e può essere lanciato come '
            'rituale. L’incantesimo può penetrare la maggior parte delle '
            'barriere, ma è bloccato da 30 cm di pietra, 2,5 cm di metallo '
            'comune, una sottile lamina di piombo o 90 cm di legno o terriccio.',
      ),
      ownerId: SpellIds.detectPoisonAndDisease,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una foglia di tasso.',
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
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'detect_poison_and_disease_presence_location_type',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'detects_poisons_poisonous_creatures_and_diseases_within_9_meters',
          'reveals_location_of_detected_poison_creature_or_disease',
          'identifies_type_of_poison_poisonous_creature_or_disease',
          'blocked_by_30_cm_stone',
          'blocked_by_2_5_cm_common_metal',
          'blocked_by_thin_sheet_of_lead',
          'blocked_by_90_cm_wood_or_dirt',
          'requires_concentration',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
      'paladin',
      'ranger',
    },
  ),
  SpellIds.inflictWounds: SpellDefinition(
    id: SpellIds.inflictWounds,
    content: RuleContent(
      id: SpellIds.inflictWounds,
      name: 'Infliggi Ferite',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Colpisce una creatura a contatto con energia necrotica.',
        details: 'L’incantatore effettua un attacco in mischia con questo '
            'incantesimo contro una creatura entro la sua portata. Se il colpo '
            'va a segno, il bersaglio subisce 3d10 danni necrotici. '
            'L’incantesimo ha durata istantanea e non richiede concentrazione. '
            'Usando uno slot di livello superiore al 1°, i danni aumentano di '
            '1d10 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.inflictWounds,
    ),
    level: 1,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
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
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.melee,
    damage: [
      SpellDamage(
        dice: '3d10',
        type: SpellDamageType.necrotic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'inflict_wounds_melee_spell_attack_necrotic',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'melee_spell_attack_against_creature_in_reach',
          'hit_deals_3d10_necrotic_damage',
          'damage_increases_by_1d10_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.hellishRebuke: SpellDefinition(
    id: SpellIds.hellishRebuke,
    content: RuleContent(
      id: SpellIds.hellishRebuke,
      name: 'Intimorire Infernale',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Reagisce a un danno subito avvolgendo l’aggressore in fiamme infernali.',
        details: 'L’incantatore può lanciare questo incantesimo come reazione '
            'quando subisce danni da una creatura entro 18 metri che sia in '
            'grado di vedere. Punta l’indice contro la creatura che lo ha '
            'danneggiato, e quella creatura viene momentaneamente avviluppata '
            'da fiamme infernali. Il bersaglio deve effettuare un tiro salvezza '
            'su Destrezza. Se lo fallisce, subisce 2d10 danni da fuoco; se lo '
            'supera, subisce soltanto metà di quei danni. Usando uno slot di '
            'livello superiore al 1°, i danni aumentano di 1d10 per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.hellishRebuke,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.reaction,
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
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '2d10',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'hellish_rebuke_reaction_fire_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'reaction_when_damaged_by_visible_creature_within_18_meters',
          'target_makes_dexterity_saving_throw',
          'failed_save_deals_2d10_fire_damage',
          'successful_save_takes_half_damage',
          'damage_increases_by_1d10_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'warlock',
    },
  ),
  SpellIds.entangle: SpellDefinition(
    id: SpellIds.entangle,
    content: RuleContent(
      id: SpellIds.entangle,
      name: 'Intralciare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Fa spuntare vegetali intralcianti che rendono difficile l’area e trattengono creature.',
        details:
            'Erbacce e rampicanti spuntano dal terreno in un quadrato con lato '
            'di 6 metri a partire da un punto entro gittata. Per la durata, i '
            'vegetali trasformano l’area in terreno difficile. Una creatura '
            'presente nell’area quando l’incantesimo viene lanciato deve '
            'superare un tiro salvezza su Forza o essere trattenuta dai '
            'vegetali intralcianti fino al termine dell’incantesimo. Una '
            'creatura trattenuta può usare la sua azione per effettuare una '
            'prova di Forza contro la CD del tiro salvezza dell’incantesimo; '
            'se ha successo, si libera. Quando l’incantesimo termina, i '
            'vegetali evocati avvizziscono.',
      ),
      ownerId: SpellIds.entangle,
    ),
    level: 1,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'entangle_restraining_plants',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_6_meter_square_of_plants',
          'area_becomes_difficult_terrain',
          'creatures_in_area_make_strength_saving_throw',
          'failed_save_restrained_by_plants',
          'restrained_creature_can_use_action_strength_check_to_escape',
          'plants_wither_when_spell_ends',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.faerieFire: SpellDefinition(
    id: SpellIds.faerieFire,
    content: RuleContent(
      id: SpellIds.faerieFire,
      name: 'Luminescenza',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Evidenzia creature e oggetti con un alone luminoso, rendendoli più facili da colpire.',
        details:
            'Ogni oggetto contenuto in un cubo con spigolo di 6 metri entro '
            'gittata viene evidenziato da un alone di luce blu, verde o viola, '
            'a scelta dell’incantatore. Ogni creatura situata nell’area quando '
            'l’incantesimo viene lanciato viene evidenziata dall’alone se '
            'fallisce un tiro salvezza su Destrezza. Per la durata, gli oggetti '
            'e le creature influenzate proiettano luce fioca entro 3 metri. '
            'Ogni tiro per colpire contro una creatura o un oggetto influenzato '
            'dispone di vantaggio se l’attaccante è in grado di vederlo. Una '
            'creatura o un oggetto influenzato non trae beneficio '
            'dall’invisibilità. L’effetto richiede concentrazione.',
      ),
      ownerId: SpellIds.faerieFire,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'faerie_fire_glowing_targets_advantage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'affects_objects_in_6_meter_cube',
          'creatures_in_area_make_dexterity_saving_throw',
          'failed_save_outlines_creature_with_colored_light',
          'affected_targets_shed_dim_light_3_meters',
          'attack_rolls_against_affected_target_have_advantage_if_attacker_can_see_it',
          'affected_target_gains_no_benefit_from_invisibility',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
    },
  ),
  SpellIds.burningHands: SpellDefinition(
    id: SpellIds.burningHands,
    content: RuleContent(
      id: SpellIds.burningHands,
      name: 'Mani Brucianti',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Sprigiona un cono di fiamme dalle mani dell’incantatore.',
        details:
            'L’incantatore apre le mani con i pollici rivolti l’uno contro '
            'l’altro, sprigionando dalle dita un sottile velo di fiamme. Ogni '
            'creatura entro un cono di 4,5 metri deve effettuare un tiro '
            'salvezza su Destrezza. Se fallisce, subisce 3d6 danni da fuoco; '
            'se lo supera, subisce soltanto metà di quei danni. Il fuoco '
            'incendia ogni oggetto infiammabile nell’area che non sia indossato '
            'o trasportato. Usando uno slot di livello superiore al 1°, i danni '
            'aumentano di 1d6 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.burningHands,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
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
        SpellTargetType.special,
      },
    ),
    damage: [
      SpellDamage(
        dice: '3d6',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'burning_hands_cone_fire_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          '4_5_meter_cone_from_caster',
          'creatures_in_cone_make_dexterity_saving_throw',
          'failed_save_deals_3d6_fire_damage',
          'successful_save_takes_half_damage',
          'ignites_flammable_objects_not_worn_or_carried',
          'damage_increases_by_1d6_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.huntersMark: SpellDefinition(
    id: SpellIds.huntersMark,
    content: RuleContent(
      id: SpellIds.huntersMark,
      name: 'Marchio del Cacciatore',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Marca una creatura come preda, aumentando i danni e aiutando a rintracciarla.',
        details:
            'L’incantatore sceglie una creatura entro gittata che sia in grado '
            'di vedere e la marchia misticamente come sua preda. Finché '
            'l’incantesimo dura, l’incantatore infligge 1d6 danni extra al '
            'bersaglio ogni volta che lo colpisce con un attacco con arma. '
            'Inoltre dispone di vantaggio alle prove di Saggezza (Percezione) '
            'e Saggezza (Sopravvivenza) effettuate per trovarlo. Se il '
            'bersaglio scende a 0 punti ferita prima che l’incantesimo termini, '
            'l’incantatore può usare un’azione bonus in un turno successivo per '
            'marchiare una nuova creatura. L’effetto richiede concentrazione. '
            'Usando slot di 3° o 4° livello, può mantenere la concentrazione '
            'fino a 8 ore; usando slot di 5° livello o superiore, fino a 24 ore.',
      ),
      ownerId: SpellIds.huntersMark,
    ),
    level: 1,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'hunters_mark_marked_prey',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'marks_visible_creature_within_27_meters',
          'weapon_hits_against_marked_target_deal_extra_1d6_damage',
          'advantage_on_wisdom_perception_to_find_target',
          'advantage_on_wisdom_survival_to_find_target',
          'can_bonus_action_mark_new_creature_after_target_drops_to_0_hp',
          'requires_concentration',
          'slot_level_3_or_4_duration_up_to_8_hours',
          'slot_level_5_or_higher_duration_up_to_24_hours',
        },
      ),
    ],
    classIds: {
      'ranger',
    },
  ),
  SpellIds.fogCloud: SpellDefinition(
    id: SpellIds.fogCloud,
    content: RuleContent(
      id: SpellIds.fogCloud,
      name: 'Nube di Nebbia',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Crea una sfera di nebbia che oscura pesantemente l’area.',
        details: 'L’incantatore crea una sfera di nebbia del raggio di 6 metri '
            'centrata su un punto entro gittata. La sfera si diffonde oltre gli '
            'angoli e la sua area risulta pesantemente oscurata. La nebbia '
            'permane per la durata dell’incantesimo o finché un vento moderato '
            'o più forte, almeno 15 km/h, non la disperde. L’effetto richiede '
            'concentrazione. Usando uno slot di livello superiore al 1°, il '
            'raggio della sfera aumenta di 6 metri per ogni livello di slot '
            'superiore.',
      ),
      ownerId: SpellIds.fogCloud,
    ),
    level: 1,
    school: SpellSchool.conjuration,
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
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'fog_cloud_heavily_obscured_sphere',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_6_meter_radius_fog_sphere',
          'fog_spreads_around_corners',
          'area_is_heavily_obscured',
          'moderate_or_stronger_wind_15_kmh_disperses_fog',
          'radius_increases_by_6_meters_per_slot_level_above_1',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.thunderwave: SpellDefinition(
    id: SpellIds.thunderwave,
    content: RuleContent(
      id: SpellIds.thunderwave,
      name: 'Onda Tonante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Propaga dall’incantatore un’onda di energia tonante che danneggia e spinge.',
        details:
            'Un’ondata di energia tonante si propaga dall’incantatore. Ogni '
            'creatura entro un cubo con spigolo di 4,5 metri originato '
            'dall’incantatore deve effettuare un tiro salvezza su Costituzione. '
            'Se fallisce, subisce 2d8 danni da tuono e viene spinta di 3 metri '
            'più lontano dall’incantatore; se supera il tiro salvezza, subisce '
            'metà dei danni e non viene spinta. Gli oggetti non fissati e '
            'completamente situati nell’area vengono automaticamente spinti di '
            '3 metri più lontano dall’incantatore. L’incantesimo emette un '
            'rombo tonante udibile fino a 90 metri. Usando uno slot superiore '
            'al 1°, i danni aumentano di 1d8 per ogni livello di slot '
            'superiore.',
      ),
      ownerId: SpellIds.thunderwave,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
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
        SpellTargetType.special,
      },
    ),
    damage: [
      SpellDamage(
        dice: '2d8',
        type: SpellDamageType.thunder,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'thunderwave_constitution_save_push',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          '4_5_meter_cube_originating_from_caster',
          'creatures_in_area_make_constitution_saving_throw',
          'failed_save_deals_2d8_thunder_damage_and_pushes_3_meters',
          'successful_save_takes_half_damage_and_is_not_pushed',
          'unsecured_objects_in_area_are_pushed_3_meters',
          'audible_thunderous_boom_out_to_90_meters',
          'damage_increases_by_1d8_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.speakWithAnimals: SpellDefinition(
    id: SpellIds.speakWithAnimals,
    content: RuleContent(
      id: SpellIds.speakWithAnimals,
      name: 'Parlare con gli Animali',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di comprendere le bestie e parlare con loro.',
        details:
            'Per la durata dell’incantesimo, l’incantatore ottiene la capacità '
            'di comprendere le bestie e comunicare verbalmente con loro. Le '
            'conoscenze e la consapevolezza di molte bestie restano limitate '
            'dalla loro intelligenza, ma l’incantatore può ottenere almeno '
            'informazioni sui luoghi o sui mostri nelle vicinanze, o su ciò che '
            'le bestie percepiscono o hanno percepito nell’ultimo giorno. '
            'L’incantatore potrebbe anche persuadere una bestia a compiere un '
            'piccolo favore, a discrezione del DM. Può essere lanciato come '
            'rituale.',
      ),
      ownerId: SpellIds.speakWithAnimals,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'speak_with_animals_communication',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_understands_beasts',
          'caster_can_communicate_verbally_with_beasts',
          'beast_knowledge_limited_by_intelligence',
          'can_learn_information_about_nearby_locations_or_monsters',
          'can_learn_what_beasts_perceived_within_last_day',
          'may_persuade_beast_to_do_small_favor_at_dm_discretion',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
    },
  ),
  SpellIds.healingWord: SpellDefinition(
    id: SpellIds.healingWord,
    content: RuleContent(
      id: SpellIds.healingWord,
      name: 'Parola Guaritrice',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Guarisce a distanza una creatura visibile con una parola risanante.',
        details:
            'Una creatura scelta dall’incantatore entro gittata e che egli sia '
            'in grado di vedere recupera punti ferita pari a 1d4 + il '
            'modificatore della caratteristica da incantatore. L’incantesimo '
            'ha durata istantanea, richiede solo componente verbale e viene '
            'lanciato come azione bonus. Non ha effetto sui costrutti o sui non '
            'morti. Usando uno slot di livello superiore al 1°, la guarigione '
            'aumenta di 1d4 punti ferita per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.healingWord,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'healing_word_bonus_action_healing',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'visible_creature_within_18_meters_regains_1d4_plus_spellcasting_modifier_hp',
          'no_effect_on_constructs_or_undead',
          'healing_increases_by_1d4_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
    },
  ),
  SpellIds.longstrider: SpellDefinition(
    id: SpellIds.longstrider,
    content: RuleContent(
      id: SpellIds.longstrider,
      name: 'Passo Veloce',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Aumenta la velocità di una creatura toccata.',
        details: 'L’incantatore tocca una creatura. Finché l’incantesimo non '
            'termina, la velocità del bersaglio aumenta di 3 metri. '
            'L’incantesimo dura 1 ora, non richiede concentrazione e può essere '
            'usato per potenziare la mobilità del bersaglio durante '
            'esplorazione, inseguimenti o combattimento. Usando uno slot di '
            'livello superiore al 1°, l’incantatore può bersagliare una '
            'creatura aggiuntiva per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.longstrider,
    ),
    level: 1,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un pizzico di terriccio.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'longstrider_speed_increase',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature_speed_increases_by_3_meters',
          'does_not_require_concentration',
          'one_additional_target_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
      'wizard',
    },
  ),
  SpellIds.protectionFromEvilAndGood: SpellDefinition(
    id: SpellIds.protectionFromEvilAndGood,
    content: RuleContent(
      id: SpellIds.protectionFromEvilAndGood,
      name: 'Protezione dal Bene e dal Male',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Protegge una creatura consenziente da aberrazioni, celestiali, elementali, folletti, immondi e non morti.',
        details: 'L’incantatore tocca una creatura consenziente. Finché '
            'l’incantesimo non termina, il bersaglio è protetto da aberrazioni, '
            'celestiali, elementali, folletti, immondi e non morti. Le creature '
            'di quei tipi subiscono svantaggio ai tiri per colpire contro il '
            'bersaglio. Inoltre, il bersaglio non può essere affascinato, '
            'posseduto o spaventato da quelle creature. Se il bersaglio è già '
            'affascinato, posseduto o spaventato da una di quelle creature, '
            'dispone di vantaggio al nuovo tiro salvezza contro l’effetto '
            'rilevante. L’incantesimo richiede concentrazione e consuma la '
            'componente materiale.',
      ),
      ownerId: SpellIds.protectionFromEvilAndGood,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Acqua santa o polvere d’argento e di ferro, consumata dall’incantesimo.',
          consumed: true,
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
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'protection_from_evil_and_good_ward',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'protects_against_aberrations_celestials_elementals_fey_fiends_and_undead',
          'protected_creature_is_willing_touched_target',
          'listed_creature_types_have_disadvantage_on_attack_rolls_against_target',
          'target_cannot_be_charmed_frightened_or_possessed_by_listed_creature_types',
          'target_has_advantage_on_new_save_against_existing_relevant_effect',
          'requires_concentration',
          'material_component_is_consumed',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.wrathfulSmite: SpellDefinition(
    id: SpellIds.wrathfulSmite,
    content: RuleContent(
      id: SpellIds.wrathfulSmite,
      name: 'Punizione Collerica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Il prossimo colpo in mischia infligge danni psichici e può spaventare il bersaglio.',
        details:
            'La prossima volta che l’incantatore colpisce con un attacco con '
            'un’arma da mischia prima che l’incantesimo termini, l’attacco '
            'infligge 1d6 danni psichici extra. Inoltre, se il bersaglio è una '
            'creatura, deve superare un tiro salvezza su Saggezza o essere '
            'spaventato dall’incantatore finché l’incantesimo non termina. '
            'Con un’azione, la creatura può effettuare una prova di Saggezza '
            'contro la CD del tiro salvezza dell’incantesimo per rafforzare la '
            'propria determinazione e terminare l’incantesimo. L’effetto viene '
            'lanciato come azione bonus e richiede concentrazione.',
      ),
      ownerId: SpellIds.wrathfulSmite,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.psychic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'wrathful_smite_psychic_frightened',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'next_melee_weapon_hit_before_spell_ends_triggers_effect',
          'hit_deals_extra_1d6_psychic_damage',
          'creature_target_makes_wisdom_saving_throw',
          'failed_save_target_frightened_of_caster',
          'frightened_target_can_use_action_wisdom_check_to_end_spell',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.searingSmite: SpellDefinition(
    id: SpellIds.searingSmite,
    content: RuleContent(
      id: SpellIds.searingSmite,
      name: 'Punizione Incandescente',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Il prossimo colpo in mischia incendia il bersaglio e infligge danni da fuoco continuati.',
        details:
            'La prossima volta che l’incantatore colpisce una creatura con un '
            'attacco con un’arma da mischia prima che l’incantesimo termini, '
            'l’arma diventa incandescente e l’attacco infligge 1d6 danni da '
            'fuoco extra, oltre a incendiare il bersaglio. All’inizio di ogni '
            'turno del bersaglio, finché l’incantesimo non termina, il '
            'bersaglio effettua un tiro salvezza su Costituzione. Se fallisce, '
            'subisce 1d6 danni da fuoco; se lo supera, l’incantesimo termina. '
            'Anche il bersaglio o una creatura entro 1,5 metri può usare '
            'un’azione per estinguere le fiamme, terminando l’incantesimo; '
            'l’effetto termina anche se le fiamme vengono soppresse in altro '
            'modo, per esempio immergendo il bersaglio in acqua. Usando slot '
            'superiori al 1°, i danni extra iniziali aumentano di 1d6 per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.searingSmite,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'searing_smite_fire_and_burning',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'next_melee_weapon_hit_against_creature_before_spell_ends_triggers_effect',
          'hit_deals_extra_1d6_fire_damage',
          'target_is_ignited',
          'target_makes_constitution_save_at_start_of_each_turn',
          'failed_save_deals_1d6_fire_damage',
          'successful_save_ends_spell',
          'target_or_adjacent_creature_can_use_action_to_extinguish_flames',
          'water_or_other_flame_suppression_ends_spell',
          'initial_extra_damage_increases_by_1d6_per_slot_level_above_1',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.thunderousSmite: SpellDefinition(
    id: SpellIds.thunderousSmite,
    content: RuleContent(
      id: SpellIds.thunderousSmite,
      name: 'Punizione Tonante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Il prossimo colpo in mischia esplode con tuono, danni extra e possibile spinta.',
        details:
            'La prossima volta che l’incantatore colpisce con un attacco con '
            'un’arma da mischia prima che l’incantesimo termini, la sua arma '
            'vibra con un rombo di tuono udibile entro 90 metri e l’attacco '
            'infligge 2d6 danni da tuono extra al bersaglio. Inoltre, se il '
            'bersaglio è una creatura, deve superare un tiro salvezza su Forza '
            'o essere spinto di 3 metri più lontano dall’incantatore e buttato '
            'a terra prono. L’effetto viene lanciato come azione bonus e '
            'richiede concentrazione fino all’attacco o al termine della durata.',
      ),
      ownerId: SpellIds.thunderousSmite,
    ),
    level: 1,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '2d6',
        type: SpellDamageType.thunder,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'thunderous_smite_thunder_push_prone',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'next_melee_weapon_hit_before_spell_ends_triggers_effect',
          'hit_deals_extra_2d6_thunder_damage',
          'thunderous_boom_audible_within_90_meters',
          'creature_target_makes_strength_saving_throw',
          'failed_save_pushes_target_3_meters_and_knocks_prone',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.purifyFoodAndDrink: SpellDefinition(
    id: SpellIds.purifyFoodAndDrink,
    content: RuleContent(
      id: SpellIds.purifyFoodAndDrink,
      name: 'Purificare Cibo e Bevande',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Purifica cibi e bevande non magici in una piccola area, rimuovendo veleni e malattie.',
        details:
            'Tutti i cibi e le bevande non magici entro una sfera del raggio '
            'di 1,5 metri centrata su un punto scelto dall’incantatore entro '
            'gittata vengono purificati e liberati da veleni e malattie. '
            'L’incantesimo ha effetto istantaneo, non richiede concentrazione '
            'e può essere lanciato come rituale. Non crea nuovo cibo o nuova '
            'acqua: modifica soltanto cibi e bevande non magici già presenti '
            'nell’area.',
      ),
      ownerId: SpellIds.purifyFoodAndDrink,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 3,
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
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'purify_food_and_drink_cleanse',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'affects_nonmagical_food_and_drink_in_1_5_meter_radius_sphere',
          'sphere_center_point_within_3_meters',
          'purifies_food_and_drink',
          'removes_poisons_and_diseases',
          'does_not_create_food_or_water',
          'ritual_spell',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
      'paladin',
    },
  ),
  SpellIds.hailOfThorns: SpellDefinition(
    id: SpellIds.hailOfThorns,
    content: RuleContent(
      id: SpellIds.hailOfThorns,
      name: 'Raffica di Spine',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Il prossimo colpo con arma a distanza esplode in spine attorno al bersaglio.',
        details:
            'La prossima volta che l’incantatore colpisce una creatura con '
            'un’arma a distanza prima che l’incantesimo termini, una raffica '
            'di spine si sprigiona dalla sua arma a distanza o dalle sue '
            'munizioni. Oltre al normale effetto dell’attacco, il bersaglio e '
            'ogni creatura entro 1,5 metri da esso devono effettuare un tiro '
            'salvezza su Destrezza. Chi fallisce subisce 1d10 danni perforanti; '
            'chi supera il tiro salvezza subisce soltanto metà di quei danni. '
            'L’effetto richiede concentrazione e viene lanciato come azione '
            'bonus. Usando slot superiori al 1°, i danni aumentano di 1d10 per '
            'ogni livello di slot superiore, fino a un massimo di 6d10.',
      ),
      ownerId: SpellIds.hailOfThorns,
    ),
    level: 1,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d10',
        type: SpellDamageType.piercing,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'hail_of_thorns_ranged_weapon_burst',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'next_ranged_weapon_hit_before_spell_ends_triggers_effect',
          'target_and_creatures_within_1_5_meters_make_dexterity_saving_throw',
          'failed_save_deals_1d10_piercing_damage',
          'successful_save_takes_half_damage',
          'normal_weapon_attack_effect_still_applies',
          'damage_increases_by_1d10_per_slot_level_above_1',
          'maximum_damage_6d10',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'ranger',
    },
  ),
  SpellIds.rayOfSickness: SpellDefinition(
    id: SpellIds.rayOfSickness,
    content: RuleContent(
      id: SpellIds.rayOfSickness,
      name: 'Raggio di Infermità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Colpisce una creatura con un raggio velenoso che può avvelenarla temporaneamente.',
        details: 'Un raggio di nauseante energia verdastra sfreccia verso una '
            'creatura entro gittata. L’incantatore effettua un attacco a '
            'distanza con questo incantesimo contro il bersaglio. Se colpisce, '
            'il bersaglio subisce 2d8 danni da veleno e deve effettuare un '
            'tiro salvezza su Costituzione. Se fallisce, è avvelenato fino alla '
            'fine del turno successivo dell’incantatore. Usando uno slot di '
            'livello superiore al 1°, i danni aumentano di 1d8 per ogni livello '
            'di slot superiore.',
      ),
      ownerId: SpellIds.rayOfSickness,
    ),
    level: 1,
    school: SpellSchool.necromancy,
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
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '2d8',
        type: SpellDamageType.poison,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'ray_of_sickness_poisoned_condition',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ranged_spell_attack_against_creature',
          'hit_deals_2d8_poison_damage',
          'hit_target_makes_constitution_saving_throw',
          'failed_save_target_poisoned_until_end_of_casters_next_turn',
          'damage_increases_by_1d8_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.tashasHideousLaughter: SpellDefinition(
    id: SpellIds.tashasHideousLaughter,
    content: RuleContent(
      id: SpellIds.tashasHideousLaughter,
      name: 'Risata Incontenibile di Tasha',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Fa cadere una creatura in una risata spasmodica, rendendola prona e incapacitata.',
        details:
            'Una creatura scelta dall’incantatore, entro gittata e che egli sia '
            'in grado di vedere, percepisce ogni cosa come esilarante ed è '
            'scossa da una risata spasmodica se l’incantesimo la influenza. Il '
            'bersaglio deve superare un tiro salvezza su Saggezza o cadere a '
            'terra prono, diventare incapacitato e non essere in grado di '
            'rialzarsi per la durata dell’incantesimo. Una creatura con '
            'Intelligenza pari o inferiore a 4 non è influenzata. Alla fine di '
            'ogni suo turno e ogni volta che subisce danni, il bersaglio può '
            'effettuare un altro tiro salvezza su Saggezza. Se il tiro salvezza '
            'è innescato dai danni, il bersaglio dispone di vantaggio. In caso '
            'di successo, l’incantesimo termina. Richiede concentrazione.',
      ),
      ownerId: SpellIds.tashasHideousLaughter,
    ),
    level: 1,
    school: SpellSchool.enchantment,
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
          description:
              'Una manciata di briciole e una piuma da agitare in aria.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'tashas_hideous_laughter_prone_incapacitated',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'visible_creature_within_9_meters',
          'target_makes_wisdom_saving_throw',
          'failed_save_target_falls_prone',
          'failed_save_target_is_incapacitated',
          'failed_save_target_cannot_stand_up',
          'creature_with_intelligence_4_or_lower_unaffected',
          'target_repeats_wisdom_save_at_end_of_each_turn',
          'target_repeats_wisdom_save_when_taking_damage',
          'save_triggered_by_damage_has_advantage',
          'successful_repeat_save_ends_spell',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'wizard',
    },
  ),
  SpellIds.expeditiousRetreat: SpellDefinition(
    id: SpellIds.expeditiousRetreat,
    content: RuleContent(
      id: SpellIds.expeditiousRetreat,
      name: 'Ritirata Rapida',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di usare Scatto come azione bonus ripetuta.',
        details:
            'Questo incantesimo consente all’incantatore di muoversi a una '
            'velocità straordinaria. Quando lancia l’incantesimo, e poi come '
            'azione bonus a ogni suo turno finché l’incantesimo non termina, '
            'l’incantatore può effettuare l’azione di Scatto. L’effetto viene '
            'lanciato come azione bonus, richiede concentrazione e dura fino a '
            '10 minuti. Non aumenta direttamente la velocità base: concede '
            'invece la possibilità di usare Scatto come azione bonus mentre '
            'l’incantesimo resta attivo.',
      ),
      ownerId: SpellIds.expeditiousRetreat,
    ),
    level: 1,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 10,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'expeditious_retreat_bonus_action_dash',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'caster_can_dash_when_spell_is_cast',
          'caster_can_dash_as_bonus_action_each_turn',
          'requires_concentration',
          'does_not_directly_increase_base_speed',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.jump: SpellDefinition(
    id: SpellIds.jump,
    content: RuleContent(
      id: SpellIds.jump,
      name: 'Saltare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Triplica la distanza coperta dai salti di una creatura toccata.',
        details: 'L’incantatore tocca una creatura. Finché l’incantesimo non '
            'termina, la distanza coperta dai salti di quella creatura è '
            'triplicata. L’effetto dura 1 minuto, non richiede concentrazione e '
            'modifica la distanza dei salti, non la velocità base della '
            'creatura. Può essere utile per attraversare ostacoli, superare '
            'dislivelli, raggiungere appigli o migliorare la mobilità tattica '
            'in combattimento e in esplorazione.',
      ),
      ownerId: SpellIds.jump,
    ),
    level: 1,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'La zampa posteriore di una cavalletta.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'jump_tripled_jump_distance',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature_jump_distance_is_tripled',
          'does_not_require_concentration',
          'does_not_change_base_speed',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.sanctuary: SpellDefinition(
    id: SpellIds.sanctuary,
    content: RuleContent(
      id: SpellIds.sanctuary,
      name: 'Santuario',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Protegge una creatura costringendo chi la attacca a superare un tiro salvezza.',
        details:
            'L’incantatore protegge una creatura entro gittata dagli attacchi. '
            'Finché l’incantesimo non termina, ogni creatura che bersaglia la '
            'creatura protetta con un attacco o con un incantesimo che infligge '
            'danni deve prima effettuare un tiro salvezza su Saggezza. Se lo '
            'fallisce, deve scegliere un nuovo bersaglio o perdere l’attacco o '
            'l’incantesimo. Santuario non protegge dagli effetti ad area, come '
            'l’esplosione di una palla di fuoco. Se la creatura protetta '
            'effettua un attacco o lancia un incantesimo che influenza una '
            'creatura nemica, l’incantesimo termina.',
      ),
      ownerId: SpellIds.sanctuary,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
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
          description: 'Uno specchietto d’argento.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'sanctuary_wisdom_save_before_targeting',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'protects_one_creature_within_9_meters',
          'creature_targeting_protected_creature_must_make_wisdom_save',
          'failed_save_must_choose_new_target_or_lose_attack_or_spell',
          'does_not_protect_against_area_effects',
          'ends_if_protected_creature_attacks',
          'ends_if_protected_creature_casts_spell_affecting_enemy',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.shieldOfFaith: SpellDefinition(
    id: SpellIds.shieldOfFaith,
    content: RuleContent(
      id: SpellIds.shieldOfFaith,
      name: 'Scudo della Fede',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Conferisce a una creatura un campo scintillante che aumenta la Classe Armatura.',
        details:
            'Un campo di energia scintillante si materializza attorno a una '
            'creatura scelta dall’incantatore entro gittata. Per la durata '
            'dell’incantesimo, il bersaglio ottiene un bonus di +2 alla Classe '
            'Armatura. L’incantesimo viene lanciato come azione bonus, richiede '
            'concentrazione e può essere mantenuto fino a 10 minuti. Il bonus '
            'rimane attivo solo finché la concentrazione continua e si applica '
            'alla creatura scelta, non all’intero gruppo.',
      ),
      ownerId: SpellIds.shieldOfFaith,
    ),
    level: 1,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Una piccola pergamena su cui sia scritto un frammento di un testo sacro.',
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
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'shield_of_faith_plus_2_ac',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'chosen_creature_within_18_meters_gains_plus_2_ac',
          'requires_concentration',
          'duration_up_to_10_minutes',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.illusoryScript: SpellDefinition(
    id: SpellIds.illusoryScript,
    content: RuleContent(
      id: SpellIds.illusoryScript,
      name: 'Scritto Illusorio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Nasconde un testo dietro un’illusione leggibile solo dalle creature designate.',
        details:
            'L’incantatore scrive su carta, pergamena o altro materiale adatto '
            'e infonde nello scritto una potente illusione che dura 10 giorni. '
            'Agli occhi dell’incantatore e delle creature designate al momento '
            'del lancio, lo scritto appare normale, nella calligrafia '
            'dell’incantatore e con il significato voluto. Per tutti gli altri, '
            'il messaggio appare come un linguaggio magico o ignoto impossibile '
            'da decifrare, oppure come un messaggio completamente diverso in '
            'una calligrafia e in un linguaggio conosciuto dall’incantatore. '
            'Se l’incantesimo viene dissolto, scompaiono sia il messaggio '
            'originale sia l’illusione. Una creatura dotata di vista pura può '
            'leggere il messaggio nascosto. Può essere lanciato come rituale e '
            'consuma l’inchiostro richiesto.',
      ),
      ownerId: SpellIds.illusoryScript,
    ),
    level: 1,
    ritual: true,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Inchiostro a base di piombo del valore di almeno 10 mo, consumato dall’incantesimo.',
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.day,
      amount: 10,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'illusory_script_hidden_message',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'caster_writes_on_suitable_writing_material',
          'designated_creatures_see_true_message',
          'others_see_unknown_magical_language_or_false_message',
          'false_message_must_use_language_known_by_caster',
          'dispel_magic_removes_original_message_and_illusion',
          'truesight_can_read_hidden_message',
          'lead_based_ink_worth_at_least_10_gp_is_consumed',
          'duration_10_days',
        },
      ),
    ],
    classIds: {
      'bard',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.unseenServant: SpellDefinition(
    id: SpellIds.unseenServant,
    content: RuleContent(
      id: SpellIds.unseenServant,
      name: 'Servitore Inosservato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una forza invisibile che esegue semplici compiti su ordine dell’incantatore.',
        details:
            'L’incantesimo crea una forza invisibile, amorfa e priva di volontà '
            'propria che svolge compiti semplici finché l’incantesimo non '
            'termina. Il servitore appare sul terreno in uno spazio libero '
            'entro gittata, ha CA 10, 1 punto ferita, Forza 2 e non può '
            'attaccare. Se scende a 0 punti ferita, l’incantesimo termina. '
            'Una volta per turno, come azione bonus, l’incantatore può '
            'ordinargli mentalmente di muoversi fino a 4,5 metri e interagire '
            'con un oggetto. Può portare oggetti, pulire, riparare, ripiegare '
            'abiti, accendere fuochi, servire pietanze, versare vino e compiti '
            'simili. Dopo aver completato l’ordine, attende il comando '
            'successivo. Se riceve un compito che lo porterebbe oltre 18 metri '
            'dall’incantatore, l’incantesimo termina. Può essere lanciato come '
            'rituale.',
      ),
      ownerId: SpellIds.unseenServant,
    ),
    level: 1,
    ritual: true,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un filo di spago e un pezzo di legno.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'unseen_servant_invisible_force',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'ritual_spell',
          'creates_invisible_mindless_amorphous_force',
          'servant_appears_on_ground_in_unoccupied_space_within_18_meters',
          'servant_has_ac_10_1_hp_strength_2',
          'servant_cannot_attack',
          'spell_ends_if_servant_reaches_0_hp',
          'caster_can_bonus_action_command_servant_each_turn',
          'servant_can_move_4_5_meters_and_interact_with_object',
          'servant_can_perform_simple_tasks',
          'spell_ends_if_task_takes_servant_more_than_18_meters_from_caster',
        },
      ),
    ],
    classIds: {
      'bard',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.sleep: SpellDefinition(
    id: SpellIds.sleep,
    content: RuleContent(
      id: SpellIds.sleep,
      name: 'Sonno',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Addormenta magicamente creature entro un’area, partendo da quelle con meno punti ferita.',
        details:
            'L’incantatore tira 5d8: il totale ottenuto indica quanti punti '
            'ferita di creature possono essere influenzati. Le creature entro '
            '6 metri da un punto scelto entro gittata sono influenzate in '
            'ordine crescente dei loro punti ferita attuali, ignorando le '
            'creature già prive di sensi. Partendo dalla creatura con meno '
            'punti ferita, ogni creatura influenzata cade priva di sensi finché '
            'l’incantesimo non termina, finché subisce danni o finché qualcuno '
            'usa un’azione per scuoterla o schiaffeggiarla e svegliarla. I '
            'punti ferita di ogni creatura influenzata vengono sottratti dal '
            'totale prima di passare alla successiva; una creatura è '
            'influenzata solo se i suoi punti ferita sono pari o inferiori al '
            'totale rimanente. Non morti e creature immuni all’essere '
            'affascinate non sono influenzati. Usando slot superiori al 1°, si '
            'tirano 2d8 aggiuntivi per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.sleep,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un pizzico di sabbia finissima, petali di rosa o un grillo.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'sleep_magical_unconscious_pool',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'roll_5d8_to_determine_total_hit_points_affected',
          'affects_creatures_within_6_meters_of_chosen_point',
          'affects_creatures_in_ascending_current_hit_points',
          'ignores_unconscious_creatures',
          'affected_creatures_fall_unconscious',
          'sleep_ends_for_creature_if_damaged',
          'sleep_ends_for_creature_if_action_used_to_wake_it',
          'creature_must_have_hp_less_than_or_equal_to_remaining_total',
          'undead_are_not_affected',
          'creatures_immune_to_charmed_are_not_affected',
          'adds_2d8_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.hex: SpellDefinition(
    id: SpellIds.hex,
    content: RuleContent(
      id: SpellIds.hex,
      name: 'Sortilegio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Maledice una creatura, aumentando i danni dell’incantatore e ostacolando una caratteristica.',
        details: 'L’incantatore scaglia una maledizione su una creatura entro '
            'gittata che sia in grado di vedere. Finché l’incantesimo non '
            'termina, l’incantatore infligge 1d6 danni necrotici extra al '
            'bersaglio ogni volta che lo colpisce con un attacco. Inoltre, '
            'quando lancia l’incantesimo, sceglie una caratteristica: il '
            'bersaglio subisce svantaggio alle prove di caratteristica '
            'effettuate con quella caratteristica. Se il bersaglio scende a 0 '
            'punti ferita prima che l’incantesimo termini, l’incantatore può '
            'usare un’azione bonus in un suo turno successivo per maledire una '
            'nuova creatura. Un incantesimo Rimuovi Maledizione lanciato sul '
            'bersaglio termina Sortilegio prematuramente. Usando slot di 3° o '
            '4° livello, la concentrazione può durare fino a 8 ore; usando uno '
            'slot di 5° livello o superiore, fino a 24 ore.',
      ),
      ownerId: SpellIds.hex,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'L’occhio pietrificato di un girino.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.necrotic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'hex_curse_extra_necrotic_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'curses_visible_creature_within_27_meters',
          'caster_deals_extra_1d6_necrotic_damage_when_hitting_cursed_target_with_attack',
          'caster_chooses_one_ability_score',
          'target_has_disadvantage_on_ability_checks_with_chosen_ability',
          'caster_can_bonus_action_move_curse_after_target_drops_to_0_hp',
          'remove_curse_ends_spell_on_target',
          'requires_concentration',
          'slot_level_3_or_4_duration_up_to_8_hours',
          'slot_level_5_or_higher_duration_up_to_24_hours',
        },
      ),
    ],
    classIds: {
      'warlock',
    },
  ),
  SpellIds.colorSpray: SpellDefinition(
    id: SpellIds.colorSpray,
    content: RuleContent(
      id: SpellIds.colorSpray,
      name: 'Spruzzo Colorato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Acceca temporaneamente creature in un cono usando un totale di punti ferita influenzabili.',
        details:
            'Dalla mano dell’incantatore si sprigiona un lampo abbagliante di '
            'luce multicolore. L’incantatore tira 6d10: il totale indica quanti '
            'punti ferita di creature possono essere influenzati. Le creature '
            'entro un cono di 4,5 metri originato dall’incantatore sono '
            'influenzate in ordine crescente dei loro punti ferita attuali, '
            'ignorando le creature prive di sensi e quelle che non sono in '
            'grado di vedere. A partire dalla creatura con meno punti ferita, '
            'ogni creatura influenzata è accecata finché l’incantesimo non '
            'termina. I punti ferita di ogni creatura vengono sottratti dal '
            'totale prima di passare alla successiva; una creatura è '
            'influenzata solo se i suoi punti ferita sono pari o inferiori al '
            'totale rimanente. Usando slot superiori al 1°, si tirano 2d10 '
            'aggiuntivi per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.colorSpray,
    ),
    level: 1,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un pizzico di sabbia o di polvere colorata di rosso, giallo e blu.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.round,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'color_spray_blinding_hp_pool',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          '4_5_meter_cone_originating_from_caster',
          'roll_6d10_to_determine_total_hit_points_affected',
          'affects_creatures_in_ascending_current_hit_points',
          'ignores_unconscious_creatures',
          'ignores_creatures_that_cannot_see',
          'affected_creatures_are_blinded_until_spell_ends',
          'subtract_each_affected_creature_hp_from_total',
          'creature_must_have_hp_less_than_or_equal_to_remaining_total',
          'adds_2d10_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.dissonantWhispers: SpellDefinition(
    id: SpellIds.dissonantWhispers,
    content: RuleContent(
      id: SpellIds.dissonantWhispers,
      name: 'Sussurri Dissonanti',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Infligge dolore psichico a una creatura e può costringerla ad allontanarsi.',
        details:
            'L’incantatore sussurra una melodia dissonante udibile solo da una '
            'creatura scelta entro gittata, causandole dolore lancinante. Il '
            'bersaglio deve effettuare un tiro salvezza su Saggezza. Se '
            'fallisce, subisce 3d6 danni psichici e, se disponibile, deve usare '
            'immediatamente la sua reazione per muoversi il più lontano '
            'possibile dall’incantatore entro la propria velocità. La creatura '
            'non si muove su terreno palesemente pericoloso, come un incendio o '
            'una fossa. Se supera il tiro salvezza, subisce metà dei danni e '
            'non deve allontanarsi. Una creatura assordata supera '
            'automaticamente il tiro salvezza. Usando slot superiori al 1°, i '
            'danni aumentano di 1d6 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.dissonantWhispers,
    ),
    level: 1,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '3d6',
        type: SpellDamageType.psychic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'dissonant_whispers_wisdom_save_forced_movement',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'target_one_creature_within_18_meters',
          'only_target_can_hear_whisper',
          'target_makes_wisdom_saving_throw',
          'failed_save_deals_3d6_psychic_damage',
          'failed_save_target_uses_reaction_to_move_away_if_available',
          'forced_movement_uses_targets_speed',
          'target_does_not_move_into_obvious_hazard',
          'successful_save_takes_half_damage_and_does_not_move',
          'deafened_creature_automatically_succeeds_save',
          'damage_increases_by_1d6_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'bard',
    },
  ),
  SpellIds.grease: SpellDefinition(
    id: SpellIds.grease,
    content: RuleContent(
      id: SpellIds.grease,
      name: 'Unto',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Ricopre il terreno di unto, creando terreno difficile e facendo cadere prone le creature.',
        details:
            'Una patina viscida di unto ricopre un quadrato di terreno con '
            'lato di 3 metri, centrato in un punto entro gittata. Per la '
            'durata dell’incantesimo, l’area diventa terreno difficile. Quando '
            'l’unto compare, ogni creatura che si trova nell’area deve '
            'superare un tiro salvezza su Destrezza o cadere a terra prona. '
            'Anche una creatura che entra nell’area o vi termina il proprio '
            'turno deve superare un tiro salvezza su Destrezza o cade prona. '
            'L’incantesimo dura 1 minuto e non richiede concentrazione.',
      ),
      ownerId: SpellIds.grease,
    ),
    level: 1,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un frammento di grasso di maiale o di burro.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'grease_slippery_difficult_terrain',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_3_meter_square_of_grease',
          'area_is_difficult_terrain',
          'creatures_in_area_when_cast_make_dexterity_saving_throw',
          'failed_save_falls_prone',
          'creature_entering_area_makes_dexterity_saving_throw',
          'creature_ending_turn_in_area_makes_dexterity_saving_throw',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.falseLife: SpellDefinition(
    id: SpellIds.falseLife,
    content: RuleContent(
      id: SpellIds.falseLife,
      name: 'Vita Falsata',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rafforza l’incantatore con punti ferita temporanei necromantici.',
        details:
            'L’incantatore si rafforza con un duplicato necromantico di vita e '
            'ottiene 1d4 + 4 punti ferita temporanei per la durata '
            'dell’incantesimo. L’effetto dura 1 ora, ha gittata personale e non '
            'richiede concentrazione. I punti ferita temporanei proteggono '
            'l’incantatore finché durano o finché vengono consumati dai danni, '
            'secondo le regole normali dei punti ferita temporanei. Usando uno '
            'slot di livello superiore al 1°, l’incantatore ottiene 5 punti '
            'ferita temporanei aggiuntivi per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.falseLife,
    ),
    level: 1,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una piccola quantità di alcol o di liquore distillato.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'false_life_temporary_hit_points',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_gains_1d4_plus_4_temporary_hit_points',
          'temporary_hit_points_last_for_spell_duration_or_until_lost',
          'does_not_require_concentration',
          'adds_5_temporary_hit_points_per_slot_level_above_1',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.aid: SpellDefinition(
    id: SpellIds.aid,
    content: RuleContent(
      id: SpellIds.aid,
      name: 'Aiuto',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rafforza fino a tre creature aumentando i loro punti ferita attuali e massimi.',
        details: 'L’incantatore rafforza il vigore e la determinazione degli '
            'alleati. Sceglie fino a tre creature entro gittata. Per la durata '
            'dell’incantesimo, il massimo dei punti ferita e i punti ferita '
            'attuali di ogni bersaglio aumentano di 5. L’effetto dura 8 ore, '
            'non richiede concentrazione e non è una normale guarigione: '
            'aumenta direttamente sia il valore massimo sia i punti ferita '
            'attuali. Usando uno slot di livello superiore al 2°, l’aumento dei '
            'punti ferita cresce di altri 5 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.aid,
    ),
    level: 2,
    school: SpellSchool.abjuration,
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
          description: 'Una minuscola striscia di tessuto bianco.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 3,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'aid_current_and_max_hp_increase',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'up_to_three_creatures_within_9_meters',
          'each_target_current_hp_increases_by_5',
          'each_target_max_hp_increases_by_5',
          'does_not_require_concentration',
          'duration_8_hours',
          'increase_grows_by_5_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.phantasmalForce: SpellDefinition(
    id: SpellIds.phantasmalForce,
    content: RuleContent(
      id: SpellIds.phantasmalForce,
      name: 'Allucinazione di Forza',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea nella mente di una creatura un’illusione percepita come reale.',
        details:
            'L’incantatore crea un’allucinazione radicata nella mente di una '
            'creatura entro gittata e che egli sia in grado di vedere. Il '
            'bersaglio effettua un tiro salvezza su Intelligenza. Se fallisce, '
            'percepisce un oggetto, una creatura o un altro fenomeno fittizio '
            'scelto dall’incantatore, non più grande di un cubo con spigolo di '
            '3 metri. L’allucinazione è percepibile solo dal bersaglio e può '
            'includere suoni, temperature e altri stimoli analoghi. Costrutti e '
            'non morti non sono influenzati. Il bersaglio può usare la sua '
            'azione per esaminare l’allucinazione con una prova di Intelligenza '
            '(Indagare) contro la CD del tiro salvezza dell’incantesimo; se ha '
            'successo, riconosce l’illusione e l’incantesimo termina. Finché è '
            'influenzato, il bersaglio razionalizza gli esiti illogici e la '
            'tratta come reale. Se l’allucinazione rappresenta una creatura o '
            'un pericolo capace logicamente di ferire, può infliggere 1d6 danni '
            'psichici al bersaglio nel turno dell’incantatore quando il '
            'bersaglio si trova nella sua area o entro 1,5 metri da essa. '
            'Richiede concentrazione.',
      ),
      ownerId: SpellIds.phantasmalForce,
    ),
    level: 2,
    school: SpellSchool.illusion,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un ciuffo di lana.',
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
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.psychic,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'phantasmal_force_mind_illusion',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'visible_creature_within_18_meters',
          'target_makes_intelligence_saving_throw',
          'failed_save_creates_illusion_only_target_perceives',
          'illusion_up_to_3_meter_cube',
          'illusion_can_include_sound_temperature_and_similar_stimuli',
          'constructs_and_undead_unaffected',
          'target_can_use_action_investigation_check_to_end_spell',
          'target_treats_illusion_as_real_and_rationalizes_contradictions',
          'illusion_can_deal_1d6_psychic_damage_per_round_if_logically_harmful',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.alterSelf: SpellDefinition(
    id: SpellIds.alterSelf,
    content: RuleContent(
      id: SpellIds.alterSelf,
      name: 'Alterare Se Stesso',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di adattare il corpo, cambiare aspetto o generare armi naturali.',
        details: 'L’incantatore assume una forma diversa scegliendo una delle '
            'opzioni disponibili al momento del lancio. Finché l’incantesimo '
            'permane, può terminare un’opzione con un’azione per ottenere i '
            'benefici di un’altra. Con Adattamento Acquatico sviluppa branchie '
            'e membrane tra le dita, può respirare sott’acqua e ottiene una '
            'velocità di nuotare pari alla sua velocità base sul terreno. Con '
            'Armi Naturali sviluppa artigli, zanne, spine, corna o un’altra '
            'arma naturale: i suoi colpi senz’armi infliggono 1d6 danni '
            'contundenti, perforanti o taglienti appropriati alla forma scelta, '
            'l’incantatore è competente con quei colpi, l’arma naturale è '
            'magica e ottiene +1 ai tiri per colpire e ai danni effettuati con '
            'essa. Con Cambiare Aspetto modifica altezza, peso, lineamenti, '
            'voce, capelli, carnagione e tratti distintivi; può sembrare membro '
            'di un’altra razza, ma le statistiche non cambiano, la taglia resta '
            'la stessa e la forma base rimane compatibile. Richiede '
            'concentrazione.',
      ),
      ownerId: SpellIds.alterSelf,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'alter_self_body_options',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_chooses_aquatic_adaptation_natural_weapons_or_change_appearance',
          'caster_can_use_action_to_change_option_during_duration',
          'aquatic_adaptation_grants_underwater_breathing',
          'aquatic_adaptation_grants_swim_speed_equal_to_walking_speed',
          'natural_weapons_unarmed_strikes_deal_1d6_bludgeoning_piercing_or_slashing',
          'natural_weapons_are_magical',
          'natural_weapons_grant_plus_1_to_attack_and_damage_rolls',
          'change_appearance_alters_visible_body_and_voice_details',
          'change_appearance_does_not_change_statistics',
          'change_appearance_does_not_change_size',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.animalMessenger: SpellDefinition(
    id: SpellIds.animalMessenger,
    content: RuleContent(
      id: SpellIds.animalMessenger,
      name: 'Animale Messaggero',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Usa una bestia Minuscola come messaggero verso un luogo visitato dall’incantatore.',
        details:
            'L’incantatore sceglie una bestia Minuscola entro gittata che sia '
            'in grado di vedere, come uno scoiattolo, una ghiandaia o un '
            'pipistrello. Specifica un luogo che ha già visitato e un '
            'destinatario descritto genericamente. Pronuncia inoltre un '
            'messaggio di massimo venticinque parole. La bestia viaggia per la '
            'durata verso il luogo indicato, coprendo circa 75 km in 24 ore se '
            'volante o 37,5 km se non volante. Quando arriva, trasmette il '
            'messaggio alla creatura corrispondente alla descrizione, replicando '
            'il suono scelto dall’incantatore. Se non raggiunge la destinazione '
            'prima della fine dell’incantesimo, il messaggio è perduto e la '
            'bestia ritorna verso il punto in cui l’incantesimo è stato '
            'lanciato. Può essere lanciato come rituale. Usando slot superiori '
            'al 2°, la durata aumenta di 48 ore per ogni livello di slot '
            'superiore.',
      ),
      ownerId: SpellIds.animalMessenger,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.enchantment,
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
          description: 'Un boccone di cibo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 24,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'animal_messenger_tiny_beast_message',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'targets_tiny_beast_within_9_meters',
          'caster_must_see_target_beast',
          'destination_must_be_place_caster_has_visited',
          'recipient_can_be_generic_description',
          'message_maximum_25_words',
          'flying_messenger_travels_about_75_km_per_24_hours',
          'other_messenger_travels_about_37_5_km_per_24_hours',
          'message_lost_if_destination_not_reached_before_spell_ends',
          'duration_increases_by_48_hours_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
    },
  ),
  SpellIds.magicWeapon: SpellDefinition(
    id: SpellIds.magicWeapon,
    content: RuleContent(
      id: SpellIds.magicWeapon,
      name: 'Arma Magica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Trasforma temporaneamente un’arma non magica in arma magica con bonus a colpire e danni.',
        details:
            'L’incantatore tocca un’arma non magica. Finché l’incantesimo non '
            'termina, quell’arma diventa magica e ottiene un bonus di +1 ai '
            'tiri per colpire e ai tiri per i danni. L’incantesimo viene '
            'lanciato come azione bonus, richiede concentrazione e può durare '
            'fino a 1 ora. Usando uno slot di 4° livello o superiore, il bonus '
            'diventa +2; usando uno slot di 6° livello o superiore, il bonus '
            'diventa +3.',
      ),
      ownerId: SpellIds.magicWeapon,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'magic_weapon_plus_bonus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'touched_nonmagical_weapon_becomes_magical',
          'weapon_gains_plus_1_attack_and_damage_bonus',
          'requires_concentration',
          'slot_level_4_or_higher_bonus_plus_2',
          'slot_level_6_or_higher_bonus_plus_3',
        },
      ),
    ],
    classIds: {
      'paladin',
      'wizard',
    },
  ),
  SpellIds.spiritualWeapon: SpellDefinition(
    id: SpellIds.spiritualWeapon,
    content: RuleContent(
      id: SpellIds.spiritualWeapon,
      name: 'Arma Spirituale',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un’arma spettrale fluttuante che attacca come azione bonus.',
        details:
            'L’incantatore crea un’arma fluttuante spettrale entro gittata. '
            'L’arma permane per la durata dell’incantesimo o finché '
            'l’incantatore non lancia di nuovo questo incantesimo. Quando lo '
            'lancia, può effettuare un attacco in mischia con questo '
            'incantesimo contro una creatura entro 1,5 metri dall’arma. Se '
            'colpisce, il bersaglio subisce 1d8 danni da forza + il '
            'modificatore della caratteristica da incantatore. Come azione '
            'bonus nei turni successivi, l’incantatore può muovere l’arma fino '
            'a 6 metri e ripetere l’attacco contro una creatura entro 1,5 metri '
            'da essa. L’arma può assumere la forma preferita '
            'dall’incantatore. Non richiede concentrazione. Usando uno slot di '
            '4° livello o superiore, i danni aumentano di 1d8 per ogni due '
            'livelli di slot superiori al 2°.',
      ),
      ownerId: SpellIds.spiritualWeapon,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
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
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    attackType: SpellAttackType.melee,
    damage: [
      SpellDamage(
        dice: '1d8',
        type: SpellDamageType.force,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'spiritual_weapon_spectral_attack',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'bonus_action_spell',
          'creates_floating_spectral_weapon_within_18_meters',
          'on_cast_can_make_melee_spell_attack_from_weapon',
          'target_must_be_within_1_5_meters_of_weapon',
          'hit_deals_1d8_force_plus_spellcasting_modifier',
          'caster_can_bonus_action_move_weapon_6_meters_and_attack_again',
          'weapon_shape_chosen_by_caster',
          'does_not_require_concentration',
          'spell_ends_if_cast_again',
          'damage_increases_by_1d8_for_every_two_slot_levels_above_2',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.nystulsMagicAura: SpellDefinition(
    id: SpellIds.nystulsMagicAura,
    content: RuleContent(
      id: SpellIds.nystulsMagicAura,
      name: 'Aura Magica di Nystul',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Maschera una creatura o un oggetto affinché le divinazioni ricevano informazioni false.',
        details:
            'L’incantatore pone un’illusione su una creatura o un oggetto che '
            'tocca, così che gli incantesimi di divinazione rivelino '
            'informazioni false su quel bersaglio. Il bersaglio può essere una '
            'creatura consenziente o un oggetto non indossato né trasportato. '
            'Al lancio l’incantatore sceglie uno o entrambi gli effetti. Con '
            'Falsa Aura, cambia il modo in cui il bersaglio appare agli effetti '
            'che individuano le aure magiche: un oggetto non magico può '
            'sembrare magico, un oggetto magico può sembrare non magico, o '
            'l’aura può apparire appartenere a una scuola scelta. Con Maschera, '
            'cambia il modo in cui il bersaglio appare agli effetti che '
            'individuano tipi di creature o allineamenti, facendolo risultare '
            'come un tipo o allineamento scelto. Se l’incantesimo viene lanciato '
            'sullo stesso bersaglio ogni giorno per 30 giorni con lo stesso '
            'effetto, l’illusione permane finché non viene dissolta.',
      ),
      ownerId: SpellIds.nystulsMagicAura,
    ),
    level: 2,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un pezzo quadrato di seta.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 24,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'nystuls_magic_aura_false_divination_info',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_willing_creature_or_unworn_uncontrolled_object',
          'divination_spells_reveal_false_information',
          'caster_can_choose_false_aura_effect',
          'false_aura_changes_detected_magic_presence_or_school',
          'caster_can_make_nonmagical_object_appear_magical',
          'caster_can_make_magical_object_appear_nonmagical',
          'caster_can_choose_mask_effect',
          'mask_changes_detected_creature_type_or_alignment',
          'same_effect_every_day_for_30_days_becomes_until_dispelled',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.moonbeam: SpellDefinition(
    id: SpellIds.moonbeam,
    content: RuleContent(
      id: SpellIds.moonbeam,
      name: 'Bagliore Lunare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un cilindro di luce lunare che infligge danni radiosi e ostacola i mutaforma.',
        details:
            'Un bagliore argentato di luce pallida forma un cilindro del raggio '
            'di 1,5 metri e alto 12 metri, centrato su un punto entro gittata. '
            'Per la durata, il cilindro è pervaso di luce fioca. Quando una '
            'creatura entra nell’area dell’incantesimo per la prima volta in un '
            'turno o vi inizia il proprio turno, deve effettuare un tiro '
            'salvezza su Costituzione. Se fallisce, subisce 2d10 danni radiosi; '
            'se supera il tiro salvezza, subisce metà danni. Un mutaforma ha '
            'svantaggio a questo tiro salvezza e, se lo fallisce, riassume '
            'istantaneamente la sua forma originale e non può assumere una forma '
            'diversa finché non esce dalla luce dell’incantesimo. Nei turni '
            'successivi al lancio, l’incantatore può usare un’azione per '
            'muovere il bagliore fino a 18 metri in qualsiasi direzione. '
            'Richiede concentrazione. Usando uno slot di livello superiore al '
            '2°, i danni aumentano di 1d10 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.moonbeam,
    ),
    level: 2,
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
      materials: [
        SpellMaterialComponent(
          description:
              'Alcuni semi di qualsiasi pianta a chicchi e un frammento di feldspato opalescente.',
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
        SpellTargetType.special,
      },
    ),
    damage: [
      SpellDamage(
        dice: '2d10',
        type: SpellDamageType.radiant,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'moonbeam_radiant_cylinder_shapeshifter',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_1_5_meter_radius_12_meter_high_cylinder',
          'cylinder_centered_on_point_within_36_meters',
          'area_filled_with_dim_light',
          'creature_entering_area_first_time_on_turn_makes_constitution_save',
          'creature_starting_turn_in_area_makes_constitution_save',
          'failed_save_deals_2d10_radiant_damage',
          'successful_save_takes_half_damage',
          'shapechanger_has_disadvantage_on_save',
          'failed_save_shapechanger_reverts_to_original_form',
          'shapechanger_cannot_assume_different_form_until_leaving_light',
          'caster_can_use_action_to_move_beam_18_meters',
          'damage_increases_by_1d10_per_slot_level_above_2',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.holdPerson: SpellDefinition(
    id: SpellIds.holdPerson,
    content: RuleContent(
      id: SpellIds.holdPerson,
      name: 'Blocca Persone',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Paralizza un umanoide se fallisce il tiro salvezza su Saggezza.',
        details: 'L’incantatore sceglie un umanoide entro gittata e che sia in '
            'grado di vedere. Il bersaglio deve superare un tiro salvezza su '
            'Saggezza o essere paralizzato per la durata dell’incantesimo. Alla '
            'fine di ogni suo turno, il bersaglio può effettuare un nuovo tiro '
            'salvezza su Saggezza; se lo supera, l’incantesimo termina su di '
            'esso. Richiede concentrazione. Usando uno slot di livello '
            'superiore al 2°, può bersagliare un umanoide aggiuntivo per ogni '
            'livello di slot superiore, purché gli umanoidi siano entro 9 metri '
            'l’uno dall’altro quando vengono bersagliati.',
      ),
      ownerId: SpellIds.holdPerson,
    ),
    level: 2,
    school: SpellSchool.enchantment,
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
      materials: [
        SpellMaterialComponent(
          description: 'Una piccola sbarra di ferro.',
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'hold_person_wisdom_save_paralyzed',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_humanoid_within_18_meters',
          'target_makes_wisdom_saving_throw',
          'failed_save_target_paralyzed',
          'target_repeats_wisdom_save_at_end_of_each_turn',
          'successful_repeat_save_ends_spell_on_target',
          'requires_concentration',
          'one_additional_humanoid_per_slot_level_above_2',
          'additional_targets_must_be_within_9_meters_of_each_other',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.magicMouth: SpellDefinition(
    id: SpellIds.magicMouth,
    content: RuleContent(
      id: SpellIds.magicMouth,
      name: 'Bocca Magica',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Inserisce in un oggetto un messaggio che viene pronunciato al verificarsi di un innesco.',
        details:
            'L’incantatore inserisce un messaggio in un oggetto entro gittata. '
            'Sceglie un oggetto che sia in grado di vedere e che non sia '
            'indossato o trasportato da un’altra creatura. Pronuncia un '
            'messaggio di massimo venticinque parole, che può essere ripetuto '
            'per un massimo di 10 minuti, e stabilisce la circostanza che farà '
            'apparire la bocca magica e pronunciare il messaggio. Quando la '
            'circostanza si verifica, la bocca appare sull’oggetto e recita il '
            'messaggio con la voce e il volume usati al lancio. Se l’oggetto ha '
            'una bocca o qualcosa di simile, l’illusione può apparire lì. Al '
            'lancio l’incantatore decide se l’incantesimo termina dopo il primo '
            'messaggio o se si ripete quando l’innesco si ripresenta. L’innesco '
            'può essere generale o dettagliato, ma deve basarsi su condizioni '
            'visibili o udibili entro 9 metri dall’oggetto. Può essere lanciato '
            'come rituale e dura finché non viene dissolto.',
      ),
      ownerId: SpellIds.magicMouth,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
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
          description:
              'Un frammento di un favo e polvere di giada del valore di almeno 10 mo, consumata dall’incantesimo.',
          minimumCostGp: 10,
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.untilDispelled,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'magic_mouth_triggered_message',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'places_message_in_visible_object_within_9_meters',
          'object_must_not_be_worn_or_carried',
          'message_maximum_25_words',
          'message_can_be_repeated_for_up_to_10_minutes',
          'caster_sets_visible_or_audible_trigger_within_9_meters_of_object',
          'magic_mouth_appears_when_trigger_occurs',
          'mouth_recites_message_in_casters_voice_and_original_volume',
          'caster_chooses_one_time_or_repeating_trigger',
          'duration_until_dispelled',
          'jade_dust_worth_at_least_10_gp_is_consumed',
        },
      ),
    ],
    classIds: {
      'bard',
      'wizard',
    },
  ),
  SpellIds.calmEmotions: SpellDefinition(
    id: SpellIds.calmEmotions,
    content: RuleContent(
      id: SpellIds.calmEmotions,
      name: 'Calmare Emozioni',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Sopprime paura o fascino, oppure rende temporaneamente indifferenti creature ostili.',
        details:
            'L’incantatore tenta di sopprimere le emozioni più intense in un '
            'gruppo di persone. Ogni umanoide entro una sfera del raggio di 6 '
            'metri centrata su un punto entro gittata deve effettuare un tiro '
            'salvezza su Carisma; una creatura può scegliere di fallirlo. Per '
            'ogni creatura che fallisce, l’incantatore sceglie uno fra due '
            'effetti. Può sopprimere qualsiasi effetto che renda il bersaglio '
            'affascinato o spaventato; quando l’incantesimo termina, gli '
            'effetti soppressi tornano ad applicarsi se la loro durata non è '
            'scaduta. In alternativa, può rendere il bersaglio indifferente a '
            'creature scelte dall’incantatore verso cui sarebbe ostile. Questa '
            'indifferenza termina se il bersaglio viene attaccato, danneggiato '
            'da un incantesimo o vede un suo alleato subire danni. Quando '
            'l’incantesimo termina, la creatura torna ostile salvo decisione '
            'diversa del DM. Richiede concentrazione.',
      ),
      ownerId: SpellIds.calmEmotions,
    ),
    level: 2,
    school: SpellSchool.enchantment,
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
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'calm_emotions_suppression_or_indifference',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'affects_humanoids_in_6_meter_radius_sphere',
          'sphere_centered_on_point_within_18_meters',
          'targets_make_charisma_saving_throw',
          'target_can_choose_to_fail_save',
          'failed_save_caster_chooses_effect_per_target',
          'can_suppress_charmed_or_frightened_effects',
          'suppressed_effects_resume_after_spell_if_duration_remains',
          'can_make_target_indifferent_to_chosen_creatures',
          'indifference_ends_if_target_is_attacked_or_damaged_by_spell',
          'indifference_ends_if_target_sees_friend_damaged',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
    },
  ),
  SpellIds.enhanceAbility: SpellDefinition(
    id: SpellIds.enhanceAbility,
    content: RuleContent(
      id: SpellIds.enhanceAbility,
      name: 'Caratteristica Potenziata',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Conferisce a una creatura un potenziamento magico legato a una caratteristica.',
        details:
            'L’incantatore tocca una creatura e le conferisce un potenziamento '
            'magico scegliendo un effetto che permane finché l’incantesimo non '
            'termina. Astuzia della Volpe concede vantaggio alle prove di '
            'Intelligenza. Forza del Toro concede vantaggio alle prove di Forza '
            'e raddoppia la capacità di trasporto. Grazia del Gatto concede '
            'vantaggio alle prove di Destrezza e impedisce danni da cadute di '
            '6 metri o meno se il bersaglio non è incapacitato. Resistenza '
            'dell’Orso concede vantaggio alle prove di Costituzione e 2d6 punti '
            'ferita temporanei, che vengono persi al termine dell’incantesimo. '
            'Saggezza del Gufo concede vantaggio alle prove di Saggezza. '
            'Splendore dell’Aquila concede vantaggio alle prove di Carisma. '
            'Richiede concentrazione. Usando uno slot di livello superiore al '
            '2°, può bersagliare una creatura aggiuntiva per ogni livello di '
            'slot superiore.',
      ),
      ownerId: SpellIds.enhanceAbility,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Peli o piume strappati a una bestia.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'enhance_ability_choose_ability_boost',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature_receives_one_chosen_enhancement',
          'foxs_cunning_advantage_on_intelligence_checks',
          'bulls_strength_advantage_on_strength_checks',
          'bulls_strength_carrying_capacity_doubles',
          'cats_grace_advantage_on_dexterity_checks',
          'cats_grace_no_damage_from_falls_6_meters_or_less_if_not_incapacitated',
          'bears_endurance_advantage_on_constitution_checks',
          'bears_endurance_grants_2d6_temporary_hit_points',
          'bears_endurance_temp_hp_lost_when_spell_ends',
          'owls_wisdom_advantage_on_wisdom_checks',
          'eagles_splendor_advantage_on_charisma_checks',
          'one_additional_target_per_slot_level_above_2',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'sorcerer',
    },
  ),
  SpellIds.blindnessDeafness: SpellDefinition(
    id: SpellIds.blindnessDeafness,
    content: RuleContent(
      id: SpellIds.blindnessDeafness,
      name: 'Cecità/Sordità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Acceca o assorda una creatura se fallisce il tiro salvezza su Costituzione.',
        details:
            'L’incantatore sceglie una creatura entro gittata e che sia in '
            'grado di vedere, decidendo se tentare di accecarla o assordarla. '
            'Il bersaglio deve effettuare un tiro salvezza su Costituzione. Se '
            'lo fallisce, subisce la condizione scelta dall’incantatore per la '
            'durata dell’incantesimo. Alla fine di ogni suo turno, il bersaglio '
            'può effettuare un nuovo tiro salvezza su Costituzione; se lo '
            'supera, l’incantesimo termina. L’effetto dura 1 minuto e non '
            'richiede concentrazione. Usando uno slot di livello superiore al '
            '2°, l’incantatore può bersagliare una creatura aggiuntiva per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.blindnessDeafness,
    ),
    level: 2,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'blindness_deafness_constitution_save_condition',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_creature_within_9_meters',
          'caster_chooses_blinded_or_deafened',
          'target_makes_constitution_saving_throw',
          'failed_save_applies_chosen_condition',
          'target_repeats_constitution_save_at_end_of_each_turn',
          'successful_repeat_save_ends_spell',
          'does_not_require_concentration',
          'one_additional_target_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.cordonOfArrows: SpellDefinition(
    id: SpellIds.cordonOfArrows,
    content: RuleContent(
      id: SpellIds.cordonOfArrows,
      name: 'Cordone di Frecce',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Incanta munizioni piantate nel terreno affinché colpiscano creature che si avvicinano.',
        details:
            'L’incantatore colloca quattro munizioni non magiche, come frecce o '
            'quadrelli, nel terreno entro gittata e le rende magiche per '
            'proteggere l’area. Finché l’incantesimo non termina, ogni volta '
            'che una creatura diversa dall’incantatore arriva entro 9 metri '
            'dalle munizioni per la prima volta in un turno o vi termina il '
            'proprio turno, una delle munizioni vola per colpirla. La creatura '
            'deve superare un tiro salvezza su Destrezza o subire 1d6 danni '
            'perforanti. La munizione viene poi distrutta. L’incantesimo termina '
            'quando non rimangono più munizioni. Al momento del lancio, '
            'l’incantatore può designare qualsiasi numero di creature che '
            'verranno ignorate dall’incantesimo. Usando uno slot di livello '
            'superiore al 2°, il numero di munizioni influenzabili aumenta di '
            'due per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.cordonOfArrows,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 1.5,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Quattro o più frecce o quadrelli.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    damage: [
      SpellDamage(
        dice: '1d6',
        type: SpellDamageType.piercing,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'cordon_of_arrows_guarding_ammunition',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'places_four_or_more_nonmagical_arrows_or_bolts_in_ground',
          'ammunition_becomes_magical_guard',
          'triggers_when_non_ignored_creature_enters_within_9_meters_first_time_on_turn',
          'triggers_when_non_ignored_creature_ends_turn_within_9_meters',
          'triggered_creature_makes_dexterity_saving_throw',
          'failed_save_deals_1d6_piercing_damage',
          'one_piece_of_ammunition_is_destroyed_after_trigger',
          'spell_ends_when_no_ammunition_remains',
          'caster_can_designate_any_number_of_ignored_creatures',
          'two_additional_ammunition_per_slot_level_above_2',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'ranger',
    },
  ),
  SpellIds.crownOfMadness: SpellDefinition(
    id: SpellIds.crownOfMadness,
    content: RuleContent(
      id: SpellIds.crownOfMadness,
      name: 'Corona di Follia',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Affascina un umanoide e può costringerlo ad attaccare una creatura scelta dall’incantatore.',
        details:
            'L’incantatore sceglie un umanoide entro gittata e che sia in grado '
            'di vedere. Il bersaglio deve superare un tiro salvezza su Saggezza '
            'o essere affascinato dall’incantatore per la durata. Mentre è '
            'affascinato in questo modo, sul bersaglio compare una corona di '
            'ferro deforme e tagliente, e nei suoi occhi brilla un bagliore di '
            'follia. In ciascuno dei suoi turni, prima di muoversi, il bersaglio '
            'affascinato deve usare la sua azione per effettuare un attacco in '
            'mischia contro una creatura diversa da sé stesso scelta '
            'mentalmente dall’incantatore. Se l’incantatore non sceglie alcuna '
            'creatura o nessuna creatura è entro portata del bersaglio, il '
            'bersaglio agisce normalmente. Nei turni successivi, l’incantatore '
            'deve usare la sua azione per mantenere il controllo, altrimenti '
            'l’incantesimo termina. Il bersaglio può effettuare un nuovo tiro '
            'salvezza su Saggezza alla fine di ogni suo turno; se lo supera, '
            'l’incantesimo termina. Richiede concentrazione.',
      ),
      ownerId: SpellIds.crownOfMadness,
    ),
    level: 2,
    school: SpellSchool.enchantment,
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'crown_of_madness_charmed_forced_attack',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_humanoid_within_36_meters',
          'target_makes_wisdom_saving_throw',
          'failed_save_target_charmed_by_caster',
          'charmed_target_has_visible_iron_crown_and_madness_glow',
          'target_must_use_action_before_moving_to_make_melee_attack',
          'attack_target_chosen_mentally_by_caster',
          'forced_attack_must_target_creature_other_than_itself',
          'target_acts_normally_if_no_creature_is_chosen_or_in_reach',
          'caster_must_use_action_on_later_turns_to_maintain_control',
          'spell_ends_if_caster_does_not_use_action_to_maintain_control',
          'target_repeats_wisdom_save_at_end_of_each_turn',
          'successful_repeat_save_ends_spell',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.spikeGrowth: SpellDefinition(
    id: SpellIds.spikeGrowth,
    content: RuleContent(
      id: SpellIds.spikeGrowth,
      name: 'Crescita di Spine',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Trasforma il terreno in un’area di spine mimetizzate, difficile e dannosa da attraversare.',
        details:
            'Spine e spuntoni nascono dal terreno entro un raggio di 6 metri '
            'centrato su un punto situato entro gittata. Per la durata '
            'dell’incantesimo, l’area diventa terreno difficile. Quando una '
            'creatura entra nell’area o si muove al suo interno, subisce 2d4 '
            'danni perforanti per ogni 1,5 metri percorsi. La trasformazione '
            'del terreno è mimetizzata in modo da sembrare naturale. Una '
            'creatura che non ha osservato l’area al momento del lancio deve '
            'superare una prova di Saggezza (Percezione) contro la CD del tiro '
            'salvezza dell’incantesimo per riconoscere il pericolo prima di '
            'entrarvi. Richiede concentrazione.',
      ),
      ownerId: SpellIds.spikeGrowth,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 45,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Sette spine aguzze o sette rametti appuntiti.',
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
    damage: [
      SpellDamage(
        dice: '2d4',
        type: SpellDamageType.piercing,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'spike_growth_hidden_piercing_terrain',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_6_meter_radius_area_centered_on_point_within_45_meters',
          'area_is_difficult_terrain',
          'creature_entering_area_takes_2d4_piercing_per_1_5_meters_moved',
          'creature_moving_within_area_takes_2d4_piercing_per_1_5_meters_moved',
          'terrain_transformation_is_camouflaged_as_natural',
          'creature_that_did_not_observe_casting_makes_wisdom_perception_check_to_notice_danger',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
    },
  ),
  SpellIds.enthrall: SpellDefinition(
    id: SpellIds.enthrall,
    content: RuleContent(
      id: SpellIds.enthrall,
      name: 'Estasiare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Distrarre creature visibili con parole frastornanti, penalizzando la loro Percezione verso altri.',
        details:
            'L’incantatore pronuncia una sequenza di parole frastornante e '
            'costringe le creature a sua scelta entro gittata e che sia in '
            'grado di vedere a effettuare un tiro salvezza su Saggezza. Una '
            'creatura che non può essere affascinata supera automaticamente il '
            'tiro salvezza; una creatura contro cui l’incantatore o i suoi '
            'compagni stanno combattendo dispone di vantaggio. Se una creatura '
            'fallisce, subisce svantaggio alle prove di Saggezza (Percezione) '
            'effettuate per percepire qualsiasi creatura diversa '
            'dall’incantatore. L’effetto dura finché l’incantesimo termina, '
            'finché il bersaglio non è più in grado di sentire l’incantatore, '
            'finché l’incantatore diventa incapacitato o finché non è più in '
            'grado di parlare.',
      ),
      ownerId: SpellIds.enthrall,
    ),
    level: 2,
    school: SpellSchool.enchantment,
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
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creatures,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'enthrall_wisdom_perception_distraction',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_chosen_visible_creatures_within_18_meters',
          'targets_make_wisdom_saving_throw',
          'creatures_that_cannot_be_charmed_automatically_succeed',
          'creatures_fighting_caster_or_allies_have_advantage_on_save',
          'failed_save_disadvantage_on_wisdom_perception_to_perceive_others',
          'disadvantage_applies_to_creatures_other_than_caster',
          'effect_ends_if_target_can_no_longer_hear_caster',
          'spell_ends_if_caster_incapacitated',
          'spell_ends_if_caster_can_no_longer_speak',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'warlock',
    },
  ),
  SpellIds.continualFlame: SpellDefinition(
    id: SpellIds.continualFlame,
    content: RuleContent(
      id: SpellIds.continualFlame,
      name: 'Fiamma Perenne',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea su un oggetto una fiamma magica permanente, luminosa ma priva di calore.',
        details:
            'Una fiamma di intensità equivalente a quella di una torcia si '
            'sprigiona da un oggetto toccato dall’incantatore. L’effetto appare '
            'come una fiamma normale, ma non produce calore e non consuma '
            'ossigeno. La fiamma perenne può essere coperta o nascosta, ma non '
            'può essere soffocata o estinta con mezzi ordinari. L’incantesimo '
            'dura finché non viene dissolto e consuma polvere di rubino del '
            'valore richiesto.',
      ),
      ownerId: SpellIds.continualFlame,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Polvere di rubino del valore di almeno 50 mo, consumata dall’incantesimo.',
          minimumCostGp: 50,
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.untilDispelled,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'continual_flame_torch_light_no_heat',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_flame_on_touched_object',
          'flame_brightness_equivalent_to_torch',
          'flame_looks_normal_but_produces_no_heat',
          'flame_does_not_consume_oxygen',
          'flame_can_be_covered_or_hidden',
          'flame_cannot_be_smothered_or_extinguished_normally',
          'duration_until_dispelled',
          'ruby_dust_worth_50_gp_is_consumed',
        },
      ),
    ],
    classIds: {
      'cleric',
      'wizard',
    },
  ),
  SpellIds.shatter: SpellDefinition(
    id: SpellIds.shatter,
    content: RuleContent(
      id: SpellIds.shatter,
      name: 'Frantumare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Produce un rumore assordante che infligge danni da tuono in una piccola area.',
        details: 'Un rumore improvviso, assordante e dolorosamente intenso si '
            'diffonde da un punto scelto dall’incantatore entro gittata. Ogni '
            'creatura entro una sfera del raggio di 3 metri centrata su quel '
            'punto deve effettuare un tiro salvezza su Costituzione. Se '
            'fallisce, subisce 3d8 danni da tuono; se supera il tiro salvezza, '
            'subisce metà danni. Una creatura fatta di materiale inorganico '
            'come pietra, cristallo o metallo subisce svantaggio a questo tiro '
            'salvezza. Anche un oggetto non magico che non sia indossato o '
            'trasportato subisce i danni se si trova nell’area. Usando uno slot '
            'di livello superiore al 2°, i danni aumentano di 1d8 per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.shatter,
    ),
    level: 2,
    school: SpellSchool.evocation,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un frammento di mica.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    damage: [
      SpellDamage(
        dice: '3d8',
        type: SpellDamageType.thunder,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'shatter_constitution_save_thunder_burst',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          '3_meter_radius_sphere_centered_on_point_within_18_meters',
          'creatures_in_area_make_constitution_saving_throw',
          'failed_save_deals_3d8_thunder_damage',
          'successful_save_takes_half_damage',
          'inorganic_creatures_have_disadvantage_on_save',
          'nonmagical_unworn_unheld_objects_in_area_take_damage',
          'damage_increases_by_1d8_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.melfsAcidArrow: SpellDefinition(
    id: SpellIds.melfsAcidArrow,
    content: RuleContent(
      id: SpellIds.melfsAcidArrow,
      name: 'Freccia Acida di Melf',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Scaglia una freccia acida contro un bersaglio, con danni immediati e successivi.',
        details:
            'Una freccia verde scintillante vola fino a un bersaglio entro '
            'gittata ed esplode in uno spruzzo d’acido. L’incantatore effettua '
            'un attacco a distanza con questo incantesimo contro il bersaglio. '
            'Se colpisce, il bersaglio subisce immediatamente 4d4 danni da '
            'acido e altri 2d4 danni da acido alla fine del suo turno '
            'successivo. Se l’attacco manca, la freccia spruzza comunque acido '
            'sul bersaglio, infliggendo metà dei danni iniziali e nessun danno '
            'alla fine del turno successivo. Usando uno slot di livello '
            'superiore al 2°, sia i danni iniziali sia quelli successivi '
            'aumentano di 1d4 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.melfsAcidArrow,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 27,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Una foglia di rabarbaro in polvere e lo stomaco di una vipera.',
        ),
      ],
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
        dice: '4d4',
        type: SpellDamageType.acid,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'melfs_acid_arrow_delayed_acid',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ranged_spell_attack_against_target_within_27_meters',
          'hit_deals_4d4_acid_damage_immediately',
          'hit_deals_2d4_acid_damage_at_end_of_targets_next_turn',
          'miss_deals_half_initial_damage',
          'miss_deals_no_delayed_damage',
          'initial_and_delayed_damage_increase_by_1d4_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.mirrorImage: SpellDefinition(
    id: SpellIds.mirrorImage,
    content: RuleContent(
      id: SpellIds.mirrorImage,
      name: 'Immagine Speculare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea tre duplicati illusori che possono deviare gli attacchi diretti contro l’incantatore.',
        details:
            'Tre duplicati illusori dell’incantatore compaiono nel suo spazio. '
            'Finché l’incantesimo non termina, si muovono assieme a lui, '
            'imitano le sue azioni e cambiano posizione rendendo impossibile '
            'capire quale immagine sia reale. L’incantatore può usare la sua '
            'azione per congedarli. Ogni volta che una creatura bersaglia '
            'l’incantatore con un attacco, l’incantatore tira un d20 per '
            'determinare se l’attacco colpisce invece un duplicato: con tre '
            'duplicati serve 6 o più, con due duplicati 8 o più, con un '
            'duplicato 11 o più. La CA di un duplicato è 10 + il modificatore '
            'di Destrezza dell’incantatore. Un duplicato colpito viene '
            'distrutto, ma ignora ogni altro danno o effetto. L’incantesimo '
            'termina quando tutti e tre i duplicati sono distrutti. Una creatura '
            'non è influenzata se non può vedere, se si affida a sensi diversi '
            'dalla vista o se percepisce le illusioni come false.',
      ),
      ownerId: SpellIds.mirrorImage,
    ),
    level: 2,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'mirror_image_three_illusory_duplicates',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_three_illusory_duplicates_in_casters_space',
          'duplicates_move_with_caster_and_mimic_actions',
          'caster_can_use_action_to_dismiss_duplicates',
          'attack_targeting_caster_can_be_redirected_to_duplicate',
          'three_duplicates_redirect_on_d20_6_or_higher',
          'two_duplicates_redirect_on_d20_8_or_higher',
          'one_duplicate_redirect_on_d20_11_or_higher',
          'duplicate_ac_is_10_plus_caster_dexterity_modifier',
          'duplicate_destroyed_when_hit_by_attack',
          'duplicates_ignore_all_other_damage_and_effects',
          'spell_ends_when_all_duplicates_destroyed',
          'creature_unaffected_if_cannot_see_or_uses_nonvisual_senses',
          'truesight_or_similar_true_perception_ignores_spell',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.detectThoughts: SpellDefinition(
    id: SpellIds.detectThoughts,
    content: RuleContent(
      id: SpellIds.detectThoughts,
      name: 'Individuazione dei Pensieri',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette di leggere pensieri superficiali, sondare più a fondo o cercare creature pensanti vicine.',
        details: 'Per la durata, l’incantatore può leggere i pensieri di certe '
            'creature. Quando lancia l’incantesimo e come azione in ogni turno, '
            'può concentrarsi su una creatura entro 9 metri che sia in grado di '
            'vedere. Una creatura con Intelligenza 3 o inferiore, o che non '
            'parli alcun linguaggio, non può essere influenzata. Inizialmente '
            'l’incantatore apprende i pensieri superficiali. Con un’azione può '
            'spostare l’attenzione su un’altra creatura o sondare più a fondo '
            'la stessa mente. Se sonda più a fondo, il bersaglio effettua un '
            'tiro salvezza su Saggezza: se fallisce, vengono rivelati i suoi '
            'ragionamenti, stato emotivo e una presenza dominante nei suoi '
            'pensieri; se supera, l’incantesimo termina. Il bersaglio è '
            'comunque consapevole della sonda mentale e può usare la sua azione '
            'per una prova contrapposta di Intelligenza contro l’incantatore; '
            'se ha successo, l’incantesimo termina. L’incantesimo può anche '
            'cercare pensieri entro 9 metri, penetrando la maggior parte delle '
            'barriere ma venendo bloccato da pietra spessa, metallo, piombo o '
            'materiali simili indicati dalla regola. Richiede concentrazione.',
      ),
      ownerId: SpellIds.detectThoughts,
    ),
    level: 2,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una moneta di rame.',
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
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'detect_thoughts_read_and_probe_minds',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_can_focus_on_visible_creature_within_9_meters_on_cast_or_as_action',
          'creature_with_intelligence_3_or_lower_unaffected',
          'creature_that_speaks_no_language_unaffected',
          'initially_reads_surface_thoughts',
          'caster_can_action_switch_to_another_creature',
          'caster_can_action_probe_deeper',
          'deep_probe_target_makes_wisdom_saving_throw',
          'failed_deep_probe_reveals_reasoning_emotional_state_and_dominant_thought',
          'successful_deep_probe_save_ends_spell',
          'target_knows_mind_is_being_probed',
          'target_can_action_intelligence_contest_to_end_spell',
          'caster_can_search_for_thinking_creatures_within_9_meters',
          'search_is_blocked_by_thick_stone_metal_lead_or_similar_barriers',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.enlargeReduce: SpellDefinition(
    id: SpellIds.enlargeReduce,
    content: RuleContent(
      id: SpellIds.enlargeReduce,
      name: 'Ingrandire/Ridurre',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Ingrandisce o riduce una creatura o un oggetto, modificando taglia, peso e Forza.',
        details:
            'L’incantatore ingrandisce o riduce una creatura o un oggetto entro '
            'gittata che sia in grado di vedere. Il bersaglio deve essere una '
            'creatura o un oggetto non indossato né trasportato. Se il bersaglio '
            'non è consenziente, può effettuare un tiro salvezza su '
            'Costituzione; se lo supera, l’incantesimo non ha effetto. Se il '
            'bersaglio è una creatura, tutto ciò che indossa e trasporta cambia '
            'taglia con lei, mentre un oggetto lasciato cadere torna subito alla '
            'taglia normale. Con Ingrandire, la taglia raddoppia in tutte le '
            'dimensioni, il peso aumenta di otto volte, la categoria di taglia '
            'aumenta di uno se possibile, il bersaglio ha vantaggio alle prove '
            'e ai tiri salvezza su Forza e le sue armi infliggono 1d4 danni '
            'extra. Con Ridurre, la taglia si dimezza, il peso diventa un '
            'ottavo, la categoria di taglia diminuisce di uno, il bersaglio ha '
            'svantaggio alle prove e ai tiri salvezza su Forza e le sue armi '
            'infliggono 1d4 danni in meno, senza scendere sotto 1 danno. '
            'Richiede concentrazione.',
      ),
      ownerId: SpellIds.enlargeReduce,
    ),
    level: 2,
    school: SpellSchool.transmutation,
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
          description: 'Un pizzico di polvere di ferro.',
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
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'enlarge_reduce_size_change',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_creature_or_unworn_unheld_object_within_9_meters',
          'unwilling_target_makes_constitution_saving_throw',
          'successful_save_no_effect',
          'creature_equipment_changes_size_with_creature',
          'dropped_object_returns_to_normal_size',
          'enlarge_doubles_dimensions_and_multiplies_weight_by_8',
          'enlarge_increases_size_category_if_space_allows',
          'enlarge_grants_advantage_on_strength_checks_and_saves',
          'enlarged_weapons_deal_extra_1d4_damage',
          'reduce_halves_dimensions_and_reduces_weight_to_one_eighth',
          'reduce_decreases_size_category',
          'reduce_grants_disadvantage_on_strength_checks_and_saves',
          'reduced_weapons_deal_1d4_less_damage_minimum_1',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.invisibility: SpellDefinition(
    id: SpellIds.invisibility,
    content: RuleContent(
      id: SpellIds.invisibility,
      name: 'Invisibilità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rende invisibile una creatura toccata finché non attacca o lancia un incantesimo.',
        details:
            'Una creatura toccata dall’incantatore diventa invisibile finché '
            'l’incantesimo non termina. Anche tutto ciò che il bersaglio '
            'indossa o trasporta diventa invisibile finché rimane sulla sua '
            'persona. L’incantesimo richiede concentrazione e può durare fino a '
            '1 ora. L’effetto termina per un bersaglio quando quel bersaglio '
            'attacca o lancia un incantesimo. Usando uno slot di livello '
            'superiore al 2°, l’incantatore può bersagliare una creatura '
            'aggiuntiva per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.invisibility,
    ),
    level: 2,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un ciglio in uno strato di resina.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'invisibility_touched_creature_hidden',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature_becomes_invisible',
          'carried_and_worn_equipment_becomes_invisible_with_target',
          'effect_ends_for_target_when_target_attacks',
          'effect_ends_for_target_when_target_casts_spell',
          'one_additional_target_per_slot_level_above_2',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.flameBlade: SpellDefinition(
    id: SpellIds.flameBlade,
    content: RuleContent(
      id: SpellIds.flameBlade,
      name: 'Lama Infuocata',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Evoca nella mano libera dell’incantatore una lama di fuoco usata per attacchi in mischia.',
        details:
            'L’incantatore evoca una lama infuocata nella sua mano libera. La '
            'lama ha forma e dimensioni simili a una scimitarra e permane per '
            'la durata dell’incantesimo. Se l’incantatore la lascia andare, la '
            'lama scompare, ma può essere evocata di nuovo usando un’azione '
            'bonus. L’incantatore può usare la sua azione per effettuare un '
            'attacco in mischia con questo incantesimo usando la lama; se '
            'colpisce, il bersaglio subisce 3d6 danni da fuoco. La lama '
            'proietta luce intensa entro 3 metri e luce fioca per altri 3 '
            'metri. Richiede concentrazione e può durare fino a 10 minuti. '
            'Usando uno slot di 4° livello o superiore, i danni aumentano di '
            '1d6 per ogni due livelli di slot superiori al 2°.',
      ),
      ownerId: SpellIds.flameBlade,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una foglia di sommacco.',
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
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    attackType: SpellAttackType.melee,
    damage: [
      SpellDamage(
        dice: '3d6',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'flame_blade_fiery_scimitar',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'bonus_action_spell',
          'creates_fiery_blade_in_casters_free_hand',
          'blade_shape_and_size_similar_to_scimitar',
          'blade_disappears_if_released',
          'caster_can_bonus_action_recreate_blade',
          'caster_can_action_make_melee_spell_attack_with_blade',
          'hit_deals_3d6_fire_damage',
          'blade_sheds_bright_light_3_meters_and_dim_light_3_more_meters',
          'damage_increases_by_1d6_for_every_two_slot_levels_above_2_starting_slot_4',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
    },
  ),
  SpellIds.levitate: SpellDefinition(
    id: SpellIds.levitate,
    content: RuleContent(
      id: SpellIds.levitate,
      name: 'Levitazione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Solleva verticalmente una creatura o un oggetto e lo mantiene sospeso.',
        details:
            'L’incantatore sceglie una creatura o un oggetto entro gittata e che '
            'sia in grado di vedere. Il bersaglio si solleva verticalmente fino '
            'a 6 metri e rimane sospeso per la durata. L’incantesimo può far '
            'levitare un bersaglio che pesa fino a 250 kg. Una creatura non '
            'consenziente che supera un tiro salvezza su Costituzione non '
            'subisce l’effetto. Il bersaglio può muoversi solo spingendosi o '
            'aggrappandosi a un oggetto fisso o a una superficie entro portata, '
            'come se stesse scalando. L’incantatore può variare l’altitudine '
            'del bersaglio fino a 6 metri in ogni direzione nel proprio turno. '
            'Richiede concentrazione e può durare fino a 10 minuti.',
      ),
      ownerId: SpellIds.levitate,
    ),
    level: 2,
    school: SpellSchool.transmutation,
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
      materials: [
        SpellMaterialComponent(
          description:
              'Un piccolo cappio di cuoio o un sottile cavo dorato piegato a forma di coppa con un lungo manico a un’estremità.',
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
        SpellTargetType.creature,
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'levitate_vertical_suspension',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_creature_or_object_within_18_meters',
          'target_levitates_vertically_up_to_6_meters',
          'target_remains_suspended_for_duration',
          'maximum_target_weight_250_kg',
          'unwilling_creature_makes_constitution_saving_throw',
          'successful_save_no_effect',
          'target_moves_only_by_pushing_or_pulling_against_fixed_object_or_surface',
          'movement_while_suspended_is_like_climbing_surface',
          'caster_can_change_targets_altitude_up_to_6_meters_on_turn',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.locateAnimalsOrPlants: SpellDefinition(
    id: SpellIds.locateAnimalsOrPlants,
    content: RuleContent(
      id: SpellIds.locateAnimalsOrPlants,
      name: 'Localizza Animali o Vegetali',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rivela direzione e distanza della bestia o del vegetale più vicino del tipo nominato.',
        details:
            'L’incantatore descrive o nomina un tipo specifico di bestia o '
            'vegetale. Concentrandosi sulla voce della natura che echeggia '
            'attorno a lui, apprende la direzione e la distanza fino alla '
            'creatura o al vegetale di quel tipo più vicino entro 7,5 km, se ne '
            'è presente almeno uno. L’incantesimo ha gittata personale, durata '
            'istantanea e può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.locateAnimalsOrPlants,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un ciuffo di pelo strappato a un segugio.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'locate_animals_or_plants_nearest_type',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'caster_names_or_describes_specific_kind_of_beast_or_plant',
          'reveals_direction_and_distance_to_nearest_matching_beast_or_plant',
          'search_radius_7_5_km',
          'instantaneous_divination',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
    },
  ),
  SpellIds.locateObject: SpellDefinition(
    id: SpellIds.locateObject,
    content: RuleContent(
      id: SpellIds.locateObject,
      name: 'Localizza Oggetto',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rivela la direzione di un oggetto familiare o del più vicino oggetto di un tipo scelto.',
        details:
            'L’incantatore descrive o nomina un oggetto a lui familiare. Per la '
            'durata, percepisce la direzione dell’ubicazione dell’oggetto, '
            'purché esso si trovi entro 300 metri; se l’oggetto è in movimento, '
            'l’incantatore sa in quale direzione si muove. L’incantesimo può '
            'localizzare un oggetto specifico noto all’incantatore, purché lo '
            'abbia visto da vicino entro 9 metri almeno una volta. In '
            'alternativa, può localizzare l’oggetto più vicino di un tipo '
            'particolare, come un certo tipo di veste, gioiello, mobile, '
            'strumento o arma. L’incantesimo non può localizzare un oggetto se '
            'una cortina di piombo di qualsiasi spessore blocca il percorso '
            'diretto tra l’incantatore e l’oggetto. Richiede concentrazione.',
      ),
      ownerId: SpellIds.locateObject,
    ),
    level: 2,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un rametto biforcuto.',
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
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'locate_object_direction_tracking',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_names_or_describes_familiar_object',
          'reveals_direction_to_object_within_300_meters',
          'reveals_direction_of_movement_if_object_is_moving',
          'can_locate_specific_object_seen_within_9_meters_before',
          'can_locate_nearest_object_of_a_particular_kind',
          'lead_blocks_direct_path_and_prevents_location',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'paladin',
      'ranger',
      'wizard',
    },
  ),
  SpellIds.spiderClimb: SpellDefinition(
    id: SpellIds.spiderClimb,
    content: RuleContent(
      id: SpellIds.spiderClimb,
      name: 'Movimenti del Ragno',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette a una creatura consenziente di muoversi su pareti e soffitti mantenendo le mani libere.',
        details:
            'Finché l’incantesimo non termina, una creatura consenziente toccata '
            'dall’incantatore ottiene la capacità di muoversi verticalmente e '
            'orizzontalmente sulle pareti e a testa in giù sui soffitti, '
            'mantenendo le mani libere. Il bersaglio ottiene inoltre una '
            'velocità di scalare pari alla sua velocità base sul terreno. '
            'L’incantesimo richiede concentrazione e può durare fino a 1 ora.',
      ),
      ownerId: SpellIds.spiderClimb,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una goccia di bitume e un ragno.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'spider_climb_wall_and_ceiling_movement',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_willing_creature',
          'target_can_move_vertically_and_horizontally_on_walls',
          'target_can_move_upside_down_on_ceilings',
          'target_keeps_hands_free_while_climbing',
          'target_gains_climb_speed_equal_to_walking_speed',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.darkness: SpellDefinition(
    id: SpellIds.darkness,
    content: RuleContent(
      id: SpellIds.darkness,
      name: 'Oscurità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una sfera di oscurità magica che blocca scurovisione e luce non magica.',
        details:
            'L’incantatore sceglie un punto entro gittata da cui si diffonde '
            'un’oscurità magica che riempie una sfera del raggio di 4,5 metri '
            'per la durata dell’incantesimo. L’oscurità si diffonde oltre gli '
            'angoli. Una creatura dotata di scurovisione non può vedere '
            'attraverso questa oscurità e le luci non magiche non possono '
            'illuminarla. Se il punto scelto si trova su un oggetto impugnato '
            'dall’incantatore o su un oggetto non indossato né trasportato, '
            'l’oscurità si diffonde dall’oggetto e si muove con esso. Coprire '
            'completamente la fonte con un oggetto opaco blocca l’oscurità. Se '
            'l’area dell’incantesimo si sovrappone a un’area di luce creata da '
            'un incantesimo di 2° livello o inferiore, l’incantesimo che ha '
            'creato la luce è dissolto. Richiede concentrazione.',
      ),
      ownerId: SpellIds.darkness,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Pelo di pipistrello e una goccia di pece o un pezzo di carbone.',
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
        SpellTargetType.point,
        SpellTargetType.object,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'darkness_magical_sphere',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_4_5_meter_radius_sphere_of_magical_darkness',
          'darkness_spreads_around_corners',
          'darkvision_cannot_see_through_darkness',
          'nonmagical_light_cannot_illuminate_darkness',
          'darkness_can_originate_from_held_or_unworn_unheld_object',
          'darkness_moves_with_source_object',
          'opaque_cover_blocks_darkness_source',
          'overlapping_light_spell_level_2_or_lower_is_dismissed',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.passWithoutTrace: SpellDefinition(
    id: SpellIds.passWithoutTrace,
    content: RuleContent(
      id: SpellIds.passWithoutTrace,
      name: 'Passare Senza Tracce',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Avvolge l’incantatore e creature scelte in un velo che migliora la furtività e nasconde le tracce.',
        details: 'L’incantatore è avvolto da un velo d’ombra e di silenzio che '
            'impedisce a lui e ai suoi compagni di essere individuati. Per la '
            'durata dell’incantesimo, ogni creatura scelta dall’incantatore e '
            'situata entro 9 metri da lui, incluso l’incantatore stesso, ottiene '
            'un bonus di +10 alle prove di Destrezza (Furtività). Inoltre, le '
            'tracce delle creature influenzate sono impossibili da seguire se '
            'non tramite mezzi magici: una creatura che riceve il bonus non '
            'lascia impronte o altre tracce del proprio passaggio. Richiede '
            'concentrazione e può durare fino a 1 ora.',
      ),
      ownerId: SpellIds.passWithoutTrace,
    ),
    level: 2,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Cenere di una foglia di vischio bruciata e un rametto di abete.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
        SpellTargetType.creatures,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'pass_without_trace_stealth_bonus',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_and_chosen_creatures_within_9_meters',
          'affected_creatures_gain_plus_10_dexterity_stealth_checks',
          'affected_creatures_tracks_can_only_be_followed_by_magical_means',
          'affected_creatures_leave_no_footprints_or_other_traces',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
    },
  ),
  SpellIds.mistyStep: SpellDefinition(
    id: SpellIds.mistyStep,
    content: RuleContent(
      id: SpellIds.mistyStep,
      name: 'Passo Velato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Teletrasporta l’incantatore in uno spazio libero visibile entro breve distanza.',
        details:
            'L’incantatore è avvolto per un istante da una foschia argentata e '
            'si teletrasporta di un massimo di 9 metri fino a uno spazio libero '
            'che sia in grado di vedere. L’incantesimo viene lanciato come '
            'azione bonus, ha solo componente verbale e la sua durata è '
            'istantanea.',
      ),
      ownerId: SpellIds.mistyStep,
    ),
    level: 2,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'misty_step_short_teleport',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'caster_teleports_up_to_9_meters',
          'destination_must_be_unoccupied_space',
          'destination_must_be_visible_to_caster',
          'instantaneous_teleportation',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.barkskin: SpellDefinition(
    id: SpellIds.barkskin,
    content: RuleContent(
      id: SpellIds.barkskin,
      name: 'Pelle Coriacea',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rende la pelle di una creatura ruvida come corteccia e impone una CA minima.',
        details: 'L’incantatore tocca una creatura consenziente. Finché '
            'l’incantesimo non termina, la pelle del bersaglio assume un '
            'aspetto ruvido simile alla corteccia e la sua Classe Armatura non '
            'può essere inferiore a 16, a prescindere dal tipo di armatura che '
            'indossa. L’incantesimo richiede concentrazione e può durare fino a '
            '1 ora.',
      ),
      ownerId: SpellIds.barkskin,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un frammento di corteccia di quercia.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'barkskin_minimum_armor_class',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_willing_creature',
          'target_skin_becomes_rough_like_bark',
          'target_armor_class_cannot_be_lower_than_16',
          'minimum_ac_applies_regardless_of_armor_worn',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
    },
  ),
  SpellIds.beastSense: SpellDefinition(
    id: SpellIds.beastSense,
    content: RuleContent(
      id: SpellIds.beastSense,
      name: 'Percezione delle Bestie',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di percepire attraverso i sensi di una bestia consenziente.',
        details: 'L’incantatore tocca una bestia consenziente. Per la durata '
            'dell’incantesimo, può usare la sua azione per vedere attraverso '
            'gli occhi della bestia e sentire ciò che essa sente, continuando a '
            'farlo finché non usa la propria azione per tornare ai suoi sensi '
            'normali. Finché percepisce il mondo attraverso i sensi della '
            'bestia, l’incantatore ottiene i benefici di qualsiasi senso '
            'speciale posseduto dalla creatura, ma resta accecato e assordato '
            'nei confronti di ciò che accade attorno a lui. Richiede '
            'concentrazione, può durare fino a 1 ora e può essere lanciato come '
            'rituale.',
      ),
      ownerId: SpellIds.beastSense,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'beast_sense_shared_senses',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'touched_willing_beast',
          'caster_can_action_see_through_beasts_eyes',
          'caster_can_action_hear_what_beast_hears',
          'caster_can_action_return_to_normal_senses',
          'caster_gains_benefit_of_beasts_special_senses',
          'caster_blinded_and_deafened_to_own_surroundings_while_using_beast_senses',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
    },
  ),
  SpellIds.prayerOfHealing: SpellDefinition(
    id: SpellIds.prayerOfHealing,
    content: RuleContent(
      id: SpellIds.prayerOfHealing,
      name: 'Preghiera di Guarigione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Guarisce fino a sei creature visibili entro gittata dopo un lancio di 10 minuti.',
        details:
            'Fino a sei creature scelte dall’incantatore, situate entro gittata '
            'e che egli sia in grado di vedere, recuperano punti ferita pari a '
            '2d8 + il modificatore della caratteristica da incantatore. '
            'L’incantesimo ha tempo di lancio di 10 minuti e durata '
            'istantanea. Non ha effetto sui costrutti o sui non morti. Usando '
            'uno slot di livello superiore al 2°, la guarigione aumenta di 1d8 '
            'per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.prayerOfHealing,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 10,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creatures,
      },
      maximumTargets: 6,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'prayer_of_healing_six_creatures_heal',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'up_to_six_visible_creatures_within_9_meters',
          'each_target_heals_2d8_plus_spellcasting_modifier',
          'no_effect_on_constructs',
          'no_effect_on_undead',
          'healing_increases_by_1d8_per_slot_level_above_2',
          'casting_time_10_minutes',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.augury: SpellDefinition(
    id: SpellIds.augury,
    content: RuleContent(
      id: SpellIds.augury,
      name: 'Presagio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Riceve un presagio su un corso d’azione specifico da intraprendere entro 30 minuti.',
        details:
            'Lanciando bastoncini incastonati di gemme, ossa di drago, carte '
            'illustrate o altri strumenti di divinazione, l’incantatore riceve '
            'un segno da un’entità ultraterrena sul risultato di un corso '
            'd’azione specifico che intende intraprendere entro i successivi 30 '
            'minuti. Il DM sceglie uno dei presagi: ventura per risultati '
            'positivi, sventura per risultati negativi, ventura e sventura se '
            'ci sono sia risultati positivi sia negativi, oppure nulla se non '
            'sono previsti risultati rilevanti. L’incantesimo non considera '
            'circostanze future che potrebbero alterare l’esito, come il lancio '
            'di altri incantesimi o la perdita o acquisizione di compagni. Può '
            'essere lanciato come rituale.',
      ),
      ownerId: SpellIds.augury,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Bastoncini, ossa o amuleti analoghi ricoperti di segni del valore di almeno 25 mo.',
          minimumCostGp: 25,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'augury_omen_for_course_of_action',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'asks_about_specific_course_of_action_within_next_30_minutes',
          'dm_returns_omen_weal_woe_weal_and_woe_or_nothing',
          'weal_positive_results',
          'woe_negative_results',
          'weal_and_woe_positive_and_negative_results',
          'nothing_no_relevant_positive_or_negative_result',
          'does_not_account_for_later_circumstances_that_change_outcome',
          'material_component_worth_at_least_25_gp',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.protectionFromPoison: SpellDefinition(
    id: SpellIds.protectionFromPoison,
    content: RuleContent(
      id: SpellIds.protectionFromPoison,
      name: 'Protezione dai Veleni',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Neutralizza un veleno su una creatura e le concede difese contro veleno.',
        details:
            'L’incantatore tocca una creatura. Se quella creatura è avvelenata, '
            'il veleno viene neutralizzato. Se il bersaglio è afflitto da più '
            'veleni, l’incantatore neutralizza un veleno di cui conosce la '
            'presenza oppure ne neutralizza uno a caso. Per la durata '
            'dell’incantesimo, il bersaglio dispone di vantaggio ai tiri '
            'salvezza per non essere avvelenato e di resistenza ai danni da '
            'veleno. L’effetto dura 1 ora e non richiede concentrazione.',
      ),
      ownerId: SpellIds.protectionFromPoison,
    ),
    level: 2,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'protection_from_poison_neutralize_and_resist',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature',
          'neutralizes_poison_if_target_is_poisoned',
          'if_multiple_poisons_caster_neutralizes_known_poison_or_random_poison',
          'target_has_advantage_on_saves_against_being_poisoned',
          'target_has_resistance_to_poison_damage',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
      'paladin',
      'ranger',
    },
  ),
  SpellIds.brandingSmite: SpellDefinition(
    id: SpellIds.brandingSmite,
    content: RuleContent(
      id: SpellIds.brandingSmite,
      name: 'Punizione Marchiante',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Carica il prossimo colpo con un bagliore radioso che rivela il bersaglio.',
        details:
            'La prossima volta che l’incantatore colpisce una creatura con un '
            'attacco con un’arma entro la durata dell’incantesimo, l’arma '
            'risplende di un bagliore astrale al momento dell’impatto. '
            'L’attacco infligge 2d6 danni radiosi extra al bersaglio. Se il '
            'bersaglio è invisibile, diventa visibile, proietta luce fioca in '
            'un raggio di 1,5 metri attorno a sé e non può diventare invisibile '
            'finché l’incantesimo non termina. Richiede concentrazione e dura '
            'fino a 1 minuto. Usando uno slot di livello superiore al 2°, i '
            'danni extra aumentano di 1d6 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.brandingSmite,
    ),
    level: 2,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.bonusAction,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '2d6',
        type: SpellDamageType.radiant,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'branding_smite_radiant_reveal',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'bonus_action_spell',
          'next_weapon_attack_hit_before_spell_ends_triggers_effect',
          'hit_deals_2d6_extra_radiant_damage',
          'invisible_target_becomes_visible',
          'target_sheds_dim_light_1_5_meters',
          'target_cannot_become_invisible_until_spell_ends',
          'extra_damage_increases_by_1d6_per_slot_level_above_2',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.rayOfEnfeeblement: SpellDefinition(
    id: SpellIds.rayOfEnfeeblement,
    content: RuleContent(
      id: SpellIds.rayOfEnfeeblement,
      name: 'Raggio di Affaticamento',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Colpisce una creatura con energia logorante e dimezza i danni dei suoi attacchi di Forza.',
        details: 'Un raggio nero di energia logorante scaturisce dal dito '
            'dell’incantatore verso una creatura entro gittata. L’incantatore '
            'effettua un attacco a distanza con questo incantesimo contro il '
            'bersaglio. Se colpisce, il bersaglio infligge soltanto metà danni '
            'con gli attacchi con le armi basati sulla Forza finché '
            'l’incantesimo non termina. Alla fine di ogni proprio turno, il '
            'bersaglio può effettuare un tiro salvezza su Costituzione; se lo '
            'supera, l’incantesimo termina. Richiede concentrazione e può '
            'durare fino a 1 minuto.',
      ),
      ownerId: SpellIds.rayOfEnfeeblement,
    ),
    level: 2,
    school: SpellSchool.necromancy,
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
    persistentEffects: [
      SpellPersistentEffect(
        id: 'ray_of_enfeeblement_strength_weapon_damage_halved',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ranged_spell_attack_against_creature_within_18_meters',
          'hit_halves_targets_strength_based_weapon_attack_damage',
          'target_repeats_constitution_save_at_end_of_each_turn',
          'successful_repeat_save_ends_spell',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'warlock',
      'wizard',
    },
  ),
  SpellIds.scorchingRay: SpellDefinition(
    id: SpellIds.scorchingRay,
    content: RuleContent(
      id: SpellIds.scorchingRay,
      name: 'Raggio Rovente',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea tre raggi di fuoco che possono colpire uno o più bersagli.',
        details:
            'L’incantatore crea tre raggi di fuoco e li scaglia contro uno o '
            'più bersagli entro gittata. Effettua un attacco a distanza con '
            'questo incantesimo per ogni raggio. Se un raggio colpisce, il '
            'bersaglio subisce 2d6 danni da fuoco. I raggi possono essere '
            'diretti contro lo stesso bersaglio o contro bersagli diversi entro '
            'gittata. Usando uno slot di 3° livello o superiore, l’incantatore '
            'crea un raggio aggiuntivo per ogni livello di slot superiore al 2°.',
      ),
      ownerId: SpellIds.scorchingRay,
    ),
    level: 2,
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
    ),
    attackType: SpellAttackType.ranged,
    damage: [
      SpellDamage(
        dice: '2d6',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'scorching_ray_three_fire_rays',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_three_fire_rays',
          'rays_can_target_one_or_more_targets_within_36_meters',
          'make_one_ranged_spell_attack_for_each_ray',
          'each_hit_deals_2d6_fire_damage',
          'one_additional_ray_per_slot_level_above_2',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.web: SpellDefinition(
    id: SpellIds.web,
    content: RuleContent(
      id: SpellIds.web,
      name: 'Ragnatela',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Evoca un cubo di ragnatele che rende il terreno difficile, oscura e trattiene le creature.',
        details:
            'L’incantatore evoca una massa di filamenti spessi e viscosi in un '
            'punto entro gittata. Le ragnatele riempiono un cubo con spigolo di '
            '6 metri generato da quel punto per la durata. L’area è terreno '
            'difficile ed è leggermente oscurata. Se le ragnatele non sono '
            'ancorate tra masse solide o stese su pavimento, muro o soffitto, '
            'collassano e l’incantesimo termina all’inizio del turno successivo '
            'dell’incantatore; su una superficie piatta hanno profondità di 1,5 '
            'metri. Ogni creatura che inizia il turno nelle ragnatele o vi entra '
            'durante il proprio turno effettua un tiro salvezza su Destrezza. '
            'Se fallisce, è trattenuta finché rimane tra le ragnatele o finché '
            'non si libera spezzandole. Una creatura trattenuta può usare la '
            'sua azione per effettuare una prova di Forza contro la CD '
            'dell’incantesimo; se ha successo, non è più trattenuta. Le '
            'ragnatele sono infiammabili: un cubo con spigolo di 1,5 metri '
            'brucia in 1 round e infligge 2d4 danni da fuoco alle creature che '
            'iniziano il turno tra le fiamme. Richiede concentrazione.',
      ),
      ownerId: SpellIds.web,
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
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un frammento di ragnatela comune.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    damage: [
      SpellDamage(
        dice: '2d4',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'web_restraining_flammable_area',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_6_meter_cube_of_webs_centered_on_point_within_18_meters',
          'web_area_is_difficult_terrain',
          'web_area_is_lightly_obscured',
          'webs_collapse_if_not_anchored_or_supported',
          'unsupported_webs_end_spell_at_start_of_casters_next_turn',
          'webs_on_flat_surface_have_1_5_meter_depth',
          'creature_starting_turn_in_webs_makes_dexterity_save',
          'creature_entering_webs_on_turn_makes_dexterity_save',
          'failed_save_creature_restrained',
          'restrained_creature_can_action_strength_check_to_break_free',
          'webs_are_flammable',
          'burning_1_5_meter_web_cube_deals_2d4_fire_to_creatures_starting_turn_in_flames',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.gentleRepose: SpellDefinition(
    id: SpellIds.gentleRepose,
    content: RuleContent(
      id: SpellIds.gentleRepose,
      name: 'Riposo Inviolato',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Protegge un cadavere dalla decomposizione e dall’essere trasformato in non morto.',
        details:
            'L’incantatore tocca un cadavere o resti di altro tipo. Per la '
            'durata dell’incantesimo, il bersaglio è protetto dalla '
            'decomposizione e non può diventare un non morto. Inoltre, '
            'l’incantesimo estende a tutti gli effetti il limite di tempo entro '
            'cui rianimare il bersaglio dalla morte: i giorni trascorsi sotto '
            'l’influenza dell’incantesimo non contano per determinare il limite '
            'di tempo di incantesimi come rianimare morti. L’effetto dura 10 '
            'giorni e può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.gentleRepose,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un pizzico di sale e due monete di rame da collocare sugli occhi del cadavere per la durata.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.day,
      amount: 10,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'gentle_repose_preserve_corpse',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'touches_corpse_or_other_remains',
          'target_protected_from_decay',
          'target_cannot_become_undead',
          'days_under_spell_do_not_count_against_raise_dead_time_limit',
          'duration_10_days',
        },
      ),
    ],
    classIds: {
      'cleric',
      'wizard',
    },
  ),
  SpellIds.heatMetal: SpellDefinition(
    id: SpellIds.heatMetal,
    content: RuleContent(
      id: SpellIds.heatMetal,
      name: 'Riscaldare il Metallo',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rende incandescente un oggetto metallico artificiale, danneggiando chi lo tocca.',
        details:
            'L’incantatore sceglie un oggetto artificiale di metallo entro '
            'gittata e che sia in grado di vedere, come un’arma di metallo o '
            'un’armatura di metallo media o pesante. L’oggetto diventa '
            'incandescente. Ogni creatura a contatto fisico con l’oggetto '
            'subisce 2d8 danni da fuoco quando l’incantesimo viene lanciato. '
            'Finché l’incantesimo non termina, l’incantatore può usare '
            'un’azione bonus in ogni turno successivo per infliggere di nuovo '
            'quei danni. Se una creatura indossa o impugna l’oggetto e subisce '
            'i danni, deve superare un tiro salvezza su Costituzione o lasciar '
            'cadere l’oggetto se può farlo. Se non lo lascia cadere, subisce '
            'svantaggio ai tiri per colpire e alle prove di caratteristica fino '
            'all’inizio del turno successivo dell’incantatore. Richiede '
            'concentrazione. Usando uno slot di livello superiore al 2°, i '
            'danni aumentano di 1d8 per ogni livello di slot superiore.',
      ),
      ownerId: SpellIds.heatMetal,
    ),
    level: 2,
    school: SpellSchool.transmutation,
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
      materials: [
        SpellMaterialComponent(
          description: 'Un pezzo di ferro e una fiamma.',
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
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    damage: [
      SpellDamage(
        dice: '2d8',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'heat_metal_glowing_object_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_manufactured_metal_object_within_18_meters',
          'object_becomes_red_hot',
          'creature_in_physical_contact_takes_2d8_fire_damage_on_cast',
          'caster_can_bonus_action_repeat_fire_damage_on_later_turns',
          'creature_wearing_or_holding_object_makes_constitution_save_after_damage',
          'failed_save_creature_drops_object_if_possible',
          'if_creature_does_not_drop_object_disadvantage_on_attack_rolls_and_ability_checks',
          'disadvantage_until_start_of_casters_next_turn',
          'damage_increases_by_1d8_per_slot_level_above_2',
          'requires_concentration',
          'uses_spellcasting_bonus_action_type_bonusAction',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
    },
  ),
  SpellIds.lesserRestoration: SpellDefinition(
    id: SpellIds.lesserRestoration,
    content: RuleContent(
      id: SpellIds.lesserRestoration,
      name: 'Ristorare Inferiore',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Termina una malattia o una condizione debilitante su una creatura toccata.',
        details: 'L’incantatore tocca una creatura e può porre termine a una '
            'malattia oppure a una condizione che la affligge. La condizione '
            'rimossa può essere accecato, assordato, avvelenato o paralizzato. '
            'L’incantesimo ha durata istantanea e richiede componenti verbali e '
            'somatiche.',
      ),
      ownerId: SpellIds.lesserRestoration,
    ),
    level: 2,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
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
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'lesser_restoration_end_disease_or_condition',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_creature',
          'can_end_one_disease',
          'can_end_blinded_condition',
          'can_end_deafened_condition',
          'can_end_poisoned_condition',
          'can_end_paralyzed_condition',
          'instantaneous_restoration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'druid',
      'paladin',
      'ranger',
    },
  ),
  SpellIds.knock: SpellDefinition(
    id: SpellIds.knock,
    content: RuleContent(
      id: SpellIds.knock,
      name: 'Scassinare',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Apre o sblocca un oggetto chiuso, bloccato o protetto magicamente.',
        details:
            'L’incantatore sceglie un oggetto entro gittata e che sia in grado '
            'di vedere. Può trattarsi di una porta, uno scrigno, un forziere, '
            'un paio di manette, un lucchetto o un altro oggetto dotato di un '
            'mezzo normale o magico per impedire l’accesso. Un bersaglio tenuto '
            'chiuso da una serratura magica, incastrato o sbarrato cessa di '
            'esserlo. Se l’oggetto è protetto da più serrature, soltanto una di '
            'esse viene sbloccata. Se il bersaglio è chiuso da Serratura '
            'Arcana, quell’incantesimo è soppresso per 10 minuti, durante i '
            'quali l’oggetto può essere aperto e chiuso normalmente. Quando '
            'l’incantesimo viene lanciato, l’oggetto emette un forte rumore '
            'simile al bussare, udibile fino a 90 metri di distanza.',
      ),
      ownerId: SpellIds.knock,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'knock_unlock_or_suppress_lock',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_object_within_18_meters',
          'can_open_door_chest_shackles_padlock_or_similar_access_barrier',
          'unlocks_one_magical_lock_jammed_barred_or_locked_restraint',
          'if_multiple_locks_only_one_is_unlocked',
          'suppresses_arcane_lock_for_10_minutes',
          'object_can_be_opened_and_closed_normally_while_arcane_lock_suppressed',
          'creates_loud_knocking_noise_audible_to_90_meters',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.findTraps: SpellDefinition(
    id: SpellIds.findTraps,
    content: RuleContent(
      id: SpellIds.findTraps,
      name: 'Scopri Trappole',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rivela la presenza di trappole entro gittata e linea di vista, ma non la loro posizione esatta.',
        details: 'L’incantatore percepisce la presenza di ogni trappola entro '
            'gittata e in linea di vista. Ai fini dell’incantesimo, una '
            'trappola è qualcosa che infliggerebbe un effetto improvviso o '
            'inaspettato considerato dannoso o indesiderabile dall’incantatore '
            'e specificamente inteso come tale dal suo creatore. Può quindi '
            'individuare un’area sotto l’effetto di Allarme, un glifo di '
            'interdizione o una fossa ad apertura meccanica, ma non rivela un '
            'cedimento naturale del pavimento, un soffitto instabile o un buco '
            'nascosto nel terreno. L’incantesimo rivela soltanto che una '
            'trappola è presente: non indica l’ubicazione di ogni trappola, ma '
            'solo la natura generale del pericolo percepito.',
      ),
      ownerId: SpellIds.findTraps,
    ),
    level: 2,
    school: SpellSchool.divination,
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
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'find_traps_presence_and_general_nature',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'detects_presence_of_traps_within_36_meters',
          'only_detects_traps_in_line_of_sight',
          'trap_must_be_intentionally_created_to_cause_harmful_or_unwanted_effect',
          'can_detect_alarm_spell_area',
          'can_detect_glyph_of_warding',
          'can_detect_mechanical_pit_trap',
          'does_not_detect_natural_floor_weakness_unstable_ceiling_or_hidden_hole',
          'does_not_reveal_exact_location_of_each_trap',
          'reveals_general_nature_of_perceived_danger',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
      'ranger',
    },
  ),
  SpellIds.darkvision: SpellDefinition(
    id: SpellIds.darkvision,
    content: RuleContent(
      id: SpellIds.darkvision,
      name: 'Scurovisione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Conferisce a una creatura consenziente la capacità di vedere al buio.',
        details:
            'L’incantatore tocca una creatura consenziente per conferirle la '
            'capacità di vedere nell’oscurità. Per la durata dell’incantesimo, '
            'quella creatura è dotata di scurovisione fino a 18 metri. '
            'L’effetto dura 8 ore e non richiede concentrazione.',
      ),
      ownerId: SpellIds.darkvision,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Un pizzico di carota essiccata o un’agata.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'darkvision_grants_18_meter_darkvision',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_willing_creature',
          'target_gains_darkvision_18_meters',
          'duration_8_hours',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'ranger',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.arcaneLock: SpellDefinition(
    id: SpellIds.arcaneLock,
    content: RuleContent(
      id: SpellIds.arcaneLock,
      name: 'Serratura Arcana',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Chiude magicamente un punto di accesso e lo rende più difficile da forzare.',
        details: 'L’incantatore tocca una porta, una finestra, un portale, un '
            'forziere o un altro punto di accesso chiuso, che diventa chiuso a '
            'chiave. L’incantatore e le creature designate al momento del '
            'lancio possono aprire l’oggetto normalmente. L’incantatore può '
            'anche stabilire una parola d’ordine che, pronunciata entro 1,5 '
            'metri dall’oggetto, sopprime l’incantesimo per 1 minuto. Altrimenti '
            'l’oggetto è impenetrabile finché non viene rotto, o finché '
            'l’incantesimo non viene dissolto o soppresso. Lanciare Scassinare '
            'sull’oggetto sopprime Serratura Arcana per 10 minuti. Finché è '
            'influenzato da questo incantesimo, l’oggetto è più difficile da '
            'rompere o aprire a forza: la CD per romperlo o scassinarlo aumenta '
            'di 10. La polvere d’oro richiesta viene consumata.',
      ),
      ownerId: SpellIds.arcaneLock,
    ),
    level: 2,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Polvere d’oro del valore di almeno 25 mo, consumata dall’incantesimo.',
          minimumCostGp: 25,
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.untilDispelled,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'arcane_lock_magically_locked_access',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touches_closed_door_window_gate_chest_or_other_entryway',
          'target_becomes_magically_locked',
          'caster_and_designated_creatures_can_open_normally',
          'password_spoken_within_1_5_meters_suppresses_spell_for_1_minute',
          'otherwise_target_is_impassable_until_broken_dispelled_or_suppressed',
          'knock_suppresses_arcane_lock_for_10_minutes',
          'dc_to_break_or_force_open_increases_by_10',
          'gold_dust_worth_25_gp_is_consumed',
          'duration_until_dispelled',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.flamingSphere: SpellDefinition(
    id: SpellIds.flamingSphere,
    content: RuleContent(
      id: SpellIds.flamingSphere,
      name: 'Sfera Infuocata',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una sfera di fuoco mobile che brucia le creature vicine o urtate.',
        details:
            'Una sfera di fuoco del diametro di 1,5 metri appare in uno spazio '
            'libero scelto dall’incantatore entro gittata e permane per la '
            'durata. Ogni creatura che termina il proprio turno entro 1,5 metri '
            'dalla sfera deve effettuare un tiro salvezza su Destrezza: se lo '
            'fallisce subisce 2d6 danni da fuoco, mentre se lo supera subisce '
            'metà danni. Con un’azione bonus, l’incantatore può muovere la '
            'sfera fino a 9 metri. Se la sfera urta una creatura, quella '
            'creatura effettua il tiro salvezza contro i danni della sfera e la '
            'sfera non può muoversi oltre in quel turno. Quando viene mossa, la '
            'sfera può superare barriere alte fino a 1,5 metri e saltare fosse '
            'larghe fino a 3 metri. Incendia gli oggetti infiammabili non '
            'indossati né trasportati, proietta luce intensa entro 6 metri e '
            'luce fioca per altri 6 metri. Richiede concentrazione. Usando uno '
            'slot di livello superiore al 2°, i danni aumentano di 1d6 per ogni '
            'livello di slot superiore.',
      ),
      ownerId: SpellIds.flamingSphere,
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
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un frammento di sego, un pizzico di zolfo e una manciata di polvere di ferro.',
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
        SpellTargetType.point,
      },
    ),
    damage: [
      SpellDamage(
        dice: '2d6',
        type: SpellDamageType.fire,
      ),
    ],
    persistentEffects: [
      SpellPersistentEffect(
        id: 'flaming_sphere_mobile_fire_hazard',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_1_5_meter_diameter_fire_sphere_in_unoccupied_space',
          'creature_ending_turn_within_1_5_meters_makes_dexterity_save',
          'failed_save_deals_2d6_fire_damage',
          'successful_save_takes_half_damage',
          'caster_can_bonus_action_move_sphere_up_to_9_meters',
          'creature_ram_by_sphere_makes_save_against_sphere_damage',
          'sphere_stops_moving_after_hitting_creature_this_turn',
          'sphere_can_cross_barriers_up_to_1_5_meters_high',
          'sphere_can_jump_pits_up_to_3_meters_wide',
          'ignites_flammable_objects_not_worn_or_carried',
          'sheds_bright_light_6_meters_and_dim_light_6_more_meters',
          'damage_increases_by_1d6_per_slot_level_above_2',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'druid',
      'wizard',
    },
  ),
  SpellIds.blur: SpellDefinition(
    id: SpellIds.blur,
    content: RuleContent(
      id: SpellIds.blur,
      name: 'Sfocatura',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rende l’incantatore sfocato, imponendo svantaggio agli attacchi contro di lui.',
        details:
            'Il corpo dell’incantatore diventa sfocato, instabile e ondeggiante '
            'agli occhi di chi è in grado di vederlo. Per la durata '
            'dell’incantesimo, le creature subiscono svantaggio ai tiri per '
            'colpire contro l’incantatore. Un attaccante è immune a questo '
            'effetto se non si affida alla vista, per esempio se è dotato di '
            'vista cieca, oppure se è in grado di vedere attraverso le illusioni '
            'come tramite vista pura. Richiede concentrazione e può durare fino '
            'a 1 minuto.',
      ),
      ownerId: SpellIds.blur,
    ),
    level: 2,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'blur_disadvantage_on_attacks',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_body_becomes_blurred_shifting_and_wavering',
          'creatures_have_disadvantage_on_attack_rolls_against_caster',
          'attacker_immune_if_not_relying_on_sight',
          'blindsight_or_similar_nonvisual_sense_ignores_effect',
          'truesight_or_seeing_through_illusions_ignores_effect',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.silence: SpellDefinition(
    id: SpellIds.silence,
    content: RuleContent(
      id: SpellIds.silence,
      name: 'Silenzio',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una sfera in cui nessun suono può essere creato o attraversare l’area.',
        details:
            'L’incantatore genera una sfera del raggio di 6 metri centrata su '
            'un punto a sua scelta entro gittata. Per la durata, nessun suono '
            'può essere creato all’interno della sfera o attraversarla. Ogni '
            'creatura o oggetto interamente all’interno della sfera è immune ai '
            'danni da tuono, e ogni creatura interamente all’interno della sfera '
            'è assordata. Nell’area è impossibile lanciare incantesimi che '
            'includano una componente verbale. Richiede concentrazione, può '
            'durare fino a 10 minuti e può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.silence,
    ),
    level: 2,
    ritual: true,
    school: SpellSchool.illusion,
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
      type: SpellDurationType.minute,
      amount: 10,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'silence_no_sound_sphere',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'creates_6_meter_radius_sphere_centered_on_point_within_36_meters',
          'no_sound_can_be_created_inside_area',
          'no_sound_can_pass_through_area',
          'creatures_and_objects_entirely_inside_are_immune_to_thunder_damage',
          'creatures_entirely_inside_are_deafened',
          'verbal_component_spells_cannot_be_cast_inside_area',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'ranger',
    },
  ),
  SpellIds.suggestion: SpellDefinition(
    id: SpellIds.suggestion,
    content: RuleContent(
      id: SpellIds.suggestion,
      name: 'Suggestione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Influenza una creatura con un corso d’azione ragionevole formulato in una o due frasi.',
        details: 'L’incantatore suggerisce un corso d’azione da intraprendere, '
            'limitandosi a una o due frasi, e influenza magicamente una '
            'creatura entro gittata e che sia in grado di vedere. La creatura '
            'deve essere in grado di sentire e capire l’incantatore; le creature '
            'che non possono essere affascinate sono immuni. La suggestione deve '
            'essere formulata in modo che il corso d’azione appaia ragionevole. '
            'Richieste palesemente autolesionistiche pongono termine '
            'all’incantesimo. Il bersaglio effettua un tiro salvezza su '
            'Saggezza; se lo fallisce, deve perseguire il corso d’azione al '
            'meglio delle sue capacità. Il corso d’azione può proseguire per '
            'l’intera durata, ma l’incantesimo termina quando il bersaglio '
            'completa un’attività più breve. L’incantatore può anche specificare '
            'condizioni che innescano un’attività speciale durante la durata. Se '
            'l’incantatore o uno dei suoi compagni infligge danni al bersaglio, '
            'l’incantesimo termina. Richiede concentrazione e può durare fino a '
            '8 ore.',
      ),
      ownerId: SpellIds.suggestion,
    ),
    level: 2,
    school: SpellSchool.enchantment,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Una lingua di serpente e un frammento di un alveare o una goccia di olio dolce.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'suggestion_reasonable_course_of_action',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'targets_visible_creature_within_9_meters',
          'target_must_hear_and_understand_caster',
          'creatures_that_cannot_be_charmed_are_immune',
          'suggestion_must_sound_reasonable',
          'obviously_self_harmful_suggestion_ends_spell',
          'target_makes_wisdom_saving_throw',
          'failed_save_target_pursues_suggested_course_of_action',
          'activity_can_continue_for_full_duration',
          'spell_ends_when_shorter_suggested_activity_is_completed',
          'caster_can_define_trigger_condition_for_special_activity',
          'spell_ends_if_caster_or_allies_damage_target',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.findSteed: SpellDefinition(
    id: SpellIds.findSteed,
    content: RuleContent(
      id: SpellIds.findSteed,
      name: 'Trova Cavalcatura',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Evoca uno spirito cavalcatura forte, intelligente e fedele legato all’incantatore.',
        details: 'L’incantatore evoca uno spirito che assume la forma di una '
            'cavalcatura insolitamente forte, intelligente e fedele, creando un '
            'legame duraturo. La cavalcatura appare in uno spazio libero entro '
            'gittata e assume una forma scelta tra cavallo da guerra, pony, '
            'cammello, alce o mastino, salvo altre forme permesse dal DM. Usa le '
            'statistiche della forma scelta, ma il suo tipo è celestiale, '
            'folletto o immondo a scelta dell’incantatore. Se la sua '
            'Intelligenza è 5 o inferiore, diventa 6 e capisce un linguaggio '
            'scelto dall’incantatore. La cavalcatura serve l’incantatore in '
            'combattimento e fuori, e quando l’incantatore è in sella può fare '
            'in modo che un incantesimo che bersaglia solo sé stesso bersagli '
            'anche la cavalcatura. Se la cavalcatura scende a 0 punti ferita o '
            'viene congedata con un’azione, scompare senza lasciare corpo; un '
            'nuovo lancio richiama la stessa cavalcatura al massimo dei punti '
            'ferita. Entro 1,5 km, l’incantatore comunica con lei '
            'telepaticamente. Non può essere legato a più di una cavalcatura per '
            'volta.',
      ),
      ownerId: SpellIds.findSteed,
    ),
    level: 2,
    school: SpellSchool.conjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 10,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
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
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'find_steed_loyal_spirit_mount',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'summons_spirit_mount_in_unoccupied_space_within_9_meters',
          'mount_form_warhorse_pony_camel_elk_or_mastiff',
          'dm_can_allow_other_mount_forms',
          'mount_type_is_celestial_fey_or_fiend',
          'mount_intelligence_becomes_6_if_lower',
          'mount_understands_one_language_chosen_by_caster',
          'mount_serves_caster_in_combat_and_outside_combat',
          'while_mounted_self_only_spells_can_also_target_mount',
          'mount_disappears_at_0_hit_points_or_when_dismissed',
          'recasting_summons_same_mount_at_full_hit_points',
          'telepathic_communication_within_1_5_km',
          'caster_can_have_only_one_bound_mount',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.ropeTrick: SpellDefinition(
    id: SpellIds.ropeTrick,
    content: RuleContent(
      id: SpellIds.ropeTrick,
      name: 'Trucco della Corda',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Trasforma una corda in accesso a uno spazio extradimensionale nascosto.',
        details:
            'L’incantatore tocca un pezzo di corda lungo al massimo 18 metri. '
            'Un’estremità della corda sale in aria finché la corda pende '
            'perpendicolarmente al terreno. All’estremità superiore si apre '
            'un’entrata invisibile verso uno spazio extradimensionale che '
            'permane fino al termine dell’incantesimo. Lo spazio può essere '
            'raggiunto arrampicandosi fino in cima alla corda e può contenere '
            'fino a otto creature di taglia Media o inferiore. La corda può '
            'essere ritratta all’interno dello spazio, sparendo alla vista di '
            'chi è all’esterno. Attacchi e incantesimi non possono attraversare '
            'lo spazio extradimensionale in entrata o in uscita, ma chi si '
            'trova all’interno può vedere all’esterno come da una finestra '
            'centrata sulla corda. Quando l’incantesimo termina, tutto ciò che '
            'si trova nello spazio cade all’esterno.',
      ),
      ownerId: SpellIds.ropeTrick,
    ),
    level: 2,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Estratto di mais in polvere e un pezzo di pergamena annodato.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'rope_trick_extradimensional_space',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'touches_rope_up_to_18_meters_long',
          'one_rope_end_rises_and_hangs_perpendicular_to_ground',
          'invisible_entrance_opens_at_top_of_rope',
          'creates_extradimensional_space_until_spell_ends',
          'space_holds_up_to_eight_medium_or_smaller_creatures',
          'rope_can_be_pulled_inside_and_hidden_from_outside',
          'attacks_and_spells_cannot_cross_space_boundary',
          'creatures_inside_can_see_outside_through_window_centered_on_rope',
          'contents_fall_out_when_spell_ends',
        },
      ),
    ],
    classIds: {
      'wizard',
    },
  ),
  SpellIds.seeInvisibility: SpellDefinition(
    id: SpellIds.seeInvisibility,
    content: RuleContent(
      id: SpellIds.seeInvisibility,
      name: 'Vedere Invisibilità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette all’incantatore di vedere creature e oggetti invisibili e il Piano Etereo.',
        details:
            'Per la durata dell’incantesimo, l’incantatore vede le creature e '
            'gli oggetti invisibili come se fossero visibili. Può inoltre vedere '
            'sul Piano Etereo; le creature e gli oggetti eterei gli appaiono '
            'spettrali e trasparenti. L’effetto dura 1 ora e non richiede '
            'concentrazione.',
      ),
      ownerId: SpellIds.seeInvisibility,
    ),
    level: 2,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un pizzico di talco e una manciata di polvere d’argento.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'see_invisibility_invisible_and_ethereal_sight',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'caster_sees_invisible_creatures_and_objects_as_visible',
          'caster_can_see_into_ethereal_plane',
          'ethereal_creatures_and_objects_appear_ghostly_and_transparent',
          'duration_1_hour',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.wardingBond: SpellDefinition(
    id: SpellIds.wardingBond,
    content: RuleContent(
      id: SpellIds.wardingBond,
      name: 'Vincolo di Interdizione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Protegge una creatura consenziente legandola misticamente all’incantatore.',
        details:
            'L’incantatore tocca una creatura consenziente e crea tra sé e il '
            'bersaglio un legame mistico che permane per la durata '
            'dell’incantesimo. Finché il bersaglio si trova entro 18 metri '
            'dall’incantatore, ottiene un bonus di +1 alla Classe Armatura e ai '
            'tiri salvezza, e resistenza a tutti i danni. Ogni volta che il '
            'bersaglio subisce danni, l’incantatore subisce lo stesso ammontare '
            'di danni. L’incantesimo termina se l’incantatore scende a 0 punti '
            'ferita, se le due creature si separano a più di 18 metri, se '
            'l’incantesimo viene lanciato di nuovo su una delle due creature '
            'collegate, oppure se l’incantatore lo interrompe con un’azione.',
      ),
      ownerId: SpellIds.wardingBond,
    ),
    level: 2,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un paio di anelli di platino del valore di almeno 50 mo, indossati dall’incantatore e dal bersaglio per la durata.',
          minimumCostGp: 50,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'warding_bond_shared_protection',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_willing_creature',
          'mystic_bond_between_caster_and_target',
          'target_must_remain_within_18_meters_of_caster',
          'target_gains_plus_1_armor_class',
          'target_gains_plus_1_saving_throws',
          'target_has_resistance_to_all_damage',
          'caster_takes_same_amount_of_damage_when_target_takes_damage',
          'spell_ends_if_caster_drops_to_0_hit_points',
          'spell_ends_if_caster_and_target_more_than_18_meters_apart',
          'spell_ends_if_cast_again_on_either_linked_creature',
          'caster_can_dismiss_with_action',
        },
      ),
    ],
    classIds: {
      'cleric',
    },
  ),
  SpellIds.zoneOfTruth: SpellDefinition(
    id: SpellIds.zoneOfTruth,
    content: RuleContent(
      id: SpellIds.zoneOfTruth,
      name: 'Zona di Verità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una sfera magica in cui le creature non possono mentire deliberatamente se falliscono il tiro salvezza.',
        details:
            'L’incantatore crea una zona magica protetta dagli inganni entro '
            'una sfera del raggio di 4,5 metri centrata su un punto entro '
            'gittata. Finché l’incantesimo non termina, una creatura che entra '
            'nell’area per la prima volta in un turno o vi inizia il proprio '
            'turno deve effettuare un tiro salvezza su Carisma. Se lo fallisce, '
            'non può mentire deliberatamente finché rimane nell’area. '
            'L’incantatore sa se ogni creatura ha superato o fallito il tiro '
            'salvezza. Una creatura influenzata è consapevole dell’incantesimo '
            'e può evitare di rispondere o dare risposte sfuggenti, purché '
            'rimanga entro i confini della verità.',
      ),
      ownerId: SpellIds.zoneOfTruth,
    ),
    level: 2,
    school: SpellSchool.enchantment,
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
      type: SpellDurationType.minute,
      amount: 10,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'zone_of_truth_charisma_save_no_lies',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_4_5_meter_radius_sphere_centered_on_point_within_18_meters',
          'creature_entering_area_first_time_on_turn_makes_charisma_save',
          'creature_starting_turn_in_area_makes_charisma_save',
          'failed_save_creature_cannot_deliberately_lie_while_in_area',
          'caster_knows_whether_each_creature_succeeded_or_failed_save',
          'affected_creature_is_aware_of_spell',
          'affected_creature_can_avoid_answering',
          'affected_creature_can_give_evasive_answers_within_truth',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'paladin',
    },
  ),
  SpellIds.animateDead: SpellDefinition(
    id: SpellIds.animateDead,
    content: RuleContent(
      id: SpellIds.animateDead,
      name: 'Animare Morti',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea o mantiene il controllo su servitori non morti ricavati da ossa o cadaveri.',
        details:
            'L’incantatore sceglie un cadavere di umanoide Medio o Piccolo, '
            'oppure un cumulo di ossa, entro gittata. La magia infonde al '
            'bersaglio un’empia parvenza di vita: un cumulo di ossa diventa '
            'uno scheletro, mentre un cadavere diventa uno zombi. A ogni suo '
            'turno, l’incantatore può usare un’azione bonus per comandare '
            'mentalmente qualsiasi creatura creata con questo incantesimo e '
            'situata entro 18 metri. Se controlla più creature, può comandarle '
            'insieme impartendo lo stesso ordine. La creatura resta sotto il '
            'controllo dell’incantatore per 24 ore; prima che il periodo '
            'termini, rilanciare l’incantesimo su di essa ristabilisce il '
            'controllo per altre 24 ore, fino a quattro creature già animate. '
            'Usando uno slot di 4° livello o superiore, l’incantatore anima o '
            'ristabilisce il controllo su due non morti aggiuntivi per ogni '
            'livello di slot superiore al 3°.',
      ),
      ownerId: SpellIds.animateDead,
    ),
    level: 3,
    school: SpellSchool.necromancy,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
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
              'Una goccia di sangue, un brandello di carne e un pizzico di polvere d’osso.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'animate_dead_skeleton_or_zombie_servant',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'targets_medium_or_small_humanoid_corpse_or_pile_of_bones_within_3_meters',
          'pile_of_bones_becomes_skeleton',
          'corpse_becomes_zombie',
          'caster_can_bonus_action_command_created_undead_within_18_meters',
          'same_command_can_be_given_to_multiple_controlled_undead',
          'undead_obeys_for_24_hours',
          'recasting_before_24_hours_maintains_control',
          'maintenance_reasserts_control_over_up_to_four_existing_undead',
          'slot_level_above_3_animates_or_controls_two_additional_undead',
        },
      ),
    ],
    classIds: {
      'cleric',
      'wizard',
    },
  ),
  SpellIds.nondetection: SpellDefinition(
    id: SpellIds.nondetection,
    content: RuleContent(
      id: SpellIds.nondetection,
      name: 'Anti-Individuazione',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Nasconde un bersaglio dalle magie di divinazione e dai sensori di scrutamento.',
        details: 'Per la durata dell’incantesimo, l’incantatore nasconde un '
            'bersaglio toccato dalle magie di divinazione. Il bersaglio può '
            'essere una creatura consenziente, un luogo o un oggetto non più '
            'grande di 3 metri in ogni dimensione. Il bersaglio non può essere '
            'bersagliato da magie di divinazione né percepito dai sensori di '
            'scrutamento magico. La polvere di diamante richiesta viene '
            'consumata e l’effetto dura 8 ore senza concentrazione.',
      ),
      ownerId: SpellIds.nondetection,
    ),
    level: 3,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un pizzico di polvere di diamante del valore di 25 mo da spruzzare sul bersaglio, consumata dall’incantesimo.',
          minimumCostGp: 25,
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
        SpellTargetType.object,
        SpellTargetType.area,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'nondetection_hidden_from_divination',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_target_hidden_from_divination_magic',
          'target_can_be_willing_creature_place_or_object',
          'place_or_object_maximum_3_meters_in_each_dimension',
          'target_cannot_be_targeted_by_divination_magic',
          'target_cannot_be_perceived_by_magical_scrying_sensors',
          'diamond_dust_worth_25_gp_is_consumed',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'ranger',
      'wizard',
    },
  ),
  SpellIds.elementalWeapon: SpellDefinition(
    id: SpellIds.elementalWeapon,
    content: RuleContent(
      id: SpellIds.elementalWeapon,
      name: 'Arma Elementale',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Rende magica un’arma non magica, aggiungendo bonus al colpire e danni elementali.',
        details: 'L’incantatore tocca un’arma non magica, che diventa un’arma '
            'magica per la durata dell’incantesimo. Sceglie un tipo di danno '
            'fra acido, freddo, fulmine, fuoco o tuono. L’arma ottiene un bonus '
            'di +1 ai tiri per colpire e infligge 1d4 danni extra del tipo '
            'scelto quando colpisce. Richiede concentrazione e può durare fino '
            'a 1 ora. Usando uno slot di 5° o 6° livello, il bonus diventa +2 e '
            'i danni extra 2d4. Usando uno slot di 7° livello o superiore, il '
            'bonus diventa +3 e i danni extra 3d4.',
      ),
      ownerId: SpellIds.elementalWeapon,
    ),
    level: 3,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.touch,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.object,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'elemental_weapon_bonus_and_extra_damage',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'touched_nonmagical_weapon_becomes_magical',
          'caster_chooses_acid_cold_lightning_fire_or_thunder',
          'weapon_gains_plus_1_attack_bonus',
          'weapon_deals_extra_1d4_chosen_damage_type_on_hit',
          'slot_5_or_6_bonus_plus_2_and_extra_damage_2d4',
          'slot_7_or_higher_bonus_plus_3_and_extra_damage_3d4',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.auraOfVitality: SpellDefinition(
    id: SpellIds.auraOfVitality,
    content: RuleContent(
      id: SpellIds.auraOfVitality,
      name: 'Aura di Vitalità',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Emana un’aura curativa che permette di guarire creature con azioni bonus.',
        details:
            'L’incantatore emana un’aura di energia curativa entro 9 metri. '
            'Finché l’incantesimo non termina, l’aura si muove assieme a lui ed '
            'è centrata su di lui. L’incantatore può usare un’azione bonus per '
            'far sì che una creatura entro l’aura, incluso l’incantatore, '
            'recuperi 2d6 punti ferita. Richiede concentrazione e può durare '
            'fino a 1 minuto.',
      ),
      ownerId: SpellIds.auraOfVitality,
    ),
    level: 3,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.action,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.minute,
      amount: 1,
      concentration: true,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'aura_of_vitality_bonus_action_healing',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_9_meter_radius_healing_aura_centered_on_caster',
          'aura_moves_with_caster',
          'caster_can_bonus_action_heal_one_creature_in_aura',
          'healing_can_target_caster',
          'target_recovers_2d6_hit_points',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'paladin',
    },
  ),
  SpellIds.waterWalk: SpellDefinition(
    id: SpellIds.waterWalk,
    content: RuleContent(
      id: SpellIds.waterWalk,
      name: 'Camminare sull\'Acqua',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Permette fino a dieci creature consenzienti di muoversi sulle superfici liquide come terreno solido.',
        details:
            'Questo incantesimo conferisce la capacità di muoversi su qualsiasi '
            'superficie liquida, come acqua, acido, fango, neve, sabbie mobili '
            'o lava, come se fosse un innocuo terreno solido. Le creature che '
            'attraversano lava fusa possono comunque subire danni dal calore. '
            'Fino a dieci creature consenzienti entro gittata e visibili '
            'dall’incantatore ottengono questa capacità per 1 ora. Se '
            'l’incantatore bersaglia una creatura immersa in un liquido, '
            'l’incantesimo la porta alla superficie a una velocità di 18 metri '
            'per round. Può essere lanciato come rituale e non richiede '
            'concentrazione.',
      ),
      ownerId: SpellIds.waterWalk,
    ),
    level: 3,
    ritual: true,
    school: SpellSchool.transmutation,
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
          description: 'Un pezzo di sughero.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.willingCreature,
        SpellTargetType.creatures,
      },
      maximumTargets: 10,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'water_walk_liquid_surfaces',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'ritual_spell',
          'up_to_ten_willing_visible_creatures_within_9_meters',
          'targets_can_move_across_liquid_surfaces_as_solid_ground',
          'valid_surfaces_include_water_acid_mud_snow_quicksand_and_lava',
          'lava_heat_can_still_damage_creatures',
          'submerged_target_rises_to_surface_18_meters_per_round',
          'duration_1_hour',
          'does_not_require_concentration',
        },
      ),
    ],
    classIds: {
      'cleric',
      'druid',
      'ranger',
      'sorcerer',
    },
  ),
  SpellIds.leomundsTinyHut: SpellDefinition(
    id: SpellIds.leomundsTinyHut,
    content: RuleContent(
      id: SpellIds.leomundsTinyHut,
      name: 'Capanna di Leomund',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una cupola di forza immobile che protegge l’incantatore e fino a nove creature.',
        details:
            'Una cupola di forza immobile del raggio di 3 metri si materializza '
            'attorno all’incantatore e sopra di lui, rimanendo stazionaria per '
            '8 ore. L’incantesimo termina se l’incantatore esce dalla sua area. '
            'Nove creature di taglia Media o inferiore possono stare dentro la '
            'cupola assieme all’incantatore; l’incantesimo fallisce se l’area '
            'include una creatura più grande o più di nove creature. Le creature '
            'e gli oggetti presenti all’interno al momento del lancio possono '
            'attraversare la cupola liberamente, mentre tutte le altre creature '
            'e oggetti non possono attraversarla. Incantesimi e altri effetti '
            'magici non possono estendersi attraverso la cupola o essere lanciati '
            'attraverso di essa. L’atmosfera interna è gradevole e asciutta. '
            'L’incantatore può scegliere luce fioca o oscurità all’interno; la '
            'cupola è opaca dall’esterno e trasparente dall’interno. Può essere '
            'lanciato come rituale.',
      ),
      ownerId: SpellIds.leomundsTinyHut,
    ),
    level: 3,
    ritual: true,
    school: SpellSchool.evocation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.self,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description: 'Una biglia di cristallo.',
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 8,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.self,
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'leomunds_tiny_hut_force_dome',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'ritual_spell',
          'creates_immobile_3_meter_radius_force_dome_around_and_above_caster',
          'spell_ends_if_caster_leaves_area',
          'holds_caster_plus_up_to_nine_medium_or_smaller_creatures',
          'spell_fails_if_area_contains_larger_creature_or_more_than_nine_creatures',
          'creatures_and_objects_inside_on_cast_can_pass_freely',
          'other_creatures_and_objects_cannot_pass_through_dome',
          'spells_and_magical_effects_cannot_extend_or_be_cast_through_dome',
          'interior_atmosphere_is_comfortable_and_dry',
          'caster_chooses_dim_light_or_darkness_inside',
          'dome_opaque_from_outside_and_transparent_from_inside',
          'duration_8_hours',
        },
      ),
    ],
    classIds: {
      'bard',
      'wizard',
    },
  ),
  SpellIds.magicCircle: SpellDefinition(
    id: SpellIds.magicCircle,
    content: RuleContent(
      id: SpellIds.magicCircle,
      name: 'Cerchio Magico',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un cilindro magico che protegge contro creature di tipi scelti o le imprigiona.',
        details:
            'L’incantatore crea un cilindro di energia magica del raggio di 3 '
            'metri e alto 6 metri, centrato su un punto del terreno entro '
            'gittata che egli sia in grado di vedere. Sceglie uno o più tipi di '
            'creature: celestiali, elementali, folletti, immondi o non morti. '
            'Le creature dei tipi scelti non possono entrare volontariamente nel '
            'cilindro con mezzi non magici; se tentano di farlo con teletrasporto '
            'o viaggio interplanare, devono prima superare un tiro salvezza su '
            'Carisma. Subiscono svantaggio ai tiri per colpire contro bersagli '
            'all’interno del cilindro, e i bersagli all’interno non possono '
            'essere affascinati, spaventati o posseduti da quelle creature. Al '
            'momento del lancio l’incantatore può invertire la magia, impedendo '
            'alle creature specificate di uscire dal cilindro e proteggendo i '
            'bersagli all’esterno. Usando uno slot di 4° livello o superiore, la '
            'durata aumenta di 1 ora per ogni livello di slot superiore al 3°.',
      ),
      ownerId: SpellIds.magicCircle,
    ),
    level: 3,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
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
              'Acqua santa o polvere d’argento e di ferro del valore di almeno 100 mo, consumata dall’incantesimo.',
          minimumCostGp: 100,
          consumed: true,
        ),
      ],
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.area,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'magic_circle_protective_or_inverted_cylinder',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_3_meter_radius_6_meter_high_cylinder_on_ground_point_within_3_meters',
          'chosen_types_celestial_elemental_fey_fiend_or_undead',
          'chosen_creatures_cannot_enter_cylinder_by_nonmagical_means',
          'teleport_or_interplanar_entry_requires_charisma_save',
          'chosen_creatures_have_disadvantage_on_attacks_against_targets_inside',
          'targets_inside_cannot_be_charmed_frightened_or_possessed_by_chosen_creatures',
          'caster_can_reverse_effect_to_trap_chosen_creatures_inside',
          'inverted_circle_protects_targets_outside',
          'material_component_worth_100_gp_is_consumed',
          'slot_level_above_3_increases_duration_by_1_hour_per_slot_level',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.clairvoyance: SpellDefinition(
    id: SpellIds.clairvoyance,
    content: RuleContent(
      id: SpellIds.clairvoyance,
      name: 'Chiaroveggenza',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea un sensore invisibile remoto che permette di vedere o udire da un luogo entro 1,5 km.',
        details:
            'L’incantatore crea un sensore invisibile entro gittata in un luogo '
            'familiare, cioè visitato o visto in precedenza, oppure in un luogo '
            'ovvio non familiare, come dietro una porta, oltre un angolo o in '
            'mezzo a un boschetto. Il sensore rimane al suo posto per la durata '
            'dell’incantesimo e non può essere attaccato o manipolato. Quando '
            'lancia l’incantesimo, l’incantatore sceglie vista o udito e può '
            'usare quel senso tramite il sensore come se si trovasse nel suo '
            'spazio. Usando la propria azione, può passare da vista a udito o '
            'viceversa. Una creatura in grado di vedere il sensore, per esempio '
            'grazie a Vedere Invisibilità o vista pura, lo percepisce come un '
            'globo luminoso e intangibile grande circa quanto il pugno '
            'dell’incantatore. Richiede concentrazione.',
      ),
      ownerId: SpellIds.clairvoyance,
    ),
    level: 3,
    school: SpellSchool.divination,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 10,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 1500,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
      materials: [
        SpellMaterialComponent(
          description:
              'Un focus del valore di almeno 100 mo: un cornetto acustico ingioiellato per l’udito o un occhio di vetro per la vista.',
          minimumCostGp: 100,
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
        SpellTargetType.point,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'clairvoyance_invisible_remote_sensor',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'creates_invisible_sensor_within_1_5_km',
          'sensor_can_be_placed_in_familiar_location',
          'sensor_can_be_placed_in_obvious_unfamiliar_location',
          'sensor_cannot_be_attacked_or_interacted_with',
          'caster_chooses_sight_or_hearing_on_cast',
          'caster_uses_chosen_sense_through_sensor_as_if_in_its_space',
          'caster_can_action_switch_between_sight_and_hearing',
          'creature_seeing_sensor_perceives_luminous_intangible_orb',
          'requires_concentration',
        },
      ),
    ],
    classIds: {
      'bard',
      'cleric',
      'sorcerer',
      'wizard',
    },
  ),
  SpellIds.counterspell: SpellDefinition(
    id: SpellIds.counterspell,
    content: RuleContent(
      id: SpellIds.counterspell,
      name: 'Controincantesimo',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary: 'Interrompe una creatura mentre sta lanciando un incantesimo.',
        details:
            'L’incantatore tenta di interrompere una creatura nell’atto di '
            'lanciare un incantesimo, usando una reazione quando vede una '
            'creatura entro 18 metri che lancia un incantesimo. Se la creatura '
            'sta lanciando un incantesimo di 3° livello o inferiore, '
            'quell’incantesimo fallisce e non ha effetto. Se sta lanciando un '
            'incantesimo di 4° livello o superiore, l’incantatore effettua una '
            'prova di caratteristica usando la propria caratteristica da '
            'incantatore; la CD è pari a 10 + il livello dell’incantesimo della '
            'creatura. In caso di successo, l’incantesimo della creatura '
            'fallisce e non ha effetto. Usando uno slot di 4° livello o '
            'superiore, l’incantesimo interrotto non ha effetto se il suo '
            'livello è pari o inferiore al livello dello slot usato.',
      ),
      ownerId: SpellIds.counterspell,
    ),
    level: 3,
    school: SpellSchool.abjuration,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.reaction,
      reactionTrigger:
          'Quando l’incantatore vede una creatura entro 18 metri che lancia un incantesimo.',
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 18,
    ),
    components: SpellComponents(
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.creature,
      },
      maximumTargets: 1,
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'counterspell_interrupt_spellcasting',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'reaction_spell',
          'trigger_seen_creature_within_18_meters_casts_spell',
          'interrupts_creature_while_casting_spell',
          'spell_level_3_or_lower_fails_automatically',
          'spell_level_4_or_higher_requires_spellcasting_ability_check',
          'counterspell_check_dc_10_plus_target_spell_level',
          'successful_check_target_spell_fails_and_has_no_effect',
          'slot_level_above_3_automatically_counters_spell_of_slot_level_or_lower',
        },
      ),
    ],
    classIds: {
      'sorcerer',
      'warlock',
      'wizard',
    },
  ),
  SpellIds.createFoodAndWater: SpellDefinition(
    id: SpellIds.createFoodAndWater,
    content: RuleContent(
      id: SpellIds.createFoodAndWater,
      name: 'Creare Cibo e Acqua',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea cibo e acqua sufficienti a nutrire fino a quindici umanoidi o cinque cavalcature.',
        details: 'L’incantatore crea 22,5 kg di cibo e 120 litri di acqua sul '
            'terreno o in contenitori entro gittata. Le provviste sono '
            'sufficienti a offrire sostentamento a un massimo di quindici '
            'umanoidi o cinque cavalcature per 24 ore. Il cibo è poco saporito '
            'ma nutriente e si guasta se non viene mangiato entro 24 ore. '
            'L’acqua è pulita e non va a male. L’incantesimo ha durata '
            'istantanea.',
      ),
      ownerId: SpellIds.createFoodAndWater,
    ),
    level: 3,
    school: SpellSchool.conjuration,
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
    ),
    duration: SpellDuration(
      type: SpellDurationType.instantaneous,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.point,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'create_food_and_water_supplies',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'creates_22_5_kg_food',
          'creates_120_liters_water',
          'created_on_ground_or_in_containers_within_9_meters',
          'sustains_up_to_fifteen_humanoids_for_24_hours',
          'sustains_up_to_five_mounts_for_24_hours',
          'food_is_bland_but_nourishing',
          'food_spoils_if_not_eaten_within_24_hours',
          'water_is_clean_and_does_not_spoil',
          'instantaneous_conjuration',
        },
      ),
    ],
    classIds: {
      'cleric',
      'paladin',
    },
  ),
  SpellIds.plantGrowth: SpellDefinition(
    id: SpellIds.plantGrowth,
    content: RuleContent(
      id: SpellIds.plantGrowth,
      name: 'Crescita Vegetale',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Fa crescere i vegetali per ostacolare il movimento o rendere fertile il terreno.',
        details:
            'Questo incantesimo incanala vitalità nei vegetali di un’area e può '
            'fornire un beneficio immediato o a lungo termine. Se l’incantatore '
            'lo lancia usando 1 azione, sceglie un punto entro gittata: tutti i '
            'vegetali normali entro un raggio di 30 metri centrato su quel '
            'punto crescono fino a formare un groviglio. Una creatura che si '
            'muove attraverso l’area deve spendere 120 cm di movimento per ogni '
            '30 cm percorsi. L’incantatore può escludere una o più aree di '
            'qualsiasi dimensione all’interno dell’area. Se invece lancia '
            'l’incantesimo nell’arco di 8 ore, rende fertile la terra: tutti i '
            'vegetali entro un raggio di 750 metri centrato su un punto entro '
            'gittata crescono rigogliosamente per 1 anno e producono il doppio '
            'del cibo normale al momento del raccolto.',
      ),
      ownerId: SpellIds.plantGrowth,
    ),
    level: 3,
    school: SpellSchool.transmutation,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.special,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 45,
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
        SpellTargetType.area,
        SpellTargetType.point,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'plant_growth_overgrowth_or_enrichment',
        type: SpellPersistentEffectType.special,
        ruleTags: {
          'casting_time_can_be_1_action_or_8_hours',
          'action_casting_targets_point_within_45_meters',
          'normal_plants_within_30_meter_radius_become_thick_overgrowth',
          'creatures_spend_120_cm_movement_per_30_cm_moved_through_area',
          'caster_can_exclude_one_or_more_areas_of_any_size',
          'eight_hour_casting_enriches_land',
          'plants_within_750_meter_radius_grow_vigorously_for_1_year',
          'harvest_produces_twice_normal_food',
          'instantaneous_transmutation',
        },
      ),
    ],
    classIds: {
      'bard',
      'druid',
      'ranger',
    },
  ),
  SpellIds.phantomSteed: SpellDefinition(
    id: SpellIds.phantomSteed,
    content: RuleContent(
      id: SpellIds.phantomSteed,
      name: 'Destriero Fantomatico',
      type: RuleContentType.spell,
      description: RuleDescription(
        summary:
            'Crea una cavalcatura quasi reale, simile a un cavallo, dotata di sella e grande velocità.',
        details:
            'Una creatura Grande, simile a un cavallo e quasi reale, appare sul '
            'terreno in uno spazio libero scelto dall’incantatore entro gittata. '
            'L’incantatore sceglie il suo aspetto, ma la creatura deve essere '
            'dotata di sella, morso e briglie. L’equipaggiamento creato '
            'dall’incantesimo svanisce se viene portato a più di 3 metri dalla '
            'cavalcatura. Per la durata, l’incantatore o una creatura scelta può '
            'cavalcare il destriero. La creatura usa le statistiche di un '
            'cavallo da galoppo, ma ha velocità di 30 metri e può percorrere '
            '15 km in un’ora o 20 km a passo veloce. Quando l’incantesimo '
            'termina, la cavalcatura svanisce gradualmente e concede al '
            'cavalcatore 1 minuto per smontare. L’incantesimo termina se '
            'l’incantatore usa un’azione per interromperlo o se la cavalcatura '
            'subisce danni. Può essere lanciato come rituale.',
      ),
      ownerId: SpellIds.phantomSteed,
    ),
    level: 3,
    ritual: true,
    school: SpellSchool.illusion,
    castingTime: SpellCastingTime(
      type: SpellCastingTimeType.minute,
      amount: 1,
    ),
    range: SpellRange(
      type: SpellRangeType.distance,
      distanceMeters: 9,
    ),
    components: SpellComponents(
      verbal: true,
      somatic: true,
    ),
    duration: SpellDuration(
      type: SpellDurationType.hour,
      amount: 1,
    ),
    target: SpellTarget(
      types: {
        SpellTargetType.special,
      },
    ),
    persistentEffects: [
      SpellPersistentEffect(
        id: 'phantom_steed_quasi_real_mount',
        type: SpellPersistentEffectType.createdObject,
        ruleTags: {
          'ritual_spell',
          'creates_large_horse_like_quasi_real_creature_in_unoccupied_space_within_9_meters',
          'caster_chooses_mount_appearance',
          'mount_has_saddle_bit_and_bridle',
          'created_equipment_vanishes_if_more_than_3_meters_from_mount',
          'caster_or_chosen_creature_can_ride_mount',
          'mount_uses_riding_horse_statistics',
          'mount_speed_30_meters',
          'mount_travels_15_km_per_hour_or_20_km_fast_pace',
          'mount_fades_when_spell_ends_and_gives_rider_1_minute_to_dismount',
          'spell_ends_if_caster_dismisses_with_action',
          'spell_ends_if_mount_takes_damage',
        },
      ),
    ],
    classIds: {
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
