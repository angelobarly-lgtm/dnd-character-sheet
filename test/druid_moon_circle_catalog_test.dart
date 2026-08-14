import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/druid_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final druid = phbClassDefinitions[ClassIds.druid]!;
  final circle = druidMoonCircleDefinition;

  test('Circle of the Moon is registered at Druid level 2', () {
    expect(druid.subclasses[DruidSubclassIds.moon], same(circle));
    expect(circle.classId, ClassIds.druid);
    expect(circle.homebrew, isFalse);
    expect(circle.supplemental, isFalse);
    expect(druid.subclassSelectionLevel, 2);
  });

  test('Circle of the Moon has the complete PHB progression', () {
    expect(
      circle.featuresByLevel,
      {
        2: ['combat_wild_shape', 'circle_forms'],
        6: ['primal_strike'],
        10: ['elemental_wild_shape'],
        14: ['thousand_forms'],
      },
    );

    final granted = circle.featuresByLevel.values.expand((ids) => ids).toSet();

    expect(circle.featureDefinitions.keys.toSet(), granted);

    for (final entry in circle.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, DruidSubclassIds.moon);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Moon Wild Shape overrides the base transformation', () {
    final base = druid.transformationFor('wild_shape')!;
    final moon = druid.transformationFor(
      'wild_shape',
      subclassId: DruidSubclassIds.moon,
    )!;

    expect(base.action, ClassTransformationAction.action);
    expect(moon.action, ClassTransformationAction.bonusAction);
    expect(base.maximumChallengeRatingAtLevel(2), 0.25);
    expect(moon.maximumChallengeRatingAtLevel(2), 1);

    expect(moon.maximumChallengeRatingAtLevel(5), 1);
    expect(moon.maximumChallengeRatingAtLevel(6), 2);
    expect(moon.maximumChallengeRatingAtLevel(9), 3);
    expect(moon.maximumChallengeRatingAtLevel(12), 4);
    expect(moon.maximumChallengeRatingAtLevel(15), 5);
    expect(moon.maximumChallengeRatingAtLevel(18), 6);
    expect(moon.maximumChallengeRatingAtLevel(20), 6);

    expect(moon.allowsSwimmingSpeedAtLevel(3), isFalse);
    expect(moon.allowsSwimmingSpeedAtLevel(4), isTrue);
    expect(moon.allowsFlyingSpeedAtLevel(7), isFalse);
    expect(moon.allowsFlyingSpeedAtLevel(8), isTrue);
  });

  test('Combat Wild Shape retains its healing rule', () {
    final feature = circle.featureDefinitions['combat_wild_shape']!;

    expect(feature.resourceId, 'wild_shape');
    expect(
      feature.ruleTags,
      containsAll({
        'bonus_action_transformation',
        'spell_slot_cost',
        'healing_1d8_per_slot_level',
      }),
    );
  });

  test('Primal Strike marks beast attacks as magical', () {
    expect(
      circle.featureDefinitions['primal_strike']!.ruleTags,
      containsAll({
        'magical_attacks',
        'overcome_nonmagical_resistance',
        'overcome_nonmagical_immunity',
      }),
    );
  });

  test('Elemental Wild Shape contains all four future bestiary IDs', () {
    final elemental = druid.transformationFor(
      'elemental_wild_shape',
      subclassId: DruidSubclassIds.moon,
    )!;

    expect(elemental.minimumLevel, 10);
    expect(elemental.resourceId, 'wild_shape');
    expect(elemental.resourceCost, 2);
    expect(elemental.action, ClassTransformationAction.bonusAction);
    expect(elemental.allowedCreatureTypes, {'elemental'});
    expect(
      elemental.fixedFormIds,
      {
        'air_elemental',
        'earth_elemental',
        'fire_elemental',
        'water_elemental',
      },
    );
  });

  test('Thousand Forms is linked to Alter Self at will', () {
    final feature = circle.featureDefinitions['thousand_forms']!;

    expect(feature.spellIds, {SpellIds.alterSelf});
    expect(
      feature.spellIds.every(spellDefinitions.containsKey),
      isTrue,
    );
    expect(
      feature.ruleTags,
      containsAll({'at_will_spell', 'spell_without_slot'}),
    );
  });

  test('Druid registry now contains exactly both PHB circles', () {
    expect(
      druid.subclasses.keys.toSet(),
      {
        DruidSubclassIds.land,
        DruidSubclassIds.moon,
      },
    );
  });
}
