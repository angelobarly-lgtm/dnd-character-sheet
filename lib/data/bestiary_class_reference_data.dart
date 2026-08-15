import 'bestiary_data.dart';

const _elementalSource = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Elementale',
  pageStart: 124,
  pageEnd: 125,
  section: 'Elementale',
);

const _modronSource = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Modron',
  pageStart: 228,
  pageEnd: 230,
  section: 'Modron',
);

CreatureRuleDefinition _referenceTrait({
  required String id,
  required String name,
  required String description,
  Set<String> tags = const {},
}) =>
    CreatureRuleDefinition(
      id: id,
      name: name,
      description: description,
      tags: tags,
    );

CreatureActionDefinition _referenceAttack({
  required String id,
  required String name,
  required CreatureAttackType type,
  required int attackBonus,
  required String damageType,
  required int averageDamage,
  required int diceCount,
  required int dieSize,
  int modifier = 0,
  double? reachMeters,
  double? normalRangeMeters,
  double? longRangeMeters,
  String target = 'un bersaglio',
  String description = 'Attacco con arma.',
  List<CreatureEffectDefinition> effects = const [],
}) =>
    CreatureActionDefinition(
      id: id,
      name: name,
      description: description,
      effects: effects,
      attack: CreatureAttackDefinition(
        type: type,
        attackBonus: attackBonus,
        reachMeters: reachMeters,
        normalRangeMeters: normalRangeMeters,
        longRangeMeters: longRangeMeters,
        target: target,
        damages: [
          CreatureDamageDefinition(
            damageType: damageType,
            average: averageDamage,
            diceCount: diceCount,
            dieSize: dieSize,
            modifier: modifier,
          ),
        ],
      ),
    );

CreatureMultiattackDefinition _referenceMultiattack({
  required String id,
  required String description,
  required Map<String, int> actionUses,
}) =>
    CreatureMultiattackDefinition(
      id: id,
      name: 'Multiattacco',
      description: description,
      options: [
        CreatureMultiattackOptionDefinition(
          id: '${id}_option',
          description: description,
          actionUses: actionUses,
        ),
      ],
    );

CreatureDefinition _referenceCreature({
  required String id,
  required String name,
  required BestiarySourceDefinition source,
  required CreatureSize size,
  required CreatureType type,
  Set<String> subtypes = const {},
  Set<String> tags = const {},
  required String alignment,
  required int armorClass,
  String? armorDescription,
  required int averageHitPoints,
  required int hitDiceCount,
  required int hitDieSize,
  int hitPointModifier = 0,
  required CreatureAbilityScores abilities,
  required List<CreatureMovementDefinition> movements,
  Map<String, int> skillBonuses = const {},
  Set<String> damageVulnerabilities = const {},
  Set<String> damageResistances = const {},
  Set<String> damageImmunities = const {},
  Set<String> conditionImmunities = const {},
  List<CreatureSenseDefinition> senses = const [],
  required int passivePerception,
  Set<String> languages = const {},
  required double challengeRating,
  required int experiencePoints,
  required int proficiencyBonus,
  List<CreatureRuleDefinition> traits = const [],
  List<CreatureActionDefinition> actions = const [],
  List<CreatureMultiattackDefinition> multiattacks = const [],
  List<CreatureVariantDefinition> variants = const [],
}) =>
    CreatureDefinition(
      id: id,
      name: name,
      source: source,
      origin: BestiaryContentOrigin.official,
      size: size,
      type: type,
      subtypes: subtypes,
      tags: tags,
      alignment: alignment,
      armorClass: CreatureArmorClassDefinition(
        value: armorClass,
        description: armorDescription,
      ),
      hitPoints: CreatureHitPointsDefinition(
        average: averageHitPoints,
        diceCount: hitDiceCount,
        dieSize: hitDieSize,
        modifier: hitPointModifier,
      ),
      abilities: abilities,
      movements: movements,
      skillBonuses: skillBonuses,
      damageVulnerabilities: damageVulnerabilities,
      damageResistances: damageResistances,
      damageImmunities: damageImmunities,
      conditionImmunities: conditionImmunities,
      senses: senses,
      passivePerception: passivePerception,
      languages: languages,
      challengeRating: challengeRating,
      experiencePoints: experiencePoints,
      proficiencyBonus: proficiencyBonus,
      traits: traits,
      actions: actions,
      multiattacks: multiattacks,
      variants: variants,
    );

const _elementalConditionImmunities = {
  'afferrato',
  'avvelenato',
  'indebolimento',
  'paralizzato',
  'pietrificato',
  'privo di sensi',
  'prono',
  'trattenuto',
};

const _nonMagicalWeaponResistances = {
  'contundente da attacchi non magici',
  'perforante da attacchi non magici',
  'tagliente da attacchi non magici',
};

final airElementalDefinition = _referenceCreature(
  id: BestiaryCreatureIds.airElemental,
  name: 'Elementale dell’Aria',
  source: _elementalSource,
  size: CreatureSize.large,
  type: CreatureType.elemental,
  subtypes: const {'air'},
  tags: const {'hover'},
  alignment: 'neutrale',
  armorClass: 15,
  averageHitPoints: 90,
  hitDiceCount: 12,
  hitDieSize: 10,
  hitPointModifier: 24,
  abilities: const CreatureAbilityScores(
    strength: 14,
    dexterity: 20,
    constitution: 14,
    intelligence: 6,
    wisdom: 10,
    charisma: 6,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 0,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 27,
    ),
  ],
  damageResistances: const {
    'fulmine',
    'tuono',
    ..._nonMagicalWeaponResistances,
  },
  damageImmunities: const {'veleno'},
  conditionImmunities: _elementalConditionImmunities,
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 10,
  languages: const {'Auran'},
  challengeRating: 5,
  experiencePoints: 1800,
  proficiencyBonus: 3,
  traits: [
    _referenceTrait(
      id: 'air_form',
      name: 'Forma d’Aria',
      description:
          'Può entrare nello spazio di una creatura ostile e fermarvisi. '
          'Può attraversare aperture larghe almeno 2,5 centimetri senza '
          'doversi stringere.',
      tags: const {'amorphous', 'occupies_hostile_space'},
    ),
  ],
  actions: [
    _referenceAttack(
      id: 'slam',
      name: 'Schianto',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 8,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 14,
      diceCount: 2,
      dieSize: 8,
      modifier: 5,
    ),
    const CreatureActionDefinition(
      id: 'whirlwind',
      name: 'Vortice',
      description: 'Ricarica 4-6. Ogni creatura nello spazio dell’elementale '
          'effettua un TS Forza CD 13. Se fallisce subisce 15 (3d8+2) '
          'danni contundenti, viene scagliata di 6 metri in una direzione '
          'casuale e cade prona. Se supera il tiro subisce metà danni e '
          'non viene scagliata né cade prona.',
      recharge: '4-6',
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'FOR',
        difficultyClass: 13,
        success: 'Metà danni; non viene scagliata e non cade prona.',
        failure: '15 danni contundenti; scagliata di 6 metri e prona.',
      ),
      effects: [
        CreatureEffectDefinition(
          id: 'whirlwind_throw',
          target: 'creature nello spazio dell’elementale',
          condition: 'prono',
          numericValues: {
            'averageDamage': 15,
            'diceCount': 3,
            'dieSize': 8,
            'modifier': 2,
            'distanceMeters': 6,
          },
          tags: {'forced_movement', 'prone'},
        ),
      ],
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_slams',
      description: 'Due attacchi con Schianto.',
      actionUses: const {'slam': 2},
    ),
  ],
);

