import 'class_catalog_data.dart';
import 'class_data.dart';

const _phbMonkSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 76-80',
);

const _monkToolIds = <String>{
  'alchemists_supplies',
  'brewers_supplies',
  'calligraphers_supplies',
  'carpenters_tools',
  'cartographers_tools',
  'cobblers_tools',
  'cooks_utensils',
  'glassblowers_tools',
  'jewelers_tools',
  'leatherworkers_tools',
  'masons_tools',
  'painters_supplies',
  'potters_tools',
  'smiths_tools',
  'tinkers_tools',
  'weavers_tools',
  'woodcarvers_tools',
  'bagpipes',
  'drum',
  'dulcimer',
  'flute',
  'lute',
  'lyre',
  'horn',
  'pan_flute',
  'shawm',
  'viol',
};

const _monkSimpleWeaponNames = <String, String>{
  'club': 'Randello',
  'dagger': 'Pugnale',
  'greatclub': 'Randello Pesante',
  'handaxe': 'Accetta',
  'javelin': 'Giacollotto',
  'light_hammer': 'Martello Leggero',
  'mace': 'Mazza',
  'quarterstaff': 'Bastone Ferrato',
  'sickle': 'Falcetto',
  'spear': 'Lancia',
  'light_crossbow': 'Balestra Leggera',
  'dart': 'Dardo',
  'shortbow': 'Arco Corto',
  'sling': 'Fionda',
};

