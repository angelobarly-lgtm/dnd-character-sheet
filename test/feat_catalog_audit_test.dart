import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feat catalog is complete, ordered, and structurally valid', () {
    final text = File('lib/data/feat_data.dart').readAsStringSync();

    final idRegex = RegExp(r"static\s+const\s+(\w+)\s*=\s*'([^']+)';");
    final defRegex = RegExp(r'FeatIds\.(\w+):\s*FeatDefinition\(');

    final ids = idRegex.allMatches(text).map((m) => m.group(1)!).toList();
    final idValues = idRegex.allMatches(text).map((m) => m.group(2)!).toList();
    final defs = defRegex.allMatches(text).map((m) => m.group(1)!).toList();

    expect(ids.length, 43);
    expect(defs.length, 43);

    expect(ids.toSet().length, ids.length, reason: 'Duplicate FeatIds names');
    expect(
      idValues.toSet().length,
      idValues.length,
      reason: 'Duplicate FeatIds values',
    );
    expect(defs.toSet().length, defs.length, reason: 'Duplicate definitions');

    final missing = ids.where((id) => !defs.contains(id)).toList();
    final extra = defs.where((id) => !ids.contains(id)).toList();

    expect(missing, isEmpty, reason: 'Missing feat definitions');
    expect(extra, isEmpty, reason: 'Extra feat definitions');

    expect(defs, ids, reason: 'Feat definitions must follow FeatIds order');

    for (final feat in defs) {
      final start = text.indexOf('FeatIds.$feat: FeatDefinition(');
      final nextStarts = defs
          .map((other) =>
              text.indexOf('\n  FeatIds.$other: FeatDefinition(', start + 1))
          .where((pos) => pos != -1)
          .toList();

      final end = nextStarts.isEmpty
          ? text.indexOf('\n};', start)
          : nextStarts.reduce((a, b) => a < b ? a : b);

      final block = text.substring(start, end);

      expect(block, contains('id: FeatIds.$feat,'));
      expect(block, contains('ownerId: FeatIds.$feat,'));
      expect(block, contains('type: RuleContentType.feat,'));
      expect(block, contains('summary:'));
      expect(block, contains('details:'));
      expect(block, contains('effects: CharacterEffects('));
    }
  });
}