final earthElementalDefinition = _referenceCreature(
  id: BestiaryCreatureIds.earthElemental,
  name: 'Elementale della Terra',
  source: _elementalSource,
  size: CreatureSize.large,
  type: CreatureType.elemental,
  subtypes: const {'earth'},
  alignment: 'neutrale',
  armorClass: 17,
  armorDescription: 'armatura naturale',
  averageHitPoints: 126,
  hitDiceCount: 12,
  hitDieSize: 10,
  hitPointModifier: 60,
  abilities: const CreatureAbilityScores(
    strength: 20,
    dexterity: 8,
    constitution: 20,
    intelligence: 5,
    wisdom: 10,
    charisma: 5,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.burrowing,
      meters: 9,
    ),
  ],
  damageVulnerabilities: const {'tuono'},
  damageResistances: _nonMagicalWeaponResistances,
  damageImmunities: const {'veleno'},
  conditionImmunities: const {
    'avvelenato',
    'indebolimento',
    'paralizzato',
    'pietrificato',
    'privo di sensi',
  },
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.tremorsense,
      meters: 18,
    ),
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 10,
  languages: const {'Terran'},
  challengeRating: 5,
  experiencePoints: 1800,
  proficiencyBonus: 3,
  traits: [
    _referenceTrait(
      id: 'earth_glide',
      name: 'Scivolare nella Terra',
      description: 'Può scavare attraverso terra e pietra non magiche e non '
          'lavorate senza disturbare il materiale attraversato.',
      tags: const {'burrowing', 'unworked_earth_and_stone'},
    ),
    _referenceTrait(
      id: 'siege_monster',
      name: 'Mostro da Assedio',
      description: 'Infligge danni doppi agli oggetti e alle strutture.',
      tags: const {'double_damage_objects_structures'},
    ),
  ],
  actions: [
    _referenceAttack(
      id: 'slam',
      name: 'Schianto',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 8,
      reachMeters: 3,
      damageType: 'contundente',
      averageDamage: 14,
      diceCount: 2,
      dieSize: 8,
      modifier: 5,
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_slams',
      description: 'Due attacchi con Schianto.',
      actionUses: const {'slam': 2},
    ),
  ],
);

final fireElementalDefinition = _referenceCreature(
  id: BestiaryCreatureIds.fireElemental,
  name: 'Elementale del Fuoco',
  source: _elementalSource,
  size: CreatureSize.large,
  type: CreatureType.elemental,
  subtypes: const {'fire'},
  alignment: 'neutrale',
  armorClass: 13,
  averageHitPoints: 102,
  hitDiceCount: 12,
  hitDieSize: 10,
  hitPointModifier: 36,
  abilities: const CreatureAbilityScores(
    strength: 10,
    dexterity: 17,
    constitution: 16,
    intelligence: 6,
    wisdom: 10,
    charisma: 7,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 15,
    ),
  ],
  damageResistances: _nonMagicalWeaponResistances,
  damageImmunities: const {'fuoco', 'veleno'},
  conditionImmunities: _elementalConditionImmunities,
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 10,
  languages: const {'Ignan'},
  challengeRating: 5,
  experiencePoints: 1800,
  proficiencyBonus: 3,
  traits: [
    _referenceTrait(
      id: 'fire_form',
      name: 'Forma di Fuoco',
      description: 'Può attraversare aperture larghe almeno 2,5 centimetri, '
          'entrare nello spazio di una creatura ostile e incendiarla. '
          'Una creatura che lo tocchi o lo colpisca in mischia da entro '
          '1,5 metri subisce 5 (1d10) danni da fuoco.',
      tags: const {'amorphous', 'contact_fire', 'ignites_creatures'},
    ),
    _referenceTrait(
      id: 'illumination',
      name: 'Illuminazione',
      description: 'Proietta luce intensa entro 9 metri e luce fioca per altri '
          '9 metri.',
      tags: const {'bright_light_9_meters', 'dim_light_18_meters'},
    ),
    _referenceTrait(
      id: 'water_susceptibility',
      name: 'Suscettibilità all’Acqua',
      description: 'Subisce 1 danno da freddo per ogni 1,5 metri percorsi '
          'nell’acqua o per ogni 4 litri d’acqua versati su di lui.',
      tags: const {'water_susceptibility'},
    ),
  ],
  actions: [
    _referenceAttack(
      id: 'touch',
      name: 'Tocco',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 6,
      reachMeters: 1.5,
      damageType: 'fuoco',
      averageDamage: 10,
      diceCount: 2,
      dieSize: 6,
      modifier: 3,
      description:
          'Una creatura o un oggetto infiammabile colpito prende fuoco '
          'e subisce 5 (1d10) danni da fuoco all’inizio di ogni suo '
          'turno finché qualcuno non usa un’azione per spegnere le fiamme.',
      effects: const [
        CreatureEffectDefinition(
          id: 'touch_ignition',
          target: 'creatura o oggetto infiammabile colpito',
          condition: 'in fiamme',
          duration: 'finché un’azione non spegne le fiamme',
          numericValues: {
            'ongoingAverageDamage': 5,
            'ongoingDiceCount': 1,
            'ongoingDieSize': 10,
          },
          tags: {'fire', 'ongoing_damage'},
        ),
      ],
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_touches',
      description: 'Due attacchi con Tocco.',
      actionUses: const {'touch': 2},
    ),
  ],
);

final waterElementalDefinition = _referenceCreature(
  id: BestiaryCreatureIds.waterElemental,
  name: 'Elementale dell’Acqua',
  source: _elementalSource,
  size: CreatureSize.large,
  type: CreatureType.elemental,
  subtypes: const {'water'},
  alignment: 'neutrale',
  armorClass: 14,
  armorDescription: 'armatura naturale',
  averageHitPoints: 114,
  hitDiceCount: 12,
  hitDieSize: 10,
  hitPointModifier: 48,
  abilities: const CreatureAbilityScores(
    strength: 18,
    dexterity: 14,
    constitution: 18,
    intelligence: 5,
    wisdom: 10,
    charisma: 8,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.swimming,
      meters: 27,
    ),
  ],
  damageResistances: const {
    'acido',
    ..._nonMagicalWeaponResistances,
  },
  damageImmunities: const {'veleno'},
  conditionImmunities: _elementalConditionImmunities,
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 10,
  languages: const {'Aquan'},
  challengeRating: 5,
  experiencePoints: 1800,
  proficiencyBonus: 3,
  traits: [
    _referenceTrait(
      id: 'water_form',
      name: 'Forma d’Acqua',
      description:
          'Può entrare nello spazio di una creatura ostile e fermarvisi '
          'e attraversare aperture larghe almeno 2,5 centimetri.',
      tags: const {'amorphous', 'occupies_hostile_space'},
    ),
    _referenceTrait(
      id: 'freeze',
      name: 'Congelamento',
      description: 'Quando subisce danni da freddo, la sua velocità è ridotta '
          'di 6 metri fino alla fine del suo turno successivo.',
      tags: const {'cold_damage_trigger', 'speed_reduction'},
    ),
  ],
  actions: [
    _referenceAttack(
      id: 'slam',
      name: 'Schianto',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 7,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 13,
      diceCount: 2,
      dieSize: 8,
      modifier: 4,
    ),
    const CreatureActionDefinition(
      id: 'whelm',
      name: 'Sommergere',
      description: 'Ricarica 4-6. Le creature nello spazio dell’elementale '
          'effettuano un TS Forza CD 15. Se falliscono subiscono '
          '13 (2d8+4) danni contundenti. Le creature Grandi o inferiori '
          'sono afferrate (CD 14), trattenute e non possono respirare, '
          'salvo che possano respirare sott’acqua.',
      recharge: '4-6',
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'FOR',
        difficultyClass: 15,
        success: 'Spinta fuori dallo spazio dell’elementale.',
        failure: '13 danni contundenti; possibile presa e soffocamento.',
      ),
      effects: [
        CreatureEffectDefinition(
          id: 'whelm_grapple',
          target: 'creatura Grande o inferiore nello spazio',
          condition: 'afferrato, trattenuto e incapace di respirare',
          numericValues: {
            'averageDamage': 13,
            'diceCount': 2,
            'dieSize': 8,
            'modifier': 4,
            'escapeDc': 14,
            'maximumLargeTargets': 1,
            'maximumMediumOrSmallerTargets': 2,
          },
          tags: {'grapple', 'restrained', 'suffocating'},
        ),
      ],
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_slams',
      description: 'Due attacchi con Schianto.',
      actionUses: const {'slam': 2},
    ),
  ],
);

