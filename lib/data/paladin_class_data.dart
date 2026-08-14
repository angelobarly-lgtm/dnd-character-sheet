import 'armor_data.dart';
import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_pack_data.dart';
import 'fighting_style_data.dart';
import 'focus_data.dart';
import 'weapon_data.dart';

const _phbPaladinSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 95-100',
);

class PaladinSubclassIds {
  static const ancients = 'oath_of_the_ancients';
  static const devotion = 'oath_of_devotion';
  static const vengeance = 'oath_of_vengeance';
}

const phbPaladinSubclassIds = <String>{
  PaladinSubclassIds.ancients,
  PaladinSubclassIds.devotion,
  PaladinSubclassIds.vengeance,
};

class PaladinFeatureIds {
  static const divineSense = 'divine_sense';
  static const layOnHands = 'lay_on_hands';
  static const fightingStyle = 'fighting_style';
  static const spellcasting = 'spellcasting';
  static const divineSmite = 'divine_smite';
  static const divineHealth = 'divine_health';
  static const sacredOath = 'sacred_oath';
  static const channelDivinity = 'channel_divinity';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const extraAttack = 'extra_attack';
  static const auraOfProtection = 'aura_of_protection';
  static const auraOfCourage = 'aura_of_courage';
  static const improvedDivineSmite = 'improved_divine_smite';
  static const cleansingTouch = 'cleansing_touch';
  static const auraImprovements = 'aura_improvements';
}

class PaladinResourceIds {
  static const divineSense = 'divine_sense';
  static const layOnHands = 'lay_on_hands';
  static const channelDivinity = 'channel_divinity';
  static const cleansingTouch = 'cleansing_touch';
}

class PaladinProgressionIds {
  static const auraRadiusMeters = 'paladin_aura_radius_meters';
}

const phbPaladinFightingStyleIds = <String>{
  'defense',
  'dueling',
  'great_weapon_fighting',
  'protection',
};

final List<CharacterChoiceOptionDefinition> phbPaladinFightingStyleOptions = [
  for (final id in phbPaladinFightingStyleIds)
    CharacterChoiceOptionDefinition(
      id: id,
      label: fightingStyleDefinitions[id]!.name,
    ),
];

final Set<String> _paladinMartialWeaponIds = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.martial)
    .map((weapon) => weapon.id)
    .toSet();

final Set<String> _paladinSimpleMeleeWeaponIds = weaponDefinitions.values
    .where(
      (weapon) =>
          weapon.category == WeaponCategory.simple &&
          weapon.kind == WeaponKind.melee,
    )
    .map((weapon) => weapon.id)
    .toSet();

final List<ClassEquipmentAlternative> paladinHolySymbolAlternatives = [
  for (final focus in focusDefinitions.values)
    if (focus.category == FocusCategory.holy)
      ClassEquipmentAlternative(
        id: 'paladin_holy_symbol_${focus.id}',
        label: focus.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'focus',
            itemId: focus.id,
          ),
        ],
      ),
];

const phbPaladinSpellIds = <String>{
  'bless',
  'command',
  'compelled_duel',
  'cure_wounds',
  'detect_evil_and_good',
  'detect_magic',
  'detect_poison_and_disease',
  'divine_favor',
  'heroism',
  'protection_from_evil_and_good',
  'purify_food_and_drink',
  'searing_smite',
  'shield_of_faith',
  'thunderous_smite',
  'wrathful_smite',
  'aid',
  'branding_smite',
  'find_steed',
  'lesser_restoration',
  'locate_object',
  'magic_weapon',
  'protection_from_poison',
  'zone_of_truth',
  'aura_of_vitality',
  'blinding_smite',
  'create_food_and_water',
  'crusaders_mantle',
  'daylight',
  'dispel_magic',
  'elemental_weapon',
  'magic_circle',
  'remove_curse',
  'revivify',
  'aura_of_life',
  'aura_of_purity',
  'banishment',
  'death_ward',
  'locate_creature',
  'staggering_smite',
  'banishing_smite',
  'circle_of_power',
  'destructive_wave',
  'dispel_evil_and_good',
  'geas',
  'raise_dead',
};