const _monkFeatureSpecs = <String, List<String>>{
  'unarmored_defense': [
    'Difesa Senza Armatura',
    'Senza armatura e senza scudo, la CA del Monaco usa Destrezza e Saggezza.',
    'La Classe Armatura è pari a 10 + modificatore di Destrezza + modificatore di Saggezza finché il Monaco non indossa armatura e non impugna uno scudo.',
  ],
  'martial_arts': [
    'Arti Marziali',
    'Il Monaco combatte efficacemente senz’armi e con le armi monastiche.',
    'Quando non indossa armatura e non usa uno scudo può usare Destrezza al posto di Forza, impiegare il dado delle Arti Marziali e compiere un colpo senz’armi come azione bonus dopo l’azione di Attacco.',
  ],
  'ki': [
    'Ki',
    'Dal 2° livello il Monaco dispone di una riserva di punti Ki.',
    'I punti Ki alimentano Raffica di Colpi, Difesa Paziente, Passo del Vento e altre capacità. Si recuperano al termine di un riposo breve o lungo dopo almeno 30 minuti di meditazione.',
  ],
  'unarmored_movement': [
    'Movimento Senza Armatura',
    'La velocità del Monaco aumenta quando non indossa armatura e non usa uno scudo.',
    'Il bonus metrico aumenta con il livello secondo la progressione della classe.',
  ],
  'monastic_tradition': [
    'Tradizione Monastica',
    'Al 3° livello il Monaco sceglie la propria tradizione monastica.',
    'La tradizione concede privilegi al 3°, 6°, 11° e 17° livello.',
  ],
  'deflect_missiles': [
    'Deviare Proiettili',
    'Il Monaco può usare la reazione per ridurre i danni di un attacco con arma a distanza.',
    'La riduzione è pari a 1d10 + Destrezza + livello da Monaco. Se il danno scende a zero può afferrare il proiettile e, spendendo 1 Ki, rilanciarlo.',
  ],
  'slow_fall': [
    'Caduta Lenta',
    'Il Monaco può ridurre i danni subiti da una caduta.',
    'Dal 4° livello può usare la reazione per ridurre i danni da caduta di un ammontare pari a cinque volte il proprio livello da Monaco.',
  ],
  'ability_score_improvement': [
    'Aumento dei Punteggi di Caratteristica',
    'Il Monaco può aumentare i punteggi di caratteristica o scegliere un talento.',
    'Il privilegio viene ottenuto ai livelli 4, 8, 12, 16 e 19 secondo le regole generali di avanzamento.',
  ],
  'extra_attack': [
    'Attacco Extra',
    'Il Monaco può attaccare due volte con l’azione di Attacco.',
    'Dal 5° livello effettua due attacchi anziché uno ogni volta che usa l’azione di Attacco nel proprio turno.',
  ],
  'stunning_strike': [
    'Colpo Stordente',
    'Il Monaco può spendere Ki per tentare di stordire una creatura colpita.',
    'Dopo un colpo con un’arma da mischia può spendere 1 Ki. Il bersaglio effettua un tiro salvezza di Costituzione o resta stordito fino alla fine del turno successivo del Monaco.',
  ],
  'ki_empowered_strikes': [
    'Colpi Ki Potenziati',
    'Gli attacchi senz’armi del Monaco sono considerati magici.',
    'Dal 6° livello superano resistenze e immunità contro attacchi e danni non magici.',
  ],
  'evasion': [
    'Elusione',
    'Il Monaco evita più efficacemente gli effetti che richiedono tiri salvezza di Destrezza.',
    'Dal 7° livello non subisce danni quando supera tali tiri salvezza e subisce soltanto metà danni quando li fallisce.',
  ],
  'stillness_of_mind': [
    'Mente Lucida',
    'Il Monaco può interrompere gli effetti che lo affascinano o lo spaventano.',
    'Dal 7° livello può usare la propria azione per terminare su se stesso un effetto di affascinato o spaventato.',
  ],
  'unarmored_movement_improvement': [
    'Miglioramento del Movimento Senza Armatura',
    'Il Monaco può muoversi lungo superfici verticali e liquidi.',
    'Dal 9° livello può attraversare tali superfici durante il proprio movimento senza cadere nel corso dello spostamento.',
  ],
  'purity_of_body': [
    'Purezza del Corpo',
    'Il controllo del Ki rende il Monaco immune a malattie e veleno.',
    'Dal 10° livello il Monaco è immune alle malattie e alla condizione avvelenato.',
  ],
  'tongue_of_the_sun_and_moon': [
    'Lingua del Sole e della Luna',
    'Il Monaco comprende tutte le lingue parlate e può essere compreso.',
    'Dal 13° livello comprende ogni linguaggio parlato e qualsiasi creatura capace di comprendere un linguaggio può capire ciò che dice.',
  ],
  'diamond_soul': [
    'Anima Adamantina',
    'Il Monaco ottiene competenza in tutti i tiri salvezza.',
    'Dal 14° livello può inoltre spendere 1 Ki per ripetere un tiro salvezza fallito, utilizzando il nuovo risultato.',
  ],
  'timeless_body': [
    'Corpo Senza Tempo',
    'Il Ki protegge il Monaco dagli effetti debilitanti dell’età.',
    'Dal 15° livello non subisce la fragilità della vecchiaia, non può essere invecchiato magicamente e non necessita più di cibo o acqua.',
  ],
  'empty_body': [
    'Corpo Vuoto',
    'Il Monaco può spendere Ki per diventare invisibile e resistente ai danni.',
    'Dal 18° livello può spendere 4 Ki per diventare invisibile per 1 minuto e ottenere resistenza a tutti i danni tranne quelli da forza; può inoltre spendere 8 Ki per usare Proiezione Astrale su se stesso.',
  ],
  'perfect_self': [
    'Perfezione Interiore',
    'Il Monaco recupera Ki quando inizia uno scontro senza risorse sufficienti.',
    'Al 20° livello, quando tira per l’iniziativa e non possiede punti Ki, ne recupera 4.',
  ],
};

const _kiFeatureIds = <String>{
  'ki',
  'deflect_missiles',
  'stunning_strike',
  'diamond_soul',
  'empty_body',
  'perfect_self',
};

CharacterClassFeatureDefinition _monkFeature(
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
        source: _phbMonkSource,
        ownerId: ClassIds.monk,
      ),
      ruleTags: {
        'class_feature',
        'monk',
        if (_kiFeatureIds.contains(id)) 'ki',
      },
      resourceId: _kiFeatureIds.contains(id) ? 'ki' : null,
    );

final monkFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  for (final entry in _monkFeatureSpecs.entries)
    entry.key: _monkFeature(entry.key, entry.value),
};

final _monkStartingWeaponAlternatives = <ClassEquipmentAlternative>[
  const ClassEquipmentAlternative(
    id: 'monk_weapon_shortsword',
    label: 'Spada Corta',
    grants: [
      ClassEquipmentGrant(
        catalogId: 'weapon',
        itemId: 'shortsword',
      ),
    ],
  ),
  for (final entry in _monkSimpleWeaponNames.entries)
    ClassEquipmentAlternative(
      id: 'monk_weapon_${entry.key}',
      label: entry.value,
      grants: [
        ClassEquipmentGrant(
          catalogId: 'weapon',
          itemId: entry.key,
        ),
      ],
    ),
];

class MonkSubclassIds {
  static const openHand = 'way_of_the_open_hand';
  static const shadow = 'way_of_shadow';
  static const fourElements = 'way_of_the_four_elements';
}

const _phbMonkTraditionSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 79-81',
);

CharacterClassFeatureDefinition _monkSubclassFeature({
  required String id,
  required String name,
  required String subclassId,
  required String summary,
  required String details,
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
        source: _phbMonkTraditionSource,
        ownerId: subclassId,
      ),
      resourceId: resourceId,
      ruleTags: {
        'subclass_feature',
        'monk',
        ...ruleTags,
      },
    );

final monkOpenHandFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'open_hand_technique': _monkSubclassFeature(
    id: 'open_hand_technique',
    name: 'Tecnica della Mano Aperta',
    subclassId: MonkSubclassIds.openHand,
    summary:
        'La Raffica di Colpi può sbilanciare, spingere o impedire le reazioni.',
    details:
        'Dal 3° livello, quando il Monaco colpisce con un attacco della Raffica di Colpi, può imporre uno degli effetti previsti: tiro salvezza di Destrezza o bersaglio prono; tiro salvezza di Forza o spinta fino a 4,5 metri; oppure impossibilità di effettuare reazioni fino alla fine del turno successivo del Monaco.',
    resourceId: 'ki',
    ruleTags: {
      'flurry_of_blows',
      'saving_throw',
      'control',
    },
  ),
  'wholeness_of_body': _monkSubclassFeature(
    id: 'wholeness_of_body',
    name: 'Integrità del Corpo',
    subclassId: MonkSubclassIds.openHand,
    summary: 'Il Monaco può usare un’azione per recuperare punti ferita.',
    details:
        'Dal 6° livello recupera un numero di punti ferita pari a tre volte il proprio livello da Monaco. Può usare nuovamente la capacità dopo un riposo lungo.',
    ruleTags: {
      'action',
      'healing',
      'long_rest',
    },
  ),
  'tranquility': _monkSubclassFeature(
    id: 'tranquility',
    name: 'Tranquillità',
    subclassId: MonkSubclassIds.openHand,
    summary:
        'Dopo un riposo lungo il Monaco è protetto da un effetto analogo a Santuario.',
    details:
        'Dall’11° livello, al termine di un riposo lungo, l’effetto dura fino al riposo lungo successivo. La CD è 8 + modificatore di Saggezza + bonus di competenza e la protezione termina anticipatamente se il Monaco attacca o lancia un incantesimo che influenza una creatura nemica.',
    ruleTags: {
      'sanctuary',
      'long_rest',
      'wisdom',
    },
  ),
  'quivering_palm': _monkSubclassFeature(
    id: 'quivering_palm',
    name: 'Palmo Tremante',
    subclassId: MonkSubclassIds.openHand,
    summary: 'Il Monaco imprime vibrazioni letali in una creatura colpita.',
    details:
        'Dal 17° livello, dopo un colpo senz’armi, può spendere 3 Ki. Le vibrazioni durano per un numero di giorni pari al livello da Monaco. Usando un’azione può terminarle: con un tiro salvezza di Costituzione fallito il bersaglio scende a 0 punti ferita, mentre con un successo subisce 10d10 danni necrotici.',
    resourceId: 'ki',
    ruleTags: {
      'unarmed_strike',
      'action',
      'constitution_save',
      'necrotic_damage',
    },
  ),
};

final monkShadowFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'shadow_arts': _monkSubclassFeature(
    id: 'shadow_arts',
    name: 'Arti dell’Ombra',
    subclassId: MonkSubclassIds.shadow,
    summary:
        'Il Monaco usa il Ki per riprodurre tecniche magiche legate alle ombre.',
    details:
        'Dal 3° livello conosce il trucchetto Illusione Minore. Può spendere 2 Ki per lanciare Oscurità, Scurovisione, Passare Senza Tracce o Silenzio senza componenti materiali.',
    resourceId: 'ki',
    ruleTags: {
      'spellcasting',
      'minor_illusion',
      'darkness',
      'darkvision',
      'pass_without_trace',
      'silence',
    },
  ),
  'shadow_step': _monkSubclassFeature(
    id: 'shadow_step',
    name: 'Passo dell’Ombra',
    subclassId: MonkSubclassIds.shadow,
    summary: 'Il Monaco si teletrasporta tra zone di luce fioca o oscurità.',
    details:
        'Dal 6° livello, come azione bonus, si teletrasporta fino a 18 metri da una zona di luce fioca o oscurità a un’altra che può vedere. Ottiene vantaggio al primo attacco in mischia effettuato prima della fine del turno.',
    ruleTags: {
      'bonus_action',
      'teleport',
      'range_18_meters',
      'advantage',
    },
  ),
  'cloak_of_shadows': _monkSubclassFeature(
    id: 'cloak_of_shadows',
    name: 'Manto d’Ombra',
    subclassId: MonkSubclassIds.shadow,
    summary: 'Il Monaco può diventare invisibile nelle ombre.',
    details:
        'Dall’11° livello, quando si trova in luce fioca o oscurità, può usare un’azione per diventare invisibile. L’effetto termina se attacca, lancia un incantesimo o entra in luce intensa.',
    ruleTags: {
      'action',
      'invisibility',
      'dim_light',
      'darkness',
    },
  ),
  'opportunist': _monkSubclassFeature(
    id: 'opportunist',
    name: 'Opportunista',
    subclassId: MonkSubclassIds.shadow,
    summary:
        'Il Monaco sfrutta le aperture create dagli attacchi degli alleati.',
    details:
        'Dal 17° livello può usare la reazione per effettuare un attacco in mischia contro una creatura entro 1,5 metri quando quella creatura viene colpita da un’altra creatura.',
    ruleTags: {
      'reaction',
      'melee_attack',
      'range_1_5_meters',
    },
  ),
};

final monkOpenHandDefinition = CharacterSubclassDefinition(
  id: MonkSubclassIds.openHand,
  name: 'Via della Mano Aperta',
  classId: ClassIds.monk,
  content: const RuleContent(
    id: MonkSubclassIds.openHand,
    name: 'Via della Mano Aperta',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che perfeziona il combattimento senz’armi e il controllo del Ki.',
      details:
          'I Monaci della Mano Aperta dominano le arti marziali, manipolano il Ki proprio e altrui e sviluppano tecniche capaci di guarire o abbattere un avversario.',
    ),
    source: _phbMonkTraditionSource,
    ownerId: ClassIds.monk,
  ),
  featuresByLevel: const {
    3: ['open_hand_technique'],
    6: ['wholeness_of_body'],
    11: ['tranquility'],
    17: ['quivering_palm'],
  },
  featureDefinitions: monkOpenHandFeatureDefinitions,
);

final monkShadowDefinition = CharacterSubclassDefinition(
  id: MonkSubclassIds.shadow,
  name: 'Via dell’Ombra',
  classId: ClassIds.monk,
  content: const RuleContent(
    id: MonkSubclassIds.shadow,
    name: 'Via dell’Ombra',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione di furtività, inganno e manipolazione soprannaturale delle ombre.',
      details:
          'I Monaci dell’Ombra operano come spie, infiltratori e combattenti silenziosi, usando il Ki per celarsi e attraversare l’oscurità.',
    ),
    source: _phbMonkTraditionSource,
    ownerId: ClassIds.monk,
  ),
  featuresByLevel: const {
    3: ['shadow_arts'],
    6: ['shadow_step'],
    11: ['cloak_of_shadows'],
    17: ['opportunist'],
  },
  featureDefinitions: monkShadowFeatureDefinitions,
);

