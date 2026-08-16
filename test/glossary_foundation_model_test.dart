import 'package:dnd_character_sheet/data/glossary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('existing glossary entries remain registered', () {
    expect(glossaryEntries, hasLength(23));
    expect(glossaryEntries, hasLength(23));

    for (final entry in glossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
    }

    expect(
      universalGlossaryEntries.length,
      greaterThanOrEqualTo(glossaryEntries.length),
    );
    expect(
      universalGlossaryEntryFor('darkvision')?.name,
      'Scurovisione',
    );
  });

  test('legacy entries remain compatible with the universal model', () {
    final entry = glossaryEntries['darkvision']!;

    expect(entry.id, 'darkvision');
    expect(entry.name, 'Scurovisione');
    expect(entry.category, GlossaryCategory.caratteristica);
    expect(entry.summary, isNotEmpty);
    expect(entry.details, isNotEmpty);
    expect(entry.sections, isNotEmpty);
    expect(entry.sources, isNotEmpty);
    expect(entry.homebrew, isFalse);
    expect(entry.supplemental, isFalse);
    expect(universalGlossaryEntries[entry.id], same(entry));
  });

  test('Italian search ignores case, accents and apostrophe style', () {
    expect(normalizeGlossaryText('  VELOCITÀ  '), 'velocita');
    expect(
      normalizeGlossaryText('Attacco dell’Avversario'),
      "attacco dell'avversario",
    );

    expect(
      searchGlossaryEntries('SCUROVISIONE').map((entry) => entry.id),
      contains('darkvision'),
    );
  });

  test('search supports aliases, tags and additional search terms', () {
    const entries = {
      'armor_class': GlossaryEntry(
        id: 'armor_class',
        name: 'Classe Armatura',
        aliases: {'CA', 'AC'},
        category: GlossaryCategory.combattimento,
        summary: 'Valore difensivo.',
        tags: {'difesa'},
        searchTerms: {'protezione'},
      ),
    };

    expect(
      searchGlossaryEntries('ca', entries: entries).single.id,
      'armor_class',
    );
    expect(
      searchGlossaryEntries('protezione', entries: entries).single.id,
      'armor_class',
    );
    expect(
      searchGlossaryEntries('difesa', entries: entries).single.id,
      'armor_class',
    );
  });

  test('automatic links prefer the longest matching expression', () {
    const entries = {
      'attack': GlossaryEntry(
        id: 'attack',
        name: 'Attacco',
        category: GlossaryCategory.combattimento,
        summary: 'Un attacco.',
      ),
      'attack_roll': GlossaryEntry(
        id: 'attack_roll',
        name: 'Tiro per Colpire',
        aliases: {'attacco con arma'},
        category: GlossaryCategory.combattimento,
        summary: 'Il tiro usato per determinare se un attacco colpisce.',
      ),
      'weapon': GlossaryEntry(
        id: 'weapon',
        name: 'Arma',
        category: GlossaryCategory.equipaggiamento,
        summary: 'Un’arma.',
      ),
    };

    final matches = findGlossaryTextMatches(
      'Effettua un attacco con arma e poi un altro attacco.',
      entries: entries,
    );

    expect(matches, hasLength(2));
    expect(matches.first.text, 'attacco con arma');
    expect(matches.first.entryId, 'attack_roll');
    expect(matches.last.text, 'attacco');
    expect(matches.last.entryId, 'attack');
  });

  test('automatic links respect word boundaries', () {
    const entries = {
      'ki': GlossaryEntry(
        id: 'ki',
        name: 'Ki',
        category: GlossaryCategory.risorsa,
        summary: 'Risorsa del Monaco.',
      ),
    };

    final matches = findGlossaryTextMatches(
      'Il Ki non deve essere trovato dentro la parola kilogrammo.',
      entries: entries,
    );

    expect(matches, hasLength(1));
    expect(matches.single.text, 'Ki');
  });

  test('current entry can be excluded to prevent self-links', () {
    const entries = {
      'advantage': GlossaryEntry(
        id: 'advantage',
        name: 'Vantaggio',
        category: GlossaryCategory.regola,
        summary: 'Tira due d20.',
      ),
    };

    expect(
      findGlossaryTextMatches(
        'Il Vantaggio consente di tirare due d20.',
        entries: entries,
        excludedEntryId: 'advantage',
      ),
      isEmpty,
    );
  });

  test('sections and references expose all related glossary ids', () {
    const entry = GlossaryEntry(
      id: 'grappled',
      name: 'Afferrato',
      category: GlossaryCategory.condizione,
      summary: 'La velocità diventa 0.',
      relatedIds: ['speed'],
      sections: [
        GlossarySectionDefinition(
          id: 'ending',
          title: 'Come termina',
          type: GlossarySectionType.completeRule,
          content: 'Termina quando l’afferratore è incapacitato.',
          relatedIds: ['incapacitated'],
        ),
      ],
      references: [
        GlossaryReferenceDefinition(
          kind: GlossaryReferenceKind.glossary,
          targetId: 'grapple',
          label: 'Lottare',
        ),
        GlossaryReferenceDefinition(
          kind: GlossaryReferenceKind.classFeature,
          targetId: 'escape_grapple',
        ),
      ],
    );

    expect(
      entry.allRelatedGlossaryIds,
      {'speed', 'incapacitated', 'grapple'},
    );
  });

  test('source page labels support single pages and ranges', () {
    const singlePage = GlossarySourceDefinition(
      book: 'Manuale del Giocatore',
      edition: '2014',
      reference: 'Condizioni',
      pageStart: 290,
    );
    const pageRange = GlossarySourceDefinition(
      book: 'Manuale del Giocatore',
      edition: '2014',
      reference: 'Combattimento',
      pageStart: 189,
      pageEnd: 198,
    );

    expect(singlePage.pageLabel, 'p. 290');
    expect(pageRange.pageLabel, 'pp. 189-198');
  });

  test('current registry has no ambiguous link terms', () {
    expect(ambiguousGlossaryLinkTerms, isEmpty);
  });

  test('current registry has no unresolved related ids', () {
    expect(unresolvedGlossaryRelatedIds, isEmpty);
  });
}
