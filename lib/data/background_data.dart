import 'character_data.dart';
import 'class_data.dart';
import 'equipment_data.dart';
import 'focus_data.dart';
import 'mount_data.dart';
import 'tool_data.dart';

/// ID canonici dei background del Manuale del Giocatore 2014.
///
/// Le varianti ufficiali possiedono un ID autonomo perché devono poter
/// essere selezionate direttamente dal creator, mantenendo al contempo
/// il collegamento con il background principale.
abstract final class BackgroundIds {
  static const acolyte = 'acolyte';
  static const guildArtisan = 'guild_artisan';
  static const guildMerchant = 'guild_merchant';
  static const charlatan = 'charlatan';
  static const criminal = 'criminal';
  static const spy = 'spy';
  static const hermit = 'hermit';
  static const folkHero = 'folk_hero';
  static const outlander = 'outlander';
  static const entertainer = 'entertainer';
  static const gladiator = 'gladiator';
  static const sailor = 'sailor';
  static const pirate = 'pirate';
  static const urchin = 'urchin';
  static const noble = 'noble';
  static const knight = 'knight';
  static const sage = 'sage';
  static const soldier = 'soldier';
}

const _guildActivities = BackgroundTableDefinition(
  id: 'guild_activities',
  name: 'Attività della Gilda',
  dieSides: 20,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Alchimisti e speziali.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Birrai, distillatori e vinificatori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Calligrafi, scribi e scrivani.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Carpentieri navali e velai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Carrozzai e carradori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Cartografi, geografi e disegnatori di mappe.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Ciabattini e calzolai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Costruttori e scalpellini.',
    ),
    BackgroundTableEntry(
      minimumRoll: 9,
      maximumRoll: 9,
      label: 'Cuochi e panettieri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 10,
      maximumRoll: 10,
      label: 'Fabbri e forgiatori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 11,
      maximumRoll: 11,
      label: 'Fabbricanti di armature, serrature e lavori cesellati.',
    ),
    BackgroundTableEntry(
      minimumRoll: 12,
      maximumRoll: 12,
      label: 'Falegnami, soffittai e imbianchini.',
    ),
    BackgroundTableEntry(
      minimumRoll: 13,
      maximumRoll: 13,
      label: 'Gioiellieri e intagliatori di gemme.',
    ),
    BackgroundTableEntry(
      minimumRoll: 14,
      maximumRoll: 14,
      label: 'Intagliatori, bottai e costruttori di archi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 15,
      maximumRoll: 15,
      label: 'Pellai, scuoiatori e conciatori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 16,
      maximumRoll: 16,
      label: 'Pittori e disegnatori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 17,
      maximumRoll: 17,
      label: 'Soffiatori di vetro e vetrai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 18,
      maximumRoll: 18,
      label: 'Stagnini, modellatori e peltrai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 19,
      maximumRoll: 19,
      label: 'Tessitori e tintori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 20,
      maximumRoll: 20,
      label: 'Vasai e piastrellai.',
    ),
  ],
);

const _guildPersonalityTraits = BackgroundTableDefinition(
  id: 'guild_artisan_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Crede che, se una cosa va fatta, debba essere fatta bene e cerca sempre di lavorare al meglio.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'È uno snob e guarda dall’alto in basso chi non sa apprezzare l’arte.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Vuole sempre sapere come funzionano le cose e quali motivazioni spingono gli altri ad agire.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Ha un proverbio da citare in ogni occasione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'È molto duro con chi non dimostra la sua stessa dedizione al lavoro costante e onesto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ama parlare a lungo della propria professione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Adora il denaro e contratta accanitamente per ottenere le condizioni migliori.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'È famoso per la qualità del proprio lavoro e si stupisce quando qualcuno non ha mai sentito parlare di lui.',
    ),
  ],
);

const _guildIdeals = BackgroundTableDefinition(
  id: 'guild_artisan_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Comunità. Ogni cittadino deve rafforzare i legami della comunità e la sicurezza della civiltà.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Generosità. I talenti vengono donati affinché siano usati per il bene del mondo.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Libertà. Tutti dovrebbero essere liberi di guadagnarsi da vivere come preferiscono.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Avidità. Agisce esclusivamente per denaro.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Persone. Ha doveri verso le persone care, non verso ideali astratti.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Aspirazioni. Lavora duramente per diventare il migliore nel proprio mestiere.',
      alignment: 'Qualsiasi',
    ),
  ],
);

const _guildBonds = BackgroundTableDefinition(
  id: 'guild_artisan_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Il laboratorio in cui ha imparato il mestiere è il luogo più importante del mondo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Ha creato un’opera straordinaria per qualcuno che si è dimostrato indegno e cerca una persona che la meriti.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Si sente in debito con la gilda, che ha fatto di lui ciò che è oggi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Persegue la ricchezza per conquistare l’amore di qualcuno.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Ha giurato di tornare alla gilda e dimostrare di essere migliore di tutti gli altri membri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Vuole vendicarsi delle forze malvagie che hanno distrutto il suo luogo di lavoro e la sua fonte di reddito.',
    ),
  ],
);

const _guildFlaws = BackgroundTableDefinition(
  id: 'guild_artisan_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Farebbe qualsiasi cosa pur di ottenere qualcosa di raro o di inestimabile valore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Si convince facilmente che qualcuno stia cercando di imbrogliarlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Nessuno deve sapere che una volta ha sottratto del denaro dai forzieri della gilda.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'È incontentabile: ciò che possiede non gli basta mai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Ucciderebbe pur di ottenere un titolo nobiliare.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'È estremamente geloso di chi produce opere migliori delle sue e vede rivali ovunque.',
    ),
  ],
);

const _guildCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _guildPersonalityTraits,
  ideals: _guildIdeals,
  bonds: _guildBonds,
  flaws: _guildFlaws,
);

const _guildMembershipFeature = BackgroundFeatureDefinition(
  id: 'guild_membership',
  content: RuleContent(
    id: 'guild_membership',
    name: 'Appartenenza alla Gilda',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'La gilda offre sostegno, contatti professionali e una certa influenza politica.',
      details:
          'I colleghi della gilda offrono vitto e alloggio al membro e provvedono al suo funerale. Le sedi della gilda permettono di incontrare datori di lavoro, alleati e gregari. Una gilda può sostenere il personaggio davanti a un’accusa giustificabile e facilitare contatti politici, purché egli rimanga un membro stimato e versi una quota di 5 monete d’oro al mese.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 128-129',
    ),
    ownerId: BackgroundIds.guildArtisan,
  ),
  ruleTags: {
    'guild_provides_food_and_lodging',
    'guild_pays_members_funeral',
    'guild_halls_provide_professional_contacts',
    'guild_may_offer_legal_support',
    'guild_may_enable_political_access',
    'monthly_guild_dues_5_gp',
    'missed_dues_must_be_repaid',
  },
);

const _charlatanScams = BackgroundTableDefinition(
  id: 'charlatan_favorite_scams',
  name: 'Truffe Preferite',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Barare ai giochi d’azzardo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Limare monete o forgiare documenti.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Insinuarsi nelle vite altrui e sfruttarne le debolezze per impossessarsi delle loro fortune.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Cambiare identità con la stessa facilità con cui cambia abito.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Compiere truffe di destrezza manuale agli angoli delle strade.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Convincere un compratore che una cianfrusaglia valga tutti i suoi risparmi.',
    ),
  ],
);

const _charlatanPersonalityTraits = BackgroundTableDefinition(
  id: 'charlatan_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Si innamora continuamente ed è sempre alla ricerca di una nuova fiamma.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Ha una battuta pronta per ogni occasione, specialmente quando l’umorismo è fuori luogo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Le lusinghe sono il suo metodo preferito per ottenere ciò che desidera.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'È un giocatore d’azzardo nato e non resiste a un rischio che prometta un guadagno.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Mente quasi sempre, anche quando non ne avrebbe motivo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Il sarcasmo e l’insulto sono le sue armi preferite.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Porta con sé diversi simboli sacri e invoca qualsiasi divinità possa essergli utile.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Si intasca ogni oggetto che sembri avere valore.',
    ),
  ],
);

const _charlatanIdeals = BackgroundTableDefinition(
  id: 'charlatan_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Indipendenza. È uno spirito libero e nessuno può dirgli cosa fare.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Giustizia. Non prende di mira chi non può permettersi di perdere nemmeno pochi spiccioli.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Carità. Distribuisce il denaro ottenuto a coloro che ne hanno realmente bisogno.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Creatività. Non usa mai due volte la stessa menzogna.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Amicizia. I beni materiali vanno e vengono, mentre i legami d’amicizia durano.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ambizione. È determinato a diventare qualcuno.',
      alignment: 'Qualsiasi',
    ),
  ],
);

const _charlatanBonds = BackgroundTableDefinition(
  id: 'charlatan_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Ha derubato la persona sbagliata e ora deve evitarla in ogni modo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Deve tutto al proprio mentore, un essere orribile che probabilmente marcisce in prigione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Da qualche parte ha un figlio che non lo conosce e cerca di rendergli il mondo migliore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Proviene da una famiglia nobile e vuole riprendersi le terre e il titolo che le sono stati sottratti.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Un individuo potente ha ucciso qualcuno che amava e ha giurato vendetta.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Ha rovinato qualcuno che non lo meritava e tenta di espiare, senza riuscire a perdonarsi.',
    ),
  ],
);

