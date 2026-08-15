import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

const _manualSource = BestiarySourceDefinition(
  book: 'Manuale dei Mostri',
  edition: '2014',
  reference: 'Scheda di prova',
  pageStart: 1,
);

const _wolfFixture = CreatureDefinition(
  id: 'wolf_fixture',
  name: 'Lupo di prova',
  aliases: {'lupo'},
  source: _manualSource,
  size: CreatureSize.medium,
  type: CreatureType.beast,
  subtypes: {'canide'},
  tags: {'animale_reale'},
  alignment: 'senza allineamento',
  armorClass: CreatureArmorClassDefinition(value: 13),
  hitPoints: CreatureHitPointsDefinition(
    average: 11,
    diceCount: 2,
    dieSize: 8,
    modifier: 2,
  ),
  abilities: CreatureAbilityScores(
    strength: 12,
    dexterity: 15,
    constitution: 12,
    intelligence: 3,
    wisdom: 12,
    charisma: 6,
  ),
  movements: [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 12,
    ),
  ],
  skillBonuses: {
    'perception': 3,
    'stealth': 4,
  },
  senses: [
    CreatureSenseDefinition(
      type: CreatureSenseType.darkvision,
      meters: 18,
    ),
  ],
  passivePerception: 13,
  environments: {
    CreatureEnvironment.forest,
    CreatureEnvironment.grassland,
  },
  challengeRating: 0.25,
  experiencePoints: 50,
  proficiencyBonus: 2,
  traits: [
    CreatureRuleDefinition(
      id: 'keen_hearing_and_smell',
      name: 'Udito e Olfatto Acuti',
      description: 'Scheda utilizzata esclusivamente dal test.',
    ),
  ],
  actions: [
    CreatureActionDefinition(
      id: 'bite',
      name: 'Morso',
      description: 'Attacco con arma da mischia.',
      effects: [
        CreatureEffectDefinition(
          id: 'bite_prone',
          target: 'creatura_colpita',
          condition: 'tiro_salvezza_fallito',
          tags: {'prone'},
        ),
      ],
      attack: CreatureAttackDefinition(
        type: CreatureAttackType.meleeWeapon,
        attackBonus: 4,
        reachMeters: 1.5,
        target: 'una creatura',
        damages: [
          CreatureDamageDefinition(
            damageType: 'perforante',
            average: 7,
            diceCount: 2,
            dieSize: 4,
            modifier: 2,
          ),
        ],
      ),
    ),
  ],
  multiattacks: [
    CreatureMultiattackDefinition(
      id: 'test_multiattack',
      name: 'Multiattacco di prova',
      description: 'Usa due volte Morso.',
      options: [
        CreatureMultiattackOptionDefinition(
          id: 'two_bites',
          description: 'Due attacchi con Morso.',
          actionUses: {'bite': 2},
        ),
      ],
    ),
  ],
);

const _eagleFixture = CreatureDefinition(
  id: 'eagle_fixture',
  name: 'Aquila di prova',
  source: _manualSource,
  size: CreatureSize.small,
  type: CreatureType.beast,
  alignment: 'senza allineamento',
  armorClass: CreatureArmorClassDefinition(value: 12),
  hitPoints: CreatureHitPointsDefinition(
    average: 3,
    diceCount: 1,
    dieSize: 6,
  ),
  abilities: CreatureAbilityScores(
    strength: 6,
    dexterity: 15,
    constitution: 10,
    intelligence: 2,
    wisdom: 14,
    charisma: 7,
  ),
  movements: [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 3,
    ),
    CreatureMovementDefinition(
      type: CreatureMovementType.flying,
      meters: 18,
    ),
  ],
  passivePerception: 14,
  environments: {CreatureEnvironment.mountain},
  challengeRating: 0,
  experiencePoints: 10,
  proficiencyBonus: 2,
);

