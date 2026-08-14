import 'ammunition_data.dart';
import 'armor_data.dart';
import 'character_data.dart';
import 'choice_data.dart';
import 'class_catalog_data.dart';
import 'equipment_pack_data.dart';
import 'focus_data.dart';
import 'class_data.dart';
import 'spell_data.dart';
import 'weapon_data.dart';

const _phbWarlockSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 113-116',
);

abstract final class WarlockFeatureIds {
  static const otherworldlyPatron = 'otherworldly_patron';
  static const pactMagic = 'pact_magic';
  static const eldritchInvocations = 'eldritch_invocations';
  static const pactBoon = 'pact_boon';
  static const abilityScoreImprovement = 'ability_score_improvement';
  static const mysticArcanum6 = 'mystic_arcanum_6';
  static const mysticArcanum7 = 'mystic_arcanum_7';
  static const mysticArcanum8 = 'mystic_arcanum_8';
  static const mysticArcanum9 = 'mystic_arcanum_9';
  static const eldritchMaster = 'eldritch_master';
}

abstract final class WarlockResourceIds {
  static const pactMagicSlots = 'pact_magic_slots';
  static const mysticArcanum6 = 'mystic_arcanum_6_use';
  static const mysticArcanum7 = 'mystic_arcanum_7_use';
  static const mysticArcanum8 = 'mystic_arcanum_8_use';
  static const mysticArcanum9 = 'mystic_arcanum_9_use';
  static const eldritchMaster = 'eldritch_master_use';
}

abstract final class WarlockChoiceIds {
  static const pactBoon = 'warlock_pact_boon';
  static const eldritchInvocations = 'warlock_eldritch_invocations';
  static const mysticArcanum6 = 'warlock_mystic_arcanum_6';
  static const mysticArcanum7 = 'warlock_mystic_arcanum_7';
  static const mysticArcanum8 = 'warlock_mystic_arcanum_8';
  static const mysticArcanum9 = 'warlock_mystic_arcanum_9';
}

abstract final class WarlockPactBoonIds {
  static const chain = 'pact_of_the_chain';
  static const blade = 'pact_of_the_blade';
  static const tome = 'pact_of_the_tome';
}

abstract final class WarlockProgressionIds {
  static const invocationsKnown = 'eldritch_invocations_known';
}

const phbWarlockPactBoonIds = <String>{
  WarlockPactBoonIds.chain,
  WarlockPactBoonIds.blade,
  WarlockPactBoonIds.tome,
};

const phbWarlockMysticArcanum6SpellIds = <String>[
  'arcane_gate',
  'circle_of_death',
  'conjure_fey',
  'create_undead',
  'eyebite',
  'flesh_to_stone',
  'true_seeing',
];

const phbWarlockMysticArcanum7SpellIds = <String>[
  'etherealness',
  'finger_of_death',
  'forcecage',
  'plane_shift',
];

const phbWarlockMysticArcanum8SpellIds = <String>[
  'demiplane',
  'dominate_monster',
  'feeblemind',
  'glibness',
  'power_word_stun',
];

const phbWarlockMysticArcanum9SpellIds = <String>[
  'astral_projection',
  'foresight',
  'imprisonment',
  'power_word_kill',
  'true_polymorph',
];

final phbWarlockSpellIds = Set<String>.unmodifiable(
  spellDefinitions.values
      .where((spell) => spell.classIds.contains(ClassIds.warlock))
      .map((spell) => spell.id),
);

final _warlockSimpleWeaponIds = Set<String>.unmodifiable(
  weaponDefinitions.values
      .where((weapon) => weapon.category == WeaponCategory.simple)
      .map((weapon) => weapon.id),
);

const _warlockArcaneFocusIds = <String>{
  FocusIds.crystal,
  FocusIds.orb,
  FocusIds.rod,
  FocusIds.staff,
  FocusIds.wand,
};

CharacterClassFeatureDefinition _warlockFeature({
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
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbWarlockSource,
        ownerId: ClassIds.warlock,
      ),
      ruleTags: ruleTags,
      resourceId: resourceId,
      choices: choices,
      effects: effects,
    );

CharacterClassFeatureDefinition _mysticArcanumFeature({
  required String id,
  required String name,
  required String choiceId,
  required String resourceId,
  required int spellLevel,
  required List<String> spellIds,
}) =>
    _warlockFeature(
      id: id,
      name: name,
      summary:
          'Sceglie un incantesimo da Warlock di $spellLevel° livello da usare senza slot.',
      details:
          'L’incantesimo scelto può essere lanciato una volta senza spendere uno slot incantesimo. L’utilizzo viene recuperato al termine di un riposo lungo.',
      ruleTags: const {
        'mystic_arcanum',
        'without_spell_slot',
        'long_rest',
      },
      resourceId: resourceId,
      choices: [
        CharacterChoiceDefinition(
          id: choiceId,
          label: 'Scegli l’Arcanum Mistico di $spellLevel° livello',
          type: CharacterChoiceType.spell,
          optionIds: spellIds,
        ),
      ],
    );

abstract final class WarlockPactBoonChoiceIds {
  static const bladeForm = 'warlock_pact_blade_form';
  static const tomeCantrips = 'warlock_pact_tome_cantrips';
}

const phbWarlockPactOfChainSpecialFamiliarIds = <String>{
  'imp',
  'pseudodragon',
  'quasit',
  'sprite',
};

const phbWarlockPactBladeMeleeWeaponIds = <String>[
  'club',
  'dagger',
  'greatclub',
  'handaxe',
  'javelin',
  'light_hammer',
  'mace',
  'quarterstaff',
  'sickle',
  'spear',
  'battleaxe',
  'flail',
  'glaive',
  'greataxe',
  'greatsword',
  'halberd',
  'lance',
  'longsword',
  'maul',
  'morningstar',
  'pike',
  'rapier',
  'scimitar',
  'shortsword',
  'trident',
  'war_pick',
  'warhammer',
  'whip',
];

final phbWarlockPactTomeCantripIds = List<String>.unmodifiable(
  spellDefinitions.values
      .where((spell) => spell.level == 0)
      .map((spell) => spell.id)
      .toList()
    ..sort(),
);

final phbWarlockPactBoonOptions = <CharacterChoiceOptionDefinition>[
  const CharacterChoiceOptionDefinition(
    id: WarlockPactBoonIds.chain,
    label: 'Patto della Catena',
    effects: CharacterEffects(
      grantedSpellIds: ['find_familiar'],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'pact_of_the_chain_ritual_familiar',
          type: CharacterRuleEffectType.spellcasting,
          target: 'find_familiar',
          referenceIds: ['find_familiar'],
          condition:
              'cast_as_ritual_and_does_not_count_against_warlock_spells_known',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_chain_special_forms',
          type: CharacterRuleEffectType.conditional,
          target: 'find_familiar_form_selection',
          referenceIds: ['imp', 'pseudodragon', 'quasit', 'sprite'],
          condition: 'in_addition_to_normal_find_familiar_forms',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_chain_familiar_attack',
          type: CharacterRuleEffectType.reaction,
          target: 'familiar_attack',
          condition:
              'when_owner_takes_attack_action_replace_one_owner_attack_and_use_familiar_reaction',
        ),
      ],
    ),
  ),
  const CharacterChoiceOptionDefinition(
    id: WarlockPactBoonIds.blade,
    label: 'Patto della Lama',
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: WarlockPactBoonChoiceIds.bladeForm,
          label: 'Scegli la forma dell’Arma del Patto',
          type: CharacterChoiceType.weapon,
          optionIds: phbWarlockPactBladeMeleeWeaponIds,
        ),
      ],
      ruleEffects: [
        CharacterRuleEffect(
          id: 'pact_of_the_blade_create_weapon',
          type: CharacterRuleEffectType.conditional,
          target: 'pact_weapon_creation',
          condition: 'action_empty_hand_choose_melee_weapon_form',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_blade_weapon_properties',
          type: CharacterRuleEffectType.conditional,
          target: 'pact_weapon',
          condition:
              'owner_is_proficient_and_weapon_is_magical_for_resistance_and_immunity',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_blade_disappearance',
          type: CharacterRuleEffectType.conditional,
          target: 'pact_weapon',
          value: 1.5,
          condition:
              'disappears_after_one_minute_farther_than_meters_or_when_recreated_dismissed_or_owner_dies',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_blade_bind_magic_weapon',
          type: CharacterRuleEffectType.conditional,
          target: 'magic_weapon_bond',
          condition:
              'one_hour_ritual_allowed_during_short_rest_excludes_artifacts_and_sentient_weapons',
        ),
      ],
    ),
  ),
  CharacterChoiceOptionDefinition(
    id: WarlockPactBoonIds.tome,
    label: 'Patto del Tomo',
    effects: CharacterEffects(
      choices: [
        CharacterChoiceDefinition(
          id: WarlockPactBoonChoiceIds.tomeCantrips,
          label: 'Scegli tre trucchetti per il Libro delle Ombre',
          type: CharacterChoiceType.cantrip,
          minimumSelections: 3,
          maximumSelections: 3,
          optionIds: phbWarlockPactTomeCantripIds,
          unique: true,
        ),
      ],
      ruleEffects: const [
        CharacterRuleEffect(
          id: 'pact_of_the_tome_book_of_shadows',
          type: CharacterRuleEffectType.spellcasting,
          target: 'book_of_shadows_cantrips',
          condition:
              'cast_at_will_count_as_warlock_cantrips_and_do_not_count_against_cantrips_known',
        ),
        CharacterRuleEffect(
          id: 'pact_of_the_tome_replacement',
          type: CharacterRuleEffectType.conditional,
          target: 'book_of_shadows',
          condition:
              'one_hour_ceremony_during_short_or_long_rest_destroys_previous_book_and_book_turns_to_dust_on_death',
        ),
      ],
    ),
  ),
];

