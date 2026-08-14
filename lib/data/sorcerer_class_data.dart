import 'ammunition_data.dart';
import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_pack_data.dart';
import 'focus_data.dart';
import 'weapon_data.dart';

const _phbSorcererSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 107-110',
);

abstract final class SorcererSubclassIds {
  static const draconicBloodline = 'draconic_bloodline';
  static const wildMagic = 'wild_magic';
}

const phbSorcererSubclassIds = <String>{
  SorcererSubclassIds.draconicBloodline,
  SorcererSubclassIds.wildMagic,
};

abstract final class SorcererFeatureIds {
  static const spellcasting = 'sorcerer_spellcasting';
  static const sorcerousOrigin = 'sorcerous_origin';
  static const fontOfMagic = 'font_of_magic';
  static const metamagic = 'metamagic';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const metamagicImprovement10 = 'metamagic_improvement_10';
  static const metamagicImprovement17 = 'metamagic_improvement_17';
  static const sorcerousRestoration = 'sorcerous_restoration';
}

abstract final class SorcererResourceIds {
  static const sorceryPoints = 'sorcery_points';
}

abstract final class SorcererConversionIds {
  static const flexibleCasting = 'flexible_casting';
}

abstract final class SorcererMetamagicIds {
  static const carefulSpell = 'careful_spell';
  static const distantSpell = 'distant_spell';
  static const empoweredSpell = 'empowered_spell';
  static const extendedSpell = 'extended_spell';
  static const heightenedSpell = 'heightened_spell';
  static const quickenedSpell = 'quickened_spell';
  static const subtleSpell = 'subtle_spell';
  static const twinnedSpell = 'twinned_spell';
}

const phbSorcererSpellIds = <String>{
  'acid_splash',
  'blade_ward',
  'chill_touch',
  'dancing_lights',
  'fire_bolt',
  'friends',
  'light',
  'mage_hand',
  'mending',
  'message',
  'minor_illusion',
  'poison_spray',
  'prestidigitation',
  'ray_of_frost',
  'shocking_grasp',
  'true_strike',
  'burning_hands',
  'charm_person',
  'chromatic_orb',
  'color_spray',
  'comprehend_languages',
  'detect_magic',
  'disguise_self',
  'expeditious_retreat',
  'false_life',
  'feather_fall',
  'fog_cloud',
  'jump',
  'mage_armor',
  'magic_missile',
  'ray_of_sickness',
  'shield',
  'silent_image',
  'sleep',
  'thunderwave',
  'witch_bolt',
  'alter_self',
  'blindness_deafness',
  'blur',
  'cloud_of_daggers',
  'crown_of_madness',
  'darkness',
  'darkvision',
  'detect_thoughts',
  'enhance_ability',
  'enlarge_reduce',
  'gust_of_wind',
  'hold_person',
  'invisibility',
  'knock',
  'levitate',
  'mirror_image',
  'misty_step',
  'phantasmal_force',
  'scorching_ray',
  'see_invisibility',
  'shatter',
  'spider_climb',
  'suggestion',
  'web',
  'blink',
  'clairvoyance',
  'counterspell',
  'daylight',
  'dispel_magic',
  'fear',
  'fireball',
  'fly',
  'gaseous_form',
  'haste',
  'hypnotic_pattern',
  'lightning_bolt',
  'major_image',
  'protection_from_energy',
  'sleet_storm',
  'slow',
  'stinking_cloud',
  'tongues',
  'water_breathing',
  'water_walk',
  'banishment',
  'blight',
  'confusion',
  'dimension_door',
  'dominate_beast',
  'greater_invisibility',
  'ice_storm',
  'polymorph',
  'stoneskin',
  'wall_of_fire',
  'animate_objects',
  'cloudkill',
  'cone_of_cold',
  'creation',
  'dominate_person',
  'hold_monster',
  'insect_plague',
  'seeming',
  'telekinesis',
  'teleportation_circle',
  'wall_of_stone',
  'arcane_gate',
  'chain_lightning',
  'circle_of_death',
  'disintegrate',
  'eyebite',
  'globe_of_invulnerability',
  'mass_suggestion',
  'move_earth',
  'sunbeam',
  'true_seeing',
  'delayed_blast_fireball',
  'etherealness',
  'finger_of_death',
  'fire_storm',
  'plane_shift',
  'prismatic_spray',
  'reverse_gravity',
  'teleport',
  'dominate_monster',
  'earthquake',
  'incendiary_cloud',
  'power_word_stun',
  'sunburst',
  'gate',
  'meteor_swarm',
  'power_word_kill',
  'time_stop',
  'wish',
};

final Set<String> _sorcererSimpleWeaponIds = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.simple)
    .map((weapon) => weapon.id)
    .toSet();

final Set<String> _sorcererArcaneFocusIds = focusDefinitions.values
    .where((focus) => focus.category == FocusCategory.arcane)
    .map((focus) => focus.id)
    .toSet();

const sorcererFlexibleCastingDefinition = ClassResourceConversionDefinition(
  id: SorcererConversionIds.flexibleCasting,
  name: 'Incantesimi Flessibili',
  minimumLevel: 2,
  resourceId: SorcererResourceIds.sorceryPoints,
  activation: ClassFeatureActivation.bonusAction,
  resourceCostBySpellSlotLevel: {1: 2, 2: 3, 3: 5, 4: 6, 5: 7},
  resourceGainedPerExpendedSlotLevel: 1,
  maximumCreatedSpellSlotLevel: 5,
  createdSpellSlotsExpireOnLongRest: true,
);

ClassResourceUsageDefinition _metamagic({
  required String id,
  required String name,
  required String summary,
  required String details,
  required int cost,
  ClassResourceCostScaling costScaling = ClassResourceCostScaling.fixed,
  bool combinable = false,
  required CharacterEffects effects,
}) =>
    ClassResourceUsageDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.classFeature,
        description: RuleDescription(summary: summary, details: details),
        source: _phbSorcererSource,
        ownerId: ClassIds.sorcerer,
      ),
      minimumLevel: 3,
      resourceId: SorcererResourceIds.sorceryPoints,
      baseResourceCost: cost,
      costScaling: costScaling,
      activation: ClassFeatureActivation.whenCasting,
      combinableWithOtherUsages: combinable,
      effects: effects,
    );

