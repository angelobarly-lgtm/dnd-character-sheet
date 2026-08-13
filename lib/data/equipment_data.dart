enum EquipmentCategory {
  adventuringGear,
  container,
  food,
  drink,
  light,
  clothing,
  miscellaneous,
}

/// Modalità principale con cui un oggetto viene utilizzato.
enum EquipmentUseType {
  action,
  attack,
  apply,
  consume,
  deploy,
  passive,
}

/// Effetto meccanico prodotto dall’utilizzo di un oggetto.
///
/// I campi opzionali consentono di descrivere oggetti offensivi,
/// curativi, consumabili e strumenti con utilizzi limitati senza
/// introdurre logica specifica nella UI.
class EquipmentUseDefinition {
  final String id;
  final String name;
  final EquipmentUseType type;

  /// Gittate espresse in metri.
  final double? normalRangeMeters;
  final double? longRangeMeters;

  final String? damageDice;
  final String? damageType;

  final String? healingDice;
  final int healingBonus;

  final String? savingThrowAbility;
  final int? savingThrowDc;

  /// Numero di utilizzi contenuti nell’oggetto.
  ///
  /// Null indica che non esiste un contatore specifico.
  final int? uses;

  /// Numero di utilizzi consumati da una singola attivazione.
  final int usesConsumed;

  /// Indica che l’oggetto stesso viene consumato dall’utilizzo.
  final bool consumesItem;

  /// Tag meccanici stabili per regole non rappresentabili tramite
  /// i campi numerici del modello.
  final Set<String> ruleTags;

  const EquipmentUseDefinition({
    required this.id,
    required this.name,
    required this.type,
    this.normalRangeMeters,
    this.longRangeMeters,
    this.damageDice,
    this.damageType,
    this.healingDice,
    this.healingBonus = 0,
    this.savingThrowAbility,
    this.savingThrowDc,
    this.uses,
    this.usesConsumed = 1,
    this.consumesItem = false,
    this.ruleTags = const {},
  })  : assert(normalRangeMeters == null || normalRangeMeters >= 0),
        assert(longRangeMeters == null || longRangeMeters >= 0),
        assert(savingThrowDc == null || savingThrowDc > 0),
        assert(uses == null || uses > 0),
        assert(usesConsumed > 0);
}

class EquipmentDefinition {
  final String id;
  final String name;
  final EquipmentCategory category;
  final double weight;
  final int cost;
  final String currency;

  /// true se l'oggetto può esistere in quantità arbitrarie
  /// (torce, razioni, chiodi, candele...)
  final bool stackable;
  final bool isContainer;
  final double? containerCapacity;
  final bool canContainItems;

  /// Descrizione regolamentare dell’oggetto.
  final String description;

  /// Utilizzi o attivazioni meccaniche disponibili.
  final List<EquipmentUseDefinition> uses;

  /// Tag passivi o proprietà generali dell’oggetto.
  final Set<String> ruleTags;

  const EquipmentDefinition({
    required this.id,
    required this.name,
    required this.category,
    this.weight = 0,
    this.cost = 0,
    this.currency = "gp",
    this.stackable = false,
    this.isContainer = false,
    this.containerCapacity,
    this.canContainItems = false,
    this.description = '',
    this.uses = const [],
    this.ruleTags = const {},
  });
}

class EquipmentIds {
  // Containers

  static const backpack = "backpack";
  static const sack = "sack";
  static const pouch = "pouch";
  static const chest = "chest";
  static const barrel = "barrel";
  static const basket = "basket";
  static const bucket = "bucket";
  static const bottle = "bottle";

  // Rope

  static const hempenRope = "hempen_rope";
  static const silkRope = "silk_rope";

  // Light

  static const torch = "torch";
  static const candle = "candle";
  static const lamp = "lamp";
  static const bullseyeLantern = "bullseye_lantern";
  static const hoodedLantern = "hooded_lantern";
  static const flaskOfOil = "flask_of_oil";

  // Food

  static const rations = "rations";
  static const waterskin = "waterskin";

  static const grapplingHook = "grappling_hook";
  static const hammer = "hammer";
  static const piton = "piton";
  static const crowbar = "crowbar";
  static const ladder = "ladder";
  static const shovel = "shovel";
  static const pick = "pick";
  static const huntingTrap = "hunting_trap";

  static const bedroll = "bedroll";
  static const blanket = "blanket";
  static const messKit = "mess_kit";
  static const tinderbox = "tinderbox";
  static const tentTwoPerson = "tent_two_person";
  static const ironPot = "iron_pot";
  static const whetstone = "whetstone";
  static const soap = "soap";

  static const climbersKit = "climbers_kit";
  static const chain = "chain";
  static const bell = "bell";
  static const blockAndTackle = "block_and_tackle";
  static const crowbarHeavy = "crowbar_heavy";
  static const fishingTackle = "fishing_tackle";
  static const huntingHorn = "hunting_horn";
  static const hourglass = "hourglass";
  static const ink = "ink";
  static const inkPen = "ink_pen";

