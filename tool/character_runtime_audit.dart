import 'dart:io';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';

import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/choice_constraint_resolver.dart';
import 'package:dnd_character_sheet/data/character_data.dart';

import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/choice_option_resolver.dart';

int runtimeTests = 0;
int runtimePassed = 0;
int runtimeFailed = 0;

void expectAbilityBonus({
  required String label,
  required ResolvedFeatEffects? resolved,
  required String ability,
  required int amount,
}) {
  if (resolved == null) {
    stdout.writeln('FAIL $label (resolve returned null)');
    return;
  }

  final ok = resolved.effects.abilityBonuses.any(
    (b) => b.ability == ability && b.amount == amount,
  );

  runtimeTests++;

  if (ok) {
    runtimePassed++;
    stdout.writeln('PASS $label');
  } else {
    runtimeFailed++;
    stdout.writeln(
      'FAIL $label (expected $ability +$amount)',
    );
  }
}

void expectArmorProficiency({
  required String label,
  required ResolvedFeatEffects? resolved,
  required String armorId,
}) {
  if (resolved == null) {
    stdout.writeln('FAIL $label (resolve returned null)');
    return;
  }

  final ok = resolved.effects.armorProficiencies.contains(armorId);

  runtimeTests++;

  if (ok) {
    runtimePassed++;
    stdout.writeln('PASS $label');
  } else {
    runtimeFailed++;
    stdout.writeln(
      'FAIL $label (missing armor proficiency: $armorId)',
    );
  }
}

