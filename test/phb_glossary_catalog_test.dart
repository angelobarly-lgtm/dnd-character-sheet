import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

String _normalizeTerm(String value) => value
    .toLowerCase()
    .replaceAll('à', 'a')
    .replaceAll('á', 'a')
    .replaceAll('è', 'e')
    .replaceAll('é', 'e')
    .replaceAll('ì', 'i')
    .replaceAll('í', 'i')
    .replaceAll('ò', 'o')
    .replaceAll('ó', 'o')
    .replaceAll('ù', 'u')
    .replaceAll('ú', 'u')
    .replaceAll('’', "'")
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

void main() {
  final sourceMaps = <Map<String, GlossaryEntry>>[
    glossaryEntries,
    phbCoreGlossaryEntries,
    phbConditionActionGlossaryEntries,
    phbSpellcastingGlossaryEntries,
    phbAbilitySkillGlossaryEntries,
    phbAdventuringGlossaryEntries,
    phbEquipmentGlossaryEntries,
    phbCharacterProgressionGlossaryEntries,
    phbAdvancedCombatGlossaryEntries,
  ];

  test('PHB glossary contains exactly 264 unique entries', () {
    expect(glossaryEntries, hasLength(23));
    expect(phbCoreGlossaryEntries, hasLength(31));
    expect(phbConditionActionGlossaryEntries, hasLength(30));
    expect(phbSpellcastingGlossaryEntries, hasLength(30));
    expect(phbAbilitySkillGlossaryEntries, hasLength(30));
    expect(phbAdventuringGlossaryEntries, hasLength(30));
    expect(phbEquipmentGlossaryEntries, hasLength(30));
    expect(phbCharacterProgressionGlossaryEntries, hasLength(30));
    expect(phbAdvancedCombatGlossaryEntries, hasLength(30));

    final allSourceIds = <String>{
      for (final sourceMap in sourceMaps) ...sourceMap.keys,
    };

    expect(allSourceIds, hasLength(264));
    expect(universalGlossaryEntries, hasLength(264));
    expect(universalGlossaryEntries.keys.toSet(), allSourceIds);
  });

  test('every map key matches the identifier stored in its entry', () {
    final mismatches = <String>[];

    for (final sourceMap in sourceMaps) {
      for (final pair in sourceMap.entries) {
        if (pair.key != pair.value.id) {
          mismatches.add('${pair.key}->${pair.value.id}');
        }
      }
    }

    expect(mismatches, isEmpty);
  });

  test('all entries contain usable Italian content', () {
    final invalid = <String>[];

    for (final entry in universalGlossaryEntries.values) {
      if (entry.id.trim().isEmpty ||
          entry.name.trim().isEmpty ||
          entry.summary.trim().isEmpty ||
          entry.details.trim().isEmpty) {
        invalid.add(entry.id);
      }
    }

    expect(invalid, isEmpty);
  });

  test('all PHB entries preserve their manual source', () {
    final invalid = <String>[];

    for (final entry in universalGlossaryEntries.values) {
      if (entry.sources.isEmpty) {
        invalid.add('${entry.id}:nessuna_fonte');
        continue;
      }

      for (final source in entry.sources) {
        if (source.book != 'Manuale del Giocatore' ||
            source.edition != '2014' ||
            source.reference.trim().isEmpty ||
            source.pageStart == null ||
            source.pageEnd == null ||
            source.pageStart! <= 0 ||
            source.pageEnd! < source.pageStart!) {
          invalid.add(entry.id);
          break;
        }
      }
    }

    expect(invalid, isEmpty);
  });

  test('no PHB glossary entry is marked homebrew or supplemental', () {
    final invalid = universalGlossaryEntries.values
        .where((entry) => entry.homebrew || entry.supplemental)
        .map((entry) => entry.id)
        .toList();

    expect(invalid, isEmpty);
  });

  test('all related glossary identifiers resolve', () {
    final unresolved = <String>{};

    for (final entry in universalGlossaryEntries.values) {
      for (final relatedId in entry.allRelatedGlossaryIds) {
        if (!universalGlossaryEntries.containsKey(relatedId)) {
          unresolved.add('${entry.id}->$relatedId');
        }
      }
    }

    expect(unresolved, isEmpty);
  });

  test('names and aliases do not create ambiguous blue links', () {
    final ownersByTerm = <String, Set<String>>{};

    for (final entry in universalGlossaryEntries.values) {
      if (!entry.linkable) {
        continue;
      }

      for (final term in entry.linkTerms) {
        final normalized = _normalizeTerm(term);
        ownersByTerm.putIfAbsent(normalized, () => <String>{}).add(entry.id);
      }
    }

    final ambiguous = <String, Set<String>>{
      for (final pair in ownersByTerm.entries)
        if (pair.value.length > 1) pair.key: pair.value,
    };

    expect(
      ambiguous,
      isEmpty,
      reason: 'Termini collegabili ambigui: $ambiguous',
    );
  });

  test('every linkable entry exposes at least one non-empty term', () {
    final invalid = <String>[];

    for (final entry
        in universalGlossaryEntries.values.where((entry) => entry.linkable)) {
      if (entry.linkTerms.isEmpty ||
          entry.linkTerms.any((term) => term.trim().isEmpty)) {
        invalid.add(entry.id);
      }
    }

    expect(invalid, isEmpty);
  });

  test('longer expressions have priority over shorter expressions', () {
    final terms = <({String term, String id})>[
      for (final entry in universalGlossaryEntries.values)
        if (entry.linkable)
          for (final term in entry.linkTerms) (term: term, id: entry.id),
    ]..sort((a, b) {
        final byLength = b.term.length.compareTo(a.term.length);
        return byLength != 0 ? byLength : a.term.compareTo(b.term);
      });

    final longAttackIndex = terms.indexWhere(
      (item) =>
          item.term == 'Attacchi a Distanza in Mischia' &&
          item.id == 'ranged_attack_close_combat',
    );
    final rangedAttackIndex = terms.indexWhere(
      (item) =>
          item.term == 'Attacchi a Distanza' && item.id == 'ranged_attack',
    );
    final genericAttackIndex = terms.indexWhere(
      (item) => item.term == 'Tiro per Colpire' && item.id == 'attack_roll',
    );

    expect(longAttackIndex, isNonNegative);
    expect(rangedAttackIndex, isNonNegative);
    expect(genericAttackIndex, isNonNegative);
    expect(longAttackIndex, lessThan(rangedAttackIndex));
  });

  test('all glossary categories used by PHB content remain searchable', () {
    final representedCategories =
        universalGlossaryEntries.values.map((entry) => entry.category).toSet();

    expect(
      representedCategories,
      containsAll(<GlossaryCategory>{
        GlossaryCategory.regola,
        GlossaryCategory.condizione,
        GlossaryCategory.risorsa,
        GlossaryCategory.azione,
        GlossaryCategory.caratteristica,
        GlossaryCategory.combattimento,
        GlossaryCategory.equipaggiamento,
      }),
    );
  });

  test('critical mobile glossary terms are present', () {
    expect(
      universalGlossaryEntries.keys,
      containsAll(<String>{
        'ability_check',
        'saving_throw',
        'attack_roll',
        'armor_class',
        'death_saving_throw',
        'short_rest',
        'long_rest',
        'concentration',
        'spell_slots',
        'blinded',
        'charmed',
        'grappled',
        'poisoned',
        'prone',
        'exhaustion',
        'initiative',
        'opportunity_attack',
        'darkvision',
        'damage_resistance',
        'multiclassing',
        'fire_damage',
        'underwater_combat',
      }),
    );
  });
}
