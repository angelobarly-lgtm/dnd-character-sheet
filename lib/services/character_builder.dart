import '../models/character_inventory.dart';
import 'equipment_generator.dart';

class CharacterBuilder {
  final EquipmentGenerator equipmentGenerator;

  const CharacterBuilder({
    this.equipmentGenerator = const EquipmentGenerator(),
  });

  CharacterInventory buildInventory({
    Iterable<InventoryEntry> items = const [],
  }) {
    return equipmentGenerator.generate(
      items: items,
    );
  }

  List<Map<String, dynamic>> buildLegacyInventory({
    Iterable<InventoryEntry> items = const [],
  }) {
    final inventory = buildInventory(items: items);

    return inventory.items
        .map(
          (e) => {
            'id': e.itemId,
            'name': e.itemId,
            'quantity': e.quantity,
            'equipped': e.equipped,
          },
        )
        .toList();
  }
}
