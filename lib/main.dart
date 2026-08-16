import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/class_data.dart';
import 'data/class_registry_data.dart';
import 'data/spell_data.dart';
import 'data/glossary_data.dart';
import 'data/character_data.dart';
import 'data/background_data.dart';
import 'data/feat_data.dart';
import 'data/race_data.dart';
import 'widgets/shop_page.dart';
import 'widgets/glossary_page.dart';

import 'data/rule_icon_data.dart';

void main() => runApp(const DndApp());

const abilities = ['FOR', 'DES', 'COS', 'INT', 'SAG', 'CAR'];
const standardArray = [15, 14, 13, 12, 10, 8];
const skillAbility = <String, String>{
  'Acrobazia': 'DES',
  'Addestrare Animali': 'SAG',
  'Arcano': 'INT',
  'Atletica': 'FOR',
  'Furtività': 'DES',
  'Indagare': 'INT',
  'Inganno': 'CAR',
  'Intimidire': 'CAR',
  'Intrattenere': 'CAR',
  'Intuizione': 'SAG',
  'Medicina': 'SAG',
  'Natura': 'INT',
  'Percezione': 'SAG',
  'Persuasione': 'CAR',
  'Rapidità di Mano': 'DES',
  'Religione': 'INT',
  'Sopravvivenza': 'SAG',
  'Storia': 'INT',
};

const monkSavingThrows = {'FOR', 'DES'};

enum V06Coin { mr, ma, me, mo, mp }

class V06Wallet {
  final Map<V06Coin, int> values;
  V06Wallet([Map<V06Coin, int>? initial])
      : values = {for (final c in V06Coin.values) c: initial?[c] ?? 0};

  int get(V06Coin coin) => values[coin] ?? 0;
  void add(V06Coin coin, int amount) =>
      values[coin] = max(0, (values[coin] ?? 0) + amount);
}

class V06Resource {
  final String id;
  final String name;
  int current;
  int maximum;
  final String recovery;
  V06Resource({
    required this.id,
    required this.name,
    required this.current,
    required this.maximum,
    required this.recovery,
  });
  void spend([int amount = 1]) => current = max(0, current - amount);
  void restore([int? amount]) =>
      current = min(maximum, current + (amount ?? maximum));
}

class V06InventoryItem {
  final String id;
  String name;
  String category;
  String description;
  int quantity;
  bool equipped;
  int charges;
  int maxCharges;
  V06InventoryItem({
    required this.id,
    required this.name,
    this.category = 'Oggetto',
    this.description = '',
    this.quantity = 1,
    this.equipped = false,
    this.charges = 0,
    this.maxCharges = 0,
  });
  void changeQuantity(int delta) => quantity = max(0, quantity + delta);
}

class V06SpellcastingState {
  String ability;
  final Map<int, int> slotsMax;
  final Map<int, int> slotsCurrent;
  V06SpellcastingState({
    this.ability = '',
    Map<int, int>? slotsMax,
    Map<int, int>? slotsCurrent,
  })  : slotsMax = slotsMax ?? {},
        slotsCurrent = slotsCurrent ?? {};
  int saveDc(int proficiency, int abilityMod) => 8 + proficiency + abilityMod;
  int attackBonus(int proficiency, int abilityMod) => proficiency + abilityMod;
  void spendSlot(int level) {
    slotsCurrent[level] = max(0, (slotsCurrent[level] ?? 0) - 1);
  }
}

class V06SessionEvent {
  final String id;
  final String type;
  final String label;
  final DateTime at;
  final int? amount;
  V06SessionEvent({
    required this.id,
    required this.type,
    required this.label,
    DateTime? at,
    this.amount,
  }) : at = at ?? DateTime.now();
}

int mod(int score) => ((score - 10) / 2).floor();
String sign(int n) => n >= 0 ? '+$n' : '$n';

const monkFeaturesByLevel = <int, List<String>>{
  1: ['Difesa Senza Armatura', 'Arti Marziali'],
  2: ['Ki', 'Movimento Senza Armatura'],
  3: ['Deviare Proiettili'],
  4: ['Caduta Lenta', 'Aumento dei Punteggi di Caratteristica'],
  5: ['Attacco Extra', 'Colpo Stordente'],
  6: ['Colpi Ki Potenziati'],
  7: ['Elusione', 'Mente Lucida'],
  8: ['Aumento dei Punteggi di Caratteristica'],
  9: ['Miglioramento del Movimento Senza Armatura'],
  10: ['Purezza del Corpo'],
  12: ['Aumento dei Punteggi di Caratteristica'],
  13: ['Lingua del Sole e della Luna'],
  14: ['Anima Adamantina'],
  15: ['Corpo Senza Tempo'],
  16: ['Aumento dei Punteggi di Caratteristica'],
  18: ['Corpo Vuoto'],
  19: ['Aumento dei Punteggi di Caratteristica'],
  20: ['Perfezione Interiore'],
};

const raceDescriptions = <String, String>{
  'Umano':
      'Versatile e adattabile. Nella versione 2014 standard aumenta di 1 tutte le caratteristiche.',
  'Umano Variante':
      'Alternativa dell’umano 2014: aumenta di 1 due caratteristiche diverse, ottiene una competenza in un’abilità e un talento al 1° livello.',
  'Nano':
      'Robusto e tenace. Ottiene +2 Costituzione; la sottorazza completa i bonus razziali.',
  'Elfo':
      'Agile e longevo. Ottiene +2 Destrezza, Scurovisione, Sensi Affinati, Retaggio Fatato e Trance.',
};

const subraceDescriptions = <String, String>{
  'Nano delle Colline':
      'Nano particolarmente resistente e saggio: +1 Saggezza e robustezza nanica.',
  'Nano delle Montagne':
      'Nano abituato a una vita fisicamente impegnativa: +2 Forza e addestramento nelle armature.',
  'Elfo Alto':
      'Elfo legato allo studio e alla magia: +1 Intelligenza, addestramento con alcune armi, un trucchetto da mago e una lingua aggiuntiva.',
  'Elfo dei Boschi':
      'Elfo rapido e furtivo negli ambienti naturali: +1 Saggezza, addestramento con alcune armi, maggiore velocità e capacità di nascondersi nella natura.',
  'Drow':
      'Elfo del sottosuolo: +1 Carisma, Scurovisione superiore, sensibilità alla luce solare, magia drow e addestramento con armi drow.',
};

const backgroundInfo = <String, String>{
  'Accolito':
      'Servizio presso un tempio o una tradizione religiosa; orientato a Intuizione, Religione, lingue e contatti con la propria fede.',
  'Artigiano di Gilda':
      'Membro di una corporazione professionale; unisce competenze sociali, mestiere e legami con la gilda.',
  'Ciarlatano':
      'Esperto di identità false, raggiri e manipolazione; privilegia Inganno e Rapidità di Mano.',
  'Criminale':
      'Esperienza nel mondo criminale, furtività e contatti clandestini.',
  'Eremita':
      'Anni di isolamento dedicati a studio, contemplazione o ricerca; legato a Medicina, Religione e una scoperta personale.',
  'Eroe Popolare':
      'Persona comune divenuta simbolo della propria gente; pratica, resistente e ben accolta dalla popolazione.',
  'Forestiero':
      'Cresciuto lontano dai centri urbani; esperto di Atletica, Sopravvivenza e territori selvaggi.',
  'Intrattenitore':
      'Artista abituato al pubblico; combina Acrobazia, Intrattenere e capacità di esibirsi.',
  'Marinaio':
      'Esperienza sulle navi e in mare; Atletica, Percezione e familiarità con navigazione e imbarcazioni.',
  'Monello':
      'Cresciuto per strada; furtivo, rapido di mano e capace di muoversi nella città.',
  'Nobile':
      'Educazione privilegiata, storia, persuasione e riconoscimento sociale.',
  'Sapiente':
      'Studioso e ricercatore; Arcano, Storia, lingue e capacità di trovare informazioni.',
  'Soldato':
      'Addestramento militare, disciplina e gerarchia; Atletica, Intimidire e riconoscimento del grado.',
};

const monkSkillChoices = <String>[
  'Acrobazia',
  'Atletica',
  'Furtività',
  'Intuizione',
  'Religione',
  'Storia',
];

const backgroundSkills = <String, List<String>>{
  'Accolito': ['Intuizione', 'Religione'],
  'Artigiano di Gilda': ['Intuizione', 'Persuasione'],
  'Ciarlatano': ['Inganno', 'Rapidità di Mano'],
  'Criminale': ['Inganno', 'Furtività'],
  'Eremita': ['Medicina', 'Religione'],
  'Eroe Popolare': ['Addestrare Animali', 'Sopravvivenza'],
  'Forestiero': ['Atletica', 'Sopravvivenza'],
  'Intrattenitore': ['Acrobazia', 'Intrattenere'],
  'Marinaio': ['Atletica', 'Percezione'],
  'Monello': ['Furtività', 'Rapidità di Mano'],
  'Nobile': ['Storia', 'Persuasione'],
  'Sapiente': ['Arcano', 'Storia'],
  'Soldato': ['Atletica', 'Intimidire'],
};

List<Map<String, dynamic>> buildBackgroundStartingInventory({
  required BackgroundDefinition? background,
  Map<String, List<String>> choices = const {},
}) =>
    <Map<String, dynamic>>[
      for (final grant in background?.startingEquipment ??
          const <BackgroundEquipmentGrant>[])
        {
          'id': grant.itemId,
          'name': grant.itemId,
          'catalogId': grant.catalogId,
          'quantity': grant.quantity,
          'equipped': false,
        },
      for (final pack in background?.startingEquipmentPacks ?? const <String>[])
        {
          'id': pack,
          'name': pack,
          'catalogId': 'pack',
          'quantity': 1,
          'equipped': false,
        },
      for (final choice
          in background?.effects.choices ?? const <CharacterChoiceDefinition>[])
        if (choice.type == CharacterChoiceType.equipment)
          for (final itemId in choices[choice.id] ?? const <String>[])
            {
              'id': itemId,
              'name': itemId,
              'catalogId': choice.catalogId ?? 'equipment',
              'quantity': 1,
              'equipped': false,
            },
    ];

String classEquipmentChoiceKey(
  String classId,
  String choiceId,
) =>
    '${classId}_equipment_$choiceId';

String classEquipmentItemChoiceKey(
  String classId,
  String choiceId,
  String alternativeId,
  String itemChoiceId,
) =>
    '${classId}_equipment_${choiceId}_${alternativeId}_$itemChoiceId';

List<Map<String, dynamic>> buildClassStartingInventory({
  required CharacterClassDefinition classDefinition,
  Map<String, List<String>> choices = const {},
}) {
  final quantities = <String, int>{};

  void addGrant(
    String catalogId,
    String itemId, [
    int quantity = 1,
  ]) {
    final key = '$catalogId::$itemId';
    quantities[key] = (quantities[key] ?? 0) + quantity;
  }

  for (final grant in classDefinition.fixedStartingEquipment) {
    addGrant(grant.catalogId, grant.itemId, grant.quantity);
  }

  for (final choice in classDefinition.startingEquipmentChoices) {
    final selectedAlternatives =
        choices[classEquipmentChoiceKey(classDefinition.id, choice.id)] ??
            const <String>[];

    for (final alternativeId in selectedAlternatives) {
      final matches = choice.alternatives.where(
        (alternative) => alternative.id == alternativeId,
      );

      if (matches.isEmpty) continue;
      final alternative = matches.first;

      for (final grant in alternative.grants) {
        addGrant(grant.catalogId, grant.itemId, grant.quantity);
      }

      for (final itemChoice in alternative.itemChoices) {
        final selectedItems = choices[classEquipmentItemChoiceKey(
              classDefinition.id,
              choice.id,
              alternative.id,
              itemChoice.id,
            )] ??
            const <String>[];

        for (final itemId in selectedItems) {
          addGrant(itemChoice.catalogId, itemId);
        }
      }
    }
  }

  return [
    for (final entry in quantities.entries)
      {
        'id': entry.key.split('::').last,
        'name': entry.key.split('::').last,
        'catalogId': entry.key.split('::').first,
        'quantity': entry.value,
        'equipped': false,
      },
  ];
}

Map<String, int> buildClassResourcesAtLevel({
  required CharacterClassDefinition classDefinition,
  required int level,
  Map<String, int> abilityModifiers = const {},
}) =>
    {
      for (final resource in classDefinition.resources)
        if (level >= resource.minimumLevel &&
            !resource.isUnlimitedAtLevel(level))
          resource.id: resource.maximumAtLevel(
            level,
            abilityModifiers: abilityModifiers,
          ),
    };

Map<String, int> buildSubclassResourcesAtLevel({
  required CharacterSubclassDefinition? subclass,
  required int level,
  Map<String, int> abilityModifiers = const {},
}) {
  if (subclass == null) return const {};

  return {
    for (final resource in subclass.resources)
      if (level >= resource.minimumLevel && !resource.isUnlimitedAtLevel(level))
        resource.id: resource.maximumAtLevel(
          level,
          abilityModifiers: abilityModifiers,
        ),
  };
}

Map<String, int> buildSpellSlotsAtLevel({
  required CharacterClassDefinition classDefinition,
  required int level,
}) {
  final slots =
      classDefinition.spellcasting?.slotsAtLevel(level) ?? const <int>[];

  return {
    for (var index = 0; index < slots.length; index++)
      if (slots[index] > 0) '${index + 1}': slots[index],
  };
}

void synchronizeHeroClassProgression(
  HeroData hero, {
  required int oldLevel,
}) {
  final definition = hero.catalogClassDefinition;
  if (definition == null) return;

  final modifiers = {
    for (final ability in abilities) ability: mod(hero.scores[ability] ?? 10),
  };

  final subclass =
      hero.subclass == null ? null : definition.subclasses[hero.subclass];

  final updatedResources = Map<String, int>.from(hero.classResources);

  for (final resource in [
    ...definition.resources,
    ...?subclass?.resources,
  ]) {
    if (hero.level < resource.minimumLevel) continue;

    if (resource.isUnlimitedAtLevel(hero.level)) {
      updatedResources.remove(resource.id);
      continue;
    }

    final oldMaximum = resource.maximumAtLevel(
      oldLevel,
      abilityModifiers: modifiers,
    );
    final newMaximum = resource.maximumAtLevel(
      hero.level,
      abilityModifiers: modifiers,
    );
    final current = updatedResources[resource.id] ?? oldMaximum;

    updatedResources[resource.id] =
        (current + newMaximum - oldMaximum).clamp(0, newMaximum).toInt();
  }

  hero.classResources = updatedResources;

  if (hero.classId == ClassIds.monk) {
    hero.ki = hero.classResources['ki'] ?? 0;
  }

  final spellcasting = subclass?.spellcasting ?? definition.spellcasting;
  final oldSlots = spellcasting?.slotsAtLevel(oldLevel) ?? const <int>[];
  final newSlots = spellcasting?.slotsAtLevel(hero.level) ?? const <int>[];
  final updatedSlots = <String, int>{};

  for (var index = 0; index < newSlots.length; index++) {
    final newMaximum = newSlots[index];
    if (newMaximum <= 0) continue;

    final oldMaximum = index < oldSlots.length ? oldSlots[index] : 0;
    final current = hero.spellSlots['${index + 1}'] ?? oldMaximum;

    updatedSlots['${index + 1}'] =
        (current + newMaximum - oldMaximum).clamp(0, newMaximum).toInt();
  }

  hero.spellSlots = updatedSlots;

  hero.preparedSpellIds = {
    ...hero.preparedSpellIds,
    ...?subclass?.alwaysPreparedSpellIdsAtLevel(hero.level),
  }.toList();
}

const weaponInfo = <String, Map<String, dynamic>>{
  'Colpo senz’armi': {
    'die': 0,
    'damage': 'marziale',
    'ability': 'DES',
    'monk': true
  },
  'Bastone ferrato': {
    'die': 6,
    'versatile': 8,
    'damage': 'contundente',
    'ability': 'DES',
    'monk': true
  },
  'Pugnale': {'die': 4, 'damage': 'perforante', 'ability': 'DES', 'monk': true},
  'Spada corta': {
    'die': 6,
    'damage': 'perforante',
    'ability': 'DES',
    'monk': true
  },
  'Ascia': {'die': 6, 'damage': 'tagliente', 'ability': 'DES', 'monk': true},
  'Giavellotto': {
    'die': 6,
    'damage': 'perforante',
    'ability': 'DES',
    'monk': true
  },
  'Martello leggero': {
    'die': 4,
    'damage': 'contundente',
    'ability': 'DES',
    'monk': true
  },
  'Lancia': {
    'die': 6,
    'versatile': 8,
    'damage': 'perforante',
    'ability': 'DES',
    'monk': true
  },
};

class HeroData {
  HeroData({
    required this.name,
    required this.baseScores,
    this.level = 1,
    this.hpRolls = const [],
    this.currentHp = -1,
    this.tempHp = 0,
    this.ki = 0,
    this.classId = ClassIds.monk,
    this.classChoices = const {},
    this.classResources = const {},
    this.hitDiceUsed = 0,
    this.subclass,
    this.subclassOptionIds = const [],
    this.feat,
    this.background = 'Soldato',
    this.backgroundId,
    this.backgroundChoices = const {},
    this.playerName = '',
    this.alignment = 'Neutrale',
    this.experiencePoints = 0,
    this.personalityTraits = '',
    this.ideals = '',
    this.bonds = '',
    this.flaws = '',
    this.age = '',
    this.height = '',
    this.weight = '',
    this.eyes = '',
    this.skin = '',
    this.hair = '',
    this.appearance = '',
    this.alliesAndOrganizations = '',
    this.additionalTreasure = '',
    this.equippedWeapon = 'Colpo senz’armi',
    this.variantBonuses = const [],
    this.deathSuccess = 0,
    this.deathFail = 0,
    this.race = 'Umano',
    this.subrace,
    this.raceId,
    this.subraceId,
    this.raceChoices = const {},
    this.featChoices = const {},
    this.languages = const ['Comune'],
    this.skillProficiencies = const [],
    this.coins = const {'MR': 0, 'MA': 0, 'ME': 0, 'MO': 0, 'MP': 0},
    this.story = '',
    this.notes = '',
    this.inspiration = false,
    this.inventory = const [],
    this.spellSlots = const {},
    this.knownSpellIds = const [],
    this.preparedSpellIds = const [],
    this.spellbookSpellIds = const [],
  });

  String name;
  String race;
  String? subrace;

  /// ID stabile della razza nel dataset universale.
  ///
  /// Null identifica un salvataggio legacy non ancora migrato.
  String? raceId;

  /// ID stabile della sottorazza nel dataset universale.
  String? subraceId;

  /// Selezioni razziali persistenti.
  ///
  /// La chiave è l'ID di CharacterChoiceDefinition.
  final Map<String, List<String>> raceChoices;

  /// Selezioni interne del talento.
  ///
  /// La chiave è l'ID della CharacterChoiceDefinition del talento.
  final Map<String, List<String>> featChoices;

  Map<String, int> baseScores;
  int level, currentHp, tempHp, ki, hitDiceUsed, deathSuccess, deathFail;
  List<int> hpRolls;

  /// ID canonico della classe scelta.
  ///
  /// Un salvataggio precedente alla migrazione viene interpretato
  /// automaticamente come Monaco.
  String classId;

  /// Scelte persistenti di competenza e dotazione della classe.
  Map<String, List<String>> classChoices;

  /// Risorse correnti della classe, indicizzate tramite ID stabile.
  ///
  /// Durante la migrazione il Ki rimane anche nel campo legacy.
  Map<String, int> classResources;

  String? subclass, feat;

  /// ID stabili delle opzioni di sottoclasse scelte dal personaggio.
  ///
  /// Per esempio, per la Via dei Quattro Elementi contiene gli ID
  /// delle discipline elementali selezionate dal giocatore.
  List<String> subclassOptionIds;

  String background;
  String? backgroundId;
  Map<String, List<String>> backgroundChoices;

  String? get resolvedBackgroundId {
    if (backgroundId != null && backgroundId!.isNotEmpty) {
      return backgroundId;
    }

    for (final entry in backgroundDefinitions.entries) {
      if (entry.value.name == background) return entry.key;
    }

    return null;
  }

  BackgroundDefinition? get resolvedBackgroundDefinition {
    final id = resolvedBackgroundId;
    return id == null ? null : backgroundDefinitionFor(id);
  }

  /// Campi identificativi della scheda ufficiale del personaggio.
  String playerName;
  String alignment;
  int experiencePoints;

  /// Personalità del personaggio, separata nei quattro riquadri PHB.
  String personalityTraits;
  String ideals;
  String bonds;
  String flaws;

  /// Descrizione fisica e seconda pagina della scheda ufficiale.
  String age;
  String height;
  String weight;
  String eyes;
  String skin;
  String hair;
  String appearance;
  String alliesAndOrganizations;
  String additionalTreasure;

  String equippedWeapon;
  List<String> variantBonuses;
  List<String> languages;
  List<String> skillProficiencies;
  Map<String, int> coins;
  String story;
  String notes;
  bool inspiration;
  List<Map<String, dynamic>> inventory;
  Map<String, int> spellSlots;
  List<String> knownSpellIds;
  List<String> preparedSpellIds;
  List<String> spellbookSpellIds;

  String get resolvedRaceId {
    if (raceId != null && raceId!.isNotEmpty) {
      return raceId!;
    }

    switch (race) {
      case 'Umano Variante':
        return HumanVariantIds.variant;
      case 'Nano':
        return RaceIds.dwarf;
      case 'Elfo':
        return RaceIds.elf;
      case 'Halfling':
        return RaceIds.halfling;
      case 'Dragonide':
        return RaceIds.dragonborn;
      case 'Gnomo':
        return RaceIds.gnome;
      case 'Mezzelfo':
        return RaceIds.halfElf;
      case 'Mezzorco':
        return RaceIds.halfOrc;
      case 'Tiefling':
        return RaceIds.tiefling;
      case 'Umano':
      default:
        return RaceIds.human;
    }
  }

  String? get resolvedSubraceId {
    if (subraceId != null && subraceId!.isNotEmpty) {
      return subraceId;
    }

    switch (subrace) {
      case 'Nano delle Colline':
        return SubraceIds.hillDwarf;
      case 'Nano delle Montagne':
        return SubraceIds.mountainDwarf;
      case 'Elfo Alto':
        return SubraceIds.highElf;
      case 'Elfo dei Boschi':
        return SubraceIds.woodElf;
      case 'Drow':
        return SubraceIds.drow;
      case 'Halfling Piedelesto':
        return SubraceIds.lightfootHalfling;
      case 'Halfling Tozzo':
        return SubraceIds.stoutHalfling;
      case 'Gnomo delle Foreste':
        return SubraceIds.forestGnome;
      case 'Gnomo delle Rocce':
        return SubraceIds.rockGnome;
      default:
        return null;
    }
  }

