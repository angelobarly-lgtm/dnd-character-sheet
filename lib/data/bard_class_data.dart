import 'armor_data.dart';
import 'character_data.dart';
import 'class_catalog_data.dart';
import 'class_data.dart';
import 'spell_data.dart';
import 'tool_data.dart';
import 'weapon_data.dart';

const _phbBardSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 51-55',
);

const _bardSkillIds = <String>{
  'acrobatics',
  'animal_handling',
  'arcana',
  'athletics',
  'deception',
  'history',
  'insight',
  'intimidation',
  'investigation',
  'medicine',
  'nature',
  'perception',
  'performance',
  'persuasion',
  'religion',
  'sleight_of_hand',
  'stealth',
  'survival',
};

const _bardInstrumentIds = <String>{
  ToolIds.bagpipes,
  ToolIds.drum,
  ToolIds.dulcimer,
  ToolIds.flute,
  ToolIds.lute,
  ToolIds.lyre,
  ToolIds.horn,
  ToolIds.panFlute,
  ToolIds.shawm,
  ToolIds.viol,
};

final _bardSpellIds = spellDefinitions.values
    .where((spell) => spell.classIds.contains(ClassIds.bard))
    .map((spell) => spell.id)
    .toSet();

CharacterClassFeatureDefinition _bardFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  String? resourceId,
  List<CharacterChoiceDefinition> choices = const [],
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
        source: _phbBardSource,
        ownerId: ClassIds.bard,
      ),
      resourceId: resourceId,
      choices: choices,
      ruleTags: {
        'class_feature',
        'bard',
        ...ruleTags,
      },
    );

final bardFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'spellcasting': _bardFeature(
    id: 'spellcasting',
    name: 'Incantesimi',
    summary:
        'Il Bardo usa il Carisma per lanciare gli incantesimi della propria lista.',
    details:
        'Dal 1° livello conosce trucchetti e incantesimi da Bardo. Il Carisma determina la CD dei tiri salvezza e il modificatore degli attacchi con incantesimo. Può lanciare come rituale un incantesimo da Bardo che conosce se possiede il descrittore rituale e può usare uno strumento musicale come focus da incantatore. Ogni volta che acquisisce un livello da Bardo può sostituire un incantesimo da Bardo conosciuto con un altro incantesimo della lista del Bardo di un livello per cui possiede slot.',
    ruleTags: {
      'spellcasting',
      'charisma',
      'musical_instrument_focus',
    },
  ),
  'bardic_inspiration': _bardFeature(
    id: 'bardic_inspiration',
    name: 'Ispirazione Bardica',
    summary: 'Il Bardo concede a un alleato un dado di Ispirazione Bardica.',
    details:
        'Come azione bonus sceglie una creatura diversa da sé entro 18 metri che possa sentirlo. Entro 10 minuti la creatura può aggiungere il dado a una prova di caratteristica, un tiro per colpire o un tiro salvezza. Può decidere dopo avere tirato il d20, ma deve usare il dado prima che il DM dichiari l’esito. Una creatura può possedere un solo dado di Ispirazione Bardica alla volta. Gli utilizzi sono pari al modificatore di Carisma, con un minimo di uno.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'bonus_action',
      'range_18_meters',
      'charisma',
    },
  ),
  'jack_of_all_trades': _bardFeature(
    id: 'jack_of_all_trades',
    name: 'Factotum',
    summary:
        'Il Bardo applica metà del bonus di competenza alle prove in cui non è competente.',
    details:
        'Dal 2° livello aggiunge metà del bonus di competenza, arrotondato per difetto, a ogni prova di caratteristica che non includa già il bonus di competenza.',
    ruleTags: {
      'ability_check',
      'half_proficiency',
    },
  ),
  'song_of_rest': _bardFeature(
    id: 'song_of_rest',
    name: 'Canto di Riposo',
    summary:
        'La musica del Bardo migliora il recupero durante un riposo breve.',
    details:
        'Dal 2° livello, se il Bardo o creature amiche che possono udire la sua esibizione recuperano punti ferita spendendo uno o più Dadi Vita al termine di un riposo breve, ciascuna recupera punti ferita aggiuntivi tirando il dado del Canto di Riposo.',
    ruleTags: {
      'short_rest',
      'healing',
      'hit_dice',
    },
  ),
  'bard_college': _bardFeature(
    id: 'bard_college',
    name: 'Collegio Bardico',
    summary:
        'Il Bardo sceglie il collegio che definisce il proprio addestramento.',
    details:
        'Al 3° livello sceglie un Collegio Bardico, che concede privilegi al 3°, 6° e 14° livello.',
    ruleTags: {
      'subclass_selection',
    },
  ),
  'expertise_3': _bardFeature(
    id: 'expertise_3',
    name: 'Maestria',
    summary:
        'Il Bardo raddoppia il bonus di competenza per due competenze possedute.',
    details:
        'Al 3° livello sceglie due competenze nelle abilità che possiede. Per le relative prove il bonus di competenza viene raddoppiato.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'bard_expertise_3',
        label: 'Scegli due competenze per Maestria',
        type: CharacterChoiceType.skill,
        catalogId: 'skill',
        minimumSelections: 2,
        maximumSelections: 2,
        requireExistingAcquisition: true,
      ),
    ],
    ruleTags: {
      'expertise',
      'skill',
    },
  ),
  'ability_score_improvement': _bardFeature(
    id: 'ability_score_improvement',
    name: 'Aumento dei Punteggi di Caratteristica',
    summary:
        'Il Bardo può aumentare i punteggi di caratteristica o scegliere un talento.',
    details:
        'Il privilegio viene ottenuto ai livelli 4, 8, 12, 16 e 19 secondo le regole generali di avanzamento.',
    ruleTags: {
      'ability_score_improvement',
      'feat',
    },
  ),
  'font_of_inspiration': _bardFeature(
    id: 'font_of_inspiration',
    name: 'Fonte di Ispirazione',
    summary:
        'L’Ispirazione Bardica viene recuperata anche con un riposo breve.',
    details:
        'Dal 5° livello il Bardo recupera tutti gli utilizzi di Ispirazione Bardica al termine di un riposo breve o lungo.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'short_rest',
      'long_rest',
    },
  ),
  'countercharm': _bardFeature(
    id: 'countercharm',
    name: 'Controfascino',
    summary: 'Il Bardo usa la musica per contrastare paura e fascinazione.',
    details:
        'Dal 6° livello, con un’azione, si esibisce fino alla fine del proprio turno successivo. Il Bardo e le creature amiche entro 9 metri che possano sentirlo ottengono vantaggio ai tiri salvezza contro essere affascinati o spaventati. L’esibizione termina anticipatamente se il Bardo diventa incapacitato o viene silenziato, oppure se la conclude volontariamente senza spendere un’azione.',
    ruleTags: {
      'action',
      'range_9_meters',
      'charmed',
      'frightened',
    },
  ),
  'expertise_10': _bardFeature(
    id: 'expertise_10',
    name: 'Maestria Aggiuntiva',
    summary: 'Il Bardo applica Maestria ad altre due competenze possedute.',
    details:
        'Al 10° livello sceglie altre due competenze nelle abilità che possiede, differenti da quelle già selezionate per Maestria.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'bard_expertise_10',
        label: 'Scegli altre due competenze per Maestria',
        type: CharacterChoiceType.skill,
        catalogId: 'skill',
        minimumSelections: 2,
        maximumSelections: 2,
        requireExistingAcquisition: true,
      ),
    ],
    ruleTags: {
      'expertise',
      'skill',
    },
  ),
  'magical_secrets_10': _bardFeature(
    id: 'magical_secrets_10',
    name: 'Segreti Magici',
    summary:
        'Il Bardo apprende due incantesimi appartenenti a qualsiasi classe.',
    details:
        'Al 10° livello sceglie due incantesimi o trucchetti da qualsiasi classe. Gli incantesimi scelti devono essere di un livello che il Bardo possa lanciare, diventano incantesimi da Bardo e sono inclusi nel totale degli incantesimi conosciuti.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'bard_magical_secrets_10',
        label: 'Scegli due Segreti Magici',
        type: CharacterChoiceType.spell,
        catalogId: 'spell',
        minimumSelections: 2,
        maximumSelections: 2,
        maximumSpellLevel: 5,
      ),
    ],
    ruleTags: {
      'magical_secrets',
      'spell_choice',
    },
  ),
  'magical_secrets_14': _bardFeature(
    id: 'magical_secrets_14',
    name: 'Segreti Magici Aggiuntivi',
    summary:
        'Il Bardo apprende altri due incantesimi appartenenti a qualsiasi classe.',
    details:
        'Al 14° livello sceglie altri due incantesimi o trucchetti da qualsiasi classe, di livello non superiore al 7°.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'bard_magical_secrets_14',
        label: 'Scegli altri due Segreti Magici',
        type: CharacterChoiceType.spell,
        catalogId: 'spell',
        minimumSelections: 2,
        maximumSelections: 2,
        maximumSpellLevel: 7,
      ),
    ],
    ruleTags: {
      'magical_secrets',
      'spell_choice',
    },
  ),
  'magical_secrets_18': _bardFeature(
    id: 'magical_secrets_18',
    name: 'Segreti Magici Superiori',
    summary:
        'Il Bardo apprende gli ultimi due incantesimi appartenenti a qualsiasi classe.',
    details:
        'Al 18° livello sceglie altri due incantesimi o trucchetti da qualsiasi classe, di livello non superiore al 9°.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'bard_magical_secrets_18',
        label: 'Scegli gli ultimi due Segreti Magici',
        type: CharacterChoiceType.spell,
        catalogId: 'spell',
        minimumSelections: 2,
        maximumSelections: 2,
        maximumSpellLevel: 9,
      ),
    ],
    ruleTags: {
      'magical_secrets',
      'spell_choice',
    },
  ),
  'superior_inspiration': _bardFeature(
    id: 'superior_inspiration',
    name: 'Ispirazione Superiore',
    summary:
        'Il Bardo recupera un utilizzo di Ispirazione Bardica quando tira l’iniziativa senza averne.',
    details:
        'Al 20° livello, quando tira per l’iniziativa e non possiede utilizzi di Ispirazione Bardica, ne recupera uno.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'initiative',
    },
  ),
};

