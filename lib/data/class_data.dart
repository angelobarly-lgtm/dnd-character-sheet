enum GlossaryCategory {
  regola,
  condizione,
  risorsa,
  azione,
  caratteristica,
  combattimento,
  equipaggiamento,
  altro,
}

class GlossaryRef {
  final String id;
  final String label;

  const GlossaryRef(this.id, this.label);
}

class RuleDescription {
  final String summary;
  final String details;
  final List<GlossaryRef> glossaryRefs;

  const RuleDescription({
    required this.summary,
    this.details = '',
    this.glossaryRefs = const [],
  });
}

/// Categoria generale di un contenuto regolamentare.
///
/// Non determina come funziona la regola: serve a identificare
/// e presentare uniformemente contenuti provenienti da sistemi diversi.
enum RuleContentType {
  classFeature,
  subclassFeature,
  subclassOption,
  race,
  subrace,
  racialTrait,
  background,
  feat,
  skill,
  action,
  spell,
  equipment,
  weapon,
  armor,
  resource,
  other,
}

/// Metadato descrittivo associato a un contenuto.
///
/// Esempi:
/// - Livello minimo: 3
/// - Caratteristica: DES
/// - Costo: 2 Ki
/// - Danno: 1d6 perforante
///
/// I metadati descrivono il contenuto ma non implementano
/// direttamente la sua meccanica.
class RuleMetadata {
  final String id;
  final String label;
  final String value;

  const RuleMetadata({
    required this.id,
    required this.label,
    required this.value,
  });
}

/// Identità editoriale opzionale di un contenuto.
class RuleSource {
  final String name;
  final String reference;

  const RuleSource({
    this.name = '',
    this.reference = '',
  });

  bool get isEmpty => name.trim().isEmpty && reference.trim().isEmpty;
}

/// Famiglia visuale utilizzata dall'interfaccia.
///
/// La famiglia determina l'aspetto generale dell'elemento.
/// Il singolo contenuto specifica invece [RuleVisualIdentity.iconId].
enum RuleVisualFamily {
  classType,
  race,
  background,
  feat,
  ability,
  skill,
  action,
  weapon,
  armor,
  equipment,
  resource,
  spell,
  other,
}

/// Scuola di magia utilizzata esclusivamente per la variante
/// cromatica degli incantesimi.
///
/// Rimane null per tutti i contenuti che non sono incantesimi
/// o per quelli per cui la scuola non è stata ancora definita.
enum SpellVisualSchool {
  abjuration,
  conjuration,
  divination,
  enchantment,
  evocation,
  illusion,
  necromancy,
  transmutation,
}

/// Identità grafica semantica di un contenuto.
///
/// Non contiene colori, widget Flutter o percorsi di file:
/// questi vengono risolti dal tema visuale dell'app.
///
/// Esempi di iconId:
/// - monk
/// - dwarf
/// - dagger
/// - flurry_of_blows
/// - ki
///
/// Se l'asset specifico non esiste, l'interfaccia usa
/// automaticamente l'icona fallback della famiglia.
class RuleVisualIdentity {
  final RuleVisualFamily family;

  /// ID stabile dell'illustrazione specifica.
  final String iconId;

  /// Variante opzionale per gli incantesimi.
  final SpellVisualSchool? spellSchool;

  const RuleVisualIdentity({
    required this.family,
    this.iconId = '',
    this.spellSchool,
  });
}

/// Rappresentazione universale di un contenuto dell'app.
///
/// Può descrivere una capacità di classe, un tratto razziale,
/// un background, un talento, un'abilità, un incantesimo,
/// un oggetto o qualsiasi altro elemento regolamentare.
///
/// Questo modello contiene identità e presentazione.
/// Le meccaniche runtime restano nei rispettivi sistemi.
class RuleContent {
  final String id;
  final String name;
  final RuleContentType type;
  final RuleDescription description;
  final List<RuleMetadata> metadata;
  final RuleSource source;

  /// Identità visuale opzionale.
  ///
  /// Se assente, l'interfaccia può dedurre una famiglia fallback
  /// da [type].
  final RuleVisualIdentity? visual;

  /// Identificatore opzionale dell'elemento proprietario.
  ///
  /// Esempi:
  /// monk
  /// way_of_the_four_elements
  /// dwarf
  /// acolyte
  final String ownerId;

  const RuleContent({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.metadata = const [],
    this.source = const RuleSource(),
    this.visual,
    this.ownerId = '',
  });
}

/// Tipo di sezione mostrata nella pagina mobile di una voce.
enum GlossarySectionType {
  completeRule,
  specialCases,
  example,
  procedure,
  interaction,
  note,
}

/// Blocco richiudibile della pagina mobile del glossario.
class GlossarySectionDefinition {
  final String id;
  final String title;
  final GlossarySectionType type;
  final String content;
  final bool initiallyExpanded;
  final Map<String, num> numericValues;
  final Set<String> tags;
  final List<String> relatedIds;

  const GlossarySectionDefinition({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    this.initiallyExpanded = false,
    this.numericValues = const {},
    this.tags = const {},
    this.relatedIds = const [],
  });
}

/// Provenienza editoriale di una voce del glossario.
class GlossarySourceDefinition {
  final String book;
  final String edition;
  final String reference;
  final int? pageStart;
  final int? pageEnd;
  final String? section;

  const GlossarySourceDefinition({
    required this.book,
    required this.edition,
    required this.reference,
    this.pageStart,
    this.pageEnd,
    this.section,
  })  : assert(pageStart == null || pageStart > 0),
        assert(pageEnd == null || pageEnd > 0),
        assert(
          pageStart == null || pageEnd == null || pageEnd >= pageStart,
        );

  String get pageLabel {
    if (pageStart == null) return reference;
    if (pageEnd == null || pageEnd == pageStart) {
      return 'p. $pageStart';
    }
    return 'pp. $pageStart-$pageEnd';
  }
}

/// Tipo di contenuto esterno collegato a una voce del glossario.
enum GlossaryReferenceKind {
  glossary,
  classDefinition,
  subclass,
  classFeature,
  race,
  racialTrait,
  background,
  feat,
  spell,
  equipment,
  weapon,
  armor,
  creature,
  damageType,
  condition,
  rule,
}

/// Collegamento dal glossario a un altro catalogo dell’app.
class GlossaryReferenceDefinition {
  final GlossaryReferenceKind kind;
  final String targetId;
  final String label;

  const GlossaryReferenceDefinition({
    required this.kind,
    required this.targetId,
    this.label = '',
  });
}

/// Voce universale del glossario.
///
/// [summary] è la spiegazione breve sempre visibile sul telefono.
/// [sections] contiene i dettagli presentati tramite sezioni a tendina.
class GlossaryEntry {
  final String id;
  final String name;
  final Set<String> aliases;
  final GlossaryCategory category;
  final String summary;
  final String details;
  final List<GlossarySectionDefinition> sections;
  final List<String> relatedIds;
  final List<GlossaryReferenceDefinition> references;
  final List<GlossarySourceDefinition> sources;
  final Set<String> tags;
  final Set<String> searchTerms;
  final bool linkable;
  final bool homebrew;
  final bool supplemental;

  const GlossaryEntry({
    required this.id,
    required this.name,
    this.aliases = const {},
    required this.category,
    required this.summary,
    this.details = '',
    this.sections = const [],
    this.relatedIds = const [],
    this.references = const [],
    this.sources = const [],
    this.tags = const {},
    this.searchTerms = const {},
    this.linkable = true,
    this.homebrew = false,
    this.supplemental = false,
  });

  Set<String> get linkTerms => {
        name,
        ...aliases,
      };

