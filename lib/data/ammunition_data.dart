enum AmmunitionCategory {
  arrow,
  bolt,
  slingBullet,
  blowgunNeedle,
}

class AmmunitionDefinition {
  final String id;
  final String name;
  final AmmunitionCategory category;
  final int bundleSize;
  final int cost;
  final String currency;
  final double weightKg;

  const AmmunitionDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.bundleSize,
    required this.cost,
    required this.currency,
    required this.weightKg,
  });
}

class AmmunitionIds {
  static const arrows = 'arrows';
  static const crossbowBolts = 'crossbow_bolts';
  static const slingBullets = 'sling_bullets';
  static const blowgunNeedles = 'blowgun_needles';
}

final ammunitionDefinitions = <String, AmmunitionDefinition>{
  AmmunitionIds.arrows: const AmmunitionDefinition(
    id: AmmunitionIds.arrows,
    name: "Frecce (20)",
    category: AmmunitionCategory.arrow,
    bundleSize: 20,
    cost: 1,
    currency: "gp",
    weightKg: 0.5,
  ),
  AmmunitionIds.crossbowBolts: const AmmunitionDefinition(
    id: AmmunitionIds.crossbowBolts,
    name: "Quadrelli (20)",
    category: AmmunitionCategory.bolt,
    bundleSize: 20,
    cost: 1,
    currency: "gp",
    weightKg: 0.75,
  ),
  AmmunitionIds.slingBullets: const AmmunitionDefinition(
    id: AmmunitionIds.slingBullets,
    name: "Proiettili per Fionda (20)",
    category: AmmunitionCategory.slingBullet,
    bundleSize: 20,
    cost: 4,
    currency: "cp",
    weightKg: 0.75,
  ),
  AmmunitionIds.blowgunNeedles: const AmmunitionDefinition(
    id: AmmunitionIds.blowgunNeedles,
    name: "Aghi per Cerbottana (50)",
    category: AmmunitionCategory.blowgunNeedle,
    bundleSize: 50,
    cost: 1,
    currency: "gp",
    weightKg: 0.5,
  ),
};
