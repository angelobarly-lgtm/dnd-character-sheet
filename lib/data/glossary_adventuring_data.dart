import 'class_data.dart';

/// Esplorazione e ambiente del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbAdventuringGlossaryEntries = {
  "travel_pace": GlossaryEntry(
    id: "travel_pace",
    name: "Passo di Viaggio",
    aliases: {"Passo Veloce", "Passo Normale", "Passo Lento"},
    category: GlossaryCategory.regola,
    summary:
        "Il ritmo veloce, normale o lento con cui un gruppo percorre una distanza durante un viaggio.",
    details:
        "Un passo veloce aumenta la distanza percorsa ma impone svantaggio alla Saggezza (Percezione) passiva. Un passo lento riduce la distanza e può consentire di muoversi furtivamente.",
    sections: [
      GlossarySectionDefinition(
        id: "travel_pace_distances",
        title: "Distanze indicative",
        type: GlossarySectionType.completeRule,
        content:
            "Passo veloce: circa 120 metri al minuto, 6 km all’ora e 45 km al giorno. Passo normale: 90 metri al minuto, 4,5 km all’ora e 36 km al giorno. Passo lento: 60 metri al minuto, 3 km all’ora e 27 km al giorno.",
        numericValues: {
          "fastKilometersPerDay": 45,
          "normalKilometersPerDay": 36,
          "slowKilometersPerDay": 27
        },
      ),
    ],
    relatedIds: ["movement", "passive_check", "perception", "stealth"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Passo di Viaggio",
        pageStart: 181,
        pageEnd: 182,
        section: "Passo di Viaggio",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "forced_march": GlossaryEntry(
    id: "forced_march",
    name: "Marcia Forzata",
    category: GlossaryCategory.regola,
    summary:
        "Un viaggio che prosegue oltre le normali otto ore giornaliere di marcia.",
    details:
        "Per ogni ora aggiuntiva, ogni personaggio effettua un tiro salvezza su Costituzione al termine dell’ora. La CD è 10 più il numero di ore oltre le prime otto; un fallimento causa un livello di Indebolimento.",
    sections: [
      GlossarySectionDefinition(
        id: "forced_march_save",
        title: "Tiro salvezza",
        type: GlossarySectionType.procedure,
        content:
            "Dopo ogni ora oltre le prime 8, effettua un tiro salvezza su Costituzione con CD 10 + numero delle ore aggiuntive già percorse.",
        numericValues: {"normalTravelHours": 8, "baseDifficultyClass": 10},
        relatedIds: ["saving_throw", "constitution", "exhaustion"],
      ),
    ],
    relatedIds: ["travel_pace", "saving_throw", "constitution", "exhaustion"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Marcia Forzata",
        pageStart: 181,
        pageEnd: 181,
        section: "Marcia Forzata",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "marching_order": GlossaryEntry(
    id: "marching_order",
    name: "Ordine di Marcia",
    category: GlossaryCategory.regola,
    summary:
        "La disposizione dei personaggi durante un viaggio, normalmente divisa in rango anteriore, centrale e posteriore.",
    details:
        "L’ordine aiuta il Dungeon Master a determinare chi incontra per primo pericoli, nemici, trappole o altri elementi dell’ambiente.",
    relatedIds: ["travel_pace", "surprise", "perception"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Ordine di Marcia",
        pageStart: 182,
        pageEnd: 182,
        section: "Ordine di Marcia",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "travel_activities": GlossaryEntry(
    id: "travel_activities",
    name: "Attività durante il Viaggio",
    aliases: {"Attività di Viaggio"},
    category: GlossaryCategory.regola,
    summary:
        "Compiti svolti dai personaggi mentre il gruppo viaggia, come orientarsi, seguire tracce, foraggiare o sorvegliare i pericoli.",
    details:
        "Un personaggio concentrato su un’attività diversa dal sorvegliare i pericoli non contribuisce normalmente alla Saggezza (Percezione) passiva del gruppo per individuare minacce.",
    relatedIds: [
      "navigation",
      "tracking",
      "foraging",
      "passive_check",
      "perception"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attività durante il Viaggio",
        pageStart: 182,
        pageEnd: 183,
        section: "Attività durante il Viaggio",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "navigation": GlossaryEntry(
    id: "navigation",
    name: "Orientarsi",
    category: GlossaryCategory.regola,
    summary:
        "L’attività di viaggio usata per impedire al gruppo di smarrire la strada.",
    details:
        "Il Dungeon Master può richiedere una prova di Saggezza (Sopravvivenza), con difficoltà determinata dal terreno, dal tempo e dagli strumenti disponibili.",
    relatedIds: ["travel_activities", "wisdom", "survival", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Orientarsi",
        pageStart: 183,
        pageEnd: 183,
        section: "Orientarsi",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "tracking": GlossaryEntry(
    id: "tracking",
    name: "Seguire Tracce",
    category: GlossaryCategory.regola,
    summary:
        "L’attività usata per seguire il passaggio di altre creature durante l’esplorazione.",
    details:
        "Il Dungeon Master può richiedere una prova di Saggezza (Sopravvivenza), modificata dall’età delle tracce, dal terreno, dal clima e dal numero di creature.",
    relatedIds: ["travel_activities", "wisdom", "survival", "ability_check"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Seguire Tracce",
        pageStart: 183,
        pageEnd: 183,
        section: "Seguire Tracce",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "foraging": GlossaryEntry(
    id: "foraging",
    name: "Foraggiare",
    category: GlossaryCategory.regola,
    summary: "L’attività usata per cercare cibo e acqua durante un viaggio.",
    details:
        "Il Dungeon Master stabilisce una CD di Saggezza (Sopravvivenza) in base all’abbondanza delle risorse. Una prova riuscita permette di trovare quantità determinate di cibo e acqua.",
    relatedIds: [
      "travel_activities",
      "survival",
      "ability_check",
      "food_requirement",
      "water_requirement"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Foraggiare",
        pageStart: 183,
        pageEnd: 183,
        section: "Foraggiare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "special_movement": GlossaryEntry(
    id: "special_movement",
    name: "Movimento Speciale",
    aliases: {"Tipi Speciali di Movimento"},
    category: GlossaryCategory.regola,
    summary:
        "Movimento che comprende arrampicarsi, nuotare, strisciare e saltare.",
    details:
        "Quando una creatura non possiede una velocità specifica adatta, alcune forme di movimento richiedono di spendere movimento aggiuntivo e possono richiedere una prova di caratteristica.",
    relatedIds: [
      "movement",
      "climbing",
      "swimming",
      "crawling",
      "long_jump",
      "high_jump"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tipi Speciali di Movimento",
        pageStart: 182,
        pageEnd: 183,
        section: "Tipi Speciali di Movimento",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "climbing": GlossaryEntry(
    id: "climbing",
    name: "Arrampicarsi",
    category: GlossaryCategory.regola,
    summary:
        "Un tipo di movimento che normalmente costa un metro aggiuntivo per ogni metro percorso.",
    details:
        "Il Dungeon Master può richiedere una prova di Forza (Atletica) quando la superficie è scivolosa, offre pochi appigli o presenta altri pericoli. Una velocità di scalare può sostituire il costo aggiuntivo previsto.",
    sections: [
      GlossarySectionDefinition(
        id: "climbing_cost",
        title: "Costo del movimento",
        type: GlossarySectionType.completeRule,
        content:
            "In assenza di una velocità di scalare applicabile, ogni metro percorso costa un metro aggiuntivo.",
        numericValues: {"movementCostMultiplier": 2},
      ),
    ],
    relatedIds: [
      "special_movement",
      "movement",
      "strength",
      "athletics",
      "ability_check"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Arrampicarsi, Nuotare e Strisciare",
        pageStart: 182,
        pageEnd: 182,
        section: "Arrampicarsi, Nuotare e Strisciare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "swimming": GlossaryEntry(
    id: "swimming",
    name: "Nuotare",
    category: GlossaryCategory.regola,
    summary:
        "Un tipo di movimento che normalmente costa un metro aggiuntivo per ogni metro percorso.",
    details:
        "Il Dungeon Master può richiedere una prova di Forza (Atletica) in acque agitate o pericolose. Una velocità di nuotare può sostituire il costo aggiuntivo previsto.",
    sections: [
      GlossarySectionDefinition(
        id: "swimming_cost",
        title: "Costo del movimento",
        type: GlossarySectionType.completeRule,
        content:
            "In assenza di una velocità di nuotare applicabile, ogni metro percorso costa un metro aggiuntivo.",
        numericValues: {"movementCostMultiplier": 2},
      ),
    ],
    relatedIds: [
      "special_movement",
      "movement",
      "strength",
      "athletics",
      "ability_check"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Arrampicarsi, Nuotare e Strisciare",
        pageStart: 182,
        pageEnd: 182,
        section: "Arrampicarsi, Nuotare e Strisciare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "crawling": GlossaryEntry(
    id: "crawling",
    name: "Strisciare",
    category: GlossaryCategory.regola,
    summary:
        "Il modo ordinario in cui una creatura prona può spostarsi senza rialzarsi.",
    details:
        "Ogni metro percorso strisciando costa un metro aggiuntivo. Se il terreno è anche difficile, i costi aggiuntivi si sommano.",
    sections: [
      GlossarySectionDefinition(
        id: "crawling_cost",
        title: "Costo del movimento",
        type: GlossarySectionType.completeRule,
        content: "Ogni metro percorso strisciando costa un metro aggiuntivo.",
        numericValues: {"movementCostMultiplier": 2},
      ),
    ],
    relatedIds: ["special_movement", "movement", "prone", "difficult_terrain"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Arrampicarsi, Nuotare e Strisciare",
        pageStart: 182,
        pageEnd: 182,
        section: "Arrampicarsi, Nuotare e Strisciare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "long_jump": GlossaryEntry(
    id: "long_jump",
    name: "Salto in Lungo",
    aliases: {"Salto Lungo"},
    category: GlossaryCategory.regola,
    summary:
        "Un salto orizzontale la cui distanza dipende dal punteggio di Forza.",
    details:
        "Con una rincorsa di almeno 3 metri, la distanza in piedi è pari al punteggio di Forza. Da fermo si copre soltanto metà della distanza. Ogni metro saltato consuma movimento.",
    sections: [
      GlossarySectionDefinition(
        id: "long_jump_running_start",
        title: "Rincorsa",
        type: GlossarySectionType.completeRule,
        content:
            "Per ottenere la distanza completa occorre muoversi di almeno 3 metri immediatamente prima del salto. Da fermo la distanza è dimezzata.",
        numericValues: {"runningStartMeters": 3, "standingDistanceDivisor": 2},
      ),
    ],
    relatedIds: ["special_movement", "movement", "strength", "athletics"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Saltare",
        pageStart: 182,
        pageEnd: 182,
        section: "Saltare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "high_jump": GlossaryEntry(
    id: "high_jump",
    name: "Salto in Alto",
    aliases: {"Salto Alto"},
    category: GlossaryCategory.regola,
    summary:
        "Un salto verticale la cui altezza dipende dal modificatore di Forza.",
    details:
        "Con una rincorsa di almeno 3 metri, l’altezza è pari a 0,9 metri più 0,3 metri per ogni punto del modificatore di Forza. Da fermo l’altezza è dimezzata.",
    sections: [
      GlossarySectionDefinition(
        id: "high_jump_formula",
        title: "Altezza del salto",
        type: GlossarySectionType.completeRule,
        content:
            "Con rincorsa: 0,9 metri + 0,3 metri per ogni punto del modificatore di Forza. Da fermo il risultato è dimezzato.",
        numericValues: {
          "baseMeters": 0.9,
          "metersPerStrengthModifier": 0.3,
          "runningStartMeters": 3,
          "standingHeightDivisor": 2
        },
      ),
    ],
    relatedIds: ["special_movement", "movement", "strength", "athletics"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Saltare",
        pageStart: 182,
        pageEnd: 182,
        section: "Saltare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "falling": GlossaryEntry(
    id: "falling",
    name: "Cadere",
    aliases: {"Caduta", "Danni da Caduta"},
    category: GlossaryCategory.regola,
    summary:
        "Una creatura che cade subisce danni contundenti in base alla distanza e normalmente atterra prona.",
    details:
        "La creatura subisce 1d6 danni contundenti per ogni 3 metri di caduta, fino a un massimo di 20d6. Atterra prona salvo che riesca a evitare i danni della caduta.",
    sections: [
      GlossarySectionDefinition(
        id: "falling_damage",
        title: "Danni da caduta",
        type: GlossarySectionType.completeRule,
        content:
            "1d6 danni contundenti per ogni 3 metri di caduta, fino a un massimo di 20d6.",
        numericValues: {"metersPerDie": 3, "dieSize": 6, "maximumDice": 20},
        relatedIds: ["damage_roll", "prone"],
      ),
    ],
    relatedIds: ["damage_roll", "damage_types", "prone"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Cadere",
        pageStart: 183,
        pageEnd: 183,
        section: "Cadere",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "suffocating": GlossaryEntry(
    id: "suffocating",
    name: "Soffocare",
    aliases: {"Soffocamento", "Trattenere il Respiro"},
    category: GlossaryCategory.regola,
    summary:
        "Le regole che determinano per quanto tempo una creatura può trattenere il respiro o sopravvivere senza aria.",
    details:
        "Una creatura può trattenere il respiro per un numero di minuti pari a 1 più il modificatore di Costituzione, con un minimo di 30 secondi. Quando termina l’aria, sopravvive per un numero di round pari al modificatore di Costituzione, con un minimo di 1 round.",
    sections: [
      GlossarySectionDefinition(
        id: "suffocating_limits",
        title: "Limiti",
        type: GlossarySectionType.completeRule,
        content:
            "Respiro: 1 + modificatore di Costituzione minuti, minimo 30 secondi. Senza aria: modificatore di Costituzione round, minimo 1.",
        numericValues: {
          "baseBreathMinutes": 1,
          "minimumBreathSeconds": 30,
          "minimumRoundsWithoutAir": 1
        },
      ),
      GlossarySectionDefinition(
        id: "suffocating_zero_hp",
        title: "Quando termina l’aria",
        type: GlossarySectionType.specialCases,
        content:
            "All’inizio del turno successivo al termine dei round disponibili, la creatura scende a 0 punti ferita, è morente e non può essere stabilizzata o recuperare punti ferita finché non può respirare.",
        relatedIds: [
          "dropping_to_zero_hit_points",
          "stabilizing_creature",
          "healing"
        ],
      ),
    ],
    relatedIds: [
      "constitution",
      "dropping_to_zero_hit_points",
      "death_saving_throw"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Soffocare",
        pageStart: 183,
        pageEnd: 183,
        section: "Soffocare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "food_requirement": GlossaryEntry(
    id: "food_requirement",
    name: "Fabbisogno di Cibo",
    aliases: {"Cibo"},
    category: GlossaryCategory.risorsa,
    summary:
        "La quantità di cibo necessaria ogni giorno per evitare gli effetti della fame.",
    details:
        "Un personaggio necessita normalmente di circa 0,5 kg di cibo al giorno. Può razionarlo mangiandone metà, ma ogni mezza razione conta come metà giornata senza cibo.",
    sections: [
      GlossarySectionDefinition(
        id: "food_starvation",
        title: "Restare senza cibo",
        type: GlossarySectionType.completeRule,
        content:
            "Una creatura può resistere senza cibo per 3 + modificatore di Costituzione giorni, con un minimo di 1 giorno. Alla fine di ogni giorno successivo subisce un livello di Indebolimento.",
        numericValues: {
          "kilogramsPerDay": 0.5,
          "baseDaysWithoutFood": 3,
          "minimumDaysWithoutFood": 1
        },
        relatedIds: ["constitution", "exhaustion"],
      ),
    ],
    relatedIds: ["foraging", "exhaustion", "constitution"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Cibo",
        pageStart: 185,
        pageEnd: 185,
        section: "Cibo",
      ),
    ],
    tags: {"phb", "esplorazione", "risorsa"},
  ),
  "water_requirement": GlossaryEntry(
    id: "water_requirement",
    name: "Fabbisogno d’Acqua",
    aliases: {"Acqua"},
    category: GlossaryCategory.risorsa,
    summary:
        "La quantità d’acqua necessaria ogni giorno per evitare disidratazione e indebolimento.",
    details:
        "Un personaggio necessita normalmente di circa 4 litri d’acqua al giorno, oppure 8 litri in condizioni di caldo intenso.",
    sections: [
      GlossarySectionDefinition(
        id: "water_shortage",
        title: "Acqua insufficiente",
        type: GlossarySectionType.completeRule,
        content:
            "Con metà del fabbisogno, alla fine della giornata è richiesto un tiro salvezza su Costituzione con CD 15; un fallimento causa un livello di Indebolimento. Con meno della metà, il livello viene subito automaticamente.",
        numericValues: {
          "litersPerDay": 4,
          "hotWeatherLitersPerDay": 8,
          "difficultyClass": 15
        },
        relatedIds: ["saving_throw", "constitution", "exhaustion"],
      ),
    ],
    relatedIds: ["foraging", "exhaustion", "constitution", "saving_throw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Acqua",
        pageStart: 185,
        pageEnd: 185,
        section: "Acqua",
      ),
    ],
    tags: {"phb", "esplorazione", "risorsa"},
  ),
  "vision_and_light": GlossaryEntry(
    id: "vision_and_light",
    name: "Vista e Illuminazione",
    aliases: {"Vista e Luce"},
    category: GlossaryCategory.regola,
    summary:
        "Le regole che determinano quanto efficacemente una creatura può vedere in base alla luce e all’oscuramento.",
    details:
        "L’ambiente può essere illuminato da luce intensa, luce fioca o oscurità e può risultare leggermente o pesantemente oscurato.",
    relatedIds: [
      "bright_light",
      "dim_light",
      "darkness",
      "lightly_obscured",
      "heavily_obscured",
      "darkvision"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 185,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "lightly_obscured": GlossaryEntry(
    id: "lightly_obscured",
    name: "Area Leggermente Oscurata",
    aliases: {"Leggermente Oscurata", "Oscuramento Leggero"},
    category: GlossaryCategory.regola,
    summary:
        "Un’area che ostacola parzialmente la vista, come luce fioca, foschia moderata o fogliame rado.",
    details:
        "Una creatura subisce svantaggio alle prove di Saggezza (Percezione) basate sulla vista quando tenta di vedere qualcosa nell’area.",
    relatedIds: ["vision_and_light", "dim_light", "perception", "disadvantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 183,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "heavily_obscured": GlossaryEntry(
    id: "heavily_obscured",
    name: "Area Pesantemente Oscurata",
    aliases: {"Pesantemente Oscurata", "Oscuramento Pesante"},
    category: GlossaryCategory.regola,
    summary:
        "Un’area che blocca completamente la vista, come oscurità, nebbia fitta o fogliame denso.",
    details:
        "Una creatura che tenta di vedere qualcosa nell’area subisce gli effetti equivalenti alla condizione Accecato per quella percezione.",
    relatedIds: ["vision_and_light", "darkness", "blinded"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 183,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "bright_light": GlossaryEntry(
    id: "bright_light",
    name: "Luce Intensa",
    category: GlossaryCategory.regola,
    summary:
        "Un livello di illuminazione che consente alla maggior parte delle creature di vedere normalmente.",
    details:
        "La luce del giorno e molte fonti luminose producono luce intensa entro la portata indicata dalla fonte.",
    relatedIds: ["vision_and_light", "dim_light", "darkness"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 183,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "dim_light": GlossaryEntry(
    id: "dim_light",
    name: "Luce Fioca",
    aliases: {"Penombra"},
    category: GlossaryCategory.regola,
    summary: "Una luce debole che crea un’area leggermente oscurata.",
    details:
        "La luce fioca si trova spesso tra una fonte di luce intensa e l’oscurità oppure durante alba e crepuscolo.",
    relatedIds: [
      "vision_and_light",
      "lightly_obscured",
      "bright_light",
      "darkness",
      "darkvision"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 183,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "darkness": GlossaryEntry(
    id: "darkness",
    name: "Oscurità",
    category: GlossaryCategory.regola,
    summary:
        "L’assenza di illuminazione, che crea normalmente un’area pesantemente oscurata.",
    details:
        "La Scurovisione e altri sensi speciali possono permettere di percepire entro l’oscurità secondo le rispettive regole.",
    relatedIds: [
      "vision_and_light",
      "heavily_obscured",
      "dim_light",
      "darkvision",
      "blindsight",
      "truesight"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista e Illuminazione",
        pageStart: 183,
        pageEnd: 183,
        section: "Vista e Illuminazione",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "blindsight": GlossaryEntry(
    id: "blindsight",
    name: "Vista Cieca",
    aliases: {"Percezione Cieca"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Un senso speciale che permette di percepire l’ambiente entro una certa portata senza affidarsi alla vista.",
    details:
        "La portata è indicata dalla capacità che concede il senso. Creature prive di occhi o dotate di ecolocazione o sensi particolarmente sviluppati possono possederlo.",
    relatedIds: ["vision_and_light", "blinded", "invisible"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista Cieca",
        pageStart: 183,
        pageEnd: 185,
        section: "Vista Cieca",
      ),
    ],
    tags: {"phb", "esplorazione", "caratteristica"},
  ),
  "truesight": GlossaryEntry(
    id: "truesight",
    name: "Vista Pura",
    aliases: {"Vista del Vero"},
    category: GlossaryCategory.caratteristica,
    summary: "Un senso speciale che rivela la realtà entro una certa portata.",
    details:
        "Entro la portata una creatura può vedere nell’oscurità normale e magica, vedere creature e oggetti invisibili, individuare automaticamente illusioni visive e superarne i tiri salvezza, percepire la forma originale dei mutaforma e osservare il Piano Etereo.",
    relatedIds: ["vision_and_light", "darkness", "invisible", "saving_throw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Vista Pura",
        pageStart: 183,
        pageEnd: 185,
        section: "Vista Pura",
      ),
    ],
    tags: {"phb", "esplorazione", "caratteristica"},
  ),
  "carrying_capacity": GlossaryEntry(
    id: "carrying_capacity",
    name: "Capacità di Trasporto",
    aliases: {"Capacità di Carico"},
    category: GlossaryCategory.regola,
    summary:
        "Il peso massimo che una creatura può trasportare senza ricorrere alle regole opzionali dell’ingombro.",
    details:
        "La capacità di trasporto è pari al punteggio di Forza moltiplicato per 7,5 kg. Creature più grandi o più piccole modificano questi valori in base alla taglia.",
    sections: [
      GlossarySectionDefinition(
        id: "carrying_capacity_formula",
        title: "Formula",
        type: GlossarySectionType.completeRule,
        content: "Capacità di trasporto = punteggio di Forza × 7,5 kg.",
        numericValues: {"kilogramsPerStrengthPoint": 7.5},
        relatedIds: ["strength"],
      ),
    ],
    relatedIds: [
      "strength",
      "ability_score",
      "size_category",
      "push_drag_lift"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Sollevare e Trasportare",
        pageStart: 176,
        pageEnd: 176,
        section: "Sollevare e Trasportare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "push_drag_lift": GlossaryEntry(
    id: "push_drag_lift",
    name: "Spingere, Trascinare o Sollevare",
    category: GlossaryCategory.regola,
    summary:
        "Il limite di peso che una creatura può spingere, trascinare o sollevare.",
    details:
        "Il limite è pari al doppio della capacità di trasporto, cioè al punteggio di Forza moltiplicato per 15 kg. Quando spinge o trascina oltre la capacità di trasporto, la velocità scende a 1,5 metri.",
    sections: [
      GlossarySectionDefinition(
        id: "push_drag_lift_formula",
        title: "Formula",
        type: GlossarySectionType.completeRule,
        content:
            "Peso massimo = punteggio di Forza × 15 kg. Oltre la capacità di trasporto, la velocità durante la spinta o il trascinamento è 1,5 metri.",
        numericValues: {
          "kilogramsPerStrengthPoint": 15,
          "overCapacitySpeedMeters": 1.5
        },
        relatedIds: ["strength", "carrying_capacity", "movement"],
      ),
    ],
    relatedIds: ["strength", "carrying_capacity", "movement", "size_category"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Spingere, Trascinare o Sollevare",
        pageStart: 176,
        pageEnd: 176,
        section: "Spingere, Trascinare o Sollevare",
      ),
    ],
    tags: {"phb", "esplorazione", "regola"},
  ),
  "size_category": GlossaryEntry(
    id: "size_category",
    name: "Categoria di Taglia",
    aliases: {"Taglia", "Categorie di Taglia"},
    category: GlossaryCategory.caratteristica,
    summary:
        "La classificazione delle dimensioni di una creatura: Minuscola, Piccola, Media, Grande, Enorme o Mastodontica.",
    details:
        "La taglia determina lo spazio controllato in combattimento e può modificare capacità di trasporto, lotta, spinta e altre interazioni.",
    sections: [
      GlossarySectionDefinition(
        id: "size_categories",
        title: "Le sei categorie",
        type: GlossarySectionType.completeRule,
        content: "Minuscola, Piccola, Media, Grande, Enorme e Mastodontica.",
        numericValues: {"categoryCount": 6},
      ),
    ],
    relatedIds: ["carrying_capacity", "push_drag_lift", "grapple", "shove"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Taglia delle Creature",
        pageStart: 191,
        pageEnd: 191,
        section: "Taglia delle Creature",
      ),
    ],
    tags: {"phb", "esplorazione", "caratteristica"},
  ),
  "space": GlossaryEntry(
    id: "space",
    name: "Spazio di una Creatura",
    aliases: {"Spazio"},
    category: GlossaryCategory.combattimento,
    summary:
        "L’area controllata da una creatura in combattimento, non la misura esatta del suo corpo.",
    details:
        "Una creatura Media o Piccola controlla normalmente uno spazio di 1,5 metri per 1,5 metri. Creature più grandi controllano spazi maggiori; più creature non possono normalmente terminare volontariamente il movimento nello stesso spazio.",
    sections: [
      GlossarySectionDefinition(
        id: "medium_space",
        title: "Creature Medie e Piccole",
        type: GlossarySectionType.completeRule,
        content:
            "Una creatura Media o Piccola controlla normalmente uno spazio quadrato con lato di 1,5 metri.",
        numericValues: {"sideMeters": 1.5},
      ),
    ],
    relatedIds: ["size_category", "movement", "difficult_terrain"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Spazio",
        pageStart: 191,
        pageEnd: 192,
        section: "Spazio",
      ),
    ],
    tags: {"phb", "esplorazione", "combattimento"},
  ),
  "inspiration": GlossaryEntry(
    id: "inspiration",
    name: "Ispirazione",
    category: GlossaryCategory.risorsa,
    summary:
        "Una ricompensa assegnata dal Dungeon Master per interpretazione, ideali, legami, difetti o azioni coerenti con il personaggio.",
    details:
        "Un personaggio possiede oppure non possiede Ispirazione: non può accumularne più di una. Può spenderla prima di un tiro per ottenere vantaggio oppure cederla a un altro personaggio per premiarne una buona interpretazione o scelta.",
    sections: [
      GlossarySectionDefinition(
        id: "inspiration_limit",
        title: "Limite e utilizzo",
        type: GlossarySectionType.completeRule,
        content:
            "Un personaggio può possedere al massimo 1 Ispirazione. Può spenderla prima di un tiro per ottenere vantaggio.",
        numericValues: {"maximum": 1},
        relatedIds: ["advantage"],
      ),
    ],
    relatedIds: ["advantage"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Ispirazione",
        pageStart: 125,
        pageEnd: 125,
        section: "Ispirazione",
      ),
    ],
    tags: {"phb", "esplorazione", "risorsa"},
  ),
};