const _charlatanFlaws = BackgroundTableDefinition(
  id: 'charlatan_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Non riesce a resistere a un bel viso.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'È perennemente indebitato e sperpera rapidamente i proventi illeciti in lussi decadenti.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'È convinto che nessuno riuscirà mai a imbrogliarlo come lui imbroglia gli altri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'La sua avidità lo mette in pericolo: se c’è denaro in gioco tenta di ottenerlo a qualsiasi costo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Non può evitare di tentare di truffare le persone più potenti di lui.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Quando la situazione precipita fugge e pensa soltanto a salvare la propria pelle.',
    ),
  ],
);

const _charlatanCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _charlatanPersonalityTraits,
  ideals: _charlatanIdeals,
  bonds: _charlatanBonds,
  flaws: _charlatanFlaws,
);

const _falseIdentityFeature = BackgroundFeatureDefinition(
  id: 'false_identity',
  content: RuleContent(
    id: 'false_identity',
    name: 'Falsa Identità',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Il ciarlatano possiede una seconda identità completa e credibile.',
      details:
          'La falsa identità comprende documenti, conoscenze consolidate e camuffamenti adeguati. Il ciarlatano può inoltre falsificare documenti ufficiali e lettere personali, purché abbia osservato un esempio del documento o della scrittura da imitare.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagina 129',
    ),
    ownerId: BackgroundIds.charlatan,
  ),
  ruleTags: {
    'has_established_false_identity',
    'has_supporting_false_documents',
    'has_identity_appropriate_disguises',
    'can_forge_seen_document_types',
    'can_imitate_seen_handwriting',
  },
);

const _criminalSpecializations = BackgroundTableDefinition(
  id: 'criminal_specializations',
  name: 'Specializzazioni Criminali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Assassino.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Borseggiatore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Brigante.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Contrabbandiere.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Picchiatore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ricattatore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Ricettatore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Scassinatore.',
    ),
  ],
);
const _criminalPersonalityTraits = BackgroundTableDefinition(
  id: 'criminal_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Ha sempre un piano di riserva quando la situazione si mette male.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Mantiene la calma in ogni situazione e non lascia che le emozioni prevalgano sulla ragione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Quando arriva in un luogo nuovo individua subito dove potrebbero essere custoditi o nascosti gli oggetti di valore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Preferisce conquistare un nuovo amico anziché crearsi un nuovo nemico.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Impiega molto tempo a fidarsi degli altri e sospetta soprattutto di chi sembra troppo onesto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Affronta i rischi senza preoccuparsi delle probabilità.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Il modo più efficace per spingerlo ad agire è dirgli che non può farlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Reagisce con collera anche alla minima provocazione.',
    ),
  ],
);
const _criminalIdeals = BackgroundTableDefinition(
  id: 'criminal_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Onore. Non deruba gli altri criminali.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Libertà. Ogni catena deve essere spezzata, compresa quella imposta agli altri.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Carità. Sottrae ricchezze a chi ne possiede troppe per aiutare chi è nel bisogno.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Avidità. È disposto a tutto pur di accumulare ricchezza.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Persone. È leale verso i suoi amici, non verso ideali astratti.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Redenzione. Crede che in ogni individuo esista ancora una scintilla di bontà.',
      alignment: 'Buono',
    ),
  ],
);
const _criminalBonds = BackgroundTableDefinition(
  id: 'criminal_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Vuole ripagare un vecchio debito contratto con un benefattore generoso.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Usa i guadagni delle sue attività illecite per mantenere la propria famiglia.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Qualcuno gli ha sottratto qualcosa di importante ed è determinato a recuperarlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Aspira a diventare il più grande ladro di tutti i tempi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Ha commesso un crimine terribile e spera di riuscire a redimersi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Una persona amata è morta per colpa sua e farà di tutto affinché non accada di nuovo.',
    ),
  ],
);
const _criminalFlaws = BackgroundTableDefinition(
  id: 'criminal_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Quando vede qualcosa di prezioso riesce soltanto a pensare a come impadronirsene.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Quando deve scegliere tra gli amici e il denaro, di solito sceglie il denaro.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Dimentica i piani stabiliti oppure decide deliberatamente di ignorarli.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Quando mente manifesta sempre un segnale che può tradirlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Quando la situazione si mette male fugge senza esitazione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Un innocente è stato incarcerato per un suo crimine e lui convive tranquillamente con questa colpa.',
    ),
  ],
);
const _criminalCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _criminalPersonalityTraits,
  ideals: _criminalIdeals,
  bonds: _criminalBonds,
  flaws: _criminalFlaws,
);

const _criminalContactFeature = BackgroundFeatureDefinition(
  id: 'criminal_contact',
  content: RuleContent(
    id: 'criminal_contact',
    name: 'Contatto Criminale',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Mantiene un contatto affidabile all’interno di una rete criminale.',
      details:
          'Il personaggio conosce un intermediario fidato collegato a una rete di criminali. Sa come inviare e ricevere messaggi anche su grandi distanze, servendosi di messaggeri locali, carovanieri corrotti e marinai poco raccomandabili.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 130-131',
    ),
    ownerId: BackgroundIds.criminal,
  ),
  ruleTags: {
    'has_reliable_criminal_contact',
    'can_exchange_messages_with_criminal_network',
    'can_communicate_over_long_distances',
    'knows_local_criminal_messengers',
    'knows_corrupt_caravan_masters',
    'knows_disreputable_sailors',
  },
);

const _hermitSolitaryLives = BackgroundTableDefinition(
  id: 'hermit_solitary_lives',
  name: 'Vita Solitaria',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Si è allontanato dalla civiltà per vivere in armonia con la natura.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Ha custodito un antico edificio in rovina o una reliquia.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'È stato esiliato per un crimine che non aveva commesso.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Ha intrapreso un pellegrinaggio alla ricerca di una persona, un luogo o una reliquia di grande valore spirituale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Ha cercato l’illuminazione spirituale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Si è ritirato dalla società dopo un evento sconvolgente.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Ha cercato un luogo tranquillo in cui lavorare a un’opera artistica, letteraria o musicale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Ha vissuto in una comunità seguendo i precetti di un ordine religioso.',
    ),
  ],
);
const _hermitPersonalityTraits = BackgroundTableDefinition(
  id: 'hermit_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Ha trascorso così tanto tempo da solo che parla raramente e preferisce comunicare con gesti e suoni.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Rimane profondamente sereno anche davanti a un disastro.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Conosce una massima di saggezza per ogni argomento ed è impaziente di condividerla.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Prova una forte empatia verso tutti coloro che soffrono.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'È completamente indifferente all’etichetta e alle convenzioni sociali.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Collega ogni evento a un grandioso disegno cosmico.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Si immerge tanto profondamente nei propri pensieri da dimenticare il mondo circostante.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Sta elaborando un vasto sistema filosofico e ama esporre le proprie idee.',
    ),
  ],
);
const _hermitIdeals = BackgroundTableDefinition(
  id: 'hermit_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Bene superiore. I suoi doni devono essere condivisi e usati a beneficio degli altri.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Logica. Le emozioni non devono oscurare ciò che è vero e giusto né limitare il ragionamento.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Libero pensiero. La ricerca e la curiosità sono fondamentali per il progresso.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Potere. La solitudine e la contemplazione conducono al potere mistico o magico.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Vivi e lascia vivere. Intromettersi negli affari altrui genera soltanto problemi.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Autocoscienza. Chi conosce veramente se stesso non ha bisogno di conoscere altro.',
      alignment: 'Qualsiasi',
    ),
  ],
);
const _hermitBonds = BackgroundTableDefinition(
  id: 'hermit_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Gli altri membri della sua comunità, del suo ordine o del suo gruppo di clausura vengono prima di ogni altra cosa.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Aveva scelto l’isolamento per sfuggire a qualcuno che potrebbe essere ancora sulle sue tracce.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Continua a cercare l’illuminazione che sperava di ottenere durante l’eremitaggio.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Aveva scelto l’isolamento perché amava una persona che non avrebbe mai potuto avere.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Se la sua scoperta diventasse di dominio pubblico, potrebbe causare la rovina del mondo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'L’isolamento gli ha rivelato un grande male che soltanto lui potrebbe riuscire a sconfiggere.',
    ),
  ],
);
const _hermitFlaws = BackgroundTableDefinition(
  id: 'hermit_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Dopo il ritorno nel mondo esterno indulge spesso nei piaceri della vita mondana.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'È tormentato da pensieri oscuri e violenti che la meditazione non è riuscita a domare.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'È estremamente dogmatico riguardo alle proprie convinzioni e alla propria filosofia.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Il bisogno di avere sempre l’ultima parola rovina le sue amicizie e l’armonia della sua vita.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Corre rischi eccessivi pur di riportare alla luce anche il più piccolo frammento di conoscenza.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ama custodire segreti che non intende condividere con nessuno.',
    ),
  ],
);
const _hermitCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _hermitPersonalityTraits,
  ideals: _hermitIdeals,
  bonds: _hermitBonds,
  flaws: _hermitFlaws,
);

const _discoveryFeature = BackgroundFeatureDefinition(
  id: 'discovery',
  content: RuleContent(
    id: 'discovery',
    name: 'Scoperta',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Durante il suo isolamento l’eremita ha compiuto una scoperta unica e importante.',
      details:
          'La scoperta può riguardare una verità sul cosmo, sulle divinità, sui piani esterni o sulle forze della natura; un luogo sconosciuto, una conoscenza dimenticata, una reliquia capace di cambiare la storia oppure informazioni pericolose. I dettagli e l’impatto della scoperta vengono concordati con il DM.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 131-132',
    ),
    ownerId: BackgroundIds.hermit,
  ),
  ruleTags: {
    'has_unique_important_discovery',
    'discovery_details_are_defined_with_dm',
    'discovery_may_reveal_cosmic_truth',
    'discovery_may_reveal_unknown_location',
    'discovery_may_reveal_forgotten_knowledge',
    'discovery_may_involve_historic_relic',
    'discovery_may_affect_campaign',
  },
);

