import 'armor_data.dart';
import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_pack_data.dart';
import 'fighting_style_data.dart';
import 'weapon_data.dart';
import 'battle_master_maneuver_data.dart';
import 'tool_data.dart';
import 'spell_data.dart';

const _phbFighterSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 70-72',
);

class FighterSubclassIds {
  static const champion = 'champion';
  static const battleMaster = 'battle_master';
  static const eldritchKnight = 'eldritch_knight';
}

const _fighterFeatureSpecs = <String, List<String>>{
  'fighting_style': [
    'Stile di Combattimento',
    'Il Guerriero adotta una particolare specializzazione marziale.',
    'Al 1° livello sceglie uno tra i sei Stili di Combattimento del Manuale del Giocatore. Non può scegliere più volte lo stesso stile.',
  ],
  'second_wind': [
    'Recuperare Energie',
    'Il Guerriero richiama le proprie riserve per recuperare punti ferita.',
    'Al 1° livello può usare un’azione bonus per recuperare 1d10 + il proprio livello da Guerriero punti ferita. Dopo l’utilizzo deve completare un riposo breve o lungo prima di poterlo usare nuovamente.',
  ],
  'action_surge': [
    'Azione Impetuosa',
    'Il Guerriero può spingersi oltre i propri normali limiti.',
    'Dal 2° livello, nel proprio turno, può effettuare un’azione aggiuntiva oltre alla propria azione normale e all’eventuale azione bonus. Recupera l’utilizzo con un riposo breve o lungo.',
  ],
  'martial_archetype': [
    'Archetipo Marziale',
    'Il Guerriero sceglie l’archetipo che rappresenta il proprio stile di combattimento.',
    'Al 3° livello sceglie Campione, Maestro di Battaglia o Cavaliere Mistico. L’archetipo concede ulteriori privilegi ai livelli 7, 10, 15 e 18.',
  ],
  'ability_score_improvement': [
    'Aumento dei Punteggi di Caratteristica',
    'Il Guerriero può migliorare le proprie caratteristiche o scegliere un talento.',
    'Ottiene questo privilegio ai livelli 4, 6, 8, 12, 14, 16 e 19, seguendo le regole generali dell’avanzamento.',
  ],
  'extra_attack': [
    'Attacco Extra',
    'Il Guerriero può effettuare due attacchi con l’azione di Attacco.',
    'Dal 5° livello può attaccare due volte anziché una quando usa l’azione di Attacco nel proprio turno.',
  ],
  'indomitable': [
    'Indomito',
    'Il Guerriero può ritentare un tiro salvezza fallito.',
    'Dal 9° livello può ripetere un tiro salvezza fallito, ma deve utilizzare il nuovo risultato. Recupera l’utilizzo dopo un riposo lungo.',
  ],
  'extra_attack_improvement': [
    'Attacco Extra Migliorato',
    'Il Guerriero può effettuare tre attacchi con l’azione di Attacco.',
    'Dall’11° livello può attaccare tre volte anziché una quando usa l’azione di Attacco nel proprio turno.',
  ],
  'indomitable_improvement': [
    'Indomito Migliorato',
    'Il numero di utilizzi di Indomito aumenta con l’esperienza.',
    'Il Guerriero può usare Indomito due volte tra un riposo lungo e l’altro dal 13° livello e tre volte dal 17° livello.',
  ],
  'action_surge_improvement': [
    'Azione Impetuosa Migliorata',
    'Il Guerriero può utilizzare Azione Impetuosa due volte.',
    'Dal 17° livello dispone di due utilizzi tra un riposo breve o lungo e non può utilizzare Azione Impetuosa più di una volta nello stesso turno.',
  ],
  'extra_attack_mastery': [
    'Attacco Extra Superiore',
    'Il Guerriero può effettuare quattro attacchi con l’azione di Attacco.',
    'Dal 20° livello può attaccare quattro volte anziché una quando usa l’azione di Attacco nel proprio turno.',
  ],
};

final List<CharacterChoiceOptionDefinition> phbFighterStyleOptions = [
  for (final id in phbFighterFightingStyleIds)
    CharacterChoiceOptionDefinition(
      id: id,
      label: fightingStyleDefinitions[id]!.name,
    ),
];

