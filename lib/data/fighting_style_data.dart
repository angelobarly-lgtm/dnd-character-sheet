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
    description: '+2 ai tiri per colpire effettuati con le armi a distanza.',
  ),
  FightingStyleIds.defense: FightingStyleDefinition(
    id: FightingStyleIds.defense,
    name: 'Difesa',
    description: '+1 alla CA finché indossi un’armatura.',
  ),
  FightingStyleIds.dueling: FightingStyleDefinition(
    id: FightingStyleIds.dueling,
    name: 'Duellare',
    description:
        '+2 ai tiri per i danni quando impugni un’arma da mischia in una mano e non impugni altre armi.',
  ),
  FightingStyleIds.greatWeaponFighting: FightingStyleDefinition(
    id: FightingStyleIds.greatWeaponFighting,
    name: 'Combattere con Armi Possenti',
    description:
        'Quando ottieni 1 o 2 su un dado di danno di un attacco con un’arma da mischia impugnata a due mani, puoi ripetere il tiro e devi usare il nuovo risultato. L’arma deve possedere la proprietà a due mani o versatile.',
  ),
  FightingStyleIds.protection: FightingStyleDefinition(
    id: FightingStyleIds.protection,
    name: 'Protezione',
    description:
        'Quando una creatura che puoi vedere attacca un bersaglio diverso da te entro 1,5 metri, puoi usare la reazione per imporre svantaggio al tiro per colpire. Devi impugnare uno scudo.',
  ),
  FightingStyleIds.twoWeaponFighting: FightingStyleDefinition(
    id: FightingStyleIds.twoWeaponFighting,
    name: 'Combattere con Due Armi',
    description:
        'Quando combatti con due armi, puoi aggiungere il modificatore di caratteristica ai danni del secondo attacco.',
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
