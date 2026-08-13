import 'equipment_data.dart';

class MountDefinition {
  final String id;
  final String name;
  final int cost;
  final String currency;
  final double speedMeters;
  final double carryingCapacityKg;

  const MountDefinition({
    required this.id,
    required this.name,
    required this.cost,
    this.currency = 'gp',
    required this.speedMeters,
    required this.carryingCapacityKg,
  });
}

enum MountGearCategory {
  barding,
  bitAndBridle,
  feed,
  saddle,
  saddlebags,
  service,
}

class MountGearDefinition {
  final String id;
  final String name;
  final MountGearCategory category;

  /// Prezzo fisso; null per la bardatura, calcolata dall'armatura base.
  final int? cost;
  final String currency;

  /// Peso fisso; null se non applicabile o calcolato dinamicamente.
  final double? weightKg;

  /// Moltiplicatori applicati all'armatura base per ottenere una bardatura.
  final int costMultiplier;
  final double weightMultiplier;

  /// Indica che il prezzo è riferito a una singola giornata.
  final bool dailyCost;

  const MountGearDefinition({
    required this.id,
    required this.name,
    required this.category,
    this.cost,
    this.currency = 'gp',
    this.weightKg,
    this.costMultiplier = 1,
    this.weightMultiplier = 1,
    this.dailyCost = false,
  });

  int costForBaseArmor(int armorCost) => armorCost * costMultiplier;

  double weightForBaseArmor(double armorWeightKg) =>
      armorWeightKg * weightMultiplier;
}

enum VehicleCategory {
  land,
  water,
}

class VehicleDefinition {
  final String id;
  final String name;
  final VehicleCategory category;
  final int cost;
  final String currency;

  /// Peso del veicolo quando specificato dalla tabella PHB.
  final double? weightKg;

  /// Velocità di viaggio delle imbarcazioni.
  final double? speedKmh;

  /// I veicoli terrestri richiedono animali da tiro.
  final bool requiresDraftAnimal;

  /// Un animale può trainare cinque volte la propria capacità,
  /// includendo il peso del veicolo.
  final double draftCapacityMultiplier;

  const VehicleDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.cost,
    this.currency = 'gp',
    this.weightKg,
    this.speedKmh,
    this.requiresDraftAnimal = false,
    this.draftCapacityMultiplier = 1,
  });
}

class MountIds {
  static const camel = 'camel';
  static const donkey = 'donkey';
  static const mule = 'mule';
  static const elephant = 'elephant';
  static const horseDraft = 'horse_draft';
  static const horseRiding = 'horse_riding';
  static const mastiff = 'mastiff';
  static const pony = 'pony';
  static const warhorse = 'warhorse';
}

class MountGearIds {
  static const barding = 'barding';
  static const saddlebags = 'saddlebags';
  static const bitAndBridle = 'bit_and_bridle';
  static const feedPerDay = 'feed_per_day';
  static const packSaddle = 'pack_saddle';
  static const ridingSaddle = 'riding_saddle';
  static const exoticSaddle = 'exotic_saddle';
  static const militarySaddle = 'military_saddle';
  static const stablingPerDay = 'stabling_per_day';
}

class VehicleIds {
  static const chariot = 'chariot';
  static const cart = EquipmentIds.cart;
  static const wagon = 'wagon';
  static const carriage = 'carriage';
  static const sled = 'sled';

  static const rowboat = 'rowboat';
  static const keelboat = 'keelboat';
  static const galley = 'galley';
  static const sailingShip = 'sailing_ship';
  static const warship = 'warship';
  static const longship = 'longship';
}

const mountDefinitions = <String, MountDefinition>{
  MountIds.camel: MountDefinition(
    id: MountIds.camel,
    name: 'Cammello',
    cost: 50,
    speedMeters: 15,
    carryingCapacityKg: 240,
  ),
  MountIds.donkey: MountDefinition(
    id: MountIds.donkey,
    name: 'Asino',
    cost: 8,
    speedMeters: 12,
    carryingCapacityKg: 210,
  ),
  MountIds.mule: MountDefinition(
    id: MountIds.mule,
    name: 'Mulo',
    cost: 8,
    speedMeters: 12,
    carryingCapacityKg: 210,
  ),
  MountIds.elephant: MountDefinition(
    id: MountIds.elephant,
    name: 'Elefante',
    cost: 200,
    speedMeters: 12,
    carryingCapacityKg: 660,
  ),
  MountIds.horseDraft: MountDefinition(
    id: MountIds.horseDraft,
    name: 'Cavallo da Tiro',
    cost: 50,
    speedMeters: 12,
    carryingCapacityKg: 270,
  ),
  MountIds.horseRiding: MountDefinition(
    id: MountIds.horseRiding,
    name: 'Cavallo da Galoppo',
    cost: 75,
    speedMeters: 18,
    carryingCapacityKg: 240,
  ),
  MountIds.mastiff: MountDefinition(
    id: MountIds.mastiff,
    name: 'Mastino',
    cost: 25,
    speedMeters: 12,
    carryingCapacityKg: 97.5,
  ),
  MountIds.pony: MountDefinition(
    id: MountIds.pony,
    name: 'Pony',
    cost: 30,
    speedMeters: 12,
    carryingCapacityKg: 112.5,
  ),
  MountIds.warhorse: MountDefinition(
    id: MountIds.warhorse,
    name: 'Cavallo da Guerra',
    cost: 400,
    speedMeters: 18,
    carryingCapacityKg: 270,
  ),
};