const _paladinFeatureSpecs = <String, List<String>>{
  PaladinFeatureIds.divineSense: [
    'Percezione del Divino',
    'Il Paladino percepisce la presenza di potenti creature sovrannaturali.',
    'Dal 1° livello può usare un’azione per percepire fino alla fine del proprio turno successivo la posizione di ogni celestiale, immondo o non morto entro 18 metri che non si trovi dietro copertura totale. Ne riconosce il tipo, ma non l’identità. Entro lo stesso raggio percepisce inoltre la presenza di ogni luogo sacro o sacrilego, come descritto dall’incantesimo Santificare.',
  ],
  PaladinFeatureIds.layOnHands: [
    'Imposizione delle Mani',
    'Il Paladino possiede una riserva di energia curativa pari a cinque volte il proprio livello.',
    'Dal 1° livello può usare un’azione per toccare una creatura e ripristinare punti ferita spendendoli dalla propria riserva. Può inoltre spendere 5 punti per neutralizzare un veleno o curare una malattia, pagando separatamente ogni veleno o malattia. La riserva si ripristina al termine di un riposo lungo. Il privilegio non ha effetto sui costrutti e sui non morti.',
  ],
  PaladinFeatureIds.fightingStyle: [
    'Stile di Combattimento',
    'Il Paladino sceglie una specializzazione marziale.',
    'Al 2° livello sceglie Difesa, Duellare, Combattere con Armi Possenti o Protezione. Non può scegliere lo stesso stile più di una volta.',
  ],
  PaladinFeatureIds.spellcasting: [
    'Incantesimi',
    'Il Paladino prepara e lancia incantesimi divini usando il Carisma.',
    'Dal 2° livello prepara un numero di incantesimi pari al proprio modificatore di Carisma più metà del livello da Paladino arrotondata per difetto, con un minimo di uno. Utilizza un simbolo sacro come focus da incantatore.',
  ],
  PaladinFeatureIds.divineSmite: [
    'Punizione Divina',
    'Il Paladino può consumare uno slot per infliggere danni radiosi aggiuntivi.',
    'Dal 2° livello, quando colpisce una creatura con un attacco con arma da mischia, può spendere uno slot incantesimo per infliggere 2d8 danni radiosi, più 1d8 per ogni livello dello slot oltre il 1° fino a un massimo di 5d8. Il danno aumenta di 1d8 contro non morti e immondi.',
  ],
  PaladinFeatureIds.divineHealth: [
    'Salute Divina',
    'La magia divina rende il Paladino immune alle malattie.',
    'Dal 3° livello il Paladino è immune alle malattie.',
  ],
  PaladinFeatureIds.sacredOath: [
    'Giuramento Sacro',
    'Il Paladino pronuncia il giuramento che definisce la propria vocazione.',
    'Al 3° livello sceglie il Giuramento degli Antichi, il Giuramento di Devozione o il Giuramento di Vendetta. Il giuramento concede incantesimi, opzioni di Incanalare Divinità e privilegi ai livelli 3, 7, 15 e 20.',
  ],
  PaladinFeatureIds.channelDivinity: [
    'Incanalare Divinità',
    'Il Paladino incanala energia divina attraverso le capacità del proprio Giuramento.',
    'Dal 3° livello dispone di un utilizzo di Incanalare Divinità. Le opzioni disponibili dipendono dal Giuramento Sacro scelto. Recupera l’utilizzo al termine di un riposo breve o lungo.',
  ],
  PaladinFeatureIds.abilityScoreImprovement: [
    'Aumento dei Punteggi di Caratteristica',
    'Il Paladino può migliorare le proprie caratteristiche o scegliere un talento.',
    'Ottiene questo privilegio ai livelli 4, 8, 12, 16 e 19, seguendo le regole generali dell’avanzamento.',
  ],
  PaladinFeatureIds.extraAttack: [
    'Attacco Extra',
    'Il Paladino può attaccare due volte con l’azione di Attacco.',
    'Dal 5° livello può attaccare due volte anziché una quando usa l’azione di Attacco nel proprio turno.',
  ],
  PaladinFeatureIds.auraOfProtection: [
    'Aura di Protezione',
    'Il Carisma del Paladino protegge i tiri salvezza propri e degli alleati vicini.',
    'Dal 6° livello, mentre è cosciente, il Paladino e le creature amiche entro 3 metri aggiungono il suo modificatore di Carisma ai tiri salvezza, fino a un bonus minimo di +1. Una creatura può beneficiare di una sola Aura di Protezione alla volta.',
  ],
  PaladinFeatureIds.auraOfCourage: [
    'Aura di Coraggio',
    'Il Paladino e gli alleati vicini non possono essere spaventati.',
    'Dal 10° livello, mentre il Paladino è cosciente, lui e le creature amiche entro 3 metri sono immuni alla condizione spaventato.',
  ],
  PaladinFeatureIds.improvedDivineSmite: [
    'Punizione Divina Migliorata',
    'Ogni colpo in mischia del Paladino infligge danni radiosi aggiuntivi.',
    'Dall’11° livello, ogni volta che il Paladino colpisce una creatura con un’arma da mischia, infligge automaticamente 1d8 danni radiosi aggiuntivi.',
  ],
  PaladinFeatureIds.cleansingTouch: [
    'Tocco Purificatore',
    'Il Paladino può porre fine agli incantesimi che influenzano una creatura.',
    'Dal 14° livello può usare un’azione per toccare sé stesso o una creatura consenziente e terminare un incantesimo attivo sul bersaglio. Può usare il privilegio un numero di volte pari al modificatore di Carisma, con un minimo di uno, recuperando tutti gli utilizzi al termine di un riposo lungo.',
  ],
  PaladinFeatureIds.auraImprovements: [
    'Aure Migliorate',
    'La portata delle aure del Paladino aumenta.',
    'Dal 18° livello il raggio di Aura di Protezione e Aura di Coraggio aumenta da 3 a 9 metri.',
  ],
};

String? _paladinFeatureResourceId(String id) {
  if (id == PaladinFeatureIds.divineSense) {
    return PaladinResourceIds.divineSense;
  }

  if (id == PaladinFeatureIds.layOnHands) {
    return PaladinResourceIds.layOnHands;
  }

  if (id == PaladinFeatureIds.channelDivinity) {
    return PaladinResourceIds.channelDivinity;
  }

  if (id == PaladinFeatureIds.cleansingTouch) {
    return PaladinResourceIds.cleansingTouch;
  }

  return null;
}

List<CharacterChoiceDefinition> _paladinFeatureChoices(String id) {
  if (id != PaladinFeatureIds.fightingStyle) return const [];

  return [
    CharacterChoiceDefinition(
      id: 'paladin_fighting_style',
      label: 'Scegli uno Stile di Combattimento da Paladino',
      type: CharacterChoiceType.other,
      catalogId: CharacterChoiceCatalogIds.fightingStyles,
      options: phbPaladinFightingStyleOptions,
      requireNewAcquisition: true,
    ),
  ];
}

CharacterEffects _paladinFeatureEffects(String id) {
  if (id == PaladinFeatureIds.divineSense) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_divine_sense_detection',
          type: CharacterRuleEffectType.conditional,
          target: 'celestial_fiend_undead_presence_and_type',
          value: 18,
          referenceIds: ['hallow'],
          condition:
              'action_until_end_of_next_turn_within_meters_without_total_cover_detects_consecrated_or_desecrated_places',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.layOnHands) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_lay_on_hands_healing',
          type: CharacterRuleEffectType.resource,
          target: PaladinResourceIds.layOnHands,
          condition:
              'action_touch_restore_hit_points_or_spend_five_per_disease_or_poison_no_effect_on_constructs_or_undead',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.spellcasting) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_prepared_spellcasting',
          type: CharacterRuleEffectType.spellcasting,
          target: 'paladin_spellcasting',
          condition:
              'charisma_prepared_half_class_level_rounded_down_holy_symbol_focus',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.divineSmite) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_divine_smite_radiant_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'melee_weapon_hit_radiant_damage',
          condition:
              'expend_spell_slot_2d8_plus_1d8_per_slot_level_above_first_maximum_5d8_plus_1d8_against_undead_or_fiend',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.divineHealth) {
    return const CharacterEffects(
      conditionImmunities: {'disease'},
    );
  }

  if (id == PaladinFeatureIds.channelDivinity) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_channel_divinity_resource',
          type: CharacterRuleEffectType.resource,
          target: PaladinResourceIds.channelDivinity,
          condition: 'options_granted_by_selected_sacred_oath',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.extraAttack) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_extra_attack',
          type: CharacterRuleEffectType.conditional,
          target: 'attacks_per_attack_action',
          value: 2,
          condition: 'paladin_uses_attack_action',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.auraOfProtection) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_aura_of_protection_saving_throws',
          type: CharacterRuleEffectType.conditional,
          target: 'saving_throws_self_and_friendly_creatures',
          referenceIds: [PaladinProgressionIds.auraRadiusMeters],
          condition:
              'paladin_conscious_within_aura_add_charisma_modifier_minimum_one_non_stacking',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.auraOfCourage) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_aura_of_courage_frightened_immunity',
          type: CharacterRuleEffectType.conditional,
          target: 'frightened_immunity_self_and_friendly_creatures',
          referenceIds: [PaladinProgressionIds.auraRadiusMeters],
          condition: 'paladin_conscious_within_aura',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.improvedDivineSmite) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_improved_divine_smite_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'melee_weapon_hit_radiant_damage',
          condition: 'automatic_1d8_radiant_damage_on_every_melee_weapon_hit',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.cleansingTouch) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_cleansing_touch_end_spell',
          type: CharacterRuleEffectType.conditional,
          target: 'active_spell_on_self_or_willing_creature',
          condition: 'action_touch_expend_cleansing_touch_use',
        ),
      ],
    );
  }

  if (id == PaladinFeatureIds.auraImprovements) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_aura_radius_improvement',
          type: CharacterRuleEffectType.conditional,
          target: PaladinProgressionIds.auraRadiusMeters,
          value: 9,
          condition: 'paladin_level_at_least_eighteen',
        ),
      ],
    );
  }

  return const CharacterEffects();
}