final phbSorcererMetamagicDefinitions = <String, ClassResourceUsageDefinition>{
  SorcererMetamagicIds.carefulSpell: _metamagic(
    id: SorcererMetamagicIds.carefulSpell,
    name: 'Incantesimo Preciso',
    summary:
        'Protegge alcune creature dagli effetti completi di un incantesimo.',
    details:
        'Spendendo 1 punto stregoneria quando lancia un incantesimo che obbliga altre creature a effettuare un tiro salvezza, lo Stregone sceglie fino a un numero di creature pari al modificatore di Carisma, minimo una. Le creature scelte superano automaticamente il tiro salvezza.',
    cost: 1,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'careful_spell_automatic_saves',
          type: CharacterRuleEffectType.conditional,
          target: 'chosen_creatures_automatically_succeed_spell_save',
          condition: 'up_to_charisma_modifier_minimum_one_creature',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.distantSpell: _metamagic(
    id: SorcererMetamagicIds.distantSpell,
    name: 'Incantesimo Distante',
    summary: 'Estende la gittata di un incantesimo.',
    details:
        'Spendendo 1 punto stregoneria, raddoppia una gittata pari o superiore a 1,5 metri oppure trasforma la gittata a contatto in 9 metri.',
    cost: 1,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'distant_spell_range',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_range',
          value: 2,
          condition: 'double_range_or_touch_becomes_nine_meters',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.empoweredSpell: _metamagic(
    id: SorcererMetamagicIds.empoweredSpell,
    name: 'Incantesimo Potenziato',
    summary: 'Ripete alcuni dadi dei danni di un incantesimo.',
    details:
        'Spendendo 1 punto stregoneria quando tira i danni, ripete fino a un numero di dadi pari al modificatore di Carisma, minimo uno, e deve usare i nuovi risultati. Può essere usato anche insieme a un’altra opzione di Metamagia.',
    cost: 1,
    combinable: true,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'empowered_spell_reroll_damage_dice',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_damage_dice_rerolls',
          condition: 'up_to_charisma_modifier_minimum_one_use_new_results',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.extendedSpell: _metamagic(
    id: SorcererMetamagicIds.extendedSpell,
    name: 'Incantesimo Esteso',
    summary: 'Raddoppia la durata di un incantesimo persistente.',
    details:
        'Spendendo 1 punto stregoneria raddoppia la durata di un incantesimo che dura almeno 1 minuto, fino a un massimo di 24 ore.',
    cost: 1,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'extended_spell_duration',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_duration',
          value: 2,
          condition: 'minimum_one_minute_maximum_twenty_four_hours',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.heightenedSpell: _metamagic(
    id: SorcererMetamagicIds.heightenedSpell,
    name: 'Incantesimo Intensificato',
    summary: 'Imposta svantaggio al primo tiro salvezza di un bersaglio.',
    details:
        'Spendendo 3 punti stregoneria, impone svantaggio a un bersaglio dell’incantesimo sul primo tiro salvezza effettuato contro quell’incantesimo.',
    cost: 3,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'heightened_spell_first_save_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target: 'one_target_first_saving_throw_against_spell',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.quickenedSpell: _metamagic(
    id: SorcererMetamagicIds.quickenedSpell,
    name: 'Incantesimo Rapido',
    summary: 'Trasforma un tempo di lancio di un’azione in azione bonus.',
    details:
        'Spendendo 2 punti stregoneria, cambia in 1 azione bonus il tempo di lancio di un incantesimo che normalmente richiede 1 azione.',
    cost: 2,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'quickened_spell_casting_time',
          type: CharacterRuleEffectType.conditional,
          target: 'one_action_spell_casting_time',
          condition: 'becomes_bonus_action_for_this_casting',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.subtleSpell: _metamagic(
    id: SorcererMetamagicIds.subtleSpell,
    name: 'Incantesimo Celato',
    summary: 'Elimina le componenti somatiche e verbali.',
    details:
        'Spendendo 1 punto stregoneria, lancia l’incantesimo senza componenti somatiche o verbali.',
    cost: 1,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'subtle_spell_components',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_components',
          condition: 'no_somatic_or_verbal_components',
        ),
      ],
    ),
  ),
  SorcererMetamagicIds.twinnedSpell: _metamagic(
    id: SorcererMetamagicIds.twinnedSpell,
    name: 'Incantesimo Raddoppiato',
    summary: 'Aggiunge un secondo bersaglio a un incantesimo idoneo.',
    details:
        'Per un incantesimo che bersaglia una sola creatura e non ha gittata incantatore, spende punti stregoneria pari al livello dell’incantesimo, o 1 per un trucchetto, per bersagliare una seconda creatura entro gittata. L’incantesimo non deve poter bersagliare più di una creatura al livello attuale.',
    cost: 1,
    costScaling: ClassResourceCostScaling.spellLevelMinimumOne,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'twinned_spell_second_target',
          type: CharacterRuleEffectType.conditional,
          target: 'second_creature_within_spell_range',
          condition:
              'single_target_not_self_range_and_cannot_target_multiple_creatures_at_current_level',
        ),
      ],
    ),
  ),
};

final phbSorcererMetamagicOptions = <CharacterChoiceOptionDefinition>[
  for (final definition in phbSorcererMetamagicDefinitions.values)
    CharacterChoiceOptionDefinition(
      id: definition.id,
      label: definition.content.name,
      effects: definition.effects,
    ),
];

CharacterClassFeatureDefinition _sorcererFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> ruleTags = const {},
  String? resourceId,
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
        source: _phbSorcererSource,
        ownerId: ClassIds.sorcerer,
      ),
      ruleTags: ruleTags,
      resourceId: resourceId,
      choices: choices,
      effects: effects,
    );

CharacterChoiceDefinition _metamagicChoice({
  required String suffix,
  required int selections,
}) =>
    CharacterChoiceDefinition(
      id: 'sorcerer_metamagic_$suffix',
      label: selections == 2
          ? 'Scegli due opzioni di Metamagia'
          : 'Scegli una nuova opzione di Metamagia',
      type: CharacterChoiceType.other,
      catalogId: CharacterChoiceCatalogIds.metamagic,
      minimumSelections: selections,
      maximumSelections: selections,
      options: phbSorcererMetamagicOptions,
      unique: true,
      requireNewAcquisition: true,
    );

final sorcererFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  SorcererFeatureIds.spellcasting: _sorcererFeature(
    id: SorcererFeatureIds.spellcasting,
    name: 'Incantesimi',
    summary:
        'Lo Stregone usa il Carisma per lanciare una selezione crescente di incantesimi innati.',
    details:
        'Dal 1° livello conosce quattro trucchetti e due incantesimi di 1° livello. Recupera tutti gli slot con un riposo lungo. Quando acquisisce un livello da Stregone può sostituire un incantesimo conosciuto con un altro incantesimo da Stregone di un livello per cui possiede slot. Carisma determina CD e tiro per colpire; può usare un focus arcano.',
    ruleTags: const {
      'spellcasting',
      'charisma',
      'spells_known',
      'arcane_focus',
    },
  ),
  SorcererFeatureIds.sorcerousOrigin: _sorcererFeature(
    id: SorcererFeatureIds.sorcerousOrigin,
    name: 'Origine Stregonesca',
    summary: 'Lo Stregone sceglie la fonte della propria magia innata.',
    details:
        'Al 1° livello sceglie Discendenza Draconica oppure Magia Selvaggia. L’origine concede privilegi al 1°, 6°, 14° e 18° livello.',
    ruleTags: const {'subclass', 'sorcerous_origin'},
  ),
  SorcererFeatureIds.fontOfMagic: _sorcererFeature(
    id: SorcererFeatureIds.fontOfMagic,
    name: 'Fonte di Magia',
    summary:
        'Lo Stregone ottiene Punti Stregoneria e li converte in slot o viceversa.',
    details:
        'Dal 2° livello possiede un numero massimo di Punti Stregoneria pari al livello da Stregone e li recupera con un riposo lungo. Come azione bonus può creare uno slot di livello non superiore al 5° spendendo 2, 3, 5, 6 o 7 punti rispettivamente, oppure sacrificare uno slot per ottenere Punti Stregoneria pari al suo livello. Gli slot creati svaniscono al termine di un riposo lungo.',
    ruleTags: const {
      'sorcery_points',
      'resource_conversion',
      'bonus_action',
    },
    resourceId: SorcererResourceIds.sorceryPoints,
  ),
  SorcererFeatureIds.metamagic: _sorcererFeature(
    id: SorcererFeatureIds.metamagic,
    name: 'Metamagia',
    summary:
        'Lo Stregone impara a plasmare i propri incantesimi spendendo Punti Stregoneria.',
    details:
        'Al 3° livello sceglie due delle otto opzioni di Metamagia del Manuale. Salvo diversa indicazione, può applicare una sola opzione a ogni lancio.',
    ruleTags: const {'metamagic', 'choice', 'sorcery_points'},
    resourceId: SorcererResourceIds.sorceryPoints,
    choices: [_metamagicChoice(suffix: '3', selections: 2)],
  ),
  SorcererFeatureIds.abilityScoreImprovement: _sorcererFeature(
    id: SorcererFeatureIds.abilityScoreImprovement,
    name: 'Aumento dei Punteggi di Caratteristica',
    summary:
        'Lo Stregone aumenta una caratteristica di 2 oppure due caratteristiche di 1.',
    details:
        'Al 4°, 8°, 12°, 16° e 19° livello aumenta di 2 un punteggio oppure aumenta di 1 due punteggi, senza superare 20 tramite questo privilegio.',
    ruleTags: const {'ability_score_improvement'},
  ),
  SorcererFeatureIds.metamagicImprovement10: _sorcererFeature(
    id: SorcererFeatureIds.metamagicImprovement10,
    name: 'Metamagia Aggiuntiva',
    summary: 'Lo Stregone apprende una terza opzione di Metamagia.',
    details:
        'Al 10° livello sceglie una nuova opzione di Metamagia che non conosce già.',
    ruleTags: const {'metamagic', 'choice', 'improvement'},
    resourceId: SorcererResourceIds.sorceryPoints,
    choices: [_metamagicChoice(suffix: '10', selections: 1)],
  ),
  SorcererFeatureIds.metamagicImprovement17: _sorcererFeature(
    id: SorcererFeatureIds.metamagicImprovement17,
    name: 'Metamagia Aggiuntiva',
    summary: 'Lo Stregone apprende una quarta opzione di Metamagia.',
    details:
        'Al 17° livello sceglie una nuova opzione di Metamagia che non conosce già.',
    ruleTags: const {'metamagic', 'choice', 'improvement'},
    resourceId: SorcererResourceIds.sorceryPoints,
    choices: [_metamagicChoice(suffix: '17', selections: 1)],
  ),
  SorcererFeatureIds.sorcerousRestoration: _sorcererFeature(
    id: SorcererFeatureIds.sorcerousRestoration,
    name: 'Ripristino Stregonesco',
    summary:
        'Lo Stregone recupera parte dei Punti Stregoneria durante i riposi brevi.',
    details:
        'Al 20° livello recupera 4 Punti Stregoneria spesi ogni volta che completa un riposo breve.',
    ruleTags: const {'sorcery_points', 'short_rest', 'recovery'},
    resourceId: SorcererResourceIds.sorceryPoints,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'sorcerous_restoration_points',
          type: CharacterRuleEffectType.resource,
          target: SorcererResourceIds.sorceryPoints,
          value: 4,
          condition: 'recover_on_short_rest',
        ),
      ],
    ),
  ),
};

const _phbSorcererDraconicSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 110-111',
);

abstract final class SorcererDraconicFeatureIds {
  static const draconicAncestry = 'sorcerer_draconic_ancestry';
  static const draconicResilience = 'draconic_resilience';
  static const elementalAffinity = 'elemental_affinity';
  static const dragonWings = 'dragon_wings';
  static const draconicPresence = 'draconic_presence';
}

abstract final class SorcererDraconicUsageIds {
  static const elementalAffinityResistance = 'elemental_affinity_resistance';
  static const draconicPresence = 'draconic_presence_usage';
}

class SorcererDraconicAncestryDefinition {
  final String id;
  final String name;
  final String damageType;
  final String damageTypeLabel;

  const SorcererDraconicAncestryDefinition({
    required this.id,
    required this.name,
    required this.damageType,
    required this.damageTypeLabel,
  });
}

const phbSorcererDraconicAncestryDefinitions =
    <String, SorcererDraconicAncestryDefinition>{
  'black': SorcererDraconicAncestryDefinition(
    id: 'black',
    name: 'Nero',
    damageType: 'acid',
    damageTypeLabel: 'Acido',
  ),
  'blue': SorcererDraconicAncestryDefinition(
    id: 'blue',
    name: 'Blu',
    damageType: 'lightning',
    damageTypeLabel: 'Fulmine',
  ),
  'brass': SorcererDraconicAncestryDefinition(
    id: 'brass',
    name: 'Ottone',
    damageType: 'fire',
    damageTypeLabel: 'Fuoco',
  ),
  'bronze': SorcererDraconicAncestryDefinition(
    id: 'bronze',
    name: 'Bronzo',
    damageType: 'lightning',
    damageTypeLabel: 'Fulmine',
  ),
  'copper': SorcererDraconicAncestryDefinition(
    id: 'copper',
    name: 'Rame',
    damageType: 'acid',
    damageTypeLabel: 'Acido',
  ),
  'gold': SorcererDraconicAncestryDefinition(
    id: 'gold',
    name: 'Oro',
    damageType: 'fire',
    damageTypeLabel: 'Fuoco',
  ),
  'green': SorcererDraconicAncestryDefinition(
    id: 'green',
    name: 'Verde',
    damageType: 'poison',
    damageTypeLabel: 'Veleno',
  ),
  'red': SorcererDraconicAncestryDefinition(
    id: 'red',
    name: 'Rosso',
    damageType: 'fire',
    damageTypeLabel: 'Fuoco',
  ),
  'silver': SorcererDraconicAncestryDefinition(
    id: 'silver',
    name: 'Argento',
    damageType: 'cold',
    damageTypeLabel: 'Freddo',
  ),
  'white': SorcererDraconicAncestryDefinition(
    id: 'white',
    name: 'Bianco',
    damageType: 'cold',
    damageTypeLabel: 'Freddo',
  ),
};

final phbSorcererDraconicAncestryOptions = <CharacterChoiceOptionDefinition>[
  for (final ancestry in phbSorcererDraconicAncestryDefinitions.values)
    CharacterChoiceOptionDefinition(
      id: ancestry.id,
      label: 'Drago ${ancestry.name} · ${ancestry.damageTypeLabel}',
      effects: CharacterEffects(
        ruleEffects: [
          CharacterRuleEffect(
            id: 'sorcerer_draconic_ancestry_${ancestry.id}',
            type: CharacterRuleEffectType.conditional,
            target: 'draconic_ancestry_damage_type',
            referenceIds: [ancestry.damageType],
            condition: 'selected_draconic_ancestor_${ancestry.id}',
          ),
        ],
      ),
    ),
];

final sorcererDraconicAncestryChoice = CharacterChoiceDefinition(
  id: 'sorcerer_draconic_ancestry_choice',
  label: 'Scegli un Antenato Draconico',
  type: CharacterChoiceType.other,
  minimumSelections: 1,
  maximumSelections: 1,
  options: phbSorcererDraconicAncestryOptions,
  unique: true,
);