final _bardSimpleWeaponAlternatives = weaponDefinitions.values
    .where((weapon) => weapon.category == WeaponCategory.simple)
    .map(
      (weapon) => ClassEquipmentAlternative(
        id: 'bard_simple_${weapon.id}',
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

final _bardInstrumentAlternatives = toolDefinitions.values
    .where((tool) => tool.category == ToolCategory.musical)
    .map(
      (tool) => ClassEquipmentAlternative(
        id: 'bard_instrument_${tool.id}',
        label: tool.name,
        grants: [
          ClassEquipmentGrant(
            catalogId: 'tool',
            itemId: tool.id,
          ),
        ],
      ),
    )
    .toList();

class BardSubclassIds {
  static const lore = 'college_of_lore';
  static const valor = 'college_of_valor';
}

const _phbBardCollegeSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'Pagine 54-55',
);

CharacterClassFeatureDefinition _bardSubclassFeature({
  required String id,
  required String name,
  required String subclassId,
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
        source: _phbBardCollegeSource,
        ownerId: subclassId,
      ),
      resourceId: resourceId,
      choices: choices,
      effects: effects,
      ruleTags: {
        'subclass_feature',
        'bard',
        ...ruleTags,
      },
    );

final bardLoreFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'bonus_proficiencies_lore': _bardSubclassFeature(
    id: 'bonus_proficiencies_lore',
    name: 'Competenze Bonus',
    subclassId: BardSubclassIds.lore,
    summary: 'Il Bardo acquisisce competenza in tre abilità a sua scelta.',
    details:
        'Al 3° livello sceglie tre abilità nelle quali non possiede già competenza.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'lore_bonus_skills',
        label: 'Scegli tre competenze bonus',
        type: CharacterChoiceType.skill,
        catalogId: 'skill',
        minimumSelections: 3,
        maximumSelections: 3,
        optionIds: [
          ..._bardSkillIds,
        ],
        requireNewAcquisition: true,
      ),
    ],
    ruleTags: {
      'skill_proficiency',
    },
  ),
  'cutting_words': _bardSubclassFeature(
    id: 'cutting_words',
    name: 'Parole Taglienti',
    subclassId: BardSubclassIds.lore,
    summary: 'Il Bardo usa l’Ispirazione Bardica per ostacolare una creatura.',
    details:
        'Dal 3° livello, quando una creatura che il Bardo può vedere entro 18 metri e che possa sentirlo effettua un tiro per colpire, una prova di caratteristica o un tiro per i danni, il Bardo può usare la reazione e spendere un’Ispirazione Bardica per sottrarre il risultato del dado dal tiro. Può farlo dopo il tiro, ma prima che il DM dichiari l’esito; nel caso dei danni, prima che siano applicati. La creatura è immune se non può sentire il Bardo o se è immune alla condizione di affascinato.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'reaction',
      'range_18_meters',
      'attack_roll',
      'ability_check',
      'damage_roll',
    },
  ),
  'additional_magical_secrets': _bardSubclassFeature(
    id: 'additional_magical_secrets',
    name: 'Segreti Magici Aggiuntivi',
    subclassId: BardSubclassIds.lore,
    summary:
        'Il Bardo apprende due incantesimi appartenenti a qualsiasi classe.',
    details:
        'Al 6° livello sceglie due incantesimi o trucchetti da qualsiasi classe, di livello non superiore al 3°. Diventano incantesimi da Bardo e non contano nel numero degli incantesimi conosciuti indicato dalla tabella della classe.',
    choices: const [
      CharacterChoiceDefinition(
        id: 'lore_additional_magical_secrets',
        label: 'Scegli due Segreti Magici Aggiuntivi',
        type: CharacterChoiceType.spell,
        catalogId: 'spell',
        minimumSelections: 2,
        maximumSelections: 2,
        maximumSpellLevel: 3,
      ),
    ],
    ruleTags: {
      'magical_secrets',
      'spell_choice',
    },
  ),
  'peerless_skill': _bardSubclassFeature(
    id: 'peerless_skill',
    name: 'Abilità Impareggiabile',
    subclassId: BardSubclassIds.lore,
    summary: 'Il Bardo può usare l’Ispirazione Bardica sulle proprie prove.',
    details:
        'Dal 14° livello, quando effettua una prova di caratteristica, può spendere un utilizzo di Ispirazione Bardica, tirare il dado e aggiungerlo al risultato. Può decidere dopo il tiro iniziale, ma prima che il DM ne dichiari l’esito.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'ability_check',
      'self_inspiration',
    },
  ),
};

final bardValorFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  'bonus_proficiencies_valor': _bardSubclassFeature(
    id: 'bonus_proficiencies_valor',
    name: 'Competenze Bonus',
    subclassId: BardSubclassIds.valor,
    summary:
        'Il Bardo acquisisce competenza in armature medie, scudi e armi da guerra.',
    details:
        'Al 3° livello ottiene competenza nelle armature medie, negli scudi e in tutte le armi da guerra.',
    effects: const CharacterEffects(
      armorProficiencies: {
        'medium_armor',
        'shield',
      },
      weaponProficiencies: {
        'martial_weapons',
      },
    ),
    ruleTags: {
      'armor_proficiency',
      'weapon_proficiency',
    },
  ),
  'combat_inspiration': _bardSubclassFeature(
    id: 'combat_inspiration',
    name: 'Ispirazione in Combattimento',
    subclassId: BardSubclassIds.valor,
    summary: 'L’Ispirazione Bardica può aumentare danni o Classe Armatura.',
    details:
        'Dal 3° livello una creatura con un dado di Ispirazione Bardica può aggiungerlo ai danni di un attacco con arma dopo avere visto il tiro per i danni. In alternativa, quando viene effettuato un tiro per colpire contro di lei, può usare la reazione per aggiungere il dado alla propria CA contro quell’attacco dopo avere visto il tiro, ma prima di sapere se l’attacco colpisce.',
    resourceId: 'bardic_inspiration',
    ruleTags: {
      'weapon_damage',
      'reaction',
      'armor_class',
    },
  ),
  'extra_attack': _bardSubclassFeature(
    id: 'extra_attack',
    name: 'Attacco Extra',
    subclassId: BardSubclassIds.valor,
    summary: 'Il Bardo può attaccare due volte con l’azione di Attacco.',
    details:
        'Dal 6° livello effettua due attacchi anziché uno ogni volta che usa l’azione di Attacco nel proprio turno.',
    ruleTags: {
      'attack_action',
      'extra_attack',
    },
  ),
  'battle_magic': _bardSubclassFeature(
    id: 'battle_magic',
    name: 'Magia da Battaglia',
    subclassId: BardSubclassIds.valor,
    summary: 'Il Bardo combina il lancio di un incantesimo con un attacco.',
    details:
        'Dal 14° livello, quando usa la propria azione per lanciare un incantesimo da Bardo, può effettuare un attacco con arma come azione bonus.',
    ruleTags: {
      'spellcasting',
      'bonus_action',
      'weapon_attack',
    },
  ),
};

