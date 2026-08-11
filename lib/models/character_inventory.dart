class InventoryEntry {
  final String itemId;

  int quantity;

  bool equipped;

  String? containerId;

  InventoryEntry({
    required this.itemId,
    this.quantity = 1,
    this.equipped = false,
    this.containerId,
  });
}

class CharacterInventory {
  final List<InventoryEntry> items;

  CharacterInventory({
    List<InventoryEntry>? items,
  }) : items = items ?? [];

  bool get isEmpty => items.isEmpty;

  int get length => items.length;

  void addItem(InventoryEntry item) {
    items.add(item);
  }

  bool removeItem(String itemId) {
    final index = items.indexWhere((e) => e.itemId == itemId);
    if (index == -1) return false;
    items.removeAt(index);
    return true;
  }

  InventoryEntry? find(String itemId) {
    for (final item in items) {
      if (item.itemId == itemId) return item;
    }
    return null;
  }

  bool contains(String itemId) => find(itemId) != null;
}
