import 'equipment_data.dart';
import 'tool_data.dart';

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
  final int cost;
  final String currency;

  const EquipmentPackDefinition({
    required this.id,
    required this.name,
    required this.items,
    required this.cost,
    this.currency = 'gp',
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
  cost: 40,
  items: [
    EquipmentPackItem(itemId: EquipmentIds.backpack),
    EquipmentPackItem(itemId: EquipmentIds.bedroll),
    EquipmentPackItem(itemId: EquipmentIds.costume, quantity: 2),
    EquipmentPackItem(itemId: EquipmentIds.candle, quantity: 5),
    EquipmentPackItem(itemId: EquipmentIds.rations, quantity: 5),
    EquipmentPackItem(itemId: EquipmentIds.waterskin),
    EquipmentPackItem(itemId: ToolIds.disguiseKit),
  ],
);

const equipmentPackDefinitions = <String, EquipmentPackDefinition>{
  EquipmentPackIds.explorer: EquipmentPackDefinition(
    id: EquipmentPackIds.explorer,
    name: "Explorer's Pack",
    cost: 10,
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
    cost: 16,
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.ballBearings),
      EquipmentPackItem(itemId: EquipmentIds.string),
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
    cost: 12,
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
    cost: 19,
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
  EquipmentPackIds.diplomat: EquipmentPackDefinition(
    id: EquipmentPackIds.diplomat,
    name: "Dotazione da Diplomatico",
    cost: 39,
    items: [
      EquipmentPackItem(itemId: EquipmentIds.chest),
      EquipmentPackItem(itemId: EquipmentIds.scrollCase, quantity: 2),
      EquipmentPackItem(itemId: EquipmentIds.fineClothes),
      EquipmentPackItem(itemId: EquipmentIds.ink),
      EquipmentPackItem(itemId: EquipmentIds.inkPen),
      EquipmentPackItem(itemId: EquipmentIds.lamp),
      EquipmentPackItem(itemId: EquipmentIds.flaskOfOil, quantity: 2),
      EquipmentPackItem(itemId: EquipmentIds.paper, quantity: 5),
      EquipmentPackItem(itemId: EquipmentIds.perfume),
      EquipmentPackItem(itemId: EquipmentIds.sealingWax),
      EquipmentPackItem(itemId: EquipmentIds.soap),
    ],
  ),
  EquipmentPackIds.scholar: EquipmentPackDefinition(
    id: EquipmentPackIds.scholar,
    name: "Dotazione da Studioso",
    cost: 40,
    items: [
      EquipmentPackItem(itemId: EquipmentIds.backpack),
      EquipmentPackItem(itemId: EquipmentIds.book),
      EquipmentPackItem(itemId: EquipmentIds.ink),
      EquipmentPackItem(itemId: EquipmentIds.inkPen),
      EquipmentPackItem(itemId: EquipmentIds.parchment, quantity: 10),
      EquipmentPackItem(itemId: EquipmentIds.scholarSandBag),
      EquipmentPackItem(itemId: EquipmentIds.scholarSmallKnife),
    ],
  ),
};
