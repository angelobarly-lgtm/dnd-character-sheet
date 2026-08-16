// Vincoli utilizzati dalle scelte dinamiche.
//
// Questo file è condiviso da character_data.dart,
// spell_data.dart e in futuro class_data.dart.

class CharacterChoiceConstraint {
  final String key;
  final List<String> values;

  /// Se valorizzato, il valore del vincolo viene ricavato
  /// dalla scelta effettuata in un'altra CharacterChoiceDefinition.
  final String? valueFromChoice;

  const CharacterChoiceConstraint({
    required this.key,
    this.values = const [],
    this.valueFromChoice,
  });
}

abstract final class CharacterChoiceConstraintKeys {
  static const spellLevel = 'spell_level';
  static const classId = 'class_id';
  static const spellSchool = 'spell_school';
  static const ritual = 'ritual';
  static const spellAttack = 'spell_attack';
}

/// Cataloghi condivisi utilizzabili dalle CharacterChoiceDefinition.
abstract final class CharacterChoiceCatalogIds {
  static const spells = 'spells';
  static const fightingStyles = 'fighting_styles';
  static const battleMasterManeuvers = 'battle_master_maneuvers';
  static const maneuvers = 'maneuvers';
  static const eldritchInvocations = 'eldritch_invocations';
  static const metamagic = 'metamagic';
}
