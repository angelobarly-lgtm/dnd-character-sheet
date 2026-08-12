import 'character_data.dart';

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
const Map<String, BackgroundDefinition> backgroundDefinitions = {};

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