const _axiomaticMind = CreatureRuleDefinition(
  id: 'axiomatic_mind',
  name: 'Mente Assiomatica',
  description: 'Il modron non può essere obbligato ad agire in modo contrario '
      'alla sua natura o alle sue istruzioni.',
  tags: {'axiomatic', 'cannot_act_against_nature_or_instructions'},
);

const _modronDisintegration = CreatureRuleDefinition(
  id: 'modron_disintegration',
  name: 'Disintegrazione',
  description: 'Se il modron muore, il corpo si disintegra in polvere. '
      'Restano soltanto le armi e gli oggetti trasportati.',
  tags: {'disintegrates_on_death'},
);

CreatureDefinition _modron({
  required String id,
  required String name,
  required CreatureSize size,
  required int armorClass,
  required int averageHitPoints,
  required int hitDiceCount,
  required int hitDieSize,
  required int hitPointModifier,
  required CreatureAbilityScores abilities,
  required List<CreatureMovementDefinition> movements,
  Map<String, int> skillBonuses = const {},
  required int passivePerception,
  required double challengeRating,
  required int experiencePoints,
  required List<CreatureActionDefinition> actions,
  List<CreatureMultiattackDefinition> multiattacks = const [],
}) =>
    _referenceCreature(
      id: id,
      name: name,
      source: _modronSource,
      size: size,
      type: CreatureType.construct,
      subtypes: const {'modron'},
      tags: const {'mechanus'},
      alignment: 'legale neutrale',
      armorClass: armorClass,
      armorDescription: 'armatura naturale',
      averageHitPoints: averageHitPoints,
      hitDiceCount: hitDiceCount,
      hitDieSize: hitDieSize,
      hitPointModifier: hitPointModifier,
      abilities: abilities,
      movements: movements,
      skillBonuses: skillBonuses,
      senses: const [
        CreatureSenseDefinition(
          type: CreatureSenseType.truesight,
          meters: 36,
        ),
      ],
      passivePerception: passivePerception,
      languages: const {'Modron'},
      challengeRating: challengeRating,
      experiencePoints: experiencePoints,
      proficiencyBonus: 2,
      traits: const [_axiomaticMind, _modronDisintegration],
      actions: actions,
      multiattacks: multiattacks,
      variants: const [
        CreatureVariantDefinition(
          id: 'rogue_modron',
          name: 'Modron Fuori Controllo',
          description:
              'Perde Mente Assiomatica e può avere qualsiasi allineamento '
              'diverso da legale neutrale.',
          source: _modronSource,
          removedTags: {
            'axiomatic',
            'cannot_act_against_nature_or_instructions',
          },
          replacementRuleIds: {'axiomatic_mind'},
        ),
      ],
    );

final monodroneDefinition = _modron(
  id: BestiaryCreatureIds.monodrone,
  name: 'Monodrone',
  size: CreatureSize.medium,
  armorClass: 15,
  averageHitPoints: 5,
  hitDiceCount: 1,
  hitDieSize: 8,
  hitPointModifier: 1,
  abilities: const CreatureAbilityScores(
    strength: 10,
    dexterity: 13,
    constitution: 12,
    intelligence: 4,
    wisdom: 10,
    charisma: 5,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 9,
    ),
  ],
  passivePerception: 10,
  challengeRating: 0.125,
  experiencePoints: 25,
  actions: [
    _referenceAttack(
      id: 'dagger',
      name: 'Pugnale',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 3,
      reachMeters: 1.5,
      damageType: 'perforante',
      averageDamage: 3,
      diceCount: 1,
      dieSize: 4,
      modifier: 1,
    ),
    _referenceAttack(
      id: 'javelin',
      name: 'Giavellotto',
      type: CreatureAttackType.rangedWeapon,
      attackBonus: 2,
      normalRangeMeters: 9,
      longRangeMeters: 36,
      damageType: 'perforante',
      averageDamage: 3,
      diceCount: 1,
      dieSize: 6,
      description: 'Attacco in mischia con portata 1,5 metri oppure a distanza '
          'con gittata 9/36 metri.',
    ),
  ],
);

final duodroneDefinition = _modron(
  id: BestiaryCreatureIds.duodrone,
  name: 'Duodrone',
  size: CreatureSize.medium,
  armorClass: 15,
  averageHitPoints: 11,
  hitDiceCount: 2,
  hitDieSize: 8,
  hitPointModifier: 2,
  abilities: const CreatureAbilityScores(
    strength: 11,
    dexterity: 13,
    constitution: 12,
    intelligence: 6,
    wisdom: 10,
    charisma: 7,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
  ],
  passivePerception: 10,
  challengeRating: 0.25,
  experiencePoints: 50,
  actions: [
    _referenceAttack(
      id: 'fist',
      name: 'Pugno',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 2,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 2,
      diceCount: 1,
      dieSize: 4,
    ),
    _referenceAttack(
      id: 'javelin',
      name: 'Giavellotto',
      type: CreatureAttackType.rangedWeapon,
      attackBonus: 3,
      normalRangeMeters: 9,
      longRangeMeters: 36,
      damageType: 'perforante',
      averageDamage: 4,
      diceCount: 1,
      dieSize: 6,
      modifier: 1,
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_fists',
      description: 'Due attacchi con i Pugni.',
      actionUses: const {'fist': 2},
    ),
    _referenceMultiattack(
      id: 'two_javelins',
      description: 'Due attacchi con il Giavellotto.',
      actionUses: const {'javelin': 2},
    ),
  ],
);

final tridroneDefinition = _modron(
  id: BestiaryCreatureIds.tridrone,
  name: 'Tridrone',
  size: CreatureSize.medium,
  armorClass: 15,
  averageHitPoints: 16,
  hitDiceCount: 3,
  hitDieSize: 8,
  hitPointModifier: 3,
  abilities: const CreatureAbilityScores(
    strength: 12,
    dexterity: 13,
    constitution: 12,
    intelligence: 9,
    wisdom: 10,
    charisma: 9,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
  ],
  passivePerception: 10,
  challengeRating: 0.5,
  experiencePoints: 100,
  actions: [
    _referenceAttack(
      id: 'fist',
      name: 'Pugno',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 3,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 3,
      diceCount: 1,
      dieSize: 4,
      modifier: 1,
    ),
    _referenceAttack(
      id: 'javelin',
      name: 'Giavellotto',
      type: CreatureAttackType.rangedWeapon,
      attackBonus: 3,
      normalRangeMeters: 9,
      longRangeMeters: 36,
      damageType: 'perforante',
      averageDamage: 4,
      diceCount: 1,
      dieSize: 6,
      modifier: 1,
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'three_fists',
      description: 'Tre attacchi con i Pugni.',
      actionUses: const {'fist': 3},
    ),
    _referenceMultiattack(
      id: 'three_javelins',
      description: 'Tre attacchi con il Giavellotto.',
      actionUses: const {'javelin': 3},
    ),
  ],
);

final quadroneDefinition = _modron(
  id: BestiaryCreatureIds.quadrone,
  name: 'Quadrone',
  size: CreatureSize.medium,
  armorClass: 16,
  averageHitPoints: 22,
  hitDiceCount: 4,
  hitDieSize: 8,
  hitPointModifier: 4,
  abilities: const CreatureAbilityScores(
    strength: 12,
    dexterity: 14,
    constitution: 12,
    intelligence: 10,
    wisdom: 10,
    charisma: 11,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 9,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 9,
    ),
  ],
  skillBonuses: const {'perception': 2},
  passivePerception: 12,
  challengeRating: 1,
  experiencePoints: 200,
  actions: [
    _referenceAttack(
      id: 'fist',
      name: 'Pugno',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 3,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 3,
      diceCount: 1,
      dieSize: 4,
      modifier: 1,
    ),
    _referenceAttack(
      id: 'shortbow',
      name: 'Arco Corto',
      type: CreatureAttackType.rangedWeapon,
      attackBonus: 4,
      normalRangeMeters: 24,
      longRangeMeters: 96,
      damageType: 'perforante',
      averageDamage: 5,
      diceCount: 1,
      dieSize: 6,
      modifier: 2,
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'two_fists',
      description: 'Due attacchi con i Pugni.',
      actionUses: const {'fist': 2},
    ),
    _referenceMultiattack(
      id: 'four_shortbow_attacks',
      description: 'Quattro attacchi con l’Arco Corto.',
      actionUses: const {'shortbow': 4},
    ),
  ],
);

