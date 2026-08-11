import 'character_data.dart';
import 'class_data.dart';

const _phb = RuleSource(
  name: 'Manuale del Giocatore',
  reference: 'Capitolo 2: Razze',
);

class RaceIds {
  static const dwarf = 'dwarf';
  static const elf = 'elf';
  static const halfling = 'halfling';
  static const human = 'human';
  static const dragonborn = 'dragonborn';
  static const gnome = 'gnome';
  static const halfElf = 'half_elf';
  static const halfOrc = 'half_orc';
  static const tiefling = 'tiefling';
  static const custom = 'custom_race';
}

class SubraceIds {
  static const hillDwarf = 'hill_dwarf';
  static const mountainDwarf = 'mountain_dwarf';

  static const highElf = 'high_elf';
  static const woodElf = 'wood_elf';
  static const drow = 'drow';

  static const lightfootHalfling = 'lightfoot_halfling';
  static const stoutHalfling = 'stout_halfling';

  static const forestGnome = 'forest_gnome';
  static const rockGnome = 'rock_gnome';
}

class DragonAncestryIds {
  static const black = 'black_dragon';
  static const blue = 'blue_dragon';
  static const brass = 'brass_dragon';
  static const bronze = 'bronze_dragon';
  static const copper = 'copper_dragon';
  static const gold = 'gold_dragon';
  static const green = 'green_dragon';
  static const red = 'red_dragon';
  static const silver = 'silver_dragon';
  static const white = 'white_dragon';
}

class HumanVariantIds {
  static const standard = 'human_standard';
  static const variant = 'human_variant';
}

class RacialFeatureIds {
  static const darkvision = 'darkvision';
  static const dwarvenResilience = 'dwarven_resilience';
  static const dwarvenCombatTraining = 'dwarven_combat_training';
  static const stonecunning = 'stonecunning';
  static const dwarvenToughness = 'dwarven_toughness';

  static const keenSenses = 'keen_senses';
  static const feyAncestry = 'fey_ancestry';
  static const trance = 'trance';

  static const lucky = 'halfling_lucky';
  static const brave = 'halfling_brave';
  static const halflingNimbleness = 'halfling_nimbleness';

  static const draconicAncestry = 'draconic_ancestry';
  static const breathWeapon = 'breath_weapon';

  static const gnomeCunning = 'gnome_cunning';
  static const naturalIllusionist = 'natural_illusionist';

  static const skillVersatility = 'skill_versatility';

  static const infernalLegacy = 'infernal_legacy';
  static const relentlessEndurance = 'relentless_endurance';
  static const savageAttacks = 'savage_attacks';
  static const hellishResistance = 'hellish_resistance';
}

/// Tratto razziale strutturato.
///
/// `content` contiene la parte descrittiva/regolamentare.
/// `effects` contiene soltanto ciò che il runtime può applicare direttamente.
/// Le regole condizionali restano identificabili tramite l'ID del tratto.
class RacialFeatureDefinition {
  final String id;
  final RuleContent content;
  final CharacterEffects effects;

  const RacialFeatureDefinition({
    required this.id,
    required this.content,
    this.effects = const CharacterEffects(),
  });
}

RuleContent _racialFeatureContent(
  String id,
  String name,
  String ownerId,
  String summary, {
  List<GlossaryRef> glossaryRefs = const [],
}) =>
    RuleContent(
      id: id,
      name: name,
      type: RuleContentType.racialTrait,
      description: RuleDescription(
        summary: summary,
        glossaryRefs: glossaryRefs,
      ),
      source: _phb,
      ownerId: ownerId,
    );

