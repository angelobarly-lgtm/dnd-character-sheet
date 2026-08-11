import 'class_data.dart';
import 'character_data.dart';
import 'choice_data.dart';

/// Definizione strutturata universale di un talento.
///
/// `effects` contiene gli effetti direttamente applicabili dal runtime.
/// Le scelte interne del talento vengono rappresentate attraverso
/// CharacterEffects.choices, usando lo stesso motore di razze,
/// background e future regole di classe.
/// ID canonici dei talenti.
///
/// Usiamo ID stabili indipendenti dal nome visualizzato.
abstract final class FeatIds {
  // PHB — ID canonici stabili.
  static const alert = 'alert';
  static const athlete = 'athlete';
  static const actor = 'actor';
  static const charger = 'charger';
  static const crossbowExpert = 'crossbow_expert';
  static const defensiveDuelist = 'defensive_duelist';
  static const dualWielder = 'dual_wielder';
  static const dungeonDelver = 'dungeon_delver';
  static const durable = 'durable';
  static const elementalAdept = 'elemental_adept';
  static const grappler = 'grappler';
  static const greatWeaponMaster = 'great_weapon_master';
  static const healer = 'healer';
  static const heavilyArmored = 'heavily_armored';
  static const heavyArmorMaster = 'heavy_armor_master';
  static const inspiringLeader = 'inspiring_leader';
  static const keenMind = 'keen_mind';
  static const lightArmorMaster = 'lightly_armored';
  static const linguist = 'linguist';
  static const lucky = 'lucky';
  static const mageSlayer = 'mage_slayer';
  static const magicInitiate = 'magic_initiate';
  static const martialAdept = 'martial_adept';
  static const mediumArmorMaster = 'medium_armor_master';
  static const mobile = 'mobile';
  static const moderatelyArmored = 'moderately_armored';
  static const mountedCombatant = 'mounted_combatant';
  static const observant = 'observant';
  static const polearmMaster = 'polearm_master';
  static const resilient = 'resilient';
  static const ritualCaster = 'ritual_caster';
  static const savageAttacker = 'savage_attacker';
  static const sentinel = 'sentinel';
  static const sharpshooter = 'sharpshooter';
  static const shieldMaster = 'shield_master';
  static const skilled = 'skilled';
  static const skulker = 'skulker';
  static const spellSniper = 'spell_sniper';
  static const tavernBrawler = 'tavern_brawler';
  static const tough = 'tough';
  static const warCaster = 'war_caster';
  static const fightingInitiate = 'fighting_initiate';
  static const weaponMaster = 'weapon_master';
}