CharacterClassFeatureDefinition _sorcererDraconicFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> ruleTags = const {},
  String? resourceId,
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
        source: _phbSorcererDraconicSource,
        ownerId: ClassIds.sorcerer,
      ),
      ruleTags: ruleTags,
      resourceId: resourceId,
      choices: choices,
      effects: effects,
    );

final sorcererDraconicFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  SorcererDraconicFeatureIds.draconicAncestry: _sorcererDraconicFeature(
    id: SorcererDraconicFeatureIds.draconicAncestry,
    name: 'Antenato Draconico',
    summary:
        'Lo Stregone sceglie una stirpe draconica e ne apprende la lingua.',
    details:
        'Al 1° livello sceglie uno dei dieci tipi di drago della tabella Discendenza Draconica. Il tipo di danno associato alimenta Affinità Elementale. Lo Stregone sa parlare, leggere e scrivere in Draconico e raddoppia il bonus di competenza nelle prove di Carisma effettuate per interagire con i draghi quando la competenza è applicabile.',
    ruleTags: const {'draconic_ancestry', 'language', 'expertise'},
    choices: [sorcererDraconicAncestryChoice],
    effects: const CharacterEffects(
      languages: {'Draconico'},
      ruleEffects: [
        CharacterRuleEffect(
          id: 'draconic_ancestry_charisma_expertise',
          type: CharacterRuleEffectType.conditional,
          target: 'charisma_checks_interacting_with_dragons',
          value: 2,
          condition: 'double_proficiency_bonus_when_proficient',
        ),
      ],
    ),
  ),
  SorcererDraconicFeatureIds.draconicResilience: _sorcererDraconicFeature(
    id: SorcererDraconicFeatureIds.draconicResilience,
    name: 'Resilienza Draconica',
    summary:
        'La magia draconica aumenta i punti ferita e protegge la pelle dello Stregone.',
    details:
        'Al 1° livello il massimo dei punti ferita aumenta di 1 e aumenta di un ulteriore punto per ogni livello da Stregone acquisito. Quando non indossa armatura, la sua Classe Armatura è pari a 13 + il modificatore di Destrezza.',
    ruleTags: const {'hit_points', 'unarmored_armor_class'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'draconic_resilience_hit_points',
          type: CharacterRuleEffectType.conditional,
          target: 'maximum_hit_points',
          value: 1,
          condition: 'per_sorcerer_level',
        ),
        CharacterRuleEffect(
          id: 'draconic_resilience_armor_class',
          type: CharacterRuleEffectType.conditional,
          target: 'unarmored_armor_class',
          value: 13,
          condition: 'base_thirteen_plus_dexterity_modifier_without_armor',
        ),
      ],
    ),
  ),
  SorcererDraconicFeatureIds.elementalAffinity: _sorcererDraconicFeature(
    id: SorcererDraconicFeatureIds.elementalAffinity,
    name: 'Affinità Elementale',
    summary:
        'Gli incantesimi affini alla stirpe infliggono più danni e possono concedere resistenza.',
    details:
        'Dal 6° livello, quando lancia un incantesimo che infligge il tipo di danno associato all’antenato draconico, aggiunge il modificatore di Carisma a un tiro per i danni di quell’incantesimo. Nello stesso momento può spendere 1 Punto Stregoneria per ottenere resistenza a quel tipo di danno per 1 ora.',
    ruleTags: const {'damage_bonus', 'damage_resistance', 'sorcery_points'},
    resourceId: SorcererResourceIds.sorceryPoints,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'elemental_affinity_damage_bonus',
          type: CharacterRuleEffectType.damageBonus,
          target: 'one_matching_spell_damage_roll',
          condition:
              'add_charisma_modifier_when_damage_matches_selected_draconic_ancestry',
        ),
      ],
    ),
  ),
  SorcererDraconicFeatureIds.dragonWings: _sorcererDraconicFeature(
    id: SorcererDraconicFeatureIds.dragonWings,
    name: 'Ali di Drago',
    summary: 'Lo Stregone manifesta ali draconiche e ottiene volo.',
    details:
        'Dal 14° livello, come azione bonus manifesta o fa scomparire un paio di ali dalla schiena. Mentre sono presenti ottiene una velocità di volare pari alla velocità attuale. Non può manifestarle mentre indossa un’armatura, a meno che questa sia predisposta; gli abiti non predisposti possono essere distrutti.',
    ruleTags: const {'bonus_action', 'flight', 'manifestation'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'dragon_wings_activation',
          type: CharacterRuleEffectType.conditional,
          target: 'manifest_or_dismiss_dragon_wings',
          condition: 'bonus_action_armor_must_accommodate_wings',
        ),
        CharacterRuleEffect(
          id: 'dragon_wings_flying_speed',
          type: CharacterRuleEffectType.movement,
          target: 'flying_speed',
          condition: 'equal_to_current_walking_speed_while_wings_manifested',
        ),
      ],
    ),
  ),
  SorcererDraconicFeatureIds.draconicPresence: _sorcererDraconicFeature(
    id: SorcererDraconicFeatureIds.draconicPresence,
    name: 'Presenza Draconica',
    summary:
        'Lo Stregone emana un’aura che affascina o spaventa le creature vicine.',
    details:
        'Dal 18° livello, come azione e spendendo 5 Punti Stregoneria, emana per un massimo di 1 minuto un’aura di soggezione o paura entro 18 metri, mantenendo la concentrazione come per un incantesimo. Una creatura ostile che inizia il turno nell’aura supera un tiro salvezza di Saggezza contro la CD degli incantesimi o resta affascinata, se è stata scelta soggezione, oppure spaventata fino alla fine dell’aura. Chi supera il tiro è immune all’aura per 24 ore.',
    ruleTags: const {
      'action',
      'aura',
      'charmed',
      'frightened',
      'concentration',
      'sorcery_points',
    },
    resourceId: SorcererResourceIds.sorceryPoints,
  ),
};

const sorcererDraconicResourceUsages = <ClassResourceUsageDefinition>[
  ClassResourceUsageDefinition(
    id: SorcererDraconicUsageIds.elementalAffinityResistance,
    content: RuleContent(
      id: SorcererDraconicUsageIds.elementalAffinityResistance,
      name: 'Resistenza dell’Affinità Elementale',
      type: RuleContentType.classFeature,
      description: RuleDescription(
        summary: 'Ottiene resistenza al tipo di danno della stirpe per 1 ora.',
        details:
            'Quando applica Affinità Elementale a un incantesimo, lo Stregone può spendere 1 Punto Stregoneria per ottenere resistenza al tipo di danno associato all’antenato draconico per 1 ora.',
      ),
      source: _phbSorcererDraconicSource,
      ownerId: ClassIds.sorcerer,
    ),
    minimumLevel: 6,
    resourceId: SorcererResourceIds.sorceryPoints,
    baseResourceCost: 1,
    activation: ClassFeatureActivation.whenCasting,
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'elemental_affinity_resistance_effect',
          type: CharacterRuleEffectType.conditional,
          target: 'damage_resistance',
          condition: 'selected_draconic_ancestry_damage_type_for_one_hour',
        ),
      ],
    ),
  ),
  ClassResourceUsageDefinition(
    id: SorcererDraconicUsageIds.draconicPresence,
    content: RuleContent(
      id: SorcererDraconicUsageIds.draconicPresence,
      name: 'Attivare Presenza Draconica',
      type: RuleContentType.classFeature,
      description: RuleDescription(
        summary: 'Attiva l’aura di soggezione o paura.',
        details:
            'Come azione spende 5 Punti Stregoneria per attivare Presenza Draconica.',
      ),
      source: _phbSorcererDraconicSource,
      ownerId: ClassIds.sorcerer,
    ),
    minimumLevel: 18,
    resourceId: SorcererResourceIds.sorceryPoints,
    baseResourceCost: 5,
    activation: ClassFeatureActivation.action,
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'draconic_presence_aura',
          type: CharacterRuleEffectType.conditional,
          target: 'hostile_creatures_within_eighteen_meters',
          value: 18,
          condition:
              'choose_awe_charmed_or_fear_frightened_wisdom_save_spell_dc_concentration_one_minute_success_immunity_twenty_four_hours',
        ),
      ],
    ),
  ),
];