const _phbWarlockInvocationSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 118-119',
);

enum EldritchInvocationSpellUse {
  none,
  atWill,
  oncePerLongRestUsingPactSlot,
}

class EldritchInvocationRitualBookDefinition {
  final CharacterChoiceDefinition initialRitualChoice;
  final int initialRitualCount;
  final int initialSpellLevel;
  final int maximumCopyableSpellLevelDivisor;
  final bool maximumCopyableSpellLevelRoundsUp;
  final int copyingHoursPerSpellLevel;
  final int copyingGoldPiecesPerSpellLevel;
  final bool copiedSpellsAreRitualOnly;
  final bool canCastKnownWarlockRituals;
  final bool initialRitualsCountAgainstSpellsKnown;

  const EldritchInvocationRitualBookDefinition({
    required this.initialRitualChoice,
    required this.initialRitualCount,
    required this.initialSpellLevel,
    required this.maximumCopyableSpellLevelDivisor,
    required this.maximumCopyableSpellLevelRoundsUp,
    required this.copyingHoursPerSpellLevel,
    required this.copyingGoldPiecesPerSpellLevel,
    required this.copiedSpellsAreRitualOnly,
    required this.canCastKnownWarlockRituals,
    required this.initialRitualsCountAgainstSpellsKnown,
  })  : assert(initialRitualCount > 0),
        assert(initialSpellLevel > 0),
        assert(maximumCopyableSpellLevelDivisor > 0),
        assert(copyingHoursPerSpellLevel > 0),
        assert(copyingGoldPiecesPerSpellLevel >= 0);

  int maximumCopyableSpellLevelAt(int warlockLevel) {
    final quotient = warlockLevel ~/ maximumCopyableSpellLevelDivisor;
    final remainder = warlockLevel % maximumCopyableSpellLevelDivisor;

    if (maximumCopyableSpellLevelRoundsUp && remainder != 0) {
      return quotient + 1;
    }

    return quotient;
  }
}

class EldritchInvocationDefinition {
  final String id;
  final String name;
  final RuleContent content;
  final int minimumWarlockLevel;
  final String? requiredPactBoonId;
  final String? requiredSpellId;
  final String? spellId;
  final EldritchInvocationSpellUse spellUse;
  final bool selfOnly;
  final bool ignoresMaterialComponents;
  final int? spellLevelOverride;
  final CharacterEffects effects;
  final EldritchInvocationRitualBookDefinition? ritualBook;

  const EldritchInvocationDefinition({
    required this.id,
    required this.name,
    required this.content,
    this.minimumWarlockLevel = 2,
    this.requiredPactBoonId,
    this.requiredSpellId,
    this.spellId,
    this.spellUse = EldritchInvocationSpellUse.none,
    this.selfOnly = false,
    this.ignoresMaterialComponents = false,
    this.spellLevelOverride,
    this.effects = const CharacterEffects(),
    this.ritualBook,
  })  : assert(minimumWarlockLevel >= 2),
        assert(
          spellUse == EldritchInvocationSpellUse.none || spellId != null,
        ),
        assert(
          spellLevelOverride == null ||
              (spellLevelOverride >= 1 && spellLevelOverride <= 9),
        );

  bool get castsSpellAtWill => spellUse == EldritchInvocationSpellUse.atWill;

  bool get spendsPactSlot =>
      spellUse == EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot;

  bool isAvailable({
    required int warlockLevel,
    String? pactBoonId,
    Set<String> knownSpellIds = const {},
  }) {
    if (warlockLevel < minimumWarlockLevel) return false;

    if (requiredPactBoonId != null && requiredPactBoonId != pactBoonId) {
      return false;
    }

    if (requiredSpellId != null && !knownSpellIds.contains(requiredSpellId)) {
      return false;
    }

    return true;
  }
}

abstract final class WarlockEldritchInvocationIds {
  static const armorOfShadows = 'armor_of_shadows';
  static const otherworldlyLeap = 'otherworldly_leap';
  static const chainsOfCarceri = 'chains_of_carceri';
  static const agonizingBlast = 'agonizing_blast';
  static const repellingBlast = 'repelling_blast';
  static const mireTheMind = 'mire_the_mind';
  static const beguilingInfluence = 'beguiling_influence';
  static const thiefOfFiveFates = 'thief_of_five_fates';
  static const thirstingBlade = 'thirsting_blade';
  static const eldritchSpear = 'eldritch_spear';
  static const bookOfAncientSecrets = 'book_of_ancient_secrets';
  static const beastSpeech = 'beast_speech';
  static const masterOfMyriadForms = 'master_of_myriad_forms';
  static const maskOfManyFaces = 'mask_of_many_faces';
  static const eyesOfTheRuneKeeper = 'eyes_of_the_rune_keeper';
  static const dreadfulWord = 'dreadful_word';
  static const ascendantStep = 'ascendant_step';
  static const signOfIllOmen = 'sign_of_ill_omen';
  static const sculptorOfFlesh = 'sculptor_of_flesh';
  static const minionsOfChaos = 'minions_of_chaos';
  static const gazeOfTwoMinds = 'gaze_of_two_minds';
  static const lifedrinker = 'lifedrinker';
  static const whispersOfTheGrave = 'whispers_of_the_grave';
  static const bewitchingWhispers = 'bewitching_whispers';
  static const oneWithShadows = 'one_with_shadows';
  static const fiendishVigor = 'fiendish_vigor';
  static const visionsOfDistantRealms = 'visions_of_distant_realms';
  static const mistyVisions = 'misty_visions';
  static const devilsSight = 'devils_sight';
  static const eldritchSight = 'eldritch_sight';
  static const witchSight = 'witch_sight';
  static const voiceOfTheChainMaster = 'voice_of_the_chain_master';
}

abstract final class WarlockInvocationChoiceIds {
  static const ancientSecretsInitialRituals =
      'warlock_ancient_secrets_initial_rituals';
}

final phbWarlockFirstLevelRitualSpellIds = List<String>.unmodifiable(
  spellDefinitions.values
      .where((spell) => spell.level == 1 && spell.ritual)
      .map((spell) => spell.id)
      .toList()
    ..sort(),
);

EldritchInvocationDefinition _warlockInvocation({
  required String id,
  required String name,
  required String summary,
  required String details,
  int minimumWarlockLevel = 2,
  String? requiredPactBoonId,
  String? requiredSpellId,
  String? spellId,
  EldritchInvocationSpellUse spellUse = EldritchInvocationSpellUse.none,
  bool selfOnly = false,
  bool ignoresMaterialComponents = false,
  int? spellLevelOverride,
  CharacterEffects effects = const CharacterEffects(),
  EldritchInvocationRitualBookDefinition? ritualBook,
}) =>
    EldritchInvocationDefinition(
      id: id,
      name: name,
      content: RuleContent(
        id: id,
        name: name,
        type: RuleContentType.classFeature,
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: _phbWarlockInvocationSource,
        ownerId: ClassIds.warlock,
      ),
      minimumWarlockLevel: minimumWarlockLevel,
      requiredPactBoonId: requiredPactBoonId,
      requiredSpellId: requiredSpellId,
      spellId: spellId,
      spellUse: spellUse,
      selfOnly: selfOnly,
      ignoresMaterialComponents: ignoresMaterialComponents,
      spellLevelOverride: spellLevelOverride,
      effects: effects,
      ritualBook: ritualBook,
    );

