import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../data/glossary_registry_data.dart';

Future<void> openGlossaryEntryPage(
  BuildContext context,
  GlossaryEntry entry, {
  Map<String, GlossaryEntry>? entries,
}) =>
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GlossaryEntryPage(
          entry: entry,
          entries: entries,
        ),
      ),
    );

class GlossaryLinkedText extends StatefulWidget {
  const GlossaryLinkedText({
    super.key,
    required this.text,
    this.currentEntryId,
    this.entries,
    this.style,
    this.linkStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.onOpenEntry,
  });

  final String text;
  final String? currentEntryId;
  final Map<String, GlossaryEntry>? entries;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final ValueChanged<GlossaryEntry>? onOpenEntry;

  @override
  State<GlossaryLinkedText> createState() => _GlossaryLinkedTextState();
}

class _GlossaryLinkedTextState extends State<GlossaryLinkedText> {
  final List<TapGestureRecognizer> _recognizers = [];

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _openEntry(GlossaryEntry entry) {
    final callback = widget.onOpenEntry;
    if (callback != null) {
      callback(entry);
      return;
    }

    openGlossaryEntryPage(
      context,
      entry,
      entries: widget.entries,
    );
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();

    final definitions = widget.entries ?? universalGlossaryEntries;
    final matches = findGlossaryTextMatches(
      widget.text,
      excludedEntryId: widget.currentEntryId,
      entries: definitions,
    );

    final defaultStyle = widget.style ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();
    final resolvedLinkStyle = defaultStyle.merge(
      widget.linkStyle ??
          TextStyle(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
            decorationColor: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
    );

    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(
            text: widget.text.substring(cursor, match.start),
            style: defaultStyle,
          ),
        );
      }

      final entry = definitions[match.entryId];
      if (entry == null) {
        spans.add(
          TextSpan(
            text: match.text,
            style: defaultStyle,
          ),
        );
      } else {
        final recognizer = TapGestureRecognizer()
          ..onTap = () => _openEntry(entry);
        _recognizers.add(recognizer);

        spans.add(
          TextSpan(
            text: match.text,
            style: resolvedLinkStyle,
            recognizer: recognizer,
            semanticsLabel: '${match.text}, collegamento al glossario',
          ),
        );
      }

      cursor = match.end;
    }

    if (cursor < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(cursor),
          style: defaultStyle,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}

class GlossaryIndexPage extends StatefulWidget {
  const GlossaryIndexPage({
    super.key,
    this.entries,
  });

  final Map<String, GlossaryEntry>? entries;

  @override
  State<GlossaryIndexPage> createState() => _GlossaryIndexPageState();
}

class _GlossaryIndexPageState extends State<GlossaryIndexPage> {
  final TextEditingController _searchController = TextEditingController();
  GlossaryCategory? _selectedCategory;
  String _query = '';

  Map<String, GlossaryEntry> get definitions =>
      widget.entries ?? universalGlossaryEntries;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GlossaryEntry> get results => searchGlossaryEntries(
        _query,
        category: _selectedCategory,
        entries: definitions,
      ).toList();

  Map<String, List<GlossaryEntry>> get alphabeticalGroups {
    final groups = <String, List<GlossaryEntry>>{};

    for (final entry in results) {
      final normalizedName = normalizeGlossaryText(entry.name);
      final letter = normalizedName.isEmpty
          ? '#'
          : normalizedName.substring(0, 1).toUpperCase();

      groups.putIfAbsent(letter, () => []).add(entry);
    }

    return Map.fromEntries(
      groups.entries.toList()
        ..sort((first, second) => first.key.compareTo(second.key)),
    );
  }

