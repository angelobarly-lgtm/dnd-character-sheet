import 'ammunition_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'character_data.dart';
import 'focus_data.dart';
import 'spell_data.dart';
import 'weapon_data.dart';

const _phbClericSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 56-63',
);

class ClericSubclassIds {
  static const knowledge = 'knowledge_domain';
  static const war = 'war_domain';
  static const trickery = 'trickery_domain';
  static const light = 'light_domain';
  static const nature = 'nature_domain';
  static const tempest = 'tempest_domain';
  static const life = 'life_domain';
}

const _knowledgeDomainSkillIds = <String>[
  'arcana',
  'history',
  'nature',
  'religion',
];

const _natureDomainSkillIds = <String>[
  'animal_handling',
  'nature',
  'survival',
];

final _natureDomainDruidCantripIds = spellDefinitions.values
    .where(
      (spell) => spell.level == 0 && spell.classIds.contains(ClassIds.druid),
    )
    .map((spell) => spell.id)
    .toList();

const _clericSkillIds = <String>{
  'history',
  'insight',
  'medicine',
  'persuasion',
  'religion',
};

final _clericSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.cleric))
    .map((spell) => spell.id)
    .toSet();

final _clericSimpleWeaponAlternatives = weaponDefinitions.values
    .where(
      (weapon) =>
          weapon.category == WeaponCategory.simple &&
          weapon.id != 'light_crossbow',
    )
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'cleric_simple_${weapon.id}',
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

final _clericBoltId = ammunitionDefinitions.values
    .singleWhere(
      (ammunition) => ammunition.category == AmmunitionCategory.bolt,
    )
    .id;

final _clericHolySymbolAlternatives = focusDefinitions.values
    .where((focus) => focus.category == FocusCategory.holy)
    .map(
      (focus) => ClassEquipmentAlternative(
        id: 'cleric_holy_symbol_${focus.id}',
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

CharacterClassFeatureDefinition _clericFeature({
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
        source: _phbClericSource,
        ownerId: ClassIds.cleric,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      choices: choices,
      effects: effects,
      ruleTags: {
        'class_feature',
        'cleric',
        ...ruleTags,
      },
    );

final clericFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'spellcasting': _clericFeature(
    id: 'spellcasting',
    name: 'Incantesimi',
    summary: 'Il Chierico prepara e lancia incantesimi divini usando Saggezza.',
    details:
        'Dal 1° livello conosce i trucchetti da Chierico e prepara ogni giorno un numero di incantesimi pari al livello da Chierico più il modificatore di Saggezza, con un minimo di uno. Può lanciare come rituale un incantesimo da Chierico preparato che possieda il descrittore rituale.',
    ruleTags: {
      'spellcasting',
      'wisdom',
      'prepared_spells',
      'ritual_casting',
    },
  ),
  'divine_domain': _clericFeature(
    id: 'divine_domain',
    name: 'Dominio Divino',
    summary: 'Il Chierico sceglie un dominio collegato alla propria divinità.',
    details:
        'Al 1° livello sceglie un Dominio Divino. Il dominio concede incantesimi sempre preparati e privilegi ai livelli 1, 2, 6, 8 e 17.',
    ruleTags: {
      'subclass_selection',
      'domain_spells',
    },
  ),
  'channel_divinity': _clericFeature(
    id: 'channel_divinity',
    name: 'Incanalare Divinità',
    summary:
        'Il Chierico incanala energia divina per produrre effetti speciali.',
    details:
        'Dal 2° livello dispone di un utilizzo di Incanalare Divinità. Gli utilizzi diventano due al 6° livello e tre al 18° livello. Recupera tutti gli utilizzi al termine di un riposo breve o lungo.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'short_rest',
      'long_rest',
      'divine_power',
    },
  ),
  'turn_undead': _clericFeature(
    id: 'turn_undead',
    name: 'Incanalare Divinità: Scacciare Non Morti',
    summary: 'Il Chierico presenta il simbolo sacro e scaccia i non morti.',
    details:
        'Come azione, ogni non morto entro 9 metri che possa vedere o sentire il Chierico effettua un tiro salvezza di Saggezza. In caso di fallimento è scacciato per 1 minuto o finché non subisce danni.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'action',
      'range_9_meters',
      'undead',
      'wisdom_save',
      'turned',
    },
  ),
  'ability_score_improvement': _clericFeature(
    id: 'ability_score_improvement',
    name: 'Aumento dei Punteggi di Caratteristica',
    summary:
        'Il Chierico può aumentare i punteggi di caratteristica o scegliere un talento.',
    details:
        'Il privilegio viene ottenuto ai livelli 4, 8, 12, 16 e 19 secondo le regole generali di avanzamento.',
    ruleTags: {
      'ability_score_improvement',
      'feat',
    },
  ),
  'destroy_undead': _clericFeature(
    id: 'destroy_undead',
    name: 'Distruggere Non Morti',
    summary:
        'I non morti più deboli vengono distrutti quando falliscono contro Scacciare Non Morti.',
    details:
        'Dal 5° livello, quando un non morto fallisce il tiro salvezza contro Scacciare Non Morti, viene distrutto se il suo grado di sfida è pari o inferiore alla soglia indicata dalla progressione.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'undead',
      'challenge_rating',
      'turn_undead',
    },
  ),
  'divine_intervention': _clericFeature(
    id: 'divine_intervention',
    name: 'Intervento Divino',
    summary: 'Il Chierico può chiedere alla propria divinità di intervenire.',
    details:
        'Dal 10° livello usa un’azione per descrivere l’aiuto richiesto e tira un d100. Se il risultato è pari o inferiore al livello da Chierico, la divinità interviene. Dopo un successo non può usare nuovamente il privilegio per 7 giorni; dopo un fallimento deve completare un riposo lungo.',
    ruleTags: {
      'action',
      'd100',
      'long_rest',
      'seven_days',
    },
  ),
  'divine_intervention_improvement': _clericFeature(
    id: 'divine_intervention_improvement',
    name: 'Intervento Divino Migliorato',
    summary: 'La richiesta di Intervento Divino ha successo automaticamente.',
    details:
        'Al 20° livello la richiesta di Intervento Divino riesce automaticamente senza richiedere il tiro percentuale.',
    ruleTags: {
      'automatic_success',
      'divine_intervention',
    },
  ),
};

