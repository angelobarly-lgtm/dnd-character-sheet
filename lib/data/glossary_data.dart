import 'class_data.dart';

/// Glossario condiviso da tutti i sistemi dell’app.
///
/// Queste sono le 23 voci introdotte con il catalogo delle razze PHB.
/// Gli ID restano invariati per preservare tutti i collegamenti esistenti.
const Map<String, GlossaryEntry> glossaryEntries = {
  "poison_resilience": GlossaryEntry(
    id: "poison_resilience",
    name: "Resilienza al Veleno",
    aliases: {"Resilienza Nanica"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto razziale che concede vantaggio ai tiri salvezza contro il veleno e resistenza ai danni da veleno.",
    details:
        "La Resilienza Nanica applica entrambe le protezioni: il vantaggio riguarda i tiri salvezza contro l’essere avvelenato o altri effetti di veleno, mentre la resistenza dimezza i danni da veleno.",
    sections: [
      GlossarySectionDefinition(
        id: "poison_resilience_effects",
        title: "Protezioni",
        type: GlossarySectionType.completeRule,
        content:
            "Vantaggio ai tiri salvezza contro il veleno e resistenza ai danni da veleno.",
        relatedIds: [
          "saving_throw",
          "advantage",
          "damage_resistance",
          "poisoned"
        ],
      ),
    ],
    relatedIds: [
      "saving_throw",
      "advantage",
      "damage_resistance",
      "poisoned",
      "damage_types"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Nano",
        pageStart: 18,
        pageEnd: 20,
        section: "Resilienza Nanica",
      ),
    ],
    tags: {"phb", "razza", "nano"},
  ),
  "racial_weapon_training": GlossaryEntry(
    id: "racial_weapon_training",
    name: "Addestramento Razziale nelle Armi",
    aliases: {
      "Addestramento da Combattimento Nanico",
      "Addestramento nelle Armi Elfiche"
    },
    category: GlossaryCategory.caratteristica,
    summary:
        "Competenze nelle armi concesse da una razza o sottorazza indipendentemente dalla classe.",
    details:
        "Il tratto elenca precisamente le armi con cui il personaggio è competente. La competenza permette di aggiungere il Bonus di Competenza ai tiri per colpire effettuati con quelle armi.",
    relatedIds: ["weapon_proficiency", "proficiency_bonus", "attack_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Nano",
        pageStart: 18,
        pageEnd: 20,
        section: "Addestramento da Combattimento Nanico",
      ),
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Elfo",
        pageStart: 21,
        pageEnd: 24,
        section: "Addestramento nelle Armi Elfiche",
      ),
    ],
    tags: {"phb", "razza", "armi"},
  ),
  "racial_hit_points": GlossaryEntry(
    id: "racial_hit_points",
    name: "Punti Ferita Razziali",
    aliases: {"Robustezza Nanica"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una modifica permanente ai punti ferita massimi concessa da una razza o sottorazza.",
    details:
        "La Robustezza Nanica aumenta i punti ferita massimi di 1 al 1° livello e di un ulteriore punto ogni volta che il personaggio ottiene un livello.",
    sections: [
      GlossarySectionDefinition(
        id: "dwarven_toughness_progression",
        title: "Progressione",
        type: GlossarySectionType.completeRule,
        content:
            "Il massimo dei punti ferita aumenta di 1 al 1° livello e di 1 per ogni livello successivo.",
        numericValues: {"hitPointsPerLevel": 1},
        relatedIds: ["hit_points"],
      ),
    ],
    relatedIds: ["hit_points"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Nano delle Colline",
        pageStart: 20,
        pageEnd: 20,
        section: "Robustezza Nanica",
      ),
    ],
    tags: {"phb", "razza", "nano"},
  ),
  "racial_cantrip": GlossaryEntry(
    id: "racial_cantrip",
    name: "Trucchetto Razziale",
    aliases: {"Trucchetto dell’Elfo Alto"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un trucchetto conosciuto grazie a una razza o sottorazza anziché alla classe del personaggio.",
    details:
        "Il tratto indica quale trucchetto viene concesso, quale caratteristica da incantatore utilizza e se la scelta è fissa o effettuata da una lista.",
    relatedIds: ["cantrip", "spellcasting_ability", "racial_spellcasting"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Elfo Alto",
        pageStart: 24,
        pageEnd: 24,
        section: "Trucchetto",
      ),
    ],
    tags: {"phb", "razza", "magia"},
  ),
  "conditional_racial_rule": GlossaryEntry(
    id: "conditional_racial_rule",
    name: "Regola Razziale Condizionale",
    category: GlossaryCategory.regola,
    summary:
        "Un tratto razziale applicabile soltanto quando ricorrono le condizioni specificate dalla capacità.",
    details:
        "Questa voce tecnica dell’app conserva requisiti, bersagli, frequenze, circostanze e limitazioni dei tratti razziali senza trasformarli in bonus sempre attivi.",
    relatedIds: ["racial_progression"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali",
      ),
    ],
    tags: {"phb", "razza", "struttura"},
  ),
  "breath_weapon": GlossaryEntry(
    id: "breath_weapon",
    name: "Arma a Soffio",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto del Dragonide che consente di usare un’azione per emettere energia distruttiva.",
    details:
        "Discendenza Draconica determina forma, dimensioni, tipo di danno e tiro salvezza. La CD è 8 più modificatore di Costituzione e Bonus di Competenza. Il danno aumenta ai livelli 6, 11 e 16 e il tratto si recupera con un riposo breve o lungo.",
    sections: [
      GlossarySectionDefinition(
        id: "breath_weapon_save_dc",
        title: "CD del tiro salvezza",
        type: GlossarySectionType.completeRule,
        content: "CD = 8 + modificatore di Costituzione + Bonus di Competenza.",
        numericValues: {"baseDifficultyClass": 8},
        relatedIds: ["constitution", "proficiency_bonus", "saving_throw"],
      ),
      GlossarySectionDefinition(
        id: "breath_weapon_progression",
        title: "Progressione dei danni",
        type: GlossarySectionType.completeRule,
        content: "2d6 al 1° livello, 3d6 al 6°, 4d6 all’11° e 5d6 al 16°.",
        numericValues: {
          "level1Dice": 2,
          "level6Dice": 3,
          "level11Dice": 4,
          "level16Dice": 5,
          "dieSize": 6
        },
        relatedIds: ["damage_roll"],
      ),
    ],
    relatedIds: [
      "draconic_ancestry",
      "action",
      "saving_throw",
      "constitution",
      "proficiency_bonus",
      "damage_roll",
      "short_rest",
      "long_rest"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Dragonide",
        pageStart: 32,
        pageEnd: 34,
        section: "Arma a Soffio",
      ),
    ],
    tags: {"phb", "razza", "dragonide"},
  ),
  "draconic_ancestry": GlossaryEntry(
    id: "draconic_ancestry",
    name: "Discendenza Draconica",
    category: GlossaryCategory.caratteristica,
    summary:
        "La scelta razziale del Dragonide che determina il tipo del soffio e la resistenza associata.",
    details:
        "Le dieci discendenze del PHB sono Argento, Bianco, Blu, Bronzo, Nero, Oro, Ottone, Rame, Rosso e Verde. Ognuna associa un tipo di danno e una forma dell’Arma a Soffio.",
    sections: [
      GlossarySectionDefinition(
        id: "draconic_ancestry_count",
        title: "Discendenze disponibili",
        type: GlossarySectionType.completeRule,
        content:
            "Il Manuale del Giocatore presenta dieci discendenze draconiche.",
        numericValues: {"ancestryCount": 10},
      ),
    ],
    relatedIds: ["breath_weapon", "damage_resistance", "damage_types"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Dragonide",
        pageStart: 32,
        pageEnd: 34,
        section: "Discendenza Draconica",
      ),
    ],
    tags: {"phb", "razza", "dragonide"},
  ),
  "fey_ancestry": GlossaryEntry(
    id: "fey_ancestry",
    name: "Retaggio Fatato",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto di Elfi e Mezzelfi che protegge dagli effetti di charme e dal sonno magico.",
    details:
        "Il personaggio dispone di vantaggio ai tiri salvezza contro l’essere affascinato e la magia non può farlo addormentare.",
    sections: [
      GlossarySectionDefinition(
        id: "fey_ancestry_protections",
        title: "Protezioni",
        type: GlossarySectionType.completeRule,
        content:
            "Vantaggio ai tiri salvezza contro l’essere Affascinato; immunità al sonno provocato dalla magia.",
        relatedIds: ["saving_throw", "advantage", "charmed"],
      ),
    ],
    relatedIds: ["saving_throw", "advantage", "charmed", "unconscious"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Elfo",
        pageStart: 21,
        pageEnd: 24,
        section: "Retaggio Fatato",
      ),
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Mezzelfo",
        pageStart: 38,
        pageEnd: 39,
        section: "Retaggio Fatato",
      ),
    ],
    tags: {"phb", "razza", "elfo", "mezzelfo"},
  ),
  "trance": GlossaryEntry(
    id: "trance",
    name: "Trance",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto elfico che sostituisce il normale sonno con quattro ore giornaliere di meditazione profonda.",
    details:
        "Durante la trance l’elfo rimane semicosciente. Dopo quattro ore ottiene lo stesso beneficio che un umano ottiene dormendo per otto ore.",
    sections: [
      GlossarySectionDefinition(
        id: "trance_duration",
        title: "Durata",
        type: GlossarySectionType.completeRule,
        content:
            "La trance dura 4 ore e fornisce il beneficio di 8 ore di sonno umano.",
        numericValues: {"tranceHours": 4, "equivalentSleepHours": 8},
        relatedIds: ["long_rest"],
      ),
    ],
    relatedIds: ["long_rest"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Elfo",
        pageStart: 21,
        pageEnd: 24,
        section: "Trance",
      ),
    ],
    tags: {"phb", "razza", "elfo"},
  ),
  "relentless_endurance": GlossaryEntry(
    id: "relentless_endurance",
    name: "Tenacia Implacabile",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto del Mezzorco che può impedirgli di scendere immediatamente a 0 punti ferita.",
    details:
        "Quando viene ridotto a 0 punti ferita ma non ucciso sul colpo, il Mezzorco può scendere invece a 1 punto ferita. Deve completare un riposo lungo prima di riutilizzare il tratto.",
    sections: [
      GlossarySectionDefinition(
        id: "relentless_endurance_result",
        title: "Risultato",
        type: GlossarySectionType.completeRule,
        content:
            "Quando il tratto si attiva, il personaggio rimane a 1 punto ferita invece di scendere a 0.",
        numericValues: {"remainingHitPoints": 1},
        relatedIds: ["hit_points"],
      ),
    ],
    relatedIds: [
      "hit_points",
      "dropping_to_zero_hit_points",
      "instant_death",
      "long_rest"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Mezzorco",
        pageStart: 40,
        pageEnd: 41,
        section: "Tenacia Implacabile",
      ),
    ],
    tags: {"phb", "razza", "mezzorco"},
  ),
  "savage_attacks": GlossaryEntry(
    id: "savage_attacks",
    name: "Attacchi Selvaggi",
    category: GlossaryCategory.combattimento,
    summary:
        "Un tratto del Mezzorco che aggiunge un dado dell’arma ai danni di un colpo critico con arma da mischia.",
    details:
        "Quando il Mezzorco ottiene un colpo critico con un attacco con arma da mischia, tira una volta aggiuntiva uno dei dadi di danno dell’arma e aggiunge il risultato ai danni extra del critico.",
    sections: [
      GlossarySectionDefinition(
        id: "savage_attacks_extra_die",
        title: "Dado aggiuntivo",
        type: GlossarySectionType.completeRule,
        content:
            "Aggiunge 1 dado di danno dell’arma al Colpo Critico con un’arma da mischia.",
        numericValues: {"additionalWeaponDice": 1},
        relatedIds: ["critical_hit", "melee_weapon"],
      ),
    ],
    relatedIds: ["critical_hit", "melee_weapon", "damage_roll"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Mezzorco",
        pageStart: 40,
        pageEnd: 41,
        section: "Attacchi Selvaggi",
      ),
    ],
    tags: {"phb", "razza", "mezzorco"},
  ),
  "hellish_resistance": GlossaryEntry(
    id: "hellish_resistance",
    name: "Resistenza Infernale",
    category: GlossaryCategory.caratteristica,
    summary: "Un tratto del Tiefling che concede resistenza ai danni da fuoco.",
    details:
        "Quando il Tiefling subisce danni da fuoco, applica le normali regole della Resistenza ai Danni.",
    relatedIds: ["damage_resistance", "damage_types"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiefling",
        pageStart: 42,
        pageEnd: 43,
        section: "Resistenza Infernale",
      ),
    ],
    tags: {"phb", "razza", "tiefling"},
  ),
  "infernal_legacy": GlossaryEntry(
    id: "infernal_legacy",
    name: "Retaggio Infernale",
    category: GlossaryCategory.caratteristica,
    summary:
        "La magia razziale del Tiefling, che concede un trucchetto e due incantesimi con l’aumentare del livello.",
    details:
        "Il Tiefling conosce Taumaturgia. Dal 3° livello può lanciare Punizione Infernale come incantesimo di 2° livello e dal 5° livello Oscurità; gli incantesimi concessi si recuperano con un riposo lungo e usano Carisma.",
    sections: [
      GlossarySectionDefinition(
        id: "infernal_legacy_levels",
        title: "Progressione",
        type: GlossarySectionType.completeRule,
        content:
            "Taumaturgia dal 1° livello, Punizione Infernale dal 3° e Oscurità dal 5°.",
        numericValues: {
          "cantripLevel": 1,
          "hellishRebukeLevel": 3,
          "darknessLevel": 5
        },
        relatedIds: ["racial_progression"],
      ),
    ],
    relatedIds: [
      "racial_spellcasting",
      "racial_progression",
      "cantrip",
      "spell",
      "charisma",
      "long_rest"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiefling",
        pageStart: 42,
        pageEnd: 43,
        section: "Retaggio Infernale",
      ),
    ],
    tags: {"phb", "razza", "tiefling", "magia"},
  ),
  "sunlight_sensitivity": GlossaryEntry(
    id: "sunlight_sensitivity",
    name: "Sensibilità alla Luce del Sole",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un tratto che impone svantaggio a determinati tiri quando il personaggio o il bersaglio si trova alla luce solare diretta.",
    details:
        "Il Drow subisce svantaggio ai tiri per colpire e alle prove di Saggezza (Percezione) basate sulla vista quando lui, il bersaglio dell’attacco o ciò che tenta di percepire si trova alla luce solare diretta.",
    relatedIds: ["bright_light", "attack_roll", "perception", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Drow",
        pageStart: 24,
        pageEnd: 24,
        section: "Sensibilità alla Luce del Sole",
      ),
    ],
    tags: {"phb", "razza", "drow"},
  ),
  "racial_progression": GlossaryEntry(
    id: "racial_progression",
    name: "Progressione Razziale",
    category: GlossaryCategory.regola,
    summary:
        "La disponibilità di capacità razziali quando il personaggio raggiunge il livello totale richiesto.",
    details:
        "Quando un tratto razziale indica un livello, si usa normalmente il livello totale del personaggio e non il livello posseduto in una singola classe.",
    relatedIds: ["infernal_legacy", "racial_spellcasting"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali",
      ),
    ],
    tags: {"phb", "razza", "progressione"},
  ),
  "darkvision": GlossaryEntry(
    id: "darkvision",
    name: "Scurovisione",
    category: GlossaryCategory.caratteristica,
    summary:
        "Un senso speciale che permette di vedere entro una portata indicata anche in condizioni di luce fioca e oscurità.",
    details:
        "Entro la portata, la creatura vede in luce fioca come se fosse luce intensa e nell’oscurità come se fosse luce fioca. Nell’oscurità non distingue i colori e vede soltanto sfumature di grigio.",
    sections: [
      GlossarySectionDefinition(
        id: "darkvision_light_levels",
        title: "Percezione della luce",
        type: GlossarySectionType.completeRule,
        content:
            "Luce fioca trattata come luce intensa; oscurità trattata come luce fioca; nell’oscurità si vedono soltanto sfumature di grigio.",
        relatedIds: ["bright_light", "dim_light", "darkness"],
      ),
    ],
    relatedIds: [
      "vision_and_light",
      "dim_light",
      "darkness",
      "lightly_obscured"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Avventura",
        pageStart: 183,
        pageEnd: 185,
        section: "Scurovisione",
      ),
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali",
      ),
    ],
    tags: {"phb", "senso", "razza"},
  ),
  "damage_resistance": GlossaryEntry(
    id: "damage_resistance",
    name: "Resistenza ai Danni",
    aliases: {"Resistenza a un Tipo di Danno"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura resistente a un tipo di danno subisce la metà dei danni di quel tipo.",
    details:
        "La resistenza si applica dopo gli altri modificatori ai danni. Più fonti di resistenza allo stesso tipo non si cumulano; le frazioni vengono arrotondate per difetto.",
    sections: [
      GlossarySectionDefinition(
        id: "damage_resistance_divisor",
        title: "Danni dimezzati",
        type: GlossarySectionType.completeRule,
        content:
            "Dopo gli altri modificatori, dividi per 2 i danni del tipo a cui la creatura è resistente e arrotonda per difetto.",
        numericValues: {"damageDivisor": 2},
        relatedIds: ["damage_roll"],
      ),
    ],
    relatedIds: [
      "damage_roll",
      "damage_types",
      "damage_vulnerability",
      "damage_immunity"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combattimento",
        pageStart: 197,
        pageEnd: 197,
        section: "Resistenza e Vulnerabilità ai Danni",
      ),
    ],
    tags: {"phb", "combattimento", "danni"},
  ),
  "saving_throw_advantage": GlossaryEntry(
    id: "saving_throw_advantage",
    name: "Vantaggio ai Tiri Salvezza",
    category: GlossaryCategory.regola,
    summary:
        "Una capacità può concedere vantaggio a specifici tiri salvezza nelle circostanze indicate.",
    details:
        "Si tirano due d20 e si usa il risultato più alto. Se sullo stesso tiro è presente anche svantaggio, vantaggio e svantaggio si annullano.",
    relatedIds: ["saving_throw", "advantage", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Uso dei Punteggi di Caratteristica",
        pageStart: 173,
        pageEnd: 179,
        section: "Vantaggio e Svantaggio",
      ),
    ],
    tags: {"phb", "tiri salvezza"},
  ),
  "condition_immunity": GlossaryEntry(
    id: "condition_immunity",
    name: "Immunità a una Condizione",
    aliases: {"Immunità alle Condizioni"},
    category: GlossaryCategory.condizione,
    summary:
        "Una creatura immune a una condizione non può subirne gli effetti.",
    details:
        "L’immunità si applica soltanto alle condizioni indicate e non implica automaticamente immunità ai danni o ad altri effetti prodotti dalla stessa fonte.",
    relatedIds: ["damage_immunity"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Appendice A",
        pageStart: 290,
        pageEnd: 292,
        section: "Condizioni",
      ),
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali",
      ),
    ],
    tags: {"phb", "condizione", "immunità"},
  ),
  "racial_spellcasting": GlossaryEntry(
    id: "racial_spellcasting",
    name: "Magia Razziale",
    category: GlossaryCategory.caratteristica,
    summary:
        "Incantesimi o trucchetti concessi da una razza o sottorazza indipendentemente dalla classe.",
    details:
        "Il tratto stabilisce incantesimi, livelli di acquisizione, caratteristica da incantatore, frequenza d’uso ed eventuale necessità di componenti. Gli incantesimi razziali non diventano automaticamente incantesimi di classe.",
    relatedIds: [
      "spell",
      "cantrip",
      "spellcasting_ability",
      "racial_cantrip",
      "racial_progression"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali Magici",
      ),
    ],
    tags: {"phb", "razza", "magia"},
  ),
  "racial_proficiency": GlossaryEntry(
    id: "racial_proficiency",
    name: "Competenza Razziale",
    category: GlossaryCategory.caratteristica,
    summary:
        "Una competenza concessa da una razza o sottorazza in aggiunta alle altre fonti del personaggio.",
    details:
        "La competenza può riguardare abilità, armi, armature o strumenti. Quando si applica a un tiro appropriato permette normalmente di aggiungere il Bonus di Competenza.",
    relatedIds: [
      "proficiency_bonus",
      "weapon_proficiency",
      "armor_proficiency",
      "tool_proficiency"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Tratti Razziali",
      ),
    ],
    tags: {"phb", "razza", "competenza"},
  ),
  "racial_language": GlossaryEntry(
    id: "racial_language",
    name: "Lingua Razziale",
    aliases: {"Lingue Razziali"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Una lingua conosciuta dal personaggio grazie alla razza o a una scelta prevista dai suoi tratti.",
    details:
        "Il personaggio può normalmente parlare, leggere e scrivere le lingue concesse. Alcuni tratti permettono di scegliere una lingua aggiuntiva tra quelle disponibili nella campagna.",
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Lingue",
      ),
    ],
    tags: {"phb", "razza", "lingua"},
  ),
  "racial_speed": GlossaryEntry(
    id: "racial_speed",
    name: "Velocità Razziale",
    category: GlossaryCategory.caratteristica,
    summary: "La velocità base sul terreno concessa dalla razza o sottorazza.",
    details:
        "La velocità indica quanti metri il personaggio può percorrere normalmente durante il proprio turno. Capacità, armature, condizioni e altre regole possono modificarla.",
    relatedIds: ["movement", "heavy_armor", "grappled", "restrained"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Razze",
        pageStart: 17,
        pageEnd: 43,
        section: "Velocità",
      ),
    ],
    tags: {"phb", "razza", "movimento"},
  ),
};

GlossaryEntry? glossaryEntryFor(String id) => glossaryEntries[id];