final phbWarlockEldritchInvocationDefinitions =
    <String, EldritchInvocationDefinition>{
  WarlockEldritchInvocationIds.armorOfShadows: _warlockInvocation(
    id: WarlockEldritchInvocationIds.armorOfShadows,
    name: 'Armatura delle Ombre',
    summary: 'Lancia Armatura Magica su se stesso a volontà.',
    details: 'Non spende slot incantesimo e non usa componenti materiali.',
    spellId: 'mage_armor',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
    ignoresMaterialComponents: true,
  ),
  WarlockEldritchInvocationIds.otherworldlyLeap: _warlockInvocation(
    id: WarlockEldritchInvocationIds.otherworldlyLeap,
    name: 'Balzo Ultraterreno',
    summary: 'Lancia Saltare su se stesso a volontà.',
    details: 'Richiede il 9° livello e non spende slot o componenti materiali.',
    minimumWarlockLevel: 9,
    spellId: 'jump',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
    ignoresMaterialComponents: true,
  ),
  WarlockEldritchInvocationIds.chainsOfCarceri: _warlockInvocation(
    id: WarlockEldritchInvocationIds.chainsOfCarceri,
    name: 'Catene di Carceri',
    summary:
        'Lancia Blocca Mostri a volontà su celestiali, immondi o elementali.',
    details:
        'Richiede il 15° livello e il Patto della Catena. Non spende slot o componenti materiali e non può colpire di nuovo la stessa creatura prima di un riposo lungo.',
    minimumWarlockLevel: 15,
    requiredPactBoonId: WarlockPactBoonIds.chain,
    spellId: 'hold_monster',
    spellUse: EldritchInvocationSpellUse.atWill,
    ignoresMaterialComponents: true,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'chains_of_carceri_target_and_cooldown',
          type: CharacterRuleEffectType.conditional,
          target: 'hold_monster',
          referenceIds: ['celestial', 'fiend', 'elemental'],
          condition:
              'target_type_restricted_and_same_creature_requires_long_rest',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.agonizingBlast: _warlockInvocation(
    id: WarlockEldritchInvocationIds.agonizingBlast,
    name: 'Deflagrazione Agonizzante',
    summary: 'Aggiunge il modificatore di Carisma ai danni.',
    details:
        'Quando Deflagrazione Occulta colpisce, aggiunge il modificatore di Carisma ai danni inflitti.',
    requiredSpellId: 'eldritch_blast',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'agonizing_blast_charisma_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'eldritch_blast_hit_damage',
          referenceIds: ['eldritch_blast'],
          condition: 'add_charisma_modifier',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.repellingBlast: _warlockInvocation(
    id: WarlockEldritchInvocationIds.repellingBlast,
    name: 'Deflagrazione Respingente',
    summary: 'Respinge il bersaglio di Deflagrazione Occulta.',
    details:
        'Quando colpisce, può spingere la creatura fino a 3 metri in linea retta allontanandola da sé.',
    requiredSpellId: 'eldritch_blast',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'repelling_blast_push',
          type: CharacterRuleEffectType.movement,
          target: 'eldritch_blast_hit_target',
          value: 3,
          referenceIds: ['eldritch_blast'],
          condition: 'push_away_in_straight_line_up_to_meters',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.mireTheMind: _warlockInvocation(
    id: WarlockEldritchInvocationIds.mireTheMind,
    name: 'Fardello Mentale',
    summary: 'Lancia Lentezza usando uno slot del Patto.',
    details:
        'Richiede il 5° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 5,
    spellId: 'slow',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.beguilingInfluence: _warlockInvocation(
    id: WarlockEldritchInvocationIds.beguilingInfluence,
    name: 'Influenza Seducente',
    summary: 'Ottiene competenza in Inganno e Persuasione.',
    details: 'Concede entrambe le competenze finché la supplica è posseduta.',
    effects: const CharacterEffects(
      skillProficiencies: {'deception', 'persuasion'},
    ),
  ),
  WarlockEldritchInvocationIds.thiefOfFiveFates: _warlockInvocation(
    id: WarlockEldritchInvocationIds.thiefOfFiveFates,
    name: 'Ladro dei Cinque Fati',
    summary: 'Lancia Anatema usando uno slot del Patto.',
    details:
        'Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    spellId: 'bane',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.thirstingBlade: _warlockInvocation(
    id: WarlockEldritchInvocationIds.thirstingBlade,
    name: 'Lama Assetata',
    summary: 'Attacca due volte con l’Arma del Patto.',
    details:
        'Richiede il 5° livello e il Patto della Lama. Quando usa l’azione di Attacco nel proprio turno può attaccare due volte anziché una.',
    minimumWarlockLevel: 5,
    requiredPactBoonId: WarlockPactBoonIds.blade,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'thirsting_blade_two_attacks',
          type: CharacterRuleEffectType.conditional,
          target: 'pact_weapon_attack_action',
          value: 2,
          condition: 'on_owner_turn_attack_twice_instead_of_once',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.eldritchSpear: _warlockInvocation(
    id: WarlockEldritchInvocationIds.eldritchSpear,
    name: 'Lancia Occulta',
    summary: 'Porta la gittata di Deflagrazione Occulta a 90 metri.',
    details: 'Richiede la conoscenza del trucchetto Deflagrazione Occulta.',
    requiredSpellId: 'eldritch_blast',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_spear_range',
          type: CharacterRuleEffectType.conditional,
          target: 'eldritch_blast_range_meters',
          value: 90,
          referenceIds: ['eldritch_blast'],
          condition: 'range_override_meters',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.bookOfAncientSecrets: _warlockInvocation(
    id: WarlockEldritchInvocationIds.bookOfAncientSecrets,
    name: 'Libro degli Antichi Segreti',
    summary: 'Trasforma il Libro delle Ombre in un libro rituale.',
    details:
        'Richiede il Patto del Tomo. Inizia con due rituali di 1° livello di qualsiasi classe e permette di trascrivere altri rituali entro il limite del livello da Warlock.',
    requiredPactBoonId: WarlockPactBoonIds.tome,
    ritualBook: EldritchInvocationRitualBookDefinition(
      initialRitualChoice: CharacterChoiceDefinition(
        id: WarlockInvocationChoiceIds.ancientSecretsInitialRituals,
        label: 'Scegli due rituali di 1° livello',
        type: CharacterChoiceType.spell,
        minimumSelections: 2,
        maximumSelections: 2,
        optionIds: phbWarlockFirstLevelRitualSpellIds,
        unique: true,
      ),
      initialRitualCount: 2,
      initialSpellLevel: 1,
      maximumCopyableSpellLevelDivisor: 2,
      maximumCopyableSpellLevelRoundsUp: true,
      copyingHoursPerSpellLevel: 2,
      copyingGoldPiecesPerSpellLevel: 50,
      copiedSpellsAreRitualOnly: true,
      canCastKnownWarlockRituals: true,
      initialRitualsCountAgainstSpellsKnown: false,
    ),
  ),
  WarlockEldritchInvocationIds.beastSpeech: _warlockInvocation(
    id: WarlockEldritchInvocationIds.beastSpeech,
    name: 'Lingue delle Bestie',
    summary: 'Lancia Parlare con gli Animali a volontà.',
    details: 'Non spende slot incantesimo.',
    spellId: 'speak_with_animals',
    spellUse: EldritchInvocationSpellUse.atWill,
  ),
  WarlockEldritchInvocationIds.masterOfMyriadForms: _warlockInvocation(
    id: WarlockEldritchInvocationIds.masterOfMyriadForms,
    name: 'Maestro di Mille Forme',
    summary: 'Lancia Alterare Se Stesso a volontà.',
    details: 'Richiede il 15° livello e non spende slot incantesimo.',
    minimumWarlockLevel: 15,
    spellId: 'alter_self',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
  ),
  WarlockEldritchInvocationIds.maskOfManyFaces: _warlockInvocation(
    id: WarlockEldritchInvocationIds.maskOfManyFaces,
    name: 'Maschera dei Molti Volti',
    summary: 'Lancia Camuffare Se Stesso a volontà.',
    details: 'Non spende slot incantesimo.',
    spellId: 'disguise_self',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
  ),
  WarlockEldritchInvocationIds.eyesOfTheRuneKeeper: _warlockInvocation(
    id: WarlockEldritchInvocationIds.eyesOfTheRuneKeeper,
    name: 'Occhi del Custode delle Rune',
    summary: 'Legge ogni forma di scrittura.',
    details: 'La capacità non richiede prove o linguaggi condivisi.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eyes_of_the_rune_keeper_read_writing',
          type: CharacterRuleEffectType.conditional,
          target: 'written_language',
          condition: 'can_read_all_writing',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.dreadfulWord: _warlockInvocation(
    id: WarlockEldritchInvocationIds.dreadfulWord,
    name: 'Parola Temibile',
    summary: 'Lancia Confusione usando uno slot del Patto.',
    details:
        'Richiede il 7° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 7,
    spellId: 'confusion',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.ascendantStep: _warlockInvocation(
    id: WarlockEldritchInvocationIds.ascendantStep,
    name: 'Passo Ascendente',
    summary: 'Lancia Levitazione su se stesso a volontà.',
    details: 'Richiede il 9° livello e non spende slot o componenti materiali.',
    minimumWarlockLevel: 9,
    spellId: 'levitate',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
    ignoresMaterialComponents: true,
  ),
  WarlockEldritchInvocationIds.signOfIllOmen: _warlockInvocation(
    id: WarlockEldritchInvocationIds.signOfIllOmen,
    name: 'Presagio di Sventura',
    summary: 'Lancia Scagliare Maledizione usando uno slot del Patto.',
    details:
        'Richiede il 5° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 5,
    spellId: 'bestow_curse',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.sculptorOfFlesh: _warlockInvocation(
    id: WarlockEldritchInvocationIds.sculptorOfFlesh,
    name: 'Scultore della Carne',
    summary: 'Lancia Metamorfosi usando uno slot del Patto.',
    details:
        'Richiede il 7° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 7,
    spellId: 'polymorph',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.minionsOfChaos: _warlockInvocation(
    id: WarlockEldritchInvocationIds.minionsOfChaos,
    name: 'Servitori del Caos',
    summary: 'Lancia Evoca Elementale usando uno slot del Patto.',
    details:
        'Richiede il 9° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 9,
    spellId: 'conjure_elemental',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.gazeOfTwoMinds: _warlockInvocation(
    id: WarlockEldritchInvocationIds.gazeOfTwoMinds,
    name: 'Sguardo delle Due Menti',
    summary: 'Percepisce il mondo attraverso i sensi di un umanoide.',
    details:
        'Con un’azione tocca un umanoide consenziente. Può mantenere il legame con un’azione finché entrambi restano sullo stesso piano; usa i sensi speciali del bersaglio ma è cieco e sordo rispetto ai propri dintorni.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'gaze_of_two_minds_sensory_link',
          type: CharacterRuleEffectType.conditional,
          target: 'willing_humanoid_senses',
          condition:
              'action_touch_same_plane_maintain_with_action_gain_special_senses_owner_blind_and_deaf_to_surroundings',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.lifedrinker: _warlockInvocation(
    id: WarlockEldritchInvocationIds.lifedrinker,
    name: 'Succhiavita',
    summary: 'Infligge danni necrotici extra con l’Arma del Patto.',
    details:
        'Richiede il 12° livello e il Patto della Lama. I danni extra sono pari al modificatore di Carisma, con un minimo di 1.',
    minimumWarlockLevel: 12,
    requiredPactBoonId: WarlockPactBoonIds.blade,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'lifedrinker_necrotic_damage',
          type: CharacterRuleEffectType.damageBonus,
          target: 'pact_weapon_hit_damage',
          condition: 'necrotic_equal_charisma_modifier_minimum_one',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.whispersOfTheGrave: _warlockInvocation(
    id: WarlockEldritchInvocationIds.whispersOfTheGrave,
    name: 'Sussurri dalla Tomba',
    summary: 'Lancia Parlare con i Morti a volontà.',
    details: 'Richiede il 9° livello e non spende slot incantesimo.',
    minimumWarlockLevel: 9,
    spellId: 'speak_with_dead',
    spellUse: EldritchInvocationSpellUse.atWill,
  ),
  WarlockEldritchInvocationIds.bewitchingWhispers: _warlockInvocation(
    id: WarlockEldritchInvocationIds.bewitchingWhispers,
    name: 'Sussurri Stregati',
    summary: 'Lancia Compulsione usando uno slot del Patto.',
    details:
        'Richiede il 7° livello. Può farlo una volta e recupera la possibilità dopo un riposo lungo.',
    minimumWarlockLevel: 7,
    spellId: 'compulsion',
    spellUse: EldritchInvocationSpellUse.oncePerLongRestUsingPactSlot,
  ),
  WarlockEldritchInvocationIds.oneWithShadows: _warlockInvocation(
    id: WarlockEldritchInvocationIds.oneWithShadows,
    name: 'Tutt’Uno con le Ombre',
    summary: 'Diventa invisibile nella luce fioca o nell’oscurità.',
    details:
        'Richiede il 5° livello. Usa un’azione e resta invisibile finché non si muove o effettua un’azione o una reazione.',
    minimumWarlockLevel: 5,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'one_with_shadows_invisibility',
          type: CharacterRuleEffectType.conditional,
          target: 'self_invisibility',
          condition:
              'action_in_dim_light_or_darkness_until_move_action_or_reaction',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.fiendishVigor: _warlockInvocation(
    id: WarlockEldritchInvocationIds.fiendishVigor,
    name: 'Vigore Immondo',
    summary: 'Lancia Vita Falsata su se stesso a volontà.',
    details:
        'La lancia come incantesimo di 1° livello senza spendere slot o componenti materiali.',
    spellId: 'false_life',
    spellUse: EldritchInvocationSpellUse.atWill,
    selfOnly: true,
    ignoresMaterialComponents: true,
    spellLevelOverride: 1,
  ),
  WarlockEldritchInvocationIds.visionsOfDistantRealms: _warlockInvocation(
    id: WarlockEldritchInvocationIds.visionsOfDistantRealms,
    name: 'Visione dei Reami Lontani',
    summary: 'Lancia Occhio Arcano a volontà.',
    details: 'Richiede il 15° livello e non spende slot incantesimo.',
    minimumWarlockLevel: 15,
    spellId: 'arcane_eye',
    spellUse: EldritchInvocationSpellUse.atWill,
  ),
  WarlockEldritchInvocationIds.mistyVisions: _warlockInvocation(
    id: WarlockEldritchInvocationIds.mistyVisions,
    name: 'Visioni Velate',
    summary: 'Lancia Immagine Silenziosa a volontà.',
    details: 'Non spende slot incantesimo o componenti materiali.',
    spellId: 'silent_image',
    spellUse: EldritchInvocationSpellUse.atWill,
    ignoresMaterialComponents: true,
  ),
  WarlockEldritchInvocationIds.devilsSight: _warlockInvocation(
    id: WarlockEldritchInvocationIds.devilsSight,
    name: 'Vista del Diavolo',
    summary: 'Vede normalmente nell’oscurità fino a 36 metri.',
    details: 'Funziona sia nell’oscurità comune sia in quella magica.',
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'devils_sight_darkness_vision',
          type: CharacterRuleEffectType.conditional,
          target: 'normal_and_magical_darkness_vision_meters',
          value: 36,
          condition: 'see_normally_in_nonmagical_and_magical_darkness',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.eldritchSight: _warlockInvocation(
    id: WarlockEldritchInvocationIds.eldritchSight,
    name: 'Vista dell’Occulto',
    summary: 'Lancia Individuazione del Magico a volontà.',
    details: 'Non spende slot incantesimo.',
    spellId: 'detect_magic',
    spellUse: EldritchInvocationSpellUse.atWill,
  ),
  WarlockEldritchInvocationIds.witchSight: _warlockInvocation(
    id: WarlockEldritchInvocationIds.witchSight,
    name: 'Vista Stregata',
    summary: 'Vede la vera forma delle creature alterate.',
    details:
        'Richiede il 15° livello. Funziona entro 9 metri e in linea di vista su mutaforma o creature celate da illusione o trasmutazione.',
    minimumWarlockLevel: 15,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'witch_sight_true_form',
          type: CharacterRuleEffectType.conditional,
          target: 'shapechanger_or_magically_concealed_true_form',
          value: 9,
          referenceIds: ['shapechanger', 'illusion', 'transmutation'],
          condition: 'within_meters_and_line_of_sight',
        ),
      ],
    ),
  ),
  WarlockEldritchInvocationIds.voiceOfTheChainMaster: _warlockInvocation(
    id: WarlockEldritchInvocationIds.voiceOfTheChainMaster,
    name: 'Voce del Signore delle Catene',
    summary: 'Comunica e percepisce attraverso il proprio famiglio.',
    details:
        'Richiede il Patto della Catena. Funziona sullo stesso piano di esistenza e permette anche di parlare con la propria voce attraverso il famiglio.',
    requiredPactBoonId: WarlockPactBoonIds.chain,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'voice_of_the_chain_master_link',
          type: CharacterRuleEffectType.conditional,
          target: 'pact_familiar_telepathy_senses_and_voice',
          condition:
              'same_plane_telepathy_perceive_through_senses_and_speak_with_owner_voice',
        ),
      ],
    ),
  ),
};

final phbWarlockEldritchInvocationIds = List<String>.unmodifiable(
  phbWarlockEldritchInvocationDefinitions.keys.toList()..sort(),
);

EldritchInvocationDefinition? phbWarlockEldritchInvocationFor(
  String id,
) =>
    phbWarlockEldritchInvocationDefinitions[id];

Iterable<EldritchInvocationDefinition> phbWarlockInvocationsAvailableFor({
  required int warlockLevel,
  String? pactBoonId,
  Set<String> knownSpellIds = const {},
}) =>
    phbWarlockEldritchInvocationDefinitions.values.where(
      (invocation) => invocation.isAvailable(
        warlockLevel: warlockLevel,
        pactBoonId: pactBoonId,
        knownSpellIds: knownSpellIds,
      ),
    );

const _phbWarlockArchfeySource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'pp. 116-117',
);

const _phbWarlockFiendSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'p. 117',
);

abstract final class WarlockSubclassIds {
  static const archfey = 'archfey';
  static const fiend = 'fiend';
  static const greatOldOne = 'great_old_one';
}

const phbWarlockSubclassIds = <String>{
  WarlockSubclassIds.archfey,
  WarlockSubclassIds.fiend,
  WarlockSubclassIds.greatOldOne,
};

abstract final class WarlockArchfeyFeatureIds {
  static const feyPresence = 'archfey_fey_presence';
  static const mistyEscape = 'archfey_misty_escape';
  static const beguilingDefenses = 'archfey_beguiling_defenses';
  static const darkDelirium = 'archfey_dark_delirium';
}

abstract final class WarlockArchfeyResourceIds {
  static const feyPresence = 'archfey_fey_presence_use';
  static const mistyEscape = 'archfey_misty_escape_use';
  static const darkDelirium = 'archfey_dark_delirium_use';
}

abstract final class WarlockFiendFeatureIds {
  static const darkOnesBlessing = 'fiend_dark_ones_blessing';
  static const darkOnesOwnLuck = 'fiend_dark_ones_own_luck';
  static const fiendishResilience = 'fiend_fiendish_resilience';
  static const hurlThroughHell = 'fiend_hurl_through_hell';
}

abstract final class WarlockFiendResourceIds {
  static const darkOnesOwnLuck = 'fiend_dark_ones_own_luck_use';
  static const hurlThroughHell = 'fiend_hurl_through_hell_use';
}

abstract final class WarlockFiendChoiceIds {
  static const fiendishResilienceDamageType = 'fiendish_resilience_damage_type';
}

const phbWarlockArchfeyExpandedSpellIdsByLevel = <int, Set<String>>{
  1: {'faerie_fire', 'sleep'},
  3: {'calm_emotions', 'phantasmal_force'},
  5: {'blink', 'plant_growth'},
  7: {'dominate_beast', 'greater_invisibility'},
  9: {'dominate_person', 'seeming'},
};

const phbWarlockFiendExpandedSpellIdsByLevel = <int, Set<String>>{
  1: {'burning_hands', 'command'},
  3: {'blindness_deafness', 'scorching_ray'},
  5: {'fireball', 'stinking_cloud'},
  7: {'fire_shield', 'wall_of_fire'},
  9: {'flame_strike', 'hallow'},
};

const phbWarlockFiendishResilienceDamageTypeLabels = <String, String>{
  'acid': 'Acido',
  'bludgeoning': 'Contundente',
  'cold': 'Freddo',
  'fire': 'Fuoco',
  'force': 'Forza',
  'lightning': 'Fulmine',
  'necrotic': 'Necrotico',
  'piercing': 'Perforante',
  'poison': 'Veleno',
  'psychic': 'Psichico',
  'radiant': 'Radioso',
  'slashing': 'Tagliente',
  'thunder': 'Tuono',
};

final phbWarlockFiendishResilienceOptions = <CharacterChoiceOptionDefinition>[
  for (final entry in phbWarlockFiendishResilienceDamageTypeLabels.entries)
    CharacterChoiceOptionDefinition(
      id: entry.key,
      label: entry.value,
      effects: CharacterEffects(
        damageResistances: {entry.key},
        ruleEffects: [
          CharacterRuleEffect(
            id: 'fiendish_resilience_${entry.key}',
            type: CharacterRuleEffectType.conditional,
            target: 'damage_resistance',
            referenceIds: [entry.key],
            condition: 'ignored_by_damage_from_magical_or_silvered_weapons',
          ),
        ],
      ),
    ),
];

CharacterClassFeatureDefinition _warlockPatronFeature({
  required String id,
  required String name,
  required String summary,
  required String details,
  required RuleSource source,
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
        description: RuleDescription(
          summary: summary,
          details: details,
        ),
        source: source,
        ownerId: ClassIds.warlock,
      ),
      ruleTags: ruleTags,
      resourceId: resourceId,
      choices: choices,
      effects: effects,
    );

final warlockArchfeyFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WarlockArchfeyFeatureIds.feyPresence: _warlockPatronFeature(
    id: WarlockArchfeyFeatureIds.feyPresence,
    name: 'Presenza Fatata',
    summary:
        'Il Warlock emana la presenza seducente o inquietante dei folletti.',
    details:
        'Dal 1° livello, con un’azione obbliga ogni creatura entro un cubo con spigolo di 3 metri originato da lui a effettuare un tiro salvezza su Saggezza contro la CD dei suoi incantesimi. Chi fallisce è affascinato o spaventato dal Warlock, a sua scelta, fino alla fine del suo turno successivo. Recupera l’utilizzo con un riposo breve o lungo.',
    source: _phbWarlockArchfeySource,
    ruleTags: const {
      'action',
      'wisdom_saving_throw',
      'charmed_or_frightened',
      'short_or_long_rest',
    },
    resourceId: WarlockArchfeyResourceIds.feyPresence,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'archfey_fey_presence_area',
          type: CharacterRuleEffectType.conditional,
          target: 'three_meter_cube_originating_from_warlock',
          value: 3,
          condition:
              'wisdom_save_against_spell_dc_on_failure_choose_charmed_or_frightened_until_end_of_warlock_next_turn',
        ),
      ],
    ),
  ),
  WarlockArchfeyFeatureIds.mistyEscape: _warlockPatronFeature(
    id: WarlockArchfeyFeatureIds.mistyEscape,
    name: 'Fuga Velata',
    summary:
        'Quando subisce danni, il Warlock diventa invisibile e si teletrasporta.',
    details:
        'Dal 6° livello, quando subisce danni può usare la reazione per diventare invisibile e teletrasportarsi fino a 18 metri in uno spazio libero visibile. L’invisibilità dura fino all’inizio del suo turno successivo oppure termina se attacca o lancia un incantesimo. Recupera l’utilizzo con un riposo breve o lungo.',
    source: _phbWarlockArchfeySource,
    ruleTags: const {
      'reaction',
      'teleportation',
      'invisibility',
      'short_or_long_rest',
    },
    resourceId: WarlockArchfeyResourceIds.mistyEscape,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'archfey_misty_escape_teleport',
          type: CharacterRuleEffectType.reaction,
          target: 'teleport_to_visible_unoccupied_space_meters',
          value: 18,
          condition:
              'when_taking_damage_become_invisible_until_start_of_next_turn_or_until_attack_or_spell',
        ),
      ],
    ),
  ),
  WarlockArchfeyFeatureIds.beguilingDefenses: _warlockPatronFeature(
    id: WarlockArchfeyFeatureIds.beguilingDefenses,
    name: 'Difese Seducenti',
    summary:
        'Il Warlock è immune all’essere affascinato e può riflettere l’effetto.',
    details:
        'Dal 10° livello non può essere affascinato. Quando una creatura tenta di affascinarlo può usare la reazione per costringerla a un tiro salvezza su Saggezza contro la CD dei suoi incantesimi; se fallisce, la creatura è affascinata dal Warlock per 1 minuto o finché subisce danni.',
    source: _phbWarlockArchfeySource,
    ruleTags: const {
      'charmed_immunity',
      'reaction',
      'reflected_charm',
    },
    effects: const CharacterEffects(
      conditionImmunities: {'charmed'},
      ruleEffects: [
        CharacterRuleEffect(
          id: 'archfey_beguiling_defenses_reflection',
          type: CharacterRuleEffectType.reaction,
          target: 'creature_attempting_to_charm_warlock',
          condition:
              'wisdom_save_against_spell_dc_or_charmed_for_one_minute_or_until_damaged',
        ),
      ],
    ),
  ),
  WarlockArchfeyFeatureIds.darkDelirium: _warlockPatronFeature(
    id: WarlockArchfeyFeatureIds.darkDelirium,
    name: 'Delirio Oscuro',
    summary: 'Il Warlock trascina una creatura in un reame illusorio.',
    details:
        'Dal 14° livello, con un’azione sceglie una creatura visibile entro 18 metri. Se fallisce un tiro salvezza su Saggezza contro la CD dei suoi incantesimi, è affascinata o spaventata dal Warlock per 1 minuto o finché termina la concentrazione. L’effetto termina anticipatamente se la creatura subisce danni. Recupera l’utilizzo con un riposo breve o lungo.',
    source: _phbWarlockArchfeySource,
    ruleTags: const {
      'action',
      'illusion',
      'concentration',
      'charmed_or_frightened',
      'short_or_long_rest',
    },
    resourceId: WarlockArchfeyResourceIds.darkDelirium,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'archfey_dark_delirium_target',
          type: CharacterRuleEffectType.conditional,
          target: 'one_visible_creature_within_meters',
          value: 18,
          condition:
              'wisdom_save_against_spell_dc_on_failure_choose_charmed_or_frightened_one_minute_concentration_ends_on_damage',
        ),
      ],
    ),
  ),
};

