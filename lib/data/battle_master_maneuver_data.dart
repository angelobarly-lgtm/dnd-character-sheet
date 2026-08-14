enum BattleMasterManeuverTrigger {
  replaceAttack,
  weaponAttackHits,
  weaponAttackRoll,
  meleeWeaponAttack,
  movement,
  bonusAction,
  damagedByMeleeAttack,
  enemyMissesMeleeAttack,
}

class BattleMasterManeuverDefinition {
  final String id;
  final String name;
  final String description;
  final Set<BattleMasterManeuverTrigger> triggers;
  final String? savingThrowAbility;
  final bool addsSuperiorityDieToDamage;
  final Set<String> ruleTags;

  const BattleMasterManeuverDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.triggers,
    this.savingThrowAbility,
    this.addsSuperiorityDieToDamage = false,
    this.ruleTags = const {},
  });
}

abstract final class BattleMasterManeuverIds {
  static const commandersStrike = 'commanders_strike';
  static const disarmingAttack = 'disarming_attack';
  static const distractingStrike = 'distracting_strike';
  static const evasiveFootwork = 'evasive_footwork';
  static const feintingAttack = 'feinting_attack';
  static const goadingAttack = 'goading_attack';
  static const lungingAttack = 'lunging_attack';
  static const maneuveringAttack = 'maneuvering_attack';
  static const menacingAttack = 'menacing_attack';
  static const parry = 'parry';
  static const precisionAttack = 'precision_attack';
  static const pushingAttack = 'pushing_attack';
  static const rally = 'rally';
  static const riposte = 'riposte';
  static const sweepingAttack = 'sweeping_attack';
  static const tripAttack = 'trip_attack';
}