final Map<String, RacialFeatureDefinition> racialFeatureDefinitions = {
  // ----------------------------------------------------------
  // NANO
  // ----------------------------------------------------------
  RacialFeatureIds.darkvision: RacialFeatureDefinition(
    id: RacialFeatureIds.darkvision,
    content: _racialFeatureContent(
      RacialFeatureIds.darkvision,
      'Scurovisione',
      RaceIds.dwarf,
      'Permette di vedere in condizioni di luce fioca e oscurità '
          'entro la portata concessa dalla razza.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
      ],
    ),
  ),

  RacialFeatureIds.dwarvenResilience: RacialFeatureDefinition(
    id: RacialFeatureIds.dwarvenResilience,
    content: _racialFeatureContent(
      RacialFeatureIds.dwarvenResilience,
      'Resilienza Nanica',
      RaceIds.dwarf,
      'Concede protezioni razziali contro il veleno.',
      glossaryRefs: const [
        GlossaryRef('damage_resistance', 'Resistenza ai Danni'),
      ],
    ),
    effects: const CharacterEffects(
      damageResistances: {'poison'},
      savingThrowAdvantageAgainst: {'poison'},
    ),
  ),

  RacialFeatureIds.dwarvenCombatTraining: RacialFeatureDefinition(
    id: RacialFeatureIds.dwarvenCombatTraining,
    content: _racialFeatureContent(
      RacialFeatureIds.dwarvenCombatTraining,
      'Addestramento da Combattimento Nanico',
      RaceIds.dwarf,
      'Concede le competenze nelle armi previste dall’addestramento nanico.',
      glossaryRefs: const [
        GlossaryRef('racial_proficiency', 'Competenza Razziale'),
      ],
    ),
    effects: const CharacterEffects(
      weaponProficiencies: {
        'battleaxe',
        'handaxe',
        'light_hammer',
        'warhammer',
      },
    ),
  ),

  RacialFeatureIds.stonecunning: RacialFeatureDefinition(
    id: RacialFeatureIds.stonecunning,
    content: _racialFeatureContent(
      RacialFeatureIds.stonecunning,
      'Esperto Minatore',
      RaceIds.dwarf,
      'Conoscenza razziale specializzata relativa alle opere in pietra.',
    ),
  ),

  RacialFeatureIds.dwarvenToughness: RacialFeatureDefinition(
    id: RacialFeatureIds.dwarvenToughness,
    content: _racialFeatureContent(
      RacialFeatureIds.dwarvenToughness,
      'Robustezza Nanica',
      SubraceIds.hillDwarf,
      'Aumenta i punti ferita massimi in funzione del livello.',
    ),
    effects: const CharacterEffects(
      hitPointsPerLevelBonus: 1,
    ),
  ),

  // ----------------------------------------------------------
  // ELFO
  // ----------------------------------------------------------
  RacialFeatureIds.keenSenses: RacialFeatureDefinition(
    id: RacialFeatureIds.keenSenses,
    content: _racialFeatureContent(
      RacialFeatureIds.keenSenses,
      'Sensi Acuti',
      RaceIds.elf,
      'Concede competenza in Percezione.',
      glossaryRefs: const [
        GlossaryRef('racial_proficiency', 'Competenza Razziale'),
      ],
    ),
    effects: const CharacterEffects(
      skillProficiencies: {'perception'},
    ),
  ),

  RacialFeatureIds.feyAncestry: RacialFeatureDefinition(
    id: RacialFeatureIds.feyAncestry,
    content: _racialFeatureContent(
      RacialFeatureIds.feyAncestry,
      'Retaggio Fatato',
      RaceIds.elf,
      'Concede le protezioni associate al retaggio fatato.',
      glossaryRefs: const [
        GlossaryRef('fey_ancestry', 'Retaggio Fatato'),
      ],
    ),
    effects: const CharacterEffects(
      savingThrowAdvantageAgainst: {'charmed'},
      conditionImmunities: {'magical_sleep'},
    ),
  ),

  RacialFeatureIds.trance: RacialFeatureDefinition(
    id: RacialFeatureIds.trance,
    content: _racialFeatureContent(
      RacialFeatureIds.trance,
      'Trance',
      RaceIds.elf,
      'Forma speciale di riposo propria degli elfi.',
      glossaryRefs: const [
        GlossaryRef('trance', 'Trance'),
      ],
    ),
  ),

  // ----------------------------------------------------------
  // HALFLING
  // ----------------------------------------------------------
  RacialFeatureIds.lucky: RacialFeatureDefinition(
    id: RacialFeatureIds.lucky,
    content: _racialFeatureContent(
      RacialFeatureIds.lucky,
      'Fortunato',
      RaceIds.halfling,
      'Tratto che modifica specifici risultati naturali di d20 '
          'secondo la regola razziale.',
    ),
  ),

  RacialFeatureIds.brave: RacialFeatureDefinition(
    id: RacialFeatureIds.brave,
    content: _racialFeatureContent(
      RacialFeatureIds.brave,
      'Coraggioso',
      RaceIds.halfling,
      'Concede vantaggio ai tiri salvezza contro l’essere spaventato.',
    ),
    effects: const CharacterEffects(
      savingThrowAdvantageAgainst: {'frightened'},
    ),
  ),

  RacialFeatureIds.halflingNimbleness: RacialFeatureDefinition(
    id: RacialFeatureIds.halflingNimbleness,
    content: _racialFeatureContent(
      RacialFeatureIds.halflingNimbleness,
      'Agilità Halfling',
      RaceIds.halfling,
      'Permette un movimento particolare attraverso lo spazio '
          'occupato da creature più grandi.',
    ),
  ),

  // ----------------------------------------------------------
  // DRAGONIDE
  // ----------------------------------------------------------
  RacialFeatureIds.draconicAncestry: RacialFeatureDefinition(
    id: RacialFeatureIds.draconicAncestry,
    content: _racialFeatureContent(
      RacialFeatureIds.draconicAncestry,
      'Discendenza Draconica',
      RaceIds.dragonborn,
      'La discendenza scelta determina il tipo di danno del soffio '
          'e la resistenza razziale associata.',
      glossaryRefs: const [
        GlossaryRef('draconic_ancestry', 'Discendenza Draconica'),
      ],
    ),
  ),

  RacialFeatureIds.breathWeapon: RacialFeatureDefinition(
    id: RacialFeatureIds.breathWeapon,
    content: _racialFeatureContent(
      RacialFeatureIds.breathWeapon,
      'Arma a Soffio',
      RaceIds.dragonborn,
      'Capacità ad area definita dalla Discendenza Draconica scelta.',
      glossaryRefs: const [
        GlossaryRef('breath_weapon', 'Arma a Soffio'),
      ],
    ),
  ),

  // ----------------------------------------------------------
  // GNOMO
  // ----------------------------------------------------------
  RacialFeatureIds.gnomeCunning: RacialFeatureDefinition(
    id: RacialFeatureIds.gnomeCunning,
    content: _racialFeatureContent(
      RacialFeatureIds.gnomeCunning,
      'Astuzia Gnomesca',
      RaceIds.gnome,
      'Concede vantaggio a specifici tiri salvezza contro effetti magici.',
    ),
  ),

  RacialFeatureIds.naturalIllusionist: RacialFeatureDefinition(
    id: RacialFeatureIds.naturalIllusionist,
    content: _racialFeatureContent(
      RacialFeatureIds.naturalIllusionist,
      'Illusionista Naturale',
      SubraceIds.forestGnome,
      'Concede un trucchetto di illusione innato.',
      glossaryRefs: const [
        GlossaryRef('racial_spellcasting', 'Magia Razziale'),
      ],
    ),
    effects: const CharacterEffects(
      grantedCantripIds: ['minor_illusion'],
    ),
  ),

  // ----------------------------------------------------------
  // MEZZELFO
  // ----------------------------------------------------------
  RacialFeatureIds.skillVersatility: RacialFeatureDefinition(
    id: RacialFeatureIds.skillVersatility,
    content: _racialFeatureContent(
      RacialFeatureIds.skillVersatility,
      'Versatilità nelle Abilità',
      RaceIds.halfElf,
      'Concede due competenze nelle abilità scelte dal personaggio.',
      glossaryRefs: const [
        GlossaryRef('racial_proficiency', 'Competenza Razziale'),
      ],
    ),
  ),

  // ----------------------------------------------------------
  // MEZZORCO
  // ----------------------------------------------------------
  RacialFeatureIds.relentlessEndurance: RacialFeatureDefinition(
    id: RacialFeatureIds.relentlessEndurance,
    content: _racialFeatureContent(
      RacialFeatureIds.relentlessEndurance,
      'Tenacia Implacabile',
      RaceIds.halfOrc,
      'Può impedire al Mezzorco di cadere immediatamente a 0 PF '
          'quando ricorrono le condizioni del tratto.',
      glossaryRefs: const [
        GlossaryRef('relentless_endurance', 'Tenacia Implacabile'),
      ],
    ),
  ),

  RacialFeatureIds.savageAttacks: RacialFeatureDefinition(
    id: RacialFeatureIds.savageAttacks,
    content: _racialFeatureContent(
      RacialFeatureIds.savageAttacks,
      'Attacchi Selvaggi',
      RaceIds.halfOrc,
      'Modifica il danno di un colpo critico effettuato con '
          'un attacco con arma da mischia.',
      glossaryRefs: const [
        GlossaryRef('savage_attacks', 'Attacchi Selvaggi'),
      ],
    ),
  ),

  // ----------------------------------------------------------
  // TIEFLING
  // ----------------------------------------------------------
  RacialFeatureIds.hellishResistance: RacialFeatureDefinition(
    id: RacialFeatureIds.hellishResistance,
    content: _racialFeatureContent(
      RacialFeatureIds.hellishResistance,
      'Resistenza Infernale',
      RaceIds.tiefling,
      'Concede resistenza ai danni da fuoco.',
      glossaryRefs: const [
        GlossaryRef('hellish_resistance', 'Resistenza Infernale'),
      ],
    ),
    effects: const CharacterEffects(
      damageResistances: {'fire'},
    ),
  ),

  RacialFeatureIds.infernalLegacy: RacialFeatureDefinition(
    id: RacialFeatureIds.infernalLegacy,
    content: _racialFeatureContent(
      RacialFeatureIds.infernalLegacy,
      'Retaggio Infernale',
      RaceIds.tiefling,
      'Concede capacità magiche razziali che si sbloccano '
          'con il livello del personaggio.',
      glossaryRefs: const [
        GlossaryRef('infernal_legacy', 'Retaggio Infernale'),
        GlossaryRef('racial_progression', 'Progressione Razziale'),
      ],
    ),
  ),
};

