import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;
  final abjuration = wizard.subclasses[WizardSubclassIds.abjuration]!;
  final conjuration = wizard.subclasses[WizardSubclassIds.conjuration]!;

  test('Abjuration and Conjuration are registered', () {
    expect(
      wizard.subclasses.keys,
      containsAll({
        WizardSubclassIds.abjuration,
        WizardSubclassIds.conjuration,
      }),
    );

    expect(abjuration.name, 'Scuola di Abiurazione');
    expect(conjuration.name, 'Scuola di Evocazione');
    expect(abjuration.classId, ClassIds.wizard);
    expect(conjuration.classId, ClassIds.wizard);
    expect(abjuration.homebrew, isFalse);
    expect(conjuration.homebrew, isFalse);
  });

  test('both schools have complete PHB feature levels', () {
    for (final school in [abjuration, conjuration]) {
      expect(school.featuresByLevel.keys.toSet(), {2, 6, 10, 14});

      final granted =
          school.featuresByLevel.values.expand((features) => features).toSet();

      expect(granted, hasLength(5));
      expect(
        granted.difference(school.featureDefinitions.keys.toSet()),
        isEmpty,
      );
      expect(school.featureDefinitions, hasLength(5));

      for (final entry in school.featureDefinitions.entries) {
        expect(entry.value.id, entry.key);
        expect(entry.value.content.id, entry.key);
        expect(entry.value.content.ownerId, ClassIds.wizard);
        expect(entry.value.content.source.isEmpty, isFalse);
        expect(entry.value.ruleTags, contains('wizard'));
        expect(entry.value.ruleTags, contains('arcane_tradition'));
      }
    }
  });

  test('both Savant features halve spellbook copying cost and time', () {
    final adjustments = [
      abjuration.spellbookCopyAdjustments.single,
      conjuration.spellbookCopyAdjustments.single,
    ];

    expect(
      adjustments.map((entry) => entry.schoolId).toSet(),
      {'abjuration', 'conjuration'},
    );

    for (final adjustment in adjustments) {
      expect(
        adjustment.adjustedCopyHours(
          4,
          baseHoursPerSpellLevel: 2,
        ),
        4,
      );
      expect(
        adjustment.adjustedCopyCostGp(
          4,
          baseCostGpPerSpellLevel: 50,
        ),
        100,
      );
    }
  });

  test('Arcane Ward uses Wizard level and Intelligence', () {
    final ward = abjuration.resources.single;

    expect(ward.id, WizardAbjurationFeatureIds.arcaneWard);
    expect(ward.minimumLevel, 2);
    expect(ward.recoveryAtLevel(20), ClassResourceRecovery.longRest);

    expect(
      ward.maximumAtLevel(
        2,
        abilityModifiers: const {'INT': 3},
      ),
      7,
    );
    expect(
      ward.maximumAtLevel(
        10,
        abilityModifiers: const {'INT': 4},
      ),
      24,
    );
    expect(
      ward.maximumAtLevel(
        20,
        abilityModifiers: const {'INT': 5},
      ),
      45,
    );

    expect(
      abjuration.featureDefinitions[WizardAbjurationFeatureIds.projectedWard]!
          .resourceId,
      WizardAbjurationFeatureIds.arcaneWard,
    );
  });

  test('Abjuration final features preserve conditional rules', () {
    expect(
      abjuration
          .featureDefinitions[WizardAbjurationFeatureIds.improvedAbjuration]!
          .ruleTags,
      containsAll({'counterspell', 'dispel_magic', 'proficiency_bonus'}),
    );
    expect(
      abjuration.featureDefinitions[WizardAbjurationFeatureIds.spellResistance]!
          .ruleTags,
      containsAll({
        'advantage_saving_throws_against_spells',
        'resistance_to_spell_damage',
      }),
    );
  });

  test('Benign Transposition is a tracked rechargeable resource', () {
    final transposition = conjuration.resources.single;

    expect(
      transposition.id,
      WizardConjurationFeatureIds.benignTransposition,
    );
    expect(transposition.minimumLevel, 6);
    expect(transposition.maximumAtLevel(5), 0);
    expect(transposition.maximumAtLevel(6), 1);
    expect(
      transposition.recoveryAtLevel(20),
      ClassResourceRecovery.longRest,
    );

    expect(
      conjuration
          .featureDefinitions[WizardConjurationFeatureIds.benignTransposition]!
          .ruleTags,
      contains('recharged_by_conjuration_spell'),
    );
  });

  test('Conjuration preserves its object, focus and summon rules', () {
    expect(
      conjuration
          .featureDefinitions[WizardConjurationFeatureIds.minorConjuration]!
          .ruleTags,
      containsAll({
        'temporary_object',
        'maximum_weight_5_kg',
        'duration_1_hour',
      }),
    );
    expect(
      conjuration
          .featureDefinitions[WizardConjurationFeatureIds.focusedConjuration]!
          .ruleTags,
      contains('concentration_not_broken_by_damage'),
    );
    expect(
      conjuration
          .featureDefinitions[WizardConjurationFeatureIds.durableSummons]!
          .ruleTags,
      contains('temporary_hit_points_30'),
    );
  });
}