  Future<void> _open(GlossaryEntry entry) => openGlossaryEntryPage(
        context,
        entry,
        entries: definitions,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = alphabeticalGroups;
    final searching = _query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossario'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                key: const Key('glossary_search_field'),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cerca nel glossario',
                  hintText: 'Es. vantaggio, CA, tiro salvezza…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Cancella ricerca',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                key: const Key('glossary_category_filters'),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: const Text('Tutte'),
                      selected: _selectedCategory == null,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                  ),
                  ...GlossaryCategory.values.map(
                    (category) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(glossaryCategoryLabel(category)),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${results.length} ${results.length == 1 ? 'voce' : 'voci'}',
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  if (_selectedCategory != null || _query.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                          _selectedCategory = null;
                        });
                      },
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('AZZERA'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: results.isEmpty
                  ? const _EmptyGlossaryResults()
                  : searching
                      ? ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            12,
                            8,
                            12,
                            24,
                          ),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) => _GlossaryResultTile(
                            entry: results[index],
                            onTap: () => _open(results[index]),
                          ),
                        )
                      : ListView(
                          key: const Key('glossary_alphabetical_list'),
                          padding: const EdgeInsets.fromLTRB(
                            8,
                            4,
                            8,
                            24,
                          ),
                          children: groups.entries
                              .map(
                                (group) => Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: ExpansionTile(
                                    key: Key(
                                      'glossary_letter_${group.key}',
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(group.key),
                                    ),
                                    title: Text(
                                      '${group.key} · ${group.value.length}',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    children: group.value
                                        .map(
                                          (entry) => _GlossaryResultTile(
                                            entry: entry,
                                            onTap: () => _open(entry),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGlossaryResults extends StatelessWidget {
  const _EmptyGlossaryResults();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 54,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Nessuna voce trovata',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Prova a cambiare ricerca o categoria.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class _GlossaryResultTile extends StatelessWidget {
  const _GlossaryResultTile({
    required this.entry,
    required this.onTap,
  });

  final GlossaryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        minVerticalPadding: 12,
        leading: const Icon(Icons.menu_book_outlined),
        title: Text(
          entry.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          entry.summary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}

class GlossaryEntryPage extends StatelessWidget {
  const GlossaryEntryPage({
    super.key,
    required this.entry,
    this.entries,
  });

  final GlossaryEntry entry;
  final Map<String, GlossaryEntry>? entries;

  Map<String, GlossaryEntry> get definitions =>
      entries ?? universalGlossaryEntries;

  List<GlossaryEntry> get relatedEntries => entry.allRelatedGlossaryIds
      .where((id) => id != entry.id)
      .map((id) => definitions[id])
      .whereType<GlossaryEntry>()
      .toList()
    ..sort((first, second) => first.name.compareTo(second.name));

  Future<void> _openRelated(
    BuildContext context,
    GlossaryEntry related,
  ) =>
      openGlossaryEntryPage(
        context,
        related,
        entries: definitions,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final related = relatedEntries;
    final externalReferences = entry.references
        .where(
          (reference) => reference.kind != GlossaryReferenceKind.glossary,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossario'),
      ),
      body: SafeArea(
        child: ListView(
          key: const Key('glossary_entry_page'),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text(
              entry.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: const Icon(
                  Icons.sell_outlined,
                  size: 17,
                ),
                label: Text(glossaryCategoryLabel(entry.category)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'REGOLA IN BREVE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GlossaryLinkedText(
                      text: entry.summary,
                      currentEntryId: entry.id,
                      entries: definitions,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (entry.details.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                child: ExpansionTile(
                  key: const Key('glossary_complete_rule_section'),
                  initiallyExpanded: false,
                  leading: const Icon(Icons.gavel_outlined),
                  title: const Text(
                    'Regola completa',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    18,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlossaryLinkedText(
                      text: entry.details,
                      currentEntryId: entry.id,
                      entries: definitions,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ...entry.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  child: ExpansionTile(
                    key: Key(
                      'glossary_section_${section.id}',
                    ),
                    initiallyExpanded: section.initiallyExpanded,
                    leading: Icon(
                      _sectionIcon(section.type),
                    ),
                    title: Text(
                      section.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      18,
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlossaryLinkedText(
                        text: section.content,
                        currentEntryId: entry.id,
                        entries: definitions,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                      ),
                      if (section.numericValues.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: section.numericValues.entries
                              .map(
                                (value) => Chip(
                                  label: Text(
                                    '${value.key}: ${value.value}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (related.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                child: ExpansionTile(
                  key: const Key('glossary_related_section'),
                  leading: const Icon(Icons.hub_outlined),
                  title: Text(
                    'Voci correlate (${related.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  children: related
                      .map(
                        (relatedEntry) => ListTile(
                          leading: const Icon(
                            Icons.menu_book_outlined,
                          ),
                          title: Text(relatedEntry.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openRelated(
                            context,
                            relatedEntry,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            if (externalReferences.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                child: ExpansionTile(
                  key: const Key(
                    'glossary_external_references_section',
                  ),
                  leading: const Icon(Icons.link),
                  title: Text(
                    'Contenuti collegati '
                    '(${externalReferences.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  children: externalReferences
                      .map(
                        (reference) => ListTile(
                          leading: const Icon(
                            Icons.open_in_new,
                          ),
                          title: Text(
                            reference.label.isEmpty
                                ? reference.targetId
                                : reference.label,
                          ),
                          subtitle: Text(
                            reference.kind.name,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            if (entry.sources.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                child: ExpansionTile(
                  key: const Key('glossary_sources_section'),
                  leading: const Icon(Icons.library_books_outlined),
                  title: Text(
                    'Fonti (${entry.sources.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  children: entry.sources
                      .map(
                        (source) => ListTile(
                          leading: const Icon(
                            Icons.book_outlined,
                          ),
                          title: Text(
                            '${source.book} · ${source.edition}',
                          ),
                          subtitle: Text(
                            [
                              source.reference,
                              source.pageLabel,
                              if (source.section != null &&
                                  source.section!.trim().isNotEmpty)
                                source.section!,
                            ].join(' · '),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

IconData _sectionIcon(GlossarySectionType type) {
  switch (type) {
    case GlossarySectionType.completeRule:
      return Icons.gavel_outlined;
    case GlossarySectionType.specialCases:
      return Icons.rule_outlined;
    case GlossarySectionType.example:
      return Icons.lightbulb_outline;
    case GlossarySectionType.procedure:
      return Icons.format_list_numbered;
    case GlossarySectionType.interaction:
      return Icons.hub_outlined;
    case GlossarySectionType.note:
      return Icons.info_outline;
  }
}
