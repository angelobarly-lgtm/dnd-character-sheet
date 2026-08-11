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
  final double weight;
  final int cost;
  final String currency;

  const ToolDefinition({
    required this.id,
    required this.name,
    required this.category,
    this.weight = 0,
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
  ),
  ToolIds.brewersSupplies: ToolDefinition(
    id: ToolIds.brewersSupplies,
    name: 'Strumenti da Birraio',
    category: ToolCategory.artisan,
  ),
  ToolIds.calligraphersSupplies: ToolDefinition(
    id: ToolIds.calligraphersSupplies,
    name: 'Strumenti da Calligrafo',
    category: ToolCategory.artisan,
  ),
  ToolIds.carpentersTools: ToolDefinition(
    id: ToolIds.carpentersTools,
    name: 'Strumenti da Carpentiere',
    category: ToolCategory.artisan,
  ),
  ToolIds.cartographersTools: ToolDefinition(
    id: ToolIds.cartographersTools,
    name: 'Strumenti da Cartografo',
    category: ToolCategory.artisan,
  ),
  ToolIds.cobblersTools: ToolDefinition(
    id: ToolIds.cobblersTools,
    name: 'Strumenti da Ciabattino',
    category: ToolCategory.artisan,
  ),
  ToolIds.cooksUtensils: ToolDefinition(
    id: ToolIds.cooksUtensils,
    name: 'Utensili da Cuoco',
    category: ToolCategory.artisan,
  ),
  ToolIds.glassblowersTools: ToolDefinition(
    id: ToolIds.glassblowersTools,
    name: 'Strumenti da Soffiatore di Vetro',
    category: ToolCategory.artisan,
  ),
  ToolIds.jewelersTools: ToolDefinition(
    id: ToolIds.jewelersTools,
    name: 'Strumenti da Gioielliere',
    category: ToolCategory.artisan,
  ),
  ToolIds.leatherworkersTools: ToolDefinition(
    id: ToolIds.leatherworkersTools,
    name: 'Strumenti da Conciatore',
    category: ToolCategory.artisan,
  ),
  ToolIds.masonsTools: ToolDefinition(
    id: ToolIds.masonsTools,
    name: 'Strumenti da Muratore',
    category: ToolCategory.artisan,
  ),
  ToolIds.paintersSupplies: ToolDefinition(
    id: ToolIds.paintersSupplies,
    name: 'Strumenti da Pittore',
    category: ToolCategory.artisan,
  ),
  ToolIds.pottersTools: ToolDefinition(
    id: ToolIds.pottersTools,
    name: 'Strumenti da Vasaio',
    category: ToolCategory.artisan,
  ),
  ToolIds.smithsTools: ToolDefinition(
    id: ToolIds.smithsTools,
    name: 'Strumenti da Fabbro',
    category: ToolCategory.artisan,
  ),
  ToolIds.tinkersTools: ToolDefinition(
    id: ToolIds.tinkersTools,
    name: 'Strumenti da Inventore',
    category: ToolCategory.artisan,
  ),
  ToolIds.weaversTools: ToolDefinition(
    id: ToolIds.weaversTools,
    name: 'Strumenti da Tessitore',
    category: ToolCategory.artisan,
  ),
  ToolIds.woodcarversTools: ToolDefinition(
    id: ToolIds.woodcarversTools,
    name: 'Strumenti da Intagliatore del Legno',
    category: ToolCategory.artisan,
  ),
  ToolIds.bagpipes: ToolDefinition(
    id: ToolIds.bagpipes,
    name: 'Cornamusa',
    category: ToolCategory.musical,
  ),
  ToolIds.drum: ToolDefinition(
    id: ToolIds.drum,
    name: 'Tamburo',
    category: ToolCategory.musical,
  ),
  ToolIds.dulcimer: ToolDefinition(
    id: ToolIds.dulcimer,
    name: 'Salterio',
    category: ToolCategory.musical,
  ),
  ToolIds.flute: ToolDefinition(
    id: ToolIds.flute,
    name: 'Flauto',
    category: ToolCategory.musical,
  ),
  ToolIds.lute: ToolDefinition(
    id: ToolIds.lute,
    name: 'Liuto',
    category: ToolCategory.musical,
  ),
  ToolIds.lyre: ToolDefinition(
    id: ToolIds.lyre,
    name: 'Lira',
    category: ToolCategory.musical,
  ),
  ToolIds.horn: ToolDefinition(
    id: ToolIds.horn,
    name: 'Corno',
    category: ToolCategory.musical,
  ),
  ToolIds.panFlute: ToolDefinition(
    id: ToolIds.panFlute,
    name: 'Flauto di Pan',
    category: ToolCategory.musical,
  ),
  ToolIds.shawm: ToolDefinition(
    id: ToolIds.shawm,
    name: 'Ciaramella',
    category: ToolCategory.musical,
  ),
  ToolIds.viol: ToolDefinition(
    id: ToolIds.viol,
    name: 'Viola',
    category: ToolCategory.musical,
  ),
  ToolIds.diceSet: ToolDefinition(
    id: ToolIds.diceSet,
    name: 'Set di Dadi',
    category: ToolCategory.gaming,
  ),
  ToolIds.dragonchessSet: ToolDefinition(
    id: ToolIds.dragonchessSet,
    name: 'Set di Dragonchess',
    category: ToolCategory.gaming,
  ),
  ToolIds.playingCardSet: ToolDefinition(
    id: ToolIds.playingCardSet,
    name: 'Mazzo di Carte',
    category: ToolCategory.gaming,
  ),
  ToolIds.threeDragonAnteSet: ToolDefinition(
    id: ToolIds.threeDragonAnteSet,
    name: 'Three-Dragon Ante',
    category: ToolCategory.gaming,
  ),
  ToolIds.disguiseKit: ToolDefinition(
    id: ToolIds.disguiseKit,
    name: 'Kit del Travestimento',
    category: ToolCategory.kit,
  ),
  ToolIds.forgeryKit: ToolDefinition(
    id: ToolIds.forgeryKit,
    name: 'Kit del Falsario',
    category: ToolCategory.kit,
  ),
  ToolIds.herbalismKit: ToolDefinition(
    id: ToolIds.herbalismKit,
    name: "Kit dell'Erborista",
    category: ToolCategory.kit,
  ),
  ToolIds.navigatorsTools: ToolDefinition(
    id: ToolIds.navigatorsTools,
    name: 'Strumenti del Navigatore',
    category: ToolCategory.kit,
  ),
  ToolIds.poisonersKit: ToolDefinition(
    id: ToolIds.poisonersKit,
    name: "Kit dell'Avvelenatore",
    category: ToolCategory.kit,
  ),
  ToolIds.thievesTools: ToolDefinition(
    id: ToolIds.thievesTools,
    name: 'Strumenti da Scasso',
    category: ToolCategory.kit,
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