RacialFeatureDefinition? racialFeatureDefinitionFor(String id) =>
    racialFeatureDefinitions[id];

const Map<String, DragonBreathDefinition> dragonBreathDefinitions = {
  DragonAncestryIds.black: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.black,
    damageType: 'acid',
    shape: EffectAreaShape.line,
    range: 9,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.blue: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.blue,
    damageType: 'lightning',
    shape: EffectAreaShape.line,
    range: 9,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.brass: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.brass,
    damageType: 'fire',
    shape: EffectAreaShape.line,
    range: 9,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.bronze: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.bronze,
    damageType: 'lightning',
    shape: EffectAreaShape.line,
    range: 9,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.copper: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.copper,
    damageType: 'acid',
    shape: EffectAreaShape.line,
    range: 9,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.gold: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.gold,
    damageType: 'fire',
    shape: EffectAreaShape.cone,
    range: 4.5,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.green: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.green,
    damageType: 'poison',
    shape: EffectAreaShape.cone,
    range: 4.5,
    savingThrowAbility: 'COS',
  ),
  DragonAncestryIds.red: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.red,
    damageType: 'fire',
    shape: EffectAreaShape.cone,
    range: 4.5,
    savingThrowAbility: 'DES',
  ),
  DragonAncestryIds.silver: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.silver,
    damageType: 'cold',
    shape: EffectAreaShape.cone,
    range: 4.5,
    savingThrowAbility: 'COS',
  ),
  DragonAncestryIds.white: DragonBreathDefinition(
    ancestryId: DragonAncestryIds.white,
    damageType: 'cold',
    shape: EffectAreaShape.cone,
    range: 4.5,
    savingThrowAbility: 'COS',
  ),
};

DragonBreathDefinition? dragonBreathDefinitionFor(String ancestryId) =>
    dragonBreathDefinitions[ancestryId];

/// Progressioni razziali PHB che dipendono dal livello totale.
const Map<String, RacialProgressionDefinition> racialProgressions = {
  SubraceIds.drow: RacialProgressionDefinition(
    grants: [
      RacialProgressionGrant(
        minimumLevel: 1,
        type: RacialGrantType.cantrip,
        contentId: 'dancing_lights',
        ability: 'CAR',
      ),
      RacialProgressionGrant(
        minimumLevel: 3,
        type: RacialGrantType.spell,
        contentId: 'faerie_fire',
        uses: 1,
        recharge: 'long_rest',
        ability: 'CAR',
      ),
      RacialProgressionGrant(
        minimumLevel: 5,
        type: RacialGrantType.spell,
        contentId: 'darkness',
        uses: 1,
        recharge: 'long_rest',
        ability: 'CAR',
      ),
    ],
  ),
  RaceIds.tiefling: RacialProgressionDefinition(
    grants: [
      RacialProgressionGrant(
        minimumLevel: 1,
        type: RacialGrantType.cantrip,
        contentId: 'thaumaturgy',
        ability: 'CAR',
      ),
      RacialProgressionGrant(
        minimumLevel: 3,
        type: RacialGrantType.spell,
        contentId: 'hellish_rebuke',
        uses: 1,
        recharge: 'long_rest',
        ability: 'CAR',
      ),
      RacialProgressionGrant(
        minimumLevel: 5,
        type: RacialGrantType.spell,
        contentId: 'darkness',
        uses: 1,
        recharge: 'long_rest',
        ability: 'CAR',
      ),
    ],
  ),
};

