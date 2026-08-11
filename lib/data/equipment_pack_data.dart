import 'equipment_data.dart';

class EquipmentPackItem {
  final String itemId;
  final int quantity;

  const EquipmentPackItem({
    required this.itemId,
    this.quantity = 1,
  });
}

class EquipmentPackDefinition {
  final String id;
  final String name;
  final List<EquipmentPackItem> items;
  final int gold;

  const EquipmentPackDefinition({
    required this.id,
    required this.name,
    required this.items,
    this.gold = 0,
  });
}

class EquipmentPackIds {
  static const burglar = "burglar_pack";
  static const diplomat = "diplomat_pack";
  static const dungeoneer = "dungeoneer_pack";
  static const entertainer = "entertainer_pack";
  static const explorer = "explorer_pack";
  static const priest = "priest_pack";
  static const scholar = "scholar_pack";
}

const _entertainerPack = EquipmentPackDefinition(
  id: EquipmentPackIds.entertainer,
  name: "Entertainer's Pack",
  items: [
    EquipmentPackItem(itemId: EquipmentIds.backpack),
    EquipmentPackItem(itemId: EquipmentIds.bedroll),
    EquipmentPackItem(itemId: EquipmentIds.costume, quantity: 2),
    EquipmentPackItem(itemId: EquipmentIds.candle, quantity: 5),
    EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 5),
    EquipmentPackItem(itemId: EquipmentIds.waterskin),
  ],
);

const equipmentPackDefinitions = <String, EquipmentPackDefinition>{
  EquipmentPackIds.explorer: EquipmentPackDefinition(
    id: EquipmentPackIds.explorer,
    name: "Explorer's Pack",
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.bedroll),
      EquipmentPackItem(itemId: EquipmentIds.messKit),
      EquipmentPackItem(itemId: EquipmentIds.tinderbox),
      EquipmentPackItem(itemId: EquipmentIds.torch, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.waterskin),
      EquipmentPackItem(itemId: EquipmentIds.hempenRope),
    ],
  ),
  EquipmentPackIds.burglar: EquipmentPackDefinition(
    id: EquipmentPackIds.burglar,
    name: "Burglar's Pack",
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.ballBearings, quantity: 1000),
      EquipmentPackItem(itemId: EquipmentIds.string, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.bell),
      EquipmentPackItem(itemId: EquipmentIds.candle, quantity: 5),
      EquipmentPackItem(itemId: EquipmentIds.crowbar),
      EquipmentPackItem(itemId: EquipmentIds.hammer),
      EquipmentPackItem(itemId: EquipmentIds.piton, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.hoodedLantern),
      EquipmentPackItem(itemId: EquipmentIds.flaskOfOil, quantity: 2),
      EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 5),
      EquipmentPackItem(itemId: EquipmentIds.tinderbox),
      EquipmentPackItem(itemId: EquipmentIds.waterskin),
      EquipmentPackItem(itemId: EquipmentIds.hempenRope),
    ],
  ),
  EquipmentPackIds.dungeoneer: EquipmentPackDefinition(
    id: EquipmentPackIds.dungeoneer,
    name: "Dungeoneer's Pack",
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.crowbar),
      EquipmentPackItem(itemId: EquipmentIds.hammer),
      EquipmentPackItem(itemId: EquipmentIds.piton, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.torch, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.tinderbox),
      EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.waterskin),
      EquipmentPackItem(itemId: EquipmentIds.hempenRope),
    ],
  ),
  EquipmentPackIds.entertainer: _entertainerPack,
  EquipmentPackIds.priest: EquipmentPackDefinition(
    id: EquipmentPackIds.priest,
    name: "Priest's Pack",
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.blanket),
      EquipmentPackItem(itemId: EquipmentIds.candle, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.tinderbox),
      EquipmentPackItem(itemId: EquipmentIds.almsBox),
      EquipmentPackItem(itemId: EquipmentIds.incense, quantity: 2),
      EquipmentPackItem(itemId: EquipmentIds.censer),
      EquipmentPackItem(itemId: EquipmentIds.robes),
      EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 2),
      EquipmentPackItem(itemId: EquipmentIds.waterskin),
    ],
  ),
};