CharacterClassFeatureDefinition _clericDomainFeature({
  required String domainId,
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
        source: _phbClericSource,
        ownerId: domainId,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      choices: choices,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'cleric',
        'divine_domain',
        domainId,
        ...ruleTags,
      },
    );

final clericTempestDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'bonus_proficiencies_tempest': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'bonus_proficiencies_tempest',
    name: 'Competenze Bonus',
    summary:
        'Il Chierico acquisisce competenza nelle armi da guerra e nelle armature pesanti.',
    details:
        'Al 1° livello il Dominio della Tempesta concede competenza nelle armi da guerra e nelle armature pesanti.',
    effects: const CharacterEffects(
      weaponProficiencies: {
        'martial_weapons',
      },
      armorProficiencies: {
        'heavy_armor',
      },
    ),
    ruleTags: {
      'weapon_proficiency',
      'martial_weapons',
      'armor_proficiency',
      'heavy_armor',
    },
  ),
  'wrath_of_the_storm': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'wrath_of_the_storm',
    name: 'Ira della Tempesta',
    summary: 'Il Chierico reagisce a un attacco sprigionando fulmini o tuoni.',
    details:
        'Dal 1° livello, quando una creatura entro 1,5 metri che il Chierico può vedere lo colpisce con un attacco, può usare la reazione. La creatura effettua un tiro salvezza di Destrezza, subendo 2d8 danni da fulmine o tuono in caso di fallimento, o la metà in caso di successo. Gli utilizzi sono pari al modificatore di Saggezza, con un minimo di uno, e si recuperano dopo un riposo lungo.',
    resourceId: 'tempest_wrath_of_the_storm',
    ruleTags: {
      'reaction',
      'range_1_5_meters',
      'dexterity_save',
      'lightning_or_thunder',
      'damage_2d8',
      'wisdom_modifier_uses',
      'long_rest',
    },
  ),
  'destructive_wrath': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'destructive_wrath',
    name: 'Incanalare Divinità: Ira Distruttiva',
    summary:
        'Il Chierico infligge il massimo danno possibile con fulmini o tuoni.',
    details:
        'Dal 2° livello, quando tira danni da fulmine o tuono, può usare Incanalare Divinità per infliggere il massimo danno possibile invece di tirare i dadi.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'maximum_damage',
      'lightning',
      'thunder',
    },
  ),
  'thunderbolt_strike': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'thunderbolt_strike',
    name: 'Colpo del Fulmine',
    summary:
        'I danni da fulmine possono spingere una creatura lontano dal Chierico.',
    details:
        'Dal 6° livello, quando infligge danni da fulmine a una creatura di taglia Grande o inferiore, il Chierico può spingerla fino a 3 metri lontano da sé.',
    ruleTags: {
      'lightning_damage',
      'push_3_meters',
      'large_or_smaller',
    },
  ),
  'divine_strike_tempest': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'divine_strike_tempest',
    name: 'Colpo Divino',
    summary: 'Un colpo con arma infligge danni da tuono aggiuntivi.',
    details:
        'Dall’8° livello, una volta per turno quando colpisce con un attacco con arma, infligge 1d8 danni da tuono aggiuntivi. Il danno aumenta a 2d8 al 14° livello.',
    ruleTags: {
      'weapon_attack',
      'thunder_damage',
      'once_per_turn',
      'damage_1d8',
      'damage_2d8_at_14',
    },
  ),
  'stormborn': _clericDomainFeature(
    domainId: ClericSubclassIds.tempest,
    id: 'stormborn',
    name: 'Nato dalla Tempesta',
    summary:
        'Il Chierico ottiene una velocità di volare quando si trova all’aperto.',
    details:
        'Dal 17° livello, quando si trova all’aperto e non sottoterra, il Chierico possiede una velocità di volare pari alla propria velocità base sul terreno.',
    ruleTags: {
      'flying_speed_equals_walking_speed',
      'outdoors',
      'not_underground',
    },
  ),
};

final clericTrickeryDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'blessing_of_the_trickster': _clericDomainFeature(
    domainId: ClericSubclassIds.trickery,
    id: 'blessing_of_the_trickster',
    name: 'Benedizione dell’Ingannatore',
    summary:
        'Il Chierico concede vantaggio alle prove di Furtività di un alleato.',
    details:
        'Dal 1° livello usa un’azione per toccare una creatura consenziente diversa da sé. La creatura dispone di vantaggio alle prove di Destrezza (Furtività) per 1 ora o finché il Chierico non usa nuovamente il privilegio.',
    ruleTags: {
      'action',
      'touch',
      'ally_only',
      'stealth_advantage',
      'duration_1_hour',
    },
  ),
  'invoke_duplicity': _clericDomainFeature(
    domainId: ClericSubclassIds.trickery,
    id: 'invoke_duplicity',
    name: 'Incanalare Divinità: Invocare Duplicato',
    summary:
        'Il Chierico crea un duplicato illusorio che può fungere da origine degli incantesimi.',
    details:
        'Dal 2° livello usa Incanalare Divinità come azione per creare un duplicato illusorio entro 9 metri, mantenendo la concentrazione fino a 1 minuto. Può spostarlo fino a 9 metri con un’azione bonus, lanciare incantesimi come se si trovasse nella sua posizione e ottenere vantaggio agli attacchi se entrambi sono entro 1,5 metri dal bersaglio.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'range_9_meters',
      'concentration',
      'duration_1_minute',
      'bonus_action_move',
      'spell_origin',
      'attack_advantage',
    },
  ),
  'cloak_of_shadows': _clericDomainFeature(
    domainId: ClericSubclassIds.trickery,
    id: 'cloak_of_shadows',
    name: 'Incanalare Divinità: Manto di Ombre',
    summary: 'Il Chierico diventa invisibile per un breve periodo.',
    details:
        'Dal 6° livello usa Incanalare Divinità come azione per diventare invisibile fino alla fine del proprio turno successivo. L’effetto termina anticipatamente se attacca o lancia un incantesimo.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'invisible',
      'ends_on_attack',
      'ends_on_spell',
    },
  ),
  'divine_strike_trickery': _clericDomainFeature(
    domainId: ClericSubclassIds.trickery,
    id: 'divine_strike_trickery',
    name: 'Colpo Divino',
    summary: 'Un colpo con arma infligge danni da veleno aggiuntivi.',
    details:
        'Dall’8° livello, una volta per turno quando colpisce con un attacco con arma, infligge 1d8 danni da veleno aggiuntivi. Il danno aumenta a 2d8 al 14° livello.',
    ruleTags: {
      'weapon_attack',
      'poison_damage',
      'once_per_turn',
      'damage_1d8',
      'damage_2d8_at_14',
    },
  ),
  'improved_duplicity': _clericDomainFeature(
    domainId: ClericSubclassIds.trickery,
    id: 'improved_duplicity',
    name: 'Duplicato Migliorato',
    summary: 'Invocare Duplicato crea quattro duplicati invece di uno.',
    details:
        'Dal 17° livello, quando usa Invocare Duplicato, il Chierico può creare fino a quattro duplicati e muoverne un qualsiasi numero con la stessa azione bonus.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'invoke_duplicity',
      'four_duplicates',
      'bonus_action_move',
    },
  ),
};

final clericWarDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'bonus_proficiencies_war': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'bonus_proficiencies_war',
    name: 'Competenze Bonus',
    summary:
        'Il Chierico acquisisce competenza nelle armi da guerra e nelle armature pesanti.',
    details:
        'Al 1° livello il Dominio della Guerra concede competenza nelle armi da guerra e nelle armature pesanti.',
    effects: const CharacterEffects(
      weaponProficiencies: {
        'martial_weapons',
      },
      armorProficiencies: {
        'heavy_armor',
      },
    ),
    ruleTags: {
      'weapon_proficiency',
      'martial_weapons',
      'armor_proficiency',
      'heavy_armor',
    },
  ),
  'war_priest': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'war_priest',
    name: 'Prete della Guerra',
    summary:
        'Dopo aver attaccato, il Chierico può effettuare un altro attacco come azione bonus.',
    details:
        'Dal 1° livello, quando usa l’azione Attaccare, può effettuare un attacco con arma come azione bonus. Può farlo un numero di volte pari al modificatore di Saggezza, con un minimo di una volta, recuperando gli utilizzi dopo un riposo lungo.',
    resourceId: 'war_priest',
    ruleTags: {
      'attack_action',
      'bonus_action_attack',
      'wisdom_modifier_uses',
      'long_rest',
    },
  ),
  'guided_strike': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'guided_strike',
    name: 'Incanalare Divinità: Colpo Guidato',
    summary: 'Il Chierico aggiunge +10 a un proprio tiro per colpire.',
    details:
        'Dal 2° livello, dopo aver effettuato un tiro per colpire ma prima che il DM dichiari l’esito, può usare Incanalare Divinità per ottenere un bonus di +10 al tiro.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'attack_roll',
      'bonus_10',
      'after_roll_before_result',
    },
  ),
  'war_gods_blessing': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'war_gods_blessing',
    name: 'Incanalare Divinità: Benedizione del Dio della Guerra',
    summary: 'Il Chierico concede +10 al tiro per colpire di un alleato.',
    details:
        'Dal 6° livello, quando una creatura entro 9 metri effettua un tiro per colpire, il Chierico può usare la reazione e Incanalare Divinità per concedere un bonus di +10 al tiro.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'reaction',
      'range_9_meters',
      'ally_attack_roll',
      'bonus_10',
    },
  ),
  'divine_strike_war': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'divine_strike_war',
    name: 'Colpo Divino',
    summary:
        'Un colpo con arma infligge danni aggiuntivi dello stesso tipo dell’arma.',
    details:
        'Dall’8° livello, una volta per turno quando colpisce con un attacco con arma, infligge 1d8 danni aggiuntivi dello stesso tipo dell’arma. Il danno aumenta a 2d8 al 14° livello.',
    ruleTags: {
      'weapon_attack',
      'weapon_damage_type',
      'once_per_turn',
      'damage_1d8',
      'damage_2d8_at_14',
    },
  ),
  'avatar_of_battle': _clericDomainFeature(
    domainId: ClericSubclassIds.war,
    id: 'avatar_of_battle',
    name: 'Avatar della Battaglia',
    summary: 'Il Chierico resiste ai danni fisici delle armi non magiche.',
    details:
        'Dal 17° livello il Chierico possiede resistenza ai danni contundenti, perforanti e taglienti inflitti da armi non magiche.',
    ruleTags: {
      'conditional_damage_resistance',
      'nonmagical_weapons',
      'bludgeoning',
      'piercing',
      'slashing',
    },
  ),
};

final clericTempestDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.tempest,
  name: 'Dominio della Tempesta',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.tempest,
    name: 'Dominio della Tempesta',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato alle tempeste, ai fulmini, ai tuoni e alla furia del cielo.',
      details:
          'I suoi Chierici indossano armature pesanti e scatenano fulmini, tuoni e venti impetuosi.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: [
      'bonus_proficiencies_tempest',
      'wrath_of_the_storm',
    ],
    2: ['destructive_wrath'],
    6: ['thunderbolt_strike'],
    8: ['divine_strike_tempest'],
    17: ['stormborn'],
  },
  featureDefinitions: clericTempestDomainFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'tempest_wrath_of_the_storm',
      name: 'Ira della Tempesta',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'SAG',
      minimumMaximum: 1,
    ),
  ],
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.fogCloud,
      SpellIds.thunderwave,
    },
    3: {
      SpellIds.gustOfWind,
      SpellIds.shatter,
    },
    5: {
      SpellIds.callLightning,
      SpellIds.sleetStorm,
    },
    7: {
      SpellIds.controlWater,
      SpellIds.iceStorm,
    },
    9: {
      SpellIds.destructiveWave,
      SpellIds.insectPlague,
    },
  },
);

final clericTrickeryDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.trickery,
  name: 'Dominio dell’Inganno',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.trickery,
    name: 'Dominio dell’Inganno',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato all’inganno, alle illusioni, alla furtività e al mutamento.',
      details:
          'I suoi Chierici confondono i nemici, creano duplicati illusori e proteggono gli alleati più furtivi.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: ['blessing_of_the_trickster'],
    2: ['invoke_duplicity'],
    6: ['cloak_of_shadows'],
    8: ['divine_strike_trickery'],
    17: ['improved_duplicity'],
  },
  featureDefinitions: clericTrickeryDomainFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.charmPerson,
      SpellIds.disguiseSelf,
    },
    3: {
      SpellIds.mirrorImage,
      SpellIds.passWithoutTrace,
    },
    5: {
      SpellIds.blink,
      SpellIds.dispelMagic,
    },
    7: {
      SpellIds.dimensionDoor,
      SpellIds.polymorph,
    },
    9: {
      SpellIds.dominatePerson,
      SpellIds.modifyMemory,
    },
  },
);

final clericWarDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.war,
  name: 'Dominio della Guerra',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.war,
    name: 'Dominio della Guerra',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato alla guerra, al valore e alla superiorità marziale.',
      details:
          'I suoi Chierici combattono in armatura pesante, guidano gli attacchi e resistono alle armi comuni.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: [
      'bonus_proficiencies_war',
      'war_priest',
    ],
    2: ['guided_strike'],
    6: ['war_gods_blessing'],
    8: ['divine_strike_war'],
    17: ['avatar_of_battle'],
  },
  featureDefinitions: clericWarDomainFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'war_priest',
      name: 'Prete della Guerra',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'SAG',
      minimumMaximum: 1,
    ),
  ],
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.divineFavor,
      SpellIds.shieldOfFaith,
    },
    3: {
      SpellIds.magicWeapon,
      SpellIds.spiritualWeapon,
    },
    5: {
      SpellIds.crusadersMantle,
      SpellIds.spiritGuardians,
    },
    7: {
      SpellIds.freedomOfMovement,
      SpellIds.stoneskin,
    },
    9: {
      SpellIds.flameStrike,
      SpellIds.holdMonster,
    },
  },
);

final clericLightDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'bonus_cantrip_light': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'bonus_cantrip_light',
    name: 'Trucchetto Bonus',
    summary: 'Il Chierico apprende il trucchetto Luce.',
    details:
        'Al 1° livello il Chierico apprende Luce, se non lo conosce già. Il trucchetto non conta nel numero di trucchetti da Chierico conosciuti.',
    spellIds: {
      SpellIds.light,
    },
    effects: const CharacterEffects(
      grantedCantripIds: [
        SpellIds.light,
      ],
    ),
    ruleTags: {
      'bonus_cantrip',
      'does_not_count_against_cantrips_known',
    },
  ),
  'warding_flare': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'warding_flare',
    name: 'Interdizione Luminosa',
    summary:
        'Il Chierico impone svantaggio a un attacco sprigionando luce divina.',
    details:
        'Dal 1° livello, quando una creatura entro 9 metri che il Chierico può vedere effettua un attacco contro di lui, può usare la reazione per imporre svantaggio. Può farlo un numero di volte pari al modificatore di Saggezza, con un minimo di una volta, recuperando gli utilizzi dopo un riposo lungo.',
    resourceId: 'light_warding_flare',
    ruleTags: {
      'reaction',
      'range_9_meters',
      'attack_disadvantage',
      'wisdom_modifier_uses',
      'long_rest',
    },
  ),
  'radiance_of_the_dawn': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'radiance_of_the_dawn',
    name: 'Incanalare Divinità: Fulgore dell’Alba',
    summary:
        'Il Chierico disperde l’oscurità e infligge danni radiosi ai nemici.',
    details:
        'Dal 2° livello usa Incanalare Divinità come azione per dissolvere l’oscurità magica entro 9 metri. Le creature ostili nell’area effettuano un tiro salvezza di Costituzione, subendo 2d10 più il livello da Chierico danni radiosi in caso di fallimento, o la metà in caso di successo.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'range_9_meters',
      'constitution_save',
      'radiant_damage',
      'damage_2d10_plus_cleric_level',
      'magical_darkness',
    },
  ),
  'improved_flare': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'improved_flare',
    name: 'Interdizione Luminosa Migliorata',
    summary:
        'Il Chierico può proteggere con Interdizione Luminosa anche un alleato.',
    details:
        'Dal 6° livello può usare Interdizione Luminosa quando una creatura entro 9 metri attacca un’altra creatura che il Chierico può vedere.',
    resourceId: 'light_warding_flare',
    ruleTags: {
      'reaction',
      'range_9_meters',
      'protect_ally',
      'attack_disadvantage',
    },
  ),
  'potent_spellcasting_light': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'potent_spellcasting_light',
    name: 'Incantesimi Potenti',
    summary:
        'Il Chierico aggiunge il modificatore di Saggezza ai danni dei trucchetti.',
    details:
        'Dall’8° livello aggiunge il modificatore di Saggezza ai danni inflitti da qualsiasi trucchetto da Chierico.',
    ruleTags: {
      'cantrip_damage',
      'wisdom_modifier',
    },
  ),
  'corona_of_light': _clericDomainFeature(
    domainId: ClericSubclassIds.light,
    id: 'corona_of_light',
    name: 'Corona di Luce',
    summary:
        'Il Chierico emette luce solare che rende vulnerabili agli effetti di fuoco e radiosi.',
    details:
        'Dal 17° livello può usare un’azione per attivare un’aura di luce solare del raggio di 18 metri. I nemici nell’area subiscono svantaggio ai tiri salvezza contro gli incantesimi che infliggono danni da fuoco o radiosi.',
    ruleTags: {
      'action',
      'aura_18_meters',
      'sunlight',
      'fire_save_disadvantage',
      'radiant_save_disadvantage',
    },
  ),
};

final clericNatureDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'acolyte_of_nature': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'acolyte_of_nature',
    name: 'Accolito della Natura',
    summary:
        'Il Chierico apprende un trucchetto da Druido e una competenza legata alla natura.',
    details:
        'Al 1° livello apprende un trucchetto da Druido a sua scelta e ottiene competenza in una tra Addestrare Animali, Natura e Sopravvivenza. Il trucchetto usa Saggezza come caratteristica da incantatore.',
    choices: [
      CharacterChoiceDefinition(
        id: 'nature_domain_druid_cantrip',
        label: 'Scegli un trucchetto da Druido',
        type: CharacterChoiceType.cantrip,
        catalogId: 'spell',
        optionIds: _natureDomainDruidCantripIds,
        requireNewAcquisition: true,
      ),
      const CharacterChoiceDefinition(
        id: 'nature_domain_skill',
        label: 'Scegli una competenza della Natura',
        type: CharacterChoiceType.skill,
        catalogId: 'skill',
        optionIds: _natureDomainSkillIds,
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'druid_cantrip',
      'wisdom_spellcasting',
      'skill_proficiency',
    },
  ),
  'bonus_proficiency_nature': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'bonus_proficiency_nature',
    name: 'Competenza Bonus',
    summary: 'Il Chierico acquisisce competenza nelle armature pesanti.',
    details:
        'Al 1° livello il Dominio della Natura concede competenza nelle armature pesanti.',
    effects: const CharacterEffects(
      armorProficiencies: {
        'heavy_armor',
      },
    ),
    ruleTags: {
      'armor_proficiency',
      'heavy_armor',
    },
  ),
  'charm_animals_and_plants': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'charm_animals_and_plants',
    name: 'Incanalare Divinità: Affascinare Animali e Vegetali',
    summary:
        'Il Chierico affascina bestie e creature vegetali nelle vicinanze.',
    details:
        'Dal 2° livello usa Incanalare Divinità come azione. Ogni bestia o creatura vegetale entro 9 metri effettua un tiro salvezza di Saggezza; in caso di fallimento è affascinata per 1 minuto o finché non subisce danni.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'range_9_meters',
      'wisdom_save',
      'beast',
      'plant',
      'charmed',
    },
  ),
  'dampen_elements': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'dampen_elements',
    name: 'Smorzare Elementi',
    summary:
        'Il Chierico concede temporaneamente resistenza a un danno elementale.',
    details:
        'Dal 6° livello, quando il Chierico o una creatura entro 9 metri subisce danni da acido, freddo, fuoco, fulmine o tuono, può usare la reazione per concedere resistenza a quella istanza di danno.',
    ruleTags: {
      'reaction',
      'range_9_meters',
      'temporary_damage_resistance',
      'acid',
      'cold',
      'fire',
      'lightning',
      'thunder',
    },
  ),
  'divine_strike_nature': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'divine_strike_nature',
    name: 'Colpo Divino',
    summary: 'Un colpo con arma infligge danni elementali aggiuntivi.',
    details:
        'Dall’8° livello, una volta per turno quando colpisce con un attacco con arma, infligge 1d8 danni aggiuntivi da freddo, fuoco o fulmine a sua scelta. Il danno aumenta a 2d8 al 14° livello.',
    ruleTags: {
      'weapon_attack',
      'once_per_turn',
      'cold_fire_or_lightning',
      'damage_1d8',
      'damage_2d8_at_14',
    },
  ),
  'master_of_nature': _clericDomainFeature(
    domainId: ClericSubclassIds.nature,
    id: 'master_of_nature',
    name: 'Maestro della Natura',
    summary:
        'Il Chierico può comandare le creature affascinate dal proprio potere divino.',
    details:
        'Dal 17° livello, mentre una creatura è affascinata da Affascinare Animali e Vegetali, il Chierico può usare un’azione bonus nel proprio turno per comandare verbalmente ciò che ciascuna creatura deve fare nel turno successivo.',
    ruleTags: {
      'bonus_action',
      'command_charmed_creatures',
      'beast',
      'plant',
    },
  ),
};

final clericLightDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.light,
  name: 'Dominio della Luce',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.light,
    name: 'Dominio della Luce',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio di luce, rinnovamento, verità e distruzione delle tenebre.',
      details:
          'I suoi Chierici manipolano la luce divina per proteggere gli alleati e bruciare i nemici.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: [
      'bonus_cantrip_light',
      'warding_flare',
    ],
    2: ['radiance_of_the_dawn'],
    6: ['improved_flare'],
    8: ['potent_spellcasting_light'],
    17: ['corona_of_light'],
  },
  featureDefinitions: clericLightDomainFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'light_warding_flare',
      name: 'Interdizione Luminosa',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'SAG',
      minimumMaximum: 1,
    ),
  ],
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.burningHands,
      SpellIds.faerieFire,
    },
    3: {
      SpellIds.flamingSphere,
      SpellIds.scorchingRay,
    },
    5: {
      SpellIds.daylight,
      SpellIds.fireball,
    },
    7: {
      SpellIds.guardianOfFaith,
      SpellIds.wallOfFire,
    },
    9: {
      SpellIds.flameStrike,
      SpellIds.scrying,
    },
  },
);

final clericNatureDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.nature,
  name: 'Dominio della Natura',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.nature,
    name: 'Dominio della Natura',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato al mondo naturale, agli animali e alle forze elementali.',
      details:
          'I suoi Chierici apprendono magia druidica, dominano animali e vegetali e proteggono dagli elementi.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: [
      'acolyte_of_nature',
      'bonus_proficiency_nature',
    ],
    2: ['charm_animals_and_plants'],
    6: ['dampen_elements'],
    8: ['divine_strike_nature'],
    17: ['master_of_nature'],
  },
  featureDefinitions: clericNatureDomainFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.animalFriendship,
      SpellIds.speakWithAnimals,
    },
    3: {
      SpellIds.barkskin,
      SpellIds.spikeGrowth,
    },
    5: {
      SpellIds.plantGrowth,
      SpellIds.windWall,
    },
    7: {
      SpellIds.dominateBeast,
      SpellIds.graspingVine,
    },
    9: {
      SpellIds.insectPlague,
      SpellIds.treeStride,
    },
  },
);

final clericKnowledgeDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'blessings_of_knowledge': _clericDomainFeature(
    domainId: ClericSubclassIds.knowledge,
    id: 'blessings_of_knowledge',
    name: 'Benedizioni della Conoscenza',
    summary:
        'Il Chierico apprende due linguaggi e ottiene una competenza superiore in due discipline accademiche.',
    details:
        'Al 1° livello sceglie due linguaggi e due abilità tra Arcano, Storia, Natura e Religione. Per le prove effettuate con le abilità scelte raddoppia il bonus di competenza.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'knowledge_domain_languages',
        label: 'Scegli due linguaggi',
        type: CharacterChoiceType.language,
        catalogId: 'language',
        minimumSelections: 2,
        maximumSelections: 2,
        optionIds: characterLanguageIds,
        requireNewAcquisition: true,
      ),
      CharacterChoiceDefinition(
        id: 'knowledge_domain_skills',
        label: 'Scegli due abilità della Conoscenza',
        type: CharacterChoiceType.skill,
        catalogId: 'skill',
        minimumSelections: 2,
        maximumSelections: 2,
        optionIds: _knowledgeDomainSkillIds,
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'language_proficiency',
      'skill_proficiency',
      'expertise',
      'double_proficiency',
    },
  ),
  'knowledge_of_the_ages': _clericDomainFeature(
    domainId: ClericSubclassIds.knowledge,
    id: 'knowledge_of_the_ages',
    name: 'Incanalare Divinità: Conoscenze Secolari',
    summary:
        'Il Chierico ottiene temporaneamente competenza in un’abilità o uno strumento.',
    details:
        'Dal 2° livello usa Incanalare Divinità per ottenere per 10 minuti competenza in un’abilità o in uno strumento a sua scelta.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'temporary_proficiency',
      'duration_10_minutes',
    },
  ),
  'read_thoughts': _clericDomainFeature(
    domainId: ClericSubclassIds.knowledge,
    id: 'read_thoughts',
    name: 'Incanalare Divinità: Lettura del Pensiero',
    summary:
        'Il Chierico legge i pensieri superficiali e può impartire una suggestione.',
    details:
        'Dal 6° livello usa Incanalare Divinità su una creatura entro 18 metri. Se il bersaglio fallisce un tiro salvezza di Saggezza, il Chierico ne legge i pensieri superficiali e può lanciare Suggestione senza consumare uno slot.',
    resourceId: 'channel_divinity',
    spellIds: {
      SpellIds.suggestion,
    },
    ruleTags: {
      'channel_divinity',
      'action',
      'range_18_meters',
      'wisdom_save',
      'thought_reading',
      'spell_without_slot',
    },
  ),
  'potent_spellcasting_knowledge': _clericDomainFeature(
    domainId: ClericSubclassIds.knowledge,
    id: 'potent_spellcasting_knowledge',
    name: 'Incantesimi Potenti',
    summary:
        'Il Chierico aggiunge il modificatore di Saggezza ai danni dei trucchetti.',
    details:
        'Dall’8° livello aggiunge il modificatore di Saggezza ai danni inflitti da qualsiasi trucchetto da Chierico.',
    ruleTags: {
      'cantrip_damage',
      'wisdom_modifier',
    },
  ),
  'visions_of_the_past': _clericDomainFeature(
    domainId: ClericSubclassIds.knowledge,
    id: 'visions_of_the_past',
    name: 'Visioni del Passato',
    summary: 'Il Chierico riceve visioni relative a un oggetto o a un luogo.',
    details:
        'Dal 17° livello, dopo almeno 1 minuto di meditazione, può leggere le impressioni psichiche lasciate su un oggetto o in un luogo. La durata massima della lettura è pari al modificatore di Saggezza in minuti.',
    ruleTags: {
      'object_reading',
      'area_reading',
      'wisdom_modifier',
      'short_rest_recharge',
    },
  ),
};

final clericLifeDomainFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'bonus_proficiency_life': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'bonus_proficiency_life',
    name: 'Competenza Bonus',
    summary: 'Il Chierico acquisisce competenza nelle armature pesanti.',
    details:
        'Al 1° livello il Dominio della Vita concede competenza nelle armature pesanti.',
    effects: const CharacterEffects(
      armorProficiencies: {
        'heavy_armor',
      },
    ),
    ruleTags: {
      'armor_proficiency',
      'heavy_armor',
    },
  ),
  'disciple_of_life': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'disciple_of_life',
    name: 'Discepolo della Vita',
    summary:
        'Gli incantesimi curativi del Chierico ripristinano più punti ferita.',
    details:
        'Dal 1° livello, quando usa un incantesimo di 1° livello o superiore per ripristinare punti ferita, il bersaglio recupera punti ferita aggiuntivi pari a 2 più il livello dell’incantesimo.',
    ruleTags: {
      'healing',
      'spell_level_bonus',
      'healing_bonus_2_plus_spell_level',
    },
  ),
  'preserve_life': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'preserve_life',
    name: 'Incanalare Divinità: Preservare la Vita',
    summary: 'Il Chierico distribuisce energia curativa tra creature ferite.',
    details:
        'Dal 2° livello usa Incanalare Divinità per distribuire punti ferita pari a cinque volte il proprio livello da Chierico tra creature entro 9 metri. Una creatura non può essere curata oltre la metà dei suoi punti ferita massimi.',
    resourceId: 'channel_divinity',
    ruleTags: {
      'channel_divinity',
      'action',
      'healing',
      'range_9_meters',
      'five_times_cleric_level',
      'half_hit_points_limit',
    },
  ),
  'blessed_healer': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'blessed_healer',
    name: 'Guaritore Benedetto',
    summary: 'Curare un’altra creatura cura anche il Chierico.',
    details:
        'Dal 6° livello, quando lancia un incantesimo di 1° livello o superiore che ripristina punti ferita a una creatura diversa da sé, recupera punti ferita pari a 2 più il livello dell’incantesimo.',
    ruleTags: {
      'self_healing',
      'healing_spell',
      'healing_bonus_2_plus_spell_level',
    },
  ),
  'divine_strike_life': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'divine_strike_life',
    name: 'Colpo Divino',
    summary: 'Un colpo con arma infligge danni radiosi aggiuntivi.',
    details:
        'Dall’8° livello, una volta per turno quando colpisce con un attacco con arma, infligge 1d8 danni radiosi aggiuntivi. Il danno aumenta a 2d8 al 14° livello.',
    ruleTags: {
      'weapon_attack',
      'radiant_damage',
      'once_per_turn',
      'damage_1d8',
      'damage_2d8_at_14',
    },
  ),
  'supreme_healing': _clericDomainFeature(
    domainId: ClericSubclassIds.life,
    id: 'supreme_healing',
    name: 'Guarigione Suprema',
    summary:
        'Gli incantesimi curativi ripristinano sempre il massimo possibile.',
    details:
        'Dal 17° livello, quando il Chierico dovrebbe tirare uno o più dadi per determinare i punti ferita ripristinati da un incantesimo, considera ogni dado come se avesse ottenuto il risultato massimo.',
    ruleTags: {
      'healing',
      'maximum_healing_dice',
    },
  ),
};

final clericKnowledgeDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.knowledge,
  name: 'Dominio della Conoscenza',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.knowledge,
    name: 'Dominio della Conoscenza',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato alla sapienza, alla memoria e alla scoperta dei segreti.',
      details:
          'I suoi Chierici padroneggiano linguaggi e discipline accademiche, leggono pensieri e ricevono visioni del passato.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: ['blessings_of_knowledge'],
    2: ['knowledge_of_the_ages'],
    6: ['read_thoughts'],
    8: ['potent_spellcasting_knowledge'],
    17: ['visions_of_the_past'],
  },
  featureDefinitions: clericKnowledgeDomainFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.command,
      SpellIds.identify,
    },
    3: {
      SpellIds.augury,
      SpellIds.suggestion,
    },
    5: {
      SpellIds.nondetection,
      SpellIds.speakWithDead,
    },
    7: {
      SpellIds.arcaneEye,
      SpellIds.confusion,
    },
    9: {
      SpellIds.legendLore,
      SpellIds.scrying,
    },
  },
);

