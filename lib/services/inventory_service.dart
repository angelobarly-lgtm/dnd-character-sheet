import '../models/character_inventory.dart';

class InventoryService {
  const InventoryService();

  void addItem(
    CharacterInventory inventory,
    InventoryEntry entry,
  ) {
    final existing = inventory.find(entry.itemId);

    if (existing != null) {
      existing.quantity += entry.quantity;
      return;
    }

    inventory.addItem(entry);
  }

  bool removeItem(
    CharacterInventory inventory,
    String itemId, {
    int quantity = 1,
  }) {
    final entry = inventory.find(itemId);

    if (entry == null) {
      return false;
    }

    if (entry.quantity > quantity) {
      entry.quantity -= quantity;
      return true;
    }

    inventory.removeItem(itemId);
    return true;
  }

  bool equip(
    CharacterInventory inventory,
    String itemId,
  ) {
    final entry = inventory.find(itemId);

    if (entry == null) {
      return false;
    }

    entry.equipped = true;
    return true;
  }

  bool unequip(
    CharacterInventory inventory,
    String itemId,
  ) {
    final entry = inventory.find(itemId);

    if (entry == null) {
      return false;
    }

    entry.equipped = false;
    return true;
  }
}