  CharacterChoiceState get resolvedRaceChoices {
    final selections = <String, List<String>>{
      for (final entry in raceChoices.entries)
        entry.key: List<String>.from(entry.value),
    };

    // Compatibilità con i personaggi Umano Variante creati
    // prima dell'introduzione di CharacterChoiceState.
    //
    // Questi valori verranno sostituiti dagli ID reali delle choice
    // quando il creator dinamico 2C.3B sarà collegato.
    if (resolvedRaceId == HumanVariantIds.variant) {
      if (variantBonuses.isNotEmpty &&
          !selections.containsKey('human_variant_ability_bonuses')) {
        selections['human_variant_ability_bonuses'] =
            variantBonuses.take(2).toList();
      }

      if (feat != null &&
          feat!.isNotEmpty &&
          !selections.containsKey('human_variant_feat')) {
        selections['human_variant_feat'] = [feat!];
      }
    }

    return CharacterChoiceState(
      selections: selections,
    );
  }

  ResolvedRaceEffects get resolvedRaceEffects => resolveRaceEffects(
        raceId: resolvedRaceId,
        subraceId: resolvedSubraceId,
        characterLevel: level,
        choices: resolvedRaceChoices,
      );

  /// Competenze nelle abilità effettivamente possedute.
  ///
  /// Il campo persistente conserva per ora le competenze legacy
  /// provenienti da classe/background; quelle razziali sono derivate.
  CharacterEffects get resolvedBackgroundEffects =>
      resolvedBackgroundDefinition?.effects ?? const CharacterEffects();

  Set<String> backgroundSelectionsOfType(
    CharacterChoiceType type,
  ) {
    final result = <String>{};
    final definition = resolvedBackgroundDefinition;

    if (definition == null) return result;

    for (final choice in definition.effects.choices) {
      if (choice.type != type) continue;
      result.addAll(backgroundChoices[choice.id] ?? const []);
    }

    return result;
  }

  Set<String> classSelectionsOfType(
    CharacterChoiceType type,
  ) {
    final result = <String>{};
    final definition = catalogClassDefinition;

    if (definition == null) return result;

    for (final choice in definition.proficiencies.choices) {
      final mappedType = switch (choice.type) {
        ClassProficiencyChoiceType.skill => CharacterChoiceType.skill,
        ClassProficiencyChoiceType.tool => CharacterChoiceType.tool,
        ClassProficiencyChoiceType.weapon => CharacterChoiceType.weapon,
        ClassProficiencyChoiceType.armor => CharacterChoiceType.armor,
        ClassProficiencyChoiceType.language => CharacterChoiceType.language,
      };

      if (mappedType != type) continue;

      result.addAll(
        classChoices['${classId}_${choice.id}'] ?? const [],
      );
    }

    final hasStructuredSkillChoice = definition.proficiencies.choices.any(
      (choice) => choice.type == ClassProficiencyChoiceType.skill,
    );

    if (type == CharacterChoiceType.skill &&
        !hasStructuredSkillChoice &&
        definition.proficiencies.skillChoices > 0) {
      result.addAll(
        classChoices['${classId}_skill_proficiencies'] ?? const [],
      );
    }

    return result;
  }

  Set<String> get effectiveSavingThrowProficiencies => {
        ...resolvedRaceEffects.effects.savingThrowProficiencies,
        ...?resolvedFeatEffects?.effects.savingThrowProficiencies,
        ...resolvedBackgroundEffects.savingThrowProficiencies,
        ...?catalogClassDefinition?.proficiencies.savingThrows,
      };

  Set<String> get effectiveSkillProficiencies => {
        ...skillProficiencies,
        ...resolvedRaceEffects.effects.skillProficiencies,
        ...resolvedBackgroundEffects.skillProficiencies,
        ...backgroundSelectionsOfType(CharacterChoiceType.skill),
        ...classSelectionsOfType(CharacterChoiceType.skill),
      };

  /// Lingue effettivamente conosciute.
  Set<String> get effectiveLanguages => {
        ...languages,
        ...resolvedRaceEffects.effects.languages,
        ...resolvedBackgroundEffects.languages,
        ...backgroundSelectionsOfType(CharacterChoiceType.language),
        ...classSelectionsOfType(CharacterChoiceType.language),
      };

  /// Competenze nelle armi concesse da razza, background e classe.
  Set<String> get effectiveWeaponProficiencies => {
        ...resolvedRaceEffects.effects.weaponProficiencies,
        ...resolvedBackgroundEffects.weaponProficiencies,
        ...backgroundSelectionsOfType(CharacterChoiceType.weapon),
        ...classSelectionsOfType(CharacterChoiceType.weapon),
        ...?catalogClassDefinition?.proficiencies.weapons,
      };

  /// Competenze nelle armature concesse dalla razza.
  Set<String> get effectiveArmorProficiencies => {
        ...resolvedRaceEffects.effects.armorProficiencies,
        ...resolvedBackgroundEffects.armorProficiencies,
        ...backgroundSelectionsOfType(CharacterChoiceType.armor),
        ...classSelectionsOfType(CharacterChoiceType.armor),
        ...?catalogClassDefinition?.proficiencies.armor,
      };

  /// Competenze negli strumenti concesse dalla razza.
  Set<String> get effectiveToolProficiencies => {
        ...resolvedRaceEffects.effects.toolProficiencies,
        ...resolvedBackgroundEffects.toolProficiencies,
        ...backgroundSelectionsOfType(CharacterChoiceType.tool),
        ...classSelectionsOfType(CharacterChoiceType.tool),
        ...?catalogClassDefinition?.proficiencies.tools,
      };

  Set<String> get damageResistances => {
        ...resolvedRaceEffects.effects.damageResistances,
      };

  Set<String> get racialSavingThrowAdvantages => {
        ...resolvedRaceEffects.effects.savingThrowAdvantageAgainst,
      };

  Set<String> get conditionImmunities => {
        ...resolvedRaceEffects.effects.conditionImmunities,
      };

  double? get darkvisionRange => resolvedRaceEffects.effects.darkvisionRange;

  Set<String> get racialFeatureIds => {
        ...resolvedRaceEffects.effects.grantedFeatureIds,
      };

  Set<String> get racialFeatIds => {
        ...resolvedRaceEffects.effects.grantedFeatIds,
      };

  Set<String> get racialSpellIds => {
        ...resolvedRaceEffects.effects.grantedSpellIds,
      };

  Set<String> get racialCantripIds => {
        ...resolvedRaceEffects.effects.grantedCantripIds,
      };

  Set<String> get racialEquipmentIds => {
        ...resolvedRaceEffects.effects.grantedEquipmentIds,
      };

  /// Talento effettivamente concesso dalle regole strutturate.
  ///
  /// I salvataggi legacy possono ancora usare `feat`; i nuovi personaggi
  /// ricavano invece l'ID da grantedFeatIds del resolver razziale.
  String? get resolvedFeatId {
    final granted = resolvedRaceEffects.effects.grantedFeatIds;

    if (granted.isNotEmpty) {
      return granted.first;
    }

    // Compatibilità temporanea con salvataggi legacy.
    if (feat != null && feat!.isNotEmpty) {
      for (final entry in featDefinitions.entries) {
        if (entry.value.name == feat || entry.key == feat) {
          return entry.key;
        }
      }
    }

    return null;
  }

  ResolvedFeatEffects? get resolvedFeatEffects {
    final id = resolvedFeatId;
    if (id == null) return null;

    return resolveFeatEffects(
      featId: id,
      selections: featChoices,
    );
  }

  Map<String, int> get scores {
    final out = Map<String, int>.from(baseScores);

    for (final bonus in resolvedRaceEffects.effects.abilityBonuses) {
      if (out.containsKey(bonus.ability)) {
        out[bonus.ability] = out[bonus.ability]! + bonus.amount;
      }
    }

    final featEffects = resolvedFeatEffects?.effects;
    if (featEffects != null) {
      for (final bonus in featEffects.abilityBonuses) {
        if (out.containsKey(bonus.ability)) {
          out[bonus.ability] = out[bonus.ability]! + bonus.amount;
        }
      }
    }

    return out;
  }

  String get raceLabel => subrace != null ? '$race · $subrace' : race;

  /// Definizione legacy usata finché il Monaco non viene migrato.
  ClassDefinition get classDefinition =>
      classDefinitionFor('Monaco') ?? monkClass;

  CharacterClassDefinition? get catalogClassDefinition =>
      phbClassDefinitionFor(classId);

  String get resolvedClassName =>
      catalogClassDefinition?.name ??
      (classId == ClassIds.monk ? 'Monaco' : classId);

  int classResourceValue(String resourceId) {
    if (resourceId == 'ki' && classId == ClassIds.monk) {
      return ki;
    }

    return classResources[resourceId] ?? 0;
  }

  void setClassResourceValue(String resourceId, int value) {
    if (value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'La risorsa non può essere negativa.',
      );
    }

    classResources = {
      ...classResources,
      resourceId: value,
    };

    if (resourceId == 'ki' && classId == ClassIds.monk) {
      ki = value;
    }
  }

  int get hitDie => catalogClassDefinition?.hitDie ?? classDefinition.hitDie;
  int get averageHitDie => (hitDie ~/ 2) + 1;

  int get prof => V06Rules.proficiencyBonus(level);
  int get maxKi => level >= 2 ? level : 0;
  int get hitDiceAvailable => max(0, level - hitDiceUsed);
  String get martialDie => level < 5
      ? 'd4'
      : level < 11
          ? 'd6'
          : level < 17
              ? 'd8'
              : 'd10';
  int get maxHp {
    final con = mod(scores['COS']!);
    final racialHpBonus =
        resolvedRaceEffects.effects.hitPointsPerLevelBonus * level;
    final featHpBonus =
        (resolvedFeatEffects?.effects.hitPointsPerLevelBonus ?? 0) * level;

    return (max(1, hitDie + con) +
            hpRolls.fold<int>(0, (sum, gainedHp) => sum + gainedHp) +
            racialHpBonus +
            featHpBonus)
        .toInt();
  }

  int get ac =>
      10 +
      mod(scores['DES']!) +
      mod(scores['SAG']!) +
      resolvedRaceEffects.effects.armorClassBonus +
      (resolvedFeatEffects?.effects.armorClassBonus ?? 0);
  int get initiative =>
      mod(scores['DES']!) +
      resolvedRaceEffects.effects.initiativeBonus +
      (resolvedFeatEffects?.effects.initiativeBonus ?? 0);
  double get speed {
    final raceDefinition = phbRaceDefinitionFor(resolvedRaceId);

    final base = resolvedRaceEffects.effects.walkingSpeedOverride ??
        raceDefinition?.speed ??
        9.0;

    final bonus = level >= 2
        ? (level >= 18
            ? 9
            : level >= 14
                ? 7.5
                : level >= 10
                    ? 6
                    : level >= 6
                        ? 4.5
                        : 3)
        : 0;
    return (base + bonus).round() +
        resolvedRaceEffects.effects.walkingSpeedBonus +
        (resolvedFeatEffects?.effects.walkingSpeedBonus ?? 0);
  }

  List<String> get features {
    final out = <String>[];
    for (var l = 1; l <= level; l++) {
      out.addAll(
        (monkClass.featuresByLevel[l] ?? const <String>[]).where(
          (f) =>
              f != 'Aumento dei Punteggi di Caratteristica' &&
              f != 'Tradizione Monastica' &&
              f != 'Privilegio della Tradizione Monastica',
        ),
      );
      if (subclass != null) {
        out.addAll(
          monkClass.subclasses[subclass]?.featuresByLevel[l] ??
              const <String>[],
        );
      }
    }
    return out;
  }

  List<String> featuresAtLevel(int targetLevel) {
    final definition = classDefinitionFor('Monaco') ?? monkClass;
    final out = <String>[...?definition.featuresByLevel[targetLevel]];

    if (subclass != null) {
      out.addAll(
        definition.subclasses[subclass]?.featuresByLevel[targetLevel] ??
            const <String>[],
      );
    }

    return out;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'baseScores': baseScores,
        'level': level,
        'hpRolls': hpRolls,
        'currentHp': currentHp,
        'tempHp': tempHp,
        'ki': ki,
        'classId': classId,
        'classChoices': classChoices,
        'classResources': {
          ...classResources,
          if (classId == ClassIds.monk) 'ki': ki,
        },
        'hitDiceUsed': hitDiceUsed,
        'subclass': subclass,
        'subclassOptionIds': subclassOptionIds,
        'feat': feat,
        'background': background,
        'backgroundId': backgroundId,
        'backgroundChoices': backgroundChoices,
        'playerName': playerName,
        'alignment': alignment,
        'experiencePoints': experiencePoints,
        'personalityTraits': personalityTraits,
        'ideals': ideals,
        'bonds': bonds,
        'flaws': flaws,
        'age': age,
        'height': height,
        'weight': weight,
        'eyes': eyes,
        'skin': skin,
        'hair': hair,
        'appearance': appearance,
        'alliesAndOrganizations': alliesAndOrganizations,
        'additionalTreasure': additionalTreasure,
        'equippedWeapon': equippedWeapon,
        'variantBonuses': variantBonuses,
        'deathSuccess': deathSuccess,
        'deathFail': deathFail,
        'race': race,
        'subrace': subrace,
        'raceId': raceId,
        'subraceId': subraceId,
        'raceChoices': raceChoices,
        'featChoices': featChoices,
        'languages': languages,
        'skillProficiencies': skillProficiencies,
        'coins': coins,
        'story': story,
        'notes': notes,
        'inspiration': inspiration,
        'inventory': inventory,
        'spellSlots': spellSlots,
        'knownSpellIds': knownSpellIds,
        'preparedSpellIds': preparedSpellIds,
        'spellbookSpellIds': spellbookSpellIds,
      };

  factory HeroData.fromJson(Map<String, dynamic> j) => HeroData(
        name: j['name'],
        baseScores: Map<String, int>.from(j['baseScores']),
        level: (j['level'] as num?)?.toInt() ?? 1,
        hpRolls: List<int>.from(j['hpRolls'] ?? []),
        currentHp: j['currentHp'] ?? -1,
        tempHp: j['tempHp'] ?? 0,
        ki: j['ki'] ??
            ((j['classResources'] as Map?)?['ki'] as num?)?.toInt() ??
            0,
        classId: j['classId'] as String? ?? ClassIds.monk,
        classChoices:
            (j['classChoices'] as Map? ?? const {}).map<String, List<String>>(
          (key, value) => MapEntry(
            key.toString(),
            List<String>.from(value as List? ?? const []),
          ),
        ),
        classResources: Map<String, int>.from(
          j['classResources'] as Map? ?? const {},
        ),
        hitDiceUsed: j['hitDiceUsed'] ?? 0,
        subclass: j['subclass'],
        subclassOptionIds:
            List<String>.from(j['subclassOptionIds'] ?? const []),
        feat: j['feat'],
        background: j['background'] ?? 'Soldato',
        backgroundId: j['backgroundId'] as String?,
        backgroundChoices: (j['backgroundChoices'] as Map? ?? const {})
            .map<String, List<String>>(
          (key, value) => MapEntry(
            key.toString(),
            List<String>.from(value as List? ?? const []),
          ),
        ),
        playerName: j['playerName'] as String? ?? '',
        alignment: j['alignment'] as String? ?? 'Neutrale',
        experiencePoints: (j['experiencePoints'] as num?)?.toInt() ?? 0,
        personalityTraits: j['personalityTraits'] as String? ?? '',
        ideals: j['ideals'] as String? ?? '',
        bonds: j['bonds'] as String? ?? '',
        flaws: j['flaws'] as String? ?? '',
        age: j['age'] as String? ?? '',
        height: j['height'] as String? ?? '',
        weight: j['weight'] as String? ?? '',
        eyes: j['eyes'] as String? ?? '',
        skin: j['skin'] as String? ?? '',
        hair: j['hair'] as String? ?? '',
        appearance: j['appearance'] as String? ?? '',
        alliesAndOrganizations: j['alliesAndOrganizations'] as String? ?? '',
        additionalTreasure: j['additionalTreasure'] as String? ?? '',
        equippedWeapon: j['equippedWeapon'] ?? 'Colpo senz’armi',
        variantBonuses: List<String>.from(j['variantBonuses'] ?? const []),
        deathSuccess: j['deathSuccess'] ?? 0,
        deathFail: j['deathFail'] ?? 0,
        race: j['race'] ?? 'Umano',
        subrace: j['subrace'],
        raceId: j['raceId'] as String?,
        subraceId: j['subraceId'] as String?,
        raceChoices:
            (j['raceChoices'] as Map? ?? const {}).map<String, List<String>>(
          (key, value) => MapEntry(
            key.toString(),
            List<String>.from(value as List? ?? const []),
          ),
        ),
        featChoices:
            (j['featChoices'] as Map? ?? const {}).map<String, List<String>>(
          (key, value) => MapEntry(
            key.toString(),
            List<String>.from(value as List? ?? const []),
          ),
        ),
        languages: List<String>.from(j['languages'] ?? const ['Comune']),
        skillProficiencies:
            List<String>.from(j['skillProficiencies'] ?? const []),
        coins: Map<String, int>.from(
            j['coins'] ?? const {'MR': 0, 'MA': 0, 'ME': 0, 'MO': 0, 'MP': 0}),
        story: j['story'] ?? '',
        notes: j['notes'] ?? '',
        inspiration: j['inspiration'] ?? false,
        inventory: (j['inventory'] as List? ?? const [])
            .map((e) => Map<String, dynamic>.from(e))
            .toList(),
        spellSlots: Map<String, int>.from(j['spellSlots'] ?? const {}),
        knownSpellIds: List<String>.from(j['knownSpellIds'] ?? const []),
        preparedSpellIds: List<String>.from(j['preparedSpellIds'] ?? const []),
        spellbookSpellIds:
            List<String>.from(j['spellbookSpellIds'] ?? const []),
      );
}

class Store {
  static const legacyKey = 'hero_v01';
  static const heroesKey = 'heroes_v04';

  static Future<List<HeroData>> loadAll() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString(heroesKey);
    if (saved != null) {
      final decoded = jsonDecode(saved);
      if (decoded is List) {
        return decoded
            .map((e) => HeroData.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    final legacy = p.getString(legacyKey);
    if (legacy != null) {
      final hero = HeroData.fromJson(
        Map<String, dynamic>.from(jsonDecode(legacy)),
      );
      await saveAll([hero]);
      return [hero];
    }
    return [];
  }

  static Future<void> saveAll(List<HeroData> heroes) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      heroesKey,
      jsonEncode(heroes.map((h) => h.toJson()).toList()),
    );
  }

  static Future<void> save(HeroData hero) async {
    final heroes = await loadAll();
    final index = heroes.indexWhere((h) => h.name == hero.name);
    if (index >= 0) {
      heroes[index] = hero;
    } else {
      heroes.add(hero);
    }
    await saveAll(heroes);
  }

  static Future<HeroData?> load() async {
    final heroes = await loadAll();
    return heroes.isEmpty ? null : heroes.first;
  }

  static Future<void> delete(HeroData hero) async {
    final heroes = await loadAll();
    heroes.removeWhere((h) => h.name == hero.name);
    await saveAll(heroes);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(heroesKey);
    await p.remove(legacyKey);
  }
}

class V06Rules {
  static int abilityMod(int score) => (score - 10) ~/ 2;
  static int proficiencyBonus(int level) => 2 + ((max(1, level) - 1) ~/ 4);
  static int monkLevelOneHp(int constitutionScore, {int extra = 0}) =>
      8 + abilityMod(constitutionScore) + extra;
  static int monkFixedHpGain(int constitutionScore, {int extraPerLevel = 0}) =>
      5 + abilityMod(constitutionScore) + extraPerLevel;
  static int spellSaveDc(int proficiency, int castingAbilityModifier) =>
      8 + proficiency + castingAbilityModifier;
  static int spellAttackBonus(int proficiency, int castingAbilityModifier) =>
      proficiency + castingAbilityModifier;
}

class V06Quantity {
  int owned;
  int available;
  V06Quantity(this.owned, {int? available}) : available = available ?? owned;
  void consume([int amount = 1]) => available = max(0, available - amount);
  void recoverAvailable() => available = owned;
  void changeOwned(int delta) {
    owned = max(0, owned + delta);
    available = min(available, owned);
  }
}

class DndApp extends StatelessWidget {
  const DndApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'D&D Character Sheet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff7b1f1f),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff4efe3),
          cardTheme:
              const CardThemeData(margin: EdgeInsets.symmetric(vertical: 5)),
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HeroData> heroes = [];
  bool loading = true;

