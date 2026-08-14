import 'armor_data.dart';
import 'character_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_data.dart';
import 'equipment_pack_data.dart';
import 'tool_data.dart';
import 'spell_data.dart';

const _phbRogueSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 94-96',
);

class RogueSubclassIds {
  static const thief = 'thief';
  static const assassin = 'assassin';
  static const arcaneTrickster = 'arcane_trickster';
}

abstract final class RogueFeatureIds {
  static const expertise = 'expertise';
  static const sneakAttack = 'sneak_attack';
  static const thievesCant = 'thieves_cant';
  static const cunningAction = 'cunning_action';
  static const roguishArchetype = 'roguish_archetype';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const uncannyDodge = 'uncanny_dodge';
  static const expertiseImprovement = 'expertise_improvement';
  static const evasion = 'evasion';
  static const reliableTalent = 'reliable_talent';
  static const blindsense = 'blindsense';
  static const slipperyMind = 'slippery_mind';
  static const elusive = 'elusive';
  static const strokeOfLuck = 'stroke_of_luck';
}

abstract final class RogueResourceIds {
  static const strokeOfLuck = 'stroke_of_luck';
}

abstract final class RogueProgressionIds {
  static const sneakAttackDice = 'sneak_attack_dice';
}

const rogueSkillLabels = <String, String>{
  'acrobatics': 'Acrobazia',
  'athletics': 'Atletica',
  'deception': 'Inganno',
  'insight': 'Intuizione',
  'intimidation': 'Intimidire',
  'investigation': 'Indagare',
  'perception': 'Percezione',
  'performance': 'Intrattenere',
  'persuasion': 'Persuasione',
  'sleight_of_hand': 'Rapidità di Mano',
  'stealth': 'Furtività',
};

final rogueExpertiseOptions = <CharacterChoiceOptionDefinition>[
  for (final entry in rogueSkillLabels.entries)
    CharacterChoiceOptionDefinition(
      id: entry.key,
      label: entry.value,
    ),
  CharacterChoiceOptionDefinition(
    id: ToolIds.thievesTools,
    label: toolDefinitions[ToolIds.thievesTools]!.name,
  ),
];

const _rogueFeatureSpecs = <String, List<String>>{
  RogueFeatureIds.expertise: [
    'Maestria',
    'Il Ladro raddoppia il bonus di competenza in due competenze possedute.',
    'Al 1° livello sceglie due competenze tra le proprie abilità e gli Strumenti da Scasso. Il bonus di competenza viene raddoppiato per qualsiasi prova che utilizzi una delle competenze scelte.',
  ],
  RogueFeatureIds.sneakAttack: [
    'Attacco Furtivo',
    'Il Ladro sfrutta una distrazione per infliggere danni aggiuntivi.',
    'Una volta per turno, quando colpisce con un’arma accurata o a distanza, infligge danni aggiuntivi se dispone di vantaggio. Non necessita di vantaggio se un nemico del bersaglio non incapacitato si trova entro 1,5 metri dal bersaglio e il Ladro non dispone di svantaggio.',
  ],
  RogueFeatureIds.thievesCant: [
    'Gergo Ladresco',
    'Il Ladro conosce un linguaggio segreto utilizzato negli ambienti criminali.',
    'Durante una normale conversazione può nascondere messaggi comprensibili soltanto a chi conosce il Gergo Ladresco. Conosce inoltre segni e simboli segreti usati per comunicare brevi informazioni.',
  ],
  RogueFeatureIds.cunningAction: [
    'Azione Scaltra',
    'Il Ladro può Scattare, Disimpegnarsi o Nascondersi con un’azione bonus.',
    'Dal 2° livello può usare un’azione bonus in ogni proprio turno per effettuare l’azione Scatto, Disimpegno o Nascondersi.',
  ],
  RogueFeatureIds.roguishArchetype: [
    'Archetipo Ladresco',
    'Il Ladro sceglie il proprio campo di specializzazione.',
    'Al 3° livello sceglie Furfante, Assassino o Mistificatore Arcano. L’archetipo concede ulteriori privilegi ai livelli 9, 13 e 17.',
  ],
  RogueFeatureIds.abilityScoreImprovement: [
    'Aumento dei Punteggi di Caratteristica',
    'Il Ladro migliora le proprie caratteristiche o sceglie un talento.',
    'Ottiene questo privilegio ai livelli 4, 8, 10, 12, 16 e 19 seguendo le regole generali dell’avanzamento.',
  ],
  RogueFeatureIds.uncannyDodge: [
    'Schivata Prodigiosa',
    'Il Ladro dimezza i danni di un attacco che riesce a vedere.',
    'Dal 5° livello, quando un attaccante che può vedere lo colpisce, il Ladro può usare la propria reazione per dimezzare i danni dell’attacco.',
  ],
  RogueFeatureIds.expertiseImprovement: [
    'Maestria Aggiuntiva',
    'Il Ladro ottiene Maestria in altre due competenze possedute.',
    'Al 6° livello sceglie altre due competenze tra le proprie abilità e gli Strumenti da Scasso nelle quali raddoppiare il bonus di competenza.',
  ],
  RogueFeatureIds.evasion: [
    'Elusione',
    'Il Ladro evita completamente alcuni effetti ad area.',
    'Dal 7° livello, quando un effetto consente un tiro salvezza su Destrezza per dimezzare i danni, non subisce danni se supera il tiro e subisce soltanto metà dei danni se lo fallisce.',
  ],
  RogueFeatureIds.reliableTalent: [
    'Dote Affidabile',
    'Le competenze padroneggiate dal Ladro producono risultati costanti.',
    'Dall’11° livello, quando effettua una prova di caratteristica alla quale aggiunge il bonus di competenza, può considerare un risultato del d20 pari o inferiore a 9 come un 10.',
  ],
  RogueFeatureIds.blindsense: [
    'Percezione Cieca',
    'Il Ladro percepisce le creature nascoste o invisibili nelle vicinanze.',
    'Dal 14° livello, se è in grado di sentire, conosce la posizione di qualsiasi creatura nascosta o invisibile entro 3 metri.',
  ],
  RogueFeatureIds.slipperyMind: [
    'Mente Sfuggente',
    'Il Ladro sviluppa una maggiore resistenza mentale.',
    'Dal 15° livello ottiene competenza nei tiri salvezza su Saggezza.',
  ],
  RogueFeatureIds.elusive: [
    'Inafferrabile',
    'Gli avversari non possono ottenere vantaggio contro il Ladro.',
    'Dal 18° livello nessun tiro per colpire dispone di vantaggio contro il Ladro finché egli non è incapacitato.',
  ],
  RogueFeatureIds.strokeOfLuck: [
    'Colpo di Fortuna',
    'Il Ladro trasforma un fallimento decisivo in un successo.',
    'Al 20° livello può trasformare un proprio attacco mancato in un colpo oppure considerare il risultato di una prova di caratteristica fallita come un 20 naturale. Recupera l’utilizzo dopo un riposo breve o lungo.',
  ],
};