String? _fighterFeatureResourceId(String id) {
  if (id == 'second_wind') return 'second_wind';

  if (id == 'action_surge' || id == 'action_surge_improvement') {
    return 'action_surge';
  }

  if (id == 'indomitable' || id == 'indomitable_improvement') {
    return 'indomitable';
  }

  return null;
}

List<CharacterChoiceDefinition> _fighterFeatureChoices(String id) {
  if (id != 'fighting_style') return const [];

  return [
    CharacterChoiceDefinition(
      id: 'fighter_fighting_style',
      label: 'Scegli uno Stile di Combattimento',
      type: CharacterChoiceType.other,
      catalogId: CharacterChoiceCatalogIds.fightingStyles,
      options: phbFighterStyleOptions,
      requireNewAcquisition: true,
    ),
  ];
}

CharacterClassFeatureDefinition _fighterFeature(
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
        source: _phbFighterSource,
        ownerId: ClassIds.fighter,
      ),
      resourceId: _fighterFeatureResourceId(id),
      choices: _fighterFeatureChoices(id),
      ruleTags: {
        'class_feature',
        'fighter',
        if (id.contains('extra_attack')) 'extra_attack',
        if (id.contains('indomitable')) 'saving_throw_reroll',
        if (id.contains('action_surge')) 'additional_action',
        if (id == 'second_wind') ...{
          'bonus_action',
          'healing',
        },
      },
    );

final fighterFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _fighterFeatureSpecs.entries)
    entry.key: _fighterFeature(entry.key, entry.value),
};

final Set<String> _fighterMartialWeaponIds = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.martial)
    .map((weapon) => weapon.id)
    .toSet();

class ChampionFeatureIds {
  static const improvedCritical = 'improved_critical';
  static const remarkableAthlete = 'remarkable_athlete';
  static const additionalFightingStyle = 'additional_fighting_style';
  static const superiorCritical = 'superior_critical';
  static const survivor = 'survivor';
}

const _phbChampionSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 72-73',
);

CharacterClassFeatureDefinition _championFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  CharacterEffects effects = const CharacterEffects(),
  List<CharacterChoiceDefinition> choices = const [],
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
        source: _phbChampionSource,
        ownerId: FighterSubclassIds.champion,
      ),
      effects: effects,
      choices: choices,
      ruleTags: {
        'subclass_feature',
        'fighter',
        'champion',
        ...ruleTags,
      },
    );

final championFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  ChampionFeatureIds.improvedCritical: _championFeature(
    id: ChampionFeatureIds.improvedCritical,
    name: 'Critico Migliorato',
    summary:
        'Gli attacchi con arma del Campione mettono a segno un critico con 19 o 20.',
    details:
        'Dal 3° livello gli attacchi con arma del Campione sono colpi critici quando il risultato del d20 è 19 o 20.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'champion_improved_critical_range',
          type: CharacterRuleEffectType.criticalRange,
          target: 'weapon_attack_critical_range',
          value: 19,
          condition: 'weapon_attack',
        ),
      ],
    ),
    ruleTags: {
      'critical_hit',
      'weapon_attack',
    },
  ),
  ChampionFeatureIds.remarkableAthlete: _championFeature(
    id: ChampionFeatureIds.remarkableAthlete,
    name: 'Atleta Straordinario',
    summary:
        'Il Campione applica parte del bonus di competenza alle prove fisiche non competenti.',
    details:
        'Dal 7° livello aggiunge metà del proprio bonus di competenza, arrotondata per eccesso, alle prove di Forza, Destrezza o Costituzione che non includono già il bonus di competenza. La distanza del salto in lungo con rincorsa aumenta inoltre di 0,3 metri per ogni punto del modificatore di Forza.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'champion_remarkable_athlete_checks',
          type: CharacterRuleEffectType.conditional,
          target: 'strength_dexterity_constitution_ability_checks',
          condition: 'add_half_proficiency_rounded_up_when_not_proficient',
        ),
        CharacterRuleEffect(
          id: 'champion_remarkable_athlete_long_jump',
          type: CharacterRuleEffectType.movement,
          target: 'running_long_jump_distance_meters',
          condition: 'add_0_3_meters_per_strength_modifier',
        ),
      ],
    ),
    ruleTags: {
      'ability_check',
      'physical_ability',
      'long_jump',
    },
  ),
  ChampionFeatureIds.additionalFightingStyle: _championFeature(
    id: ChampionFeatureIds.additionalFightingStyle,
    name: 'Stile di Combattimento Aggiuntivo',
    summary:
        'Il Campione apprende un secondo Stile di Combattimento del Guerriero.',
    details:
        'Al 10° livello sceglie un secondo Stile di Combattimento tra quelli del Manuale del Giocatore. Non può scegliere nuovamente uno stile che possiede già.',
    choices: [
      CharacterChoiceDefinition(
        id: 'champion_additional_fighting_style',
        label: 'Scegli uno Stile di Combattimento aggiuntivo',
        type: CharacterChoiceType.other,
        catalogId: CharacterChoiceCatalogIds.fightingStyles,
        options: phbFighterStyleOptions,
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'fighting_style',
      'choice',
    },
  ),
  ChampionFeatureIds.superiorCritical: _championFeature(
    id: ChampionFeatureIds.superiorCritical,
    name: 'Critico Superiore',
    summary:
        'L’intervallo di critico degli attacchi con arma aumenta ulteriormente.',
    details:
        'Dal 15° livello gli attacchi con arma del Campione sono colpi critici quando il risultato del d20 è 18, 19 o 20.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'champion_superior_critical_range',
          type: CharacterRuleEffectType.criticalRange,
          target: 'weapon_attack_critical_range',
          value: 18,
          condition: 'weapon_attack',
        ),
      ],
    ),
    ruleTags: {
      'critical_hit',
      'weapon_attack',
    },
  ),
  ChampionFeatureIds.survivor: _championFeature(
    id: ChampionFeatureIds.survivor,
    name: 'Sopravvissuto',
    summary: 'Il Campione recupera punti ferita quando è gravemente ferito.',
    details:
        'Dal 18° livello, all’inizio di ogni proprio turno, se possiede almeno 1 punto ferita ma non più della metà dei suoi punti ferita massimi, recupera 5 + il modificatore di Costituzione punti ferita.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'champion_survivor_healing',
          type: CharacterRuleEffectType.conditional,
          target: 'hit_point_recovery_at_start_of_turn',
          value: 5,
          condition:
              'current_hp_above_zero_and_not_above_half_maximum_plus_constitution_modifier',
        ),
      ],
    ),
    ruleTags: {
      'healing',
      'start_of_turn',
      'constitution',
    },
  ),
};

final championSubclassDefinition = CharacterSubclassDefinition(
  id: FighterSubclassIds.champion,
  name: 'Campione',
  classId: ClassIds.fighter,
  content: RuleContent(
    id: FighterSubclassIds.champion,
    name: 'Campione',
    type: RuleContentType.subclassFeature,
    description: const RuleDescription(
      summary:
          'Un archetipo marziale concentrato sull’eccellenza fisica e sulla potenza dei colpi.',
      details:
          'Il Campione perfeziona le capacità fondamentali del Guerriero, amplia l’intervallo dei colpi critici, migliora le prestazioni atletiche e sviluppa una straordinaria capacità di sopravvivenza.',
    ),
    source: _phbChampionSource,
    ownerId: ClassIds.fighter,
  ),
  featuresByLevel: const {
    3: [
      ChampionFeatureIds.improvedCritical,
    ],
    7: [
      ChampionFeatureIds.remarkableAthlete,
    ],
    10: [
      ChampionFeatureIds.additionalFightingStyle,
    ],
    15: [
      ChampionFeatureIds.superiorCritical,
    ],
    18: [
      ChampionFeatureIds.survivor,
    ],
  },
  featureDefinitions: championFeatureDefinitions,
);

abstract final class BattleMasterFeatureIds {
  static const combatSuperiority = 'combat_superiority';
  static const studentOfWar = 'student_of_war';
  static const knowYourEnemy = 'know_your_enemy';
  static const improvedCombatSuperiority = 'improved_combat_superiority';
  static const relentless = 'relentless';
}

abstract final class BattleMasterResourceIds {
  static const superiorityDice = 'superiority_dice';
}

abstract final class BattleMasterProgressionIds {
  static const superiorityDie = 'superiority_die';
  static const maneuverSaveDc = 'maneuver_save_dc';
}

const _phbBattleMasterSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 73-74',
);

final _battleMasterArtisanToolOptions = toolDefinitions.values
    .where((tool) => tool.category == ToolCategory.artisan)
    .map(
      (tool) => CharacterChoiceOptionDefinition(
        id: tool.id,
        label: tool.name,
      ),
    )
    .toList(growable: false);

