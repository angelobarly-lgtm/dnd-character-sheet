import 'class_catalog_data.dart';
import 'class_data.dart';
import 'weapon_data.dart';

const _phbBarbarianSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 46-50',
);

const _barbarianFeatureSpecs = <String, List<String>>{
  'rage': [
    'Ira',
    'Il Barbaro entra in uno stato di furia combattiva che aumenta la sua potenza e resistenza.',
    'Come azione bonus, finché non indossa un’armatura pesante, ottiene vantaggio alle prove e ai tiri salvezza di Forza, un bonus ai danni degli attacchi con armi da mischia basati su Forza e resistenza ai danni contundenti, perforanti e taglienti. Durante l’Ira non può lanciare incantesimi né concentrarsi su di essi. L’Ira dura 1 minuto e termina anticipatamente se perde i sensi o conclude un turno senza avere attaccato una creatura ostile dal turno precedente e senza avere subito danni; può anche terminarla come azione bonus.',
  ],
  'unarmored_defense': [
    'Difesa Senza Armatura',
    'Il Barbaro può affidarsi a Destrezza e Costituzione per difendersi.',
    'Quando non indossa armatura, la sua Classe Armatura è pari a 10 + modificatore di Destrezza + modificatore di Costituzione. Può comunque utilizzare uno scudo.',
  ],
  'reckless_attack': [
    'Attacco Irruento',
    'Il Barbaro può attaccare senza curarsi della propria difesa.',
    'Dal 2° livello, quando effettua il primo attacco del turno, può ottenere vantaggio agli attacchi in mischia basati su Forza durante quel turno. In cambio, gli attacchi contro di lui hanno vantaggio fino al suo turno successivo.',
  ],
  'danger_sense': [
    'Percezione del Pericolo',
    'Il Barbaro reagisce istintivamente ai pericoli visibili.',
    'Dal 2° livello ottiene vantaggio ai tiri salvezza di Destrezza contro effetti che può vedere, purché non sia accecato, assordato o incapacitato.',
  ],
  'primal_path': [
    'Cammino Primordiale',
    'Il Barbaro sceglie il cammino che definisce la natura della propria furia.',
    'Al 3° livello sceglie un Cammino Primordiale, che concede privilegi al 3°, 6°, 10° e 14° livello.',
  ],
  'ability_score_improvement': [
    'Aumento dei Punteggi di Caratteristica',
    'Il Barbaro può aumentare i punteggi di caratteristica o scegliere un talento.',
    'Il privilegio viene ottenuto ai livelli 4, 8, 12, 16 e 19 secondo le regole generali di avanzamento.',
  ],
  'extra_attack': [
    'Attacco Extra',
    'Il Barbaro può attaccare due volte con l’azione di Attacco.',
    'Dal 5° livello effettua due attacchi anziché uno ogni volta che usa l’azione di Attacco nel proprio turno.',
  ],
  'fast_movement': [
    'Movimento Veloce',
    'La velocità del Barbaro aumenta di 3 metri.',
    'Dal 5° livello la velocità aumenta di 3 metri purché il Barbaro non indossi un’armatura pesante.',
  ],
  'feral_instinct': [
    'Istinto Ferino',
    'Gli istinti del Barbaro gli permettono di agire rapidamente.',
    'Dal 7° livello ottiene vantaggio ai tiri di iniziativa. Se è sorpreso e non è incapacitato, può agire normalmente nel primo turno soltanto se entra in Ira prima di fare qualsiasi altra cosa.',
  ],
  'brutal_critical': [
    'Critico Brutale',
    'I colpi critici del Barbaro infliggono dadi di danno aggiuntivi.',
    'Dal 9° livello aggiunge un dado dell’arma ai danni dei colpi critici. I dadi aggiuntivi diventano due al 13° livello e tre al 17° livello.',
  ],
  'relentless_rage': [
    'Ira Implacabile',
    'Il Barbaro può continuare a combattere quando dovrebbe cadere a 0 punti ferita.',
    'Dall’11° livello, se scende a 0 punti ferita mentre è in Ira e non viene ucciso sul colpo, può effettuare un tiro salvezza di Costituzione con CD 10 per restare a 1 punto ferita. La CD aumenta di 5 dopo ogni utilizzo successivo e torna a 10 dopo un riposo breve o lungo.',
  ],
  'persistent_rage': [
    'Ira Persistente',
    'L’Ira termina anticipatamente soltanto se il Barbaro lo decide o perde conoscenza.',
    'Dal 15° livello l’Ira non termina più perché il Barbaro non ha attaccato una creatura o non ha subito danni.',
  ],
  'indomitable_might': [
    'Potenza Indomabile',
    'La Forza del Barbaro stabilisce un risultato minimo per alcune prove.',
    'Dal 18° livello, se il totale di una prova di Forza è inferiore al punteggio di Forza, può usare quel punteggio al posto del risultato.',
  ],
  'primal_champion': [
    'Campione Primordiale',
    'Il Barbaro raggiunge l’apice della potenza fisica.',
    'Al 20° livello i punteggi di Forza e Costituzione aumentano di 4 e il loro valore massimo diventa 24. Inoltre il numero di utilizzi dell’Ira diventa illimitato.',
  ],
};

