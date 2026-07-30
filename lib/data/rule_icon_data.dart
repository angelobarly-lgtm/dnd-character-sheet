// Catalogo semantico delle identità visuali.
//
// Gli ID sono indipendenti:
// - dal testo regolamentare;
// - dal nome visualizzato;
// - dal percorso dell'asset;
// - dalla palette.
//
// Gli asset grafici vengono risolti separatamente.
//
// IMPORTANTE:
// questo catalogo descrive soltanto l'identità visuale.
// Sottorazze, sottoclassi, capacità e altri contenuti verranno
// aggiunti sulla base delle fonti del progetto.

abstract final class RuleIconIds {
  // ==========================================================
  // FALLBACK DI CATEGORIA
  // ==========================================================

  static const classType = 'class';
  static const race = 'race';
  static const background = 'background';
  static const feat = 'feat';
  static const ability = 'ability';
  static const skill = 'skill';
  static const action = 'action';
  static const weapon = 'weapon';
  static const armor = 'armor';
  static const equipment = 'equipment';
  static const resource = 'resource';
  static const spell = 'spell';
  static const other = 'other';

  // ==========================================================
  // RAZZE
  // ==========================================================

  static const elf = 'elf';
  static const halfling = 'halfling';
  static const dwarf = 'dwarf';
  static const human = 'human';
  static const dragonborn = 'dragonborn';
  static const gnome = 'gnome';
  static const halfElf = 'half_elf';
  static const halfOrc = 'half_orc';
  static const tiefling = 'tiefling';

  /// Fallback per una razza creata dal giocatore.
  /// Ogni razza homebrew conserva comunque un proprio ID dati.
  static const customRace = 'custom_race';

  // ==========================================================
  // CLASSI
  // ==========================================================

  static const artificer = 'artificer';
  static const barbarian = 'barbarian';
  static const bard = 'bard';
  static const cleric = 'cleric';
  static const druid = 'druid';
  static const fighter = 'fighter';
  static const rogue = 'rogue';
  static const wizard = 'wizard';
  static const monk = 'monk';
  static const paladin = 'paladin';
  static const ranger = 'ranger';
  static const sorcerer = 'sorcerer';
  static const warlock = 'warlock';

  /// Fallback per una classe creata dal giocatore.
  static const customClass = 'custom_class';

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  static const acolyte = 'acolyte';
  static const guildArtisan = 'guild_artisan';
  static const charlatan = 'charlatan';
  static const criminal = 'criminal';
  static const hermit = 'hermit';
  static const folkHero = 'folk_hero';
  static const outlander = 'outlander';
  static const entertainer = 'entertainer';
  static const sailor = 'sailor';
  static const urchin = 'urchin';
  static const noble = 'noble';
  static const sage = 'sage';
  static const soldier = 'soldier';

  static const customBackground = 'custom_background';

  // ==========================================================
  // TALENTI
  // ==========================================================

  static const skilled = 'skilled';
  static const elementalAdept = 'elemental_adept';
  static const martialAdept = 'martial_adept';
  static const savageAttacker = 'savage_attacker';
  static const alert = 'alert';
  static const skulker = 'skulker';
  static const athlete = 'athlete';
  static const actor = 'actor';
  static const charger = 'charger';
  static const spellSniper = 'spell_sniper';
  static const dualWielder = 'dual_wielder';
  static const mountedCombatant = 'mounted_combatant';
  static const inspiringLeader = 'inspiring_leader';
  static const lightlyArmored = 'lightly_armored';
  static const moderatelyArmored = 'moderately_armored';
  static const heavilyArmored = 'heavily_armored';
  static const defensiveDuelist = 'defensive_duelist';
  static const crossbowExpert = 'crossbow_expert';
  static const dungeonDelver = 'dungeon_delver';
  static const lucky = 'lucky';
  static const healer = 'healer';
  static const warCaster = 'war_caster';
  static const ritualCaster = 'ritual_caster';
  static const magicInitiate = 'magic_initiate';
  static const linguist = 'linguist';
  static const grappler = 'grappler';
  static const tavernBrawler = 'tavern_brawler';
  static const weaponMaster = 'weapon_master';
  static const greatWeaponMaster = 'great_weapon_master';
  static const shieldMaster = 'shield_master';
  static const mediumArmorMaster = 'medium_armor_master';
  static const heavyArmorMaster = 'heavy_armor_master';
  static const polearmMaster = 'polearm_master';
  static const keenMind = 'keen_mind';
  static const mobile = 'mobile';
  static const observant = 'observant';
  static const resilient = 'resilient';
  static const tough = 'tough';
  static const sentinel = 'sentinel';
  static const mageSlayer = 'mage_slayer';
  static const durable = 'durable';
  static const sharpshooter = 'sharpshooter';