List<CharacterChoiceDefinition> _rogueFeatureChoices(String id) {
  if (id == RogueFeatureIds.expertise) {
    return [
      CharacterChoiceDefinition(
        id: 'rogue_expertise_level_1',
        label: 'Scegli due competenze per Maestria',
        type: CharacterChoiceType.other,
        minimumSelections: 2,
        maximumSelections: 2,
        options: rogueExpertiseOptions,
        requireExistingAcquisition: true,
      ),
    ];
  }

  if (id == RogueFeatureIds.expertiseImprovement) {
    return [
      CharacterChoiceDefinition(
        id: 'rogue_expertise_level_6',
        label: 'Scegli altre due competenze per Maestria',
        type: CharacterChoiceType.other,
        minimumSelections: 2,
        maximumSelections: 2,
        options: rogueExpertiseOptions,
        requireExistingAcquisition: true,
      ),
    ];
  }

  return const [];
}

CharacterEffects _rogueFeatureEffects(String id) {
  if (id == RogueFeatureIds.sneakAttack) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_sneak_attack_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: RogueProgressionIds.sneakAttackDice,
          condition:
              'once_per_turn_finesse_or_ranged_weapon_and_advantage_or_adjacent_enemy_of_target_without_disadvantage',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.thievesCant) {
    return const CharacterEffects(
      languages: {
        'thieves_cant',
      },
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_thieves_cant_hidden_message',
          type: CharacterRuleEffectType.conditional,
          target: 'hidden_messages',
          condition: 'conversation_or_secret_signs',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.cunningAction) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_cunning_action_dash',
          type: CharacterRuleEffectType.conditional,
          target: 'dash',
          condition: 'bonus_action_on_own_turn',
        ),
        CharacterRuleEffect(
          id: 'rogue_cunning_action_disengage',
          type: CharacterRuleEffectType.conditional,
          target: 'disengage',
          condition: 'bonus_action_on_own_turn',
        ),
        CharacterRuleEffect(
          id: 'rogue_cunning_action_hide',
          type: CharacterRuleEffectType.conditional,
          target: 'hide',
          condition: 'bonus_action_on_own_turn',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.uncannyDodge) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_uncanny_dodge_damage_reduction',
          type: CharacterRuleEffectType.reaction,
          target: 'incoming_attack_damage',
          value: 0.5,
          condition: 'visible_attacker_hits_rogue',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.evasion) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_evasion_success',
          type: CharacterRuleEffectType.conditional,
          target: 'dexterity_save_half_damage_effect',
          value: 0,
          condition: 'successful_dexterity_saving_throw',
        ),
        CharacterRuleEffect(
          id: 'rogue_evasion_failure',
          type: CharacterRuleEffectType.conditional,
          target: 'dexterity_save_half_damage_effect',
          value: 0.5,
          condition: 'failed_dexterity_saving_throw',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.reliableTalent) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_reliable_talent_minimum_roll',
          type: CharacterRuleEffectType.conditional,
          target: 'proficient_ability_check_d20',
          value: 10,
          condition: 'natural_d20_result_9_or_lower',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.blindsense) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_blindsense_range',
          type: CharacterRuleEffectType.passiveScoreBonus,
          target: 'hidden_or_invisible_creature_location',
          value: 3,
          condition: 'rogue_can_hear',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.slipperyMind) {
    return const CharacterEffects(
      savingThrowProficiencies: {
        'SAG',
      },
    );
  }

  if (id == RogueFeatureIds.elusive) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_elusive_prevents_advantage',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_roll_advantage_against_rogue',
          condition: 'rogue_not_incapacitated',
        ),
      ],
    );
  }

  if (id == RogueFeatureIds.strokeOfLuck) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'rogue_stroke_of_luck_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'missed_attack',
          value: 1,
          condition: 'turn_miss_into_hit',
        ),
        CharacterRuleEffect(
          id: 'rogue_stroke_of_luck_ability_check',
          type: CharacterRuleEffectType.conditional,
          target: 'failed_ability_check',
          value: 20,
          condition: 'treat_d20_roll_as_20',
        ),
      ],
    );
  }

  return const CharacterEffects();
}

