import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'equipment_data.dart';
import 'equipment_pack_data.dart';
import 'focus_data.dart';
import 'spell_data.dart';

const _phbWizardSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 81-84',
);

class WizardSubclassIds {
  static const abjuration = 'school_of_abjuration';
  static const conjuration = 'school_of_conjuration';
  static const divination = 'school_of_divination';
  static const enchantment = 'school_of_enchantment';
  static const evocation = 'school_of_evocation';
  static const illusion = 'school_of_illusion';
  static const necromancy = 'school_of_necromancy';
  static const transmutation = 'school_of_transmutation';
}

class WizardFeatureIds {
  static const spellcasting = 'wizard_spellcasting';
  static const arcaneRecovery = 'arcane_recovery';
  static const arcaneTradition = 'arcane_tradition';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const spellMastery = 'spell_mastery';
  static const signatureSpells = 'signature_spells';
}

class WizardResourceIds {
  static const arcaneRecovery = 'arcane_recovery';
  static const signatureSpells = 'signature_spells';
}

class WizardChoiceIds {
  static const initialCantrips = 'wizard_initial_cantrips';
  static const initialSpellbook = 'wizard_initial_spellbook';
  static const spellMasteryFirstLevel = 'wizard_spell_mastery_first_level';
  static const spellMasterySecondLevel = 'wizard_spell_mastery_second_level';
  static const signatureSpells = 'wizard_signature_spells';
}

final wizardClassSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.wizard))
    .map((spell) => spell.id)
    .toSet();

CharacterChoiceDefinition _wizardSpellChoice({
  required String id,
  required String label,
  required int spellLevel,
  int selections = 1,
  bool existing = false,
  CharacterChoiceType type = CharacterChoiceType.spell,
}) =>
    CharacterChoiceDefinition(
      id: id,
      label: label,
      type: type,
      catalogId: CharacterChoiceCatalogIds.spells,
      minimumSelections: selections,
      maximumSelections: selections,
      requireNewAcquisition: !existing,
      requireExistingAcquisition: existing,
      constraints: [
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.classId,
          values: [ClassIds.wizard],
        ),
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.spellLevel,
          values: ['$spellLevel'],
        ),
      ],
    );

final wizardInitialSpellChoices = [
  _wizardSpellChoice(
    id: WizardChoiceIds.initialCantrips,
    label: 'Scegli tre trucchetti da Mago',
    spellLevel: 0,
    selections: 3,
    type: CharacterChoiceType.cantrip,
  ),
  _wizardSpellChoice(
    id: WizardChoiceIds.initialSpellbook,
    label: 'Scegli sei incantesimi da Mago di 1° livello per il libro',
    spellLevel: 1,
    selections: 6,
  ),
];

const _wizardFeatureSpecs = <String, List<String>>{
  WizardFeatureIds.spellcasting: [
    'Incantesimi',
    'Il Mago usa Intelligenza e prepara gli incantesimi contenuti nel proprio libro.',
    'Al 1° livello conosce tre trucchetti e possiede un libro con sei incantesimi da Mago di 1° livello. Prepara dal libro un numero di incantesimi pari al livello da Mago più il modificatore di Intelligenza, con un minimo di uno, e recupera tutti gli slot dopo un riposo lungo. Può cambiare la lista preparata dopo un riposo lungo studiando almeno 1 minuto per livello di ogni incantesimo. Può celebrare come rituale un incantesimo da Mago con il descrittore rituale presente nel libro anche se non è preparato e può usare un focus arcano. Intelligenza determina la CD, pari a 8 + bonus di competenza + modificatore di Intelligenza, e il modificatore di attacco. A ogni nuovo livello da Mago aggiunge gratuitamente al libro due incantesimi di un livello che può lanciare.',
  ],
  WizardFeatureIds.arcaneRecovery: [
    'Recupero Arcano',
    'Il Mago recupera parte della propria energia studiando il libro.',
    'Una volta al giorno, dopo un riposo breve, recupera slot il cui livello combinato non supera metà del livello da Mago arrotondata per eccesso. Non può recuperare slot di 6° livello o superiore.',
  ],
  WizardFeatureIds.arcaneTradition: [
    'Tradizione Arcana',
    'Il Mago sceglie una delle otto scuole di magia.',
    'Al 2° livello sceglie una Tradizione Arcana, che concede ulteriori privilegi ai livelli 2, 6, 10 e 14.',
  ],
  WizardFeatureIds.abilityScoreImprovement: [
    'Aumento dei Punteggi di Caratteristica',
    'Il Mago migliora le proprie caratteristiche o sceglie un talento.',
    'Ottiene questo privilegio ai livelli 4, 8, 12, 16 e 19.',
  ],
  WizardFeatureIds.spellMastery: [
    'Maestria negli Incantesimi',
    'Il Mago può lanciare a volontà due incantesimi preparati di basso livello.',
    'Al 18° livello sceglie un incantesimo da Mago di 1° livello e uno di 2° livello presenti nel libro. Quando li ha preparati può lanciarli al loro livello più basso senza spendere slot. Per lanciarli a un livello superiore deve spendere normalmente uno slot. Dopo otto ore di studio può sostituire uno o entrambi con incantesimi diversi degli stessi livelli.',
  ],
  WizardFeatureIds.signatureSpells: [
    'Incantesimi Personali',
    'Due incantesimi di 3° livello diventano sempre preparati e più facili da lanciare.',
    'Al 20° livello sceglie due incantesimi da Mago di 3° livello presenti nel libro. Sono sempre preparati, non contano nel limite degli incantesimi preparati e ciascuno può essere lanciato una volta al 3° livello senza spendere slot. Recupera entrambi gli utilizzi dopo un riposo breve o lungo. Per lanciarli a un livello superiore deve spendere normalmente uno slot.',
  ],
};

List<CharacterChoiceDefinition> _wizardFeatureChoices(String id) {
  if (id == WizardFeatureIds.spellcasting) {
    return wizardInitialSpellChoices;
  }

  if (id == WizardFeatureIds.spellMastery) {
    return [
      _wizardSpellChoice(
        id: WizardChoiceIds.spellMasteryFirstLevel,
        label: 'Scegli un incantesimo da Mago di 1° livello nel libro',
        spellLevel: 1,
        existing: true,
      ),
      _wizardSpellChoice(
        id: WizardChoiceIds.spellMasterySecondLevel,
        label: 'Scegli un incantesimo da Mago di 2° livello nel libro',
        spellLevel: 2,
        existing: true,
      ),
    ];
  }

  if (id == WizardFeatureIds.signatureSpells) {
    return [
      _wizardSpellChoice(
        id: WizardChoiceIds.signatureSpells,
        label: 'Scegli due incantesimi da Mago di 3° livello nel libro',
        spellLevel: 3,
        selections: 2,
        existing: true,
      ),
    ];
  }

  return const [];
}

String? _wizardFeatureResourceId(String id) {
  if (id == WizardFeatureIds.arcaneRecovery) {
    return WizardResourceIds.arcaneRecovery;
  }

  if (id == WizardFeatureIds.signatureSpells) {
    return WizardResourceIds.signatureSpells;
  }

  return null;
}

