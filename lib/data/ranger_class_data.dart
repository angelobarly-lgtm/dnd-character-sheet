import 'armor_data.dart';
import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_pack_data.dart';
import 'fighting_style_data.dart';
import 'weapon_data.dart';

const _phbRangerSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 102-105',
);

abstract final class RangerSubclassIds {
  static const hunter = 'hunter';
  static const beastMaster = 'beast_master';
}

const phbRangerSubclassIds = <String>{
  RangerSubclassIds.hunter,
  RangerSubclassIds.beastMaster,
};

abstract final class RangerFeatureIds {
  static const favoredEnemy = 'favored_enemy';
  static const naturalExplorer = 'natural_explorer';
  static const fightingStyle = 'fighting_style';
  static const spellcasting = 'spellcasting';
  static const rangerArchetype = 'ranger_archetype';
  static const primevalAwareness = 'primeval_awareness';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const extraAttack = 'extra_attack';
  static const favoredEnemyImprovement6 = 'favored_enemy_improvement_6';
  static const naturalExplorerImprovement6 = 'natural_explorer_improvement_6';
  static const landStride = 'land_stride';
  static const naturalExplorerImprovement10 = 'natural_explorer_improvement_10';
  static const hideInPlainSight = 'hide_in_plain_sight';
  static const favoredEnemyImprovement14 = 'favored_enemy_improvement_14';
  static const vanish = 'vanish';
  static const feralSenses = 'feral_senses';
  static const foeSlayer = 'foe_slayer';
}

const phbRangerFightingStyleIds = <String>{
  'archery',
  'defense',
  'dueling',
  'two_weapon_fighting',
};

final List<CharacterChoiceOptionDefinition> phbRangerFightingStyleOptions = [
  for (final id in phbRangerFightingStyleIds)
    CharacterChoiceOptionDefinition(
      id: id,
      label: fightingStyleDefinitions[id]!.name,
    ),
];

const phbRangerFavoredEnemyOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(id: 'aberration', label: 'Aberrazioni'),
  CharacterChoiceOptionDefinition(id: 'beast', label: 'Bestie'),
  CharacterChoiceOptionDefinition(id: 'celestial', label: 'Celestiali'),
  CharacterChoiceOptionDefinition(id: 'construct', label: 'Costrutti'),
  CharacterChoiceOptionDefinition(id: 'dragon', label: 'Draghi'),
  CharacterChoiceOptionDefinition(id: 'elemental', label: 'Elementali'),
  CharacterChoiceOptionDefinition(id: 'fey', label: 'Folletti'),
  CharacterChoiceOptionDefinition(id: 'giant', label: 'Giganti'),
  CharacterChoiceOptionDefinition(id: 'fiend', label: 'Immondi'),
  CharacterChoiceOptionDefinition(id: 'ooze', label: 'Melme'),
  CharacterChoiceOptionDefinition(id: 'monstrosity', label: 'Mostruosità'),
  CharacterChoiceOptionDefinition(id: 'undead', label: 'Non Morti'),
  CharacterChoiceOptionDefinition(id: 'plant', label: 'Vegetali'),
  CharacterChoiceOptionDefinition(
    id: 'two_humanoid_races',
    label: 'Due Razze di Umanoidi',
  ),
];

const phbRangerTerrainOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(id: 'arctic', label: 'Artico'),
  CharacterChoiceOptionDefinition(id: 'coast', label: 'Costa'),
  CharacterChoiceOptionDefinition(id: 'desert', label: 'Deserto'),
  CharacterChoiceOptionDefinition(id: 'forest', label: 'Foresta'),
  CharacterChoiceOptionDefinition(id: 'mountain', label: 'Montagna'),
  CharacterChoiceOptionDefinition(id: 'swamp', label: 'Palude'),
  CharacterChoiceOptionDefinition(id: 'grassland', label: 'Prateria'),
  CharacterChoiceOptionDefinition(id: 'underdark', label: 'Underdark'),
];

final Set<String> _rangerSimpleMeleeWeaponIds = weaponDefinitions.values
    .where(
      (weapon) =>
          weapon.category == WeaponCategory.simple &&
          weapon.kind == WeaponKind.melee,
    )
    .map((weapon) => weapon.id)
    .toSet();

const phbRangerSpellIds = <String>{
  'alarm',
  'animal_friendship',
  'cure_wounds',
  'detect_magic',
  'detect_poison_and_disease',
  'ensnaring_strike',
  'fog_cloud',
  'goodberry',
  'hail_of_thorns',
  'hunters_mark',
  'jump',
  'longstrider',
  'speak_with_animals',
  'animal_messenger',
  'barkskin',
  'beast_sense',
  'cordon_of_arrows',
  'darkvision',
  'find_traps',
  'lesser_restoration',
  'locate_animals_or_plants',
  'locate_object',
  'pass_without_trace',
  'protection_from_poison',
  'silence',
  'spike_growth',
  'conjure_animals',
  'conjure_barrage',
  'daylight',
  'lightning_arrow',
  'nondetection',
  'plant_growth',
  'protection_from_energy',
  'speak_with_plants',
  'water_breathing',
  'water_walk',
  'wind_wall',
  'conjure_woodland_beings',
  'freedom_of_movement',
  'grasping_vine',
  'locate_creature',
  'stoneskin',
  'commune_with_nature',
  'conjure_volley',
  'swift_quiver',
  'tree_stride',
};

CharacterChoiceDefinition _favoredEnemyChoice(String suffix) =>
    CharacterChoiceDefinition(
      id: 'ranger_favored_enemy_$suffix',
      label: 'Scegli un tipo di Nemico Prescelto',
      type: CharacterChoiceType.other,
      catalogId: 'favored_enemy_types',
      options: phbRangerFavoredEnemyOptions,
      requireNewAcquisition: true,
    );