CharacterClassFeatureDefinition _paladinFeature(
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
        source: _phbPaladinSource,
        ownerId: ClassIds.paladin,
      ),
      resourceId: _paladinFeatureResourceId(id),
      choices: _paladinFeatureChoices(id),
      effects: _paladinFeatureEffects(id),
      ruleTags: {
        'class_feature',
        'paladin',
        if (id == PaladinFeatureIds.fightingStyle) 'fighting_style',
        if (id == PaladinFeatureIds.spellcasting) ...{
          'spellcasting',
          'half_caster',
          'prepared_spells',
          'divine_magic',
        },
        if (id == PaladinFeatureIds.divineSmite ||
            id == PaladinFeatureIds.improvedDivineSmite) ...{
          'radiant_damage',
          'melee_weapon',
          'smite',
        },
        if (id == PaladinFeatureIds.sacredOath) 'subclass_selection',
        if (id == PaladinFeatureIds.channelDivinity) 'channel_divinity',
        if (id == PaladinFeatureIds.auraOfProtection ||
            id == PaladinFeatureIds.auraOfCourage ||
            id == PaladinFeatureIds.auraImprovements)
          'aura',
      },
    );

final paladinFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _paladinFeatureSpecs.entries)
    entry.key: _paladinFeature(entry.key, entry.value),
};

class PaladinAncientsFeatureIds {
  static const naturesWrath = 'natures_wrath';
  static const turnTheFaithless = 'turn_the_faithless';
  static const auraOfWarding = 'aura_of_warding';
  static const undyingSentinel = 'undying_sentinel';
  static const elderChampion = 'elder_champion';
}

class PaladinDevotionFeatureIds {
  static const sacredWeapon = 'sacred_weapon';
  static const turnTheUnholy = 'turn_the_unholy';
  static const auraOfDevotion = 'aura_of_devotion';
  static const purityOfSpirit = 'purity_of_spirit';
  static const holyNimbus = 'holy_nimbus';
}

class PaladinVengeanceFeatureIds {
  static const abjureEnemy = 'abjure_enemy';
  static const vowOfEnmity = 'vow_of_enmity';
  static const relentlessAvenger = 'relentless_avenger';
  static const soulOfVengeance = 'soul_of_vengeance';
  static const avengingAngel = 'avenging_angel';
}

class PaladinOathResourceIds {
  static const undyingSentinel = 'undying_sentinel';
  static const elderChampion = 'elder_champion';
  static const holyNimbus = 'holy_nimbus';
  static const avengingAngel = 'avenging_angel';
}

const _phbPaladinAncientsSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 99-100',
);

const _phbPaladinDevotionSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'p. 99',
);

const _phbPaladinVengeanceSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 100-101',
);

CharacterClassFeatureDefinition _paladinOathFeature({
  required String oathId,
  required RuleSource source,
  required String id,
  required String name,
  required String summary,
  required String details,
  String? resourceId,
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
        source: source,
        ownerId: oathId,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'paladin',
        'sacred_oath',
        oathId,
        ...ruleTags,
      },
    );

final paladinAncientsFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  PaladinAncientsFeatureIds.naturesWrath: _paladinOathFeature(
    oathId: PaladinSubclassIds.ancients,
    source: _phbPaladinAncientsSource,
    id: PaladinAncientsFeatureIds.naturesWrath,
    name: 'Collera della Natura',
    summary:
        'Il Paladino evoca rampicanti spettrali per trattenere un avversario.',
    details:
        'Al 3° livello può usare un’azione e Incanalare Divinità contro una creatura visibile entro 3 metri. Il bersaglio sceglie se effettuare un tiro salvezza di Forza o Destrezza; se fallisce è trattenuto. Ripete il tiro salvezza alla fine di ogni proprio turno, liberandosi in caso di successo.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_ancients_natures_wrath_restrained',
          type: CharacterRuleEffectType.conditional,
          target: 'visible_creature_restrained_by_spectral_vines',
          value: 3,
          condition:
              'action_expend_channel_divinity_strength_or_dexterity_save_repeat_at_end_of_each_turn',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'action',
      'range_3_meters',
      'strength_or_dexterity_save',
      'restrained',
    },
  ),
  PaladinAncientsFeatureIds.turnTheFaithless: _paladinOathFeature(
    oathId: PaladinSubclassIds.ancients,
    source: _phbPaladinAncientsSource,
    id: PaladinAncientsFeatureIds.turnTheFaithless,
    name: 'Scacciare gli Infedeli',
    summary: 'Il Paladino respinge temporaneamente folletti e immondi.',
    details:
        'Al 3° livello può usare un’azione, il proprio simbolo sacro e Incanalare Divinità. Ogni folletto o immondo entro 9 metri che possa sentirlo effettua un tiro salvezza di Saggezza. Se fallisce è scacciato per 1 minuto o finché non subisce danni: deve tentare di allontanarsi il più possibile, non può avvicinarsi volontariamente entro 9 metri e non può effettuare reazioni. Può usare come azione soltanto Scatto o tentare di liberarsi da un effetto che gli impedisce di muoversi; se non può muoversi può usare Schivata. Se la sua vera forma è celata da un’illusione, una forma mutata o un effetto analogo, viene rivelata quando la creatura è scacciata.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_ancients_turn_the_faithless',
          type: CharacterRuleEffectType.conditional,
          target: 'fey_and_fiends_turned',
          value: 9,
          condition:
              'action_expend_channel_divinity_can_hear_paladin_wisdom_save_one_minute_or_until_damaged_forced_retreat_no_reactions_dash_escape_or_dodge_only_reveal_true_form',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'action',
      'range_9_meters',
      'wisdom_save',
      'fey',
      'fiend',
      'turned',
    },
  ),
  PaladinAncientsFeatureIds.auraOfWarding: _paladinOathFeature(
    oathId: PaladinSubclassIds.ancients,
    source: _phbPaladinAncientsSource,
    id: PaladinAncientsFeatureIds.auraOfWarding,
    name: 'Aura di Interdizione',
    summary:
        'Il Paladino e gli alleati vicini resistono ai danni degli incantesimi.',
    details:
        'Dal 7° livello, mentre il Paladino è cosciente, lui e le creature amiche entro 3 metri possiedono resistenza ai danni inflitti dagli incantesimi. Dal 18° livello il raggio aumenta a 9 metri.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_ancients_aura_of_warding',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_damage_resistance_self_and_friendly_creatures',
          referenceIds: [PaladinProgressionIds.auraRadiusMeters],
          condition: 'paladin_conscious_within_aura',
        ),
      ],
    ),
    ruleTags: {
      'aura',
      'spell_damage_resistance',
      'paladin_conscious',
    },
  ),
  PaladinAncientsFeatureIds.undyingSentinel: _paladinOathFeature(
    oathId: PaladinSubclassIds.ancients,
    source: _phbPaladinAncientsSource,
    id: PaladinAncientsFeatureIds.undyingSentinel,
    name: 'Sentinella Imperitura',
    summary:
        'Il Paladino può sopravvivere a un colpo mortale e non subisce gli svantaggi della vecchiaia.',
    details:
        'Dal 15° livello, quando viene ridotto a 0 punti ferita senza essere ucciso sul colpo, può scendere invece a 1 punto ferita. Recupera questa capacità dopo un riposo lungo. Inoltre non subisce gli svantaggi della vecchiaia e non può essere invecchiato magicamente.',
    resourceId: PaladinOathResourceIds.undyingSentinel,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_ancients_undying_sentinel_survival',
          type: CharacterRuleEffectType.conditional,
          target: 'reduced_to_zero_hit_points',
          value: 1,
          condition:
              'not_killed_outright_expend_undying_sentinel_use_drop_to_one_hit_point',
        ),
        CharacterRuleEffect(
          id: 'paladin_ancients_undying_sentinel_aging',
          type: CharacterRuleEffectType.conditional,
          target: 'aging_effects',
          condition: 'no_drawbacks_from_old_age_and_cannot_be_magically_aged',
        ),
      ],
    ),
    ruleTags: {
      'survival',
      'one_hit_point',
      'long_rest',
      'aging_immunity',
    },
  ),
  PaladinAncientsFeatureIds.elderChampion: _paladinOathFeature(
    oathId: PaladinSubclassIds.ancients,
    source: _phbPaladinAncientsSource,
    id: PaladinAncientsFeatureIds.elderChampion,
    name: 'Campione degli Antichi',
    summary:
        'Il Paladino assume per un minuto l’aspetto di una forza primordiale.',
    details:
        'Al 20° livello può usare un’azione per trasformarsi per 1 minuto. All’inizio di ogni proprio turno recupera 10 punti ferita; può lanciare come azione bonus gli incantesimi da Paladino che normalmente richiedono un’azione; i nemici entro 3 metri subiscono svantaggio ai tiri salvezza contro i suoi incantesimi da Paladino e le sue opzioni di Incanalare Divinità. Recupera l’utilizzo dopo un riposo lungo.',
    resourceId: PaladinOathResourceIds.elderChampion,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_ancients_elder_champion_activation',
          type: CharacterRuleEffectType.resource,
          target: PaladinOathResourceIds.elderChampion,
          condition: 'action_duration_one_minute',
        ),
        CharacterRuleEffect(
          id: 'paladin_ancients_elder_champion_regeneration',
          type: CharacterRuleEffectType.conditional,
          target: 'hit_point_recovery_at_start_of_turn',
          value: 10,
          condition: 'elder_champion_active',
        ),
        CharacterRuleEffect(
          id: 'paladin_ancients_elder_champion_spell_action',
          type: CharacterRuleEffectType.spellcasting,
          target: 'paladin_spell_casting_time',
          condition:
              'elder_champion_active_action_spell_can_be_cast_as_bonus_action',
        ),
        CharacterRuleEffect(
          id: 'paladin_ancients_elder_champion_save_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target:
              'enemy_saving_throws_against_paladin_spells_and_channel_divinity',
          value: 3,
          condition: 'elder_champion_active_enemy_within_meters',
        ),
      ],
    ),
    ruleTags: {
      'action',
      'transformation',
      'duration_1_minute',
      'healing_10',
      'bonus_action_spell',
      'saving_throw_disadvantage',
      'range_3_meters',
      'long_rest',
    },
  ),
};