String? _rogueFeatureResourceId(String id) =>
    id == RogueFeatureIds.strokeOfLuck ? RogueResourceIds.strokeOfLuck : null;

CharacterClassFeatureDefinition _rogueFeature(
  String id,
  List<String> spec,
) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: spec[0],
        type: RuleContentType.classFeature,
        description: RuleDescription(
          summary: spec[1],
          details: spec[2],
        ),
        source: _phbRogueSource,
        ownerId: ClassIds.rogue,
      ),
      resourceId: _rogueFeatureResourceId(id),
      choices: _rogueFeatureChoices(id),
      effects: _rogueFeatureEffects(id),
      ruleTags: {
        'class_feature',
        'rogue',
        if (id == RogueFeatureIds.sneakAttack) ...{
          'once_per_turn',
          'finesse_or_ranged_weapon',
          'extra_damage',
        },
        if (id == RogueFeatureIds.cunningAction) ...{
          'bonus_action',
          'dash',
          'disengage',
          'hide',
        },
        if (id == RogueFeatureIds.uncannyDodge) ...{
          'reaction',
          'halve_damage',
        },
        if (id == RogueFeatureIds.evasion) ...{
          'dexterity_saving_throw',
          'damage_reduction',
        },
        if (id == RogueFeatureIds.strokeOfLuck) ...{
          'short_or_long_rest_recovery',
          'turn_failure_into_success',
        },
      },
    );

final rogueFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _rogueFeatureSpecs.entries)
    entry.key: _rogueFeature(entry.key, entry.value),
};

const _phbThiefSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 97',
);

class ThiefFeatureIds {
  static const fastHands = 'fast_hands';
  static const secondStoryWork = 'second_story_work';
  static const supremeSneak = 'supreme_sneak';
  static const useMagicDevice = 'use_magic_device';
  static const thievesReflexes = 'thieves_reflexes';
}

CharacterClassFeatureDefinition _thiefFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  required CharacterEffects effects,
  required Set<String> ruleTags,
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.subclassFeature,
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbThiefSource,
        ownerId: RogueSubclassIds.thief,
      ),
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'rogue',
        'thief',
        ...ruleTags,
      },
    );

final thiefFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  ThiefFeatureIds.fastHands: _thiefFeature(
    id: ThiefFeatureIds.fastHands,
    name: 'Mani Veloci',
    summary:
        'Il Furfante amplia gli utilizzi dell’azione bonus concessa da Azione Scaltra.',
    details:
        'Dal 3° livello può usare l’azione bonus di Azione Scaltra per effettuare una prova di Destrezza (Rapidità di Mano), usare gli Arnesi da Scasso per disarmare una trappola o aprire una serratura, oppure effettuare l’azione Usare un Oggetto.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thief_fast_hands_bonus_action',
          type: CharacterRuleEffectType.conditional,
          target: 'cunning_action_options',
          referenceIds: [
            'sleight_of_hand',
            'thieves_tools',
            'use_an_object',
          ],
          condition: 'use_as_bonus_action_through_cunning_action',
        ),
      ],
    ),
    ruleTags: {
      'bonus_action',
      'cunning_action',
      'sleight_of_hand',
      'thieves_tools',
      'use_an_object',
    },
  ),
  ThiefFeatureIds.secondStoryWork: _thiefFeature(
    id: ThiefFeatureIds.secondStoryWork,
    name: 'Lavoro al Secondo Piano',
    summary:
        'Il Furfante si arrampica più rapidamente e compie salti più lunghi.',
    details:
        'Dal 3° livello arrampicarsi non gli costa movimento aggiuntivo. Quando effettua un salto in lungo con rincorsa, la distanza aumenta di 0,3 metri per ogni punto del suo modificatore di Destrezza.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thief_second_story_climbing',
          type: CharacterRuleEffectType.movement,
          target: 'climbing_movement_cost',
          value: 1,
          condition: 'climbing_does_not_cost_extra_movement',
        ),
        CharacterRuleEffect(
          id: 'thief_second_story_running_jump',
          type: CharacterRuleEffectType.movement,
          target: 'running_jump_distance_meters',
          value: 0.3,
          condition: 'add_value_for_each_point_of_dexterity_modifier',
        ),
      ],
    ),
    ruleTags: {
      'movement',
      'climbing',
      'long_jump',
      'dexterity',
    },
  ),
  ThiefFeatureIds.supremeSneak: _thiefFeature(
    id: ThiefFeatureIds.supremeSneak,
    name: 'Furtività Suprema',
    summary:
        'Il Furfante è particolarmente abile nel muoversi senza essere scoperto.',
    details:
        'Dal 9° livello dispone di vantaggio alle prove di Destrezza (Furtività) se nello stesso turno non si muove per più della metà della propria velocità.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thief_supreme_sneak_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'dexterity_stealth_checks',
          condition: 'movement_not_greater_than_half_speed_during_same_turn',
        ),
      ],
    ),
    ruleTags: {
      'advantage',
      'stealth',
      'movement',
    },
  ),
  ThiefFeatureIds.useMagicDevice: _thiefFeature(
    id: ThiefFeatureIds.useMagicDevice,
    name: 'Utilizzare Oggetti Magici',
    summary:
        'Il Furfante può usare oggetti magici normalmente preclusi ad altri personaggi.',
    details:
        'Dal 13° livello ignora tutti i requisiti di classe, razza e livello relativi all’uso degli oggetti magici.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thief_use_magic_device_requirements',
          type: CharacterRuleEffectType.conditional,
          target: 'magic_item_use_requirements',
          referenceIds: [
            'class_requirement',
            'race_requirement',
            'level_requirement',
          ],
          condition: 'ignore_class_race_and_level_requirements',
        ),
      ],
    ),
    ruleTags: {
      'magic_item',
      'ignore_requirement',
    },
  ),
  ThiefFeatureIds.thievesReflexes: _thiefFeature(
    id: ThiefFeatureIds.thievesReflexes,
    name: 'Riflessi da Furfante',
    summary:
        'Il Furfante può effettuare due turni durante il primo round di combattimento.',
    details:
        'Dal 17° livello effettua due turni durante il primo round di ogni combattimento. Il primo avviene alla sua normale iniziativa e il secondo alla sua iniziativa meno 10. Non può beneficiare di questo privilegio quando è sorpreso.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thief_reflexes_first_round_turns',
          type: CharacterRuleEffectType.conditional,
          target: 'turns_during_first_combat_round',
          value: 2,
          condition: 'not_surprised_second_turn_at_initiative_minus_10',
        ),
      ],
    ),
    ruleTags: {
      'initiative',
      'additional_turn',
      'first_round',
    },
  ),
};

