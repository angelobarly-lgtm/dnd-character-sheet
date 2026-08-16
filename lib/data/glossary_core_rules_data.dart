import 'class_data.dart';

/// Regole fondamentali del Manuale del Giocatore 2014.
///
/// Le descrizioni sono sintetizzate per l’uso interattivo nell’app;
/// le fonti conservano il riferimento alla regola completa del manuale.
const Map<String, GlossaryEntry> phbCoreGlossaryEntries = {
  "ability_check": GlossaryEntry(
    id: "ability_check",
    name: "Prova di Caratteristica",
    aliases: {"Prove di Caratteristica"},
    category: GlossaryCategory.regola,
    summary:
        "Un tiro di d20 determina se una creatura riesce a superare un compito il cui esito è incerto.",
    details:
        "Si tira un d20, si aggiunge il modificatore della caratteristica indicata e si confronta il totale con la Classe Difficoltà stabilita dal Dungeon Master.",
    sections: [
      GlossarySectionDefinition(
        id: "ability_check_procedure",
        title: "Come si risolve",
        type: GlossarySectionType.procedure,
        content:
            "Tira 1d20 e aggiungi il modificatore della caratteristica pertinente. Se il totale è pari o superiore alla Classe Difficoltà, la prova riesce.",
        numericValues: {"diceCount": 1, "dieSize": 20},
      ),
      GlossarySectionDefinition(
        id: "ability_check_skills",
        title: "Abilità e competenza",
        type: GlossarySectionType.interaction,
        content:
            "Quando una prova coinvolge un’abilità in cui il personaggio è competente, al tiro si aggiunge anche il Bonus di Competenza.",
        relatedIds: ["proficiency_bonus"],
      ),
    ],
    relatedIds: ["proficiency_bonus", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Prove di Caratteristica",
        pageStart: 174,
        pageEnd: 175,
        section: "Prove di Caratteristica",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "proficiency_bonus": GlossaryEntry(
    id: "proficiency_bonus",
    name: "Bonus di Competenza",
    category: GlossaryCategory.regola,
    summary:
        "Un bonus determinato dal livello totale del personaggio che si applica quando una regola concede competenza.",
    details:
        "Il Bonus di Competenza può applicarsi a tiri per colpire, tiri salvezza, prove di caratteristica e altri usi indicati dalle regole. Normalmente non si aggiunge più di una volta allo stesso tiro.",
    relatedIds: ["ability_check", "saving_throw", "attack_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Bonus di Competenza",
        pageStart: 173,
        pageEnd: 174,
        section: "Bonus di Competenza",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "advantage": GlossaryEntry(
    id: "advantage",
    name: "Vantaggio",
    category: GlossaryCategory.regola,
    summary:
        "Quando una creatura dispone di vantaggio, tira due d20 e usa il risultato più alto.",
    details:
        "Più fonti di vantaggio non fanno tirare dadi aggiuntivi. Se vantaggio e svantaggio si applicano allo stesso tiro, si annullano e si tira un solo d20.",
    sections: [
      GlossarySectionDefinition(
        id: "advantage_roll",
        title: "Tiro con vantaggio",
        type: GlossarySectionType.procedure,
        content:
            "Tira 2d20 e conserva il risultato più alto. Applica poi normalmente modificatori e bonus.",
        numericValues: {"diceCount": 2, "dieSize": 20},
      ),
      GlossarySectionDefinition(
        id: "advantage_cancellation",
        title: "Interazione con lo svantaggio",
        type: GlossarySectionType.interaction,
        content:
            "Se almeno una fonte concede vantaggio e almeno una impone svantaggio, il tiro non dispone né dell’uno né dell’altro, indipendentemente dal numero di fonti.",
        relatedIds: ["disadvantage"],
      ),
    ],
    relatedIds: ["disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vantaggio e Svantaggio",
        pageStart: 173,
        pageEnd: 173,
        section: "Vantaggio e Svantaggio",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "disadvantage": GlossaryEntry(
    id: "disadvantage",
    name: "Svantaggio",
    category: GlossaryCategory.regola,
    summary:
        "Quando una creatura subisce svantaggio, tira due d20 e usa il risultato più basso.",
    details:
        "Più fonti di svantaggio non fanno tirare dadi aggiuntivi. Se vantaggio e svantaggio si applicano allo stesso tiro, si annullano.",
    sections: [
      GlossarySectionDefinition(
        id: "disadvantage_roll",
        title: "Tiro con svantaggio",
        type: GlossarySectionType.procedure,
        content:
            "Tira 2d20 e conserva il risultato più basso. Applica poi normalmente modificatori e bonus.",
        numericValues: {"diceCount": 2, "dieSize": 20},
      ),
    ],
    relatedIds: ["advantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vantaggio e Svantaggio",
        pageStart: 173,
        pageEnd: 173,
        section: "Vantaggio e Svantaggio",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "saving_throw": GlossaryEntry(
    id: "saving_throw",
    name: "Tiro Salvezza",
    aliases: {"Tiri Salvezza"},
    category: GlossaryCategory.regola,
    summary:
        "Un tiro effettuato per resistere o sottrarsi a un incantesimo, una trappola, un veleno, una malattia o un’altra minaccia.",
    details:
        "Si tira un d20 e si aggiunge il modificatore della caratteristica indicata. Il Bonus di Competenza si aggiunge soltanto se la creatura è competente in quel tiro salvezza.",
    sections: [
      GlossarySectionDefinition(
        id: "saving_throw_procedure",
        title: "Come si risolve",
        type: GlossarySectionType.procedure,
        content:
            "Tira 1d20, aggiungi il modificatore della caratteristica richiesta e, se previsto, il Bonus di Competenza. Il totale deve raggiungere o superare la CD dell’effetto.",
        numericValues: {"diceCount": 1, "dieSize": 20},
        relatedIds: ["proficiency_bonus"],
      ),
    ],
    relatedIds: ["proficiency_bonus", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiri Salvezza",
        pageStart: 179,
        pageEnd: 179,
        section: "Tiri Salvezza",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "attack_roll": GlossaryEntry(
    id: "attack_roll",
    name: "Tiro per Colpire",
    aliases: {"Tiro di Attacco", "Tiri per Colpire"},
    category: GlossaryCategory.combattimento,
    summary: "Il tiro che determina se un attacco colpisce il bersaglio.",
    details:
        "Si tira un d20 e si aggiungono il modificatore appropriato e gli eventuali bonus. L’attacco colpisce se il totale è pari o superiore alla Classe Armatura del bersaglio.",
    sections: [
      GlossarySectionDefinition(
        id: "attack_roll_natural_results",
        title: "Risultati naturali",
        type: GlossarySectionType.specialCases,
        content:
            "Un 1 naturale sul d20 manca sempre. Un 20 naturale colpisce sempre ed è un Colpo Critico.",
        numericValues: {"automaticMiss": 1, "automaticHit": 20},
        relatedIds: ["critical_hit"],
      ),
    ],
    relatedIds: ["armor_class", "critical_hit", "proficiency_bonus"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Effettuare un Attacco",
        pageStart: 194,
        pageEnd: 194,
        section: "Effettuare un Attacco",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "armor_class": GlossaryEntry(
    id: "armor_class",
    name: "Classe Armatura",
    category: GlossaryCategory.combattimento,
    summary:
        "Il valore che rappresenta quanto sia difficile colpire una creatura con un attacco.",
    details:
        "Un tiro per colpire deve eguagliare o superare la Classe Armatura del bersaglio. Armatura, scudo, Destrezza, magia e capacità speciali possono determinarla o modificarla.",
    relatedIds: ["attack_roll", "cover"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Classe Armatura",
        pageStart: 177,
        pageEnd: 177,
        section: "Classe Armatura",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "critical_hit": GlossaryEntry(
    id: "critical_hit",
    name: "Colpo Critico",
    aliases: {"Colpi Critici"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un attacco che ottiene 20 naturale infligge danni aggiuntivi tirando due volte tutti i dadi di danno dell’attacco.",
    details:
        "Si tirano due volte tutti i dadi di danno dell’attacco, compresi i dadi aggiuntivi applicabili al colpo. I modificatori fissi vengono aggiunti una sola volta.",
    sections: [
      GlossarySectionDefinition(
        id: "critical_hit_dice",
        title: "Dadi raddoppiati",
        type: GlossarySectionType.procedure,
        content:
            "Raccogli tutti i dadi di danno dell’attacco, tirali due volte, somma i risultati e aggiungi una sola volta i modificatori pertinenti.",
        numericValues: {"damageDiceMultiplier": 2},
      ),
    ],
    relatedIds: ["attack_roll", "damage_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Colpi Critici",
        pageStart: 196,
        pageEnd: 196,
        section: "Colpi Critici",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "damage_roll": GlossaryEntry(
    id: "damage_roll",
    name: "Tiro per i Danni",
    aliases: {"Tiro dei Danni"},
    category: GlossaryCategory.combattimento,
    summary:
        "Il tiro che determina quanti danni infligge un’arma, un incantesimo o un altro effetto.",
    details:
        "L’arma o l’effetto indica i dadi da tirare e gli eventuali modificatori. Ogni tipo di danno può interagire con resistenze, vulnerabilità e immunità.",
    relatedIds: [
      "damage_types",
      "damage_resistance",
      "damage_vulnerability",
      "damage_immunity"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Danni e Guarigione",
        pageStart: 196,
        pageEnd: 197,
        section: "Danni e Guarigione",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "damage_types": GlossaryEntry(
    id: "damage_types",
    name: "Tipi di Danno",
    category: GlossaryCategory.combattimento,
    summary:
        "Le categorie che descrivono la natura dei danni, come contundenti, perforanti, taglienti, da fuoco o necrotici.",
    details:
        "Il tipo non aggiunge regole proprie, ma permette a resistenze, vulnerabilità, immunità e capacità speciali di modificare gli effetti dei danni.",
    relatedIds: [
      "damage_roll",
      "damage_resistance",
      "damage_vulnerability",
      "damage_immunity"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "damage_vulnerability": GlossaryEntry(
    id: "damage_vulnerability",
    name: "Vulnerabilità ai Danni",
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura vulnerabile a un tipo di danno subisce il doppio dei danni di quel tipo.",
    details:
        "Resistenza e vulnerabilità si applicano dopo gli altri modificatori ai danni. Più fonti della stessa vulnerabilità non si cumulano.",
    sections: [
      GlossarySectionDefinition(
        id: "damage_vulnerability_multiplier",
        title: "Moltiplicatore",
        type: GlossarySectionType.completeRule,
        content:
            "Dopo gli altri modificatori applicabili, raddoppia i danni del tipo a cui la creatura è vulnerabile.",
        numericValues: {"damageMultiplier": 2},
      ),
    ],
    relatedIds: ["damage_resistance", "damage_immunity", "damage_types"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Resistenza e Vulnerabilità ai Danni",
        pageStart: 197,
        pageEnd: 197,
        section: "Resistenza e Vulnerabilità ai Danni",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "damage_immunity": GlossaryEntry(
    id: "damage_immunity",
    name: "Immunità ai Danni",
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura immune a un tipo di danno non subisce danni di quel tipo.",
    details:
        "L’immunità ai danni è distinta dall’Immunità a una Condizione. Una creatura può possedere l’una senza possedere l’altra.",
    relatedIds: [
      "damage_resistance",
      "damage_vulnerability",
      "condition_immunity"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Resistenza e Vulnerabilità ai Danni",
        pageStart: 197,
        pageEnd: 197,
        section: "Resistenza e Vulnerabilità ai Danni",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "hit_points": GlossaryEntry(
    id: "hit_points",
    name: "Punti Ferita",
    category: GlossaryCategory.risorsa,
    summary:
        "La misura della resistenza fisica e mentale, della volontà di vivere e della capacità di evitare conseguenze letali.",
    details:
        "I punti ferita attuali possono variare da 0 al massimo della creatura. Finché una creatura possiede almeno 1 punto ferita può normalmente agire senza penalità dovute ai danni subiti.",
    sections: [
      GlossarySectionDefinition(
        id: "hit_points_bounds",
        title: "Valori minimo e massimo",
        type: GlossarySectionType.completeRule,
        content:
            "I punti ferita attuali non possono superare il massimo della creatura e non scendono sotto 0.",
        numericValues: {"minimumCurrentHitPoints": 0},
      ),
    ],
    relatedIds: [
      "temporary_hit_points",
      "healing",
      "dropping_to_zero_hit_points"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punti Ferita",
        pageStart: 196,
        pageEnd: 197,
        section: "Punti Ferita",
      ),
    ],
    tags: {"phb", "regole fondamentali", "risorsa"},
  ),
  "temporary_hit_points": GlossaryEntry(
    id: "temporary_hit_points",
    name: "Punti Ferita Temporanei",
    category: GlossaryCategory.risorsa,
    summary:
        "Una riserva separata di protezione che assorbe i danni prima dei punti ferita normali.",
    details:
        "I punti ferita temporanei non si sommano tra loro: quando se ne ricevono di nuovi si mantengono quelli già posseduti oppure si sostituiscono con il nuovo valore. Non possono essere ripristinati tramite guarigione.",
    sections: [
      GlossarySectionDefinition(
        id: "temporary_hit_points_damage",
        title: "Assorbire i danni",
        type: GlossarySectionType.procedure,
        content:
            "Quando la creatura subisce danni, sottrai prima i punti ferita temporanei. Gli eventuali danni rimanenti riducono i punti ferita normali.",
      ),
      GlossarySectionDefinition(
        id: "temporary_hit_points_no_stacking",
        title: "Nessuna cumulabilità",
        type: GlossarySectionType.specialCases,
        content:
            "Due concessioni di punti ferita temporanei non si sommano. La creatura sceglie quale valore conservare.",
      ),
    ],
    relatedIds: ["hit_points", "healing"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punti Ferita Temporanei",
        pageStart: 198,
        pageEnd: 198,
        section: "Punti Ferita Temporanei",
      ),
    ],
    tags: {"phb", "regole fondamentali", "risorsa"},
  ),
  "healing": GlossaryEntry(
    id: "healing",
    name: "Guarigione",
    category: GlossaryCategory.regola,
    summary:
        "Il recupero di punti ferita tramite magia, riposo o altre capacità.",
    details:
        "I punti ferita recuperati non possono portare una creatura oltre il suo massimo. Una creatura morta non può recuperare punti ferita salvo che una regola lo permetta espressamente.",
    relatedIds: ["hit_points", "temporary_hit_points", "stabilizing_creature"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Guarigione",
        pageStart: 197,
        pageEnd: 197,
        section: "Guarigione",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "dropping_to_zero_hit_points": GlossaryEntry(
    id: "dropping_to_zero_hit_points",
    name: "Scendere a 0 Punti Ferita",
    aliases: {"Cadere a 0 Punti Ferita"},
    category: GlossaryCategory.combattimento,
    summary:
        "Quando una creatura scende a 0 punti ferita, cade priva di sensi oppure muore istantaneamente se i danni residui sono sufficienti.",
    details:
        "Un personaggio a 0 punti ferita che non muore deve normalmente effettuare tiri salvezza contro morte all’inizio dei propri turni.",
    relatedIds: ["death_saving_throw", "instant_death", "stabilizing_creature"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Scendere a 0 Punti Ferita",
        pageStart: 197,
        pageEnd: 198,
        section: "Scendere a 0 Punti Ferita",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "death_saving_throw": GlossaryEntry(
    id: "death_saving_throw",
    name: "Tiro Salvezza contro Morte",
    aliases: {"Tiri Salvezza contro Morte"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un tiro speciale effettuato all’inizio del turno quando un personaggio possiede 0 punti ferita ed è instabile.",
    details:
        "Con 10 o più si ottiene un successo, altrimenti un fallimento. Tre successi stabilizzano il personaggio; tre fallimenti lo fanno morire. Successi e fallimenti si azzerano quando il personaggio recupera punti ferita o diventa stabile.",
    sections: [
      GlossarySectionDefinition(
        id: "death_save_results",
        title: "Successi e fallimenti",
        type: GlossarySectionType.procedure,
        content:
            "Tira 1d20 senza aggiungere modificatori ordinari. Un risultato di 10 o più è un successo. Dopo 3 successi il personaggio è stabile; dopo 3 fallimenti muore.",
        numericValues: {
          "dieSize": 20,
          "difficultyClass": 10,
          "successesRequired": 3,
          "failuresRequired": 3
        },
      ),
      GlossarySectionDefinition(
        id: "death_save_natural_results",
        title: "Risultati di 1 e 20",
        type: GlossarySectionType.specialCases,
        content:
            "Un 1 naturale conta come due fallimenti. Con un 20 naturale il personaggio recupera 1 punto ferita.",
        numericValues: {"naturalOneFailures": 2, "naturalTwentyHitPoints": 1},
      ),
      GlossarySectionDefinition(
        id: "death_save_damage",
        title: "Subire danni a 0 punti ferita",
        type: GlossarySectionType.interaction,
        content:
            "Subire danni a 0 punti ferita causa un fallimento. Se il danno proviene da un colpo critico causa due fallimenti; i danni residui possono inoltre provocare morte istantanea.",
        relatedIds: ["critical_hit", "instant_death"],
      ),
    ],
    relatedIds: [
      "dropping_to_zero_hit_points",
      "stabilizing_creature",
      "instant_death"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiri Salvezza contro Morte",
        pageStart: 197,
        pageEnd: 198,
        section: "Tiri Salvezza contro Morte",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "instant_death": GlossaryEntry(
    id: "instant_death",
    name: "Morte Istantanea",
    category: GlossaryCategory.combattimento,
    summary:
        "Danni massicci possono uccidere immediatamente una creatura senza ricorrere ai tiri salvezza contro morte.",
    details:
        "Quando i danni riducono una creatura a 0 punti ferita e i danni rimanenti sono almeno pari ai suoi punti ferita massimi, la creatura muore.",
    relatedIds: [
      "hit_points",
      "dropping_to_zero_hit_points",
      "death_saving_throw"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Morte Istantanea",
        pageStart: 197,
        pageEnd: 197,
        section: "Morte Istantanea",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "stabilizing_creature": GlossaryEntry(
    id: "stabilizing_creature",
    name: "Stabilizzare una Creatura",
    aliases: {"Stabilizzazione"},
    category: GlossaryCategory.azione,
    summary:
        "Un personaggio può prestare soccorso a una creatura a 0 punti ferita per impedirle di continuare a effettuare tiri salvezza contro morte.",
    details:
        "È richiesta un’azione e una prova di Saggezza (Medicina) con CD 10. Una creatura stabile resta a 0 punti ferita, è priva di sensi e recupera 1 punto ferita dopo 1d4 ore se non viene curata prima.",
    sections: [
      GlossarySectionDefinition(
        id: "stabilizing_check",
        title: "Prova di Medicina",
        type: GlossarySectionType.procedure,
        content:
            "Usa un’azione ed effettua una prova di Saggezza (Medicina) con CD 10. In caso di successo la creatura diventa stabile.",
        numericValues: {"difficultyClass": 10},
        relatedIds: ["ability_check", "action"],
      ),
      GlossarySectionDefinition(
        id: "stable_recovery",
        title: "Recupero spontaneo",
        type: GlossarySectionType.specialCases,
        content:
            "Una creatura stabile che non viene curata recupera 1 punto ferita dopo 1d4 ore.",
        numericValues: {"diceCount": 1, "dieSize": 4, "hitPointsRecovered": 1},
      ),
    ],
    relatedIds: ["ability_check", "death_saving_throw", "healing"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Stabilizzare una Creatura",
        pageStart: 197,
        pageEnd: 198,
        section: "Stabilizzare una Creatura",
      ),
    ],
    tags: {"phb", "regole fondamentali", "azione"},
  ),
  "short_rest": GlossaryEntry(
    id: "short_rest",
    name: "Riposo Breve",
    category: GlossaryCategory.regola,
    summary:
        "Un periodo di almeno un’ora durante il quale un personaggio non svolge attività più impegnative di mangiare, bere, leggere o medicarsi.",
    details:
        "Al termine del riposo il personaggio può spendere uno o più Dadi Vita per recuperare punti ferita, risolvendoli uno alla volta.",
    sections: [
      GlossarySectionDefinition(
        id: "short_rest_duration",
        title: "Durata e attività",
        type: GlossarySectionType.completeRule,
        content:
            "Il riposo dura almeno 1 ora e non consente attività più impegnative di mangiare, bere, leggere o medicarsi.",
        numericValues: {"minimumMinutes": 60},
      ),
    ],
    relatedIds: ["hit_dice", "healing", "long_rest"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Riposo Breve",
        pageStart: 186,
        pageEnd: 186,
        section: "Riposo Breve",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "long_rest": GlossaryEntry(
    id: "long_rest",
    name: "Riposo Lungo",
    category: GlossaryCategory.regola,
    summary:
        "Un periodo prolungato di almeno otto ore che permette di recuperare completamente i punti ferita e parte dei Dadi Vita spesi.",
    details:
        "Al termine del riposo il personaggio recupera tutti i punti ferita perduti e fino a metà dei suoi Dadi Vita totali, con un minimo di uno. Non può beneficiare di più di un riposo lungo ogni 24 ore e deve iniziarlo con almeno 1 punto ferita.",
    sections: [
      GlossarySectionDefinition(
        id: "long_rest_duration",
        title: "Durata",
        type: GlossarySectionType.completeRule,
        content:
            "Il riposo dura almeno 8 ore e comprende sonno e non più di 2 ore di attività leggere, come leggere, parlare, mangiare o montare la guardia.",
        numericValues: {"minimumHours": 8, "maximumLightActivityHours": 2},
      ),
      GlossarySectionDefinition(
        id: "long_rest_recovery",
        title: "Recupero",
        type: GlossarySectionType.procedure,
        content:
            "Il personaggio recupera tutti i punti ferita perduti e Dadi Vita spesi fino a metà del proprio totale, con un minimo di 1 dado.",
        numericValues: {
          "hitPointRecoveryPercent": 100,
          "hitDiceRecoveryDivisor": 2,
          "minimumHitDiceRecovered": 1
        },
        relatedIds: ["hit_points", "hit_dice"],
      ),
    ],
    relatedIds: ["short_rest", "hit_dice", "healing"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Riposo Lungo",
        pageStart: 186,
        pageEnd: 186,
        section: "Riposo Lungo",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "hit_dice": GlossaryEntry(
    id: "hit_dice",
    name: "Dadi Vita",
    aliases: {"Dado Vita"},
    category: GlossaryCategory.risorsa,
    summary:
        "Dadi determinati dalle classi del personaggio, utilizzabili durante un riposo breve per recuperare punti ferita.",
    details:
        "Dopo un riposo breve il personaggio può spendere Dadi Vita uno alla volta. Per ogni dado tira e aggiunge il modificatore di Costituzione, recuperando un numero di punti ferita pari al totale, fino al proprio massimo.",
    relatedIds: ["short_rest", "long_rest", "hit_points"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Riposo Breve",
        pageStart: 186,
        pageEnd: 186,
        section: "Riposo Breve",
      ),
    ],
    tags: {"phb", "regole fondamentali", "risorsa"},
  ),
  "initiative": GlossaryEntry(
    id: "initiative",
    name: "Iniziativa",
    category: GlossaryCategory.combattimento,
    summary:
        "L’ordine dei turni durante un combattimento, determinato tramite una prova di Destrezza.",
    details:
        "All’inizio del combattimento ogni partecipante effettua una prova di Destrezza. Il Dungeon Master può effettuare un solo tiro per gruppi di creature identiche. Si agisce dal risultato più alto al più basso.",
    sections: [
      GlossarySectionDefinition(
        id: "initiative_ties",
        title: "Risultati in parità",
        type: GlossarySectionType.specialCases,
        content:
            "Il Dungeon Master decide l’ordine tra creature sotto il suo controllo in parità; i giocatori decidono tra i loro personaggi. Il Dungeon Master può decidere una parità tra un mostro e un personaggio.",
      ),
    ],
    relatedIds: ["ability_check", "surprise"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "L’Ordine di Combattimento",
        pageStart: 189,
        pageEnd: 189,
        section: "L’Ordine di Combattimento",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "surprise": GlossaryEntry(
    id: "surprise",
    name: "Sorpresa",
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura colta impreparata all’inizio del combattimento può essere sorpresa durante il suo primo turno.",
    details:
        "Il Dungeon Master confronta le prove di Destrezza (Furtività) di chi si nasconde con la Saggezza (Percezione) passiva delle altre creature. Una creatura sorpresa non può muoversi né compiere azioni nel suo primo turno e non può effettuare reazioni finché quel turno non termina.",
    relatedIds: ["initiative", "action", "reaction", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Sorpresa",
        pageStart: 189,
        pageEnd: 189,
        section: "Sorpresa",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "movement": GlossaryEntry(
    id: "movement",
    name: "Movimento",
    category: GlossaryCategory.azione,
    summary:
        "Durante il proprio turno una creatura può muoversi fino a una distanza pari alla sua velocità.",
    details:
        "Il movimento può essere suddiviso prima e dopo un’azione e può essere ripartito tra diversi tipi di velocità seguendo le regole previste.",
    relatedIds: ["difficult_terrain", "opportunity_attack", "action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Movimento e Posizione",
        pageStart: 190,
        pageEnd: 191,
        section: "Movimento e Posizione",
      ),
    ],
    tags: {"phb", "regole fondamentali", "azione"},
  ),
  "difficult_terrain": GlossaryEntry(
    id: "difficult_terrain",
    name: "Terreno Difficile",
    category: GlossaryCategory.regola,
    summary:
        "Un terreno che richiede movimento aggiuntivo per essere attraversato.",
    details:
        "Ogni metro percorso su terreno difficile costa un metro aggiuntivo di movimento. La regola si applica anche quando più elementi nello stesso spazio rendono difficile il terreno.",
    sections: [
      GlossarySectionDefinition(
        id: "difficult_terrain_cost",
        title: "Costo del movimento",
        type: GlossarySectionType.completeRule,
        content:
            "Per ogni metro attraversato su terreno difficile, la creatura deve spendere 2 metri del proprio movimento disponibile.",
        numericValues: {"movementCostMultiplier": 2},
      ),
    ],
    relatedIds: ["movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Terreno Difficile",
        pageStart: 182,
        pageEnd: 182,
        section: "Terreno Difficile",
      ),
    ],
    tags: {"phb", "regole fondamentali", "regola"},
  ),
  "action": GlossaryEntry(
    id: "action",
    name: "Azione",
    aliases: {"Azioni"},
    category: GlossaryCategory.azione,
    summary:
        "La principale attività che una creatura può compiere durante il proprio turno.",
    details:
        "Nel proprio turno una creatura può normalmente compiere un’azione, scegliendola tra quelle disponibili nelle regole oppure usando un’azione concessa da una classe, capacità, incantesimo o altro elemento.",
    relatedIds: ["bonus_action", "reaction", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni in Combattimento",
        pageStart: 189,
        pageEnd: 193,
        section: "Azioni in Combattimento",
      ),
    ],
    tags: {"phb", "regole fondamentali", "azione"},
  ),
  "bonus_action": GlossaryEntry(
    id: "bonus_action",
    name: "Azione Bonus",
    aliases: {"Azioni Bonus"},
    category: GlossaryCategory.azione,
    summary:
        "Un’attività aggiuntiva disponibile soltanto quando una capacità, un incantesimo o un’altra regola consente di compierla.",
    details:
        "Nel proprio turno una creatura può compiere al massimo un’azione bonus. Se più opzioni sono disponibili deve scegliere quale usare. Non può compierla quando è privata della capacità di compiere azioni.",
    sections: [
      GlossarySectionDefinition(
        id: "bonus_action_limit",
        title: "Limite per turno",
        type: GlossarySectionType.completeRule,
        content:
            "Una creatura può effettuare una sola azione bonus nel proprio turno, anche se dispone di più capacità che ne richiedono una.",
        numericValues: {"maximumPerTurn": 1},
      ),
    ],
    relatedIds: ["action", "reaction"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azioni Bonus",
        pageStart: 189,
        pageEnd: 190,
        section: "Azioni Bonus",
      ),
    ],
    tags: {"phb", "regole fondamentali", "azione"},
  ),
  "reaction": GlossaryEntry(
    id: "reaction",
    name: "Reazione",
    aliases: {"Reazioni"},
    category: GlossaryCategory.azione,
    summary:
        "Una risposta immediata a un evento scatenante, effettuabile nel proprio turno o in quello di un’altra creatura.",
    details:
        "Dopo avere effettuato una reazione, una creatura non può effettuarne un’altra fino all’inizio del proprio turno successivo.",
    sections: [
      GlossarySectionDefinition(
        id: "reaction_recovery",
        title: "Disponibilità",
        type: GlossarySectionType.completeRule,
        content:
            "Una volta usata, la reazione torna disponibile all’inizio del turno successivo della creatura.",
        numericValues: {"maximumBeforeNextTurn": 1},
      ),
    ],
    relatedIds: ["action", "bonus_action", "opportunity_attack"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Reazioni",
        pageStart: 190,
        pageEnd: 190,
        section: "Reazioni",
      ),
    ],
    tags: {"phb", "regole fondamentali", "azione"},
  ),
  "opportunity_attack": GlossaryEntry(
    id: "opportunity_attack",
    name: "Attacco di Opportunità",
    aliases: {"Attacchi di Opportunità"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un attacco in mischia effettuato come reazione quando un nemico visibile esce volontariamente dalla portata della creatura.",
    details:
        "L’attacco si risolve immediatamente prima che il bersaglio lasci la portata. Una creatura non lo provoca quando usa l’azione Disimpegno o quando viene spostata senza usare il proprio movimento, azione o reazione.",
    relatedIds: ["reaction", "attack_roll", "movement"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi di Opportunità",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi di Opportunità",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
  "cover": GlossaryEntry(
    id: "cover",
    name: "Copertura",
    category: GlossaryCategory.combattimento,
    summary:
        "Un ostacolo può proteggere un bersaglio concedendo bonus alla Classe Armatura e ai tiri salvezza su Destrezza.",
    details:
        "Mezza copertura concede +2 alla Classe Armatura e ai tiri salvezza su Destrezza; tre quarti di copertura concedono +5. Con copertura totale il bersaglio non può essere preso direttamente come bersaglio da un attacco o incantesimo, salvo eccezioni.",
    sections: [
      GlossarySectionDefinition(
        id: "cover_degrees",
        title: "Gradi di copertura",
        type: GlossarySectionType.completeRule,
        content:
            "Mezza copertura concede +2 alla CA e ai tiri salvezza su Destrezza. Tre quarti di copertura concedono +5. La copertura totale impedisce di prendere direttamente il bersaglio come bersaglio.",
        numericValues: {"halfCoverBonus": 2, "threeQuartersCoverBonus": 5},
        relatedIds: ["armor_class", "saving_throw"],
      ),
    ],
    relatedIds: ["armor_class", "saving_throw", "attack_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Copertura",
        pageStart: 196,
        pageEnd: 196,
        section: "Copertura",
      ),
    ],
    tags: {"phb", "regole fondamentali", "combattimento"},
  ),
};