const warlockArchfeyResources = <ClassResourceDefinition>[
  ClassResourceDefinition(
    id: WarlockArchfeyResourceIds.feyPresence,
    name: 'Presenza Fatata',
    minimumLevel: 1,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {1: 1},
  ),
  ClassResourceDefinition(
    id: WarlockArchfeyResourceIds.mistyEscape,
    name: 'Fuga Velata',
    minimumLevel: 6,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {6: 1},
  ),
  ClassResourceDefinition(
    id: WarlockArchfeyResourceIds.darkDelirium,
    name: 'Delirio Oscuro',
    minimumLevel: 14,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {14: 1},
  ),
];

final warlockArchfeyDefinition = CharacterSubclassDefinition(
  id: WarlockSubclassIds.archfey,
  name: 'Il Signore Fatato',
  classId: ClassIds.warlock,
  content: const RuleContent(
    id: WarlockSubclassIds.archfey,
    name: 'Il Signore Fatato',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Il patrono è un nobile o una dama dei folletti, custode di antichi segreti.',
      details:
          'Il Signore Fatato concede magia di ammaliamento e illusione, fughe soprannaturali e difese contro il controllo mentale.',
    ),
    source: _phbWarlockArchfeySource,
    ownerId: ClassIds.warlock,
  ),
  featuresByLevel: const {
    1: [WarlockArchfeyFeatureIds.feyPresence],
    6: [WarlockArchfeyFeatureIds.mistyEscape],
    10: [WarlockArchfeyFeatureIds.beguilingDefenses],
    14: [WarlockArchfeyFeatureIds.darkDelirium],
  },
  featureDefinitions: warlockArchfeyFeatureDefinitions,
  expandedSpellIdsByLevel: phbWarlockArchfeyExpandedSpellIdsByLevel,
  resources: warlockArchfeyResources,
);

final warlockFiendFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WarlockFiendFeatureIds.darkOnesBlessing: _warlockPatronFeature(
    id: WarlockFiendFeatureIds.darkOnesBlessing,
    name: 'Benedizione dell’Oscuro',
    summary: 'Abbattere una creatura ostile concede punti ferita temporanei.',
    details:
        'Dal 1° livello, quando porta una creatura ostile a 0 punti ferita, il Warlock ottiene punti ferita temporanei pari al proprio modificatore di Carisma più il proprio livello da Warlock, fino a un minimo di 1.',
    source: _phbWarlockFiendSource,
    ruleTags: const {
      'temporary_hit_points',
      'hostile_creature_zero_hp',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'fiend_dark_ones_blessing_temporary_hit_points',
          type: CharacterRuleEffectType.conditional,
          target: 'temporary_hit_points',
          condition:
              'when_hostile_creature_reduced_to_zero_charisma_modifier_plus_warlock_level_minimum_one',
        ),
      ],
    ),
  ),
  WarlockFiendFeatureIds.darkOnesOwnLuck: _warlockPatronFeature(
    id: WarlockFiendFeatureIds.darkOnesOwnLuck,
    name: 'Fortuna dell’Oscuro',
    summary:
        'Il Warlock aggiunge 1d10 a una prova di caratteristica o a un tiro salvezza.',
    details:
        'Dal 6° livello può aggiungere 1d10 a una prova di caratteristica o a un tiro salvezza dopo aver visto il tiro iniziale ma prima che l’effetto sia applicato. Recupera l’utilizzo con un riposo breve o lungo.',
    source: _phbWarlockFiendSource,
    ruleTags: const {
      'ability_check',
      'saving_throw',
      'one_d10',
      'short_or_long_rest',
    },
    resourceId: WarlockFiendResourceIds.darkOnesOwnLuck,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'fiend_dark_ones_own_luck_bonus',
          type: CharacterRuleEffectType.conditional,
          target: 'ability_check_or_saving_throw',
          condition:
              'add_one_d10_after_seeing_initial_roll_before_effect_applies',
        ),
      ],
    ),
  ),
  WarlockFiendFeatureIds.fiendishResilience: _warlockPatronFeature(
    id: WarlockFiendFeatureIds.fiendishResilience,
    name: 'Resilienza Immonda',
    summary:
        'Dopo un riposo il Warlock sceglie un tipo di danno a cui resistere.',
    details:
        'Dal 10° livello, quando completa un riposo breve o lungo sceglie un tipo di danno e ne ottiene resistenza finché non effettua una nuova scelta. I danni inferti da armi magiche o argentate ignorano questa resistenza.',
    source: _phbWarlockFiendSource,
    ruleTags: const {
      'damage_resistance',
      'reselect_after_short_or_long_rest',
      'magical_or_silvered_weapon_exception',
    },
    choices: [
      CharacterChoiceDefinition(
        id: WarlockFiendChoiceIds.fiendishResilienceDamageType,
        label: 'Scegli il tipo di danno per Resilienza Immonda',
        type: CharacterChoiceType.other,
        minimumSelections: 1,
        maximumSelections: 1,
        options: phbWarlockFiendishResilienceOptions,
        unique: true,
      ),
    ],
  ),
  WarlockFiendFeatureIds.hurlThroughHell: _warlockPatronFeature(
    id: WarlockFiendFeatureIds.hurlThroughHell,
    name: 'Scagliare all’Inferno',
    summary:
        'Un bersaglio colpito viene trascinato temporaneamente nei piani inferiori.',
    details:
        'Dal 14° livello, quando colpisce una creatura con un attacco, il Warlock può farla scomparire nei piani inferiori. Il bersaglio ritorna alla fine del turno successivo del Warlock nello spazio precedente o nel più vicino spazio libero. Se non è un immondo subisce 10d10 danni psichici. Recupera l’utilizzo con un riposo lungo.',
    source: _phbWarlockFiendSource,
    ruleTags: const {
      'on_attack_hit',
      'banishment',
      'psychic_damage',
      'long_rest',
    },
    resourceId: WarlockFiendResourceIds.hurlThroughHell,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'fiend_hurl_through_hell_effect',
          type: CharacterRuleEffectType.conditional,
          target: 'creature_hit_by_attack',
          referenceIds: ['psychic'],
          condition:
              'disappears_until_end_of_warlock_next_turn_non_fiend_takes_10d10_psychic_damage',
        ),
      ],
    ),
  ),
};

