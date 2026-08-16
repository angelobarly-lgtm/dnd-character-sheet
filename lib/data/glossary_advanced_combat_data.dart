import 'class_data.dart';

/// Tipi di danno e combattimento avanzato del PHB 2014.
const Map<String, GlossaryEntry> phbAdvancedCombatGlossaryEntries = {
  "acid_damage": GlossaryEntry(
    id: "acid_damage",
    name: "Danni da Acido",
    aliases: {"Acido"},
    category: GlossaryCategory.combattimento,
    summary:
        "Sostanze corrosive, spruzzi caustici ed enzimi dissolventi infliggono danni da acido.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "bludgeoning_damage": GlossaryEntry(
    id: "bludgeoning_damage",
    name: "Danni Contundenti",
    aliases: {"Contundente", "Danno Contundente"},
    category: GlossaryCategory.combattimento,
    summary:
        "Urti, martelli, cadute, costrizioni e altri impatti smussati infliggono danni contundenti.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "cold_damage": GlossaryEntry(
    id: "cold_damage",
    name: "Danni da Freddo",
    aliases: {"Freddo"},
    category: GlossaryCategory.combattimento,
    summary:
        "Gelo soprannaturale, temperature estreme e soffi glaciali infliggono danni da freddo.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "fire_damage": GlossaryEntry(
    id: "fire_damage",
    name: "Danni da Fuoco",
    aliases: {"Fuoco"},
    category: GlossaryCategory.combattimento,
    summary:
        "Fiamme, calore intenso e soffi infuocati infliggono danni da fuoco.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "force_damage": GlossaryEntry(
    id: "force_damage",
    name: "Danni da Forza",
    aliases: {"Danno da Forza"},
    category: GlossaryCategory.combattimento,
    summary:
        "Energia magica pura concentrata in una forma nociva infligge danni da forza.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "lightning_damage": GlossaryEntry(
    id: "lightning_damage",
    name: "Danni da Fulmine",
    aliases: {"Fulmine"},
    category: GlossaryCategory.combattimento,
    summary:
        "Scariche elettriche e saette magiche infliggono danni da fulmine.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "necrotic_damage": GlossaryEntry(
    id: "necrotic_damage",
    name: "Danni Necrotici",
    aliases: {"Necrotico", "Danno Necrotico"},
    category: GlossaryCategory.combattimento,
    summary:
        "Energia che avvizzisce materia e forza vitale infligge danni necrotici.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "piercing_damage": GlossaryEntry(
    id: "piercing_damage",
    name: "Danni Perforanti",
    aliases: {"Perforante", "Danno Perforante"},
    category: GlossaryCategory.combattimento,
    summary:
        "Punte, morsi, frecce e armi che penetrano infliggono danni perforanti.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "poison_damage": GlossaryEntry(
    id: "poison_damage",
    name: "Danni da Veleno",
    aliases: {"Veleno"},
    category: GlossaryCategory.combattimento,
    summary:
        "Veleni, tossine, gas nocivi e secrezioni velenose infliggono danni da veleno.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "psychic_damage": GlossaryEntry(
    id: "psychic_damage",
    name: "Danni Psichici",
    aliases: {"Psichico", "Danno Psichico"},
    category: GlossaryCategory.combattimento,
    summary:
        "Assalti mentali ed effetti che colpiscono direttamente la mente infliggono danni psichici.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "radiant_damage": GlossaryEntry(
    id: "radiant_damage",
    name: "Danni Radiosi",
    aliases: {"Radioso", "Danno Radioso"},
    category: GlossaryCategory.combattimento,
    summary:
        "Energia sacra o luminosa che brucia lo spirito infligge danni radiosi.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "slashing_damage": GlossaryEntry(
    id: "slashing_damage",
    name: "Danni Taglienti",
    aliases: {"Tagliente", "Danno Tagliente"},
    category: GlossaryCategory.combattimento,
    summary: "Lame, artigli e altri bordi affilati infliggono danni taglienti.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "thunder_damage": GlossaryEntry(
    id: "thunder_damage",
    name: "Danni da Tuono",
    aliases: {"Tuono"},
    category: GlossaryCategory.combattimento,
    summary:
        "Esplosioni sonore e onde d’urto concussive infliggono danni da tuono.",
    details:
        "Il tipo di danno non introduce da solo una regola aggiuntiva, ma interagisce con Resistenza ai Danni, Vulnerabilità ai Danni, Immunità ai Danni e capacità specifiche.",
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
        reference: "Tipi di Danno",
        pageStart: 196,
        pageEnd: 197,
        section: "Tipi di Danno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "combat": GlossaryEntry(
    id: "combat",
    name: "Combattimento",
    aliases: {"Scontro"},
    category: GlossaryCategory.combattimento,
    summary:
        "La sequenza strutturata con cui si risolvono scontri tra personaggi, creature e altri avversari.",
    details:
        "Il combattimento è organizzato in round e turni. All’inizio vengono determinate sorpresa, posizioni e iniziativa; poi ogni partecipante agisce nel proprio turno seguendo l’ordine stabilito.",
    relatedIds: [
      "combat_round",
      "turn",
      "initiative",
      "surprise",
      "movement",
      "action",
      "bonus_action",
      "reaction"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combattimento",
        pageStart: 189,
        pageEnd: 198,
        section: "Combattimento",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "combat_round": GlossaryEntry(
    id: "combat_round",
    name: "Round",
    aliases: {"Round di Combattimento"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un intervallo di circa sei secondi durante il quale ogni partecipante al combattimento svolge un turno.",
    details:
        "Quando tutti i partecipanti hanno completato il proprio turno, il round termina e ne inizia uno nuovo mantenendo normalmente lo stesso ordine di iniziativa.",
    sections: [
      GlossarySectionDefinition(
        id: "combat_round_duration",
        title: "Durata narrativa",
        type: GlossarySectionType.completeRule,
        content: "Un round rappresenta circa 6 secondi nel mondo di gioco.",
        numericValues: {"seconds": 6},
      ),
    ],
    relatedIds: ["combat", "turn", "initiative"],
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
    tags: {"phb", "combattimento"},
  ),
  "turn": GlossaryEntry(
    id: "turn",
    name: "Turno",
    aliases: {"Turni"},
    category: GlossaryCategory.combattimento,
    summary:
        "La parte del round durante la quale una creatura può muoversi e compiere le attività disponibili.",
    details:
        "Nel proprio turno una creatura può normalmente muoversi fino alla propria velocità e compiere un’azione. Può inoltre usare un’azione bonus se una regola la concede e interagire con un oggetto.",
    relatedIds: [
      "combat_round",
      "movement",
      "action",
      "bonus_action",
      "object_interaction"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Il Proprio Turno",
        pageStart: 189,
        pageEnd: 190,
        section: "Il Proprio Turno",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "breaking_up_movement": GlossaryEntry(
    id: "breaking_up_movement",
    name: "Suddividere il Movimento",
    aliases: {"Spezzare il Movimento"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura può distribuire il proprio movimento in momenti diversi del turno.",
    details:
        "Il movimento può avvenire prima e dopo l’azione e tra altre attività, purché la distanza complessiva non superi il movimento disponibile.",
    relatedIds: ["turn", "movement", "action", "movement_between_attacks"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Spezzare il Movimento",
        pageStart: 190,
        pageEnd: 190,
        section: "Spezzare il Movimento",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "movement_between_attacks": GlossaryEntry(
    id: "movement_between_attacks",
    name: "Muoversi tra gli Attacchi",
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura che effettua più attacchi può suddividere ulteriormente il proprio movimento tra un attacco e l’altro.",
    details:
        "Se un privilegio come Attacco Extra concede più attacchi con la stessa azione, la creatura può muoversi tra quegli attacchi usando il movimento ancora disponibile.",
    relatedIds: ["breaking_up_movement", "movement", "attack_action"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Muoversi tra gli Attacchi",
        pageStart: 190,
        pageEnd: 190,
        section: "Muoversi tra gli Attacchi",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "moving_through_creatures": GlossaryEntry(
    id: "moving_through_creatures",
    name: "Muoversi attraverso le Creature",
    aliases: {"Attraversare lo Spazio di una Creatura"},
    category: GlossaryCategory.combattimento,
    summary:
        "Le regole che determinano quando una creatura può attraversare lo spazio occupato da un’altra.",
    details:
        "È possibile attraversare lo spazio di una creatura non ostile. Lo spazio di una creatura ostile può essere attraversato soltanto se è almeno due categorie di taglia più grande o più piccola. Lo spazio di un’altra creatura è terreno difficile.",
    sections: [
      GlossarySectionDefinition(
        id: "hostile_size_difference",
        title: "Creature ostili",
        type: GlossarySectionType.completeRule,
        content:
            "Per attraversare lo spazio di una creatura ostile deve esserci una differenza di almeno 2 categorie di taglia.",
        numericValues: {"minimumSizeCategoryDifference": 2},
        relatedIds: ["size_category"],
      ),
    ],
    relatedIds: ["movement", "space", "size_category", "difficult_terrain"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Muoversi Attorno ad Altre Creature",
        pageStart: 191,
        pageEnd: 192,
        section: "Muoversi Attorno ad Altre Creature",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "squeezing": GlossaryEntry(
    id: "squeezing",
    name: "Stringersi in uno Spazio",
    aliases: {"Stringersi"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una creatura può attraversare uno spazio sufficiente per una creatura di una categoria di taglia inferiore.",
    details:
        "Mentre si stringe, ogni metro costa un metro aggiuntivo; la creatura subisce svantaggio ai tiri per colpire e ai tiri salvezza su Destrezza, mentre gli attacchi contro di lei dispongono di vantaggio.",
    sections: [
      GlossarySectionDefinition(
        id: "squeezing_cost",
        title: "Costo del movimento",
        type: GlossarySectionType.completeRule,
        content:
            "Ogni metro percorso mentre ci si stringe costa un metro aggiuntivo.",
        numericValues: {"movementCostMultiplier": 2},
        relatedIds: ["movement"],
      ),
    ],
    relatedIds: [
      "movement",
      "space",
      "size_category",
      "attack_roll",
      "saving_throw",
      "advantage",
      "disadvantage"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Stringersi in uno Spazio Più Piccolo",
        pageStart: 192,
        pageEnd: 192,
        section: "Stringersi in uno Spazio Più Piccolo",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "flying_movement": GlossaryEntry(
    id: "flying_movement",
    name: "Movimento in Volo",
    aliases: {"Volare", "Velocità di Volare"},
    category: GlossaryCategory.regola,
    summary: "Il movimento effettuato tramite una velocità di volare.",
    details:
        "Se una creatura volante viene buttata prona, vede la propria velocità ridotta a 0 o perde la capacità di muoversi, cade salvo che possa fluttuare o sia mantenuta in aria dalla magia.",
    relatedIds: ["movement", "prone", "falling"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Movimento in Volo",
        pageStart: 191,
        pageEnd: 191,
        section: "Movimento in Volo",
      ),
    ],
    tags: {"phb", "combattimento", "regola"},
  ),
  "ranged_attack": GlossaryEntry(
    id: "ranged_attack",
    name: "Attacco a Distanza",
    aliases: {"Attacchi a Distanza"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un attacco effettuato scagliando un proiettile o producendo un effetto contro un bersaglio distante.",
    details:
        "L’attacco può essere effettuato entro la gittata specificata. Oltre la gittata normale e fino a quella lunga il tiro per colpire subisce svantaggio; oltre la gittata lunga il bersaglio non può essere attaccato.",
    relatedIds: [
      "attack_roll",
      "ranged_weapon",
      "spell_attack_roll",
      "disadvantage",
      "ranged_attack_close_combat"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi a Distanza",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi a Distanza",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "ranged_attack_close_combat": GlossaryEntry(
    id: "ranged_attack_close_combat",
    name: "Attacchi a Distanza in Mischia",
    aliases: {"Attacco a Distanza in Mischia"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una penalità applicata quando si effettua un attacco a distanza mentre un nemico è troppo vicino.",
    details:
        "Il tiro per colpire subisce svantaggio se l’attaccante si trova entro 1,5 metri da una creatura ostile che può vederlo e che non è incapacitata.",
    sections: [
      GlossarySectionDefinition(
        id: "ranged_close_distance",
        title: "Distanza",
        type: GlossarySectionType.completeRule,
        content:
            "La penalità si applica quando la creatura ostile si trova entro 1,5 metri.",
        numericValues: {"maximumDistanceMeters": 1.5},
      ),
    ],
    relatedIds: [
      "ranged_attack",
      "attack_roll",
      "disadvantage",
      "incapacitated"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attacchi a Distanza in Mischia",
        pageStart: 195,
        pageEnd: 195,
        section: "Attacchi a Distanza in Mischia",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "unseen_attackers_targets": GlossaryEntry(
    id: "unseen_attackers_targets",
    name: "Attaccanti e Bersagli Non Visibili",
    aliases: {"Attaccante Non Visibile", "Bersaglio Non Visibile"},
    category: GlossaryCategory.combattimento,
    summary:
        "Le regole per effettuare attacchi quando l’attaccante o il bersaglio non può essere visto.",
    details:
        "Attaccare un bersaglio che non si vede impone svantaggio. Se il bersaglio non si trova nella posizione scelta, l’attacco manca. Quando una creatura attacca senza essere vista dispone di vantaggio e normalmente rivela la propria posizione.",
    relatedIds: [
      "attack_roll",
      "advantage",
      "disadvantage",
      "invisible",
      "hide_action"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Attaccanti e Bersagli Non Visibili",
        pageStart: 194,
        pageEnd: 195,
        section: "Attaccanti e Bersagli Non Visibili",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "mounted_combat": GlossaryEntry(
    id: "mounted_combat",
    name: "Combattimento in Sella",
    aliases: {"Combattere in Sella"},
    category: GlossaryCategory.combattimento,
    summary:
        "Le regole per combattere mentre una creatura cavalca una cavalcatura consenziente e adatta.",
    details:
        "La cavalcatura deve essere almeno una categoria di taglia più grande e possedere un’anatomia adatta. Può essere controllata oppure agire indipendentemente.",
    sections: [
      GlossarySectionDefinition(
        id: "mount_size_requirement",
        title: "Requisito di taglia",
        type: GlossarySectionType.completeRule,
        content:
            "La cavalcatura deve essere almeno 1 categoria di taglia più grande del cavaliere.",
        numericValues: {"minimumSizeCategoriesLarger": 1},
        relatedIds: ["size_category"],
      ),
    ],
    relatedIds: [
      "size_category",
      "mounting_dismounting",
      "controlled_mount",
      "independent_mount"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combattere in Sella",
        pageStart: 198,
        pageEnd: 198,
        section: "Combattere in Sella",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "mounting_dismounting": GlossaryEntry(
    id: "mounting_dismounting",
    name: "Montare e Smontare",
    aliases: {"Montare in Sella", "Smontare di Sella"},
    category: GlossaryCategory.regola,
    summary:
        "Il movimento necessario per salire su una cavalcatura o scendere da essa.",
    details:
        "Una volta durante il proprio movimento, una creatura può montare o smontare spendendo movimento pari a metà della propria velocità. Non può farlo se non possiede abbastanza movimento disponibile.",
    sections: [
      GlossarySectionDefinition(
        id: "mounting_movement_cost",
        title: "Costo",
        type: GlossarySectionType.completeRule,
        content:
            "Montare o smontare costa movimento pari a metà della velocità della creatura.",
        numericValues: {"speedFractionDivisor": 2},
        relatedIds: ["movement"],
      ),
      GlossarySectionDefinition(
        id: "forced_dismount",
        title: "Disarcionamento",
        type: GlossarySectionType.specialCases,
        content:
            "Se un effetto sposta la cavalcatura contro la sua volontà, il cavaliere effettua un tiro salvezza su Destrezza con CD 10 o cade prono entro 1,5 metri.",
        numericValues: {"difficultyClass": 10, "fallDistanceMeters": 1.5},
        relatedIds: ["saving_throw", "prone"],
      ),
    ],
    relatedIds: ["mounted_combat", "movement", "prone", "saving_throw"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Montare e Smontare",
        pageStart: 198,
        pageEnd: 198,
        section: "Montare e Smontare",
      ),
    ],
    tags: {"phb", "combattimento", "regola"},
  ),
  "controlled_mount": GlossaryEntry(
    id: "controlled_mount",
    name: "Cavalcatura Controllata",
    aliases: {"Controllare una Cavalcatura"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una cavalcatura addestrata che agisce secondo le indicazioni del cavaliere.",
    details:
        "L’iniziativa della cavalcatura diventa quella del cavaliere. Si muove nel turno del cavaliere e può compiere soltanto le azioni Scatto, Disimpegno e Schivata.",
    relatedIds: [
      "mounted_combat",
      "initiative",
      "dash_action",
      "disengage_action",
      "dodge_action"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Controllare una Cavalcatura",
        pageStart: 198,
        pageEnd: 198,
        section: "Controllare una Cavalcatura",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "independent_mount": GlossaryEntry(
    id: "independent_mount",
    name: "Cavalcatura Indipendente",
    aliases: {"Cavalcatura Intelligente"},
    category: GlossaryCategory.combattimento,
    summary:
        "Una cavalcatura che conserva la propria volontà e agisce autonomamente.",
    details:
        "Mantiene il proprio posto nell’ordine di iniziativa e agisce secondo le proprie decisioni. Il cavaliere non limita le azioni che può compiere.",
    relatedIds: ["mounted_combat", "initiative", "turn"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Cavalcature Indipendenti",
        pageStart: 198,
        pageEnd: 198,
        section: "Cavalcature Indipendenti",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "underwater_combat": GlossaryEntry(
    id: "underwater_combat",
    name: "Combattimento Sott’Acqua",
    aliases: {"Combattere Sott’Acqua"},
    category: GlossaryCategory.combattimento,
    summary:
        "Le modifiche agli attacchi effettuati mentre una creatura combatte immersa nell’acqua.",
    details:
        "Senza una velocità di nuotare, gli attacchi con armi da mischia subiscono svantaggio salvo che usino pugnale, giavellotto, spada corta, lancia o tridente. Gli attacchi a distanza oltre la gittata normale mancano automaticamente e quelli entro gittata normale subiscono svantaggio salvo specifiche eccezioni.",
    sections: [
      GlossarySectionDefinition(
        id: "underwater_fire_resistance",
        title: "Resistenza al fuoco",
        type: GlossarySectionType.specialCases,
        content:
            "Le creature e gli oggetti completamente immersi nell’acqua dispongono di resistenza ai danni da fuoco.",
        relatedIds: ["damage_resistance", "fire_damage"],
      ),
    ],
    relatedIds: [
      "swimming",
      "melee_weapon",
      "ranged_weapon",
      "attack_roll",
      "disadvantage",
      "fire_damage"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combattere Sott’Acqua",
        pageStart: 198,
        pageEnd: 198,
        section: "Combattere Sott’Acqua",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
  "knocking_out_creature": GlossaryEntry(
    id: "knocking_out_creature",
    name: "Mettere Fuori Combattimento",
    aliases: {"Danno Non Letale", "Attacco Non Letale"},
    category: GlossaryCategory.combattimento,
    summary:
        "La scelta di lasciare priva di sensi una creatura invece di ucciderla.",
    details:
        "Quando un attaccante riduce una creatura a 0 punti ferita con un attacco in mischia, può dichiarare che la mette fuori combattimento. La creatura diventa stabile e priva di sensi.",
    relatedIds: [
      "melee_weapon",
      "dropping_to_zero_hit_points",
      "stabilizing_creature",
      "unconscious"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Mettere Fuori Combattimento una Creatura",
        pageStart: 198,
        pageEnd: 198,
        section: "Mettere Fuori Combattimento una Creatura",
      ),
    ],
    tags: {"phb", "combattimento"},
  ),
};