CharacterClassFeatureDefinition _battleMasterFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  String? resourceId,
  List<CharacterChoiceDefinition> choices = const [],
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
        source: _phbBattleMasterSource,
        ownerId: FighterSubclassIds.battleMaster,
      ),
      resourceId: resourceId,
      choices: choices,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'fighter',
        FighterSubclassIds.battleMaster,
        ...ruleTags,
      },
    );

final battleMasterFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  BattleMasterFeatureIds.combatSuperiority: _battleMasterFeature(
    id: BattleMasterFeatureIds.combatSuperiority,
    name: 'Superiorità in Combattimento',
    summary:
        'Il Maestro di Battaglia apprende manovre alimentate dai Dadi di Superiorità.',
    details:
        'Dal 3° livello conosce tre manovre e possiede quattro Dadi di Superiorità d8. Può usare soltanto una manovra per ogni attacco. Apprende due manovre aggiuntive ai livelli 7, 10 e 15 e, ogni volta che ne apprende di nuove, può sostituire una manovra conosciuta. Recupera tutti i dadi spesi al termine di un riposo breve o lungo. La CD delle manovre è 8 più il bonus di competenza più il modificatore di Forza o Destrezza, a sua scelta.',
    resourceId: BattleMasterResourceIds.superiorityDice,
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'battle_master_maneuver_catalog',
          type: CharacterRuleEffectType.conditional,
          target: 'battle_master_maneuvers',
          referenceIds:
              battleMasterManeuverDefinitions.keys.toList(growable: false),
        ),
        CharacterRuleEffect(
          id: 'battle_master_maneuver_save_dc',
          type: CharacterRuleEffectType.conditional,
          target: BattleMasterProgressionIds.maneuverSaveDc,
          condition:
              '8_plus_proficiency_bonus_plus_strength_or_dexterity_modifier',
        ),
      ],
    ),
    ruleTags: {
      'maneuvers',
      'superiority_dice',
      'short_or_long_rest_recovery',
    },
  ),
  BattleMasterFeatureIds.studentOfWar: _battleMasterFeature(
    id: BattleMasterFeatureIds.studentOfWar,
    name: 'Studioso della Guerra',
    summary:
        'Il Maestro di Battaglia ottiene competenza in uno strumento da artigiano.',
    details:
        'Al 3° livello sceglie un tipo di strumenti da artigiano nel quale non possiede già competenza.',
    choices: [
      CharacterChoiceDefinition(
        id: 'battle_master_artisan_tool',
        label: 'Scegli uno strumento da artigiano',
        type: CharacterChoiceType.tool,
        minimumSelections: 1,
        maximumSelections: 1,
        options: _battleMasterArtisanToolOptions,
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'artisan_tool_proficiency',
    },
  ),
  BattleMasterFeatureIds.knowYourEnemy: _battleMasterFeature(
    id: BattleMasterFeatureIds.knowYourEnemy,
    name: 'Conosci il Tuo Nemico',
    summary:
        'Il Guerriero studia una creatura per confrontarne le capacità con le proprie.',
    details:
        'Dal 7° livello, dopo almeno un minuto di osservazione o interazione fuori dal combattimento, il Guerriero apprende se la creatura gli è superiore, inferiore o pari in due caratteristiche scelte tra Forza, Destrezza, Costituzione, Classe Armatura, punti ferita attuali, livelli totali e livelli da Guerriero.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'battle_master_know_your_enemy_comparison',
          type: CharacterRuleEffectType.conditional,
          target: 'relative_characteristics',
          value: 2,
          referenceIds: [
            'FOR',
            'DES',
            'COS',
            'armor_class',
            'current_hit_points',
            'total_levels',
            'fighter_levels',
          ],
          condition: 'observe_or_interact_for_1_minute_outside_combat',
        ),
      ],
    ),
    ruleTags: {
      'observe_creature',
      'compare_two_characteristics',
      'outside_combat',
    },
  ),
  BattleMasterFeatureIds.improvedCombatSuperiority: _battleMasterFeature(
    id: BattleMasterFeatureIds.improvedCombatSuperiority,
    name: 'Superiorità in Combattimento Migliorata',
    summary: 'Il Dado di Superiorità aumenta con i livelli da Guerriero.',
    details:
        'Al 10° livello i Dadi di Superiorità diventano d10. Al 18° livello diventano d12.',
    resourceId: BattleMasterResourceIds.superiorityDice,
    ruleTags: {
      'superiority_die_progression',
      'd10_at_level_10',
      'd12_at_level_18',
    },
  ),
  BattleMasterFeatureIds.relentless: _battleMasterFeature(
    id: BattleMasterFeatureIds.relentless,
    name: 'Implacabile',
    summary:
        'Il Maestro di Battaglia recupera un Dado di Superiorità entrando in combattimento.',
    details:
        'Dal 15° livello, quando tira l’iniziativa senza Dadi di Superiorità disponibili, ne recupera uno.',
    resourceId: BattleMasterResourceIds.superiorityDice,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'battle_master_relentless_recovery',
          type: CharacterRuleEffectType.resource,
          target: BattleMasterResourceIds.superiorityDice,
          value: 1,
          condition: 'roll_initiative_with_no_superiority_dice_remaining',
        ),
      ],
    ),
    ruleTags: {
      'initiative_recovery',
      'recover_one_superiority_die',
    },
  ),
};

