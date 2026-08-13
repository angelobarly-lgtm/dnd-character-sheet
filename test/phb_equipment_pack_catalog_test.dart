import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

const phbPackCosts = <String, int>{
  EquipmentPackIds.burglar: 16,
  EquipmentPackIds.diplomat: 39,
  EquipmentPackIds.dungeoneer: 12,
  EquipmentPackIds.entertainer: 40,
  EquipmentPackIds.explorer: 10,
  EquipmentPackIds.priest: 19,
  EquipmentPackIds.scholar: 40,
};

const expectedPackContents = <String, Map<String, int>>{
  EquipmentPackIds.burglar: {
    EquipmentIds.backpack: 1,
    EquipmentIds.ballBearings: 1,
    EquipmentIds.string: 1,
    EquipmentIds.bell: 1,
    EquipmentIds.candle: 5,
    EquipmentIds.crowbar: 1,
    EquipmentIds.hammer: 1,
    EquipmentIds.piton: 10,
    EquipmentIds.hoodedLantern: 1,
    EquipmentIds.flaskOfOil: 2,
    EquipmentIds.rations: 5,
    EquipmentIds.tinderbox: 1,
    EquipmentIds.waterskin: 1,
    EquipmentIds.hempenRope: 1,
  },
  EquipmentPackIds.diplomat: {
    EquipmentIds.chest: 1,
    EquipmentIds.scrollCase: 2,
    EquipmentIds.fineClothes: 1,
    EquipmentIds.ink: 1,
    EquipmentIds.inkPen: 1,
    EquipmentIds.lamp: 1,
    EquipmentIds.flaskOfOil: 2,
    EquipmentIds.paper: 5,
    EquipmentIds.perfume: 1,
    EquipmentIds.sealingWax: 1,
    EquipmentIds.soap: 1,
  },
  EquipmentPackIds.dungeoneer: {
    EquipmentIds.backpack: 1,
    EquipmentIds.crowbar: 1,
    EquipmentIds.hammer: 1,
    EquipmentIds.piton: 10,
    EquipmentIds.torch: 10,
    EquipmentIds.tinderbox: 1,
    EquipmentIds.rations: 10,
    EquipmentIds.waterskin: 1,
    EquipmentIds.hempenRope: 1,
  },
  EquipmentPackIds.entertainer: {
    EquipmentIds.backpack: 1,
    EquipmentIds.bedroll: 1,
    EquipmentIds.costume: 2,
    EquipmentIds.candle: 5,
    EquipmentIds.rations: 5,
    EquipmentIds.waterskin: 1,
    ToolIds.disguiseKit: 1,
  },
  EquipmentPackIds.explorer: {
    EquipmentIds.backpack: 1,
    EquipmentIds.bedroll: 1,
    EquipmentIds.messKit: 1,
    EquipmentIds.tinderbox: 1,
    EquipmentIds.torch: 10,
    EquipmentIds.rations: 10,
    EquipmentIds.waterskin: 1,
    EquipmentIds.hempenRope: 1,
  },
  EquipmentPackIds.priest: {
    EquipmentIds.backpack: 1,
    EquipmentIds.blanket: 1,
    EquipmentIds.candle: 10,
    EquipmentIds.tinderbox: 1,
    EquipmentIds.almsBox: 1,
    EquipmentIds.incense: 2,
    EquipmentIds.censer: 1,
    EquipmentIds.robes: 1,
    EquipmentIds.rations: 2,
    EquipmentIds.waterskin: 1,
  },
  EquipmentPackIds.scholar: {
    EquipmentIds.backpack: 1,
    EquipmentIds.book: 1,
    EquipmentIds.ink: 1,
    EquipmentIds.inkPen: 1,
    EquipmentIds.parchment: 10,
    EquipmentIds.scholarSandBag: 1,
    EquipmentIds.scholarSmallKnife: 1,
  },
};

void main() {
  test('PHB equipment pack registry contains all seven packs', () {
    expect(phbPackCosts.length, 7);
    expect(expectedPackContents.length, 7);
    expect(equipmentPackDefinitions.length, 7);
    expect(
      equipmentPackDefinitions.keys.toSet(),
      phbPackCosts.keys.toSet(),
    );
  });

  test('PHB equipment pack prices match the manual', () {
    for (final entry in phbPackCosts.entries) {
      final pack = equipmentPackDefinitions[entry.key];

      expect(pack, isNotNull, reason: 'Dotazione mancante: ${entry.key}');
      expect(pack!.cost, entry.value, reason: 'Costo errato: ${entry.key}');
      expect(pack.currency, 'gp');
    }
  });

  test('PHB equipment pack contents and quantities are exact', () {
    for (final entry in expectedPackContents.entries) {
      final pack = equipmentPackDefinitions[entry.key]!;
      final actual = <String, int>{};

      for (final item in pack.items) {
        expect(item.quantity, greaterThan(0));
        actual.update(
          item.itemId,
          (quantity) => quantity + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }

      expect(actual, entry.value, reason: 'Contenuto errato: ${entry.key}');
    }
  });

  test('every equipment pack item resolves to a known catalog entry', () {
    for (final pack in equipmentPackDefinitions.values) {
      for (final item in pack.items) {
        final resolved = equipmentDefinitions.containsKey(item.itemId) ||
            toolDefinitions.containsKey(item.itemId);

        expect(
          resolved,
          isTrue,
          reason: '${pack.id}: oggetto sconosciuto ${item.itemId}',
        );
      }
    }
  });

  test('scholar accessories are distinct from the urchin knife', () {
    expect(
      EquipmentIds.scholarSmallKnife,
      isNot(EquipmentIds.urchinSmallKnife),
    );
    expect(
      equipmentDefinitions[EquipmentIds.scholarSandBag]!.ruleTags,
      contains('not_sold_separately'),
    );
    expect(
      equipmentDefinitions[EquipmentIds.scholarSmallKnife]!.ruleTags,
      contains('not_sold_separately'),
    );
  });
}