  Set<String> get allRelatedGlossaryIds => {
        ...relatedIds,
        ...sections.expand((section) => section.relatedIds),
        ...references
            .where(
              (reference) => reference.kind == GlossaryReferenceKind.glossary,
            )
            .map((reference) => reference.targetId),
      };
}

/// Registry globale del glossario.
///
/// Tutti i sistemi dell'app possono riferirsi alle stesse voci tramite
/// GlossaryRef.id: classi, razze, background, talenti, abilità,
/// incantesimi, equipaggiamento e qualsiasi contenuto futuro.
///
/// Il dataset verrà popolato progressivamente senza modificare
/// il sistema di visualizzazione.

class ClassDefinition {
  final String id;
  final String name;
  final int hitDie;
  final Set<String> savingThrows;
  final Map<int, List<String>> featuresByLevel;
  final Map<String, RuleDescription> featureDescriptions;
  final Map<String, SubclassDefinition> subclasses;

  const ClassDefinition({
    required this.id,
    required this.name,
    required this.hitDie,
    required this.savingThrows,
    required this.featuresByLevel,
    this.featureDescriptions = const {},
    this.subclasses = const {},
  });
}

class SubclassOptionDefinition {
  final String id;
  final String name;
  final String category;
  final RuleDescription description;

  /// Livello minimo del personaggio richiesto per scegliere l'opzione.
  final int minimumLevel;

  /// Costo base dell'opzione, se applicabile.
  /// Il significato è determinato da [resource].
  final int? cost;

  /// Costo massimo selezionabile, se l'opzione permette di
  /// aumentare volontariamente la spesa della risorsa.
  ///
  /// Se null, [cost] rappresenta un costo fisso.
  final int? maximumCost;

  /// Indica se l'opzione permette di spendere volontariamente
  /// una quantità di risorsa superiore al costo base.
  ///
  /// L'eventuale limite effettivo può dipendere dalle regole
  /// della classe, dal livello o da [maximumCost].
  final bool allowsAdditionalResource;

  /// ID stabile della risorsa consumata, per esempio "ki".
  /// Rimane null per opzioni senza costo.
  final String? resource;

  /// ID dell'incantesimo collegato all'opzione, quando presente.
  ///
  /// Permette all'interfaccia e al motore delle regole di risolvere
  /// direttamente l'incantesimo senza dipendere dal testo descrittivo.
  final String? spellId;

  /// Incantesimi sempre preparati concessi dall’opzione ai vari livelli.
  ///
  /// Serve, per esempio, per gli otto ambienti del Circolo della Terra.
  final Map<int, Set<String>> alwaysPreparedSpellIdsByLevel;

  /// Manuale o altra fonte editoriale dell'opzione.
  final String source;

  /// Riferimento interno alla fonte.
  final String sourceRef;

  /// True se l'opzione viene ottenuta automaticamente e non
  /// occupa uno degli slot di scelta del personaggio.
  final bool grantedAutomatically;

  const SubclassOptionDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.minimumLevel = 1,
    this.cost,
    this.maximumCost,
    this.allowsAdditionalResource = false,
    this.resource,
    this.spellId,
    this.alwaysPreparedSpellIdsByLevel = const {},
    this.source = '',
    this.sourceRef = '',
    this.grantedAutomatically = false,
  });

  Set<String> alwaysPreparedSpellIdsAtLevel(int level) {
    final result = <String>{};

    for (final entry in alwaysPreparedSpellIdsByLevel.entries) {
      if (entry.key <= level) {
        result.addAll(entry.value);
      }
    }

    return Set<String>.unmodifiable(result);
  }
}

class SubclassOptionProgression {
  /// Numero totale di opzioni conosciute/selezionabili
  /// al raggiungimento di ciascun livello.
  final Map<int, int> selectionsByLevel;

  /// Livelli ai quali, quando si ottiene una nuova opzione,
  /// il sistema consente anche di sostituirne una già scelta.
  final Set<int> replacementLevels;

  const SubclassOptionProgression({
    required this.selectionsByLevel,
    this.replacementLevels = const {},
  });

  int selectionsAtLevel(int level) {
    var result = 0;

    for (final entry in selectionsByLevel.entries) {
      if (entry.key <= level && entry.value > result) {
        result = entry.value;
      }
    }

    return result;
  }

  bool canReplaceAtLevel(int level) => replacementLevels.contains(level);
}

class SubclassDefinition {
  final String name;
  final String description;

  /// Manuale o altra fonte editoriale della sottoclasse.
  final String source;

  /// Riferimento interno alla fonte, utilizzabile in futuro dalla UI.
  /// Può rimanere vuoto finché il riferimento non viene verificato.
  final String sourceRef;

  final Map<int, List<String>> featuresByLevel;
  final Map<String, RuleDescription> featureDescriptions;

  /// Opzioni selezionabili appartenenti alla sottoclasse.
  ///
  /// Esempi: discipline elementali, manovre, invocazioni
  /// o altri sistemi equivalenti.
  final List<SubclassOptionDefinition> options;

  /// Regole di progressione per le opzioni selezionabili.
  /// Rimane null per le sottoclassi che non usano questo sistema.
  final SubclassOptionProgression? optionProgression;

  const SubclassDefinition({
    required this.name,
    required this.description,
    this.source = '',
    this.sourceRef = '',
    required this.featuresByLevel,
    this.featureDescriptions = const {},
    this.options = const [],
    this.optionProgression,
  });
}