final pentadroneDefinition = _modron(
  id: BestiaryCreatureIds.pentadrone,
  name: 'Pentadrone',
  size: CreatureSize.large,
  armorClass: 16,
  averageHitPoints: 32,
  hitDiceCount: 5,
  hitDieSize: 10,
  hitPointModifier: 5,
  abilities: const CreatureAbilityScores(
    strength: 15,
    dexterity: 14,
    constitution: 12,
    intelligence: 10,
    wisdom: 10,
    charisma: 13,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 12,
    ),
  ],
  skillBonuses: const {'perception': 4},
  passivePerception: 14,
  challengeRating: 2,
  experiencePoints: 450,
  actions: [
    _referenceAttack(
      id: 'arm',
      name: 'Braccio',
      type: CreatureAttackType.meleeWeapon,
      attackBonus: 4,
      reachMeters: 1.5,
      damageType: 'contundente',
      averageDamage: 5,
      diceCount: 1,
      dieSize: 6,
      modifier: 2,
    ),
    const CreatureActionDefinition(
      id: 'paralysis_gas',
      name: 'Gas Paralizzante',
      description:
          'Ricarica 5-6. Esala gas in un cono di 9 metri. Ogni creatura '
          'nell’area supera un TS Costituzione CD 11 o resta paralizzata '
          'per 1 minuto, ripetendo il tiro alla fine di ogni turno.',
      recharge: '5-6',
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 11,
        success: 'Nessun effetto.',
        failure:
            'Paralizzato per 1 minuto; nuovo tiro alla fine di ogni turno.',
      ),
      effects: [
        CreatureEffectDefinition(
          id: 'paralysis_gas_effect',
          target: 'creature in un cono di 9 metri',
          condition: 'paralizzato',
          duration: '1 minuto',
          numericValues: {'coneMeters': 9},
          tags: {'paralyzed', 'repeat_save_end_of_turn'},
        ),
      ],
    ),
  ],
  multiattacks: [
    _referenceMultiattack(
      id: 'five_arms',
      description: 'Cinque attacchi con il Braccio.',
      actionUses: const {'arm': 5},
    ),
  ],
);

const _manualFlumph = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Flumph',
  pageStart: 136,
);

const _manualImp = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Imp',
  pageStart: 78,
);

const _manualPseudodragon = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Pseudodrago',
  pageStart: 255,
);

const _manualQuasit = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Quasit',
  pageStart: 63,
);

const _manualSprite = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Spiritello',
  pageStart: 281,
);

const _manualUnicorn = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Unicorno',
  pageStart: 293,
  pageEnd: 294,
);

CreatureRuleDefinition _closureTrait({
  required String id,
  required String name,
  required String description,
  Set<String> tags = const {},
}) =>
    CreatureRuleDefinition(
      id: id,
      name: name,
      description: description,
      tags: tags,
    );

CreatureActionDefinition _closureMeleeAttack({
  required String id,
  required String name,
  required int attackBonus,
  required double reachMeters,
  required String target,
  required String description,
  required String damageType,
  required int averageDamage,
  required int diceCount,
  required int dieSize,
  int modifier = 0,
  List<CreatureDamageDefinition> additionalDamages = const [],
  CreatureSavingThrowDefinition? savingThrow,
  List<CreatureEffectDefinition> effects = const [],
  Set<String> tags = const {},
}) =>
    CreatureActionDefinition(
      id: id,
      name: name,
      description: description,
      tags: tags,
      savingThrow: savingThrow,
      effects: effects,
      attack: CreatureAttackDefinition(
        type: CreatureAttackType.meleeWeapon,
        attackBonus: attackBonus,
        reachMeters: reachMeters,
        target: target,
        damages: [
          CreatureDamageDefinition(
            damageType: damageType,
            average: averageDamage,
            diceCount: diceCount,
            dieSize: dieSize,
            modifier: modifier,
          ),
          ...additionalDamages,
        ],
      ),
    );

CreatureActionDefinition _closureRangedAttack({
  required String id,
  required String name,
  required int attackBonus,
  required double normalRangeMeters,
  required double longRangeMeters,
  required String target,
  required String description,
  required String damageType,
  required int averageDamage,
  required int diceCount,
  required int dieSize,
  int modifier = 0,
  CreatureSavingThrowDefinition? savingThrow,
  List<CreatureEffectDefinition> effects = const [],
  Set<String> tags = const {},
}) =>
    CreatureActionDefinition(
      id: id,
      name: name,
      description: description,
      tags: tags,
      savingThrow: savingThrow,
      effects: effects,
      attack: CreatureAttackDefinition(
        type: CreatureAttackType.rangedWeapon,
        attackBonus: attackBonus,
        normalRangeMeters: normalRangeMeters,
        longRangeMeters: longRangeMeters,
        target: target,
        damages: [
          CreatureDamageDefinition(
            damageType: damageType,
            average: averageDamage,
            diceCount: diceCount,
            dieSize: dieSize,
            modifier: modifier,
          ),
        ],
      ),
    );

CreatureDefinition _closureCreature({
  required String id,
  required String name,
  required BestiarySourceDefinition source,
  required CreatureSize size,
  required CreatureType type,
  Set<String> subtypes = const {},
  Set<String> tags = const {},
  required String alignment,
  required int armorClass,
  String? armorDescription,
  required int averageHitPoints,
  required int hitDiceCount,
  required int hitDieSize,
  int hitPointModifier = 0,
  required CreatureAbilityScores abilities,
  required List<CreatureMovementDefinition> movements,
  Map<String, int> savingThrowBonuses = const {},
  Map<String, int> skillBonuses = const {},
  Set<String> damageVulnerabilities = const {},
  Set<String> damageResistances = const {},
  Set<String> damageImmunities = const {},
  Set<String> conditionImmunities = const {},
  List<CreatureSenseDefinition> senses = const [],
  required int passivePerception,
  Set<String> languages = const {},
  List<CreatureCommunicationDefinition> communications = const [],
  required double challengeRating,
  required int experiencePoints,
  int proficiencyBonus = 2,
  List<CreatureRuleDefinition> traits = const [],
  List<CreatureActionDefinition> actions = const [],
  int legendaryActionUses = 0,
  List<CreatureActionDefinition> legendaryActions = const [],
  CreatureLairDefinition? lair,
  List<CreatureSpellcastingDefinition> spellcasting = const [],
  String? description,
}) =>
    CreatureDefinition(
      id: id,
      name: name,
      source: source,
      origin: BestiaryContentOrigin.official,
      size: size,
      type: type,
      subtypes: subtypes,
      tags: tags,
      alignment: alignment,
      armorClass: CreatureArmorClassDefinition(
        value: armorClass,
        description: armorDescription,
      ),
      hitPoints: CreatureHitPointsDefinition(
        average: averageHitPoints,
        diceCount: hitDiceCount,
        dieSize: hitDieSize,
        modifier: hitPointModifier,
      ),
      abilities: abilities,
      movements: movements,
      savingThrowBonuses: savingThrowBonuses,
      skillBonuses: skillBonuses,
      damageVulnerabilities: damageVulnerabilities,
      damageResistances: damageResistances,
      damageImmunities: damageImmunities,
      conditionImmunities: conditionImmunities,
      senses: senses,
      passivePerception: passivePerception,
      languages: languages,
      communications: communications,
      challengeRating: challengeRating,
      experiencePoints: experiencePoints,
      proficiencyBonus: proficiencyBonus,
      traits: traits,
      actions: actions,
      legendaryActionUses: legendaryActionUses,
      legendaryActions: legendaryActions,
      lair: lair,
      spellcasting: spellcasting,
      description: description,
    );