CharacterEffects _wizardFeatureEffects(String id) {
  if (id == WizardFeatureIds.spellcasting) {
    return CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'wizard_full_spellcasting',
          type: CharacterRuleEffectType.spellcasting,
          target: 'wizard_spellcasting',
          referenceIds: wizardClassSpellIds.toList(growable: false),
          condition: 'intelligence_full_caster_prepared_from_spellbook',
        ),
        const CharacterRuleEffect(
          id: 'wizard_ritual_casting_from_spellbook',
          type: CharacterRuleEffectType.conditional,
          target: 'wizard_ritual_casting',
          condition: 'ritual_spell_in_spellbook_need_not_be_prepared',
        ),
      ],
    );
  }

  if (id == WizardFeatureIds.arcaneRecovery) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'wizard_arcane_recovery_slots',
          type: CharacterRuleEffectType.resource,
          target: 'expended_spell_slots',
          condition:
              'after_short_rest_combined_levels_ceiling_half_wizard_level_maximum_slot_level_five',
        ),
      ],
    );
  }

  if (id == WizardFeatureIds.spellMastery) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'wizard_spell_mastery_free_casting',
          type: CharacterRuleEffectType.conditional,
          target: 'spell_mastery_selected_spells',
          value: 8,
          condition:
              'cast_at_lowest_level_without_slot_when_prepared_change_after_eight_hours',
        ),
      ],
    );
  }

  if (id == WizardFeatureIds.signatureSpells) {
    return const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'wizard_signature_spells_always_prepared',
          type: CharacterRuleEffectType.conditional,
          target: 'signature_spells_preparation',
          value: 2,
          condition: 'always_prepared_and_not_counted_against_limit',
        ),
        CharacterRuleEffect(
          id: 'wizard_signature_spells_free_casts',
          type: CharacterRuleEffectType.resource,
          target: 'signature_spell_free_casts',
          value: 2,
          condition: 'each_selected_spell_once_per_short_or_long_rest',
        ),
      ],
    );
  }

  return const CharacterEffects();
}

CharacterClassFeatureDefinition _wizardFeature(
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
        source: _phbWizardSource,
        ownerId: ClassIds.wizard,
      ),
      resourceId: _wizardFeatureResourceId(id),
      choices: _wizardFeatureChoices(id),
      effects: _wizardFeatureEffects(id),
      ruleTags: {
        'class_feature',
        'wizard',
        if (id == WizardFeatureIds.spellcasting) ...{
          'spellcasting',
          'full_caster',
          'spellbook',
          'ritual_casting',
        },
        if (id == WizardFeatureIds.arcaneRecovery) 'spell_slot_recovery',
        if (id == WizardFeatureIds.arcaneTradition) 'subclass_selection',
        if (id == WizardFeatureIds.spellMastery) 'at_will_spell',
        if (id == WizardFeatureIds.signatureSpells) 'always_prepared',
      },
    );

final wizardFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _wizardFeatureSpecs.entries)
    entry.key: _wizardFeature(entry.key, entry.value),
};

final wizardArcaneFocusAlternatives = <ClassEquipmentAlternative>[
  const ClassEquipmentAlternative(
    id: 'wizard_component_pouch',
    label: 'Borsa dei Componenti',
    grants: [
      ClassEquipmentGrant(
        catalogId: 'focus',
        itemId: FocusIds.componentPouch,
      ),
    ],
  ),
  for (final focus in focusDefinitions.values)
    if (focus.category == FocusCategory.arcane)
      ClassEquipmentAlternative(
        id: 'wizard_arcane_focus_${focus.id}',
        label: focus.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'focus',
            itemId: focus.id,
          ),
        ],
      ),
];

class WizardAbjurationFeatureIds {
  static const savant = 'abjuration_savant';
  static const arcaneWard = 'arcane_ward';
  static const projectedWard = 'projected_ward';
  static const improvedAbjuration = 'improved_abjuration';
  static const spellResistance = 'spell_resistance';
}

class WizardConjurationFeatureIds {
  static const savant = 'conjuration_savant';
  static const minorConjuration = 'minor_conjuration';
  static const benignTransposition = 'benign_transposition';
  static const focusedConjuration = 'focused_conjuration';
  static const durableSummons = 'durable_summons';
}

const _phbWizardAbjurationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 84-85',
);

const _phbWizardConjurationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 86',
);

CharacterClassFeatureDefinition _wizardSchoolFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  required String schoolId,
  required RuleSource source,
  String? resourceId,
  List<CharacterChoiceDefinition> choices = const [],
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
        ownerId: ClassIds.wizard,
      ),
      resourceId: resourceId,
      choices: choices,
      spellIds: spellIds,
      effects: effects,
      ruleTags: {
        'wizard',
        'arcane_tradition',
        'subclass_feature',
        schoolId,
        ...ruleTags,
      },
    );

final wizardAbjurationFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardAbjurationFeatureIds.savant: _wizardSchoolFeature(
    id: WizardAbjurationFeatureIds.savant,
    name: 'Abiuratore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Abiurazione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Abiurazione sono dimezzati.',
    schoolId: 'abjuration',
    source: _phbWizardAbjurationSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardAbjurationFeatureIds.arcaneWard: _wizardSchoolFeature(
    id: WizardAbjurationFeatureIds.arcaneWard,
    name: 'Interdizione Arcana',
    summary:
        'Gli incantesimi di Abiurazione alimentano un’interdizione che assorbe i danni.',
    details:
        'Dal 2° livello, quando il Mago lancia un incantesimo di Abiurazione di 1° livello o superiore può creare un’interdizione con punti ferita pari al doppio del livello da Mago più il modificatore di Intelligenza. L’interdizione subisce i danni al posto del Mago e recupera punti ferita pari al doppio del livello di ogni successivo incantesimo di Abiurazione lanciato. Una nuova interdizione può essere creata dopo un riposo lungo.',
    schoolId: 'abjuration',
    source: _phbWizardAbjurationSource,
    resourceId: WizardAbjurationFeatureIds.arcaneWard,
    ruleTags: {
      'arcane_ward',
      'damage_absorption',
      'recharged_by_abjuration_spell',
      'first_level_spell_or_higher',
    },
  ),
  WizardAbjurationFeatureIds.projectedWard: _wizardSchoolFeature(
    id: WizardAbjurationFeatureIds.projectedWard,
    name: 'Interdizione Proiettata',
    summary:
        'L’Interdizione Arcana può assorbire i danni destinati a una creatura vicina.',
    details:
        'Dal 6° livello, quando una creatura visibile entro 9 metri subisce danni, il Mago può usare la propria reazione per fare in modo che l’Interdizione Arcana assorba quei danni. I danni eccedenti colpiscono la creatura protetta.',
    schoolId: 'abjuration',
    source: _phbWizardAbjurationSource,
    resourceId: WizardAbjurationFeatureIds.arcaneWard,
    ruleTags: {
      'reaction',
      'range_9_meters',
      'protect_ally',
      'arcane_ward',
    },
  ),
  WizardAbjurationFeatureIds.improvedAbjuration: _wizardSchoolFeature(
    id: WizardAbjurationFeatureIds.improvedAbjuration,
    name: 'Abiurazione Migliorata',
    summary:
        'Il bonus di competenza si applica alle prove di caratteristica di Abiurazione.',
    details:
        'Dal 10° livello, quando il Mago effettua una prova di caratteristica come parte di Controincantesimo o Dissolvi Magie, aggiunge il proprio bonus di competenza alla prova.',
    schoolId: 'abjuration',
    source: _phbWizardAbjurationSource,
    ruleTags: {
      'ability_check',
      'proficiency_bonus',
      'counterspell',
      'dispel_magic',
    },
  ),
  WizardAbjurationFeatureIds.spellResistance: _wizardSchoolFeature(
    id: WizardAbjurationFeatureIds.spellResistance,
    name: 'Resistenza agli Incantesimi',
    summary:
        'Il Mago è resistente ai danni degli incantesimi e dispone di vantaggio ai relativi tiri salvezza.',
    details:
        'Dal 14° livello, il Mago dispone di vantaggio ai tiri salvezza contro gli incantesimi e di resistenza ai danni inflitti dagli incantesimi.',
    schoolId: 'abjuration',
    source: _phbWizardAbjurationSource,
    ruleTags: {
      'advantage_saving_throws_against_spells',
      'resistance_to_spell_damage',
    },
  ),
};

final wizardAbjurationDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.abjuration,
  name: 'Scuola di Abiurazione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.abjuration,
    name: 'Scuola di Abiurazione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione dedicata alle protezioni, alle interdizioni e alla negazione della magia.',
      details:
          'Gli abiuratori proteggono sé stessi e i propri alleati, dissolvono gli effetti magici e contrastano gli incantesimi ostili.',
    ),
    source: _phbWizardAbjurationSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardAbjurationFeatureIds.savant,
      WizardAbjurationFeatureIds.arcaneWard,
    ],
    6: [WizardAbjurationFeatureIds.projectedWard],
    10: [WizardAbjurationFeatureIds.improvedAbjuration],
    14: [WizardAbjurationFeatureIds.spellResistance],
  },
  featureDefinitions: wizardAbjurationFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardAbjurationFeatureIds.arcaneWard,
      name: 'Interdizione Arcana',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      classLevelMultiplier: 2,
      additionalMaximumAbility: 'INT',
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardAbjurationFeatureIds.savant,
      schoolId: 'abjuration',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

final wizardConjurationFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardConjurationFeatureIds.savant: _wizardSchoolFeature(
    id: WizardConjurationFeatureIds.savant,
    name: 'Evocatore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Evocazione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Evocazione sono dimezzati.',
    schoolId: 'conjuration',
    source: _phbWizardConjurationSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardConjurationFeatureIds.minorConjuration: _wizardSchoolFeature(
    id: WizardConjurationFeatureIds.minorConjuration,
    name: 'Evocazione Minore',
    summary:
        'Il Mago evoca temporaneamente un piccolo oggetto non magico già osservato.',
    details:
        'Dal 2° livello, il Mago può usare un’azione per evocare nella propria mano o in uno spazio libero visibile entro 3 metri un oggetto inanimato non magico già visto. L’oggetto non può essere più lungo di 90 centimetri né pesare più di 5 kg, appare palesemente magico ed emana luce fioca entro 1,5 metri. Scompare dopo un’ora, quando il privilegio viene usato nuovamente oppure quando subisce qualsiasi danno.',
    schoolId: 'conjuration',
    source: _phbWizardConjurationSource,
    ruleTags: {
      'action',
      'range_3_meters',
      'temporary_object',
      'maximum_weight_5_kg',
      'duration_1_hour',
    },
  ),
  WizardConjurationFeatureIds.benignTransposition: _wizardSchoolFeature(
    id: WizardConjurationFeatureIds.benignTransposition,
    name: 'Trasposizione Benevola',
    summary:
        'Il Mago si teletrasporta o scambia il proprio posto con una creatura consenziente.',
    details:
        'Dal 6° livello, il Mago può usare un’azione per teletrasportarsi fino a 9 metri in uno spazio libero visibile, oppure scambiare il proprio posto con una creatura consenziente Piccola o Media entro la stessa distanza. Il privilegio si recupera dopo un riposo lungo o dopo avere lanciato un incantesimo di Evocazione di 1° livello o superiore.',
    schoolId: 'conjuration',
    source: _phbWizardConjurationSource,
    resourceId: WizardConjurationFeatureIds.benignTransposition,
    ruleTags: {
      'action',
      'teleport',
      'range_9_meters',
      'swap_with_willing_creature',
      'recharged_by_conjuration_spell',
    },
  ),
  WizardConjurationFeatureIds.focusedConjuration: _wizardSchoolFeature(
    id: WizardConjurationFeatureIds.focusedConjuration,
    name: 'Evocazione Focalizzata',
    summary:
        'I danni non interrompono la concentrazione sugli incantesimi di Evocazione.',
    details:
        'Dal 10° livello, mentre il Mago si concentra su un incantesimo di Evocazione, i danni subiti non possono interrompere la sua concentrazione.',
    schoolId: 'conjuration',
    source: _phbWizardConjurationSource,
    ruleTags: {
      'concentration',
      'concentration_not_broken_by_damage',
    },
  ),
  WizardConjurationFeatureIds.durableSummons: _wizardSchoolFeature(
    id: WizardConjurationFeatureIds.durableSummons,
    name: 'Evocazioni Perduranti',
    summary:
        'Le creature evocate o create dagli incantesimi ottengono punti ferita temporanei.',
    details:
        'Dal 14° livello, ogni creatura evocata o creata dal Mago tramite un incantesimo di Evocazione possiede 30 punti ferita temporanei.',
    schoolId: 'conjuration',
    source: _phbWizardConjurationSource,
    ruleTags: {
      'summoned_creatures',
      'created_creatures',
      'temporary_hit_points_30',
    },
  ),
};

final wizardConjurationDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.conjuration,
  name: 'Scuola di Evocazione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.conjuration,
    name: 'Scuola di Evocazione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che trasporta creature e oggetti da un luogo all’altro.',
      details:
          'Gli evocatori fanno apparire oggetti, attraversano lo spazio istantaneamente e richiamano creature al proprio servizio.',
    ),
    source: _phbWizardConjurationSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardConjurationFeatureIds.savant,
      WizardConjurationFeatureIds.minorConjuration,
    ],
    6: [WizardConjurationFeatureIds.benignTransposition],
    10: [WizardConjurationFeatureIds.focusedConjuration],
    14: [WizardConjurationFeatureIds.durableSummons],
  },
  featureDefinitions: wizardConjurationFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardConjurationFeatureIds.benignTransposition,
      name: 'Trasposizione Benevola',
      minimumLevel: 6,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {6: 1},
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardConjurationFeatureIds.savant,
      schoolId: 'conjuration',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

class WizardDivinationFeatureIds {
  static const savant = 'divination_savant';
  static const portent = 'portent';
  static const expertDivination = 'expert_divination';
  static const thirdEye = 'the_third_eye';
  static const greaterPortent = 'greater_portent';
}

class WizardEnchantmentFeatureIds {
  static const savant = 'enchantment_savant';
  static const hypnoticGaze = 'hypnotic_gaze';
  static const instinctiveCharm = 'instinctive_charm';
  static const splitEnchantment = 'split_enchantment';
  static const alterMemories = 'alter_memories';
}

const _phbWizardDivinationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 85-86',
);

const _phbWizardEnchantmentSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 85',
);

final wizardDivinationFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardDivinationFeatureIds.savant: _wizardSchoolFeature(
    id: WizardDivinationFeatureIds.savant,
    name: 'Divinatore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Divinazione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Divinazione sono dimezzati.',
    schoolId: 'divination',
    source: _phbWizardDivinationSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardDivinationFeatureIds.portent: _wizardSchoolFeature(
    id: WizardDivinationFeatureIds.portent,
    name: 'Portento',
    summary:
        'Dopo un riposo lungo il Mago registra due risultati di d20 da sostituire a futuri tiri.',
    details:
        'Dal 2° livello, dopo ogni riposo lungo il Mago tira due d20 e ne registra i risultati. Prima che venga effettuato un tiro per colpire, un tiro salvezza o una prova di caratteristica da lui o da una creatura visibile, può sostituire quel tiro con uno dei risultati registrati. Può sostituire un solo tiro per turno e ogni risultato può essere usato una sola volta.',
    schoolId: 'divination',
    source: _phbWizardDivinationSource,
    resourceId: WizardDivinationFeatureIds.portent,
    ruleTags: {
      'd20',
      'replace_roll',
      'before_roll',
      'once_per_turn',
      'attack_roll',
      'saving_throw',
      'ability_check',
    },
  ),
  WizardDivinationFeatureIds.expertDivination: _wizardSchoolFeature(
    id: WizardDivinationFeatureIds.expertDivination,
    name: 'Divinazione Esperta',
    summary:
        'Lanciare una Divinazione di livello elevato permette di recuperare uno slot inferiore.',
    details:
        'Dal 6° livello, quando il Mago lancia un incantesimo di Divinazione di 2° livello o superiore usando uno slot, recupera uno slot già speso. Lo slot recuperato deve essere di livello inferiore a quello usato e non può essere superiore al 5° livello.',
    schoolId: 'divination',
    source: _phbWizardDivinationSource,
    ruleTags: {
      'spell_slot_recovery',
      'trigger_divination_spell',
      'second_level_spell_or_higher',
      'lower_slot_than_cast',
      'maximum_recovered_slot_level_5',
    },
  ),
  WizardDivinationFeatureIds.thirdEye: _wizardSchoolFeature(
    id: WizardDivinationFeatureIds.thirdEye,
    name: 'Terzo Occhio',
    summary:
        'Il Mago ottiene temporaneamente una tra quattro percezioni soprannaturali.',
    details:
        'Dal 10° livello, il Mago può usare un’azione per ottenere una capacità fino a quando non diventa incapacitato o completa un riposo: scurovisione entro 18 metri, vista sul Piano Etereo entro 18 metri, capacità di leggere qualsiasi linguaggio oppure capacità di vedere creature e oggetti invisibili entro 3 metri. Il privilegio si recupera dopo un riposo breve o lungo.',
    schoolId: 'divination',
    source: _phbWizardDivinationSource,
    resourceId: WizardDivinationFeatureIds.thirdEye,
    ruleTags: {
      'action',
      'choose_one',
      'darkvision_18_meters',
      'ethereal_sight_18_meters',
      'read_any_language',
      'see_invisibility_3_meters',
    },
  ),
  WizardDivinationFeatureIds.greaterPortent: _wizardSchoolFeature(
    id: WizardDivinationFeatureIds.greaterPortent,
    name: 'Portento Superiore',
    summary: 'Il Mago registra tre risultati di Portento anziché due.',
    details:
        'Dal 14° livello, quando utilizza Portento il Mago tira tre d20 anziché due dopo ogni riposo lungo.',
    schoolId: 'divination',
    source: _phbWizardDivinationSource,
    resourceId: WizardDivinationFeatureIds.portent,
    ruleTags: {
      'd20',
      'portent_rolls_3',
      'long_rest',
    },
  ),
};

final wizardDivinationDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.divination,
  name: 'Scuola di Divinazione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.divination,
    name: 'Scuola di Divinazione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che interpreta passato, presente e possibili futuri.',
      details:
          'I divinatori raccolgono informazioni nascoste, anticipano gli eventi e manipolano gli esiti grazie alle proprie visioni.',
    ),
    source: _phbWizardDivinationSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardDivinationFeatureIds.savant,
      WizardDivinationFeatureIds.portent,
    ],
    6: [WizardDivinationFeatureIds.expertDivination],
    10: [WizardDivinationFeatureIds.thirdEye],
    14: [WizardDivinationFeatureIds.greaterPortent],
  },
  featureDefinitions: wizardDivinationFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardDivinationFeatureIds.portent,
      name: 'Portento',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        2: 2,
        14: 3,
      },
    ),
    ClassResourceDefinition(
      id: WizardDivinationFeatureIds.thirdEye,
      name: 'Terzo Occhio',
      minimumLevel: 10,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {10: 1},
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardDivinationFeatureIds.savant,
      schoolId: 'divination',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

final wizardEnchantmentFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardEnchantmentFeatureIds.savant: _wizardSchoolFeature(
    id: WizardEnchantmentFeatureIds.savant,
    name: 'Ammaliatore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Ammaliamento richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Ammaliamento sono dimezzati.',
    schoolId: 'enchantment',
    source: _phbWizardEnchantmentSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardEnchantmentFeatureIds.hypnoticGaze: _wizardSchoolFeature(
    id: WizardEnchantmentFeatureIds.hypnoticGaze,
    name: 'Sguardo Ipnotico',
    summary:
        'Lo sguardo del Mago può affascinare e rendere incapace una creatura vicina.',
    details:
        'Dal 2° livello, il Mago può usare un’azione contro una creatura entro 1,5 metri che sia in grado di vederlo e sentirlo. Se fallisce un tiro salvezza su Saggezza, la creatura è affascinata, incapacitata, visibilmente frastornata e ha velocità zero fino alla fine del turno successivo del Mago. Il Mago può mantenere l’effetto usando la propria azione a ogni turno. L’effetto termina se il Mago si allontana oltre 1,5 metri, se la creatura non può più vederlo o sentirlo oppure se subisce danni. Dopo la fine dell’effetto o un tiro salvezza iniziale riuscito, il privilegio non può essere usato nuovamente sulla stessa creatura fino al successivo riposo lungo.',
    schoolId: 'enchantment',
    source: _phbWizardEnchantmentSource,
    ruleTags: {
      'action',
      'range_1_5_meters',
      'wisdom_saving_throw',
      'charmed',
      'incapacitated',
      'speed_zero',
      'per_target_long_rest_immunity',
    },
  ),
  WizardEnchantmentFeatureIds.instinctiveCharm: _wizardSchoolFeature(
    id: WizardEnchantmentFeatureIds.instinctiveCharm,
    name: 'Fascino Istintivo',
    summary: 'Il Mago può deviare un attacco verso un’altra creatura vicina.',
    details:
        'Dal 6° livello, quando una creatura visibile entro 9 metri effettua un tiro per colpire contro il Mago, egli può usare la propria reazione, purché un’altra creatura si trovi entro la gittata dell’attacco. Deve decidere prima di sapere se l’attacco colpirà. Se l’attaccante fallisce un tiro salvezza su Saggezza, deve bersagliare la creatura più vicina diversa dal Mago e da sé stesso; a parità di distanza sceglie l’attaccante. Dopo un tiro salvezza riuscito, il privilegio non può essere usato nuovamente contro quella creatura fino al successivo riposo lungo. Le creature immuni alla condizione affascinato sono immuni a questo effetto.',
    schoolId: 'enchantment',
    source: _phbWizardEnchantmentSource,
    ruleTags: {
      'reaction',
      'range_9_meters',
      'wisdom_saving_throw',
      'redirect_attack',
      'per_target_long_rest_immunity',
    },
  ),
  WizardEnchantmentFeatureIds.splitEnchantment: _wizardSchoolFeature(
    id: WizardEnchantmentFeatureIds.splitEnchantment,
    name: 'Ammaliamento Condiviso',
    summary:
        'Un Ammaliamento a bersaglio singolo può influenzare una seconda creatura.',
    details:
        'Dal 10° livello, quando il Mago lancia un incantesimo di Ammaliamento di 1° livello o superiore che bersaglia una sola creatura, può scegliere come bersaglio una seconda creatura.',
    schoolId: 'enchantment',
    source: _phbWizardEnchantmentSource,
    ruleTags: {
      'first_level_spell_or_higher',
      'single_target_spell',
      'additional_target',
    },
  ),
  WizardEnchantmentFeatureIds.alterMemories: _wizardSchoolFeature(
    id: WizardEnchantmentFeatureIds.alterMemories,
    name: 'Alterare Ricordi',
    summary:
        'Le creature affascinate possono ignorare l’influenza magica e dimenticare il tempo trascorso.',
    details:
        'Dal 14° livello, quando il Mago affascina una o più creature con un incantesimo, può fare in modo che una di esse resti inconsapevole di essere stata affascinata. Prima che l’incantesimo termini può usare una volta la propria azione per imporle un tiro salvezza su Intelligenza contro la CD degli incantesimi. Se fallisce, dimentica un numero di ore pari a 1 più il modificatore di Carisma del Mago, fino a un minimo di un’ora. Il Mago può scegliere un periodo inferiore, ma non superiore alla durata dell’incantesimo di ammaliamento.',
    schoolId: 'enchantment',
    source: _phbWizardEnchantmentSource,
    ruleTags: {
      'charmed_target_unaware',
      'intelligence_saving_throw',
      'erase_memories',
      'minimum_1_hour',
    },
  ),
};

final wizardEnchantmentDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.enchantment,
  name: 'Scuola di Ammaliamento',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.enchantment,
    name: 'Scuola di Ammaliamento',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che influenza emozioni, decisioni e percezioni delle creature.',
      details:
          'Gli ammaliatori placano, dominano o confondono gli avversari manipolandone magicamente la mente.',
    ),
    source: _phbWizardEnchantmentSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardEnchantmentFeatureIds.savant,
      WizardEnchantmentFeatureIds.hypnoticGaze,
    ],
    6: [WizardEnchantmentFeatureIds.instinctiveCharm],
    10: [WizardEnchantmentFeatureIds.splitEnchantment],
    14: [WizardEnchantmentFeatureIds.alterMemories],
  },
  featureDefinitions: wizardEnchantmentFeatureDefinitions,
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardEnchantmentFeatureIds.savant,
      schoolId: 'enchantment',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