const monkClass =
    ClassDefinition(id: 'monk', name: 'Monaco', hitDie: 8, savingThrows: {
  'FOR',
  'DES'
}, featuresByLevel: {
  1: ['Difesa Senza Armatura', 'Arti Marziali'],
  2: ['Ki', 'Movimento Senza Armatura'],
  3: ['Deviare Proiettili'],
  4: ['Caduta Lenta', 'Aumento dei Punteggi di Caratteristica'],
  5: ['Attacco Extra', 'Colpo Stordente'],
  6: ['Colpi Ki Potenziati'],
  7: ['Elusione', 'Mente Lucida'],
  8: ['Aumento dei Punteggi di Caratteristica'],
  9: ['Miglioramento del Movimento Senza Armatura'],
  10: ['Purezza del Corpo'],
  12: ['Aumento dei Punteggi di Caratteristica'],
  13: ['Lingua del Sole e della Luna'],
  14: ['Anima Adamantina'],
  15: ['Corpo Senza Tempo'],
  16: ['Aumento dei Punteggi di Caratteristica'],
  18: ['Corpo Vuoto'],
  19: ['Aumento dei Punteggi di Caratteristica'],
  20: ['Perfezione Interiore'],
}, featureDescriptions: {
  'Aumento dei Punteggi di Caratteristica': RuleDescription(
    summary:
        'La progressione del personaggio permette di migliorare i propri punteggi di caratteristica secondo le regole previste.',
    details:
        'Quando il Monaco raggiunge i livelli appropriati può applicare l’aumento dei punteggi di caratteristica previsto dalla progressione della classe, rispettando i limiti e le opzioni consentite.',
    glossaryRefs: [
      GlossaryRef('punteggio_caratteristica', 'Punteggio di caratteristica'),
      GlossaryRef('caratteristica', 'Caratteristica'),
    ],
  ),
  'Colpi Ki Potenziati': RuleDescription(
    summary:
        'La padronanza del Ki rende gli attacchi senz’armi del Monaco capaci di superare determinate resistenze.',
    details:
        'Da questo punto della progressione, gli attacchi senz’armi del Monaco vengono considerati secondo le proprietà previste dalla capacità quando si determinano resistenze e immunità ai relativi danni.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
      GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
      GlossaryRef('resistenza', 'Resistenza'),
      GlossaryRef('immunita', 'Immunità'),
      GlossaryRef('danno', 'Danno'),
    ],
  ),
  'Lingua del Sole e della Luna': RuleDescription(
    summary:
        'La disciplina del Monaco gli permette di superare le normali barriere linguistiche.',
    details:
        'Questa capacità avanzata modifica il modo in cui il Monaco comunica e comprende le creature, secondo le condizioni previste dalla capacità.',
    glossaryRefs: [
      GlossaryRef('linguaggio', 'Linguaggio'),
      GlossaryRef('comunicazione', 'Comunicazione'),
    ],
  ),
  'Miglioramento del Movimento Senza Armatura': RuleDescription(
    summary:
        'La mobilità soprannaturale del Monaco amplia ulteriormente le possibilità offerte dal Movimento Senza Armatura.',
    details:
        'La capacità estende il Movimento Senza Armatura consentendo forme di movimento aggiuntive nelle condizioni previste, mantenendo i requisiti della capacità di base.',
    glossaryRefs: [
      GlossaryRef('movimento_senza_armatura', 'Movimento Senza Armatura'),
      GlossaryRef('movimento', 'Movimento'),
      GlossaryRef('velocita', 'Velocità'),
      GlossaryRef('armatura', 'Armatura'),
    ],
  ),
  'Difesa Senza Armatura': RuleDescription(
    summary:
        'Quando combatte senza armatura, il Monaco può affidarsi alla propria agilità e disciplina per difendersi.',
    details:
        'La capacità rappresenta la difesa naturale del Monaco quando non utilizza un’armatura. Il calcolo della CA dipende dalle caratteristiche previste dalla capacità e dalle condizioni in cui essa può essere utilizzata.',
    glossaryRefs: [
      GlossaryRef('ca', 'Classe Armatura'),
      GlossaryRef('armatura', 'Armatura'),
      GlossaryRef('destrezza', 'Destrezza'),
      GlossaryRef('saggezza', 'Saggezza'),
    ],
  ),
  'Arti Marziali': RuleDescription(
    summary:
        'Il Monaco utilizza addestramento e tecnica per combattere efficacemente senz’armi e con le proprie armi monastiche.',
    details:
        'Questa capacità modifica il modo in cui il Monaco può effettuare determinati attacchi e ne accompagna la progressione marziale. Le proprietà applicabili dipendono dal livello e dalle condizioni previste dalla capacità.',
    glossaryRefs: [
      GlossaryRef('attacco', 'Attacco'),
      GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
      GlossaryRef('arma', 'Arma'),
      GlossaryRef('danno', 'Danno'),
    ],
  ),
  'Ki': RuleDescription(
    summary:
        'Il Monaco dispone di una riserva di Ki che può spendere per utilizzare tecniche speciali.',
    details:
        'Il Ki è una risorsa della classe Monaco. Le capacità che lo utilizzano specificano il costo e l’effetto prodotto. La quantità disponibile e le modalità di recupero dipendono dalla progressione della classe.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
      GlossaryRef('risorsa', 'Risorsa'),
      GlossaryRef('riposo', 'Riposo'),
    ],
  ),
  'Movimento Senza Armatura': RuleDescription(
    summary:
        'La mobilità del Monaco aumenta mentre combatte senza l’impedimento dell’armatura.',
    details:
        'La capacità migliora la mobilità del personaggio secondo la progressione del Monaco e richiede il rispetto delle condizioni previste per il suo utilizzo.',
    glossaryRefs: [
      GlossaryRef('velocita', 'Velocità'),
      GlossaryRef('movimento', 'Movimento'),
      GlossaryRef('armatura', 'Armatura'),
    ],
  ),
  'Deviare Proiettili': RuleDescription(
    summary:
        'Il Monaco può reagire a determinati attacchi a distanza tentando di ridurne l’efficacia.',
    details:
        'Questa capacità utilizza la reazione del personaggio quando vengono soddisfatte le condizioni previste. Il risultato dipende dalle regole della capacità e può interagire con ulteriori opzioni del Monaco.',
    glossaryRefs: [
      GlossaryRef('reazione', 'Reazione'),
      GlossaryRef('attacco_distanza', 'Attacco a distanza'),
      GlossaryRef('danno', 'Danno'),
    ],
  ),
  'Caduta Lenta': RuleDescription(
    summary:
        'Il Monaco può sfruttare il proprio addestramento per ridurre le conseguenze di una caduta.',
    details:
        'Quando si verificano le condizioni previste dalla capacità, il Monaco può mitigare i danni derivanti da una caduta.',
    glossaryRefs: [
      GlossaryRef('caduta', 'Caduta'),
      GlossaryRef('danno', 'Danno'),
      GlossaryRef('reazione', 'Reazione'),
    ],
  ),
  'Attacco Extra': RuleDescription(
    summary:
        'L’addestramento marziale permette al Monaco di effettuare più attacchi durante la propria azione di Attacco.',
    details:
        'Questa capacità modifica il numero di attacchi che il personaggio può effettuare quando utilizza l’azione di Attacco, secondo la progressione prevista dalla classe.',
    glossaryRefs: [
      GlossaryRef('azione', 'Azione'),
      GlossaryRef('azione_attacco', 'Azione di Attacco'),
      GlossaryRef('attacco', 'Attacco'),
    ],
  ),
  'Colpo Stordente': RuleDescription(
    summary:
        'Il Monaco può incanalare il Ki in un colpo nel tentativo di lasciare temporaneamente il bersaglio stordito.',
    details:
        'La capacità combina un attacco con l’utilizzo del Ki e può richiedere al bersaglio di superare un tiro salvezza. In caso di fallimento viene applicata la condizione prevista dalla capacità per la durata indicata.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
      GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
      GlossaryRef('stordito', 'Stordito'),
      GlossaryRef('condizione', 'Condizione'),
    ],
  ),
  'Elusione': RuleDescription(
    summary:
        'La straordinaria agilità del Monaco gli permette di evitare o mitigare alcuni effetti ad area.',
    details:
        'La capacità modifica le conseguenze di determinati effetti che richiedono un tiro salvezza appropriato, secondo le condizioni previste dalla regola.',
    glossaryRefs: [
      GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
      GlossaryRef('destrezza', 'Destrezza'),
      GlossaryRef('danno', 'Danno'),
    ],
  ),
  'Mente Lucida': RuleDescription(
    summary:
        'La disciplina mentale permette al Monaco di liberarsi da determinati effetti che alterano il controllo delle proprie azioni.',
    details:
        'La capacità consente al Monaco di contrastare specifiche condizioni quando ne soddisfa i requisiti di utilizzo.',
    glossaryRefs: [
      GlossaryRef('azione', 'Azione'),
      GlossaryRef('affascinato', 'Affascinato'),
      GlossaryRef('spaventato', 'Spaventato'),
      GlossaryRef('condizione', 'Condizione'),
    ],
  ),
  'Purezza del Corpo': RuleDescription(
    summary:
        'Il controllo del proprio corpo rende il Monaco resistente a specifiche minacce fisiche.',
    details:
        'Questa capacità rappresenta una forma avanzata di disciplina corporea e applica le immunità o protezioni previste dalla progressione della classe.',
    glossaryRefs: [
      GlossaryRef('immunita', 'Immunità'),
      GlossaryRef('malattia', 'Malattia'),
      GlossaryRef('veleno', 'Veleno'),
    ],
  ),
  'Anima Adamantina': RuleDescription(
    summary:
        'La disciplina del Monaco rafforza profondamente la sua capacità di resistere agli effetti avversi.',
    details:
        'Questa capacità migliora le difese del personaggio nei tiri salvezza secondo le regole previste dalla progressione del Monaco.',
    glossaryRefs: [
      GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
      GlossaryRef('competenza', 'Competenza'),
    ],
  ),
  'Corpo Senza Tempo': RuleDescription(
    summary:
        'La padronanza del Ki altera il rapporto del Monaco con gli effetti dell’età e con alcuni bisogni fisici.',
    details:
        'Questa capacità rappresenta uno degli effetti della disciplina monastica avanzata sul corpo del personaggio.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
    ],
  ),
  'Corpo Vuoto': RuleDescription(
    summary:
        'Il Monaco raggiunge un livello di controllo del Ki capace di produrre effetti difensivi e mistici eccezionali.',
    details:
        'Questa capacità avanzata utilizza il Ki e applica gli effetti previsti dalla progressione della classe per la durata indicata.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
      GlossaryRef('invisibile', 'Invisibile'),
      GlossaryRef('resistenza', 'Resistenza'),
    ],
  ),
  'Perfezione Interiore': RuleDescription(
    summary:
        'Al culmine della propria disciplina, il Monaco possiede un legame eccezionale con la propria riserva di Ki.',
    details:
        'La capacità di livello massimo interviene sulla disponibilità della risorsa Ki nelle circostanze previste dalla regola.',
    glossaryRefs: [
      GlossaryRef('ki', 'Ki'),
      GlossaryRef('risorsa', 'Risorsa'),
    ],
  ),
}, subclasses: {
  'Via della Mano Aperta': SubclassDefinition(
    name: 'Via della Mano Aperta',
    description:
        'Una tradizione focalizzata sulla padronanza delle arti marziali e sul controllo del combattimento senz’armi.',
    source: 'Manuale del Giocatore',
    sourceRef: 'PHB',
    featuresByLevel: {
      3: ['Tecnica della Mano Aperta'],
      6: ['Integrità del Corpo'],
      11: ['Tranquillità'],
      17: ['Palmo Tremante'],
    },
    featureDescriptions: {
      'Tecnica della Mano Aperta': RuleDescription(
        summary:
            'La Raffica di Colpi permette al Monaco di accompagnare i propri colpi con effetti di controllo.',
        details:
            'Dal 3° livello, quando colpisce una creatura con uno degli attacchi concessi da Raffica di Colpi, il Monaco può applicare uno degli effetti previsti dalla capacità: sbilanciare il bersaglio, spostarlo oppure impedirgli temporaneamente di effettuare reazioni.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('raffica_di_colpi', 'Raffica di Colpi'),
          GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
          GlossaryRef('prono', 'Prono'),
          GlossaryRef('reazione', 'Reazione'),
        ],
      ),
      'Integrità del Corpo': RuleDescription(
        summary:
            'Il Monaco può utilizzare la propria disciplina per recuperare punti ferita.',
        details:
            'Dal 6° livello, il Monaco può usare un’azione per recuperare punti ferita in quantità determinata dal proprio livello da Monaco. Dopo aver utilizzato questa capacità deve completare un riposo lungo prima di poterla usare nuovamente.',
        glossaryRefs: [
          GlossaryRef('azione', 'Azione'),
          GlossaryRef('punti_ferita', 'Punti Ferita'),
          GlossaryRef('riposo_lungo', 'Riposo lungo'),
        ],
      ),
      'Tranquillità': RuleDescription(
        summary:
            'La quiete interiore del Monaco rende più difficile rivolgere direttamente la violenza contro di lui.',
        details:
            'Dall’11° livello, al termine di un riposo lungo il Monaco ottiene la protezione prevista dalla capacità. L’effetto permane finché non termina secondo le condizioni indicate dalla regola o fino al successivo riposo lungo.',
        glossaryRefs: [
          GlossaryRef('riposo_lungo', 'Riposo lungo'),
          GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
          GlossaryRef('incantesimo', 'Incantesimo'),
        ],
      ),
      'Palmo Tremante': RuleDescription(
        summary:
            'Il Monaco può imprimere nel corpo di una creatura vibrazioni di Ki potenzialmente letali.',
        details:
            'Dal 17° livello, dopo aver colpito una creatura con un colpo senz’armi, il Monaco può spendere Ki per imprimere vibrazioni che rimangono nel bersaglio per la durata prevista. Successivamente può usare un’azione per terminarle, costringendo il bersaglio a subire l’effetto previsto dalla capacità in base al risultato del tiro salvezza.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
          GlossaryRef('azione', 'Azione'),
          GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
          GlossaryRef('costituzione', 'Costituzione'),
          GlossaryRef('danno_necrotico', 'Danno necrotico'),
          GlossaryRef('punti_ferita', 'Punti Ferita'),
        ],
      ),
    },
  ),
  'Via dell’Ombra': SubclassDefinition(
    name: 'Via dell’Ombra',
    description:
        'Una tradizione che combina disciplina monastica, furtività e tecniche soprannaturali legate all’ombra.',
    source: 'Manuale del Giocatore',
    sourceRef: 'PHB',
    featuresByLevel: {
      3: ['Arti dell’Ombra'],
      6: ['Passo d’Ombra'],
      11: ['Manto d’Ombra'],
      17: ['Opportunista'],
    },
    featureDescriptions: {
      'Arti dell’Ombra': RuleDescription(
        summary:
            'Il Monaco usa il Ki per produrre effetti soprannaturali legati all’ombra, al silenzio e alla furtività.',
        details:
            'Dal 3° livello, il Monaco apprende tecniche magiche proprie della tradizione e può spendere Ki per produrre gli effetti previsti dalla capacità. Saggezza è la caratteristica associata alle capacità magiche della tradizione.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('incantesimo', 'Incantesimo'),
          GlossaryRef('saggezza', 'Saggezza'),
          GlossaryRef('oscurita', 'Oscurità'),
          GlossaryRef('silenzio', 'Silenzio'),
          GlossaryRef('furtivita', 'Furtività'),
        ],
      ),
      'Passo d’Ombra': RuleDescription(
        summary:
            'Il Monaco può spostarsi istantaneamente tra zone immerse nell’ombra.',
        details:
            'Dal 6° livello, quando si trova nelle condizioni di illuminazione previste dalla capacità, il Monaco può usare un’azione bonus per teletrasportarsi in uno spazio idoneo che possa vedere. Questo movimento favorisce inoltre il primo attacco in mischia successivo effettuato nel turno.',
        glossaryRefs: [
          GlossaryRef('azione_bonus', 'Azione bonus'),
          GlossaryRef('teletrasporto', 'Teletrasporto'),
          GlossaryRef('luce_fioca', 'Luce fioca'),
          GlossaryRef('oscurita', 'Oscurità'),
          GlossaryRef('vantaggio', 'Vantaggio'),
          GlossaryRef('attacco_mischia', 'Attacco in mischia'),
        ],
      ),
      'Manto d’Ombra': RuleDescription(
        summary:
            'Il Monaco può confondersi con le ombre fino a scomparire alla vista.',
        details:
            'Dall’11° livello, quando si trova nelle condizioni di illuminazione richieste, il Monaco può usare un’azione per diventare invisibile. L’effetto termina quando si verifica una delle condizioni previste dalla capacità.',
        glossaryRefs: [
          GlossaryRef('azione', 'Azione'),
          GlossaryRef('invisibile', 'Invisibile'),
          GlossaryRef('luce_fioca', 'Luce fioca'),
          GlossaryRef('oscurita', 'Oscurità'),
          GlossaryRef('attacco', 'Attacco'),
          GlossaryRef('incantesimo', 'Incantesimo'),
        ],
      ),
      'Opportunista': RuleDescription(
        summary:
            'Il Monaco sfrutta immediatamente un’apertura creata dall’attacco di un’altra creatura.',
        details:
            'Dal 17° livello, quando una creatura vicina viene colpita da un attacco effettuato da qualcun altro, il Monaco può usare la propria reazione per effettuare un attacco in mischia contro quella creatura, rispettando le condizioni della capacità.',
        glossaryRefs: [
          GlossaryRef('reazione', 'Reazione'),
          GlossaryRef('attacco', 'Attacco'),
          GlossaryRef('attacco_mischia', 'Attacco in mischia'),
        ],
      ),
    },
  ),
  'Via dei Quattro Elementi': SubclassDefinition(
    name: 'Via dei Quattro Elementi',
    description:
        'Una tradizione che permette al Monaco di incanalare il proprio Ki attraverso discipline legate alle forze elementali.',
    source: 'Manuale del Giocatore',
    sourceRef: 'PHB',
    featuresByLevel: {
      3: ['Discepolo degli Elementi'],
      6: ['Discipline Elementali Aggiuntive'],
      11: ['Discipline Elementali Aggiuntive'],
      17: ['Discipline Elementali Aggiuntive'],
    },
    featureDescriptions: {
      'Discepolo degli Elementi': RuleDescription(
        summary:
            'Il Monaco apprende discipline che gli permettono di incanalare il Ki nelle forze elementali.',
        details:
            'Dal 3° livello, il Monaco apprende discipline elementali e può utilizzarne gli effetti secondo i rispettivi requisiti e costi in Ki. Con la progressione della tradizione aumenta il numero di discipline conosciute e diventa possibile sostituirne alcune.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('disciplina_elementale', 'Disciplina elementale'),
          GlossaryRef('incantesimo', 'Incantesimo'),
          GlossaryRef('saggezza', 'Saggezza'),
        ],
      ),
      'Discipline Elementali Aggiuntive': RuleDescription(
        summary:
            'La progressione della tradizione amplia le discipline elementali conosciute dal Monaco.',
        details:
            'Al 6°, 11° e 17° livello la tradizione amplia le opzioni elementali disponibili. Le singole discipline possono avere requisiti di livello, costi in Ki ed effetti differenti; queste scelte saranno rappresentate separatamente dal sistema delle opzioni di sottoclasse.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('disciplina_elementale', 'Disciplina elementale'),
          GlossaryRef('livello', 'Livello'),
        ],
      ),
    },
    optionProgression: SubclassOptionProgression(
      selectionsByLevel: {
        3: 1,
        6: 2,
        11: 3,
        17: 4,
      },
      replacementLevels: {6, 11, 17},
    ),
    options: [
      SubclassOptionDefinition(
        id: 'sintonia_elementale',
        name: 'Sintonia Elementale',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        grantedAutomatically: true,
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Il Monaco controlla brevemente piccole manifestazioni delle forze elementali.',
          details:
              'Usando un’azione, il Monaco può produrre entro 9 metri piccoli effetti innocui legati ad acqua, aria, fuoco o terra, accendere o spegnere piccole fiamme, riscaldare o raffreddare materiale non vivente oppure generare temporaneamente una piccola quantità o forma elementale.',
          glossaryRefs: [
            GlossaryRef('azione', 'Azione'),
            GlossaryRef('elemento', 'Elemento'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'cavalcare_il_vento',
        name: 'Cavalcare il Vento',
        category: 'disciplina_elementale',
        minimumLevel: 11,
        cost: 4,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco usa il Ki per ottenere la capacità di volare.',
          details:
              'Dall’11° livello, il Monaco può spendere 4 punti Ki per lanciare volare bersagliando se stesso.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'colpo_della_cenere_turbinante',
        name: 'Colpo della Cenere Turbinante',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 2,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco scatena una fiammata attraverso il proprio Ki.',
          details:
              'Il Monaco può spendere 2 punti Ki per lanciare mani brucianti.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
            GlossaryRef('fuoco', 'Fuoco'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'difesa_della_montagna_eterna',
        name: 'Difesa della Montagna Eterna',
        category: 'disciplina_elementale',
        minimumLevel: 17,
        cost: 5,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Il Monaco assume la resistenza soprannaturale della pietra.',
          details:
              'Dal 17° livello, il Monaco può spendere 5 punti Ki per lanciare pelle di pietra bersagliando se stesso.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'fiamme_della_fenice',
        name: 'Fiamme della Fenice',
        category: 'disciplina_elementale',
        minimumLevel: 11,
        cost: 4,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Il Monaco concentra il Ki in una potente esplosione di fuoco.',
          details:
              'Dall’11° livello, il Monaco può spendere 4 punti Ki per lanciare palla di fuoco.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
            GlossaryRef('fuoco', 'Fuoco'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'fiume_della_fiamma_famelica',
        name: 'Fiume della Fiamma Famelica',
        category: 'disciplina_elementale',
        minimumLevel: 17,
        cost: 5,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco innalza una barriera di fuoco alimentata dal Ki.',
          details:
              'Dal 17° livello, il Monaco può spendere 5 punti Ki per lanciare muro di fuoco.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
            GlossaryRef('fuoco', 'Fuoco'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'forma_del_fiume_fluente',
        name: 'Forma del Fiume Fluente',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 1,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco rimodella acqua e ghiaccio attraverso il Ki.',
          details:
              'Con un’azione e 1 punto Ki, il Monaco può trasformare acqua in ghiaccio o viceversa e modellare il ghiaccio entro i limiti previsti dalla disciplina, senza usarlo per intrappolare o danneggiare direttamente una creatura.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('azione', 'Azione'),
            GlossaryRef('acqua', 'Acqua'),
            GlossaryRef('ghiaccio', 'Ghiaccio'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'frusta_d_acqua',
        name: 'Frusta d’Acqua',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 2,
        resource: 'ki',
        allowsAdditionalResource: true,
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Una frusta d’acqua danneggia e può sbilanciare o trascinare una creatura.',
          details:
              'Con un’azione e almeno 2 punti Ki, il Monaco bersaglia una creatura visibile entro 9 metri. Un tiro salvezza su Destrezza determina danni ed effetti; Ki aggiuntivo può aumentare il danno della disciplina.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('azione', 'Azione'),
            GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
            GlossaryRef('destrezza', 'Destrezza'),
            GlossaryRef('prono', 'Prono'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'gong_della_sommita',
        name: 'Gong della Sommità',
        category: 'disciplina_elementale',
        minimumLevel: 6,
        cost: 3,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco sprigiona una violenta forza sonora.',
          details:
              'Dal 6° livello, il Monaco può spendere 3 punti Ki per lanciare frantumare.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'morsa_del_vento_del_nord',
        name: 'Morsa del Vento del Nord',
        category: 'disciplina_elementale',
        minimumLevel: 6,
        cost: 3,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco usa il Ki per immobilizzare una creatura.',
          details:
              'Dal 6° livello, il Monaco può spendere 3 punti Ki per lanciare blocca persone.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'onda_della_terra_tumultuosa',
        name: 'Onda della Terra Tumultuosa',
        category: 'disciplina_elementale',
        minimumLevel: 17,
        cost: 6,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco solleva la terra formando una grande barriera.',
          details:
              'Dal 17° livello, il Monaco può spendere 6 punti Ki per lanciare muro di pietra.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'postura_della_nebbia',
        name: 'Postura della Nebbia',
        category: 'disciplina_elementale',
        minimumLevel: 11,
        cost: 4,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Il Monaco trasforma il proprio corpo in una forma simile alla nebbia.',
          details:
              'Dall’11° livello, il Monaco può spendere 4 punti Ki per lanciare forma gassosa bersagliando se stesso.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'pugno_dei_quattro_tuoni',
        name: 'Pugno dei Quattro Tuoni',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 2,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco libera una violenta onda di energia tonante.',
          details:
              'Il Monaco può spendere 2 punti Ki per lanciare onda tonante.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'pugno_dell_aria_inviolabile',
        name: 'Pugno dell’Aria Inviolabile',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 2,
        resource: 'ki',
        allowsAdditionalResource: true,
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Una scarica di aria compressa colpisce, respinge e può abbattere una creatura.',
          details:
              'Con un’azione e almeno 2 punti Ki, il Monaco bersaglia una creatura entro 9 metri. La creatura effettua un tiro salvezza su Forza; Ki aggiuntivo può aumentare il danno della disciplina.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('azione', 'Azione'),
            GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
            GlossaryRef('forza', 'Forza'),
            GlossaryRef('prono', 'Prono'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'soffio_dell_inverno',
        name: 'Soffio dell’Inverno',
        category: 'disciplina_elementale',
        minimumLevel: 17,
        cost: 6,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco scatena una devastante ondata di gelo.',
          details:
              'Dal 17° livello, il Monaco può spendere 6 punti Ki per lanciare cono di freddo.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
            GlossaryRef('freddo', 'Freddo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'spiriti_della_burrasca_impetuosa',
        name: 'Spiriti della Burrasca Impetuosa',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 2,
        resource: 'ki',
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary: 'Il Monaco richiama una potente corrente di vento.',
          details:
              'Il Monaco può spendere 2 punti Ki per lanciare folata di vento.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('incantesimo', 'Incantesimo'),
          ],
        ),
      ),
      SubclassOptionDefinition(
        id: 'zanne_del_serpente_di_fuoco',
        name: 'Zanne del Serpente di Fuoco',
        category: 'disciplina_elementale',
        minimumLevel: 3,
        cost: 1,
        resource: 'ki',
        allowsAdditionalResource: true,
        source: 'Manuale del Giocatore',
        sourceRef: 'PHB',
        description: RuleDescription(
          summary:
              'Il Monaco avvolge pugni e piedi in fiamme, aumentando portata e potenza dei colpi senz’armi.',
          details:
              'Quando usa l’azione Attacco nel proprio turno, il Monaco può spendere 1 punto Ki per estendere di 3 metri la portata dei colpi senz’armi per quell’azione e per il resto del turno. I colpi infliggono danni da fuoco e, quando uno colpisce, può spendere altro Ki per aggiungere danni da fuoco.',
          glossaryRefs: [
            GlossaryRef('ki', 'Ki'),
            GlossaryRef('azione_attacco', 'Azione Attacco'),
            GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
            GlossaryRef('portata', 'Portata'),
            GlossaryRef('fuoco', 'Fuoco'),
          ],
        ),
      ),
    ],
  ),
  'Via del Maestro Ubriaco': SubclassDefinition(
    name: 'Via del Maestro Ubriaco',
    description:
        'Uno stile imprevedibile che usa movimenti apparentemente scoordinati per confondere gli avversari e dominare il ritmo dello scontro.',
    source: 'Guida Omnicomprensiva di Xanathar',
    sourceRef: 'XGE',
    featuresByLevel: {
      3: ['Competenza Bonus', 'Tecnica dell’Ubriaco'],
      6: ['Andatura Ondeggiante'],
      11: ['Fortuna dell’Ubriaco'],
      17: ['Frenesia Intossicata'],
    },
    featureDescriptions: {
      'Competenza Bonus': RuleDescription(
        summary:
            'Il Maestro Ubriaco amplia il proprio addestramento con competenze legate alla rappresentazione e alla tradizione del suo stile.',
        details:
            'Dal 3° livello, quando sceglie questa tradizione, il Monaco ottiene l’addestramento aggiuntivo previsto dalla capacità, riflettendo l’aspetto teatrale e apparentemente disordinato dello stile del Maestro Ubriaco.',
        glossaryRefs: [
          GlossaryRef('competenza', 'Competenza'),
          GlossaryRef('abilita', 'Abilità'),
        ],
      ),
      'Tecnica dell’Ubriaco': RuleDescription(
        summary:
            'La Raffica di Colpi permette al Monaco di muoversi con maggiore libertà durante lo scontro.',
        details:
            'Dal 3° livello, quando usa Raffica di Colpi, il Monaco beneficia anche di Disimpegno e aumenta temporaneamente la propria velocità per quel turno.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('raffica_di_colpi', 'Raffica di Colpi'),
          GlossaryRef('disimpegno', 'Disimpegno'),
          GlossaryRef('velocita', 'Velocità'),
          GlossaryRef('movimento', 'Movimento'),
        ],
      ),
      'Andatura Ondeggiante': RuleDescription(
        summary:
            'I movimenti imprevedibili del Maestro Ubriaco diventano strumenti difensivi e tattici.',
        details:
            'Dal 6° livello, questa capacità migliora il modo in cui il Monaco si rialza da prono e gli permette, nelle circostanze previste, di sfruttare un attacco in mischia mancato da un avversario indirizzandolo contro un’altra creatura vicina.',
        glossaryRefs: [
          GlossaryRef('prono', 'Prono'),
          GlossaryRef('movimento', 'Movimento'),
          GlossaryRef('reazione', 'Reazione'),
          GlossaryRef('attacco_mischia', 'Attacco in mischia'),
        ],
      ),
      'Fortuna dell’Ubriaco': RuleDescription(
        summary:
            'Il Monaco può spendere Ki per neutralizzare uno svantaggio su un tiro.',
        details:
            'Dall’11° livello, quando effettua un tiro per colpire, una prova di caratteristica o un tiro salvezza con svantaggio, il Monaco può spendere 2 punti Ki per annullare lo svantaggio per quel tiro.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('svantaggio', 'Svantaggio'),
          GlossaryRef('tiro_per_colpire', 'Tiro per colpire'),
          GlossaryRef('prova_caratteristica', 'Prova di caratteristica'),
          GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
        ],
      ),
      'Frenesia Intossicata': RuleDescription(
        summary:
            'La Raffica di Colpi diventa particolarmente efficace quando il Monaco affronta più avversari.',
        details:
            'Dal 17° livello, quando usa Raffica di Colpi, il Monaco può ampliare la propria sequenza offensiva distribuendo gli attacchi aggiuntivi contro bersagli differenti secondo i limiti della capacità.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('raffica_di_colpi', 'Raffica di Colpi'),
          GlossaryRef('attacco', 'Attacco'),
        ],
      ),
    },
  ),
  'Via del Kensei': SubclassDefinition(
    name: 'Via del Kensei',
    description:
        'Una tradizione che porta la disciplina monastica nell’uso magistrale di determinate armi.',
    source: 'Guida Omnicomprensiva di Xanathar',
    sourceRef: 'XGE',
    featuresByLevel: {
      3: ['Via del Kensei'],
      6: ['Tutt’uno con la Lama'],
      11: ['Affilare la Lama'],
      17: ['Precisione Infallibile'],
    },
    featureDescriptions: {
      'Via del Kensei': RuleDescription(
        summary:
            'Il Monaco trasforma determinate armi in estensioni della propria disciplina marziale.',
        details:
            'Dal 3° livello, il Kensei sviluppa un legame speciale con determinate armi e apprende tecniche che ne ampliano l’impiego. Con la progressione può aggiungere ulteriori armi al proprio repertorio kensei.',
        glossaryRefs: [
          GlossaryRef('arma', 'Arma'),
          GlossaryRef('arma_kensei', 'Arma kensei'),
          GlossaryRef('competenza', 'Competenza'),
          GlossaryRef('arti_marziali', 'Arti Marziali'),
        ],
      ),
      'Tutt’uno con la Lama': RuleDescription(
        summary:
            'Il legame con le armi kensei permette al Monaco di incanalare il Ki attraverso di esse.',
        details:
            'Dal 6° livello, la padronanza delle armi kensei ne migliora l’efficacia secondo le proprietà previste dalla capacità e permette al Monaco di utilizzare il Ki per potenziare la propria offensiva.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('arma_kensei', 'Arma kensei'),
          GlossaryRef('attacco', 'Attacco'),
          GlossaryRef('danno', 'Danno'),
          GlossaryRef('resistenza', 'Resistenza'),
          GlossaryRef('immunita', 'Immunità'),
        ],
      ),
      'Affilare la Lama': RuleDescription(
        summary:
            'Il Monaco può incanalare Ki in un’arma kensei per potenziarla temporaneamente.',
        details:
            'Dall’11° livello, il Monaco può spendere Ki per conferire temporaneamente a un’arma kensei idonea un bonus ai tiri per colpire e ai danni, rispettando i limiti e le incompatibilità previste dalla capacità.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('arma_kensei', 'Arma kensei'),
          GlossaryRef('tiro_per_colpire', 'Tiro per colpire'),
          GlossaryRef('danno', 'Danno'),
        ],
      ),
      'Precisione Infallibile': RuleDescription(
        summary:
            'La padronanza del Kensei permette al Monaco di correggere un attacco mancato.',
        details:
            'Dal 17° livello, quando manca con un tiro per colpire effettuato con un’arma da Monaco nel proprio turno, può ripetere quel tiro secondo il limite previsto dalla capacità.',
        glossaryRefs: [
          GlossaryRef('arma_monaco', 'Arma da Monaco'),
          GlossaryRef('tiro_per_colpire', 'Tiro per colpire'),
          GlossaryRef('turno', 'Turno'),
        ],
      ),
    },
  ),
  'Via dell’Anima Solare': SubclassDefinition(
    name: 'Via dell’Anima Solare',
    description:
        'Una tradizione che insegna a proiettare l’energia interiore del Monaco in manifestazioni di energia radiosa.',
    source: 'Guida Omnicomprensiva di Xanathar',
    sourceRef: 'XGE',
    featuresByLevel: {
      3: ['Dardo Solare Radioso'],
      6: ['Colpo ad Arco Bruciante'],
      11: ['Esplosione Solare Rovente'],
      17: ['Scudo Solare'],
    },
    featureDescriptions: {
      'Dardo Solare Radioso': RuleDescription(
        summary:
            'Il Monaco proietta la propria energia interiore sotto forma di attacchi radianti a distanza.',
        details:
            'Dal 3° livello, il Monaco ottiene una tecnica offensiva a distanza basata sull’energia radiante e collegata alla propria progressione nelle Arti Marziali. Il Ki può essere utilizzato per ampliare la sequenza offensiva secondo le regole della capacità.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('arti_marziali', 'Arti Marziali'),
          GlossaryRef('attacco_distanza', 'Attacco a distanza'),
          GlossaryRef('danno_radiante', 'Danno radiante'),
        ],
      ),
      'Colpo ad Arco Bruciante': RuleDescription(
        summary:
            'Il Monaco accompagna la propria offensiva con una manifestazione di energia infuocata.',
        details:
            'Dal 6° livello, dopo aver effettuato l’azione di Attacco nel proprio turno, il Monaco può utilizzare il Ki per produrre l’effetto offensivo previsto dalla capacità e può investirvi ulteriore Ki entro i limiti consentiti.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('azione_attacco', 'Azione di Attacco'),
          GlossaryRef('danno_fuoco', 'Danno da fuoco'),
        ],
      ),
      'Esplosione Solare Rovente': RuleDescription(
        summary:
            'Il Monaco concentra la propria energia in un’esplosione radiante a distanza.',
        details:
            'Dall’11° livello, il Monaco può generare un’esplosione di energia in un punto entro la gittata prevista. Le creature nell’area devono resistere all’effetto della capacità e il Monaco può spendere Ki per aumentarne la potenza.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('azione', 'Azione'),
          GlossaryRef('area_effetto', 'Area di effetto'),
          GlossaryRef('tiro_salvezza', 'Tiro salvezza'),
          GlossaryRef('danno_radiante', 'Danno radiante'),
        ],
      ),
      'Scudo Solare': RuleDescription(
        summary:
            'Il Monaco emana luce e può reagire contro un avversario che riesce a colpirlo.',
        details:
            'Dal 17° livello, il Monaco può manifestare un’aura luminosa. Mentre la manifestazione è attiva, può reagire contro una creatura che lo colpisce con un attacco in mischia, applicando l’effetto radiante previsto dalla capacità.',
        glossaryRefs: [
          GlossaryRef('luce', 'Luce'),
          GlossaryRef('reazione', 'Reazione'),
          GlossaryRef('attacco_mischia', 'Attacco in mischia'),
          GlossaryRef('danno_radiante', 'Danno radiante'),
        ],
      ),
    },
  ),
  'Via del Sé Astrale': SubclassDefinition(
    name: 'Via del Sé Astrale',
    description:
        'Una tradizione che manifesta esteriormente il sé spirituale del Monaco attraverso il Ki.',
    source: 'Calderone Omnicomprensivo di Tasha',
    sourceRef: 'TCE',
    featuresByLevel: {
      3: ['Braccia del Sé Astrale'],
      6: ['Volto del Sé Astrale'],
      11: ['Corpo del Sé Astrale'],
      17: ['Sé Astrale Risvegliato'],
    },
    featureDescriptions: {
      'Braccia del Sé Astrale': RuleDescription(
        summary:
            'Il Monaco manifesta braccia spettrali che rappresentano una parte del proprio sé interiore.',
        details:
            'Dal 3° livello, il Monaco può spendere Ki per evocare le braccia del proprio Sé Astrale. La manifestazione produce gli effetti iniziali previsti dalla capacità e, mentre permane, modifica alcune possibilità offensive e fisiche del Monaco, permettendogli di affidarsi maggiormente alla propria Saggezza e di estendere la portata dei propri colpi senz’armi.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('saggezza', 'Saggezza'),
          GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
          GlossaryRef('portata', 'Portata'),
          GlossaryRef('danno_forza', 'Danno da forza'),
        ],
      ),
      'Volto del Sé Astrale': RuleDescription(
        summary:
            'Il Monaco manifesta il volto del proprio Sé Astrale ottenendo capacità sensoriali e comunicative soprannaturali.',
        details:
            'Dal 6° livello, il Monaco può manifestare il volto astrale, separatamente o insieme alle braccia. Finché è presente, ottiene i benefici sensoriali e comunicativi previsti dalla capacità, migliorando la propria percezione e il modo in cui può farsi udire o comunicare.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('percezione', 'Percezione'),
          GlossaryRef('sensi', 'Sensi'),
          GlossaryRef('comunicazione', 'Comunicazione'),
        ],
      ),
      'Corpo del Sé Astrale': RuleDescription(
        summary:
            'La manifestazione astrale si estende al corpo del Monaco e ne rafforza le capacità difensive e offensive.',
        details:
            'Dall’11° livello, quando il Monaco ha manifestato sia le braccia sia il volto del Sé Astrale, può manifestarne anche il corpo. La forma completa gli concede i benefici difensivi e offensivi previsti dalla capacità, migliorando la sua interazione con determinati tipi di danno e la potenza dei colpi delle braccia astrali.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('danno', 'Danno'),
          GlossaryRef('reazione', 'Reazione'),
          GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
          GlossaryRef('danno_forza', 'Danno da forza'),
        ],
      ),
      'Sé Astrale Risvegliato': RuleDescription(
        summary:
            'Il Monaco porta la manifestazione del proprio Sé Astrale alla sua espressione più completa.',
        details:
            'Dal 17° livello, il Monaco può manifestare pienamente il Sé Astrale spendendo Ki. Finché la manifestazione permane, ottiene i miglioramenti difensivi e offensivi di massimo livello previsti dalla tradizione, inclusi benefici alla propria protezione e alla sequenza di attacchi effettuati tramite il Sé Astrale.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('classe_armatura', 'Classe Armatura'),
          GlossaryRef('attacco', 'Attacco'),
          GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
        ],
      ),
    },
  ),
  'Via della Misericordia': SubclassDefinition(
    name: 'Via della Misericordia',
    description:
        'Una tradizione che unisce conoscenze mediche e Ki, permettendo al Monaco di portare guarigione o sofferenza.',
    source: 'Calderone Omnicomprensivo di Tasha',
    sourceRef: 'TCE',
    featuresByLevel: {
      3: [
        'Strumenti della Misericordia',
        'Mani della Guarigione',
        'Mani del Dolore',
      ],
      6: ['Tocco del Medico'],
      11: ['Raffica di Guarigione e Dolore'],
      17: ['Mano della Misericordia Suprema'],
    },
    featureDescriptions: {
      'Strumenti della Misericordia': RuleDescription(
        summary:
            'Il Monaco riceve un addestramento adatto a chi porta guarigione, sollievo o una morte misericordiosa.',
        details:
            'Dal 3° livello, il Monaco ottiene le competenze previste dalla tradizione e acquisisce gli strumenti simbolici e pratici associati al proprio ruolo di portatore di misericordia.',
        glossaryRefs: [
          GlossaryRef('competenza', 'Competenza'),
          GlossaryRef('medicina', 'Medicina'),
          GlossaryRef('strumento', 'Strumento'),
        ],
      ),
      'Mani della Guarigione': RuleDescription(
        summary:
            'Il Monaco può incanalare il Ki attraverso il contatto per ripristinare i punti ferita di una creatura.',
        details:
            'Dal 3° livello, il Monaco può spendere Ki per toccare una creatura e farle recuperare punti ferita in base al proprio dado delle Arti Marziali e al modificatore di Saggezza. La capacità interagisce inoltre con Raffica di Colpi secondo la progressione della tradizione.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('punti_ferita', 'Punti Ferita'),
          GlossaryRef('arti_marziali', 'Arti Marziali'),
          GlossaryRef('saggezza', 'Saggezza'),
          GlossaryRef('raffica_di_colpi', 'Raffica di Colpi'),
        ],
      ),
      'Mani del Dolore': RuleDescription(
        summary:
            'Il Monaco può convogliare il Ki in un colpo per infliggere ulteriore sofferenza al bersaglio.',
        details:
            'Dal 3° livello, quando colpisce una creatura con un colpo senz’armi, il Monaco può spendere Ki per infliggere danni necrotici aggiuntivi determinati dal proprio dado delle Arti Marziali e dal modificatore di Saggezza, rispettando il limite d’uso previsto dalla capacità.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('attacco_senz_armi', 'Attacco senz’armi'),
          GlossaryRef('arti_marziali', 'Arti Marziali'),
          GlossaryRef('saggezza', 'Saggezza'),
          GlossaryRef('danno_necrotico', 'Danno necrotico'),
        ],
      ),
      'Tocco del Medico': RuleDescription(
        summary:
            'Le Mani della Guarigione e le Mani del Dolore acquisiscono effetti aggiuntivi.',
        details:
            'Dal 6° livello, l’uso di Mani della Guarigione può rimuovere determinate condizioni dalla creatura curata, mentre Mani del Dolore può imporre al bersaglio colpito la condizione prevista dalla capacità fino alla fine del turno successivo del Monaco.',
        glossaryRefs: [
          GlossaryRef('mani_della_guarigione', 'Mani della Guarigione'),
          GlossaryRef('mani_del_dolore', 'Mani del Dolore'),
          GlossaryRef('condizione', 'Condizione'),
          GlossaryRef('avvelenato', 'Avvelenato'),
        ],
      ),
      'Raffica di Guarigione e Dolore': RuleDescription(
        summary:
            'Il Monaco integra con maggiore efficienza guarigione e dolore nella propria Raffica di Colpi.',
        details:
            'Dall’11° livello, quando usa Raffica di Colpi, il Monaco può applicare Mani della Guarigione e Mani del Dolore con l’efficienza e i limiti previsti dalla capacità, riducendo il costo necessario per combinarle con la propria sequenza di colpi.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('raffica_di_colpi', 'Raffica di Colpi'),
          GlossaryRef('mani_della_guarigione', 'Mani della Guarigione'),
          GlossaryRef('mani_del_dolore', 'Mani del Dolore'),
        ],
      ),
      'Mano della Misericordia Suprema': RuleDescription(
        summary:
            'La padronanza del Ki permette al Monaco di riportare alla vita una creatura morta di recente.',
        details:
            'Dal 17° livello, il Monaco può utilizzare Mani della Guarigione su una creatura morta entro il limite temporale previsto dalla capacità e spendere una quantità significativa di Ki per riportarla in vita, facendole recuperare punti ferita e rimuovendo le condizioni indicate dalla regola. Questa applicazione è soggetta a un limite prima di poter essere usata nuovamente.',
        glossaryRefs: [
          GlossaryRef('ki', 'Ki'),
          GlossaryRef('mani_della_guarigione', 'Mani della Guarigione'),
          GlossaryRef('punti_ferita', 'Punti Ferita'),
          GlossaryRef('morte', 'Morte'),
          GlossaryRef('riposo_lungo', 'Riposo lungo'),
        ],
      ),
    },
  ),
});