SubclassOptionDefinition _elementalDiscipline({
  required String id,
  required String name,
  required int minimumLevel,
  required String summary,
  required String details,
  int? cost,
  int? maximumCost,
  String? spellId,
  bool allowsAdditionalResource = false,
  bool grantedAutomatically = false,
}) =>
    SubclassOptionDefinition(
      id: id,
      name: name,
      category: 'elemental_discipline',
      minimumLevel: minimumLevel,
      cost: cost,
      maximumCost: maximumCost,
      allowsAdditionalResource: allowsAdditionalResource,
      resource: cost == null ? null : 'ki',
      spellId: spellId,
      source: 'Manuale del Giocatore 2014',
      sourceRef: 'Pagine 80-81',
      grantedAutomatically: grantedAutomatically,
      description: RuleDescription(
        summary: summary,
        details: details,
        glossaryRefs: [
          GlossaryRef(
            'elemental_discipline',
            'Disciplina Elementale',
          ),
          if (cost != null) GlossaryRef('ki', 'Ki'),
        ],
      ),
    );

final monkFourElementsOptions = <SubclassOptionDefinition>[
  _elementalDiscipline(
    id: 'sintonia_elementale',
    name: 'Sintonia Elementale',
    minimumLevel: 3,
    grantedAutomatically: true,
    summary:
        'Il Monaco controlla piccole manifestazioni innocue degli elementi.',
    details:
        'Usando un’azione può produrre entro 9 metri effetti minori legati ad acqua, aria, fuoco o terra, accendere o spegnere piccole fiamme, riscaldare o raffreddare materiale non vivente oppure generare una breve forma elementale.',
  ),
  _elementalDiscipline(
    id: 'colpo_della_cenere_turbinante',
    spellId: 'burning_hands',
    name: 'Colpo della Cenere Turbinante',
    minimumLevel: 3,
    cost: 2,
    summary: 'Il Monaco scatena una fiammata attraverso il proprio Ki.',
    details: 'Il Monaco può spendere 2 punti Ki per lanciare Mani Brucianti.',
  ),
  _elementalDiscipline(
    id: 'forma_del_fiume_fluente',
    name: 'Forma del Fiume Fluente',
    minimumLevel: 3,
    cost: 1,
    summary: 'Il Monaco rimodella acqua e ghiaccio attraverso il Ki.',
    details:
        'Con un’azione e 1 punto Ki può trasformare acqua in ghiaccio o viceversa e modellare il ghiaccio entro i limiti della disciplina, senza intrappolare o danneggiare direttamente una creatura.',
  ),
  _elementalDiscipline(
    id: 'frusta_d_acqua',
    name: 'Frusta d’Acqua',
    minimumLevel: 3,
    cost: 2,
    maximumCost: 4,
    allowsAdditionalResource: true,
    summary:
        'Una frusta d’acqua danneggia e può sbilanciare o trascinare una creatura.',
    details:
        'Con un’azione e almeno 2 punti Ki bersaglia una creatura visibile entro 9 metri. Un tiro salvezza di Destrezza determina danni ed effetti; può spendere fino a 2 Ki aggiuntivi per aumentare il danno.',
  ),
  _elementalDiscipline(
    id: 'pugno_dei_quattro_tuoni',
    spellId: 'thunderwave',
    name: 'Pugno dei Quattro Tuoni',
    minimumLevel: 3,
    cost: 2,
    summary: 'Il Monaco libera una violenta onda di energia tonante.',
    details: 'Il Monaco può spendere 2 punti Ki per lanciare Onda Tonante.',
  ),
  _elementalDiscipline(
    id: 'pugno_dell_aria_inviolabile',
    name: 'Pugno dell’Aria Inviolabile',
    minimumLevel: 3,
    cost: 2,
    maximumCost: 4,
    allowsAdditionalResource: true,
    summary:
        'Una scarica d’aria colpisce, respinge e può abbattere una creatura.',
    details:
        'Con un’azione e almeno 2 punti Ki bersaglia una creatura entro 9 metri. Il bersaglio effettua un tiro salvezza di Forza; può spendere fino a 2 Ki aggiuntivi per aumentare il danno.',
  ),
  _elementalDiscipline(
    id: 'spiriti_della_burrasca_impetuosa',
    spellId: 'gust_of_wind',
    name: 'Spiriti della Burrasca Impetuosa',
    minimumLevel: 3,
    cost: 2,
    summary: 'Il Monaco richiama una potente corrente di vento.',
    details: 'Il Monaco può spendere 2 punti Ki per lanciare Folata di Vento.',
  ),
  _elementalDiscipline(
    id: 'zanne_del_serpente_di_fuoco',
    name: 'Zanne del Serpente di Fuoco',
    minimumLevel: 3,
    cost: 1,
    allowsAdditionalResource: true,
    summary:
        'Fiamme elementali aumentano portata e potenza dei colpi senz’armi.',
    details:
        'Quando usa l’azione di Attacco può spendere 1 Ki per aumentare di 3 metri la portata dei colpi senz’armi per il resto del turno e convertirne i danni in fuoco. Quando colpisce può spendere 1 Ki aggiuntivo per infliggere 1d10 danni da fuoco extra.',
  ),
  _elementalDiscipline(
    id: 'gong_della_sommita',
    spellId: 'shatter',
    name: 'Gong della Sommità',
    minimumLevel: 6,
    cost: 3,
    summary: 'Il Monaco sprigiona una violenta forza sonora.',
    details: 'Dal 6° livello può spendere 3 punti Ki per lanciare Frantumare.',
  ),
  _elementalDiscipline(
    id: 'morsa_del_vento_del_nord',
    spellId: 'hold_person',
    name: 'Morsa del Vento del Nord',
    minimumLevel: 6,
    cost: 3,
    summary: 'Il Monaco usa il Ki per immobilizzare una creatura.',
    details:
        'Dal 6° livello può spendere 3 punti Ki per lanciare Blocca Persone.',
  ),
  _elementalDiscipline(
    id: 'cavalcare_il_vento',
    spellId: 'fly',
    name: 'Cavalcare il Vento',
    minimumLevel: 11,
    cost: 4,
    summary: 'Il Monaco usa il Ki per ottenere la capacità di volare.',
    details:
        'Dall’11° livello può spendere 4 punti Ki per lanciare Volare bersagliando se stesso.',
  ),
  _elementalDiscipline(
    id: 'fiamme_della_fenice',
    spellId: 'fireball',
    name: 'Fiamme della Fenice',
    minimumLevel: 11,
    cost: 4,
    summary: 'Il Monaco concentra il Ki in una potente esplosione di fuoco.',
    details:
        'Dall’11° livello può spendere 4 punti Ki per lanciare Palla di Fuoco.',
  ),
  _elementalDiscipline(
    id: 'postura_della_nebbia',
    spellId: 'gaseous_form',
    name: 'Postura della Nebbia',
    minimumLevel: 11,
    cost: 4,
    summary:
        'Il Monaco trasforma il proprio corpo in una forma simile alla nebbia.',
    details:
        'Dall’11° livello può spendere 4 punti Ki per lanciare Forma Gassosa bersagliando se stesso.',
  ),
  _elementalDiscipline(
    id: 'difesa_della_montagna_eterna',
    spellId: 'stoneskin',
    name: 'Difesa della Montagna Eterna',
    minimumLevel: 17,
    cost: 5,
    summary: 'Il Monaco assume la resistenza soprannaturale della pietra.',
    details:
        'Dal 17° livello può spendere 5 punti Ki per lanciare Pelle di Pietra bersagliando se stesso.',
  ),
  _elementalDiscipline(
    id: 'fiume_della_fiamma_famelica',
    spellId: 'wall_of_fire',
    name: 'Fiume della Fiamma Famelica',
    minimumLevel: 17,
    cost: 5,
    summary: 'Il Monaco innalza una barriera di fuoco alimentata dal Ki.',
    details:
        'Dal 17° livello può spendere 5 punti Ki per lanciare Muro di Fuoco.',
  ),
  _elementalDiscipline(
    id: 'onda_della_terra_tumultuosa',
    spellId: 'wall_of_stone',
    name: 'Onda della Terra Tumultuosa',
    minimumLevel: 17,
    cost: 6,
    summary: 'Il Monaco solleva la terra formando una grande barriera.',
    details:
        'Dal 17° livello può spendere 6 punti Ki per lanciare Muro di Pietra.',
  ),
  _elementalDiscipline(
    id: 'soffio_dell_inverno',
    spellId: 'cone_of_cold',
    name: 'Soffio dell’Inverno',
    minimumLevel: 17,
    cost: 6,
    summary: 'Il Monaco scatena una devastante ondata di gelo.',
    details:
        'Dal 17° livello può spendere 6 punti Ki per lanciare Cono di Freddo.',
  ),
];

final monkFourElementsFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  'disciple_of_the_elements': _monkSubclassFeature(
    id: 'disciple_of_the_elements',
    name: 'Discepolo degli Elementi',
    subclassId: MonkSubclassIds.fourElements,
    summary:
        'Il Monaco apprende discipline che incanalano il Ki negli elementi.',
    details:
        'Dal 3° livello apprende automaticamente Sintonia Elementale e sceglie una disciplina aggiuntiva. La Saggezza è la caratteristica da incantatore e la CD delle discipline è pari a 8 + bonus di competenza + modificatore di Saggezza.',
    resourceId: 'ki',
    ruleTags: {
      'elemental_discipline',
      'wisdom',
      'spellcasting',
    },
  ),
  'additional_elemental_discipline': _monkSubclassFeature(
    id: 'additional_elemental_discipline',
    name: 'Disciplina Elementale Aggiuntiva',
    subclassId: MonkSubclassIds.fourElements,
    summary: 'La progressione amplia le discipline conosciute dal Monaco.',
    details:
        'Al 6°, 11° e 17° livello il Monaco apprende una disciplina aggiuntiva e può sostituire una disciplina scelta in precedenza con un’altra per cui soddisfa i requisiti.',
    resourceId: 'ki',
    ruleTags: {
      'elemental_discipline',
      'subclass_option',
      'replacement',
    },
  ),
};