/// Primo nucleo migrato dal creator legacy.
///
/// Questo non rappresenta ancora il catalogo completo PHB/Xanathar/Tasha.
/// Serve a collegare immediatamente CharacterChoiceType.feat al runtime
/// universale senza mantenere la selezione speciale dell'Umano Variante.
const Map<String, FeatDefinition> featDefinitions = {
  FeatIds.alert: FeatDefinition(
    id: FeatIds.alert,
    name: 'Allerta',
    content: RuleContent(
      id: FeatIds.alert,
      name: 'Allerta',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Aumenta drasticamente la prontezza e protegge dalle imboscate.',
        details: 'Conferisce +5 all’iniziativa, impedisce di essere sorpresi '
            'finché si è coscienti e neutralizza il vantaggio ottenuto '
            'da creature non viste dal personaggio.',
      ),
      ownerId: FeatIds.alert,
    ),
    effects: CharacterEffects(
      initiativeBonus: 5,
      ruleEffects: [
        CharacterRuleEffect(
          id: 'alert_cannot_be_surprised',
          type: CharacterRuleEffectType.conditional,
          target: 'surprised',
          condition: 'while_conscious',
        ),
        CharacterRuleEffect(
          id: 'alert_unseen_attackers_no_advantage',
          type: CharacterRuleEffectType.conditional,
          target: 'incoming_attack_advantage',
          condition: 'attacker_unseen_by_character',
        ),
      ],
    ),
  ),
  FeatIds.athlete: FeatDefinition(
    id: FeatIds.athlete,
    name: 'Atleta',
    content: RuleContent(
      id: FeatIds.athlete,
      name: 'Atleta',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora capacità fisiche e movimento.',
        details:
            'Migliora una caratteristica fisica e rende più efficienti alcune forme di movimento.',
      ),
      ownerId: FeatIds.athlete,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'FOR_OR_DES',
          amount: 1,
        ),
      ],
      choices: [
        CharacterChoiceDefinition(
          id: 'athlete_ability',
          label: 'Caratteristica di Atleta',
          type: CharacterChoiceType.ability,
          optionIds: ['FOR', 'DES'],
        ),
      ],
    ),
  ),
  FeatIds.actor: FeatDefinition(
    id: FeatIds.actor,
    name: 'Attore',
    content: RuleContent(
      id: FeatIds.actor,
      name: 'Attore',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora Carisma e capacità di impersonare altre persone.',
        details: 'Conferisce un aumento di Carisma e capacità speciali legate '
            'all’interpretazione, all’imitazione e al camuffamento.',
      ),
      ownerId: FeatIds.actor,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'CAR',
          amount: 1,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'actor_impersonation_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'impersonation_checks',
          condition: 'while_impersonating_another_person',
        ),
        CharacterRuleEffect(
          id: 'actor_mimicry',
          type: CharacterRuleEffectType.conditional,
          target: 'speech_and_sound_mimicry',
        ),
      ],
    ),
  ),
  FeatIds.charger: FeatDefinition(
    id: FeatIds.charger,
    name: 'Carica',
    content: RuleContent(
      id: FeatIds.charger,
      name: 'Carica',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Permette di trasformare uno Scatto in un attacco o una spinta come azione bonus.',
        details:
            'Dopo avere usato l’azione di Scatto, il personaggio può usare '
            'un’azione bonus per effettuare un attacco con arma da mischia '
            'o spingere una creatura. Se si è mosso di almeno 3 metri in '
            'linea retta immediatamente prima, un attacco riuscito può '
            'ottenere +5 ai danni oppure una spinta riuscita può allontanare '
            'il bersaglio fino a 3 metri.',
      ),
      ownerId: FeatIds.charger,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'ritual_caster_class',
          label: 'Classe incantatrice',
          type: CharacterChoiceType.other,
          optionIds: [
            'bard',
            'cleric',
            'druid',
            'sorcerer',
            'warlock',
            'wizard',
          ],
        ),
        CharacterChoiceDefinition(
          id: 'ritual_caster_spells',
          label: 'Incantesimi rituali',
          type: CharacterChoiceType.spell,
          catalogId: CharacterChoiceCatalogIds.spells,
          minimumSelections: 2,
          maximumSelections: 2,
          constraints: [
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.classId,
              valueFromChoice: 'ritual_caster_class',
            ),
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.spellLevel,
              values: ['1'],
            ),
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.ritual,
              values: ['true'],
            ),
          ],
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'charger_dash_bonus_action',
          type: CharacterRuleEffectType.conditional,
          target: 'bonus_action_after_dash',
          condition: 'dash_action_used',
        ),
        CharacterRuleEffect(
          id: 'charger_straight_line_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'charger_attack_or_shove',
          condition: 'moved_3m_straight_before_bonus_action',
        ),
      ],
    ),
  ),
  FeatIds.crossbowExpert: FeatDefinition(
    id: FeatIds.crossbowExpert,
    name: 'Esperto di Balestre',
    content: RuleContent(
      id: FeatIds.crossbowExpert,
      name: 'Esperto di Balestre',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Rimuove alcune limitazioni delle balestre e migliora il combattimento a distanza ravvicinato.',
        details: 'Ignora la proprietà di ricarica delle balestre in cui è '
            'competente. Una creatura ostile entro 1,5 metri non impone '
            'svantaggio ai suoi tiri per colpire a distanza. Dopo avere '
            'usato l’azione di Attacco con un’arma a una mano, può usare '
            'un’azione bonus per attaccare con una balestra a mano impugnata.',
      ),
      ownerId: FeatIds.crossbowExpert,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'crossbow_expert_ignore_loading',
          type: CharacterRuleEffectType.conditional,
          target: 'crossbow_loading_property',
          condition: 'proficient_with_crossbow',
        ),
        CharacterRuleEffect(
          id: 'crossbow_expert_close_range',
          type: CharacterRuleEffectType.conditional,
          target: 'ranged_attack_disadvantage',
          condition: 'hostile_creature_within_1_5m',
        ),
        CharacterRuleEffect(
          id: 'crossbow_expert_hand_crossbow_bonus_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'hand_crossbow_bonus_attack',
          condition: 'attack_action_with_one_handed_weapon',
        ),
      ],
    ),
  ),
  FeatIds.defensiveDuelist: FeatDefinition(
    id: FeatIds.defensiveDuelist,
    name: 'Duellante Difensivo',
    content: RuleContent(
      id: FeatIds.defensiveDuelist,
      name: 'Duellante Difensivo',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Può usare la reazione per aumentare la CA contro un attacco in mischia.',
        details: 'Quando impugna un’arma accurata in cui è competente e viene '
            'colpito da un attacco in mischia, può usare la sua reazione '
            'per aggiungere il bonus di competenza alla CA contro '
            'quell’attacco, potenzialmente trasformandolo in un mancato.',
      ),
      ownerId: FeatIds.defensiveDuelist,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.minimumAbility,
        value: 'DES',
        minimum: 13,
      ),
    ],
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'martial_adept_maneuvers',
          label: 'Manovre del Maestro di Battaglia',
          type: CharacterChoiceType.other,
          minimumSelections: 2,
          maximumSelections: 2,
          catalogId: CharacterChoiceCatalogIds.battleMasterManeuvers,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'defensive_duelist_reaction_ac',
          type: CharacterRuleEffectType.conditional,
          target: 'armor_class_against_triggering_melee_attack',
          condition:
              'wielding_proficient_finesse_weapon_and_hit_by_melee_attack',
        ),
      ],
    ),
  ),
  FeatIds.dualWielder: FeatDefinition(
    id: FeatIds.dualWielder,
    name: 'Combattere con Due Armi',
    content: RuleContent(
      id: FeatIds.dualWielder,
      name: 'Combattere con Due Armi',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora il combattimento con due armi.',
        details: 'Ottiene un bonus di +1 alla CA quando impugna separatamente '
            'un\'arma da mischia in ciascuna mano, può combattere con due '
            'armi anche se le armi non sono leggere purché siano a una mano '
            'e può estrarre o riporre due armi a una mano quando normalmente '
            'potrebbe estrarne o riporne una sola.',
      ),
      ownerId: FeatIds.dualWielder,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'dual_wielder_ac_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'armor_class',
          value: 1,
          condition: 'wielding_two_melee_weapons',
        ),
        CharacterRuleEffect(
          id: 'dual_wielder_ignore_light_requirement',
          type: CharacterRuleEffectType.conditional,
          target: 'two_weapon_fighting',
          condition: 'one_handed_melee_weapons',
        ),
        CharacterRuleEffect(
          id: 'dual_wielder_draw_two_weapons',
          type: CharacterRuleEffectType.conditional,
          target: 'draw_or_stow_weapons',
          value: 2,
        ),
      ],
    ),
  ),
  FeatIds.dungeonDelver: FeatDefinition(
    id: FeatIds.dungeonDelver,
    name: 'Esperto di Dungeon',
    content: RuleContent(
      id: FeatIds.dungeonDelver,
      name: 'Esperto di Dungeon',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Migliora l’individuazione di porte segrete e la capacità di affrontare le trappole.',
        details: 'Concede vantaggio a Percezione e Indagare per individuare '
            'porte segrete, vantaggio ai tiri salvezza contro le trappole '
            'e resistenza ai danni da esse inflitti. Permette inoltre di '
            'cercare trappole muovendosi a passo normale.',
      ),
      ownerId: FeatIds.dungeonDelver,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'dungeon_delver_secret_door_perception',
          type: CharacterRuleEffectType.conditional,
          target: 'Percezione',
          condition: 'detect_secret_door',
        ),
        CharacterRuleEffect(
          id: 'dungeon_delver_secret_door_investigation',
          type: CharacterRuleEffectType.conditional,
          target: 'Indagare',
          condition: 'detect_secret_door',
        ),
        CharacterRuleEffect(
          id: 'dungeon_delver_trap_saves',
          type: CharacterRuleEffectType.conditional,
          target: 'saving_throw',
          condition: 'avoid_or_resist_trap',
        ),
        CharacterRuleEffect(
          id: 'dungeon_delver_trap_damage_resistance',
          type: CharacterRuleEffectType.conditional,
          target: 'trap_damage',
          condition: 'damage_from_trap',
        ),
        CharacterRuleEffect(
          id: 'dungeon_delver_normal_pace_trap_search',
          type: CharacterRuleEffectType.conditional,
          target: 'trap_search_movement_pace',
          condition: 'searching_for_traps',
        ),
      ],
    ),
  ),
  FeatIds.durable: FeatDefinition(
    id: FeatIds.durable,
    name: 'Durevole',
    content: RuleContent(
      id: FeatIds.durable,
      name: 'Durevole',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Aumenta Costituzione e migliora il recupero con i Dadi Vita.',
        details: 'Conferisce un aumento di Costituzione e rende più affidabile '
            'il recupero dei punti ferita tramite i Dadi Vita.',
      ),
      ownerId: FeatIds.durable,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'COS',
          amount: 1,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'durable_hit_die_minimum',
          type: CharacterRuleEffectType.conditional,
          target: 'hit_die_healing',
          value: 2,
          condition: 'minimum_roll_multiplier_of_constitution_modifier',
        ),
      ],
    ),
  ),
  FeatIds.elementalAdept: FeatDefinition(
    id: FeatIds.elementalAdept,
    name: 'Esperto Elementale',
    content: RuleContent(
      id: FeatIds.elementalAdept,
      name: 'Esperto Elementale',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Specializzazione in un tipo di danno elementale.',
        details:
            'Scegli un tipo di danno tra acido, freddo, fuoco, fulmine o tuono. '
            'Gli 1 ottenuti sui dadi di danno degli incantesimi di quel tipo '
            'sono considerati 2 e gli incantesimi ignorano la resistenza a quel '
            'tipo di danno.',
      ),
      ownerId: FeatIds.elementalAdept,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'elemental_adept_ignore_resistance',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_damage_resistance',
          condition: 'chosen_damage_type',
        ),
        CharacterRuleEffect(
          id: 'elemental_adept_damage_die_minimum',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_damage_die',
          value: 2,
          condition: 'reroll_ones_as_two',
        ),
      ],
    ),
  ),
  FeatIds.grappler: FeatDefinition(
    id: FeatIds.grappler,
    name: 'Lottatore',
    content: RuleContent(
      id: FeatIds.grappler,
      name: 'Lottatore',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora il combattimento contro creature afferrate.',
        details: 'Concede vantaggio agli attacchi contro una creatura '
            'afferrata dal personaggio e permette di tentare di '
            'immobilizzarla tramite un’ulteriore prova di lotta.',
      ),
      ownerId: FeatIds.grappler,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.minimumAbility,
        value: 'FOR',
        minimum: 13,
      ),
    ],
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'grappler_advantage_against_grappled',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_roll',
          condition: 'target_grappled_by_character',
        ),
        CharacterRuleEffect(
          id: 'grappler_pin',
          type: CharacterRuleEffectType.conditional,
          target: 'grapple_pin',
          condition: 'target_already_grappled_by_character',
        ),
      ],
    ),
  ),
  FeatIds.greatWeaponMaster: FeatDefinition(
    id: FeatIds.greatWeaponMaster,
    name: 'Maestro delle Armi Possenti',
    content: RuleContent(
      id: FeatIds.greatWeaponMaster,
      name: 'Maestro delle Armi Possenti',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Massimizza l\'efficacia delle armi pesanti.',
        details:
            'Quando metti a segno un colpo critico o riduci una creatura a 0 '
            'punti ferita con un\'arma da mischia, puoi effettuare un attacco '
            'con arma da mischia come azione bonus. Prima di effettuare un '
            'attacco con un\'arma pesante con cui sei competente puoi scegliere '
            'di subire una penalità di -5 al tiro per colpire; se l\'attacco '
            'colpisce infligge +10 danni.',
      ),
      ownerId: FeatIds.greatWeaponMaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'great_weapon_master_bonus_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'bonus_attack',
          condition: 'critical_hit_or_reduce_to_zero_hp',
        ),
        CharacterRuleEffect(
          id: 'great_weapon_master_power_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'heavy_weapon_attack',
          value: 10,
          condition: 'minus_five_to_hit',
        ),
      ],
    ),
  ),
  FeatIds.healer: FeatDefinition(
    id: FeatIds.healer,
    name: 'Guaritore',
    content: RuleContent(
      id: FeatIds.healer,
      name: 'Guaritore',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Permette di curare efficacemente con un kit da guaritore.',
        details:
            'Quando usi un kit da guaritore per stabilizzare una creatura, '
            'essa recupera anche 1 punto ferita. Come azione puoi spendere '
            'un utilizzo del kit per far recuperare a una creatura 1d6 + 4 '
            'punti ferita più un numero di punti ferita aggiuntivi pari al '
            'massimo dei suoi Dadi Vita. Una creatura non può beneficiare di '
            'questa cura finché non completa un riposo breve o lungo.',
      ),
      ownerId: FeatIds.healer,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'healer_stabilize_restore_hp',
          type: CharacterRuleEffectType.conditional,
          target: 'stabilize_with_healers_kit',
          value: 1,
        ),
        CharacterRuleEffect(
          id: 'healer_medical_treatment',
          type: CharacterRuleEffectType.conditional,
          target: 'healers_kit_healing',
          condition: 'once_per_short_or_long_rest_per_target',
        ),
      ],
    ),
  ),
  FeatIds.heavilyArmored: FeatDefinition(
    id: FeatIds.heavilyArmored,
    name: 'Corazzato Pesantemente',
    content: RuleContent(
      id: FeatIds.heavilyArmored,
      name: 'Corazzato Pesantemente',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Aumenta Forza e concede competenza nelle armature pesanti.',
        details: 'Richiede addestramento nelle armature medie; aumenta Forza '
            'e concede competenza nelle armature pesanti.',
      ),
      ownerId: FeatIds.heavilyArmored,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.proficiency,
        value: 'medium_armor',
      ),
    ],
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'FOR',
          amount: 1,
        ),
      ],
      armorProficiencies: {
        'heavy_armor',
      },
    ),
  ),
  FeatIds.heavyArmorMaster: FeatDefinition(
    id: FeatIds.heavyArmorMaster,
    name: 'Maestro delle Armature Pesanti',
    content: RuleContent(
      id: FeatIds.heavyArmorMaster,
      name: 'Maestro delle Armature Pesanti',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Aumenta la Forza e riduce i danni subiti mentre indossi un\'armatura pesante.',
        details: 'La Forza aumenta di 1, fino a un massimo di 20. '
            'Quando indossi un\'armatura pesante, i danni contundenti, '
            'perforanti e taglienti inflitti da armi non magiche sono '
            'ridotti di 3.',
      ),
      ownerId: FeatIds.heavyArmorMaster,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'FOR',
          amount: 1,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'heavy_armor_master_damage_reduction',
          type: CharacterRuleEffectType.conditional,
          target: 'nonmagical_weapon_damage',
          value: 3,
          condition: 'while_wearing_heavy_armor',
        ),
      ],
    ),
  ),
  FeatIds.inspiringLeader: FeatDefinition(
    id: FeatIds.inspiringLeader,
    name: 'Condottiero Ispiratore',
    content: RuleContent(
      id: FeatIds.inspiringLeader,
      name: 'Condottiero Ispiratore',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Ispira gli alleati con un discorso, concedendo punti ferita temporanei.',
        details: 'Dedicando 10 minuti a ispirare i compagni, il personaggio '
            'può concedere punti ferita temporanei a sé stesso e fino '
            'a sei creature amiche che possano vederlo o sentirlo e '
            'comprenderlo. Il beneficio dipende dal livello e dal '
            'modificatore di Carisma.',
      ),
      ownerId: FeatIds.inspiringLeader,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.minimumAbility,
        value: 'CAR',
        minimum: 13,
      ),
    ],
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'inspiring_leader_temporary_hp',
          type: CharacterRuleEffectType.conditional,
          target: 'temporary_hit_points',
          condition: 'after_10_minute_inspiring_speech',
        ),
      ],
    ),
  ),
  FeatIds.keenMind: FeatDefinition(
    id: FeatIds.keenMind,
    name: 'Mente Acuta',
    content: RuleContent(
      id: FeatIds.keenMind,
      name: 'Mente Acuta',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Aumenta Intelligenza e conferisce un eccezionale orientamento.',
        details: 'Conferisce un aumento di Intelligenza e capacità speciali '
            'legate a orientamento, tempo e memoria.',
      ),
      ownerId: FeatIds.keenMind,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'INT',
          amount: 1,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'keen_mind_orientation',
          type: CharacterRuleEffectType.conditional,
          target: 'orientation',
        ),
        CharacterRuleEffect(
          id: 'keen_mind_timekeeping',
          type: CharacterRuleEffectType.conditional,
          target: 'time_awareness',
        ),
        CharacterRuleEffect(
          id: 'keen_mind_memory',
          type: CharacterRuleEffectType.conditional,
          target: 'recent_memory',
        ),
      ],
    ),
  ),
  FeatIds.lightArmorMaster: FeatDefinition(
    id: FeatIds.lightArmorMaster,
    name: 'Corazzato Leggermente',
    content: RuleContent(
      id: FeatIds.lightArmorMaster,
      name: 'Corazzato Leggermente',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Migliora Forza o Destrezza e concede addestramento nelle armature leggere.',
        details: 'Conferisce un aumento di Forza o Destrezza e competenza '
            'nelle armature leggere.',
      ),
      ownerId: FeatIds.lightArmorMaster,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'FOR_OR_DES',
          amount: 1,
        ),
      ],
      armorProficiencies: {
        'light_armor',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'lightly_armored_ability',
          label: 'Caratteristica di Corazzato Leggermente',
          type: CharacterChoiceType.ability,
          optionIds: ['FOR', 'DES'],
          minimumSelections: 1,
          maximumSelections: 1,
        ),
      ],
    ),
  ),
  FeatIds.linguist: FeatDefinition(
    id: FeatIds.linguist,
    name: 'Linguista',
    content: RuleContent(
      id: FeatIds.linguist,
      name: 'Linguista',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Aumenta Intelligenza e permette di apprendere nuove lingue.',
        details: 'Conferisce un aumento di Intelligenza, tre lingue a scelta '
            'e la capacità di creare messaggi cifrati.',
      ),
      ownerId: FeatIds.linguist,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'INT',
          amount: 1,
        ),
      ],
      choices: [
        CharacterChoiceDefinition(
          id: 'linguist_languages',
          label: 'Tre lingue di Linguista',
          type: CharacterChoiceType.language,
          minimumSelections: 3,
          maximumSelections: 3,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'linguist_cipher',
          type: CharacterRuleEffectType.conditional,
          target: 'written_cipher',
        ),
      ],
    ),
  ),
  FeatIds.lucky: FeatDefinition(
    id: FeatIds.lucky,
    name: 'Fortunato',
    content: RuleContent(
      id: FeatIds.lucky,
      name: 'Fortunato',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Conferisce una riserva di fortuna.',
        details:
            'Conferisce una riserva limitata utilizzabile per influenzare alcuni tiri.',
      ),
      ownerId: FeatIds.lucky,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'lucky_luck_points',
          type: CharacterRuleEffectType.conditional,
          target: 'luck_points',
          value: 3,
          condition: 'recovered_on_long_rest',
        ),
        CharacterRuleEffect(
          id: 'lucky_extra_d20',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_roll_ability_check_or_saving_throw',
          condition: 'spend_luck_point_to_roll_extra_d20',
        ),
        CharacterRuleEffect(
          id: 'lucky_affect_attack_against_you',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_roll_against_you',
          condition: 'spend_luck_point_to_roll_extra_d20_for_attacker',
        ),
      ],
    ),
  ),
  FeatIds.mageSlayer: FeatDefinition(
    id: FeatIds.mageSlayer,
    name: 'Uccisore di Maghi',
    content: RuleContent(
      id: FeatIds.mageSlayer,
      name: 'Uccisore di Maghi',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Specializzato nel combattere gli incantatori.',
        details:
            'Quando una creatura entro 1,5 metri da te lancia un incantesimo, '
            'puoi usare la tua reazione per effettuare un attacco in mischia '
            'contro di essa. Quando infliggi danni a una creatura che si sta '
            'concentrando su un incantesimo, essa effettua il tiro salvezza '
            'per mantenere la concentrazione con svantaggio. Inoltre hai '
            'vantaggio ai tiri salvezza contro gli incantesimi lanciati dalle '
            'creature entro 1,5 metri da te.',
      ),
      ownerId: FeatIds.mageSlayer,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'mage_slayer_reaction_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'reaction_attack',
          condition: 'adjacent_creature_casts_spell',
        ),
        CharacterRuleEffect(
          id: 'mage_slayer_concentration_disadvantage',
          type: CharacterRuleEffectType.conditional,
          target: 'concentration_save',
          condition: 'after_melee_damage',
        ),
        CharacterRuleEffect(
          id: 'mage_slayer_spell_save_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'saving_throws_against_adjacent_spells',
        ),
      ],
    ),
  ),
  FeatIds.magicInitiate: FeatDefinition(
    id: FeatIds.magicInitiate,
    name: 'Iniziato alla Magia',
    content: RuleContent(
      id: FeatIds.magicInitiate,
      name: 'Iniziato alla Magia',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Apprendi una piccola quantità di magia da una classe.',
        details: 'Scegli una classe incantatrice. Apprendi due trucchetti e un '
            'incantesimo di 1° livello dalla lista di quella classe. '
            'L’incantesimo di 1° livello può essere lanciato una volta per '
            'riposo lungo senza spendere slot e può essere lanciato '
            'normalmente se possiedi gli slot appropriati.',
      ),
      ownerId: FeatIds.magicInitiate,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'magic_initiate_class',
          label: 'Classe incantatrice',
          type: CharacterChoiceType.other,
          optionIds: [
            'bard',
            'cleric',
            'druid',
            'sorcerer',
            'warlock',
            'wizard',
          ],
        ),
        CharacterChoiceDefinition(
          id: 'magic_initiate_cantrips',
          label: 'Trucchetti',
          type: CharacterChoiceType.cantrip,
          catalogId: CharacterChoiceCatalogIds.spells,
          minimumSelections: 2,
          maximumSelections: 2,
          constraints: [
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.classId,
              valueFromChoice: 'magic_initiate_class',
            ),
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.spellLevel,
              values: ['0'],
            ),
          ],
        ),
        CharacterChoiceDefinition(
          id: 'magic_initiate_spell',
          label: 'Incantesimo di 1° livello',
          type: CharacterChoiceType.spell,
          catalogId: CharacterChoiceCatalogIds.spells,
          constraints: [
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.classId,
              valueFromChoice: 'magic_initiate_class',
            ),
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.spellLevel,
              values: ['1'],
            ),
          ],
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'magic_initiate_choose_spellcasting_class',
          type: CharacterRuleEffectType.spellcasting,
          target: 'spellcasting_class',
        ),
        CharacterRuleEffect(
          id: 'magic_initiate_learn_cantrips',
          type: CharacterRuleEffectType.spellcasting,
          target: 'cantrips',
          value: 2,
        ),
        CharacterRuleEffect(
          id: 'magic_initiate_learn_first_level_spell',
          type: CharacterRuleEffectType.spellcasting,
          target: 'first_level_spell',
          value: 1,
        ),
      ],
    ),
  ),
  FeatIds.martialAdept: FeatDefinition(
    id: FeatIds.martialAdept,
    name: 'Adepto Marziale',
    content: RuleContent(
      id: FeatIds.martialAdept,
      name: 'Adepto Marziale',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Apprendi due manovre e ottieni un dado di superiorità.',
        details: 'Apprendi due manovre dalla lista del Maestro di Battaglia. '
            'Ottieni un dado di superiorità (d6), che si ricarica dopo un '
            'riposo breve o lungo.',
      ),
      ownerId: FeatIds.martialAdept,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'martial_adept_superiority_die',
          type: CharacterRuleEffectType.resource,
          target: 'superiority_die',
          value: 1,
        ),
        CharacterRuleEffect(
          id: 'martial_adept_maneuvers',
          type: CharacterRuleEffectType.conditional,
          target: 'battle_master_maneuvers',
        ),
      ],
    ),
  ),
  FeatIds.mediumArmorMaster: FeatDefinition(
    id: FeatIds.mediumArmorMaster,
    name: 'Maestro delle Armature Medie',
    content: RuleContent(
      id: FeatIds.mediumArmorMaster,
      name: 'Maestro delle Armature Medie',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Sfrutti al meglio le armature medie.',
        details:
            'Quando indossi un’armatura media, non hai svantaggio alle prove '
            'di Furtività imposto dall’armatura. Inoltre puoi applicare un '
            'bonus di Destrezza fino a +3 invece del normale +2 alla Classe '
            'Armatura.',
      ),
      ownerId: FeatIds.mediumArmorMaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'medium_armor_master_dex_cap',
          type: CharacterRuleEffectType.conditional,
          target: 'medium_armor_dexterity_cap',
          value: 3,
        ),
        CharacterRuleEffect(
          id: 'medium_armor_master_no_stealth_disadvantage',
          type: CharacterRuleEffectType.conditional,
          target: 'medium_armor_stealth',
          condition: 'ignore_disadvantage',
        ),
      ],
    ),
  ),
  FeatIds.mobile: FeatDefinition(
    id: FeatIds.mobile,
    name: 'Mobile',
    content: RuleContent(
      id: FeatIds.mobile,
      name: 'Mobile',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Favorisce movimento e combattimento dinamico.',
        details:
            'Migliora la mobilità del personaggio e alcune interazioni con il movimento in combattimento.',
      ),
      ownerId: FeatIds.mobile,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'mobile_speed_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'walking_speed',
          value: 10,
        ),
        CharacterRuleEffect(
          id: 'mobile_dash_ignores_difficult_terrain',
          type: CharacterRuleEffectType.conditional,
          target: 'difficult_terrain',
          condition: 'after_dash_action_on_turn',
        ),
        CharacterRuleEffect(
          id: 'mobile_no_opportunity_from_attacked_creature',
          type: CharacterRuleEffectType.conditional,
          target: 'opportunity_attack_against_you',
          condition:
              'creature_you_made_melee_attack_against_this_turn_hit_or_miss',
        ),
      ],
    ),
  ),
  FeatIds.moderatelyArmored: FeatDefinition(
    id: FeatIds.moderatelyArmored,
    name: 'Moderatamente Corazzato',
    content: RuleContent(
      id: FeatIds.moderatelyArmored,
      name: 'Moderatamente Corazzato',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Migliora Forza o Destrezza e concede addestramento in armature medie e scudi.',
        details: 'Richiede competenza nelle armature leggere. Conferisce un '
            'aumento di Forza o Destrezza e competenza nelle armature '
            'medie e negli scudi.',
      ),
      ownerId: FeatIds.moderatelyArmored,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.proficiency,
        value: 'light_armor',
      ),
    ],
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(
          ability: 'FOR_OR_DES',
          amount: 1,
        ),
      ],
      armorProficiencies: {
        'medium_armor',
        'shield',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'moderately_armored_ability',
          label: 'Caratteristica di Moderatamente Corazzato',
          type: CharacterChoiceType.ability,
          optionIds: ['FOR', 'DES'],
          minimumSelections: 1,
          maximumSelections: 1,
        ),
      ],
    ),
  ),
  FeatIds.mountedCombatant: FeatDefinition(
    id: FeatIds.mountedCombatant,
    name: 'Combattente in Sella',
    content: RuleContent(
      id: FeatIds.mountedCombatant,
      name: 'Combattente in Sella',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Ottieni vantaggi quando combatti mentre sei in sella.',
        details:
            'Hai vantaggio agli attacchi in mischia contro creature non in '
            'sella più piccole della tua cavalcatura. Puoi obbligare un '
            'attacco che bersaglia la tua cavalcatura a bersagliare te. '
            'Se la cavalcatura deve effettuare un tiro salvezza su Destrezza '
            'per subire metà danni, se lo supera non subisce alcun danno e '
            'se lo fallisce subisce solo metà danni.',
      ),
      ownerId: FeatIds.mountedCombatant,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'mounted_combatant_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'mounted_melee_attacks',
          condition: 'target_smaller_than_mount',
        ),
        CharacterRuleEffect(
          id: 'mounted_combatant_redirect_attack',
          type: CharacterRuleEffectType.reaction,
          target: 'mount_targeting_attack',
        ),
        CharacterRuleEffect(
          id: 'mounted_combatant_mount_evasion',
          type: CharacterRuleEffectType.conditional,
          target: 'mount_dexterity_save',
          condition: 'evasion',
        ),
      ],
    ),
  ),
  FeatIds.observant: FeatDefinition(
    id: FeatIds.observant,
    name: 'Osservatore',
    content: RuleContent(
      id: FeatIds.observant,
      name: 'Osservatore',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora attenzione e capacità di osservazione.',
        details:
            'Migliora una caratteristica mentale e alcune capacità legate all’osservazione.',
      ),
      ownerId: FeatIds.observant,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'observant_ability',
          label: 'Caratteristica di Osservatore',
          type: CharacterChoiceType.ability,
          optionIds: ['INT', 'SAG'],
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'observant_passive_perception',
          type: CharacterRuleEffectType.conditional,
          target: 'passive_perception',
        ),
        CharacterRuleEffect(
          id: 'observant_passive_investigation',
          type: CharacterRuleEffectType.conditional,
          target: 'passive_investigation',
        ),
      ],
    ),
  ),
  FeatIds.polearmMaster: FeatDefinition(
    id: FeatIds.polearmMaster,
    name: 'Maestro delle Armi ad Asta',
    content: RuleContent(
      id: FeatIds.polearmMaster,
      name: 'Maestro delle Armi ad Asta',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Sfrutti al massimo alabarde, lance, bastoni ferrati e picche.',
        details:
            'Quando usi l’azione Attaccare con un’alabarda, una lancia, un '
            'bastone ferrato, un quarto di bastone o una picca, puoi usare '
            'un’azione bonus per effettuare un attacco con l’estremità '
            'opposta dell’arma. Inoltre, mentre impugni una di queste armi, '
            'le creature provocano un attacco di opportunità quando entrano '
            'nella tua portata.',
      ),
      ownerId: FeatIds.polearmMaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'polearm_master_bonus_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'polearm_bonus_attack',
        ),
        CharacterRuleEffect(
          id: 'polearm_master_opportunity_reach',
          type: CharacterRuleEffectType.reaction,
          target: 'opportunity_attack_on_entering_reach',
        ),
      ],
    ),
  ),
  FeatIds.resilient: FeatDefinition(
    id: FeatIds.resilient,
    name: 'Resiliente',
    content: RuleContent(
      id: FeatIds.resilient,
      name: 'Resiliente',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora una caratteristica e il relativo tiro salvezza.',
        details:
            'Aumenta una caratteristica scelta e conferisce competenza nel relativo tiro salvezza.',
      ),
      ownerId: FeatIds.resilient,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'resilient_ability',
          label: 'Caratteristica di Resiliente',
          type: CharacterChoiceType.ability,
          options: [
            CharacterChoiceOptionDefinition(
              id: 'FOR',
              label: 'Forza',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'FOR', amount: 1),
                ],
                savingThrowProficiencies: {'FOR'},
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'DES',
              label: 'Destrezza',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'DES', amount: 1),
                ],
                savingThrowProficiencies: {'DES'},
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'COS',
              label: 'Costituzione',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'COS', amount: 1),
                ],
                savingThrowProficiencies: {'COS'},
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'INT',
              label: 'Intelligenza',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'INT', amount: 1),
                ],
                savingThrowProficiencies: {'INT'},
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'SAG',
              label: 'Saggezza',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'SAG', amount: 1),
                ],
                savingThrowProficiencies: {'SAG'},
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'CAR',
              label: 'Carisma',
              effects: CharacterEffects(
                abilityBonuses: [
                  AbilityBonusDefinition(ability: 'CAR', amount: 1),
                ],
                savingThrowProficiencies: {'CAR'},
              ),
            ),
          ],
        ),
      ],
    ),
  ),
  FeatIds.ritualCaster: FeatDefinition(
    id: FeatIds.ritualCaster,
    name: 'Incantatore Rituale',
    content: RuleContent(
      id: FeatIds.ritualCaster,
      name: 'Incantatore Rituale',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Apprendi un libro dei rituali e puoi ampliare il tuo repertorio.',
        details:
            'Scegli una classe incantatrice. Ricevi un libro dei rituali con '
            'due incantesimi rituali di 1° livello della lista di quella '
            'classe. Puoi aggiungere altri incantesimi rituali trovati durante '
            'le avventure seguendo le regole del talento.',
      ),
      ownerId: FeatIds.ritualCaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ritual_caster_spellbook',
          type: CharacterRuleEffectType.spellcasting,
          target: 'ritual_book',
        ),
        CharacterRuleEffect(
          id: 'ritual_caster_learn_rituals',
          type: CharacterRuleEffectType.conditional,
          target: 'ritual_spells',
        ),
      ],
    ),
  ),
  FeatIds.savageAttacker: FeatDefinition(
    id: FeatIds.savageAttacker,
    name: 'Aggressore Selvaggio',
    content: RuleContent(
      id: FeatIds.savageAttacker,
      name: 'Aggressore Selvaggio',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Permette di ritirare i danni di un attacco con arma da mischia.',
        details: 'Una volta per turno, quando tira i danni di un attacco '
            'con un’arma da mischia, il personaggio può ripetere il '
            'tiro per i danni dell’arma e scegliere quale risultato usare.',
      ),
      ownerId: FeatIds.savageAttacker,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'savage_attacker_melee_weapon_damage_reroll',
          type: CharacterRuleEffectType.conditional,
          target: 'melee_weapon_damage_roll',
          condition: 'once_per_turn',
        ),
      ],
    ),
  ),
  FeatIds.sentinel: FeatDefinition(
    id: FeatIds.sentinel,
    name: 'Sentinella',
    content: RuleContent(
      id: FeatIds.sentinel,
      name: 'Sentinella',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Blocchi i nemici e punisci i loro movimenti.',
        details:
            'Quando colpisci una creatura con un attacco di opportunità, la '
            'sua velocità diventa 0 per il resto del turno. Le creature '
            'provocano attacchi di opportunità anche se usano Disimpegno. '
            'Quando una creatura entro 1,5 metri da te attacca un bersaglio '
            'diverso da te, puoi usare la tua reazione per effettuare un '
            'attacco in mischia contro quella creatura.',
      ),
      ownerId: FeatIds.sentinel,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'sentinel_speed_zero',
          type: CharacterRuleEffectType.conditional,
          target: 'opportunity_attack',
          condition: 'speed_becomes_zero',
        ),
        CharacterRuleEffect(
          id: 'sentinel_ignore_disengage',
          type: CharacterRuleEffectType.reaction,
          target: 'opportunity_attack',
          condition: 'target_used_disengage',
        ),
        CharacterRuleEffect(
          id: 'sentinel_protect_ally',
          type: CharacterRuleEffectType.reaction,
          target: 'melee_attack_against_adjacent_enemy',
          condition: 'enemy_attacks_other_target',
        ),
      ],
    ),
  ),
  FeatIds.sharpshooter: FeatDefinition(
    id: FeatIds.sharpshooter,
    name: 'Tiratore Scelto',
    content: RuleContent(
      id: FeatIds.sharpshooter,
      name: 'Tiratore Scelto',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Massimizzi l’efficacia degli attacchi a distanza.',
        details:
            'Attaccare a lunga gittata non impone svantaggio, i tuoi attacchi '
            'a distanza ignorano mezza copertura e tre quarti di copertura e '
            'prima di effettuare un attacco con un’arma a distanza con cui sei '
            'competente puoi scegliere di subire una penalità di −5 al tiro '
            'per colpire; se colpisci infliggi +10 danni.',
      ),
      ownerId: FeatIds.sharpshooter,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'sharpshooter_ignore_long_range_disadvantage',
          type: CharacterRuleEffectType.conditional,
          target: 'ranged_attack',
          condition: 'ignore_long_range_disadvantage',
        ),
        CharacterRuleEffect(
          id: 'sharpshooter_ignore_cover',
          type: CharacterRuleEffectType.conditional,
          target: 'ranged_attack_cover',
          condition: 'half_and_three_quarters_cover',
        ),
        CharacterRuleEffect(
          id: 'sharpshooter_power_shot',
          type: CharacterRuleEffectType.conditional,
          target: 'ranged_attack',
          value: 10,
          condition: 'minus_five_to_hit',
        ),
      ],
    ),
  ),
  FeatIds.shieldMaster: FeatDefinition(
    id: FeatIds.shieldMaster,
    name: 'Maestro dello Scudo',
    content: RuleContent(
      id: FeatIds.shieldMaster,
      name: 'Maestro dello Scudo',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Sfrutti lo scudo sia in difesa che in attacco.',
        details: 'Se effettui l’azione Attaccare nel tuo turno, puoi usare '
            'un’azione bonus per tentare di spingere una creatura entro 1,5 '
            'metri con lo scudo. Se non sei incapacitato, puoi aggiungere il '
            'bonus di CA dello scudo ai tiri salvezza su Destrezza contro '
            'effetti che bersagliano solo te. Se un effetto ti consente di '
            'effettuare un tiro salvezza su Destrezza per dimezzare i danni, '
            'puoi usare la tua reazione per non subire danni in caso di '
            'successo.',
      ),
      ownerId: FeatIds.shieldMaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'shield_master_bonus_shove',
          type: CharacterRuleEffectType.conditional,
          target: 'bonus_action_shove',
          condition: 'after_attack_action',
        ),
        CharacterRuleEffect(
          id: 'shield_master_dexterity_save_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'dexterity_saving_throw',
          condition: 'add_shield_ac_bonus',
        ),
        CharacterRuleEffect(
          id: 'shield_master_evasion',
          type: CharacterRuleEffectType.reaction,
          target: 'dexterity_save_half_damage',
          condition: 'take_no_damage_on_success',
        ),
      ],
    ),
  ),
  FeatIds.skilled: FeatDefinition(
    id: FeatIds.skilled,
    name: 'Abile',
    content: RuleContent(
      id: FeatIds.skilled,
      name: 'Abile',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Concede tre nuove competenze a scelta.',
        details: 'Permette di acquisire tre competenze scegliendo tra abilità '
            'e strumenti.',
      ),
      ownerId: FeatIds.skilled,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'skilled_proficiencies',
          requireNewAcquisition: true,
          label: 'Tre competenze di Abile',
          type: CharacterChoiceType.other,
          minimumSelections: 3,
          maximumSelections: 3,
        ),
      ],
    ),
  ),
  FeatIds.skulker: FeatDefinition(
    id: FeatIds.skulker,
    name: 'Appostato',
    content: RuleContent(
      id: FeatIds.skulker,
      name: 'Appostato',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Migliora la capacità di nascondersi, attaccare da nascosto '
            'e vedere in luce fioca.',
        details: 'Permette di tentare di nascondersi quando si è leggermente '
            'oscurati rispetto alla creatura da cui ci si nasconde. '
            'Mancare con un attacco con arma a distanza mentre si è '
            'nascosti non rivela la propria posizione. La luce fioca '
            'non impone svantaggio alle prove di Saggezza (Percezione) '
            'basate sulla vista.',
      ),
      ownerId: FeatIds.skulker,
    ),
    prerequisites: [
      FeatPrerequisite(
        type: FeatPrerequisiteType.minimumAbility,
        value: 'DES',
        minimum: 13,
      ),
    ],
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'skulker_hide_lightly_obscured',
          type: CharacterRuleEffectType.conditional,
          target: 'hide',
          condition: 'lightly_obscured_from_target',
        ),
        CharacterRuleEffect(
          id: 'skulker_ranged_miss_keeps_hidden',
          type: CharacterRuleEffectType.conditional,
          target: 'hidden_position_reveal',
          condition: 'miss_with_ranged_weapon_attack_while_hidden',
        ),
        CharacterRuleEffect(
          id: 'skulker_dim_light_visual_perception',
          type: CharacterRuleEffectType.conditional,
          target: 'visual_perception_disadvantage',
          condition: 'dim_light',
        ),
      ],
    ),
  ),
  FeatIds.spellSniper: FeatDefinition(
    id: FeatIds.spellSniper,
    name: 'Cecchino Arcano',
    content: RuleContent(
      id: FeatIds.spellSniper,
      name: 'Cecchino Arcano',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Raddoppia la gittata degli incantesimi con attacco e ignora la copertura.',
        details:
            'La gittata degli incantesimi che richiedono un tiro per colpire '
            'raddoppia. I tuoi attacchi con incantesimo ignorano mezza copertura '
            'e tre quarti di copertura. Inoltre apprendi un trucchetto che '
            'richiede un tiro per colpire dalla lista di una classe.',
      ),
      ownerId: FeatIds.spellSniper,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'spell_sniper_cantrip',
          label: 'Trucchetto',
          type: CharacterChoiceType.cantrip,
          catalogId: CharacterChoiceCatalogIds.spells,
          constraints: [
            CharacterChoiceConstraint(
              key: CharacterChoiceConstraintKeys.spellLevel,
              values: ['0'],
            ),
          ],
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'spell_sniper_double_range',
          type: CharacterRuleEffectType.spellcasting,
          target: 'spell_attack_range',
          value: 2,
        ),
        CharacterRuleEffect(
          id: 'spell_sniper_ignore_cover',
          type: CharacterRuleEffectType.spellcasting,
          target: 'spell_attack_cover',
          condition: 'ignore_half_and_three_quarters_cover',
        ),
        CharacterRuleEffect(
          id: 'spell_sniper_bonus_cantrip',
          type: CharacterRuleEffectType.spellcasting,
          target: 'bonus_cantrip',
          value: 1,
        ),
      ],
    ),
  ),
  FeatIds.tavernBrawler: FeatDefinition(
    id: FeatIds.tavernBrawler,
    name: 'Combattente da Taverna',
    content: RuleContent(
      id: FeatIds.tavernBrawler,
      name: 'Combattente da Taverna',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Migliora Forza o Costituzione e potenzia il combattimento improvvisato.',
        details: 'Conferisce un aumento di Forza o Costituzione e capacità '
            'speciali con armi improvvisate, colpi senz’armi e lotta.',
      ),
      ownerId: FeatIds.tavernBrawler,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'tavern_brawler_ability',
          label: 'Caratteristica di Combattente da Taverna',
          type: CharacterChoiceType.ability,
          optionIds: ['FOR', 'COS'],
          minimumSelections: 1,
          maximumSelections: 1,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'tavern_brawler_improvised_weapons',
          type: CharacterRuleEffectType.conditional,
          target: 'improvised_weapons',
        ),
        CharacterRuleEffect(
          id: 'tavern_brawler_unarmed_strike',
          type: CharacterRuleEffectType.damageBonus,
          target: 'unarmed_strike',
        ),
        CharacterRuleEffect(
          id: 'tavern_brawler_bonus_grapple',
          type: CharacterRuleEffectType.conditional,
          target: 'grapple',
          condition: 'after_unarmed_or_improvised_weapon_hit',
        ),
      ],
    ),
  ),
  FeatIds.tough: FeatDefinition(
    id: FeatIds.tough,
    name: 'Robusto',
    content: RuleContent(
      id: FeatIds.tough,
      name: 'Robusto',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Aumenta permanentemente i punti ferita.',
        details:
            'Aumenta i punti ferita massimi in funzione del livello del personaggio.',
      ),
      ownerId: FeatIds.tough,
    ),
    effects: CharacterEffects(
      hitPointsPerLevelBonus: 2,
    ),
  ),
  FeatIds.warCaster: FeatDefinition(
    id: FeatIds.warCaster,
    name: 'Incantatore da Guerra',
    content: RuleContent(
      id: FeatIds.warCaster,
      name: 'Incantatore da Guerra',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Mantieni più facilmente la concentrazione e lanci incantesimi anche con le mani occupate.',
        details:
            'Hai vantaggio ai tiri salvezza su Costituzione per mantenere la '
            'concentrazione su un incantesimo. Puoi eseguire le componenti '
            'somatiche degli incantesimi anche quando hai armi o scudi in '
            'entrambe le mani. Quando una creatura provoca un attacco di '
            'opportunità da parte tua, puoi usare la tua reazione per lanciare '
            'un incantesimo che bersaglia solo quella creatura invece di '
            'effettuare un attacco di opportunità.',
      ),
      ownerId: FeatIds.warCaster,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'war_caster_concentration_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'concentration_saving_throws',
        ),
        CharacterRuleEffect(
          id: 'war_caster_somatic_components',
          type: CharacterRuleEffectType.spellcasting,
          target: 'somatic_components_with_occupied_hands',
        ),
        CharacterRuleEffect(
          id: 'war_caster_spell_opportunity_attack',
          type: CharacterRuleEffectType.reaction,
          target: 'opportunity_spell',
          condition: 'single_target_spell',
        ),
      ],
    ),
  ),
  FeatIds.fightingInitiate: FeatDefinition(
    id: FeatIds.fightingInitiate,
    name: 'Iniziato al Combattimento',
    content: RuleContent(
      id: FeatIds.fightingInitiate,
      name: 'Iniziato al Combattimento',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary: 'Apprendi uno stile di combattimento.',
        details: 'Scegli uno stile di combattimento disponibile. '
            'Non puoi scegliere uno stile che possiedi già.',
      ),
      ownerId: FeatIds.fightingInitiate,
    ),
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'grant_fighting_style',
          type: CharacterRuleEffectType.conditional,
          target: 'fighting_style',
          value: 1,
        ),
      ],
    ),
  ),
  FeatIds.weaponMaster: FeatDefinition(
    id: FeatIds.weaponMaster,
    name: 'Maestro d’Armi',
    content: RuleContent(
      id: FeatIds.weaponMaster,
      name: 'Maestro d’Armi',
      type: RuleContentType.feat,
      description: RuleDescription(
        summary:
            'Migliora Forza o Destrezza e concede addestramento con nuove armi.',
        details: 'Conferisce un aumento di Forza o Destrezza e competenza '
            'con quattro armi a scelta.',
      ),
      ownerId: FeatIds.weaponMaster,
    ),
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: 'weapon_master_ability',
          label: 'Caratteristica di Maestro d’Armi',
          type: CharacterChoiceType.ability,
          optionIds: ['FOR', 'DES'],
          minimumSelections: 1,
          maximumSelections: 1,
        ),
        CharacterChoiceDefinition(
          id: 'weapon_master_weapons',
          requireNewAcquisition: true,
          label: 'Quattro armi di Maestro d’Armi',
          type: CharacterChoiceType.weapon,
          minimumSelections: 4,
          maximumSelections: 4,
        ),
      ],
    ),
  ),
};

