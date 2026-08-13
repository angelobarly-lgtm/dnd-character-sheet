import 'ammunition_data.dart';
import 'armor_data.dart';
import 'equipment_data.dart';
import 'equipment_pack_data.dart';
import 'focus_data.dart';
import 'mount_data.dart';
import 'service_data.dart';
import 'tool_data.dart';
import 'trade_good_data.dart';
import 'weapon_data.dart';

enum ShopCategory {
  adventuringGear,
  ammunition,
  weapons,
  armor,
  tools,
  focuses,
  equipmentPacks,
  mounts,
  mountGear,
  vehicles,
  tradeGoods,
  services,
  lodging,
}

enum ShopPricingMode {
  fixed,
  perDay,
  perDistance,
  dmDetermined,
  armorMultiplier,
}

class ShopCatalogEntry {
  final String catalogId;
  final String itemId;
  final String name;
  final ShopCategory category;
  final ShopPricingMode pricingMode;

  /// Prezzo direttamente applicabile.
  final int? cost;
  final String? currency;

  /// Prezzo PHB mostrato solo come riferimento.
  final int? referenceCost;
  final String? referenceCurrency;

  final int? rateDistanceMeters;
  final int costMultiplier;
  final double weightMultiplier;
  final int grantedQuantity;
  final bool addToInventory;

  const ShopCatalogEntry({
    required this.catalogId,
    required this.itemId,
    required this.name,
    required this.category,
    required this.pricingMode,
    this.cost,
    this.currency,
    this.referenceCost,
    this.referenceCurrency,
    this.rateDistanceMeters,
    this.costMultiplier = 1,
    this.weightMultiplier = 1,
    this.grantedQuantity = 1,
    this.addToInventory = true,
  })  : assert(grantedQuantity > 0),
        assert(costMultiplier > 0),
        assert(weightMultiplier > 0);

  String get id => '$catalogId:$itemId';

  bool get hasFixedPrice =>
      cost != null &&
      currency != null &&
      pricingMode != ShopPricingMode.dmDetermined &&
      pricingMode != ShopPricingMode.armorMultiplier;
}

List<ShopCatalogEntry> buildShopCatalog() {
  final entries = <ShopCatalogEntry>[
    for (final item in equipmentDefinitions.values)
      if (item.cost > 0)
        ShopCatalogEntry(
          catalogId: 'equipment',
          itemId: item.id,
          name: item.name,
          category: ShopCategory.adventuringGear,
          pricingMode: ShopPricingMode.fixed,
          cost: item.cost,
          currency: item.currency,
        ),
    for (final item in ammunitionDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'ammunition',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.ammunition,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
        grantedQuantity: item.bundleSize,
      ),
    for (final item in weaponDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'weapon',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.weapons,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in armorDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'armor',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.armor,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in toolDefinitions.values)
      if (item.category != ToolCategory.vehicle && item.cost > 0)
        ShopCatalogEntry(
          catalogId: 'tool',
          itemId: item.id,
          name: item.name,
          category: ShopCategory.tools,
          pricingMode: ShopPricingMode.fixed,
          cost: item.cost,
          currency: item.currency,
        ),
    for (final item in focusDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'focus',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.focuses,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in equipmentPackDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'equipment_pack',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.equipmentPacks,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in mountDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'mount',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.mounts,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in mountGearDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'mount_gear',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.mountGear,
        pricingMode: item.cost == null
            ? ShopPricingMode.armorMultiplier
            : item.dailyCost
                ? ShopPricingMode.perDay
                : ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.cost == null ? null : item.currency,
        costMultiplier: item.costMultiplier,
        weightMultiplier: item.weightMultiplier,
      ),
    for (final item in vehicleDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'vehicle',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.vehicles,
        pricingMode: ShopPricingMode.fixed,
        cost: item.cost,
        currency: item.currency,
      ),
    for (final item in tradeGoodDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'trade_good',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.tradeGoods,
        pricingMode: ShopPricingMode.fixed,
        cost: item.price.amount,
        currency: item.price.currency,
      ),
    for (final item in serviceDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'service',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.services,
        pricingMode: switch (item.pricingMode) {
          ServicePricingMode.fixed => ShopPricingMode.fixed,
          ServicePricingMode.perDistance => ShopPricingMode.perDistance,
          ServicePricingMode.perDay => ShopPricingMode.perDay,
          ServicePricingMode.dmDetermined => ShopPricingMode.dmDetermined,
        },
        cost: item.price?.amount,
        currency: item.price?.currency,
        rateDistanceMeters: item.rateDistanceMeters,
        addToInventory: false,
      ),
    for (final item in lodgingDefinitions.values)
      ShopCatalogEntry(
        catalogId: 'lodging',
        itemId: item.id,
        name: item.name,
        category: ShopCategory.lodging,
        pricingMode: ShopPricingMode.dmDetermined,
        referenceCost: item.referencePrice.amount,
        referenceCurrency: item.referencePrice.currency,
        addToInventory: false,
      ),
  ];

  entries.sort((a, b) {
    final categoryComparison = a.category.index.compareTo(b.category.index);
    if (categoryComparison != 0) {
      return categoryComparison;
    }
    return a.name.compareTo(b.name);
  });

  return List.unmodifiable(entries);
}

final shopCatalog = buildShopCatalog();

Iterable<ShopCatalogEntry> shopEntriesFor(ShopCategory category) =>
    shopCatalog.where((entry) => entry.category == category);