final flumphDefinition = _closureCreature(
  id: BestiaryCreatureIds.flumph,
  name: 'Flumph',
  source: _manualFlumph,
  size: CreatureSize.small,
  type: CreatureType.aberration,
  tags: const {'telepathic', 'flying'},
  alignment: 'legale buono',
  armorClass: 12,
  averageHitPoints: 7,
  hitDiceCount: 2,
  hitDieSize: 6,
  abilities: const CreatureAbilityScores(
    strength: 6,
    dexterity: 15,
    constitution: 10,
    intelligence: 14,
    wisdom: 14,
    charisma: 11,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 1.5,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 9,
    ),
  ],
  skillBonuses: const {
    'arcana': 4,
    'religion': 4,
    'history': 4,
  },
  damageVulnerabilities: const {'psichico'},
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 12,
  languages: const {'Sottocomune'},
  communications: [
    CreatureCommunicationDefinition(
      type: CreatureCommunicationType.telepathy,
      value: 'Telepatia',
      rangeMeters: 18,
    ),
    const CreatureCommunicationDefinition(
      type: CreatureCommunicationType.understandsOnly,
      value: 'Sottocomune',
    ),
  ],
  challengeRating: 0.125,
  experiencePoints: 25,
  traits: [
    _closureTrait(
      id: 'advanced_telepathy',
      name: 'Telepatia Avanzata',
      description:
          'Il flumph percepisce il contenuto di ogni comunicazione telepatica '
          'usata entro 18 metri e non può essere sorpreso da una creatura dotata '
          'di una forma di telepatia.',
      tags: const {'telepathy', 'communication', 'cannot_be_surprised'},
    ),
    _closureTrait(
      id: 'prone_deficiency',
      name: 'Incapacità da Prono',
      description:
          'Se il flumph viene buttato a terra, atterra capovolto ed è incapacitato. '
          'Alla fine di ogni suo turno può effettuare un tiro salvezza su '
          'Destrezza con CD 10, rimettendosi diritto in caso di successo.',
      tags: const {'prone', 'incapacitated', 'dexterity_save_dc_10'},
    ),
    _closureTrait(
      id: 'telepathic_shroud',
      name: 'Manto Telepatico',
      description:
          'Il flumph è immune a qualsiasi effetto che ne percepisca le emozioni '
          'o ne legga i pensieri, nonché agli incantesimi di divinazione.',
      tags: const {'telepathy', 'thought_immunity', 'divination_immunity'},
    ),
  ],
  actions: [
    _closureMeleeAttack(
      id: 'tendrils',
      name: 'Tentacoli',
      attackBonus: 4,
      reachMeters: 1.5,
      target: 'una creatura',
      description:
          'Attacco con arma da mischia. Il bersaglio colpito subisce danni da '
          'acido e deve superare un tiro salvezza su Costituzione con CD 10, '
          'altrimenti è avvelenato per 1d4 ore ed emana un odore percepibile '
          'fino a 90 metri. L’effetto termina se viene ripulito con acqua.',
      damageType: 'acido',
      averageDamage: 4,
      diceCount: 1,
      dieSize: 4,
      modifier: 2,
      savingThrow: const CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 10,
        success: 'nessun effetto aggiuntivo',
        failure: 'avvelenato per 1d4 ore',
      ),
      effects: const [
        CreatureEffectDefinition(
          id: 'tendrils_stench',
          target: 'bersaglio',
          condition: 'avvelenato',
          duration: '1d4 ore o finché ripulito con acqua',
          numericValues: {'detectionRangeMeters': 90},
          tags: {'stench', 'poisoned'},
        ),
      ],
    ),
    const CreatureActionDefinition(
      id: 'stench_spray',
      name: 'Spruzzo Maleodorante',
      description:
          'Una volta al giorno il flumph spruzza un liquido in un cono di '
          '4,5 metri. Ogni creatura nell’area deve superare un tiro salvezza '
          'su Destrezza con CD 10 o essere ricoperta e avvelenata per 1d4 ore. '
          'L’odore può essere rimosso durante un riposo breve usando acqua, '
          'alcol o aceto.',
      uses: 1,
      tags: {'cone_4_5_meters', 'stench', 'poisoned'},
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'DES',
        difficultyClass: 10,
        success: 'nessun effetto',
        failure: 'ricoperto e avvelenato per 1d4 ore',
      ),
      effects: [
        CreatureEffectDefinition(
          id: 'stench_spray_coating',
          target: 'creature in un cono di 4,5 metri',
          condition: 'avvelenato',
          duration: '1d4 ore o finché ripulito',
          tags: {'stench', 'removable_with_water_alcohol_or_vinegar'},
        ),
      ],
    ),
  ],
);

final impDefinition = _closureCreature(
  id: BestiaryCreatureIds.imp,
  name: 'Imp',
  source: _manualImp,
  size: CreatureSize.tiny,
  type: CreatureType.fiend,
  subtypes: const {'devil', 'shapechanger'},
  tags: const {'familiar_option', 'telepathic', 'flying'},
  alignment: 'legale malvagio',
  armorClass: 13,
  averageHitPoints: 10,
  hitDiceCount: 3,
  hitDieSize: 4,
  hitPointModifier: 3,
  abilities: const CreatureAbilityScores(
    strength: 6,
    dexterity: 17,
    constitution: 13,
    intelligence: 11,
    wisdom: 12,
    charisma: 14,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 6,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 12,
    ),
  ],
  skillBonuses: const {
    'stealth': 5,
    'deception': 4,
    'insight': 3,
    'persuasion': 4,
  },
  damageResistances: const {
    'freddo',
    'contundente_perforante_tagliente_da_attacchi_non_magici_non_argentati',
  },
  damageImmunities: const {'fuoco', 'veleno'},
  conditionImmunities: const {'avvelenato'},
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 36,
    ),
  ],
  passivePerception: 11,
  languages: const {'Comune', 'Infernale'},
  communications: [
    CreatureCommunicationDefinition(
      type: CreatureCommunicationType.telepathy,
      value: 'Telepatia',
      rangeMeters: 36,
    ),
  ],
  challengeRating: 1,
  experiencePoints: 200,
  traits: [
    _closureTrait(
      id: 'shapechanger',
      name: 'Mutaforma',
      description:
          'L’imp può usare la sua azione per trasformarsi in un corvo, un ratto '
          'o un ragno, oppure per tornare alla sua vera forma. Le statistiche '
          'rimangono invariate salvo le velocità indicate dal manuale. '
          'L’equipaggiamento non cambia forma e alla morte torna alla vera forma.',
      tags: const {
        'shapechanger',
        'raven_form',
        'rat_form',
        'spider_form',
      },
    ),
    _closureTrait(
      id: 'devils_sight',
      name: 'Vista del Diavolo',
      description: 'L’oscurità magica non ostacola la scurovisione dell’imp.',
      tags: const {'darkvision', 'magical_darkness'},
    ),
    _closureTrait(
      id: 'magic_resistance',
      name: 'Resistenza alla Magia',
      description:
          'L’imp dispone di vantaggio ai tiri salvezza contro incantesimi '
          'e altri effetti magici.',
      tags: const {'magic_resistance', 'saving_throw_advantage'},
    ),
  ],
  actions: [
    _closureMeleeAttack(
      id: 'sting',
      name: 'Pungiglione',
      attackBonus: 5,
      reachMeters: 1.5,
      target: 'una creatura',
      description:
          'Attacco con arma da mischia. Il bersaglio subisce danni perforanti '
          'e deve effettuare un tiro salvezza su Costituzione con CD 11, '
          'subendo 10 danni da veleno in caso di fallimento o la metà in caso '
          'di successo.',
      damageType: 'perforante',
      averageDamage: 5,
      diceCount: 1,
      dieSize: 4,
      modifier: 3,
      additionalDamages: const [
        CreatureDamageDefinition(
          damageType: 'veleno',
          average: 10,
          diceCount: 3,
          dieSize: 6,
          condition: 'metà danni con tiro salvezza superato',
        ),
      ],
      savingThrow: const CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 11,
        success: 'metà dei danni da veleno',
        failure: '10 (3d6) danni da veleno',
      ),
    ),
    const CreatureActionDefinition(
      id: 'invisibility',
      name: 'Invisibilità',
      description:
          'L’imp diventa invisibile finché non attacca, finché non termina '
          'la propria concentrazione come se si concentrasse su un incantesimo, '
          'oppure finché la concentrazione non termina.',
      tags: {'invisible', 'concentration'},
      effects: [
        CreatureEffectDefinition(
          id: 'imp_invisibility',
          target: 'sé stesso',
          condition: 'invisibile',
          duration: 'finché attacca o perde la concentrazione',
        ),
      ],
    ),
  ],
);

