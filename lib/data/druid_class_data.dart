import 'armor_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'character_data.dart';
import 'equipment_pack_data.dart';
import 'focus_data.dart';
import 'spell_data.dart';
import 'tool_data.dart';
import 'weapon_data.dart';

const _phbDruidSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 64-69',
);

class DruidSubclassIds {
  static const land = 'circle_of_the_land';
  static const moon = 'circle_of_the_moon';
}

class DruidLandIds {
  static const arctic = 'land_arctic';
  static const coast = 'land_coast';
  static const desert = 'land_desert';
  static const forest = 'land_forest';
  static const grassland = 'land_grassland';
  static const mountain = 'land_mountain';
  static const swamp = 'land_swamp';
  static const underdark = 'land_underdark';
}

const _druidSkillIds = <String>{
  'arcana',
  'animal_handling',
  'insight',
  'medicine',
  'nature',
  'perception',
  'religion',
  'survival',
};

const _druidWeaponProficiencyIds = <String>{
  'club',
  'dagger',
  'dart',
  'javelin',
  'mace',
  'quarterstaff',
  'scimitar',
  'sickle',
  'sling',
  'spear',
};

final _druidSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.druid))
    .map((spell) => spell.id)
    .toSet();

final _druidSimpleWeaponAlternatives = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.simple)
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'druid_simple_${weapon.id}',
        label: weapon.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'weapon',
            itemId: weapon.id,
          ),
        ],
      ),
    )
    .toList();

final _druidSimpleMeleeWeaponAlternatives = weaponDefinitions.values
    .where(
      (weapon) =>
          weapon.category == WeaponCategory.simple &&
          weapon.kind == WeaponKind.melee,
    )
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'druid_simple_melee_${weapon.id}',
        label: weapon.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'weapon',
            itemId: weapon.id,
          ),
        ],
      ),
    )
    .toList();

final _druidFocusAlternatives = focusDefinitions.values
    .where((focus) => focus.category == FocusCategory.druidic)
    .map(
      (focus) => ClassEquipmentAlternative(
        id: 'druid_focus_${focus.id}',
        label: focus.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'focus',
            itemId: focus.id,
          ),
        ],
      ),
    )
    .toList();

CharacterClassFeatureDefinition _druidFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  String? resourceId,
  Set<String> spellIds = const {},
  List<CharacterChoiceDefinition> choices = const [],
  CharacterEffects effects = const CharacterEffects(),
  Set<String> ruleTags = const {},
}) =>
    CharacterClassFeatureDefinition(
      id: id,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.classFeature,
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbDruidSource,
        ownerId: ClassIds.druid,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      choices: choices,
      effects: effects,
      ruleTags: {
        'class_feature',
        'druid',
        ...ruleTags,
      },
    );

CharacterClassFeatureDefinition _druidSubclassFeature({
  required String subclassId,
  required String id,
  required String name,
  required String summary,
  required String details,
  String? resourceId,
  Set<String> spellIds = const {},
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
        source: _phbDruidSource,
        ownerId: subclassId,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      choices: choices,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'druid',
        subclassId,
        ...ruleTags,
      },
    );

SubclassOptionDefinition _druidLandOption({
  required String id,
  required String name,
  required String summary,
  required Map<int, Set<String>> spellsByLevel,
}) =>
    SubclassOptionDefinition(
      id: id,
      name: name,
      category: 'circle_land_type',
      minimumLevel: 2,
      source: 'Manuale del Giocatore 2014',
      sourceRef: 'Pagina 68',
      description: RuleDescription(
        summary: summary,
        details:
            'Gli incantesimi del territorio diventano sempre preparati ai livelli 3, 5, 7 e 9 e non contano nel numero di incantesimi preparati.',
      ),
      alwaysPreparedSpellIdsByLevel: spellsByLevel,
    );