final battleMasterManeuverOptions = battleMasterManeuverDefinitions.values
    .map(
      (maneuver) => SubclassOptionDefinition(
        id: maneuver.id,
        name: maneuver.name,
        category: 'battle_master_maneuver',
        minimumLevel: 3,
        cost: 1,
        resource: BattleMasterResourceIds.superiorityDice,
        source: 'Manuale del Giocatore 2014',
        sourceRef: 'Pagine 73-74',
        description: RuleDescription(
          summary: maneuver.description,
          details:
              'La manovra consuma un Dado di Superiorità quando viene utilizzata.',
        ),
      ),
    )
    .toList(growable: false);

final battleMasterSubclassDefinition = CharacterSubclassDefinition(
  id: FighterSubclassIds.battleMaster,
  name: 'Maestro di Battaglia',
  classId: ClassIds.fighter,
  content: const RuleContent(
    id: FighterSubclassIds.battleMaster,
    name: 'Maestro di Battaglia',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un combattente tattico che domina il campo di battaglia attraverso manovre specializzate.',
      details:
          'Il Maestro di Battaglia studia la teoria e la pratica del combattimento, impiegando Dadi di Superiorità per alimentare manovre offensive, difensive e di comando.',
    ),
    source: _phbBattleMasterSource,
    ownerId: ClassIds.fighter,
  ),
  featuresByLevel: const {
    3: [
      BattleMasterFeatureIds.combatSuperiority,
      BattleMasterFeatureIds.studentOfWar,
    ],
    7: [
      BattleMasterFeatureIds.knowYourEnemy,
    ],
    10: [
      BattleMasterFeatureIds.improvedCombatSuperiority,
    ],
    15: [
      BattleMasterFeatureIds.relentless,
    ],
    18: [
      BattleMasterFeatureIds.improvedCombatSuperiority,
    ],
  },
  featureDefinitions: battleMasterFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: BattleMasterResourceIds.superiorityDice,
      name: 'Dadi di Superiorità',
      minimumLevel: 3,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        3: 4,
        7: 5,
        15: 6,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: BattleMasterProgressionIds.superiorityDie,
      name: 'Dado di Superiorità',
      valuesByLevel: {
        3: 'd8',
        10: 'd10',
        18: 'd12',
      },
    ),
    ClassProgressionValueDefinition(
      id: BattleMasterProgressionIds.maneuverSaveDc,
      name: 'CD delle Manovre',
      valuesByLevel: {
        3: '8 + bonus di competenza + modificatore di FOR o DES',
      },
    ),
  ],
  options: battleMasterManeuverOptions,
  optionProgression: const SubclassOptionProgression(
    selectionsByLevel: {
      3: 3,
      7: 5,
      10: 7,
      15: 9,
    },
    replacementLevels: {
      7,
      10,
      15,
    },
  ),
);

abstract final class EldritchKnightFeatureIds {
  static const spellcasting = 'eldritch_knight_spellcasting';
  static const weaponBond = 'weapon_bond';
  static const warMagic = 'war_magic';
  static const eldritchStrike = 'eldritch_strike';
  static const arcaneCharge = 'arcane_charge';
  static const improvedWarMagic = 'improved_war_magic';
}

abstract final class EldritchKnightSpellPoolIds {
  static const abjurationAndEvocation = 'eldritch_knight_abjuration_evocation';
  static const unrestricted = 'eldritch_knight_unrestricted';
}

