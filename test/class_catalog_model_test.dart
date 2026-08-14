import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/data/class_data.dart';
import 'package:flutter_test/flutter_test.dart';

RuleContent testContent(String id, String name) => RuleContent(
      id: id,
      name: name,
      type: RuleContentType.classFeature,
      description: const RuleDescription(summary: 'Contenuto di prova.'),
      source: const RuleSource(name: 'Manuale del Giocatore 2014'),
      ownerId: 'test',
    );

void main() {
  test('the 12 canonical PHB class ids are unique and complete', () {
    expect(phbClassIds.length, 12);
    expect(phbClassIds, {
      ClassIds.barbarian,
      ClassIds.bard,
      ClassIds.cleric,
      ClassIds.druid,
      ClassIds.fighter,
      ClassIds.monk,
      ClassIds.paladin,
      ClassIds.ranger,
      ClassIds.rogue,
      ClassIds.sorcerer,
      ClassIds.warlock,
      ClassIds.wizard,
    });
  });

  test('class resources resolve their progressive maximum', () {
    const resource = ClassResourceDefinition(
      id: 'test_resource',
      name: 'Risorsa',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.shortRest,
      maximumByLevel: {
        2: 2,
        3: 3,
        5: 5,
        20: 20,
      },
    );

    expect(resource.maximumAtLevel(1), 0);
    expect(resource.maximumAtLevel(2), 2);
    expect(resource.maximumAtLevel(4), 3);
    expect(resource.maximumAtLevel(17), 5);
    expect(resource.maximumAtLevel(20), 20);
  });

  test('starting-equipment alternatives can grant item groups', () {
    const choice = ClassEquipmentChoice(
      id: 'armor_choice',
      label: 'Scegli la dotazione',
      alternatives: [
        ClassEquipmentAlternative(
          id: 'light_package',
          label: 'Dotazione leggera',
          grants: [
            ClassEquipmentGrant(
              catalogId: 'armor',
              itemId: 'leather',
            ),
            ClassEquipmentGrant(
              catalogId: 'weapon',
              itemId: 'longbow',
            ),
            ClassEquipmentGrant(
              catalogId: 'ammunition',
              itemId: 'arrows',
              quantity: 20,
            ),
          ],
        ),
      ],
    );

    expect(choice.alternatives.single.grants.length, 3);
    expect(choice.alternatives.single.grants.last.quantity, 20);
  });

  test('spellcasting progression resolves known spells and pact slots', () {
    const spellcasting = ClassSpellcastingDefinition(
      progression: ClassSpellcastingProgression.pact,
      ability: 'CAR',
      minimumLevel: 1,
      cantripsKnownByLevel: {
        1: 2,
        4: 3,
        10: 4,
      },
      spellsKnownByLevel: {
        1: 2,
        2: 3,
        3: 4,
      },
      pactSlotLevelByClassLevel: {
        1: 1,
        3: 2,
        5: 3,
        7: 4,
        9: 5,
      },
    );

    expect(spellcasting.cantripsKnownAtLevel(8), 3);
    expect(spellcasting.spellsKnownAtLevel(3), 4);
    expect(spellcasting.pactSlotLevelAtLevel(8), 4);
  });

  test('class definitions separate PHB and supplemental subclasses', () {
    final phbSubclass = CharacterSubclassDefinition(
      id: 'phb_subclass',
      name: 'Sottoclasse PHB',
      classId: ClassIds.monk,
      content: testContent('phb_subclass', 'Sottoclasse PHB'),
      featuresByLevel: const {},
      featureDefinitions: const {},
    );

    final supplementalSubclass = CharacterSubclassDefinition(
      id: 'supplemental_subclass',
      name: 'Sottoclasse supplementare',
      classId: ClassIds.monk,
      content: testContent(
        'supplemental_subclass',
        'Sottoclasse supplementare',
      ),
      featuresByLevel: const {},
      featureDefinitions: const {},
      supplemental: true,
    );

    final definition = CharacterClassDefinition(
      id: ClassIds.monk,
      name: 'Monaco',
      content: testContent(ClassIds.monk, 'Monaco'),
      hitDie: 8,
      proficiencies: const ClassProficiencyDefinition(
        savingThrows: {'FOR', 'DES'},
        skillOptions: {'Acrobazia', 'Atletica'},
        skillChoices: 2,
      ),
      featuresByLevel: const {
        1: ['martial_arts'],
      },
      featureDefinitions: const {},
      subclassSelectionLevel: 3,
      subclasses: {
        phbSubclass.id: phbSubclass,
        supplementalSubclass.id: supplementalSubclass,
      },
    );

    expect(definition.featuresAtLevel(1), ['martial_arts']);
    expect(definition.phbSubclasses.length, 1);
    expect(definition.supplementalSubclasses.length, 1);
  });
  test('generic proficiency choices support skills and tools', () {
    const proficiencies = ClassProficiencyDefinition(
      choices: [
        ClassProficiencyChoiceDefinition(
          id: 'skill_choice',
          label: 'Scegli due abilità',
          type: ClassProficiencyChoiceType.skill,
          optionIds: {'acrobatics', 'athletics', 'stealth'},
          selections: 2,
        ),
        ClassProficiencyChoiceDefinition(
          id: 'tool_choice',
          label: 'Scegli uno strumento',
          type: ClassProficiencyChoiceType.tool,
          optionIds: {'flute', 'smiths_tools'},
          selections: 1,
        ),
      ],
    );

    expect(proficiencies.choices.length, 2);
    expect(proficiencies.choices.first.selections, 2);
    expect(
      proficiencies.choices.last.type,
      ClassProficiencyChoiceType.tool,
    );
  });

  test('progression values support dice and metric bonuses', () {
    const martialArts = ClassProgressionValueDefinition(
      id: 'martial_arts_die',
      name: 'Dado delle Arti Marziali',
      valuesByLevel: {
        1: 'd4',
        5: 'd6',
        11: 'd8',
        17: 'd10',
      },
    );

    const movement = ClassProgressionValueDefinition(
      id: 'unarmored_movement_bonus',
      name: 'Movimento Senza Armatura',
      valuesByLevel: {
        2: '3 m',
        6: '4.5 m',
        10: '6 m',
        14: '7.5 m',
        18: '9 m',
      },
    );

    expect(martialArts.valueAtLevel(4), 'd4');
    expect(martialArts.valueAtLevel(17), 'd10');
    expect(movement.valueAtLevel(1), isNull);
    expect(movement.valueAtLevel(15), '7.5 m');
  });

  test('subclasses support internal selectable options', () {
    final subclass = CharacterSubclassDefinition(
      id: 'four_elements',
      name: 'Via dei Quattro Elementi',
      classId: ClassIds.monk,
      content: testContent(
        'four_elements',
        'Via dei Quattro Elementi',
      ),
      featuresByLevel: const {},
      featureDefinitions: const {},
      options: const [
        SubclassOptionDefinition(
          id: 'elemental_attunement',
          name: 'Sintonia Elementale',
          category: 'elemental_discipline',
          description: RuleDescription(
            summary: 'Disciplina elementale.',
          ),
          minimumLevel: 3,
          source: 'Manuale del Giocatore',
          sourceRef: 'PHB',
        ),
      ],
      optionProgression: const SubclassOptionProgression(
        selectionsByLevel: {
          3: 1,
          6: 2,
          11: 3,
          17: 4,
        },
        replacementLevels: {6, 11, 17},
      ),
    );

    expect(subclass.options.length, 1);
    expect(subclass.optionProgression!.selectionsAtLevel(11), 3);
    expect(subclass.optionProgression!.canReplaceAtLevel(17), isTrue);
  });

  test('class resources can become unlimited at a verified level', () {
    const resource = ClassResourceDefinition(
      id: 'rage',
      name: 'Ira',
      minimumLevel: 1,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {
        1: 2,
        17: 6,
      },
      unlimitedFromLevel: 20,
    );

    expect(resource.maximumAtLevel(19), 6);
    expect(resource.maximumAtLevel(20), 6);
    expect(resource.isUnlimitedAtLevel(19), isFalse);
    expect(resource.isUnlimitedAtLevel(20), isTrue);
  });

  test('resources can depend on an ability and change recovery', () {
    const resource = ClassResourceDefinition(
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
    );

    expect(resource.maximumAtLevel(0), 0);
    expect(resource.maximumAtLevel(1), 1);
    expect(
      resource.maximumAtLevel(
        1,
        abilityModifiers: {'CAR': 4},
      ),
      4,
    );
    expect(
      resource.maximumAtLevel(
        1,
        abilityModifiers: {'CAR': 0},
      ),
      1,
    );
    expect(
      resource.recoveryAtLevel(4),
      ClassResourceRecovery.longRest,
    );
    expect(
      resource.recoveryAtLevel(5),
      ClassResourceRecovery.shortRest,
    );
  });

  test('class features support structured choices', () {
    const feature = CharacterClassFeatureDefinition(
      id: 'expertise',
      content: RuleContent(
        id: 'expertise',
        name: 'Maestria',
        type: RuleContentType.classFeature,
        description: RuleDescription(
          summary: 'Sceglie competenze possedute.',
        ),
      ),
      choices: [
        CharacterChoiceDefinition(
          id: 'expertise_skills',
          label: 'Scegli due competenze',
          type: CharacterChoiceType.skill,
          minimumSelections: 2,
          maximumSelections: 2,
          requireExistingAcquisition: true,
        ),
      ],
    );

    expect(feature.choices, hasLength(1));
    expect(
      feature.choices.single.requireExistingAcquisition,
      isTrue,
    );
  });

  test('class features support permanent structured effects', () {
    const feature = CharacterClassFeatureDefinition(
      id: 'bonus_proficiencies',
      content: RuleContent(
        id: 'bonus_proficiencies',
        name: 'Competenze Bonus',
        type: RuleContentType.subclassFeature,
        description: RuleDescription(
          summary: 'Concede competenze permanenti.',
        ),
      ),
      effects: CharacterEffects(
        armorProficiencies: {
          'medium_armor',
          'shield',
        },
        weaponProficiencies: {
          'martial_weapons',
        },
      ),
    );

    expect(
      feature.effects.armorProficiencies,
      {
        'medium_armor',
        'shield',
      },
    );
    expect(
      feature.effects.weaponProficiencies,
      {
        'martial_weapons',
      },
    );
  });

  test('equipment alternatives support proficiency requirements', () {
    const alternative = ClassEquipmentAlternative(
      id: 'warhammer',
      label: 'Martello da Guerra',
      grants: [
        ClassEquipmentGrant(
          catalogId: 'weapon',
          itemId: 'warhammer',
        ),
      ],
      requiredProficiencyIds: {
        'martial_weapons',
      },
    );

    expect(
      alternative.requiredProficiencyIds,
      {'martial_weapons'},
    );
  });

  test('prepared spellcasting supports ability-based formulas', () {
    const spellcasting = ClassSpellcastingDefinition(
      progression: ClassSpellcastingProgression.full,
      ability: 'SAG',
      minimumLevel: 1,
      preparesSpells: true,
      preparedSpellLevelDivisor: 1,
    );

    expect(spellcasting.preparedSpellsAtLevel(0), 0);
    expect(
      spellcasting.preparedSpellsAtLevel(
        1,
        abilityModifiers: {'SAG': 3},
      ),
      4,
    );
    expect(
      spellcasting.preparedSpellsAtLevel(
        10,
        abilityModifiers: {'SAG': 5},
      ),
      15,
    );
    expect(
      spellcasting.preparedSpellsAtLevel(
        1,
        abilityModifiers: {'SAG': -2},
      ),
      1,
    );
  });

  test('ClassSpellbookDefinition tracks automatic and copied spells', () {
    const spellbook = ClassSpellbookDefinition(
      catalogId: 'equipment',
      itemId: 'spellbook',
      initialSpells: 6,
      spellsLearnedPerLevel: 2,
      copyTimeHoursPerSpellLevel: 2,
      copyCostGpPerSpellLevel: 50,
      backupCopyTimeHoursPerSpellLevel: 1,
      backupCopyCostGpPerSpellLevel: 10,
    );

    expect(spellbook.automaticSpellsAtLevel(0), 0);
    expect(spellbook.automaticSpellsAtLevel(1), 6);
    expect(spellbook.automaticSpellsAtLevel(2), 8);
    expect(spellbook.automaticSpellsAtLevel(20), 44);

    expect(spellbook.copyTimeHours(3), 6);
    expect(spellbook.copyCostGp(3), 150);
    expect(
      spellbook.copyTimeHours(3, ownNotation: true),
      3,
    );
    expect(
      spellbook.copyCostGp(3, ownNotation: true),
      30,
    );
    expect(spellbook.ritualSpellsNeedPreparation, isFalse);
  });
  test('class resources support level plus ability formulas', () {
    const resource = ClassResourceDefinition(
      id: 'arcane_ward',
      name: 'Interdizione Arcana',
      minimumLevel: 2,
      recovery: ClassResourceRecovery.longRest,
      maximumByLevel: {},
      classLevelMultiplier: 2,
      additionalMaximumAbility: 'INT',
    );

    expect(
      resource.maximumAtLevel(
        1,
        abilityModifiers: const {'INT': 3},
      ),
      0,
    );
    expect(
      resource.maximumAtLevel(
        2,
        abilityModifiers: const {'INT': 3},
      ),
      7,
    );
    expect(
      resource.maximumAtLevel(
        20,
        abilityModifiers: const {'INT': 5},
      ),
      45,
    );
  });

  test('spellbook copying adjustments support school discounts', () {
    const adjustment = ClassSpellbookCopyAdjustmentDefinition(
      id: 'abjuration_savant',
      schoolId: 'abjuration',
      timeNumerator: 1,
      timeDenominator: 2,
      costNumerator: 1,
      costDenominator: 2,
    );

    expect(
      adjustment.adjustedCopyHours(
        3,
        baseHoursPerSpellLevel: 2,
      ),
      3,
    );
    expect(
      adjustment.adjustedCopyCostGp(
        3,
        baseCostGpPerSpellLevel: 50,
      ),
      75,
    );
  });
}
