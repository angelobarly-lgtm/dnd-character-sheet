enum ToolCategory {
  artisan,
  gaming,
  musical,
  kit,
  vehicle,
  other,
}

class ToolDefinition {
  final String id;
  final String name;
  final ToolCategory category;
  final double weightKg;
  final int cost;
  final String currency;

  const ToolDefinition({
    required this.id,
    required this.name,
    required this.category,
    this.weightKg = 0,
    this.cost = 0,
    this.currency = 'gp',
  });
}

class ToolIds {
  // Artisan's Tools
  static const alchemistsSupplies = 'alchemists_supplies';
  static const brewersSupplies = 'brewers_supplies';
  static const calligraphersSupplies = 'calligraphers_supplies';
  static const carpentersTools = 'carpenters_tools';
  static const cartographersTools = 'cartographers_tools';
  static const cobblersTools = 'cobblers_tools';
  static const cooksUtensils = 'cooks_utensils';
  static const glassblowersTools = 'glassblowers_tools';
  static const jewelersTools = 'jewelers_tools';
  static const leatherworkersTools = 'leatherworkers_tools';
  static const masonsTools = 'masons_tools';
  static const paintersSupplies = 'painters_supplies';
  static const pottersTools = 'potters_tools';
  static const smithsTools = 'smiths_tools';
  static const tinkersTools = 'tinkers_tools';
  static const weaversTools = 'weavers_tools';
  static const woodcarversTools = 'woodcarvers_tools';

  // Musical Instruments
  static const bagpipes = 'bagpipes';
  static const drum = 'drum';
  static const dulcimer = 'dulcimer';
  static const flute = 'flute';
  static const lute = 'lute';
  static const lyre = 'lyre';
  static const horn = 'horn';
  static const panFlute = 'pan_flute';
  static const shawm = 'shawm';
  static const viol = 'viol';

  // Gaming Sets
  static const diceSet = 'dice_set';
  static const dragonchessSet = 'dragonchess_set';
  static const playingCardSet = 'playing_card_set';
  static const threeDragonAnteSet = 'three_dragon_ante_set';

  // Kits
  static const disguiseKit = 'disguise_kit';
  static const forgeryKit = 'forgery_kit';
  static const herbalismKit = 'herbalism_kit';
  static const navigatorsTools = 'navigators_tools';
  static const poisonersKit = 'poisoners_kit';
  static const thievesTools = 'thieves_tools';

  // Vehicles
  static const landVehicles = 'land_vehicles';
  static const waterVehicles = 'water_vehicles';
}