final paladinAncientsDefinition = CharacterSubclassDefinition(
  id: PaladinSubclassIds.ancients,
  name: 'Giuramento degli Antichi',
  classId: ClassIds.paladin,
  content: const RuleContent(
    id: PaladinSubclassIds.ancients,
    name: 'Giuramento degli Antichi',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Giuramento consacrato alla vita, alla luce, alla speranza e alla bellezza del mondo.',
      details:
          'I Paladini degli Antichi proteggono la luce e la vita del mondo. I loro dettami sono Alimenta la Luce, tramite misericordia e perdono; Proteggi la Luce, opponendosi a ciò che distrugge bontà, bellezza e vita; Preserva la Tua Luce, coltivando gioia, arte e speranza; e Sii la Luce, diventando un esempio di coraggio per chi vive nella disperazione.',
    ),
    source: _phbPaladinAncientsSource,
    ownerId: ClassIds.paladin,
  ),
  featuresByLevel: const {
    3: [
      PaladinAncientsFeatureIds.naturesWrath,
      PaladinAncientsFeatureIds.turnTheFaithless,
    ],
    7: [PaladinAncientsFeatureIds.auraOfWarding],
    15: [PaladinAncientsFeatureIds.undyingSentinel],
    20: [PaladinAncientsFeatureIds.elderChampion],
  },
  featureDefinitions: paladinAncientsFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    3: {
      'ensnaring_strike',
      'speak_with_animals',
    },
    5: {
      'moonbeam',
      'misty_step',
    },
    9: {
      'plant_growth',
      'protection_from_energy',
    },
    13: {
      'ice_storm',
      'stoneskin',
    },
    17: {
      'commune_with_nature',
      'tree_stride',
    },
  },
  resources: const [
    ClassResourceDefinition(
      id: PaladinOathResourceIds.undyingSentinel,
      name: 'Sentinella Imperitura',
      minimumLevel: 15,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        15: 1,
      },
    ),
    ClassResourceDefinition(
      id: PaladinOathResourceIds.elderChampion,
      name: 'Campione degli Antichi',
      minimumLevel: 20,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        20: 1,
      },
    ),
  ],
);

final paladinDevotionFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  PaladinDevotionFeatureIds.sacredWeapon: _paladinOathFeature(
    oathId: PaladinSubclassIds.devotion,
    source: _phbPaladinDevotionSource,
    id: PaladinDevotionFeatureIds.sacredWeapon,
    name: 'Arma Consacrata',
    summary: 'Il Paladino infonde energia positiva in un’arma impugnata.',
    details:
        'Al 3° livello può usare un’azione e Incanalare Divinità per consacrare un’arma impugnata per 1 minuto. Aggiunge il modificatore di Carisma ai tiri per colpire effettuati con essa, con un bonus minimo di +1. L’arma emette luce intensa entro 6 metri e luce fioca per altri 6 metri e, se non è già magica, diventa magica per la durata. Il Paladino può terminare l’effetto nel proprio turno come parte di un’altra azione; l’effetto termina anche se non impugna o trasporta più l’arma oppure se cade privo di sensi.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_devotion_sacred_weapon_attack_bonus',
          type: CharacterRuleEffectType.attackBonus,
          target: 'selected_held_weapon_attack_rolls',
          condition:
              'action_expend_channel_divinity_duration_one_minute_add_charisma_modifier_minimum_one',
        ),
        CharacterRuleEffect(
          id: 'paladin_devotion_sacred_weapon_light',
          type: CharacterRuleEffectType.conditional,
          target: 'selected_held_weapon_light',
          value: 6,
          condition:
              'bright_light_meters_and_dim_light_same_additional_distance_weapon_becomes_magical_ends_if_not_held_or_carried_or_paladin_unconscious',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'action',
      'duration_1_minute',
      'charisma_attack_bonus',
      'minimum_bonus_1',
      'magical_weapon',
      'bright_light_6_meters',
    },
  ),
  PaladinDevotionFeatureIds.turnTheUnholy: _paladinOathFeature(
    oathId: PaladinSubclassIds.devotion,
    source: _phbPaladinDevotionSource,
    id: PaladinDevotionFeatureIds.turnTheUnholy,
    name: 'Scacciare i Sacrileghi',
    summary: 'Il Paladino respinge temporaneamente immondi e non morti.',
    details:
        'Al 3° livello può usare un’azione, il proprio simbolo sacro e Incanalare Divinità. Ogni immondo o non morto entro 9 metri che possa vederlo o sentirlo effettua un tiro salvezza di Saggezza. Se fallisce è scacciato per 1 minuto o finché non subisce danni: deve tentare di allontanarsi il più possibile, non può avvicinarsi volontariamente entro 9 metri e non può effettuare reazioni. Può usare come azione soltanto Scatto o tentare di liberarsi da un effetto che gli impedisce di muoversi; se non può muoversi può usare Schivata.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_devotion_turn_the_unholy',
          type: CharacterRuleEffectType.conditional,
          target: 'fiends_and_undead_turned',
          value: 9,
          condition:
              'action_expend_channel_divinity_can_see_or_hear_paladin_wisdom_save_one_minute_or_until_damaged_forced_retreat_no_reactions_dash_escape_or_dodge_only',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'action',
      'range_9_meters',
      'wisdom_save',
      'fiend',
      'undead',
      'turned',
    },
  ),
  PaladinDevotionFeatureIds.auraOfDevotion: _paladinOathFeature(
    oathId: PaladinSubclassIds.devotion,
    source: _phbPaladinDevotionSource,
    id: PaladinDevotionFeatureIds.auraOfDevotion,
    name: 'Aura di Devozione',
    summary: 'Il Paladino e gli alleati vicini non possono essere affascinati.',
    details:
        'Dal 7° livello, mentre il Paladino è cosciente, lui e le creature amiche entro 3 metri sono immuni alla condizione affascinato. Dal 18° livello il raggio aumenta a 9 metri.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_devotion_charmed_immunity',
          type: CharacterRuleEffectType.conditional,
          target: 'charmed_immunity_self_and_friendly_creatures',
          referenceIds: [PaladinProgressionIds.auraRadiusMeters],
          condition: 'paladin_conscious_within_aura',
        ),
      ],
    ),
    ruleTags: {
      'aura',
      'charmed_immunity',
      'paladin_conscious',
    },
  ),
  PaladinDevotionFeatureIds.purityOfSpirit: _paladinOathFeature(
    oathId: PaladinSubclassIds.devotion,
    source: _phbPaladinDevotionSource,
    id: PaladinDevotionFeatureIds.purityOfSpirit,
    name: 'Purezza di Spirito',
    summary:
        'Il Paladino è costantemente protetto contro determinate creature sovrannaturali.',
    details:
        'Dal 15° livello il Paladino è sempre sotto gli effetti dell’incantesimo Protezione dal Bene e dal Male.',
    spellIds: const {
      'protection_from_evil_and_good',
    },
    effects: const CharacterEffects(
      grantedSpellIds: [
        'protection_from_evil_and_good',
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_devotion_permanent_protection_from_evil_and_good',
          type: CharacterRuleEffectType.spellcasting,
          target: 'protection_from_evil_and_good',
          condition: 'always_active_without_concentration_or_spell_slot',
        ),
      ],
    ),
    ruleTags: {
      'always_active_spell',
      'protection_from_evil_and_good',
    },
  ),
  PaladinDevotionFeatureIds.holyNimbus: _paladinOathFeature(
    oathId: PaladinSubclassIds.devotion,
    source: _phbPaladinDevotionSource,
    id: PaladinDevotionFeatureIds.holyNimbus,
    name: 'Nube Sacra',
    summary: 'Il Paladino emana un’aura di luce solare che danneggia i nemici.',
    details:
        'Al 20° livello può usare un’azione per emanare per 1 minuto luce intensa entro 9 metri e luce fioca per altri 9 metri. Un nemico che inizia il turno nella luce intensa subisce 10 danni radiosi. Per la durata il Paladino dispone inoltre di vantaggio ai tiri salvezza contro gli incantesimi lanciati da immondi o non morti. Recupera l’utilizzo dopo un riposo lungo.',
    resourceId: PaladinOathResourceIds.holyNimbus,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_devotion_holy_nimbus_activation',
          type: CharacterRuleEffectType.resource,
          target: PaladinOathResourceIds.holyNimbus,
          condition: 'action_duration_one_minute',
        ),
        CharacterRuleEffect(
          id: 'paladin_devotion_holy_nimbus_radiant_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'enemy_start_of_turn_radiant_damage',
          value: 10,
          condition: 'holy_nimbus_active_enemy_within_9_meters',
        ),
        CharacterRuleEffect(
          id: 'paladin_devotion_holy_nimbus_saving_throws',
          type: CharacterRuleEffectType.advantage,
          target: 'saving_throws_against_spells',
          condition: 'holy_nimbus_active_spell_cast_by_fiend_or_undead',
        ),
      ],
    ),
    ruleTags: {
      'action',
      'duration_1_minute',
      'sunlight',
      'range_9_meters',
      'radiant_damage_10',
      'saving_throw_advantage',
      'long_rest',
    },
  ),
};

