import 'character_data.dart';
import 'choice_data.dart';
import 'spell_data.dart';
import 'battle_master_maneuver_data.dart';
import 'fighting_style_data.dart';

/// Restituisce le opzioni disponibili per una CharacterChoiceDefinition.
///
/// Ordine di priorità:
/// 1. options
/// 2. optionIds
/// 3. constraints
List<CharacterChoiceOptionDefinition> resolveCharacterChoiceOptions(
  CharacterChoiceDefinition choice,
) {
  if (choice.options.isNotEmpty) {
    return choice.options;
  }

  if (choice.catalogId != null) {
    switch (choice.catalogId) {
      case CharacterChoiceCatalogIds.spells:
        return spellDefinitionsMatching(choice.constraints)
            .map(
              (spell) => CharacterChoiceOptionDefinition(
                id: spell.id,
                label: spell.content.name,
              ),
            )
            .toList();

      case CharacterChoiceCatalogIds.battleMasterManeuvers:
        return battleMasterManeuverDefinitions.values
            .map(
              (m) => CharacterChoiceOptionDefinition(
                id: m.id,
                label: m.name,
              ),
            )
            .toList(growable: false);

      case CharacterChoiceCatalogIds.fightingStyles:
        return fightingStyleDefinitions.values
            .map(
              (style) => CharacterChoiceOptionDefinition(
                id: style.id,
                label: style.name,
              ),
            )
            .toList();
    }
  }

  if (choice.optionIds.isNotEmpty) {
    return choice.optionIds
        .map(
          (id) => CharacterChoiceOptionDefinition(
            id: id,
            label: id,
          ),
        )
        .toList();
  }

  // LEGACY fallback.
  // I nuovi cataloghi devono usare catalogId.
  if (choice.constraints.isNotEmpty) {
    return spellDefinitionsMatching(choice.constraints)
        .map(
          (spell) => CharacterChoiceOptionDefinition(
            id: spell.id,
            label: spell.content.name,
          ),
        )
        .toList();
  }

  return const [];
}