  /// Fallback per un talento creato dal giocatore.
  static const customFeat = 'custom_feat';

  // ==========================================================
  // CONTENUTI PILOTA GIÀ PREVISTI
  // ==========================================================

  static const ki = 'ki';
  static const flurryOfBlows = 'flurry_of_blows';
  static const patientDefense = 'patient_defense';
  static const stepOfTheWind = 'step_of_the_wind';

  static const dagger = 'dagger';
}

/// Asset effettivamente presenti nel progetto.
///
/// NON aggiungere qui un percorso finché il relativo file non esiste.
/// RuleIconGlyph utilizzerà il fallback della famiglia per gli ID
/// che non possiedono ancora un asset.
const Map<String, String> ruleIconAssets = {
  // Classi.
  RuleIconIds.monk: 'assets/icons/rules/classes/monk.png',

  // Razze.
  RuleIconIds.human: 'assets/icons/rules/races/human.png',
  RuleIconIds.elf: 'assets/icons/rules/races/elf.png',
  RuleIconIds.halfling: 'assets/icons/rules/races/halfling.png',
  RuleIconIds.dwarf: 'assets/icons/rules/races/dwarf.png',

  // Risorse.
  RuleIconIds.ki: 'assets/icons/rules/resources/ki.png',

  // Capacità.
  RuleIconIds.flurryOfBlows: 'assets/icons/rules/abilities/flurry_of_blows.png',
  RuleIconIds.patientDefense:
      'assets/icons/rules/abilities/patient_defense.png',
  RuleIconIds.stepOfTheWind:
      'assets/icons/rules/abilities/step_of_the_wind.png',

  // Armi.
  RuleIconIds.dagger: 'assets/icons/rules/weapons/dagger.png',
};

/// Risoluzione visuale dei nomi mostrati nell'interfaccia.
///
/// Queste mappe non contengono regole di gioco.
/// Collegano esclusivamente il nome del contenuto al suo iconId.

// ============================================================
// RAZZE
// ============================================================

const Map<String, String> raceIconIds = {
  'Elfo': RuleIconIds.elf,
  'Halfling': RuleIconIds.halfling,
  'Nano': RuleIconIds.dwarf,
  'Umano': RuleIconIds.human,
  'Umano Variante': RuleIconIds.human,
  'Dragonide': RuleIconIds.dragonborn,
  'Gnomo': RuleIconIds.gnome,
  'Mezzelfo': RuleIconIds.halfElf,
  'Mezzorco': RuleIconIds.halfOrc,
  'Tiefling': RuleIconIds.tiefling,
};

String raceIconIdFor(String name) =>
    raceIconIds[name] ?? RuleIconIds.customRace;

// ============================================================
// CLASSI
// ============================================================

const Map<String, String> classIconIds = {
  'Artefice': RuleIconIds.artificer,
  'Barbaro': RuleIconIds.barbarian,
  'Bardo': RuleIconIds.bard,
  'Chierico': RuleIconIds.cleric,
  'Druido': RuleIconIds.druid,
  'Guerriero': RuleIconIds.fighter,
  'Ladro': RuleIconIds.rogue,
  'Mago': RuleIconIds.wizard,
  'Monaco': RuleIconIds.monk,
  'Paladino': RuleIconIds.paladin,
  'Ranger': RuleIconIds.ranger,
  'Stregone': RuleIconIds.sorcerer,
  'Warlock': RuleIconIds.warlock,
};

String classIconIdFor(String name) =>
    classIconIds[name] ?? RuleIconIds.customClass;

