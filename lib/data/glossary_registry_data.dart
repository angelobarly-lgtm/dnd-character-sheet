import 'class_data.dart';
import 'glossary_data.dart';
import 'glossary_core_rules_data.dart';
import 'glossary_conditions_actions_data.dart';
import 'glossary_spellcasting_data.dart';
import 'glossary_abilities_skills_data.dart';
import 'glossary_adventuring_data.dart';
import 'glossary_equipment_data.dart';
import 'glossary_character_progression_data.dart';
import 'glossary_advanced_combat_data.dart';

export 'class_data.dart';
export 'glossary_data.dart';
export 'glossary_core_rules_data.dart';
export 'glossary_conditions_actions_data.dart';
export 'glossary_spellcasting_data.dart';
export 'glossary_abilities_skills_data.dart';
export 'glossary_adventuring_data.dart';
export 'glossary_equipment_data.dart';
export 'glossary_character_progression_data.dart';
export 'glossary_advanced_combat_data.dart';

/// Registro universale del glossario.
///
/// I manuali supplementari aggiungeranno le proprie mappe senza modificare
/// il modello o l’interfaccia mobile.
final Map<String, GlossaryEntry> universalGlossaryEntries = {
  ...glossaryEntries,
  ...phbCoreGlossaryEntries,
  ...phbConditionActionGlossaryEntries,
  ...phbSpellcastingGlossaryEntries,
  ...phbAbilitySkillGlossaryEntries,
  ...phbAdventuringGlossaryEntries,
  ...phbEquipmentGlossaryEntries,
  ...phbCharacterProgressionGlossaryEntries,
  ...phbAdvancedCombatGlossaryEntries,
};

GlossaryEntry? universalGlossaryEntryFor(String id) =>
    universalGlossaryEntries[id];

String normalizeGlossaryText(String value) {
  var normalized = value.toLowerCase().trim();

  const replacements = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ä': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'ö': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    '’': "'",
    '‘': "'",
    'ʼ': "'",
  };

  for (final replacement in replacements.entries) {
    normalized = normalized.replaceAll(
      replacement.key,
      replacement.value,
    );
  }

  return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
}

String _normalizeGlossaryTextPreservingLength(String value) {
  var normalized = value.toLowerCase();

  const replacements = {
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ä': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'ö': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    '’': "'",
    '‘': "'",
    'ʼ': "'",
  };

  for (final replacement in replacements.entries) {
    normalized = normalized.replaceAll(
      replacement.key,
      replacement.value,
    );
  }

  return normalized;
}

String glossaryCategoryLabel(GlossaryCategory category) {
  switch (category) {
    case GlossaryCategory.regola:
      return 'Regole';
    case GlossaryCategory.condizione:
      return 'Condizioni';
    case GlossaryCategory.risorsa:
      return 'Risorse';
    case GlossaryCategory.azione:
      return 'Azioni';
    case GlossaryCategory.caratteristica:
      return 'Caratteristiche';
    case GlossaryCategory.combattimento:
      return 'Combattimento';
    case GlossaryCategory.equipaggiamento:
      return 'Equipaggiamento';
    case GlossaryCategory.altro:
      return 'Altro';
  }
}

Iterable<GlossaryEntry> searchGlossaryEntries(
  String query, {
  GlossaryCategory? category,
  Map<String, GlossaryEntry>? entries,
}) {
  final definitions = entries ?? universalGlossaryEntries;
  final normalizedQuery = normalizeGlossaryText(query);

  final results = definitions.values.where((entry) {
    if (category != null && entry.category != category) {
      return false;
    }

    if (normalizedQuery.isEmpty) return true;

    final searchableValues = <String>{
      entry.id,
      entry.name,
      entry.summary,
      entry.details,
      ...entry.aliases,
      ...entry.searchTerms,
      ...entry.tags,
      ...entry.sections.expand(
        (section) => {
          section.title,
          section.content,
          ...section.tags,
        },
      ),
    };

    return searchableValues.any(
      (value) => normalizeGlossaryText(value).contains(normalizedQuery),
    );
  }).toList()
    ..sort((first, second) {
      final nameComparison = first.name.compareTo(second.name);
      if (nameComparison != 0) return nameComparison;
      return first.id.compareTo(second.id);
    });

  return results;
}

/// Segmento del testo riconosciuto come collegamento al glossario.
class GlossaryTextMatch {
  final int start;
  final int end;
  final String text;
  final String entryId;

  const GlossaryTextMatch({
    required this.start,
    required this.end,
    required this.text,
    required this.entryId,
  });