class WizardEvocationFeatureIds {
  static const savant = 'evocation_savant';
  static const sculptSpells = 'sculpt_spells';
  static const potentCantrip = 'potent_cantrip';
  static const empoweredEvocation = 'empowered_evocation';
  static const overchannel = 'overchannel';
}

class WizardIllusionFeatureIds {
  static const savant = 'illusion_savant';
  static const improvedMinorIllusion = 'improved_minor_illusion';
  static const malleableIllusions = 'malleable_illusions';
  static const illusorySelf = 'illusory_self';
  static const illusoryReality = 'illusory_reality';
}

class WizardIllusionChoiceIds {
  static const improvedMinorIllusionCantrip = 'improved_minor_illusion_cantrip';
}

const _phbWizardEvocationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 87',
);

const _phbWizardIllusionSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 86-87',
);

CharacterChoiceDefinition _improvedMinorIllusionCantripChoice() {
  final template = wizardFeatureDefinitions[WizardFeatureIds.spellcasting]!
      .choices
      .singleWhere(
        (choice) => choice.id == WizardChoiceIds.initialCantrips,
      );

  return CharacterChoiceDefinition(
    id: WizardIllusionChoiceIds.improvedMinorIllusionCantrip,
    label:
        'Ottieni Illusione Minore o, se già conosciuta, un altro trucchetto da Mago',
    type: template.type,
    catalogId: template.catalogId,
    minimumSelections: 1,
    maximumSelections: 1,
    optionIds: template.optionIds,
    options: template.options,
    constraints: template.constraints,
    unique: true,
    requireNewAcquisition: true,
  );
}

final wizardEvocationFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardEvocationFeatureIds.savant: _wizardSchoolFeature(
    id: WizardEvocationFeatureIds.savant,
    name: 'Invocatore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Invocazione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Invocazione sono dimezzati.',
    schoolId: 'evocation',
    source: _phbWizardEvocationSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardEvocationFeatureIds.sculptSpells: _wizardSchoolFeature(
    id: WizardEvocationFeatureIds.sculptSpells,
    name: 'Plasmare Incantesimi',
    summary:
        'Il Mago crea zone sicure per proteggere alcune creature dalle proprie Invocazioni.',
    details:
        'Dal 2° livello, quando il Mago lancia un incantesimo di Invocazione che influenza altre creature visibili, può scegliere un numero di creature pari a uno più il livello dell’incantesimo. Le creature scelte superano automaticamente i loro tiri salvezza contro l’incantesimo e non subiscono danni se normalmente ne subirebbero la metà con un tiro salvezza riuscito.',
    schoolId: 'evocation',
    source: _phbWizardEvocationSource,
    ruleTags: {
      'safe_creatures',
      'one_plus_spell_level_targets',
      'automatic_saving_throw_success',
      'no_damage_on_success',
    },
  ),
  WizardEvocationFeatureIds.potentCantrip: _wizardSchoolFeature(
    id: WizardEvocationFeatureIds.potentCantrip,
    name: 'Trucchetto Potente',
    summary:
        'I trucchetti offensivi infliggono metà danno anche dopo un tiro salvezza riuscito.',
    details:
        'Dal 6° livello, quando una creatura supera un tiro salvezza contro un trucchetto del Mago che infligge danni, subisce comunque metà dei danni del trucchetto ma nessuno dei suoi effetti aggiuntivi.',
    schoolId: 'evocation',
    source: _phbWizardEvocationSource,
    ruleTags: {
      'damaging_cantrip',
      'half_damage_on_successful_save',
      'no_additional_effects_on_success',
    },
  ),
  WizardEvocationFeatureIds.empoweredEvocation: _wizardSchoolFeature(
    id: WizardEvocationFeatureIds.empoweredEvocation,
    name: 'Invocazione Potente',
    summary:
        'Il modificatore di Intelligenza si aggiunge a un tiro per i danni di un’Invocazione.',
    details:
        'Dal 10° livello, il Mago può aggiungere il proprio modificatore di Intelligenza a un tiro per i danni di qualsiasi incantesimo da Mago appartenente alla scuola di Invocazione.',
    schoolId: 'evocation',
    source: _phbWizardEvocationSource,
    ruleTags: {
      'intelligence_modifier',
      'one_damage_roll',
      'wizard_evocation_spell',
    },
  ),
  WizardEvocationFeatureIds.overchannel: _wizardSchoolFeature(
    id: WizardEvocationFeatureIds.overchannel,
    name: 'Saturazione Magica',
    summary:
        'Il Mago può massimizzare i danni di un incantesimo, rischiando danni necrotici con gli usi successivi.',
    details:
        'Dal 14° livello, quando il Mago lancia un incantesimo da Mago dal 1° al 5° livello che infligge danni, può infliggere il massimo danno possibile invece di tirare. Il primo uso dopo un riposo lungo non produce effetti avversi. Ogni uso aggiuntivo prima del riposo lungo infligge immediatamente 2d12 danni necrotici per livello dell’incantesimo; ogni ulteriore uso aumenta di 1d12 per livello questi danni. I danni necrotici ignorano resistenza e immunità.',
    schoolId: 'evocation',
    source: _phbWizardEvocationSource,
    resourceId: WizardEvocationFeatureIds.overchannel,
    ruleTags: {
      'maximum_spell_damage',
      'wizard_spell_levels_1_to_5',
      'first_use_safe',
      'additional_use_2d12_per_spell_level',
      'additional_d12_per_repeated_use',
      'necrotic_damage',
      'ignores_resistance_and_immunity',
    },
  ),
};

final wizardEvocationDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.evocation,
  name: 'Scuola di Invocazione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.evocation,
    name: 'Scuola di Invocazione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che domina energie elementali e forze distruttive.',
      details:
          'Gli invocatori modellano le aree dei propri incantesimi, proteggono gli alleati e sprigionano una potenza magica superiore.',
    ),
    source: _phbWizardEvocationSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardEvocationFeatureIds.savant,
      WizardEvocationFeatureIds.sculptSpells,
    ],
    6: [WizardEvocationFeatureIds.potentCantrip],
    10: [WizardEvocationFeatureIds.empoweredEvocation],
    14: [WizardEvocationFeatureIds.overchannel],
  },
  featureDefinitions: wizardEvocationFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardEvocationFeatureIds.overchannel,
      name: 'Saturazione Magica: uso sicuro',
      minimumLevel: 14,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {14: 1},
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardEvocationFeatureIds.savant,
      schoolId: 'evocation',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

final wizardIllusionFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardIllusionFeatureIds.savant: _wizardSchoolFeature(
    id: WizardIllusionFeatureIds.savant,
    name: 'Illusionista Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Illusione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Illusione sono dimezzati.',
    schoolId: 'illusion',
    source: _phbWizardIllusionSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardIllusionFeatureIds.improvedMinorIllusion: _wizardSchoolFeature(
    id: WizardIllusionFeatureIds.improvedMinorIllusion,
    name: 'Illusione Minore Migliorata',
    summary:
        'Il Mago apprende Illusione Minore e può crearne simultaneamente immagine e suono.',
    details:
        'Dal 2° livello, il Mago apprende il trucchetto Illusione Minore. Se lo conosce già, apprende un altro trucchetto da Mago. Quando lancia Illusione Minore può creare con lo stesso lancio sia un suono sia un’immagine.',
    schoolId: 'illusion',
    source: _phbWizardIllusionSource,
    choices: [_improvedMinorIllusionCantripChoice()],
    ruleTags: {
      'minor_illusion',
      'fallback_wizard_cantrip_if_already_known',
      'sound_and_image',
    },
  ),
  WizardIllusionFeatureIds.malleableIllusions: _wizardSchoolFeature(
    id: WizardIllusionFeatureIds.malleableIllusions,
    name: 'Illusioni Duttili',
    summary: 'Il Mago può modificare un’illusione persistente già lanciata.',
    details:
        'Dal 6° livello, quando il Mago lancia un incantesimo di Illusione con durata di almeno un minuto, può usare un’azione per modificarne la natura entro i normali parametri dell’incantesimo, purché possa vedere l’illusione.',
    schoolId: 'illusion',
    source: _phbWizardIllusionSource,
    ruleTags: {
      'action',
      'illusion_duration_at_least_1_minute',
      'must_see_illusion',
      'modify_existing_illusion',
    },
  ),
  WizardIllusionFeatureIds.illusorySelf: _wizardSchoolFeature(
    id: WizardIllusionFeatureIds.illusorySelf,
    name: 'Sosia Illusorio',
    summary:
        'Un duplicato illusorio fa mancare automaticamente un attacco diretto contro il Mago.',
    details:
        'Dal 10° livello, quando una creatura effettua un tiro per colpire contro il Mago, egli può usare la propria reazione per interporre un duplicato illusorio. L’attacco manca automaticamente e il privilegio si recupera dopo un riposo breve o lungo.',
    schoolId: 'illusion',
    source: _phbWizardIllusionSource,
    resourceId: WizardIllusionFeatureIds.illusorySelf,
    ruleTags: {
      'reaction',
      'attack_automatically_misses',
      'illusory_duplicate',
    },
  ),
  WizardIllusionFeatureIds.illusoryReality: _wizardSchoolFeature(
    id: WizardIllusionFeatureIds.illusoryReality,
    name: 'Realtà Illusoria',
    summary:
        'Una parte inanimata di un’illusione può diventare temporaneamente reale.',
    details:
        'Dal 14° livello, quando il Mago lancia un incantesimo di Illusione di 1° livello o superiore, può rendere reale per un minuto un oggetto inanimato e non magico che faccia parte dell’illusione. Può farlo come azione bonus durante il proprio turno mentre l’incantesimo è attivo. L’oggetto non può infliggere danni né danneggiare direttamente qualcuno.',
    schoolId: 'illusion',
    source: _phbWizardIllusionSource,
    ruleTags: {
      'first_level_spell_or_higher',
      'bonus_action',
      'nonmagical_inanimate_object',
      'duration_1_minute',
      'cannot_deal_damage_or_directly_harm',
    },
  ),
};

final wizardIllusionDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.illusion,
  name: 'Scuola di Illusione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.illusion,
    name: 'Scuola di Illusione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che inganna i sensi e rende credibili immagini impossibili.',
      details:
          'Gli illusionisti creano percezioni false, modificano le proprie illusioni e possono infine conferire loro una temporanea realtà.',
    ),
    source: _phbWizardIllusionSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardIllusionFeatureIds.savant,
      WizardIllusionFeatureIds.improvedMinorIllusion,
    ],
    6: [WizardIllusionFeatureIds.malleableIllusions],
    10: [WizardIllusionFeatureIds.illusorySelf],
    14: [WizardIllusionFeatureIds.illusoryReality],
  },
  featureDefinitions: wizardIllusionFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardIllusionFeatureIds.illusorySelf,
      name: 'Sosia Illusorio',
      minimumLevel: 10,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {10: 1},
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardIllusionFeatureIds.savant,
      schoolId: 'illusion',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

class WizardNecromancyFeatureIds {
  static const savant = 'necromancy_savant';
  static const grimHarvest = 'grim_harvest';
  static const undeadThralls = 'undead_thralls';
  static const inuredToUndeath = 'inured_to_undeath';
  static const commandUndead = 'command_undead';
}

class WizardTransmutationFeatureIds {
  static const savant = 'transmutation_savant';
  static const minorAlchemy = 'minor_alchemy';
  static const transmutersStone = 'transmuters_stone';
  static const shapechanger = 'shapechanger';
  static const masterTransmuter = 'master_transmuter';
}

class WizardTransmutationChoiceIds {
  static const transmutersStoneBenefit = 'transmuters_stone_benefit';
  static const masterTransmuterEffect = 'master_transmuter_effect';
}

const _phbWizardNecromancySource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 87-88',
);

const _phbWizardTransmutationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagina 88',
);

final wizardNecromancyFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardNecromancyFeatureIds.savant: _wizardSchoolFeature(
    id: WizardNecromancyFeatureIds.savant,
    name: 'Necromante Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Necromanzia richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Necromanzia sono dimezzati.',
    schoolId: 'necromancy',
    source: _phbWizardNecromancySource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardNecromancyFeatureIds.grimHarvest: _wizardSchoolFeature(
    id: WizardNecromancyFeatureIds.grimHarvest,
    name: 'Raccolto Macabro',
    summary:
        'Uccidere una creatura con un incantesimo permette al Mago di recuperare punti ferita.',
    details:
        'Dal 2° livello, una volta per turno quando il Mago uccide una o più creature con un incantesimo di 1° livello o superiore, recupera punti ferita pari al doppio del livello dell’incantesimo, oppure al triplo se l’incantesimo appartiene alla scuola di Necromanzia. Il privilegio non funziona contro costrutti e non morti.',
    schoolId: 'necromancy',
    source: _phbWizardNecromancySource,
    ruleTags: {
      'once_per_turn',
      'trigger_creature_killed_by_spell',
      'first_level_spell_or_higher',
      'healing_twice_spell_level',
      'necromancy_healing_three_times_spell_level',
      'excludes_constructs',
      'excludes_undead',
    },
  ),
  WizardNecromancyFeatureIds.undeadThralls: _wizardSchoolFeature(
    id: WizardNecromancyFeatureIds.undeadThralls,
    name: 'Servitori Non Morti',
    summary:
        'Animare Morti viene aggiunto al libro e crea servitori non morti più numerosi e resistenti.',
    details:
        'Dal 6° livello, il Mago aggiunge Animare Morti al libro se non è già presente. Quando lo lancia può animare un cadavere o cumulo d’ossa aggiuntivo. I non morti creati tramite un incantesimo di Necromanzia aumentano i propri punti ferita massimi di un valore pari al livello da Mago e aggiungono il bonus di competenza del Mago ai tiri per i danni delle armi.',
    schoolId: 'necromancy',
    source: _phbWizardNecromancySource,
    spellIds: {'animate_dead'},
    ruleTags: {
      'animate_dead',
      'additional_undead_target',
      'undead_hit_points_plus_wizard_level',
      'weapon_damage_plus_proficiency_bonus',
    },
  ),
  WizardNecromancyFeatureIds.inuredToUndeath: _wizardSchoolFeature(
    id: WizardNecromancyFeatureIds.inuredToUndeath,
    name: 'Impervio alla Non Morte',
    summary:
        'Il Mago resiste ai danni necrotici e il suo massimo di punti ferita non può essere ridotto.',
    details:
        'Dal 10° livello, il Mago possiede resistenza ai danni necrotici e il suo massimo di punti ferita non può essere ridotto.',
    schoolId: 'necromancy',
    source: _phbWizardNecromancySource,
    effects: const CharacterEffects(
      damageResistances: {'necrotic'},
    ),
    ruleTags: {
      'necrotic_resistance',
      'hit_point_maximum_cannot_be_reduced',
    },
  ),
  WizardNecromancyFeatureIds.commandUndead: _wizardSchoolFeature(
    id: WizardNecromancyFeatureIds.commandUndead,
    name: 'Comandare Non Morti',
    summary: 'Il Mago può assoggettare un non morto visibile entro 18 metri.',
    details:
        'Dal 14° livello, il Mago può usare un’azione per scegliere un non morto visibile entro 18 metri. Il bersaglio effettua un tiro salvezza su Carisma contro la CD degli incantesimi. Se lo supera, il Mago non può più utilizzare questo privilegio contro quella creatura; se lo fallisce, diventa amichevole e obbedisce finché il privilegio non viene usato di nuovo. Un non morto con Intelligenza almeno 8 dispone di vantaggio al tiro salvezza; con Intelligenza almeno 12 può ripeterlo alla fine di ogni ora finché non si libera.',
    schoolId: 'necromancy',
    source: _phbWizardNecromancySource,
    ruleTags: {
      'action',
      'undead_target',
      'range_18_meters',
      'charisma_saving_throw',
      'controlled_until_feature_reused',
      'intelligence_8_advantage',
      'intelligence_12_repeat_save_hourly',
    },
  ),
};

final wizardNecromancyDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.necromancy,
  name: 'Scuola di Necromanzia',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.necromancy,
    name: 'Scuola di Necromanzia',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che studia le energie della vita, della morte e della non morte.',
      details:
          'I necromanti sottraggono energia vitale ai nemici, creano servitori non morti e imparano a dominarli.',
    ),
    source: _phbWizardNecromancySource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardNecromancyFeatureIds.savant,
      WizardNecromancyFeatureIds.grimHarvest,
    ],
    6: [WizardNecromancyFeatureIds.undeadThralls],
    10: [WizardNecromancyFeatureIds.inuredToUndeath],
    14: [WizardNecromancyFeatureIds.commandUndead],
  },
  featureDefinitions: wizardNecromancyFeatureDefinitions,
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardNecromancyFeatureIds.savant,
      schoolId: 'necromancy',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

final wizardTransmutationFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WizardTransmutationFeatureIds.savant: _wizardSchoolFeature(
    id: WizardTransmutationFeatureIds.savant,
    name: 'Trasmutatore Sapiente',
    summary:
        'Copiare nel libro un incantesimo di Trasmutazione richiede metà tempo e metà oro.',
    details:
        'Dal 2° livello, l’oro e il tempo necessari per copiare nel libro degli incantesimi un incantesimo appartenente alla scuola di Trasmutazione sono dimezzati.',
    schoolId: 'transmutation',
    source: _phbWizardTransmutationSource,
    ruleTags: {
      'spellbook',
      'spellbook_copy_discount',
      'half_copy_time',
      'half_copy_cost',
    },
  ),
  WizardTransmutationFeatureIds.minorAlchemy: _wizardSchoolFeature(
    id: WizardTransmutationFeatureIds.minorAlchemy,
    name: 'Alchimia Minore',
    summary:
        'Il Mago trasforma temporaneamente un materiale comune in un altro.',
    details:
        'Dal 2° livello, il Mago può trasformare un oggetto non magico composto interamente di legno, pietra non preziosa, ferro, rame o argento in un oggetto fatto di un altro materiale dello stesso elenco. Ogni 10 minuti può trasformare una quantità di materiale pari a un cubo con spigolo di 30 centimetri. La trasformazione dura un’ora o termina quando il Mago perde la concentrazione come se si concentrasse su un incantesimo.',
    schoolId: 'transmutation',
    source: _phbWizardTransmutationSource,
    ruleTags: {
      'wood',
      'stone',
      'iron',
      'copper',
      'silver',
      '10_minutes_per_30_cm_edge_cube',
      'duration_1_hour',
      'concentration',
    },
  ),
  WizardTransmutationFeatureIds.transmutersStone: _wizardSchoolFeature(
    id: WizardTransmutationFeatureIds.transmutersStone,
    name: 'Pietra del Trasmutatore',
    summary: 'Il Mago crea una pietra che conferisce uno tra diversi benefici.',
    details:
        'Dal 6° livello, dopo 8 ore di lavoro il Mago crea una Pietra del Trasmutatore. Chi la possiede ottiene il beneficio scelto: scurovisione entro 18 metri, aumento della velocità di 3 metri finché è privo di ingombro, competenza nei tiri salvezza su Costituzione oppure resistenza ad acido, freddo, fuoco, fulmine o tuono. Quando il Mago lancia un incantesimo di Trasmutazione di 1° livello o superiore può cambiare il beneficio soltanto se porta la pietra con sé. Creare una nuova pietra fa cessare di funzionare la precedente.',
    schoolId: 'transmutation',
    source: _phbWizardTransmutationSource,
    choices: const [
      CharacterChoiceDefinition(
        id: WizardTransmutationChoiceIds.transmutersStoneBenefit,
        label: 'Scegli il beneficio della Pietra del Trasmutatore',
        type: CharacterChoiceType.other,
        minimumSelections: 1,
        maximumSelections: 1,
        optionIds: [
          'darkvision_18_meters',
          'speed_bonus_3_meters',
          'constitution_saving_throw_proficiency',
          'acid_resistance',
          'cold_resistance',
          'fire_resistance',
          'lightning_resistance',
          'thunder_resistance',
        ],
      ),
    ],
    ruleTags: {
      'creation_time_8_hours',
      'single_transmuters_stone',
      'benefit_changes_on_transmutation_spell',
    },
  ),
  WizardTransmutationFeatureIds.shapechanger: _wizardSchoolFeature(
    id: WizardTransmutationFeatureIds.shapechanger,
    name: 'Mutaforma',
    summary:
        'Il Mago aggiunge Metamorfosi al libro e può trasformare gratuitamente sé stesso.',
    details:
        'Dal 10° livello, il Mago aggiunge Metamorfosi al libro se non è già presente. Può lanciarlo su sé stesso senza spendere uno slot per assumere la forma di una bestia con grado di sfida 1 o inferiore. Questo uso si recupera dopo un riposo breve o lungo.',
    schoolId: 'transmutation',
    source: _phbWizardTransmutationSource,
    resourceId: WizardTransmutationFeatureIds.shapechanger,
    spellIds: {'polymorph'},
    ruleTags: {
      'polymorph',
      'self_only',
      'no_spell_slot',
      'beast_challenge_rating_1_or_lower',
    },
  ),
  WizardTransmutationFeatureIds.masterTransmuter: _wizardSchoolFeature(
    id: WizardTransmutationFeatureIds.masterTransmuter,
    name: 'Maestro Trasmutatore',
    summary:
        'Consumando la pietra il Mago produce uno tra quattro potenti effetti.',
    details:
        'Dal 14° livello, il Mago può usare un’azione e distruggere la Pietra del Trasmutatore per scegliere un effetto. Trasformazione Migliore richiede 10 minuti e converte un oggetto non magico contenuto in un cubo con spigolo di 1,5 metri in un oggetto di taglia e massa analoghe e valore pari o inferiore. Panacea rimuove tutte le maledizioni, malattie e veleni da una creatura toccata e le ripristina tutti i punti ferita. Ripristinare Vita lancia Rianimare Morti senza slot e senza che l’incantesimo sia presente nel libro. Ripristinare Giovinezza riduce l’età apparente di 3d10 anni, fino a un minimo di 13 anni, senza estendere la vita. La pietra non può essere ricreata prima di un riposo lungo.',
    schoolId: 'transmutation',
    source: _phbWizardTransmutationSource,
    resourceId: WizardTransmutationFeatureIds.masterTransmuter,
    spellIds: {'raise_dead'},
    choices: const [
      CharacterChoiceDefinition(
        id: WizardTransmutationChoiceIds.masterTransmuterEffect,
        label: 'Scegli l’effetto di Maestro Trasmutatore',
        type: CharacterChoiceType.other,
        minimumSelections: 1,
        maximumSelections: 1,
        optionIds: [
          'major_transformation',
          'panacea',
          'restore_life',
          'restore_youth',
        ],
      ),
    ],
    ruleTags: {
      'action',
      'consume_transmuters_stone',
      'major_transformation',
      'panacea',
      'raise_dead_without_spell_slot',
      'restore_youth_3d10_years',
      'minimum_apparent_age_13',
      'does_not_extend_lifespan',
    },
  ),
};