const _folkHeroDefiningEvents = BackgroundTableDefinition(
  id: 'folk_hero_defining_events',
  name: 'Eventi Segnanti',
  dieSides: 10,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Si è opposto agli agenti di un tiranno.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Ha salvato molte persone durante una catastrofe naturale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Ha affrontato da solo un mostro terribile.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Ha derubato un mercante corrotto per aiutare i poveri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Ha guidato un gruppo contro un esercito invasore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ha sottratto le armi di un tiranno per consegnarle al popolo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Ha insegnato ai contadini a usare gli attrezzi agricoli come armi contro i soldati del tiranno.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Una sua protesta simbolica ha convinto un nobile ad annullare un decreto impopolare.',
    ),
    BackgroundTableEntry(
      minimumRoll: 9,
      maximumRoll: 9,
      label:
          'Un celestiale, un folletto o una creatura simile lo ha benedetto o gli ha rivelato le sue vere origini.',
    ),
    BackgroundTableEntry(
      minimumRoll: 10,
      maximumRoll: 10,
      label:
          'Arruolato nell’esercito di un signore, è diventato comandante ed è stato ricompensato per il suo eroismo.',
    ),
  ],
);
const _folkHeroPersonalityTraits = BackgroundTableDefinition(
  id: 'folk_hero_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Giudica gli altri dalle loro azioni, non dalle loro parole.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'È sempre pronto ad aiutare qualcuno che si trova nei guai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Quando si pone un obiettivo lo persegue nonostante ogni difficoltà.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Attribuisce grande valore alla correttezza e cerca la soluzione più equa in ogni conflitto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Ha grande fiducia nelle proprie capacità e cerca di trasmetterla agli altri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Preferisce agire anziché perdersi in lunghe riflessioni.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Usa parole altisonanti per sembrare più intelligente di quanto sia realmente.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Si annoia facilmente e teme che il proprio destino si stia compiendo altrove.',
    ),
  ],
);
const _folkHeroIdeals = BackgroundTableDefinition(
  id: 'folk_hero_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Rispetto. Ogni persona merita di essere trattata con dignità.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Giustizia. Nessuno deve ricevere trattamenti di favore e nessuno è al di sopra della legge.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Libertà. Ai tiranni non deve essere consentito di opprimere il popolo.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Potenza. Chi è forte può prendersi ciò che desidera e che ritiene di meritare.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Sincerità. Non esiste nulla di buono nel fingere di essere ciò che non si è.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Destino. Nulla può allontanarlo dalla missione che gli è stata assegnata.',
      alignment: 'Qualsiasi',
    ),
  ],
);
const _folkHeroBonds = BackgroundTableDefinition(
  id: 'folk_hero_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Ha perso le tracce della propria famiglia e spera un giorno di ritrovarla.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Ama la regione in cui ha lavorato ed è determinato a proteggerla.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Un nobile prepotente lo fece picchiare e ora si oppone a ogni bullo che incontra.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Porta sempre con sé gli strumenti del proprio vecchio mestiere per non dimenticare le sue radici.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Protegge chi non è in grado di difendersi da solo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Vorrebbe che la persona amata in gioventù fosse al suo fianco per condividere il suo destino.',
    ),
  ],
);
const _folkHeroFlaws = BackgroundTableDefinition(
  id: 'folk_hero_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Il tiranno della sua regione natale farà tutto il possibile per vederlo morto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'È tanto convinto di essere destinato a grandi imprese da ignorare i propri limiti e il rischio di fallire.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Qualcuno che lo conobbe da giovane sa un segreto tanto imbarazzante da impedirgli di tornare a casa.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Non sa resistere ai vizi della vita cittadina, soprattutto alle bevande alcoliche.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'In segreto crede che tutto funzionerebbe meglio se fosse lui il sovrano assoluto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Ha grandi difficoltà a fidarsi dei propri alleati.',
    ),
  ],
);
const _outlanderOrigins = BackgroundTableDefinition(
  id: 'outlander_origins',
  name: 'Origini',
  dieSides: 10,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Cacciatore con trappole.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Cacciatore di taglie.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Cacciatore-raccoglitore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Colono.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Esule o reietto.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Forestale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Guida.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Nomade tribale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 9,
      maximumRoll: 9,
      label: 'Pellegrino.',
    ),
    BackgroundTableEntry(
      minimumRoll: 10,
      maximumRoll: 10,
      label: 'Predone tribale.',
    ),
  ],
);
const _outlanderPersonalityTraits = BackgroundTableDefinition(
  id: 'outlander_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'È animato da un desiderio insaziabile di viaggiare che lo ha condotto lontano da casa.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Veglia sui propri amici come se fossero cuccioli indifesi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Una volta ha corso per quaranta chilometri per avvertire il clan dell’arrivo di un’orda e sarebbe pronto a rifarlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Trae una lezione da ogni situazione osservata nel mondo naturale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Non si lascia impressionare dalla ricchezza o dai modi raffinati.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Afferra e manipola continuamente gli oggetti, talvolta rompendoli senza volerlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label:
          'Si sente molto più a proprio agio con gli animali che con le persone.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'È stato allevato dai lupi.',
    ),
  ],
);
const _outlanderIdeals = BackgroundTableDefinition(
  id: 'outlander_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Cambiamento. La vita muta come le stagioni e ogni individuo deve cambiare con essa.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Bene superiore. Ognuno deve contribuire alla prosperità e alla felicità della tribù.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Onore. Disonorare se stessi significa disonorare tutto il proprio clan.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Potere. Il più forte possiede il diritto di governare.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Natura. Il mondo naturale è più importante di ogni artificio della civiltà.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Gloria. È doveroso conquistare gloria in battaglia per se stessi e per il proprio clan.',
      alignment: 'Qualsiasi',
    ),
  ],
);
const _outlanderBonds = BackgroundTableDefinition(
  id: 'outlander_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'La sua famiglia, il suo clan o la sua tribù sono la cosa più importante della sua vita.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Una ferita inflitta alla natura incontaminata della sua terra è una ferita inflitta a lui.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Ha giurato vendetta contro coloro che hanno distrutto la sua terra.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'È l’ultimo membro della propria tribù e deve consegnarne il nome alla leggenda.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Ha avuto la visione di un disastro imminente e farà tutto il possibile per impedirlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Sente il dovere di garantire la sopravvivenza e la continuità della propria tribù.',
    ),
  ],
);
const _outlanderFlaws = BackgroundTableDefinition(
  id: 'outlander_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Ama troppo la birra, il vino e le altre bevande alcoliche.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Vive senza compromessi e non adotta mai alcuna cautela.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Ricorda ogni insulto e cova un profondo rancore verso chi lo ha offeso.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Ha difficoltà a fidarsi dei membri di altre razze, tribù o società.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Risponde con la violenza a quasi ogni sfida.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Non intende salvare chi non è capace di salvarsi da solo: per lui il forte sopravvive e il debole perisce.',
    ),
  ],
);
const _folkHeroCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _folkHeroPersonalityTraits,
  ideals: _folkHeroIdeals,
  bonds: _folkHeroBonds,
  flaws: _folkHeroFlaws,
);

const _outlanderCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _outlanderPersonalityTraits,
  ideals: _outlanderIdeals,
  bonds: _outlanderBonds,
  flaws: _outlanderFlaws,
);

const _rusticHospitalityFeature = BackgroundFeatureDefinition(
  id: 'rustic_hospitality',
  content: RuleContent(
    id: 'rustic_hospitality',
    name: 'Ospitalità Rurale',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'La gente comune offre all’eroe popolare rifugio, riposo e protezione.',
      details:
          'L’eroe popolare può trovare presso gli altri popolani un luogo in cui nascondersi, riposare o recuperare le forze, purché la sua presenza non costituisca un pericolo noto. I popolani lo nascondono alla legge e a chi lo cerca, ma non mettono a rischio la propria vita per lui.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 132-133',
    ),
    ownerId: BackgroundIds.folkHero,
  ),
  ruleTags: {
    'commoners_can_provide_hiding_place',
    'commoners_can_provide_rest',
    'commoners_can_provide_recovery',
    'aid_requires_no_known_danger_to_commoners',
    'commoners_hide_character_from_law',
    'commoners_hide_character_from_pursuers',
    'commoners_will_not_risk_their_lives',
  },
);

const _wandererFeature = BackgroundFeatureDefinition(
  id: 'wanderer',
  content: RuleContent(
    id: 'wanderer',
    name: 'Viandante',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Possiede un’eccellente memoria geografica e sa procurare sostentamento nelle terre selvagge.',
      details:
          'Il forestiero ricorda sempre la disposizione generale del territorio, degli insediamenti e dei punti di riferimento circostanti. Può inoltre trovare ogni giorno cibo e acqua fresca per sé e per altre cinque persone, purché il territorio offra risorse adeguate.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 133-134',
    ),
    ownerId: BackgroundIds.outlander,
  ),
  ruleTags: {
    'remembers_general_terrain_layout',
    'remembers_settlements',
    'remembers_landmarks',
    'can_find_daily_food_and_water',
    'supports_self_and_five_others',
    'foraging_requires_available_resources',
  },
);