  static const parchment = Color(0xffeee3c7);
  static const ink = Color(0xff211d19);
  static const wine = Color(0xff6f1d1b);
  static const gold = Color(0xff9a793e);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final loaded = await Store.loadAll();
    if (!mounted) return;
    setState(() {
      heroes = loaded;
      loading = false;
    });
  }

  Future<void> _createHero() async {
    final h = await Navigator.push<HeroData>(
      context,
      MaterialPageRoute(builder: (_) => const CreatorPage()),
    );
    if (h == null) return;
    await Store.save(h);
    await _reload();
  }

  Future<void> _openHero(HeroData h) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SheetPage(hero: h)),
    );
    await Store.save(h);
    await _reload();
  }

  Future<void> _openGlossary() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const GlossaryIndexPage(),
      ),
    );
  }

  Widget _ornament() => const Row(
        children: [
          Expanded(child: Divider(color: gold, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.auto_awesome, size: 18, color: gold),
          ),
          Expanded(child: Divider(color: gold, thickness: 1)),
        ],
      );

  Widget _heroCard(HeroData h) => InkWell(
        onTap: () => _openHero(h),
        onLongPress: () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Elimina personaggio'),
              content: Text('Eliminare definitivamente ${h.name}?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('ANNULLA')),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('ELIMINA')),
              ],
            ),
          );
          if (ok == true) {
            await Store.delete(h);
            await _reload();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xfff7f0dd),
            border: Border.all(color: ink, width: 1.5),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 2),
                color: Color(0x33000000),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: ink,
                child: Text(
                  h.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xfff4ead0),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Text(
                      'Monaco ${h.level} · ${h.raceLabel}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (h.subclass != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          h.subclass!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    const Divider(height: 22),
                    Row(
                      children: [
                        Expanded(
                            child: _HomeMetric('PF',
                                '${h.currentHp < 0 ? h.maxHp : h.currentHp}/${h.maxHp}')),
                        Expanded(child: _HomeMetric('CA', '${h.ac}')),
                        Expanded(
                            child: _HomeMetric('KI', '${h.ki}/${h.maxKi}')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'TOCCA PER APRIRE LA SCHEDA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: parchment,
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfff4ecd8), Color(0xffe8d9b8)],
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 30),
                    children: [
                      const Icon(Icons.shield_outlined, size: 44, color: wine),
                      const SizedBox(height: 8),
                      const Text(
                        'CRONACHE DEGLI EROI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ink,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Text(
                        'D&D · Scheda Personaggio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff5c5144),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ornament(),
                      const SizedBox(height: 22),
                      Text(
                        heroes.isEmpty
                            ? 'INIZIA UNA NUOVA AVVENTURA'
                            : 'I TUOI PERSONAGGI',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...heroes.map(_heroCard),
                      if (heroes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(14, 10, 14, 24),
                          child: Text(
                            'Ogni leggenda comincia da un nome. Crea il tuo personaggio e prepara la sua scheda per l’avventura.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: _createHero,
                        icon: const Icon(Icons.add, color: wine),
                        label: Text(
                          heroes.isEmpty
                              ? 'CREA IL TUO PRIMO PG'
                              : 'CREA NUOVO PG',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ink,
                          backgroundColor: const Color(0xfff7f0dd),
                          side: const BorderSide(color: wine, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        key: const Key('open_glossary_button'),
                        onPressed: _openGlossary,
                        icon: const Icon(
                          Icons.menu_book_outlined,
                          color: wine,
                        ),
                        label: const Text(
                          'APRI IL GLOSSARIO',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ink,
                          backgroundColor: const Color(0xfff7f0dd),
                          side: const BorderSide(
                            color: gold,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}

class _HomeMetric extends StatelessWidget {
  const _HomeMetric(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      );
}

enum StatMethod { standard, pointBuy, dice, manual }

class FantasySection extends StatelessWidget {
  const FantasySection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xfff7f0dd),
          border: Border.all(color: const Color(0xff2b2722), width: 1.3),
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 2),
              color: Color(0x22000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xff211d19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xfff4ead0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: Color(0xffd9c8a5),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ],
        ),
      );
}

class SheetBox extends StatelessWidget {
  const SheetBox({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xfffbf6e9),
            border: Border.all(color: const Color(0xff2b2722), width: 1.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff211d19),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ],
          ),
        ),
      );
}

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});
  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final Set<String> monkSkills = {'Acrobazia', 'Intuizione'};
  final name = TextEditingController();
  StatMethod method = StatMethod.standard;
  Map<String, int?> assigned = {for (final a in abilities) a: null};
  List<List<int>> rolls = [];
  Map<String, int> manual = {for (final a in abilities) a: 8};
  String race = 'Umano';
  String? subrace;

  String raceId = RaceIds.human;
  String? subraceId;

  /// Stato universale delle scelte razziali del creator.
  final Map<String, List<String>> raceChoices = {};
  final Map<String, List<String>> backgroundChoices = {};
  final Map<String, List<String>> classChoices = {};
  final Map<String, List<String>> featChoices = {};

  String classId = ClassIds.monk;
  String? subclassId;
  String background = 'Soldato';
  String? feat;
  final Set<String> variantBonuses = {'DES', 'SAG'};

  List<CharacterClassDefinition> get creatorClassDefinitions {
    final definitions = phbClassDefinitions.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return definitions;
  }

  CharacterClassDefinition get creatorClassDefinition =>
      phbClassDefinitionFor(classId) ?? phbClassDefinitions[ClassIds.monk]!;

  List<CharacterSubclassDefinition> get creatorSubclassDefinitions {
    final definitions = creatorClassDefinition.subclasses.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return definitions;
  }

  CharacterSubclassDefinition? get creatorSubclassDefinition =>
      subclassId == null ? null : creatorClassDefinition.subclasses[subclassId];

  bool get creatorRequiresSubclassAtLevelOne =>
      creatorClassDefinition.subclassSelectionLevel == 1 &&
      creatorSubclassDefinitions.isNotEmpty;

  CharacterChoiceType classChoiceType(
    ClassProficiencyChoiceType type,
  ) =>
      switch (type) {
        ClassProficiencyChoiceType.skill => CharacterChoiceType.skill,
        ClassProficiencyChoiceType.tool => CharacterChoiceType.tool,
        ClassProficiencyChoiceType.weapon => CharacterChoiceType.weapon,
        ClassProficiencyChoiceType.armor => CharacterChoiceType.armor,
        ClassProficiencyChoiceType.language => CharacterChoiceType.language,
      };

  Set<String> creatorAcquiredIdsForClassChoice(
    CharacterChoiceType type,
  ) =>
      switch (type) {
        CharacterChoiceType.skill => {
            ...creatorResolvedRaceEffects.effects.skillProficiencies,
            ...?creatorBackgroundDefinition?.effects.skillProficiencies,
            ...backgroundSelectionsForCreator(CharacterChoiceType.skill),
          },
        CharacterChoiceType.language => {
            'Comune',
            ...creatorResolvedRaceEffects.effects.languages,
            ...?creatorBackgroundDefinition?.effects.languages,
            ...backgroundSelectionsForCreator(CharacterChoiceType.language),
          },
        CharacterChoiceType.tool => {
            ...creatorResolvedRaceEffects.effects.toolProficiencies,
            ...?creatorBackgroundDefinition?.effects.toolProficiencies,
            ...backgroundSelectionsForCreator(CharacterChoiceType.tool),
          },
        CharacterChoiceType.weapon => {
            ...creatorResolvedRaceEffects.effects.weaponProficiencies,
            ...?creatorBackgroundDefinition?.effects.weaponProficiencies,
            ...backgroundSelectionsForCreator(CharacterChoiceType.weapon),
          },
        CharacterChoiceType.armor => {
            ...creatorResolvedRaceEffects.effects.armorProficiencies,
            ...?creatorBackgroundDefinition?.effects.armorProficiencies,
            ...backgroundSelectionsForCreator(CharacterChoiceType.armor),
          },
        _ => <String>{},
      };

  Set<String> backgroundSelectionsForCreator(
    CharacterChoiceType type,
  ) {
    final result = <String>{};

    for (final choice in activeBackgroundChoices) {
      if (choice.type == type) {
        result.addAll(backgroundChoices[choice.id] ?? const []);
      }
    }

    return result;
  }

  int get creatorMaximumSpellLevel {
    final spellcasting = creatorClassDefinition.spellcasting;
    if (spellcasting == null) return 0;

    final slots = spellcasting.slotsAtLevel(1);
    var maximum = 0;

    for (var index = 0; index < slots.length; index++) {
      if (slots[index] > 0) maximum = index + 1;
    }

    final pactLevel = spellcasting.pactSlotLevelAtLevel(1);
    return pactLevel > maximum ? pactLevel : maximum;
  }

  List<String> creatorSpellIdsWhere(
    bool Function(SpellDefinition spell) accepts,
  ) {
    final spellcasting = creatorClassDefinition.spellcasting;
    if (spellcasting == null) return const [];

    final availableIds = <String>{
      ...spellcasting.spellIds,
      ...?creatorSubclassDefinition?.expandedSpellIdsAtLevel(1),
    };

    final spells = availableIds
        .map((id) => spellDefinitions[id])
        .whereType<SpellDefinition>()
        .where(accepts)
        .toList()
      ..sort(
        (a, b) => a.content.name.compareTo(b.content.name),
      );

    return spells.map((spell) => spell.id).toList();
  }

  List<CharacterChoiceDefinition> get activeInitialSpellChoices {
    final spellcasting = creatorClassDefinition.spellcasting;

    if (spellcasting == null || spellcasting.minimumLevel > 1) {
      return const [];
    }

    final choices = <CharacterChoiceDefinition>[];
    final cantrips = spellcasting.cantripsKnownAtLevel(1);

    if (cantrips > 0) {
      choices.add(
        CharacterChoiceDefinition(
          id: '${classId}_initial_cantrips',
          label: 'Trucchetti conosciuti',
          type: CharacterChoiceType.cantrip,
          minimumSelections: cantrips,
          maximumSelections: cantrips,
          optionIds: creatorSpellIdsWhere(
            (spell) => spell.level == 0,
          ),
        ),
      );
    }

    final spellbook = creatorClassDefinition.spellbook;

    if (spellbook != null) {
      choices.add(
        CharacterChoiceDefinition(
          id: '${classId}_initial_spellbook',
          label: 'Incantesimi iniziali nel libro',
          type: CharacterChoiceType.spell,
          minimumSelections: spellbook.initialSpells,
          maximumSelections: spellbook.initialSpells,
          maximumSpellLevel: spellbook.initialSpellLevel,
          optionIds: creatorSpellIdsWhere(
            (spell) =>
                spell.level > 0 && spell.level <= spellbook.initialSpellLevel,
          ),
        ),
      );
    } else {
      final known = spellcasting.spellsKnownAtLevel(1);

      if (known > 0) {
        choices.add(
          CharacterChoiceDefinition(
            id: '${classId}_initial_known_spells',
            label: 'Incantesimi conosciuti',
            type: CharacterChoiceType.spell,
            minimumSelections: known,
            maximumSelections: known,
            maximumSpellLevel: creatorMaximumSpellLevel,
            optionIds: creatorSpellIdsWhere(
              (spell) =>
                  spell.level > 0 && spell.level <= creatorMaximumSpellLevel,
            ),
          ),
        );
      }
    }

    if (spellcasting.preparesSpells) {
      final abilityModifiers = {
        for (final ability in abilities)
          ability: mod(creatorAbilityScore(ability)),
      };

      final prepared = spellcasting.preparedSpellsAtLevel(
        1,
        abilityModifiers: abilityModifiers,
      );

      if (prepared > 0) {
        final bookChoiceId = '${classId}_initial_spellbook';
        final available = spellbook == null
            ? creatorSpellIdsWhere(
                (spell) =>
                    spell.level > 0 && spell.level <= creatorMaximumSpellLevel,
              )
            : List<String>.from(
                classChoices[bookChoiceId] ?? const [],
              );

        choices.add(
          CharacterChoiceDefinition(
            id: '${classId}_initial_prepared_spells',
            label: 'Incantesimi preparati',
            type: CharacterChoiceType.spell,
            minimumSelections: prepared,
            maximumSelections: prepared,
            maximumSpellLevel: creatorMaximumSpellLevel,
            optionIds: available,
          ),
        );
      }
    }

    return choices;
  }

  List<String> get incompleteInitialSpellChoiceIds {
    final incomplete = <String>[];

    for (final choice in activeInitialSpellChoices) {
      final selected = classChoices[choice.id] ?? const <String>[];
      final containsInvalid =
          selected.any((id) => !choice.optionIds.contains(id));

      if (selected.length < choice.minimumSelections ||
          selected.length > choice.maximumSelections ||
          containsInvalid) {
        incomplete.add(choice.id);
      }
    }

    return incomplete;
  }

  List<CharacterChoiceDefinition> get activeClassProficiencyChoices {
    final proficiencies = creatorClassDefinition.proficiencies;
    final result = <CharacterChoiceDefinition>[];

    for (final choice in proficiencies.choices) {
      final type = classChoiceType(choice.type);
      final acquired = creatorAcquiredIdsForClassChoice(type);
      final options = choice.optionIds
          .where(
            (id) => !choice.requireNewAcquisition || !acquired.contains(id),
          )
          .toList()
        ..sort();

      result.add(
        CharacterChoiceDefinition(
          id: '${classId}_${choice.id}',
          label: choice.label,
          type: type,
          minimumSelections: choice.selections,
          maximumSelections: choice.selections,
          optionIds: options,
          requireNewAcquisition: choice.requireNewAcquisition,
        ),
      );
    }

    final hasStructuredSkillChoice = proficiencies.choices.any(
      (choice) => choice.type == ClassProficiencyChoiceType.skill,
    );

    if (!hasStructuredSkillChoice && proficiencies.skillChoices > 0) {
      final acquired =
          creatorAcquiredIdsForClassChoice(CharacterChoiceType.skill);
      final options = proficiencies.skillOptions
          .where((id) => !acquired.contains(id))
          .toList()
        ..sort();

      result.add(
        CharacterChoiceDefinition(
          id: '${classId}_skill_proficiencies',
          label: 'Competenze nelle abilità',
          type: CharacterChoiceType.skill,
          minimumSelections: proficiencies.skillChoices,
          maximumSelections: proficiencies.skillChoices,
          optionIds: options,
          requireNewAcquisition: true,
        ),
      );
    }

    return result;
  }

  List<String> selectedClassEquipmentAlternatives(
    ClassEquipmentChoice choice,
  ) =>
      classChoices[classEquipmentChoiceKey(classId, choice.id)] ?? const [];

  void setClassEquipmentAlternative(
    ClassEquipmentChoice choice,
    String alternativeId,
    bool selected,
  ) {
    final key = classEquipmentChoiceKey(classId, choice.id);
    final current = List<String>.from(classChoices[key] ?? const []);

    if (selected) {
      if (choice.selections == 1) {
        for (final previousId in current) {
          final prefix = '${classId}_equipment_${choice.id}_${previousId}_';
          classChoices.removeWhere(
            (storedKey, value) => storedKey.startsWith(prefix),
          );
        }

        current
          ..clear()
          ..add(alternativeId);
      } else if (!current.contains(alternativeId) &&
          current.length < choice.selections) {
        current.add(alternativeId);
      }
    } else {
      current.remove(alternativeId);
      final prefix = '${classId}_equipment_${choice.id}_${alternativeId}_';
      classChoices.removeWhere(
        (storedKey, value) => storedKey.startsWith(prefix),
      );
    }

    if (current.isEmpty) {
      classChoices.remove(key);
    } else {
      classChoices[key] = current;
    }
  }

  void setClassEquipmentItemAt(
    ClassEquipmentChoice choice,
    ClassEquipmentAlternative alternative,
    ClassEquipmentItemChoice itemChoice,
    int index,
    String itemId,
  ) {
    final key = classEquipmentItemChoiceKey(
      classId,
      choice.id,
      alternative.id,
      itemChoice.id,
    );

    final current = List<String>.from(classChoices[key] ?? const []);

    if (!itemChoice.allowDuplicates &&
        current.asMap().entries.any(
              (entry) => entry.key != index && entry.value == itemId,
            )) {
      return;
    }

    if (index < current.length) {
      current[index] = itemId;
    } else {
      while (current.length < index) {
        current.add('');
      }
      current.add(itemId);
    }

    current.removeWhere((value) => value.isEmpty);
    classChoices[key] = current;
  }

  List<String> get incompleteClassEquipmentChoiceLabels {
    final incomplete = <String>[];

    for (final choice in creatorClassDefinition.startingEquipmentChoices) {
      final alternatives = selectedClassEquipmentAlternatives(choice);

      if (alternatives.length != choice.selections) {
        incomplete.add(choice.label);
        continue;
      }

      for (final alternativeId in alternatives) {
        final matches = choice.alternatives.where(
          (alternative) => alternative.id == alternativeId,
        );

        if (matches.isEmpty) {
          incomplete.add(choice.label);
          continue;
        }

        final alternative = matches.first;

        if (!creatorCanSelectEquipmentAlternative(alternative)) {
          incomplete.add(choice.label);
          continue;
        }

        for (final itemChoice in alternative.itemChoices) {
          final selectedItems = classChoices[classEquipmentItemChoiceKey(
                classId,
                choice.id,
                alternative.id,
                itemChoice.id,
              )] ??
              const <String>[];

          final duplicatesInvalid = !itemChoice.allowDuplicates &&
              selectedItems.toSet().length != selectedItems.length;

          if (selectedItems.length != itemChoice.selections ||
              duplicatesInvalid) {
            incomplete.add(itemChoice.label);
          }
        }
      }
    }

    return incomplete.toSet().toList();
  }

  List<String> get incompleteClassChoiceIds {
    final incomplete = <String>[];

    for (final choice in activeClassProficiencyChoices) {
      final selected = classChoices[choice.id] ?? const <String>[];

      if (selected.length < choice.minimumSelections ||
          selected.length > choice.maximumSelections) {
        incomplete.add(choice.id);
      }
    }

    return incomplete;
  }

  List<RaceDefinition> get creatorRaceDefinitions => [
        ...phbRaceDefinitions.values,
        humanVariantDefinition,
      ];

  RaceDefinition get selectedRaceDefinition =>
      phbRaceDefinitionFor(raceId) ?? phbRaceDefinitions[RaceIds.human]!;

  SubraceDefinition? get selectedSubraceDefinition {
    final id = subraceId;
    if (id == null) return null;
    return selectedRaceDefinition.subraces[id];
  }

  String? get creatorSelectedFeatId {
    final selected = raceChoices['human_variant_feat'];

    if (selected == null || selected.isEmpty) {
      return null;
    }

    final id = selected.first;

    return featDefinitions.containsKey(id) ? id : null;
  }

  FeatDefinition? get creatorSelectedFeatDefinition {
    final id = creatorSelectedFeatId;
    return id == null ? null : featDefinitionFor(id);
  }

  List<CharacterChoiceDefinition> get activeFeatChoices =>
      creatorSelectedFeatDefinition?.effects.choices ??
      const <CharacterChoiceDefinition>[];

  Set<String> get creatorOwnedProficiencies {
    final raceEffects = creatorResolvedRaceEffects.effects;

    return <String>{
      ...raceEffects.skillProficiencies,
      ...raceEffects.savingThrowProficiencies,
      ...raceEffects.weaponProficiencies,
      ...raceEffects.armorProficiencies,
      ...raceEffects.toolProficiencies,
      ...?backgroundSkills[background],
      ...monkSkills,
    };
  }

  CharacterEligibilityState get creatorEligibilityState {
    return CharacterEligibilityState(
      abilityScores: {
        for (final ability in abilities) ability: creatorAbilityScore(ability),
      },
      raceId: raceId,
      proficiencies: creatorOwnedProficiencies,

      // Il creator attuale è ancora Monaco di 1° livello e non possiede
      // spellcasting di classe. Gli effetti razziali che concedono
      // cantrip/spell non equivalgono automaticamente alla feature
      // Spellcasting.
      canCastSpells: false,
    );
  }

  CharacterEligibilityResult? get creatorSelectedFeatEligibility {
    final definition = creatorSelectedFeatDefinition;

    if (definition == null) {
      return null;
    }

    return evaluateFeatEligibility(
      feat: definition,
      state: creatorEligibilityState,
    );
  }

  List<CharacterChoiceDefinition> get activeRaceChoices => [
        ...selectedRaceDefinition.effects.choices,
        if (selectedSubraceDefinition != null)
          ...selectedSubraceDefinition!.effects.choices,
      ];

  CharacterChoiceState get creatorRaceChoiceState => CharacterChoiceState(
        selections: {
          for (final entry in raceChoices.entries)
            entry.key: List<String>.from(entry.value),
        },
      );

  ResolvedRaceEffects get creatorResolvedRaceEffects => resolveRaceEffects(
        raceId: raceId,
        subraceId: subraceId,
        characterLevel: 1,
        choices: creatorRaceChoiceState,
      );

  List<CharacterChoiceOptionDefinition> structuredOptionsFor(
    CharacterChoiceDefinition choice,
  ) =>
      choice.options;

  List<String> featOptionIdsFor(
    CharacterChoiceDefinition choice,
  ) {
    if (choice.id == 'skilled_proficiencies') {
      return [
        for (final id in characterSkillIds) 'skill:$id',
        for (final id in characterToolIds) 'tool:$id',
      ];
    }

    if (choice.options.isNotEmpty) {
      return choice.options.map((option) => option.id).toList(growable: false);
    }

    if (choice.optionIds.isNotEmpty) {
      return choice.optionIds;
    }

    switch (choice.type) {
      case CharacterChoiceType.ability:
        return const ['FOR', 'DES', 'COS', 'INT', 'SAG', 'CAR'];

      case CharacterChoiceType.skill:
        return characterSkillIds;

      case CharacterChoiceType.language:
        return characterLanguageIds;

      case CharacterChoiceType.feat:
        return featDefinitions.keys.toList(growable: false);

      case CharacterChoiceType.tool:
      case CharacterChoiceType.weapon:
      case CharacterChoiceType.armor:
      case CharacterChoiceType.equipment:
      case CharacterChoiceType.spell:
      case CharacterChoiceType.cantrip:
      case CharacterChoiceType.subclass:
      case CharacterChoiceType.other:
        return const [];
    }
  }

  String featOptionLabel(
    CharacterChoiceDefinition choice,
    String id,
  ) {
    for (final option in choice.options) {
      if (option.id == id) {
        return option.label;
      }
    }

    const abilityLabels = {
      'FOR': 'Forza',
      'DES': 'Destrezza',
      'COS': 'Costituzione',
      'INT': 'Intelligenza',
      'SAG': 'Saggezza',
      'CAR': 'Carisma',
    };

    return abilityLabels[id] ?? id;
  }

  List<String> simpleOptionIdsFor(
    CharacterChoiceDefinition choice,
  ) {
    if (choice.optionIds.isNotEmpty) {
      return choice.optionIds;
    }

    switch (choice.type) {
      case CharacterChoiceType.skill:
        return characterSkillIds;

      case CharacterChoiceType.language:
        // Una choice "lingua extra" non deve proporre lingue che
        // la razza possiede già automaticamente.
        final alreadyKnown = creatorResolvedRaceEffects.effects.languages;

        return characterLanguageIds
            .where((id) => !alreadyKnown.contains(id))
            .toList();

      case CharacterChoiceType.ability:
      case CharacterChoiceType.tool:
      case CharacterChoiceType.weapon:
      case CharacterChoiceType.armor:
      case CharacterChoiceType.equipment:
      case CharacterChoiceType.feat:
        return featDefinitions.keys.toList(growable: false);

      case CharacterChoiceType.spell:
      case CharacterChoiceType.cantrip:
      case CharacterChoiceType.subclass:
      case CharacterChoiceType.other:
        return const [];
    }
  }

  bool choiceHasAvailableDomain(
    CharacterChoiceDefinition choice,
  ) =>
      choice.options.isNotEmpty || simpleOptionIdsFor(choice).isNotEmpty;

  String choiceOptionLabel(
    CharacterChoiceDefinition choice,
    String id,
  ) {
    for (final option in choice.options) {
      if (option.id == id) return option.label;
    }

    // Etichette comuni dei domini semplici già utilizzati dal progetto.
    const abilityLabels = {
      'FOR': 'Forza',
      'DES': 'Destrezza',
      'COS': 'Costituzione',
      'INT': 'Intelligenza',
      'SAG': 'Saggezza',
      'CAR': 'Carisma',
    };

    if (choice.type == CharacterChoiceType.feat) {
      return featNameFor(id);
    }

    return abilityLabels[id] ?? id;
  }

  BackgroundDefinition? get creatorBackgroundDefinition {
    for (final definition in backgroundDefinitions.values) {
      if (definition.name == background) {
        return definition;
      }
    }
    return null;
  }

  List<CharacterChoiceDefinition> get activeBackgroundChoices =>
      creatorBackgroundDefinition?.effects.choices ?? const [];

  List<String> get incompleteBackgroundChoiceIds {
    final incomplete = <String>[];

    for (final choice in activeBackgroundChoices) {
      final selected = backgroundChoices[choice.id] ?? const <String>[];

      if (selected.length < choice.minimumSelections ||
          selected.length > choice.maximumSelections) {
        incomplete.add(choice.id);
      }
    }

    return incomplete;
  }

  void clearInactiveRaceChoices() {
    final activeIds = activeRaceChoices.map((choice) => choice.id).toSet();

    raceChoices.removeWhere(
      (choiceId, _) => !activeIds.contains(choiceId),
    );
  }

  void setChoiceSelection(
    Map<String, List<String>> state,
    CharacterChoiceDefinition choice,
    String optionId,
    bool selected,
  ) {
    final current = List<String>.from(state[choice.id] ?? const []);

    if (selected) {
      if (choice.unique && current.contains(optionId)) return;

      if (choice.maximumSelections == 1) {
        current
          ..clear()
          ..add(optionId);
      } else if (current.length < choice.maximumSelections) {
        current.add(optionId);
      }
    } else {
      current.remove(optionId);
    }

    if (current.isEmpty) {
      state.remove(choice.id);
    } else {
      state[choice.id] = current;
    }
  }

  void setRaceChoiceSelection(
    CharacterChoiceDefinition choice,
    String optionId,
    bool selected,
  ) {
    setChoiceSelection(
      raceChoices,
      choice,
      optionId,
      selected,
    );
  }

  List<String> get incompleteFeatChoiceIds {
    final incomplete = <String>[];

    for (final choice in activeFeatChoices) {
      final selected = featChoices[choice.id] ?? const <String>[];

      if (selected.length < choice.minimumSelections ||
          selected.length > choice.maximumSelections) {
        incomplete.add(choice.id);
      }
    }

    return incomplete;
  }

  bool featChoiceOptionAlreadyOwned(
    CharacterChoiceDefinition choice,
    String optionId,
  ) {
    if (!choice.requireNewAcquisition) {
      return false;
    }

    String proficiencyId = optionId;

    if (optionId.startsWith('skill:')) {
      proficiencyId = optionId.substring('skill:'.length);
    } else if (optionId.startsWith('tool:')) {
      proficiencyId = optionId.substring('tool:'.length);
    }

    return creatorOwnedProficiencies.contains(proficiencyId);
  }

  Widget buildFeatChoice(
    CharacterChoiceDefinition choice,
  ) {
    final selected = featChoices[choice.id] ?? const <String>[];

    final optionIds = featOptionIdsFor(choice);

    return FantasySection(
      title: choice.label,
      subtitle: choice.minimumSelections == choice.maximumSelections
          ? 'Scegli ${choice.minimumSelections}.'
          : 'Scegli da ${choice.minimumSelections} a '
              '${choice.maximumSelections}.',
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: optionIds.map((id) {
          final isSelected = selected.contains(id);
          final alreadyOwned = featChoiceOptionAlreadyOwned(choice, id);

          return FilterChip(
            label: Text(
              alreadyOwned
                  ? '${featOptionLabel(choice, id)} · già posseduta'
                  : featOptionLabel(choice, id),
            ),
            selected: isSelected,
            onSelected: alreadyOwned
                ? null
                : (value) {
                    setState(() {
                      final current = List<String>.from(
                        featChoices[choice.id] ?? const <String>[],
                      );

                      if (value) {
                        if (!current.contains(id) &&
                            current.length < choice.maximumSelections) {
                          current.add(id);
                        }
                      } else {
                        current.remove(id);
                      }

                      if (current.isEmpty) {
                        featChoices.remove(choice.id);
                      } else {
                        featChoices[choice.id] = current;
                      }
                    });
                  },
          );
        }).toList(),
      ),
    );
  }

  Widget buildFeatEligibilityPanel(String featId) {
    final definition = featDefinitionFor(featId);

    if (definition == null) {
      return const SizedBox.shrink();
    }

    final eligibility = evaluateFeatEligibility(
      feat: definition,
      state: creatorEligibilityState,
    );

    final description = definition.content.description;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description.summary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (description.details.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(description.details),
          ],
          const SizedBox(height: 8),
          Text(
            definition.prerequisites.isEmpty
                ? 'Nessun prerequisito.'
                : eligibility.canSelect
                    ? 'Requisiti soddisfatti'
                    : 'Requisiti non soddisfatti',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (eligibility.requirements.isNotEmpty) ...[
            const SizedBox(height: 4),
            for (final result in eligibility.requirements)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      result.satisfied
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${result.label} — ${result.detail}',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget buildCharacterChoice(
    CharacterChoiceDefinition choice, {
    required Map<String, List<String>> selectionState,
    required void Function(
      CharacterChoiceDefinition choice,
      String optionId,
      bool selected,
    ) onSelectionChanged,
  }) {
    final selected = selectionState[choice.id] ?? const <String>[];

    final structured = structuredOptionsFor(choice);
    final simple = simpleOptionIdsFor(choice);

    final optionIds = structured.isNotEmpty
        ? structured.map((option) => option.id).toList()
        : simple;

    final requiredText = choice.minimumSelections == choice.maximumSelections
        ? 'Scegli ${choice.minimumSelections}'
        : 'Scegli da ${choice.minimumSelections} '
            'a ${choice.maximumSelections}';

    if (optionIds.isEmpty) {
      return Card(
        child: ListTile(
          title: Text(choice.label),
          subtitle: Text(
            '$requiredText. '
            'Il catalogo ${choice.type.name} sarà collegato '
            'nel prossimo popolamento dati.',
          ),
          trailing: const Icon(Icons.pending_outlined),
        ),
      );
    }

    if (choice.maximumSelections == 1) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                choice.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(requiredText),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: selected.isEmpty ? null : selected.first,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    onSelectionChanged(
                      choice,
                      value,
                      true,
                    );
                  });
                },
                child: Column(
                  children: [
                    for (final optionId in optionIds)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<String>(
                            value: optionId,
                            title: Text(
                              choiceOptionLabel(
                                choice,
                                optionId,
                              ),
                            ),
                          ),
                          if (choice.type == CharacterChoiceType.feat)
                            buildFeatEligibilityPanel(optionId),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$requiredText '
              '(${selected.length}/${choice.maximumSelections})',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final optionId in optionIds)
                  FilterChip(
                    label: Text(
                      choiceOptionLabel(
                        choice,
                        optionId,
                      ),
                    ),
                    selected: selected.contains(optionId),
                    onSelected: (value) {
                      setState(() {
                        onSelectionChanged(
                          choice,
                          optionId,
                          value,
                        );
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRaceChoice(CharacterChoiceDefinition choice) =>
      buildCharacterChoice(
        choice,
        selectionState: raceChoices,
        onSelectionChanged: setRaceChoiceSelection,
      );

  Set<String> get creatorAvailableProficiencyIds => {
        ...creatorResolvedRaceEffects.effects.weaponProficiencies,
        ...creatorResolvedRaceEffects.effects.armorProficiencies,
        ...creatorResolvedRaceEffects.effects.toolProficiencies,
        ...?creatorBackgroundDefinition?.effects.weaponProficiencies,
        ...?creatorBackgroundDefinition?.effects.armorProficiencies,
        ...?creatorBackgroundDefinition?.effects.toolProficiencies,
        ...creatorClassDefinition.proficiencies.weapons,
        ...creatorClassDefinition.proficiencies.armor,
        ...creatorClassDefinition.proficiencies.tools,
        ...backgroundSelectionsForCreator(CharacterChoiceType.weapon),
        ...backgroundSelectionsForCreator(CharacterChoiceType.armor),
        ...backgroundSelectionsForCreator(CharacterChoiceType.tool),
        for (final choice in activeClassProficiencyChoices)
          ...classChoices[choice.id] ?? const <String>[],
      };

  bool creatorCanSelectEquipmentAlternative(
    ClassEquipmentAlternative alternative,
  ) =>
      creatorAvailableProficiencyIds.containsAll(
        alternative.requiredProficiencyIds,
      );

  String classEquipmentItemLabel(
    String catalogId,
    String itemId,
  ) =>
      choiceOptionLabel(
        CharacterChoiceDefinition(
          id: 'equipment_label',
          label: 'Equipaggiamento',
          type: CharacterChoiceType.equipment,
          catalogId: catalogId,
          optionIds: [itemId],
        ),
        itemId,
      );

  Widget buildClassEquipmentItemChoice(
    ClassEquipmentChoice choice,
    ClassEquipmentAlternative alternative,
    ClassEquipmentItemChoice itemChoice,
  ) {
    final key = classEquipmentItemChoiceKey(
      classId,
      choice.id,
      alternative.id,
      itemChoice.id,
    );
    final selected = classChoices[key] ?? const <String>[];
    final sortedOptions = itemChoice.optionIds.toList()..sort();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            itemChoice.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          for (var index = 0; index < itemChoice.selections; index++) ...[
            Builder(
              builder: (context) {
                final current =
                    index < selected.length ? selected[index] : null;

                final available = sortedOptions
                    .where(
                      (itemId) =>
                          itemChoice.allowDuplicates ||
                          itemId == current ||
                          !selected.contains(itemId),
                    )
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('$key-$index-$current'),
                    initialValue: current,
                    decoration: InputDecoration(
                      labelText: itemChoice.selections == 1
                          ? 'Scelta'
                          : 'Scelta ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    items: [
                      for (final itemId in available)
                        DropdownMenuItem<String>(
                          value: itemId,
                          child: Text(
                            classEquipmentItemLabel(
                              itemChoice.catalogId,
                              itemId,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (itemId) {
                      if (itemId == null) return;

                      setState(() {
                        setClassEquipmentItemAt(
                          choice,
                          alternative,
                          itemChoice,
                          index,
                          itemId,
                        );
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildClassEquipmentChoice(
    ClassEquipmentChoice choice,
  ) {
    final selected = selectedClassEquipmentAlternatives(choice);

    Widget alternativeTile(
      ClassEquipmentAlternative alternative,
    ) {
      final enabled = creatorCanSelectEquipmentAlternative(alternative);

      return RadioListTile<String>(
        value: alternative.id,
        enabled: enabled,
        title: Text(alternative.label),
        subtitle:
            enabled ? null : const Text('Competenze richieste non possedute'),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              choice.label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            if (choice.selections == 1)
              RadioGroup<String>(
                groupValue: selected.isEmpty ? null : selected.first,
                onChanged: (alternativeId) {
                  if (alternativeId == null) return;

                  setState(() {
                    setClassEquipmentAlternative(
                      choice,
                      alternativeId,
                      true,
                    );
                  });
                },
                child: Column(
                  children: [
                    for (final alternative in choice.alternatives)
                      alternativeTile(alternative),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final alternative in choice.alternatives)
                    FilterChip(
                      label: Text(alternative.label),
                      selected: selected.contains(alternative.id),
                      onSelected:
                          creatorCanSelectEquipmentAlternative(alternative)
                              ? (value) {
                                  setState(() {
                                    setClassEquipmentAlternative(
                                      choice,
                                      alternative.id,
                                      value,
                                    );
                                  });
                                }
                              : null,
                    ),
                ],
              ),
            for (final alternative in choice.alternatives)
              if (selected.contains(alternative.id)) ...[
                const Divider(height: 22),
                Text(
                  alternative.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (final grant in alternative.grants)
                  Text(
                    '• ${classEquipmentItemLabel(
                      grant.catalogId,
                      grant.itemId,
                    )} ×${grant.quantity}',
                  ),
                for (final itemChoice in alternative.itemChoices)
                  buildClassEquipmentItemChoice(
                    choice,
                    alternative,
                    itemChoice,
                  ),
              ],
          ],
        ),
      ),
    );
  }

  Future<void> showInitialSpellPicker(
    CharacterChoiceDefinition choice,
  ) async {
    final temporary = List<String>.from(
      classChoices[choice.id] ?? const [],
    );
    var query = '';

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final normalizedQuery = query.trim().toLowerCase();
          final available = choice.optionIds
              .map((id) => spellDefinitions[id])
              .whereType<SpellDefinition>()
              .where(
                (spell) =>
                    normalizedQuery.isEmpty ||
                    spell.content.name.toLowerCase().contains(normalizedQuery),
              )
              .toList()
            ..sort(
              (a, b) => a.content.name.compareTo(b.content.name),
            );

          final complete = temporary.length >= choice.minimumSelections &&
              temporary.length <= choice.maximumSelections;

          return FractionallySizedBox(
            heightFactor: 0.92,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    choice.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Scelte: ${temporary.length} / '
                    '${choice.maximumSelections}',
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cerca incantesimo',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setSheetState(() => query = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: available.isEmpty
                        ? const Center(
                            child: Text(
                              'Nessun incantesimo disponibile.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: available.length,
                            itemBuilder: (context, index) {
                              final spell = available[index];
                              final selected = temporary.contains(spell.id);

                              return CheckboxListTile(
                                value: selected,
                                title: Text(spell.content.name),
                                subtitle: Text(
                                  spell.level == 0
                                      ? 'Trucchetto'
                                      : 'Livello ${spell.level}',
                                ),
                                onChanged: (value) {
                                  setSheetState(() {
                                    if (value == true) {
                                      if (!selected &&
                                          temporary.length <
                                              choice.maximumSelections) {
                                        temporary.add(spell.id);
                                      }
                                    } else {
                                      temporary.remove(spell.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: complete
                        ? () => Navigator.pop(sheetContext, true)
                        : null,
                    icon: const Icon(Icons.check),
                    label: const Text('CONFERMA SCELTE'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (confirmed != true) return;

    setState(() {
      classChoices[choice.id] = temporary;

      if (choice.id == '${classId}_initial_spellbook') {
        final preparedKey = '${classId}_initial_prepared_spells';
        final prepared = List<String>.from(
          classChoices[preparedKey] ?? const [],
        )..removeWhere(
            (spellId) => !temporary.contains(spellId),
          );

        if (prepared.isEmpty) {
          classChoices.remove(preparedKey);
        } else {
          classChoices[preparedKey] = prepared;
        }
      }
    });
  }

  Widget buildInitialSpellChoice(
    CharacterChoiceDefinition choice,
  ) {
    final selected = classChoices[choice.id] ?? const <String>[];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              choice.label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Scelte: ${selected.length} / '
              '${choice.maximumSelections}',
            ),
            const SizedBox(height: 8),
            if (selected.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final spellId in selected)
                    InputChip(
                      label: Text(
                        spellDefinitions[spellId]?.content.name ?? spellId,
                      ),
                      onDeleted: () {
                        setState(() {
                          final updated = List<String>.from(selected)
                            ..remove(spellId);

                          if (updated.isEmpty) {
                            classChoices.remove(choice.id);
                          } else {
                            classChoices[choice.id] = updated;
                          }

                          if (choice.id == '${classId}_initial_spellbook') {
                            final preparedKey =
                                '${classId}_initial_prepared_spells';
                            final prepared = List<String>.from(
                              classChoices[preparedKey] ?? const [],
                            )..remove(spellId);

                            if (prepared.isEmpty) {
                              classChoices.remove(preparedKey);
                            } else {
                              classChoices[preparedKey] = prepared;
                            }
                          }
                        });
                      },
                    ),
                ],
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: choice.optionIds.isEmpty
                  ? null
                  : () => showInitialSpellPicker(choice),
              icon: const Icon(Icons.auto_stories_outlined),
              label: Text(
                choice.optionIds.isEmpty
                    ? 'COMPLETA PRIMA IL LIBRO'
                    : 'SCEGLI DALLA LISTA UFFICIALE',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClassChoice(CharacterChoiceDefinition choice) =>
      buildCharacterChoice(
        choice,
        selectionState: classChoices,
        onSelectionChanged: (
          selectedChoice,
          optionId,
          selected,
        ) =>
            setChoiceSelection(
          classChoices,
          selectedChoice,
          optionId,
          selected,
        ),
      );

  Widget buildBackgroundChoice(CharacterChoiceDefinition choice) =>
      buildCharacterChoice(
        choice,
        selectionState: backgroundChoices,
        onSelectionChanged: (
          selectedChoice,
          optionId,
          selected,
        ) =>
            setChoiceSelection(
          backgroundChoices,
          selectedChoice,
          optionId,
          selected,
        ),
      );

  int creatorAbilityScore(String ability) {
    final int base;

    if (method == StatMethod.standard) {
      base = assigned[ability] ?? 0;
    } else {
      base = manual[ability] ?? 8;
    }

    return base + racialBonus(ability);
  }

  int racialBonus(String ability) {
    return creatorResolvedRaceEffects.effects.abilityBonuses
        .where((bonus) => bonus.ability == ability)
        .fold<int>(
          0,
          (sum, bonus) => sum + bonus.amount,
        );
  }

  String bonusText(String a) {
    final b = racialBonus(a);
    if (b == 0) return 'nessun bonus';

    final source =
        selectedSubraceDefinition?.name ?? selectedRaceDefinition.name;

    return '$source +$b';
  }

  int pointCost(int s) =>
      const {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9}[s] ?? 99;
  int get used => manual.values.fold(0, (x, y) => x + pointCost(y));

  List<int> roll4d6() {
    final r = Random();
    return List.generate(4, (_) => r.nextInt(6) + 1)..sort();
  }

  void reroll() {
    setState(() {
      rolls = List.generate(6, (_) => roll4d6());
      assigned = {for (final a in abilities) a: null};
    });
  }

  List<int> get dicePool =>
      rolls.map((d) => d.skip(1).fold(0, (a, b) => a + b)).toList();

  List<int> availablePool() {
    final src = method == StatMethod.standard ? standardArray : dicePool;
    final left = [...src];
    for (final v in assigned.values) {
      if (v != null) left.remove(v);
    }
    return left;
  }

  String methodTitle(StatMethod m) => switch (m) {
        StatMethod.standard => 'Valori standard',
        StatMethod.pointBuy => 'Acquisto punti',
        StatMethod.dice => 'Tiro 4d6',
        StatMethod.manual => 'Inserimento manuale',
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Creazione · V0.6')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Crea il personaggio',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Text(
                  'V0.6: scheda intelligente interattiva, progressione del Monaco e creazione guidata.'),
              const SizedBox(height: 14),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome del personaggio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FantasySection(
                title: 'Razza',
                subtitle:
                    'Scegli la stirpe e leggi subito bonus e tratti principali.',
                child: Column(
                  children: [
                    RadioGroup<String>(
                      groupValue: raceId,
                      onChanged: (value) {
                        if (value == null) return;

                        final definition = phbRaceDefinitionFor(value);
                        if (definition == null) return;

                        setState(() {
                          raceId = definition.id;
                          race = definition.name;

                          subraceId = null;
                          subrace = null;

                          raceChoices.clear();
                          featChoices.clear();
                        });
                      },
                      child: Column(
                        children: [
                          for (final definition in creatorRaceDefinitions)
                            RadioListTile<String>(
                              value: definition.id,
                              secondary: RuleVisualTile(
                                visual: RuleVisualIdentity(
                                  family: RuleVisualFamily.race,
                                  iconId: raceIconIdFor(definition.name),
                                ),
                              ),
                              title: Text(definition.name),
                              subtitle:
                                  Text(definition.content.description.summary),
                            ),
                        ],
                      ),
                    ),
                    if (selectedRaceDefinition.subraces.isNotEmpty) ...[
                      const Divider(),
                      Text(
                        'Sottorazza',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      RadioGroup<String>(
                        groupValue: subraceId,
                        onChanged: (value) {
                          if (value == null) return;

                          final definition =
                              selectedRaceDefinition.subraces[value];

                          if (definition == null) return;

                          setState(() {
                            subraceId = definition.id;
                            subrace = definition.name;
                            clearInactiveRaceChoices();
                          });
                        },
                        child: Column(
                          children: [
                            for (final definition
                                in selectedRaceDefinition.subraces.values)
                              RadioListTile<String>(
                                value: definition.id,
                                title: Text(definition.name),
                                subtitle: Text(
                                  definition.content.description.summary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (activeRaceChoices.isNotEmpty) ...[
                      const Divider(),
                      Text(
                        'Scelte razziali',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      for (final choice in activeRaceChoices)
                        buildRaceChoice(choice),
                      if (activeFeatChoices.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        for (final choice in activeFeatChoices)
                          buildFeatChoice(choice),
                      ],
                    ],
                  ],
                ),
              ),
              FantasySection(
                title: 'Classe',
                subtitle: 'Scegli una delle classi ufficiali del Manuale del '
                    'Giocatore 2014.',
                child: RadioGroup<String>(
                  groupValue: classId,
                  onChanged: (value) {
                    if (value == null || value == classId) return;

                    setState(() {
                      classId = value;
                      subclassId = null;
                      classChoices.clear();
                      monkSkills.clear();
                    });
                  },
                  child: Column(
                    children: [
                      for (final definition in creatorClassDefinitions)
                        RadioListTile<String>(
                          value: definition.id,
                          secondary: RuleVisualTile(
                            visual: RuleVisualIdentity(
                              family: RuleVisualFamily.classType,
                              iconId: classIconIdFor(definition.name),
                            ),
                          ),
                          title: Text(definition.name),
                          subtitle: Text(
                            'Dado Vita d${definition.hitDie}',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (creatorRequiresSubclassAtLevelOne)
                FantasySection(
                  title: 'Sottoclasse',
                  subtitle: '${creatorClassDefinition.name} sceglie la '
                      'sottoclasse al livello 1.',
                  child: RadioGroup<String>(
                    groupValue: subclassId,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        subclassId = value;
                        classChoices.removeWhere(
                          (key, value) =>
                              key.startsWith('${classId}_subclass_') ||
                              key.startsWith('${classId}_initial_'),
                        );
                      });
                    },
                    child: Column(
                      children: [
                        for (final definition in creatorSubclassDefinitions)
                          RadioListTile<String>(
                            value: definition.id,
                            title: Text(definition.name),
                            subtitle: Text(
                              definition.content.description.summary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              FantasySection(
                title: 'Background',
                subtitle: 'Il background concede automaticamente competenze, '
                    'linguaggi, monete ed equipaggiamento.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RadioGroup<String>(
                      groupValue: background,
                      onChanged: (value) {
                        if (value == null || value == background) return;

                        setState(() {
                          background = value;
                          backgroundChoices.clear();
                          classChoices.clear();
                        });
                      },
                      child: Column(
                        children: backgroundInfo.entries
                            .map(
                              (entry) => RadioListTile<String>(
                                value: entry.key,
                                secondary: RuleVisualTile(
                                  visual: RuleVisualIdentity(
                                    family: RuleVisualFamily.background,
                                    iconId: backgroundIconIdFor(entry.key),
                                  ),
                                ),
                                title: Text(entry.key),
                                subtitle: Text(entry.value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (activeBackgroundChoices.isNotEmpty) ...[
                      const Divider(height: 28),
                      const Text(
                        'SCELTE DEL BACKGROUND',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final choice in activeBackgroundChoices)
                        buildBackgroundChoice(choice),
                    ],
                  ],
                ),
              ),
              FantasySection(
                title: 'Competenze di ${creatorClassDefinition.name}',
                subtitle: 'Le competenze già concesse da razza o background '
                    'sono escluse dalle opzioni.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (activeClassProficiencyChoices.isEmpty)
                      const Text(
                        'Questa classe non richiede scelte aggiuntive.',
                      ),
                    for (final choice in activeClassProficiencyChoices)
                      buildClassChoice(choice),
                  ],
                ),
              ),
              if (creatorClassDefinition.fixedStartingEquipment.isNotEmpty ||
                  creatorClassDefinition.startingEquipmentChoices.isNotEmpty)
                FantasySection(
                  title: 'Dotazione di ${creatorClassDefinition.name}',
                  subtitle:
                      'Gli oggetti fissi vengono aggiunti automaticamente. '
                      'Completa le alternative richieste.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (creatorClassDefinition
                          .fixedStartingEquipment.isNotEmpty) ...[
                        const Text(
                          'DOTAZIONE FISSA',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final grant
                            in creatorClassDefinition.fixedStartingEquipment)
                          Text(
                            '• ${classEquipmentItemLabel(
                              grant.catalogId,
                              grant.itemId,
                            )} ×${grant.quantity}',
                          ),
                        const Divider(height: 24),
                      ],
                      for (final choice
                          in creatorClassDefinition.startingEquipmentChoices)
                        buildClassEquipmentChoice(choice),
                    ],
                  ),
                ),
              if (activeInitialSpellChoices.isNotEmpty)
                FantasySection(
                  title: 'Magia di ${creatorClassDefinition.name}',
                  subtitle: 'Scegli trucchetti, incantesimi conosciuti, '
                      'preparati o contenuti nel libro secondo la classe.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final choice in activeInitialSpellChoices)
                        buildInitialSpellChoice(choice),
                    ],
                  ),
                ),
              const Divider(height: 28),
              Text('Caratteristiche',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SegmentedButton<StatMethod>(
                segments: StatMethod.values
                    .map((m) =>
                        ButtonSegment(value: m, label: Text(methodTitle(m))))
                    .toList(),
                selected: {method},
                showSelectedIcon: false,
                onSelectionChanged: (s) {
                  final v = s.first;
                  setState(() {
                    method = v;
                    assigned = {for (final a in abilities) a: null};
                    if (v == StatMethod.pointBuy) {
                      manual = {for (final a in abilities) a: 8};
                    }
                    if (v == StatMethod.dice) reroll();
                  });
                },
              ),
              if (method == StatMethod.dice) ...[
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Tira 6 gruppi da 4d6. In ogni gruppo il dado più basso viene scartato; il totale rimasto va poi assegnato a una caratteristica.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                ...rolls.asMap().entries.map((e) {
                  final d = e.value;
                  final total = d.skip(1).fold(0, (a, b) => a + b);
                  return Card(
                    child: ListTile(
                      title: Text('Risultato ${e.key + 1}: $total',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Wrap(
                        spacing: 6,
                        children: d.asMap().entries.map((x) {
                          final discarded = x.key == 0;
                          return Chip(
                            avatar: const Icon(Icons.casino, size: 16),
                            label: Text(
                                '${x.value}${discarded ? ' · scartato' : ''}'),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: reroll,
                  icon: const Icon(Icons.casino),
                  label: const Text('TIRA DI NUOVO I 6 GRUPPI'),
                ),
              ],
              if (method == StatMethod.pointBuy)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(
                    value: min(used / 27, 1),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              if (method == StatMethod.pointBuy)
                Text('Punti spesi: $used / 27',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: used > 27 ? Colors.red : null)),
              const SizedBox(height: 8),
              ...abilities.map((a) {
                if (method == StatMethod.standard ||
                    method == StatMethod.dice) {
                  final avail = availablePool();
                  final current = assigned[a];
                  final opts = <int>{
                    ...?current == null ? null : [current],
                    ...avail
                  }.toList()
                    ..sort((x, y) => y.compareTo(x));
                  return Card(
                    child: ListTile(
                      title: Text(a,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(current == null
                          ? 'Tocca “Scegli” e assegna uno dei valori disponibili'
                          : 'Base $current  →  ${bonusText(a)}  →  ${current + racialBonus(a)}  (${sign(mod(current + racialBonus(a)))})'),
                      trailing: DropdownButton<int>(
                        value: current,
                        hint: const Text('Scegli'),
                        items: opts
                            .map((v) =>
                                DropdownMenuItem(value: v, child: Text('$v')))
                            .toList(),
                        onChanged: (v) => setState(() => assigned[a] = v),
                      ),
                    ),
                  );
                }
                final val = manual[a]!;
                return Card(
                  child: ListTile(
                    title: Text(a,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Base $val  →  ${bonusText(a)}  →  ${val + racialBonus(a)}  (${sign(mod(val + racialBonus(a)))})'),
                    leading: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        final minv = method == StatMethod.pointBuy ? 8 : 1;
                        if (val > minv) setState(() => manual[a] = val - 1);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$val',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            final maxv =
                                method == StatMethod.pointBuy ? 15 : 30;
                            if (val < maxv) setState(() => manual[a] = val + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.check),
                onPressed: () {
                  Map<String, int>? base;
                  if (method == StatMethod.standard ||
                      method == StatMethod.dice) {
                    if (assigned.values.any((v) => v == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Assegna tutti e sei i valori.')),
                      );
                      return;
                    }
                    base = {for (final a in abilities) a: assigned[a]!};
                  } else {
                    if (method == StatMethod.pointBuy && used > 27) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Hai superato i 27 punti.')),
                      );
                      return;
                    }
                    base = Map.of(manual);
                  }
                  if (selectedRaceDefinition.subraces.isNotEmpty &&
                      subraceId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scegli la sottorazza.'),
                      ),
                    );
                    return;
                  }

                  final raceResolution = creatorResolvedRaceEffects;

                  if (!raceResolution.choiceValidation.canFinalize) {
                    final missing =
                        raceResolution.choiceValidation.incompleteChoiceIds;

                    final issues = raceResolution.choiceValidation.issues;

                    final message = issues.isNotEmpty
                        ? issues.first.message
                        : missing.isNotEmpty
                            ? 'Completa tutte le scelte razziali obbligatorie.'
                            : 'Controlla le scelte razziali.';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                    return;
                  }
                  if (name.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Inserisci il nome del personaggio.')),
                    );
                    return;
                  }
                  if (creatorRequiresSubclassAtLevelOne && subclassId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scegli la sottoclasse.'),
                      ),
                    );
                    return;
                  }

                  if (incompleteInitialSpellChoiceIds.isNotEmpty) {
                    final missingLabels = activeInitialSpellChoices
                        .where(
                          (choice) => incompleteInitialSpellChoiceIds
                              .contains(choice.id),
                        )
                        .map((choice) => choice.label)
                        .join(', ');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Completa le scelte magiche: $missingLabels.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (incompleteClassEquipmentChoiceLabels.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Completa la dotazione della classe: '
                          '${incompleteClassEquipmentChoiceLabels.join(', ')}.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (incompleteClassChoiceIds.isNotEmpty) {
                    final missingLabels = activeClassProficiencyChoices
                        .where(
                          (choice) =>
                              incompleteClassChoiceIds.contains(choice.id),
                        )
                        .map((choice) => choice.label)
                        .join(', ');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Completa le scelte della classe: '
                          '$missingLabels.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (incompleteFeatChoiceIds.isNotEmpty) {
                    final missingLabels = activeFeatChoices
                        .where(
                          (choice) =>
                              incompleteFeatChoiceIds.contains(choice.id),
                        )
                        .map((choice) => choice.label)
                        .join(', ');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Completa le scelte del talento: $missingLabels.',
                        ),
                      ),
                    );
                    return;
                  }

                  final featEligibility = creatorSelectedFeatEligibility;

                  if (featEligibility?.canSelect == false) {
                    final missing = featEligibility!.requirements
                        .where((result) => !result.satisfied)
                        .map(
                          (result) => '${result.label}: ${result.detail}',
                        )
                        .join('\n');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Il talento selezionato non soddisfa '
                          'tutti i prerequisiti.\n$missing',
                        ),
                      ),
                    );
                    return;
                  }

                  if (incompleteBackgroundChoiceIds.isNotEmpty) {
                    final missingLabels = activeBackgroundChoices
                        .where(
                          (choice) => incompleteBackgroundChoiceIds.contains(
                            choice.id,
                          ),
                        )
                        .map((choice) => choice.label)
                        .join(', ');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Completa le scelte del background: '
                          '$missingLabels.',
                        ),
                      ),
                    );
                    return;
                  }

                  final selectedBackground = backgroundDefinitions.values
                      .where((definition) => definition.name == background)
                      .firstOrNull;

                  final backgroundInventory = buildBackgroundStartingInventory(
                    background: selectedBackground,
                    choices: backgroundChoices,
                  );

                  final classInventory = buildClassStartingInventory(
                    classDefinition: creatorClassDefinition,
                    choices: classChoices,
                  );

                  final initialCantrips = List<String>.from(
                    classChoices['${classId}_initial_cantrips'] ?? const [],
                  );
                  final initialKnownSpells = List<String>.from(
                    classChoices['${classId}_initial_known_spells'] ?? const [],
                  );
                  final initialSpellbook = List<String>.from(
                    classChoices['${classId}_initial_spellbook'] ?? const [],
                  );
                  final initialPreparedSpells = List<String>.from(
                    classChoices['${classId}_initial_prepared_spells'] ??
                        const [],
                  );

                  final automaticSubclassSpells = creatorSubclassDefinition
                          ?.alwaysPreparedSpellIdsAtLevel(1) ??
                      const <String>{};

                  final h = HeroData(
                    classId: classId,
                    subclass: subclassId,
                    race: race,
                    raceId: raceId,
                    subrace: subrace,
                    subraceId: subraceId,
                    raceChoices: {
                      for (final entry in raceChoices.entries)
                        entry.key: List<String>.from(entry.value),
                    },
                    featChoices: {
                      for (final entry in featChoices.entries)
                        entry.key: List<String>.from(entry.value),
                    },
                    background: background,
                    backgroundId: selectedBackground?.id,
                    backgroundChoices: {
                      for (final entry in backgroundChoices.entries)
                        entry.key: List<String>.from(entry.value),
                    },
                    classChoices: {
                      for (final entry in classChoices.entries)
                        entry.key: List<String>.from(entry.value),
                    },
                    feat: feat,
                    variantBonuses: variantBonuses.toList(),
                    name: name.text.trim(),
                    baseScores: base,
                    skillProficiencies: <String>{
                      ...?backgroundSkills[background],
                      ...?selectedBackground?.effects.skillProficiencies,
                    }.toList(),
                    languages: <String>{
                      'Comune',
                      ...?selectedBackground?.effects.languages,
                    }.toList(),
                    coins: Map<String, int>.from(
                      selectedBackground?.startingCoins ?? const {},
                    ),
                    inventory: [
                      ...backgroundInventory,
                      ...classInventory,
                    ],
                    knownSpellIds: {
                      ...initialCantrips,
                      ...initialKnownSpells,
                    }.toList(),
                    preparedSpellIds: {
                      ...initialPreparedSpells,
                      ...automaticSubclassSpells,
                    }.toList(),
                    spellbookSpellIds: initialSpellbook,
                  );

                  final abilityModifiers = {
                    for (final ability in abilities)
                      ability: mod(h.scores[ability] ?? 10),
                  };

                  h.classResources = {
                    ...buildClassResourcesAtLevel(
                      classDefinition: creatorClassDefinition,
                      level: h.level,
                      abilityModifiers: abilityModifiers,
                    ),
                    ...buildSubclassResourcesAtLevel(
                      subclass: creatorSubclassDefinition,
                      level: h.level,
                      abilityModifiers: abilityModifiers,
                    ),
                  };

                  if (h.classId == ClassIds.monk) {
                    h.ki = h.classResources['ki'] ?? 0;
                  }

                  h.spellSlots = buildSpellSlotsAtLevel(
                    classDefinition: creatorClassDefinition,
                    level: h.level,
                  );

                  h.currentHp = h.maxHp;
                  Navigator.pop(context, h);
                },
                label: const Text('CREA PERSONAGGIO'),
              ),
            ],
          ),
        ),
      );
}

class InfoTile extends StatelessWidget {
  const InfoTile(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      );
}

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.hero});
  final HeroData hero;
  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  HeroData get h => widget.hero;
  int tab = 0;

  Future<void> persist() async {
    await Store.save(h);
    if (mounted) setState(() {});
  }

  String get coinSummary => const ['MR', 'MA', 'ME', 'MO', 'MP']
      .map((coin) => '$coin ${h.coins[coin] ?? 0}')
      .join(' · ');

  Future<void> openShop() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ShopPage(
          coins: h.coins,
          inventory: h.inventory,
          onChanged: (coins, inventory) async {
            h.coins = Map<String, int>.from(coins);
            h.inventory = inventory
                .map((entry) => Map<String, dynamic>.from(entry))
                .toList();
            await Store.save(h);

            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (h.currentHp < 0) h.currentHp = h.maxHp;
  }

  List<SubclassOptionDefinition> get knownElementalDisciplines {
    final subclassName = h.subclass;
    if (subclassName == null) {
      return const <SubclassOptionDefinition>[];
    }

    final subclass = monkClass.subclasses[subclassName];
    if (subclass == null) {
      return const <SubclassOptionDefinition>[];
    }

    final knownIds = h.subclassOptionIds.toSet();

    return subclass.options
        .where(
          (option) =>
              option.category == 'disciplina_elementale' &&
              knownIds.contains(option.id) &&
              option.minimumLevel <= h.level,
        )
        .toList();
  }

  int get elementalDisciplineKiLimit {
    if (h.level >= 17) return 6;
    if (h.level >= 13) return 5;
    if (h.level >= 9) return 4;
    if (h.level >= 5) return 3;
    return 2;
  }

  int get elementalDisciplineSaveDc => 8 + h.prof + mod(h.scores['SAG']!);

  int get elementalDisciplineAttackBonus => h.prof + mod(h.scores['SAG']!);

  Future<void> useElementalDiscipline(
    SubclassOptionDefinition option,
  ) async {
    if (option.category != 'disciplina_elementale') return;

    final baseCost = option.cost ?? 0;
    var selectedCost = baseCost;

    if (option.resource == 'ki') {
      var maximumAllowed = elementalDisciplineKiLimit;

      if (option.maximumCost != null) {
        maximumAllowed = min(maximumAllowed, option.maximumCost!);
      }

      maximumAllowed = min(maximumAllowed, h.ki);

      if (baseCost > h.ki) {
        if (!mounted) return;

        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(option.name),
            content: Text(
              'Ki insufficiente.\n\n'
              'Costo minimo: $baseCost Ki\n'
              'Ki disponibile: ${h.ki}/${h.maxKi}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('CHIUDI'),
              ),
            ],
          ),
        );
        return;
      }

      if (option.allowsAdditionalResource && maximumAllowed > baseCost) {
        final chosen = await showDialog<int>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(option.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.description.summary),
                const SizedBox(height: 12),
                const Text(
                  'Quanti punti Ki vuoi spendere?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var cost = baseCost; cost <= maximumAllowed; cost++)
                      ActionChip(
                        label: Text('$cost Ki'),
                        onPressed: () => Navigator.pop(ctx, cost),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Limite per il tuo livello: '
                  '$elementalDisciplineKiLimit Ki',
                ),
                Text('Ki disponibile: ${h.ki}/${h.maxKi}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('ANNULLA'),
              ),
            ],
          ),
        );

        if (chosen == null || !mounted) return;
        selectedCost = chosen;
      }

      if (selectedCost > h.ki ||
          selectedCost > elementalDisciplineKiLimit ||
          (option.maximumCost != null && selectedCost > option.maximumCost!)) {
        return;
      }
    }

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(option.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                option.description.summary,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (option.description.details.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(option.description.details),
              ],
              const SizedBox(height: 14),
              Text('CD disciplina: $elementalDisciplineSaveDc'),
              Text(
                'Attacco con disciplina: '
                '${sign(elementalDisciplineAttackBonus)}',
              ),
              if (option.resource == 'ki') ...[
                const SizedBox(height: 8),
                Text('Costo: $selectedCost Ki'),
                Text('Ki disponibile: ${h.ki}/${h.maxKi}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ANNULLA'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              option.resource == 'ki' && selectedCost > 0
                  ? 'USA · $selectedCost KI'
                  : 'USA',
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    if (option.resource == 'ki' && selectedCost > 0) {
      setState(() {
        h.ki = max(0, h.ki - selectedCost);
      });

      await persist();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          option.resource == 'ki' && selectedCost > 0
              ? '${option.name} · -$selectedCost Ki'
              : option.name,
        ),
      ),
    );
  }

  Future<void> rollCheck(String label, int bonus) async {
    final first = Random().nextInt(20) + 1;
    final mode = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Come vuoi effettuare il tiro?'),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, 'svantaggio'),
                        child: const Text('SVANTAGGIO'))),
                const SizedBox(width: 8),
                Expanded(
                    child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, 'normale'),
                        child: const Text('NORMALE'))),
                const SizedBox(width: 8),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, 'vantaggio'),
                        child: const Text('VANTAGGIO'))),
              ]),
            ],
          ),
        ),
      ),
    );
    if (mode == null || !mounted) return;
    final second = mode == 'normale' ? null : Random().nextInt(20) + 1;
    final natural = second == null
        ? first
        : (mode == 'vantaggio' ? max(first, second) : min(first, second));
    final total = natural + bonus;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
              second == null ? '🎲 $natural' : '🎲 $first / $second → $natural',
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Modificatore ${sign(bonus)}'),
          const Divider(),
          Text('TOTALE $total', style: Theme.of(ctx).textTheme.headlineSmall),
          if (natural == 20)
            const Text('20 NATURALE!',
                style: TextStyle(fontWeight: FontWeight.bold)),
          if (natural == 1)
            const Text('1 NATURALE',
                style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('CHIUDI'))
        ],
      ),
    );
  }

  Widget statBox(String a) => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => rollCheck('Prova di $a', mod(h.scores[a]!)),
        child: Container(
          width: 104,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xfffffbef),
            border: Border.all(color: const Color(0xff7b5b2e), width: 1.4),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 3, offset: Offset(0, 2), color: Color(0x33000000))
            ],
          ),
          child: Column(
            children: [
              Text(a, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${h.scores[a]}', style: const TextStyle(fontSize: 25)),
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xffefe1bd),
                child: Text(sign(mod(h.scores[a]!)),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 3),
              const Text('TOCCA PER TIRARE', style: TextStyle(fontSize: 8)),
            ],
          ),
        ),
      );

  Future<SubclassOptionDefinition?> chooseSubclassOption({
    required SubclassDefinition subclass,
    required int level,
    required Set<String> excludedIds,
    String title = 'Scegli un’opzione',
  }) async {
    final available = subclass.options
        .where(
          (option) =>
              !option.grantedAutomatically &&
              option.minimumLevel <= level &&
              !excludedIds.contains(option.id),
        )
        .toList();

    if (available.isEmpty) return null;

    return showDialog<SubclassOptionDefinition>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: available
                .map(
                  (option) => ListTile(
                    title: Text(option.name),
                    subtitle: Text(option.description.summary),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(ctx, option),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ANNULLA'),
          ),
        ],
      ),
    );
  }

  Future<SubclassOptionDefinition?> chooseKnownSubclassOption({
    required SubclassDefinition subclass,
    required Set<String> knownIds,
    String title = 'Scegli l’opzione da sostituire',
  }) async {
    final known = subclass.options
        .where(
          (option) =>
              !option.grantedAutomatically && knownIds.contains(option.id),
        )
        .toList();

    if (known.isEmpty) return null;

    return showDialog<SubclassOptionDefinition>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: known
                .map(
                  (option) => ListTile(
                    title: Text(option.name),
                    subtitle: Text(option.description.summary),
                    trailing: const Icon(Icons.swap_horiz),
                    onTap: () => Navigator.pop(ctx, option),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ANNULLA'),
          ),
        ],
      ),
    );
  }

  Future<void> levelUp() async {
    if (h.level >= 20) return;
    final next = h.level + 1;
    final hp = await showDialog<int>(
      context: context,
      builder: (ctx) => HpDialog(
        nextLevel: next,
        conMod: mod(h.scores['COS']!),
        hitDie: h.hitDie,
      ),
    );
    if (hp == null || !mounted) return;

    String? chosenSubclass;

    final universalClass = h.catalogClassDefinition;
    final mustChooseUniversalSubclass = h.subclass == null &&
        universalClass != null &&
        (h.level + 1) == universalClass.subclassSelectionLevel &&
        universalClass.subclasses.isNotEmpty;

    if (mustChooseUniversalSubclass) {
      final definitions = universalClass.subclasses.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      final selectedSubclass = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            'Scegli la sottoclasse di ${universalClass.name}',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final definition in definitions)
                  ListTile(
                    title: Text(definition.name),
                    subtitle: Text(
                      definition.content.description.summary,
                    ),
                    onTap: () => Navigator.pop(
                      dialogContext,
                      definition.id,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      if (selectedSubclass == null) return;
      if (!mounted) return;
      chosenSubclass = selectedSubclass;
    }
    var chosenSubclassOptionIds = List<String>.from(h.subclassOptionIds);

    if (next == 3) {
      chosenSubclass = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const SubclassPage()),
      );
      if (chosenSubclass == null || !mounted) return;

      final subclassDefinition = monkClass.subclasses[chosenSubclass];

      if (subclassDefinition != null) {
        final automaticOptions = subclassDefinition.options
            .where(
              (option) =>
                  option.grantedAutomatically && option.minimumLevel <= next,
            )
            .map((option) => option.id);

        chosenSubclassOptionIds = {
          ...chosenSubclassOptionIds,
          ...automaticOptions,
        }.toList();

        final progression = subclassDefinition.optionProgression;
        final selectionsAtLevel = progression?.selectionsByLevel[next] ?? 0;

        final alreadyChosenSelectable = subclassDefinition.options
            .where(
              (option) =>
                  !option.grantedAutomatically &&
                  chosenSubclassOptionIds.contains(option.id),
            )
            .length;

        final choicesNeeded = selectionsAtLevel - alreadyChosenSelectable;

        for (var i = 0; i < choicesNeeded; i++) {
          final option = await chooseSubclassOption(
            subclass: subclassDefinition,
            level: next,
            excludedIds: chosenSubclassOptionIds.toSet(),
            title: 'Scegli una disciplina elementale',
          );

          if (option == null || !mounted) return;

          chosenSubclassOptionIds.add(option.id);
        }
      }
    } else if (h.subclass != null) {
      final subclassDefinition = monkClass.subclasses[h.subclass];
      final progression = subclassDefinition?.optionProgression;
      final selectionsAtLevel = progression?.selectionsByLevel[next];

      if (subclassDefinition != null && selectionsAtLevel != null) {
        final automaticOptions = subclassDefinition.options
            .where(
              (option) =>
                  option.grantedAutomatically && option.minimumLevel <= next,
            )
            .map((option) => option.id);

        chosenSubclassOptionIds = {
          ...chosenSubclassOptionIds,
          ...automaticOptions,
        }.toList();

        final alreadyChosenSelectable = subclassDefinition.options
            .where(
              (option) =>
                  !option.grantedAutomatically &&
                  chosenSubclassOptionIds.contains(option.id),
            )
            .length;

        final choicesNeeded = selectionsAtLevel - alreadyChosenSelectable;

        for (var i = 0; i < choicesNeeded; i++) {
          final option = await chooseSubclassOption(
            subclass: subclassDefinition,
            level: next,
            excludedIds: chosenSubclassOptionIds.toSet(),
            title: 'Scegli una nuova disciplina elementale',
          );

          if (option == null || !mounted) return;

          chosenSubclassOptionIds.add(option.id);
        }

        if (progression?.canReplaceAtLevel(next) == true) {
          final replace = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Sostituire una disciplina?'),
              content: const Text(
                'Puoi sostituire una disciplina elementale già conosciuta '
                'con un’altra disponibile al tuo livello.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('NO'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('SOSTITUISCI'),
                ),
              ],
            ),
          );

          if (!mounted) return;

          if (replace == true) {
            final oldOption = await chooseKnownSubclassOption(
              subclass: subclassDefinition,
              knownIds: chosenSubclassOptionIds.toSet(),
              title: 'Disciplina da sostituire',
            );

            if (!mounted) return;

            // Annullare questa scelta significa semplicemente
            // rinunciare alla sostituzione. Il level-up continua.
            if (oldOption != null) {
              final idsWithoutOld = Set<String>.from(chosenSubclassOptionIds)
                ..remove(oldOption.id);

              final replacement = await chooseSubclassOption(
                subclass: subclassDefinition,
                level: next,
                excludedIds: idsWithoutOld,
                title: 'Scegli la nuova disciplina',
              );

              if (!mounted) return;

              // Se viene annullata la seconda scelta, conserviamo
              // la disciplina originale e proseguiamo normalmente.
              if (replacement != null) {
                chosenSubclassOptionIds
                  ..remove(oldOption.id)
                  ..add(replacement.id);
              }
            }
          }
        }
      }
    }

    if (const [4, 8, 12, 16, 19].contains(next)) {
      final ok = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => AsiPage(hero: h)),
      );
      if (ok != true || !mounted) return;
    }

    if (chosenSubclass != null) {
      h.subclass = chosenSubclass;
    }

    h.subclassOptionIds = chosenSubclassOptionIds;
    h.hpRolls = [...h.hpRolls, hp];
    final previousClassLevel = h.level;
    h.level = next;

    synchronizeHeroClassProgression(
      h,
      oldLevel: previousClassLevel,
    );
    h.ki = h.maxKi;
    h.currentHp = h.maxHp;
    await persist();

    if (!mounted) return;
    final newFeatures = h.featuresAtLevel(next);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Monaco $next'),
        content: Text(
          newFeatures.isEmpty
              ? 'Avanzamento completato.'
              : 'Avanzamento completato.\n\nNovità del livello $next:\n• ${newFeatures.join('\n• ')}',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  void ability(String name, int cost, String desc) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.headlineSmall),
              Text(cost == 0 ? 'Nessun costo' : 'Costo: $cost Ki'),
              const SizedBox(height: 10),
              Text(desc),
              const SizedBox(height: 10),
              const Text(
                'Descrizione sintetica delle regole 5e 2014, rielaborata per l’uso nell’app.',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              ),
              if (cost > 0) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: h.ki >= cost
                        ? () {
                            setState(() => h.ki -= cost);
                            Navigator.pop(ctx);
                            Store.save(h);
                          }
                        : null,
                    child: Text(
                        h.ki >= cost ? 'USA CAPACITÀ' : 'KI INSUFFICIENTE'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void restoreAllSpellSlots() {
    final rules = h.catalogClassDefinition?.spellcasting;
    final maximumSlots = rules?.slotsAtLevel(h.level) ?? const <int>[];

    h.spellSlots = {
      for (var index = 0; index < maximumSlots.length; index++)
        if (maximumSlots[index] > 0) '${index + 1}': maximumSlots[index],
    };
  }

  Future<void> shortRest() async {
    final hitDie = h.hitDie;
    final available = h.hitDiceAvailable;
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => HitDiceDialog(
        available: available,
        hitDie: hitDie,
      ),
    );
    if (result == null) return;

    h.ki = h.maxKi;

    final spellcasting = h.catalogClassDefinition?.spellcasting;
    if ((spellcasting?.pactSlotLevelAtLevel(h.level) ?? 0) > 0) {
      restoreAllSpellSlots();
    }

    if (result > 0) {
      final con = mod(h.scores['COS']!);
      final rolls = List.generate(result, (_) => Random().nextInt(hitDie) + 1);
      final heal = rolls.fold(0, (sum, roll) => sum + max(0, roll + con));
      h.hitDiceUsed += result;
      h.currentHp = min(h.maxHp, h.currentHp + heal);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '🎲 ${rolls.join(', ')} · COS ${sign(con)} per dado · recuperi $heal PF'),
          ),
        );
      }
    }
    await persist();
  }

  Future<void> longRest() async {
    h.ki = h.maxKi;
    restoreAllSpellSlots();
    h.currentHp = h.maxHp;
    h.tempHp = 0;
    h.deathFail = 0;
    h.deathSuccess = 0;
    final recover = max(1, h.level ~/ 2);
    h.hitDiceUsed = max(0, h.hitDiceUsed - recover);
    await persist();
  }

  Future<void> editOfficialSheetField({
    required String title,
    required String value,
    required ValueChanged<String> onSaved,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) async {
    var draft = value;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextFormField(
          initialValue: value,
          onChanged: (next) => draft = next,
          autofocus: true,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ANNULLA'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, draft),
            child: const Text('SALVA'),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return;

    onSaved(result.trim());
    await persist();
  }

  Widget sheetTab() {
    const ink = Color(0xff171717);
    const paper = Color(0xffeee9dc);
    const panel = Color(0xfffffdf7);
    const accent = Color(0xff8b1f1f);
    const muted = Color(0xff5d5a54);

    final effectiveSkills = h.effectiveSkillProficiencies;
    final savingThrowProficiencies = <String>{
      ...monkSavingThrows,
      ...h.effectiveSavingThrowProficiencies,
      if (h.classId == ClassIds.monk && h.level >= 14) ...abilities,
    };

    final passivePerception = 10 +
        mod(h.scores['SAG']!) +
        (effectiveSkills.contains('Percezione') ? h.prof : 0);

    Widget officialLabel(String label) => Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: ink,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.75,
          ),
        );

    Widget officialPanel({
      required String title,
      required Widget child,
      EdgeInsets padding = const EdgeInsets.fromLTRB(12, 14, 12, 12),
      Key? key,
    }) =>
        Container(
          key: key,
          padding: padding,
          decoration: BoxDecoration(
            color: panel,
            border: Border.all(color: ink, width: 1.7),
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                left: 7,
                top: -21,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: panel,
                  child: officialLabel(title),
                ),
              ),
            ],
          ),
        );

    Widget identityCell({
      required String label,
      required String value,
      VoidCallback? onTap,
    }) {
      final content = Container(
        constraints: const BoxConstraints(minHeight: 50),
        padding: const EdgeInsets.fromLTRB(8, 7, 8, 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ink, width: 1.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    value.trim().isEmpty ? '—' : value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: muted,
                  ),
              ],
            ),
            const SizedBox(height: 3),
            officialLabel(label),
          ],
        ),
      );

      if (onTap == null) return content;

      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    Widget fold({
      required String title,
      required IconData icon,
      required List<Widget> children,
      bool initiallyExpanded = false,
      Key? key,
    }) =>
        Container(
          key: key,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: ink, width: 1.6),
            borderRadius: BorderRadius.circular(7),
          ),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            maintainState: true,
            iconColor: accent,
            collapsedIconColor: ink,
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: Icon(icon, color: ink),
            title: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            children: children,
          ),
        );

    Widget abilityBox(String ability, double width) {
      final score = h.scores[ability]!;
      final modifier = mod(score);

      return InkWell(
        onTap: () => rollCheck('Prova di $ability', modifier),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: width,
          height: 124,
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          decoration: BoxDecoration(
            color: panel,
            border: Border.all(color: ink, width: 1.8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              officialLabel(ability),
              const SizedBox(height: 3),
              Text(
                sign(modifier),
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Container(
                width: 45,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: panel,
                  border: Border.all(color: ink, width: 1.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Icon(Icons.casino_outlined, size: 13),
            ],
          ),
        ),
      );
    }

    Widget saveRow(String ability) {
      final proficient = savingThrowProficiencies.contains(ability);
      final bonus = mod(h.scores[ability]!) + (proficient ? h.prof : 0);

      return InkWell(
        onTap: () => rollCheck('Tiro salvezza $ability', bonus),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                proficient ? Icons.circle : Icons.circle_outlined,
                size: 14,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 35,
                child: Text(
                  sign(bonus),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Expanded(child: Text(ability)),
              const Icon(Icons.casino_outlined, size: 16),
            ],
          ),
        ),
      );
    }

    Widget skillRow(MapEntry<String, String> entry) {
      final proficient = effectiveSkills.contains(entry.key);
      final bonus = mod(h.scores[entry.value]!) + (proficient ? h.prof : 0);

      return InkWell(
        onTap: () => rollCheck(entry.key, bonus),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                proficient ? Icons.circle : Icons.circle_outlined,
                size: 13,
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: 34,
                child: Text(
                  sign(bonus),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text(
                entry.value,
                style: const TextStyle(
                  color: muted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.casino_outlined, size: 14),
            ],
          ),
        ),
      );
    }

    Widget deathDots({
      required String label,
      required int value,
      required ValueChanged<int> onChanged,
      required String keyPrefix,
    }) =>
        Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...List.generate(3, (index) {
              final number = index + 1;

              return IconButton(
                key: Key('${keyPrefix}_$number'),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 34,
                  minHeight: 34,
                ),
                onPressed: () {
                  onChanged(value == number ? number - 1 : number);
                },
                icon: Icon(
                  number <= value ? Icons.circle : Icons.circle_outlined,
                  size: 20,
                  color: keyPrefix.contains('success')
                      ? const Color(0xff245c35)
                      : accent,
                ),
              );
            }),
          ],
        );

    Widget editableNarrative({
      required String label,
      required String value,
      required ValueChanged<String> onSaved,
      int maxLines = 4,
    }) =>
        InkWell(
          onTap: () => editOfficialSheetField(
            title: label,
            value: value,
            maxLines: maxLines,
            onSaved: onSaved,
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: panel,
              border: Border.all(color: ink, width: 1.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: officialLabel(label)),
                    const Icon(Icons.edit_outlined, size: 15),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  value.trim().isEmpty ? 'Tocca per compilare' : value,
                  style: TextStyle(
                    color: value.trim().isEmpty ? muted : ink,
                    fontStyle: value.trim().isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        );

    Widget combatSummary() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 104),
                decoration: BoxDecoration(
                  color: panel,
                  border: Border.all(color: ink, width: 2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    officialLabel('Classe Armatura'),
                    const SizedBox(height: 5),
                    Text(
                      '${h.ac}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'CA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => rollCheck('Iniziativa', h.initiative),
                child: officialPanel(
                  title: 'Iniziativa',
                  padding: const EdgeInsets.fromLTRB(6, 18, 6, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sign(h.initiative),
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.casino_outlined, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: officialPanel(
                title: 'Velocità',
                padding: const EdgeInsets.fromLTRB(6, 18, 6, 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${h.speed}',
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'METRI',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

    Widget hitPointsPanel() => officialPanel(
          key: const Key('official_hit_points_panel'),
          title: 'Punti Ferita',
          child: Column(
            children: [
              Text(
                'Massimo dei Punti Ferita: ${h.maxHp}',
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    key: const Key('official_hp_minus'),
                    tooltip: 'Subisci 1 danno',
                    onPressed: () {
                      h.currentHp = max(0, h.currentHp - 1);
                      persist();
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Column(
                    children: [
                      Text(
                        '${h.currentHp}',
                        style: const TextStyle(
                          fontSize: 39,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      officialLabel('Attuali'),
                    ],
                  ),
                  IconButton(
                    key: const Key('official_hp_plus'),
                    tooltip: 'Recupera 1 Punto Ferita',
                    onPressed: () {
                      h.currentHp = min(h.maxHp, h.currentHp + 1);
                      persist();
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const Divider(color: ink),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        officialLabel('PF temporanei'),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                h.tempHp = max(0, h.tempHp - 1);
                                persist();
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 20,
                              ),
                            ),
                            Text(
                              '${h.tempHp}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                h.tempHp++;
                                persist();
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 65, color: ink),
                  Expanded(
                    child: Column(
                      children: [
                        officialLabel('Dadi Vita'),
                        const SizedBox(height: 5),
                        Text(
                          '${h.hitDiceAvailable}/${h.level}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text('d${h.hitDie}'),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: ink),
              officialLabel('Tiri salvezza contro morte'),
              deathDots(
                label: 'Successi',
                value: h.deathSuccess,
                keyPrefix: 'official_death_success',
                onChanged: (value) {
                  h.deathSuccess = value;
                  persist();
                },
              ),
              deathDots(
                label: 'Fallimenti',
                value: h.deathFail,
                keyPrefix: 'official_death_failure',
                onChanged: (value) {
                  h.deathFail = value;
                  persist();
                },
              ),
            ],
          ),
        );

    Widget attacksPanel() {
      final name = h.equippedWeapon;
      final data = weaponInfo[name];
      final ability = '${data?['ability'] ?? 'DES'}';
      final damageBonus = mod(h.scores[ability] ?? 10);
      final damage =
          '1d${weaponDie(name)}${damageBonus == 0 ? '' : sign(damageBonus)}';
      final damageType = '${data?['damage'] ?? 'contundente'}';

      return officialPanel(
        title: 'Attacchi e incantesimi',
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: officialLabel('Nome'),
                ),
                Expanded(
                  flex: 2,
                  child: officialLabel('Bonus Att.'),
                ),
                Expanded(
                  flex: 4,
                  child: officialLabel('Danni/Tipo'),
                ),
              ],
            ),
            const Divider(color: ink),
            InkWell(
              key: const Key('official_primary_attack'),
              onTap: () => rollWeaponAttack(name),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        sign(weaponAttackBonus(name)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '$damage $damageType',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const Icon(Icons.casino_outlined, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      key: const Key('official_character_sheet'),
      color: paper,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: BoxDecoration(
              color: panel,
              border: Border.all(color: ink, width: 2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DUNGEONS & DRAGONS',
                            style: TextStyle(
                              color: accent,
                              fontFamily: 'serif',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            'SCHEDA DEL PERSONAGGIO · 5E 2014',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: ink, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${h.level}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: ink, thickness: 1.5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    h.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: officialLabel('Nome del personaggio'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: identityCell(
                        label: 'Classe e livello',
                        value: '${h.resolvedClassName} ${h.level}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: identityCell(
                        label: 'Background',
                        value: h.background,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: identityCell(
                        label: 'Nome del giocatore',
                        value: h.playerName,
                        onTap: () => editOfficialSheetField(
                          title: 'Nome del giocatore',
                          value: h.playerName,
                          onSaved: (value) => h.playerName = value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: identityCell(
                        label: 'Razza',
                        value: h.raceLabel,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: identityCell(
                        label: 'Allineamento',
                        value: h.alignment,
                        onTap: () => editOfficialSheetField(
                          title: 'Allineamento',
                          value: h.alignment,
                          onSaved: (value) => h.alignment = value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: identityCell(
                        label: 'Punti esperienza',
                        value: '${h.experiencePoints}',
                        onTap: () => editOfficialSheetField(
                          title: 'Punti esperienza',
                          value: '${h.experiencePoints}',
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            h.experiencePoints =
                                max(0, int.tryParse(value) ?? 0);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 650 ? 6 : 3;
              final spacing = 6.0;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: 7,
                children: abilities
                    .map((ability) => abilityBox(ability, width))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: officialPanel(
                  title: 'Ispirazione',
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 7),
                  child: InkWell(
                    key: const Key('official_inspiration'),
                    onTap: () {
                      h.inspiration = !h.inspiration;
                      persist();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          h.inspiration ? Icons.star : Icons.star_border,
                          color: h.inspiration ? accent : ink,
                        ),
                        const SizedBox(width: 5),
                        Text(h.inspiration ? 'SÌ' : 'NO'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: officialPanel(
                  title: 'Bonus competenza',
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 7),
                  child: Center(
                    child: Text(
                      sign(h.prof),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: officialPanel(
                  title: 'Percezione passiva',
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 7),
                  child: Center(
                    child: Text(
                      '$passivePerception',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          combatSummary(),
          const SizedBox(height: 18),
          hitPointsPanel(),
          const SizedBox(height: 18),
          attacksPanel(),
          fold(
            key: const Key('official_saves_skills_section'),
            title: 'Tiri salvezza e abilità',
            icon: Icons.casino_outlined,
            children: [
              const SizedBox(height: 4),
              officialPanel(
                title: 'Tiri salvezza',
                child: Column(
                  children: abilities.map(saveRow).toList(),
                ),
              ),
              const SizedBox(height: 18),
              officialPanel(
                title: 'Abilità',
                child: Column(
                  children: skillAbility.entries.map(skillRow).toList(),
                ),
              ),
            ],
          ),
          fold(
            key: const Key('official_personality_section'),
            title: 'Personalità',
            icon: Icons.psychology_outlined,
            children: [
              editableNarrative(
                label: 'Tratti caratteriali',
                value: h.personalityTraits,
                onSaved: (value) => h.personalityTraits = value,
              ),
              editableNarrative(
                label: 'Ideali',
                value: h.ideals,
                onSaved: (value) => h.ideals = value,
              ),
              editableNarrative(
                label: 'Legami',
                value: h.bonds,
                onSaved: (value) => h.bonds = value,
              ),
              editableNarrative(
                label: 'Difetti',
                value: h.flaws,
                onSaved: (value) => h.flaws = value,
              ),
            ],
          ),
          fold(
            key: const Key('official_proficiencies_section'),
            title: 'Altre competenze e linguaggi',
            icon: Icons.record_voice_over_outlined,
            children: [
              editableNarrative(
                label: 'Linguaggi',
                value: h.effectiveLanguages.isEmpty
                    ? ''
                    : h.effectiveLanguages.join(', '),
                onSaved: (value) {
                  h.languages = value
                      .split(',')
                      .map((item) => item.trim())
                      .where((item) => item.isNotEmpty)
                      .toList();
                },
              ),
              if (h.effectiveSkillProficiencies.isNotEmpty)
                editableNarrative(
                  label: 'Competenze nelle abilità',
                  value: h.effectiveSkillProficiencies.join(', '),
                  onSaved: (value) {
                    h.skillProficiencies = value
                        .split(',')
                        .map((item) => item.trim())
                        .where((item) => item.isNotEmpty)
                        .toList();
                  },
                ),
              if (h.effectiveWeaponProficiencies.isNotEmpty)
                editableNarrative(
                  label: 'Competenze nelle armi',
                  value: h.effectiveWeaponProficiencies.join(', '),
                  onSaved: (_) {},
                ),
              if (h.effectiveArmorProficiencies.isNotEmpty)
                editableNarrative(
                  label: 'Competenze nelle armature',
                  value: h.effectiveArmorProficiencies.join(', '),
                  onSaved: (_) {},
                ),
              if (h.effectiveToolProficiencies.isNotEmpty)
                editableNarrative(
                  label: 'Competenze negli strumenti',
                  value: h.effectiveToolProficiencies.join(', '),
                  onSaved: (_) {},
                ),
            ],
          ),
          fold(
            key: const Key('official_features_section'),
            title: 'Privilegi e capacità',
            icon: Icons.auto_awesome_outlined,
            children: [
              if (h.features.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Nessun privilegio disponibile.'),
                )
              else
                ...h.features.map(
                  (feature) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.circle,
                      size: 7,
                    ),
                    title: Text(feature),
                  ),
                ),
            ],
          ),
          fold(
            key: const Key('official_rest_section'),
            title: 'Riposo e avanzamento',
            icon: Icons.hotel_outlined,
            children: [
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: shortRest,
                  icon: const Icon(Icons.hotel),
                  label: const Text('RIPOSO BREVE'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: longRest,
                  icon: const Icon(Icons.bedtime_outlined),
                  label: const Text('RIPOSO LUNGO'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: h.level < 20 ? levelUp : null,
                  icon: const Icon(Icons.arrow_upward),
                  label: Text(
                    h.level < 20
                        ? 'SALI AL LIVELLO ${h.level + 1}'
                        : 'LIVELLO MASSIMO',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<SubclassOptionDefinition> get knownSubclassOptions {
    final subclass =
        h.subclass == null ? null : monkClass.subclasses[h.subclass];

    if (subclass == null) {
      return const <SubclassOptionDefinition>[];
    }

    final knownIds = h.subclassOptionIds.toSet();

    final options = subclass.options
        .where(
          (option) =>
              knownIds.contains(option.id) && option.minimumLevel <= h.level,
        )
        .toList()
      ..sort((a, b) {
        final byLevel = a.minimumLevel.compareTo(b.minimumLevel);
        if (byLevel != 0) return byLevel;
        return a.name.compareTo(b.name);
      });

    return options;
  }

  Future<void> showSubclassOption(
    SubclassOptionDefinition option,
  ) async {
    final baseCost = option.cost;
    final usesKi = option.resource == 'ki' && baseCost != null;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                option.name,
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Livello minimo ${option.minimumLevel}'
                '${baseCost == null ? '' : ' · Costo base $baseCost Ki'}',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              RuleDescriptionView.legacy(
                description: option.description,
                source: option.source,
                sourceRef: option.sourceRef,
                metadata: [
                  'Livello minimo ${option.minimumLevel}',
                  if (baseCost != null) 'Costo base $baseCost Ki',
                  if (option.allowsAdditionalResource)
                    'Spesa aggiuntiva consentita',
                ],
              ),
              const SizedBox(height: 18),

              // Per ora automatizziamo soltanto il costo base esplicito.
              // Discipline con costo variabile/incrementabile continueranno
              // a mostrare la regola senza inventare una spesa automatica.
              if (usesKi)
                FilledButton.icon(
                  onPressed: h.ki >= baseCost
                      ? () async {
                          setState(() {
                            h.ki = max(0, h.ki - baseCost);
                          });
                          await persist();

                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                          }
                        }
                      : null,
                  icon: const Icon(Icons.bolt),
                  label: Text(
                    h.ki >= baseCost
                        ? 'USA · $baseCost KI'
                        : 'KI INSUFFICIENTE',
                  ),
                ),
              if (!usesKi)
                const Text(
                  'Consulta la descrizione per applicare gli effetti '
                  'della disciplina.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subclassOptionsSection() {
    final options = knownSubclassOptions;

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    return FantasySection(
      title: h.subclass == 'Via dei Quattro Elementi'
          ? 'Discipline Elementali'
          : 'Opzioni della sottoclasse',
      child: Column(
        children: options.map((option) {
          final cost = option.cost;

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              option.grantedAutomatically
                  ? Icons.auto_awesome
                  : Icons.local_fire_department_outlined,
            ),
            title: Text(option.name),
            subtitle: Text(
              option.description.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cost != null) ...[
                  Text(
                    '$cost Ki',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => showSubclassOption(option),
          );
        }).toList(),
      ),
    );
  }

  Widget abilitiesTab() => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Capacità',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              KiCounter(
                value: h.ki,
                maxValue: h.maxKi,
                onMinus: h.ki > 0
                    ? () {
                        h.ki--;
                        persist();
                      }
                    : null,
                onPlus: h.ki < h.maxKi
                    ? () {
                        h.ki++;
                        persist();
                      }
                    : null,
              ),
            ],
          ),
          Text('Arti Marziali: ${h.martialDie}'),
          const SizedBox(height: 8),
          ...h.features.map(
            (f) => Card(
              child: ListTile(
                title: Text(f),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final subclassDefinition = h.subclass == null
                      ? null
                      : monkClass.subclasses[h.subclass];

                  final isSubclass = subclassDefinition?.featuresByLevel.values
                          .expand((features) => features)
                          .contains(f) ??
                      false;

                  final ruleDescription = isSubclass
                      ? subclassDefinition?.featureDescriptions[f]
                      : monkClass.featureDescriptions[f];

                  final desc = ruleDescription == null
                      ? (isSubclass
                          ? 'Privilegio della tradizione ${h.subclass}.'
                          : (monkFeatureInfo[f] ??
                              'Privilegio del Monaco ottenuto con la progressione di classe.'))
                      : ruleDescription.details.isNotEmpty
                          ? ruleDescription.details
                          : ruleDescription.summary;
                  final cost = <String, int>{
                        'Colpo Stordente': 1,
                        'Anima Adamantina': 1,
                        'Corpo Vuoto': 4,
                        'Arti dell’Ombra': 2,
                        'Affilare la Lama': 1,
                        'Braccia del Sé Astrale': 1,
                        'Mani della Guarigione': 1,
                        'Mani del Dolore': 1,
                        'Fortuna dell’Ubriaco': 2,
                        'Esplosione Solare Rovente': 1,
                        'Mano della Misericordia Suprema': 5,
                      }[f] ??
                      0;
                  ability(f, cost, desc);
                },
              ),
            ),
          ),
          if (h.level >= 2) ...[
            AbilityActionTile(
                title: 'Raffica di Colpi',
                subtitle: '1 Ki',
                visual: const RuleVisualIdentity(
                  family: RuleVisualFamily.ability,
                  iconId: RuleIconIds.flurryOfBlows,
                ),
                onTap: () => ability('Raffica di Colpi', 1,
                    'Dopo l’azione Attacco, spendi 1 Ki per effettuare due colpi senz’armi come azione bonus.')),
            subclassOptionsSection(),
            if (knownSubclassOptions.isNotEmpty) const SizedBox(height: 12),
            AbilityActionTile(
                title: 'Difesa Paziente',
                subtitle: '1 Ki',
                visual: const RuleVisualIdentity(
                  family: RuleVisualFamily.ability,
                  iconId: RuleIconIds.patientDefense,
                ),
                onTap: () => ability('Difesa Paziente', 1,
                    'Spendi 1 Ki per usare Schivare come azione bonus nel tuo turno.')),
            AbilityActionTile(
                title: 'Passo del Vento',
                subtitle: '1 Ki',
                visual: const RuleVisualIdentity(
                  family: RuleVisualFamily.ability,
                  iconId: RuleIconIds.stepOfTheWind,
                ),
                onTap: () => ability('Passo del Vento', 1,
                    'Spendi 1 Ki per Disimpegno o Scatto come azione bonus; la distanza di salto aumenta per il turno.')),
          ],
          const SizedBox(height: 80),
        ],
      );

  int weaponDie(String name) {
    if (name == 'Colpo senz’armi') {
      return int.tryParse(h.martialDie.substring(1)) ?? 4;
    }
    final data = weaponInfo[name];
    final base = (data?['die'] as int?) ?? 4;
    final martial = int.tryParse(h.martialDie.substring(1)) ?? 4;
    return (data?['monk'] == true) ? max(base, martial) : base;
  }

  int weaponAttackBonus(String name) {
    final ability = '${weaponInfo[name]?['ability'] ?? 'DES'}';
    return mod(h.scores[ability] ?? 10) + h.prof;
  }

  String weaponDamage(String name) {
    final die = weaponDie(name);
    final ability = '${weaponInfo[name]?['ability'] ?? 'DES'}';
    final bonus = mod(h.scores[ability] ?? 10);
    final type = weaponInfo[name]?['damage'] == 'marziale'
        ? 'contundente'
        : '${weaponInfo[name]?['damage'] ?? ''}';
    return '1d$die ${sign(bonus)} $type';
  }

  Future<void> rollWeaponAttack(String name) async {
    await rollCheck(
      'Attacco · $name',
      weaponAttackBonus(name),
    );
  }

  Widget equipmentTab() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Equipaggiamento',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text(
              'Il Monaco calcola qui il danno delle armi compatibili con le Arti Marziali. Armature e scudi non vengono equipaggiati perché disattivano parti fondamentali della classe.'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('Negozio'),
              subtitle: Text(
                'Compra equipaggiamento e servizi usando il portamonete.\n'
                '$coinSummary',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: openShop,
            ),
          ),
          FantasySection(
            title: 'Inventario',
            subtitle: 'Oggetti acquistati e dotazione del personaggio.',
            child: h.inventory.isEmpty
                ? const ListTile(
                    leading: Icon(Icons.inventory_2_outlined),
                    title: Text('Inventario vuoto'),
                  )
                : Column(
                    children: h.inventory.map((item) {
                      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
                      final name =
                          item['name']?.toString() ?? item['id'].toString();

                      return ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(name),
                        subtitle: Text(
                          item['catalogId']?.toString() ?? 'equipment',
                        ),
                        trailing: Text('×$quantity'),
                      );
                    }).toList(),
                  ),
          ),
          FantasySection(
            title: 'Equipaggiato',
            child: ListTile(
              leading: const Icon(Icons.gavel),
              title: Text(h.equippedWeapon),
              subtitle: Text(
                'Attacco ${sign(weaponAttackBonus(h.equippedWeapon))} · '
                'Danno: ${weaponDamage(h.equippedWeapon)}',
              ),
              trailing: const Icon(Icons.casino),
              onTap: () => rollWeaponAttack(h.equippedWeapon),
            ),
          ),
          FantasySection(
            title: 'Armi',
            subtitle:
                'Tocca un’arma per equipaggiarla; il danno mostrato usa il dado marziale quando applicabile.',
            child: Column(
              children: weaponInfo.keys.map((w) {
                final selected = h.equippedWeapon == w;
                return ListTile(
                  leading: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined),
                  title: Text(w),
                  subtitle: Text('Danno: ${weaponDamage(w)}'),
                  trailing: selected
                      ? const Text('EQUIPAGGIATA')
                      : const Text('EQUIPAGGIA'),
                  onTap: () async {
                    h.equippedWeapon = w;
                    await persist();
                  },
                );
              }).toList(),
            ),
          ),
        ],
      );

  Future<void> togglePreparedSpell(SpellDefinition spell) async {
    final rules = h.catalogClassDefinition?.spellcasting;
    if (rules == null || !rules.preparesSpells || spell.level == 0) return;

    final selected = h.preparedSpellIds.toSet();

    if (selected.remove(spell.id)) {
      h.preparedSpellIds = selected.toList();
      await persist();
      return;
    }

    final limit = rules.preparedSpellsAtLevel(
      h.level,
      abilityModifiers: {
        for (final ability in abilities) ability: mod(h.scores[ability] ?? 10),
      },
    );

    if (selected.length >= limit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Puoi preparare al massimo $limit incantesimi.',
          ),
        ),
      );
      return;
    }

    selected.add(spell.id);
    h.preparedSpellIds = selected.toList();
    await persist();
  }

  Future<void> removeCharacterSpell(SpellDefinition spell) async {
    h.knownSpellIds = h.knownSpellIds.where((id) => id != spell.id).toList();
    h.preparedSpellIds =
        h.preparedSpellIds.where((id) => id != spell.id).toList();
    h.spellbookSpellIds =
        h.spellbookSpellIds.where((id) => id != spell.id).toList();

    await persist();
  }

  Future<void> addSpellFromClassList() async {
    final classDefinition = h.catalogClassDefinition;
    final rules = classDefinition?.spellcasting;

    if (rules == null) return;

    final alreadyRegistered = {
      ...h.knownSpellIds,
      ...h.preparedSpellIds,
      ...h.spellbookSpellIds,
    };

    final available = spellDefinitions.values
        .where(
          (spell) =>
              !alreadyRegistered.contains(spell.id) &&
              (rules.spellIds.contains(spell.id) ||
                  spell.classIds.contains(h.classId)),
        )
        .toList()
      ..sort((a, b) {
        final level = a.level.compareTo(b.level);
        return level != 0 ? level : a.content.name.compareTo(b.content.name);
      });

    final selected = await showModalBottomSheet<SpellDefinition>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          children: [
            const ListTile(
              title: Text(
                'AGGIUNGI INCANTESIMO',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text('Lista ufficiale della classe'),
            ),
            for (final spell in available)
              ListTile(
                title: Text(spell.content.name),
                subtitle: Text(
                  spell.level == 0 ? 'Trucchetto' : 'Livello ${spell.level}',
                ),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () => Navigator.pop(ctx, spell),
              ),
          ],
        ),
      ),
    );

    if (selected == null || !mounted) return;

    if (selected.level == 0) {
      h.knownSpellIds = {...h.knownSpellIds, selected.id}.toList();
    } else if (classDefinition?.spellbook != null) {
      h.spellbookSpellIds = {
        ...h.spellbookSpellIds,
        selected.id,
      }.toList();
    } else if (rules.preparesSpells) {
      h.preparedSpellIds = {
        ...h.preparedSpellIds,
        selected.id,
      }.toList();
    } else {
      h.knownSpellIds = {...h.knownSpellIds, selected.id}.toList();
    }

    await persist();
  }

  Future<void> showSpellSheet(SpellDefinition spell) async {
    final rules = h.catalogClassDefinition?.spellcasting;
    final maximumSlots = rules?.slotsAtLevel(h.level) ?? const <int>[];

    int maximumAt(int level) =>
        level <= maximumSlots.length ? maximumSlots[level - 1] : 0;

    int currentAt(int level) => h.spellSlots['$level'] ?? maximumAt(level);

    Future<void> castSpell(BuildContext sheetContext) async {
      if (spell.level == 0) {
        Navigator.pop(sheetContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${spell.content.name} lanciato.')),
        );
        return;
      }

      final available = [
        for (var level = spell.level; level <= 9; level++)
          if (maximumAt(level) > 0 && currentAt(level) > 0) level,
      ];

      if (available.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nessuno slot disponibile.')),
        );
        return;
      }

      final chosen = await showDialog<int>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Scegli lo slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final level in available)
                ListTile(
                  title: Text('Slot di livello $level'),
                  subtitle: Text('${currentAt(level)} disponibili'),
                  onTap: () => Navigator.pop(ctx, level),
                ),
            ],
          ),
        ),
      );

      if (chosen == null || !mounted) return;

      h.spellSlots = {
        ...h.spellSlots,
        '$chosen': currentAt(chosen) - 1,
      };
      await persist();

      if (sheetContext.mounted) Navigator.pop(sheetContext);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${spell.content.name} lanciato con uno slot di livello $chosen.',
            ),
          ),
        );
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            Text(
              spell.content.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            Text(
              spell.level == 0
                  ? 'Trucchetto'
                  : 'Incantesimo di livello ${spell.level}',
            ),
            const Divider(),
            RuleDescriptionView(
              content: spell.content,
              initiallyExpanded: true,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => castSpell(sheetContext),
              icon: const Icon(Icons.auto_fix_high),
              label: Text(
                spell.level == 0 ? 'LANCIA TRUCCHETTO' : 'LANCIA INCANTESIMO',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget spellsTab() {
    final rules = h.catalogClassDefinition?.spellcasting;
    final ability = rules?.ability ?? 'SAG';
    final abilityModifier = mod(h.scores[ability] ?? 10);
    final saveDc = 8 + h.prof + abilityModifier;
    final attackBonus = h.prof + abilityModifier;
    final characterSpellIds = {
      ...h.knownSpellIds,
      ...h.preparedSpellIds,
      ...h.spellbookSpellIds,
    };
    final characterSpells = characterSpellIds
        .map((id) => spellDefinitions[id])
        .whereType<SpellDefinition>()
        .toList()
      ..sort((a, b) {
        final level = a.level.compareTo(b.level);
        return level != 0 ? level : a.content.name.compareTo(b.content.name);
      });
    final selectedCount = characterSpells.length;
    final maximumSlots = rules?.slotsAtLevel(h.level) ?? const <int>[];

    int maximumAt(int level) =>
        level <= maximumSlots.length ? maximumSlots[level - 1] : 0;

    int currentAt(int level) => h.spellSlots['$level'] ?? maximumAt(level);

    void changeSlot(int level, int change) {
      h.spellSlots = {
        ...h.spellSlots,
        '$level': (currentAt(level) + change).clamp(0, maximumAt(level)),
      };
      persist();
    }

    Widget metric(String label, String value) => Expanded(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

    return Material(
      color: const Color(0xffeee9dc),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        children: [
          const Text(
            'DUNGEONS & DRAGONS',
            style: TextStyle(
              color: Color(0xff8b1f1f),
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'INCANTESIMI · 5E 2014',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              metric('CARATTERISTICA', ability),
              metric('CD SALVEZZA', '$saveDc'),
              metric('BONUS ATTACCO', sign(attackBonus)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            rules == null
                ? 'La classe non possiede una progressione magica base.'
                : '$selectedCount incantesimi registrati per il personaggio.',
          ),
          if (maximumSlots.any((value) => value > 0)) ...[
            const SizedBox(height: 16),
            const Text(
              'SLOT INCANTESIMO',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            for (var level = 1; level <= 9; level++)
              if (maximumAt(level) > 0)
                Card(
                  child: ListTile(
                    title: Text('Livello $level'),
                    subtitle: Text(
                      '${currentAt(level)} / ${maximumAt(level)} disponibili',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: currentAt(level) > 0
                              ? () => changeSlot(level, -1)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          onPressed: currentAt(level) < maximumAt(level)
                              ? () => changeSlot(level, 1)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: rules == null ? null : addSpellFromClassList,
              icon: const Icon(Icons.add),
              label: const Text('AGGIUNGI TRUCCHETTO O INCANTESIMO'),
            ),
          ),
          const SizedBox(height: 14),
          if (characterSpells.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.menu_book_outlined),
                title: Text('Nessun incantesimo registrato'),
                subtitle: Text(
                  'Gli incantesimi scelti dal personaggio appariranno qui.',
                ),
              ),
            ),
          for (var spellLevel = 0; spellLevel <= 9; spellLevel++)
            if (characterSpells.any((spell) => spell.level == spellLevel))
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1.3),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ExpansionTile(
                  initiallyExpanded: spellLevel == 0,
                  title: Text(
                    spellLevel == 0
                        ? 'TRUCCHETTI'
                        : 'INCANTESIMI DI LIVELLO $spellLevel',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  children: [
                    for (final spell in characterSpells)
                      if (spell.level == spellLevel)
                        ListTile(
                          title: Text(spell.content.name),
                          subtitle: Text(
                            [
                              if (spell.ritual) 'Rituale',
                              if (h.preparedSpellIds.contains(spell.id))
                                'Preparato',
                            ].join(' · '),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (action) {
                              if (action == 'prepare') {
                                togglePreparedSpell(spell);
                              } else if (action == 'remove') {
                                removeCharacterSpell(spell);
                              }
                            },
                            itemBuilder: (context) => [
                              if (rules?.preparesSpells == true &&
                                  spell.level > 0)
                                PopupMenuItem(
                                  value: 'prepare',
                                  child: Text(
                                    h.preparedSpellIds.contains(spell.id)
                                        ? 'Rimuovi preparazione'
                                        : 'Prepara',
                                  ),
                                ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text('Rimuovi dalla scheda'),
                              ),
                            ],
                          ),
                          onTap: () => showSpellSheet(spell),
                        ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget officialProfileField(
    String label,
    String value,
    ValueChanged<String> onSaved,
  ) =>
      ListTile(
        title: Text(label),
        subtitle: Text(value.trim().isEmpty ? 'Tocca per compilare' : value),
        trailing: const Icon(Icons.edit_outlined),
        onTap: () => editOfficialSheetField(
          title: label,
          value: value,
          onSaved: onSaved,
        ),
      );

  Widget officialProfileNarrative(
    String label,
    String value,
    ValueChanged<String> onSaved,
  ) =>
      ListTile(
        title: Text(
          label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value.trim().isEmpty ? 'Tocca per compilare' : value,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.edit_note),
        onTap: () => editOfficialSheetField(
          title: label,
          value: value,
          maxLines: 8,
          onSaved: onSaved,
        ),
      );

  Widget profileTab() => Material(
        color: const Color(0xffeee9dc),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'DUNGEONS & DRAGONS',
              style: TextStyle(
                color: Color(0xff8b1f1f),
                fontFamily: 'serif',
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'DETTAGLI DEL PERSONAGGIO · 5E 2014',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xfffffdf7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1.7),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  ListTile(title: const Text('Nome'), subtitle: Text(h.name)),
                  ListTile(
                      title: const Text('Razza'),
                      subtitle: Text('${h.raceLabel} (2014)')),
                  ListTile(
                      title: const Text('Classe'),
                      subtitle: Text('Monaco ${h.level}')),
                  ListTile(
                      title: const Text('Tradizione'),
                      subtitle: Text(h.subclass ?? 'Non ancora scelta')),
                  ListTile(
                      title: const Text('Background'),
                      subtitle: Text(h.background)),
                  const Divider(),
                  officialProfileField(
                    'Età',
                    h.age,
                    (value) => h.age = value,
                  ),
                  officialProfileField(
                    'Altezza',
                    h.height,
                    (value) => h.height = value,
                  ),
                  officialProfileField(
                    'Peso',
                    h.weight,
                    (value) => h.weight = value,
                  ),
                  officialProfileField(
                    'Occhi',
                    h.eyes,
                    (value) => h.eyes = value,
                  ),
                  officialProfileField(
                    'Pelle',
                    h.skin,
                    (value) => h.skin = value,
                  ),
                  officialProfileField(
                    'Capelli',
                    h.hair,
                    (value) => h.hair = value,
                  ),
                  const Divider(),
                  ListTile(
                      title: const Text('Talento'),
                      subtitle: Text(h.feat ?? 'Nessuno')),
                  const Divider(),
                  officialProfileNarrative(
                    'Aspetto del personaggio',
                    h.appearance,
                    (value) => h.appearance = value,
                  ),
                  officialProfileNarrative(
                    'Storia del personaggio',
                    h.story,
                    (value) => h.story = value,
                  ),
                  officialProfileNarrative(
                    'Alleati e organizzazioni',
                    h.alliesAndOrganizations,
                    (value) => h.alliesAndOrganizations = value,
                  ),
                  officialProfileNarrative(
                    'Tesori aggiuntivi',
                    h.additionalTreasure,
                    (value) => h.additionalTreasure = value,
                  ),
                  officialProfileNarrative(
                    'Note',
                    h.notes,
                    (value) => h.notes = value,
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('D&D Character Sheet'),
                    subtitle: Text('Versione 0.6.0 · Build 6'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pages = [
      sheetTab(),
      abilitiesTab(),
      equipmentTab(),
      spellsTab(),
      profileTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(h.name),
        actions: [
          IconButton(
              onPressed: levelUp,
              icon: const Icon(Icons.upgrade),
              tooltip: 'Sali di livello')
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.description), label: 'Scheda'),
            NavigationDestination(
                icon: Icon(Icons.auto_awesome), label: 'Capacità'),
            NavigationDestination(icon: Icon(Icons.backpack), label: 'Equip.'),
            NavigationDestination(
              icon: Icon(Icons.auto_fix_high),
              label: 'Magia',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Dettagli',
            ),
          ],
        ),
      ),
      body: SafeArea(bottom: false, child: pages[tab]),
    );
  }
}

class Metric extends StatelessWidget {
  const Metric(this.label, this.value, {super.key});
  final String label, value;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      );
}

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.onMinus,
    required this.onPlus,
  });
  final String title;
  final int value, maxValue;
  final VoidCallback onMinus, onPlus;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$value / $maxValue', style: const TextStyle(fontSize: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: onMinus,
                      icon: const Icon(Icons.remove_circle_outline)),
                  IconButton(
                      onPressed: onPlus,
                      icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
            ],
          ),
        ),
      );
}

class KiCounter extends StatelessWidget {
  const KiCounter({
    super.key,
    required this.value,
    required this.maxValue,
    this.onMinus,
    this.onPlus,
  });
  final int value, maxValue;
  final VoidCallback? onMinus, onPlus;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_circle)),
          Text('Ki $value/$maxValue',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(onPressed: onPlus, icon: const Icon(Icons.add_circle)),
        ],
      );
}

class DeathRow extends StatelessWidget {
  const DeathRow(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: 85, child: Text(label)),
          ...List.generate(3, (i) {
            final n = i + 1;
            return IconButton(
              onPressed: () => onChanged(value == n ? n - 1 : n),
              icon: Icon(n <= value ? Icons.circle : Icons.circle_outlined),
            );
          }),
        ],
      );
}

const monkFeatureInfo = <String, String>{
  'Difesa Senza Armatura':
      'Senza armatura e scudo, la CA usa Destrezza e Saggezza oltre alla base 10.',
  'Arti Marziali':
      'Migliora colpi senz’armi e armi da monaco; il dado cresce ai livelli 5, 11 e 17.',
  'Ki':
      'Riserva pari al livello da Monaco, usata per alimentare tecniche speciali e recuperata con il riposo previsto.',
  'Movimento Senza Armatura':
      'Aumenta la velocità quando non indossi armatura e non usi uno scudo.',
  'Deviare Proiettili':
      'Usa la reazione per ridurre i danni di un attacco a distanza con arma e, in certe condizioni, rilanciare il proiettile.',
  'Caduta Lenta':
      'Usa la reazione per ridurre i danni da caduta in funzione del livello.',
  'Attacco Extra': 'Quando usi l’azione Attacco, puoi effettuare due attacchi.',
  'Colpo Stordente':
      'Dopo un colpo in mischia puoi spendere Ki per tentare di stordire il bersaglio.',
  'Colpi Ki Potenziati':
      'I colpi senz’armi contano come magici per superare resistenze e immunità appropriate.',
  'Elusione':
      'Migliora la difesa contro effetti basati su tiri salvezza su Destrezza.',
  'Mente Lucida':
      'Permette di terminare su di te un effetto di affascinato o spaventato.',
  'Purezza del Corpo': 'Conferisce immunità alle malattie e ai veleni.',
  'Lingua del Sole e della Luna':
      'Permette di comprendere le lingue parlate e farsi comprendere da chi conosce una lingua.',
  'Anima Adamantina':
      'Conferisce competenza in tutti i tiri salvezza e consente di usare Ki per ritentare un fallimento.',
  'Corpo Senza Tempo':
      'Il Ki protegge il corpo dagli effetti debilitanti dell’età e riduce alcuni bisogni fisici.',
  'Corpo Vuoto':
      'Tecnica di alto livello che usa Ki per ottenere potenti difese e accedere alla proiezione astrale.',
  'Perfezione Interiore':
      'Al livello 20 permette di recuperare una piccola riserva di Ki entrando in combattimento senza Ki.',
  'Tecnica della Mano Aperta':
      'Aggiunge effetti di controllo ai colpi della Raffica di Colpi.',
  'Integrità del Corpo':
      'Permette di recuperare punti ferita con un’azione; l’uso è limitato.',
  'Tranquillità':
      'Dopo un riposo lungo fornisce una protezione che ostacola gli attacchi finché l’effetto non viene interrotto.',
  'Palmo Tremante':
      'Tecnica culminante della Mano Aperta che imprime vibrazioni letali attivabili successivamente.',
};

class AbilityActionTile extends StatelessWidget {
  const AbilityActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.visual,
  });

  final String title, subtitle;
  final VoidCallback onTap;
  final RuleVisualIdentity? visual;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: visual == null
              ? null
              : RuleVisualTile(
                  visual: visual!,
                ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.play_arrow),
          onTap: onTap,
        ),
      );
}

Future<void> showGlossaryEntry(
  BuildContext context,
  GlossaryRef reference,
) async {
  final entry = glossaryEntryFor(reference.id);

  if (entry == null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Voce di glossario non ancora disponibile: ${reference.label}',
          ),
        ),
      );
    return;
  }

  await openGlossaryEntryPage(context, entry);
}

/// Tema visuale centralizzato per tutti i contenuti regolamentari.
///
/// I colori appartengono alle famiglie, non ai singoli contenuti.
/// Gli incantesimi possono sostituire il colore della famiglia
/// con quello della propria scuola di magia.
class RuleVisualTheme {
  const RuleVisualTheme._();

  static Color familyColor(RuleVisualFamily family) {
    switch (family) {
      case RuleVisualFamily.classType:
        return const Color(0xffd8a23d);
      case RuleVisualFamily.race:
        return const Color(0xff70a37f);
      case RuleVisualFamily.background:
        return const Color(0xffa88bc1);
      case RuleVisualFamily.feat:
        return const Color(0xffd17a6f);
      case RuleVisualFamily.ability:
        return const Color(0xffdc8d45);
      case RuleVisualFamily.skill:
        return const Color(0xff6ea6b8);
      case RuleVisualFamily.action:
        return const Color(0xffd5b85a);
      case RuleVisualFamily.weapon:
        return const Color(0xffb9b9b9);
      case RuleVisualFamily.armor:
        return const Color(0xff8e9aa3);
      case RuleVisualFamily.equipment:
        return const Color(0xffa98b6d);
      case RuleVisualFamily.resource:
        return const Color(0xff7ca7d8);
      case RuleVisualFamily.spell:
        return const Color(0xff9b83c7);
      case RuleVisualFamily.other:
        return const Color(0xffb0a99f);
    }
  }

  static Color spellSchoolColor(SpellVisualSchool school) {
    switch (school) {
      case SpellVisualSchool.abjuration:
        return const Color(0xff7da7d9);
      case SpellVisualSchool.conjuration:
        return const Color(0xffd0a05f);
      case SpellVisualSchool.divination:
        return const Color(0xffd7c65c);
      case SpellVisualSchool.enchantment:
        return const Color(0xffd58aad);
      case SpellVisualSchool.evocation:
        return const Color(0xffd96b5f);
      case SpellVisualSchool.illusion:
        return const Color(0xff9b83c7);
      case SpellVisualSchool.necromancy:
        return const Color(0xff7f8c72);
      case SpellVisualSchool.transmutation:
        return const Color(0xff70ad91);
    }
  }

  static Color backgroundFor(RuleVisualIdentity visual) {
    final school = visual.spellSchool;

    if (visual.family == RuleVisualFamily.spell && school != null) {
      return spellSchoolColor(school);
    }

    return familyColor(visual.family);
  }

  /// Fallback Material usato finché non esiste il pittogramma
  /// personalizzato corrispondente a iconId.
  static IconData fallbackIcon(RuleVisualFamily family) {
    switch (family) {
      case RuleVisualFamily.classType:
        return Icons.shield_outlined;
      case RuleVisualFamily.race:
        return Icons.groups_outlined;
      case RuleVisualFamily.background:
        return Icons.history_edu_outlined;
      case RuleVisualFamily.feat:
        return Icons.workspace_premium_outlined;
      case RuleVisualFamily.ability:
        return Icons.flash_on_outlined;
      case RuleVisualFamily.skill:
        return Icons.psychology_outlined;
      case RuleVisualFamily.action:
        return Icons.play_arrow_outlined;
      case RuleVisualFamily.weapon:
        return Icons.gavel_outlined;
      case RuleVisualFamily.armor:
        return Icons.shield_outlined;
      case RuleVisualFamily.equipment:
        return Icons.backpack_outlined;
      case RuleVisualFamily.resource:
        return Icons.bolt_outlined;
      case RuleVisualFamily.spell:
        return Icons.auto_fix_high_outlined;
      case RuleVisualFamily.other:
        return Icons.category_outlined;
    }
  }
}

/// Tessera visuale standard dell'app.
///
/// Forma quadrata, sfondo semantico e pittogramma nero.
/// In futuro iconId verrà risolto verso gli asset grafici originali.
/// Fino ad allora viene sempre mostrato un fallback coerente.

/// Registry degli asset visuali specifici.
///
/// La chiave è RuleVisualIdentity.iconId.
/// Il percorso dell'asset rimane confinato qui: i dataset regolamentari
/// conoscono soltanto l'ID semantico.
///
/// Aggiungeremo le voci progressivamente mentre realizziamo
/// il set grafico originale.
String? ruleIconAssetFor(String iconId) {
  final normalized = iconId.trim();

  if (normalized.isEmpty) return null;

  return ruleIconAssets[normalized];
}

/// Pittogramma interno alla tessera.
///
/// Se iconId possiede un asset registrato usa l'immagine.
/// In caso contrario usa sempre il fallback della famiglia,
/// quindi un contenuto nuovo non rimane mai senza icona.
class RuleIconGlyph extends StatelessWidget {
  const RuleIconGlyph({
    super.key,
    required this.visual,
    required this.size,
  });

  final RuleVisualIdentity visual;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = ruleIconAssetFor(visual.iconId);

    if (asset == null) {
      return Icon(
        RuleVisualTheme.fallbackIcon(visual.family),
        color: Colors.black,
        size: size,
      );
    }

    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,

      // Le icone sorgente saranno nere/trasparenti.
      // Il filtro garantisce comunque una resa nera uniforme.
      color: Colors.black,
      colorBlendMode: BlendMode.srcIn,

      // Se un asset registrato viene accidentalmente rimosso,
      // l'interfaccia continua a funzionare con il fallback.
      errorBuilder: (context, error, stackTrace) => Icon(
        RuleVisualTheme.fallbackIcon(visual.family),
        color: Colors.black,
        size: size,
      ),
    );
  }
}

class RuleVisualTile extends StatelessWidget {
  const RuleVisualTile({
    super.key,
    required this.visual,
    this.size = 44,
    this.borderRadius = 9,
  });

  final RuleVisualIdentity visual;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final background = RuleVisualTheme.backgroundFor(visual);

    return Semantics(
      image: true,
      label: visual.iconId.isEmpty
          ? 'Icona ${visual.family.name}'
          : 'Icona ${visual.iconId}',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.22),
          ),
        ),
        alignment: Alignment.center,
        child: RuleIconGlyph(
          visual: visual,
          size: size * 0.62,
        ),
      ),
    );
  }
}