final thiefSubclassDefinition = CharacterSubclassDefinition(
  id: RogueSubclassIds.thief,
  name: 'Furfante',
  classId: ClassIds.rogue,
  content: const RuleContent(
    id: RogueSubclassIds.thief,
    name: 'Furfante',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Ladro specializzato nell’agilità, nell’infiltrazione e nell’uso rapido degli oggetti.',
      details:
          'Il Furfante perfeziona le capacità tradizionali del Ladro, muovendosi rapidamente negli ambienti urbani, agendo con grande velocità e sfruttando oggetti normalmente inaccessibili.',
    ),
    source: _phbThiefSource,
    ownerId: ClassIds.rogue,
  ),
  featuresByLevel: const {
    3: [
      ThiefFeatureIds.fastHands,
      ThiefFeatureIds.secondStoryWork,
    ],
    9: [
      ThiefFeatureIds.supremeSneak,
    ],
    13: [
      ThiefFeatureIds.useMagicDevice,
    ],
    17: [
      ThiefFeatureIds.thievesReflexes,
    ],
  },
  featureDefinitions: thiefFeatureDefinitions,
);

const _phbAssassinSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 97',
);

class AssassinFeatureIds {
  static const bonusProficiencies = 'assassin_bonus_proficiencies';
  static const assassinate = 'assassinate';
  static const infiltrationExpertise = 'infiltration_expertise';
  static const impostor = 'impostor';
  static const deathStrike = 'death_strike';
}

CharacterClassFeatureDefinition _assassinFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  CharacterEffects effects = const CharacterEffects(),
  Set<String> ruleTags = const {},
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.subclassFeature,
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbAssassinSource,
        ownerId: RogueSubclassIds.assassin,
      ),
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'rogue',
        'assassin',
        ...ruleTags,
      },
    );

final assassinFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  AssassinFeatureIds.bonusProficiencies: _assassinFeature(
    id: AssassinFeatureIds.bonusProficiencies,
    name: 'Competenze Bonus',
    summary:
        'L’Assassino apprende a utilizzare strumenti essenziali per travestimenti e veleni.',
    details:
        'Quando sceglie questo archetipo al 3° livello, ottiene competenza nel Kit da Travestimento e nel Kit da Avvelenatore.',
    effects: const CharacterEffects(
      toolProficiencies: {
        ToolIds.disguiseKit,
        ToolIds.poisonersKit,
      },
    ),
    ruleTags: {
      'tool_proficiency',
      'disguise',
      'poison',
    },
  ),
  AssassinFeatureIds.assassinate: _assassinFeature(
    id: AssassinFeatureIds.assassinate,
    name: 'Assassinare',
    summary:
        'L’Assassino colpisce con particolare efficacia i nemici impreparati.',
    details:
        'Dal 3° livello dispone di vantaggio ai tiri per colpire contro le creature che non hanno ancora effettuato un turno nel combattimento. Ogni colpo messo a segno contro una creatura sorpresa è un colpo critico.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'assassin_assassinate_attack_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'attack_rolls',
          condition: 'target_has_not_taken_a_turn_in_current_combat',
        ),
        CharacterRuleEffect(
          id: 'assassin_assassinate_surprise_critical',
          type: CharacterRuleEffectType.conditional,
          target: 'hits_against_surprised_creatures',
          condition: 'hit_is_automatically_critical',
        ),
      ],
    ),
    ruleTags: {
      'advantage',
      'attack_roll',
      'surprised',
      'critical_hit',
    },
  ),
  AssassinFeatureIds.infiltrationExpertise: _assassinFeature(
    id: AssassinFeatureIds.infiltrationExpertise,
    name: 'Maestro Infiltrato',
    summary:
        'L’Assassino può costruire una falsa identità completa e credibile.',
    details:
        'Dal 9° livello può impiegare sette giorni e 25 mo per creare una falsa identità dotata di storia, professione e affiliazioni. Non può stabilire un’identità appartenente a una persona esistente.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'assassin_false_identity_preparation_days',
          type: CharacterRuleEffectType.conditional,
          target: 'false_identity_preparation_days',
          value: 7,
          condition: 'seven_days_of_preparation',
        ),
        CharacterRuleEffect(
          id: 'assassin_false_identity_cost_gp',
          type: CharacterRuleEffectType.conditional,
          target: 'false_identity_creation_cost_gp',
          value: 25,
          condition: 'identity_includes_history_profession_and_affiliations',
        ),
        CharacterRuleEffect(
          id: 'assassin_false_identity_support',
          type: CharacterRuleEffectType.conditional,
          target: 'false_identity_credibility',
          condition:
              'other_creatures_believe_identity_until_given_reason_not_to',
        ),
      ],
    ),
    ruleTags: {
      'false_identity',
      'downtime',
      'infiltration',
    },
  ),
  AssassinFeatureIds.impostor: _assassinFeature(
    id: AssassinFeatureIds.impostor,
    name: 'Impostore',
    summary:
        'L’Assassino imita linguaggio, scrittura e comportamento di un’altra persona.',
    details:
        'Dal 13° livello, dopo avere studiato per almeno tre ore il linguaggio, la scrittura e il comportamento di una creatura, può imitarla. Dispone di vantaggio alle prove di Carisma (Inganno) effettuate per evitare che l’inganno venga scoperto.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'assassin_impostor_study_time',
          type: CharacterRuleEffectType.conditional,
          target: 'impersonation_study_hours',
          value: 3,
          condition: 'study_speech_handwriting_and_mannerisms',
        ),
        CharacterRuleEffect(
          id: 'assassin_impostor_deception_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'charisma_deception_checks',
          condition: 'prevent_detection_while_impersonating_studied_creature',
        ),
      ],
    ),
    ruleTags: {
      'impersonation',
      'deception',
      'advantage',
    },
  ),
  AssassinFeatureIds.deathStrike: _assassinFeature(
    id: AssassinFeatureIds.deathStrike,
    name: 'Colpo Mortale',
    summary: 'L’Assassino infligge danni devastanti alle creature sorprese.',
    details:
        'Dal 17° livello, quando colpisce una creatura sorpresa, il bersaglio deve superare un tiro salvezza su Costituzione con CD 8 + bonus di competenza dell’Assassino + modificatore di Destrezza dell’Assassino. Se fallisce, i danni dell’attacco vengono raddoppiati.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'assassin_death_strike_saving_throw',
          type: CharacterRuleEffectType.conditional,
          target: 'surprised_target_constitution_saving_throw',
          referenceIds: [
            'constitution',
            'dexterity',
            'proficiency_bonus',
          ],
          condition: 'dc_8_plus_dexterity_modifier_plus_proficiency_bonus',
        ),
        CharacterRuleEffect(
          id: 'assassin_death_strike_damage_multiplier',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_damage_multiplier',
          value: 2,
          condition: 'target_surprised_and_constitution_saving_throw_failed',
        ),
      ],
    ),
    ruleTags: {
      'surprised',
      'saving_throw',
      'constitution',
      'double_damage',
    },
  ),
};

final assassinSubclassDefinition = CharacterSubclassDefinition(
  id: RogueSubclassIds.assassin,
  name: 'Assassino',
  classId: ClassIds.rogue,
  content: const RuleContent(
    id: RogueSubclassIds.assassin,
    name: 'Assassino',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Ladro specializzato nell’eliminazione silenziosa, nei travestimenti e nell’infiltrazione.',
      details:
          'L’Assassino sfrutta sorpresa, false identità e imitazione per avvicinarsi ai propri bersagli e colpirli prima che possano reagire.',
    ),
    source: _phbAssassinSource,
    ownerId: ClassIds.rogue,
  ),
  featuresByLevel: const {
    3: [
      AssassinFeatureIds.bonusProficiencies,
      AssassinFeatureIds.assassinate,
    ],
    9: [
      AssassinFeatureIds.infiltrationExpertise,
    ],
    13: [
      AssassinFeatureIds.impostor,
    ],
    17: [
      AssassinFeatureIds.deathStrike,
    ],
  },
  featureDefinitions: assassinFeatureDefinitions,
);

const _phbArcaneTricksterSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 97-98',
);

class ArcaneTricksterFeatureIds {
  static const spellcasting = 'arcane_trickster_spellcasting';
  static const mageHandLegerdemain = 'mage_hand_legerdemain';
  static const magicalAmbush = 'magical_ambush';
  static const versatileTrickster = 'versatile_trickster';
  static const spellThief = 'spell_thief';
}

class ArcaneTricksterSpellPoolIds {
  static const enchantmentAndIllusion = 'arcane_trickster_enchantment_illusion';
  static const unrestricted = 'arcane_trickster_unrestricted';
}

class ArcaneTricksterResourceIds {
  static const spellThief = 'spell_thief';
}

final arcaneTricksterWizardSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.wizard))
    .map((spell) => spell.id)
    .toSet();

CharacterClassFeatureDefinition _arcaneTricksterFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> spellIds = const {},
  CharacterEffects effects = const CharacterEffects(),
  String? resourceId,
  Set<String> ruleTags = const {},
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.subclassFeature,
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbArcaneTricksterSource,
        ownerId: RogueSubclassIds.arcaneTrickster,
      ),
      spellIds: spellIds,
      effects: effects,
      resourceId: resourceId,
      ruleTags: {
        'subclass_feature',
        'rogue',
        'arcane_trickster',
        ...ruleTags,
      },
    );

final arcaneTricksterFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  ArcaneTricksterFeatureIds.spellcasting: _arcaneTricksterFeature(
    id: ArcaneTricksterFeatureIds.spellcasting,
    name: 'Incantesimi',
    summary:
        'Il Mistificatore Arcano apprende a lanciare incantesimi da Mago usando Intelligenza.',
    details:
        'Dal 3° livello apprende Mano Magica e altri trucchetti da Mago. La maggior parte degli incantesimi conosciuti deve appartenere alle scuole di Ammaliamento o Illusione, mentre quattro incantesimi possono essere scelti liberamente ai livelli 3, 8, 14 e 20.',
    spellIds: const {
      SpellIds.mageHand,
    },
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'arcane_trickster_spellcasting_progression',
          type: CharacterRuleEffectType.spellcasting,
          target: 'wizard_spellcasting',
          referenceIds: arcaneTricksterWizardSpellIds.toList(growable: false),
          condition:
              'intelligence_third_caster_enchantment_illusion_restriction',
        ),
      ],
    ),
    ruleTags: {
      'spellcasting',
      'intelligence_spellcasting',
      'third_caster',
      'wizard_spell_list',
      'mage_hand_required',
    },
  ),
  ArcaneTricksterFeatureIds.mageHandLegerdemain: _arcaneTricksterFeature(
    id: ArcaneTricksterFeatureIds.mageHandLegerdemain,
    name: 'Gioco di Prestigio della Mano Magica',
    summary:
        'Il Mistificatore Arcano usa Mano Magica per compiere azioni furtive a distanza.',
    details:
        'Dal 3° livello, quando lancia Mano Magica, la mano spettrale può essere invisibile. Può usarla per riporre o recuperare oggetti portati da altre creature e per usare gli Arnesi da Scasso a distanza. Può controllarla tramite l’azione bonus concessa da Azione Scaltra.',
    spellIds: const {
      SpellIds.mageHand,
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'arcane_trickster_invisible_mage_hand',
          type: CharacterRuleEffectType.conditional,
          target: 'mage_hand_visibility',
          referenceIds: [
            SpellIds.mageHand,
          ],
          condition: 'mage_hand_can_be_invisible',
        ),
        CharacterRuleEffect(
          id: 'arcane_trickster_mage_hand_additional_uses',
          type: CharacterRuleEffectType.conditional,
          target: 'mage_hand_additional_uses',
          referenceIds: [
            'sleight_of_hand',
            'thieves_tools',
            'carried_container',
          ],
          condition: 'stow_retrieve_objects_and_use_thieves_tools_at_range',
        ),
        CharacterRuleEffect(
          id: 'arcane_trickster_mage_hand_bonus_action',
          type: CharacterRuleEffectType.conditional,
          target: 'control_mage_hand',
          referenceIds: [
            'cunning_action',
            SpellIds.mageHand,
          ],
          condition: 'may_control_with_cunning_action_bonus_action',
        ),
      ],
    ),
    ruleTags: {
      'mage_hand',
      'bonus_action',
      'cunning_action',
      'thieves_tools',
      'sleight_of_hand',
    },
  ),
  ArcaneTricksterFeatureIds.magicalAmbush: _arcaneTricksterFeature(
    id: ArcaneTricksterFeatureIds.magicalAmbush,
    name: 'Imboscata Magica',
    summary:
        'Gli incantesimi del Mistificatore Arcano sono più difficili da resistere quando viene nascosto.',
    details:
        'Dal 9° livello, se è nascosto a una creatura quando le lancia contro un incantesimo, quella creatura dispone di svantaggio a qualsiasi tiro salvezza contro l’incantesimo durante quel turno.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'arcane_trickster_magical_ambush_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target: 'saving_throws_against_rogue_spell',
          condition:
              'rogue_hidden_from_target_when_spell_is_cast_during_same_turn',
        ),
      ],
    ),
    ruleTags: {
      'hidden',
      'spell_saving_throw',
      'disadvantage',
    },
  ),
  ArcaneTricksterFeatureIds.versatileTrickster: _arcaneTricksterFeature(
    id: ArcaneTricksterFeatureIds.versatileTrickster,
    name: 'Ingannatore Versatile',
    summary:
        'Mano Magica può distrarre un avversario e facilitare gli attacchi del Ladro.',
    details:
        'Dal 13° livello può usare un’azione bonus per designare una creatura situata entro 1,5 metri dalla mano creata da Mano Magica. Dispone di vantaggio ai tiri per colpire contro quella creatura fino alla fine del turno.',
    spellIds: const {
      SpellIds.mageHand,
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'arcane_trickster_versatile_trickster_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'attack_rolls_against_designated_creature',
          value: 1.5,
          referenceIds: [
            SpellIds.mageHand,
          ],
          condition:
              'bonus_action_target_within_1_5_meters_of_mage_hand_until_end_of_turn',
        ),
      ],
    ),
    ruleTags: {
      'mage_hand',
      'bonus_action',
      'advantage',
      'attack_roll',
    },
  ),
  ArcaneTricksterFeatureIds.spellThief: _arcaneTricksterFeature(
    id: ArcaneTricksterFeatureIds.spellThief,
    name: 'Ladro di Incantesimi',
    summary:
        'Il Mistificatore Arcano può neutralizzare e sottrarre temporaneamente un incantesimo.',
    details:
        'Dal 17° livello, subito dopo che una creatura lo bersaglia o lo include nell’area di un incantesimo, può usare la propria reazione per imporle un tiro salvezza usando la caratteristica da incantatore. Se il tiro fallisce, l’effetto contro il Ladro è negato e, se l’incantesimo è almeno di 1° livello e di un livello che può lanciare, il Ladro lo conosce per 8 ore mentre la creatura non può lanciarlo.',
    resourceId: ArcaneTricksterResourceIds.spellThief,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'arcane_trickster_spell_thief_reaction',
          type: CharacterRuleEffectType.reaction,
          target: 'spell_targeting_or_including_rogue',
          condition:
              'immediately_after_spell_is_cast_and_before_effect_resolution',
        ),
        CharacterRuleEffect(
          id: 'arcane_trickster_spell_thief_saving_throw',
          type: CharacterRuleEffectType.conditional,
          target: 'caster_spellcasting_ability_saving_throw',
          referenceIds: [
            'intelligence',
            'proficiency_bonus',
          ],
          condition: 'dc_equals_rogue_spell_save_dc',
        ),
        CharacterRuleEffect(
          id: 'arcane_trickster_spell_thief_negation',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_effect_against_rogue',
          condition: 'negated_when_caster_fails_saving_throw',
        ),
        CharacterRuleEffect(
          id: 'arcane_trickster_spell_thief_duration_hours',
          type: CharacterRuleEffectType.conditional,
          target: 'stolen_spell_duration_hours',
          value: 8,
          condition:
              'spell_level_at_least_one_and_not_above_rogue_casting_limit',
        ),
      ],
    ),
    ruleTags: {
      'reaction',
      'spell_negation',
      'stolen_spell',
      'long_rest_resource',
    },
  ),
};

