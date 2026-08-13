import 'package:dnd_character_sheet/data/ammunition_data.dart';
import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:dnd_character_sheet/data/mount_data.dart';
import 'package:dnd_character_sheet/data/service_data.dart';
import 'package:dnd_character_sheet/data/shop_catalog.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:dnd_character_sheet/data/trade_good_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unified shop catalog has unique stable ids', () {
    final ids = shopCatalog.map((entry) => entry.id).toList();

    expect(ids.toSet().length, ids.length);
    expect(ids.every((id) => id.contains(':')), isTrue);
  });

  test('unified catalog covers every purchasable source registry', () {
    expect(
      shopEntriesFor(ShopCategory.ammunition).length,
      ammunitionDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.weapons).length,
      weaponDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.armor).length,
      armorDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.focuses).length,
      focusDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.equipmentPacks).length,
      equipmentPackDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.mounts).length,
      mountDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.mountGear).length,
      mountGearDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.vehicles).length,
      vehicleDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.tradeGoods).length,
      tradeGoodDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.services).length,
      serviceDefinitions.length,
    );
    expect(
      shopEntriesFor(ShopCategory.lodging).length,
      lodgingDefinitions.length,
    );

    final expectedEquipment =
        equipmentDefinitions.values.where((item) => item.cost > 0).length;
    final expectedTools = toolDefinitions.values
        .where(
          (item) => item.category != ToolCategory.vehicle && item.cost > 0,
        )
        .length;

    expect(
      shopEntriesFor(ShopCategory.adventuringGear).length,
      expectedEquipment,
    );
    expect(shopEntriesFor(ShopCategory.tools).length, expectedTools);
  });

  test('fixed shop entries always have valid prices', () {
    final errors = <String>[];

    for (final entry in shopCatalog.where((entry) => entry.hasFixedPrice)) {
      if (entry.cost == null || entry.cost! < 0) {
        errors.add('${entry.id}: costo non valido');
      }
      if (!{'cp', 'sp', 'ep', 'gp', 'pp'}.contains(entry.currency)) {
        errors.add('${entry.id}: valuta non valida');
      }
      if (entry.name.trim().isEmpty) {
        errors.add('${entry.id}: nome vuoto');
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('ammunition purchases grant the complete PHB bundle', () {
    for (final ammunition in ammunitionDefinitions.values) {
      final entry = shopCatalog.singleWhere((candidate) =>
          candidate.catalogId == 'ammunition' &&
          candidate.itemId == ammunition.id);

      expect(entry.grantedQuantity, ammunition.bundleSize);
    }
  });

  test('services and lodgings never enter the inventory', () {
    final nonInventoryEntries = shopCatalog.where(
      (entry) =>
          entry.category == ShopCategory.services ||
          entry.category == ShopCategory.lodging,
    );

    expect(nonInventoryEntries.every((entry) => !entry.addToInventory), isTrue);
  });

  test('lodging keeps PHB reference prices but requires the DM price', () {
    final lodgings = shopEntriesFor(ShopCategory.lodging).toList();

    expect(lodgings.length, 6);
    expect(
      lodgings.every(
        (entry) =>
            entry.pricingMode == ShopPricingMode.dmDetermined &&
            entry.cost == null &&
            entry.referenceCost != null &&
            entry.referenceCurrency != null,
      ),
      isTrue,
    );
  });
}