FeatDefinition? featDefinitionFor(String id) => featDefinitions[id];

String featNameFor(String id) => featDefinitions[id]?.name ?? id;

/// Risultato runtime di un talento dopo l'applicazione delle sue choice.
class ResolvedFeatEffects {
  final FeatDefinition definition;
  final CharacterEffects effects;

  const ResolvedFeatEffects({
    required this.definition,
    required this.effects,
  });
}

CharacterEffects _mergeFeatEffects(
  CharacterEffects a,
  CharacterEffects b,
) {
  return CharacterEffects(
    abilityBonuses: [
      ...a.abilityBonuses,
      ...b.abilityBonuses,
    ],
    skillProficiencies: {
      ...a.skillProficiencies,
      ...b.skillProficiencies,
    },
    savingThrowProficiencies: {
      ...a.savingThrowProficiencies,
      ...b.savingThrowProficiencies,
    },
    weaponProficiencies: {
      ...a.weaponProficiencies,
      ...b.weaponProficiencies,
    },
    armorProficiencies: {
      ...a.armorProficiencies,
      ...b.armorProficiencies,
    },
    toolProficiencies: {
      ...a.toolProficiencies,
      ...b.toolProficiencies,
    },
    languages: {
      ...a.languages,
      ...b.languages,
    },
    damageResistances: {
      ...a.damageResistances,
      ...b.damageResistances,
    },
    savingThrowAdvantageAgainst: {
      ...a.savingThrowAdvantageAgainst,
      ...b.savingThrowAdvantageAgainst,
    },
    conditionImmunities: {
      ...a.conditionImmunities,
      ...b.conditionImmunities,
    },
    darkvisionRange: b.darkvisionRange ?? a.darkvisionRange,
    walkingSpeedOverride: b.walkingSpeedOverride ?? a.walkingSpeedOverride,
    hitPointsPerLevelBonus: a.hitPointsPerLevelBonus + b.hitPointsPerLevelBonus,
    armorClassBonus: a.armorClassBonus + b.armorClassBonus,
    initiativeBonus: a.initiativeBonus + b.initiativeBonus,
    walkingSpeedBonus: a.walkingSpeedBonus + b.walkingSpeedBonus,
    grantedFeatureIds: [
      ...a.grantedFeatureIds,
      ...b.grantedFeatureIds,
    ],
    grantedFeatIds: [
      ...a.grantedFeatIds,
      ...b.grantedFeatIds,
    ],
    grantedSpellIds: [
      ...a.grantedSpellIds,
      ...b.grantedSpellIds,
    ],
    grantedCantripIds: [
      ...a.grantedCantripIds,
      ...b.grantedCantripIds,
    ],
    grantedEquipmentIds: [
      ...a.grantedEquipmentIds,
      ...b.grantedEquipmentIds,
    ],
    ruleEffects: [
      ...a.ruleEffects,
      ...b.ruleEffects,
    ],
    choices: [
      ...a.choices,
      ...b.choices,
    ],
  );
}