final druidLandOptions = <SubclassOptionDefinition>[
  _druidLandOption(
    id: DruidLandIds.arctic,
    name: 'Artico',
    summary: 'Magia del gelo, della neve e degli ambienti polari.',
    spellsByLevel: const {
      3: {SpellIds.holdPerson, SpellIds.spikeGrowth},
      5: {SpellIds.sleetStorm, SpellIds.slow},
      7: {SpellIds.freedomOfMovement, SpellIds.iceStorm},
      9: {SpellIds.communeWithNature, SpellIds.coneOfCold},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.coast,
    name: 'Costa',
    summary: 'Magia del mare, delle onde e delle regioni costiere.',
    spellsByLevel: const {
      3: {SpellIds.mirrorImage, SpellIds.mistyStep},
      5: {SpellIds.waterBreathing, SpellIds.waterWalk},
      7: {SpellIds.controlWater, SpellIds.freedomOfMovement},
      9: {SpellIds.conjureElemental, SpellIds.scrying},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.desert,
    name: 'Deserto',
    summary: 'Magia della calura, dell’aridità e delle distese sabbiose.',
    spellsByLevel: const {
      3: {SpellIds.blur, SpellIds.silence},
      5: {SpellIds.createFoodAndWater, SpellIds.protectionFromEnergy},
      7: {SpellIds.blight, SpellIds.hallucinatoryTerrain},
      9: {SpellIds.insectPlague, SpellIds.wallOfStone},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.forest,
    name: 'Foresta',
    summary: 'Magia degli alberi, delle piante e delle selve.',
    spellsByLevel: const {
      3: {SpellIds.barkskin, SpellIds.spiderClimb},
      5: {SpellIds.callLightning, SpellIds.plantGrowth},
      7: {SpellIds.divination, SpellIds.freedomOfMovement},
      9: {SpellIds.communeWithNature, SpellIds.treeStride},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.grassland,
    name: 'Prateria',
    summary: 'Magia degli spazi aperti, della velocità e dell’occultamento.',
    spellsByLevel: const {
      3: {SpellIds.invisibility, SpellIds.passWithoutTrace},
      5: {SpellIds.daylight, SpellIds.haste},
      7: {SpellIds.divination, SpellIds.freedomOfMovement},
      9: {SpellIds.dream, SpellIds.insectPlague},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.mountain,
    name: 'Montagna',
    summary: 'Magia della roccia, delle vette e dei fulmini.',
    spellsByLevel: const {
      3: {SpellIds.spiderClimb, SpellIds.spikeGrowth},
      5: {SpellIds.lightningBolt, SpellIds.meldIntoStone},
      7: {SpellIds.stoneShape, SpellIds.stoneskin},
      9: {SpellIds.passwall, SpellIds.wallOfStone},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.swamp,
    name: 'Palude',
    summary: 'Magia delle acque stagnanti, dei veleni e della decomposizione.',
    spellsByLevel: const {
      3: {SpellIds.darkness, SpellIds.melfsAcidArrow},
      5: {SpellIds.waterWalk, SpellIds.stinkingCloud},
      7: {SpellIds.freedomOfMovement, SpellIds.locateCreature},
      9: {SpellIds.insectPlague, SpellIds.scrying},
    },
  ),
  _druidLandOption(
    id: DruidLandIds.underdark,
    name: 'Underdark',
    summary: 'Magia delle caverne profonde, delle ragnatele e delle spore.',
    spellsByLevel: const {
      3: {SpellIds.spiderClimb, SpellIds.web},
      5: {SpellIds.gaseousForm, SpellIds.stinkingCloud},
      7: {SpellIds.greaterInvisibility, SpellIds.stoneShape},
      9: {SpellIds.cloudkill, SpellIds.insectPlague},
    },
  ),
];

final druidMoonCircleFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'combat_wild_shape': _druidSubclassFeature(
    subclassId: DruidSubclassIds.moon,
    id: 'combat_wild_shape',
    name: 'Forma Selvatica da Combattimento',
    summary:
        'Il Druido può assumere Forma Selvatica come azione bonus e curarsi durante la trasformazione.',
    details:
        'Dal 2° livello può usare Forma Selvatica come azione bonus. Mentre è trasformato può usare un’azione bonus e consumare uno slot incantesimo per recuperare 1d8 punti ferita per livello dello slot consumato.',
    resourceId: 'wild_shape',
    ruleTags: {
      'bonus_action_transformation',
      'bonus_action_healing',
      'spell_slot_cost',
      'healing_1d8_per_slot_level',
    },
  ),
  'circle_forms': _druidSubclassFeature(
    subclassId: DruidSubclassIds.moon,
    id: 'circle_forms',
    name: 'Forme del Circolo',
    summary: 'Il Druido accede a forme animali con grado di sfida superiore.',
    details:
        'Dal 2° livello può trasformarsi in una bestia con grado di sfida massimo 1, rispettando ancora i limiti alle velocità di nuotare e volare. Dal 6° livello il grado di sfida massimo diventa pari al livello da Druido diviso per tre, arrotondato per difetto.',
    resourceId: 'wild_shape',
    ruleTags: {
      'wild_shape_override',
      'challenge_rating_1_at_level_2',
      'challenge_rating_level_divided_by_3_at_level_6',
    },
  ),
  'primal_strike': _druidSubclassFeature(
    subclassId: DruidSubclassIds.moon,
    id: 'primal_strike',
    name: 'Colpo Primordiale',
    summary: 'Gli attacchi della Forma Selvatica sono considerati magici.',
    details:
        'Dal 6° livello gli attacchi effettuati nella forma di una bestia sono considerati magici ai fini di superare resistenze e immunità agli attacchi e ai danni non magici.',
    ruleTags: {
      'wild_shape',
      'magical_attacks',
      'overcome_nonmagical_resistance',
      'overcome_nonmagical_immunity',
    },
  ),
  'elemental_wild_shape': _druidSubclassFeature(
    subclassId: DruidSubclassIds.moon,
    id: 'elemental_wild_shape',
    name: 'Forma Selvatica Elementale',
    summary:
        'Il Druido assume la forma di un elementale spendendo due utilizzi.',
    details:
        'Dal 10° livello può spendere due utilizzi di Forma Selvatica contemporaneamente per trasformarsi in un elementale dell’acqua, dell’aria, della terra o del fuoco.',
    resourceId: 'wild_shape',
    ruleTags: {
      'elemental_transformation',
      'resource_cost_2',
      'air_elemental',
      'earth_elemental',
      'fire_elemental',
      'water_elemental',
    },
  ),
  'thousand_forms': _druidSubclassFeature(
    subclassId: DruidSubclassIds.moon,
    id: 'thousand_forms',
    name: 'Mille Forme',
    summary: 'Il Druido può alterare liberamente il proprio aspetto fisico.',
    details:
        'Dal 14° livello può lanciare Alterare Se Stesso a volontà, senza consumare slot incantesimo.',
    spellIds: {
      SpellIds.alterSelf,
    },
    ruleTags: {
      'at_will_spell',
      'spell_without_slot',
      'self_transformation',
    },
  ),
};

final druidMoonCircleDefinition = CharacterSubclassDefinition(
  id: DruidSubclassIds.moon,
  name: 'Circolo della Luna',
  classId: ClassIds.druid,
  content: const RuleContent(
    id: DruidSubclassIds.moon,
    name: 'Circolo della Luna',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Druidi specializzati nelle trasformazioni animali e nel combattimento in Forma Selvatica.',
      details:
          'Il Circolo della Luna rende Forma Selvatica più rapida e potente, consente di assumere forme elementali e infine di alterare liberamente il proprio aspetto.',
    ),
    source: _phbDruidSource,
    ownerId: ClassIds.druid,
  ),
  featuresByLevel: const {
    2: [
      'combat_wild_shape',
      'circle_forms',
    ],
    6: ['primal_strike'],
    10: ['elemental_wild_shape'],
    14: ['thousand_forms'],
  },
  featureDefinitions: druidMoonCircleFeatureDefinitions,
  transformations: const [
    ClassTransformationDefinition(
      id: 'wild_shape',
      name: 'Forma Selvatica del Circolo della Luna',
      minimumLevel: 2,
      resourceId: 'wild_shape',
      action: ClassTransformationAction.bonusAction,
      durationHoursLevelDivisor: 2,
      maximumChallengeRatingByLevel: {
        2: 1,
        6: 2,
        9: 3,
        12: 4,
        15: 5,
        18: 6,
      },
      swimmingSpeedMinimumLevel: 4,
      flyingSpeedMinimumLevel: 8,
      spellcastingMinimumLevel: 18,
      allowedCreatureTypes: {
        'beast',
      },
    ),
    ClassTransformationDefinition(
      id: 'elemental_wild_shape',
      name: 'Forma Selvatica Elementale',
      minimumLevel: 10,
      resourceId: 'wild_shape',
      resourceCost: 2,
      action: ClassTransformationAction.bonusAction,
      durationHoursLevelDivisor: 2,
      maximumChallengeRatingByLevel: {},
      spellcastingMinimumLevel: 18,
      allowedCreatureTypes: {
        'elemental',
      },
      fixedFormIds: {
        'air_elemental',
        'earth_elemental',
        'fire_elemental',
        'water_elemental',
      },
    ),
  ],
);

final druidLandCircleFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'bonus_cantrip_land': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'bonus_cantrip_land',
    name: 'Trucchetto Bonus',
    summary: 'Il Druido apprende un trucchetto da Druido aggiuntivo.',
    details:
        'Al 2° livello apprende un trucchetto da Druido a sua scelta. Il trucchetto non conta nel numero di trucchetti normalmente conosciuti.',
    choices: [
      CharacterChoiceDefinition(
        id: 'land_circle_bonus_cantrip',
        label: 'Scegli un trucchetto da Druido aggiuntivo',
        type: CharacterChoiceType.cantrip,
        catalogId: 'spell',
        optionIds: spellDefinitions.values
            .where(
              (spell) =>
                  spell.level == 0 && spell.classIds.contains(ClassIds.druid),
            )
            .map((spell) => spell.id)
            .toList(),
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'bonus_cantrip',
      'does_not_count_against_cantrips_known',
    },
  ),
  'natural_recovery': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'natural_recovery',
    name: 'Recupero Naturale',
    summary:
        'Durante un riposo breve il Druido recupera parte degli slot incantesimo.',
    details:
        'Dal 2° livello, una volta per riposo lungo, durante un riposo breve recupera slot per un totale di livelli pari a metà del livello da Druido arrotondata per eccesso. Nessuno slot recuperato può essere di 6° livello o superiore.',
    resourceId: 'natural_recovery',
    ruleTags: {
      'short_rest_activation',
      'long_rest_recharge',
      'spell_slot_recovery',
      'half_druid_level_rounded_up',
      'maximum_slot_level_5',
    },
  ),
  'circle_spells_land': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'circle_spells_land',
    name: 'Incantesimi del Circolo',
    summary: 'Il territorio scelto concede incantesimi sempre preparati.',
    details:
        'Dal 3° livello gli incantesimi associati all’ambiente scelto sono sempre preparati, sono considerati incantesimi da Druido e non contano nel totale degli incantesimi preparati.',
    ruleTags: {
      'always_prepared',
      'land_type',
      'does_not_count_against_prepared_spells',
    },
  ),
  'lands_stride': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'lands_stride',
    name: 'Andatura sul Territorio',
    summary:
        'Il Druido attraversa la vegetazione e il terreno difficile senza rallentare.',
    details:
        'Dal 6° livello muoversi attraverso terreno difficile non magico non costa movimento extra. Può inoltre attraversare vegetazione non magica senza rallentare e senza subire danni da spine, aculei o pericoli simili. Dispone di vantaggio ai tiri salvezza contro vegetali creati o manipolati magicamente per ostacolare il movimento.',
    ruleTags: {
      'ignore_nonmagical_difficult_terrain',
      'ignore_nonmagical_plants',
      'magical_plant_save_advantage',
    },
  ),
  'natures_ward': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'natures_ward',
    name: 'Interdizione della Natura',
    summary:
        'Il Druido diventa immune a veleno e malattie e resiste alle influenze di folletti ed elementali.',
    details:
        'Dal 10° livello è immune a veleno e malattie e non può essere affascinato o spaventato da elementali o folletti.',
    effects: const CharacterEffects(
      conditionImmunities: {
        'poisoned',
        'disease',
      },
    ),
    ruleTags: {
      'poison_immunity',
      'disease_immunity',
      'elemental_charm_immunity',
      'elemental_fear_immunity',
      'fey_charm_immunity',
      'fey_fear_immunity',
    },
  ),
  'natures_sanctuary': _druidSubclassFeature(
    subclassId: DruidSubclassIds.land,
    id: 'natures_sanctuary',
    name: 'Rifugio della Natura',
    summary: 'Animali e vegetali esitano ad attaccare il Druido.',
    details:
        'Dal 14° livello, quando una bestia o una creatura vegetale attacca il Druido, deve effettuare un tiro salvezza di Saggezza contro la CD degli incantesimi del Druido. Se fallisce deve scegliere un altro bersaglio o l’attacco manca automaticamente. Se supera il tiro è immune all’effetto per 24 ore. La creatura è consapevole dell’effetto prima di effettuare l’attacco.',
    ruleTags: {
      'beast',
      'plant',
      'wisdom_save',
      'redirect_attack_or_miss',
      'success_immunity_24_hours',
    },
  ),
};

