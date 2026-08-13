import 'package:flutter_test/flutter_test.dart';

import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';

const phbFeatIds = <String>{
  FeatIds.alert,
  FeatIds.athlete,
  FeatIds.actor,
  FeatIds.charger,
  FeatIds.crossbowExpert,
  FeatIds.defensiveDuelist,
  FeatIds.dualWielder,
  FeatIds.dungeonDelver,
  FeatIds.durable,
  FeatIds.elementalAdept,
  FeatIds.grappler,
  FeatIds.greatWeaponMaster,
  FeatIds.healer,
  FeatIds.heavilyArmored,
  FeatIds.heavyArmorMaster,
  FeatIds.inspiringLeader,
  FeatIds.keenMind,
  FeatIds.lightArmorMaster,
  FeatIds.linguist,
  FeatIds.lucky,
  FeatIds.mageSlayer,
  FeatIds.magicInitiate,
  FeatIds.martialAdept,
  FeatIds.mediumArmorMaster,
  FeatIds.mobile,
  FeatIds.moderatelyArmored,
  FeatIds.mountedCombatant,
  FeatIds.observant,
  FeatIds.polearmMaster,
  FeatIds.resilient,
  FeatIds.ritualCaster,
  FeatIds.savageAttacker,
  FeatIds.sentinel,
  FeatIds.sharpshooter,
  FeatIds.shieldMaster,
  FeatIds.skilled,
  FeatIds.skulker,
  FeatIds.spellSniper,
  FeatIds.tavernBrawler,
  FeatIds.tough,
  FeatIds.warCaster,
  FeatIds.weaponMaster,
};

bool hasMechanicalDefinition(FeatDefinition feat) {
  final effects = feat.effects;

  return feat.prerequisites.isNotEmpty ||
      effects.abilityBonuses.isNotEmpty ||
      effects.skillProficiencies.isNotEmpty ||
      effects.savingThrowProficiencies.isNotEmpty ||
      effects.weaponProficiencies.isNotEmpty ||
      effects.armorProficiencies.isNotEmpty ||
      effects.toolProficiencies.isNotEmpty ||
      effects.languages.isNotEmpty ||
      effects.damageResistances.isNotEmpty ||
      effects.savingThrowAdvantageAgainst.isNotEmpty ||
      effects.conditionImmunities.isNotEmpty ||
      effects.darkvisionRange != null ||
      effects.walkingSpeedOverride != null ||
      effects.hitPointsPerLevelBonus != 0 ||
      effects.armorClassBonus != 0 ||
      effects.initiativeBonus != 0 ||
      effects.walkingSpeedBonus != 0 ||
      effects.grantedFeatureIds.isNotEmpty ||
      effects.grantedFeatIds.isNotEmpty ||
      effects.grantedSpellIds.isNotEmpty ||
      effects.grantedCantripIds.isNotEmpty ||
      effects.grantedEquipmentIds.isNotEmpty ||
      effects.ruleEffects.isNotEmpty ||
      effects.choices.isNotEmpty;
}

void main() {
  test('PHB 2014 feat catalog contains exactly 42 feats', () {
    expect(phbFeatIds.length, 42);
    expect(
      featDefinitions.keys.toSet(),
      {
        ...phbFeatIds,
        FeatIds.fightingInitiate,
      },
    );
  });

  test('all PHB feats are structurally complete', () {
    for (final id in phbFeatIds) {
      final feat = featDefinitions[id];

      expect(
        feat,
        isNotNull,
        reason: 'Definizione mancante: $id',
      );

      expect(feat!.id, id);
      expect(feat.name.trim(), isNotEmpty);
      expect(feat.homebrew, isFalse);

      expect(feat.content.id, id);
      expect(feat.content.ownerId, id);
      expect(feat.content.name, feat.name);
      expect(feat.content.type, RuleContentType.feat);

      expect(
        feat.content.description.summary.trim(),
        isNotEmpty,
        reason: 'Summary mancante: $id',
      );
      expect(
        feat.content.description.details.trim(),
        isNotEmpty,
        reason: 'Details mancanti: $id',
      );

      expect(
        feat.content.source.isEmpty,
        isFalse,
        reason: 'Fonte mancante: $id',
      );
      expect(
        feat.content.source.name,
        'Manuale del Giocatore 2014',
      );

      expect(
        feat.content.visual,
        isNotNull,
        reason: 'Identità visuale mancante: $id',
      );
      expect(
        feat.content.visual!.family,
        RuleVisualFamily.feat,
      );
      expect(feat.content.visual!.iconId, id);

      expect(
        hasMechanicalDefinition(feat),
        isTrue,
        reason: 'Effetti meccanici mancanti: $id',
      );

      final choiceIds =
          feat.effects.choices.map((choice) => choice.id).toList();

      expect(
        choiceIds.toSet().length,
        choiceIds.length,
        reason: 'Choice ID duplicati: $id',
      );

      for (final choice in feat.effects.choices) {
        expect(choice.id.trim(), isNotEmpty);
        expect(choice.label.trim(), isNotEmpty);
        expect(
          choice.minimumSelections,
          greaterThanOrEqualTo(0),
        );
        expect(
          choice.maximumSelections,
          greaterThanOrEqualTo(
            choice.minimumSelections,
          ),
        );
      }

      final ruleEffectIds =
          feat.effects.ruleEffects.map((effect) => effect.id).toList();

      expect(
        ruleEffectIds.toSet().length,
        ruleEffectIds.length,
        reason: 'Rule effect ID duplicati: $id',
      );
    }
  });

  test('supplementary feat remains outside PHB scope', () {
    expect(
      phbFeatIds.contains(FeatIds.fightingInitiate),
      isFalse,
    );

    final feat = featDefinitions[FeatIds.fightingInitiate];

    expect(feat, isNotNull);
    expect(feat!.content.ownerId, FeatIds.fightingInitiate);
    expect(feat.content.type, RuleContentType.feat);
    expect(feat.content.source.isEmpty, isFalse);
    expect(
      feat.content.source.name,
      'Il Calderone Omnicomprensivo di Tasha',
    );
    expect(feat.content.visual, isNotNull);
    expect(
      feat.content.visual!.family,
      RuleVisualFamily.feat,
    );
    expect(
      feat.content.visual!.iconId,
      FeatIds.fightingInitiate,
    );
  });
}
