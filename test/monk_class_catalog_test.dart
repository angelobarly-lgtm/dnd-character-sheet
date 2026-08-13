import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monk = phbClassDefinitions[ClassIds.monk]!;

  test('Monk is registered with its PHB core identity', () {
    expect(monk.id, ClassIds.monk);
    expect(monk.name, 'Monaco');
    expect(monk.hitDie, 8);
    expect(monk.subclassSelectionLevel, 3);
    expect(monk.homebrew, isFalse);
  });

  test('Monk saving throws and skill choices match the PHB', () {
    expect(monk.proficiencies.savingThrows, {'FOR', 'DES'});
    expect(
      monk.proficiencies.skillOptions,
      {
        'acrobatics',
        'athletics',
        'history',
        'insight',
        'religion',
        'stealth',
      },
    );
    expect(monk.proficiencies.skillChoices, 2);

    final toolChoice = monk.proficiencies.choices.singleWhere(
      (choice) => choice.id == 'monk_artisan_tool_or_instrument',
    );

    expect(toolChoice.type, ClassProficiencyChoiceType.tool);
    expect(toolChoice.selections, 1);
    expect(toolChoice.optionIds.length, 27);
  });

  test('Monk starting equipment is represented as real choices', () {
    expect(monk.startingEquipmentChoices.length, 2);

    final weaponChoice = monk.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'monk_starting_weapon',
    );
    final packChoice = monk.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'monk_starting_pack',
    );

    expect(weaponChoice.alternatives.length, 15);
    expect(packChoice.alternatives.length, 2);

    expect(monk.fixedStartingEquipment, hasLength(1));
    expect(monk.fixedStartingEquipment.single.itemId, 'dart');
    expect(monk.fixedStartingEquipment.single.quantity, 10);
  });

  test('Monk has a complete Ki progression', () {
    final ki = monk.resources.singleWhere(
      (resource) => resource.id == 'ki',
    );

    expect(ki.minimumLevel, 2);
    expect(ki.recovery, ClassResourceRecovery.shortRest);
    expect(ki.maximumAtLevel(1), 0);

    for (var level = 2; level <= 20; level++) {
      expect(
        ki.maximumAtLevel(level),
        level,
        reason: 'Ki errato al livello $level',
      );
    }
  });

  test('Monk martial die and movement use verified progression', () {
    expect(monk.progressionValue('martial_arts_die', 1), 'd4');
    expect(monk.progressionValue('martial_arts_die', 10), 'd6');
    expect(monk.progressionValue('martial_arts_die', 11), 'd8');
    expect(monk.progressionValue('martial_arts_die', 20), 'd10');

    expect(monk.progressionValue('unarmored_movement_bonus', 1), isNull);
    expect(monk.progressionValue('unarmored_movement_bonus', 2), '3 m');
    expect(monk.progressionValue('unarmored_movement_bonus', 18), '9 m');
  });

  test('Every granted Monk feature has a registered definition', () {
    final grantedIds =
        monk.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      grantedIds.difference(monk.featureDefinitions.keys.toSet()),
      isEmpty,
    );
    expect(grantedIds, hasLength(20));
  });

  test('Monk base progression reaches level 20', () {
    expect(monk.featuresAtLevel(1), contains('martial_arts'));
    expect(monk.featuresAtLevel(3), contains('monastic_tradition'));
    expect(monk.featuresAtLevel(5), contains('extra_attack'));
    expect(monk.featuresAtLevel(20), ['perfect_self']);
    expect(monk.subclasses.length, 3);
  });
}