RacialProgressionDefinition? racialProgressionFor(String id) =>
    racialProgressions[id];

const dragonbornAncestryOptions = <CharacterChoiceOptionDefinition>[
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.black,
    label: 'Nero',
    effects: CharacterEffects(
      damageResistances: {'acid'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.blue,
    label: 'Blu',
    effects: CharacterEffects(
      damageResistances: {'lightning'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.brass,
    label: 'Ottone',
    effects: CharacterEffects(
      damageResistances: {'fire'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.bronze,
    label: 'Bronzo',
    effects: CharacterEffects(
      damageResistances: {'lightning'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.copper,
    label: 'Rame',
    effects: CharacterEffects(
      damageResistances: {'acid'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.gold,
    label: 'Oro',
    effects: CharacterEffects(
      damageResistances: {'fire'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.green,
    label: 'Verde',
    effects: CharacterEffects(
      damageResistances: {'poison'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.red,
    label: 'Rosso',
    effects: CharacterEffects(
      damageResistances: {'fire'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.silver,
    label: 'Argento',
    effects: CharacterEffects(
      damageResistances: {'cold'},
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: DragonAncestryIds.white,
    label: 'Bianco',
    effects: CharacterEffects(
      damageResistances: {'cold'},
    ),
  ),
];

RuleContent _raceContent(
  String id,
  String name,
  String summary, {
  List<GlossaryRef> glossaryRefs = const [],
}) =>
    RuleContent(
      id: id,
      name: name,
      type: RuleContentType.race,
      description: RuleDescription(
        summary: summary,
        glossaryRefs: glossaryRefs,
      ),
      source: _phb,
      ownerId: id,
    );

const dwarfSubraces = <String, SubraceDefinition>{
  SubraceIds.hillDwarf: SubraceDefinition(
    id: SubraceIds.hillDwarf,
    name: 'Nano delle Colline',
    raceId: RaceIds.dwarf,
    content: RuleContent(
      id: SubraceIds.hillDwarf,
      name: 'Nano delle Colline',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Sottorazza nanica resistente e tenace.',
      ),
      source: _phb,
      ownerId: RaceIds.dwarf,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'SAG', amount: 1),
      ],
      hitPointsPerLevelBonus: 1,
      grantedFeatureIds: [
        RacialFeatureIds.dwarvenToughness,
      ],
    ),
  ),
  SubraceIds.mountainDwarf: SubraceDefinition(
    id: SubraceIds.mountainDwarf,
    name: 'Nano delle Montagne',
    raceId: RaceIds.dwarf,
    content: RuleContent(
      id: SubraceIds.mountainDwarf,
      name: 'Nano delle Montagne',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Sottorazza nanica robusta e addestrata alla guerra.',
      ),
      source: _phb,
      ownerId: RaceIds.dwarf,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'FOR', amount: 2),
      ],
      armorProficiencies: {
        'light_armor',
        'medium_armor',
      },
    ),
  ),
};

const elfSubraces = <String, SubraceDefinition>{
  SubraceIds.highElf: SubraceDefinition(
    id: SubraceIds.highElf,
    name: 'Elfo Alto',
    raceId: RaceIds.elf,
    content: RuleContent(
      id: SubraceIds.highElf,
      name: 'Elfo Alto',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Sottorazza elfica legata allo studio e alla magia.',
      ),
      source: _phb,
      ownerId: RaceIds.elf,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'INT', amount: 1),
      ],
      weaponProficiencies: {
        'longsword',
        'shortsword',
        'shortbow',
        'longbow',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'high_elf_cantrip',
          label: 'Trucchetto da mago',
          type: CharacterChoiceType.cantrip,
        ),
        CharacterChoiceDefinition(
          id: 'high_elf_extra_language',
          label: 'Lingua extra',
          type: CharacterChoiceType.language,
        ),
      ],
    ),
  ),
  SubraceIds.woodElf: SubraceDefinition(
    id: SubraceIds.woodElf,
    name: 'Elfo dei Boschi',
    raceId: RaceIds.elf,
    content: RuleContent(
      id: SubraceIds.woodElf,
      name: 'Elfo dei Boschi',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Sottorazza elfica rapida e legata agli ambienti naturali.',
      ),
      source: _phb,
      ownerId: RaceIds.elf,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'SAG', amount: 1),
      ],
      weaponProficiencies: {
        'longsword',
        'shortsword',
        'shortbow',
        'longbow',
      },
      walkingSpeedOverride: 10.5,
      grantedFeatureIds: [
        'mask_of_the_wild',
      ],
    ),
  ),
  SubraceIds.drow: SubraceDefinition(
    id: SubraceIds.drow,
    name: 'Drow',
    raceId: RaceIds.elf,
    content: RuleContent(
      id: SubraceIds.drow,
      name: 'Drow',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary:
            'Sottorazza elfica dotata di scurovisione superiore e magia innata.',
      ),
      source: _phb,
      ownerId: RaceIds.elf,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'CAR', amount: 1),
      ],
      darkvisionRange: 36,
      weaponProficiencies: {
        'rapier',
        'shortsword',
        'hand_crossbow',
      },
      grantedFeatureIds: [
        'sunlight_sensitivity',
        'drow_magic',
      ],
    ),
  ),
};