const _entertainerArtForms = BackgroundTableDefinition(
  id: 'entertainer_art_forms',
  name: 'Discipline Artistiche',
  dieSides: 10,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Acrobata.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'Attore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Cantore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Danzatore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label: 'Giocoliere.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Giullare.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Mangiatore di fuoco.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label: 'Narratore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 9,
      maximumRoll: 9,
      label: 'Poeta.',
    ),
    BackgroundTableEntry(
      minimumRoll: 10,
      maximumRoll: 10,
      label: 'Strumentista.',
    ),
  ],
);
const _entertainerPersonalityTraits = BackgroundTableDefinition(
  id: 'entertainer_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Possiede una storia interessante per ogni situazione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Quando arriva in un luogo nuovo si informa subito sulle dicerie e sui pettegolezzi locali.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'È un inguaribile romantico, sempre alla ricerca di qualcuno di speciale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Sa allentare le tensioni tanto bene che nessuno rimane arrabbiato a lungo con lui o con i suoi compagni.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Apprezza un insulto ben costruito anche quando è rivolto contro di lui.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Si amareggia quando non è al centro dell’attenzione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Punta sempre alla perfezione in ogni esibizione.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Cambia umore o opinione con la stessa rapidità con cui cambia la tonalità di una canzone.',
    ),
  ],
);
const _entertainerIdeals = BackgroundTableDefinition(
  id: 'entertainer_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Bellezza. Attraverso le proprie esibizioni vuole rendere il mondo migliore.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Tradizione. Le storie, le leggende e le canzoni del passato non devono essere dimenticate.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Creatività. Il mondo ha bisogno di nuove idee e di azioni significative.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Avidità. Si esibisce soltanto per ottenere denaro e fama.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Persone. I sorrisi sul volto del pubblico sono l’unica cosa che conta.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Onestà. L’arte deve scaturire dal cuore, riflettere l’anima e rivelare chi siamo veramente.',
      alignment: 'Qualsiasi',
    ),
  ],
);
const _entertainerBonds = BackgroundTableDefinition(
  id: 'entertainer_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Il suo strumento musicale è il bene più prezioso perché gli ricorda una persona amata.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Qualcuno ha rubato il suo prezioso strumento e ha giurato di recuperarlo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Vuole diventare famoso a qualsiasi costo.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Ammira un eroe delle antiche leggende e confronta continuamente le proprie imprese con le sue.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Farebbe qualsiasi cosa per dimostrare di essere superiore al proprio odiato rivale.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Farebbe qualsiasi cosa per i membri della sua vecchia compagnia di artisti.',
    ),
  ],
);
const _entertainerFlaws = BackgroundTableDefinition(
  id: 'entertainer_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Farebbe qualunque cosa pur di ottenere fama e onore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Quando vede un bel viso perde completamente il proprio buon senso.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Uno scandalo gli impedisce di tornare a casa e problemi simili sembrano seguirlo ovunque.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Ha ridicolizzato un nobile che ora vuole la sua testa e probabilmente commetterebbe di nuovo lo stesso errore.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Non riesce a nascondere i propri sentimenti e la sua lingua affilata lo mette spesso nei guai.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Nonostante ogni sforzo, non riesce a essere affidabile nemmeno con i propri amici.',
    ),
  ],
);
const _entertainerCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _entertainerPersonalityTraits,
  ideals: _entertainerIdeals,
  bonds: _entertainerBonds,
  flaws: _entertainerFlaws,
);

const _byPopularDemandFeature = BackgroundFeatureDefinition(
  id: 'by_popular_demand',
  content: RuleContent(
    id: 'by_popular_demand',
    name: 'A Grande Richiesta',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Trova sempre un luogo in cui esibirsi e riceve vitto e alloggio in cambio dello spettacolo.',
      details:
          'L’intrattenitore trova normalmente un luogo in cui esibirsi, come una locanda, una taverna, un circo, un teatro o una corte. Riceve gratuitamente vitto e alloggio di qualità adeguata al locale se si esibisce ogni notte. Nelle località in cui si è già esibito può inoltre essere riconosciuto e ammirato come una celebrità locale.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 135-136',
    ),
    ownerId: BackgroundIds.entertainer,
  ),
  ruleTags: {
    'can_find_performance_venue',
    'performance_may_be_at_inn_or_tavern',
    'performance_may_be_at_circus_or_theater',
    'performance_may_be_at_noble_court',
    'nightly_performance_provides_food',
    'nightly_performance_provides_lodging',
    'lodging_quality_depends_on_venue',
    'recognized_as_local_celebrity',
  },
);

const _sailorPersonalityTraits = BackgroundTableDefinition(
  id: 'sailor_personality_traits',
  name: 'Tratti Caratteriali',
  dieSides: 8,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'I suoi amici sanno di poter contare su di lui in ogni circostanza.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Lavora duramente per potersi divertire con altrettanto entusiasmo quando il lavoro è finito.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Ama attraccare in porti sconosciuti e conoscere nuovi amici davanti a una fiasca di birra.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'È disposto ad alterare leggermente la verità pur di raccontare una buona storia.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Considera una rissa in taverna un ottimo modo per conoscere una nuova città.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Non rifiuta mai una scommessa amichevole.',
    ),
    BackgroundTableEntry(
      minimumRoll: 7,
      maximumRoll: 7,
      label: 'Usa un linguaggio tanto sporco quanto la tana di un otyugh.',
    ),
    BackgroundTableEntry(
      minimumRoll: 8,
      maximumRoll: 8,
      label:
          'Apprezza il lavoro ben fatto, soprattutto quando riesce a convincere qualcun altro a svolgerlo.',
    ),
  ],
);
const _sailorIdeals = BackgroundTableDefinition(
  id: 'sailor_ideals',
  name: 'Ideali',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'Rispetto. Una nave resta unita grazie al rispetto reciproco tra capitano ed equipaggio.',
      alignment: 'Buono',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'Giustizia. Poiché tutti collaborano, le ricompense devono essere divise equamente.',
      alignment: 'Legale',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Libertà. Il mare rappresenta la libertà di andare ovunque e fare qualsiasi cosa.',
      alignment: 'Caotico',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'Dominio. Si considera un predatore e vede le altre navi come prede.',
      alignment: 'Malvagio',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Persone. Si sente responsabile verso la propria ciurma, non verso ideali astratti.',
      alignment: 'Neutrale',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Ambizione. Desidera una nave propria per poter decidere autonomamente il suo destino.',
      alignment: 'Qualsiasi',
    ),
  ],
);
const _sailorBonds = BackgroundTableDefinition(
  id: 'sailor_bonds',
  name: 'Legami',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label:
          'La sua lealtà appartiene prima al capitano e poi a tutti gli altri.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label:
          'La nave è l’unica cosa che conta veramente: capitani e marinai vanno e vengono.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label: 'Non dimenticherà mai il proprio primo viaggio.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label:
          'In una città portuale ha conosciuto una persona per cui ha quasi abbandonato il mare.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'È stato imbrogliato durante la divisione di un bottino e vuole ottenere ciò che gli spetta.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label:
          'Pirati spietati hanno ucciso il capitano e la ciurma, saccheggiato la nave e lo hanno abbandonato; ora cerca vendetta.',
    ),
  ],
);
const _sailorFlaws = BackgroundTableDefinition(
  id: 'sailor_flaws',
  name: 'Difetti',
  dieSides: 6,
  entries: [
    BackgroundTableEntry(
      minimumRoll: 1,
      maximumRoll: 1,
      label: 'Obbedisce agli ordini anche quando li considera sbagliati.',
    ),
    BackgroundTableEntry(
      minimumRoll: 2,
      maximumRoll: 2,
      label: 'È disposto a dire qualsiasi cosa pur di evitare altro lavoro.',
    ),
    BackgroundTableEntry(
      minimumRoll: 3,
      maximumRoll: 3,
      label:
          'Se qualcuno mette in dubbio il suo coraggio non si ritira, per quanto la situazione diventi pericolosa.',
    ),
    BackgroundTableEntry(
      minimumRoll: 4,
      maximumRoll: 4,
      label: 'Quando comincia a bere gli riesce molto difficile fermarsi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 5,
      maximumRoll: 5,
      label:
          'Non riesce a evitare di intascare monete e piccoli oggetti lasciati incustoditi.',
    ),
    BackgroundTableEntry(
      minimumRoll: 6,
      maximumRoll: 6,
      label: 'Il suo orgoglio probabilmente finirà per causare la sua rovina.',
    ),
  ],
);
const _sailorCharacteristics = BackgroundSuggestedCharacteristics(
  personalityTraits: _sailorPersonalityTraits,
  ideals: _sailorIdeals,
  bonds: _sailorBonds,
  flaws: _sailorFlaws,
);

const _shipsPassageFeature = BackgroundFeatureDefinition(
  id: 'ships_passage',
  content: RuleContent(
    id: 'ships_passage',
    name: 'Passaggio Via Nave',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'Può ottenere un passaggio gratuito su una nave per sé e per i propri compagni.',
      details:
          'Il marinaio può chiedere un passaggio gratuito sulla nave su cui ha prestato servizio o su un’altra nave con cui mantiene buoni rapporti. Non può garantire tempi o rotta e il DM stabilisce la durata del viaggio. In cambio, il marinaio e i suoi compagni devono aiutare l’equipaggio durante la traversata.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagine 136-137',
    ),
    ownerId: BackgroundIds.sailor,
  ),
  ruleTags: {
    'can_request_free_ship_passage',
    'passage_includes_adventuring_companions',
    'uses_former_or_friendly_ship',
    'route_is_not_guaranteed',
    'travel_time_is_determined_by_dm',
    'travelers_must_help_ship_crew',
  },
);

