import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;
  final divination = wizard.subclasses[WizardSubclassIds.divination]!;
  final enchantment = wizard.subclasses[WizardSubclassIds.enchantment]!;

  test('Divination and Enchantment are registered', () {
    expect(
      wizard.subclasses.keys,
      containsAll({
        WizardSubclassIds.divination,
        WizardSubclassIds.enchantment,
      }),
    );
    expect(divination.name, 'Scuola di Divinazione');
    expect(enchantment.name, 'Scuola di Ammaliamento');
    expect(divination.classId, ClassIds.wizard);
    expect(enchantment.classId, ClassIds.wizard);
  });

  test('both schools have complete feature progressions', () {
    for (final school in [divination, enchantment]) {
      expect(school.featuresByLevel.keys.toSet(), {2, 6, 10, 14});

      final granted =
          school.featuresByLevel.values.expand((features) => features).toSet();

      expect(granted, hasLength(5));
      expect(
        granted.difference(school.featureDefinitions.keys.toSet()),
        isEmpty,
      );

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

  test('both schools possess their structured Savant discount', () {
    final adjustments = [
      divination.spellbookCopyAdjustments.single,
      enchantment.spellbookCopyAdjustments.single,
    ];

    expect(
      adjustments.map((entry) => entry.schoolId).toSet(),
      {'divination', 'enchantment'},
    );

    for (final adjustment in adjustments) {
      expect(
        adjustment.adjustedCopyHours(
          2,
          baseHoursPerSpellLevel: 2,
        ),
        2,
      );
      expect(
        adjustment.adjustedCopyCostGp(
          2,
          baseCostGpPerSpellLevel: 50,
        ),
        50,
      );
    }
  });

  test('Portent increases from two to three stored d20 rolls', () {
    final portent = divination.resources.singleWhere(
      (resource) => resource.id == WizardDivinationFeatureIds.portent,
    );

    expect(portent.minimumLevel, 2);
    expect(portent.maximumAtLevel(1), 0);
    expect(portent.maximumAtLevel(2), 2);
    expect(portent.maximumAtLevel(13), 2);
    expect(portent.maximumAtLevel(14), 3);
    expect(portent.maximumAtLevel(20), 3);
    expect(portent.recoveryAtLevel(20), ClassResourceRecovery.longRest);

    expect(
      divination.featureDefinitions[WizardDivinationFeatureIds.greaterPortent]!
          .resourceId,
      WizardDivinationFeatureIds.portent,
    );
  });

  test('Expert Divination preserves the recovered-slot restrictions', () {
    expect(
      divination
          .featureDefinitions[WizardDivinationFeatureIds.expertDivination]!
          .ruleTags,
      containsAll({
        'trigger_divination_spell',
        'lower_slot_than_cast',
        'maximum_recovered_slot_level_5',
      }),
    );
  });

  test('The Third Eye is tracked and exposes all four benefits', () {
    final thirdEye = divination.resources.singleWhere(
      (resource) => resource.id == WizardDivinationFeatureIds.thirdEye,
    );

    expect(thirdEye.minimumLevel, 10);
    expect(thirdEye.maximumAtLevel(9), 0);
    expect(thirdEye.maximumAtLevel(10), 1);
    expect(thirdEye.recoveryAtLevel(20), ClassResourceRecovery.shortRest);

    expect(
      divination
          .featureDefinitions[WizardDivinationFeatureIds.thirdEye]!.ruleTags,
      containsAll({
        'darkvision_18_meters',
        'ethereal_sight_18_meters',
        'read_any_language',
        'see_invisibility_3_meters',
      }),
    );
  });

  test('Enchantment keeps its per-target immunities', () {
    expect(
      enchantment.featureDefinitions[WizardEnchantmentFeatureIds.hypnoticGaze]!
          .ruleTags,
      containsAll({
        'charmed',
        'incapacitated',
        'speed_zero',
        'per_target_long_rest_immunity',
      }),
    );
    expect(
      enchantment
          .featureDefinitions[WizardEnchantmentFeatureIds.instinctiveCharm]!
          .ruleTags,
      containsAll({
        'reaction',
        'redirect_attack',
        'per_target_long_rest_immunity',
      }),
    );
  });

  test('Split Enchantment and Alter Memories retain their limits', () {
    expect(
      enchantment
          .featureDefinitions[WizardEnchantmentFeatureIds.splitEnchantment]!
          .ruleTags,
      containsAll({
        'first_level_spell_or_higher',
        'single_target_spell',
        'additional_target',
      }),
    );
    expect(
      enchantment.featureDefinitions[WizardEnchantmentFeatureIds.alterMemories]!
          .ruleTags,
      containsAll({
        'charmed_target_unaware',
        'charisma_saving_throw',
        'erase_memories',
        'minimum_1_hour',
      }),
    );
  });
}
