import 'class_catalog_data.dart';
import 'monk_class_data.dart';

export 'class_catalog_data.dart';

final Map<String, CharacterClassDefinition> phbClassDefinitions = {
  ClassIds.monk: monkClassDefinition,
};

CharacterClassDefinition? phbClassDefinitionFor(String id) =>
    phbClassDefinitions[id];
