import 'barbarian_class_data.dart';
import 'bard_class_data.dart';
import 'class_catalog_data.dart';
import 'cleric_class_data.dart';
import 'druid_class_data.dart';
import 'fighter_class_data.dart';
import 'monk_class_data.dart';
import 'paladin_class_data.dart';
import 'ranger_class_data.dart';
import 'rogue_class_data.dart';
import 'sorcerer_class_data.dart';
import 'warlock_class_data.dart';
import 'wizard_class_data.dart';

export 'class_catalog_data.dart';

final Map<String, CharacterClassDefinition> phbClassDefinitions = {
  ClassIds.barbarian: barbarianClassDefinition,
  ClassIds.bard: bardClassDefinition,
  ClassIds.cleric: clericClassDefinition,
  ClassIds.druid: druidClassDefinition,
  ClassIds.fighter: fighterClassDefinition,
  ClassIds.monk: monkClassDefinition,
  ClassIds.paladin: paladinClassDefinition,
  ClassIds.ranger: rangerClassDefinition,
  ClassIds.rogue: rogueClassDefinition,
  ClassIds.sorcerer: sorcererClassDefinition,
  ClassIds.warlock: warlockClassDefinition,
  ClassIds.wizard: wizardClassDefinition,
};

CharacterClassDefinition? phbClassDefinitionFor(String id) =>
    phbClassDefinitions[id];
