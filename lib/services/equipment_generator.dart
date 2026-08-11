import '../models/character_inventory.dart';
import 'inventory_service.dart';

class EquipmentGenerator {
  final InventoryService _inventoryService;

  const EquipmentGenerator({
    InventoryService inventoryService = const InventoryService(),
  }) : _inventoryService = inventoryService;

  CharacterInventory generate({
    Iterable<InventoryEntry> items = const [],
  }) {
    final inventory = CharacterInventory();

    for (final item in items) {
      _inventoryService.addItem(inventory, item);
    }

    return inventory;
  }
}
