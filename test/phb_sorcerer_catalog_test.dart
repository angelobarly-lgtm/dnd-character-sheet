import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/sorcerer_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sorcerer = phbClassDefinitions[ClassIds.sorcerer]!;
  final draconic = sorcerer.subclasses[SorcererSubclassIds.draconicBloodline]!;
  final wildMagic = sorcerer.subclasses[SorcererSubclassIds.wildMagic]!;

  test('Sorcerer is registered as PHB 2014 content', () {
    expect(phbClassDefinitions, contains(ClassIds.sorcerer));
    expect(sorcerer.id, ClassIds.sorcerer);
    expect(sorcerer.name, 'Stregone');
    expect(sorcerer.content.source.name, 'Manuale del Giocatore 2014');
    expect(
      sorcerer.subclasses.keys.toSet(),
      phbSorcererSubclassIds,
    );
  });

  test('Sorcerer base progression grants only defined features', () {
    final granted =
        sorcerer.featuresByLevel.values.expand((features) => features).toSet();
    final defined = sorcerer.featureDefinitions.keys.toSet();

    expect(granted.difference(defined), isEmpty);
    expect(defined.difference(granted), isEmpty);

    expect(sorcerer.featuresAtLevel(1), hasLength(2));
    expect(sorcerer.featuresAtLevel(2), hasLength(1));
    expect(sorcerer.featuresAtLevel(3), hasLength(1));
    expect(sorcerer.featuresAtLevel(4), isNotEmpty);
    expect(sorcerer.featuresAtLevel(10), isNotEmpty);
    expect(sorcerer.featuresAtLevel(17), isNotEmpty);
    expect(sorcerer.featuresAtLevel(20), hasLength(1));

    for (final entry in sorcerer.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.sorcerer);
      expect(
        entry.value.content.source.name,
        'Manuale del Giocatore 2014',
      );
    }
  });

  test('Sorcerer spellcasting matches the PHB full-caster table', () {
    final spellcasting = sorcerer.spellcasting!;

    expect(spellcasting.ability, 'CAR');
    expect(spellcasting.minimumLevel, 1);
    expect(spellcasting.preparesSpells, isFalse);
    expect(spellcasting.ritualCasting, isFalse);

    expect(
      spellcasting.slotsAtLevel(1),
      [2, 0, 0, 0, 0, 0, 0, 0, 0],
    );
    expect(
      spellcasting.slotsAtLevel(5),
      [4, 3, 2, 0, 0, 0, 0, 0, 0],
    );
    expect(
      spellcasting.slotsAtLevel(11),
      [4, 3, 3, 3, 2, 1, 0, 0, 0],
    );
    expect(
      spellcasting.slotsAtLevel(20),
      [4, 3, 3, 3, 3, 2, 2, 1, 1],
    );

    expect(spellcasting.cantripsKnownAtLevel(1), 4);
    expect(spellcasting.cantripsKnownAtLevel(10), 6);
    expect(spellcasting.cantripsKnownAtLevel(20), 6);

    expect(spellcasting.spellsKnownAtLevel(1), 2);
    expect(spellcasting.spellsKnownAtLevel(3), 4);
    expect(spellcasting.spellsKnownAtLevel(11), 12);
    expect(spellcasting.spellsKnownAtLevel(17), 15);
    expect(spellcasting.spellsKnownAtLevel(20), 15);

    expect(spellcasting.spellIds, hasLength(129));
    expect(
      spellcasting.spellIds.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('Sorcery Points progress from level 2 to level 20', () {
    final sorceryPoints = sorcerer.resources.singleWhere(
      (resource) => resource.name == 'Punti Stregoneria',
    );

    expect(sorceryPoints.minimumLevel, 2);
    expect(sorceryPoints.maximumAtLevel(1), 0);
    expect(sorceryPoints.maximumAtLevel(2), 2);
    expect(sorceryPoints.maximumAtLevel(5), 5);
    expect(sorceryPoints.maximumAtLevel(10), 10);
    expect(sorceryPoints.maximumAtLevel(20), 20);
    expect(
      sorceryPoints.recovery,
      ClassResourceRecovery.longRest,
    );
  });

  test('both PHB Sorcerous Origins use levels 1, 6, 14 and 18', () {
    for (final subclass in [draconic, wildMagic]) {
      expect(subclass.classId, ClassIds.sorcerer);
      expect(subclass.featuresByLevel.keys.toSet(), {1, 6, 14, 18});
      expect(
        subclass.content.source.name,
        'Manuale del Giocatore 2014',
      );

      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();
      final defined = subclass.featureDefinitions.keys.toSet();

      expect(granted.difference(defined), isEmpty);
      expect(defined.difference(granted), isEmpty);

      for (final entry in subclass.featureDefinitions.entries) {
        expect(entry.value.id, entry.key);
        expect(entry.value.content.id, entry.key);
        expect(entry.value.content.ownerId, ClassIds.sorcerer);
        expect(
          entry.value.content.source.name,
          'Manuale del Giocatore 2014',
        );
      }
    }
  });

  test('Draconic Bloodline contains all ten PHB ancestries', () {
    expect(draconic.name, 'Discendenza Draconica');

    final ancestryChoice = draconic.featureDefinitions.values
        .expand((feature) => feature.choices)
        .singleWhere((choice) => choice.options.length == 10);

    expect(ancestryChoice.minimumSelections, 1);
    expect(ancestryChoice.maximumSelections, 1);
    expect(ancestryChoice.options, hasLength(10));
    expect(
      ancestryChoice.options.map((option) => option.id).toSet(),
      hasLength(10),
    );

    for (final option in ancestryChoice.options) {
      expect(option.id, isNotEmpty);
      expect(option.label, isNotEmpty);
    }
  });

  test('Wild Magic contains the complete d100 table', () {
    expect(wildMagic.name, 'Magia Selvaggia');

    final table = wildMagic.randomTables.single;
    expect(table.dieSides, 100);
    expect(table.entries, hasLength(50));

    for (var roll = 1; roll <= 100; roll++) {
      expect(
        table.entries.where((entry) => entry.matches(roll)),
        hasLength(1),
      );
      expect(table.entryForRoll(roll), isNotNull);
    }

    final creatureIds =
        table.entries.expand((entry) => entry.creatureIds).toSet();

    expect(creatureIds, {'modron', 'flumph', 'unicorn'});
  });

  test('all Sorcerer spell references resolve to the canonical catalog', () {
    final referencedSpellIds = <String>{
      ...sorcerer.spellcasting!.spellIds,
      for (final feature in sorcerer.featureDefinitions.values)
        ...feature.spellIds,
    };

    for (final subclass in sorcerer.subclasses.values) {
      for (final feature in subclass.featureDefinitions.values) {
        referencedSpellIds.addAll(feature.spellIds);
      }

      for (final table in subclass.randomTables) {
        for (final entry in table.entries) {
          referencedSpellIds.addAll(entry.spellIds);
        }
      }
    }

    expect(
      referencedSpellIds.difference(spellDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('all Sorcerer resource links resolve correctly', () {
    final classResourceIds =
        sorcerer.resources.map((resource) => resource.id).toSet();

    for (final feature in sorcerer.featureDefinitions.values) {
      final resourceId = feature.resourceId;
      if (resourceId != null) {
        expect(classResourceIds, contains(resourceId));
      }
    }

    for (final subclass in sorcerer.subclasses.values) {
      final availableResourceIds = <String>{
        ...classResourceIds,
        ...subclass.resources.map((resource) => resource.id),
      };

      for (final feature in subclass.featureDefinitions.values) {
        final resourceId = feature.resourceId;
        if (resourceId != null) {
          expect(availableResourceIds, contains(resourceId));
        }
      }

      for (final usage in subclass.resourceUsages) {
        expect(
          availableResourceIds,
          contains(usage.resourceId),
        );
      }
    }
  });

  test('Sorcerer catalog contains no duplicate structural identifiers', () {
    expect(
      sorcerer.featureDefinitions.keys,
      hasLength(sorcerer.featureDefinitions.length),
    );

    final subclassFeatureIds = <String>{};
    final subclassResourceIds = <String>{};
    final randomTableIds = <String>{};

    for (final subclass in sorcerer.subclasses.values) {
      for (final featureId in subclass.featureDefinitions.keys) {
        expect(subclassFeatureIds.add(featureId), isTrue);
      }

      for (final resource in subclass.resources) {
        expect(subclassResourceIds.add(resource.id), isTrue);
      }

      for (final table in subclass.randomTables) {
        expect(randomTableIds.add(table.id), isTrue);

        final entryIds = <String>{};
        for (final entry in table.entries) {
          expect(entryIds.add(entry.id), isTrue);
        }
      }
    }
  });
}