// ============================================================
// BACKGROUND
// ============================================================

const Map<String, String> backgroundIconIds = {
  'Accolito': RuleIconIds.acolyte,
  'Artigiano di Gilda': RuleIconIds.guildArtisan,
  'Ciarlatano': RuleIconIds.charlatan,
  'Criminale': RuleIconIds.criminal,
  'Eremita': RuleIconIds.hermit,
  'Eroe popolare': RuleIconIds.folkHero,
  'Forestiero': RuleIconIds.outlander,
  'Intrattenitore': RuleIconIds.entertainer,
  'Marinaio': RuleIconIds.sailor,
  'Monello': RuleIconIds.urchin,
  'Nobile': RuleIconIds.noble,
  'Sapiente': RuleIconIds.sage,
  'Soldato': RuleIconIds.soldier,
};

String backgroundIconIdFor(String name) =>
    backgroundIconIds[name] ?? RuleIconIds.customBackground;

// ============================================================
// TALENTI
// ============================================================

const Map<String, String> featIconIds = {
  'Abile': RuleIconIds.skilled,
  'Adepto Elementale': RuleIconIds.elementalAdept,
  'Adepto Marziale': RuleIconIds.martialAdept,
  'Aggressore selvaggio': RuleIconIds.savageAttacker,
  'Allerta': RuleIconIds.alert,
  'Appostato': RuleIconIds.skulker,
  'Atleta': RuleIconIds.athlete,
  'Attore': RuleIconIds.actor,
  'Carica': RuleIconIds.charger,
  'Cecchino Magico': RuleIconIds.spellSniper,
  'Combattente a Due Armi': RuleIconIds.dualWielder,
  'Combattente in sella': RuleIconIds.mountedCombatant,
  'Condottiero Ispiratore': RuleIconIds.inspiringLeader,
  'Corazze Leggere': RuleIconIds.lightlyArmored,
  'Corazze Medie': RuleIconIds.moderatelyArmored,
  'Corazze Pesanti': RuleIconIds.heavilyArmored,
  'Duellante Difensivo': RuleIconIds.defensiveDuelist,
  'Esperto di Balestre': RuleIconIds.crossbowExpert,
  'Esperto di Dungeon': RuleIconIds.dungeonDelver,
  'Fortunato': RuleIconIds.lucky,
  'Guaritore': RuleIconIds.healer,
  'Incantatore da Guerra': RuleIconIds.warCaster,
  'Incantatore Rituale': RuleIconIds.ritualCaster,
  'Iniziato alla Magia': RuleIconIds.magicInitiate,
  'Linguista': RuleIconIds.linguist,
  'Lottatore': RuleIconIds.grappler,
  'Lottatore da Taverna': RuleIconIds.tavernBrawler,
  "Maestro D'armi": RuleIconIds.weaponMaster,
  "Maestro d'armi possenti": RuleIconIds.greatWeaponMaster,
  'Maestro degli scudi': RuleIconIds.shieldMaster,
  'Maestro delle Armature Medie': RuleIconIds.mediumArmorMaster,
  'Maestro delle Armature Pesanti': RuleIconIds.heavyArmorMaster,
  'Maestro delle Armi su Asta': RuleIconIds.polearmMaster,
  'Mente Acuta': RuleIconIds.keenMind,
  'Mobilità': RuleIconIds.mobile,
  'Osservatore': RuleIconIds.observant,
  'Resiliente': RuleIconIds.resilient,
  'Robusto': RuleIconIds.tough,
  'Sentinella': RuleIconIds.sentinel,
  'Sterminatore di Maghi': RuleIconIds.mageSlayer,
  'Tenace': RuleIconIds.durable,
  'Tiratore scelto': RuleIconIds.sharpshooter,
};

String featIconIdFor(String name) =>
    featIconIds[name] ?? RuleIconIds.customFeat;

/// Risoluzione visuale dei nomi mostrati nell'interfaccia.
///
/// Queste mappe non contengono regole di gioco.
/// Collegano esclusivamente il nome del contenuto al suo iconId.

// ============================================================
// RAZZE
// ============================================================