final arcaneTricksterSubclassDefinition = CharacterSubclassDefinition(
  id: RogueSubclassIds.arcaneTrickster,
  name: 'Mistificatore Arcano',
  classId: ClassIds.rogue,
  content: const RuleContent(
    id: RogueSubclassIds.arcaneTrickster,
    name: 'Mistificatore Arcano',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Ladro che combina furtività, destrezza manuale e magia arcana.',
      details:
          'Il Mistificatore Arcano usa soprattutto Ammaliamento e Illusione, potenzia Mano Magica e sfrutta i propri incantesimi per distrarre, sorprendere e ingannare i nemici.',
    ),
    source: _phbArcaneTricksterSource,
    ownerId: ClassIds.rogue,
  ),
  featuresByLevel: const {
    3: [
      ArcaneTricksterFeatureIds.spellcasting,
      ArcaneTricksterFeatureIds.mageHandLegerdemain,
    ],
    9: [
      ArcaneTricksterFeatureIds.magicalAmbush,
    ],
    13: [
      ArcaneTricksterFeatureIds.versatileTrickster,
    ],
    17: [
      ArcaneTricksterFeatureIds.spellThief,
    ],
  },
  featureDefinitions: arcaneTricksterFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: ArcaneTricksterResourceIds.spellThief,
      name: 'Ladro di Incantesimi',
      minimumLevel: 17,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        17: 1,
      },
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.third,
    ability: 'INT',
    minimumLevel: 3,
    slotsByClassLevel: const {
      3: [2],
      4: [3],
      5: [3],
      6: [3],
      7: [4, 2],
      8: [4, 2],
      9: [4, 2],
      10: [4, 3],
      11: [4, 3],
      12: [4, 3],
      13: [4, 3, 2],
      14: [4, 3, 2],
      15: [4, 3, 2],
      16: [4, 3, 3],
      17: [4, 3, 3],
      18: [4, 3, 3],
      19: [4, 3, 3, 1],
      20: [4, 3, 3, 1],
    },
    cantripsKnownByLevel: const {
      3: 3,
      10: 4,
    },
    spellsKnownByLevel: const {
      3: 3,
      4: 4,
      7: 5,
      8: 6,
      10: 7,
      11: 8,
      13: 9,
      14: 10,
      16: 11,
      19: 12,
      20: 13,
    },
    spellIds: arcaneTricksterWizardSpellIds,
    learningPools: const [
      ClassSpellLearningPoolDefinition(
        id: ArcaneTricksterSpellPoolIds.enchantmentAndIllusion,
        name: 'Ammaliamento e Illusione',
        allowedSchoolIds: {
          'enchantment',
          'illusion',
        },
        knownByLevel: {
          3: 2,
          4: 3,
          7: 4,
          10: 5,
          11: 6,
          13: 7,
          16: 8,
          19: 9,
        },
      ),
      ClassSpellLearningPoolDefinition(
        id: ArcaneTricksterSpellPoolIds.unrestricted,
        name: 'Scuola Libera',
        knownByLevel: {
          3: 1,
          8: 2,
          14: 3,
          20: 4,
        },
      ),
    ],
  ),
);