  static const jug = "jug";
  static const vial = "vial";
  static const flask = "flask";
  static const magnifyingGlass = "magnifying_glass";
  static const lock = "lock";
  static const manacles = "manacles";
  static const mirrorSteel = "mirror_steel";
  static const paper = "paper";
  static const parchment = "parchment";
  static const perfume = "perfume";

  static const pole = "pole";
  static const portableRam = "portable_ram";
  static const scaleMerchant = "scale_merchant";
  static const sealingWax = "sealing_wax";
  static const signalWhistle = "signal_whistle";
  static const signetRing = "signet_ring";
  static const spade = "spade";
  static const spyglass = "spyglass";
  static const string = "string";
  static const twine = "twine";
  static const ballBearings = "ball_bearings";
  static const costume = "costume";
  static const incense = "incense";
  static const robes = "robes";
  static const fineClothes = "fine_clothes";
  static const commonClothes = "common_clothes";
  static const almsBox = "alms_box";
  static const censer = "censer";
  static const prayerBook = "prayer_book";
  static const prayerWheel = "prayer_wheel";
  static const guildLetter = "guild_letter";
  static const travelersClothes = "travelers_clothes";
  static const cart = "cart";
  static const charlatanColoredBottles = "charlatan_colored_bottles";
  static const loadedDice = "loaded_dice";
  static const markedCards = "marked_cards";
  static const falseDucalSignetRing = "false_ducal_signet_ring";
  static const scrollCase = "scroll_case";
  static const animalTrophy = "animal_trophy";
  static const admirerLoveLetter = "admirer_love_letter";
  static const admirerLockOfHair = "admirer_lock_of_hair";
  static const admirerTrinket = "admirer_trinket";
  static const sailorsRabbitFoot = "sailors_rabbit_foot";
  static const sailorsHoleyStone = "sailors_holey_stone";
  static const randomTrinket = "random_trinket";
  static const urchinSmallKnife = "urchin_small_knife";
  static const homeCityMap = "home_city_map";
  static const petMouse = "pet_mouse";
  static const parentsMemento = "parents_memento";
  static const pedigreeScroll = "pedigree_scroll";
  static const sageDeadColleagueLetter = "sage_dead_colleague_letter";
  static const soldierRankInsignia = "soldier_rank_insignia";
  static const soldierEnemyDaggerTrophy = "soldier_enemy_dagger_trophy";
  static const soldierBrokenBladeTrophy = "soldier_broken_blade_trophy";
  static const soldierTornBannerTrophy = "soldier_torn_banner_trophy";
  static const abacus = "abacus";
  static const acidVial = "acid_vial";
  static const alchemistsFireFlask = "alchemists_fire_flask";
  static const antitoxinVial = "antitoxin_vial";
  static const book = "book";
  static const caltrops = "caltrops";
  static const crossbowBoltCase = "crossbow_bolt_case";
  static const chalk = "chalk";
  static const sledgehammer = "sledgehammer";
  static const healersKit = "healers_kit";
  static const holyWaterFlask = "holy_water_flask";
  static const basicPoison = "basic_poison";
  static const potionOfHealing = "potion_of_healing";
  static const quiver = "quiver";
  static const spellbook = "spellbook";
  static const ironSpikes = "iron_spikes";
}