const warlockFiendResources = <ClassResourceDefinition>[
  ClassResourceDefinition(
    id: WarlockFiendResourceIds.darkOnesOwnLuck,
    name: 'Fortuna dell’Oscuro',
    minimumLevel: 6,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {6: 1},
  ),
  ClassResourceDefinition(
    id: WarlockFiendResourceIds.hurlThroughHell,
    name: 'Scagliare all’Inferno',
    minimumLevel: 14,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {14: 1},
  ),
];

final warlockFiendDefinition = CharacterSubclassDefinition(
  id: WarlockSubclassIds.fiend,
  name: 'L’Immondo',
  classId: ClassIds.warlock,
  content: const RuleContent(
    id: WarlockSubclassIds.fiend,
    name: 'L’Immondo',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Il patrono è un potente immondo dei piani inferiori di esistenza.',
      details:
          'L’Immondo concede tenacia soprannaturale, controllo del fato, resistenza ai danni e il potere di trascinare i nemici nei piani inferiori.',
    ),
    source: _phbWarlockFiendSource,
    ownerId: ClassIds.warlock,
  ),
  featuresByLevel: const {
    1: [WarlockFiendFeatureIds.darkOnesBlessing],
    6: [WarlockFiendFeatureIds.darkOnesOwnLuck],
    10: [WarlockFiendFeatureIds.fiendishResilience],
    14: [WarlockFiendFeatureIds.hurlThroughHell],
  },
  featureDefinitions: warlockFiendFeatureDefinitions,
  expandedSpellIdsByLevel: phbWarlockFiendExpandedSpellIdsByLevel,
  resources: warlockFiendResources,
);

const _phbWarlockGreatOldOneSource = RuleSource(
  name: 'Manuale del Giocatore 2014',
  reference: 'p. 118',
);

abstract final class WarlockGreatOldOneFeatureIds {
  static const awakenedMind = 'great_old_one_awakened_mind';
  static const entropicWard = 'great_old_one_entropic_ward';
  static const thoughtShield = 'great_old_one_thought_shield';
  static const createThrall = 'great_old_one_create_thrall';
}

abstract final class WarlockGreatOldOneResourceIds {
  static const entropicWard = 'great_old_one_entropic_ward_use';
}

const phbWarlockGreatOldOneExpandedSpellIdsByLevel = <int, Set<String>>{
  1: {'dissonant_whispers', 'tashas_hideous_laughter'},
  3: {'detect_thoughts', 'phantasmal_force'},
  5: {'clairvoyance', 'sending'},
  7: {'dominate_beast', 'evards_black_tentacles'},
  9: {'dominate_person', 'telekinesis'},
};

final warlockGreatOldOneFeatureDefinitions =
    <String, CharacterClassFeatureDefinition>{
  WarlockGreatOldOneFeatureIds.awakenedMind: _warlockPatronFeature(
    id: WarlockGreatOldOneFeatureIds.awakenedMind,
    name: 'Mente Risvegliata',
    summary: 'Il Warlock comunica telepaticamente con le creature visibili.',
    details:
        'Dal 1° livello può parlare telepaticamente con qualsiasi creatura visibile entro 9 metri. Non è necessario condividere un linguaggio, ma la creatura deve essere in grado di capire almeno un linguaggio.',
    source: _phbWarlockGreatOldOneSource,
    ruleTags: const {
      'telepathy',
      'visible_creature',
      'language_required',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'great_old_one_awakened_mind_telepathy',
          type: CharacterRuleEffectType.conditional,
          target: 'visible_creature_within_meters',
          value: 9,
          condition:
              'telepathic_speech_no_shared_language_required_target_must_understand_at_least_one_language',
        ),
      ],
    ),
  ),
  WarlockGreatOldOneFeatureIds.entropicWard: _warlockPatronFeature(
    id: WarlockGreatOldOneFeatureIds.entropicWard,
    name: 'Interdizione Entropica',
    summary:
        'Il Warlock ostacola un attacco e trasforma un colpo mancato in un vantaggio.',
    details:
        'Dal 6° livello, quando una creatura effettua un tiro per colpire contro il Warlock, egli può usare la reazione per imporre svantaggio. Se l’attacco manca, il successivo tiro per colpire del Warlock contro quella creatura dispone di vantaggio se effettuato entro la fine del suo turno successivo. Recupera l’utilizzo con un riposo breve o lungo.',
    source: _phbWarlockGreatOldOneSource,
    ruleTags: const {
      'reaction',
      'disadvantage',
      'conditional_advantage',
      'short_or_long_rest',
    },
    resourceId: WarlockGreatOldOneResourceIds.entropicWard,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'great_old_one_entropic_ward_disadvantage',
          type: CharacterRuleEffectType.disadvantage,
          target: 'incoming_attack_roll',
          condition: 'reaction_when_creature_makes_attack_roll_against_warlock',
        ),
        CharacterRuleEffect(
          id: 'great_old_one_entropic_ward_advantage',
          type: CharacterRuleEffectType.advantage,
          target: 'next_attack_roll_against_same_creature',
          condition:
              'only_if_triggering_attack_misses_before_end_of_warlock_next_turn',
        ),
      ],
    ),
  ),
  WarlockGreatOldOneFeatureIds.thoughtShield: _warlockPatronFeature(
    id: WarlockGreatOldOneFeatureIds.thoughtShield,
    name: 'Scudo del Pensiero',
    summary: 'La mente del Warlock è protetta e riflette i danni psichici.',
    details:
        'Dal 10° livello i suoi pensieri non possono essere letti tramite telepatia o altri mezzi senza il suo consenso. Ottiene resistenza ai danni psichici e ogni creatura che gli infligge danni psichici subisce lo stesso ammontare di danni.',
    source: _phbWarlockGreatOldOneSource,
    ruleTags: const {
      'thought_protection',
      'psychic_resistance',
      'psychic_damage_reflection',
    },
    effects: const CharacterEffects(
      damageResistances: {'psychic'},
      ruleEffects: [
        CharacterRuleEffect(
          id: 'great_old_one_thought_shield_privacy',
          type: CharacterRuleEffectType.conditional,
          target: 'thought_reading',
          condition:
              'cannot_read_thoughts_by_telepathy_or_other_means_without_warlock_consent',
        ),
        CharacterRuleEffect(
          id: 'great_old_one_thought_shield_reflection',
          type: CharacterRuleEffectType.conditional,
          target: 'creature_dealing_psychic_damage_to_warlock',
          referenceIds: ['psychic'],
          condition:
              'source_creature_takes_psychic_damage_equal_to_damage_dealt',
        ),
      ],
    ),
  ),
  WarlockGreatOldOneFeatureIds.createThrall: _warlockPatronFeature(
    id: WarlockGreatOldOneFeatureIds.createThrall,
    name: 'Creare Servitore',
    summary: 'Il Warlock contamina la mente di un umanoide incapacitato.',
    details:
        'Dal 14° livello, con un’azione tocca un umanoide incapacitato, che diventa affascinato dal Warlock finché non viene bersagliato da Rimuovi Maledizione, la condizione non viene rimossa o il Warlock usa nuovamente il privilegio. Il Warlock può comunicare telepaticamente con il servitore finché entrambi si trovano sullo stesso piano di esistenza.',
    source: _phbWarlockGreatOldOneSource,
    ruleTags: const {
      'action',
      'touch',
      'incapacitated_humanoid',
      'charmed',
      'single_thrall',
      'same_plane_telepathy',
    },
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'great_old_one_create_thrall_charm',
          type: CharacterRuleEffectType.conditional,
          target: 'incapacitated_humanoid_touched',
          referenceIds: ['remove_curse'],
          condition:
              'charmed_until_remove_curse_condition_removed_or_feature_used_again',
        ),
        CharacterRuleEffect(
          id: 'great_old_one_create_thrall_telepathy',
          type: CharacterRuleEffectType.conditional,
          target: 'current_charmed_thrall',
          condition: 'telepathic_communication_while_both_are_on_same_plane',
        ),
      ],
    ),
  ),
};