const _rageFeatureIds = <String>{
  'rage',
  'relentless_rage',
  'persistent_rage',
  'primal_champion',
};

CharacterClassFeatureDefinition _barbarianFeature(
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
        source: _phbBarbarianSource,
        ownerId: ClassIds.barbarian,
      ),
      resourceId: _rageFeatureIds.contains(id) ? 'rage' : null,
      ruleTags: {
        'class_feature',
        'barbarian',
        if (_rageFeatureIds.contains(id)) 'rage',
      },
    );

final barbarianFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _barbarianFeatureSpecs.entries)
    entry.key: _barbarianFeature(entry.key, entry.value),
};

final _martialMeleeWeaponAlternatives = weaponDefinitions.values
    .where(
      (weapon) =>
          weapon.category == WeaponCategory.martial &&
          weapon.kind == WeaponKind.melee &&
          weapon.id != 'greataxe',
    )
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'barbarian_martial_${weapon.id}',
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

final _simpleWeaponAlternatives = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.simple)
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'barbarian_simple_${weapon.id}',
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

class BarbarianSubclassIds {
  static const berserker = 'path_of_the_berserker';
  static const totemWarrior = 'path_of_the_totem_warrior';
}

const _phbBarbarianPathSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 49-50',
);

CharacterClassFeatureDefinition _barbarianSubclassFeature({
  required String id,
  required String name,
  required String subclassId,
  required String summary,
  required String details,
  String? resourceId,
  Set<String> spellIds = const {},
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
        source: _phbBarbarianPathSource,
        ownerId: subclassId,
      ),
      resourceId: resourceId,
      spellIds: spellIds,
      ruleTags: {
        'subclass_feature',
        'barbarian',
        ...ruleTags,
      },
    );

final barbarianBerserkerFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'frenzy': _barbarianSubclassFeature(
    id: 'frenzy',
    name: 'Frenesia',
    subclassId: BarbarianSubclassIds.berserker,
    summary: 'Il Barbaro può trasformare la propria Ira in una frenesia.',
    details:
        'Dal 3° livello, quando entra in Ira, può scegliere di entrare in Frenesia. Per la durata dell’Ira può effettuare un singolo attacco con arma da mischia come azione bonus in ogni turno successivo. Quando l’Ira termina, subisce un livello di indebolimento.',
    resourceId: 'rage',
    ruleTags: {
      'rage',
      'bonus_action',
      'melee_attack',
      'exhaustion',
    },
  ),
  'mindless_rage': _barbarianSubclassFeature(
    id: 'mindless_rage',
    name: 'Ira Incontenibile',
    subclassId: BarbarianSubclassIds.berserker,
    summary:
        'Durante l’Ira il Barbaro non può essere affascinato o spaventato.',
    details:
        'Dal 6° livello, mentre è in Ira, non può essere affascinato o spaventato. Se è già soggetto a uno di questi effetti quando entra in Ira, l’effetto viene sospeso per la durata dell’Ira.',
    resourceId: 'rage',
    ruleTags: {
      'rage',
      'charmed',
      'frightened',
    },
  ),
  'intimidating_presence': _barbarianSubclassFeature(
    id: 'intimidating_presence',
    name: 'Presenza Intimidatoria',
    subclassId: BarbarianSubclassIds.berserker,
    summary:
        'Il Barbaro può terrorizzare una creatura con la propria presenza.',
    details:
        'Dal 10° livello usa un’azione per costringere una creatura entro 9 metri che possa vederlo o udirlo a effettuare un tiro salvezza di Saggezza. La CD è 8 + bonus di competenza + modificatore di Carisma. In caso di fallimento la creatura è spaventata fino alla fine del turno successivo del Barbaro e l’effetto può essere prolungato usando altre azioni. Termina se la creatura conclude il turno fuori dalla linea di vista o oltre 18 metri; se supera il tiro salvezza, il Barbaro non può usare nuovamente il privilegio su di essa per 24 ore.',
    ruleTags: {
      'action',
      'range_9_meters',
      'wisdom_save',
      'charisma',
      'frightened',
    },
  ),
  'retaliation': _barbarianSubclassFeature(
    id: 'retaliation',
    name: 'Ritorsione',
    subclassId: BarbarianSubclassIds.berserker,
    summary:
        'Il Barbaro reagisce immediatamente quando viene ferito da vicino.',
    details:
        'Dal 14° livello, quando subisce danni da una creatura entro 1,5 metri, può usare la propria reazione per effettuare un attacco con arma da mischia contro quella creatura.',
    ruleTags: {
      'reaction',
      'melee_attack',
      'range_1_5_meters',
    },
  ),
};

final barbarianTotemFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'spirit_seeker': _barbarianSubclassFeature(
    id: 'spirit_seeker',
    name: 'Cercatore di Spiriti',
    subclassId: BarbarianSubclassIds.totemWarrior,
    summary:
        'Il Barbaro stabilisce un legame spirituale con il mondo naturale.',
    details:
        'Dal 3° livello può lanciare Percezione delle Bestie e Parlare con gli Animali come rituali. Questi incantesimi rappresentano il contatto con gli spiriti animali.',
    spellIds: {
      'beast_sense',
      'speak_with_animals',
    },
    ruleTags: {
      'ritual_casting',
      'beast_sense',
      'speak_with_animals',
    },
  ),
  'totem_spirit': _barbarianSubclassFeature(
    id: 'totem_spirit',
    name: 'Spirito Totemico',
    subclassId: BarbarianSubclassIds.totemWarrior,
    summary:
        'Il Barbaro sceglie uno spirito animale che modifica la propria Ira.',
    details:
        'Al 3° livello sceglie Orso, Aquila o Lupo. Non è obbligato a effettuare la stessa scelta ai livelli successivi del Cammino Totemico.',
    resourceId: 'rage',
    ruleTags: {
      'rage',
      'totem_choice',
      'subclass_option',
    },
  ),
  'aspect_of_the_beast': _barbarianSubclassFeature(
    id: 'aspect_of_the_beast',
    name: 'Aspetto della Bestia',
    subclassId: BarbarianSubclassIds.totemWarrior,
    summary:
        'Il Barbaro assume una qualità fisica dello spirito animale scelto.',
    details:
        'Dal 6° livello sceglie un beneficio permanente dell’Orso, dell’Aquila o del Lupo. Può scegliere un animale diverso da quello selezionato al 3° livello.',
    ruleTags: {
      'totem_choice',
      'subclass_option',
    },
  ),
  'spirit_walker': _barbarianSubclassFeature(
    id: 'spirit_walker',
    name: 'Viandante Spirituale',
    subclassId: BarbarianSubclassIds.totemWarrior,
    summary: 'Il Barbaro può consultare gli spiriti della natura.',
    details:
        'Dal 10° livello può lanciare Comunione con la Natura come rituale, facendo apparire una versione spirituale dell’animale totemico scelto per comunicare le informazioni ottenute.',
    spellIds: {
      'commune_with_nature',
    },
    ruleTags: {
      'ritual_casting',
      'commune_with_nature',
    },
  ),
  'totemic_attunement': _barbarianSubclassFeature(
    id: 'totemic_attunement',
    name: 'Sintonia Totemica',
    subclassId: BarbarianSubclassIds.totemWarrior,
    summary:
        'Il legame con uno spirito animale conferisce un beneficio superiore durante l’Ira.',
    details:
        'Dal 14° livello sceglie Orso, Aquila o Lupo. La scelta può essere diversa da quelle effettuate ai livelli precedenti.',
    resourceId: 'rage',
    ruleTags: {
      'rage',
      'totem_choice',
      'subclass_option',
    },
  ),
};

