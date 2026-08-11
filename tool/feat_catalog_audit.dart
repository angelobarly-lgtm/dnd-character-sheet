import 'dart:io';

import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';

void main() {
  var errors = 0;
  var warnings = 0;

  void ok(String label) => stdout.writeln('${label.padRight(24, ".")} OK');

  void fail(String label, String message) {
    errors++;
    stdout.writeln('${label.padRight(24, ".")} ERROR');
    stdout.writeln('  • $message');
  }

  final definitions = featDefinitions.values.toList();

  // Duplicate ids
  final ids = <String>{};

  for (final feat in definitions) {
    if (!ids.add(feat.id)) {
      fail('Duplicate ids', feat.id);
    }
  }

  if (errors == 0) {
    ok('Duplicate ids');
  }

  // Definition keys
  var keyErrors = 0;

  featDefinitions.forEach((key, feat) {
    if (key != feat.id) {
      keyErrors++;
      fail('Definition keys', '$key != ${feat.id}');
    }
  });

  if (keyErrors == 0) {
    ok('Definition keys');
  }

  // Owner ids
  var ownerErrors = 0;

  for (final feat in definitions) {
    if (feat.content.ownerId != feat.id) {
      ownerErrors++;
      fail('Owner ids', feat.id);
    }
  }

  if (ownerErrors == 0) {
    ok('Owner ids');
  }

  // Names
  var nameErrors = 0;

  for (final feat in definitions) {
    if (feat.name.trim().isEmpty) {
      nameErrors++;
      fail('Names', feat.id);
    }

    if (feat.content.name.trim().isEmpty) {
      nameErrors++;
      fail('Content names', feat.id);
    }
  }

  if (nameErrors == 0) {
    ok('Names');
  }

  // Ability bonuses
  var abilityBonusWarnings = 0;

  const featsThatShouldIncreaseAbility = {
    // PHB 2014
    'actor',
    'athlete',
    'durable',
    'heavily_armored',
    'heavy_armor_master',
    'keen_mind',
    'lightly_armored',
    'linguist',
    'moderately_armored',
    'observant',
    'resilient',
    'tavern_brawler',
    'weapon_master',
  };

  for (final feat in definitions) {
    final hasAbilityBonus = feat.effects.abilityBonuses.isNotEmpty;

    final hasAbilityChoice = feat.effects.choices.any(
      (c) => c.type == CharacterChoiceType.ability,
    );

    final abilitySummary = hasAbilityBonus
        ? feat.effects.abilityBonuses
            .map((b) => '${b.ability}+${b.amount}')
            .join(', ')
        : hasAbilityChoice
            ? 'CHOICE'
            : 'NONE';

    if (featsThatShouldIncreaseAbility.contains(feat.id) &&
        !(hasAbilityBonus || hasAbilityChoice)) {
      abilityBonusWarnings++;
      stdout.writeln(
        'Ability bonuses....... WARNING (${feat.id} should grant +1 ability) [found: $abilitySummary]',
      );
    }

    if (!featsThatShouldIncreaseAbility.contains(feat.id) &&
        (hasAbilityBonus || hasAbilityChoice)) {
      abilityBonusWarnings++;
      stdout.writeln(
        'Ability bonuses....... WARNING (${feat.id} unexpectedly grants +1 ability) [found: $abilitySummary]',
      );
    }
  }

  if (abilityBonusWarnings == 0) {
    ok('Ability bonuses');
  } else {
    warnings += abilityBonusWarnings;
  }

  // Structured effects
  var effectWarnings = 0;

  for (final feat in definitions) {
    final e = feat.effects;

    final hasStructuredEffect = e.abilityBonuses.isNotEmpty ||
        e.choices.isNotEmpty ||
        e.skillProficiencies.isNotEmpty ||
        e.savingThrowProficiencies.isNotEmpty ||
        e.weaponProficiencies.isNotEmpty ||
        e.armorProficiencies.isNotEmpty ||
        e.toolProficiencies.isNotEmpty ||
        e.languages.isNotEmpty ||
        e.damageResistances.isNotEmpty ||
        e.savingThrowAdvantageAgainst.isNotEmpty ||
        e.conditionImmunities.isNotEmpty ||
        e.darkvisionRange != null ||
        e.walkingSpeedOverride != null ||
        e.hitPointsPerLevelBonus != 0 ||
        e.armorClassBonus != 0 ||
        e.initiativeBonus != 0 ||
        e.walkingSpeedBonus != 0 ||
        e.grantedFeatureIds.isNotEmpty ||
        e.grantedFeatIds.isNotEmpty ||
        e.grantedSpellIds.isNotEmpty ||
        e.grantedCantripIds.isNotEmpty ||
        e.grantedEquipmentIds.isNotEmpty ||
        e.ruleEffects.isNotEmpty;

    if (!hasStructuredEffect) {
      effectWarnings++;
      stdout.writeln(
        'Structured effects... WARNING (${feat.id} has no structured effects)',
      );

      stdout.writeln('    abilityBonuses ........ ${e.abilityBonuses.length}');
      stdout.writeln('    choices ............... ${e.choices.length}');
      stdout.writeln(
          '    skillProficiencies .... ${e.skillProficiencies.length}');
      stdout.writeln(
          '    savingThrows .......... ${e.savingThrowProficiencies.length}');
      stdout.writeln(
          '    weaponProficiencies ... ${e.weaponProficiencies.length}');
      stdout.writeln(
          '    armorProficiencies .... ${e.armorProficiencies.length}');
      stdout
          .writeln('    toolProficiencies ..... ${e.toolProficiencies.length}');
      stdout.writeln('    languages ............. ${e.languages.length}');
      stdout
          .writeln('    grantedFeatures ....... ${e.grantedFeatureIds.length}');
      stdout.writeln('    grantedFeats .......... ${e.grantedFeatIds.length}');
      stdout.writeln('    grantedSpells ......... ${e.grantedSpellIds.length}');
      stdout
          .writeln('    grantedCantrips ....... ${e.grantedCantripIds.length}');
      stdout.writeln(
          '    grantedEquipment ...... ${e.grantedEquipmentIds.length}');
      stdout.writeln('    ruleEffects ........... ${e.ruleEffects.length}');
      stdout.writeln();
    }
  }

  if (effectWarnings == 0) {
    ok('Structured effects');
  } else {
    warnings += effectWarnings;
  }

  // Rule effect ids
  var duplicateRuleEffectIds = 0;
  final seenRuleEffectIds = <String>{};

  for (final feat in definitions) {
    for (final effect in feat.effects.ruleEffects) {
      if (!seenRuleEffectIds.add(effect.id)) {
        duplicateRuleEffectIds++;
        stdout.writeln(
          'Rule effect ids...... WARNING (duplicate id: ${effect.id})',
        );
      }
    }
  }

  if (duplicateRuleEffectIds == 0) {
    ok('Rule effect ids');
  } else {
    warnings += duplicateRuleEffectIds;
  }

  stdout.writeln();
  stdout.writeln('Definitions: ${definitions.length}');
  stdout.writeln('Errors: $errors');
  stdout.writeln('Warnings: $warnings');

  if (errors == 0) {
    stdout.writeln();
    stdout.writeln('PHB FEAT CATALOG VERIFIED');
  } else {
    exitCode = 1;
  }
}
