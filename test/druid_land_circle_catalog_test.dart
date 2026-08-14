import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/druid_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final druid = phbClassDefinitions[ClassIds.druid]!;
  final circle = druidLandCircleDefinition;

  test('Circle of the Land is registered at Druid level 2', () {
    expect(druid.subclasses[DruidSubclassIds.land], same(circle));
    expect(circle.classId, ClassIds.druid);
    expect(circle.homebrew, isFalse);
    expect(circle.supplemental, isFalse);
    expect(druid.subclassSelectionLevel, 2);
  });

  test('Circle of the Land has the complete PHB progression', () {
    expect(
      circle.featuresByLevel,
      {
        2: ['bonus_cantrip_land', 'natural_recovery'],
        3: ['circle_spells_land'],
        6: ['lands_stride'],
        10: ['natures_ward'],
        14: ['natures_sanctuary'],
      },
    );

    final granted = circle.featuresByLevel.values.expand((ids) => ids).toSet();

    expect(circle.featureDefinitions.keys.toSet(), granted);

    for (final entry in circle.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, DruidSubclassIds.land);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('bonus cantrip is a structured Druid-cantrip choice', () {
    final feature = circle.featureDefinitions['bonus_cantrip_land']!;
    final choice = feature.choices.single;

    expect(choice.id, 'land_circle_bonus_cantrip');
    expect(choice.type, CharacterChoiceType.cantrip);
    expect(choice.requireNewAcquisition, isTrue);
    expect(choice.optionIds, hasLength(8));

    expect(
      choice.optionIds.every(
        (id) =>
            spellDefinitions[id]!.level == 0 &&
            spellDefinitions[id]!.classIds.contains(ClassIds.druid),
      ),
      isTrue,
    );
  });

  test('Natural Recovery has a long-rest use and slot formula', () {
    final resource = circle.resources.single;
    final recovery = circle.spellSlotRecoveries.single;

    expect(resource.id, 'natural_recovery');
    expect(resource.maximumAtLevel(1), 0);
    expect(resource.maximumAtLevel(2), 1);
    expect(resource.maximumAtLevel(20), 1);
    expect(resource.recovery, ClassResourceRecovery.longRest);

    expect(recovery.resourceId, resource.id);
    expect(recovery.requiresShortRest, isTrue);
    expect(recovery.maximumSlotLevel, 5);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(1), 0);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(2), 1);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(3), 2);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(10), 5);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(20), 10);
    expect(recovery.canRecoverSlotLevel(5), isTrue);
    expect(recovery.canRecoverSlotLevel(6), isFalse);
  });

  test('all eight PHB land types are selectable exactly once', () {
    expect(circle.options, hasLength(8));
    expect(
      circle.options.map((option) => option.id).toSet(),
      {
        DruidLandIds.arctic,
        DruidLandIds.coast,
        DruidLandIds.desert,
        DruidLandIds.forest,
        DruidLandIds.grassland,
        DruidLandIds.mountain,
        DruidLandIds.swamp,
        DruidLandIds.underdark,
      },
    );

    expect(
      circle.options.every(
        (option) =>
            option.category == 'circle_land_type' &&
            option.minimumLevel == 2 &&
            option.source.isNotEmpty &&
            option.sourceRef.isNotEmpty,
      ),
      isTrue,
    );

    expect(circle.optionProgression!.selectionsAtLevel(1), 0);
    expect(circle.optionProgression!.selectionsAtLevel(2), 1);
    expect(circle.optionProgression!.selectionsAtLevel(20), 1);
  });

  test('the eight land tables contain 64 canonical spell entries', () {
    var tableEntries = 0;

    for (final land in circle.options) {
      expect(
        land.alwaysPreparedSpellIdsByLevel.keys.toSet(),
        {3, 5, 7, 9},
        reason: land.id,
      );

      for (final entry in land.alwaysPreparedSpellIdsByLevel.entries) {
        expect(
          entry.value,
          hasLength(2),
          reason: '${land.id}, livello ${entry.key}',
        );

        for (final spellId in entry.value) {
          expect(
            spellDefinitions.containsKey(spellId),
            isTrue,
            reason: '${land.id}: $spellId',
          );
        }

        tableEntries += entry.value.length;
      }

      expect(land.alwaysPreparedSpellIdsAtLevel(2), isEmpty);
      expect(land.alwaysPreparedSpellIdsAtLevel(3), hasLength(2));
      expect(land.alwaysPreparedSpellIdsAtLevel(5), hasLength(4));
      expect(land.alwaysPreparedSpellIdsAtLevel(7), hasLength(6));
      expect(land.alwaysPreparedSpellIdsAtLevel(9), hasLength(8));
      expect(land.alwaysPreparedSpellIdsAtLevel(20), hasLength(8));
    }

    expect(tableEntries, 64);
  });

  test('Arctic and Underdark tables match their PHB snapshots', () {
    final lands = {
      for (final option in circle.options) option.id: option,
    };

    expect(
      lands[DruidLandIds.arctic]!.alwaysPreparedSpellIdsByLevel,
      {
        3: {SpellIds.holdPerson, SpellIds.spikeGrowth},
        5: {SpellIds.sleetStorm, SpellIds.slow},
        7: {SpellIds.freedomOfMovement, SpellIds.iceStorm},
        9: {SpellIds.communeWithNature, SpellIds.coneOfCold},
      },
    );

    expect(
      lands[DruidLandIds.underdark]!.alwaysPreparedSpellIdsByLevel,
      {
        3: {SpellIds.spiderClimb, SpellIds.web},
        5: {SpellIds.gaseousForm, SpellIds.stinkingCloud},
        7: {SpellIds.greaterInvisibility, SpellIds.stoneShape},
        9: {SpellIds.cloudkill, SpellIds.insectPlague},
      },
    );
  });

  test('Land defensive features remain machine-readable', () {
    final ward = circle.featureDefinitions['natures_ward']!;

    expect(
      ward.effects.conditionImmunities,
      {'poisoned', 'disease'},
    );
    expect(
      ward.ruleTags,
      containsAll({
        'poison_immunity',
        'disease_immunity',
        'fey_charm_immunity',
        'elemental_fear_immunity',
      }),
    );

    expect(
      circle.featureDefinitions['lands_stride']!.ruleTags,
      contains('ignore_nonmagical_difficult_terrain'),
    );
    expect(
      circle.featureDefinitions['natures_sanctuary']!.ruleTags,
      contains('success_immunity_24_hours'),
    );
  });
}