CharacterEffects _featChoiceEffects(
  CharacterChoiceDefinition choice,
  List<String> selectedIds,
) {
  var result = const CharacterEffects();

  for (final selectedId in selectedIds) {
    CharacterChoiceOptionDefinition? structuredOption;

    for (final option in choice.options) {
      if (option.id == selectedId) {
        structuredOption = option;
        break;
      }
    }

    if (structuredOption != null) {
      result = _mergeFeatEffects(result, structuredOption.effects);
      continue;
    }

    if (choice.id == 'skilled_proficiencies') {
      if (selectedId.startsWith('skill:')) {
        result = _mergeFeatEffects(
          result,
          CharacterEffects(
            skillProficiencies: {
              selectedId.substring('skill:'.length),
            },
          ),
        );
        continue;
      }

      if (selectedId.startsWith('tool:')) {
        result = _mergeFeatEffects(
          result,
          CharacterEffects(
            toolProficiencies: {
              selectedId.substring('tool:'.length),
            },
          ),
        );
        continue;
      }
    }

    final CharacterEffects selectedEffect;

    switch (choice.type) {
      case CharacterChoiceType.ability:
        selectedEffect = CharacterEffects(
          abilityBonuses: [
            AbilityBonusDefinition(
              ability: selectedId,
              amount: 1,
            ),
          ],
        );

      case CharacterChoiceType.skill:
        selectedEffect = CharacterEffects(
          skillProficiencies: {selectedId},
        );

      case CharacterChoiceType.language:
        selectedEffect = CharacterEffects(
          languages: {selectedId},
        );

      case CharacterChoiceType.tool:
        selectedEffect = CharacterEffects(
          toolProficiencies: {selectedId},
        );

      case CharacterChoiceType.weapon:
        selectedEffect = CharacterEffects(
          weaponProficiencies: {selectedId},
        );

      case CharacterChoiceType.armor:
        selectedEffect = CharacterEffects(
          armorProficiencies: {selectedId},
        );

      case CharacterChoiceType.feat:
        selectedEffect = CharacterEffects(
          grantedFeatIds: [selectedId],
        );

      case CharacterChoiceType.spell:
        selectedEffect = CharacterEffects(
          grantedSpellIds: [selectedId],
        );

      case CharacterChoiceType.cantrip:
        selectedEffect = CharacterEffects(
          grantedCantripIds: [selectedId],
        );

      case CharacterChoiceType.equipment:
        selectedEffect = CharacterEffects(
          grantedEquipmentIds: [selectedId],
        );

      case CharacterChoiceType.subclass:
      case CharacterChoiceType.other:
        selectedEffect = const CharacterEffects();
    }

    result = _mergeFeatEffects(result, selectedEffect);
  }

  return result;
}