const _phbEldritchKnightSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 74-75',
);

final eldritchKnightWizardSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.wizard))
    .map((spell) => spell.id)
    .toSet();

CharacterClassFeatureDefinition _eldritchKnightFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> spellIds = const {},
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
        source: _phbEldritchKnightSource,
        ownerId: FighterSubclassIds.eldritchKnight,
      ),
      spellIds: spellIds,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'fighter',
        FighterSubclassIds.eldritchKnight,
        ...ruleTags,
      },
    );

final eldritchKnightFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  EldritchKnightFeatureIds.spellcasting: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.spellcasting,
    name: 'Incantesimi',
    summary: 'Il Cavaliere Mistico apprende a lanciare incantesimi da Mago.',
    details:
        'Dal 3° livello usa Intelligenza come caratteristica da incantatore e recupera tutti gli slot spesi al termine di un riposo lungo. I trucchetti possono appartenere a qualsiasi scuola. La maggior parte degli incantesimi conosciuti deve appartenere ad Abiurazione o Invocazione, mentre quattro incantesimi possono essere scelti liberamente ai livelli 3, 8, 14 e 20. Ogni volta che acquisisce un livello da Guerriero può sostituire un incantesimo da Mago conosciuto con un altro di un livello per cui possiede slot; il sostituto deve essere di Abiurazione o Invocazione, salvo quando sostituisce uno dei quattro incantesimi di scuola libera.',
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_spellcasting_progression',
          type: CharacterRuleEffectType.spellcasting,
          target: 'wizard_spellcasting',
          referenceIds: eldritchKnightWizardSpellIds.toList(growable: false),
          condition:
              'intelligence_third_caster_abjuration_evocation_restriction',
        ),
      ],
    ),
    ruleTags: {
      'spellcasting',
      'intelligence_spellcasting',
      'third_caster',
      'wizard_spell_list',
    },
  ),
  EldritchKnightFeatureIds.weaponBond: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.weaponBond,
    name: 'Arma Vincolata',
    summary:
        'Il Cavaliere Mistico crea un legame magico con un massimo di due armi.',
    details:
        'Con un rituale di un’ora, che può celebrare durante un riposo breve, crea un legame con un’arma tenuta a portata di mano. Non può essere disarmato dall’arma legata a meno che non sia incapacitato. Se si trova sullo stesso piano di esistenza, può evocarla nella propria mano con un’azione bonus. Può mantenere fino a due armi legate ed evocarne soltanto una con la stessa azione bonus; vincolarne una terza spezza uno dei legami precedenti.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_bonded_weapon_limit',
          type: CharacterRuleEffectType.conditional,
          target: 'bonded_weapons',
          value: 2,
          condition: 'one_hour_ritual',
        ),
        CharacterRuleEffect(
          id: 'eldritch_knight_bonded_weapon_cannot_be_disarmed',
          type: CharacterRuleEffectType.conditional,
          target: 'disarm_bonded_weapon',
          condition: 'fighter_is_conscious',
        ),
        CharacterRuleEffect(
          id: 'eldritch_knight_summon_bonded_weapon',
          type: CharacterRuleEffectType.conditional,
          target: 'summon_bonded_weapon_to_hand',
          condition: 'bonus_action_and_same_plane_of_existence',
        ),
      ],
    ),
    ruleTags: {
      'weapon_bond',
      'maximum_two_weapons',
      'one_hour_ritual',
      'bonus_action_summon',
    },
  ),
  EldritchKnightFeatureIds.warMagic: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.warMagic,
    name: 'Magia da Guerra',
    summary:
        'Dopo aver lanciato un trucchetto il Guerriero può attaccare con un’azione bonus.',
    details:
        'Dal 7° livello, quando usa la propria azione per lanciare un trucchetto, può effettuare un attacco con arma usando un’azione bonus.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_war_magic_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'bonus_action_weapon_attack',
          condition: 'after_casting_cantrip_with_action',
        ),
      ],
    ),
    ruleTags: {
      'cantrip',
      'bonus_action_weapon_attack',
    },
  ),
  EldritchKnightFeatureIds.eldritchStrike: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.eldritchStrike,
    name: 'Colpo Mistico',
    summary:
        'Le armi del Cavaliere Mistico indeboliscono le difese magiche del bersaglio.',
    details:
        'Dal 10° livello, quando colpisce una creatura con un attacco con arma, quella creatura dispone di svantaggio al prossimo tiro salvezza contro un incantesimo lanciato dal Guerriero prima della fine del suo turno successivo.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_spell_save_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target: 'next_saving_throw_against_fighter_spell',
          condition: 'after_weapon_hit_until_end_of_fighter_next_turn',
        ),
      ],
    ),
    ruleTags: {
      'weapon_hit',
      'spell_saving_throw_disadvantage',
    },
  ),
  EldritchKnightFeatureIds.arcaneCharge: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.arcaneCharge,
    name: 'Carica Arcana',
    summary: 'Azione Impetuosa permette al Guerriero di teletrasportarsi.',
    details:
        'Dal 15° livello, quando usa Azione Impetuosa, può teletrasportarsi fino a 9 metri in uno spazio libero che può vedere. Può farlo prima o dopo l’azione aggiuntiva.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_arcane_charge_teleport',
          type: CharacterRuleEffectType.movement,
          target: 'teleport',
          value: 9,
          referenceIds: [
            'action_surge',
          ],
          condition: 'before_or_after_action_surge_additional_action',
        ),
      ],
    ),
    ruleTags: {
      'action_surge',
      'teleport_9_meters',
    },
  ),
  EldritchKnightFeatureIds.improvedWarMagic: _eldritchKnightFeature(
    id: EldritchKnightFeatureIds.improvedWarMagic,
    name: 'Magia da Guerra Migliorata',
    summary:
        'Dopo aver lanciato un incantesimo il Guerriero può attaccare con un’azione bonus.',
    details:
        'Dal 18° livello, quando usa la propria azione per lanciare un incantesimo, può effettuare un attacco con arma usando un’azione bonus.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_knight_improved_war_magic_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'bonus_action_weapon_attack',
          condition: 'after_casting_spell_with_action',
        ),
      ],
    ),
    ruleTags: {
      'spell',
      'bonus_action_weapon_attack',
    },
  ),
};