SubclassOptionDefinition _barbarianTotemOption({
  required String id,
  required String name,
  required String category,
  required int minimumLevel,
  required String summary,
  required String details,
}) =>
    SubclassOptionDefinition(
      id: id,
      name: name,
      category: category,
      minimumLevel: minimumLevel,
      source: 'Manuale del Giocatore 2014',
      sourceRef: 'Pagina 50',
      description: RuleDescription(
        summary: summary,
        details: details,
      ),
    );

final barbarianTotemOptions = <SubclassOptionDefinition>[
  _barbarianTotemOption(
    id: 'totem_spirit_bear',
    name: 'Spirito Totemico: Orso',
    category: 'totem_spirit',
    minimumLevel: 3,
    summary: 'Durante l’Ira il Barbaro resiste a quasi ogni tipo di danno.',
    details:
        'Mentre è in Ira, il Barbaro possiede resistenza a tutti i danni tranne quelli psichici.',
  ),
  _barbarianTotemOption(
    id: 'totem_spirit_eagle',
    name: 'Spirito Totemico: Aquila',
    category: 'totem_spirit',
    minimumLevel: 3,
    summary: 'Durante l’Ira il Barbaro si muove rapidamente tra i nemici.',
    details:
        'Mentre è in Ira e non indossa armatura pesante, le altre creature subiscono svantaggio agli attacchi di opportunità contro di lui e può usare Scatto come azione bonus.',
  ),
  _barbarianTotemOption(
    id: 'totem_spirit_wolf',
    name: 'Spirito Totemico: Lupo',
    category: 'totem_spirit',
    minimumLevel: 3,
    summary:
        'Durante l’Ira il Barbaro aiuta gli alleati ad assalire i nemici vicini.',
    details:
        'Mentre è in Ira, gli alleati ottengono vantaggio agli attacchi in mischia contro le creature ostili che si trovano entro 1,5 metri dal Barbaro.',
  ),
  _barbarianTotemOption(
    id: 'aspect_of_the_beast_bear',
    name: 'Aspetto della Bestia: Orso',
    category: 'aspect_of_the_beast',
    minimumLevel: 6,
    summary: 'La forza dell’Orso aumenta la capacità di trasporto del Barbaro.',
    details:
        'La capacità di trasporto, inclusi i pesi massimi che può sollevare, spingere o trascinare, raddoppia. Ottiene inoltre vantaggio alle prove di Forza per spingere, tirare, sollevare o spezzare oggetti.',
  ),
  _barbarianTotemOption(
    id: 'aspect_of_the_beast_eagle',
    name: 'Aspetto della Bestia: Aquila',
    category: 'aspect_of_the_beast',
    minimumLevel: 6,
    summary:
        'La vista dell’Aquila permette di osservare chiaramente a grande distanza.',
    details:
        'Il Barbaro vede fino a 1,5 km senza difficoltà e distingue dettagli come se fossero a non più di 30 metri. La luce fioca non impone svantaggio alle prove di Saggezza (Percezione) basate sulla vista.',
  ),
  _barbarianTotemOption(
    id: 'aspect_of_the_beast_wolf',
    name: 'Aspetto della Bestia: Lupo',
    category: 'aspect_of_the_beast',
    minimumLevel: 6,
    summary: 'Il Barbaro sviluppa l’abilità del Lupo nel seguire le tracce.',
    details:
        'Può seguire le tracce di altre creature viaggiando a passo veloce e può muoversi furtivamente viaggiando a passo normale.',
  ),
  _barbarianTotemOption(
    id: 'totemic_attunement_bear',
    name: 'Sintonia Totemica: Orso',
    category: 'totemic_attunement',
    minimumLevel: 14,
    summary:
        'Durante l’Ira il Barbaro costringe i nemici vicini a concentrarsi su di lui.',
    details:
        'Mentre è in Ira, le creature ostili entro 1,5 metri subiscono svantaggio agli attacchi contro bersagli diversi dal Barbaro o da un altro personaggio dotato di questo privilegio. Una creatura non è influenzata se non può vedere o sentire il Barbaro oppure se non può essere spaventata.',
  ),
  _barbarianTotemOption(
    id: 'totemic_attunement_eagle',
    name: 'Sintonia Totemica: Aquila',
    category: 'totemic_attunement',
    minimumLevel: 14,
    summary: 'Durante l’Ira il Barbaro può volare per brevi spostamenti.',
    details:
        'Mentre è in Ira possiede una velocità di volare pari alla velocità sul terreno, ma cade se termina il proprio turno in aria senza un altro sostegno.',
  ),
  _barbarianTotemOption(
    id: 'totemic_attunement_wolf',
    name: 'Sintonia Totemica: Lupo',
    category: 'totemic_attunement',
    minimumLevel: 14,
    summary: 'Durante l’Ira il Barbaro può abbattere una creatura colpita.',
    details:
        'Mentre è in Ira, quando colpisce con un attacco con arma da mischia, può usare un’azione bonus per rendere prona una creatura di taglia Grande o inferiore.',
  ),
];