final pseudodragonDefinition = _closureCreature(
  id: BestiaryCreatureIds.pseudodragon,
  name: 'Pseudodrago',
  source: _manualPseudodragon,
  size: CreatureSize.tiny,
  type: CreatureType.dragon,
  tags: const {'familiar_option', 'telepathic', 'flying'},
  alignment: 'neutrale buono',
  armorClass: 13,
  averageHitPoints: 7,
  hitDiceCount: 2,
  hitDieSize: 4,
  hitPointModifier: 2,
  abilities: const CreatureAbilityScores(
    strength: 6,
    dexterity: 15,
    constitution: 13,
    intelligence: 10,
    wisdom: 12,
    charisma: 10,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 4.5,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 18,
    ),
  ],
  skillBonuses: const {'perception': 3, 'stealth': 4},
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.blindsight,
      meters: 3,
    ),
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 13,
  languages: const {'Comune', 'Draconico'},
  communications: [
    CreatureCommunicationDefinition(
      type: CreatureCommunicationType.telepathy,
      value: 'Telepatia',
      rangeMeters: 30,
    ),
    const CreatureCommunicationDefinition(
      type: CreatureCommunicationType.understandsOnly,
      value: 'Comune e Draconico',
    ),
  ],
  challengeRating: 0.25,
  experiencePoints: 50,
  traits: [
    _closureTrait(
      id: 'keen_senses',
      name: 'Sensi Acuti',
      description: 'Il pseudodrago dispone di vantaggio alle prove di Saggezza '
          '(Percezione) basate sull’udito, sulla vista o sull’olfatto.',
      tags: const {'hearing', 'sight', 'smell', 'perception_advantage'},
    ),
    _closureTrait(
      id: 'magic_resistance',
      name: 'Resistenza alla Magia',
      description:
          'Il pseudodrago dispone di vantaggio ai tiri salvezza contro '
          'incantesimi e altri effetti magici.',
      tags: const {'magic_resistance', 'saving_throw_advantage'},
    ),
    _closureTrait(
      id: 'limited_telepathy',
      name: 'Telepatia Limitata',
      description:
          'Il pseudodrago può comunicare telepaticamente semplici idee, '
          'emozioni e immagini a una creatura entro 30 metri che sia in grado '
          'di capire un linguaggio.',
      tags: const {'telepathy', 'range_30_meters', 'simple_concepts'},
    ),
  ],
  actions: [
    _closureMeleeAttack(
      id: 'bite',
      name: 'Morso',
      attackBonus: 4,
      reachMeters: 1.5,
      target: 'una creatura',
      description: 'Attacco con arma da mischia.',
      damageType: 'perforante',
      averageDamage: 4,
      diceCount: 1,
      dieSize: 4,
      modifier: 2,
    ),
    _closureMeleeAttack(
      id: 'sting',
      name: 'Pungiglione',
      attackBonus: 4,
      reachMeters: 1.5,
      target: 'una creatura',
      description:
          'Il bersaglio deve superare un tiro salvezza su Costituzione con '
          'CD 11 o essere avvelenato per 1 ora. Se fallisce di 5 o più, cade '
          'privo di sensi per la stessa durata. L’effetto termina se subisce '
          'danni o se una creatura usa un’azione per svegliarlo.',
      damageType: 'perforante',
      averageDamage: 4,
      diceCount: 1,
      dieSize: 4,
      modifier: 2,
      savingThrow: const CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 11,
        success: 'nessun effetto aggiuntivo',
        failure: 'avvelenato; privo di sensi se fallisce di 5 o più',
      ),
      effects: const [
        CreatureEffectDefinition(
          id: 'pseudodragon_sting_poison',
          target: 'bersaglio',
          condition: 'avvelenato',
          duration: '1 ora',
          tags: {'unconscious_on_failure_by_5', 'ends_on_damage_or_waking'},
        ),
      ],
    ),
  ],
);

final quasitDefinition = _closureCreature(
  id: BestiaryCreatureIds.quasit,
  name: 'Quasit',
  source: _manualQuasit,
  size: CreatureSize.tiny,
  type: CreatureType.fiend,
  subtypes: const {'demon', 'shapechanger'},
  tags: const {'familiar_option', 'telepathic'},
  alignment: 'caotico malvagio',
  armorClass: 13,
  averageHitPoints: 7,
  hitDiceCount: 3,
  hitDieSize: 4,
  abilities: const CreatureAbilityScores(
    strength: 5,
    dexterity: 17,
    constitution: 10,
    intelligence: 7,
    wisdom: 10,
    charisma: 10,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 12,
    ),
  ],
  skillBonuses: const {'stealth': 5},
  damageResistances: const {
    'freddo',
    'fuoco',
    'fulmine',
    'contundente_perforante_tagliente_da_attacchi_non_magici',
  },
  damageImmunities: const {'veleno'},
  conditionImmunities: const {'avvelenato'},
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 36,
    ),
  ],
  passivePerception: 10,
  languages: const {'Abissale', 'Comune'},
  communications: [
    CreatureCommunicationDefinition(
      type: CreatureCommunicationType.telepathy,
      value: 'Telepatia',
      rangeMeters: 36,
    ),
  ],
  challengeRating: 1,
  experiencePoints: 200,
  traits: [
    _closureTrait(
      id: 'shapechanger',
      name: 'Mutaforma',
      description:
          'Il quasit può trasformarsi in un pipistrello, un millepiedi o un '
          'rospo, oppure tornare alla sua vera forma. Le statistiche rimangono '
          'invariate salvo le velocità indicate dal manuale. Alla morte torna '
          'alla vera forma.',
      tags: const {
        'shapechanger',
        'bat_form',
        'centipede_form',
        'toad_form',
      },
    ),
    _closureTrait(
      id: 'magic_resistance',
      name: 'Resistenza alla Magia',
      description:
          'Il quasit dispone di vantaggio ai tiri salvezza contro incantesimi '
          'e altri effetti magici.',
      tags: const {'magic_resistance', 'saving_throw_advantage'},
    ),
  ],
  actions: [
    _closureMeleeAttack(
      id: 'claws',
      name: 'Artigli',
      attackBonus: 4,
      reachMeters: 1.5,
      target: 'una creatura',
      description:
          'Il bersaglio deve effettuare un tiro salvezza su Costituzione con '
          'CD 10. Se lo fallisce, subisce 5 danni da veleno ed è avvelenato '
          'per 1 minuto; può ripetere il tiro alla fine di ogni suo turno.',
      damageType: 'perforante',
      averageDamage: 5,
      diceCount: 1,
      dieSize: 4,
      modifier: 3,
      additionalDamages: const [
        CreatureDamageDefinition(
          damageType: 'veleno',
          average: 5,
          diceCount: 2,
          dieSize: 4,
          condition: 'tiro salvezza su Costituzione con CD 10 fallito',
        ),
      ],
      savingThrow: const CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 10,
        success: 'nessun danno da veleno e nessuna condizione',
        failure: '5 (2d4) danni da veleno e avvelenato per 1 minuto',
      ),
      effects: const [
        CreatureEffectDefinition(
          id: 'quasit_claw_poison',
          target: 'bersaglio',
          condition: 'avvelenato',
          duration: '1 minuto',
          tags: {'repeat_save_at_end_of_turn'},
        ),
      ],
    ),
    const CreatureActionDefinition(
      id: 'scare',
      name: 'Spaventare',
      description:
          'Una creatura entro 6 metri deve superare un tiro salvezza su '
          'Saggezza con CD 10 o essere spaventata per 1 minuto. Può ripetere '
          'il tiro alla fine di ogni suo turno, con svantaggio se il quasit '
          'è visibile.',
      uses: 1,
      tags: {'range_6_meters', 'frightened', 'recharges_after_rest'},
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'SAG',
        difficultyClass: 10,
        success: 'nessun effetto',
        failure: 'spaventato per 1 minuto',
      ),
      effects: [
        CreatureEffectDefinition(
          id: 'quasit_frightened',
          target: 'una creatura entro 6 metri',
          condition: 'spaventato',
          duration: '1 minuto',
          tags: {'repeat_save', 'disadvantage_if_quasit_visible'},
        ),
      ],
    ),
    const CreatureActionDefinition(
      id: 'invisibility',
      name: 'Invisibilità',
      description:
          'Il quasit diventa invisibile finché non attacca, usa Spaventare '
          'o termina la propria concentrazione.',
      tags: {'invisible', 'concentration'},
      effects: [
        CreatureEffectDefinition(
          id: 'quasit_invisibility',
          target: 'sé stesso',
          condition: 'invisibile',
          duration: 'finché attacca, usa Spaventare o perde la concentrazione',
        ),
      ],
    ),
  ],
);