final toolDefinitions = <String, ToolDefinition>{
  ToolIds.alchemistsSupplies: ToolDefinition(
    id: ToolIds.alchemistsSupplies,
    name: 'Strumenti da Alchimista',
    category: ToolCategory.artisan,
    weightKg: 4.0,
    cost: 50,
    currency: 'gp',
  ),
  ToolIds.brewersSupplies: ToolDefinition(
    id: ToolIds.brewersSupplies,
    name: 'Strumenti da Birraio',
    category: ToolCategory.artisan,
    weightKg: 4.5,
    cost: 20,
    currency: 'gp',
  ),
  ToolIds.calligraphersSupplies: ToolDefinition(
    id: ToolIds.calligraphersSupplies,
    name: 'Strumenti da Calligrafo',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 10,
    currency: 'gp',
  ),
  ToolIds.carpentersTools: ToolDefinition(
    id: ToolIds.carpentersTools,
    name: 'Strumenti da Carpentiere',
    category: ToolCategory.artisan,
    weightKg: 3.0,
    cost: 8,
    currency: 'gp',
  ),
  ToolIds.cartographersTools: ToolDefinition(
    id: ToolIds.cartographersTools,
    name: 'Strumenti da Cartografo',
    category: ToolCategory.artisan,
    weightKg: 3.0,
    cost: 15,
    currency: 'gp',
  ),
  ToolIds.cobblersTools: ToolDefinition(
    id: ToolIds.cobblersTools,
    name: 'Strumenti da Ciabattino',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 5,
    currency: 'gp',
  ),
  ToolIds.cooksUtensils: ToolDefinition(
    id: ToolIds.cooksUtensils,
    name: 'Utensili da Cuoco',
    category: ToolCategory.artisan,
    weightKg: 4.0,
    cost: 1,
    currency: 'gp',
  ),
  ToolIds.glassblowersTools: ToolDefinition(
    id: ToolIds.glassblowersTools,
    name: 'Strumenti da Soffiatore di Vetro',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 30,
    currency: 'gp',
  ),
  ToolIds.jewelersTools: ToolDefinition(
    id: ToolIds.jewelersTools,
    name: 'Strumenti da Gioielliere',
    category: ToolCategory.artisan,
    weightKg: 1.0,
    cost: 25,
    currency: 'gp',
  ),
  ToolIds.leatherworkersTools: ToolDefinition(
    id: ToolIds.leatherworkersTools,
    name: 'Strumenti da Conciatore',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 5,
    currency: 'gp',
  ),
  ToolIds.masonsTools: ToolDefinition(
    id: ToolIds.masonsTools,
    name: 'Strumenti da Muratore',
    category: ToolCategory.artisan,
    weightKg: 4.0,
    cost: 10,
    currency: 'gp',
  ),
  ToolIds.paintersSupplies: ToolDefinition(
    id: ToolIds.paintersSupplies,
    name: 'Strumenti da Pittore',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 10,
    currency: 'gp',
  ),
  ToolIds.pottersTools: ToolDefinition(
    id: ToolIds.pottersTools,
    name: 'Strumenti da Vasaio',
    category: ToolCategory.artisan,
    weightKg: 1.5,
    cost: 10,
    currency: 'gp',
  ),
  ToolIds.smithsTools: ToolDefinition(
    id: ToolIds.smithsTools,
    name: 'Strumenti da Fabbro',
    category: ToolCategory.artisan,
    weightKg: 4.0,
    cost: 20,
    currency: 'gp',
  ),
  ToolIds.tinkersTools: ToolDefinition(
    id: ToolIds.tinkersTools,
    name: 'Strumenti da Inventore',
    category: ToolCategory.artisan,
    weightKg: 5.0,
    cost: 50,
    currency: 'gp',
  ),
  ToolIds.weaversTools: ToolDefinition(
    id: ToolIds.weaversTools,
    name: 'Strumenti da Tessitore',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 1,
    currency: 'gp',
  ),
  ToolIds.woodcarversTools: ToolDefinition(
    id: ToolIds.woodcarversTools,
    name: 'Strumenti da Intagliatore del Legno',
    category: ToolCategory.artisan,
    weightKg: 2.5,
    cost: 1,
    currency: 'gp',
  ),
  ToolIds.bagpipes: ToolDefinition(
    id: ToolIds.bagpipes,
    name: 'Cornamusa',
    category: ToolCategory.musical,
    weightKg: 3.0,
    cost: 30,
    currency: 'gp',
  ),
  ToolIds.drum: ToolDefinition(
    id: ToolIds.drum,
    name: 'Tamburo',
    category: ToolCategory.musical,
    weightKg: 1.5,
    cost: 6,
    currency: 'gp',
  ),
  ToolIds.dulcimer: ToolDefinition(
    id: ToolIds.dulcimer,
    name: 'Salterio',
    category: ToolCategory.musical,
    weightKg: 5.0,
    cost: 25,
    currency: 'gp',
  ),
  ToolIds.flute: ToolDefinition(
    id: ToolIds.flute,
    name: 'Flauto',
    category: ToolCategory.musical,
    weightKg: 0.5,
    cost: 2,
    currency: 'gp',
  ),
  ToolIds.lute: ToolDefinition(
    id: ToolIds.lute,
    name: 'Liuto',
    category: ToolCategory.musical,
    weightKg: 1.0,
    cost: 35,
    currency: 'gp',
  ),
  ToolIds.lyre: ToolDefinition(
    id: ToolIds.lyre,
    name: 'Lira',
    category: ToolCategory.musical,
    weightKg: 1.0,
    cost: 30,
    currency: 'gp',
  ),
  ToolIds.horn: ToolDefinition(
    id: ToolIds.horn,
    name: 'Corno',
    category: ToolCategory.musical,
    weightKg: 1.0,
    cost: 3,
    currency: 'gp',
  ),
  ToolIds.panFlute: ToolDefinition(
    id: ToolIds.panFlute,
    name: 'Flauto di Pan',
    category: ToolCategory.musical,
    weightKg: 1.0,
    cost: 12,
    currency: 'gp',
  ),
  ToolIds.shawm: ToolDefinition(
    id: ToolIds.shawm,
    name: 'Ciaramella',
    category: ToolCategory.musical,
    weightKg: 0.5,
    cost: 2,
    currency: 'gp',
  ),
  ToolIds.viol: ToolDefinition(
    id: ToolIds.viol,
    name: 'Viola',
    category: ToolCategory.musical,
    weightKg: 0.5,
    cost: 30,
    currency: 'gp',
  ),
  ToolIds.diceSet: ToolDefinition(
    id: ToolIds.diceSet,
    name: 'Set di Dadi',
    category: ToolCategory.gaming,
    weightKg: 0.0,
    cost: 1,
    currency: 'sp',
  ),
  ToolIds.dragonchessSet: ToolDefinition(
    id: ToolIds.dragonchessSet,
    name: 'Set di Dragonchess',
    category: ToolCategory.gaming,
    weightKg: 0.25,
    cost: 1,
    currency: 'gp',
  ),
  ToolIds.playingCardSet: ToolDefinition(
    id: ToolIds.playingCardSet,
    name: 'Mazzo di Carte',
    category: ToolCategory.gaming,
    weightKg: 0.0,
    cost: 5,
    currency: 'sp',
  ),
  ToolIds.threeDragonAnteSet: ToolDefinition(
    id: ToolIds.threeDragonAnteSet,
    name: 'Three-Dragon Ante',
    category: ToolCategory.gaming,
    weightKg: 0.0,
    cost: 1,
    currency: 'gp',
  ),
  ToolIds.disguiseKit: ToolDefinition(
    id: ToolIds.disguiseKit,
    name: 'Kit del Travestimento',
    category: ToolCategory.kit,
    weightKg: 1.5,
    cost: 25,
    currency: 'gp',
  ),
  ToolIds.forgeryKit: ToolDefinition(
    id: ToolIds.forgeryKit,
    name: 'Kit del Falsario',
    category: ToolCategory.kit,
    weightKg: 2.5,
    cost: 15,
    currency: 'gp',
  ),
  ToolIds.herbalismKit: ToolDefinition(
    id: ToolIds.herbalismKit,
    name: "Kit dell'Erborista",
    category: ToolCategory.kit,
    weightKg: 1.5,
    cost: 5,
    currency: 'gp',
  ),
  ToolIds.navigatorsTools: ToolDefinition(
    id: ToolIds.navigatorsTools,
    name: 'Strumenti del Navigatore',
    category: ToolCategory.kit,
    weightKg: 1.0,
    cost: 25,
    currency: 'gp',
  ),
  ToolIds.poisonersKit: ToolDefinition(
    id: ToolIds.poisonersKit,
    name: "Kit dell'Avvelenatore",
    category: ToolCategory.kit,
    weightKg: 1.0,
    cost: 50,
    currency: 'gp',
  ),
  ToolIds.thievesTools: ToolDefinition(
    id: ToolIds.thievesTools,
    name: 'Strumenti da Scasso',
    category: ToolCategory.kit,
    weightKg: 0.5,
    cost: 25,
    currency: 'gp',
  ),
  ToolIds.landVehicles: ToolDefinition(
    id: ToolIds.landVehicles,
    name: 'Veicoli Terrestri',
    category: ToolCategory.vehicle,
  ),
  ToolIds.waterVehicles: ToolDefinition(
    id: ToolIds.waterVehicles,
    name: 'Veicoli Acquatici',
    category: ToolCategory.vehicle,
  ),
};