final sorcererDraconicBloodlineDefinition = CharacterSubclassDefinition(
  id: SorcererSubclassIds.draconicBloodline,
  name: 'Discendenza Draconica',
  classId: ClassIds.sorcerer,
  content: const RuleContent(
    id: SorcererSubclassIds.draconicBloodline,
    name: 'Discendenza Draconica',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary: 'La magia innata dello Stregone deriva da una stirpe draconica.',
      details:
          'La Discendenza Draconica concede tratti fisici, affinità elementale, ali e la capacità di proiettare la presenza terrificante o maestosa di un drago.',
    ),
    source: _phbSorcererDraconicSource,
    ownerId: ClassIds.sorcerer,
  ),
  featuresByLevel: const {
    1: [
      SorcererDraconicFeatureIds.draconicAncestry,
      SorcererDraconicFeatureIds.draconicResilience,
    ],
    6: [SorcererDraconicFeatureIds.elementalAffinity],
    14: [SorcererDraconicFeatureIds.dragonWings],
    18: [SorcererDraconicFeatureIds.draconicPresence],
  },
  featureDefinitions: sorcererDraconicFeatureDefinitions,
  resourceUsages: sorcererDraconicResourceUsages,
);

const _phbSorcererWildMagicSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 111-112',
);

abstract final class SorcererWildMagicFeatureIds {
  static const wildMagicSurge = 'wild_magic_surge';
  static const tidesOfChaos = 'tides_of_chaos';
  static const bendLuck = 'bend_luck';
  static const controlledChaos = 'controlled_chaos';
  static const spellBombardment = 'spell_bombardment';
}

abstract final class SorcererWildMagicResourceIds {
  static const tidesOfChaos = 'tides_of_chaos_uses';
}

abstract final class SorcererWildMagicUsageIds {
  static const tidesOfChaos = 'use_tides_of_chaos';
  static const bendLuck = 'use_bend_luck';
}

abstract final class SorcererWildMagicTableIds {
  static const wildMagicSurges = 'wild_magic_surges';
}

ClassRandomTableEntryDefinition _wildMagicEntry({
  required String id,
  required int minimumRoll,
  required int maximumRoll,
  required String description,
  Set<String> spellIds = const {},
  Set<String> creatureIds = const {},
}) =>
    ClassRandomTableEntryDefinition(
      id: id,
      minimumRoll: minimumRoll,
      maximumRoll: maximumRoll,
      description: description,
      spellIds: spellIds,
      creatureIds: creatureIds,
    );