void main() {
  stdout.writeln('========================================');
  stdout.writeln(' D&D CHARACTER RUNTIME AUDIT');
  stdout.writeln('========================================');
  stdout.writeln();

  stdout.writeln('STEP 1  Character creation .......... TODO');
  stdout.writeln('STEP 2  Race application ............ TODO');
  stdout.writeln('STEP 3  Class application ........... TODO');
  stdout.writeln('STEP 4  Ability Score Improvement ... TODO');
  stdout.writeln('STEP 5  Feat prerequisites .......... TODO');
  stdout.writeln('STEP 6  Feat effects ................ TODO');
  stdout.writeln('STEP 7  Spell acquisition ........... TODO');
  stdout.writeln('STEP 8  Character choices ........... TODO');
  stdout.writeln();

  stdout.writeln();
  stdout.writeln('DISCOVERY');
  stdout.writeln('---------');

  stdout.writeln('✓ CharacterChoiceDefinition -> CharacterEffects');
  stdout.writeln('✓ Ability choices generate AbilityBonusDefinition');
  stdout.writeln('✓ Feat effects are merged by _mergeFeatEffects()');
  stdout.writeln();

  stdout.writeln('NEXT RUNTIME TEST');
  stdout.writeln('-----------------');
  stdout.writeln('Athlete');
  stdout.writeln('  -> choose STR');
  stdout.writeln('  -> expect AbilityBonus(STR,+1)');
  stdout.writeln();

  stdout.writeln();
  stdout.writeln('========================================');
  stdout.writeln('FEAT RUNTIME TESTS');
  stdout.writeln('========================================');

  final athleteStr = resolveFeatEffects(
    featId: FeatIds.athlete,
    selections: {
      'athlete_ability': ['FOR'],
    },
  );

  expectAbilityBonus(
    label: 'Athlete -> FOR +1',
    resolved: athleteStr,
    ability: 'FOR',
    amount: 1,
  );

  final athleteDex = resolveFeatEffects(
    featId: FeatIds.athlete,
    selections: {
      'athlete_ability': ['DES'],
    },
  );

  expectAbilityBonus(
    label: 'Athlete -> DES +1',
    resolved: athleteDex,
    ability: 'DES',
    amount: 1,
  );

  stdout.writeln();
  stdout.writeln('HEAVILY ARMORED');

  final heavilyArmored = resolveFeatEffects(
    featId: FeatIds.heavilyArmored,
  );

  expectAbilityBonus(
    label: 'Heavily Armored -> FOR +1',
    resolved: heavilyArmored,
    ability: 'FOR',
    amount: 1,
  );

  expectArmorProficiency(
    label: 'Heavily Armored -> Heavy Armor',
    resolved: heavilyArmored,
    armorId: 'heavy_armor',
  );

  stdout.writeln();

  stdout.writeln('LIGHTLY ARMORED');

  final lightlyArmored = resolveFeatEffects(
    featId: FeatIds.lightArmorMaster,
    selections: {
      'lightly_armored_ability': ['FOR'],
    },
  );

  expectAbilityBonus(
    label: 'Lightly Armored -> FOR +1',
    resolved: lightlyArmored,
    ability: 'FOR',
    amount: 1,
  );

  expectArmorProficiency(
    label: 'Lightly Armored -> Light Armor',
    resolved: lightlyArmored,
    armorId: 'light_armor',
  );

  stdout.writeln();

  stdout.writeln('MODERATELY ARMORED');

  final moderatelyArmored = resolveFeatEffects(
    featId: FeatIds.moderatelyArmored,
    selections: {
      'moderately_armored_ability': ['FOR'],
    },
  );

  expectAbilityBonus(
    label: 'Moderately Armored -> FOR +1',
    resolved: moderatelyArmored,
    ability: 'FOR',
    amount: 1,
  );

  expectArmorProficiency(
    label: 'Moderately Armored -> Medium Armor',
    resolved: moderatelyArmored,
    armorId: 'medium_armor',
  );

  expectArmorProficiency(
    label: 'Moderately Armored -> Shield',
    resolved: moderatelyArmored,
    armorId: 'shield',
  );

  stdout.writeln();

  stdout.writeln();

  stdout.writeln('HEAVY ARMOR MASTER');

  final heavyArmorMaster = resolveFeatEffects(
    featId: FeatIds.heavyArmorMaster,
  );

  expectAbilityBonus(
    label: 'Heavy Armor Master -> FOR +1',
    resolved: heavyArmorMaster,
    ability: 'FOR',
    amount: 1,
  );

  final hasRuleEffect = heavyArmorMaster?.effects.ruleEffects.any(
        (e) => e.id == 'heavy_armor_master_damage_reduction',
      ) ??
      false;

  runtimeTests++;

  if (hasRuleEffect) {
    runtimePassed++;
    stdout.writeln(
      'PASS Heavy Armor Master -> Damage Reduction Rule',
    );
  } else {
    runtimeFailed++;
    stdout.writeln(
      'FAIL Heavy Armor Master -> Damage Reduction Rule',
    );
  }

  stdout.writeln();

  stdout.writeln('MEDIUM ARMOR MASTER');

  final mediumArmorMaster = resolveFeatEffects(
    featId: FeatIds.mediumArmorMaster,
  );

  for (final ruleId in const [
    'medium_armor_master_dex_cap',
    'medium_armor_master_no_stealth_disadvantage',
  ]) {
    final ok = mediumArmorMaster?.effects.ruleEffects.any(
          (e) => e.id == ruleId,
        ) ??
        false;

    runtimeTests++;

    if (ok) {
      runtimePassed++;
      stdout.writeln('PASS Medium Armor Master -> $ruleId');
    } else {
      runtimeFailed++;
      stdout.writeln('FAIL Medium Armor Master -> $ruleId');
    }
  }

  stdout.writeln();

  stdout.writeln('OBSERVANT');

  final observantInt = resolveFeatEffects(
    featId: FeatIds.observant,
    selections: {
      'observant_ability': ['INT'],
    },
  );

  expectAbilityBonus(
    label: 'Observant -> INT +1',
    resolved: observantInt,
    ability: 'INT',
    amount: 1,
  );

  final observantWis = resolveFeatEffects(
    featId: FeatIds.observant,
    selections: {
      'observant_ability': ['SAG'],
    },
  );

  expectAbilityBonus(
    label: 'Observant -> SAG +1',
    resolved: observantWis,
    ability: 'SAG',
    amount: 1,
  );

  final hasPassiveRule = observantInt?.effects.ruleEffects.any(
        (e) => e.id == 'observant_passive_perception',
      ) ??
      false;

  runtimeTests++;

  if (hasPassiveRule) {
    runtimePassed++;
    stdout.writeln(
      'PASS Observant -> Passive Perception Rule',
    );
  } else {
    runtimeFailed++;
    stdout.writeln(
      'FAIL Observant -> Passive Perception Rule',
    );
  }

  stdout.writeln();

  stdout.writeln();

  stdout.writeln('RESILIENT');

  final resilientStr = resolveFeatEffects(
    featId: FeatIds.resilient,
    selections: {
      'resilient_ability': ['FOR'],
    },
  );

  expectAbilityBonus(
    label: 'Resilient -> FOR +1',
    resolved: resilientStr,
    ability: 'FOR',
    amount: 1,
  );

  runtimeTests++;

  if (resilientStr?.effects.savingThrowProficiencies.contains('FOR') ?? false) {
    runtimePassed++;
    stdout.writeln('PASS Resilient -> FOR Save');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Resilient -> FOR Save');
  }

  final resilientDex = resolveFeatEffects(
    featId: FeatIds.resilient,
    selections: {
      'resilient_ability': ['DES'],
    },
  );

  expectAbilityBonus(
    label: 'Resilient -> DES +1',
    resolved: resilientDex,
    ability: 'DES',
    amount: 1,
  );

  runtimeTests++;

  if (resilientDex?.effects.savingThrowProficiencies.contains('DES') ?? false) {
    runtimePassed++;
    stdout.writeln('PASS Resilient -> DES Save');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Resilient -> DES Save');
  }

  stdout.writeln();

  stdout.writeln('WEAPON MASTER');

  final weaponMaster = resolveFeatEffects(
    featId: FeatIds.weaponMaster,
    selections: {
      'weapon_master_ability': ['FOR'],
      'weapon_master_weapons': [
        'longsword',
        'longbow',
        'warhammer',
        'rapier',
      ],
    },
  );

  expectAbilityBonus(
    label: 'Weapon Master -> FOR +1',
    resolved: weaponMaster,
    ability: 'FOR',
    amount: 1,
  );

  for (final weapon in [
    'longsword',
    'longbow',
    'warhammer',
    'rapier',
  ]) {
    runtimeTests++;

    if (weaponMaster?.effects.weaponProficiencies.contains(weapon) ?? false) {
      runtimePassed++;
      stdout.writeln('PASS Weapon Master -> $weapon');
    } else {
      runtimeFailed++;
      stdout.writeln('FAIL Weapon Master -> $weapon');
    }
  }

  stdout.writeln();
  stdout.writeln('========================================');
  stdout.writeln('SPELL CHOICE ENGINE');
  stdout.writeln('========================================');

  final wizardCantrips = spellDefinitionsMatching([
    const CharacterChoiceConstraint(
      key: CharacterChoiceConstraintKeys.classId,
      values: ['wizard'],
    ),
    const CharacterChoiceConstraint(
      key: CharacterChoiceConstraintKeys.spellLevel,
      values: ['0'],
    ),
  ]);

  runtimeTests++;

  final okWizardCantrips = wizardCantrips.isNotEmpty &&
      wizardCantrips.every(
        (spell) => spell.level == 0 && spell.classIds.contains('wizard'),
      );

  if (okWizardCantrips) {
    runtimePassed++;
    stdout.writeln('PASS Wizard cantrip filter');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Wizard cantrip filter');
  }

  final clericSpells = spellDefinitionsMatching([
    const CharacterChoiceConstraint(
      key: CharacterChoiceConstraintKeys.classId,
      values: ['cleric'],
    ),
  ]);

  runtimeTests++;

  final okClericClass = clericSpells.isNotEmpty &&
      clericSpells.every(
        (spell) => spell.classIds.contains('cleric'),
      );

  if (okClericClass) {
    runtimePassed++;
    stdout.writeln('PASS Cleric class filter');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Cleric class filter');
  }

  final wizardLevel1 = spellDefinitionsMatching([
    const CharacterChoiceConstraint(
      key: CharacterChoiceConstraintKeys.classId,
      values: ['wizard'],
    ),
    const CharacterChoiceConstraint(
      key: CharacterChoiceConstraintKeys.spellLevel,
      values: ['1'],
    ),
  ]);

  runtimeTests++;

  final okWizardLevel1 = wizardLevel1.isNotEmpty &&
      wizardLevel1.every(
        (spell) => spell.level == 1 && spell.classIds.contains('wizard'),
      );

  if (okWizardLevel1) {
    runtimePassed++;
    stdout.writeln('PASS Wizard level 1 filter');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Wizard level 1 filter');
  }

  final resolvedWizardChoice = resolveCharacterChoiceOptions(
    CharacterChoiceDefinition(
      id: 'wizard_cantrips',
      label: 'Wizard Cantrips',
      type: CharacterChoiceType.cantrip,
      constraints: const [
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.classId,
          values: ['wizard'],
        ),
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.spellLevel,
          values: ['0'],
        ),
      ],
    ),
  );

  runtimeTests++;

  final okChoiceResolver = resolvedWizardChoice.isNotEmpty &&
      resolvedWizardChoice.every(
        (option) => option.id.isNotEmpty && option.label.isNotEmpty,
      );

  if (okChoiceResolver) {
    runtimePassed++;
    stdout.writeln('PASS Choice resolver (wizard cantrips)');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Choice resolver (wizard cantrips)');
  }

  stdout.writeln();
  stdout.writeln();

  runtimeTests++;

  final resolvedConstraints = resolveChoiceConstraints(
    constraints: const [
      CharacterChoiceConstraint(
        key: CharacterChoiceConstraintKeys.classId,
        valueFromChoice: 'magic_initiate_class',
      ),
      CharacterChoiceConstraint(
        key: CharacterChoiceConstraintKeys.spellLevel,
        values: ['0'],
      ),
    ],
    choiceState: const CharacterChoiceState(
      selections: {
        'magic_initiate_class': ['wizard'],
      },
    ),
  );

  final resolvedSpells = spellDefinitionsMatching(
    resolvedConstraints,
  );

  final okMagicInitiate = resolvedSpells.isNotEmpty &&
      resolvedSpells.every(
        (s) => s.level == 0 && s.classIds.contains('wizard'),
      );

  if (okMagicInitiate) {
    runtimePassed++;
    stdout.writeln('PASS Magic Initiate constraint resolver');
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Magic Initiate constraint resolver');
  }

  stdout.writeln();

  final ritualWizard = resolveCharacterChoiceOptions(
    const CharacterChoiceDefinition(
      id: 'runtime_ritual_test',
      label: 'Runtime Ritual Test',
      type: CharacterChoiceType.spell,
      catalogId: CharacterChoiceCatalogIds.spells,
      constraints: [
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.classId,
          values: ['wizard'],
        ),
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.spellLevel,
          values: ['1'],
        ),
        CharacterChoiceConstraint(
          key: CharacterChoiceConstraintKeys.ritual,
          values: ['true'],
        ),
      ],
    ),
  );

  runtimeTests++;

  final okRitualWizard = ritualWizard.length == 2 &&
      ritualWizard.any((s) => s.label == 'Trova Famiglio') &&
      ritualWizard.any((s) => s.label == 'Identificare');

  if (okRitualWizard) {
    runtimePassed++;
    stdout.writeln('PASS Ritual Caster resolver');

    final fightingChoices = resolveCharacterChoiceOptions(
      const CharacterChoiceDefinition(
        id: 'runtime_fighting_style',
        label: 'Runtime Fighting Style',
        type: CharacterChoiceType.other,
        catalogId: CharacterChoiceCatalogIds.fightingStyles,
      ),
    );

    runtimeTests++;

    final okFighting = fightingChoices.length >= 11 &&
        fightingChoices.any((c) => c.id == FightingStyleIds.archery) &&
        fightingChoices.any((c) => c.id == FightingStyleIds.defense);

    if (okFighting) {
      runtimePassed++;
      stdout.writeln('PASS Fighting Style catalog');
      final maneuvers = resolveCharacterChoiceOptions(
        const CharacterChoiceDefinition(
          id: 'runtime_maneuver_test',
          label: 'Runtime Maneuver Test',
          type: CharacterChoiceType.other,
          catalogId: CharacterChoiceCatalogIds.battleMasterManeuvers,
        ),
      );

      runtimeTests++;

      if (maneuvers.isNotEmpty) {
        runtimePassed++;
        stdout.writeln('PASS Battle Master maneuver catalog');
      } else {
        runtimeFailed++;
        stdout.writeln('FAIL Battle Master maneuver catalog');
      }
    } else {
      runtimeFailed++;
      stdout.writeln('FAIL Fighting Style catalog');
    }
  } else {
    runtimeFailed++;
    stdout.writeln('FAIL Ritual Caster resolver');
  }

  stdout.writeln('========================================');
  stdout.writeln('KNOWN RUNTIME FEATURES NOT YET IMPLEMENTED');
  stdout.writeln('========================================');

  const missingStructuredRules = [
    (
      'Observant',
      'Passive Perception / Passive Investigation bonus not yet modeled',
    ),
    (
      'Lucky',
      'Luck point mechanic not yet modeled',
    ),
    (
      'Mobile',
      'Opportunity attack immunity after melee attack not yet modeled',
    ),
  ];

  for (final item in missingStructuredRules) {
    stdout.writeln('TODO ${item.$1}');
    stdout.writeln('     ${item.$2}');
  }

  stdout.writeln('========================================');
  stdout.writeln('SUMMARY');
  stdout.writeln('========================================');
  stdout.writeln('Tests executed : $runtimeTests');
  stdout.writeln('Passed         : $runtimePassed');
  stdout.writeln('Failed         : $runtimeFailed');

  stdout.writeln('Runtime audit scaffold created.');
}