CharacterChoiceDefinition _favoredHumanoidRacesChoice(String suffix) =>
    CharacterChoiceDefinition(
      id: 'ranger_favored_enemy_humanoid_races_$suffix',
      label:
          'Se hai scelto gli umanoidi, indica due razze di umanoidi distinte',
      type: CharacterChoiceType.other,
      catalogId: 'humanoid_races',
      minimumSelections: 0,
      maximumSelections: 2,
      requireNewAcquisition: true,
    );

CharacterChoiceDefinition _favoredEnemyLanguageChoice(String suffix) =>
    CharacterChoiceDefinition(
      id: 'ranger_favored_enemy_language_$suffix',
      label:
          'Scegli un linguaggio parlato dal nuovo Nemico Prescelto, se disponibile',
      type: CharacterChoiceType.language,
      catalogId: 'languages',
      minimumSelections: 0,
      maximumSelections: 1,
      requireNewAcquisition: true,
    );

CharacterChoiceDefinition _naturalExplorerChoice(String suffix) =>
    CharacterChoiceDefinition(
      id: 'ranger_favored_terrain_$suffix',
      label: 'Scegli un tipo di Terreno Prescelto',
      type: CharacterChoiceType.other,
      catalogId: 'favored_terrains',
      options: phbRangerTerrainOptions,
      requireNewAcquisition: true,
    );

CharacterClassFeatureDefinition _rangerFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> ruleTags = const {},
  List<CharacterChoiceDefinition> choices = const [],
  CharacterEffects effects = const CharacterEffects(),
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.classFeature,
        description: RuleDescription(summary: summary, details: details),
        source: _phbRangerSource,
        ownerId: ClassIds.ranger,
      ),
      ruleTags: ruleTags,
      choices: choices,
      effects: effects,
    );

final rangerFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  RangerFeatureIds.favoredEnemy: _rangerFeature(
    id: RangerFeatureIds.favoredEnemy,
    name: 'Nemico Prescelto',
    summary:
        'Il Ranger è particolarmente esperto nel seguire e studiare un tipo di nemico.',
    details:
        'Dal 1° livello sceglie un tipo tra aberrazioni, bestie, celestiali, costrutti, draghi, elementali, folletti, giganti, immondi, melme, mostruosità, non morti o vegetali; in alternativa sceglie due razze di umanoidi. Dispone di vantaggio alle prove di Saggezza (Sopravvivenza) per seguirne le tracce e alle prove di Intelligenza per ricordare informazioni che li riguardano. Apprende inoltre un linguaggio parlato dal nemico scelto, se ne esiste uno.',
    ruleTags: const {
      'favored_enemy',
      'tracking',
      'knowledge',
      'language',
    },
    choices: [
      _favoredEnemyChoice('1'),
      _favoredHumanoidRacesChoice('1'),
      _favoredEnemyLanguageChoice('1'),
    ],
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_favored_enemy_tracking_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'wisdom_survival_tracking_favored_enemies',
        ),
        CharacterRuleEffect(
          id: 'ranger_favored_enemy_recall_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'intelligence_checks_recall_favored_enemies',
        ),
      ],
    ),
  ),
  RangerFeatureIds.naturalExplorer: _rangerFeature(
    id: RangerFeatureIds.naturalExplorer,
    name: 'Esploratore Nato',
    summary:
        'Il Ranger eccelle nei viaggi e nella sopravvivenza in un ambiente naturale prescelto.',
    details:
        'Dal 1° livello sceglie artico, costa, deserto, foresta, montagna, palude, prateria o Underdark. Nelle prove di Intelligenza o Saggezza legate a quel terreno raddoppia il bonus di competenza quando usa un’abilità competente. Durante viaggi di almeno un’ora nel terreno prescelto: il terreno difficile non rallenta il gruppo; il gruppo non può smarrirsi salvo cause magiche; il Ranger resta allerta mentre svolge altre attività; se viaggia da solo può muoversi furtivamente a passo normale; trova il doppio del cibo quando foraggia; seguendo tracce apprende numero esatto, taglie e tempo trascorso dal passaggio delle creature.',
    ruleTags: const {
      'favored_terrain',
      'travel',
      'expertise',
      'foraging',
      'tracking',
    },
    choices: [_naturalExplorerChoice('1')],
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_natural_explorer_travel_benefits',
          type: CharacterRuleEffectType.conditional,
          target: 'travel_one_hour_or_more_in_favored_terrain',
          condition:
              'double_proficiency_intelligence_or_wisdom_if_proficient_ignore_group_difficult_terrain_no_nonmagical_lost_remain_alert_solo_stealth_normal_pace_double_food_exact_tracks',
        ),
      ],
    ),
  ),
  RangerFeatureIds.fightingStyle: _rangerFeature(
    id: RangerFeatureIds.fightingStyle,
    name: 'Stile di Combattimento',
    summary: 'Il Ranger sceglie una specializzazione marziale.',
    details:
        'Al 2° livello sceglie Tiro, Difesa, Duellare oppure Combattere con Due Armi. Non può scegliere lo stesso stile più di una volta.',
    ruleTags: const {'fighting_style', 'choice'},
    choices: [
      CharacterChoiceDefinition(
        id: 'ranger_fighting_style',
        label: 'Scegli uno Stile di Combattimento da Ranger',
        type: CharacterChoiceType.other,
        catalogId: CharacterChoiceCatalogIds.fightingStyles,
        options: phbRangerFightingStyleOptions,
        requireNewAcquisition: true,
      ),
    ],
  ),
  RangerFeatureIds.spellcasting: _rangerFeature(
    id: RangerFeatureIds.spellcasting,
    name: 'Incantesimi',
    summary:
        'Il Ranger conosce una selezione crescente di incantesimi della natura e usa Saggezza per lanciarli.',
    details:
        'Dal 2° livello conosce due incantesimi di 1° livello dalla lista del Ranger. Il numero di incantesimi conosciuti cresce secondo la tabella di classe e ogni incantesimo deve essere di un livello per cui possiede slot. Ogni volta che acquisisce un livello da Ranger può sostituire un incantesimo conosciuto con un altro incantesimo da Ranger di livello lanciabile. Saggezza determina la CD dei tiri salvezza e il modificatore degli attacchi con incantesimo. Recupera tutti gli slot con un riposo lungo.',
    ruleTags: const {
      'spellcasting',
      'wisdom',
      'spells_known',
      'long_rest',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_spellcasting_progression',
          type: CharacterRuleEffectType.spellcasting,
          target: 'ranger_spellcasting',
          condition:
              'wisdom_spells_known_replace_one_on_ranger_level_up_long_rest_slots',
        ),
      ],
    ),
  ),
  RangerFeatureIds.rangerArchetype: _rangerFeature(
    id: RangerFeatureIds.rangerArchetype,
    name: 'Archetipo Ranger',
    summary:
        'Il Ranger sceglie il modello che definisce il suo metodo di difesa delle terre selvagge.',
    details:
        'Al 3° livello sceglie il Cacciatore oppure il Signore delle Bestie. L’archetipo conferisce privilegi al 3°, 7°, 11° e 15° livello.',
    ruleTags: const {'subclass', 'ranger_archetype'},
  ),
  RangerFeatureIds.primevalAwareness: _rangerFeature(
    id: RangerFeatureIds.primevalAwareness,
    name: 'Consapevolezza Primordiale',
    summary:
        'Il Ranger consuma uno slot per percepire la presenza di creature sovrannaturali nei dintorni.',
    details:
        'Dal 3° livello può usare un’azione e spendere uno slot incantesimo da Ranger. Per 1 minuto per livello dello slot percepisce se entro 1,5 km sono presenti aberrazioni, celestiali, draghi, elementali, folletti, immondi o non morti; il raggio diventa 9 km nel suo terreno prescelto. Non apprende né il numero né l’ubicazione delle creature.',
    ruleTags: const {
      'action',
      'spell_slot',
      'detection',
      'favored_terrain',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_primeval_awareness_detection',
          type: CharacterRuleEffectType.conditional,
          target:
              'aberration_celestial_dragon_elemental_fey_fiend_undead_presence',
          value: 1.5,
          condition:
              'action_spend_ranger_spell_slot_duration_minutes_per_slot_level_range_km_or_nine_in_favored_terrain_no_number_or_location',
        ),
      ],
    ),
  ),
  RangerFeatureIds.abilityScoreImprovement: _rangerFeature(
    id: RangerFeatureIds.abilityScoreImprovement,
    name: 'Aumento dei Punteggi di Caratteristica',
    summary:
        'Il Ranger migliora una caratteristica o distribuisce l’aumento tra due caratteristiche.',
    details:
        'Al 4°, 8°, 12°, 16° e 19° livello aumenta di 2 un punteggio di caratteristica oppure aumenta di 1 due punteggi. Un punteggio non può superare 20 tramite questo privilegio.',
    ruleTags: const {'ability_score_improvement'},
  ),
  RangerFeatureIds.extraAttack: _rangerFeature(
    id: RangerFeatureIds.extraAttack,
    name: 'Attacco Extra',
    summary: 'Il Ranger attacca due volte con l’azione di Attacco.',
    details:
        'Dal 5° livello può attaccare due volte anziché una ogni volta che effettua l’azione di Attacco nel proprio turno.',
    ruleTags: const {'extra_attack', 'attack_action'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_extra_attack_count',
          type: CharacterRuleEffectType.conditional,
          target: 'attacks_per_attack_action',
          value: 2,
          condition: 'ranger_level_at_least_five',
        ),
      ],
    ),
  ),
  RangerFeatureIds.favoredEnemyImprovement6: _rangerFeature(
    id: RangerFeatureIds.favoredEnemyImprovement6,
    name: 'Nemico Prescelto Migliorato',
    summary: 'Il Ranger sceglie un secondo Nemico Prescelto.',
    details:
        'Al 6° livello sceglie un Nemico Prescelto aggiuntivo e, se disponibile, un linguaggio da esso parlato. Conserva tutti i benefici del privilegio originale.',
    ruleTags: const {'favored_enemy', 'improvement', 'language'},
    choices: [
      _favoredEnemyChoice('2'),
      _favoredHumanoidRacesChoice('2'),
      _favoredEnemyLanguageChoice('2'),
    ],
  ),
  RangerFeatureIds.naturalExplorerImprovement6: _rangerFeature(
    id: RangerFeatureIds.naturalExplorerImprovement6,
    name: 'Esploratore Nato Migliorato',
    summary: 'Il Ranger sceglie un secondo Terreno Prescelto.',
    details:
        'Al 6° livello sceglie un tipo di Terreno Prescelto aggiuntivo e applica a esso tutti i benefici di Esploratore Nato.',
    ruleTags: const {'favored_terrain', 'improvement'},
    choices: [_naturalExplorerChoice('2')],
  ),
  RangerFeatureIds.landStride: _rangerFeature(
    id: RangerFeatureIds.landStride,
    name: 'Andatura sul Territorio',
    summary:
        'Il Ranger attraversa terreno difficile e vegetazione con eccezionale facilità.',
    details:
        'Dall’8° livello il terreno difficile non magico non richiede movimento extra. Può attraversare vegetali non magici senza rallentare e senza subire danni da spine, aculei o pericoli simili. Dispone inoltre di vantaggio ai tiri salvezza contro vegetali creati o manipolati magicamente per ostacolare il movimento.',
    ruleTags: const {
      'movement',
      'difficult_terrain',
      'plants',
      'saving_throw_advantage',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_land_stride_nonmagical_terrain',
          type: CharacterRuleEffectType.movement,
          target: 'nonmagical_difficult_terrain_and_plants',
          condition:
              'no_extra_movement_no_nonmagical_plant_slowing_or_hazard_damage',
        ),
        CharacterRuleEffect(
          id: 'ranger_land_stride_magical_plants_save',
          type: CharacterRuleEffectType.advantage,
          target: 'saving_throws_against_magical_plants_impeding_movement',
        ),
      ],
    ),
  ),
  RangerFeatureIds.naturalExplorerImprovement10: _rangerFeature(
    id: RangerFeatureIds.naturalExplorerImprovement10,
    name: 'Esploratore Nato Migliorato',
    summary: 'Il Ranger sceglie un terzo Terreno Prescelto.',
    details:
        'Al 10° livello sceglie un terzo tipo di Terreno Prescelto e applica a esso tutti i benefici di Esploratore Nato.',
    ruleTags: const {'favored_terrain', 'improvement'},
    choices: [_naturalExplorerChoice('3')],
  ),
  RangerFeatureIds.hideInPlainSight: _rangerFeature(
    id: RangerFeatureIds.hideInPlainSight,
    name: 'Nascondersi in Piena Vista',
    summary:
        'Il Ranger prepara una mimetizzazione naturale che migliora notevolmente la sua furtività finché rimane immobile.',
    details:
        'Dal 10° livello può impiegare 1 minuto e materiali naturali adatti, come fango, terriccio, vegetali o fuliggine, per mimetizzarsi. Deve appiattirsi contro una superficie solida alta e larga almeno quanto lui e ottiene +10 alle prove di Destrezza (Furtività) finché resta fermo senza muoversi e senza effettuare azioni o reazioni. Dopo essersi mosso o avere effettuato un’azione o reazione deve mimetizzarsi di nuovo.',
    ruleTags: const {'stealth', 'preparation', 'stationary'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hide_in_plain_sight_stealth_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'dexterity_stealth_checks',
          value: 10,
          condition:
              'prepare_one_minute_natural_materials_against_solid_surface_ends_on_movement_action_or_reaction',
        ),
      ],
    ),
  ),
  RangerFeatureIds.favoredEnemyImprovement14: _rangerFeature(
    id: RangerFeatureIds.favoredEnemyImprovement14,
    name: 'Nemico Prescelto Migliorato',
    summary: 'Il Ranger sceglie un terzo Nemico Prescelto.',
    details:
        'Al 14° livello sceglie un terzo Nemico Prescelto e, se disponibile, un linguaggio da esso parlato. Conserva tutti i benefici del privilegio originale.',
    ruleTags: const {'favored_enemy', 'improvement', 'language'},
    choices: [
      _favoredEnemyChoice('3'),
      _favoredHumanoidRacesChoice('3'),
      _favoredEnemyLanguageChoice('3'),
    ],
  ),
  RangerFeatureIds.vanish: _rangerFeature(
    id: RangerFeatureIds.vanish,
    name: 'Svanire',
    summary:
        'Il Ranger si nasconde rapidamente e non lascia tracce seguibili con mezzi ordinari.',
    details:
        'Dal 14° livello può usare l’azione Nascondersi come azione bonus nel proprio turno. Inoltre non è possibile seguirne le tracce con mezzi non magici, a meno che non decida volontariamente di lasciare una pista.',
    ruleTags: const {'bonus_action', 'hide', 'tracking'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_vanish_bonus_action_hide',
          type: CharacterRuleEffectType.conditional,
          target: 'hide_action',
          condition: 'usable_as_bonus_action_on_turn',
        ),
        CharacterRuleEffect(
          id: 'ranger_vanish_untrackable',
          type: CharacterRuleEffectType.conditional,
          target: 'nonmagical_tracking_against_ranger',
          condition: 'impossible_unless_ranger_chooses_to_leave_trail',
        ),
      ],
    ),
  ),
  RangerFeatureIds.feralSenses: _rangerFeature(
    id: RangerFeatureIds.feralSenses,
    name: 'Sensi Ferini',
    summary:
        'Il Ranger combatte efficacemente contro creature che non riesce a vedere e percepisce gli invisibili vicini.',
    details:
        'Al 18° livello, quando attacca una creatura che non vede, questa incapacità non impone svantaggio ai suoi tiri per colpire. È inoltre consapevole dell’ubicazione di ogni creatura invisibile entro 9 metri, purché la creatura non sia nascosta a lui e il Ranger non sia accecato o assordato.',
    ruleTags: const {
      'unseen_target',
      'invisible_creature_detection',
      'range_9_meters',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_feral_senses_unseen_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'attack_rolls_against_unseen_creatures',
          condition: 'no_disadvantage_from_inability_to_see_target',
        ),
        CharacterRuleEffect(
          id: 'ranger_feral_senses_invisible_location',
          type: CharacterRuleEffectType.conditional,
          target: 'location_of_invisible_creatures_within_meters',
          value: 9,
          condition:
              'creature_not_hidden_from_ranger_and_ranger_not_blinded_or_deafened',
        ),
      ],
    ),
  ),
  RangerFeatureIds.foeSlayer: _rangerFeature(
    id: RangerFeatureIds.foeSlayer,
    name: 'Sterminatore di Nemici',
    summary:
        'Il Ranger applica la propria Saggezza a un attacco contro un Nemico Prescelto ogni turno.',
    details:
        'Al 20° livello, una volta per turno, può aggiungere il proprio modificatore di Saggezza al tiro per colpire oppure al tiro per i danni di un attacco effettuato contro un Nemico Prescelto. Può decidere prima o dopo il tiro, ma prima che gli effetti del tiro siano applicati.',
    ruleTags: const {
      'favored_enemy',
      'wisdom_modifier',
      'once_per_turn',
      'attack_or_damage',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_foe_slayer_wisdom_bonus',
          type: CharacterRuleEffectType.conditional,
          target:
              'attack_roll_or_damage_roll_against_favored_enemy_wisdom_modifier',
          condition:
              'once_per_turn_choose_before_or_after_roll_before_roll_effects_apply',
        ),
      ],
    ),
  ),
};

