enum FocusCategory {
  arcane,
  druidic,
  holy,
  componentPouch,
}

class FocusDefinition {
  final String id;
  final String name;
  final FocusCategory category;
  final double weightKg;
  final int cost;
  final String currency;

  const FocusDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.weightKg,
    required this.cost,
    this.currency = 'gp',
  });
}

class FocusIds {
  // Arcane Focus
  static const crystal = 'crystal';
  static const orb = 'orb';
  static const rod = 'rod';
  static const staff = 'staff_focus';
  static const wand = 'wand';

  // Druidic Focus
  static const sprigOfMistletoe = 'sprig_of_mistletoe';
  static const totem = 'totem';
  static const woodenStaff = 'wooden_staff';
  static const yewWand = 'yew_wand';

  // Holy Symbols
  static const amulet = 'amulet';
  static const emblem = 'emblem';
  static const reliquary = 'reliquary';

  // Component Pouch
  static const componentPouch = 'component_pouch';
}

final focusDefinitions = <String, FocusDefinition>{
  FocusIds.crystal: const FocusDefinition(
    id: FocusIds.crystal,
    name: "Cristallo",
    category: FocusCategory.arcane,
    weightKg: 0.5,
    cost: 10,
  ),
  FocusIds.orb: const FocusDefinition(
    id: FocusIds.orb,
    name: "Sfera",
    category: FocusCategory.arcane,
    weightKg: 1.5,
    cost: 20,
  ),
  FocusIds.rod: const FocusDefinition(
    id: FocusIds.rod,
    name: "Verga",
    category: FocusCategory.arcane,
    weightKg: 1,
    cost: 10,
  ),
  FocusIds.staff: const FocusDefinition(
    id: FocusIds.staff,
    name: "Bastone Arcano",
    category: FocusCategory.arcane,
    weightKg: 2,
    cost: 5,
  ),
  FocusIds.wand: const FocusDefinition(
    id: FocusIds.wand,
    name: "Bacchetta",
    category: FocusCategory.arcane,
    weightKg: 0.5,
    cost: 10,
  ),
  FocusIds.sprigOfMistletoe: const FocusDefinition(
    id: FocusIds.sprigOfMistletoe,
    name: "Rametto di Vischio",
    category: FocusCategory.druidic,
    weightKg: 0,
    cost: 1,
  ),
  FocusIds.totem: const FocusDefinition(
    id: FocusIds.totem,
    name: "Totem",
    category: FocusCategory.druidic,
    weightKg: 0,
    cost: 1,
  ),
  FocusIds.woodenStaff: const FocusDefinition(
    id: FocusIds.woodenStaff,
    name: "Bastone di Legno",
    category: FocusCategory.druidic,
    weightKg: 2,
    cost: 5,
  ),
  FocusIds.yewWand: const FocusDefinition(
    id: FocusIds.yewWand,
    name: "Bacchetta di Tasso",
    category: FocusCategory.druidic,
    weightKg: 0.5,
    cost: 10,
  ),
  FocusIds.amulet: const FocusDefinition(
    id: FocusIds.amulet,
    name: "Amuleto",
    category: FocusCategory.holy,
    weightKg: 0.5,
    cost: 5,
  ),
  FocusIds.emblem: const FocusDefinition(
    id: FocusIds.emblem,
    name: "Emblema Sacro",
    category: FocusCategory.holy,
    weightKg: 0,
    cost: 5,
  ),
  FocusIds.reliquary: const FocusDefinition(
    id: FocusIds.reliquary,
    name: "Reliquiario",
    category: FocusCategory.holy,
    weightKg: 1,
    cost: 5,
  ),
  FocusIds.componentPouch: const FocusDefinition(
    id: FocusIds.componentPouch,
    name: "Borsa dei Componenti",
    category: FocusCategory.componentPouch,
    weightKg: 1,
    cost: 25,
  ),
};