const battleMasterManeuverDefinitions =
    <String, BattleMasterManeuverDefinition>{
  BattleMasterManeuverIds.commandersStrike: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.commandersStrike,
    name: 'Colpo del Comandante',
    description:
        'Il Guerriero rinuncia a uno dei propri attacchi e usa un’azione bonus per consentire a un alleato di effettuare un attacco con la sua reazione, aggiungendo il dado di superiorità ai danni.',
    triggers: {
      BattleMasterManeuverTrigger.replaceAttack,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'ally_reaction_attack',
      'replace_attack',
      'bonus_action',
    },
  ),
  BattleMasterManeuverIds.disarmingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.disarmingAttack,
    name: 'Attacco Disarmante',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni e può costringere il bersaglio a lasciar cadere un oggetto impugnato.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    savingThrowAbility: 'FOR',
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'disarm',
      'weapon_attack',
    },
  ),
  BattleMasterManeuverIds.distractingStrike: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.distractingStrike,
    name: 'Attacco Distraente',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni; il prossimo attacco di un alleato contro il bersaglio dispone di vantaggio.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'ally_attack_advantage',
      'weapon_attack',
    },
  ),
  BattleMasterManeuverIds.evasiveFootwork: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.evasiveFootwork,
    name: 'Scarto Elusivo',
    description:
        'Quando si muove, il Guerriero può aggiungere il dado di superiorità alla propria Classe Armatura fino al termine del movimento.',
    triggers: {
      BattleMasterManeuverTrigger.movement,
    },
    ruleTags: {
      'armor_class_bonus',
      'movement',
    },
  ),
  BattleMasterManeuverIds.feintingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.feintingAttack,
    name: 'Attacco con Finta',
    description:
        'Con un’azione bonus il Guerriero sceglie una creatura adiacente: il prossimo attacco contro di essa dispone di vantaggio e, se colpisce, aggiunge il dado di superiorità ai danni.',
    triggers: {
      BattleMasterManeuverTrigger.bonusAction,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'attack_advantage',
      'bonus_action',
      'adjacent_target',
    },
  ),
  BattleMasterManeuverIds.goadingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.goadingAttack,
    name: 'Attacco Adescante',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni e può rendere più difficili gli attacchi del bersaglio contro altre creature.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    savingThrowAbility: 'SAG',
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'goad',
      'disadvantage_against_other_targets',
    },
  ),
  BattleMasterManeuverIds.lungingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.lungingAttack,
    name: 'Attacco con Affondo',
    description:
        'Quando effettua un attacco con arma da mischia, il Guerriero aumenta la portata dell’attacco di 1,5 metri e aggiunge il dado di superiorità ai danni se colpisce.',
    triggers: {
      BattleMasterManeuverTrigger.meleeWeaponAttack,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'reach_bonus_1_5_meters',
      'melee_weapon_attack',
    },
  ),
  BattleMasterManeuverIds.maneuveringAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.maneuveringAttack,
    name: 'Attacco con Manovra',
    description:
        'Dopo aver colpito, il Guerriero aggiunge il dado di superiorità ai danni e consente a un alleato di muoversi usando la propria reazione senza provocare l’attacco di opportunità del bersaglio.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'ally_reaction_movement',
      'avoid_target_opportunity_attack',
    },
  ),
  BattleMasterManeuverIds.menacingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.menacingAttack,
    name: 'Attacco Minaccioso',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni e può spaventare il bersaglio fino al termine del turno successivo.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    savingThrowAbility: 'SAG',
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'frightened',
      'weapon_attack',
    },
  ),
  BattleMasterManeuverIds.parry: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.parry,
    name: 'Parata',
    description:
        'Quando subisce danni da un attacco in mischia, il Guerriero usa la propria reazione per ridurre i danni del risultato del dado di superiorità più il modificatore di Destrezza.',
    triggers: {
      BattleMasterManeuverTrigger.damagedByMeleeAttack,
    },
    ruleTags: {
      'reaction',
      'damage_reduction',
      'add_dexterity_modifier',
    },
  ),
  BattleMasterManeuverIds.precisionAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.precisionAttack,
    name: 'Attacco Preciso',
    description:
        'Quando effettua un attacco con arma, il Guerriero può aggiungere il dado di superiorità al tiro per colpire prima o dopo il tiro, ma prima di conoscerne l’esito.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackRoll,
    },
    ruleTags: {
      'attack_roll_bonus',
      'before_attack_result',
    },
  ),
  BattleMasterManeuverIds.pushingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.pushingAttack,
    name: 'Attacco con Spinta',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni e può spingere il bersaglio fino a 4,5 metri.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    savingThrowAbility: 'FOR',
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'push_4_5_meters',
      'maximum_large_target',
    },
  ),
  BattleMasterManeuverIds.rally: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.rally,
    name: 'Incoraggiamento',
    description:
        'Con un’azione bonus il Guerriero concede a un alleato che può vederlo o sentirlo punti ferita temporanei pari al dado di superiorità più il modificatore di Carisma.',
    triggers: {
      BattleMasterManeuverTrigger.bonusAction,
    },
    ruleTags: {
      'temporary_hit_points',
      'add_charisma_modifier',
      'bonus_action',
    },
  ),
  BattleMasterManeuverIds.riposte: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.riposte,
    name: 'Replica',
    description:
        'Quando una creatura manca il Guerriero con un attacco in mischia, egli usa la propria reazione per effettuare un attacco in mischia e aggiunge il dado di superiorità ai danni se colpisce.',
    triggers: {
      BattleMasterManeuverTrigger.enemyMissesMeleeAttack,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'reaction',
      'melee_weapon_attack',
    },
  ),
  BattleMasterManeuverIds.sweepingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.sweepingAttack,
    name: 'Attacco con Spazzata',
    description:
        'Dopo aver colpito con un attacco in mischia, il Guerriero può infliggere il risultato del dado di superiorità a una seconda creatura adiacente al bersaglio originale.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'secondary_target',
      'melee_weapon_attack',
    },
  ),
  BattleMasterManeuverIds.tripAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.tripAttack,
    name: 'Attacco Sbilanciante',
    description:
        'Dopo aver colpito con un attacco con arma, il Guerriero aggiunge il dado di superiorità ai danni e può buttare a terra prono il bersaglio.',
    triggers: {
      BattleMasterManeuverTrigger.weaponAttackHits,
    },
    savingThrowAbility: 'FOR',
    addsSuperiorityDieToDamage: true,
    ruleTags: {
      'prone',
      'maximum_large_target',
    },
  ),
};
