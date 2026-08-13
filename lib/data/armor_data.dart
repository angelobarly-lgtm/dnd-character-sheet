enum ArmorCategory {
  light,
  medium,
  heavy,
  shield,
}

class ArmorDefinition {
  final String id;
  final String name;

  final ArmorCategory category;

  final int armorClass;
  final bool addDexterity;
  final int? maxDexterityBonus;

  final int strengthRequirement;

  final bool stealthDisadvantage;

  final double weightKg;

  final int cost;

  final String currency;

  const ArmorDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.armorClass,
    required this.addDexterity,
    this.maxDexterityBonus,
    this.strengthRequirement = 0,
    this.stealthDisadvantage = false,
    required this.weightKg,
    required this.cost,
    required this.currency,
  });
}

class ArmorIds {
  static const padded = 'padded';
  static const leather = 'leather';
  static const studdedLeather = 'studded_leather';

  static const hide = 'hide';
  static const chainShirt = 'chain_shirt';
  static const scaleMail = 'scale_mail';
  static const breastplate = 'breastplate';
  static const halfPlate = 'half_plate';

  static const ringMail = 'ring_mail';
  static const chainMail = 'chain_mail';
  static const splint = 'splint';
  static const plate = 'plate';

  static const shield = 'shield';
}

final armorDefinitions = <String, ArmorDefinition>{
  ArmorIds.padded: ArmorDefinition(
    id: ArmorIds.padded,
    name: 'Armatura Imbottita',
    category: ArmorCategory.light,
    armorClass: 11,
    addDexterity: true,
    stealthDisadvantage: true,
    weightKg: 4,
    cost: 5,
    currency: 'gp',
  ),
  ArmorIds.leather: ArmorDefinition(
    id: ArmorIds.leather,
    name: 'Armatura di Cuoio',
    category: ArmorCategory.light,
    armorClass: 11,
    addDexterity: true,
    weightKg: 5,
    cost: 10,
    currency: 'gp',
  ),
  ArmorIds.studdedLeather: ArmorDefinition(
    id: ArmorIds.studdedLeather,
    name: 'Armatura di Cuoio Borchiato',
    category: ArmorCategory.light,
    armorClass: 12,
    addDexterity: true,
    weightKg: 6.5,
    cost: 45,
    currency: 'gp',
  ),
  ArmorIds.hide: ArmorDefinition(
    id: ArmorIds.hide,
    name: 'Armatura di Pelle',
    category: ArmorCategory.medium,
    armorClass: 12,
    addDexterity: true,
    maxDexterityBonus: 2,
    weightKg: 6,
    cost: 10,
    currency: 'gp',
  ),
  ArmorIds.chainShirt: ArmorDefinition(
    id: ArmorIds.chainShirt,
    name: 'Corazza di Maglia',
    category: ArmorCategory.medium,
    armorClass: 13,
    addDexterity: true,
    maxDexterityBonus: 2,
    weightKg: 10,
    cost: 50,
    currency: 'gp',
  ),
  ArmorIds.scaleMail: ArmorDefinition(
    id: ArmorIds.scaleMail,
    name: 'Corazza a Scaglie',
    category: ArmorCategory.medium,
    armorClass: 14,
    addDexterity: true,
    maxDexterityBonus: 2,
    stealthDisadvantage: true,
    weightKg: 22.5,
    cost: 50,
    currency: 'gp',
  ),
  ArmorIds.breastplate: ArmorDefinition(
    id: ArmorIds.breastplate,
    name: 'Corazza',
    category: ArmorCategory.medium,
    armorClass: 14,
    addDexterity: true,
    maxDexterityBonus: 2,
    weightKg: 10,
    cost: 400,
    currency: 'gp',
  ),
  ArmorIds.halfPlate: ArmorDefinition(
    id: ArmorIds.halfPlate,
    name: 'Mezza Armatura',
    category: ArmorCategory.medium,
    armorClass: 15,
    addDexterity: true,
    maxDexterityBonus: 2,
    stealthDisadvantage: true,
    weightKg: 20,
    cost: 750,
    currency: 'gp',
  ),
  ArmorIds.ringMail: ArmorDefinition(
    id: ArmorIds.ringMail,
    name: 'Giaco ad Anelli',
    category: ArmorCategory.heavy,
    armorClass: 14,
    addDexterity: false,
    stealthDisadvantage: true,
    weightKg: 20,
    cost: 30,
    currency: 'gp',
  ),
  ArmorIds.chainMail: ArmorDefinition(
    id: ArmorIds.chainMail,
    name: 'Cotta di Maglia',
    category: ArmorCategory.heavy,
    armorClass: 16,
    addDexterity: false,
    strengthRequirement: 13,
    stealthDisadvantage: true,
    weightKg: 27.5,
    cost: 75,
    currency: 'gp',
  ),
  ArmorIds.splint: ArmorDefinition(
    id: ArmorIds.splint,
    name: 'Armatura a Strisce',
    category: ArmorCategory.heavy,
    armorClass: 17,
    addDexterity: false,
    strengthRequirement: 15,
    stealthDisadvantage: true,
    weightKg: 30,
    cost: 200,
    currency: 'gp',
  ),
  ArmorIds.plate: ArmorDefinition(
    id: ArmorIds.plate,
    name: 'Armatura Completa',
    category: ArmorCategory.heavy,
    armorClass: 18,
    addDexterity: false,
    strengthRequirement: 15,
    stealthDisadvantage: true,
    weightKg: 32.5,
    cost: 1500,
    currency: 'gp',
  ),
  ArmorIds.shield: ArmorDefinition(
    id: ArmorIds.shield,
    name: 'Scudo',
    category: ArmorCategory.shield,
    armorClass: 2,
    addDexterity: false,
    weightKg: 3,
    cost: 10,
    currency: 'gp',
  ),
};
