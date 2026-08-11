import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('spell catalog is complete and structurally valid', () {
    final text = File('lib/data/spell_data.dart').readAsStringSync();

    final idRegex = RegExp(r"static\s+const\s+(\w+)\s*=\s*'([^']+)';");
    final defRegex = RegExp(r'SpellIds\.(\w+):\s*SpellDefinition\(');

    final ids = idRegex.allMatches(text).map((m) => m.group(1)!).toList();
    final idValues = idRegex.allMatches(text).map((m) => m.group(2)!).toList();
    final defs = defRegex.allMatches(text).map((m) => m.group(1)!).toList();

    expect(ids.length, 35);
    expect(defs.length, 35);

    expect(ids.toSet().length, ids.length, reason: 'Duplicate SpellIds names');
    expect(
      idValues.toSet().length,
      idValues.length,
      reason: 'Duplicate SpellIds values',
    );
    expect(defs.toSet().length, defs.length, reason: 'Duplicate definitions');

    final missing = ids.where((id) => !defs.contains(id)).toList();
    final extra = defs.where((id) => !ids.contains(id)).toList();

    expect(missing, isEmpty, reason: 'Missing spell definitions');
    expect(extra, isEmpty, reason: 'Extra spell definitions');

    for (final spell in defs) {
      final start = text.indexOf('SpellIds.$spell: SpellDefinition(');
      final nextStarts = defs
          .map(
            (other) => text.indexOf(
              '\n  SpellIds.$other: SpellDefinition(',
              start + 1,
            ),
          )
          .where((pos) => pos != -1)
          .toList();

      final end = nextStarts.isEmpty
          ? text.indexOf('\n};', start)
          : nextStarts.reduce((a, b) => a < b ? a : b);

      final block = text.substring(start, end);

      expect(block, contains('id: SpellIds.$spell,'));
      expect(block, contains('ownerId: SpellIds.$spell,'));
      expect(block, contains('type: RuleContentType.spell,'));
      expect(block, contains('level:'));
      expect(block, contains('school:'));
      expect(block, contains('castingTime:'));
      expect(block, contains('range:'));
      expect(block, contains('components:'));
      expect(block, contains('duration:'));
      expect(block, contains('classIds:'));
    }
  });
}
