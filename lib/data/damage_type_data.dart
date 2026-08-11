class DamageTypeDefinition {
  final String id;
  final String name;
  final String description;

  const DamageTypeDefinition({
    required this.id,
    required this.name,
    required this.description,
  });
}

abstract final class DamageTypeIds {
  static const bludgeoning = 'bludgeoning';
  static const piercing = 'piercing';
  static const slashing = 'slashing';

  static const acid = 'acid';
  static const cold = 'cold';
  static const fire = 'fire';
  static const force = 'force';
  static const lightning = 'lightning';
  static const necrotic = 'necrotic';
  static const poison = 'poison';
  static const psychic = 'psychic';
  static const radiant = 'radiant';
  static const thunder = 'thunder';
}

const Map<String, DamageTypeDefinition> damageTypeDefinitions = {
  DamageTypeIds.bludgeoning: DamageTypeDefinition(
    id: DamageTypeIds.bludgeoning,
    name: 'Contundente',
    description: 'Danni causati da impatti e colpi contundenti.',
  ),
  DamageTypeIds.piercing: DamageTypeDefinition(
    id: DamageTypeIds.piercing,
    name: 'Perforante',
    description: 'Danni causati da punte, frecce e perforazioni.',
  ),
  DamageTypeIds.slashing: DamageTypeDefinition(
    id: DamageTypeIds.slashing,
    name: 'Tagliente',
    description: 'Danni causati da lame e armi affilate.',
  ),
  DamageTypeIds.acid: DamageTypeDefinition(
    id: DamageTypeIds.acid,
    name: 'Acido',
    description: 'Danni da sostanze corrosive.',
  ),
  DamageTypeIds.cold: DamageTypeDefinition(
    id: DamageTypeIds.cold,
    name: 'Freddo',
    description: 'Danni da gelo e temperature estreme.',
  ),
  DamageTypeIds.fire: DamageTypeDefinition(
    id: DamageTypeIds.fire,
    name: 'Fuoco',
    description: 'Danni causati dalle fiamme.',
  ),
  DamageTypeIds.force: DamageTypeDefinition(
    id: DamageTypeIds.force,
    name: 'Forza',
    description: 'Energia magica pura.',
  ),
  DamageTypeIds.lightning: DamageTypeDefinition(
    id: DamageTypeIds.lightning,
    name: 'Fulmine',
    description: 'Scariche elettriche.',
  ),
  DamageTypeIds.necrotic: DamageTypeDefinition(
    id: DamageTypeIds.necrotic,
    name: 'Necrotico',
    description: 'Energia che consuma la forza vitale.',
  ),
  DamageTypeIds.poison: DamageTypeDefinition(
    id: DamageTypeIds.poison,
    name: 'Veleno',
    description: 'Danni provocati da tossine e veleni.',
  ),
  DamageTypeIds.psychic: DamageTypeDefinition(
    id: DamageTypeIds.psychic,
    name: 'Psichico',
    description: 'Danni alla mente.',
  ),
  DamageTypeIds.radiant: DamageTypeDefinition(
    id: DamageTypeIds.radiant,
    name: 'Radiante',
    description: 'Energia divina e luce sacra.',
  ),
  DamageTypeIds.thunder: DamageTypeDefinition(
    id: DamageTypeIds.thunder,
    name: 'Tuono',
    description: 'Onde sonore e boati.',
  ),
};