const mountGearDefinitions = <String, MountGearDefinition>{
  MountGearIds.barding: MountGearDefinition(
    id: MountGearIds.barding,
    name: 'Bardatura',
    category: MountGearCategory.barding,
    costMultiplier: 4,
    weightMultiplier: 2,
  ),
  MountGearIds.saddlebags: MountGearDefinition(
    id: MountGearIds.saddlebags,
    name: 'Bisacce',
    category: MountGearCategory.saddlebags,
    cost: 4,
    weightKg: 4,
  ),
  MountGearIds.bitAndBridle: MountGearDefinition(
    id: MountGearIds.bitAndBridle,
    name: 'Morso e Briglie',
    category: MountGearCategory.bitAndBridle,
    cost: 2,
    weightKg: 0.5,
  ),
  MountGearIds.feedPerDay: MountGearDefinition(
    id: MountGearIds.feedPerDay,
    name: 'Nutrimento per Cavalcatura',
    category: MountGearCategory.feed,
    cost: 5,
    currency: 'cp',
    weightKg: 5,
    dailyCost: true,
  ),
  MountGearIds.packSaddle: MountGearDefinition(
    id: MountGearIds.packSaddle,
    name: 'Sella da Carico',
    category: MountGearCategory.saddle,
    cost: 5,
    weightKg: 7.5,
  ),
  MountGearIds.ridingSaddle: MountGearDefinition(
    id: MountGearIds.ridingSaddle,
    name: 'Sella da Galoppo',
    category: MountGearCategory.saddle,
    cost: 10,
    weightKg: 12.5,
  ),
  MountGearIds.exoticSaddle: MountGearDefinition(
    id: MountGearIds.exoticSaddle,
    name: 'Sella Esotica',
    category: MountGearCategory.saddle,
    cost: 60,
    weightKg: 20,
  ),
  MountGearIds.militarySaddle: MountGearDefinition(
    id: MountGearIds.militarySaddle,
    name: 'Sella Militare',
    category: MountGearCategory.saddle,
    cost: 20,
    weightKg: 15,
  ),
  MountGearIds.stablingPerDay: MountGearDefinition(
    id: MountGearIds.stablingPerDay,
    name: 'Stallaggio',
    category: MountGearCategory.service,
    cost: 5,
    currency: 'sp',
    dailyCost: true,
  ),
};

const vehicleDefinitions = <String, VehicleDefinition>{
  VehicleIds.chariot: VehicleDefinition(
    id: VehicleIds.chariot,
    name: 'Biga',
    category: VehicleCategory.land,
    cost: 250,
    weightKg: 50,
    requiresDraftAnimal: true,
    draftCapacityMultiplier: 5,
  ),
  VehicleIds.cart: VehicleDefinition(
    id: VehicleIds.cart,
    name: 'Carretto',
    category: VehicleCategory.land,
    cost: 15,
    weightKg: 100,
    requiresDraftAnimal: true,
    draftCapacityMultiplier: 5,
  ),
  VehicleIds.wagon: VehicleDefinition(
    id: VehicleIds.wagon,
    name: 'Carro',
    category: VehicleCategory.land,
    cost: 35,
    weightKg: 200,
    requiresDraftAnimal: true,
    draftCapacityMultiplier: 5,
  ),
  VehicleIds.carriage: VehicleDefinition(
    id: VehicleIds.carriage,
    name: 'Carrozza',
    category: VehicleCategory.land,
    cost: 100,
    weightKg: 300,
    requiresDraftAnimal: true,
    draftCapacityMultiplier: 5,
  ),
  VehicleIds.sled: VehicleDefinition(
    id: VehicleIds.sled,
    name: 'Slitta',
    category: VehicleCategory.land,
    cost: 20,
    weightKg: 150,
    requiresDraftAnimal: true,
    draftCapacityMultiplier: 5,
  ),
  VehicleIds.rowboat: VehicleDefinition(
    id: VehicleIds.rowboat,
    name: 'Barca a Remi',
    category: VehicleCategory.water,
    cost: 50,
    weightKg: 50,
    speedKmh: 2.25,
  ),
  VehicleIds.keelboat: VehicleDefinition(
    id: VehicleIds.keelboat,
    name: 'Barcone',
    category: VehicleCategory.water,
    cost: 3000,
    speedKmh: 1.5,
  ),
  VehicleIds.galley: VehicleDefinition(
    id: VehicleIds.galley,
    name: 'Galea',
    category: VehicleCategory.water,
    cost: 30000,
    speedKmh: 6,
  ),
  VehicleIds.sailingShip: VehicleDefinition(
    id: VehicleIds.sailingShip,
    name: 'Nave a Vela',
    category: VehicleCategory.water,
    cost: 10000,
    speedKmh: 3,
  ),
  VehicleIds.warship: VehicleDefinition(
    id: VehicleIds.warship,
    name: 'Nave da Guerra',
    category: VehicleCategory.water,
    cost: 25000,
    speedKmh: 3.75,
  ),
  VehicleIds.longship: VehicleDefinition(
    id: VehicleIds.longship,
    name: 'Nave Lunga',
    category: VehicleCategory.water,
    cost: 10000,
    speedKmh: 4.5,
  ),
};
