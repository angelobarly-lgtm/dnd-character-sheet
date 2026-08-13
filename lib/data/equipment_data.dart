enum EquipmentCategory {
  adventuringGear,
  container,
  food,
  drink,
  light,
  clothing,
  miscellaneous,
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
}

final equipmentDefinitions = <String, EquipmentDefinition>{
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
