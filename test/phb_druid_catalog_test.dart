import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/druid_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final druid = phbClassDefinitions[ClassIds.druid]!;

  test('PHB Druid is registered with the complete base structure', () {
    expect(druid, same(druidClassDefinition));
    expect(druid.id, ClassIds.druid);
    expect(druid.name, 'Druido');
    expect(druid.hitDie, 8);
    expect(druid.subclassSelectionLevel, 2);
    expect(druid.homebrew, isFalse);

    expect(druid.spellcasting, isNotNull);
    expect(druid.spellcasting!.ability, 'SAG');
    expect(druid.spellcasting!.spellIds, hasLength(110));
    expect(
      druid.spellcasting!.spellIds.every(spellDefinitions.containsKey),
      isTrue,
    );
  });

  test('all base Druid features are registered coherently', () {
    final granted = druid.featuresByLevel.values.expand((ids) => ids).toSet();

    expect(granted, druid.featureDefinitions.keys.toSet());

    for (final entry in druid.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.druid);
      expect(entry.value.content.source.isEmpty, isFalse);
    }

    expect(
      druid.featuresAtLevel(18),
      containsAll({'timeless_body', 'beast_spells'}),
    );
    expect(druid.featuresAtLevel(20), ['archdruid']);
  });

  test('the two PHB Druid Circles are registered exactly once', () {
    expect(
      druid.subclasses.keys.toSet(),
      {
        DruidSubclassIds.land,
        DruidSubclassIds.moon,
      },
    );

    expect(
      {
        for (final circle in druid.subclasses.values) circle.id: circle.name,
      },
      {
        DruidSubclassIds.land: 'Circolo della Terra',
        DruidSubclassIds.moon: 'Circolo della Luna',
      },
    );

    for (final circle in druid.subclasses.values) {
      expect(circle.classId, ClassIds.druid);
      expect(circle.homebrew, isFalse);
      expect(circle.supplemental, isFalse);
      expect(circle.content.ownerId, ClassIds.druid);
      expect(circle.content.source.isEmpty, isFalse);
    }
  });

  test('all circle features have definitions and stable ownership', () {
    for (final circle in druid.subclasses.values) {
      final granted =
          circle.featuresByLevel.values.expand((ids) => ids).toList();

      expect(granted.toSet().length, granted.length, reason: circle.id);
      expect(
        circle.featureDefinitions.keys.toSet(),
        granted.toSet(),
        reason: circle.id,
      );

      for (final entry in circle.featureDefinitions.entries) {
        expect(entry.value.id, entry.key, reason: circle.id);
        expect(entry.value.content.id, entry.key, reason: circle.id);
        expect(
          entry.value.content.ownerId,
          circle.id,
          reason: '${circle.id}: ${entry.key}',
        );
        expect(entry.value.content.source.isEmpty, isFalse);
      }
    }
  });

  test('Circle of the Land contains all eight PHB environments', () {
    final land = druidLandCircleDefinition;

    expect(land.options, hasLength(8));
    expect(
      land.options.map((option) => option.id).toSet(),
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

    expect(land.optionProgression!.selectionsAtLevel(1), 0);
    expect(land.optionProgression!.selectionsAtLevel(2), 1);
    expect(land.optionProgression!.selectionsAtLevel(20), 1);
  });

  test('all 64 Circle of the Land spell-table entries are canonical', () {
    var entries = 0;

    for (final environment in druidLandCircleDefinition.options) {
      expect(
        environment.alwaysPreparedSpellIdsByLevel.keys.toSet(),
        {3, 5, 7, 9},
        reason: environment.id,
      );

      for (final levelEntry
          in environment.alwaysPreparedSpellIdsByLevel.entries) {
        expect(levelEntry.value, hasLength(2), reason: environment.id);

        for (final spellId in levelEntry.value) {
          expect(
            spellDefinitions.containsKey(spellId),
            isTrue,
            reason: '${environment.id}: $spellId',
          );
        }

        entries += levelEntry.value.length;
      }

      expect(
        environment.alwaysPreparedSpellIdsAtLevel(9),
        hasLength(8),
        reason: environment.id,
      );
    }

    expect(entries, 64);
  });

  test('Natural Recovery is connected to its resource and formula', () {
    final land = druidLandCircleDefinition;
    final resource = land.resources.single;
    final recovery = land.spellSlotRecoveries.single;

    expect(resource.id, 'natural_recovery');
    expect(recovery.id, resource.id);
    expect(recovery.resourceId, resource.id);
    expect(recovery.requiresShortRest, isTrue);
    expect(recovery.maximumSlotLevel, 5);

    expect(recovery.maximumCombinedSlotLevelsAtLevel(2), 1);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(3), 2);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(9), 5);
    expect(recovery.maximumCombinedSlotLevelsAtLevel(20), 10);
  });

  test('base and Moon Wild Shape progressions resolve independently', () {
    final base = druid.transformationFor('wild_shape')!;
    final moon = druid.transformationFor(
      'wild_shape',
      subclassId: DruidSubclassIds.moon,
    )!;

    expect(base.action, ClassTransformationAction.action);
    expect(moon.action, ClassTransformationAction.bonusAction);

    expect(base.maximumChallengeRatingAtLevel(2), 0.25);
    expect(base.maximumChallengeRatingAtLevel(4), 0.5);
    expect(base.maximumChallengeRatingAtLevel(8), 1);

    expect(moon.maximumChallengeRatingAtLevel(2), 1);
    expect(moon.maximumChallengeRatingAtLevel(6), 2);
    expect(moon.maximumChallengeRatingAtLevel(9), 3);
    expect(moon.maximumChallengeRatingAtLevel(12), 4);
    expect(moon.maximumChallengeRatingAtLevel(15), 5);
    expect(moon.maximumChallengeRatingAtLevel(18), 6);

    expect(base.durationHoursAtLevel(20), 10);
    expect(moon.durationHoursAtLevel(20), 10);
    expect(base.allowsSpellcastingAtLevel(18), isTrue);
    expect(moon.allowsSpellcastingAtLevel(18), isTrue);
  });

  test('Elemental Wild Shape is ready for the future creature catalog', () {
    final elemental = druid.transformationFor(
      'elemental_wild_shape',
      subclassId: DruidSubclassIds.moon,
    )!;

    expect(elemental.minimumLevel, 10);
    expect(elemental.resourceCost, 2);
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

  test('every class and circle resource reference resolves', () {
    final classResourceIds =
        druid.resources.map((resource) => resource.id).toSet();

    expect(classResourceIds, {'wild_shape'});

    for (final feature in druid.featureDefinitions.values) {
      if (feature.resourceId == null) continue;
      expect(classResourceIds, contains(feature.resourceId));
    }

    for (final transformation in druid.transformations) {
      expect(classResourceIds, contains(transformation.resourceId));
    }

    for (final circle in druid.subclasses.values) {
      final localResourceIds =
          circle.resources.map((resource) => resource.id).toSet();

      final availableResourceIds = {
        ...classResourceIds,
        ...localResourceIds,
      };

      for (final feature in circle.featureDefinitions.values) {
        if (feature.resourceId == null) continue;

        expect(
          availableResourceIds,
          contains(feature.resourceId),
          reason: '${circle.id}: ${feature.id}',
        );
      }

      for (final transformation in circle.transformations) {
        expect(
          availableResourceIds,
          contains(transformation.resourceId),
          reason: '${circle.id}: ${transformation.id}',
        );
      }

      for (final recovery in circle.spellSlotRecoveries) {
        expect(
          availableResourceIds,
          contains(recovery.resourceId),
          reason: '${circle.id}: ${recovery.id}',
        );
      }
    }
  });

  test('Wild Shape becomes unlimited only for the Archdruid', () {
    final resource =
        druid.resources.singleWhere((entry) => entry.id == 'wild_shape');

    expect(resource.maximumAtLevel(2), 2);
    expect(resource.maximumAtLevel(19), 2);
    expect(resource.isUnlimitedAtLevel(19), isFalse);
    expect(resource.isUnlimitedAtLevel(20), isTrue);
    expect(
      druid.featureDefinitions['archdruid']!.ruleTags,
      contains('unlimited_resource'),
    );
  });

  test('Druidic preserves its complete secret-message rules', () {
    final details =
        druid.featureDefinitions['druidic']!.content.description.details;

    expect(details, contains('individuano automaticamente'));
    expect(details, contains('Saggezza (Percezione)'));
    expect(details, contains('CD 15'));
    expect(details, contains('senza l’aiuto della magia'));
  });

  test('Druid spell preparation follows the complete PHB procedure', () {
    final details =
        druid.featureDefinitions['spellcasting']!.content.description.details;

    expect(details, contains('livelli per cui possiede slot'));
    expect(details, contains('riposo lungo'));
    expect(details, contains('1 minuto per livello'));
    expect(details, contains('focus druidico'));
  });

  test('Wild Shape retains all PHB transformation rules', () {
    final details =
        druid.featureDefinitions['wild_shape']!.content.description.details;

    expect(details, contains('arrotondato per difetto'));
    expect(details, contains('azione bonus'));
    expect(details, contains('privo di sensi'));
    expect(details, contains('0 punti ferita'));
    expect(details, contains('azioni leggendarie o di tana'));
    expect(details, contains('danni eccedenti'));
    expect(details, contains('conserva la concentrazione'));
    expect(details, contains('sensi speciali'));
    expect(details, contains('si fonde nella forma'));
  });

  test('Circle of the Land uses the official Nature Refuge name', () {
    final land = druid.subclasses[DruidSubclassIds.land]!;
    final refuge = land.featureDefinitions['natures_sanctuary']!;

    expect(refuge.content.name, 'Rifugio della Natura');
    expect(
      refuge.content.description.details,
      contains('CD degli incantesimi del Druido'),
    );
    expect(
      refuge.content.description.details,
      contains('consapevole dell’effetto'),
    );
    expect(
      refuge.content.description.details,
      contains('24 ore'),
    );
  });

  test('Land Stride includes thorns and magical-plant saving throws', () {
    final details = druid.subclasses[DruidSubclassIds.land]!
        .featureDefinitions['lands_stride']!.content.description.details;

    expect(details, contains('spine, aculei'));
    expect(details, contains('tiri salvezza'));
    expect(details, contains('creati o manipolati magicamente'));
  });

  test('Archdruid component benefits work in both forms', () {
    final details =
        druid.featureDefinitions['archdruid']!.content.description.details;

    expect(details, contains('numero illimitato'));
    expect(details, contains('componenti verbali e somatiche'));
    expect(details, contains('prive di costo e non consumate'));
    expect(details, contains('forma normale'));
    expect(details, contains('forma bestiale'));
  });

  test('all subclass choices have unique stable IDs', () {
    final ids = <String>[
      for (final circle in druid.subclasses.values)
        for (final feature in circle.featureDefinitions.values)
          ...feature.choices.map((choice) => choice.id),
      for (final option in druidLandCircleDefinition.options) option.id,
    ];

    expect(ids.toSet().length, ids.length);
    expect(ids, contains('land_circle_bonus_cantrip'));
  });
}
