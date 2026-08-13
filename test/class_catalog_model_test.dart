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
}