final equipmentDefinitions = <String, EquipmentDefinition>{
  EquipmentIds.potionOfHealing: const EquipmentDefinition(
    id: EquipmentIds.potionOfHealing,
    name: "Pozione di Guarigione",
    category: EquipmentCategory.adventuringGear,
    weight: 0.5,
    cost: 50,
    currency: "gp",
    description:
        "Una creatura può bere la pozione o somministrarla a un’altra creatura per ripristinarne i punti ferita.",
    uses: [
      EquipmentUseDefinition(
        id: "drink_or_administer_healing_potion",
        name: "Bere o Somministrare la Pozione",
        type: EquipmentUseType.consume,
        healingDice: "2d4",
        healingBonus: 2,
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "can_be_administered_to_another_creature",
          "target_regains_hit_points",
          "has_no_effect_on_dead_creature",
        },
      ),
    ],
  ),
  EquipmentIds.quiver: const EquipmentDefinition(
    id: EquipmentIds.quiver,
    name: "Faretra",
    category: EquipmentCategory.container,
    weight: 1,
    cost: 1,
    currency: "gp",
    isContainer: true,
    containerCapacity: 20,
    canContainItems: true,
    description:
        "Un contenitore progettato per trasportare fino a venti frecce.",
    ruleTags: {
      "holds_arrows",
      "maximum_20_arrows",
    },
  ),
  EquipmentIds.spellbook: const EquipmentDefinition(
    id: EquipmentIds.spellbook,
    name: "Libro degli Incantesimi",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 50,
    currency: "gp",
    description:
        "Un volume rilegato contenente cento pagine di pergamena adatte a trascrivere incantesimi.",
    ruleTags: {
      "contains_100_blank_vellum_pages",
      "can_record_wizard_spells",
      "required_for_wizard_spell_preparation",
    },
  ),
  EquipmentIds.ironSpikes: const EquipmentDefinition(
    id: EquipmentIds.ironSpikes,
    name: "Chiodi di Ferro, 10",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 1,
    currency: "gp",
    stackable: true,
    description:
        "Un assortimento di dieci robusti chiodi di ferro utilizzabili per fissare corde, bloccare accessi o altri impieghi pratici.",
    ruleTags: {
      "bundle_contains_10_iron_spikes",
      "can_secure_rope",
      "can_wedge_objects_or_doors",
    },
  ),
  EquipmentIds.sledgehammer: const EquipmentDefinition(
    id: EquipmentIds.sledgehammer,
    name: "Mazza da Fabbro",
    category: EquipmentCategory.adventuringGear,
    weight: 10,
    cost: 2,
    currency: "gp",
    description:
        "Un pesante martello da lavoro progettato per colpire con grande forza.",
    ruleTags: {
      "heavy_work_hammer",
      "usable_as_improvised_weapon",
    },
  ),
  EquipmentIds.healersKit: const EquipmentDefinition(
    id: EquipmentIds.healersKit,
    name: "Kit del Guaritore",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 5,
    currency: "gp",
    description:
        "Una borsa contenente bende, pomate e stecche. Il kit dispone di dieci utilizzi.",
    uses: [
      EquipmentUseDefinition(
        id: "healers_kit_stabilize",
        name: "Stabilizzare una Creatura",
        type: EquipmentUseType.action,
        uses: 10,
        usesConsumed: 1,
        ruleTags: {
          "target_creature_at_0_hit_points",
          "stabilizes_target",
          "medicine_check_not_required",
        },
      ),
    ],
    ruleTags: {
      "contains_10_uses",
    },
  ),
  EquipmentIds.holyWaterFlask: const EquipmentDefinition(
    id: EquipmentIds.holyWaterFlask,
    name: "Acqua Santa, Ampolla",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 25,
    currency: "gp",
    description:
        "L’acqua benedetta danneggia immondi e non morti quando viene versata o scagliata contro di loro.",
    uses: [
      EquipmentUseDefinition(
        id: "holy_water_splash",
        name: "Versare o Lanciare l’Acqua Santa",
        type: EquipmentUseType.attack,
        normalRangeMeters: 6,
        damageDice: "2d6",
        damageType: "radiant",
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "treated_as_improvised_weapon_when_thrown",
          "ranged_attack",
          "target_fiend_or_undead",
          "contents_can_be_splashed_on_adjacent_target",
          "flask_shatters_on_thrown_hit",
        },
      ),
    ],
    ruleTags: {
      "cleric_or_paladin_can_create",
      "creation_requires_1_hour",
      "creation_consumes_25_gp_powdered_silver",
      "creation_expends_first_level_spell_slot",
    },
  ),
  EquipmentIds.basicPoison: const EquipmentDefinition(
    id: EquipmentIds.basicPoison,
    name: "Veleno Base, Fiala",
    category: EquipmentCategory.adventuringGear,
    cost: 100,
    currency: "gp",
    description:
        "Il veleno può rivestire un’arma tagliente o perforante oppure fino a tre munizioni.",
    uses: [
      EquipmentUseDefinition(
        id: "apply_basic_poison",
        name: "Applicare il Veleno Base",
        type: EquipmentUseType.apply,
        damageDice: "1d4",
        damageType: "poison",
        savingThrowAbility: "COS",
        savingThrowDc: 10,
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "coats_one_slashing_or_piercing_weapon",
          "can_instead_coat_up_to_3_pieces_of_ammunition",
          "poison_remains_potent_for_1_minute",
          "damage_applies_on_hit",
          "damage_requires_failed_saving_throw",
        },
      ),
    ],
  ),
  EquipmentIds.book: const EquipmentDefinition(
    id: EquipmentIds.book,
    name: "Libro",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 25,
    currency: "gp",
    description:
        "Un volume che può contenere poesia, storia, conoscenze specialistiche, diagrammi o appunti relativi a un particolare argomento.",
    ruleTags: {
      "contains_written_knowledge",
      "subject_defined_by_book",
    },
  ),
  EquipmentIds.caltrops: const EquipmentDefinition(
    id: EquipmentIds.caltrops,
    name: "Triboli, Sacchetto da 20",
    category: EquipmentCategory.adventuringGear,
    weight: 2,
    cost: 1,
    currency: "gp",
    description:
        "Un sacchetto contiene venti punte metalliche che possono essere sparse sul terreno per ostacolare il passaggio.",
    uses: [
      EquipmentUseDefinition(
        id: "deploy_caltrops",
        name: "Spargere i Triboli",
        type: EquipmentUseType.deploy,
        damageDice: "1",
        damageType: "piercing",
        savingThrowAbility: "DES",
        savingThrowDc: 15,
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "covers_1_5_meter_square",
          "creature_entering_area_makes_saving_throw",
          "failed_save_stops_creature_movement",
          "failed_save_reduces_walking_speed_by_3_meters",
          "speed_penalty_ends_after_regaining_at_least_1_hit_point",
          "moving_at_half_speed_avoids_saving_throw",
        },
      ),
    ],
  ),
  EquipmentIds.crossbowBoltCase: const EquipmentDefinition(
    id: EquipmentIds.crossbowBoltCase,
    name: "Custodia per Quadrelli",
    category: EquipmentCategory.container,
    weight: 1,
    cost: 1,
    currency: "gp",
    isContainer: true,
    containerCapacity: 20,
    canContainItems: true,
    description:
        "Una custodia di legno capace di contenere fino a venti quadrelli da balestra.",
    ruleTags: {
      "holds_crossbow_bolts",
      "maximum_20_crossbow_bolts",
    },
  ),
  EquipmentIds.chalk: const EquipmentDefinition(
    id: EquipmentIds.chalk,
    name: "Gesso, Pezzo",
    category: EquipmentCategory.adventuringGear,
    cost: 1,
    currency: "cp",
    description:
        "Un piccolo pezzo di gesso utilizzabile per scrivere o tracciare segni su superfici adatte.",
    ruleTags: {
      "can_mark_surfaces",
    },
  ),
  EquipmentIds.abacus: const EquipmentDefinition(
    id: EquipmentIds.abacus,
    name: "Abaco",
    category: EquipmentCategory.adventuringGear,
    weight: 2,
    cost: 2,
    currency: "gp",
    description:
        "Uno strumento di calcolo manuale formato da file di elementi mobili.",
    ruleTags: {
      "manual_calculation_tool",
    },
  ),
  EquipmentIds.acidVial: const EquipmentDefinition(
    id: EquipmentIds.acidVial,
    name: "Acido, Fiala",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 25,
    currency: "gp",
    description:
        "La fiala può essere versata sul contenuto oppure scagliata contro una creatura o un oggetto entro 6 metri.",
    uses: [
      EquipmentUseDefinition(
        id: "acid_vial_splash",
        name: "Versare o Lanciare l’Acido",
        type: EquipmentUseType.attack,
        normalRangeMeters: 6,
        damageDice: "2d6",
        damageType: "acid",
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "ranged_attack",
          "target_creature_or_object",
          "contents_can_be_splashed_on_adjacent_target",
          "vial_shatters_on_thrown_hit",
        },
      ),
    ],
  ),
  EquipmentIds.alchemistsFireFlask: const EquipmentDefinition(
    id: EquipmentIds.alchemistsFireFlask,
    name: "Fuoco dell’Alchimista, Ampolla",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 50,
    currency: "gp",
    description:
        "Il fluido adesivo si incendia a contatto con l’aria e continua a bruciare sul bersaglio colpito.",
    uses: [
      EquipmentUseDefinition(
        id: "alchemists_fire_throw",
        name: "Lanciare il Fuoco dell’Alchimista",
        type: EquipmentUseType.attack,
        normalRangeMeters: 6,
        damageDice: "1d4",
        damageType: "fire",
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "treated_as_improvised_weapon",
          "ranged_attack",
          "target_creature_or_object",
          "damage_occurs_at_start_of_target_turn",
          "burning_damage_repeats_until_extinguished",
          "extinguish_requires_action",
          "extinguish_requires_dc_10_dexterity_check",
        },
      ),
    ],
  ),
  EquipmentIds.antitoxinVial: const EquipmentDefinition(
    id: EquipmentIds.antitoxinVial,
    name: "Antitossina, Fiala",
    category: EquipmentCategory.adventuringGear,
    cost: 50,
    currency: "gp",
    description:
        "Una creatura che beve la fiala ottiene temporaneamente una maggiore resistenza agli effetti del veleno.",
    uses: [
      EquipmentUseDefinition(
        id: "drink_antitoxin",
        name: "Bere l’Antitossina",
        type: EquipmentUseType.consume,
        consumesItem: true,
        ruleTags: {
          "requires_action",
          "grants_advantage_on_saving_throws_against_poison",
          "effect_duration_1_hour",
          "no_effect_on_constructs",
          "no_effect_on_undead",
        },
      ),
    ],
  ),
  EquipmentIds.sageDeadColleagueLetter: const EquipmentDefinition(
    id: EquipmentIds.sageDeadColleagueLetter,
    name: "Lettera di un Collega Defunto",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.soldierRankInsignia: const EquipmentDefinition(
    id: EquipmentIds.soldierRankInsignia,
    name: "Fregio del Grado Militare",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.soldierEnemyDaggerTrophy: const EquipmentDefinition(
    id: EquipmentIds.soldierEnemyDaggerTrophy,
    name: "Pugnale Sottratto a un Nemico Caduto",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.soldierBrokenBladeTrophy: const EquipmentDefinition(
    id: EquipmentIds.soldierBrokenBladeTrophy,
    name: "Lama Spezzata Sottratta a un Nemico Caduto",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.soldierTornBannerTrophy: const EquipmentDefinition(
    id: EquipmentIds.soldierTornBannerTrophy,
    name: "Brandello di Stendardo Nemico",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.urchinSmallKnife: const EquipmentDefinition(
    id: EquipmentIds.urchinSmallKnife,
    name: "Coltellino",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.homeCityMap: const EquipmentDefinition(
    id: EquipmentIds.homeCityMap,
    name: "Mappa della Città di Appartenenza",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.petMouse: const EquipmentDefinition(
    id: EquipmentIds.petMouse,
    name: "Topolino Addomesticato",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.parentsMemento: const EquipmentDefinition(
    id: EquipmentIds.parentsMemento,
    name: "Ciondolo in Ricordo dei Genitori",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.pedigreeScroll: const EquipmentDefinition(
    id: EquipmentIds.pedigreeScroll,
    name: "Pergamena con Albero Genealogico",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.sailorsRabbitFoot: const EquipmentDefinition(
    id: EquipmentIds.sailorsRabbitFoot,
    name: "Zampa di Coniglio Portafortuna",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.sailorsHoleyStone: const EquipmentDefinition(
    id: EquipmentIds.sailorsHoleyStone,
    name: "Piccola Pietra Forata Portafortuna",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.randomTrinket: const EquipmentDefinition(
    id: EquipmentIds.randomTrinket,
    name: "Oggetto Insolito Casuale",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.admirerLoveLetter: const EquipmentDefinition(
    id: EquipmentIds.admirerLoveLetter,
    name: "Lettera d'Amore di un Ammiratore",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.admirerLockOfHair: const EquipmentDefinition(
    id: EquipmentIds.admirerLockOfHair,
    name: "Ciocca di Capelli di un Ammiratore",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.admirerTrinket: const EquipmentDefinition(
    id: EquipmentIds.admirerTrinket,
    name: "Monile Donato da un Ammiratore",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.animalTrophy: const EquipmentDefinition(
    id: EquipmentIds.animalTrophy,
    name: "Trofeo di un Animale Ucciso",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.scrollCase: const EquipmentDefinition(
    id: EquipmentIds.scrollCase,
    name: "Custodia per Mappe o Pergamene",
    category: EquipmentCategory.container,
    weight: 1,
    cost: 1,
    isContainer: true,
    canContainItems: true,
  ),
  EquipmentIds.guildLetter: const EquipmentDefinition(
    id: EquipmentIds.guildLetter,
    name: "Lettera di Presentazione della Gilda",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.travelersClothes: const EquipmentDefinition(
    id: EquipmentIds.travelersClothes,
    name: "Abito da Viaggiatore",
    category: EquipmentCategory.clothing,
    weight: 4,
    cost: 2,
  ),
  EquipmentIds.cart: const EquipmentDefinition(
    id: EquipmentIds.cart,
    name: "Carretto",
    category: EquipmentCategory.miscellaneous,
    weight: 200,
    cost: 15,
  ),
  EquipmentIds.charlatanColoredBottles: const EquipmentDefinition(
    id: EquipmentIds.charlatanColoredBottles,
    name: "Dieci Bottiglie Sigillate di Liquido Colorato",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.loadedDice: const EquipmentDefinition(
    id: EquipmentIds.loadedDice,
    name: "Serie di Dadi Truccati",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.markedCards: const EquipmentDefinition(
    id: EquipmentIds.markedCards,
    name: "Mazzo di Carte Segnate",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.falseDucalSignetRing: const EquipmentDefinition(
    id: EquipmentIds.falseDucalSignetRing,
    name: "Anello con Sigillo di un Duca Immaginario",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.prayerBook: const EquipmentDefinition(
    id: EquipmentIds.prayerBook,
    name: "Libro di Preghiere",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.prayerWheel: const EquipmentDefinition(
    id: EquipmentIds.prayerWheel,
    name: "Ruota della Preghiera",
    category: EquipmentCategory.miscellaneous,
  ),
  EquipmentIds.backpack: const EquipmentDefinition(
    id: EquipmentIds.backpack,
    name: "Zaino",
    category: EquipmentCategory.container,
    weight: 5,
    cost: 2,
    isContainer: true,
    canContainItems: true,
    containerCapacity: 50,
  ),
  EquipmentIds.sack: const EquipmentDefinition(
    id: EquipmentIds.sack,
    name: "Sacco",
    category: EquipmentCategory.container,
    weight: 0.5,
    cost: 1,
    currency: "sp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 30,
  ),
  EquipmentIds.pouch: const EquipmentDefinition(
    id: EquipmentIds.pouch,
    name: "Borsa",
    category: EquipmentCategory.container,
    weight: 1,
    cost: 5,
    currency: "sp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 6,
  ),
  EquipmentIds.chest: const EquipmentDefinition(
    id: EquipmentIds.chest,
    name: "Forziere",
    category: EquipmentCategory.container,
    weight: 25,
    cost: 5,
    isContainer: true,
    canContainItems: true,
    containerCapacity: 300,
  ),
  EquipmentIds.barrel: const EquipmentDefinition(
    id: EquipmentIds.barrel,
    name: "Barile",
    category: EquipmentCategory.container,
    weight: 70,
    cost: 2,
    isContainer: true,
    canContainItems: true,
    containerCapacity: 40,
  ),
  EquipmentIds.basket: const EquipmentDefinition(
    id: EquipmentIds.basket,
    name: "Cesto",
    category: EquipmentCategory.container,
    weight: 2,
    cost: 4,
    currency: "sp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 40,
  ),
  EquipmentIds.bucket: const EquipmentDefinition(
    id: EquipmentIds.bucket,
    name: "Secchio",
    category: EquipmentCategory.container,
    weight: 2,
    cost: 5,
    currency: "cp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 20,
  ),
  EquipmentIds.bottle: const EquipmentDefinition(
    id: EquipmentIds.bottle,
    name: "Bottiglia di Vetro",
    category: EquipmentCategory.container,
    weight: 2,
    cost: 2,
    isContainer: true,
    canContainItems: true,
    containerCapacity: 2,
  ),
  EquipmentIds.hempenRope: const EquipmentDefinition(
    id: EquipmentIds.hempenRope,
    name: "Corda di Canapa (15 m)",
    category: EquipmentCategory.adventuringGear,
    weight: 10,
    cost: 1,
  ),
  EquipmentIds.silkRope: const EquipmentDefinition(
    id: EquipmentIds.silkRope,
    name: "Corda di Seta (15 m)",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 10,
  ),
  EquipmentIds.torch: const EquipmentDefinition(
    id: EquipmentIds.torch,
    name: "Torcia",
    category: EquipmentCategory.light,
    weight: 1,
    cost: 1,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.candle: const EquipmentDefinition(
    id: EquipmentIds.candle,
    name: "Candela",
    category: EquipmentCategory.light,
    cost: 1,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.lamp: const EquipmentDefinition(
    id: EquipmentIds.lamp,
    name: "Lampada",
    category: EquipmentCategory.light,
    weight: 1,
    cost: 5,
  ),
  EquipmentIds.bullseyeLantern: const EquipmentDefinition(
    id: EquipmentIds.bullseyeLantern,
    name: "Lanterna Focalizzata",
    category: EquipmentCategory.light,
    weight: 2,
    cost: 10,
  ),
  EquipmentIds.hoodedLantern: const EquipmentDefinition(
    id: EquipmentIds.hoodedLantern,
    name: "Lanterna Schermabile",
    category: EquipmentCategory.light,
    weight: 2,
    cost: 5,
  ),
  EquipmentIds.flaskOfOil: const EquipmentDefinition(
    id: EquipmentIds.flaskOfOil,
    name: "Ampolla d'Olio",
    category: EquipmentCategory.light,
    weight: 1,
    cost: 1,
    currency: "sp",
    stackable: true,
  ),
  EquipmentIds.rations: const EquipmentDefinition(
    id: EquipmentIds.rations,
    name: "Razioni (1 giorno)",
    category: EquipmentCategory.food,
    weight: 2,
    cost: 5,
    currency: "sp",
    stackable: true,
  ),
  EquipmentIds.waterskin: const EquipmentDefinition(
    id: EquipmentIds.waterskin,
    name: "Otre",
    category: EquipmentCategory.drink,
    weight: 5,
    cost: 2,
    currency: "sp",
  ),
  EquipmentIds.grapplingHook: const EquipmentDefinition(
    id: EquipmentIds.grapplingHook,
    name: "Rampino",
    category: EquipmentCategory.adventuringGear,
    weight: 4,
    cost: 2,
  ),
  EquipmentIds.hammer: const EquipmentDefinition(
    id: EquipmentIds.hammer,
    name: "Martello",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 1,
  ),
  EquipmentIds.piton: const EquipmentDefinition(
    id: EquipmentIds.piton,
    name: "Chiodo da Roccia",
    category: EquipmentCategory.adventuringGear,
    weight: 0.25,
    cost: 5,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.crowbar: const EquipmentDefinition(
    id: EquipmentIds.crowbar,
    name: "Piede di Porco",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 2,
  ),
  EquipmentIds.ladder: const EquipmentDefinition(
    id: EquipmentIds.ladder,
    name: "Scala (3 m)",
    category: EquipmentCategory.adventuringGear,
    weight: 25,
    cost: 1,
    currency: "sp",
  ),
  EquipmentIds.shovel: const EquipmentDefinition(
    id: EquipmentIds.shovel,
    name: "Pala",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 2,
  ),
  EquipmentIds.pick: const EquipmentDefinition(
    id: EquipmentIds.pick,
    name: "Piccone",
    category: EquipmentCategory.adventuringGear,
    weight: 10,
    cost: 2,
  ),
  EquipmentIds.huntingTrap: const EquipmentDefinition(
    id: EquipmentIds.huntingTrap,
    name: "Trappola da Caccia",
    category: EquipmentCategory.adventuringGear,
    weight: 25,
    cost: 5,
  ),
  EquipmentIds.bedroll: const EquipmentDefinition(
    id: EquipmentIds.bedroll,
    name: "Giaciglio",
    category: EquipmentCategory.adventuringGear,
    weight: 7,
    cost: 1,
    currency: "gp",
  ),
  EquipmentIds.blanket: const EquipmentDefinition(
    id: EquipmentIds.blanket,
    name: "Coperta",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 5,
    currency: "sp",
  ),
  EquipmentIds.messKit: const EquipmentDefinition(
    id: EquipmentIds.messKit,
    name: "Gavetta",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 2,
    currency: "sp",
  ),
  EquipmentIds.tinderbox: const EquipmentDefinition(
    id: EquipmentIds.tinderbox,
    name: "Acciarino",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 5,
    currency: "sp",
  ),
  EquipmentIds.tentTwoPerson: const EquipmentDefinition(
    id: EquipmentIds.tentTwoPerson,
    name: "Tenda (2 persone)",
    category: EquipmentCategory.adventuringGear,
    weight: 20,
    cost: 2,
  ),
  EquipmentIds.ironPot: const EquipmentDefinition(
    id: EquipmentIds.ironPot,
    name: "Pentola di Ferro",
    category: EquipmentCategory.adventuringGear,
    weight: 10,
    cost: 2,
  ),
  EquipmentIds.whetstone: const EquipmentDefinition(
    id: EquipmentIds.whetstone,
    name: "Pietra per Affilare",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 1,
    currency: "cp",
  ),
  EquipmentIds.soap: const EquipmentDefinition(
    id: EquipmentIds.soap,
    name: "Sapone",
    category: EquipmentCategory.adventuringGear,
    cost: 2,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.climbersKit: const EquipmentDefinition(
    id: EquipmentIds.climbersKit,
    name: "Kit da Scalatore",
    category: EquipmentCategory.adventuringGear,
    weight: 12,
    cost: 25,
  ),
  EquipmentIds.chain: const EquipmentDefinition(
    id: EquipmentIds.chain,
    name: "Catena (3 m)",
    category: EquipmentCategory.adventuringGear,
    weight: 10,
    cost: 5,
  ),
  EquipmentIds.bell: const EquipmentDefinition(
    id: EquipmentIds.bell,
    name: "Campanella",
    category: EquipmentCategory.adventuringGear,
    cost: 1,
    currency: "gp",
  ),
  EquipmentIds.blockAndTackle: const EquipmentDefinition(
    id: EquipmentIds.blockAndTackle,
    name: "Carrucola",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 1,
  ),
  EquipmentIds.crowbarHeavy: const EquipmentDefinition(
    id: EquipmentIds.crowbarHeavy,
    name: "Leva Pesante",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 2,
  ),
  EquipmentIds.fishingTackle: const EquipmentDefinition(
    id: EquipmentIds.fishingTackle,
    name: "Attrezzatura da Pesca",
    category: EquipmentCategory.adventuringGear,
    weight: 4,
    cost: 1,
  ),
  EquipmentIds.huntingHorn: const EquipmentDefinition(
    id: EquipmentIds.huntingHorn,
    name: "Corno da Caccia",
    category: EquipmentCategory.adventuringGear,
    weight: 2,
    cost: 3,
    currency: "gp",
  ),
  EquipmentIds.hourglass: const EquipmentDefinition(
    id: EquipmentIds.hourglass,
    name: "Clessidra",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 25,
  ),
  EquipmentIds.ink: const EquipmentDefinition(
    id: EquipmentIds.ink,
    name: "Inchiostro (30 ml)",
    category: EquipmentCategory.adventuringGear,
    cost: 10,
    currency: "gp",
    stackable: true,
  ),
  EquipmentIds.inkPen: const EquipmentDefinition(
    id: EquipmentIds.inkPen,
    name: "Pennino",
    category: EquipmentCategory.adventuringGear,
    cost: 2,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.jug: const EquipmentDefinition(
    id: EquipmentIds.jug,
    name: "Brocca",
    category: EquipmentCategory.container,
    weight: 4,
    cost: 2,
    currency: "cp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 8,
  ),
  EquipmentIds.vial: const EquipmentDefinition(
    id: EquipmentIds.vial,
    name: "Fiala",
    category: EquipmentCategory.container,
    cost: 1,
    currency: "gp",
    stackable: true,
  ),
  EquipmentIds.flask: const EquipmentDefinition(
    id: EquipmentIds.flask,
    name: "Ampolla",
    category: EquipmentCategory.container,
    weight: 1,
    cost: 2,
    currency: "cp",
    stackable: true,
    isContainer: true,
    canContainItems: true,
    containerCapacity: 1,
  ),
  EquipmentIds.magnifyingGlass: const EquipmentDefinition(
    id: EquipmentIds.magnifyingGlass,
    name: "Lente d'Ingrandimento",
    category: EquipmentCategory.adventuringGear,
    cost: 100,
  ),
  EquipmentIds.lock: const EquipmentDefinition(
    id: EquipmentIds.lock,
    name: "Lucchetto",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 10,
  ),
  EquipmentIds.manacles: const EquipmentDefinition(
    id: EquipmentIds.manacles,
    name: "Manette",
    category: EquipmentCategory.adventuringGear,
    weight: 6,
    cost: 2,
  ),
  EquipmentIds.mirrorSteel: const EquipmentDefinition(
    id: EquipmentIds.mirrorSteel,
    name: "Specchio d'Acciaio",
    category: EquipmentCategory.adventuringGear,
    weight: 0.5,
    cost: 5,
  ),
  EquipmentIds.paper: const EquipmentDefinition(
    id: EquipmentIds.paper,
    name: "Foglio di Carta",
    category: EquipmentCategory.adventuringGear,
    cost: 2,
    currency: "sp",
    stackable: true,
  ),
  EquipmentIds.parchment: const EquipmentDefinition(
    id: EquipmentIds.parchment,
    name: "Pergamena",
    category: EquipmentCategory.adventuringGear,
    cost: 1,
    currency: "sp",
    stackable: true,
  ),
  EquipmentIds.perfume: const EquipmentDefinition(
    id: EquipmentIds.perfume,
    name: "Profumo",
    category: EquipmentCategory.adventuringGear,
    cost: 5,
  ),
  EquipmentIds.pole: const EquipmentDefinition(
    id: EquipmentIds.pole,
    name: "Pertica (3 m)",
    category: EquipmentCategory.adventuringGear,
    weight: 7,
    cost: 5,
    currency: "cp",
  ),
  EquipmentIds.portableRam: const EquipmentDefinition(
    id: EquipmentIds.portableRam,
    name: "Ariete Portatile",
    category: EquipmentCategory.adventuringGear,
    weight: 35,
    cost: 4,
  ),
  EquipmentIds.scaleMerchant: const EquipmentDefinition(
    id: EquipmentIds.scaleMerchant,
    name: "Bilancia da Mercante",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 5,
  ),
  EquipmentIds.sealingWax: const EquipmentDefinition(
    id: EquipmentIds.sealingWax,
    name: "Ceralacca",
    category: EquipmentCategory.adventuringGear,
    cost: 5,
    currency: "sp",
    stackable: true,
  ),
  EquipmentIds.signalWhistle: const EquipmentDefinition(
    id: EquipmentIds.signalWhistle,
    name: "Fischietto",
    category: EquipmentCategory.adventuringGear,
    cost: 5,
    currency: "cp",
  ),
  EquipmentIds.signetRing: const EquipmentDefinition(
    id: EquipmentIds.signetRing,
    name: "Anello con Sigillo",
    category: EquipmentCategory.adventuringGear,
    cost: 5,
  ),
  EquipmentIds.spade: const EquipmentDefinition(
    id: EquipmentIds.spade,
    name: "Vanga",
    category: EquipmentCategory.adventuringGear,
    weight: 5,
    cost: 2,
  ),
  EquipmentIds.spyglass: const EquipmentDefinition(
    id: EquipmentIds.spyglass,
    name: "Cannocchiale",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 1000,
  ),
  EquipmentIds.string: const EquipmentDefinition(
    id: EquipmentIds.string,
    name: "Spago (3 m)",
    category: EquipmentCategory.adventuringGear,
    cost: 1,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.twine: const EquipmentDefinition(
    id: EquipmentIds.twine,
    name: "Cordino",
    category: EquipmentCategory.adventuringGear,
    cost: 1,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.ballBearings: const EquipmentDefinition(
    id: EquipmentIds.ballBearings,
    name: "Sfere di Ferro (1.000)",
    category: EquipmentCategory.adventuringGear,
    weight: 2,
    cost: 1,
    stackable: true,
  ),
  EquipmentIds.costume: const EquipmentDefinition(
    id: EquipmentIds.costume,
    name: "Costume",
    category: EquipmentCategory.adventuringGear,
    weight: 4,
    cost: 5,
  ),
  EquipmentIds.incense: const EquipmentDefinition(
    id: EquipmentIds.incense,
    name: "Incenso",
    category: EquipmentCategory.adventuringGear,
    cost: 0,
    currency: "cp",
    stackable: true,
  ),
  EquipmentIds.robes: const EquipmentDefinition(
    id: EquipmentIds.robes,
    name: "Vesti",
    category: EquipmentCategory.adventuringGear,
    weight: 4,
    cost: 1,
  ),
  EquipmentIds.fineClothes: const EquipmentDefinition(
    id: EquipmentIds.fineClothes,
    name: "Abiti Eleganti",
    category: EquipmentCategory.adventuringGear,
    weight: 6,
    cost: 15,
    currency: "gp",
  ),
  EquipmentIds.commonClothes: const EquipmentDefinition(
    id: EquipmentIds.commonClothes,
    name: "Abiti Comuni",
    category: EquipmentCategory.adventuringGear,
    weight: 3,
    cost: 5,
    currency: "sp",
  ),
  EquipmentIds.almsBox: const EquipmentDefinition(
    id: EquipmentIds.almsBox,
    name: "Cassetta delle Elemosine",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 5,
    currency: "gp",
    isContainer: true,
    canContainItems: true,
    containerCapacity: 2,
  ),
  EquipmentIds.censer: const EquipmentDefinition(
    id: EquipmentIds.censer,
    name: "Turibolo",
    category: EquipmentCategory.adventuringGear,
    weight: 1,
    cost: 5,
    currency: "gp",
  ),
};