const _rangerSpellSlotsByLevel = <int, List<int>>{
  1: [0, 0, 0, 0, 0],
  2: [2, 0, 0, 0, 0],
  3: [3, 0, 0, 0, 0],
  4: [3, 0, 0, 0, 0],
  5: [4, 2, 0, 0, 0],
  6: [4, 2, 0, 0, 0],
  7: [4, 3, 0, 0, 0],
  8: [4, 3, 0, 0, 0],
  9: [4, 3, 2, 0, 0],
  10: [4, 3, 2, 0, 0],
  11: [4, 3, 3, 0, 0],
  12: [4, 3, 3, 0, 0],
  13: [4, 3, 3, 1, 0],
  14: [4, 3, 3, 1, 0],
  15: [4, 3, 3, 2, 0],
  16: [4, 3, 3, 2, 0],
  17: [4, 3, 3, 3, 1],
  18: [4, 3, 3, 3, 1],
  19: [4, 3, 3, 3, 2],
  20: [4, 3, 3, 3, 2],
};

const _rangerSpellsKnownByLevel = <int, int>{
  2: 2,
  3: 3,
  5: 4,
  7: 5,
  9: 6,
  11: 7,
  13: 8,
  15: 9,
  17: 10,
  19: 11,
};

const _phbRangerHunterSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 105-106',
);