const _badReputationFeature = BackgroundFeatureDefinition(
  id: 'bad_reputation',
  content: RuleContent(
    id: 'bad_reputation',
    name: 'Pessima Fama',
    type: RuleContentType.background,
    description: RuleDescription(
      summary:
          'La sua reputazione incute paura e gli consente di evitare conseguenze per alcune infrazioni minori.',
      details:
          'Negli insediamenti civilizzati la gente teme il pirata. Può passarla liscia per infrazioni minori, come non pagare un pasto o sfondare la porta di un negozio, perché la maggior parte delle persone non denuncia le sue azioni alle autorità.',
    ),
    source: RuleSource(
      name: 'Manuale del Giocatore 2014',
      reference: 'Pagina 137',
    ),
    ownerId: BackgroundIds.pirate,
  ),
  ruleTags: {
    'feared_due_to_bad_reputation',
    'applies_in_civilized_settlements',
    'minor_offenses_often_go_unreported',
    'can_avoid_consequences_for_unpaid_meal',
    'can_avoid_consequences_for_minor_property_damage',
    'does_not_cover_serious_crimes',
  },
);

/// Registro canonico dei background.
///
/// Verrà popolato progressivamente seguendo la checklist PHB.
const Map<String, BackgroundDefinition> backgroundDefinitions = {
  BackgroundIds.acolyte: BackgroundDefinition(
    id: BackgroundIds.acolyte,
    name: 'Accolito',
    content: RuleContent(
      id: BackgroundIds.acolyte,
      name: 'Accolito',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Ha trascorso la propria vita al servizio di un tempio, di una divinità o di un pantheon.',
        details:
            'Un accolito funge da intermediario tra il reame del sacro e il mondo dei mortali, celebra riti solenni, offre sacrifici e assiste i fedeli. Il suo servizio religioso non implica necessariamente che sia un chierico.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagina 127',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'acolyte',
      ),
      ownerId: BackgroundIds.acolyte,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Intuizione',
        'Religione',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'acolyte_languages',
          label: 'Scegli due linguaggi',
          type: CharacterChoiceType.language,
          minimumSelections: 2,
          maximumSelections: 2,
          optionIds: characterLanguageIds,
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'acolyte_holy_symbol',
          label: 'Scegli un simbolo sacro',
          type: CharacterChoiceType.equipment,
          catalogId: 'focus',
          optionIds: [
            FocusIds.amulet,
            FocusIds.emblem,
            FocusIds.reliquary,
          ],
        ),
        CharacterChoiceDefinition(
          id: 'acolyte_prayer_item',
          label: 'Scegli un oggetto di preghiera',
          type: CharacterChoiceType.equipment,
          catalogId: 'equipment',
          optionIds: [
            EquipmentIds.prayerBook,
            EquipmentIds.prayerWheel,
          ],
        ),
      ],
    ),
    feature: BackgroundFeatureDefinition(
      id: 'shelter_of_the_faithful',
      content: RuleContent(
        id: 'shelter_of_the_faithful',
        name: 'Rifugio dei Fedeli',
        type: RuleContentType.background,
        description: RuleDescription(
          summary:
              'I membri della stessa fede rispettano e sostengono l’accolito.',
          details:
              'L’accolito può celebrare le cerimonie religiose della sua divinità. Lui e i suoi compagni possono ricevere cure e guarigioni gratuite presso una presenza stabile della sua fede, fornendo comunque le componenti materiali richieste. I fedeli mantengono l’accolito offrendo a lui uno stile di vita modesto. Presso un tempio con cui mantiene buoni rapporti può inoltre ottenere ospitalità e chiedere ai sacerdoti aiuto che non li esponga a pericoli.',
        ),
        source: RuleSource(
          name: 'Manuale del Giocatore 2014',
          reference: 'Pagina 127',
        ),
        ownerId: BackgroundIds.acolyte,
      ),
      ruleTags: {
        'can_perform_religious_ceremonies',
        'faithful_offer_modest_lifestyle',
        'temple_provides_free_care',
        'caster_supplies_required_spell_components',
        'temple_can_provide_safe_assistance',
        'temple_can_provide_lodging',
      },
    ),
    suggestedCharacteristics: BackgroundSuggestedCharacteristics(
      personalityTraits: BackgroundTableDefinition(
        id: 'acolyte_personality_traits',
        name: 'Tratti Caratteriali',
        dieSides: 8,
        entries: [
          BackgroundTableEntry(
            minimumRoll: 1,
            maximumRoll: 1,
            label:
                'Venera un particolare eroe della sua fede e si ispira continuamente alle sue gesta e al suo esempio.',
          ),
          BackgroundTableEntry(
            minimumRoll: 2,
            maximumRoll: 2,
            label:
                'Trova punti in comune perfino tra due acerrimi nemici e cerca sempre una soluzione pacifica.',
          ),
          BackgroundTableEntry(
            minimumRoll: 3,
            maximumRoll: 3,
            label:
                'Vede presagi in ogni evento e gesto, convinto che gli dèi cerchino continuamente di parlare ai mortali.',
          ),
          BackgroundTableEntry(
            minimumRoll: 4,
            maximumRoll: 4,
            label: 'Nulla riesce a minare il suo ottimismo.',
          ),
          BackgroundTableEntry(
            minimumRoll: 5,
            maximumRoll: 5,
            label:
                'Cita i testi sacri e i proverbi pressoché in ogni situazione, non sempre con esattezza.',
          ),
          BackgroundTableEntry(
            minimumRoll: 6,
            maximumRoll: 6,
            label:
                'È tollerante o intollerante verso le altre fedi e rispetta o disprezza il culto degli altri dèi.',
          ),
          BackgroundTableEntry(
            minimumRoll: 7,
            maximumRoll: 7,
            label:
                'Ha conosciuto i piaceri del buon cibo, del buon vino e dell’alta società; la povertà lo mette a disagio.',
          ),
          BackgroundTableEntry(
            minimumRoll: 8,
            maximumRoll: 8,
            label:
                'Ha trascorso così tanto tempo nel tempio da avere difficoltà a interagire con gli altri nel mondo esterno.',
          ),
        ],
      ),
      ideals: BackgroundTableDefinition(
        id: 'acolyte_ideals',
        name: 'Ideali',
        dieSides: 6,
        entries: [
          BackgroundTableEntry(
            minimumRoll: 1,
            maximumRoll: 1,
            label:
                'Tradizione. Le antiche tradizioni di preghiera e sacrificio devono essere conservate e sostenute.',
            alignment: 'Legale',
          ),
          BackgroundTableEntry(
            minimumRoll: 2,
            maximumRoll: 2,
            label:
                'Carità. Cerca sempre di aiutare i bisognosi e non esita a sacrificarsi personalmente.',
            alignment: 'Buono',
          ),
          BackgroundTableEntry(
            minimumRoll: 3,
            maximumRoll: 3,
            label:
                'Cambiamento. Deve contribuire alla diffusione dei mutamenti che gli dèi operano costantemente nel mondo.',
            alignment: 'Caotico',
          ),
          BackgroundTableEntry(
            minimumRoll: 4,
            maximumRoll: 4,
            label:
                'Potere. Spera di raggiungere le posizioni più elevate nella gerarchia della sua chiesa.',
            alignment: 'Legale',
          ),
          BackgroundTableEntry(
            minimumRoll: 5,
            maximumRoll: 5,
            label:
                'Fede. È convinto che la sua divinità guidi le sue scelte e che il suo impegno sarà ricompensato.',
            alignment: 'Legale',
          ),
          BackgroundTableEntry(
            minimumRoll: 6,
            maximumRoll: 6,
            label:
                'Ambizione. Cerca di dimostrarsi degno del favore della sua divinità e corregge ciò che contrasta con i suoi insegnamenti.',
            alignment: 'Qualsiasi',
          ),
        ],
      ),
      bonds: BackgroundTableDefinition(
        id: 'acolyte_bonds',
        name: 'Legami',
        dieSides: 6,
        entries: [
          BackgroundTableEntry(
            minimumRoll: 1,
            maximumRoll: 1,
            label:
                'Morirebbe pur di recuperare un’antica reliquia della sua fede, perduta da molto tempo.',
          ),
          BackgroundTableEntry(
            minimumRoll: 2,
            maximumRoll: 2,
            label:
                'Cerca vendetta contro i ministri corrotti del tempio che lo accusarono di eresia.',
          ),
          BackgroundTableEntry(
            minimumRoll: 3,
            maximumRoll: 3,
            label:
                'Deve la vita al sacerdote che lo accolse nel tempio dopo la morte dei suoi genitori.',
          ),
          BackgroundTableEntry(
            minimumRoll: 4,
            maximumRoll: 4,
            label: 'Tutto ciò che fa, lo fa per la gente comune.',
          ),
          BackgroundTableEntry(
            minimumRoll: 5,
            maximumRoll: 5,
            label:
                'Farebbe qualunque cosa pur di proteggere il tempio in cui ha servito.',
          ),
          BackgroundTableEntry(
            minimumRoll: 6,
            maximumRoll: 6,
            label:
                'Protegge un testo sacro che i suoi nemici considerano eretico e vogliono distruggere.',
          ),
        ],
      ),
      flaws: BackgroundTableDefinition(
        id: 'acolyte_flaws',
        name: 'Difetti',
        dieSides: 6,
        entries: [
          BackgroundTableEntry(
            minimumRoll: 1,
            maximumRoll: 1,
            label:
                'Giudica gli altri con durezza e se stesso ancora più severamente.',
          ),
          BackgroundTableEntry(
            minimumRoll: 2,
            maximumRoll: 2,
            label:
                'Si affida totalmente e acriticamente a chi detiene il potere nel suo tempio.',
          ),
          BackgroundTableEntry(
            minimumRoll: 3,
            maximumRoll: 3,
            label:
                'La sua religiosità lo induce a credere ciecamente a chi professa la sua stessa fede.',
          ),
          BackgroundTableEntry(
            minimumRoll: 4,
            maximumRoll: 4,
            label: 'È inflessibile.',
          ),
          BackgroundTableEntry(
            minimumRoll: 5,
            maximumRoll: 5,
            label:
                'Non si fida degli sconosciuti e si aspetta sempre il peggio da loro.',
          ),
          BackgroundTableEntry(
            minimumRoll: 6,
            maximumRoll: 6,
            label:
                'Quando si prefigge un obiettivo ne è ossessionato, fino a ignorare ogni altro aspetto della sua vita.',
          ),
        ],
      ),
    ),
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.incense,
        quantity: 5,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.robes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.guildArtisan: BackgroundDefinition(
    id: BackgroundIds.guildArtisan,
    name: 'Artigiano di Gilda',
    content: RuleContent(
      id: BackgroundIds.guildArtisan,
      name: 'Artigiano di Gilda',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un maestro artigiano inserito nel mondo mercantile e sostenuto dalla propria gilda.',
        details:
            'Ha imparato un mestiere sotto la guida di un maestro e conosce sia la lavorazione delle materie prime sia le pratiche commerciali legate alla propria professione.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 128-129',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'guild_artisan',
      ),
      ownerId: BackgroundIds.guildArtisan,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Intuizione',
        'Persuasione',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'guild_artisan_tools',
          label: 'Scegli gli strumenti da artigiano conosciuti e ricevuti',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.alchemistsSupplies,
              label: 'Strumenti da Alchimista',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.alchemistsSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.alchemistsSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.brewersSupplies,
              label: 'Strumenti da Birraio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.brewersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.brewersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.calligraphersSupplies,
              label: 'Strumenti da Calligrafo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.calligraphersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.calligraphersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.carpentersTools,
              label: 'Strumenti da Carpentiere',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.carpentersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.carpentersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cartographersTools,
              label: 'Strumenti da Cartografo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cartographersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.cartographersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cobblersTools,
              label: 'Strumenti da Ciabattino',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cobblersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.cobblersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cooksUtensils,
              label: 'Utensili da Cuoco',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cooksUtensils,
                },
                grantedEquipmentIds: [
                  ToolIds.cooksUtensils,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.glassblowersTools,
              label: 'Strumenti da Soffiatore di Vetro',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.glassblowersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.glassblowersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.jewelersTools,
              label: 'Strumenti da Gioielliere',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.jewelersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.jewelersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.leatherworkersTools,
              label: 'Strumenti da Conciatore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.leatherworkersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.leatherworkersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.masonsTools,
              label: 'Strumenti da Muratore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.masonsTools,
                },
                grantedEquipmentIds: [
                  ToolIds.masonsTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.paintersSupplies,
              label: 'Strumenti da Pittore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.paintersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.paintersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.pottersTools,
              label: 'Strumenti da Vasaio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.pottersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.pottersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.smithsTools,
              label: 'Strumenti da Fabbro',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.smithsTools,
                },
                grantedEquipmentIds: [
                  ToolIds.smithsTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.tinkersTools,
              label: 'Strumenti da Inventore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.tinkersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.tinkersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.weaversTools,
              label: 'Strumenti da Tessitore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.weaversTools,
                },
                grantedEquipmentIds: [
                  ToolIds.weaversTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.woodcarversTools,
              label: 'Strumenti da Intagliatore del Legno',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.woodcarversTools,
                },
                grantedEquipmentIds: [
                  ToolIds.woodcarversTools,
                ],
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'guild_artisan_language',
          label: 'Scegli un linguaggio',
          type: CharacterChoiceType.language,
          optionIds: characterLanguageIds,
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _guildMembershipFeature,
    tables: [
      _guildActivities,
    ],
    suggestedCharacteristics: _guildCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.guildLetter,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.travelersClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.guildMerchant: BackgroundDefinition(
    id: BackgroundIds.guildMerchant,
    name: 'Mercante di Gilda',
    content: RuleContent(
      id: BackgroundIds.guildMerchant,
      name: 'Mercante di Gilda',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un mercante, carovaniere o negoziante appartenente a una potente organizzazione commerciale.',
        details:
            'Compra, trasporta e vende merci o materie prime invece di produrle personalmente. Può lavorare per un consorzio mercantile, una famiglia commerciale o una rete di carovane.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagina 129',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'guild_merchant',
      ),
      ownerId: BackgroundIds.guildMerchant,
    ),
    parentBackgroundId: BackgroundIds.guildArtisan,
    effects: CharacterEffects(
      skillProficiencies: {
        'Intuizione',
        'Persuasione',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'guild_merchant_training',
          label:
              'Scegli gli Strumenti del Navigatore oppure un linguaggio aggiuntivo',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.navigatorsTools,
              label: 'Competenza negli Strumenti del Navigatore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.navigatorsTools,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_comune',
              label: 'Linguaggio: Comune',
              effects: CharacterEffects(
                languages: {
                  'Comune',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_nanico',
              label: 'Linguaggio: Nanico',
              effects: CharacterEffects(
                languages: {
                  'Nanico',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_elfico',
              label: 'Linguaggio: Elfico',
              effects: CharacterEffects(
                languages: {
                  'Elfico',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_gigante',
              label: 'Linguaggio: Gigante',
              effects: CharacterEffects(
                languages: {
                  'Gigante',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_gnomesco',
              label: 'Linguaggio: Gnomesco',
              effects: CharacterEffects(
                languages: {
                  'Gnomesco',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_goblin',
              label: 'Linguaggio: Goblin',
              effects: CharacterEffects(
                languages: {
                  'Goblin',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_halfling',
              label: 'Linguaggio: Halfling',
              effects: CharacterEffects(
                languages: {
                  'Halfling',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_orchesco',
              label: 'Linguaggio: Orchesco',
              effects: CharacterEffects(
                languages: {
                  'Orchesco',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_abissale',
              label: 'Linguaggio: Abissale',
              effects: CharacterEffects(
                languages: {
                  'Abissale',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_celestiale',
              label: 'Linguaggio: Celestiale',
              effects: CharacterEffects(
                languages: {
                  'Celestiale',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_draconico',
              label: 'Linguaggio: Draconico',
              effects: CharacterEffects(
                languages: {
                  'Draconico',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_gergo_delle_profondità',
              label: 'Linguaggio: Gergo delle Profondità',
              effects: CharacterEffects(
                languages: {
                  'Gergo delle Profondità',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_infernale',
              label: 'Linguaggio: Infernale',
              effects: CharacterEffects(
                languages: {
                  'Infernale',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_primordiale',
              label: 'Linguaggio: Primordiale',
              effects: CharacterEffects(
                languages: {
                  'Primordiale',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_silvano',
              label: 'Linguaggio: Silvano',
              effects: CharacterEffects(
                languages: {
                  'Silvano',
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'guild_merchant_language_sottocomune',
              label: 'Linguaggio: Sottocomune',
              effects: CharacterEffects(
                languages: {
                  'Sottocomune',
                },
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'guild_merchant_language',
          label: 'Scegli il linguaggio del background principale',
          type: CharacterChoiceType.language,
          optionIds: characterLanguageIds,
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _guildMembershipFeature,
    tables: [
      _guildActivities,
    ],
    suggestedCharacteristics: _guildCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: MountIds.mule,
        catalogId: 'mount',
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.cart,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.guildLetter,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.travelersClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.charlatan: BackgroundDefinition(
    id: BackgroundIds.charlatan,
    name: 'Ciarlatano',
    content: RuleContent(
      id: BackgroundIds.charlatan,
      name: 'Ciarlatano',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un abile manipolatore capace di leggere i desideri altrui e sfruttarli a proprio vantaggio.',
        details:
            'Il ciarlatano confeziona promesse e identità credibili, facendo leva sui desideri e sulle debolezze delle persone. Possiede una tecnica di truffa preferita e gli strumenti necessari per sostenerla.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 129-130',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'charlatan',
      ),
      ownerId: BackgroundIds.charlatan,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Inganno',
        'Rapidità di Mano',
      },
      toolProficiencies: {
        ToolIds.forgeryKit,
        ToolIds.disguiseKit,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'charlatan_con_tools',
          label: 'Scegli gli strumenti della truffa',
          type: CharacterChoiceType.equipment,
          optionIds: [
            EquipmentIds.charlatanColoredBottles,
            EquipmentIds.loadedDice,
            EquipmentIds.markedCards,
            EquipmentIds.falseDucalSignetRing,
          ],
        ),
      ],
    ),
    feature: _falseIdentityFeature,
    tables: [
      _charlatanScams,
    ],
    suggestedCharacteristics: _charlatanCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.fineClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: ToolIds.disguiseKit,
        catalogId: 'tool',
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.criminal: BackgroundDefinition(
    id: BackgroundIds.criminal,
    name: 'Criminale',
    content: RuleContent(
      id: BackgroundIds.criminal,
      name: 'Criminale',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un malfattore esperto, legato al mondo clandestino e alle sue reti.',
        details:
            'Ha violato ripetutamente la legge, ha trascorso molto tempo tra altri criminali e conserva ancora contatti con quel mondo di furti, violenza e traffici illeciti.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 130-131',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'criminal',
      ),
      ownerId: BackgroundIds.criminal,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Furtività',
        'Inganno',
      },
      toolProficiencies: {
        ToolIds.thievesTools,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'criminal_gaming_set',
          label: 'Scegli un tipo di gioco',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.diceSet,
              label: 'Set di Dadi',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.diceSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dragonchessSet,
              label: 'Set di Dragonchess',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.dragonchessSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.playingCardSet,
              label: 'Mazzo di Carte',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.playingCardSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.threeDragonAnteSet,
              label: 'Three-Dragon Ante',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.threeDragonAnteSet,
                },
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _criminalContactFeature,
    tables: [
      _criminalSpecializations,
    ],
    suggestedCharacteristics: _criminalCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.crowbar,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.spy: BackgroundDefinition(
    id: BackgroundIds.spy,
    name: 'Spia',
    content: RuleContent(
      id: BackgroundIds.spy,
      name: 'Spia',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un agente addestrato a raccogliere e trasmettere informazioni segrete.',
        details:
            'Possiede capacità simili a quelle di uno scassinatore o di un contrabbandiere, ma le usa per lo spionaggio. Può operare per una corona, un’organizzazione oppure vendere i segreti scoperti al miglior offerente.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagina 131',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'spy',
      ),
      ownerId: BackgroundIds.spy,
    ),
    parentBackgroundId: BackgroundIds.criminal,
    effects: CharacterEffects(
      skillProficiencies: {
        'Furtività',
        'Inganno',
      },
      toolProficiencies: {
        ToolIds.thievesTools,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'spy_gaming_set',
          label: 'Scegli un tipo di gioco',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.diceSet,
              label: 'Set di Dadi',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.diceSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dragonchessSet,
              label: 'Set di Dragonchess',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.dragonchessSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.playingCardSet,
              label: 'Mazzo di Carte',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.playingCardSet,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.threeDragonAnteSet,
              label: 'Three-Dragon Ante',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.threeDragonAnteSet,
                },
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _criminalContactFeature,
    tables: [
      _criminalSpecializations,
    ],
    suggestedCharacteristics: _criminalCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.crowbar,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.hermit: BackgroundDefinition(
    id: BackgroundIds.hermit,
    name: 'Eremita',
    content: RuleContent(
      id: BackgroundIds.hermit,
      name: 'Eremita',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Ha trascorso gli anni formativi della propria vita lontano dalla società.',
        details:
            'Ha vissuto in un luogo isolato, presso una comunità separata oppure completamente da solo. Lontano dalla confusione della società ha trovato tranquillità, solitudine e forse alcune delle risposte che cercava.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 131-132',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'hermit',
      ),
      ownerId: BackgroundIds.hermit,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Medicina',
        'Religione',
      },
      toolProficiencies: {
        ToolIds.herbalismKit,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'hermit_language',
          label: 'Scegli un linguaggio',
          type: CharacterChoiceType.language,
          optionIds: characterLanguageIds,
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _discoveryFeature,
    tables: [
      _hermitSolitaryLives,
    ],
    suggestedCharacteristics: _hermitCharacteristics,
    startingCoins: {
      'MO': 5,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.scrollCase,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.blanket,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: ToolIds.herbalismKit,
        catalogId: 'tool',
      ),
    ],
  ),
  BackgroundIds.folkHero: BackgroundDefinition(
    id: BackgroundIds.folkHero,
    name: 'Eroe Popolare',
    content: RuleContent(
      id: BackgroundIds.folkHero,
      name: 'Eroe Popolare',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Una persona di umili origini riconosciuta come campione dalla gente comune.',
        details:
            'Proviene dai ceti sociali più bassi, ma è destinato a qualcosa di grandioso. La comunità natale lo considera già il proprio campione contro tiranni, mostri e altre minacce.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 132-133',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'folk_hero',
      ),
      ownerId: BackgroundIds.folkHero,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Addestrare Animali',
        'Sopravvivenza',
      },
      toolProficiencies: {
        ToolIds.landVehicles,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'folk_hero_artisan_tools',
          label: 'Scegli gli strumenti da artigiano conosciuti e ricevuti',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.alchemistsSupplies,
              label: 'Strumenti da Alchimista',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.alchemistsSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.alchemistsSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.brewersSupplies,
              label: 'Strumenti da Birraio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.brewersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.brewersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.calligraphersSupplies,
              label: 'Strumenti da Calligrafo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.calligraphersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.calligraphersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.carpentersTools,
              label: 'Strumenti da Carpentiere',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.carpentersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.carpentersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cartographersTools,
              label: 'Strumenti da Cartografo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cartographersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.cartographersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cobblersTools,
              label: 'Strumenti da Ciabattino',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cobblersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.cobblersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.cooksUtensils,
              label: 'Utensili da Cuoco',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.cooksUtensils,
                },
                grantedEquipmentIds: [
                  ToolIds.cooksUtensils,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.glassblowersTools,
              label: 'Strumenti da Soffiatore di Vetro',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.glassblowersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.glassblowersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.jewelersTools,
              label: 'Strumenti da Gioielliere',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.jewelersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.jewelersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.leatherworkersTools,
              label: 'Strumenti da Conciatore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.leatherworkersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.leatherworkersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.masonsTools,
              label: 'Strumenti da Muratore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.masonsTools,
                },
                grantedEquipmentIds: [
                  ToolIds.masonsTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.paintersSupplies,
              label: 'Strumenti da Pittore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.paintersSupplies,
                },
                grantedEquipmentIds: [
                  ToolIds.paintersSupplies,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.pottersTools,
              label: 'Strumenti da Vasaio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.pottersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.pottersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.smithsTools,
              label: 'Strumenti da Fabbro',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.smithsTools,
                },
                grantedEquipmentIds: [
                  ToolIds.smithsTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.tinkersTools,
              label: 'Strumenti da Inventore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.tinkersTools,
                },
                grantedEquipmentIds: [
                  ToolIds.tinkersTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.weaversTools,
              label: 'Strumenti da Tessitore',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.weaversTools,
                },
                grantedEquipmentIds: [
                  ToolIds.weaversTools,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.woodcarversTools,
              label: 'Strumenti da Intagliatore del Legno',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.woodcarversTools,
                },
                grantedEquipmentIds: [
                  ToolIds.woodcarversTools,
                ],
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _rusticHospitalityFeature,
    tables: [
      _folkHeroDefiningEvents,
    ],
    suggestedCharacteristics: _folkHeroCharacteristics,
    startingCoins: {
      'MO': 10,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.shovel,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.ironPot,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.outlander: BackgroundDefinition(
    id: BackgroundIds.outlander,
    name: 'Forestiero',
    content: RuleContent(
      id: BackgroundIds.outlander,
      name: 'Forestiero',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'È cresciuto nelle terre selvagge, lontano dalle comodità della civiltà.',
        details:
            'È sopravvissuto a migrazioni, intemperie e lunghi periodi di solitudine. Che sia nomade, esploratore, cacciatore, raccoglitore o predone, rimane un maestro della vita nelle terre selvagge.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 133-134',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'outlander',
      ),
      ownerId: BackgroundIds.outlander,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Atletica',
        'Sopravvivenza',
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'outlander_musical_instrument',
          label: 'Scegli uno strumento musicale conosciuto e ricevuto',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.bagpipes,
              label: 'Cornamusa',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.bagpipes,
                },
                grantedEquipmentIds: [
                  ToolIds.bagpipes,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.drum,
              label: 'Tamburo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.drum,
                },
                grantedEquipmentIds: [
                  ToolIds.drum,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dulcimer,
              label: 'Salterio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.dulcimer,
                },
                grantedEquipmentIds: [
                  ToolIds.dulcimer,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.flute,
              label: 'Flauto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.flute,
                },
                grantedEquipmentIds: [
                  ToolIds.flute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lute,
              label: 'Liuto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lute,
                },
                grantedEquipmentIds: [
                  ToolIds.lute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lyre,
              label: 'Lira',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lyre,
                },
                grantedEquipmentIds: [
                  ToolIds.lyre,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.horn,
              label: 'Corno',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.horn,
                },
                grantedEquipmentIds: [
                  ToolIds.horn,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.panFlute,
              label: 'Flauto di Pan',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.panFlute,
                },
                grantedEquipmentIds: [
                  ToolIds.panFlute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.shawm,
              label: 'Ciaramella',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.shawm,
                },
                grantedEquipmentIds: [
                  ToolIds.shawm,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.viol,
              label: 'Viola',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.viol,
                },
                grantedEquipmentIds: [
                  ToolIds.viol,
                ],
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'outlander_language',
          label: 'Scegli un linguaggio',
          type: CharacterChoiceType.language,
          optionIds: characterLanguageIds,
          requireNewAcquisition: true,
        ),
      ],
    ),
    feature: _wandererFeature,
    tables: [
      _outlanderOrigins,
    ],
    suggestedCharacteristics: _outlanderCharacteristics,
    startingCoins: {
      'MO': 10,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: 'quarterstaff',
        catalogId: 'weapon',
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.huntingTrap,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.animalTrophy,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.travelersClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.entertainer: BackgroundDefinition(
    id: BackgroundIds.entertainer,
    name: 'Intrattenitore',
    content: RuleContent(
      id: BackgroundIds.entertainer,
      name: 'Intrattenitore',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un artista capace di entusiasmare, divertire e ispirare il proprio pubblico.',
        details:
            'Che si dedichi alla musica, alla poesia, alla danza, alla recitazione o alla comicità, vive per la propria arte e sa mantenere l’attenzione degli spettatori.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 135-136',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'entertainer',
      ),
      ownerId: BackgroundIds.entertainer,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Acrobazia',
        'Intrattenere',
      },
      toolProficiencies: {
        ToolIds.disguiseKit,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'entertainer_musical_instrument',
          label: 'Scegli lo strumento musicale conosciuto e ricevuto',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.bagpipes,
              label: 'Cornamusa',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.bagpipes,
                },
                grantedEquipmentIds: [
                  ToolIds.bagpipes,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.drum,
              label: 'Tamburo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.drum,
                },
                grantedEquipmentIds: [
                  ToolIds.drum,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dulcimer,
              label: 'Salterio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.dulcimer,
                },
                grantedEquipmentIds: [
                  ToolIds.dulcimer,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.flute,
              label: 'Flauto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.flute,
                },
                grantedEquipmentIds: [
                  ToolIds.flute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lute,
              label: 'Liuto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lute,
                },
                grantedEquipmentIds: [
                  ToolIds.lute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lyre,
              label: 'Lira',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lyre,
                },
                grantedEquipmentIds: [
                  ToolIds.lyre,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.horn,
              label: 'Corno',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.horn,
                },
                grantedEquipmentIds: [
                  ToolIds.horn,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.panFlute,
              label: 'Flauto di Pan',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.panFlute,
                },
                grantedEquipmentIds: [
                  ToolIds.panFlute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.shawm,
              label: 'Ciaramella',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.shawm,
                },
                grantedEquipmentIds: [
                  ToolIds.shawm,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.viol,
              label: 'Viola',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.viol,
                },
                grantedEquipmentIds: [
                  ToolIds.viol,
                ],
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'entertainer_admirer_token',
          label: 'Scegli il pegno ricevuto da un ammiratore',
          type: CharacterChoiceType.equipment,
          catalogId: 'equipment',
          optionIds: [
            EquipmentIds.admirerLoveLetter,
            EquipmentIds.admirerLockOfHair,
            EquipmentIds.admirerTrinket,
          ],
        ),
      ],
    ),
    feature: _byPopularDemandFeature,
    tables: [
      _entertainerArtForms,
    ],
    suggestedCharacteristics: _entertainerCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.costume,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.gladiator: BackgroundDefinition(
    id: BackgroundIds.gladiator,
    name: 'Gladiatore',
    content: RuleContent(
      id: BackgroundIds.gladiator,
      name: 'Gladiatore',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un combattente addestrato a trasformare la battaglia in uno spettacolo.',
        details:
            'È un intrattenitore specializzato nel combattimento appariscente. Può esibirsi in arene e fosse clandestine e può sostituire lo strumento musicale della dotazione con un’arma economica ma insolita.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagina 136',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'gladiator',
      ),
      ownerId: BackgroundIds.gladiator,
    ),
    parentBackgroundId: BackgroundIds.entertainer,
    effects: CharacterEffects(
      skillProficiencies: {
        'Acrobazia',
        'Intrattenere',
      },
      toolProficiencies: {
        ToolIds.disguiseKit,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'gladiator_musical_instrument_proficiency',
          label: 'Scegli lo strumento musicale in cui sei competente',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.bagpipes,
              label: 'Cornamusa',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.bagpipes,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.drum,
              label: 'Tamburo',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.drum,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dulcimer,
              label: 'Salterio',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.dulcimer,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.flute,
              label: 'Flauto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.flute,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lute,
              label: 'Liuto',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lute,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lyre,
              label: 'Lira',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.lyre,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.horn,
              label: 'Corno',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.horn,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.panFlute,
              label: 'Flauto di Pan',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.panFlute,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.shawm,
              label: 'Ciaramella',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.shawm,
                },
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.viol,
              label: 'Viola',
              effects: CharacterEffects(
                toolProficiencies: {
                  ToolIds.viol,
                },
              ),
            ),
          ],
          requireNewAcquisition: true,
        ),
        CharacterChoiceDefinition(
          id: 'gladiator_display_equipment',
          label:
              'Scegli uno strumento musicale oppure un’arma insolita economica',
          type: CharacterChoiceType.other,
          options: [
            CharacterChoiceOptionDefinition(
              id: ToolIds.bagpipes,
              label: 'Cornamusa',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.bagpipes,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.drum,
              label: 'Tamburo',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.drum,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.dulcimer,
              label: 'Salterio',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.dulcimer,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.flute,
              label: 'Flauto',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.flute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lute,
              label: 'Liuto',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.lute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.lyre,
              label: 'Lira',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.lyre,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.horn,
              label: 'Corno',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.horn,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.panFlute,
              label: 'Flauto di Pan',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.panFlute,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.shawm,
              label: 'Ciaramella',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.shawm,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: ToolIds.viol,
              label: 'Viola',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  ToolIds.viol,
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'trident',
              label: 'Tridente',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  'trident',
                ],
              ),
            ),
            CharacterChoiceOptionDefinition(
              id: 'net',
              label: 'Rete',
              effects: CharacterEffects(
                grantedEquipmentIds: [
                  'net',
                ],
              ),
            ),
          ],
        ),
        CharacterChoiceDefinition(
          id: 'gladiator_admirer_token',
          label: 'Scegli il pegno ricevuto da un ammiratore',
          type: CharacterChoiceType.equipment,
          catalogId: 'equipment',
          optionIds: [
            EquipmentIds.admirerLoveLetter,
            EquipmentIds.admirerLockOfHair,
            EquipmentIds.admirerTrinket,
          ],
        ),
      ],
    ),
    feature: _byPopularDemandFeature,
    tables: [
      _entertainerArtForms,
    ],
    suggestedCharacteristics: _entertainerCharacteristics,
    startingCoins: {
      'MO': 15,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.costume,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.sailor: BackgroundDefinition(
    id: BackgroundIds.sailor,
    name: 'Marinaio',
    content: RuleContent(
      id: BackgroundIds.sailor,
      name: 'Marinaio',
      type: RuleContentType.background,
      description: RuleDescription(
        summary: 'Ha prestato servizio per anni a bordo di un vascello.',
        details:
            'Ha affrontato burrasche, mostri degli abissi e predoni. La vita di bordo, il rapporto con la ciurma e l’orizzonte lontano hanno plasmato la sua esperienza e il suo carattere.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagine 136-137',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'sailor',
      ),
      ownerId: BackgroundIds.sailor,
    ),
    effects: CharacterEffects(
      skillProficiencies: {
        'Atletica',
        'Percezione',
      },
      toolProficiencies: {
        ToolIds.navigatorsTools,
        ToolIds.waterVehicles,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'sailor_lucky_charm',
          label: 'Scegli un portafortuna',
          type: CharacterChoiceType.equipment,
          catalogId: 'equipment',
          optionIds: [
            EquipmentIds.sailorsRabbitFoot,
            EquipmentIds.sailorsHoleyStone,
            EquipmentIds.randomTrinket,
          ],
        ),
      ],
    ),
    feature: _shipsPassageFeature,
    suggestedCharacteristics: _sailorCharacteristics,
    startingCoins: {
      'MO': 10,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: 'club',
        catalogId: 'weapon',
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.silkRope,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
  BackgroundIds.pirate: BackgroundDefinition(
    id: BackgroundIds.pirate,
    name: 'Pirata',
    content: RuleContent(
      id: BackgroundIds.pirate,
      name: 'Pirata',
      type: RuleContentType.background,
      description: RuleDescription(
        summary:
            'Un marinaio cresciuto tra scorrerie, sangue e combattimenti in mare.',
        details:
            'Ha prestato servizio agli ordini di un temibile pirata e ha imparato a sopravvivere in un mondo di squali e predoni. Le sue azioni gli hanno procurato una reputazione inquietante in numerose città portuali.',
      ),
      source: RuleSource(
        name: 'Manuale del Giocatore 2014',
        reference: 'Pagina 137',
      ),
      visual: RuleVisualIdentity(
        family: RuleVisualFamily.background,
        iconId: 'pirate',
      ),
      ownerId: BackgroundIds.pirate,
    ),
    parentBackgroundId: BackgroundIds.sailor,
    effects: CharacterEffects(
      skillProficiencies: {
        'Atletica',
        'Percezione',
      },
      toolProficiencies: {
        ToolIds.navigatorsTools,
        ToolIds.waterVehicles,
      },
      choices: [
        CharacterChoiceDefinition(
          id: 'pirate_lucky_charm',
          label: 'Scegli un portafortuna',
          type: CharacterChoiceType.equipment,
          catalogId: 'equipment',
          optionIds: [
            EquipmentIds.sailorsRabbitFoot,
            EquipmentIds.sailorsHoleyStone,
            EquipmentIds.randomTrinket,
          ],
        ),
      ],
    ),
    feature: _badReputationFeature,
    suggestedCharacteristics: _sailorCharacteristics,
    startingCoins: {
      'MO': 10,
    },
    startingEquipment: [
      BackgroundEquipmentGrant(
        itemId: 'club',
        catalogId: 'weapon',
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.silkRope,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.commonClothes,
      ),
      BackgroundEquipmentGrant(
        itemId: EquipmentIds.pouch,
      ),
    ],
  ),
};

BackgroundDefinition? backgroundDefinitionFor(String id) =>
    backgroundDefinitions[id];

Iterable<BackgroundDefinition> get mainBackgroundDefinitions =>
    backgroundDefinitions.values.where(
      (background) => !background.isVariant,
    );

Iterable<BackgroundDefinition> backgroundVariantsFor(String parentId) =>
    backgroundDefinitions.values.where(
      (background) => background.parentBackgroundId == parentId,
    );