final druidLandCircleDefinition = CharacterSubclassDefinition(
  id: DruidSubclassIds.land,
  name: 'Circolo della Terra',
  classId: ClassIds.druid,
  content: const RuleContent(
    id: DruidSubclassIds.land,
    name: 'Circolo della Terra',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary: 'Druidi mistici legati a uno specifico territorio naturale.',
      details:
          'Il Circolo della Terra concede un trucchetto aggiuntivo, recupero degli slot e una lista di incantesimi determinata dall’ambiente scelto.',
    ),
    source: _phbDruidSource,
    ownerId: ClassIds.druid,
  ),
  featuresByLevel: const {
    2: [
      'bonus_cantrip_land',
      'natural_recovery',
    ],
    3: ['circle_spells_land'],
    6: ['lands_stride'],
    10: ['natures_ward'],
    14: ['natures_sanctuary'],
  },
  featureDefinitions: druidLandCircleFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'natural_recovery',
      name: 'Recupero Naturale',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        2: 1,
      },
    ),
  ],
  spellSlotRecoveries: const [
    ClassSpellSlotRecoveryDefinition(
      id: 'natural_recovery',
      name: 'Recupero Naturale',
      minimumLevel: 2,
      resourceId: 'natural_recovery',
      classLevelDivisor: 2,
      roundUp: true,
      maximumSlotLevel: 5,
      requiresShortRest: true,
    ),
  ],
  options: druidLandOptions,
  optionProgression: const SubclassOptionProgression(
    selectionsByLevel: {
      2: 1,
    },
  ),
);

final druidFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'druidic': _druidFeature(
    id: 'druidic',
    name: 'Druidico',
    summary:
        'Il Druido conosce il linguaggio segreto utilizzato dagli altri druidi.',
    details:
        'Dal 1° livello il Druido conosce il Druidico. Può parlare questo linguaggio e usarlo per lasciare messaggi segreti che gli altri conoscitori del Druidico individuano automaticamente. Le altre creature possono notare la presenza di un messaggio superando una prova di Saggezza (Percezione) con CD 15, ma non possono decifrarlo senza l’aiuto della magia.',
    effects: const CharacterEffects(
      languages: {
        'druidic',
      },
    ),
    ruleTags: {
      'secret_language',
      'hidden_messages',
    },
  ),
  'spellcasting': _druidFeature(
    id: 'spellcasting',
    name: 'Incantesimi',
    summary: 'Il Druido prepara e lancia incantesimi naturali usando Saggezza.',
    details:
        'Dal 1° livello conosce i trucchetti da Druido e prepara un numero di incantesimi pari al livello da Druido più il modificatore di Saggezza, con un minimo di uno. Gli incantesimi preparati devono appartenere a livelli per cui possiede slot. Può cambiare la lista al termine di un riposo lungo, pregando e meditando per almeno 1 minuto per livello di ogni incantesimo preparato. Può lanciare come rituale un incantesimo da Druido preparato che possieda il descrittore rituale e può usare un focus druidico come focus da incantatore.',
    ruleTags: {
      'spellcasting',
      'wisdom',
      'prepared_spells',
      'ritual_casting',
      'druidic_focus',
    },
  ),
  'druidic_armor_restriction': _druidFeature(
    id: 'druidic_armor_restriction',
    name: 'Tabù del Metallo',
    summary: 'I druidi evitano armature e scudi realizzati con il metallo.',
    details:
        'Pur possedendo competenza nelle armature leggere, nelle armature medie e negli scudi, i druidi non indossano armature e non usano scudi realizzati in metallo.',
    ruleTags: {
      'armor_restriction',
      'nonmetal_armor',
      'nonmetal_shield',
    },
  ),
  'wild_shape': _druidFeature(
    id: 'wild_shape',
    name: 'Forma Selvatica',
    summary:
        'Il Druido assume magicamente la forma di una bestia già osservata.',
    details:
        'Dal 2° livello usa un’azione e un utilizzo di Forma Selvatica per trasformarsi in una bestia che ha già visto. Il grado di sfida massimo e le velocità consentite dipendono dal livello. La trasformazione dura un numero di ore pari a metà del livello da Druido arrotondato per difetto; può prolungarla spendendo un altro utilizzo, terminarla anticipatamente con un’azione bonus e torna automaticamente alla forma normale se cade privo di sensi, scende a 0 punti ferita o muore. Le statistiche sono sostituite da quelle della bestia, ma conserva allineamento, personalità, Intelligenza, Saggezza, Carisma e le proprie competenze; usa il bonus della bestia quando una competenza condivisa è superiore e non può usare azioni leggendarie o di tana. Assume i punti ferita e i Dadi Vita della bestia e gli eventuali danni eccedenti si trasferiscono alla forma normale. Non può lanciare incantesimi, ma conserva la concentrazione e può continuare a usare le azioni di un incantesimo già lanciato. Mantiene i privilegi che la nuova forma può fisicamente utilizzare e i sensi speciali posseduti anche dalla bestia. Decide se l’equipaggiamento cade a terra, si fonde nella forma o rimane indossato; l’equipaggiamento fuso non produce effetti.',
    resourceId: 'wild_shape',
    ruleTags: {
      'transformation',
      'beast',
      'seen_form_required',
      'action',
    },
  ),
  'druid_circle': _druidFeature(
    id: 'druid_circle',
    name: 'Circolo Druidico',
    summary: 'Il Druido sceglie un circolo che definisce il proprio cammino.',
    details:
        'Al 2° livello sceglie il Circolo della Terra o il Circolo della Luna. Il circolo concede ulteriori privilegi ai livelli indicati dalla sua progressione.',
    ruleTags: {
      'subclass_selection',
    },
  ),
  'wild_shape_improvement': _druidFeature(
    id: 'wild_shape_improvement',
    name: 'Forma Selvatica Migliorata',
    summary:
        'Il Druido accede a forme più potenti e a nuove modalità di movimento.',
    details:
        'Dal 4° livello può scegliere bestie con grado di sfida massimo 1/2 e dotate di velocità di nuotare. Dall’8° livello può scegliere bestie con grado di sfida massimo 1 e dotate di velocità di volare.',
    resourceId: 'wild_shape',
    ruleTags: {
      'transformation_improvement',
      'challenge_rating',
      'swimming_speed',
      'flying_speed',
    },
  ),
  'ability_score_improvement': _druidFeature(
    id: 'ability_score_improvement',
    name: 'Aumento dei Punteggi di Caratteristica',
    summary:
        'Il Druido può aumentare i punteggi di caratteristica o scegliere un talento.',
    details:
        'Il privilegio viene ottenuto ai livelli 4, 8, 12, 16 e 19 secondo le regole generali di avanzamento.',
    ruleTags: {
      'ability_score_improvement',
      'feat',
    },
  ),
  'timeless_body': _druidFeature(
    id: 'timeless_body',
    name: 'Corpo Senza Tempo',
    summary: 'La magia primordiale rallenta drasticamente l’invecchiamento.',
    details:
        'Dal 18° livello, per ogni dieci anni trascorsi, il corpo del Druido invecchia soltanto di un anno.',
    ruleTags: {
      'aging',
      'one_year_per_ten_years',
    },
  ),
  'beast_spells': _druidFeature(
    id: 'beast_spells',
    name: 'Incantesimi Bestiali',
    summary:
        'Il Druido può lanciare molti dei propri incantesimi mentre è in Forma Selvatica.',
    details:
        'Dal 18° livello può eseguire le componenti verbali e somatiche degli incantesimi da Druido mentre è in Forma Selvatica, ma non può fornire componenti materiali.',
    ruleTags: {
      'wild_shape',
      'spellcasting_while_transformed',
      'verbal_components',
      'somatic_components',
      'no_material_components',
    },
  ),
  'archdruid': _druidFeature(
    id: 'archdruid',
    name: 'Arcidruido',
    summary:
        'Il Druido può usare Forma Selvatica senza limiti e semplifica le componenti degli incantesimi.',
    details:
        'Al 20° livello può usare Forma Selvatica un numero illimitato di volte. Può inoltre ignorare le componenti verbali e somatiche degli incantesimi da Druido e le componenti materiali prive di costo e non consumate, sia nella forma normale sia in una forma bestiale assunta tramite Forma Selvatica.',
    resourceId: 'wild_shape',
    ruleTags: {
      'unlimited_resource',
      'ignore_verbal_components',
      'ignore_somatic_components',
      'ignore_noncostly_material_components',
    },
  ),
};