final spriteDefinition = _closureCreature(
  id: BestiaryCreatureIds.sprite,
  name: 'Spiritello',
  source: _manualSprite,
  size: CreatureSize.tiny,
  type: CreatureType.fey,
  tags: const {'familiar_option', 'flying'},
  alignment: 'neutrale buono',
  armorClass: 15,
  armorDescription: 'armatura di cuoio',
  averageHitPoints: 2,
  hitDiceCount: 1,
  hitDieSize: 4,
  abilities: const CreatureAbilityScores(
    strength: 3,
    dexterity: 18,
    constitution: 10,
    intelligence: 14,
    wisdom: 13,
    charisma: 11,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 3,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 12,
    ),
  ],
  skillBonuses: const {'perception': 3, 'stealth': 8},
  passivePerception: 13,
  languages: const {'Comune', 'Elfico', 'Silvano'},
  challengeRating: 0.25,
  experiencePoints: 50,
  actions: [
    _closureMeleeAttack(
      id: 'longsword',
      name: 'Spada Lunga',
      attackBonus: 2,
      reachMeters: 1.5,
      target: 'una creatura',
      description: 'Attacco con arma da mischia.',
      damageType: 'tagliente',
      averageDamage: 1,
      diceCount: 0,
      dieSize: 0,
      modifier: 1,
    ),
    _closureRangedAttack(
      id: 'shortbow',
      name: 'Arco Corto',
      attackBonus: 6,
      normalRangeMeters: 12,
      longRangeMeters: 48,
      target: 'una creatura',
      description:
          'Il bersaglio deve superare un tiro salvezza su Costituzione con '
          'CD 10 o essere avvelenato per 1 minuto. Se fallisce di 5 o più, '
          'cade privo di sensi. L’effetto termina se subisce danni o se una '
          'creatura usa un’azione per svegliarlo.',
      damageType: 'perforante',
      averageDamage: 1,
      diceCount: 0,
      dieSize: 0,
      modifier: 1,
      savingThrow: const CreatureSavingThrowDefinition(
        ability: 'COS',
        difficultyClass: 10,
        success: 'nessun effetto aggiuntivo',
        failure: 'avvelenato; privo di sensi se fallisce di 5 o più',
      ),
      effects: const [
        CreatureEffectDefinition(
          id: 'sprite_arrow_poison',
          target: 'bersaglio',
          condition: 'avvelenato',
          duration: '1 minuto',
          tags: {'unconscious_on_failure_by_5', 'ends_on_damage_or_waking'},
        ),
      ],
    ),
    const CreatureActionDefinition(
      id: 'heart_sight',
      name: 'Vista del Cuore',
      description:
          'Lo spiritello tocca una creatura e ne apprende lo stato emotivo. '
          'Se il bersaglio fallisce un tiro salvezza su Carisma con CD 10, '
          'lo spiritello ne apprende anche l’allineamento. Celestiali, immondi '
          'e non morti rivelano inoltre la propria natura.',
      tags: {'touch', 'emotion_detection', 'alignment_detection'},
      savingThrow: CreatureSavingThrowDefinition(
        ability: 'CAR',
        difficultyClass: 10,
        success: 'rivela soltanto lo stato emotivo',
        failure: 'rivela stato emotivo, allineamento e natura speciale',
      ),
    ),
    const CreatureActionDefinition(
      id: 'invisibility',
      name: 'Invisibilità',
      description:
          'Lo spiritello diventa invisibile finché non attacca, lancia un '
          'incantesimo o termina la propria concentrazione. Anche il suo '
          'equipaggiamento diventa invisibile.',
      tags: {'invisible', 'concentration', 'equipment_invisible'},
      effects: [
        CreatureEffectDefinition(
          id: 'sprite_invisibility',
          target: 'sé stesso e il suo equipaggiamento',
          condition: 'invisibile',
          duration:
              'finché attacca, lancia un incantesimo o perde la concentrazione',
        ),
      ],
    ),
  ],
);