/// Risolve gli effetti effettivi di un talento.
///
/// `selections` usa come chiave l'ID della CharacterChoiceDefinition.
ResolvedFeatEffects? resolveFeatEffects({
  required String featId,
  Map<String, List<String>> selections = const {},
}) {
  final definition = featDefinitionFor(featId);

  if (definition == null) {
    return null;
  }

  var effects = definition.effects;

  for (final choice in definition.effects.choices) {
    effects = _mergeFeatEffects(
      effects,
      _featChoiceEffects(
        choice,
        selections[choice.id] ?? const [],
      ),
    );
  }

  return ResolvedFeatEffects(
    definition: definition,
    effects: effects,
  );
}

/// Converte i prerequisiti canonici di un talento nel formato universale
/// usato da CharacterEligibility.
///
/// Questo adattatore mantiene FeatDefinition indipendente dalla UI e
/// permette allo stesso evaluator di essere riutilizzato dal multiclasse.
List<CharacterRequirement> featCharacterRequirements(
  FeatDefinition feat,
) {
  return feat.prerequisites.map((prerequisite) {
    switch (prerequisite.type) {
      case FeatPrerequisiteType.minimumAbility:
        return CharacterRequirement(
          type: CharacterRequirementType.minimumAbility,
          value: prerequisite.value,
          minimum: prerequisite.minimum,
        );

      case FeatPrerequisiteType.race:
        return CharacterRequirement(
          type: CharacterRequirementType.race,
          value: prerequisite.value,
        );

      case FeatPrerequisiteType.proficiency:
        return CharacterRequirement(
          type: CharacterRequirementType.proficiency,
          value: prerequisite.value,
        );

      case FeatPrerequisiteType.spellcasting:
        return CharacterRequirement(
          type: CharacterRequirementType.spellcasting,
          value: prerequisite.value,
        );

      case FeatPrerequisiteType.other:
        return CharacterRequirement(
          type: CharacterRequirementType.other,
          value: prerequisite.value,
        );
    }
  }).toList(growable: false);
}

/// Valuta tutti i prerequisiti di un talento.
///
/// Un risultato negativo impedisce la conferma del talento, non la sua
/// consultazione nell'interfaccia.
CharacterEligibilityResult evaluateFeatEligibility({
  required FeatDefinition feat,
  required CharacterEligibilityState state,
}) {
  return evaluateCharacterEligibility(
    requirements: featCharacterRequirements(feat),
    state: state,
  );
}