final druidClassDefinition = CharacterClassDefinition(
  id: ClassIds.druid,
  name: 'Druido',
  content: const RuleContent(
    id: ClassIds.druid,
    name: 'Druido',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un sacerdote della natura che lancia incantesimi primordiali e assume forme animali.',
      details:
          'Il Druido trae potere dalla natura, prepara incantesimi usando Saggezza e sviluppa Forma Selvatica dal 2° livello.',
    ),
    source: _phbDruidSource,
    ownerId: ClassIds.druid,
  ),
  hitDie: 8,
  proficiencies: const ClassProficiencyDefinition(
    armor: {
      'light_armor',
      'medium_armor',
      'shield',
    },
    weapons: _druidWeaponProficiencyIds,
    tools: {
      ToolIds.herbalismKit,
    },
    savingThrows: {
      'INT',
      'SAG',
    },
    skillOptions: _druidSkillIds,
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'druid_skills',
        label: 'Scegli due abilità da Druido',
        type: ClassProficiencyChoiceType.skill,
        optionIds: _druidSkillIds,
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'druid_shield_or_simple_weapon',
      label: 'Scegli uno scudo di legno o un’arma semplice',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'druid_wooden_shield',
          label: 'Scudo di Legno',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: ArmorIds.shield,
            ),
          ],
        ),
        ..._druidSimpleWeaponAlternatives,
      ],
    ),
    ClassEquipmentChoice(
      id: 'druid_scimitar_or_simple_melee_weapon',
      label: 'Scegli una scimitarra o un’arma semplice da mischia',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'druid_scimitar',
          label: 'Scimitarra',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'scimitar',
            ),
          ],
        ),
        ..._druidSimpleMeleeWeaponAlternatives,
      ],
    ),
    ClassEquipmentChoice(
      id: 'druidic_focus',
      label: 'Scegli un focus druidico',
      alternatives: _druidFocusAlternatives,
    ),
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'armor',
      itemId: ArmorIds.leather,
    ),
    ClassEquipmentGrant(
      catalogId: 'equipment_pack',
      itemId: EquipmentPackIds.explorer,
    ),
  ],
  featuresByLevel: const {
    1: [
      'druidic',
      'spellcasting',
      'druidic_armor_restriction',
    ],
    2: [
      'wild_shape',
      'druid_circle',
    ],
    4: [
      'wild_shape_improvement',
      'ability_score_improvement',
    ],
    8: [
      'wild_shape_improvement',
      'ability_score_improvement',
    ],
    12: ['ability_score_improvement'],
    16: ['ability_score_improvement'],
    18: [
      'timeless_body',
      'beast_spells',
    ],
    19: ['ability_score_improvement'],
    20: ['archdruid'],
  },
  featureDefinitions: druidFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'wild_shape',
      name: 'Forma Selvatica',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        2: 2,
      },
      unlimitedFromLevel: 20,
    ),
  ],
  transformations: const [
    ClassTransformationDefinition(
      id: 'wild_shape',
      name: 'Forma Selvatica',
      minimumLevel: 2,
      resourceId: 'wild_shape',
      durationHoursLevelDivisor: 2,
      maximumChallengeRatingByLevel: {
        2: 0.25,
        4: 0.5,
        8: 1,
      },
      swimmingSpeedMinimumLevel: 4,
      flyingSpeedMinimumLevel: 8,
      spellcastingMinimumLevel: 18,
      allowedCreatureTypes: {
        'beast',
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'wild_shape_max_cr',
      name: 'Grado di Sfida Massimo di Forma Selvatica',
      valuesByLevel: {
        2: '1/4',
        4: '1/2',
        8: '1',
      },
    ),
    ClassProgressionValueDefinition(
      id: 'wild_shape_duration_hours',
      name: 'Durata Massima di Forma Selvatica in Ore',
      valuesByLevel: {
        2: '1',
        4: '2',
        6: '3',
        8: '4',
        10: '5',
        12: '6',
        14: '7',
        16: '8',
        18: '9',
        20: '10',
      },
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.full,
    ability: 'SAG',
    minimumLevel: 1,
    ritualCasting: true,
    preparesSpells: true,
    spellIds: _druidSpellIds,
    preparedSpellLevelDivisor: 1,
    minimumPreparedSpells: 1,
    cantripsKnownByLevel: const {
      1: 2,
      4: 3,
      10: 4,
    },
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
  ),
  subclassSelectionLevel: 2,
  subclasses: {
    DruidSubclassIds.land: druidLandCircleDefinition,
    DruidSubclassIds.moon: druidMoonCircleDefinition,
  },
);