final clericLifeDomainDefinition = CharacterSubclassDefinition(
  id: ClericSubclassIds.life,
  name: 'Dominio della Vita',
  classId: ClassIds.cleric,
  content: const RuleContent(
    id: ClericSubclassIds.life,
    name: 'Dominio della Vita',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un dominio dedicato alla vitalità, alla guarigione e alla protezione.',
      details:
          'I suoi Chierici indossano armature pesanti, rafforzano le cure e preservano la vita dei compagni.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  featuresByLevel: const {
    1: [
      'bonus_proficiency_life',
      'disciple_of_life',
    ],
    2: ['preserve_life'],
    6: ['blessed_healer'],
    8: ['divine_strike_life'],
    17: ['supreme_healing'],
  },
  featureDefinitions: clericLifeDomainFeatureDefinitions,
  alwaysPreparedSpellIdsByLevel: const {
    1: {
      SpellIds.bless,
      SpellIds.cureWounds,
    },
    3: {
      SpellIds.lesserRestoration,
      SpellIds.spiritualWeapon,
    },
    5: {
      SpellIds.beaconOfHope,
      SpellIds.revivify,
    },
    7: {
      SpellIds.deathWard,
      SpellIds.guardianOfFaith,
    },
    9: {
      SpellIds.massCureWounds,
      SpellIds.raiseDead,
    },
  },
);

final clericClassDefinition = CharacterClassDefinition(
  id: ClassIds.cleric,
  name: 'Chierico',
  content: const RuleContent(
    id: ClassIds.cleric,
    name: 'Chierico',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un sacerdote guerriero che incanala il potere divino attraverso fede e preghiera.',
      details:
          'Il Chierico prepara incantesimi divini, scaccia i non morti e riceve capacità specifiche dal dominio della propria divinità.',
    ),
    source: _phbClericSource,
    ownerId: ClassIds.cleric,
  ),
  hitDie: 8,
  proficiencies: const ClassProficiencyDefinition(
    armor: {
      'light_armor',
      'medium_armor',
      'shield',
    },
    weapons: {
      'simple_weapons',
    },
    savingThrows: {
      'SAG',
      'CAR',
    },
    skillOptions: _clericSkillIds,
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'cleric_skills',
        label: 'Scegli due abilità da Chierico',
        type: ClassProficiencyChoiceType.skill,
        optionIds: _clericSkillIds,
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    const ClassEquipmentChoice(
      id: 'cleric_primary_weapon',
      label: 'Scegli l’arma iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'cleric_mace',
          label: 'Mazza',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'mace',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'cleric_warhammer',
          label: 'Martello da Guerra, se competente',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'warhammer',
            ),
          ],
          requiredProficiencyIds: {
            'martial_weapons',
          },
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'cleric_starting_armor',
      label: 'Scegli l’armatura iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'cleric_scale_mail',
          label: 'Corazza di Scaglie',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: 'scale_mail',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'cleric_leather_armor',
          label: 'Armatura di Cuoio',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: 'leather',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'cleric_chain_mail',
          label: 'Cotta di Maglia, se competente',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: 'chain_mail',
            ),
          ],
          requiredProficiencyIds: {
            'heavy_armor',
          },
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'cleric_secondary_weapon',
      label: 'Scegli l’arma secondaria',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'cleric_light_crossbow',
          label: 'Balestra Leggera e 20 Quadrelli',
          grants: [
            const ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'light_crossbow',
            ),
            ClassEquipmentGrant(
              catalogId: 'ammunition',
              itemId: _clericBoltId,
              quantity: 20,
            ),
          ],
        ),
        ..._clericSimpleWeaponAlternatives,
      ],
    ),
    const ClassEquipmentChoice(
      id: 'cleric_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'cleric_priest_pack',
          label: 'Dotazione da Sacerdote',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: 'priest_pack',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'cleric_explorer_pack',
          label: 'Dotazione da Esploratore',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: 'explorer_pack',
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'cleric_holy_symbol',
      label: 'Scegli il simbolo sacro',
      alternatives: _clericHolySymbolAlternatives,
    ),
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'armor',
      itemId: 'shield',
    ),
  ],
  featuresByLevel: const {
    1: [
      'spellcasting',
      'divine_domain',
    ],
    2: [
      'channel_divinity',
      'turn_undead',
    ],
    4: [
      'ability_score_improvement',
    ],
    5: [
      'destroy_undead',
    ],
    8: [
      'ability_score_improvement',
    ],
    10: [
      'divine_intervention',
    ],
    12: [
      'ability_score_improvement',
    ],
    16: [
      'ability_score_improvement',
    ],
    19: [
      'ability_score_improvement',
    ],
    20: [
      'divine_intervention_improvement',
    ],
  },
  featureDefinitions: clericFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'channel_divinity',
      name: 'Incanalare Divinità',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        2: 1,
        6: 2,
        18: 3,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'destroy_undead_cr',
      name: 'Grado di Sfida di Distruggere Non Morti',
      valuesByLevel: {
        5: '1/2',
        8: '1',
        11: '2',
        14: '3',
        17: '4',
      },
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.full,
    ability: 'SAG',
    minimumLevel: 1,
    ritualCasting: true,
    preparesSpells: true,
    spellIds: _clericSpellIds,
    preparedSpellLevelDivisor: 1,
    minimumPreparedSpells: 1,
    cantripsKnownByLevel: const {
      1: 3,
      4: 4,
      10: 5,
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
  subclassSelectionLevel: 1,
  subclasses: {
    ClericSubclassIds.knowledge: clericKnowledgeDomainDefinition,
    ClericSubclassIds.war: clericWarDomainDefinition,
    ClericSubclassIds.trickery: clericTrickeryDomainDefinition,
    ClericSubclassIds.light: clericLightDomainDefinition,
    ClericSubclassIds.nature: clericNatureDomainDefinition,
    ClericSubclassIds.tempest: clericTempestDomainDefinition,
    ClericSubclassIds.life: clericLifeDomainDefinition,
  },
);