/// Determina la famiglia visuale di fallback da RuleContentType.
///
/// Serve ai contenuti migrati a RuleContent che non possiedono
/// ancora un'identità grafica specifica.
RuleVisualFamily visualFamilyForContentType(RuleContentType type) {
  switch (type) {
    case RuleContentType.classFeature:
    case RuleContentType.subclassFeature:
    case RuleContentType.subclassOption:
      return RuleVisualFamily.ability;

    case RuleContentType.race:
    case RuleContentType.subrace:
    case RuleContentType.racialTrait:
      return RuleVisualFamily.race;

    case RuleContentType.background:
      return RuleVisualFamily.background;

    case RuleContentType.feat:
      return RuleVisualFamily.feat;

    case RuleContentType.skill:
      return RuleVisualFamily.skill;

    case RuleContentType.action:
      return RuleVisualFamily.action;

    case RuleContentType.spell:
      return RuleVisualFamily.spell;

    case RuleContentType.weapon:
      return RuleVisualFamily.weapon;

    case RuleContentType.armor:
      return RuleVisualFamily.armor;

    case RuleContentType.equipment:
      return RuleVisualFamily.equipment;

    case RuleContentType.resource:
      return RuleVisualFamily.resource;

    case RuleContentType.other:
      return RuleVisualFamily.other;
  }
}