abstract final class RangerHunterFeatureIds {
  static const huntersPrey = 'hunters_prey';
  static const defensiveTactics = 'defensive_tactics';
  static const multiattack = 'multiattack';
  static const superiorHunterDefense = 'superior_hunter_defense';
}

const rangerHunterPreyOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(
    id: 'horde_breaker',
    label: 'Devastatore dell’Orda',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_horde_breaker_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'additional_weapon_attack_with_same_weapon',
          value: 1.5,
          condition:
              'once_per_turn_different_creature_within_meters_of_original_target_and_within_weapon_range',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'colossus_slayer',
    label: 'Sterminatore di Colossi',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_colossus_slayer_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'weapon_attack_hit_damage',
          condition: 'target_below_hit_point_maximum_once_per_turn_extra_1d8',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'giant_killer',
    label: 'Uccisore di Giganti',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_giant_killer_reaction',
          type: CharacterRuleEffectType.reaction,
          target: 'attack_large_or_larger_creature',
          value: 1.5,
          condition:
              'visible_creature_within_meters_hits_or_misses_ranger_attack_immediately_after',
        ),
      ],
    ),
  ),
];

const rangerHunterDefensiveTacticsOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(
    id: 'multiattack_defense',
    label: 'Difesa dal Multiattacco',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_multiattack_defense_ac',
          type: CharacterRuleEffectType.conditional,
          target: 'armor_class_against_subsequent_attacks_same_creature',
          value: 4,
          condition: 'after_creature_hits_ranger_until_end_of_current_turn',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'escape_the_horde',
    label: 'Sfuggire all’Orda',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_escape_the_horde_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target: 'opportunity_attacks_against_ranger',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'steel_will',
    label: 'Volontà d’Acciaio',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_steel_will_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'saving_throws_against_frightened',
        ),
      ],
    ),
  ),
];

const rangerHunterMultiattackOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(
    id: 'whirlwind_attack',
    label: 'Attacco Turbinante',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_whirlwind_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'melee_attack_against_any_number_of_creatures',
          value: 1.5,
          condition:
              'action_creatures_within_meters_separate_attack_roll_for_each_target',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'volley',
    label: 'Raffica',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_volley',
          type: CharacterRuleEffectType.conditional,
          target: 'ranged_attack_against_any_number_of_creatures',
          value: 3,
          condition:
              'action_creatures_within_meters_of_visible_point_in_weapon_range_separate_attack_roll_and_ammunition_each',
        ),
      ],
    ),
  ),
];

const rangerHunterSuperiorDefenseOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(
    id: 'evasion',
    label: 'Elusione',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_evasion',
          type: CharacterRuleEffectType.conditional,
          target: 'dexterity_save_for_half_damage',
          condition: 'success_zero_damage_failure_half_damage',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'stand_against_the_tide',
    label: 'Opporsi alla Marea',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_stand_against_tide_reaction',
          type: CharacterRuleEffectType.reaction,
          target: 'hostile_creature_repeat_missed_melee_attack',
          condition:
              'hostile_creature_misses_ranger_choose_other_creature_not_attacker',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: 'uncanny_dodge',
    label: 'Schivata Prodigiosa',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'ranger_hunter_uncanny_dodge_reaction',
          type: CharacterRuleEffectType.reaction,
          target: 'damage_from_attack',
          value: 0.5,
          condition: 'visible_attacker_hits_ranger_halve_attack_damage',
        ),
      ],
    ),
  ),
];

CharacterClassFeatureDefinition _rangerHunterFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  required String choiceId,
  required String choiceLabel,
  required List<CharacterChoiceOptionDefinition> options,
  required Set<String> ruleTags,
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.subclassFeature,
        description: RuleDescription(summary: summary, details: details),
        source: _phbRangerHunterSource,
        ownerId: RangerSubclassIds.hunter,
      ),
      ruleTags: ruleTags,
      choices: [
        CharacterChoiceDefinition(
          id: choiceId,
          label: choiceLabel,
          type: CharacterChoiceType.other,
          catalogId: 'ranger_hunter_options',
          options: options,
          requireNewAcquisition: true,
        ),
      ],
    );

final rangerHunterFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  RangerHunterFeatureIds.huntersPrey: _rangerHunterFeature(
    id: RangerHunterFeatureIds.huntersPrey,
    name: 'Preda del Cacciatore',
    summary:
        'Il Cacciatore sceglie una tecnica offensiva specializzata contro una particolare forma di minaccia.',
    details:
        'Al 3° livello sceglie Devastatore dell’Orda, Sterminatore di Colossi oppure Uccisore di Giganti. La scelta è permanente e applica integralmente i limiti indicati dalla tecnica selezionata.',
    choiceId: 'ranger_hunter_prey_choice',
    choiceLabel: 'Scegli una Preda del Cacciatore',
    options: rangerHunterPreyOptions,
    ruleTags: const {'choice', 'offense', 'hunter'},
  ),
  RangerHunterFeatureIds.defensiveTactics: _rangerHunterFeature(
    id: RangerHunterFeatureIds.defensiveTactics,
    name: 'Tattiche Difensive',
    summary:
        'Il Cacciatore sceglie una tecnica difensiva contro attacchi ripetuti, orde o paura.',
    details:
        'Al 7° livello sceglie Difesa dal Multiattacco, Sfuggire all’Orda oppure Volontà d’Acciaio.',
    choiceId: 'ranger_hunter_defensive_tactics_choice',
    choiceLabel: 'Scegli una Tattica Difensiva',
    options: rangerHunterDefensiveTacticsOptions,
    ruleTags: const {'choice', 'defense', 'hunter'},
  ),
  RangerHunterFeatureIds.multiattack: _rangerHunterFeature(
    id: RangerHunterFeatureIds.multiattack,
    name: 'Multiattacco',
    summary:
        'Il Cacciatore impara a colpire numerosi avversari con un’unica azione.',
    details:
        'All’11° livello sceglie Attacco Turbinante, per attaccare separatamente ogni creatura entro 1,5 metri, oppure Raffica, per attaccare separatamente ogni creatura entro 3 metri da un punto visibile nella gittata dell’arma, consumando le munizioni necessarie.',
    choiceId: 'ranger_hunter_multiattack_choice',
    choiceLabel: 'Scegli una forma di Multiattacco',
    options: rangerHunterMultiattackOptions,
    ruleTags: const {'choice', 'multiattack', 'action', 'hunter'},
  ),
  RangerHunterFeatureIds.superiorHunterDefense: _rangerHunterFeature(
    id: RangerHunterFeatureIds.superiorHunterDefense,
    name: 'Difesa del Cacciatore Superiore',
    summary:
        'Il Cacciatore sceglie una difesa superiore contro aree, attacchi deviati o colpi visibili.',
    details:
        'Al 15° livello sceglie Elusione, Opporsi alla Marea oppure Schivata Prodigiosa. Ogni opzione conserva i propri requisiti, la reazione eventualmente richiesta e le limitazioni sul bersaglio.',
    choiceId: 'ranger_hunter_superior_defense_choice',
    choiceLabel: 'Scegli una Difesa del Cacciatore Superiore',
    options: rangerHunterSuperiorDefenseOptions,
    ruleTags: const {'choice', 'superior_defense', 'hunter'},
  ),
};

final rangerHunterDefinition = CharacterSubclassDefinition(
  id: RangerSubclassIds.hunter,
  name: 'Cacciatore',
  classId: ClassIds.ranger,
  content: const RuleContent(
    id: RangerSubclassIds.hunter,
    name: 'Cacciatore',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Ranger specializzato nel combattere le minacce più varie delle terre selvagge.',
      details:
          'Il Cacciatore costituisce un baluardo tra il mondo civilizzato e i pericoli selvaggi, scegliendo a ogni traguardo una tecnica offensiva o difensiva adatta agli avversari affrontati.',
    ),
    source: _phbRangerHunterSource,
    ownerId: ClassIds.ranger,
  ),
  featuresByLevel: const {
    3: [RangerHunterFeatureIds.huntersPrey],
    7: [RangerHunterFeatureIds.defensiveTactics],
    11: [RangerHunterFeatureIds.multiattack],
    15: [RangerHunterFeatureIds.superiorHunterDefense],
  },
  featureDefinitions: rangerHunterFeatureDefinitions,
);

const _phbRangerBeastMasterSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 105-106',
);

abstract final class RangerBeastMasterFeatureIds {
  static const rangerCompanion = 'rangers_companion';
  static const exceptionalTraining = 'exceptional_training';
  static const bestialFury = 'bestial_fury';
  static const shareSpells = 'share_spells';
}

abstract final class RangerCompanionIds {
  static const animalCompanion = 'ranger_animal_companion';
}

abstract final class RangerCompanionCommandIds {
  static const verbalMovement = 'verbal_movement';
  static const standardAction = 'standard_action_command';
  static const exceptionalTraining = 'exceptional_training_command';
}

