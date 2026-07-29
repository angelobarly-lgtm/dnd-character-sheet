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

class GlossaryEntry {
  final String id;
  final String name;
  final GlossaryCategory category;
  final String summary;
  final String details;
  final List<String> relatedIds;

  const GlossaryEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    this.details = '',
    this.relatedIds = const [],
  });
}

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

class SubclassDefinition {
  final String name;
  final String description;
  final Map<int, List<String>> featuresByLevel;
  final Map<String, RuleDescription> featureDescriptions;

  const SubclassDefinition({
    required this.name,
    required this.description,
    required this.featuresByLevel,
    this.featureDescriptions = const {},
  });
}

const monkClass = ClassDefinition(
  id: 'monk',
  name: 'Monaco',
  hitDie: 8,
  savingThrows: {'FOR', 'DES'},
  featuresByLevel: {
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
  },
  featureDescriptions: {
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
  },
  subclasses: {
    'Via della Mano Aperta': SubclassDefinition(
      name: 'Via della Mano Aperta',
      description:
          'Una tradizione focalizzata sul controllo del combattimento senz’armi.',
      featuresByLevel: {
        3: ['Tecnica della Mano Aperta'],
        6: ['Integrità del Corpo'],
        11: ['Tranquillità'],
        17: ['Palmo Tremante'],
      },
    ),
    'Via dell’Ombra': SubclassDefinition(
      name: 'Via dell’Ombra',
      description: 'Una tradizione legata a furtività e tecniche d’ombra.',
      featuresByLevel: {
        3: ['Arti dell’Ombra'],
        6: ['Passo d’Ombra'],
        11: ['Manto d’Ombra'],
        17: ['Opportunista'],
      },
    ),
    'Via dei Quattro Elementi': SubclassDefinition(
      name: 'Via dei Quattro Elementi',
      description:
          'Una tradizione che unisce disciplina monastica e tecniche elementali.',
      featuresByLevel: {
        3: ['Discepolo degli Elementi'],
        6: ['Discipline Elementali Aggiuntive'],
        11: ['Discipline Elementali Aggiuntive'],
        17: ['Discipline Elementali Aggiuntive'],
      },
    ),
  },
);

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