RuleVisualIdentity visualForRuleContent(RuleContent content) {
  return content.visual ??
      RuleVisualIdentity(
        family: visualFamilyForContentType(content.type),
        iconId: content.id,
      );
}

class RuleDescriptionView extends StatefulWidget {
  const RuleDescriptionView({
    super.key,
    required this.content,
    this.initiallyExpanded = false,
  })  : description = null,
        legacyMetadata = const [],
        legacySource = '',
        legacySourceRef = '';

  /// Costruttore temporaneo per i contenuti non ancora migrati
  /// a RuleContent.
  ///
  /// Permette di convertire progressivamente razze, background,
  /// talenti, capacità, abilità, equipaggiamento e altri dataset
  /// senza duplicare la UI.
  const RuleDescriptionView.legacy({
    super.key,
    required this.description,
    List<String> metadata = const [],
    String source = '',
    String sourceRef = '',
    this.initiallyExpanded = false,
  })  : content = null,
        legacyMetadata = metadata,
        legacySource = source,
        legacySourceRef = sourceRef;

  final RuleContent? content;

  final RuleDescription? description;
  final List<String> legacyMetadata;
  final String legacySource;
  final String legacySourceRef;

  final bool initiallyExpanded;

  RuleDescription get resolvedDescription =>
      content?.description ?? description!;