final monkFourElementsDefinition = CharacterSubclassDefinition(
  id: MonkSubclassIds.fourElements,
  name: 'Via dei Quattro Elementi',
  classId: ClassIds.monk,
  content: const RuleContent(
    id: MonkSubclassIds.fourElements,
    name: 'Via dei Quattro Elementi',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Una tradizione che incanala il Ki attraverso aria, acqua, fuoco e terra.',
      details:
          'I suoi Monaci apprendono discipline elementali con requisiti e costi differenti, ampliando e modificando le proprie scelte durante la progressione.',
    ),
    source: _phbMonkTraditionSource,
    ownerId: ClassIds.monk,
  ),
  featuresByLevel: const {
    3: ['disciple_of_the_elements'],
    6: ['additional_elemental_discipline'],
    11: ['additional_elemental_discipline'],
    17: ['additional_elemental_discipline'],
  },
  featureDefinitions: monkFourElementsFeatureDefinitions,
  options: monkFourElementsOptions,
  optionProgression: const SubclassOptionProgression(
    selectionsByLevel: {
      3: 1,
      6: 2,
      11: 3,
      17: 4,
    },
    replacementLevels: {
      6,
      11,
      17,
    },
  ),
);

final monkSubclasses = <String, CharacterSubclassDefinition>{
  MonkSubclassIds.openHand: monkOpenHandDefinition,
  MonkSubclassIds.shadow: monkShadowDefinition,
  MonkSubclassIds.fourElements: monkFourElementsDefinition,
};