final bardLoreDefinition = CharacterSubclassDefinition(
  id: BardSubclassIds.lore,
  name: 'Collegio della Sapienza',
  classId: ClassIds.bard,
  content: const RuleContent(
    id: BardSubclassIds.lore,
    name: 'Collegio della Sapienza',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un collegio dedicato alla conoscenza, alla versatilità e al potere delle parole.',
      details:
          'I Bardi della Sapienza raccolgono informazioni da ogni fonte, ampliano le proprie competenze e usano parole e magia per influenzare gli eventi.',
    ),
    source: _phbBardCollegeSource,
    ownerId: ClassIds.bard,
  ),
  featuresByLevel: const {
    3: [
      'bonus_proficiencies_lore',
      'cutting_words',
    ],
    6: [
      'additional_magical_secrets',
    ],
    14: [
      'peerless_skill',
    ],
  },
  featureDefinitions: bardLoreFeatureDefinitions,
);

final bardValorDefinition = CharacterSubclassDefinition(
  id: BardSubclassIds.valor,
  name: 'Collegio del Valore',
  classId: ClassIds.bard,
  content: const RuleContent(
    id: BardSubclassIds.valor,
    name: 'Collegio del Valore',
    type: RuleContentType.subclassFeature,
    description: RuleDescription(
      summary:
          'Un collegio marziale che celebra gli eroi e combatte al loro fianco.',
      details:
          'I Bardi del Valore uniscono magia e armi, ispirano gli alleati in battaglia e sviluppano competenze marziali superiori.',
    ),
    source: _phbBardCollegeSource,
    ownerId: ClassIds.bard,
  ),
  featuresByLevel: const {
    3: [
      'bonus_proficiencies_valor',
      'combat_inspiration',
    ],
    6: [
      'extra_attack',
    ],
    14: [
      'battle_magic',
    ],
  },
  featureDefinitions: bardValorFeatureDefinitions,
);

final bardSubclasses = <String, CharacterSubclassDefinition>{
  BardSubclassIds.lore: bardLoreDefinition,
  BardSubclassIds.valor: bardValorDefinition,
};