  List<RuleMetadata> get resolvedMetadata {
    if (content != null) return content!.metadata;

    return [
      for (var i = 0; i < legacyMetadata.length; i++)
        RuleMetadata(
          id: 'legacy_$i',
          label: '',
          value: legacyMetadata[i],
        ),
    ];
  }

  RuleSource get resolvedSource =>
      content?.source ??
      RuleSource(
        name: legacySource,
        reference: legacySourceRef,
      );

  @override
  State<RuleDescriptionView> createState() => _RuleDescriptionViewState();
}

class _RuleDescriptionViewState extends State<RuleDescriptionView> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  bool get hasMore {
    final description = widget.resolvedDescription;
    final source = widget.resolvedSource;

    return description.details.trim().isNotEmpty ||
        description.glossaryRefs.isNotEmpty ||
        widget.resolvedMetadata.isNotEmpty ||
        !source.isEmpty;
  }

  String metadataLabel(RuleMetadata metadata) {
    final label = metadata.label.trim();
    final value = metadata.value.trim();

    if (label.isEmpty) return value;
    if (value.isEmpty) return label;

    return '$label: $value';
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.resolvedDescription;
    final metadata = widget.resolvedMetadata;
    final source = widget.resolvedSource;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlossaryLinkedText(
          text: description.summary,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (hasMore) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
              ),
              label: Text(
                expanded ? 'MOSTRA MENO' : 'MOSTRA ALTRO',
              ),
            ),
          ),
        ],
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState:
              expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (description.details.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                GlossaryLinkedText(
                  text: description.details,
                ),
              ],
              if (metadata.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: metadata
                      .map(metadataLabel)
                      .where((item) => item.trim().isNotEmpty)
                      .map(
                        (item) => Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(item),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (description.glossaryRefs.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'GLOSSARIO',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: description.glossaryRefs
                      .map(
                        (ref) => ActionChip(
                          avatar: const Icon(
                            Icons.menu_book_outlined,
                            size: 16,
                          ),
                          label: Text(ref.label),
                          onPressed: () {
                            showGlossaryEntry(context, ref);
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
              if (!source.isEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  [
                    if (source.name.trim().isNotEmpty) source.name.trim(),
                    if (source.reference.trim().isNotEmpty)
                      source.reference.trim(),
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class HpDialog extends StatefulWidget {
  const HpDialog({
    super.key,
    required this.nextLevel,
    required this.conMod,
    required this.hitDie,
  });

  final int nextLevel;
  final int conMod;

  /// Numero di facce del Dado Vita della classe.
  /// Esempi: d6 -> 6, d8 -> 8, d10 -> 10, d12 -> 12.
  final int hitDie;

  /// Valore medio fisso del Dado Vita per l'avanzamento:
  /// metà del dado + 1.
  ///
  /// d6 -> 4
  /// d8 -> 5
  /// d10 -> 6
  /// d12 -> 7
  int get averageHitDie => (hitDie ~/ 2) + 1;

  @override
  State<HpDialog> createState() => _HpDialogState();
}

class _HpDialogState extends State<HpDialog> {
  int? rolled;

  int gainedHp(int dieValue) => max(1, dieValue + widget.conMod);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('PF · livello ${widget.nextLevel}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scegli il valore del Dado Vita per questo livello. '
              'Il modificatore di Costituzione viene applicato separatamente.',
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VALORE MEDIO DEL d${widget.hitDie}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+${widget.averageHitDie}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text('Costituzione: ${sign(widget.conMod)}'),
                  Text(
                    'PF ottenuti: +${gainedHp(widget.averageHitDie)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (rolled != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎲 d${widget.hitDie} = $rolled',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text('Costituzione: ${sign(widget.conMod)}'),
                    Text(
                      'PF ottenuti: +${gainedHp(rolled!)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            const Text(
              'Eventuali bonus aggiuntivi, come la robustezza del Nano '
              'delle Colline, vengono calcolati separatamente dal Dado Vita.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              gainedHp(widget.averageHitDie),
            ),
            child: Text(
              'USA VALORE MEDIO +${widget.averageHitDie}',
            ),
          ),
          FilledButton(
            onPressed: () {
              setState(
                () => rolled = Random().nextInt(widget.hitDie) + 1,
              );
            },
            child: Text('TIRA d${widget.hitDie}'),
          ),
          if (rolled != null)
            FilledButton(
              onPressed: () => Navigator.pop(context, gainedHp(rolled!)),
              child: const Text('USA QUESTO TIRO'),
            ),
        ],
      );
}

class HitDiceDialog extends StatefulWidget {
  const HitDiceDialog({
    super.key,
    required this.available,
    required this.hitDie,
  });

  final int available;
  final int hitDie;
  @override
  State<HitDiceDialog> createState() => _HitDiceDialogState();
}

class _HitDiceDialogState extends State<HitDiceDialog> {
  int count = 0;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Riposo breve'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Il Ki verrà recuperato. Scegli quanti Dadi Vita spendere.'),
            const SizedBox(height: 12),
            Text('Disponibili: ${widget.available}d${widget.hitDie}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: count > 0 ? () => setState(() => count--) : null,
                    icon: const Icon(Icons.remove_circle_outline)),
                Text('$count d${widget.hitDie}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: count < widget.available
                        ? () => setState(() => count++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ANNULLA')),
          FilledButton(
            onPressed: () => Navigator.pop(context, count),
            child: Text(
              count == 0 ? 'SOLO RIPOSO' : 'TIRA $count d${widget.hitDie}',
            ),
          ),
        ],
      );
}

class SubclassPage extends StatelessWidget {
  const SubclassPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tradizione Monastica')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                  'Tocca una Via per vedere cosa offre. La scelta non viene salvata finché non premi “Scegli questa Via”.'),
              const SizedBox(height: 10),
              ...monkClass.subclasses.keys.map(
                (s) => Card(
                  child: ListTile(
                    title: Text(s),
                    subtitle: Text(
                        'Livello 3: ${(monkClass.subclasses[s]?.featuresByLevel[3] ?? const <String>[]).join(', ')}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final confirmed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SubclassPreviewPage(name: s)),
                      );
                      if (confirmed == true && context.mounted) {
                        Navigator.pop(context, s);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class SubclassPreviewPage extends StatelessWidget {
  const SubclassPreviewPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final level3 =
        monkClass.subclasses[name]?.featuresByLevel[3] ?? const <String>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(monkClass.subclasses[name]?.description ?? ''),
            const SizedBox(height: 18),
            Text('Ottieni al livello 3',
                style: Theme.of(context).textTheme.titleLarge),
            ...level3.map((f) => ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(f),
                )),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.arrow_back),
              label: const Text('INDIETRO · GUARDA LE ALTRE VIE'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.check),
              label: const Text('SCEGLI QUESTA VIA'),
            ),
          ],
        ),
      ),
    );
  }
}

class AsiPage extends StatefulWidget {
  const AsiPage({super.key, required this.hero});
  final HeroData hero;
  @override
  State<AsiPage> createState() => _AsiPageState();
}

class _AsiPageState extends State<AsiPage> {
  String mode = 'plus2';
  String? a1, a2;
  String? selectedFeat;

  @override
  void initState() {
    super.initState();
    selectedFeat = widget.hero.feat;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Livello 4 · ASI o Talento')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RadioGroup<String>(
                groupValue: mode,
                onChanged: (v) {
                  if (v != null) setState(() => mode = v);
                },
                child: const Column(
                  children: [
                    RadioListTile(
                        value: 'plus2', title: Text('+2 a una caratteristica')),
                    RadioListTile(
                        value: 'split',
                        title: Text('+1 a due caratteristiche diverse')),
                    RadioListTile(
                        value: 'feat', title: Text('Scegli un talento')),
                  ],
                ),
              ),
              if (mode != 'feat') ...[
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Caratteristica'),
                  items: abilities
                      .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text('$a · ${widget.hero.scores[a]}')))
                      .toList(),
                  onChanged: (v) => setState(() {
                    a1 = v;
                    if (a2 == v) a2 = null;
                  }),
                ),
                if (mode == 'split')
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Seconda caratteristica'),
                    items: abilities
                        .where((a) => a != a1)
                        .map((a) => DropdownMenuItem(
                            value: a,
                            child: Text('$a · ${widget.hero.scores[a]}')))
                        .toList(),
                    onChanged: (v) => setState(() => a2 = v),
                  ),
              ] else ...[
                const SizedBox(height: 10),
                const Text(
                    'Talenti V0.2 · selezione iniziale. Le descrizioni complete saranno aggiunte dalle fonti verificate.'),
                RadioGroup<String>(
                  groupValue: selectedFeat,
                  onChanged: (v) => setState(() => selectedFeat = v),
                  child: Column(
                    children: ['Allerta', 'Atleta', 'Fortunato']
                        .map((f) =>
                            RadioListTile<String>(value: f, title: Text(f)))
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (mode == 'feat') {
                    if (selectedFeat == null) return;
                    widget.hero.feat = selectedFeat;
                    Navigator.pop(context, true);
                    return;
                  }
                  if (a1 == null || (mode == 'split' && a2 == null)) return;
                  final inc1 = mode == 'plus2' ? 2 : 1;
                  widget.hero.baseScores[a1!] =
                      min(19, widget.hero.baseScores[a1!]! + inc1);
                  if (mode == 'split') {
                    widget.hero.baseScores[a2!] =
                        min(19, widget.hero.baseScores[a2!]! + 1);
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('CONFERMA SCELTA'),
              ),
            ],
          ),
        ),
      );
}
