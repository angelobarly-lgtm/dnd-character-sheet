import 'dart:io';

import 'package:dnd_character_sheet/data/spell_data.dart';

typedef AuditFail = void Function(String label, String message);
typedef AuditOk = void Function(String label);

void checkDuplicateIds(
  List<SpellDefinition> definitions,
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;
  final ids = <String>{};

  for (final spell in definitions) {
    if (!ids.add(spell.id)) {
      errors++;
      fail('Duplicate ids', spell.id);
    }
  }

  if (errors == 0) ok('Duplicate ids');
}

void checkDefinitionKeys(
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;

  spellDefinitions.forEach((key, spell) {
    if (key != spell.id) {
      errors++;
      fail('Definition keys', '$key != ${spell.id}');
    }
  });

  if (errors == 0) ok('Definition keys');
}

void checkOwnerIds(
  List<SpellDefinition> definitions,
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;

  for (final spell in definitions) {
    if (spell.content.ownerId != spell.id) {
      errors++;
      fail('Owner ids', spell.id);
    }
  }

  if (errors == 0) ok('Owner ids');
}

void checkLevels(
  List<SpellDefinition> definitions,
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;

  for (final spell in definitions) {
    if (spell.level < 0 || spell.level > 9) {
      errors++;
      fail('Levels', '${spell.id}: ${spell.level}');
    }
  }

  if (errors == 0) ok('Levels');
}

void checkNames(
  List<SpellDefinition> definitions,
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;

  for (final spell in definitions) {
    if (spell.content.name.trim().isEmpty) {
      errors++;
      fail('Names', spell.id);
    }
  }

  if (errors == 0) ok('Names');
}

void checkComponents(
  List<SpellDefinition> definitions,
  AuditFail fail,
  AuditOk ok,
) {
  var errors = 0;

  for (final spell in definitions) {
    if (spell.components.material != spell.components.materials.isNotEmpty) {
      errors++;
      fail('Components', spell.id);
    }
  }

  if (errors == 0) ok('Components');
}

void checkPhbCantripCoverage(
  List<SpellDefinition> definitions,
) {
  const expected = {
    'acid_splash',
    'blade_ward',
    'chill_touch',
    'dancing_lights',
    'druidcraft',
    'eldritch_blast',
    'fire_bolt',
    'friends',
    'guidance',
    'light',
    'mage_hand',
    'mending',
    'message',
    'minor_illusion',
    'poison_spray',
    'prestidigitation',
    'produce_flame',
    'ray_of_frost',
    'resistance',
    'sacred_flame',
    'shillelagh',
    'shocking_grasp',
    'spare_the_dying',
    'thaumaturgy',
    'true_strike',
    'vicious_mockery',
  };

  final present =
      definitions.where((s) => s.level == 0).map((s) => s.id).toSet();

  final missing = expected.difference(present).toList()..sort();

  stdout.writeln();
  stdout.writeln('===== PHB CANTRIPS COVERAGE =====');
  stdout.writeln('Presenti : ${present.length}/${expected.length}');
  stdout.writeln('Mancanti : ${missing.length}');
  stdout.writeln();

  if (missing.isNotEmpty) {
    for (final id in missing) {
      stdout.writeln(' - $id');
    }
  }
}

void main() {
  var totalErrors = 0;
  var totalWarnings = 0;

  void ok(String label) => stdout.writeln('${label.padRight(24, ".")} OK');

  void fail(String label, String message) {
    totalErrors++;
    stdout.writeln('${label.padRight(24, ".")} ERROR');
    stdout.writeln('  • $message');
  }

  final definitions = spellDefinitions.values.toList();

  checkDuplicateIds(definitions, fail, ok);
  checkDefinitionKeys(fail, ok);
  checkOwnerIds(definitions, fail, ok);
  checkLevels(definitions, fail, ok);
  checkNames(definitions, fail, ok);
  checkComponents(definitions, fail, ok);

  stdout.writeln();
  stdout.writeln('Definitions: ${definitions.length}');
  stdout.writeln('Errors: $totalErrors');
  stdout.writeln('Warnings: $totalWarnings');

  if (totalErrors == 0) {
    stdout.writeln();
    stdout.writeln('SPELL CATALOG VERIFIED');
  } else {
    exitCode = 1;
  }
}