final paladinDevotionDefinition = CharacterSubclassDefinition(
  id: PaladinSubclassIds.devotion,
  name: 'Giuramento di Devozione',
  classId: ClassIds.paladin,
  content: const RuleContent(
    id: PaladinSubclassIds.devotion,
    name: 'Giuramento di Devozione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Giuramento dedicato agli ideali di giustizia, virtù, onore e ordine.',
      details:
          'I Paladini della Devozione perseguono i più alti ideali di giustizia, virtù e ordine. I loro dettami sono Onestà, mantenendo la parola data; Coraggio, agendo senza cedere alla paura; Compassione, aiutando e proteggendo gli altri con saggezza; Onore, offrendo un esempio virtuoso; e Dovere, assumendosi la responsabilità delle proprie azioni e proteggendo chi è affidato alle loro cure.',
    ),
    source: _phbPaladinDevotionSource,
    ownerId: ClassIds.paladin,
  ),
  featuresByLevel: const {
    3: [
      PaladinDevotionFeatureIds.sacredWeapon,
      PaladinDevotionFeatureIds.turnTheUnholy,
    ],
    7: [PaladinDevotionFeatureIds.auraOfDevotion],
    15: [PaladinDevotionFeatureIds.purityOfSpirit],
    20: [PaladinDevotionFeatureIds.holyNimbus],
  },
  featureDefinitions: paladinDevotionFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    3: {
      'protection_from_evil_and_good',
      'sanctuary',
    },
    5: {
      'lesser_restoration',
      'zone_of_truth',
    },
    9: {
      'beacon_of_hope',
      'dispel_magic',
    },
    13: {
      'freedom_of_movement',
      'guardian_of_faith',
    },
    17: {
      'commune',
      'flame_strike',
    },
  },
  resources: const [
    ClassResourceDefinition(
      id: PaladinOathResourceIds.holyNimbus,
      name: 'Nube Sacra',
      minimumLevel: 20,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        20: 1,
      },
    ),
  ],
);

final paladinVengeanceFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  PaladinVengeanceFeatureIds.abjureEnemy: _paladinOathFeature(
    oathId: PaladinSubclassIds.vengeance,
    source: _phbPaladinVengeanceSource,
    id: PaladinVengeanceFeatureIds.abjureEnemy,
    name: 'Abiurare Nemico',
    summary:
        'Il Paladino denuncia un avversario e ne spezza temporaneamente la capacità di fuggire.',
    details:
        'Al 3° livello può usare un’azione, il proprio simbolo sacro e Incanalare Divinità contro una creatura visibile entro 18 metri. Il bersaglio effettua un tiro salvezza di Saggezza, salvo che sia immune alla condizione spaventato; immondi e non morti subiscono svantaggio al tiro. Se fallisce, è spaventato per 1 minuto o finché non subisce danni, la sua velocità diventa 0 e non può beneficiare di bonus alla velocità. Se supera il tiro, la sua velocità è dimezzata per la stessa durata.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_vengeance_abjure_enemy_failed_save',
          type: CharacterRuleEffectType.conditional,
          target: 'visible_creature_frightened_speed_zero',
          value: 18,
          condition:
              'action_expend_channel_divinity_wisdom_save_fiend_or_undead_disadvantage_unless_frightened_immune_failure_one_minute_or_until_damaged_no_speed_bonuses',
        ),
        CharacterRuleEffect(
          id: 'paladin_vengeance_abjure_enemy_successful_save',
          type: CharacterRuleEffectType.movement,
          target: 'visible_creature_speed_multiplier',
          value: 0.5,
          condition: 'successful_wisdom_save_one_minute_or_until_damaged',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'action',
      'range_18_meters',
      'wisdom_save',
      'frightened',
      'speed_reduction',
    },
  ),
  PaladinVengeanceFeatureIds.vowOfEnmity: _paladinOathFeature(
    oathId: PaladinSubclassIds.vengeance,
    source: _phbPaladinVengeanceSource,
    id: PaladinVengeanceFeatureIds.vowOfEnmity,
    name: 'Giuramento di Inimicizia',
    summary: 'Il Paladino concentra la propria vendetta su un singolo nemico.',
    details:
        'Al 3° livello può usare un’azione bonus e Incanalare Divinità per formulare un giuramento contro una creatura visibile entro 3 metri. Dispone di vantaggio ai tiri per colpire contro quel bersaglio per 1 minuto, finché il bersaglio non scende a 0 punti ferita o finché non cade privo di sensi.',
    resourceId: PaladinResourceIds.channelDivinity,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_vengeance_vow_of_enmity_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'attack_rolls_against_vow_of_enmity_target',
          value: 3,
          condition:
              'bonus_action_expend_channel_divinity_visible_creature_one_minute_or_until_zero_hit_points_or_unconscious',
        ),
      ],
    ),
    ruleTags: {
      'channel_divinity',
      'bonus_action',
      'range_3_meters',
      'attack_advantage',
      'duration_1_minute',
    },
  ),
  PaladinVengeanceFeatureIds.relentlessAvenger: _paladinOathFeature(
    oathId: PaladinSubclassIds.vengeance,
    source: _phbPaladinVengeanceSource,
    id: PaladinVengeanceFeatureIds.relentlessAvenger,
    name: 'Vendicatore Implacabile',
    summary:
        'Il Paladino può inseguire un nemico colpito mentre tenta di allontanarsi.',
    details:
        'Dal 7° livello, quando colpisce una creatura con un attacco di opportunità, può muoversi immediatamente fino a metà della propria velocità come parte della stessa reazione. Questo movimento non provoca attacchi di opportunità.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_vengeance_relentless_avenger_movement',
          type: CharacterRuleEffectType.movement,
          target: 'movement_after_opportunity_attack_hit',
          value: 0.5,
          condition:
              'immediately_as_part_of_same_reaction_without_provoking_opportunity_attacks',
        ),
      ],
    ),
    ruleTags: {
      'opportunity_attack',
      'reaction',
      'movement',
      'half_speed',
    },
  ),
  PaladinVengeanceFeatureIds.soulOfVengeance: _paladinOathFeature(
    oathId: PaladinSubclassIds.vengeance,
    source: _phbPaladinVengeanceSource,
    id: PaladinVengeanceFeatureIds.soulOfVengeance,
    name: 'Anima di Vendetta',
    summary:
        'Il Paladino può contrattaccare il bersaglio del proprio Giuramento di Inimicizia.',
    details:
        'Dal 15° livello, quando una creatura soggetta al suo Giuramento di Inimicizia effettua un attacco, il Paladino può usare la propria reazione per effettuare contro di essa un attacco con un’arma da mischia, purché la creatura sia entro portata.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_vengeance_soul_of_vengeance_reaction_attack',
          type: CharacterRuleEffectType.reaction,
          target: 'melee_weapon_attack_against_vow_of_enmity_target',
          condition: 'target_makes_attack_and_is_within_melee_weapon_reach',
        ),
      ],
    ),
    ruleTags: {
      'reaction',
      'melee_weapon_attack',
      'vow_of_enmity',
    },
  ),
  PaladinVengeanceFeatureIds.avengingAngel: _paladinOathFeature(
    oathId: PaladinSubclassIds.vengeance,
    source: _phbPaladinVengeanceSource,
    id: PaladinVengeanceFeatureIds.avengingAngel,
    name: 'Angelo Vendicatore',
    summary: 'Il Paladino assume la forma di un vendicatore angelico alato.',
    details:
        'Al 20° livello può usare un’azione per trasformarsi per 1 ora. Ottiene una velocità di volare di 18 metri ed emana un’aura minacciosa entro 9 metri. La prima volta che una creatura nemica entra nell’aura o vi inizia il turno durante una battaglia, deve superare un tiro salvezza di Saggezza oppure è spaventata dal Paladino per 1 minuto o finché non subisce danni. I tiri per colpire contro la creatura spaventata dispongono di vantaggio. Recupera l’utilizzo al termine di un riposo lungo.',
    resourceId: PaladinOathResourceIds.avengingAngel,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'paladin_vengeance_avenging_angel_activation',
          type: CharacterRuleEffectType.resource,
          target: PaladinOathResourceIds.avengingAngel,
          condition: 'action_duration_one_hour',
        ),
        CharacterRuleEffect(
          id: 'paladin_vengeance_avenging_angel_flight',
          type: CharacterRuleEffectType.movement,
          target: 'flying_speed_meters',
          value: 18,
          condition: 'avenging_angel_active',
        ),
        CharacterRuleEffect(
          id: 'paladin_vengeance_avenging_angel_fear_aura',
          type: CharacterRuleEffectType.conditional,
          target: 'enemy_creature_frightened_by_paladin',
          value: 9,
          condition:
              'first_entry_or_start_turn_in_aura_during_battle_wisdom_save_failure_one_minute_or_until_damaged',
        ),
        CharacterRuleEffect(
          id: 'paladin_vengeance_avenging_angel_attack_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'attack_rolls_against_creature_frightened_by_paladin',
          condition: 'avenging_angel_fear_aura_active',
        ),
      ],
    ),
    ruleTags: {
      'action',
      'transformation',
      'duration_1_hour',
      'flying_speed_18_meters',
      'aura',
      'range_9_meters',
      'frightened',
      'wisdom_save',
      'long_rest',
    },
  ),
};

final paladinVengeanceDefinition = CharacterSubclassDefinition(
  id: PaladinSubclassIds.vengeance,
  name: 'Giuramento di Vendetta',
  classId: ClassIds.paladin,
  content: const RuleContent(
    id: PaladinSubclassIds.vengeance,
    name: 'Giuramento di Vendetta',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un Giuramento che impone di punire chi ha commesso le colpe più gravi.',
      details:
          'I Paladini della Vendetta perseguono i malfattori con determinazione assoluta. I loro dettami sono Combattere il Male Peggiore, affrontando sempre la minaccia più grave; Nessuna Pietà per i Malvagi, riservando la misericordia ai nemici ordinari; Costi Quel Che Costi, senza lasciarsi sfuggire l’occasione di fermare i propri nemici; e Risarcimento, aiutando le vittime delle atrocità che non sono riusciti a impedire.',
    ),
    source: _phbPaladinVengeanceSource,
    ownerId: ClassIds.paladin,
  ),
  featuresByLevel: const {
    3: [
      PaladinVengeanceFeatureIds.abjureEnemy,
      PaladinVengeanceFeatureIds.vowOfEnmity,
    ],
    7: [PaladinVengeanceFeatureIds.relentlessAvenger],
    15: [PaladinVengeanceFeatureIds.soulOfVengeance],
    20: [PaladinVengeanceFeatureIds.avengingAngel],
  },
  featureDefinitions: paladinVengeanceFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    3: {
      'bane',
      'hunters_mark',
    },
    5: {
      'hold_person',
      'misty_step',
    },
    9: {
      'haste',
      'protection_from_energy',
    },
    13: {
      'banishment',
      'dimension_door',
    },
    17: {
      'hold_monster',
      'scrying',
    },
  },
  resources: const [
    ClassResourceDefinition(
      id: PaladinOathResourceIds.avengingAngel,
      name: 'Angelo Vendicatore',
      minimumLevel: 20,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        20: 1,
      },
    ),
  ],
);

