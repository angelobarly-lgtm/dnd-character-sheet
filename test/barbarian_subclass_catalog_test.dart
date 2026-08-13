import 'package:dnd_character_sheet/data/barbarian_class_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final barbarian = phbClassDefinitions[ClassIds.barbarian]!;

  test('both PHB Barbarian paths are registered', () {
    expect(
      barbarian.subclasses.keys.toSet(),
      {
        BarbarianSubclassIds.berserker,
        BarbarianSubclassIds.totemWarrior,
      },
    );
    expect(barbarian.phbSubclasses, hasLength(2));
    expect(barbarian.supplementalSubclasses, isEmpty);

    for (final subclass in barbarian.subclasses.values) {
      expect(subclass.classId, ClassIds.barbarian);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
      expect(subclass.content.source.isEmpty, isFalse);
    }
  });

  test('Berserker progression and feature definitions are complete', () {
    final berserker = barbarian.subclasses[BarbarianSubclassIds.berserker]!;

    expect(berserker.featuresByLevel, {
      3: ['frenzy'],
      6: ['mindless_rage'],
      10: ['intimidating_presence'],
      14: ['retaliation'],
    });

    final granted =
        berserker.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(
        berserker.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );

    expect(berserker.featureDefinitions['frenzy']!.resourceId, 'rage');
    expect(
      berserker.featureDefinitions['mindless_rage']!.resourceId,
      'rage',
    );
  });

  test('Totem Warrior progression and definitions are complete', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(totem.featuresByLevel, {
      3: [
        'spirit_seeker',
        'totem_spirit',
      ],
      6: ['aspect_of_the_beast'],
      10: ['spirit_walker'],
      14: ['totemic_attunement'],
    });

    final granted =
        totem.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(5));
    expect(
      granted.difference(totem.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('Totem Warrior has three independent choices at each tier', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(totem.options, hasLength(9));
    expect(
      totem.options.map((option) => option.id).toSet(),
      hasLength(9),
    );

    expect(
      totem.options.where((option) => option.category == 'totem_spirit'),
      hasLength(3),
    );
    expect(
      totem.options.where(
        (option) => option.category == 'aspect_of_the_beast',
      ),
      hasLength(3),
    );
    expect(
      totem.options.where(
        (option) => option.category == 'totemic_attunement',
      ),
      hasLength(3),
    );
  });

  test('Totem choice progression reaches three selections', () {
    final progression = barbarian
        .subclasses[BarbarianSubclassIds.totemWarrior]!.optionProgression!;

    expect(progression.selectionsAtLevel(2), 0);
    expect(progression.selectionsAtLevel(3), 1);
    expect(progression.selectionsAtLevel(6), 2);
    expect(progression.selectionsAtLevel(13), 2);
    expect(progression.selectionsAtLevel(14), 3);
    expect(progression.selectionsAtLevel(20), 3);
    expect(progression.replacementLevels, isEmpty);
  });

  test('Totem options use metric distances', () {
    final options =
        barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!.options;

    final wolfSpirit = options.singleWhere(
      (option) => option.id == 'totem_spirit_wolf',
    );
    final eagleAspect = options.singleWhere(
      (option) => option.id == 'aspect_of_the_beast_eagle',
    );
    final bearAttunement = options.singleWhere(
      (option) => option.id == 'totemic_attunement_bear',
    );

    expect(wolfSpirit.description.details, contains('1,5 metri'));
    expect(eagleAspect.description.details, contains('1,6 km'));
    expect(eagleAspect.description.details, contains('30 metri'));
    expect(bearAttunement.description.details, contains('1,5 metri'));
  });

  test('all subclass content has stable ownership and descriptions', () {
    for (final subclass in barbarian.phbSubclasses) {
      expect(subclass.content.ownerId, ClassIds.barbarian);
      expect(subclass.content.description.summary.trim(), isNotEmpty);
      expect(subclass.content.description.details.trim(), isNotEmpty);

      for (final entry in subclass.featureDefinitions.entries) {
        final content = entry.value.content;

        expect(content.id, entry.key);
        expect(content.ownerId, subclass.id);
        expect(content.description.summary.trim(), isNotEmpty);
        expect(content.description.details.trim(), isNotEmpty);
      }

      for (final option in subclass.options) {
        expect(option.source.trim(), isNotEmpty);
        expect(option.sourceRef.trim(), isNotEmpty);
        expect(option.description.summary.trim(), isNotEmpty);
        expect(option.description.details.trim(), isNotEmpty);
      }
    }
  });
}
