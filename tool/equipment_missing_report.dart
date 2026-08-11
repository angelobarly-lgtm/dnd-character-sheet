import 'dart:io';

import 'package:dnd_character_sheet/data/equipment_data.dart';

void main() {
  stdout.writeln("========================================");
  stdout.writeln("EQUIPMENT REPORT");
  stdout.writeln("========================================");

  stdout.writeln("Definitions : ${equipmentDefinitions.length}");

  final ids = equipmentDefinitions.keys.toList()..sort();

  stdout.writeln("IDs");
  stdout.writeln("----------------------------------------");

  for (final id in ids) {
    stdout.writeln(id);
  }

  stdout.writeln("----------------------------------------");
  stdout.writeln("Total IDs : ${ids.length}");
}