const halflingSubraces = <String, SubraceDefinition>{
  SubraceIds.lightfootHalfling: SubraceDefinition(
    id: SubraceIds.lightfootHalfling,
    name: 'Halfling Piedelesto',
    raceId: RaceIds.halfling,
    content: RuleContent(
      id: SubraceIds.lightfootHalfling,
      name: 'Halfling Piedelesto',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Halfling naturalmente furtivo e socievole.',
      ),
      source: _phb,
      ownerId: RaceIds.halfling,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'CAR', amount: 1),
      ],
      grantedFeatureIds: [
        'naturally_stealthy',
      ],
    ),
  ),
  SubraceIds.stoutHalfling: SubraceDefinition(
    id: SubraceIds.stoutHalfling,
    name: 'Halfling Tozzo',
    raceId: RaceIds.halfling,
    content: RuleContent(
      id: SubraceIds.stoutHalfling,
      name: 'Halfling Tozzo',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Halfling particolarmente resistente.',
      ),
      source: _phb,
      ownerId: RaceIds.halfling,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'COS', amount: 1),
      ],
      damageResistances: {
        'poison',
      },
      savingThrowAdvantageAgainst: {
        'poison',
      },
      grantedFeatureIds: [
        'stout_resilience',
      ],
    ),
  ),
};

const gnomeSubraces = <String, SubraceDefinition>{
  SubraceIds.forestGnome: SubraceDefinition(
    id: SubraceIds.forestGnome,
    name: 'Gnomo delle Foreste',
    raceId: RaceIds.gnome,
    content: RuleContent(
      id: SubraceIds.forestGnome,
      name: 'Gnomo delle Foreste',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Gnomo dotato di magia illusoria innata.',
      ),
      source: _phb,
      ownerId: RaceIds.gnome,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'DES', amount: 1),
      ],
      grantedCantripIds: [
        'minor_illusion',
      ],
      grantedFeatureIds: [
        RacialFeatureIds.naturalIllusionist,
        'speak_with_small_beasts',
      ],
    ),
  ),
  SubraceIds.rockGnome: SubraceDefinition(
    id: SubraceIds.rockGnome,
    name: 'Gnomo delle Rocce',
    raceId: RaceIds.gnome,
    content: RuleContent(
      id: SubraceIds.rockGnome,
      name: 'Gnomo delle Rocce',
      type: RuleContentType.subrace,
      description: RuleDescription(
        summary: 'Gnomo ingegnoso e particolarmente portato per i congegni.',
      ),
      source: _phb,
      ownerId: RaceIds.gnome,
    ),
    effects: CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'COS', amount: 1),
      ],
      toolProficiencies: {
        'tinkers_tools',
      },
      grantedFeatureIds: [
        'artificers_lore',
        'tinker',
      ],
    ),
  ),
};