final monkClassDefinition = CharacterClassDefinition(
  id: ClassIds.monk,
  name: 'Monaco',
  content: const RuleContent(
    id: ClassIds.monk,
    name: 'Monaco',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un combattente disciplinato che trasforma corpo, mente e Ki in armi.',
      details:
          'Il Monaco padroneggia le arti marziali, combatte senza armatura e sviluppa tecniche soprannaturali alimentate dal Ki.',
    ),
    source: _phbMonkSource,
    ownerId: ClassIds.monk,
  ),
  hitDie: 8,
  proficiencies: ClassProficiencyDefinition(
    weapons: {
      ..._monkSimpleWeaponNames.keys,
      'shortsword',
    },
    savingThrows: {
      'FOR',
      'DES',
    },
    skillOptions: {
      'acrobatics',
      'athletics',
      'history',
      'insight',
      'religion',
      'stealth',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'monk_skills',
        label: 'Scegli due abilità da Monaco',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'acrobatics',
          'athletics',
          'history',
          'insight',
          'religion',
          'stealth',
        },
        selections: 2,
      ),
      ClassProficiencyChoiceDefinition(
        id: 'monk_artisan_tool_or_instrument',
        label: 'Scegli uno strumento da artigiano o uno strumento musicale',
        type: ClassProficiencyChoiceType.tool,
        optionIds: _monkToolIds,
        selections: 1,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'monk_starting_weapon',
      label: 'Scegli l’arma iniziale',
      alternatives: _monkStartingWeaponAlternatives,
    ),
    const ClassEquipmentChoice(
      id: 'monk_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'monk_pack_dungeoneer',
          label: 'Dotazione da Esploratore di Sotterranei',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: 'dungeoneer_pack',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'monk_pack_explorer',
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
  ],
  fixedStartingEquipment: const [
    ClassEquipmentGrant(
      catalogId: 'weapon',
      itemId: 'dart',
      quantity: 10,
    ),
  ],
  featuresByLevel: const {
    1: [
      'unarmored_defense',
      'martial_arts',
    ],
    2: [
      'ki',
      'unarmored_movement',
    ],
    3: [
      'monastic_tradition',
      'deflect_missiles',
    ],
    4: [
      'slow_fall',
      'ability_score_improvement',
    ],
    5: [
      'extra_attack',
      'stunning_strike',
    ],
    6: [
      'ki_empowered_strikes',
    ],
    7: [
      'evasion',
      'stillness_of_mind',
    ],
    8: [
      'ability_score_improvement',
    ],
    9: [
      'unarmored_movement_improvement',
    ],
    10: [
      'purity_of_body',
    ],
    12: [
      'ability_score_improvement',
    ],
    13: [
      'tongue_of_the_sun_and_moon',
    ],
    14: [
      'diamond_soul',
    ],
    15: [
      'timeless_body',
    ],
    16: [
      'ability_score_improvement',
    ],
    18: [
      'empty_body',
    ],
    19: [
      'ability_score_improvement',
    ],
    20: [
      'perfect_self',
    ],
  },
  featureDefinitions: monkFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'ki',
      name: 'Ki',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        2: 2,
        3: 3,
        4: 4,
        5: 5,
        6: 6,
        7: 7,
        8: 8,
        9: 9,
        10: 10,
        11: 11,
        12: 12,
        13: 13,
        14: 14,
        15: 15,
        16: 16,
        17: 17,
        18: 18,
        19: 19,
        20: 20,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'martial_arts_die',
      name: 'Dado delle Arti Marziali',
      valuesByLevel: {
        1: 'd4',
        5: 'd6',
        11: 'd8',
        17: 'd10',
      },
    ),
    ClassProgressionValueDefinition(
      id: 'unarmored_movement_bonus',
      name: 'Movimento Senza Armatura',
      valuesByLevel: {
        2: '3 m',
        6: '4.5 m',
        10: '6 m',
        14: '7.5 m',
        18: '9 m',
      },
    ),
  ],
  subclassSelectionLevel: 3,
  subclasses: monkSubclasses,
);
