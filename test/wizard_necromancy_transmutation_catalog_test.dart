import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;
  final necromancy = wizard.subclasses[WizardSubclassIds.necromancy]!;
  final transmutation = wizard.subclasses[WizardSubclassIds.transmutation]!;

  test('Necromancy and Transmutation are registered', () {
    expect(
      wizard.subclasses.keys,
      containsAll({
        WizardSubclassIds.necromancy,
        WizardSubclassIds.transmutation,
      }),
    );
    expect(necromancy.name, 'Scuola di Necromanzia');
    expect(transmutation.name, 'Scuola di Trasmutazione');
    expect(necromancy.classId, ClassIds.wizard);
    expect(transmutation.classId, ClassIds.wizard);
  });

  test('both schools have complete PHB progressions', () {
    for (final school in [necromancy, transmutation]) {
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

  test('both schools possess their Savant discounts', () {
    final adjustments = [
      necromancy.spellbookCopyAdjustments.single,
      transmutation.spellbookCopyAdjustments.single,
    ];

    expect(
      adjustments.map((entry) => entry.schoolId).toSet(),
      {'necromancy', 'transmutation'},
    );

    for (final adjustment in adjustments) {
      expect(
        adjustment.adjustedCopyHours(
          6,
          baseHoursPerSpellLevel: 2,
        ),
        6,
      );
      expect(
        adjustment.adjustedCopyCostGp(
          6,
          baseCostGpPerSpellLevel: 50,
        ),
        150,
      );
    }
  });

  test('Grim Harvest preserves healing and target restrictions', () {
    expect(
      necromancy
          .featureDefinitions[WizardNecromancyFeatureIds.grimHarvest]!.ruleTags,
      containsAll({
        'once_per_turn',
        'healing_twice_spell_level',
        'necromancy_healing_three_times_spell_level',
        'excludes_constructs',
        'excludes_undead',
      }),
    );
  });

  test('Undead Thralls links Animate Dead and its bonuses', () {
    final thralls = necromancy
        .featureDefinitions[WizardNecromancyFeatureIds.undeadThralls]!;

    expect(thralls.spellIds, {'animate_dead'});
    expect(
      thralls.ruleTags,
      containsAll({
        'additional_undead_target',
        'undead_hit_points_plus_wizard_level',
        'weapon_damage_plus_proficiency_bonus',
      }),
    );
  });

  test('Inured to Undeath grants structured necrotic resistance', () {
    final inured = necromancy
        .featureDefinitions[WizardNecromancyFeatureIds.inuredToUndeath]!;

    expect(inured.effects.damageResistances, {'necrotic'});
    expect(
      inured.ruleTags,
      contains('hit_point_maximum_cannot_be_reduced'),
    );
  });

  test('Command Undead retains intelligent-undead limitations', () {
    expect(
      necromancy.featureDefinitions[WizardNecromancyFeatureIds.commandUndead]!
          .ruleTags,
      containsAll({
        'range_18_meters',
        'charisma_saving_throw',
        'intelligence_8_advantage',
        'intelligence_12_repeat_save_hourly',
      }),
    );
  });

  test('Transmuter Stone exposes all eight selectable benefits', () {
    final feature = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.transmutersStone]!;
    final choice = feature.choices.single;

    expect(
      choice.id,
      WizardTransmutationChoiceIds.transmutersStoneBenefit,
    );
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.optionIds, hasLength(8));
    expect(
      choice.optionIds,
      containsAll({
        'darkvision_18_meters',
        'speed_bonus_3_meters',
        'constitution_saving_throw_proficiency',
        'acid_resistance',
        'cold_resistance',
        'fire_resistance',
        'lightning_resistance',
        'thunder_resistance',
      }),
    );
  });

  test('Shapechanger links Polymorph and recovers on a short rest', () {
    final feature = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.shapechanger]!;
    final resource = transmutation.resources.singleWhere(
      (entry) => entry.id == WizardTransmutationFeatureIds.shapechanger,
    );

    expect(feature.spellIds, {'polymorph'});
    expect(
      feature.ruleTags,
      containsAll({
        'self_only',
        'no_spell_slot',
        'beast_challenge_rating_1_or_lower',
      }),
    );
    expect(resource.minimumLevel, 10);
    expect(resource.maximumAtLevel(10), 1);
    expect(resource.recoveryAtLevel(20), ClassResourceRecovery.shortRest);
  });

  test('Master Transmuter exposes four effects and Restore Life', () {
    final feature = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.masterTransmuter]!;
    final resource = transmutation.resources.singleWhere(
      (entry) => entry.id == WizardTransmutationFeatureIds.masterTransmuter,
    );

    expect(feature.spellIds, {'raise_dead'});
    expect(feature.choices.single.optionIds, {
      'major_transformation',
      'panacea',
      'restore_life',
      'restore_youth',
    });
    expect(
      feature.ruleTags,
      containsAll({
        'consume_transmuters_stone',
        'raise_dead_without_spell_slot',
        'restore_youth_3d10_years',
        'does_not_extend_lifespan',
      }),
    );
    expect(resource.minimumLevel, 14);
    expect(resource.maximumAtLevel(14), 1);
    expect(resource.recoveryAtLevel(20), ClassResourceRecovery.longRest);
  });
}
