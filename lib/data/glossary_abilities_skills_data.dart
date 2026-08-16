import 'class_data.dart';

/// Caratteristiche e abilità del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbAbilitySkillGlossaryEntries = {
  "ability_score": GlossaryEntry(
    id: "ability_score",
    name: "Punteggio di Caratteristica",
    aliases: {"Punteggi di Caratteristica", "Modificatore di Caratteristica"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Il valore numerico che rappresenta una delle sei caratteristiche fondamentali di una creatura.",
    details:
        "Ogni punteggio genera un modificatore usato nelle prove di caratteristica, nei tiri salvezza, nei tiri per colpire e in altre regole. Il modificatore è pari al punteggio meno 10, diviso per 2 e arrotondato per difetto.",
    sections: [
      GlossarySectionDefinition(
        id: "ability_modifier_formula",
        title: "Calcolare il modificatore",
        type: GlossarySectionType.procedure,
        content:
            "Sottrai 10 dal punteggio, dividi il risultato per 2 e arrotonda per difetto.",
        numericValues: {"neutralScore": 10, "divisor": 2},
      ),
    ],
    relatedIds: [
      "strength",
      "dexterity",
      "constitution",
      "intelligence",
      "wisdom",
      "charisma"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Punteggi e Modificatori di Caratteristica",
        pageStart: 173,
        pageEnd: 173,
        section: "Punteggi e Modificatori di Caratteristica",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "strength": GlossaryEntry(
    id: "strength",
    name: "Forza",
    category: GlossaryCategory.caratteristica,
    summary:
        "Misura la potenza fisica, l’addestramento atletico e la capacità di esercitare forza bruta.",
    details:
        "La Forza viene usata per sollevare, spingere, tirare, spezzare oggetti, arrampicarsi, saltare, nuotare e compiere molti attacchi con armi da mischia.",
    relatedIds: ["ability_score", "athletics", "ability_check", "saving_throw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Forza",
        pageStart: 175,
        pageEnd: 176,
        section: "Forza",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "dexterity": GlossaryEntry(
    id: "dexterity",
    name: "Destrezza",
    category: GlossaryCategory.caratteristica,
    summary: "Misura agilità, riflessi, equilibrio e precisione dei movimenti.",
    details:
        "La Destrezza contribuisce alla Classe Armatura, all’Iniziativa, a molti attacchi a distanza e con armi accurate, nonché alle abilità Acrobazia, Rapidità di Mano e Furtività.",
    relatedIds: [
      "ability_score",
      "acrobatics",
      "sleight_of_hand",
      "stealth",
      "armor_class",
      "initiative"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Destrezza",
        pageStart: 176,
        pageEnd: 177,
        section: "Destrezza",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "constitution": GlossaryEntry(
    id: "constitution",
    name: "Costituzione",
    category: GlossaryCategory.caratteristica,
    summary: "Misura salute, vigore e resistenza fisica.",
    details:
        "La Costituzione contribuisce ai punti ferita e viene usata per resistere a privazioni, veleni, malattie e altri effetti che mettono alla prova la vitalità. Non è associata ad alcuna abilità.",
    relatedIds: [
      "ability_score",
      "hit_points",
      "saving_throw",
      "poisoned",
      "concentration"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Costituzione",
        pageStart: 177,
        pageEnd: 177,
        section: "Costituzione",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "intelligence": GlossaryEntry(
    id: "intelligence",
    name: "Intelligenza",
    category: GlossaryCategory.caratteristica,
    summary:
        "Misura acutezza mentale, precisione della memoria e capacità di ragionamento.",
    details:
        "L’Intelligenza viene usata per ricordare informazioni, analizzare indizi, ragionare e applicare conoscenze accademiche.",
    relatedIds: [
      "ability_score",
      "arcana",
      "history",
      "investigation",
      "nature",
      "religion"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Intelligenza",
        pageStart: 177,
        pageEnd: 178,
        section: "Intelligenza",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "wisdom": GlossaryEntry(
    id: "wisdom",
    name: "Saggezza",
    category: GlossaryCategory.caratteristica,
    summary: "Misura percezione, intuito e sintonia con il mondo circostante.",
    details:
        "La Saggezza viene usata per leggere il comportamento, notare dettagli, curare, seguire tracce e comprendere animali e ambiente.",
    relatedIds: [
      "ability_score",
      "animal_handling",
      "insight",
      "medicine",
      "perception",
      "survival"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Saggezza",
        pageStart: 178,
        pageEnd: 178,
        section: "Saggezza",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "charisma": GlossaryEntry(
    id: "charisma",
    name: "Carisma",
    category: GlossaryCategory.caratteristica,
    summary: "Misura sicurezza, eloquenza, presenza e forza della personalità.",
    details:
        "Il Carisma viene usato per influenzare, intrattenere, ingannare o intimidire altre creature tramite parole, comportamento e presenza.",
    relatedIds: [
      "ability_score",
      "deception",
      "intimidation",
      "performance",
      "persuasion"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Carisma",
        pageStart: 178,
        pageEnd: 179,
        section: "Carisma",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "athletics": GlossaryEntry(
    id: "athletics",
    name: "Atletica",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Forza usata nelle situazioni difficili che coinvolgono arrampicarsi, saltare o nuotare.",
    details:
        "Può essere richiesta per superare ostacoli fisici, restare a galla, contrastare una corrente, aumentare la distanza di un salto o evitare un pericolo durante un’attività atletica.",
    relatedIds: [
      "strength",
      "ability_check",
      "grapple",
      "escape_grapple",
      "shove"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Atletica",
        pageStart: 175,
        pageEnd: 175,
        section: "Atletica",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "acrobatics": GlossaryEntry(
    id: "acrobatics",
    name: "Acrobazia",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Destrezza usata per mantenere l’equilibrio o eseguire manovre acrobatiche.",
    details:
        "Può servire per restare in piedi su superfici instabili, camminare su una fune, eseguire tuffi, capriole o altre manovre basate su equilibrio e agilità.",
    relatedIds: ["dexterity", "ability_check", "escape_grapple"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Acrobazia",
        pageStart: 176,
        pageEnd: 176,
        section: "Acrobazia",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "sleight_of_hand": GlossaryEntry(
    id: "sleight_of_hand",
    name: "Rapidità di Mano",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Destrezza usata per compiere movimenti manuali rapidi, precisi o nascosti.",
    details:
        "Può essere usata per nascondere un oggetto, sottrarre una borsa, infilare qualcosa nelle tasche altrui o manipolare un oggetto senza essere notati.",
    relatedIds: ["dexterity", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Rapidità di Mano",
        pageStart: 176,
        pageEnd: 176,
        section: "Rapidità di Mano",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "stealth": GlossaryEntry(
    id: "stealth",
    name: "Furtività",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Destrezza usata per evitare di essere visti o uditi.",
    details:
        "Si usa per nascondersi, muoversi silenziosamente, superare guardie o avvicinarsi senza rivelare la propria presenza.",
    relatedIds: [
      "dexterity",
      "ability_check",
      "hide_action",
      "surprise",
      "passive_check"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Furtività",
        pageStart: 176,
        pageEnd: 176,
        section: "Furtività",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "arcana": GlossaryEntry(
    id: "arcana",
    name: "Arcano",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Intelligenza relativa a incantesimi, oggetti magici, simboli occulti, tradizioni magiche e piani di esistenza.",
    details:
        "Una prova di Arcano può permettere di ricordare o interpretare conoscenze teoriche riguardanti la magia.",
    relatedIds: ["intelligence", "ability_check", "spell", "school_of_magic"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Arcano",
        pageStart: 177,
        pageEnd: 177,
        section: "Arcano",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "history": GlossaryEntry(
    id: "history",
    name: "Storia",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Intelligenza relativa a eventi storici, popoli, regni, guerre, leggende e civiltà.",
    details:
        "Una prova di Storia può permettere di ricordare informazioni su avvenimenti, personaggi, culture o luoghi del passato.",
    relatedIds: ["intelligence", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Storia",
        pageStart: 177,
        pageEnd: 177,
        section: "Storia",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "investigation": GlossaryEntry(
    id: "investigation",
    name: "Indagare",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Intelligenza usata per cercare indizi e dedurre conclusioni.",
    details:
        "Può servire per individuare un oggetto nascosto, comprendere il funzionamento di un congegno, riconoscere una falsificazione o dedurre dove possa trovarsi un passaggio segreto.",
    relatedIds: ["intelligence", "ability_check", "search_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Indagare",
        pageStart: 177,
        pageEnd: 177,
        section: "Indagare",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "nature": GlossaryEntry(
    id: "nature",
    name: "Natura",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Intelligenza relativa a terreno, piante, animali, clima e cicli naturali.",
    details:
        "Una prova di Natura può permettere di ricordare conoscenze teoriche sul mondo naturale e sulle creature che lo abitano.",
    relatedIds: ["intelligence", "ability_check", "survival"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Natura",
        pageStart: 177,
        pageEnd: 177,
        section: "Natura",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "religion": GlossaryEntry(
    id: "religion",
    name: "Religione",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Intelligenza relativa a divinità, riti, preghiere, gerarchie religiose, simboli sacri e culti.",
    details:
        "Una prova di Religione può permettere di ricordare informazioni su tradizioni religiose, pratiche rituali e creature legate alla fede.",
    relatedIds: ["intelligence", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Religione",
        pageStart: 177,
        pageEnd: 177,
        section: "Religione",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "animal_handling": GlossaryEntry(
    id: "animal_handling",
    name: "Addestrare Animali",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Saggezza usata per calmare, controllare o comprendere il comportamento di un animale.",
    details:
        "Può essere richiesta per gestire una cavalcatura impaurita, intuire le intenzioni di un animale o compiere una manovra rischiosa mentre si cavalca.",
    relatedIds: ["wisdom", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Addestrare Animali",
        pageStart: 178,
        pageEnd: 178,
        section: "Addestrare Animali",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "insight": GlossaryEntry(
    id: "insight",
    name: "Intuizione",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Saggezza usata per comprendere le vere intenzioni di una creatura.",
    details:
        "Può permettere di cogliere menzogne, esitazioni, cambiamenti nel comportamento, linguaggio corporeo e altri indizi sociali.",
    relatedIds: ["wisdom", "ability_check", "deception"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Intuizione",
        pageStart: 178,
        pageEnd: 178,
        section: "Intuizione",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "medicine": GlossaryEntry(
    id: "medicine",
    name: "Medicina",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Saggezza usata per diagnosticare malattie, riconoscere cause di morte e prestare cure immediate.",
    details:
        "Una prova di Medicina con CD 10 può stabilizzare una creatura morente a 0 punti ferita.",
    sections: [
      GlossarySectionDefinition(
        id: "medicine_stabilization",
        title: "Stabilizzare",
        type: GlossarySectionType.interaction,
        content:
            "Per stabilizzare una creatura a 0 punti ferita è richiesta una prova di Saggezza (Medicina) con CD 10.",
        numericValues: {"difficultyClass": 10},
        relatedIds: ["stabilizing_creature"],
      ),
    ],
    relatedIds: ["wisdom", "ability_check", "stabilizing_creature", "healing"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Medicina",
        pageStart: 178,
        pageEnd: 178,
        section: "Medicina",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "perception": GlossaryEntry(
    id: "perception",
    name: "Percezione",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Saggezza usata per individuare la presenza di qualcosa tramite i sensi.",
    details:
        "Può servire per ascoltare una conversazione, notare una creatura nascosta, scorgere un dettaglio o rilevare un pericolo nell’ambiente.",
    relatedIds: [
      "wisdom",
      "ability_check",
      "passive_check",
      "surprise",
      "search_action"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Percezione",
        pageStart: 178,
        pageEnd: 178,
        section: "Percezione",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "survival": GlossaryEntry(
    id: "survival",
    name: "Sopravvivenza",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Saggezza usata per seguire tracce, orientarsi e affrontare pericoli naturali.",
    details:
        "Può servire per cacciare, prevedere il tempo, evitare sabbie mobili, riconoscere tracce o trovare una strada in territori selvaggi.",
    relatedIds: ["wisdom", "ability_check", "nature"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Sopravvivenza",
        pageStart: 178,
        pageEnd: 178,
        section: "Sopravvivenza",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "deception": GlossaryEntry(
    id: "deception",
    name: "Inganno",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Carisma usata per nascondere la verità tramite parole, azioni o travestimenti.",
    details:
        "Può servire per mentire, mantenere un volto impassibile, creare un diversivo o fingersi un’altra persona.",
    relatedIds: ["charisma", "ability_check", "insight"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Inganno",
        pageStart: 178,
        pageEnd: 178,
        section: "Inganno",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "intimidation": GlossaryEntry(
    id: "intimidation",
    name: "Intimidire",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Carisma usata per influenzare qualcuno tramite minacce, ostilità o dimostrazioni di forza.",
    details:
        "Il Dungeon Master determina conseguenze e reazioni della creatura intimidita in base alla situazione.",
    relatedIds: ["charisma", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Intimidire",
        pageStart: 178,
        pageEnd: 178,
        section: "Intimidire",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "performance": GlossaryEntry(
    id: "performance",
    name: "Intrattenere",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Carisma usata per dilettare un pubblico con musica, danza, recitazione, narrazione o altre esibizioni.",
    details:
        "Una prova determina quanto efficacemente l’esibizione coinvolge o impressiona chi vi assiste.",
    relatedIds: ["charisma", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Intrattenere",
        pageStart: 179,
        pageEnd: 179,
        section: "Intrattenere",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "persuasion": GlossaryEntry(
    id: "persuasion",
    name: "Persuasione",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un’abilità di Carisma usata per influenzare gli altri tramite tatto, cortesia e buone intenzioni.",
    details:
        "Può servire per negoziare, ispirare fiducia, richiedere un favore o convincere una creatura con argomenti sinceri.",
    relatedIds: ["charisma", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Persuasione",
        pageStart: 179,
        pageEnd: 179,
        section: "Persuasione",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "caratteristica"},
  ),
  "difficulty_class": GlossaryEntry(
    id: "difficulty_class",
    name: "Classe Difficoltà",
    aliases: {"CD", "Classi Difficoltà"},
    category: GlossaryCategory.regola,
    summary:
        "Il valore bersaglio che una prova di caratteristica o un tiro salvezza deve eguagliare o superare per riuscire.",
    details:
        "Il Dungeon Master stabilisce la CD in base alla difficoltà del compito oppure usa il valore definito dalla regola che produce l’effetto.",
    sections: [
      GlossarySectionDefinition(
        id: "difficulty_examples",
        title: "Difficoltà tipiche",
        type: GlossarySectionType.example,
        content:
            "Molto facile: CD 5. Facile: CD 10. Moderata: CD 15. Difficile: CD 20. Molto difficile: CD 25. Quasi impossibile: CD 30.",
        numericValues: {
          "veryEasy": 5,
          "easy": 10,
          "medium": 15,
          "hard": 20,
          "veryHard": 25,
          "nearlyImpossible": 30
        },
      ),
    ],
    relatedIds: ["ability_check", "saving_throw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Prove di Caratteristica",
        pageStart: 174,
        pageEnd: 174,
        section: "Prove di Caratteristica",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "regola"},
  ),
  "passive_check": GlossaryEntry(
    id: "passive_check",
    name: "Prova Passiva",
    aliases: {"Prove Passive", "Percezione Passiva"},
    category: GlossaryCategory.regola,
    summary:
        "Una prova speciale che non comporta alcun tiro di dado e rappresenta un risultato medio ripetuto o una valutazione segreta.",
    details:
        "Il punteggio passivo è 10 più tutti i modificatori normalmente applicabili. Il vantaggio aggiunge 5 al punteggio, mentre lo svantaggio sottrae 5.",
    sections: [
      GlossarySectionDefinition(
        id: "passive_check_formula",
        title: "Formula",
        type: GlossarySectionType.completeRule,
        content:
            "Punteggio passivo = 10 + tutti i modificatori della prova. Aggiungi 5 con vantaggio o sottrai 5 con svantaggio.",
        numericValues: {
          "baseValue": 10,
          "advantageModifier": 5,
          "disadvantageModifier": -5
        },
        relatedIds: ["advantage", "disadvantage"],
      ),
    ],
    relatedIds: ["ability_check", "advantage", "disadvantage", "perception"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Prove Passive",
        pageStart: 175,
        pageEnd: 175,
        section: "Prove Passive",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "regola"},
  ),
  "contest": GlossaryEntry(
    id: "contest",
    name: "Contesa",
    aliases: {"Contese"},
    category: GlossaryCategory.regola,
    summary:
        "Una situazione in cui due creature effettuano prove di caratteristica contrapposte perché gli sforzi di una contrastano direttamente quelli dell’altra.",
    details:
        "La creatura con il totale più alto prevale. In caso di parità la situazione rimane invariata, come se nessuna delle due avesse ottenuto un successo decisivo.",
    relatedIds: ["ability_check", "grapple", "escape_grapple", "shove"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Contese",
        pageStart: 174,
        pageEnd: 174,
        section: "Contese",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "regola"},
  ),
  "group_check": GlossaryEntry(
    id: "group_check",
    name: "Prova di Gruppo",
    aliases: {"Prove di Gruppo"},
    category: GlossaryCategory.regola,
    summary:
        "Una prova effettuata da tutti i membri di un gruppo per determinare se il gruppo riesce collettivamente in un compito.",
    details:
        "Tutti effettuano la prova. Se almeno metà del gruppo riesce, l’intero gruppo riesce; altrimenti il gruppo fallisce.",
    sections: [
      GlossarySectionDefinition(
        id: "group_check_threshold",
        title: "Soglia del gruppo",
        type: GlossarySectionType.completeRule,
        content:
            "Il gruppo riesce quando almeno metà dei suoi membri supera la prova.",
        numericValues: {
          "requiredSuccessFractionNumerator": 1,
          "requiredSuccessFractionDenominator": 2
        },
      ),
    ],
    relatedIds: ["ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Prove di Gruppo",
        pageStart: 175,
        pageEnd: 175,
        section: "Prove di Gruppo",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "regola"},
  ),
  "working_together": GlossaryEntry(
    id: "working_together",
    name: "Collaborare",
    aliases: {"Lavorare Assieme"},
    category: GlossaryCategory.regola,
    summary:
        "Una creatura può aiutare un’altra in un compito, permettendo a chi guida lo sforzo di effettuare la prova con vantaggio.",
    details:
        "La collaborazione è possibile soltanto quando chi aiuta potrebbe tentare il compito da solo. Se il compito richiede competenza, anche chi aiuta deve possederla.",
    relatedIds: [
      "ability_check",
      "advantage",
      "help_action",
      "proficiency_bonus"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Collaborare",
        pageStart: 175,
        pageEnd: 175,
        section: "Collaborare",
      ),
    ],
    tags: {"phb", "caratteristiche e abilità", "regola"},
  ),
};