final barbarianBerserkerDefinition = CharacterSubclassDefinition(
  id: BarbarianSubclassIds.berserker,
  name: 'Cammino del Berserker',
  classId: ClassIds.barbarian,
  content: const RuleContent(
    id: BarbarianSubclassIds.berserker,
    name: 'Cammino del Berserker',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary: 'Un cammino di furia incontrollabile e violenza implacabile.',
      details:
          'Il Berserker trasforma l’Ira in Frenesia, ignora paura e fascinazione e reagisce con violenza a chi riesce a ferirlo.',
    ),
    source: _phbBarbarianPathSource,
    ownerId: ClassIds.barbarian,
  ),
  featuresByLevel: const {
    3: ['frenzy'],
    6: ['mindless_rage'],
    10: ['intimidating_presence'],
    14: ['retaliation'],
  },
  featureDefinitions: barbarianBerserkerFeatureDefinitions,
);

final barbarianTotemWarriorDefinition = CharacterSubclassDefinition(
  id: BarbarianSubclassIds.totemWarrior,
  name: 'Cammino del Combattente Totemico',
  classId: ClassIds.barbarian,
  content: const RuleContent(
    id: BarbarianSubclassIds.totemWarrior,
    name: 'Cammino del Combattente Totemico',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary: 'Un cammino spirituale che trae capacità dagli spiriti animali.',
      details:
          'Il Combattente Totemico entra in comunione con Orso, Aquila e Lupo, scegliendo indipendentemente uno spirito ai livelli previsti.',
    ),
    source: _phbBarbarianPathSource,
    ownerId: ClassIds.barbarian,
  ),
  featuresByLevel: const {
    3: [
      'spirit_seeker',
      'totem_spirit',
    ],
    6: ['aspect_of_the_beast'],
    10: ['spirit_walker'],
    14: ['totemic_attunement'],
  },
  featureDefinitions: barbarianTotemFeatureDefinitions,
  options: barbarianTotemOptions,
  optionProgression: const SubclassOptionProgression(
    selectionsByLevel: {
      3: 1,
      6: 2,
      14: 3,
    },
  ),
);