final rogueSubclasses = <String, CharacterSubclassDefinition>{
  RogueSubclassIds.arcaneTrickster: arcaneTricksterSubclassDefinition,
  RogueSubclassIds.assassin: assassinSubclassDefinition,
  RogueSubclassIds.thief: thiefSubclassDefinition,
};

final rogueClassDefinition = CharacterClassDefinition(
  id: ClassIds.rogue,
  name: 'Ladro',
  content: const RuleContent(
    id: ClassIds.rogue,
    name: 'Ladro',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un avventuriero astuto che supera gli ostacoli con abilità, precisione e furtività.',
      details:
          'Il Ladro padroneggia numerose competenze, sfrutta le distrazioni per eseguire Attacchi Furtivi e sviluppa riflessi eccezionali.',
    ),
    source: _phbRogueSource,
    ownerId: ClassIds.rogue,
  ),
  hitDie: 8,
  proficiencies: const ClassProficiencyDefinition(
    armor: {
      'light_armor',
    },
    weapons: {
      'simple_weapons',
      'hand_crossbow',
      'longsword',
      'rapier',
      'shortsword',
    },
    tools: {
      ToolIds.thievesTools,
    },
    savingThrows: {
      'DES',
      'INT',
    },
    skillOptions: {
      'acrobatics',
      'athletics',
      'deception',
      'insight',
      'intimidation',
      'investigation',
      'perception',
      'performance',
      'persuasion',
      'sleight_of_hand',
      'stealth',
    },
    skillChoices: 4,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'rogue_skills',
        label: 'Scegli quattro abilità da Ladro',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'acrobatics',
          'athletics',
          'deception',
          'insight',
          'intimidation',
          'investigation',
          'perception',
          'performance',
          'persuasion',
          'sleight_of_hand',
          'stealth',
        },
        selections: 4,
      ),
    ],
  ),
  startingEquipmentChoices: const [
    ClassEquipmentChoice(
      id: 'rogue_primary_weapon',
      label: 'Scegli l’arma principale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'rogue_rapier',
          label: 'Stocco',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'rapier',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'rogue_shortsword_primary',
          label: 'Spada Corta',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'shortsword',
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'rogue_secondary_weapon',
      label: 'Scegli la dotazione secondaria',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'rogue_shortbow',
          label: 'Arco Corto, Faretra e 20 Frecce',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'shortbow',
            ),
            ClassEquipmentGrant(
              catalogId: 'equipment',
              itemId: EquipmentIds.quiver,
            ),
            ClassEquipmentGrant(
              catalogId: 'ammunition',
              itemId: 'arrows',
              quantity: 20,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'rogue_shortsword_secondary',
          label: 'Spada Corta',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'shortsword',
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'rogue_pack',
      label: 'Scegli la dotazione da esplorazione',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'rogue_burglar_pack',
          label: 'Dotazione da Scassinatore',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.burglar,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'rogue_dungeoneer_pack',
          label: 'Dotazione da Avventuriero',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.dungeoneer,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'rogue_explorer_pack',
          label: 'Dotazione da Esploratore',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.explorer,
            ),
          ],
        ),
      ],
    ),
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'armor',
      itemId: ArmorIds.leather,
    ),
    ClassEquipmentGrant(
      catalogId: 'weapon',
      itemId: 'dagger',
      quantity: 2,
    ),
    ClassEquipmentGrant(
      catalogId: 'tool',
      itemId: ToolIds.thievesTools,
    ),
  ],
  featuresByLevel: const {
    1: [
      RogueFeatureIds.expertise,
      RogueFeatureIds.sneakAttack,
      RogueFeatureIds.thievesCant,
    ],
    2: [
      RogueFeatureIds.cunningAction,
    ],
    3: [
      RogueFeatureIds.roguishArchetype,
    ],
    4: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    5: [
      RogueFeatureIds.uncannyDodge,
    ],
    6: [
      RogueFeatureIds.expertiseImprovement,
    ],
    7: [
      RogueFeatureIds.evasion,
    ],
    8: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    10: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    11: [
      RogueFeatureIds.reliableTalent,
    ],
    12: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    14: [
      RogueFeatureIds.blindsense,
    ],
    15: [
      RogueFeatureIds.slipperyMind,
    ],
    16: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    18: [
      RogueFeatureIds.elusive,
    ],
    19: [
      RogueFeatureIds.abilityScoreImprovement,
    ],
    20: [
      RogueFeatureIds.strokeOfLuck,
    ],
  },
  featureDefinitions: rogueFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: RogueResourceIds.strokeOfLuck,
      name: 'Colpo di Fortuna',
      minimumLevel: 20,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        20: 1,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: RogueProgressionIds.sneakAttackDice,
      name: 'Dadi dell’Attacco Furtivo',
      valuesByLevel: {
        1: '1d6',
        3: '2d6',
        5: '3d6',
        7: '4d6',
        9: '5d6',
        11: '6d6',
        13: '7d6',
        15: '8d6',
        17: '9d6',
        19: '10d6',
      },
    ),
  ],
  subclassSelectionLevel: 3,
  subclasses: rogueSubclasses,
);
