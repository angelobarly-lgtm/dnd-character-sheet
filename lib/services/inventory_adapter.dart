import '../models/character_inventory.dart';

class InventoryAdapter {
  const InventoryAdapter();

  CharacterInventory fromLegacy(List<Map<String, dynamic>> legacy) {
    final inventory = CharacterInventory();

    for (final item in legacy) {
      inventory.addItem(
        InventoryEntry(
          itemId: item['id']?.toString() ?? item['name'].toString(),
          quantity: item['quantity'] ?? 1,
        ),
      );
    }

    return inventory;
  }

  List<Map<String, dynamic>> toLegacy(CharacterInventory inventory) {
    return inventory.items
        .map((e) => {
              'id': e.itemId,
              'quantity': e.quantity,
            })
        .toList();
  }
}
