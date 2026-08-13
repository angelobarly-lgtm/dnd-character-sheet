enum ItemCategory {
  weapon,
  armor,
  shield,
  tool,
  focus,
  ammunition,
  equipment,
  mount,
  vehicle,
  tradeGood,
  service,
  magicItem,
}

abstract class ItemDefinition {
  final String id;
  final String name;

  final ItemCategory category;

  final double weightKg;

  final int cost;
  final String currency;

  const ItemDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.weightKg,
    required this.cost,
    this.currency = 'gp',
  });
}

abstract class ItemCatalog<T extends ItemDefinition> {
  const ItemCatalog();

  Map<String, T> get definitions;
}

class ItemRegistry {
  const ItemRegistry._();

  static final Map<String, ItemDefinition> _items = {};

  static void registerAll(Map<String, ItemDefinition> items) {
    _items.addAll(items);
  }

  static ItemDefinition? byId(String id) => _items[id];

  static bool contains(String id) => _items.containsKey(id);

  static Iterable<ItemDefinition> get all => _items.values;

  static int get count => _items.length;

  static void clear() => _items.clear();
}