final unicornDefinition = _closureCreature(
  id: BestiaryCreatureIds.unicorn,
  name: 'Unicorno',
  source: _manualUnicorn,
  size: CreatureSize.large,
  type: CreatureType.celestial,
  tags: const {'legendary', 'telepathic', 'mount'},
  alignment: 'legale buono',
  armorClass: 12,
  averageHitPoints: 67,
  hitDiceCount: 9,
  hitDieSize: 10,
  hitPointModifier: 18,
  abilities: const CreatureAbilityScores(
    strength: 18,
    dexterity: 14,
    constitution: 15,
    intelligence: 11,
    wisdom: 17,
    charisma: 16,
  ),
  movements: const [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 15,
    ),
  ],
  damageImmunities: const {'veleno'},
  conditionImmunities: const {'affascinato', 'avvelenato', 'paralizzato'},
  senses: const [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 13,
  languages: const {'Celestiale', 'Elfico', 'Silvano'},
  communications: [
    CreatureCommunicationDefinition(
      type: CreatureCommunicationType.telepathy,
      value: 'Telepatia',
      rangeMeters: 18,
    ),
  ],
  challengeRating: 5,
  experiencePoints: 1800,
  proficiencyBonus: 3,
  traits: [
    _closureTrait(
      id: 'charge',
      name: 'Carica',
      description:
          'Se l’unicorno si muove di almeno 6 metri in linea retta verso un '
          'bersaglio e poi lo colpisce con il Corno nello stesso turno, '
          'infligge 9 (2d8) danni perforanti aggiuntivi. Il bersaglio deve '
          'superare un tiro salvezza su Forza con CD 15 o cadere prono.',
      tags: const {
        'charge',
        'minimum_6_meters',
        'extra_2d8_piercing',
        'strength_save_dc_15',
        'prone',
      },
    ),
    _closureTrait(
      id: 'magic_resistance',
      name: 'Resistenza alla Magia',
      description:
          'L’unicorno dispone di vantaggio ai tiri salvezza contro incantesimi '
          'e altri effetti magici.',
      tags: const {'magic_resistance', 'saving_throw_advantage'},
    ),
    _closureTrait(
      id: 'magic_weapons',
      name: 'Armi Magiche',
      description:
          'Gli attacchi con arma dell’unicorno sono considerati magici.',
      tags: const {'magical_weapon_attacks'},
    ),
  ],
  spellcasting: const [
    CreatureSpellcastingDefinition(
      ability: 'CAR',
      spellSaveDifficultyClass: 14,
      innate: true,
      requiresComponents: false,
      atWillSpellIds: {
        'druidcraft',
        'detect_evil_and_good',
        'pass_without_trace',
      },
      limitedUsesBySpellId: {
        'calm_emotions': 1,
        'dispel_evil_and_good': 1,
        'entangle': 1,
      },
    ),
  ],
  actions: [
    _closureMeleeAttack(
      id: 'hooves',
      name: 'Zoccoli',
      attackBonus: 7,
      reachMeters: 1.5,
      target: 'una creatura',
      description: 'Attacco con arma da mischia.',
      damageType: 'contundente',
      averageDamage: 11,
      diceCount: 2,
      dieSize: 6,
      modifier: 4,
    ),
    _closureMeleeAttack(
      id: 'horn',
      name: 'Corno',
      attackBonus: 7,
      reachMeters: 1.5,
      target: 'una creatura',
      description: 'Attacco con arma da mischia.',
      damageType: 'perforante',
      averageDamage: 8,
      diceCount: 1,
      dieSize: 8,
      modifier: 4,
    ),
    const CreatureActionDefinition(
      id: 'healing_touch',
      name: 'Tocco Guaritore',
      description: 'L’unicorno tocca un’altra creatura. Il bersaglio recupera '
          '11 (2d8+2) punti ferita e viene liberato da tutte le malattie '
          'e da tutti i veleni che lo affliggono.',
      uses: 3,
      tags: {'healing', 'cures_disease', 'neutralizes_poison'},
      effects: [
        CreatureEffectDefinition(
          id: 'unicorn_healing_touch',
          target: 'un’altra creatura',
          numericValues: {
            'averageHealing': 11,
            'healingDiceCount': 2,
            'healingDieSize': 8,
            'healingModifier': 2,
          },
          tags: {
            'restore_hit_points',
            'cure_all_diseases',
            'remove_all_poisons'
          },
        ),
      ],
    ),
    const CreatureActionDefinition(
      id: 'teleport',
      name: 'Teletrasporto',
      description:
          'L’unicorno teletrasporta magicamente sé stesso e fino a tre creature '
          'consenzienti entro 1,5 metri, assieme all’equipaggiamento trasportato, '
          'in un luogo che conosce entro 1,5 km.',
      uses: 1,
      tags: {'teleport', 'up_to_three_willing_creatures'},
      effects: [
        CreatureEffectDefinition(
          id: 'unicorn_teleport',
          target: 'sé stesso e fino a tre creature consenzienti',
          numericValues: {
            'selectionRangeMeters': 1.5,
            'destinationRangeMeters': 1500,
            'maximumAdditionalCreatures': 3,
          },
          tags: {'teleport', 'carried_equipment'},
        ),
      ],
    ),
  ],
  legendaryActionUses: 3,
  legendaryActions: const [
    CreatureActionDefinition(
      id: 'legendary_hooves',
      name: 'Zoccoli',
      type: CreatureActionType.legendaryAction,
      legendaryActionCost: 1,
      description: 'L’unicorno effettua un attacco con gli Zoccoli.',
      tags: {'references_hooves'},
    ),
    CreatureActionDefinition(
      id: 'shimmering_shield',
      name: 'Scudo Scintillante',
      type: CreatureActionType.legendaryAction,
      legendaryActionCost: 2,
      description:
          'L’unicorno crea un campo magico scintillante attorno a sé stesso '
          'o a un’altra creatura entro 18 metri. Il bersaglio ottiene un bonus '
          'di +2 alla CA fino alla fine del turno successivo dell’unicorno.',
      tags: {'range_18_meters', 'armor_class_bonus_2'},
      effects: [
        CreatureEffectDefinition(
          id: 'shimmering_shield_bonus',
          target: 'sé stesso o una creatura entro 18 metri',
          duration: 'fino alla fine del turno successivo dell’unicorno',
          numericValues: {'armorClassBonus': 2},
        ),
      ],
    ),
    CreatureActionDefinition(
      id: 'heal_self',
      name: 'Guarire Sé Stesso',
      type: CreatureActionType.legendaryAction,
      legendaryActionCost: 3,
      description: 'L’unicorno recupera 11 (2d8+2) punti ferita.',
      tags: {'self_healing'},
      effects: [
        CreatureEffectDefinition(
          id: 'unicorn_self_healing',
          target: 'sé stesso',
          numericValues: {
            'averageHealing': 11,
            'healingDiceCount': 2,
            'healingDieSize': 8,
            'healingModifier': 2,
          },
        ),
      ],
    ),
  ],
  lair: const CreatureLairDefinition(
    description:
        'La tana di un unicorno è permeata dalla sua magia celestiale e produce '
        'gli effetti regionali descritti dal Manuale dei Mostri.',
    regionalEffects: [
      CreatureRegionalEffectDefinition(
        id: 'unicorn_extinguishes_flames',
        name: 'Fiamme Soffocate',
        description:
            'Le fiamme non magiche accese entro la regione vengono soffocate.',
        radiusMeters: 9000,
        endingCondition: 'termina immediatamente alla morte dell’unicorno',
      ),
      CreatureRegionalEffectDefinition(
        id: 'unicorn_hidden_creatures',
        name: 'Creature Protette',
        description:
            'Le creature native dell’area dispongono di vantaggio alle prove '
            'di Destrezza (Furtività) effettuate per nascondersi.',
        radiusMeters: 9000,
        endingCondition: 'termina immediatamente alla morte dell’unicorno',
      ),
      CreatureRegionalEffectDefinition(
        id: 'unicorn_maximized_healing',
        name: 'Guarigione Potenziata',
        description:
            'Quando una creatura buona lancia un incantesimo o usa un effetto '
            'magico che ripristina punti ferita, recupera il massimo numero '
            'possibile di punti ferita.',
        radiusMeters: 9000,
        endingCondition: 'termina immediatamente alla morte dell’unicorno',
      ),
      CreatureRegionalEffectDefinition(
        id: 'unicorn_suppressed_curses',
        name: 'Maledizioni Soppresse',
        description:
            'Le maledizioni che influenzano una creatura buona sono soppresse '
            'finché la creatura rimane nella regione.',
        radiusMeters: 9000,
        endingCondition: 'termina immediatamente alla morte dell’unicorno',
      ),
    ],
  ),
  description:
      'Celestiale leggendario protettore dei boschi sacri e delle creature buone.',
);

final Map<String, CreatureDefinition> phbBestiaryClassReferenceDefinitions = {
  BestiaryCreatureIds.flumph: flumphDefinition,
  BestiaryCreatureIds.imp: impDefinition,
  BestiaryCreatureIds.pseudodragon: pseudodragonDefinition,
  BestiaryCreatureIds.quasit: quasitDefinition,
  BestiaryCreatureIds.sprite: spriteDefinition,
  BestiaryCreatureIds.unicorn: unicornDefinition,
  BestiaryCreatureIds.airElemental: airElementalDefinition,
  BestiaryCreatureIds.earthElemental: earthElementalDefinition,
  BestiaryCreatureIds.fireElemental: fireElementalDefinition,
  BestiaryCreatureIds.waterElemental: waterElementalDefinition,
  BestiaryCreatureIds.monodrone: monodroneDefinition,
  BestiaryCreatureIds.duodrone: duodroneDefinition,
  BestiaryCreatureIds.tridrone: tridroneDefinition,
  BestiaryCreatureIds.quadrone: quadroneDefinition,
  BestiaryCreatureIds.pentadrone: pentadroneDefinition,
};

const Map<String, BestiaryCreatureGroupDefinition>
    phbBestiaryCreatureGroupDefinitions = {
  BestiaryCreatureIds.modron: BestiaryCreatureGroupDefinition(
    id: BestiaryCreatureIds.modron,
    name: 'Modron',
    source: _modronSource,
    creatureIds: {
      BestiaryCreatureIds.monodrone,
      BestiaryCreatureIds.duodrone,
      BestiaryCreatureIds.tridrone,
      BestiaryCreatureIds.quadrone,
      BestiaryCreatureIds.pentadrone,
    },
    description: 'Gruppo dei cinque ranghi di modron che il Dungeon Master può '
        'scegliere per effetti che richiedono genericamente un modron.',
  ),
};
