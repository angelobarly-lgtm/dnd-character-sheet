import 'dart:io';

import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testTable = BackgroundTableDefinition(
    id: 'test_table',
    name: 'Tabella di prova',
    dieSides: 6,
    entries: [
      BackgroundTableEntry(
        minimumRoll: 1,
        maximumRoll: 2,
        label: 'Primo risultato',
      ),
      BackgroundTableEntry(
        minimumRoll: 3,
        maximumRoll: 6,
        label: 'Secondo risultato',
      ),
    ],
  );

  test('background table resolves single values and ranges', () {
    expect(testTable.entryForRoll(1)?.label, 'Primo risultato');
    expect(testTable.entryForRoll(2)?.label, 'Primo risultato');
    expect(testTable.entryForRoll(3)?.label, 'Secondo risultato');
    expect(testTable.entryForRoll(6)?.label, 'Secondo risultato');
    expect(testTable.entryForRoll(0), isNull);
    expect(testTable.entryForRoll(7), isNull);
  });

  test('suggested characteristics report their completeness', () {
    const empty = BackgroundSuggestedCharacteristics();
    const complete = BackgroundSuggestedCharacteristics(
      personalityTraits: testTable,
      ideals: testTable,
      bonds: testTable,
      flaws: testTable,
    );

    expect(empty.isComplete, isFalse);
    expect(complete.isComplete, isTrue);
  });

  test('PHB background ids are unique and complete', () {
    final text = File('lib/data/background_data.dart').readAsStringSync();

    final idRegex = RegExp(
      r"static\s+const\s+(\w+)\s*=\s*'([^']+)';",
    );

    final matches = idRegex.allMatches(text).toList();
    final names = matches.map((match) => match.group(1)!).toList();
    final values = matches.map((match) => match.group(2)!).toList();

    expect(names.length, 18);
    expect(values.length, 18);
    expect(names.toSet().length, 18);
    expect(values.toSet().length, 18);
  });
}