const rangerAnimalCompanionDefinition = ClassCompanionDefinition(
  id: RangerCompanionIds.animalCompanion,
  name: 'Compagno Animale del Ranger',
  featureId: RangerBeastMasterFeatureIds.rangerCompanion,
  minimumLevel: 3,
  creatureCatalogId: 'bestiary',
  allowedCreatureTypes: {'beast'},
  maximumChallengeRating: 0.25,
  maximumSize: ClassCompanionSize.medium,
  proficiencyBonusTargets: {
    ClassCompanionProficiencyBonusTarget.armorClass,
    ClassCompanionProficiencyBonusTarget.attackRolls,
    ClassCompanionProficiencyBonusTarget.damageRolls,
    ClassCompanionProficiencyBonusTarget.proficientSavingThrows,
    ClassCompanionProficiencyBonusTarget.proficientSkillChecks,
  },
  hitPointMinimumClassLevelMultiplier: 4,
  usesHigherOfStatBlockOrMinimumHitPoints: true,
  usesOwnHitDiceDuringShortRest: true,
  sharesOwnerInitiative: true,
  movesOnOwnerTurn: true,
  reactionsRequireCommand: false,
  actsIndependentlyWhenOwnerAbsentOrIncapacitated: true,
  canTakeAnyActionWhenIndependent: true,
  protectsOwnerWhenIndependent: true,
  soloFavoredTerrainStealthAtNormalPace: true,
  weaponAttackWhileCommandingAttackMinimumLevel: 5,
  attacksPerAttackCommandByLevel: {3: 1, 11: 2},
  attackCommandAllowsMultiattackMinimumLevel: 11,
  replacementBondHours: 8,
  replacementRequiresNonhostileCreature: true,
  sharedSelfSpellMinimumLevel: 15,
  sharedSpellMaximumDistanceMeters: 9,
  commands: [
    ClassCompanionCommandDefinition(
      id: RangerCompanionCommandIds.verbalMovement,
      name: 'Comando Verbale di Movimento',
      minimumLevel: 3,
      activation: ClassCompanionCommandActivation.noAction,
      actions: {'move'},
      verbal: true,
    ),
    ClassCompanionCommandDefinition(
      id: RangerCompanionCommandIds.standardAction,
      name: 'Comando del Compagno',
      minimumLevel: 3,
      activation: ClassCompanionCommandActivation.action,
      actions: {'attack', 'dash', 'disengage', 'dodge', 'help'},
    ),
    ClassCompanionCommandDefinition(
      id: RangerCompanionCommandIds.exceptionalTraining,
      name: 'Comando di Addestramento Eccezionale',
      minimumLevel: 7,
      activation: ClassCompanionCommandActivation.bonusAction,
      actions: {'dash', 'disengage', 'dodge', 'help'},
      requiresCompanionNotAttacking: true,
    ),
  ],
);

CharacterClassFeatureDefinition _rangerBeastMasterFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  required Set<String> ruleTags,
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.subclassFeature,
        description: RuleDescription(summary: summary, details: details),
        source: _phbRangerBeastMasterSource,
        ownerId: RangerSubclassIds.beastMaster,
      ),
      ruleTags: ruleTags,
    );

final rangerBeastMasterFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  RangerBeastMasterFeatureIds.rangerCompanion: _rangerBeastMasterFeature(
    id: RangerBeastMasterFeatureIds.rangerCompanion,
    name: 'Compagno del Ranger',
    summary:
        'Il Signore delle Bestie stringe un legame con una bestia che combatte e viaggia al suo fianco.',
    details:
        'Al 3° livello sceglie una bestia non più grande di taglia Media e con grado di sfida pari o inferiore a 1/4. Aggiunge il proprio bonus di competenza alla CA, ai tiri per colpire, ai danni e ai tiri salvezza e alle abilità in cui la bestia è competente. I punti ferita massimi sono il valore della scheda o quattro volte il livello da Ranger, scegliendo il maggiore; durante i riposi brevi la bestia usa i propri Dadi Vita. Condivide l’iniziativa del Ranger e agisce secondo i suoi comandi. Il movimento può essere comandato verbalmente senza azione; per Attaccare, Aiutare, Disimpegnarsi, Scattare o Schivare il Ranger usa la propria azione. Le reazioni non richiedono comandi. Se il Ranger è assente o incapacitato, la bestia sceglie autonomamente qualsiasi azione, concentrandosi sulla protezione di sé stessa e del Ranger. Dal 5° livello il Ranger può effettuare un attacco con un’arma quando usa l’azione per comandare Attaccare. Se la bestia muore, può legarsi a una nuova bestia idonea e non ostile trascorrendo 8 ore con essa. Viaggiando soltanto con il compagno nel terreno prescelto, può muoversi furtivamente a passo normale.',
    ruleTags: const {
      'companion',
      'beast',
      'command',
      'proficiency_scaling',
      'hit_points',
    },
  ),
  RangerBeastMasterFeatureIds.exceptionalTraining: _rangerBeastMasterFeature(
    id: RangerBeastMasterFeatureIds.exceptionalTraining,
    name: 'Addestramento Eccezionale',
    summary:
        'Il Ranger impartisce più rapidamente al compagno i comandi non offensivi.',
    details:
        'Dal 7° livello, in qualsiasi turno in cui la bestia non attacca, il Ranger può usare un’azione bonus per comandarle di Aiutare, Disimpegnarsi, Scattare o Schivare durante il proprio turno.',
    ruleTags: const {'companion', 'bonus_action', 'command'},
  ),
  RangerBeastMasterFeatureIds.bestialFury: _rangerBeastMasterFeature(
    id: RangerBeastMasterFeatureIds.bestialFury,
    name: 'Furia Bestiale',
    summary:
        'Il compagno animale può effettuare due attacchi quando riceve il comando di Attaccare.',
    details:
        'Dall’11° livello, quando il Ranger comanda alla bestia di usare l’azione Attaccare, essa può effettuare due attacchi oppure usare l’azione Multiattacco, se la possiede.',
    ruleTags: const {'companion', 'attack', 'multiattack'},
  ),
  RangerBeastMasterFeatureIds.shareSpells: _rangerBeastMasterFeature(
    id: RangerBeastMasterFeatureIds.shareSpells,
    name: 'Condividere Incantesimi',
    summary:
        'Gli incantesimi che il Ranger lancia su sé stesso possono influenzare anche il compagno.',
    details:
        'Dal 15° livello, quando il Ranger lancia un incantesimo che bersaglia sé stesso, può influenzare anche il compagno animale se questo si trova entro 9 metri.',
    ruleTags: const {'companion', 'spellcasting', 'range_9_meters'},
  ),
};

