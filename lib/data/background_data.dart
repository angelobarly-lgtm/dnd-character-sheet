import 'character_data.dart';
import 'class_data.dart';
import 'equipment_data.dart';
import 'focus_data.dart';

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
