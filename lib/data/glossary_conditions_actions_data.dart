import 'class_data.dart';

/// Condizioni e azioni fondamentali del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbConditionActionGlossaryEntries = {
  "blinded": GlossaryEntry(
    id: "blinded",
    name: "Accecato",
    aliases: {"Accecata", "Accecati", "Accecate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura accecata non può vedere e fallisce automaticamente le prove di caratteristica basate sulla vista.",
    details:
        "I tiri per colpire contro la creatura dispongono di vantaggio, mentre i suoi tiri per colpire subiscono svantaggio.",
    relatedIds: ["ability_check", "attack_roll", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "charmed": GlossaryEntry(
    id: "charmed",
    name: "Affascinato",
    aliases: {"Affascinata", "Affascinati", "Affascinate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura affascinata non può attaccare chi l’ha affascinata né prenderla come bersaglio di capacità o effetti magici nocivi.",
    details:
        "Chi ha provocato la condizione dispone di vantaggio alle prove di caratteristica effettuate per interagire socialmente con la creatura.",
    relatedIds: ["attack_roll", "ability_check", "advantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "grappled": GlossaryEntry(
    id: "grappled",
    name: "Afferrato",
    aliases: {"Afferrata", "Afferrati", "Afferrate"},
    category: GlossaryCategory.condizione,
    summary:
        "La velocità di una creatura afferrata diventa 0 e non può beneficiare di alcun bonus alla velocità.",
    details:
        "La condizione termina se chi afferra diventa incapacitato o se un effetto allontana la creatura afferrata dalla portata di chi la trattiene.",
    sections: [
      GlossarySectionDefinition(
        id: "grappled_speed",
        title: "Velocità",
        type: GlossarySectionType.completeRule,
        content:
            "La velocità diventa 0 e la creatura non può beneficiare di bonus alla velocità.",
        numericValues: {"speedMeters": 0},
      ),
    ],
    relatedIds: ["grapple", "escape_grapple", "incapacitated", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "deafened": GlossaryEntry(
    id: "deafened",
    name: "Assordato",
    aliases: {"Assordata", "Assordati", "Assordate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura assordata non può sentire e fallisce automaticamente le prove di caratteristica basate sull’udito.",
    details:
        "La condizione non impedisce automaticamente di parlare, muoversi o vedere.",
    relatedIds: ["ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "poisoned": GlossaryEntry(
    id: "poisoned",
    name: "Avvelenato",
    aliases: {"Avvelenata", "Avvelenati", "Avvelenate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura avvelenata subisce svantaggio ai tiri per colpire e alle prove di caratteristica.",
    details:
        "La condizione non implica necessariamente danni da veleno: durata ed eventuali altri effetti dipendono dalla fonte.",
    relatedIds: ["attack_roll", "ability_check", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "incapacitated": GlossaryEntry(
    id: "incapacitated",
    name: "Incapacitato",
    aliases: {"Incapacitata", "Incapacitati", "Incapacitate"},
    category: GlossaryCategory.condizione,
    summary: "Una creatura incapacitata non può compiere azioni o reazioni.",
    details:
        "Altre condizioni, come paralizzato, pietrificato, stordito e privo di sensi, rendono a loro volta la creatura incapacitata.",
    relatedIds: [
      "action",
      "reaction",
      "paralyzed",
      "petrified",
      "stunned",
      "unconscious"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 290,
        pageEnd: 290,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "invisible": GlossaryEntry(
    id: "invisible",
    name: "Invisibile",
    aliases: {"Invisibili"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura invisibile non può essere vista senza l’aiuto della magia o di un senso speciale.",
    details:
        "Ai fini del nascondersi la creatura è considerata pesantemente oscurata. I suoi tiri per colpire dispongono di vantaggio e quelli contro di lei subiscono svantaggio; rumori e tracce possono comunque rivelarne la posizione.",
    relatedIds: ["hide_action", "attack_roll", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 291,
        pageEnd: 291,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "paralyzed": GlossaryEntry(
    id: "paralyzed",
    name: "Paralizzato",
    aliases: {"Paralizzata", "Paralizzati", "Paralizzate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura paralizzata è incapacitata, non può muoversi o parlare e fallisce automaticamente i tiri salvezza su Forza e Destrezza.",
    details:
        "I tiri per colpire contro di lei dispongono di vantaggio. Un attacco che la colpisce da una distanza non superiore a 1,5 metri è un colpo critico.",
    sections: [
      GlossarySectionDefinition(
        id: "paralyzed_close_critical",
        title: "Attacchi ravvicinati",
        type: GlossarySectionType.interaction,
        content:
            "Ogni attacco che colpisce la creatura da una distanza non superiore a 1,5 metri è un Colpo Critico.",
        numericValues: {"maximumDistanceMeters": 1.5},
        relatedIds: ["critical_hit"],
      ),
    ],
    relatedIds: [
      "incapacitated",
      "saving_throw",
      "attack_roll",
      "critical_hit"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 291,
        pageEnd: 291,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "petrified": GlossaryEntry(
    id: "petrified",
    name: "Pietrificato",
    aliases: {"Pietrificata", "Pietrificati", "Pietrificate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura pietrificata e gli oggetti non magici che indossa o trasporta si trasformano in una sostanza solida inanimata.",
    details:
        "Il peso della creatura aumenta di dieci volte e la creatura non invecchia. È incapacitata, non può muoversi o parlare, non è consapevole dell’ambiente, fallisce automaticamente i tiri salvezza su Forza e Destrezza, dispone di resistenza a tutti i danni ed è immune a veleno e malattie.",
    sections: [
      GlossarySectionDefinition(
        id: "petrified_weight",
        title: "Trasformazione",
        type: GlossarySectionType.completeRule,
        content:
            "Il peso della creatura aumenta di dieci volte e la creatura non invecchia durante la pietrificazione.",
        numericValues: {"weightMultiplier": 10},
      ),
    ],
    relatedIds: [
      "incapacitated",
      "saving_throw",
      "damage_resistance",
      "poisoned"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 291,
        pageEnd: 291,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "unconscious": GlossaryEntry(
    id: "unconscious",
    name: "Privo di Sensi",
    aliases: {"Priva di Sensi", "Privi di Sensi", "Prive di Sensi"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura priva di sensi è incapacitata, non può muoversi o parlare e non è consapevole dell’ambiente circostante.",
    details:
        "Lascia cadere ciò che impugna, cade prona e fallisce automaticamente i tiri salvezza su Forza e Destrezza. Gli attacchi contro di lei dispongono di vantaggio e quelli che colpiscono entro 1,5 metri sono colpi critici.",
    sections: [
      GlossarySectionDefinition(
        id: "unconscious_close_critical",
        title: "Attacchi ravvicinati",
        type: GlossarySectionType.interaction,
        content:
            "Un attacco che colpisce la creatura da una distanza non superiore a 1,5 metri è un Colpo Critico.",
        numericValues: {"maximumDistanceMeters": 1.5},
        relatedIds: ["critical_hit"],
      ),
    ],
    relatedIds: [
      "incapacitated",
      "prone",
      "saving_throw",
      "attack_roll",
      "critical_hit"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 292,
        pageEnd: 292,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "prone": GlossaryEntry(
    id: "prone",
    name: "Prono",
    aliases: {"Prona", "Proni", "Prone"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura prona può muoversi soltanto strisciando, a meno che non si rialzi spendendo metà della propria velocità.",
    details:
        "La creatura subisce svantaggio ai propri tiri per colpire. Un attacco contro di lei dispone di vantaggio se l’attaccante si trova entro 1,5 metri, altrimenti subisce svantaggio.",
    sections: [
      GlossarySectionDefinition(
        id: "prone_stand",
        title: "Rialzarsi",
        type: GlossarySectionType.procedure,
        content:
            "Per rialzarsi la creatura deve spendere una quantità di movimento pari a metà della propria velocità.",
        numericValues: {"speedFractionDivisor": 2},
        relatedIds: ["movement"],
      ),
    ],
    relatedIds: ["movement", "attack_roll", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 292,
        pageEnd: 292,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "frightened": GlossaryEntry(
    id: "frightened",
    name: "Spaventato",
    aliases: {"Spaventata", "Spaventati", "Spaventate"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura spaventata subisce svantaggio alle prove di caratteristica e ai tiri per colpire finché la fonte della paura si trova entro la sua linea di vista.",
    details:
        "La creatura non può avvicinarsi volontariamente alla fonte della propria paura.",
    relatedIds: ["ability_check", "attack_roll", "disadvantage", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 292,
        pageEnd: 292,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "stunned": GlossaryEntry(
    id: "stunned",
    name: "Stordito",
    aliases: {"Stordita", "Storditi", "Stordite"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura stordita è incapacitata, non può muoversi e può parlare soltanto in modo esitante.",
    details:
        "Fallisce automaticamente i tiri salvezza su Forza e Destrezza e i tiri per colpire contro di lei dispongono di vantaggio.",
    relatedIds: ["incapacitated", "saving_throw", "attack_roll", "advantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 292,
        pageEnd: 292,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "restrained": GlossaryEntry(
    id: "restrained",
    name: "Trattenuto",
    aliases: {"Trattenuta", "Trattenuti", "Trattenute"},
    category: GlossaryCategory.condizione,
    summary:
        "La velocità di una creatura trattenuta diventa 0 e non può beneficiare di alcun bonus alla velocità.",
    details:
        "I tiri per colpire contro di lei dispongono di vantaggio, i suoi tiri per colpire subiscono svantaggio e i suoi tiri salvezza su Destrezza subiscono svantaggio.",
    sections: [
      GlossarySectionDefinition(
        id: "restrained_speed",
        title: "Velocità",
        type: GlossarySectionType.completeRule,
        content:
            "La velocità diventa 0 e la creatura non può beneficiare di bonus alla velocità.",
        numericValues: {"speedMeters": 0},
      ),
    ],
    relatedIds: [
      "movement",
      "attack_roll",
      "saving_throw",
      "advantage",
      "disadvantage"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Condizioni",
        pageStart: 292,
        pageEnd: 292,
        section: "Condizioni",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "exhaustion": GlossaryEntry(
    id: "exhaustion",
    name: "Indebolimento",
    category: GlossaryCategory.condizione,
    summary:
        "L’indebolimento è una condizione cumulativa divisa in sei livelli, ciascuno dei quali aggiunge i propri effetti a quelli precedenti.",
    details:
        "Una creatura subisce gli effetti del proprio livello e di tutti i livelli inferiori. Un effetto che riduce l’indebolimento ne abbassa il livello del valore indicato; scendere sotto il livello 1 rimuove la condizione.",
    sections: [
      GlossarySectionDefinition(
        id: "exhaustion_levels",
        title: "I sei livelli",
        type: GlossarySectionType.completeRule,
        content:
            "Livello 1: svantaggio alle prove di caratteristica. Livello 2: velocità dimezzata. Livello 3: svantaggio ai tiri per colpire e ai tiri salvezza. Livello 4: punti ferita massimi dimezzati. Livello 5: velocità 0. Livello 6: morte.",
        numericValues: {"maximumLevel": 6, "deathLevel": 6},
      ),
      GlossarySectionDefinition(
        id: "exhaustion_recovery",
        title: "Recupero",
        type: GlossarySectionType.interaction,
        content:
            "Terminare un Riposo Lungo riduce l’indebolimento di un livello, purché la creatura abbia anche ingerito cibo e bevande.",
        numericValues: {"levelsRemovedByLongRest": 1},
        relatedIds: ["long_rest"],
      ),
    ],
    relatedIds: [
      "ability_check",
      "attack_roll",
      "saving_throw",
      "hit_points",
      "movement",
      "long_rest"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Indebolimento",
        pageStart: 291,
        pageEnd: 291,
        section: "Indebolimento",
      ),
    ],
    tags: {"phb", "glossario", "condizione"},
  ),
  "attack_action": GlossaryEntry(
    id: "attack_action",
    name: "Attaccare",
    category: GlossaryCategory.azione,
    summary:
        "Con l’azione Attaccare una creatura effettua un attacco in mischia o a distanza.",
    details:
        "Alcuni privilegi consentono di effettuare più di un attacco con la stessa azione. Ciascun attacco richiede normalmente un tiro per colpire separato.",
    relatedIds: ["action", "attack_roll", "grapple", "shove"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "cast_spell_action": GlossaryEntry(
    id: "cast_spell_action",
    name: "Lanciare un Incantesimo",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura può lanciare un incantesimo quando il suo tempo di lancio richiede un’azione e soddisfa tutti gli altri requisiti.",
    details:
        "Gli incantesimi possono richiedere azioni, azioni bonus, reazioni o tempi più lunghi. Gli effetti e i bersagli sono determinati dalla descrizione dell’incantesimo.",
    relatedIds: ["action", "bonus_action", "reaction"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "dash_action": GlossaryEntry(
    id: "dash_action",
    name: "Scatto",
    category: GlossaryCategory.azione,
    summary:
        "L’azione Scatto concede movimento aggiuntivo per il turno corrente pari alla velocità della creatura dopo l’applicazione dei modificatori.",
    details:
        "Se la velocità è 9 metri, effettuare uno Scatto consente fino a 9 metri aggiuntivi di movimento. Ogni aumento o riduzione della velocità modifica allo stesso modo il movimento aggiuntivo.",
    relatedIds: ["action", "movement", "difficult_terrain"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "disengage_action": GlossaryEntry(
    id: "disengage_action",
    name: "Disimpegno",
    category: GlossaryCategory.azione,
    summary:
        "Quando una creatura usa l’azione Disimpegno, il suo movimento non provoca attacchi di opportunità per il resto del turno.",
    details:
        "La protezione riguarda il movimento effettuato nello stesso turno e non impedisce altre reazioni che possiedono condizioni di attivazione differenti.",
    relatedIds: ["action", "movement", "opportunity_attack"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "dodge_action": GlossaryEntry(
    id: "dodge_action",
    name: "Schivata",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura che usa l’azione Schivata si concentra interamente sull’evitare gli attacchi.",
    details:
        "Fino all’inizio del suo turno successivo, ogni tiro per colpire contro di lei subisce svantaggio se può vedere l’attaccante e la creatura dispone di vantaggio ai tiri salvezza su Destrezza. Perde questi benefici se diventa incapacitata o se la sua velocità scende a 0.",
    relatedIds: [
      "action",
      "attack_roll",
      "saving_throw",
      "advantage",
      "disadvantage",
      "incapacitated"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "help_action": GlossaryEntry(
    id: "help_action",
    name: "Aiuto",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura può aiutare un’altra creatura a completare un compito, concedendole vantaggio alla successiva prova appropriata.",
    details:
        "In combattimento può anche distrarre un nemico entro 1,5 metri: il primo tiro per colpire effettuato da un alleato contro quel bersaglio prima del turno successivo di chi aiuta dispone di vantaggio.",
    sections: [
      GlossarySectionDefinition(
        id: "help_attack_range",
        title: "Aiutare un attacco",
        type: GlossarySectionType.interaction,
        content:
            "Il bersaglio deve trovarsi entro 1,5 metri da chi usa Aiuto quando l’azione viene effettuata.",
        numericValues: {"maximumDistanceMeters": 1.5},
      ),
    ],
    relatedIds: ["action", "ability_check", "attack_roll", "advantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "hide_action": GlossaryEntry(
    id: "hide_action",
    name: "Nascondersi",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura che usa l’azione Nascondersi effettua una prova di Destrezza (Furtività) secondo le regole per nascondersi.",
    details:
        "In caso di successo ottiene i benefici derivanti dall’essere nascosta. Il Dungeon Master determina se le circostanze consentono il tentativo.",
    relatedIds: ["action", "ability_check", "invisible"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 192,
        pageEnd: 192,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "ready_action": GlossaryEntry(
    id: "ready_action",
    name: "Prepararsi",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura può preparare un’azione da risolvere in seguito come reazione a una circostanza percepibile.",
    details:
        "La creatura sceglie l’evento scatenante e l’azione che effettuerà in risposta. Quando l’evento si verifica può usare la propria reazione subito dopo, oppure ignorarlo.",
    sections: [
      GlossarySectionDefinition(
        id: "ready_spell",
        title: "Preparare un incantesimo",
        type: GlossarySectionType.specialCases,
        content:
            "L’incantesimo viene lanciato normalmente durante la preparazione, mantenendone l’energia tramite concentrazione fino all’evento scatenante. Se la concentrazione si interrompe, l’incantesimo si dissolve senza effetto.",
        relatedIds: ["cast_spell_action"],
      ),
    ],
    relatedIds: ["action", "reaction", "cast_spell_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 193,
        pageEnd: 193,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "search_action": GlossaryEntry(
    id: "search_action",
    name: "Cercare",
    category: GlossaryCategory.azione,
    summary:
        "Quando una creatura usa l’azione Cercare dedica la propria attenzione a trovare qualcosa.",
    details:
        "Il Dungeon Master può richiedere una prova di Saggezza (Percezione) o di Intelligenza (Indagare), a seconda di ciò che viene cercato.",
    relatedIds: ["action", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 193,
        pageEnd: 193,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "use_object_action": GlossaryEntry(
    id: "use_object_action",
    name: "Usare un Oggetto",
    category: GlossaryCategory.azione,
    summary:
        "Quando l’utilizzo di un oggetto richiede un’azione, una creatura effettua l’azione Usare un Oggetto.",
    details:
        "Questa azione serve anche quando una creatura vuole interagire con un secondo oggetto nello stesso turno dopo avere già utilizzato la normale interazione gratuita.",
    relatedIds: ["action", "object_interaction"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 193,
        pageEnd: 193,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "grapple": GlossaryEntry(
    id: "grapple",
    name: "Lottare",
    aliases: {"Lotta", "Afferrare"},
    category: GlossaryCategory.azione,
    summary:
        "Una creatura può sostituire uno dei propri attacchi dell’azione Attaccare con un tentativo di afferrare un bersaglio.",
    details:
        "Il bersaglio deve essere al massimo di una categoria di taglia superiore e deve trovarsi entro portata. Si effettua una prova di Forza (Atletica) contrapposta alla Forza (Atletica) o Destrezza (Acrobazia) del bersaglio.",
    relatedIds: [
      "attack_action",
      "ability_check",
      "grappled",
      "escape_grapple"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi in Mischia",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi in Mischia",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "escape_grapple": GlossaryEntry(
    id: "escape_grapple",
    name: "Sfuggire a una Lotta",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura afferrata può usare la propria azione per tentare di liberarsi.",
    details:
        "Effettua una prova di Forza (Atletica) o Destrezza (Acrobazia) contrapposta alla prova di Forza (Atletica) di chi la trattiene. Se vince, la condizione Afferrato termina.",
    relatedIds: ["action", "ability_check", "grapple", "grappled"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi in Mischia",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi in Mischia",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "shove": GlossaryEntry(
    id: "shove",
    name: "Spingere una Creatura",
    category: GlossaryCategory.azione,
    summary:
        "Una creatura può sostituire uno dei propri attacchi dell’azione Attaccare con un tentativo di spingere un bersaglio.",
    details:
        "Il bersaglio deve essere al massimo di una categoria di taglia superiore e trovarsi entro portata. Con una prova contrapposta riuscita, l’attaccante sceglie se farlo cadere prono oppure allontanarlo di 1,5 metri.",
    sections: [
      GlossarySectionDefinition(
        id: "shove_distance",
        title: "Allontanamento",
        type: GlossarySectionType.completeRule,
        content:
            "In alternativa a rendere il bersaglio Prono, chi spinge può allontanarlo di 1,5 metri.",
        numericValues: {"distanceMeters": 1.5},
        relatedIds: ["prone"],
      ),
    ],
    relatedIds: ["attack_action", "ability_check", "prone", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi in Mischia",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi in Mischia",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "two_weapon_fighting": GlossaryEntry(
    id: "two_weapon_fighting",
    name: "Combattere con Due Armi",
    category: GlossaryCategory.azione,
    summary:
        "Quando una creatura attacca con un’arma da mischia leggera impugnata in una mano, può usare un’azione bonus per attaccare con un’altra arma da mischia leggera impugnata nell’altra mano.",
    details:
        "All’attacco dell’azione bonus non si aggiunge il modificatore di caratteristica ai danni, salvo che quel modificatore sia negativo. Se una delle armi possiede la proprietà da lancio, può essere lanciata.",
    relatedIds: ["attack_action", "bonus_action", "attack_roll", "damage_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combattere con Due Armi",
        pageStart: 195,
        pageEnd: 195,
        section: "Combattere con Due Armi",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
  "object_interaction": GlossaryEntry(
    id: "object_interaction",
    name: "Interazione con un Oggetto",
    category: GlossaryCategory.azione,
    summary:
        "Durante il proprio movimento o la propria azione una creatura può normalmente interagire gratuitamente con un oggetto o elemento dell’ambiente.",
    details:
        "Per interagire con un secondo oggetto nello stesso turno è necessario usare l’azione Usare un Oggetto. Il Dungeon Master può richiedere un’azione anche per interazioni particolarmente impegnative.",
    sections: [
      GlossarySectionDefinition(
        id: "object_interaction_limit",
        title: "Interazione gratuita",
        type: GlossarySectionType.completeRule,
        content:
            "È normalmente disponibile una sola interazione gratuita con un oggetto durante il proprio movimento o la propria azione.",
        numericValues: {"freeInteractionsPerTurn": 1},
        relatedIds: ["use_object_action"],
      ),
    ],
    relatedIds: ["action", "use_object_action", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Altre Attività nel Proprio Turno",
        pageStart: 190,
        pageEnd: 190,
        section: "Altre Attività nel Proprio Turno",
      ),
    ],
    tags: {"phb", "glossario", "azione"},
  ),
};
