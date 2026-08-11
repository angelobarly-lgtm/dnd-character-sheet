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

  const FocusDefinition({
    required this.id,
    required this.name,
    required this.category,
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
  ),
  FocusIds.orb: const FocusDefinition(
    id: FocusIds.orb,
    name: "Sfera",
    category: FocusCategory.arcane,
  ),
  FocusIds.rod: const FocusDefinition(
    id: FocusIds.rod,
    name: "Verga",
    category: FocusCategory.arcane,
  ),
  FocusIds.staff: const FocusDefinition(
    id: FocusIds.staff,
    name: "Bastone Arcano",
    category: FocusCategory.arcane,
  ),
  FocusIds.wand: const FocusDefinition(
    id: FocusIds.wand,
    name: "Bacchetta",
    category: FocusCategory.arcane,
  ),
  FocusIds.sprigOfMistletoe: const FocusDefinition(
    id: FocusIds.sprigOfMistletoe,
    name: "Rametto di Vischio",
    category: FocusCategory.druidic,
  ),
  FocusIds.totem: const FocusDefinition(
    id: FocusIds.totem,
    name: "Totem",
    category: FocusCategory.druidic,
  ),
  FocusIds.woodenStaff: const FocusDefinition(
    id: FocusIds.woodenStaff,
    name: "Bastone di Legno",
    category: FocusCategory.druidic,
  ),
  FocusIds.yewWand: const FocusDefinition(
    id: FocusIds.yewWand,
    name: "Bacchetta di Tasso",
    category: FocusCategory.druidic,
  ),
  FocusIds.amulet: const FocusDefinition(
    id: FocusIds.amulet,
    name: "Amuleto",
    category: FocusCategory.holy,
  ),
  FocusIds.emblem: const FocusDefinition(
    id: FocusIds.emblem,
    name: "Emblema Sacro",
    category: FocusCategory.holy,
  ),
  FocusIds.reliquary: const FocusDefinition(
    id: FocusIds.reliquary,
    name: "Reliquiario",
    category: FocusCategory.holy,
  ),
  FocusIds.componentPouch: const FocusDefinition(
    id: FocusIds.componentPouch,
    name: "Borsa dei Componenti",
    category: FocusCategory.componentPouch,
  ),
};