final paladinClassDefinition = CharacterClassDefinition(
  id: ClassIds.paladin,
  name: 'Paladino',
  content: const RuleContent(
    id: ClassIds.paladin,
    name: 'Paladino',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un guerriero sacro legato a un giuramento, capace di combattere, guarire e incanalare magia divina.',
      details:
          'Il Paladino unisce addestramento marziale, incantesimi preparati, energia curativa, punizioni radiose e aure protettive. Al 3° livello pronuncia il Giuramento Sacro che definisce la propria vocazione.',
    ),
    source: _phbPaladinSource,
    ownerId: ClassIds.paladin,
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
      'SAG',
      'CAR',
    },
    skillOptions: {
      'athletics',
      'insight',
      'intimidation',
      'medicine',
      'persuasion',
      'religion',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'paladin_skills',
        label: 'Scegli due abilità da Paladino',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'athletics',
          'insight',
          'intimidation',
          'medicine',
          'persuasion',
          'religion',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'paladin_martial_loadout',
      label: 'Scegli la dotazione marziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'paladin_martial_weapon_and_shield',
          label: 'Un’Arma da Guerra e uno Scudo',
          grants: const [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.shield,
            ),
          ],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'paladin_martial_weapon_with_shield',
              label: 'Scegli un’Arma da Guerra',
              catalogId: 'weapon',
              optionIds: _paladinMartialWeaponIds,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'paladin_two_martial_weapons',
          label: 'Due Armi da Guerra',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'paladin_two_martial_weapon_selection',
              label: 'Scegli due Armi da Guerra',
              catalogId: 'weapon',
              optionIds: _paladinMartialWeaponIds,
              selections: 2,
              allowDuplicates: true,
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'paladin_secondary_weapon',
      label: 'Scegli la dotazione secondaria',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'paladin_five_javelins',
          label: 'Cinque Giavellotti',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'javelin',
              quantity: 5,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'paladin_simple_melee_weapon',
          label: 'Un’Arma Semplice da Mischia',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'paladin_simple_melee_weapon_selection',
              label: 'Scegli un’Arma Semplice da Mischia',
              catalogId: 'weapon',
              optionIds: _paladinSimpleMeleeWeaponIds,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'paladin_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'paladin_priest_pack',
          label: 'Dotazione da Sacerdote',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.priest,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'paladin_explorer_pack',
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
    ClassEquipmentChoice(
      id: 'paladin_holy_symbol',
      label: 'Scegli il Simbolo Sacro',
      alternatives: paladinHolySymbolAlternatives,
    ),
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'armor',
      itemId: ArmorIds.chainMail,
    ),
  ],
  featuresByLevel: const {
    1: [
      PaladinFeatureIds.divineSense,
      PaladinFeatureIds.layOnHands,
    ],
    2: [
      PaladinFeatureIds.fightingStyle,
      PaladinFeatureIds.spellcasting,
      PaladinFeatureIds.divineSmite,
    ],
    3: [
      PaladinFeatureIds.divineHealth,
      PaladinFeatureIds.sacredOath,
      PaladinFeatureIds.channelDivinity,
    ],
    4: [PaladinFeatureIds.abilityScoreImprovement],
    5: [PaladinFeatureIds.extraAttack],
    6: [PaladinFeatureIds.auraOfProtection],
    8: [PaladinFeatureIds.abilityScoreImprovement],
    10: [PaladinFeatureIds.auraOfCourage],
    11: [PaladinFeatureIds.improvedDivineSmite],
    12: [PaladinFeatureIds.abilityScoreImprovement],
    14: [PaladinFeatureIds.cleansingTouch],
    16: [PaladinFeatureIds.abilityScoreImprovement],
    18: [PaladinFeatureIds.auraImprovements],
    19: [PaladinFeatureIds.abilityScoreImprovement],
  },
  featureDefinitions: paladinFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: PaladinResourceIds.divineSense,
      name: 'Percezione del Divino',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'CAR',
      baseMaximum: 1,
      minimumMaximum: 1,
    ),
    ClassResourceDefinition(
      id: PaladinResourceIds.layOnHands,
      name: 'Imposizione delle Mani',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      classLevelMultiplier: 5,
    ),
    ClassResourceDefinition(
      id: PaladinResourceIds.channelDivinity,
      name: 'Incanalare Divinità',
      minimumLevel: 3,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        3: 1,
      },
    ),
    ClassResourceDefinition(
      id: PaladinResourceIds.cleansingTouch,
      name: 'Tocco Purificatore',
      minimumLevel: 14,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'CAR',
      minimumMaximum: 1,
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: PaladinProgressionIds.auraRadiusMeters,
      name: 'Raggio delle Aure in Metri',
      valuesByLevel: {
        6: '3',
        18: '9',
      },
    ),
  ],
  spellcasting: const ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.half,
    ability: 'CAR',
    minimumLevel: 2,
    ritualCasting: false,
    preparesSpells: true,
    spellIds: phbPaladinSpellIds,
    preparedSpellLevelDivisor: 2,
    minimumPreparedSpells: 1,
    slotsByClassLevel: {
      2: [2],
      3: [3],
      4: [3],
      5: [4, 2],
      6: [4, 2],
      7: [4, 3],
      8: [4, 3],
      9: [4, 3, 2],
      10: [4, 3, 2],
      11: [4, 3, 3],
      12: [4, 3, 3],
      13: [4, 3, 3, 1],
      14: [4, 3, 3, 1],
      15: [4, 3, 3, 2],
      16: [4, 3, 3, 2],
      17: [4, 3, 3, 3, 1],
      18: [4, 3, 3, 3, 1],
      19: [4, 3, 3, 3, 2],
      20: [4, 3, 3, 3, 2],
    },
  ),
  subclassSelectionLevel: 3,
  subclasses: {
    PaladinSubclassIds.ancients: paladinAncientsDefinition,
    PaladinSubclassIds.devotion: paladinDevotionDefinition,
    PaladinSubclassIds.vengeance: paladinVengeanceDefinition,
  },
);
