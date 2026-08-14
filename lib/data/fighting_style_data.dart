class FightingStyleDefinition {
  final String id;
  final String name;
  final String description;

  const FightingStyleDefinition({
    required this.id,
    required this.name,
    required this.description,
  });
}

abstract final class FightingStyleIds {
  static const archery = 'archery';
  static const defense = 'defense';
  static const dueling = 'dueling';
  static const greatWeaponFighting = 'great_weapon_fighting';
  static const protection = 'protection';
  static const twoWeaponFighting = 'two_weapon_fighting';
  static const blindFighting = 'blind_fighting';
  static const interception = 'interception';
  static const superiorTechnique = 'superior_technique';
  static const thrownWeaponFighting = 'thrown_weapon_fighting';
  static const unarmedFighting = 'unarmed_fighting';
}

const Set<String> phbFighterFightingStyleIds = {
  FightingStyleIds.archery,
  FightingStyleIds.defense,
  FightingStyleIds.dueling,
  FightingStyleIds.greatWeaponFighting,
  FightingStyleIds.protection,
  FightingStyleIds.twoWeaponFighting,
};

const Map<String, FightingStyleDefinition> fightingStyleDefinitions = {
  FightingStyleIds.archery: FightingStyleDefinition(
    id: FightingStyleIds.archery,
    name: 'Tiro',
    description: '+2 ai tiri per colpire con armi a distanza.',
  ),
  FightingStyleIds.defense: FightingStyleDefinition(
    id: FightingStyleIds.defense,
    name: 'Difesa',
    description: '+1 CA mentre indossi un\'armatura.',
  ),
  FightingStyleIds.dueling: FightingStyleDefinition(
    id: FightingStyleIds.dueling,
    name: 'Duellare',
    description: '+2 ai danni con un\'arma a una mano.',
  ),
  FightingStyleIds.greatWeaponFighting: FightingStyleDefinition(
    id: FightingStyleIds.greatWeaponFighting,
    name: 'Combattere con Armi Possenti',
    description: 'Ritira 1 e 2 sui dadi di danno.',
  ),
  FightingStyleIds.protection: FightingStyleDefinition(
    id: FightingStyleIds.protection,
    name: 'Protezione',
    description: 'Imponi svantaggio a un attacco contro un alleato.',
  ),
  FightingStyleIds.twoWeaponFighting: FightingStyleDefinition(
    id: FightingStyleIds.twoWeaponFighting,
    name: 'Combattere con Due Armi',
    description: 'Aggiungi il modificatore al danno del secondo attacco.',
  ),
  FightingStyleIds.blindFighting: FightingStyleDefinition(
    id: FightingStyleIds.blindFighting,
    name: 'Combattere alla Cieca',
    description: 'Vista cieca entro 3 metri.',
  ),
  FightingStyleIds.interception: FightingStyleDefinition(
    id: FightingStyleIds.interception,
    name: 'Intercettazione',
    description: 'Riduci i danni subiti da un alleato.',
  ),
  FightingStyleIds.superiorTechnique: FightingStyleDefinition(
    id: FightingStyleIds.superiorTechnique,
    name: 'Tecnica Superiore',
    description: 'Ottieni una manovra e un dado di superiorità.',
  ),
  FightingStyleIds.thrownWeaponFighting: FightingStyleDefinition(
    id: FightingStyleIds.thrownWeaponFighting,
    name: 'Armi da Lancio',
    description: 'Bonus alle armi da lancio.',
  ),
  FightingStyleIds.unarmedFighting: FightingStyleDefinition(
    id: FightingStyleIds.unarmedFighting,
    name: 'Combattimento Senz\'Armi',
    description: 'Migliora i danni senz\'armi.',
  ),
};