final phbSorcererWildMagicSurgeEntries = <ClassRandomTableEntryDefinition>[
  _wildMagicEntry(
    id: "surge_01_02_repeated_rolls",
    minimumRoll: 1,
    maximumRoll: 2,
    description:
        "Tira su questa tabella all’inizio di ogni tuo turno per il minuto successivo, ignorando questo risultato ai tiri successivi.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_03_04_see_invisible",
    minimumRoll: 3,
    maximumRoll: 4,
    description:
        "Per il minuto successivo puoi vedere qualsiasi creatura invisibile verso cui disponi di linea di vista.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_05_06_modron",
    minimumRoll: 5,
    maximumRoll: 6,
    description:
        "Un modron scelto e controllato dal DM compare in uno spazio libero entro 1,5 metri e scompare 1 minuto dopo.",
    spellIds: const <String>{},
    creatureIds: {"modron"},
  ),
  _wildMagicEntry(
    id: "surge_07_08_fireball",
    minimumRoll: 7,
    maximumRoll: 8,
    description:
        "Lanci Palla di Fuoco come incantesimo di 3° livello centrato su te stesso.",
    spellIds: {"fireball"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_09_10_magic_missile",
    minimumRoll: 9,
    maximumRoll: 10,
    description: "Lanci Dardo Incantato come incantesimo di 5° livello.",
    spellIds: {"magic_missile"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_11_12_height",
    minimumRoll: 11,
    maximumRoll: 12,
    description:
        "Tira un d10. La tua altezza cambia di 2,5 cm per il risultato: dispari rimpicciolisce, pari cresce.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_13_14_confusion",
    minimumRoll: 13,
    maximumRoll: 14,
    description: "Lanci Confusione centrato su te stesso.",
    spellIds: {"confusion"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_15_16_regeneration",
    minimumRoll: 15,
    maximumRoll: 16,
    description:
        "Per il minuto successivo recuperi 5 punti ferita all’inizio di ogni tuo turno.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_17_18_feather_beard",
    minimumRoll: 17,
    maximumRoll: 18,
    description:
        "Sviluppi una barba di piume che rimane finché non starnutisci, quando le piume schizzano via senza danni.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_19_20_grease",
    minimumRoll: 19,
    maximumRoll: 20,
    description: "Lanci Unto centrato su te stesso.",
    spellIds: {"grease"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_21_22_save_disadvantage",
    minimumRoll: 21,
    maximumRoll: 22,
    description:
        "Le creature hanno svantaggio ai tiri salvezza contro il prossimo incantesimo che lancerai entro 1 minuto e che richieda un tiro salvezza.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_23_24_blue_skin",
    minimumRoll: 23,
    maximumRoll: 24,
    description:
        "La tua pelle diventa azzurra; Rimuovi Maledizione può terminare l’effetto.",
    spellIds: {"remove_curse"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_25_26_third_eye",
    minimumRoll: 25,
    maximumRoll: 26,
    description:
        "Per 1 minuto un occhio appare sulla tua fronte e hai vantaggio alle prove di Saggezza (Percezione) basate sulla vista.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_27_28_quickened_spells",
    minimumRoll: 27,
    maximumRoll: 28,
    description:
        "Per 1 minuto i tuoi incantesimi con tempo di lancio di 1 azione richiedono invece 1 azione bonus.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_29_30_teleport",
    minimumRoll: 29,
    maximumRoll: 30,
    description:
        "Ti teletrasporti fino a 18 metri in uno spazio libero visibile.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_31_32_astral_plane",
    minimumRoll: 31,
    maximumRoll: 32,
    description:
        "Sei trasportato sul Piano Astrale fino alla fine del turno successivo, poi ritorni nello spazio precedente o nel più vicino spazio libero.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_33_34_maximize_damage",
    minimumRoll: 33,
    maximumRoll: 34,
    description:
        "Massimizzi i danni del prossimo incantesimo che infligge danni lanciato entro 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_35_36_age",
    minimumRoll: 35,
    maximumRoll: 36,
    description:
        "Tira un d10. La tua età cambia di altrettanti anni: dispari ringiovanisce fino a un minimo di un anno, pari invecchia.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_37_38_flumphs",
    minimumRoll: 37,
    maximumRoll: 38,
    description:
        "1d6 flumph controllati dal DM appaiono entro 18 metri, sono spaventati da te e svaniscono dopo 1 minuto.",
    spellIds: const <String>{},
    creatureIds: {"flumph"},
  ),
  _wildMagicEntry(
    id: "surge_39_40_healing",
    minimumRoll: 39,
    maximumRoll: 40,
    description: "Recuperi 2d10 punti ferita.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_41_42_potted_plant",
    minimumRoll: 41,
    maximumRoll: 42,
    description:
        "Diventi una pianta in vaso fino all’inizio del turno successivo: sei incapacitato e vulnerabile a tutti i danni; a 0 PF il vaso si rompe e torni normale.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_43_44_bonus_teleport",
    minimumRoll: 43,
    maximumRoll: 44,
    description:
        "Per 1 minuto puoi teletrasportarti fino a 6 metri come azione bonus in ogni tuo turno.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_45_46_levitate",
    minimumRoll: 45,
    maximumRoll: 46,
    description: "Lanci Levitazione su te stesso.",
    spellIds: {"levitate"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_47_48_unicorn",
    minimumRoll: 47,
    maximumRoll: 48,
    description:
        "Un unicorno controllato dal DM appare entro 1,5 metri e scompare 1 minuto dopo.",
    spellIds: const <String>{},
    creatureIds: {"unicorn"},
  ),
  _wildMagicEntry(
    id: "surge_49_50_pink_bubbles",
    minimumRoll: 49,
    maximumRoll: 50,
    description:
        "Non puoi parlare per 1 minuto; quando ci provi, bolle rosa escono dalla tua bocca.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_51_52_spectral_shield",
    minimumRoll: 51,
    maximumRoll: 52,
    description:
        "Per 1 minuto uno scudo spettrale ti conferisce +2 alla CA e immunità a Dardo Incantato.",
    spellIds: {"magic_missile"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_53_54_alcohol_immunity",
    minimumRoll: 53,
    maximumRoll: 54,
    description: "Sei immune all’intossicazione alcolica per 5d6 giorni.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_55_56_hair_loss",
    minimumRoll: 55,
    maximumRoll: 56,
    description: "Perdi tutti i capelli, che ricrescono entro 24 ore.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_57_58_ignite_objects",
    minimumRoll: 57,
    maximumRoll: 58,
    description:
        "Per 1 minuto ogni oggetto infiammabile che tocchi, se non indossato o trasportato da un’altra creatura, prende fuoco.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_59_60_recover_spell_slot",
    minimumRoll: 59,
    maximumRoll: 60,
    description:
        "Recuperi lo slot incantesimo di livello più basso che hai speso.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_61_62_shouting",
    minimumRoll: 61,
    maximumRoll: 62,
    description: "Per 1 minuto devi gridare quando parli.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_63_64_fog_cloud",
    minimumRoll: 63,
    maximumRoll: 64,
    description: "Lanci Nube di Nebbia centrata su te stesso.",
    spellIds: {"fog_cloud"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_65_66_lightning_damage",
    minimumRoll: 65,
    maximumRoll: 66,
    description:
        "Fino a tre creature scelte entro 9 metri subiscono 4d10 danni da fulmine.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_67_68_frightened",
    minimumRoll: 67,
    maximumRoll: 68,
    description:
        "Sei spaventato dalla creatura più vicina fino alla fine del tuo turno successivo.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_69_70_mass_invisibility",
    minimumRoll: 69,
    maximumRoll: 70,
    description:
        "Ogni creatura entro 9 metri diventa invisibile per 1 minuto; l’effetto termina quando attacca o lancia un incantesimo.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_71_72_all_damage_resistance",
    minimumRoll: 71,
    maximumRoll: 72,
    description: "Ottieni resistenza a tutti i danni per 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_73_74_poisoned",
    minimumRoll: 73,
    maximumRoll: 74,
    description:
        "Una creatura casuale entro 18 metri diventa avvelenata per 1d4 ore.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_75_76_bright_light",
    minimumRoll: 75,
    maximumRoll: 76,
    description:
        "Emetti luce intensa entro 9 metri per 1 minuto; chi termina il turno entro 1,5 metri è accecato fino alla fine del proprio turno successivo.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_77_78_polymorph",
    minimumRoll: 77,
    maximumRoll: 78,
    description:
        "Lanci Metamorfosi su te stesso; se fallisci il tiro salvezza diventi una pecora per la durata.",
    spellIds: {"polymorph"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_79_80_butterflies",
    minimumRoll: 79,
    maximumRoll: 80,
    description:
        "Farfalle e petali illusori fluttuano entro 3 metri per 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_81_82_additional_action",
    minimumRoll: 81,
    maximumRoll: 82,
    description: "Puoi effettuare immediatamente un’azione aggiuntiva.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_83_84_necrotic_burst",
    minimumRoll: 83,
    maximumRoll: 84,
    description:
        "Ogni creatura entro 9 metri subisce 1d10 danni necrotici; recuperi PF pari alla somma dei danni inflitti.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_85_86_mirror_image",
    minimumRoll: 85,
    maximumRoll: 86,
    description: "Lanci Immagine Speculare.",
    spellIds: {"mirror_image"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_87_88_fly",
    minimumRoll: 87,
    maximumRoll: 88,
    description: "Lanci Volare su una creatura casuale entro 18 metri.",
    spellIds: {"fly"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_89_90_invisible_and_inaudible",
    minimumRoll: 89,
    maximumRoll: 90,
    description:
        "Diventi invisibile e non puoi essere udito per 1 minuto; l’effetto termina se attacchi o lanci un incantesimo.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_91_92_reincarnate",
    minimumRoll: 91,
    maximumRoll: 92,
    description:
        "Se muori entro 1 minuto torni immediatamente in vita come per Reincarnazione.",
    spellIds: {"reincarnate"},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_93_94_size_increase",
    minimumRoll: 93,
    maximumRoll: 94,
    description: "La tua taglia aumenta di una categoria per 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_95_96_piercing_vulnerability",
    minimumRoll: 95,
    maximumRoll: 96,
    description:
        "Tu e tutte le creature entro 9 metri ottenete vulnerabilità ai danni perforanti per 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_97_98_ethereal_music",
    minimumRoll: 97,
    maximumRoll: 98,
    description: "Sei circondato da una debole musica eterea per 1 minuto.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
  _wildMagicEntry(
    id: "surge_99_100_restore_sorcery_points",
    minimumRoll: 99,
    maximumRoll: 100,
    description: "Recuperi tutti i Punti Stregoneria spesi.",
    spellIds: const <String>{},
    creatureIds: const <String>{},
  ),
];

final sorcererWildMagicSurgeTable = ClassRandomTableDefinition(
  id: SorcererWildMagicTableIds.wildMagicSurges,
  content: const RuleContent(
    id: SorcererWildMagicTableIds.wildMagicSurges,
    name: 'Impulsi di Magia Selvaggia',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary: 'Tabella d100 degli Impulsi di Magia Selvaggia.',
      details: 'Contiene i cinquanta effetti del Manuale del Giocatore.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'p. 112',
    ),
    ownerId: ClassIds.sorcerer,
  ),
  minimumLevel: 1,
  dieSides: 100,
  entries: phbSorcererWildMagicSurgeEntries,
);

CharacterClassFeatureDefinition _sorcererWildMagicFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  Set<String> ruleTags = const {},
  String? resourceId,
  CharacterEffects effects = const CharacterEffects(),
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.classFeature,
        description: RuleDescription(summary: summary, details: details),
        source: _phbSorcererWildMagicSource,
        ownerId: ClassIds.sorcerer,
      ),
      ruleTags: ruleTags,
      resourceId: resourceId,
      effects: effects,
    );

final sorcererWildMagicFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  SorcererWildMagicFeatureIds.wildMagicSurge: _sorcererWildMagicFeature(
    id: SorcererWildMagicFeatureIds.wildMagicSurge,
    name: 'Impulso di Magia Selvaggia',
    summary: 'Gli incantesimi possono scatenare effetti incontrollati.',
    details:
        'Una volta per turno il DM può richiedere un d20 dopo un incantesimo da Stregone di 1° livello o superiore. Con 1 si tira sulla tabella d100. Gli incantesimi generati non accettano Metamagia e ignorano la concentrazione per la durata completa.',
    ruleTags: const {'d20', 'd100', 'wild_magic', 'dm_trigger'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'wild_magic_surge_trigger',
          type: CharacterRuleEffectType.conditional,
          target: SorcererWildMagicTableIds.wildMagicSurges,
          value: 1,
          condition:
              'once_per_turn_dm_may_request_d20_after_sorcerer_spell_level_one_or_higher_surge_on_one',
        ),
        CharacterRuleEffect(
          id: 'wild_magic_surge_spell_rules',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_cast_by_wild_magic_table',
          condition:
              'cannot_use_metamagic_and_ignores_concentration_for_full_duration',
        ),
      ],
    ),
  ),
  SorcererWildMagicFeatureIds.tidesOfChaos: _sorcererWildMagicFeature(
    id: SorcererWildMagicFeatureIds.tidesOfChaos,
    name: 'Onde di Caos',
    summary: 'Ottiene vantaggio a un tiro scelto.',
    details:
        'Ottiene vantaggio a un tiro per colpire, prova di caratteristica o tiro salvezza. Recupera l’uso con un riposo lungo o dopo un impulso richiesto dal DM in seguito a un incantesimo da Stregone di 1° livello o superiore.',
    ruleTags: const {'advantage', 'long_rest', 'wild_magic', 'dm_trigger'},
    resourceId: SorcererWildMagicResourceIds.tidesOfChaos,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'tides_of_chaos_dm_refresh',
          type: CharacterRuleEffectType.resource,
          target: SorcererWildMagicResourceIds.tidesOfChaos,
          value: 1,
          condition:
              'refresh_after_dm_triggered_surge_following_sorcerer_spell_level_one_or_higher',
        ),
      ],
    ),
  ),
  SorcererWildMagicFeatureIds.bendLuck: _sorcererWildMagicFeature(
    id: SorcererWildMagicFeatureIds.bendLuck,
    name: 'Piegare la Fortuna',
    summary: 'Altera di 1d4 il tiro di una creatura visibile.',
    details:
        'Come reazione e spendendo 2 Punti Stregoneria, dopo il tiro ma prima dei suoi effetti aggiunge o sottrae 1d4 a un attacco, prova o tiro salvezza di un’altra creatura visibile.',
    ruleTags: const {'reaction', 'd4', 'sorcery_points'},
    resourceId: SorcererResourceIds.sorceryPoints,
  ),
  SorcererWildMagicFeatureIds.controlledChaos: _sorcererWildMagicFeature(
    id: SorcererWildMagicFeatureIds.controlledChaos,
    name: 'Caos Controllato',
    summary: 'Tira due volte sulla tabella e sceglie il risultato.',
    details:
        'Ogni volta che tira sulla tabella Impulsi di Magia Selvaggia, tira due volte e sceglie quale risultato usare.',
    ruleTags: const {'wild_magic', 'roll_twice', 'choose_result'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'controlled_chaos_two_rolls',
          type: CharacterRuleEffectType.conditional,
          target: SorcererWildMagicTableIds.wildMagicSurges,
          value: 2,
          condition: 'roll_twice_choose_one_result',
        ),
      ],
    ),
  ),
  SorcererWildMagicFeatureIds.spellBombardment: _sorcererWildMagicFeature(
    id: SorcererWildMagicFeatureIds.spellBombardment,
    name: 'Bombardamento Magico',
    summary: 'Ripete un dado massimo dei danni e somma il risultato.',
    details:
        'Quando un dado dei danni di un incantesimo ottiene il massimo, ne sceglie uno, lo tira di nuovo e aggiunge il nuovo risultato; una volta per turno.',
    ruleTags: const {'spell_damage', 'reroll', 'once_per_turn'},
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'spell_bombardment_extra_die',
          type: CharacterRuleEffectType.damageBonus,
          target: 'one_maximum_spell_damage_die',
          condition: 'reroll_and_add_new_result_once_per_turn',
        ),
      ],
    ),
  ),
};