final wizardTransmutationDefinition = CharacterSubclassDefinition(
  id: WizardSubclassIds.transmutation,
  name: 'Scuola di Trasmutazione',
  classId: ClassIds.wizard,
  content: const RuleContent(
    id: WizardSubclassIds.transmutation,
    name: 'Scuola di Trasmutazione',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che altera materia, forma, energia e proprietà fisiche.',
      details:
          'I trasmutatori modificano materiali e creature, creano pietre magiche e padroneggiano trasformazioni capaci perfino di restaurare la vita.',
    ),
    source: _phbWizardTransmutationSource,
    ownerId: ClassIds.wizard,
  ),
  featuresByLevel: const {
    2: [
      WizardTransmutationFeatureIds.savant,
      WizardTransmutationFeatureIds.minorAlchemy,
    ],
    6: [WizardTransmutationFeatureIds.transmutersStone],
    10: [WizardTransmutationFeatureIds.shapechanger],
    14: [WizardTransmutationFeatureIds.masterTransmuter],
  },
  featureDefinitions: wizardTransmutationFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardTransmutationFeatureIds.shapechanger,
      name: 'Mutaforma',
      minimumLevel: 10,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {10: 1},
    ),
    ClassResourceDefinition(
      id: WizardTransmutationFeatureIds.masterTransmuter,
      name: 'Maestro Trasmutatore',
      minimumLevel: 14,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {14: 1},
    ),
  ],
  spellbookCopyAdjustments: const [
    ClassSpellbookCopyAdjustmentDefinition(
      id: WizardTransmutationFeatureIds.savant,
      schoolId: 'transmutation',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    ),
  ],
);

final wizardSubclasses = <String, CharacterSubclassDefinition>{
  WizardSubclassIds.abjuration: wizardAbjurationDefinition,
  WizardSubclassIds.conjuration: wizardConjurationDefinition,
  WizardSubclassIds.divination: wizardDivinationDefinition,
  WizardSubclassIds.enchantment: wizardEnchantmentDefinition,
  WizardSubclassIds.evocation: wizardEvocationDefinition,
  WizardSubclassIds.illusion: wizardIllusionDefinition,
  WizardSubclassIds.necromancy: wizardNecromancyDefinition,
  WizardSubclassIds.transmutation: wizardTransmutationDefinition,
};

final wizardClassDefinition = CharacterClassDefinition(
  id: ClassIds.wizard,
  name: 'Mago',
  content: const RuleContent(
    id: ClassIds.wizard,
    name: 'Mago',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Uno studioso della magia arcana capace di manipolare la struttura della realtà.',
      details:
          'Il Mago raccoglie incantesimi nel proprio libro, prepara formule diverse ogni giorno e sceglie una Tradizione Arcana.',
    ),
    source: _phbWizardSource,
    ownerId: ClassIds.wizard,
  ),
  hitDie: 6,
  proficiencies: const ClassProficiencyDefinition(
    weapons: {
      'dagger',
      'dart',
      'sling',
      'quarterstaff',
      'light_crossbow',
    },
    savingThrows: {'INT', 'SAG'},
    skillOptions: {
      'arcana',
      'history',
      'insight',
      'investigation',
      'medicine',
      'religion',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'wizard_skills',
        label: 'Scegli due abilità da Mago',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'arcana',
          'history',
          'insight',
          'investigation',
          'medicine',
          'religion',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    const ClassEquipmentChoice(
      id: 'wizard_weapon',
      label: 'Scegli l’arma iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'wizard_quarterstaff',
          label: 'Bastone Ferrato',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'quarterstaff',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'wizard_dagger',
          label: 'Pugnale',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'dagger',
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'wizard_focus',
      label: 'Scegli il focus da incantatore',
      alternatives: wizardArcaneFocusAlternatives,
    ),
    const ClassEquipmentChoice(
      id: 'wizard_pack',
      label: 'Scegli la dotazione da esplorazione',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'wizard_scholar_pack',
          label: 'Dotazione da Studioso',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.scholar,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'wizard_explorer_pack',
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
      catalogId: 'equipment',
      itemId: EquipmentIds.spellbook,
    ),
  ],
  featuresByLevel: const {
    1: [
      WizardFeatureIds.spellcasting,
      WizardFeatureIds.arcaneRecovery,
    ],
    2: [WizardFeatureIds.arcaneTradition],
    4: [WizardFeatureIds.abilityScoreImprovement],
    8: [WizardFeatureIds.abilityScoreImprovement],
    12: [WizardFeatureIds.abilityScoreImprovement],
    16: [WizardFeatureIds.abilityScoreImprovement],
    18: [WizardFeatureIds.spellMastery],
    19: [WizardFeatureIds.abilityScoreImprovement],
    20: [WizardFeatureIds.signatureSpells],
  },
  featureDefinitions: wizardFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: WizardResourceIds.arcaneRecovery,
      name: 'Recupero Arcano',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.dawn,
      maximumByLevel: {1: 1},
    ),
    ClassResourceDefinition(
      id: WizardResourceIds.signatureSpells,
      name: 'Incantesimi Personali',
      minimumLevel: 20,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {20: 2},
    ),
  ],
  spellSlotRecoveries: const [
    ClassSpellSlotRecoveryDefinition(
      id: WizardResourceIds.arcaneRecovery,
      name: 'Recupero Arcano',
      minimumLevel: 1,
      resourceId: WizardResourceIds.arcaneRecovery,
      classLevelDivisor: 2,
      roundUp: true,
      maximumSlotLevel: 5,
      requiresShortRest: true,
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.full,
    ability: 'INT',
    minimumLevel: 1,
    ritualCasting: true,
    preparesSpells: true,
    slotsByClassLevel: const {
      1: [2],
      2: [3],
      3: [4, 2],
      4: [4, 3],
      5: [4, 3, 2],
      6: [4, 3, 3],
      7: [4, 3, 3, 1],
      8: [4, 3, 3, 2],
      9: [4, 3, 3, 3, 1],
      10: [4, 3, 3, 3, 2],
      11: [4, 3, 3, 3, 2, 1],
      12: [4, 3, 3, 3, 2, 1],
      13: [4, 3, 3, 3, 2, 1, 1],
      14: [4, 3, 3, 3, 2, 1, 1],
      15: [4, 3, 3, 3, 2, 1, 1, 1],
      16: [4, 3, 3, 3, 2, 1, 1, 1],
      17: [4, 3, 3, 3, 2, 1, 1, 1, 1],
      18: [4, 3, 3, 3, 3, 1, 1, 1, 1],
      19: [4, 3, 3, 3, 3, 2, 1, 1, 1],
      20: [4, 3, 3, 3, 3, 2, 2, 1, 1],
    },
    cantripsKnownByLevel: const {
      1: 3,
      4: 4,
      10: 5,
    },
    spellIds: wizardClassSpellIds,
  ),
  spellbook: const ClassSpellbookDefinition(
    catalogId: 'equipment',
    itemId: EquipmentIds.spellbook,
    initialSpells: 6,
    spellsLearnedPerLevel: 2,
    copyTimeHoursPerSpellLevel: 2,
    copyCostGpPerSpellLevel: 50,
    backupCopyTimeHoursPerSpellLevel: 1,
    backupCopyCostGpPerSpellLevel: 10,
  ),
  subclassSelectionLevel: 2,
  subclasses: wizardSubclasses,
);
