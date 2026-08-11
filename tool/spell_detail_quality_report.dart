import 'dart:io';

String _stripStringLiterals(String source) {
  final pieces = RegExp(r"'([^']*)'").allMatches(source).map((m) {
    return m.group(1) ?? '';
  }).join(' ');

  return pieces
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(r'\n', ' ')
      .replaceAll(r"\'", "'")
      .trim();
}

void main() {
  final file = File('lib/data/spell_data.dart');
  if (!file.existsSync()) {
    stderr.writeln('ERRORE: lib/data/spell_data.dart non trovato.');
    exit(1);
  }

  final text = file.readAsStringSync();

  final ids = RegExp(
    r"static\s+const\s+(\w+)\s*=\s*'([^']+)';",
  ).allMatches(text).map((m) => m.group(1)!).toList();

  final defs = RegExp(
    r'SpellIds\.(\w+):\s*SpellDefinition\(',
  ).allMatches(text).map((m) => m.group(1)!).toList();

  final errors = <String>[];
  final warnings = <String>[];

  for (final spell in defs) {
    final start = text.indexOf('SpellIds.$spell: SpellDefinition(');
    final nextPositions = defs
        .map((other) =>
            text.indexOf('\n  SpellIds.$other: SpellDefinition(', start + 1))
        .where((pos) => pos != -1)
        .toList();

    final end = nextPositions.isEmpty
        ? text.indexOf('\n};', start)
        : nextPositions.reduce((a, b) => a < b ? a : b);

    if (start == -1 || end == -1) {
      errors.add('$spell: blocco definizione non leggibile');
      continue;
    }

    final block = text.substring(start, end);

    final mandatoryTokens = <String>[
      'id: SpellIds.$spell,',
      'ownerId: SpellIds.$spell,',
      'type: RuleContentType.spell,',
      'summary:',
      'details:',
      'level:',
      'school:',
      'castingTime:',
      'range:',
      'components:',
      'duration:',
      'classIds:',
    ];

    for (final token in mandatoryTokens) {
      if (!block.contains(token)) {
        errors.add('$spell: manca $token');
      }
    }

    final summaryStart = block.indexOf('summary:');
    final detailsStart = block.indexOf('details:');
    final ownerStart = block.indexOf('ownerId:');

    if (summaryStart != -1 &&
        detailsStart != -1 &&
        detailsStart > summaryStart) {
      final summaryText = _stripStringLiterals(
        block.substring(summaryStart, detailsStart),
      );
      if (summaryText.length < 35) {
        warnings.add(
            '$spell: summary molto breve (${summaryText.length} caratteri)');
      }
    }

    if (detailsStart != -1 && ownerStart != -1 && ownerStart > detailsStart) {
      final detailsText = _stripStringLiterals(
        block.substring(detailsStart, ownerStart),
      );

      if (detailsText.length < 180) {
        errors.add(
            '$spell: details troppo breve (${detailsText.length} caratteri)');
      }

      final hasMechanics = [
        'tiro',
        'bersaglio',
        'creatura',
        'danni',
        'durata',
        'azione',
        'effetto',
        'incantesimo',
        'vantaggio',
        'svantaggio',
        'punti ferita',
        'gittata',
        'superare',
      ].any((word) => detailsText.toLowerCase().contains(word));

      if (!hasMechanics) {
        warnings.add('$spell: details forse poco meccanico');
      }
    } else {
      errors.add('$spell: impossibile leggere details');
    }

    final hasRulesRepresentation = block.contains('damage:') ||
        block.contains('healing') ||
        block.contains('persistentEffects:') ||
        block.contains('defensiveEffects:') ||
        block.contains('conditions:') ||
        block.contains('attackType:');

    if (!hasRulesRepresentation) {
      warnings.add('$spell: nessun effetto regolistico strutturato trovato');
    }
  }

  final missing = ids.where((id) => !defs.contains(id)).toList();
  final extra = defs.where((id) => !ids.contains(id)).toList();

  if (missing.isNotEmpty) {
    errors.add('SpellIds senza definizione: ${missing.join(', ')}');
  }

  if (extra.isNotEmpty) {
    errors.add('Definizioni senza SpellIds: ${extra.join(', ')}');
  }

  stdout.writeln('=== SPELL DETAIL QUALITY REPORT ===');
  stdout.writeln('SpellIds: ${ids.length}');
  stdout.writeln('Definitions: ${defs.length}');
  stdout.writeln('Errors: ${errors.length}');
  stdout.writeln('Warnings: ${warnings.length}');

  if (errors.isNotEmpty) {
    stdout.writeln('');
    stdout.writeln('ERRORI');
    for (final error in errors) {
      stdout.writeln('- $error');
    }
  }

  if (warnings.isNotEmpty) {
    stdout.writeln('');
    stdout.writeln('AVVISI');
    for (final warning in warnings) {
      stdout.writeln('- $warning');
    }
  }

  if (errors.isNotEmpty) {
    exit(1);
  }

  stdout.writeln('');
  stdout.writeln('SPELL DETAIL QUALITY VERIFIED');
}
