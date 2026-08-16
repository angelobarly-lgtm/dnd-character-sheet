import 'class_data.dart';

/// Creazione e avanzamento del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbCharacterProgressionGlossaryEntries = {
  "character_creation": GlossaryEntry(
    id: "character_creation",
    name: "Creazione del Personaggio",
    category: GlossaryCategory.regola,
    summary:
        "Il procedimento con cui si definiscono razza, classe, caratteristiche, background, equipaggiamento e identità di un personaggio.",
    details:
        "Il Manuale del Giocatore propone un ordine guidato, ma gli elementi devono essere considerati insieme perché razza, classe e background influenzano capacità, competenze e storia.",
    relatedIds: [
      "race_definition",
      "class_definition",
      "background_definition",
      "ability_score",
      "starting_equipment"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Creazione del Personaggio",
        pageStart: 11,
        pageEnd: 15,
        section: "Creazione del Personaggio",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "race_definition": GlossaryEntry(
    id: "race_definition",
    name: "Razza",
    aliases: {"Razze"},
    category: GlossaryCategory.caratteristica,
    summary:
        "L’origine fantastica del personaggio, che ne determina tratti innati e culturali.",
    details:
        "Una razza può concedere incrementi di caratteristica, età, taglia, velocità, lingue, sensi, competenze e altri tratti. Alcune razze richiedono anche la scelta di una sottorazza.",
    relatedIds: [
      "subrace_definition",
      "racial_speed",
      "racial_language",
      "racial_proficiency",
      "racial_progression"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Razze",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "subrace_definition": GlossaryEntry(
    id: "subrace_definition",
    name: "Sottorazza",
    aliases: {"Sottorazze"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una diramazione di una razza che aggiunge o modifica determinati tratti razziali.",
    details:
        "Quando una razza presenta sottorazze, il personaggio sceglie una delle opzioni disponibili e ottiene i suoi tratti oltre a quelli condivisi dalla razza principale.",
    relatedIds: ["race_definition", "racial_progression"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze e Sottorazze",
        pageStart: 17,
        pageEnd: 43,
        section: "Razze e Sottorazze",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "class_definition": GlossaryEntry(
    id: "class_definition",
    name: "Classe",
    aliases: {"Classi"},
    category: GlossaryCategory.caratteristica,
    summary:
        "La vocazione avventurosa che determina privilegi, competenze, Dado Vita e progressione principale del personaggio.",
    details:
        "La classe stabilisce ciò che il personaggio sa fare a ogni livello. Alcune classi concedono magia, risorse specifiche e una scelta di sottoclasse.",
    relatedIds: [
      "subclass_definition",
      "class_level",
      "hit_dice",
      "proficiency_bonus",
      "gaining_level"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Scegliere una Classe",
        pageStart: 11,
        pageEnd: 15,
        section: "Scegliere una Classe",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "subclass_definition": GlossaryEntry(
    id: "subclass_definition",
    name: "Sottoclasse",
    aliases: {"Sottoclassi"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una specializzazione scelta all’interno di una classe e sviluppata ai livelli indicati dalla relativa progressione.",
    details:
        "La sottoclasse può essere chiamata cammino, collegio, dominio, circolo, archetipo, tradizione, origine, patrono o giuramento. Il livello della scelta dipende dalla classe.",
    relatedIds: ["class_definition", "class_level"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Classi",
        pageStart: 45,
        pageEnd: 119,
        section: "Classi",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "background_definition": GlossaryEntry(
    id: "background_definition",
    name: "Background",
    category: GlossaryCategory.caratteristica,
    summary:
        "La vita e l’esperienza del personaggio prima dell’inizio della sua carriera da avventuriero.",
    details:
        "Il background concede competenze, lingue o strumenti, equipaggiamento, un privilegio e caratteristiche personali come tratto, ideale, legame e difetto.",
    relatedIds: [
      "personality_trait",
      "ideal",
      "bond",
      "flaw",
      "starting_equipment",
      "language_definition",
      "tool_proficiency"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Background",
        pageStart: 125,
        pageEnd: 141,
        section: "Background",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "character_level": GlossaryEntry(
    id: "character_level",
    name: "Livello del Personaggio",
    aliases: {"Livello Totale"},
    category: GlossaryCategory.caratteristica,
    summary:
        "La somma di tutti i livelli posseduti dal personaggio nelle sue classi.",
    details:
        "Per un personaggio con una sola classe coincide con il livello di classe. Per un personaggio multiclasse determina Bonus di Competenza e soglie basate sul livello totale.",
    relatedIds: [
      "class_level",
      "experience_points",
      "gaining_level",
      "multiclassing",
      "proficiency_bonus_multiclass"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Oltre il 1° Livello",
        pageStart: 15,
        pageEnd: 15,
        section: "Oltre il 1° Livello",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "class_level": GlossaryEntry(
    id: "class_level",
    name: "Livello di Classe",
    aliases: {"Livelli di Classe"},
    category: GlossaryCategory.caratteristica,
    summary: "Il numero di livelli posseduti in una specifica classe.",
    details:
        "Il livello di classe determina i privilegi ottenuti dalla tabella di quella classe. In un personaggio multiclasse viene calcolato separatamente per ciascuna classe.",
    relatedIds: [
      "character_level",
      "class_definition",
      "subclass_definition",
      "multiclassing"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Oltre il 1° Livello",
        pageStart: 15,
        pageEnd: 15,
        section: "Oltre il 1° Livello",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "experience_points": GlossaryEntry(
    id: "experience_points",
    name: "Punti Esperienza",
    aliases: {"PE", "Esperienza"},
    category: GlossaryCategory.risorsa,
    summary:
        "La misura numerica dei progressi compiuti dal personaggio attraverso avventure e sfide.",
    details:
        "Quando il totale raggiunge la soglia del livello successivo, il personaggio può avanzare. Il Dungeon Master può usare in alternativa una progressione senza punti esperienza.",
    relatedIds: ["character_level", "gaining_level"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Oltre il 1° Livello",
        pageStart: 15,
        pageEnd: 15,
        section: "Oltre il 1° Livello",
      ),
    ],
    tags: {"phb", "personaggio", "risorsa"},
  ),
  "gaining_level": GlossaryEntry(
    id: "gaining_level",
    name: "Aumento di Livello",
    aliases: {"Salire di Livello", "Avanzamento di Livello"},
    category: GlossaryCategory.regola,
    summary:
        "Il passaggio a un nuovo livello, che concede privilegi e può aumentare i punti ferita massimi.",
    details:
        "Il personaggio consulta la tabella della classe in cui acquisisce il livello, applica i nuovi privilegi e aggiorna Dadi Vita, punti ferita, Bonus di Competenza e magia quando previsto.",
    relatedIds: [
      "character_level",
      "class_level",
      "experience_points",
      "hit_point_maximum",
      "hit_dice",
      "proficiency_bonus"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Oltre il 1° Livello",
        pageStart: 15,
        pageEnd: 15,
        section: "Oltre il 1° Livello",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "hit_point_maximum": GlossaryEntry(
    id: "hit_point_maximum",
    name: "Punti Ferita Massimi",
    aliases: {"Massimo dei Punti Ferita"},
    category: GlossaryCategory.risorsa,
    summary: "Il limite superiore dei punti ferita attuali di una creatura.",
    details:
        "Il massimo iniziale dipende dal Dado Vita della classe e dalla Costituzione. A ogni livello successivo aumenta secondo la classe scelta e il modificatore di Costituzione.",
    relatedIds: [
      "hit_points",
      "hit_points_first_level",
      "hit_points_higher_levels",
      "constitution",
      "hit_dice"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punti Ferita e Dadi Vita",
        pageStart: 12,
        pageEnd: 15,
        section: "Punti Ferita e Dadi Vita",
      ),
    ],
    tags: {"phb", "personaggio", "risorsa"},
  ),
  "hit_points_first_level": GlossaryEntry(
    id: "hit_points_first_level",
    name: "Punti Ferita al 1° Livello",
    category: GlossaryCategory.regola,
    summary: "I punti ferita massimi iniziali del personaggio.",
    details:
        "Al 1° livello il massimo è pari al valore più alto del Dado Vita della classe più il modificatore di Costituzione, applicando eventuali altri bonus.",
    relatedIds: ["hit_point_maximum", "hit_dice", "constitution"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punti Ferita e Dadi Vita",
        pageStart: 12,
        pageEnd: 12,
        section: "Punti Ferita e Dadi Vita",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "hit_points_higher_levels": GlossaryEntry(
    id: "hit_points_higher_levels",
    name: "Punti Ferita ai Livelli Successivi",
    category: GlossaryCategory.regola,
    summary:
        "L’aumento dei punti ferita massimi ottenuto quando il personaggio acquisisce un nuovo livello.",
    details:
        "Per ogni livello dopo il primo si tira il Dado Vita della classe oppure si usa il valore medio indicato, aggiungendo il modificatore di Costituzione. L’aumento minimo è normalmente di 1 punto ferita.",
    sections: [
      GlossarySectionDefinition(
        id: "higher_level_minimum_hp",
        title: "Incremento minimo",
        type: GlossarySectionType.completeRule,
        content:
            "Dopo avere applicato il modificatore di Costituzione, l’aumento dei punti ferita massimi è almeno 1.",
        numericValues: {"minimumIncrease": 1},
        relatedIds: ["constitution"],
      ),
    ],
    relatedIds: [
      "hit_point_maximum",
      "hit_dice",
      "constitution",
      "gaining_level"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Oltre il 1° Livello",
        pageStart: 15,
        pageEnd: 15,
        section: "Oltre il 1° Livello",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "ability_score_improvement": GlossaryEntry(
    id: "ability_score_improvement",
    name: "Aumento dei Punteggi di Caratteristica",
    aliases: {"Incremento dei Punteggi di Caratteristica"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un privilegio di classe che permette di aumentare uno o due punteggi di caratteristica.",
    details:
        "È possibile aumentare un punteggio di 2 oppure due punteggi di 1. Normalmente questo privilegio non può portare un punteggio oltre 20; se consentito, può essere sostituito dalla scelta di un talento.",
    sections: [
      GlossarySectionDefinition(
        id: "ability_score_improvement_values",
        title: "Incrementi",
        type: GlossarySectionType.completeRule,
        content:
            "Aumenta un punteggio di 2 oppure due punteggi di 1. Il limite ordinario è 20.",
        numericValues: {
          "singleScoreIncrease": 2,
          "twoScoreIncrease": 1,
          "ordinaryMaximum": 20
        },
        relatedIds: ["ability_score"],
      ),
    ],
    relatedIds: ["ability_score", "feat_definition"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Aumento dei Punteggi di Caratteristica",
        pageStart: 45,
        pageEnd: 119,
        section: "Aumento dei Punteggi di Caratteristica",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "feat_definition": GlossaryEntry(
    id: "feat_definition",
    name: "Talento",
    aliases: {"Talenti"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una capacità speciale che rappresenta addestramento, esperienza o potere al di fuori della normale progressione di classe.",
    details:
        "Quando una regola consente di scegliere un talento, il personaggio deve soddisfarne gli eventuali prerequisiti. Salvo diversa indicazione, ogni talento può essere acquisito una sola volta.",
    relatedIds: ["ability_score_improvement", "multiclass_prerequisites"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Talenti",
        pageStart: 165,
        pageEnd: 170,
        section: "Talenti",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "multiclassing": GlossaryEntry(
    id: "multiclassing",
    name: "Multiclasse",
    aliases: {"Multiclassare", "Personaggio Multiclasse"},
    category: GlossaryCategory.regola,
    summary:
        "La regola opzionale che permette a un personaggio di acquisire livelli in più classi.",
    details:
        "Il personaggio conserva i livelli separati per ciascuna classe, mentre il livello totale è la loro somma. Deve soddisfare i prerequisiti e applicare regole specifiche per competenze, privilegi e magia.",
    relatedIds: [
      "character_level",
      "class_level",
      "multiclass_prerequisites",
      "multiclass_proficiencies",
      "multiclass_class_features",
      "multiclass_spellcasting",
      "multiclass_pact_magic"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Multiclasse",
        pageStart: 163,
        pageEnd: 165,
        section: "Multiclasse",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "multiclass_prerequisites": GlossaryEntry(
    id: "multiclass_prerequisites",
    name: "Prerequisiti del Multiclasse",
    aliases: {"Prerequisiti di Multiclasse"},
    category: GlossaryCategory.regola,
    summary:
        "I punteggi di caratteristica minimi richiesti per entrare in una nuova classe o abbandonare temporaneamente quella attuale.",
    details:
        "Per acquisire un livello in una nuova classe il personaggio deve soddisfare i prerequisiti della classe attuale e di quella nuova.",
    relatedIds: ["multiclassing", "ability_score", "class_definition"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Prerequisiti",
        pageStart: 163,
        pageEnd: 164,
        section: "Prerequisiti",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "multiclass_proficiencies": GlossaryEntry(
    id: "multiclass_proficiencies",
    name: "Competenze del Multiclasse",
    aliases: {"Competenze Multiclasse"},
    category: GlossaryCategory.regola,
    summary:
        "Le competenze limitate ottenute quando si entra in una nuova classe dopo il 1° livello.",
    details:
        "Il personaggio non riceve automaticamente tutte le competenze iniziali della nuova classe. La tabella del multiclasse specifica armature, armi, strumenti e abilità eventualmente concesse.",
    relatedIds: [
      "multiclassing",
      "proficiency_bonus",
      "armor_proficiency",
      "weapon_proficiency",
      "tool_proficiency"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Competenze",
        pageStart: 164,
        pageEnd: 164,
        section: "Competenze",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "multiclass_class_features": GlossaryEntry(
    id: "multiclass_class_features",
    name: "Privilegi di Classe nel Multiclasse",
    category: GlossaryCategory.regola,
    summary:
        "Le regole che disciplinano privilegi simili ottenuti da più classi.",
    details:
        "Difesa Senza Armatura non si cumula con un’altra formula omonima, Attacco Extra non aggiunge ulteriori attacchi tra classi e Incanalare Divinità può offrire nuove opzioni senza concedere automaticamente utilizzi aggiuntivi.",
    relatedIds: ["multiclassing", "armor_class", "attack_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Privilegi di Classe",
        pageStart: 164,
        pageEnd: 164,
        section: "Privilegi di Classe",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "multiclass_spellcasting": GlossaryEntry(
    id: "multiclass_spellcasting",
    name: "Incantesimi del Multiclasse",
    aliases: {"Incantatore Multiclasse"},
    category: GlossaryCategory.regola,
    summary:
        "La progressione degli slot incantesimo di un personaggio che possiede la capacità Incantesimi da più classi.",
    details:
        "Incantesimi conosciuti e preparati vengono determinati separatamente per ogni classe. Gli slot condivisi derivano dalla somma dei livelli da incantatore interi, metà dei livelli delle classi da mezzo incantatore arrotondata per difetto e un terzo dei livelli delle sottoclassi appropriate arrotondato per difetto.",
    sections: [
      GlossarySectionDefinition(
        id: "multiclass_caster_divisors",
        title: "Contributi agli slot",
        type: GlossarySectionType.completeRule,
        content:
            "Incantatore completo: tutti i livelli. Mezzo incantatore: metà dei livelli arrotondata per difetto. Terzo incantatore: un terzo dei livelli arrotondato per difetto.",
        numericValues: {
          "fullCasterDivisor": 1,
          "halfCasterDivisor": 2,
          "thirdCasterDivisor": 3
        },
        relatedIds: ["spell_slots", "class_level"],
      ),
    ],
    relatedIds: [
      "multiclassing",
      "spell_slots",
      "known_spells",
      "prepared_spells",
      "class_level"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Incantesimi",
        pageStart: 164,
        pageEnd: 165,
        section: "Incantesimi",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "multiclass_pact_magic": GlossaryEntry(
    id: "multiclass_pact_magic",
    name: "Magia del Patto nel Multiclasse",
    category: GlossaryCategory.regola,
    summary:
        "L’interazione tra gli slot di Magia del Patto del Warlock e gli slot della capacità Incantesimi.",
    details:
        "Gli slot di Magia del Patto restano separati, ma possono essere usati per lanciare incantesimi conosciuti o preparati tramite Incantesimi; allo stesso modo gli slot di Incantesimi possono lanciare incantesimi da Warlock conosciuti.",
    relatedIds: [
      "multiclassing",
      "spell_slots",
      "known_spells",
      "prepared_spells"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Magia del Patto",
        pageStart: 164,
        pageEnd: 165,
        section: "Magia del Patto",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "proficiency_bonus_multiclass": GlossaryEntry(
    id: "proficiency_bonus_multiclass",
    name: "Bonus di Competenza del Multiclasse",
    category: GlossaryCategory.regola,
    summary:
        "Il Bonus di Competenza di un personaggio multiclasse dipende dal livello totale, non dai singoli livelli di classe.",
    details:
        "Si consulta la tabella di avanzamento del personaggio usando la somma di tutti i livelli posseduti. Il bonus non viene sommato tra le diverse classi.",
    relatedIds: [
      "multiclassing",
      "proficiency_bonus",
      "character_level",
      "class_level"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punti Esperienza",
        pageStart: 163,
        pageEnd: 163,
        section: "Punti Esperienza",
      ),
    ],
    tags: {"phb", "personaggio", "regola"},
  ),
  "alignment": GlossaryEntry(
    id: "alignment",
    name: "Allineamento",
    aliases: {"Allineamenti"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una descrizione generale degli atteggiamenti morali e personali del personaggio.",
    details:
        "L’allineamento combina un asse tra legge e caos con uno tra bene e male. È uno strumento interpretativo e non obbliga il personaggio a comportarsi sempre nello stesso modo.",
    sections: [
      GlossarySectionDefinition(
        id: "alignment_axes",
        title: "I due assi",
        type: GlossarySectionType.completeRule,
        content:
            "Legale, Neutrale o Caotico; Buono, Neutrale o Malvagio. La combinazione produce nove allineamenti comuni.",
        numericValues: {"commonAlignmentCount": 9},
      ),
    ],
    relatedIds: ["personality_trait", "ideal", "bond", "flaw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Allineamento",
        pageStart: 122,
        pageEnd: 123,
        section: "Allineamento",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "personality_trait": GlossaryEntry(
    id: "personality_trait",
    name: "Tratto della Personalità",
    aliases: {"Tratti della Personalità"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un modo di fare, interesse, abitudine o peculiarità che aiuta a distinguere il personaggio.",
    details:
        "Un background propone esempi, ma il giocatore può scegliere o inventare tratti adatti alla storia del personaggio.",
    relatedIds: [
      "background_definition",
      "ideal",
      "bond",
      "flaw",
      "inspiration"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Caratteristiche Personali",
        pageStart: 123,
        pageEnd: 124,
        section: "Caratteristiche Personali",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "ideal": GlossaryEntry(
    id: "ideal",
    name: "Ideale",
    aliases: {"Ideali"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Il principio, obiettivo morale o convinzione fondamentale che guida il personaggio.",
    details:
        "L’ideale può essere collegato all’allineamento, ma può anche derivare da fede, ambizione, tradizione o esperienza personale.",
    relatedIds: [
      "background_definition",
      "alignment",
      "personality_trait",
      "bond",
      "flaw",
      "inspiration"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Ideali",
        pageStart: 124,
        pageEnd: 124,
        section: "Ideali",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "bond": GlossaryEntry(
    id: "bond",
    name: "Legame",
    aliases: {"Legami"},
    category: GlossaryCategory.caratteristica,
    summary:
        "La persona, il luogo, l’oggetto o il dovere a cui il personaggio è profondamente legato.",
    details:
        "Un legame può motivare l’avventura, creare responsabilità, definire ciò che il personaggio vuole proteggere o offrire al Dungeon Master spunti narrativi.",
    relatedIds: [
      "background_definition",
      "personality_trait",
      "ideal",
      "flaw",
      "inspiration"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Legami",
        pageStart: 124,
        pageEnd: 124,
        section: "Legami",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "flaw": GlossaryEntry(
    id: "flaw",
    name: "Difetto",
    aliases: {"Difetti"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una debolezza, paura, vizio o vulnerabilità che può causare problemi al personaggio.",
    details:
        "Un difetto significativo crea decisioni e complicazioni narrative e può essere usato dal Dungeon Master per assegnare Ispirazione quando influenza davvero il gioco.",
    relatedIds: [
      "background_definition",
      "personality_trait",
      "ideal",
      "bond",
      "inspiration"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Difetti",
        pageStart: 124,
        pageEnd: 125,
        section: "Difetti",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "language_definition": GlossaryEntry(
    id: "language_definition",
    name: "Lingua",
    aliases: {"Lingue"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un idioma che un personaggio può parlare e normalmente anche leggere e scrivere.",
    details:
        "Razza e background concedono lingue iniziali; alcune classi, talenti o capacità ne aggiungono altre. Il Dungeon Master può introdurre lingue rare o segrete.",
    relatedIds: ["racial_language", "background_definition"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Lingue",
        pageStart: 123,
        pageEnd: 123,
        section: "Lingue",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "age_definition": GlossaryEntry(
    id: "age_definition",
    name: "Età",
    category: GlossaryCategory.caratteristica,
    summary:
        "L’età del personaggio e le tappe di maturità e longevità tipiche della sua razza.",
    details:
        "L’età può influenzare storia e aspetto del personaggio, ma nel Manuale del Giocatore non modifica automaticamente i punteggi di caratteristica.",
    relatedIds: ["race_definition"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Età",
        pageStart: 17,
        pageEnd: 43,
        section: "Età",
      ),
    ],
    tags: {"phb", "personaggio", "caratteristica"},
  ),
  "starting_equipment": GlossaryEntry(
    id: "starting_equipment",
    name: "Equipaggiamento Iniziale",
    aliases: {"Equipaggiamento di Partenza"},
    category: GlossaryCategory.equipaggiamento,
    summary: "Gli oggetti posseduti dal personaggio all’inizio del gioco.",
    details:
        "Classe e background propongono dotazioni e scelte iniziali. In alternativa, con il permesso previsto dalle regole, il personaggio può acquistare equipaggiamento usando la ricchezza iniziale della classe.",
    relatedIds: [
      "class_definition",
      "background_definition",
      "equipment_pack",
      "currency",
      "weapon",
      "armor"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Scegliere l’Equipaggiamento",
        pageStart: 14,
        pageEnd: 14,
        section: "Scegliere l’Equipaggiamento",
      ),
    ],
    tags: {"phb", "personaggio", "equipaggiamento"},
  ),
};