const sorcererWildMagicResources = <ClassResourceDefinition>[
  ClassResourceDefinition(
    id: SorcererWildMagicResourceIds.tidesOfChaos,
    name: 'Onde di Caos',
    minimumLevel: 1,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {1: 1},
  ),
];

const sorcererWildMagicResourceUsages = <ClassResourceUsageDefinition>[
  ClassResourceUsageDefinition(
    id: SorcererWildMagicUsageIds.tidesOfChaos,
    content: RuleContent(
      id: SorcererWildMagicUsageIds.tidesOfChaos,
      name: 'Usare Onde di Caos',
      type: RuleContentType.classFeature,
      description: RuleDescription(
        summary: 'Ottiene vantaggio a un tiro.',
        details: 'Consuma l’uso di Onde di Caos.',
      ),
      source: _phbSorcererWildMagicSource,
      ownerId: ClassIds.sorcerer,
    ),
    minimumLevel: 1,
    resourceId: SorcererWildMagicResourceIds.tidesOfChaos,
    baseResourceCost: 1,
    activation: ClassFeatureActivation.noAction,
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'tides_of_chaos_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'one_attack_roll_ability_check_or_saving_throw',
        ),
      ],
    ),
  ),
  ClassResourceUsageDefinition(
    id: SorcererWildMagicUsageIds.bendLuck,
    content: RuleContent(
      id: SorcererWildMagicUsageIds.bendLuck,
      name: 'Usare Piegare la Fortuna',
      type: RuleContentType.classFeature,
      description: RuleDescription(
        summary: 'Aggiunge o sottrae 1d4 al tiro altrui.',
        details: 'Dopo il tiro, prima dei suoi effetti, usa la reazione.',
      ),
      source: _phbSorcererWildMagicSource,
      ownerId: ClassIds.sorcerer,
    ),
    minimumLevel: 6,
    resourceId: SorcererResourceIds.sorceryPoints,
    baseResourceCost: 2,
    activation: ClassFeatureActivation.reaction,
    effects: CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'bend_luck_d4',
          type: CharacterRuleEffectType.conditional,
          target: 'visible_other_creature_attack_check_or_save',
          condition: 'after_roll_before_effect_add_or_subtract_one_d4',
        ),
      ],
    ),
  ),
];