  int get length => end - start;
}

class _GlossaryLinkCandidate {
  final String normalizedTerm;
  final String entryId;

  const _GlossaryLinkCandidate({
    required this.normalizedTerm,
    required this.entryId,
  });
}

bool _isGlossaryWordCharacter(String character) =>
    RegExp(r"[a-z0-9_']").hasMatch(character);

bool _hasValidGlossaryBoundaries(
  String normalizedText,
  int start,
  int end,
) {
  final beforeIsWord = start > 0 &&
      _isGlossaryWordCharacter(normalizedText.substring(start - 1, start));
  final afterIsWord = end < normalizedText.length &&
      _isGlossaryWordCharacter(normalizedText.substring(end, end + 1));

  return !beforeIsWord && !afterIsWord;
}

List<_GlossaryLinkCandidate> _glossaryLinkCandidates(
  Map<String, GlossaryEntry> entries, {
  String? excludedEntryId,
}) {
  final byNormalizedTerm = <String, String>{};

  final orderedEntries = entries.values.toList()
    ..sort((first, second) => first.id.compareTo(second.id));

  for (final entry in orderedEntries) {
    if (!entry.linkable || entry.id == excludedEntryId) continue;

    for (final term in entry.linkTerms) {
      final normalized = normalizeGlossaryText(term);

      if (normalized.length < 2) continue;
      byNormalizedTerm.putIfAbsent(normalized, () => entry.id);
    }
  }

  final candidates = byNormalizedTerm.entries
      .map(
        (entry) => _GlossaryLinkCandidate(
          normalizedTerm: entry.key,
          entryId: entry.value,
        ),
      )
      .toList()
    ..sort((first, second) {
      final lengthComparison = second.normalizedTerm.length.compareTo(
        first.normalizedTerm.length,
      );
      if (lengthComparison != 0) return lengthComparison;
      return first.normalizedTerm.compareTo(second.normalizedTerm);
    });

  return candidates;
}

/// Individua automaticamente nomi e alias presenti nel testo.
///
/// In caso di sovrapposizione viene sempre preferita l’espressione più lunga.
List<GlossaryTextMatch> findGlossaryTextMatches(
  String text, {
  String? excludedEntryId,
  Map<String, GlossaryEntry>? entries,
}) {
  if (text.isEmpty) return const [];

  final definitions = entries ?? universalGlossaryEntries;
  final normalizedText = _normalizeGlossaryTextPreservingLength(text);
  final candidates = _glossaryLinkCandidates(
    definitions,
    excludedEntryId: excludedEntryId,
  );

  final matches = <GlossaryTextMatch>[];
  var cursor = 0;

  while (cursor < normalizedText.length) {
    _GlossaryLinkCandidate? selected;

    for (final candidate in candidates) {
      final end = cursor + candidate.normalizedTerm.length;
      if (end > normalizedText.length) continue;

      if (normalizedText.substring(cursor, end) != candidate.normalizedTerm) {
        continue;
      }

      if (!_hasValidGlossaryBoundaries(normalizedText, cursor, end)) {
        continue;
      }

      selected = candidate;
      break;
    }

    if (selected == null) {
      cursor++;
      continue;
    }

    final end = cursor + selected.normalizedTerm.length;
    matches.add(
      GlossaryTextMatch(
        start: cursor,
        end: end,
        text: text.substring(cursor, end),
        entryId: selected.entryId,
      ),
    );
    cursor = end;
  }

  return matches;
}

Set<String> get unresolvedGlossaryRelatedIds {
  final availableIds = universalGlossaryEntries.keys.toSet();
  final referencedIds = universalGlossaryEntries.values
      .expand((entry) => entry.allRelatedGlossaryIds)
      .toSet();

  return referencedIds.difference(availableIds);
}

/// Termini che rimanderebbero a più voci diverse.
///
/// Il nome viene normalizzato, quindi accenti e apostrofi tipografici
/// non creano falsi duplicati.
Map<String, Set<String>> get ambiguousGlossaryLinkTerms {
  final ownersByTerm = <String, Set<String>>{};

  for (final entry in universalGlossaryEntries.values) {
    if (!entry.linkable) continue;

    for (final term in entry.linkTerms) {
      final normalized = normalizeGlossaryText(term);
      if (normalized.length < 2) continue;

      ownersByTerm.putIfAbsent(normalized, () => <String>{}).add(entry.id);
    }
  }

  return Map.fromEntries(
    ownersByTerm.entries.where((entry) => entry.value.length > 1),
  );
}
