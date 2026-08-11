import 'class_data.dart';

/// Glossario condiviso da tutti i sistemi dell'app.
///
/// Le voci vengono aggiunte insieme ai contenuti che le utilizzano:
/// razze, classi, background, talenti, magia ed equipaggiamento.
const Map<String, GlossaryEntry> glossaryEntries = {
  'poison_resilience': GlossaryEntry(
    id: 'poison_resilience',
    name: 'Resilienza al Veleno',
    category: GlossaryCategory.caratteristica,
    summary: 'Insieme di protezioni contro il veleno concesse da '
        'uno specifico tratto razziale.',
  ),
  'racial_weapon_training': GlossaryEntry(
    id: 'racial_weapon_training',
    name: 'Addestramento Razziale nelle Armi',
    category: GlossaryCategory.caratteristica,
    summary: 'Competenze nelle armi concesse dalla razza o sottorazza '
        'indipendentemente dalla classe.',
  ),
  'racial_hit_points': GlossaryEntry(
    id: 'racial_hit_points',
    name: 'Punti Ferita Razziali',
    category: GlossaryCategory.caratteristica,
    summary: 'Modifica permanente ai punti ferita massimi derivata '
        'da una caratteristica razziale.',
  ),
  'racial_cantrip': GlossaryEntry(
    id: 'racial_cantrip',
    name: 'Trucchetto Razziale',
    category: GlossaryCategory.caratteristica,
    summary: 'Trucchetto conosciuto grazie a una razza o sottorazza '
        'anziché alla classe del personaggio.',
  ),
  'conditional_racial_rule': GlossaryEntry(
    id: 'conditional_racial_rule',
    name: 'Regola Razziale Condizionale',
    category: GlossaryCategory.regola,
    summary: 'Tratto razziale applicabile soltanto quando ricorrono '
        'le condizioni specificate dalla capacità.',
  ),
  'breath_weapon': GlossaryEntry(
    id: 'breath_weapon',
    name: 'Arma a Soffio',
    category: GlossaryCategory.caratteristica,
    summary: 'Capacità dragonide la cui area e tipo di danno dipendono '
        'dalla Discendenza Draconica scelta.',
  ),
  'draconic_ancestry': GlossaryEntry(
    id: 'draconic_ancestry',
    name: 'Discendenza Draconica',
    category: GlossaryCategory.caratteristica,
    summary: 'Scelta razziale del Dragonide che determina il tipo del suo '
        'soffio e la resistenza associata.',
  ),
  'fey_ancestry': GlossaryEntry(
    id: 'fey_ancestry',
    name: 'Retaggio Fatato',
    category: GlossaryCategory.caratteristica,
    summary: 'Tratto di retaggio fatato che interagisce con charme e sonno '
        'secondo le regole della razza che lo concede.',
  ),
  'trance': GlossaryEntry(
    id: 'trance',
    name: 'Trance',
    category: GlossaryCategory.caratteristica,
    summary: 'Tratto elfico che sostituisce il normale sonno con la speciale '
        'forma di riposo descritta dalla capacità.',
  ),
  'relentless_endurance': GlossaryEntry(
    id: 'relentless_endurance',
    name: 'Tenacia Implacabile',
    category: GlossaryCategory.caratteristica,
    summary: 'Tratto del Mezzorco che può impedirgli di cadere immediatamente '
        'a 0 punti ferita nelle circostanze previste dalla capacità.',
  ),
  'savage_attacks': GlossaryEntry(
    id: 'savage_attacks',
    name: 'Attacchi Selvaggi',
    category: GlossaryCategory.combattimento,
    summary: 'Tratto del Mezzorco che modifica il danno di un colpo critico '
        'effettuato con un attacco con arma da mischia.',
  ),
  'hellish_resistance': GlossaryEntry(
    id: 'hellish_resistance',
    name: 'Resistenza Infernale',
    category: GlossaryCategory.caratteristica,
    summary: 'Tratto del Tiefling che concede resistenza ai danni da fuoco.',
  ),
  'infernal_legacy': GlossaryEntry(
    id: 'infernal_legacy',
    name: 'Retaggio Infernale',
    category: GlossaryCategory.caratteristica,
    summary: 'Magia razziale del Tiefling che concede capacità magiche '
        'aggiuntive con l’aumentare del livello.',
  ),
  'sunlight_sensitivity': GlossaryEntry(
    id: 'sunlight_sensitivity',
    name: 'Sensibilità alla Luce del Sole',
    category: GlossaryCategory.caratteristica,
    summary: 'Tratto che applica gli effetti descritti dalla capacità quando '
        'il personaggio o il suo bersaglio si trova alla luce solare diretta.',
  ),
  'racial_progression': GlossaryEntry(
    id: 'racial_progression',
    name: 'Progressione Razziale',
    category: GlossaryCategory.regola,
    summary:
        'Capacità razziali che diventano disponibili quando il personaggio '
        'raggiunge il livello totale richiesto.',
  ),
  'darkvision': GlossaryEntry(
    id: 'darkvision',
    name: 'Scurovisione',
    category: GlossaryCategory.caratteristica,
    summary:
        'Capacità di vedere in condizioni di oscurità entro la portata prevista dalla regola che la concede.',
  ),
  'damage_resistance': GlossaryEntry(
    id: 'damage_resistance',
    name: 'Resistenza ai Danni',
    category: GlossaryCategory.combattimento,
    summary:
        'Regola che riduce gli effetti dei danni del tipo indicato dalla capacità che concede la resistenza.',
  ),
  'saving_throw_advantage': GlossaryEntry(
    id: 'saving_throw_advantage',
    name: 'Vantaggio ai Tiri Salvezza',
    category: GlossaryCategory.regola,
    summary:
        'Una capacità può concedere vantaggio a specifici tiri salvezza nelle circostanze indicate dalla regola.',
  ),
  'condition_immunity': GlossaryEntry(
    id: 'condition_immunity',
    name: 'Immunità a una Condizione',
    category: GlossaryCategory.condizione,
    summary:
        'Il personaggio non può subire la condizione indicata dalla regola che concede l’immunità.',
  ),
  'racial_spellcasting': GlossaryEntry(
    id: 'racial_spellcasting',
    name: 'Magia Razziale',
    category: GlossaryCategory.caratteristica,
    summary:
        'Incantesimi o trucchetti concessi da un tratto razziale secondo i requisiti e i livelli indicati dal tratto.',
  ),
  'racial_proficiency': GlossaryEntry(
    id: 'racial_proficiency',
    name: 'Competenza Razziale',
    category: GlossaryCategory.caratteristica,
    summary:
        'Competenza concessa da una razza o sottorazza in aggiunta alle altre fonti del personaggio.',
  ),
  'racial_language': GlossaryEntry(
    id: 'racial_language',
    name: 'Lingua Razziale',
    category: GlossaryCategory.caratteristica,
    summary:
        'Lingua conosciuta dal personaggio grazie alla sua razza o a una scelta prevista dai suoi tratti razziali.',
  ),
  'racial_speed': GlossaryEntry(
    id: 'racial_speed',
    name: 'Velocità Razziale',
    category: GlossaryCategory.caratteristica,
    summary:
        'Velocità base o modifica alla velocità determinata dalla razza o sottorazza del personaggio.',
  ),
};

GlossaryEntry? glossaryEntryFor(String id) => glossaryEntries[id];