final eldritchKnightSubclassDefinition = CharacterSubclassDefinition(
  id: FighterSubclassIds.eldritchKnight,
  name: 'Cavaliere Mistico',
  classId: ClassIds.fighter,
  content: const RuleContent(
    id: FighterSubclassIds.eldritchKnight,
    name: 'Cavaliere Mistico',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un combattente che unisce la disciplina marziale alla magia arcana.',
      details:
          'Il Cavaliere Mistico apprende incantesimi da Mago, crea legami magici con le proprie armi e combina attacchi e magia sul campo di battaglia.',
    ),
    source: _phbEldritchKnightSource,
    ownerId: ClassIds.fighter,
  ),
  featuresByLevel: const {
    3: [
      EldritchKnightFeatureIds.spellcasting,
      EldritchKnightFeatureIds.weaponBond,
    ],
    7: [
      EldritchKnightFeatureIds.warMagic,
    ],
    10: [
      EldritchKnightFeatureIds.eldritchStrike,
    ],
    15: [
      EldritchKnightFeatureIds.arcaneCharge,
    ],
    18: [
      EldritchKnightFeatureIds.improvedWarMagic,
    ],
  },
  featureDefinitions: eldritchKnightFeatureDefinitions,
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
      3: 2,
      10: 3,
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
    spellIds: eldritchKnightWizardSpellIds,
    learningPools: const [
      ClassSpellLearningPoolDefinition(
        id: EldritchKnightSpellPoolIds.abjurationAndEvocation,
        name: 'Abiurazione e Invocazione',
        allowedSchoolIds: {
          'abjuration',
          'evocation',
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
        id: EldritchKnightSpellPoolIds.unrestricted,
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

final fighterSubclasses = <String, CharacterSubclassDefinition>{
  FighterSubclassIds.eldritchKnight: eldritchKnightSubclassDefinition,
  FighterSubclassIds.battleMaster: battleMasterSubclassDefinition,
  FighterSubclassIds.champion: championSubclassDefinition,
};

final fighterClassDefinition = CharacterClassDefinition(
  id: ClassIds.fighter,
  name: 'Guerriero',
  content: RuleContent(
    id: ClassIds.fighter,
    name: 'Guerriero',
    type: RuleContentType.classFeature,
    description: const RuleDescription(
      summary:
          'Un combattente versatile capace di padroneggiare armi, armature e numerose tecniche marziali.',
      details:
          'Il Guerriero possiede il più ampio addestramento marziale, sviluppa una specializzazione di combattimento e ottiene più attacchi e incrementi di caratteristica rispetto alle altre classi.',
    ),
    source: _phbFighterSource,
    ownerId: ClassIds.fighter,
  ),
  hitDie: 10,
  proficiencies: const ClassProficiencyDefinition(
    armor: {
      'light_armor',
      'medium_armor',
      'heavy_armor',
      'shield',
    },
    weapons: {
      'simple_weapons',
      'martial_weapons',
    },
    savingThrows: {
      'FOR',
      'COS',
    },
    skillOptions: {
      'acrobatics',
      'animal_handling',
      'athletics',
      'history',
      'insight',
      'intimidation',
      'perception',
      'survival',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'fighter_skills',
        label: 'Scegli due abilità da Guerriero',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'acrobatics',
          'animal_handling',
          'athletics',
          'history',
          'insight',
          'intimidation',
          'perception',
          'survival',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    const ClassEquipmentChoice(
      id: 'fighter_armor',
      label: 'Scegli l’armatura iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'fighter_chain_mail',
          label: 'Cotta di Maglia',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.chainMail,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'fighter_leather_longbow',
          label: 'Armatura di Cuoio, Arco Lungo e 20 Frecce',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.leather,
            ),
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
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'fighter_martial_loadout',
      label: 'Scegli la dotazione marziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'fighter_martial_weapon_and_shield',
          label: 'Un’Arma da Guerra e uno Scudo',
          grants: const [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.shield,
            ),
          ],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'fighter_martial_weapon_with_shield',
              label: 'Scegli un’Arma da Guerra',
              catalogId: 'weapon',
              optionIds: _fighterMartialWeaponIds,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'fighter_two_martial_weapons',
          label: 'Due Armi da Guerra',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'fighter_two_martial_weapon_selection',
              label: 'Scegli due Armi da Guerra',
              catalogId: 'weapon',
              optionIds: _fighterMartialWeaponIds,
              selections: 2,
              allowDuplicates: true,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'fighter_ranged_loadout',
      label: 'Scegli la dotazione secondaria',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'fighter_light_crossbow',
          label: 'Balestra Leggera e 20 Quadrelli',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'light_crossbow',
            ),
            ClassEquipmentGrant(
              catalogId: 'ammunition',
              itemId: 'crossbow_bolts',
              quantity: 20,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'fighter_two_handaxes',
          label: 'Due Asce',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'handaxe',
              quantity: 2,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'fighter_pack',
      label: 'Scegli la dotazione da esplorazione',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'fighter_dungeoneer_pack',
          label: 'Dotazione da Avventuriero',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.dungeoneer,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'fighter_explorer_pack',
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
  featuresByLevel: const {
    1: [
      'fighting_style',
      'second_wind',
    ],
    2: [
      'action_surge',
    ],
    3: [
      'martial_archetype',
    ],
    4: [
      'ability_score_improvement',
    ],
    5: [
      'extra_attack',
    ],
    6: [
      'ability_score_improvement',
    ],
    8: [
      'ability_score_improvement',
    ],
    9: [
      'indomitable',
    ],
    11: [
      'extra_attack_improvement',
    ],
    12: [
      'ability_score_improvement',
    ],
    13: [
      'indomitable_improvement',
    ],
    14: [
      'ability_score_improvement',
    ],
    16: [
      'ability_score_improvement',
    ],
    17: [
      'action_surge_improvement',
      'indomitable_improvement',
    ],
    19: [
      'ability_score_improvement',
    ],
    20: [
      'extra_attack_mastery',
    ],
  },
  featureDefinitions: fighterFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'second_wind',
      name: 'Recuperare Energie',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        1: 1,
      },
    ),
    ClassResourceDefinition(
      id: 'action_surge',
      name: 'Azione Impetuosa',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        2: 1,
        17: 2,
      },
    ),
    ClassResourceDefinition(
      id: 'indomitable',
      name: 'Indomito',
      minimumLevel: 9,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        9: 1,
        13: 2,
        17: 3,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'attacks_per_attack_action',
      name: 'Attacchi per Azione di Attacco',
      valuesByLevel: {
        1: '1',
        5: '2',
        11: '3',
        20: '4',
      },
    ),
  ],
  subclassSelectionLevel: 3,
  subclasses: fighterSubclasses,
);