final bardClassDefinition = CharacterClassDefinition(
  id: ClassIds.bard,
  name: 'Bardo',
  content: const RuleContent(
    id: ClassIds.bard,
    name: 'Bardo',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un incantatore versatile che trasforma musica, parole e talento in magia.',
      details:
          'Il Bardo padroneggia numerose abilità, sostiene gli alleati con l’Ispirazione Bardica e apprende incantesimi provenienti da tradizioni differenti.',
    ),
    source: _phbBardSource,
    ownerId: ClassIds.bard,
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
    savingThrows: {
      'DES',
      'CAR',
    },
    skillOptions: _bardSkillIds,
    skillChoices: 3,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'bard_skills',
        label: 'Scegli tre abilità',
        type: ClassProficiencyChoiceType.skill,
        optionIds: _bardSkillIds,
        selections: 3,
      ),
      ClassProficiencyChoiceDefinition(
        id: 'bard_musical_instruments',
        label: 'Scegli tre strumenti musicali',
        type: ClassProficiencyChoiceType.tool,
        optionIds: _bardInstrumentIds,
        selections: 3,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'bard_primary_weapon',
      label: 'Scegli l’arma iniziale',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'bard_rapier',
          label: 'Stocco',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'rapier',
            ),
          ],
        ),
        const ClassEquipmentAlternative(
          id: 'bard_longsword',
          label: 'Spada Lunga',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'longsword',
            ),
          ],
        ),
        ..._bardSimpleWeaponAlternatives,
      ],
    ),
    const ClassEquipmentChoice(
      id: 'bard_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'bard_diplomat_pack',
          label: 'Dotazione da Diplomatico',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: 'diplomat_pack',
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'bard_entertainer_pack',
          label: 'Dotazione da Intrattenitore',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: 'entertainer_pack',
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'bard_starting_instrument',
      label: 'Scegli lo strumento musicale iniziale',
      alternatives: _bardInstrumentAlternatives,
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
    ),
  ],
  featuresByLevel: const {
    1: [
      'spellcasting',
      'bardic_inspiration',
    ],
    2: [
      'jack_of_all_trades',
      'song_of_rest',
    ],
    3: [
      'bard_college',
      'expertise_3',
    ],
    4: [
      'ability_score_improvement',
    ],
    5: [
      'font_of_inspiration',
    ],
    6: [
      'countercharm',
    ],
    8: [
      'ability_score_improvement',
    ],
    10: [
      'expertise_10',
      'magical_secrets_10',
    ],
    12: [
      'ability_score_improvement',
    ],
    14: [
      'magical_secrets_14',
    ],
    16: [
      'ability_score_improvement',
    ],
    18: [
      'magical_secrets_18',
    ],
    19: [
      'ability_score_improvement',
    ],
    20: [
      'superior_inspiration',
    ],
  },
  featureDefinitions: bardFeatureDefinitions,
  resources: const [
    ClassResourceDefinition(
      id: 'bardic_inspiration',
      name: 'Ispirazione Bardica',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      maximumAbility: 'CAR',
      minimumMaximum: 1,
      recoveryByLevel: {
        5: ClassResourceRecovery.shortRest,
      },
    ),
  ],
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: 'bardic_inspiration_die',
      name: 'Dado di Ispirazione Bardica',
      valuesByLevel: {
        1: 'd6',
        5: 'd8',
        10: 'd10',
        15: 'd12',
      },
    ),
    ClassProgressionValueDefinition(
      id: 'song_of_rest_die',
      name: 'Dado del Canto di Riposo',
      valuesByLevel: {
        2: 'd6',
        9: 'd8',
        13: 'd10',
        17: 'd12',
      },
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.full,
    ability: 'CAR',
    minimumLevel: 1,
    ritualCasting: true,
    preparesSpells: false,
    spellIds: _bardSpellIds,
    cantripsKnownByLevel: const {
      1: 2,
      4: 3,
      10: 4,
    },
    spellsKnownByLevel: const {
      1: 4,
      2: 5,
      3: 6,
      4: 7,
      5: 8,
      6: 9,
      7: 10,
      8: 11,
      9: 12,
      10: 14,
      11: 15,
      12: 15,
      13: 16,
      14: 18,
      15: 19,
      16: 19,
      17: 20,
      18: 22,
      19: 22,
      20: 22,
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
  subclassSelectionLevel: 3,
  subclasses: bardSubclasses,
);
