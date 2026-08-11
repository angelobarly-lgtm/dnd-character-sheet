import 'item_data.dart';
import 'equipment_data.dart';
import 'armor_data.dart';
import 'weapon_data.dart';

class GameDatabase {
  static bool _initialized = false;

  static bool get initialized => _initialized;

  static void initialize() {
    if (_initialized) return;

    ItemRegistry.clear();

    ItemRegistry.registerAll(
      equipmentDefinitions.cast<String, ItemDefinition>(),
    );

    ItemRegistry.registerAll(
      weaponDefinitions.cast<String, ItemDefinition>(),
    );

    ItemRegistry.registerAll(
      armorDefinitions.cast<String, ItemDefinition>(),
    );

    _initialized = true;
  }

  static void reset() {
    _initialized = false;
    ItemRegistry.clear();
  }
}
