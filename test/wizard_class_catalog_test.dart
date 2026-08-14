import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;

  test('Wizard is registered with its canonical PHB identity', () {
    expect(wizard.id, ClassIds.wizard);
    expect(wizard.name, 'Mago');
    expect(wizard.hitDie, 6);
    expect(wizard.subclassSelectionLevel, 2);
    expect(wizard.homebrew, isFalse);
    expect(phbClassDefinitions[ClassIds.wizard], same(wizard));
  });

  test('Wizard proficiencies match the PHB class', () {
    expect(wizard.proficiencies.armor, isEmpty);
    expect(wizard.proficiencies.tools, isEmpty);
    expect(
      wizard.proficiencies.weapons,
      {'dagger', 'dart', 'sling', 'quarterstaff', 'light_crossbow'},
    );
    expect(wizard.proficiencies.savingThrows, {'INT', 'SAG'});
    expect(wizard.proficiencies.skillChoices, 2);
    expect(
      wizard.proficiencies.skillOptions,
      {
        'arcana',
        'history',
        'insight',
        'investigation',
        'medicine',
        'religion',
      },
    );
  });

  test('Wizard starting equipment is complete and catalog-backed', () {
    expect(wizard.startingEquipmentChoices, hasLength(3));

    final packChoice = wizard.startingEquipmentChoices.singleWhere(
      (choice) => choice.alternatives.every(
        (alternative) =>
            alternative.grants.isNotEmpty &&
            alternative.grants.every(
              (grant) => grant.catalogId == 'equipment_pack',
            ),
      ),
    );

    expect(
      packChoice.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      {EquipmentPackIds.scholar, EquipmentPackIds.explorer},
    );

    final focusChoice = wizard.startingEquipmentChoices.singleWhere(
      (choice) => choice.alternatives.every(
        (alternative) =>
            alternative.grants.isNotEmpty &&
            alternative.grants.every((grant) => grant.catalogId == 'focus'),
      ),
    );

    final expectedFoci = focusDefinitions.values
        .where(
          (focus) =>
              focus.category == FocusCategory.arcane ||
              focus.category == FocusCategory.componentPouch,
        )
        .map((focus) => focus.id)
        .toSet();

    expect(
      focusChoice.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      expectedFoci,
    );

    expect(wizard.fixedStartingEquipment, hasLength(1));
    expect(wizard.fixedStartingEquipment.single.catalogId, 'equipment');
    expect(
      wizard.fixedStartingEquipment.single.itemId,
      EquipmentIds.spellbook,
    );
  });

  test('Wizard spellbook grants six initial spells and two per level', () {
    final spellbook = wizard.spellbook;

    expect(spellbook, isNotNull);
    expect(spellbook!.automaticSpellsAtLevel(1), 6);
    expect(spellbook.automaticSpellsAtLevel(2), 8);
    expect(spellbook.automaticSpellsAtLevel(10), 24);
    expect(spellbook.automaticSpellsAtLevel(20), 44);
  });

  test('Wizard uses complete Intelligence prepared spellcasting', () {
    final magic = wizard.spellcasting!;

    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'INT');
    expect(magic.minimumLevel, 1);
    expect(magic.preparesSpells, isTrue);
    expect(magic.ritualCasting, isTrue);
    expect(magic.preparedSpellLevelDivisor, 1);
    expect(magic.minimumPreparedSpells, 1);

    expect(
      magic.preparedSpellsAtLevel(
        1,
        abilityModifiers: const {'INT': 3},
      ),
      4,
    );
    expect(
      magic.preparedSpellsAtLevel(
        20,
        abilityModifiers: const {'INT': 5},
      ),
      25,
    );

    expect(magic.cantripsKnownAtLevel(1), 3);
    expect(magic.cantripsKnownAtLevel(4), 4);
    expect(magic.cantripsKnownAtLevel(10), 5);
    expect(magic.cantripsKnownAtLevel(20), 5);
  });

  test('Wizard has the complete full-caster slot progression', () {
    final magic = wizard.spellcasting!;

    expect(magic.slotsByClassLevel.keys.toSet(), {
      for (var level = 1; level <= 20; level++) level,
    });

    expect(magic.slotsAtLevel(1), [2]);
    expect(magic.slotsAtLevel(3), [4, 2]);
    expect(magic.slotsAtLevel(5), [4, 3, 2]);
    expect(magic.slotsAtLevel(9), [4, 3, 3, 3, 1]);
    expect(magic.slotsAtLevel(11), [4, 3, 3, 3, 2, 1]);
    expect(magic.slotsAtLevel(17), [4, 3, 3, 3, 2, 1, 1, 1, 1]);
    expect(magic.slotsAtLevel(18), [4, 3, 3, 3, 3, 1, 1, 1, 1]);
    expect(magic.slotsAtLevel(19), [4, 3, 3, 3, 3, 2, 1, 1, 1]);
    expect(magic.slotsAtLevel(20), [4, 3, 3, 3, 3, 2, 2, 1, 1]);
  });

  test('Wizard spell list comes from the canonical spell registry', () {
    final expected = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.wizard))
        .map((spell) => spell.id)
        .toSet();

    expect(expected, isNotEmpty);
    expect(wizard.spellcasting!.spellIds, expected);
    expect(expected.every(spellDefinitions.containsKey), isTrue);
  });

  test('Initial Wizard spell choices are structured', () {
    final choices =
        wizard.featureDefinitions[WizardFeatureIds.spellcasting]!.choices;
    final byId = {for (final choice in choices) choice.id: choice};

    final cantrips = byId[WizardChoiceIds.initialCantrips]!;
    expect(cantrips.catalogId, CharacterChoiceCatalogIds.spells);
    expect(cantrips.minimumSelections, 3);
    expect(cantrips.maximumSelections, 3);
    expect(cantrips.requireNewAcquisition, isTrue);

    final spellbook = byId[WizardChoiceIds.initialSpellbook]!;
    expect(spellbook.catalogId, CharacterChoiceCatalogIds.spells);
    expect(spellbook.minimumSelections, 6);
    expect(spellbook.maximumSelections, 6);
    expect(spellbook.requireNewAcquisition, isTrue);
  });

  test('Arcane Recovery is represented as resource and slot recovery', () {
    final resource = wizard.resources.singleWhere(
      (entry) => entry.id == WizardResourceIds.arcaneRecovery,
    );

    expect(resource.minimumLevel, 1);
    expect(resource.maximumAtLevel(1), 1);
    expect(resource.recoveryAtLevel(20), ClassResourceRecovery.dawn);

    expect(wizard.spellSlotRecoveries, hasLength(1));
    expect(
      wizard.spellSlotRecoveries.single.id,
      WizardResourceIds.arcaneRecovery,
    );
  });

  test('Spell Mastery and Signature Spells have persistent choices', () {
    final mastery = wizard.featureDefinitions[WizardFeatureIds.spellMastery]!;
    final signature =
        wizard.featureDefinitions[WizardFeatureIds.signatureSpells]!;

    expect(mastery.choices, hasLength(2));
    expect(
      mastery.choices.map((choice) => choice.id).toSet(),
      {
        WizardChoiceIds.spellMasteryFirstLevel,
        WizardChoiceIds.spellMasterySecondLevel,
      },
    );
    expect(
      mastery.choices.every(
        (choice) =>
            choice.catalogId == CharacterChoiceCatalogIds.spells &&
            choice.minimumSelections == 1 &&
            choice.maximumSelections == 1 &&
            choice.requireExistingAcquisition,
      ),
      isTrue,
    );

    expect(signature.choices, hasLength(1));
    expect(signature.choices.single.id, WizardChoiceIds.signatureSpells);
    expect(signature.choices.single.minimumSelections, 2);
    expect(signature.choices.single.maximumSelections, 2);
    expect(signature.choices.single.requireExistingAcquisition, isTrue);
    expect(signature.resourceId, WizardResourceIds.signatureSpells);

    final resource = wizard.resources.singleWhere(
      (entry) => entry.id == WizardResourceIds.signatureSpells,
    );
    expect(resource.minimumLevel, 20);
    expect(resource.maximumAtLevel(20), 2);
    expect(resource.recoveryAtLevel(20), ClassResourceRecovery.shortRest);
  });

  test('Every granted Wizard feature has a registered definition', () {
    final granted =
        wizard.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(wizard.featureDefinitions.keys.toSet()),
      isEmpty,
    );
    expect(wizard.featureDefinitions, hasLength(6));

    for (final entry in wizard.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.wizard);
      expect(entry.value.content.source.isEmpty, isFalse);
      expect(entry.value.ruleTags, contains('wizard'));
    }
  });

  test('Wizard base progression is ready for the eight PHB schools', () {
    expect(wizard.featuresAtLevel(1), {
      WizardFeatureIds.spellcasting,
      WizardFeatureIds.arcaneRecovery,
    });
    expect(
      wizard.featuresAtLevel(2),
      contains(WizardFeatureIds.arcaneTradition),
    );
    expect(
      wizard.featuresAtLevel(18),
      contains(WizardFeatureIds.spellMastery),
    );
    expect(
      wizard.featuresAtLevel(20),
      contains(WizardFeatureIds.signatureSpells),
    );
    expect(
      wizard.subclasses.keys.toSet(),
      {
        WizardSubclassIds.abjuration,
        WizardSubclassIds.conjuration,
        WizardSubclassIds.divination,
        WizardSubclassIds.enchantment,
        WizardSubclassIds.evocation,
        WizardSubclassIds.illusion,
        WizardSubclassIds.necromancy,
        WizardSubclassIds.transmutation,
      },
    );
  });
}