const _swarmFixture = CreatureDefinition(
  id: 'swarm_fixture',
  name: 'Sciame di prova',
  source: _manualSource,
  size: CreatureSize.medium,
  type: CreatureType.beast,
  swarmOfSize: CreatureSize.tiny,
  alignment: 'senza allineamento',
  armorClass: CreatureArmorClassDefinition(value: 10),
  hitPoints: CreatureHitPointsDefinition(
    average: 5,
    diceCount: 2,
    dieSize: 4,
  ),
  abilities: CreatureAbilityScores(
    strength: 1,
    dexterity: 10,
    constitution: 10,
    intelligence: 1,
    wisdom: 10,
    charisma: 1,
  ),
  movements: [
    CreatureMovementDefinition(
      type: CreatureMovementType.walking,
      meters: 6,
    ),
  ],
  passivePerception: 10,
  challengeRating: 0.125,
  experiencePoints: 25,
  proficiencyBonus: 2,
);

void main() {
  test('source preserves edition and exact manual page', () {
    expect(_manualSource.book, 'Manuale dei Mostri');
    expect(_manualSource.edition, '2014');
    expect(_manualSource.pageLabel, 'p. 1');
  });

  test('ability scores resolve PHB modifiers', () {
    expect(_wolfFixture.abilities.modifierFor('FOR'), 1);
    expect(_wolfFixture.abilities.modifierFor('DES'), 2);
    expect(_wolfFixture.abilities.modifierFor('INT'), -4);
    expect(
      () => _wolfFixture.abilities.modifierFor('XXX'),
      throwsArgumentError,
    );
  });

  test('hit points and damage preserve average and dice formula', () {
    expect(_wolfFixture.hitPoints.formula, '2d8 + 2');

    final damage = _wolfFixture.actions.single.attack!.damages.single;

    expect(damage.average, 7);
    expect(damage.formula, '2d4 + 2');
  });

  test('complete stat block supports metadata and environments', () {
    expect(_wolfFixture.aliases, contains('lupo'));
    expect(_wolfFixture.subtypes, contains('canide'));
    expect(_wolfFixture.tags, contains('animale_reale'));
    expect(
      _wolfFixture.environments,
      contains(CreatureEnvironment.forest),
    );
    expect(_wolfFixture.homebrew, isFalse);
    expect(_wolfFixture.supplemental, isFalse);
  });

  test('effects and multiattacks resolve existing actions', () {
    final bite = _wolfFixture.actionFor('bite');

    expect(bite, isNotNull);
    expect(bite!.effects.single.id, 'bite_prone');
    expect(
      _wolfFixture.multiattacks.single.referencedActionIds,
      {'bite'},
    );
    expect(_wolfFixture.unresolvedMultiattackActionIds, isEmpty);
  });

  test('generic filters support type, size, challenge and habitat', () {
    const fixtures = [
      _wolfFixture,
      _eagleFixture,
      _swarmFixture,
    ];

    final result = filterBestiaryDefinitions(
      fixtures,
      allowedTypes: const {CreatureType.beast},
      maximumSize: CreatureSize.medium,
      maximumChallengeRating: 0.25,
      environments: const {CreatureEnvironment.forest},
      includeSwarms: false,
    ).toList();

    expect(result.map((creature) => creature.id), ['wolf_fixture']);
  });

  test('Wild Shape excludes flight and swarms when unavailable', () {
    const fixtures = [
      _wolfFixture,
      _eagleFixture,
      _swarmFixture,
    ];

    final levelTwoForms = eligibleWildShapeFormsFrom(
      fixtures,
      maximumChallengeRating: 0.25,
      allowsSwimmingSpeed: false,
      allowsFlyingSpeed: false,
      allowsSpellcasting: false,
    ).toList();

    expect(
      levelTwoForms.map((creature) => creature.id).toSet(),
      {'wolf_fixture'},
    );

    final flyingForms = eligibleWildShapeFormsFrom(
      fixtures,
      maximumChallengeRating: 0.25,
      allowsSwimmingSpeed: true,
      allowsFlyingSpeed: true,
      allowsSpellcasting: false,
    ).toList();

    expect(
      flyingForms.map((creature) => creature.id).toSet(),
      {'wolf_fixture', 'eagle_fixture'},
    );
  });

  test('Beast Master filtering excludes swarms', () {
    const fixtures = [
      _wolfFixture,
      _eagleFixture,
      _swarmFixture,
    ];

    final companions = eligibleBeastCompanionsFrom(
      fixtures,
      maximumChallengeRating: 0.25,
      maximumSize: CreatureSize.medium,
    ).toList();

    expect(
      companions.map((creature) => creature.id).toSet(),
      {'wolf_fixture', 'eagle_fixture'},
    );
  });

  test('advanced model supports conditional defenses and lairs', () {
    const creature = CreatureDefinition(
      id: 'advanced_fixture',
      name: 'Creatura avanzata',
      source: _manualSource,
      size: CreatureSize.large,
      type: CreatureType.dragon,
      alignment: 'legale malvagio',
      armorClass: CreatureArmorClassDefinition(value: 18),
      alternativeArmorClasses: [
        CreatureArmorClassDefinition(
          value: 20,
          description: 'All’interno della tana',
        ),
      ],
      hitPoints: CreatureHitPointsDefinition(
        average: 100,
        diceCount: 10,
        dieSize: 10,
        modifier: 40,
      ),
      abilities: CreatureAbilityScores(
        strength: 20,
        dexterity: 10,
        constitution: 18,
        intelligence: 14,
        wisdom: 12,
        charisma: 16,
      ),
      movements: [
        CreatureMovementDefinition(
          type: CreatureMovementType.walking,
          meters: 12,
        ),
      ],
      conditionalDamageInteractions: [
        CreatureDamageInteractionDefinition(
          response: CreatureDamageResponseType.resistance,
          damageTypes: {'contundente', 'perforante', 'tagliente'},
          condition: 'attacchi non magici',
          bypassedBy: {'magico'},
        ),
      ],
      communications: [
        CreatureCommunicationDefinition(
          type: CreatureCommunicationType.telepathy,
          value: 'telepatia',
          rangeMeters: 36,
        ),
      ],
      passivePerception: 15,
      challengeRating: 10,
      experiencePoints: 5900,
      proficiencyBonus: 4,
      legendaryActionUses: 3,
      legendaryActions: [
        CreatureActionDefinition(
          id: 'legendary_move',
          name: 'Movimento',
          type: CreatureActionType.legendaryAction,
          description: 'La creatura si muove.',
          legendaryActionCost: 1,
        ),
      ],
      lair: CreatureLairDefinition(
        description: 'Tana di prova.',
        initiativeCount: 20,
        actions: [
          CreatureActionDefinition(
            id: 'lair_effect',
            name: 'Effetto della Tana',
            type: CreatureActionType.lairAction,
            description: 'Effetto strutturale di prova.',
          ),
        ],
        regionalEffects: [
          CreatureRegionalEffectDefinition(
            id: 'regional_effect',
            name: 'Effetto Regionale',
            description: 'Effetto strutturale di prova.',
            radiusMeters: 1500,
          ),
        ],
      ),
      variants: [
        CreatureVariantDefinition(
          id: 'advanced_variant',
          name: 'Variante',
          description: 'Variante strutturale di prova.',
        ),
      ],
    );

    expect(creature.armorClasses, hasLength(2));
    expect(creature.hasLegendaryActions, isTrue);
    expect(creature.hasLair, isTrue);
    expect(creature.lair!.regionalEffects, hasLength(1));
    expect(creature.variants.single.id, 'advanced_variant');
  });

  test('spellcasting collects every referenced spell', () {
    const spellcasting = CreatureSpellcastingDefinition(
      ability: 'CAR',
      atWillSpellIds: {'detect_magic'},
      spellIdsByLevel: {
        1: {'charm_person'},
      },
      limitedUsesBySpellId: {
        'invisibility': 1,
      },
      innate: true,
      requiresComponents: false,
    );

    expect(
      spellcasting.allSpellIds,
      {'detect_magic', 'charm_person', 'invisibility'},
    );
  });

  test('registry supports incremental manual insertion', () {
    expect(
      phbBestiaryDefinitions.keys.toSet(),
      containsAll(phbBestiaryBeastDefinitions.keys),
    );
    expect(phbBestiaryDefinitions, hasLength(109));
    expect(
      phbBestiaryDefinitions.keys,
      containsAll(const {
        BestiaryCreatureIds.airElemental,
        BestiaryCreatureIds.earthElemental,
        BestiaryCreatureIds.fireElemental,
        BestiaryCreatureIds.waterElemental,
        BestiaryCreatureIds.monodrone,
        BestiaryCreatureIds.duodrone,
        BestiaryCreatureIds.tridrone,
        BestiaryCreatureIds.quadrone,
        BestiaryCreatureIds.pentadrone,
      }),
    );
  });

  test('all existing class references remain tracked', () {
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });
}
