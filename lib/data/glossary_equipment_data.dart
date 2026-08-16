import 'class_data.dart';

/// Equipaggiamento e proprietà del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbEquipmentGlossaryEntries = {
  "currency": GlossaryEntry(
    id: "currency",
    name: "Valuta",
    aliases: {"Monete", "Denaro"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Le monete usate per acquistare beni e servizi, normalmente espresse in rame, argento, electrum, oro e platino.",
    details:
        "La moneta d’oro è l’unità di riferimento più comune. Dieci monete di rame valgono una moneta d’argento; cinque monete d’argento una moneta di electrum; due monete di electrum una moneta d’oro; dieci monete d’oro una moneta di platino.",
    sections: [
      GlossarySectionDefinition(
        id: "currency_exchange",
        title: "Conversioni",
        type: GlossarySectionType.completeRule,
        content: "10 mr = 1 ma; 5 ma = 1 me; 2 me = 1 mo; 10 mo = 1 mp.",
        numericValues: {
          "copperPerSilver": 10,
          "silverPerElectrum": 5,
          "electrumPerGold": 2,
          "goldPerPlatinum": 10
        },
      ),
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Ricchezza",
        pageStart: 143,
        pageEnd: 143,
        section: "Ricchezza",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "lifestyle_expenses": GlossaryEntry(
    id: "lifestyle_expenses",
    name: "Spese dello Stile di Vita",
    aliases: {"Stile di Vita"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Il costo giornaliero del tenore di vita mantenuto da un personaggio tra un’avventura e l’altra.",
    details:
        "Gli stili di vita vanno da miserabile ad aristocratico e influenzano alloggio, cibo, condizioni di vita e ambienti sociali frequentati.",
    relatedIds: ["currency"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Spese dello Stile di Vita",
        pageStart: 157,
        pageEnd: 158,
        section: "Spese dello Stile di Vita",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "armor": GlossaryEntry(
    id: "armor",
    name: "Armatura",
    aliases: {"Armature"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Equipaggiamento protettivo che determina o modifica la Classe Armatura di chi lo indossa.",
    details:
        "Le armature sono suddivise in leggere, medie e pesanti. Competenza, requisito di Forza, limite di Destrezza e svantaggio alla Furtività dipendono dall’armatura specifica.",
    relatedIds: [
      "armor_class",
      "armor_proficiency",
      "light_armor",
      "medium_armor",
      "heavy_armor",
      "shield"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armature e Scudi",
        pageStart: 144,
        pageEnd: 146,
        section: "Armature e Scudi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "armor_proficiency": GlossaryEntry(
    id: "armor_proficiency",
    name: "Competenza nelle Armature",
    aliases: {"Competenza nell’Armatura"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "L’addestramento necessario per indossare un’armatura senza subirne le penalità previste.",
    details:
        "Indossare un’armatura senza competenza impone svantaggio alle prove di caratteristica, ai tiri salvezza e ai tiri per colpire basati su Forza o Destrezza e impedisce di lanciare incantesimi.",
    relatedIds: [
      "armor",
      "ability_check",
      "saving_throw",
      "attack_roll",
      "disadvantage",
      "spell"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Competenza nelle Armature",
        pageStart: 144,
        pageEnd: 144,
        section: "Competenza nelle Armature",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "light_armor": GlossaryEntry(
    id: "light_armor",
    name: "Armatura Leggera",
    aliases: {"Armature Leggere"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’armatura flessibile che consente di aggiungere l’intero modificatore di Destrezza alla Classe Armatura.",
    details:
        "Le armature leggere privilegiano mobilità e agilità. Il valore preciso della Classe Armatura dipende dal tipo indossato.",
    relatedIds: ["armor", "armor_class", "dexterity", "armor_proficiency"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armature Leggere",
        pageStart: 144,
        pageEnd: 145,
        section: "Armature Leggere",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "medium_armor": GlossaryEntry(
    id: "medium_armor",
    name: "Armatura Media",
    aliases: {"Armature Medie"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’armatura che offre protezione superiore limitando normalmente a +2 il contributo della Destrezza alla Classe Armatura.",
    details:
        "Alcune armature medie impongono svantaggio alle prove di Furtività. Il valore preciso dipende dal tipo indossato.",
    sections: [
      GlossarySectionDefinition(
        id: "medium_armor_dexterity_limit",
        title: "Limite di Destrezza",
        type: GlossarySectionType.completeRule,
        content:
            "Il modificatore di Destrezza applicabile alla Classe Armatura è normalmente limitato a un massimo di +2.",
        numericValues: {"maximumDexterityModifier": 2},
        relatedIds: ["dexterity", "armor_class"],
      ),
    ],
    relatedIds: [
      "armor",
      "armor_class",
      "dexterity",
      "stealth",
      "armor_proficiency"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armature Medie",
        pageStart: 144,
        pageEnd: 145,
        section: "Armature Medie",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "heavy_armor": GlossaryEntry(
    id: "heavy_armor",
    name: "Armatura Pesante",
    aliases: {"Armature Pesanti"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’armatura che fornisce una Classe Armatura fissa senza aggiungere il modificatore di Destrezza.",
    details:
        "Alcune armature pesanti richiedono un punteggio minimo di Forza. Se il requisito non è soddisfatto, la velocità della creatura viene ridotta di 3 metri.",
    sections: [
      GlossarySectionDefinition(
        id: "heavy_armor_strength_penalty",
        title: "Requisito di Forza",
        type: GlossarySectionType.interaction,
        content:
            "Se la Forza è inferiore al requisito dell’armatura, la velocità viene ridotta di 3 metri.",
        numericValues: {"speedPenaltyMeters": 3},
        relatedIds: ["strength", "movement"],
      ),
    ],
    relatedIds: [
      "armor",
      "armor_class",
      "strength",
      "movement",
      "armor_proficiency"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armature Pesanti",
        pageStart: 144,
        pageEnd: 145,
        section: "Armature Pesanti",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "shield": GlossaryEntry(
    id: "shield",
    name: "Scudo",
    aliases: {"Scudi"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Equipaggiamento impugnato in una mano che normalmente concede +2 alla Classe Armatura.",
    details:
        "Una creatura può beneficiare di un solo scudo alla volta e deve possedere la competenza appropriata per evitarne le penalità.",
    sections: [
      GlossarySectionDefinition(
        id: "shield_bonus",
        title: "Bonus alla Classe Armatura",
        type: GlossarySectionType.completeRule,
        content: "Uno scudo normalmente concede +2 alla Classe Armatura.",
        numericValues: {"armorClassBonus": 2, "handsRequired": 1},
        relatedIds: ["armor_class"],
      ),
    ],
    relatedIds: ["armor", "armor_class", "armor_proficiency"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Scudi",
        pageStart: 144,
        pageEnd: 146,
        section: "Scudi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "donning_doffing_armor": GlossaryEntry(
    id: "donning_doffing_armor",
    name: "Indossare e Togliere un’Armatura",
    aliases: {"Indossare un’Armatura", "Togliere un’Armatura"},
    category: GlossaryCategory.regola,
    summary: "I tempi necessari per indossare o rimuovere armature e scudi.",
    details:
        "Indossare significa equipaggiare correttamente l’oggetto; togliere significa rimuoverlo. Un’altra creatura può aiutare a dimezzare il tempo necessario per togliere un’armatura.",
    sections: [
      GlossarySectionDefinition(
        id: "armor_times",
        title: "Tempi",
        type: GlossarySectionType.completeRule,
        content:
            "Armatura leggera: 1 minuto per indossare e 1 per togliere. Media: 5 minuti e 1 minuto. Pesante: 10 minuti e 5 minuti. Scudo: 1 azione per indossare o togliere.",
        numericValues: {
          "lightDonMinutes": 1,
          "lightDoffMinutes": 1,
          "mediumDonMinutes": 5,
          "mediumDoffMinutes": 1,
          "heavyDonMinutes": 10,
          "heavyDoffMinutes": 5,
          "shieldDonActions": 1,
          "shieldDoffActions": 1
        },
        relatedIds: ["action"],
      ),
    ],
    relatedIds: ["armor", "shield", "help_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Indossare e Togliere un’Armatura",
        pageStart: 146,
        pageEnd: 146,
        section: "Indossare e Togliere un’Armatura",
      ),
    ],
    tags: {"phb", "equipaggiamento", "regola"},
  ),
  "weapon": GlossaryEntry(
    id: "weapon",
    name: "Arma",
    aliases: {"Armi"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Equipaggiamento usato per effettuare attacchi e infliggere il tipo e i dadi di danno indicati.",
    details:
        "Le armi sono classificate come semplici o da guerra e come da mischia o a distanza. Le proprietà dell’arma modificano il modo in cui può essere utilizzata.",
    relatedIds: [
      "attack_roll",
      "damage_roll",
      "weapon_proficiency",
      "simple_weapon",
      "martial_weapon",
      "melee_weapon",
      "ranged_weapon"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi",
        pageStart: 146,
        pageEnd: 149,
        section: "Armi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "weapon_proficiency": GlossaryEntry(
    id: "weapon_proficiency",
    name: "Competenza nelle Armi",
    aliases: {"Competenza nell’Arma"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "L’addestramento che permette di aggiungere il Bonus di Competenza ai tiri per colpire effettuati con determinate armi.",
    details:
        "La competenza non si aggiunge normalmente al tiro per i danni. Razza, classe, sottoclasse, talento o altre capacità stabiliscono le armi conosciute.",
    relatedIds: ["weapon", "proficiency_bonus", "attack_roll", "damage_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Competenza nelle Armi",
        pageStart: 146,
        pageEnd: 146,
        section: "Competenza nelle Armi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "simple_weapon": GlossaryEntry(
    id: "simple_weapon",
    name: "Arma Semplice",
    aliases: {"Armi Semplici"},
    category: GlossaryCategory.equipaggiamento,
    summary: "Un’arma comune e relativamente facile da usare.",
    details:
        "Molte classi concedono competenza con tutte le armi semplici. Ogni arma conserva comunque le proprie proprietà, gittata e danni.",
    relatedIds: ["weapon", "weapon_proficiency", "martial_weapon"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi Semplici",
        pageStart: 146,
        pageEnd: 149,
        section: "Armi Semplici",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "martial_weapon": GlossaryEntry(
    id: "martial_weapon",
    name: "Arma da Guerra",
    aliases: {"Armi da Guerra"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’arma che richiede un addestramento più specializzato rispetto a un’arma semplice.",
    details:
        "La competenza nelle armi da guerra viene concessa soltanto da specifiche classi, razze, talenti o altre capacità.",
    relatedIds: ["weapon", "weapon_proficiency", "simple_weapon"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi da Guerra",
        pageStart: 146,
        pageEnd: 149,
        section: "Armi da Guerra",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "melee_weapon": GlossaryEntry(
    id: "melee_weapon",
    name: "Arma da Mischia",
    aliases: {"Armi da Mischia"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’arma progettata per attaccare bersagli entro la propria portata in mischia.",
    details:
        "Un attacco con arma da mischia usa normalmente Forza per il tiro per colpire e per i danni, salvo che una proprietà o capacità indichi diversamente.",
    relatedIds: [
      "weapon",
      "attack_roll",
      "damage_roll",
      "strength",
      "finesse_property",
      "reach_property"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi",
        pageStart: 146,
        pageEnd: 149,
        section: "Armi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "ranged_weapon": GlossaryEntry(
    id: "ranged_weapon",
    name: "Arma a Distanza",
    aliases: {"Armi a Distanza"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’arma progettata per effettuare attacchi contro bersagli entro una gittata normale o lunga.",
    details:
        "Un attacco con arma a distanza usa normalmente Destrezza. Oltre la gittata normale e fino alla gittata lunga il tiro per colpire subisce svantaggio; oltre la gittata lunga non può essere effettuato.",
    relatedIds: [
      "weapon",
      "attack_roll",
      "dexterity",
      "disadvantage",
      "ammunition_property"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi",
        pageStart: 146,
        pageEnd: 149,
        section: "Armi",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "improvised_weapon": GlossaryEntry(
    id: "improvised_weapon",
    name: "Arma Improvvisata",
    aliases: {"Armi Improvvisate"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un oggetto non costruito come arma ma usato per effettuare un attacco.",
    details:
        "Se assomiglia a un’arma può usare le caratteristiche di quell’arma a discrezione del Dungeon Master. Altrimenti infligge normalmente 1d4 danni; un’arma improvvisata lanciata ha gittata 6/18 metri.",
    sections: [
      GlossarySectionDefinition(
        id: "improvised_weapon_defaults",
        title: "Valori predefiniti",
        type: GlossarySectionType.completeRule,
        content:
            "Danno 1d4; gittata di lancio 6/18 metri quando non viene assimilata a un’altra arma.",
        numericValues: {
          "diceCount": 1,
          "dieSize": 4,
          "normalRangeMeters": 6,
          "longRangeMeters": 18
        },
      ),
    ],
    relatedIds: ["weapon", "attack_roll", "damage_roll", "thrown_property"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi Improvvisate",
        pageStart: 147,
        pageEnd: 148,
        section: "Armi Improvvisate",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "unarmed_strike": GlossaryEntry(
    id: "unarmed_strike",
    name: "Colpo Senz’Armi",
    aliases: {"Colpi Senz’Armi"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un attacco in mischia effettuato con pugno, calcio, testata o un colpo simile.",
    details:
        "In caso di successo infligge danni contundenti pari a 1 più il modificatore di Forza. Una creatura è competente nei propri colpi senz’armi.",
    sections: [
      GlossarySectionDefinition(
        id: "unarmed_damage",
        title: "Danni",
        type: GlossarySectionType.completeRule,
        content: "Danni contundenti = 1 + modificatore di Forza.",
        numericValues: {"baseDamage": 1},
        relatedIds: ["strength", "damage_roll"],
      ),
    ],
    relatedIds: ["attack_roll", "damage_roll", "strength", "damage_types"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi in Mischia",
        pageStart: 149,
        pageEnd: 149,
        section: "Attacchi in Mischia",
      ),
    ],
    tags: {"phb", "equipaggiamento", "combattimento"},
  ),
  "silvered_weapon": GlossaryEntry(
    id: "silvered_weapon",
    name: "Arma Argentata",
    aliases: {"Armi Argentate", "Munizioni Argentate"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un’arma o una munizione rivestita d’argento per superare le difese di alcune creature.",
    details:
        "Argentare una singola arma o dieci munizioni costa 100 monete d’oro. Il costo comprende argento e lavoro necessario senza compromettere l’efficacia dell’oggetto.",
    sections: [
      GlossarySectionDefinition(
        id: "silvering_cost",
        title: "Costo",
        type: GlossarySectionType.completeRule,
        content:
            "Argentare un’arma oppure 10 munizioni costa 100 monete d’oro.",
        numericValues: {"goldCost": 100, "ammunitionCount": 10},
        relatedIds: ["currency"],
      ),
    ],
    relatedIds: ["weapon", "ammunition_property", "currency"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Armi Argentate",
        pageStart: 148,
        pageEnd: 148,
        section: "Armi Argentate",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "ammunition_property": GlossaryEntry(
    id: "ammunition_property",
    name: "Proprietà Munizioni",
    aliases: {"Munizioni"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che richiede munizioni appropriate per effettuare attacchi a distanza con l’arma.",
    details:
        "Estrarre la munizione fa parte dell’attacco. Dopo una battaglia, dedicando un minuto alla ricerca è possibile recuperare metà delle munizioni utilizzate.",
    sections: [
      GlossarySectionDefinition(
        id: "ammunition_recovery",
        title: "Recupero",
        type: GlossarySectionType.completeRule,
        content:
            "Dopo 1 minuto di ricerca si recupera metà delle munizioni utilizzate durante la battaglia.",
        numericValues: {"searchMinutes": 1, "recoveryDivisor": 2},
      ),
    ],
    relatedIds: [
      "weapon",
      "ranged_weapon",
      "attack_action",
      "object_interaction"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Munizioni",
        pageStart: 146,
        pageEnd: 147,
        section: "Proprietà delle Armi: Munizioni",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "finesse_property": GlossaryEntry(
    id: "finesse_property",
    name: "Proprietà Accurata",
    aliases: {"Accurata"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che permette di usare Forza oppure Destrezza per il tiro per colpire e i danni.",
    details:
        "Lo stesso modificatore scelto deve essere utilizzato sia per il tiro per colpire sia per il tiro per i danni dell’attacco.",
    relatedIds: [
      "weapon",
      "strength",
      "dexterity",
      "attack_roll",
      "damage_roll"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Accurata",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Accurata",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "heavy_property": GlossaryEntry(
    id: "heavy_property",
    name: "Proprietà Pesante",
    aliases: {"Pesante"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che rende l’arma difficile da utilizzare efficacemente per una creatura Piccola o Minuscola.",
    details:
        "Una creatura Piccola o Minuscola subisce svantaggio ai tiri per colpire effettuati con un’arma pesante.",
    relatedIds: ["weapon", "size_category", "attack_roll", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Pesante",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Pesante",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "light_property": GlossaryEntry(
    id: "light_property",
    name: "Proprietà Leggera",
    aliases: {"Leggera"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che rende l’arma adatta al combattimento con due armi.",
    details:
        "La proprietà non modifica direttamente peso o danni, ma è normalmente richiesta per gli attacchi concessi dalla regola Combattere con Due Armi.",
    relatedIds: ["weapon", "two_weapon_fighting"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Leggera",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Leggera",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "loading_property": GlossaryEntry(
    id: "loading_property",
    name: "Proprietà Ricarica",
    aliases: {"Ricarica"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che limita il numero di munizioni utilizzabili quando si impiega un’azione, azione bonus o reazione per attaccare.",
    details:
        "Indipendentemente dal numero di attacchi normalmente effettuabili, con quell’arma può essere scagliata una sola munizione durante la stessa azione, azione bonus o reazione.",
    sections: [
      GlossarySectionDefinition(
        id: "loading_limit",
        title: "Limite",
        type: GlossarySectionType.completeRule,
        content:
            "Una sola munizione per ogni azione, azione bonus o reazione usata per attaccare con l’arma.",
        numericValues: {"maximumShotsPerActivity": 1},
      ),
    ],
    relatedIds: [
      "weapon",
      "ammunition_property",
      "action",
      "bonus_action",
      "reaction"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Ricarica",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Ricarica",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "reach_property": GlossaryEntry(
    id: "reach_property",
    name: "Proprietà Portata",
    aliases: {"Portata"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che aumenta di 1,5 metri la portata della creatura quando attacca con l’arma.",
    details:
        "La portata aumentata si applica anche quando si determina la distanza entro cui può essere effettuato un attacco di opportunità con quell’arma.",
    sections: [
      GlossarySectionDefinition(
        id: "reach_increase",
        title: "Incremento",
        type: GlossarySectionType.completeRule,
        content:
            "La portata aumenta di 1,5 metri per gli attacchi effettuati con l’arma.",
        numericValues: {"additionalReachMeters": 1.5},
        relatedIds: ["opportunity_attack"],
      ),
    ],
    relatedIds: ["weapon", "melee_weapon", "opportunity_attack"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Portata",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Portata",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "special_property": GlossaryEntry(
    id: "special_property",
    name: "Proprietà Speciale",
    aliases: {"Speciale"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che rimanda a regole particolari descritte nella voce della specifica arma.",
    details:
        "Ogni arma speciale deve essere consultata individualmente, perché gli effetti non sono condivisi da tutte le armi con questa proprietà.",
    relatedIds: ["weapon"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Speciale",
        pageStart: 147,
        pageEnd: 148,
        section: "Proprietà delle Armi: Speciale",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "thrown_property": GlossaryEntry(
    id: "thrown_property",
    name: "Proprietà da Lancio",
    aliases: {"Da Lancio"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che permette di lanciare un’arma da mischia per effettuare un attacco a distanza.",
    details:
        "Si usa lo stesso modificatore di caratteristica che verrebbe usato per un attacco in mischia con l’arma. Se possiede anche Accurata, si può scegliere Forza o Destrezza.",
    relatedIds: [
      "weapon",
      "melee_weapon",
      "ranged_weapon",
      "strength",
      "dexterity",
      "finesse_property"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Da Lancio",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Da Lancio",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "two_handed_property": GlossaryEntry(
    id: "two_handed_property",
    name: "Proprietà a Due Mani",
    aliases: {"A Due Mani"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che richiede due mani quando si attacca con l’arma.",
    details:
        "La proprietà richiede due mani durante l’attacco, ma non impedisce necessariamente di reggere l’arma con una sola mano in altri momenti.",
    sections: [
      GlossarySectionDefinition(
        id: "two_handed_requirement",
        title: "Mani richieste",
        type: GlossarySectionType.completeRule,
        content: "Per attaccare con l’arma sono richieste 2 mani.",
        numericValues: {"handsRequiredForAttack": 2},
      ),
    ],
    relatedIds: ["weapon", "attack_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: A Due Mani",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: A Due Mani",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "versatile_property": GlossaryEntry(
    id: "versatile_property",
    name: "Proprietà Versatile",
    aliases: {"Versatile"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una proprietà che consente di usare l’arma con una o due mani, cambiando il dado di danno.",
    details:
        "Il valore di danno tra parentesi nella tabella dell’arma viene usato quando l’attacco in mischia viene effettuato impugnando l’arma con due mani.",
    relatedIds: ["weapon", "melee_weapon", "damage_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Proprietà delle Armi: Versatile",
        pageStart: 147,
        pageEnd: 147,
        section: "Proprietà delle Armi: Versatile",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "equipment_pack": GlossaryEntry(
    id: "equipment_pack",
    name: "Dotazione",
    aliases: {"Dotazioni", "Pacchetto di Equipaggiamento"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un insieme predefinito di oggetti acquistabile o selezionabile come equipaggiamento iniziale.",
    details:
        "Una dotazione semplifica l’acquisto di gruppi ricorrenti di oggetti. Ogni elemento mantiene quantità, peso e regole proprie.",
    relatedIds: ["currency", "object_interaction", "carrying_capacity"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Dotazioni",
        pageStart: 151,
        pageEnd: 151,
        section: "Dotazioni",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
  "tool_proficiency": GlossaryEntry(
    id: "tool_proficiency",
    name: "Competenza negli Strumenti",
    aliases: {"Competenza in uno Strumento"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "L’addestramento che consente di aggiungere il Bonus di Competenza alle prove di caratteristica effettuate usando uno strumento.",
    details:
        "La competenza in uno strumento non è un’abilità separata. Il Dungeon Master sceglie la caratteristica appropriata in base al modo in cui lo strumento viene utilizzato.",
    relatedIds: ["ability_check", "proficiency_bonus"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Strumenti",
        pageStart: 154,
        pageEnd: 154,
        section: "Strumenti",
      ),
    ],
    tags: {"phb", "equipaggiamento"},
  ),
};