const warlockGreatOldOneResources = <ClassResourceDefinition>[
  ClassResourceDefinition(
    id: WarlockGreatOldOneResourceIds.entropicWard,
    name: 'Interdizione Entropica',
    minimumLevel: 6,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {6: 1},
  ),
];

final warlockGreatOldOneDefinition = CharacterSubclassDefinition(
  id: WarlockSubclassIds.greatOldOne,
  name: 'Il Grande Antico',
  classId: ClassIds.warlock,
  content: const RuleContent(
    id: WarlockSubclassIds.greatOldOne,
    name: 'Il Grande Antico',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Il patrono è un’entità aliena ed estranea al tessuto della realtà.',
      details:
          'Il Grande Antico concede telepatia, difese entropiche, protezione mentale e il potere di contaminare la mente di un servitore.',
    ),
    source: _phbWarlockGreatOldOneSource,
    ownerId: ClassIds.warlock,
  ),
  featuresByLevel: const {
    1: [WarlockGreatOldOneFeatureIds.awakenedMind],
    6: [WarlockGreatOldOneFeatureIds.entropicWard],
    10: [WarlockGreatOldOneFeatureIds.thoughtShield],
    14: [WarlockGreatOldOneFeatureIds.createThrall],
  },
  featureDefinitions: warlockGreatOldOneFeatureDefinitions,
  expandedSpellIdsByLevel: phbWarlockGreatOldOneExpandedSpellIdsByLevel,
  resources: warlockGreatOldOneResources,
);

final warlockFeatureDefinitions = <String, CharacterClassFeatureDefinition>{
  WarlockFeatureIds.otherworldlyPatron: _warlockFeature(
    id: WarlockFeatureIds.otherworldlyPatron,
    name: 'Patrono Ultraterreno',
    summary: 'Stipula un patto con un potente essere extraplanare.',
    details:
        'Al 1° livello sceglie il Signore Fatato, l’Immondo o il Grande Antico. Il patrono concede privilegi al 1°, 6°, 10° e 14° livello.',
    ruleTags: const {'subclass_choice', 'otherworldly_patron'},
  ),
  WarlockFeatureIds.pactMagic: _warlockFeature(
    id: WarlockFeatureIds.pactMagic,
    name: 'Magia del Patto',
    summary:
        'Lancia incantesimi usando slot del Patto tutti dello stesso livello.',
    details:
        'Tutti gli slot incantesimo del Warlock hanno il livello indicato dalla progressione. Gli slot spesi vengono recuperati al termine di un riposo breve o lungo.',
    ruleTags: const {
      'spellcasting',
      'pact_magic',
      'short_rest',
      'long_rest',
    },
    resourceId: WarlockResourceIds.pactMagicSlots,
  ),
  WarlockFeatureIds.eldritchInvocations: _warlockFeature(
    id: WarlockFeatureIds.eldritchInvocations,
    name: 'Suppliche Occulte',
    summary: 'Apprende frammenti di conoscenza proibita.',
    details:
        'Al 2° livello sceglie due Suppliche Occulte. Il numero aumenta con la progressione della classe e una supplica conosciuta può essere sostituita ogni volta che il Warlock acquisisce un livello.',
    ruleTags: const {
      'eldritch_invocations',
      'replace_on_level_up',
    },
    choices: [
      CharacterChoiceDefinition(
        id: WarlockChoiceIds.eldritchInvocations,
        label: 'Scegli le Suppliche Occulte',
        type: CharacterChoiceType.other,
        catalogId: CharacterChoiceCatalogIds.eldritchInvocations,
        minimumSelections: 2,
        maximumSelections: 8,
        optionIds: phbWarlockEldritchInvocationIds,
        unique: true,
      ),
    ],
  ),
  WarlockFeatureIds.pactBoon: _warlockFeature(
    id: WarlockFeatureIds.pactBoon,
    name: 'Dono del Patto',
    summary: 'Riceve un dono speciale dal proprio patrono.',
    details:
        'Al 3° livello sceglie il Patto della Catena, il Patto della Lama o il Patto del Tomo.',
    ruleTags: const {'pact_boon', 'choice'},
    choices: [
      CharacterChoiceDefinition(
        id: WarlockChoiceIds.pactBoon,
        label: 'Scegli il Dono del Patto',
        type: CharacterChoiceType.other,
        optionIds: const [
          WarlockPactBoonIds.chain,
          WarlockPactBoonIds.blade,
          WarlockPactBoonIds.tome,
        ],
        options: phbWarlockPactBoonOptions,
      ),
    ],
  ),
  WarlockFeatureIds.abilityScoreImprovement: _warlockFeature(
    id: WarlockFeatureIds.abilityScoreImprovement,
    name: 'Aumento dei Punteggi di Caratteristica',
    summary: 'Aumenta i punteggi di caratteristica o sceglie un talento.',
    details:
        'Aumenta di 2 un punteggio di caratteristica oppure aumenta di 1 due punteggi, senza superare 20 tramite questo privilegio.',
    ruleTags: const {'ability_score_improvement'},
  ),
  WarlockFeatureIds.mysticArcanum6: _mysticArcanumFeature(
    id: WarlockFeatureIds.mysticArcanum6,
    name: 'Arcanum Mistico (6° livello)',
    choiceId: WarlockChoiceIds.mysticArcanum6,
    resourceId: WarlockResourceIds.mysticArcanum6,
    spellLevel: 6,
    spellIds: phbWarlockMysticArcanum6SpellIds,
  ),
  WarlockFeatureIds.mysticArcanum7: _mysticArcanumFeature(
    id: WarlockFeatureIds.mysticArcanum7,
    name: 'Arcanum Mistico (7° livello)',
    choiceId: WarlockChoiceIds.mysticArcanum7,
    resourceId: WarlockResourceIds.mysticArcanum7,
    spellLevel: 7,
    spellIds: phbWarlockMysticArcanum7SpellIds,
  ),
  WarlockFeatureIds.mysticArcanum8: _mysticArcanumFeature(
    id: WarlockFeatureIds.mysticArcanum8,
    name: 'Arcanum Mistico (8° livello)',
    choiceId: WarlockChoiceIds.mysticArcanum8,
    resourceId: WarlockResourceIds.mysticArcanum8,
    spellLevel: 8,
    spellIds: phbWarlockMysticArcanum8SpellIds,
  ),
  WarlockFeatureIds.mysticArcanum9: _mysticArcanumFeature(
    id: WarlockFeatureIds.mysticArcanum9,
    name: 'Arcanum Mistico (9° livello)',
    choiceId: WarlockChoiceIds.mysticArcanum9,
    resourceId: WarlockResourceIds.mysticArcanum9,
    spellLevel: 9,
    spellIds: phbWarlockMysticArcanum9SpellIds,
  ),
  WarlockFeatureIds.eldritchMaster: _warlockFeature(
    id: WarlockFeatureIds.eldritchMaster,
    name: 'Maestro dell’Occulto',
    summary: 'Invoca il patrono per recuperare gli slot della Magia del Patto.',
    details:
        'Trascorre 1 minuto invocando il patrono e recupera tutti gli slot della Magia del Patto spesi. Deve completare un riposo lungo prima di usare nuovamente il privilegio.',
    ruleTags: const {
      'duration_1_minute',
      'recover_all_pact_slots',
      'long_rest',
    },
    resourceId: WarlockResourceIds.eldritchMaster,
    effects: const CharacterEffects(
      ruleEffects: [
        CharacterRuleEffect(
          id: 'eldritch_master_restore_pact_slots',
          type: CharacterRuleEffectType.resource,
          target: WarlockResourceIds.pactMagicSlots,
          condition: 'after_one_minute_restore_all_spent_pact_magic_slots',
        ),
      ],
    ),
  ),
};

