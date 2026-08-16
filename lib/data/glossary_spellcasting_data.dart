import 'class_data.dart';

/// Regole della magia del Manuale del Giocatore 2014.
const Map<String, GlossaryEntry> phbSpellcastingGlossaryEntries = {
  "spell": GlossaryEntry(
    id: "spell",
    name: "Incantesimo",
    aliases: {"Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "Un effetto magico discreto modellato e liberato da un incantatore secondo le regole della magia.",
    details:
        "Ogni incantesimo specifica livello, scuola, tempo di lancio, gittata, componenti, durata ed effetto. Classe e capacità determinano quali incantesimi una creatura può utilizzare.",
    relatedIds: [
      "spell_level",
      "casting_time",
      "spell_range",
      "spell_duration",
      "school_of_magic"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Cos’è un Incantesimo?",
        pageStart: 201,
        pageEnd: 201,
        section: "Cos’è un Incantesimo?",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "cantrip": GlossaryEntry(
    id: "cantrip",
    name: "Trucchetto",
    aliases: {"Trucchetti"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo di livello 0 che può essere lanciato a volontà senza consumare slot incantesimo.",
    details:
        "La pratica ripetuta ha fissato il trucchetto nella mente dell’incantatore. Alcuni trucchetti aumentano di potenza quando il personaggio raggiunge determinati livelli.",
    sections: [
      GlossarySectionDefinition(
        id: "cantrip_level",
        title: "Livello e slot",
        type: GlossarySectionType.completeRule,
        content:
            "Un trucchetto è un incantesimo di livello 0 e non consuma slot incantesimo.",
        numericValues: {"spellLevel": 0, "slotCost": 0},
        relatedIds: ["spell_level", "spell_slots"],
      ),
    ],
    relatedIds: ["spell", "spell_level", "spell_slots"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Trucchetti",
        pageStart: 201,
        pageEnd: 201,
        section: "Trucchetti",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spell_level": GlossaryEntry(
    id: "spell_level",
    name: "Livello dell’Incantesimo",
    aliases: {"Livello di Incantesimo", "Livelli degli Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "Una misura della potenza generale di un incantesimo, compresa tra il livello 0 dei trucchetti e il livello 9.",
    details:
        "Il livello dell’incantesimo non coincide direttamente con il livello del personaggio. Per lanciare un incantesimo di livello 1 o superiore serve normalmente uno slot di livello adeguato.",
    sections: [
      GlossarySectionDefinition(
        id: "spell_level_range",
        title: "Intervallo dei livelli",
        type: GlossarySectionType.completeRule,
        content:
            "I trucchetti sono di livello 0; gli altri incantesimi possono essere di livello compreso tra 1 e 9.",
        numericValues: {"minimumLevel": 0, "maximumLevel": 9},
      ),
    ],
    relatedIds: ["spell", "cantrip", "spell_slots", "casting_at_higher_level"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Livello dell’Incantesimo",
        pageStart: 201,
        pageEnd: 201,
        section: "Livello dell’Incantesimo",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spell_slots": GlossaryEntry(
    id: "spell_slots",
    name: "Slot Incantesimo",
    aliases: {"Slot Incantesimi", "Slot di Incantesimo"},
    category: GlossaryCategory.risorsa,
    summary:
        "Una risorsa consumata per lanciare la maggior parte degli incantesimi di livello 1 o superiore.",
    details:
        "Per lanciare un incantesimo occorre spendere uno slot di livello pari o superiore al livello dell’incantesimo. Lo slot viene consumato anche se l’incantesimo non produce l’esito sperato.",
    relatedIds: [
      "spell",
      "spell_level",
      "casting_at_higher_level",
      "long_rest"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Slot Incantesimo",
        pageStart: 201,
        pageEnd: 201,
        section: "Slot Incantesimo",
      ),
    ],
    tags: {"phb", "magia", "risorsa"},
  ),
  "known_spells": GlossaryEntry(
    id: "known_spells",
    name: "Incantesimi Conosciuti",
    aliases: {"Incantesimo Conosciuto"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Gli incantesimi che un personaggio conosce stabilmente secondo la progressione della propria classe o un’altra capacità.",
    details:
        "Una classe che usa incantesimi conosciuti indica quanti il personaggio può conoscere e quando può sostituirli. Conoscere un incantesimo non elimina la necessità di possedere uno slot adeguato.",
    relatedIds: ["prepared_spells", "spell_slots", "spellcasting_ability"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Incantesimi Conosciuti e Preparati",
        pageStart: 201,
        pageEnd: 201,
        section: "Incantesimi Conosciuti e Preparati",
      ),
    ],
    tags: {"phb", "magia", "caratteristica"},
  ),
  "prepared_spells": GlossaryEntry(
    id: "prepared_spells",
    name: "Incantesimi Preparati",
    aliases: {"Incantesimo Preparato", "Preparare gli Incantesimi"},
    category: GlossaryCategory.caratteristica,
    summary:
        "Gli incantesimi scelti da un personaggio dalla propria lista disponibile e utilizzabili fino alla preparazione successiva.",
    details:
        "Numero, procedura e momento della preparazione sono stabiliti dalla classe. Preparare un incantesimo non consuma slot; lo slot viene speso quando l’incantesimo viene lanciato.",
    relatedIds: ["known_spells", "spell_slots", "spellcasting_ability"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Incantesimi Conosciuti e Preparati",
        pageStart: 201,
        pageEnd: 201,
        section: "Incantesimi Conosciuti e Preparati",
      ),
    ],
    tags: {"phb", "magia", "caratteristica"},
  ),
  "casting_at_higher_level": GlossaryEntry(
    id: "casting_at_higher_level",
    name: "Lanciare a un Livello Superiore",
    aliases: {"Livello Superiore"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo può essere lanciato usando uno slot di livello superiore al suo livello base.",
    details:
        "L’incantesimo assume il livello dello slot utilizzato. Se la descrizione prevede benefici aggiuntivi ai livelli superiori, tali benefici vengono applicati in base allo slot consumato.",
    relatedIds: ["spell_level", "spell_slots"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Lanciare un Incantesimo a un Livello Superiore",
        pageStart: 201,
        pageEnd: 201,
        section: "Lanciare un Incantesimo a un Livello Superiore",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "ritual_casting": GlossaryEntry(
    id: "ritual_casting",
    name: "Celebrare Rituali",
    aliases: {"Rituale", "Rituali", "Lancio Rituale"},
    category: GlossaryCategory.regola,
    summary:
        "Alcuni incantesimi possono essere lanciati come rituali senza consumare slot incantesimo.",
    details:
        "Il lancio rituale richiede 10 minuti aggiuntivi rispetto al normale tempo di lancio. Una creatura può usare questa modalità soltanto se una capacità glielo consente e l’incantesimo possiede il descrittore rituale.",
    sections: [
      GlossarySectionDefinition(
        id: "ritual_extra_time",
        title: "Tempo aggiuntivo",
        type: GlossarySectionType.completeRule,
        content:
            "Lanciare un incantesimo come rituale aggiunge 10 minuti al suo normale tempo di lancio e non consuma slot.",
        numericValues: {"additionalMinutes": 10, "slotCost": 0},
        relatedIds: ["spell_slots", "casting_time"],
      ),
    ],
    relatedIds: ["spell_slots", "casting_time", "longer_casting_time"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Rituali",
        pageStart: 201,
        pageEnd: 202,
        section: "Rituali",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "casting_time": GlossaryEntry(
    id: "casting_time",
    name: "Tempo di Lancio",
    aliases: {"Tempi di Lancio"},
    category: GlossaryCategory.regola,
    summary:
        "Il tempo necessario per lanciare un incantesimo, espresso normalmente in azioni, azioni bonus, reazioni, minuti o ore.",
    details:
        "L’incantatore deve dedicare all’incantesimo il tipo di attività indicato. Tempi superiori a un’azione seguono le regole dei tempi di lancio più lunghi.",
    relatedIds: [
      "cast_spell_action",
      "bonus_action_spell",
      "reaction_spell",
      "longer_casting_time"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tempo di Lancio",
        pageStart: 202,
        pageEnd: 202,
        section: "Tempo di Lancio",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "bonus_action_spell": GlossaryEntry(
    id: "bonus_action_spell",
    name: "Incantesimo con Azione Bonus",
    aliases: {"Incantesimi con Azione Bonus"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo con tempo di lancio di un’azione bonus usa l’azione bonus del turno.",
    details:
        "Quando una creatura lancia un incantesimo come azione bonus, nello stesso turno non può lanciare altri incantesimi, tranne un trucchetto con tempo di lancio di un’azione.",
    sections: [
      GlossarySectionDefinition(
        id: "bonus_action_spell_limit",
        title: "Limite nello stesso turno",
        type: GlossarySectionType.interaction,
        content:
            "Dopo un incantesimo lanciato come azione bonus, l’unico altro incantesimo consentito nello stesso turno è un trucchetto con tempo di lancio di un’azione.",
        relatedIds: ["bonus_action", "cantrip", "action"],
      ),
    ],
    relatedIds: [
      "bonus_action",
      "cast_spell_action",
      "cantrip",
      "casting_time"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Azione Bonus",
        pageStart: 202,
        pageEnd: 202,
        section: "Azione Bonus",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "reaction_spell": GlossaryEntry(
    id: "reaction_spell",
    name: "Incantesimo con Reazione",
    aliases: {"Incantesimi con Reazione"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo con tempo di lancio di una reazione viene lanciato in risposta allo specifico evento indicato.",
    details:
        "La descrizione dell’incantesimo stabilisce l’evento scatenante. L’incantatore deve avere ancora disponibile la propria reazione.",
    relatedIds: ["reaction", "casting_time"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Reazioni",
        pageStart: 202,
        pageEnd: 202,
        section: "Reazioni",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "longer_casting_time": GlossaryEntry(
    id: "longer_casting_time",
    name: "Tempo di Lancio Più Lungo",
    aliases: {"Tempi di Lancio Più Lunghi"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo che richiede più di un’azione o reazione impegna l’incantatore durante ogni turno del lancio.",
    details:
        "L’incantatore deve usare la propria azione a ogni turno e mantenere la concentrazione. Se la concentrazione viene interrotta o l’azione non viene impiegata, l’incantesimo fallisce senza consumare lo slot.",
    relatedIds: ["action", "concentration", "casting_time", "spell_slots"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tempi di Lancio Più Lunghi",
        pageStart: 202,
        pageEnd: 202,
        section: "Tempi di Lancio Più Lunghi",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spell_range": GlossaryEntry(
    id: "spell_range",
    name: "Gittata dell’Incantesimo",
    aliases: {"Gittata degli Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "La distanza entro la quale deve trovarsi il bersaglio o il punto d’origine di un incantesimo al momento del lancio.",
    details:
        "Dopo il lancio, gli effetti non terminano automaticamente se il bersaglio esce dalla gittata, salvo diversa indicazione. Gli incantesimi con gittata contatto richiedono di toccare il bersaglio.",
    relatedIds: ["spell_target", "clear_path_to_target", "target_self"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Gittata",
        pageStart: 202,
        pageEnd: 202,
        section: "Gittata",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "verbal_component": GlossaryEntry(
    id: "verbal_component",
    name: "Componente Verbale",
    aliases: {"Componenti Verbali"},
    category: GlossaryCategory.regola,
    summary:
        "Parole mistiche pronunciate con tono e risonanza specifici durante il lancio di un incantesimo.",
    details:
        "Una creatura incapace di parlare o impossibilitata a produrre i suoni richiesti non può fornire una componente verbale.",
    relatedIds: ["spell", "somatic_component", "material_component"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Componenti: Verbale",
        pageStart: 203,
        pageEnd: 203,
        section: "Componenti: Verbale",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "somatic_component": GlossaryEntry(
    id: "somatic_component",
    name: "Componente Somatica",
    aliases: {"Componenti Somatiche"},
    category: GlossaryCategory.regola,
    summary:
        "Una gestualità precisa richiesta per lanciare determinati incantesimi.",
    details:
        "Se un incantesimo richiede una componente somatica, l’incantatore deve poter usare liberamente almeno una mano per eseguire i gesti.",
    sections: [
      GlossarySectionDefinition(
        id: "somatic_free_hand",
        title: "Mano libera",
        type: GlossarySectionType.completeRule,
        content:
            "L’incantatore deve disporre dell’uso libero di almeno una mano per eseguire la componente somatica.",
        numericValues: {"minimumFreeHands": 1},
      ),
    ],
    relatedIds: ["spell", "verbal_component", "material_component"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Componenti: Somatica",
        pageStart: 203,
        pageEnd: 203,
        section: "Componenti: Somatica",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "material_component": GlossaryEntry(
    id: "material_component",
    name: "Componente Materiale",
    aliases: {"Componenti Materiali"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Uno o più oggetti o sostanze necessari per lanciare determinati incantesimi.",
    details:
        "Una borsa per componenti o un focus da incantatore può sostituire i materiali privi di costo indicato e non consumati. Un materiale con un costo specifico deve essere posseduto; se viene consumato, deve essere fornito a ogni lancio.",
    relatedIds: [
      "component_pouch_rule",
      "spellcasting_focus_rule",
      "object_interaction"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Componenti: Materiale",
        pageStart: 203,
        pageEnd: 203,
        section: "Componenti: Materiale",
      ),
    ],
    tags: {"phb", "magia", "equipaggiamento"},
  ),
  "component_pouch_rule": GlossaryEntry(
    id: "component_pouch_rule",
    name: "Borsa per Componenti",
    aliases: {"Borsa delle Componenti"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Una piccola borsa impermeabile che contiene i materiali comuni necessari al lancio degli incantesimi.",
    details:
        "Può sostituire le componenti materiali che non possiedono un costo specifico e che non vengono consumate dall’incantesimo.",
    relatedIds: ["material_component", "spellcasting_focus_rule"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Componenti: Materiale",
        pageStart: 203,
        pageEnd: 203,
        section: "Componenti: Materiale",
      ),
    ],
    tags: {"phb", "magia", "equipaggiamento"},
  ),
  "spellcasting_focus_rule": GlossaryEntry(
    id: "spellcasting_focus_rule",
    name: "Focus da Incantatore",
    aliases: {"Focus Arcano", "Focus Druidico", "Simbolo Sacro"},
    category: GlossaryCategory.equipaggiamento,
    summary:
        "Un oggetto speciale che alcune classi possono usare per fornire le componenti materiali degli incantesimi.",
    details:
        "Il focus sostituisce soltanto componenti materiali prive di costo specifico e non consumate. La classe o capacità stabilisce quale tipo di focus può essere utilizzato.",
    relatedIds: ["material_component", "component_pouch_rule"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Componenti: Materiale",
        pageStart: 203,
        pageEnd: 203,
        section: "Componenti: Materiale",
      ),
    ],
    tags: {"phb", "magia", "equipaggiamento"},
  ),
  "spell_duration": GlossaryEntry(
    id: "spell_duration",
    name: "Durata dell’Incantesimo",
    aliases: {"Durata degli Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "Il periodo durante il quale persiste l’effetto di un incantesimo.",
    details:
        "Una durata può essere istantanea oppure espressa in round, minuti, ore o altre unità. Alcuni incantesimi richiedono concentrazione per continuare.",
    relatedIds: ["instantaneous_duration", "concentration"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Durata",
        pageStart: 203,
        pageEnd: 204,
        section: "Durata",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "instantaneous_duration": GlossaryEntry(
    id: "instantaneous_duration",
    name: "Durata Istantanea",
    category: GlossaryCategory.regola,
    summary:
        "Una durata che produce l’effetto dell’incantesimo una sola volta, senza mantenerlo magicamente nel tempo.",
    details:
        "Poiché la magia agisce soltanto per un istante, l’effetto prodotto non può essere dissolto come un effetto magico persistente.",
    relatedIds: ["spell_duration"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Istantanea",
        pageStart: 203,
        pageEnd: 203,
        section: "Istantanea",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "concentration": GlossaryEntry(
    id: "concentration",
    name: "Concentrazione",
    category: GlossaryCategory.risorsa,
    summary:
        "Lo sforzo mentale necessario per mantenere attivo un incantesimo o un altro effetto.",
    details:
        "Una creatura può mantenere la concentrazione su un solo effetto alla volta. Lanciare un altro incantesimo che richiede concentrazione termina quella precedente.",
    sections: [
      GlossarySectionDefinition(
        id: "concentration_damage",
        title: "Subire danni",
        type: GlossarySectionType.procedure,
        content:
            "Quando subisce danni, la creatura effettua un tiro salvezza su Costituzione. La CD è 10 oppure metà dei danni subiti, scegliendo il valore più alto.",
        numericValues: {"minimumDifficultyClass": 10, "damageDivisor": 2},
        relatedIds: ["saving_throw"],
      ),
      GlossarySectionDefinition(
        id: "concentration_end",
        title: "Interruzione",
        type: GlossarySectionType.specialCases,
        content:
            "La concentrazione termina volontariamente senza richiedere un’azione, quando si lancia un altro effetto che la richiede, quando la creatura diventa incapacitata o muore, oppure quando fallisce il tiro salvezza previsto.",
        relatedIds: ["incapacitated"],
      ),
    ],
    relatedIds: ["spell_duration", "saving_throw", "incapacitated"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Concentrazione",
        pageStart: 203,
        pageEnd: 204,
        section: "Concentrazione",
      ),
    ],
    tags: {"phb", "magia", "risorsa"},
  ),
  "spell_target": GlossaryEntry(
    id: "spell_target",
    name: "Bersaglio dell’Incantesimo",
    aliases: {"Bersagli degli Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "La creatura, l’oggetto o il punto nello spazio scelto per ricevere o originare l’effetto di un incantesimo.",
    details:
        "La descrizione stabilisce quali bersagli sono validi e quanti possono essere scelti. Normalmente l’incantatore deve disporre di un percorso libero verso il bersaglio.",
    relatedIds: [
      "spell_range",
      "clear_path_to_target",
      "target_self",
      "area_of_effect"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Bersagli",
        pageStart: 204,
        pageEnd: 204,
        section: "Bersagli",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "clear_path_to_target": GlossaryEntry(
    id: "clear_path_to_target",
    name: "Percorso Libero fino al Bersaglio",
    aliases: {"Percorso Libero"},
    category: GlossaryCategory.regola,
    summary:
        "Per prendere qualcosa come bersaglio di un incantesimo deve esistere un percorso non bloccato fino a esso.",
    details:
        "Se il punto d’origine di un’area viene collocato oltre un ostacolo che fornisce copertura totale, il punto d’origine si forma sul lato più vicino dell’ostacolo.",
    relatedIds: ["spell_target", "cover", "area_of_effect"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Un Percorso Libero fino al Bersaglio",
        pageStart: 204,
        pageEnd: 204,
        section: "Un Percorso Libero fino al Bersaglio",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "target_self": GlossaryEntry(
    id: "target_self",
    name: "Bersaglio: Incantatore",
    aliases: {"Gittata Incantatore"},
    category: GlossaryCategory.regola,
    summary:
        "Un incantesimo con gittata incantatore ha origine dall’incantatore o agisce direttamente su di lui.",
    details:
        "Se crea un’area che si muove con l’incantatore, quest’ultimo ne è il punto d’origine ma non è necessariamente uno dei bersagli dell’effetto.",
    relatedIds: ["spell_target", "spell_range", "area_of_effect"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Bersagliare Se Stessi",
        pageStart: 204,
        pageEnd: 204,
        section: "Bersagliare Se Stessi",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "area_of_effect": GlossaryEntry(
    id: "area_of_effect",
    name: "Area di Effetto",
    aliases: {"Aree di Effetto"},
    category: GlossaryCategory.regola,
    summary:
        "Una forma geometrica usata da un incantesimo o effetto per determinare quali creature e oggetti vengono coinvolti.",
    details:
        "Le forme più comuni sono cono, cubo, cilindro, linea e sfera. Ogni area possiede un punto d’origine e segue le regole indicate per estensione e ostacoli.",
    relatedIds: ["spell_target", "clear_path_to_target", "cover"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Aree di Effetto",
        pageStart: 204,
        pageEnd: 205,
        section: "Aree di Effetto",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spell_saving_throw": GlossaryEntry(
    id: "spell_saving_throw",
    name: "Tiro Salvezza contro un Incantesimo",
    aliases: {"Tiri Salvezza contro gli Incantesimi"},
    category: GlossaryCategory.regola,
    summary:
        "Un tiro salvezza richiesto da un incantesimo per evitarne o ridurne gli effetti.",
    details:
        "La caratteristica usata e gli effetti di un successo o fallimento sono indicati dall’incantesimo. La CD è determinata dalla caratteristica da incantatore, dal Bonus di Competenza e dal valore base 8.",
    sections: [
      GlossarySectionDefinition(
        id: "spell_save_dc_formula",
        title: "CD degli incantesimi",
        type: GlossarySectionType.completeRule,
        content:
            "CD = 8 + Bonus di Competenza + modificatore della caratteristica da incantatore.",
        numericValues: {"baseDifficultyClass": 8},
        relatedIds: ["proficiency_bonus", "spellcasting_ability"],
      ),
    ],
    relatedIds: ["saving_throw", "spellcasting_ability", "proficiency_bonus"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiri Salvezza",
        pageStart: 205,
        pageEnd: 205,
        section: "Tiri Salvezza",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spell_attack_roll": GlossaryEntry(
    id: "spell_attack_roll",
    name: "Tiro per Colpire con Incantesimo",
    aliases: {"Attacco con Incantesimo", "Attacchi con Incantesimo"},
    category: GlossaryCategory.combattimento,
    summary:
        "Un tiro per colpire richiesto da alcuni incantesimi per determinare se l’effetto raggiunge il bersaglio.",
    details:
        "Il bonus al tiro è pari al Bonus di Competenza più il modificatore della caratteristica da incantatore. Si applicano le normali regole dei tiri per colpire.",
    relatedIds: ["attack_roll", "spellcasting_ability", "proficiency_bonus"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiri per Colpire",
        pageStart: 205,
        pageEnd: 205,
        section: "Tiri per Colpire",
      ),
    ],
    tags: {"phb", "magia", "combattimento"},
  ),
  "combining_magical_effects": GlossaryEntry(
    id: "combining_magical_effects",
    name: "Combinare Effetti Magici",
    aliases: {"Combinazione degli Effetti Magici"},
    category: GlossaryCategory.regola,
    summary:
        "Gli effetti di incantesimi diversi si sommano, mentre gli effetti dello stesso incantesimo lanciato più volte normalmente non si sommano.",
    details:
        "Quando più lanci dello stesso incantesimo si sovrappongono, si applica soltanto l’effetto più potente oppure quello più recente se hanno pari potenza. Le durate continuano comunque a essere conteggiate.",
    relatedIds: ["spell", "spell_duration"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Combinare Effetti Magici",
        pageStart: 205,
        pageEnd: 205,
        section: "Combinare Effetti Magici",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "school_of_magic": GlossaryEntry(
    id: "school_of_magic",
    name: "Scuola di Magia",
    aliases: {"Scuole di Magia"},
    category: GlossaryCategory.regola,
    summary:
        "Una delle otto categorie accademiche usate per descrivere la natura di un incantesimo.",
    details:
        "Le scuole sono Abiurazione, Ammaliamento, Divinazione, Evocazione, Illusione, Invocazione, Necromanzia e Trasmutazione. La scuola non impone regole generali aggiuntive, ma può interagire con privilegi e capacità.",
    sections: [
      GlossarySectionDefinition(
        id: "schools_list",
        title: "Le otto scuole",
        type: GlossarySectionType.completeRule,
        content:
            "Abiurazione, Ammaliamento, Divinazione, Evocazione, Illusione, Invocazione, Necromanzia e Trasmutazione.",
        numericValues: {"schoolCount": 8},
      ),
    ],
    relatedIds: ["spell"],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Scuole di Magia",
        pageStart: 203,
        pageEnd: 203,
        section: "Scuole di Magia",
      ),
    ],
    tags: {"phb", "magia", "regola"},
  ),
  "spellcasting_ability": GlossaryEntry(
    id: "spellcasting_ability",
    name: "Caratteristica da Incantatore",
    aliases: {"Caratteristica da Incantesimi"},
    category: GlossaryCategory.caratteristica,
    summary:
        "La caratteristica indicata dalla classe o capacità e usata per determinare l’efficacia degli incantesimi.",
    details:
        "Il modificatore della caratteristica da incantatore contribuisce alla CD dei tiri salvezza contro gli incantesimi e al bonus dei tiri per colpire con incantesimo.",
    sections: [
      GlossarySectionDefinition(
        id: "spellcasting_formulas",
        title: "Formule",
        type: GlossarySectionType.completeRule,
        content:
            "CD del tiro salvezza = 8 + Bonus di Competenza + modificatore della caratteristica da incantatore. Modificatore di attacco con incantesimo = Bonus di Competenza + modificatore della caratteristica da incantatore.",
        numericValues: {"spellSaveBase": 8},
        relatedIds: [
          "spell_saving_throw",
          "spell_attack_roll",
          "proficiency_bonus"
        ],
      ),
    ],
    relatedIds: [
      "spell_saving_throw",
      "spell_attack_roll",
      "proficiency_bonus"
    ],
    sources: [
      GlossarySourceDefinition(
        book: "Manuale del Giocatore",
        edition: "2014",
        reference: "Tiri Salvezza e Tiri per Colpire",
        pageStart: 205,
        pageEnd: 205,
        section: "Tiri Salvezza e Tiri per Colpire",
      ),
    ],
    tags: {"phb", "magia", "caratteristica"},
  ),
};