final Map<String, RaceDefinition> phbRaceDefinitions = {
  RaceIds.dwarf: RaceDefinition(
    id: RaceIds.dwarf,
    name: 'Nano',
    content: _raceContent(
      RaceIds.dwarf,
      'Nano',
      'Razza robusta dotata di resistenza e addestramento nanico.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
        GlossaryRef('damage_resistance', 'Resistenza ai Danni'),
      ],
    ),
    speed: 7.5,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'COS', amount: 2),
      ],
      languages: {
        'common',
        'dwarvish',
      },
      darkvisionRange: 18,
      damageResistances: {
        'poison',
      },
      savingThrowAdvantageAgainst: {
        'poison',
      },
      weaponProficiencies: {
        'battleaxe',
        'handaxe',
        'light_hammer',
        'warhammer',
      },
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.dwarvenResilience,
        RacialFeatureIds.dwarvenCombatTraining,
        RacialFeatureIds.stonecunning,
      ],
      choices: [
        CharacterChoiceDefinition(
          id: 'dwarf_artisan_tool',
          label: 'Strumento da artigiano nanico',
          type: CharacterChoiceType.tool,
          optionIds: [
            'smiths_tools',
            'brewers_supplies',
            'masons_tools',
          ],
        ),
      ],
    ),
    subraces: dwarfSubraces,
  ),
  RaceIds.elf: RaceDefinition(
    id: RaceIds.elf,
    name: 'Elfo',
    content: _raceContent(
      RaceIds.elf,
      'Elfo',
      'Razza agile dotata di sensi affinati e retaggio fatato.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
      ],
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'DES', amount: 2),
      ],
      languages: {
        'common',
        'elvish',
      },
      darkvisionRange: 18,
      skillProficiencies: {
        'perception',
      },
      savingThrowAdvantageAgainst: {
        'charmed',
      },
      conditionImmunities: {
        'magical_sleep',
      },
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.keenSenses,
        RacialFeatureIds.feyAncestry,
        RacialFeatureIds.trance,
      ],
    ),
    subraces: elfSubraces,
  ),
  RaceIds.halfling: RaceDefinition(
    id: RaceIds.halfling,
    name: 'Halfling',
    content: _raceContent(
      RaceIds.halfling,
      'Halfling',
      'Razza piccola, agile e fortunata.',
    ),
    speed: 7.5,
    size: 'Piccola',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'DES', amount: 2),
      ],
      languages: {
        'common',
        'halfling',
      },
      savingThrowAdvantageAgainst: {
        'frightened',
      },
      grantedFeatureIds: [
        RacialFeatureIds.lucky,
        RacialFeatureIds.brave,
        RacialFeatureIds.halflingNimbleness,
      ],
    ),
    subraces: halflingSubraces,
  ),
  RaceIds.human: RaceDefinition(
    id: RaceIds.human,
    name: 'Umano',
    content: _raceContent(
      RaceIds.human,
      'Umano',
      'Razza versatile diffusa in numerosi mondi.',
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'FOR', amount: 1),
        AbilityBonusDefinition(ability: 'DES', amount: 1),
        AbilityBonusDefinition(ability: 'COS', amount: 1),
        AbilityBonusDefinition(ability: 'INT', amount: 1),
        AbilityBonusDefinition(ability: 'SAG', amount: 1),
        AbilityBonusDefinition(ability: 'CAR', amount: 1),
      ],
      languages: {
        'common',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'human_extra_language',
          label: 'Lingua extra',
          type: CharacterChoiceType.language,
        ),
      ],
    ),
  ),
  RaceIds.dragonborn: RaceDefinition(
    id: RaceIds.dragonborn,
    name: 'Dragonide',
    content: _raceContent(
      RaceIds.dragonborn,
      'Dragonide',
      'Razza draconica la cui discendenza determina soffio e resistenza.',
      glossaryRefs: const [
        GlossaryRef('damage_resistance', 'Resistenza ai Danni'),
      ],
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'FOR', amount: 2),
        AbilityBonusDefinition(ability: 'CAR', amount: 1),
      ],
      languages: {
        'common',
        'draconic',
      },
      grantedFeatureIds: [
        RacialFeatureIds.draconicAncestry,
        RacialFeatureIds.breathWeapon,
      ],
      choices: [
        CharacterChoiceDefinition(
          id: 'dragonborn_ancestry',
          label: 'Discendenza Draconica',
          type: CharacterChoiceType.other,
          options: dragonbornAncestryOptions,
        ),
      ],
    ),
  ),
  RaceIds.gnome: RaceDefinition(
    id: RaceIds.gnome,
    name: 'Gnomo',
    content: _raceContent(
      RaceIds.gnome,
      'Gnomo',
      'Razza piccola, brillante e resistente agli effetti magici.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
      ],
    ),
    speed: 7.5,
    size: 'Piccola',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'INT', amount: 2),
      ],
      languages: {
        'common',
        'gnomish',
      },
      darkvisionRange: 18,
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.gnomeCunning,
      ],
    ),
    subraces: gnomeSubraces,
  ),
  RaceIds.halfElf: RaceDefinition(
    id: RaceIds.halfElf,
    name: 'Mezzelfo',
    content: _raceContent(
      RaceIds.halfElf,
      'Mezzelfo',
      'Razza versatile che combina retaggio umano ed elfico.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
      ],
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'CAR', amount: 2),
      ],
      languages: {
        'common',
        'elvish',
      },
      darkvisionRange: 18,
      savingThrowAdvantageAgainst: {
        'charmed',
      },
      conditionImmunities: {
        'magical_sleep',
      },
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.feyAncestry,
        RacialFeatureIds.skillVersatility,
      ],
      choices: [
        CharacterChoiceDefinition(
          id: 'half_elf_ability_bonuses',
          label: 'Due caratteristiche diverse +1',
          type: CharacterChoiceType.ability,
          minimumSelections: 2,
          maximumSelections: 2,
          optionIds: ['FOR', 'DES', 'COS', 'INT', 'SAG'],
        ),
        CharacterChoiceDefinition(
          id: 'half_elf_skills',
          label: 'Due competenze nelle abilità',
          type: CharacterChoiceType.skill,
          minimumSelections: 2,
          maximumSelections: 2,
        ),
        CharacterChoiceDefinition(
          id: 'half_elf_extra_language',
          label: 'Lingua extra',
          type: CharacterChoiceType.language,
        ),
      ],
    ),
  ),
  RaceIds.halfOrc: RaceDefinition(
    id: RaceIds.halfOrc,
    name: 'Mezzorco',
    content: _raceContent(
      RaceIds.halfOrc,
      'Mezzorco',
      'Razza forte e resistente dotata di retaggio orchesco.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
      ],
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'FOR', amount: 2),
        AbilityBonusDefinition(ability: 'COS', amount: 1),
      ],
      languages: {
        'common',
        'orc',
      },
      darkvisionRange: 18,
      skillProficiencies: {
        'intimidation',
      },
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.relentlessEndurance,
        RacialFeatureIds.savageAttacks,
      ],
    ),
  ),
  RaceIds.tiefling: RaceDefinition(
    id: RaceIds.tiefling,
    name: 'Tiefling',
    content: _raceContent(
      RaceIds.tiefling,
      'Tiefling',
      'Razza dotata di retaggio infernale, resistenza al fuoco '
          'e magia innata.',
      glossaryRefs: const [
        GlossaryRef('darkvision', 'Scurovisione'),
        GlossaryRef('damage_resistance', 'Resistenza ai Danni'),
        GlossaryRef('racial_spellcasting', 'Magia Razziale'),
      ],
    ),
    speed: 9,
    size: 'Media',
    effects: const CharacterEffects(
      abilityBonuses: [
        AbilityBonusDefinition(ability: 'INT', amount: 1),
        AbilityBonusDefinition(ability: 'CAR', amount: 2),
      ],
      languages: {
        'common',
        'infernal',
      },
      darkvisionRange: 18,
      damageResistances: {
        'fire',
      },
      grantedFeatureIds: [
        RacialFeatureIds.darkvision,
        RacialFeatureIds.hellishResistance,
        RacialFeatureIds.infernalLegacy,
      ],
    ),
  ),
};

final RaceDefinition humanVariantDefinition = RaceDefinition(
  id: HumanVariantIds.variant,
  name: 'Umano Variante',
  content: _raceContent(
    HumanVariantIds.variant,
    'Umano Variante',
    'Variante dell’Umano che sostituisce l’incremento standard '
        'delle caratteristiche con scelte più specializzate.',
    glossaryRefs: const [
      GlossaryRef('racial_proficiency', 'Competenza Razziale'),
    ],
  ),
  speed: 9,
  size: 'Media',
  effects: const CharacterEffects(
    languages: {
      'common',
    },
    choices: [
      CharacterChoiceDefinition(
        id: 'human_variant_abilities',
        label: 'Due caratteristiche diverse +1',
        type: CharacterChoiceType.ability,
        minimumSelections: 2,
        maximumSelections: 2,
        optionIds: [
          'FOR',
          'DES',
          'COS',
          'INT',
          'SAG',
          'CAR',
        ],
      ),
      CharacterChoiceDefinition(
        id: 'human_variant_skill',
        label: 'Competenza in un’abilità',
        type: CharacterChoiceType.skill,
      ),
      CharacterChoiceDefinition(
        id: 'human_variant_feat',
        label: 'Talento',
        type: CharacterChoiceType.feat,
      ),
      CharacterChoiceDefinition(
        id: 'human_variant_language',
        label: 'Lingua extra',
        type: CharacterChoiceType.language,
      ),
    ],
  ),
);