const warlockResources = <ClassResourceDefinition>[
  ClassResourceDefinition(
    id: WarlockResourceIds.pactMagicSlots,
    name: 'Slot della Magia del Patto',
    minimumLevel: 1,
    recovery: ClassResourceRecovery.shortRest,
    maximumByLevel: {
      1: 1,
      2: 2,
      11: 3,
      17: 4,
    },
  ),
  ClassResourceDefinition(
    id: WarlockResourceIds.mysticArcanum6,
    name: 'Arcanum Mistico di 6° livello',
    minimumLevel: 11,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {11: 1},
  ),
  ClassResourceDefinition(
    id: WarlockResourceIds.mysticArcanum7,
    name: 'Arcanum Mistico di 7° livello',
    minimumLevel: 13,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {13: 1},
  ),
  ClassResourceDefinition(
    id: WarlockResourceIds.mysticArcanum8,
    name: 'Arcanum Mistico di 8° livello',
    minimumLevel: 15,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {15: 1},
  ),
  ClassResourceDefinition(
    id: WarlockResourceIds.mysticArcanum9,
    name: 'Arcanum Mistico di 9° livello',
    minimumLevel: 17,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {17: 1},
  ),
  ClassResourceDefinition(
    id: WarlockResourceIds.eldritchMaster,
    name: 'Maestro dell’Occulto',
    minimumLevel: 20,
    recovery: ClassResourceRecovery.longRest,
    maximumByLevel: {20: 1},
  ),
];

final warlockClassDefinition = CharacterClassDefinition(
  id: ClassIds.warlock,
  name: 'Warlock',
  content: const RuleContent(
    id: ClassIds.warlock,
    name: 'Warlock',
    type: RuleContentType.classFeature,
    description: RuleDescription(
      summary:
          'Un incantatore che ottiene conoscenze e poteri stipulando un patto con un’entità ultraterrena.',
      details:
          'Il Warlock combina Magia del Patto, Suppliche Occulte, un Dono del Patto e gli insegnamenti progressivi del proprio patrono.',
    ),
    source: _phbWarlockSource,
    ownerId: ClassIds.warlock,
  ),
  hitDie: 8,
  proficiencies: const ClassProficiencyDefinition(
    armor: {'light_armor'},
    weapons: {'simple_weapons'},
    savingThrows: {'SAG', 'CAR'},
    skillOptions: {
      'arcana',
      'investigation',
      'deception',
      'intimidation',
      'nature',
      'religion',
      'history',
    },
    skillChoices: 2,
    choices: [
      ClassProficiencyChoiceDefinition(
        id: 'warlock_skills',
        label: 'Scegli due abilità da Warlock',
        type: ClassProficiencyChoiceType.skill,
        optionIds: {
          'arcana',
          'investigation',
          'deception',
          'intimidation',
          'nature',
          'religion',
          'history',
        },
        selections: 2,
      ),
    ],
  ),
  startingEquipmentChoices: [
    ClassEquipmentChoice(
      id: 'warlock_primary_weapon',
      label: 'Scegli la dotazione offensiva',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'warlock_light_crossbow',
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
          id: 'warlock_simple_weapon',
          label: 'Una qualsiasi Arma Semplice',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'warlock_primary_simple_weapon',
              label: 'Scegli un’Arma Semplice',
              catalogId: 'weapon',
              optionIds: _warlockSimpleWeaponIds,
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'warlock_spellcasting_focus',
      label: 'Scegli il focus da incantatore',
      alternatives: [
        const ClassEquipmentAlternative(
          id: 'warlock_component_pouch',
          label: 'Borsa dei Componenti',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'focus',
              itemId: FocusIds.componentPouch,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'warlock_arcane_focus',
          label: 'Un Focus Arcano',
          grants: const [],
          itemChoices: [
            const ClassEquipmentItemChoice(
              id: 'warlock_arcane_focus_selection',
              label: 'Scegli un Focus Arcano',
              catalogId: 'focus',
              optionIds: _warlockArcaneFocusIds,
            ),
          ],
        ),
      ],
    ),
    const ClassEquipmentChoice(
      id: 'warlock_starting_pack',
      label: 'Scegli la dotazione iniziale',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'warlock_scholar_pack',
          label: 'Dotazione da Studioso',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.scholar,
            ),
          ],
        ),
        ClassEquipmentAlternative(
          id: 'warlock_dungeoneer_pack',
          label: 'Dotazione da Avventuriero',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'equipment_pack',
              itemId: EquipmentPackIds.dungeoneer,
            ),
          ],
        ),
      ],
    ),
    ClassEquipmentChoice(
      id: 'warlock_additional_simple_weapon',
      label: 'Scegli l’Arma Semplice aggiuntiva',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'warlock_additional_simple_weapon_selection',
          label: 'Una qualsiasi Arma Semplice',
          grants: const [],
          itemChoices: [
            ClassEquipmentItemChoice(
              id: 'warlock_additional_simple_weapon_item',
              label: 'Scegli un’Arma Semplice',
              catalogId: 'weapon',
              optionIds: _warlockSimpleWeaponIds,
            ),
          ],
        ),
      ],
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
      quantity: 2,
    ),
  ],
  featuresByLevel: const {
    1: [
      WarlockFeatureIds.otherworldlyPatron,
      WarlockFeatureIds.pactMagic,
    ],
    2: [WarlockFeatureIds.eldritchInvocations],
    3: [WarlockFeatureIds.pactBoon],
    4: [WarlockFeatureIds.abilityScoreImprovement],
    8: [WarlockFeatureIds.abilityScoreImprovement],
    11: [WarlockFeatureIds.mysticArcanum6],
    12: [WarlockFeatureIds.abilityScoreImprovement],
    13: [WarlockFeatureIds.mysticArcanum7],
    15: [WarlockFeatureIds.mysticArcanum8],
    16: [WarlockFeatureIds.abilityScoreImprovement],
    17: [WarlockFeatureIds.mysticArcanum9],
    19: [WarlockFeatureIds.abilityScoreImprovement],
    20: [WarlockFeatureIds.eldritchMaster],
  },
  featureDefinitions: warlockFeatureDefinitions,
  resources: warlockResources,
  progressionValues: const [
    ClassProgressionValueDefinition(
      id: WarlockProgressionIds.invocationsKnown,
      name: 'Suppliche Conosciute',
      valuesByLevel: {
        2: '2',
        5: '3',
        7: '4',
        9: '5',
        12: '6',
        15: '7',
        18: '8',
      },
    ),
  ],
  spellcasting: ClassSpellcastingDefinition(
    progression: ClassSpellcastingProgression.pact,
    ability: 'CAR',
    minimumLevel: 1,
    ritualCasting: false,
    preparesSpells: false,
    spellIds: phbWarlockSpellIds,
    cantripsKnownByLevel: const {
      1: 2,
      4: 3,
      10: 4,
    },
    spellsKnownByLevel: const {
      1: 2,
      2: 3,
      3: 4,
      4: 5,
      5: 6,
      6: 7,
      7: 8,
      8: 9,
      9: 10,
      10: 10,
      11: 11,
      12: 11,
      13: 12,
      14: 12,
      15: 13,
      16: 13,
      17: 14,
      18: 14,
      19: 15,
      20: 15,
    },
    slotsByClassLevel: const {
      1: [1],
      2: [2],
      3: [0, 2],
      4: [0, 2],
      5: [0, 0, 2],
      6: [0, 0, 2],
      7: [0, 0, 0, 2],
      8: [0, 0, 0, 2],
      9: [0, 0, 0, 0, 2],
      10: [0, 0, 0, 0, 2],
      11: [0, 0, 0, 0, 3],
      12: [0, 0, 0, 0, 3],
      13: [0, 0, 0, 0, 3],
      14: [0, 0, 0, 0, 3],
      15: [0, 0, 0, 0, 3],
      16: [0, 0, 0, 0, 3],
      17: [0, 0, 0, 0, 4],
      18: [0, 0, 0, 0, 4],
      19: [0, 0, 0, 0, 4],
      20: [0, 0, 0, 0, 4],
    },
    pactSlotLevelByClassLevel: const {
      1: 1,
      3: 2,
      5: 3,
      7: 4,
      9: 5,
    },
  ),
  subclassSelectionLevel: 1,
  subclasses: {
    WarlockSubclassIds.archfey: warlockArchfeyDefinition,
    WarlockSubclassIds.fiend: warlockFiendDefinition,
    WarlockSubclassIds.greatOldOne: warlockGreatOldOneDefinition,
  },
);
