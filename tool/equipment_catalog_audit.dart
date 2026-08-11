import 'dart:io';

import 'package:dnd_character_sheet/data/equipment_data.dart';

void main() {
  stdout.writeln("========================================");
  stdout.writeln("EQUIPMENT CATALOG AUDIT");
  stdout.writeln("========================================");

  stdout.writeln("Equipment definitions: ${equipmentDefinitions.length}");

  final ids = equipmentDefinitions.keys.toSet();

  stdout.writeln("Unique ids: ${ids.length}");

  if (ids.length != equipmentDefinitions.length) {
    stdout.writeln("WARNING: duplicate ids detected");
  } else {
    stdout.writeln("PASS Unique IDs");
  }

  stdout.writeln("========================================");
}