List<Map<String, dynamic>> startingInventoryFor(String background) {
  final items = <Map<String, dynamic>>[
    {
      'name': 'Spada corta',
      'quantity': 1,
      'equipped': false,
      'source': 'Monaco',
    },
    {
      'name': 'Dardo',
      'quantity': 10,
      'equipped': false,
      'source': 'Monaco',
    },
  ];

  final backgroundItem = switch (background) {
    'Accolito' => 'Simbolo sacro',
    'Artigiano di Gilda' => 'Attrezzi da artigiano',
    'Ciarlatano' => 'Kit da camuffamento',
    'Criminale' => 'Piede di porco',
    'Eremita' => 'Kit da erborista',
    'Eroe Popolare' => 'Attrezzi da artigiano',
    'Forestiero' => 'Bastone',
    'Intrattenitore' => 'Strumento musicale',
    'Marinaio' => 'Corda di seta',
    'Monello' => 'Coltellino',
    'Nobile' => 'Anello con sigillo',
    'Sapiente' => 'Calamaio',
    'Soldato' => 'Insegna del grado',
    _ => null,
  };

  if (backgroundItem != null) {
    items.add({
      'name': backgroundItem,
      'quantity': 1,
      'equipped': false,
      'source': background,
    });
  }

  return items;
}

const classRegistry = <String, ClassDefinition>{
  'Monaco': monkClass,
};

ClassDefinition? classDefinitionFor(String name) => classRegistry[name];
