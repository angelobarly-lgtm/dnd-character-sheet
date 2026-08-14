import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;
  final evocation = wizard.subclasses[WizardSubclassIds.evocation]!;
  final illusion = wizard.subclasses[WizardSubclassIds.illusion]!;

  test('Evocation and Illusion are registered', () {
    expect(
      wizard.subclasses.keys,
      containsAll({
        WizardSubclassIds.evocation,
        WizardSubclassIds.illusion,
      }),
    );
    expect(evocation.name, 'Scuola di Invocazione');
    expect(illusion.name, 'Scuola di Illusione');
    expect(evocation.classId, ClassIds.wizard);
    expect(illusion.classId, ClassIds.wizard);
  });

  test('both schools have complete feature progressions', () {
    for (final school in [evocation, illusion]) {
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
        expect(entry.value.content.ownerId, ClassIds.wizard);
        expect(entry.value.content.source.isEmpty, isFalse);
        expect(entry.value.ruleTags, contains('wizard'));
        expect(entry.value.ruleTags, contains('arcane_tradition'));
      }
    }
  });

  test('both schools halve copying cost and time', () {
    final adjustments = [
      evocation.spellbookCopyAdjustments.single,
      illusion.spellbookCopyAdjustments.single,
    ];

    expect(
      adjustments.map((entry) => entry.schoolId).toSet(),
      {'evocation', 'illusion'},
    );

    for (final adjustment in adjustments) {
      expect(
        adjustment.adjustedCopyHours(
          5,
          baseHoursPerSpellLevel: 2,
        ),
        5,
      );
      expect(
        adjustment.adjustedCopyCostGp(
          5,
          baseCostGpPerSpellLevel: 50,
        ),
        125,
      );
    }
  });

  test('Sculpt Spells and Potent Cantrip preserve saving-throw rules', () {
    expect(
      evocation
          .featureDefinitions[WizardEvocationFeatureIds.sculptSpells]!.ruleTags,
      containsAll({
        'one_plus_spell_level_targets',
        'automatic_saving_throw_success',
        'no_damage_on_success',
      }),
    );
    expect(
      evocation.featureDefinitions[WizardEvocationFeatureIds.potentCantrip]!
          .ruleTags,
      containsAll({
        'half_damage_on_successful_save',
        'no_additional_effects_on_success',
      }),
    );
  });

  test('Overchannel tracks its safe use and repeated-use penalty', () {
    final overchannel = evocation.resources.single;

    expect(overchannel.id, WizardEvocationFeatureIds.overchannel);
    expect(overchannel.minimumLevel, 14);
    expect(overchannel.maximumAtLevel(13), 0);
    expect(overchannel.maximumAtLevel(14), 1);
    expect(
      overchannel.recoveryAtLevel(20),
      ClassResourceRecovery.longRest,
    );

    expect(
      evocation
          .featureDefinitions[WizardEvocationFeatureIds.overchannel]!.ruleTags,
      containsAll({
        'wizard_spell_levels_1_to_5',
        'first_use_safe',
        'additional_use_2d12_per_spell_level',
        'additional_d12_per_repeated_use',
        'ignores_resistance_and_immunity',
      }),
    );
  });

  test('Improved Minor Illusion has a persistent cantrip choice', () {
    final feature = illusion
        .featureDefinitions[WizardIllusionFeatureIds.improvedMinorIllusion]!;
    final choice = feature.choices.single;

    expect(
      choice.id,
      WizardIllusionChoiceIds.improvedMinorIllusionCantrip,
    );
    expect(choice.catalogId, CharacterChoiceCatalogIds.spells);
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.requireNewAcquisition, isTrue);
    expect(
      feature.ruleTags,
      containsAll({
        'minor_illusion',
        'fallback_wizard_cantrip_if_already_known',
        'sound_and_image',
      }),
    );
  });

  test('Illusory Self is a short-rest resource', () {
    final illusorySelf = illusion.resources.single;

    expect(
      illusorySelf.id,
      WizardIllusionFeatureIds.illusorySelf,
    );
    expect(illusorySelf.minimumLevel, 10);
    expect(illusorySelf.maximumAtLevel(9), 0);
    expect(illusorySelf.maximumAtLevel(10), 1);
    expect(
      illusorySelf.recoveryAtLevel(20),
      ClassResourceRecovery.shortRest,
    );
  });

  test('Malleable Illusions and Illusory Reality retain their limits', () {
    expect(
      illusion.featureDefinitions[WizardIllusionFeatureIds.malleableIllusions]!
          .ruleTags,
      containsAll({
        'illusion_duration_at_least_1_minute',
        'must_see_illusion',
        'modify_existing_illusion',
      }),
    );
    expect(
      illusion.featureDefinitions[WizardIllusionFeatureIds.illusoryReality]!
          .ruleTags,
      containsAll({
        'first_level_spell_or_higher',
        'bonus_action',
        'duration_1_minute',
        'cannot_deal_damage_or_directly_harm',
      }),
    );
  });
}