final barbarianSubclasses = <String, CharacterSubclassDefinition>{
  BarbarianSubclassIds.berserker: barbarianBerserkerDefinition,
  BarbarianSubclassIds.totemWarrior: barbarianTotemWarriorDefinition,
};

final barbarianClassDefinition = CharacterClassDefinition(
  id: ClassIds.barbarian,
  name: 'Barbaro',
  content: const RuleContent(
    id: ClassIds.barbarian,
    name: 'Barbaro',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un combattente feroce che trae potere dall’Ira e dagli istinti primordiali.',
      details:
          'Il Barbaro possiede grande resistenza, combatte in prima linea e sviluppa una furia capace di aumentare danni, forza fisica e capacità di sopravvivenza.',
    ),
    source: _phbBarbarianSource,
    ownerId: ClassIds.barbarian,
  ),
  hitDie: 12,
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
      'COS',
    },
    skillOptions: {
      'animal_handling',
      'athletics',
      'intimidation',
      'nature',
      'perception',
      'survival',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'barbarian_skills',
        label: 'Scegli due abilità da Barbaro',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'animal_handling',
          'athletics',
          'intimidation',
          'nature',
          'perception',
          'survival',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'barbarian_primary_weapon',
      label: 'Scegli l’arma marziale iniziale',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'barbarian_greataxe',
          label: 'Ascia Bipenne',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'greataxe',
            ),
          ],
        ),
        ..._martialMeleeWeaponAlternatives,
      ],
    ),
    ClassEquipmentChoice(
      id: 'barbarian_secondary_weapon',
      label: 'Scegli le armi secondarie',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'barbarian_two_handaxes',
          label: 'Due Accette',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'handaxe',
              quantity: 2,
            ),
          ],
        ),
        ..._simpleWeaponAlternatives,
      ],
    ),
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'equipment_pack',
      itemId: 'explorer_pack',
    ),
    ClassEquipmentGrant(
      catalogId: 'weapon',
      itemId: 'javelin',
      quantity: 4,
    ),
  ],
  featuresByLevel: const {
    1: [
      'rage',
      'unarmored_defense',
    ],
    2: [
      'reckless_attack',
      'danger_sense',
    ],
    3: [
      'primal_path',
    ],
    4: [
      'ability_score_improvement',
    ],
    5: [
      'extra_attack',
      'fast_movement',
    ],
    7: [
      'feral_instinct',
    ],
    8: [
      'ability_score_improvement',
    ],
    9: [
      'brutal_critical',
    ],
    11: [
      'relentless_rage',
    ],
    12: [
      'ability_score_improvement',
    ],
    13: [
      'brutal_critical',
    ],
    15: [
      'persistent_rage',
    ],
    16: [
      'ability_score_improvement',
    ],
    17: [
      'brutal_critical',
    ],
    18: [
      'indomitable_might',
    ],
    19: [
      'ability_score_improvement',
    ],
    20: [
      'primal_champion',
    ],
  },
  featureDefinitions: barbarianFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'rage',
      name: 'Ira',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        1: 2,
        3: 3,
        6: 4,
        12: 5,
        17: 6,
      },
      unlimitedFromLevel: 20,
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'rage_damage',
      name: 'Danni dell’Ira',
      valuesByLevel: {
        1: '+2',
        9: '+3',
        16: '+4',
      },
    ),
    ClassProgressionValueDefinition(
      id: 'brutal_critical_dice',
      name: 'Dadi del Critico Brutale',
      valuesByLevel: {
        9: '1',
        13: '2',
        17: '3',
      },
    ),
  ],
  subclassSelectionLevel: 3,
  subclasses: barbarianSubclasses,
);