final sorcererWildMagicDefinition = CharacterSubclassDefinition(
  id: SorcererSubclassIds.wildMagic,
  name: 'Magia Selvaggia',
  classId: ClassIds.sorcerer,
  content: const RuleContent(
    id: SorcererSubclassIds.wildMagic,
    name: 'Magia Selvaggia',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary: 'La magia innata deriva dalle forze imprevedibili del caos.',
      details:
          'Scatena impulsi casuali, piega la probabilità e sviluppa un controllo parziale sul caos.',
    ),
    source: _phbSorcererWildMagicSource,
    ownerId: ClassIds.sorcerer,
  ),
  featuresByLevel: const {
    1: [
      SorcererWildMagicFeatureIds.wildMagicSurge,
      SorcererWildMagicFeatureIds.tidesOfChaos,
    ],
    6: [SorcererWildMagicFeatureIds.bendLuck],
    14: [SorcererWildMagicFeatureIds.controlledChaos],
    18: [SorcererWildMagicFeatureIds.spellBombardment],
  },
  featureDefinitions: sorcererWildMagicFeatureDefinitions,
  resources: sorcererWildMagicResources,
  resourceUsages: sorcererWildMagicResourceUsages,
  randomTables: [sorcererWildMagicSurgeTable],
);

const _sorcererSpellSlotsByLevel = <int, List<int>>{
  1: [2, 0, 0, 0, 0, 0, 0, 0, 0],
  2: [3, 0, 0, 0, 0, 0, 0, 0, 0],
  3: [4, 2, 0, 0, 0, 0, 0, 0, 0],
  4: [4, 3, 0, 0, 0, 0, 0, 0, 0],
  5: [4, 3, 2, 0, 0, 0, 0, 0, 0],
  6: [4, 3, 3, 0, 0, 0, 0, 0, 0],
  7: [4, 3, 3, 1, 0, 0, 0, 0, 0],
  8: [4, 3, 3, 2, 0, 0, 0, 0, 0],
  9: [4, 3, 3, 3, 1, 0, 0, 0, 0],
  10: [4, 3, 3, 3, 2, 0, 0, 0, 0],
  11: [4, 3, 3, 3, 2, 1, 0, 0, 0],
  12: [4, 3, 3, 3, 2, 1, 0, 0, 0],
  13: [4, 3, 3, 3, 2, 1, 1, 0, 0],
  14: [4, 3, 3, 3, 2, 1, 1, 0, 0],
  15: [4, 3, 3, 3, 2, 1, 1, 1, 0],
  16: [4, 3, 3, 3, 2, 1, 1, 1, 0],
  17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
  18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
  19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
  20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
};

const _sorcererCantripsKnownByLevel = <int, int>{1: 4, 4: 5, 10: 6};

const _sorcererSpellsKnownByLevel = <int, int>{
  1: 2,
  2: 3,
  3: 4,
  4: 5,
  5: 6,
  6: 7,
  7: 8,
  8: 9,
  9: 10,
  10: 11,
  11: 12,
  13: 13,
  15: 14,
  17: 15,
};

final sorcererClassDefinition = CharacterClassDefinition(
  id: ClassIds.sorcerer,
  name: 'Stregone',
  content: const RuleContent(
    id: ClassIds.sorcerer,
    name: 'Stregone',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un incantatore la cui magia innata nasce da una discendenza o da un’influenza soprannaturale.',
      details:
          'Lo Stregone conosce pochi incantesimi ma li plasma tramite i Punti Stregoneria e la Metamagia. Al 1° livello sceglie l’Origine Stregonesca che determina la natura del suo potere.',
    ),
    source: _phbSorcererSource,
    ownerId: ClassIds.sorcerer,
  ),
  hitDie: 6,
  proficiencies: const ClassProficiencyDefinition(
    weapons: {
      'light_crossbow',
      'quarterstaff',
      'dart',
      'sling',
      'dagger',
    },
    savingThrows: {'COS', 'CAR'},
    skillOptions: {
      'arcana',
      'deception',
      'intimidation',
      'insight',
      'persuasion',
      'religion',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'sorcerer_skills',
        label: 'Scegli due abilità da Stregone',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'arcana',
          'deception',
          'intimidation',
          'insight',
          'persuasion',
          'religion',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'sorcerer_weapon',
      label: 'Scegli l’arma iniziale',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'sorcerer_light_crossbow',
          label: 'Balestra Leggera e 20 Quadrelli',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'light_crossbow',
            ),
            ClassEquipmentGrant(
              catalogId: 'ammunition',
              itemId: AmmunitionIds.crossbowBolts,
              quantity: 20,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'sorcerer_simple_weapon',
          label: 'Una qualsiasi Arma Semplice',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'sorcerer_simple_weapon_selection',
              label: 'Scegli un’Arma Semplice',
              catalogId: 'weapon',
              optionIds: _sorcererSimpleWeaponIds,
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'sorcerer_spellcasting_focus',
      label: 'Scegli la dotazione da incantatore',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'sorcerer_component_pouch',
          label: 'Borsa per Componenti',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'focus',
              itemId: FocusIds.componentPouch,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'sorcerer_arcane_focus',
          label: 'Focus Arcano',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'sorcerer_arcane_focus_selection',
              label: 'Scegli un Focus Arcano',
              catalogId: 'focus',
              optionIds: _sorcererArcaneFocusIds,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'sorcerer_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'sorcerer_dungeoneer_pack',
          label: 'Dotazione da Avventuriero',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.dungeoneer,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'sorcerer_explorer_pack',
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
      itemId: 'dagger',
      quantity: 2,
    ),
  ],
  featuresByLevel: const {
    1: [
      SorcererFeatureIds.spellcasting,
      SorcererFeatureIds.sorcerousOrigin,
    ],
    2: [SorcererFeatureIds.fontOfMagic],
    3: [SorcererFeatureIds.metamagic],
    4: [SorcererFeatureIds.abilityScoreImprovement],
    8: [SorcererFeatureIds.abilityScoreImprovement],
    10: [SorcererFeatureIds.metamagicImprovement10],
    12: [SorcererFeatureIds.abilityScoreImprovement],
    16: [SorcererFeatureIds.abilityScoreImprovement],
    17: [SorcererFeatureIds.metamagicImprovement17],
    19: [SorcererFeatureIds.abilityScoreImprovement],
    20: [SorcererFeatureIds.sorcerousRestoration],
  },
  featureDefinitions: sorcererFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: SorcererResourceIds.sorceryPoints,
      name: 'Punti Stregoneria',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      classLevelMultiplier: 1,
    ),
  ],
  resourceConversions: const [sorcererFlexibleCastingDefinition],
  resourceUsages: phbSorcererMetamagicDefinitions.values.toList(),
  spellcasting: const ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.full,
    ability: 'CAR',
    minimumLevel: 1,
    slotsByClassLevel: _sorcererSpellSlotsByLevel,
    cantripsKnownByLevel: _sorcererCantripsKnownByLevel,
    spellsKnownByLevel: _sorcererSpellsKnownByLevel,
    spellIds: phbSorcererSpellIds,
  ),
  subclassSelectionLevel: 1,
  subclasses: {
    SorcererSubclassIds.draconicBloodline: sorcererDraconicBloodlineDefinition,
    SorcererSubclassIds.wildMagic: sorcererWildMagicDefinition,
  },
);
