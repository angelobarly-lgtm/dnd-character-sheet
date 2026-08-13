import 'barbarian_class_data.dart';
import 'bard_class_data.dart';
import 'class_catalog_data.dart';
import 'monk_class_data.dart';

export 'class_catalog_data.dart';

final Map<String, CharacterClassDefinition> phbClassDefinitions = {
  ClassIds.barbarian: barbarianClassDefinition,
  ClassIds.bard: bardClassDefinition,
  ClassIds.monk: monkClassDefinition,
};

CharacterClassDefinition? phbClassDefinitionFor(String id) =>
    phbClassDefinitions[id];