CharacterEffects _mergeCharacterEffects(
  CharacterEffects a,
  CharacterEffects b,
) {
  return CharacterEffects(
    abilityBonuses: [
      ...a.abilityBonuses,
      ...b.abilityBonuses,
    ],
    skillProficiencies: {
      ...a.skillProficiencies,
      ...b.skillProficiencies,
    },
    savingThrowProficiencies: {
      ...a.savingThrowProficiencies,
      ...b.savingThrowProficiencies,
    },
    weaponProficiencies: {
      ...a.weaponProficiencies,
      ...b.weaponProficiencies,
    },
    armorProficiencies: {
      ...a.armorProficiencies,
      ...b.armorProficiencies,
    },
    toolProficiencies: {
      ...a.toolProficiencies,
      ...b.toolProficiencies,
    },
    languages: {
      ...a.languages,
      ...b.languages,
    },
    damageResistances: {
      ...a.damageResistances,
      ...b.damageResistances,
    },
    savingThrowAdvantageAgainst: {
      ...a.savingThrowAdvantageAgainst,
      ...b.savingThrowAdvantageAgainst,
    },
    conditionImmunities: {
      ...a.conditionImmunities,
      ...b.conditionImmunities,
    },

    // Una sottorazza/opzione più specifica può sostituire il valore base.
    darkvisionRange: b.darkvisionRange ?? a.darkvisionRange,
    walkingSpeedOverride: b.walkingSpeedOverride ?? a.walkingSpeedOverride,

    hitPointsPerLevelBonus: a.hitPointsPerLevelBonus + b.hitPointsPerLevelBonus,
    armorClassBonus: a.armorClassBonus + b.armorClassBonus,
    initiativeBonus: a.initiativeBonus + b.initiativeBonus,
    walkingSpeedBonus: a.walkingSpeedBonus + b.walkingSpeedBonus,

    grantedFeatureIds: {
      ...a.grantedFeatureIds,
      ...b.grantedFeatureIds,
    }.toList(growable: false),

    grantedFeatIds: {
      ...a.grantedFeatIds,
      ...b.grantedFeatIds,
    }.toList(growable: false),

    grantedSpellIds: {
      ...a.grantedSpellIds,
      ...b.grantedSpellIds,
    }.toList(growable: false),

    grantedCantripIds: {
      ...a.grantedCantripIds,
      ...b.grantedCantripIds,
    }.toList(growable: false),

    grantedEquipmentIds: {
      ...a.grantedEquipmentIds,
      ...b.grantedEquipmentIds,
    }.toList(growable: false),

    ruleEffects: [
      ...a.ruleEffects,
      ...b.ruleEffects,
    ],
    choices: [
      ...a.choices,
      ...b.choices,
    ],
  );
}

bool _choiceRequiresSelection(CharacterChoiceDefinition choice) =>
    choice.minimumSelections > 0;

Set<String> _allowedChoiceIds(CharacterChoiceDefinition choice) => {
      ...choice.optionIds,
      ...choice.options.map((option) => option.id),
    };

CharacterChoiceValidationResult _validateChoices(
  List<CharacterChoiceDefinition> definitions,
  CharacterChoiceState state,
) {
  final incomplete = <String>[];
  final issues = <CharacterChoiceIssue>[];

  for (final choice in definitions) {
    final selected = state.selectedFor(choice.id);

    if (selected.isEmpty) {
      if (_choiceRequiresSelection(choice)) {
        incomplete.add(choice.id);
      }
      continue;
    }

    if (selected.length < choice.minimumSelections) {
      incomplete.add(choice.id);
    }

    if (selected.length > choice.maximumSelections) {
      issues.add(
        CharacterChoiceIssue(
          choiceId: choice.id,
          message:
              'Sono consentite al massimo ${choice.maximumSelections} selezioni.',
        ),
      );
    }

    if (choice.unique && selected.toSet().length != selected.length) {
      issues.add(
        CharacterChoiceIssue(
          choiceId: choice.id,
          message: 'La stessa opzione non può essere scelta più volte.',
        ),
      );
    }

    final allowed = _allowedChoiceIds(choice);

    // Un dominio vuoto indica una scelta il cui catalogo sarà fornito
    // dal sistema specifico: abilità, lingue, talenti, strumenti ecc.
    if (allowed.isNotEmpty) {
      for (final id in selected) {
        if (!allowed.contains(id)) {
          issues.add(
            CharacterChoiceIssue(
              choiceId: choice.id,
              message: 'Opzione non consentita: $id.',
            ),
          );
        }
      }
    }
  }

  return CharacterChoiceValidationResult(
    incompleteChoiceIds: List.unmodifiable(incomplete.toSet()),
    issues: List.unmodifiable(issues),
  );
}

