import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/monk_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monk = phbClassDefinitions[ClassIds.monk]!;

  test('Open Hand and Shadow are registered as PHB Monk traditions', () {
    expect(
      monk.subclasses.keys.toSet(),
      {
        MonkSubclassIds.openHand,
        MonkSubclassIds.shadow,
        MonkSubclassIds.fourElements,
      },
    );

    for (final subclass in monk.subclasses.values) {
      expect(subclass.classId, ClassIds.monk);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
    }
  });

  test('Open Hand progression and definitions are complete', () {
    final openHand = monk.subclasses[MonkSubclassIds.openHand]!;

    expect(openHand.featuresByLevel, {
      3: ['open_hand_technique'],
      6: ['wholeness_of_body'],
      11: ['tranquility'],
      17: ['quivering_palm'],
    });

    final granted =
        openHand.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(openHand.featureDefinitions.keys.toSet()),
      isEmpty,
    );
    expect(
      openHand.featureDefinitions['quivering_palm']!.resourceId,
      'ki',
    );
  });

  test('Shadow progression and definitions are complete', () {
    final shadow = monk.subclasses[MonkSubclassIds.shadow]!;

    expect(shadow.featuresByLevel, {
      3: ['shadow_arts'],
      6: ['shadow_step'],
      11: ['cloak_of_shadows'],
      17: ['opportunist'],
    });

    final granted =
        shadow.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(shadow.featureDefinitions.keys.toSet()),
      isEmpty,
    );
    expect(shadow.featureDefinitions['shadow_arts']!.resourceId, 'ki');
  });

  test('Open Hand uses metric distances and the verified Ki costs', () {
    final technique = monkOpenHandFeatureDefinitions['open_hand_technique']!;
    final palm = monkOpenHandFeatureDefinitions['quivering_palm']!;

    expect(technique.content.description.details, contains('4,5 metri'));
    expect(palm.content.description.details, contains('3 Ki'));
    expect(palm.content.description.details, contains('10d10'));
  });

  test('Shadow uses metric distances and registered spell techniques', () {
    final arts = monkShadowFeatureDefinitions['shadow_arts']!;
    final step = monkShadowFeatureDefinitions['shadow_step']!;
    final opportunist = monkShadowFeatureDefinitions['opportunist']!;

    expect(arts.content.description.details, contains('2 Ki'));
    expect(arts.ruleTags, contains('pass_without_trace'));
    expect(step.content.description.details, contains('18 metri'));
    expect(opportunist.content.description.details, contains('1,5 metri'));
  });

  test('No supplemental Monk tradition has been registered yet', () {
    expect(monk.supplementalSubclasses, isEmpty);
    expect(monk.phbSubclasses.length, 3);
  });
}