final rangerBeastMasterDefinition = CharacterSubclassDefinition(
  id: RangerSubclassIds.beastMaster,
  name: 'Signore delle Bestie',
  classId: ClassIds.ranger,
  content: const RuleContent(
    id: RangerSubclassIds.beastMaster,
    name: 'Signore delle Bestie',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Ranger che stringe un profondo legame con una bestia compagna.',
      details:
          'Il Signore delle Bestie combatte in sintonia con un compagno animale, ne migliora le capacità e infine condivide con esso i propri incantesimi.',
    ),
    source: _phbRangerBeastMasterSource,
    ownerId: ClassIds.ranger,
  ),
  featuresByLevel: const {
    3: [RangerBeastMasterFeatureIds.rangerCompanion],
    7: [RangerBeastMasterFeatureIds.exceptionalTraining],
    11: [RangerBeastMasterFeatureIds.bestialFury],
    15: [RangerBeastMasterFeatureIds.shareSpells],
  },
  featureDefinitions: rangerBeastMasterFeatureDefinitions,
  companions: const [rangerAnimalCompanionDefinition],
);

final rangerClassDefinition = CharacterClassDefinition(
  id: ClassIds.ranger,
  name: 'Ranger',
  content: const RuleContent(
    id: ClassIds.ranger,
    name: 'Ranger',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un combattente delle terre selvagge specializzato nella caccia, nell’esplorazione e nella magia della natura.',
      details:
          'Il Ranger protegge i confini della civiltà, studia nemici specifici, domina i viaggi negli ambienti naturali e dal 2° livello usa incantesimi basati sulla Saggezza. Al 3° livello sceglie un Archetipo Ranger.',
    ),
    source: _phbRangerSource,
    ownerId: ClassIds.ranger,
  ),
  hitDie: 10,
  proficiencies: const ClassProficiencyDefinition(
    armor: {
      'light_armor',
      'medium_armor',
      'shield',
    },
    weapons: {
      'simple_weapons',
      'martial_weapons',
    },
    savingThrows: {
      'FOR',
      'DES',
    },
    skillOptions: {
      'animal_handling',
      'athletics',
      'stealth',
      'investigation',
      'insight',
      'nature',
      'perception',
      'survival',
    },
    skillChoices: 3,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'ranger_skills',
        label: 'Scegli tre abilità da Ranger',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'animal_handling',
          'athletics',
          'stealth',
          'investigation',
          'insight',
          'nature',
          'perception',
          'survival',
        },
        selections: 3,
      ),
    ],
  ),
  startingEquipmentChoices: [
    const ClassEquipmentChoice(
      id: 'ranger_starting_armor',
      label: 'Scegli l’armatura iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'ranger_scale_mail',
          label: 'Corazza a Scaglie',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.scaleMail,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'ranger_leather_armor',
          label: 'Armatura di Cuoio',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.leather,
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'ranger_melee_weapons',
      label: 'Scegli le armi da mischia iniziali',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'ranger_two_shortswords',
          label: 'Due Spade Corte',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'shortsword',
              quantity: 2,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'ranger_two_simple_melee_weapons',
          label: 'Due Armi Semplici da Mischia',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'ranger_simple_melee_weapon_selection',
              label: 'Scegli due Armi Semplici da Mischia',
              catalogId: 'weapon',
              optionIds: _rangerSimpleMeleeWeaponIds,
              selections: 2,
              allowDuplicates: true,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'ranger_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'ranger_dungeoneer_pack',
          label: 'Dotazione da Avventuriero',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.dungeoneer,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'ranger_explorer_pack',
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
      catalogId: 'weapon',
      itemId: 'longbow',
    ),
    ClassEquipmentGrant(
      catalogId: 'ammunition',
      itemId: 'arrows',
      quantity: 20,
    ),
  ],
  featuresByLevel: const {
    1: [
      RangerFeatureIds.favoredEnemy,
      RangerFeatureIds.naturalExplorer,
    ],
    2: [
      RangerFeatureIds.fightingStyle,
      RangerFeatureIds.spellcasting,
    ],
    3: [
      RangerFeatureIds.rangerArchetype,
      RangerFeatureIds.primevalAwareness,
    ],
    4: [RangerFeatureIds.abilityScoreImprovement],
    5: [RangerFeatureIds.extraAttack],
    6: [
      RangerFeatureIds.favoredEnemyImprovement6,
      RangerFeatureIds.naturalExplorerImprovement6,
    ],
    8: [
      RangerFeatureIds.abilityScoreImprovement,
      RangerFeatureIds.landStride,
    ],
    10: [
      RangerFeatureIds.naturalExplorerImprovement10,
      RangerFeatureIds.hideInPlainSight,
    ],
    12: [RangerFeatureIds.abilityScoreImprovement],
    14: [
      RangerFeatureIds.favoredEnemyImprovement14,
      RangerFeatureIds.vanish,
    ],
    16: [RangerFeatureIds.abilityScoreImprovement],
    18: [RangerFeatureIds.feralSenses],
    19: [RangerFeatureIds.abilityScoreImprovement],
    20: [RangerFeatureIds.foeSlayer],
  },
  featureDefinitions: rangerFeatureDefinitions,
  spellcasting: const ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.half,
    ability: 'SAG',
    minimumLevel: 2,
    slotsByClassLevel: _rangerSpellSlotsByLevel,
    spellsKnownByLevel: _rangerSpellsKnownByLevel,
    spellIds: phbRangerSpellIds,
  ),
  subclassSelectionLevel: 3,
  subclasses: {
    RangerSubclassIds.hunter: rangerHunterDefinition,
    RangerSubclassIds.beastMaster: rangerBeastMasterDefinition,
  },
);
