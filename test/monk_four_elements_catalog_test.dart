import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/monk_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monk = phbClassDefinitions[ClassIds.monk]!;
  final fourElements = monk.subclasses[MonkSubclassIds.fourElements]!;

  test('Four Elements is registered as the third PHB Monk tradition', () {
    expect(fourElements.id, MonkSubclassIds.fourElements);
    expect(fourElements.classId, ClassIds.monk);
    expect(fourElements.homebrew, isFalse);
    expect(fourElements.supplemental, isFalse);
    expect(monk.phbSubclasses.length, 3);
  });

  test('Four Elements feature progression is complete', () {
    expect(fourElements.featuresByLevel, {
      3: ['disciple_of_the_elements'],
      6: ['additional_elemental_discipline'],
      11: ['additional_elemental_discipline'],
      17: ['additional_elemental_discipline'],
    });

    final granted = fourElements.featuresByLevel.values
        .expand((features) => features)
        .toSet();

    expect(
      granted.difference(
        fourElements.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );
  });

  test('all 17 elemental disciplines are registered', () {
    expect(fourElements.options, hasLength(17));

    final ids = fourElements.options.map((option) => option.id).toList();

    expect(ids.toSet(), hasLength(17));
    expect(
      ids,
      containsAll({
        'sintonia_elementale',
        'frusta_d_acqua',
        'pugno_dell_aria_inviolabile',
        'soffio_dell_inverno',
        'onda_della_terra_tumultuosa',
      }),
    );
  });

  test('Elemental Attunement is the only automatic discipline', () {
    final automatic = fourElements.options
        .where((option) => option.grantedAutomatically)
        .toList();

    expect(automatic, hasLength(1));
    expect(automatic.single.id, 'sintonia_elementale');
    expect(automatic.single.cost, isNull);
    expect(automatic.single.resource, isNull);
  });

  test('selectable disciplines have verified level distribution', () {
    final selectable = fourElements.options
        .where((option) => !option.grantedAutomatically)
        .toList();

    expect(selectable, hasLength(16));

    expect(
      selectable.where((option) => option.minimumLevel == 3),
      hasLength(7),
    );
    expect(
      selectable.where((option) => option.minimumLevel == 6),
      hasLength(2),
    );
    expect(
      selectable.where((option) => option.minimumLevel == 11),
      hasLength(3),
    );
    expect(
      selectable.where((option) => option.minimumLevel == 17),
      hasLength(4),
    );

    expect(
      selectable.every((option) => option.resource == 'ki'),
      isTrue,
    );
  });

  test('discipline selection and replacement progression is correct', () {
    final progression = fourElements.optionProgression!;

    expect(progression.selectionsAtLevel(2), 0);
    expect(progression.selectionsAtLevel(3), 1);
    expect(progression.selectionsAtLevel(6), 2);
    expect(progression.selectionsAtLevel(11), 3);
    expect(progression.selectionsAtLevel(17), 4);
    expect(progression.selectionsAtLevel(20), 4);

    expect(progression.canReplaceAtLevel(3), isFalse);
    expect(progression.canReplaceAtLevel(6), isTrue);
    expect(progression.canReplaceAtLevel(11), isTrue);
    expect(progression.canReplaceAtLevel(17), isTrue);
  });

  test('variable-cost disciplines expose their spending rules', () {
    final variable = fourElements.options
        .where((option) => option.allowsAdditionalResource)
        .toList();

    expect(variable, hasLength(3));

    final waterWhip = variable.singleWhere(
      (option) => option.id == 'frusta_d_acqua',
    );
    final unbrokenAir = variable.singleWhere(
      (option) => option.id == 'pugno_dell_aria_inviolabile',
    );
    final fireSnake = variable.singleWhere(
      (option) => option.id == 'zanne_del_serpente_di_fuoco',
    );

    expect(waterWhip.maximumCost, 4);
    expect(unbrokenAir.maximumCost, 4);
    expect(fireSnake.maximumCost, isNull);
  });

  test('elemental disciplines use metric distances', () {
    final attunement = fourElements.options.singleWhere(
      (option) => option.id == 'sintonia_elementale',
    );
    final waterWhip = fourElements.options.singleWhere(
      (option) => option.id == 'frusta_d_acqua',
    );
    final fireSnake = fourElements.options.singleWhere(
      (option) => option.id == 'zanne_del_serpente_di_fuoco',
    );

    expect(attunement.description.details, contains('9 metri'));
    expect(waterWhip.description.details, contains('9 metri'));
    expect(fireSnake.description.details, contains('3 metri'));
  });
}