CharacterEffects _effectsFromChoice(
  CharacterChoiceDefinition choice,
  CharacterChoiceState state,
) {
  final selected = state.selectedFor(choice.id);

  if (selected.isEmpty) {
    return const CharacterEffects();
  }

  var result = const CharacterEffects();

  // Prima risolviamo eventuali opzioni con effetti espliciti.
  for (final selectedId in selected) {
    CharacterChoiceOptionDefinition? structuredOption;

    for (final option in choice.options) {
      if (option.id == selectedId) {
        structuredOption = option;
        break;
      }
    }

    if (structuredOption != null) {
      result = _mergeCharacterEffects(
        result,
        structuredOption.effects,
      );
      continue;
    }

    // Le scelte semplici vengono convertite in CharacterEffects
    // in base al tipo della scelta.
    switch (choice.type) {
      case CharacterChoiceType.ability:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            abilityBonuses: [
              AbilityBonusDefinition(
                ability: selectedId,
                amount: 1,
              ),
            ],
          ),
        );

      case CharacterChoiceType.skill:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            skillProficiencies: {selectedId},
          ),
        );

      case CharacterChoiceType.language:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            languages: {selectedId},
          ),
        );

      case CharacterChoiceType.tool:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            toolProficiencies: {selectedId},
          ),
        );

      case CharacterChoiceType.weapon:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            weaponProficiencies: {selectedId},
          ),
        );

      case CharacterChoiceType.armor:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            armorProficiencies: {selectedId},
          ),
        );

      case CharacterChoiceType.feat:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedFeatIds: [selectedId],
          ),
        );

      case CharacterChoiceType.cantrip:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedCantripIds: [selectedId],
          ),
        );

      case CharacterChoiceType.spell:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedSpellIds: [selectedId],
          ),
        );

      case CharacterChoiceType.equipment:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedEquipmentIds: [selectedId],
          ),
        );

      case CharacterChoiceType.subclass:
        // La sottoclasse appartiene alla progressione di classe.
        // Il resolver razziale non deve applicare effetti generici.
        break;

      case CharacterChoiceType.other:
        // `other` non possiede una semantica universale.
        // Le opzioni di questo tipo devono dichiarare effects.
        break;
    }
  }

  return result;
}

CharacterEffects _effectsFromSelections(
  CharacterEffects source,
  CharacterChoiceState state,
) {
  var result = const CharacterEffects();

  for (final choice in source.choices) {
    result = _mergeCharacterEffects(
      result,
      _effectsFromChoice(choice, state),
    );
  }

  return result;
}

CharacterEffects _effectsFromProgression(
  List<RacialProgressionGrant> grants,
) {
  var result = const CharacterEffects();

  for (final grant in grants) {
    switch (grant.type) {
      case RacialGrantType.feature:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedFeatureIds: [grant.contentId],
          ),
        );

      case RacialGrantType.cantrip:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedCantripIds: [grant.contentId],
          ),
        );

      case RacialGrantType.spell:
        result = _mergeCharacterEffects(
          result,
          CharacterEffects(
            grantedSpellIds: [grant.contentId],
          ),
        );
    }
  }

  return result;
}

/// Risolve tutti gli effetti razziali applicabili al personaggio.
///
/// Non modifica stato globale e non contiene controlli basati sui nomi
/// visualizzati nell'interfaccia.
ResolvedRaceEffects resolveRaceEffects({
  required String raceId,
  String? subraceId,
  int characterLevel = 1,
  CharacterChoiceState choices = const CharacterChoiceState(),
}) {
  if (characterLevel < 1) {
    throw ArgumentError.value(
      characterLevel,
      'characterLevel',
      'Il livello deve essere almeno 1.',
    );
  }

  final race = phbRaceDefinitionFor(raceId);

  if (race == null) {
    return const ResolvedRaceEffects(
      effects: CharacterEffects(),
    );
  }

  var effects = race.effects;

  SubraceDefinition? subrace;

  if (subraceId != null) {
    subrace = race.subraces[subraceId];

    if (subrace != null) {
      effects = _mergeCharacterEffects(
        effects,
        subrace.effects,
      );
    }
  }

  final choiceDefinitions = <CharacterChoiceDefinition>[
    ...race.effects.choices,
    if (subrace != null) ...subrace.effects.choices,
  ];

  final choiceValidation = _validateChoices(
    choiceDefinitions,
    choices,
  );

  // Le scelte valide già effettuate producono immediatamente effetti.
  // Una creazione ancora incompleta può quindi essere mostrata in UI
  // senza dover inventare valori temporanei.
  effects = _mergeCharacterEffects(
    effects,
    _effectsFromSelections(race.effects, choices),
  );

  // Effetti prodotti da opzioni strutturate della sottorazza.
  if (subrace != null) {
    effects = _mergeCharacterEffects(
      effects,
      _effectsFromSelections(subrace.effects, choices),
    );
  }

  final grants = <RacialProgressionGrant>[];

  final raceProgression = racialProgressionFor(race.id);

  if (raceProgression != null) {
    grants.addAll(
      raceProgression.availableAtLevel(characterLevel),
    );
  }

  if (subrace != null) {
    final subraceProgression = racialProgressionFor(subrace.id);

    if (subraceProgression != null) {
      grants.addAll(
        subraceProgression.availableAtLevel(characterLevel),
      );
    }
  }

  effects = _mergeCharacterEffects(
    effects,
    _effectsFromProgression(grants),
  );

  return ResolvedRaceEffects(
    effects: effects,
    progressionGrants: List.unmodifiable(grants),
    choiceValidation: choiceValidation,
  );
}

/// Restituisce la definizione del soffio associata alla scelta corrente.
///
/// Null indica che il personaggio non ha ancora scelto una discendenza
/// valida oppure che la razza non utilizza questa scelta.
DragonBreathDefinition? resolveDragonBreath(
  CharacterChoiceState choices,
) {
  final ancestry = choices.singleFor('dragonborn_ancestry');

  if (ancestry == null) {
    return null;
  }

  return dragonBreathDefinitionFor(ancestry);
}

RaceDefinition? phbRaceDefinitionFor(String id) {
  if (id == HumanVariantIds.variant) {
    return humanVariantDefinition;
  }

  return phbRaceDefinitions[id];
}
