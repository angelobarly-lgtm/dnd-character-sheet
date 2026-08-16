import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 14,
  'DES': 16,
  'COS': 14,
  'INT': 10,
  'SAG': 14,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 9', () {
    test('Sentinella azzera la velocità solo dopo avere colpito', () {
      final effects = featDefinitions[FeatIds.sentinel]!.effects.ruleEffects;
      final speed = effects.firstWhere(
        (effect) => effect.id == 'sentinel_speed_zero',
      );

      expect(speed.type, CharacterRuleEffectType.movement);
      expect(speed.value, 0);
      expect(
        speed.condition,
        'opportunity_attack_hits_until_end_of_turn',
      );

      expect(
        effects.map((effect) => effect.id),
        containsAll([
          'sentinel_ignore_disengage',
          'sentinel_protect_ally',
        ]),
      );
    });

    test('Tiratore Scelto separa -5 attacco e +10 danni', () {
      final effects =
          featDefinitions[FeatIds.sharpshooter]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      final attack = byId['sharpshooter_power_shot_to_hit']!;
      final damage = byId['sharpshooter_power_shot_damage']!;

      expect(attack.type, CharacterRuleEffectType.attackBonus);
      expect(attack.value, -5);
      expect(damage.type, CharacterRuleEffectType.damageBonus);
      expect(damage.value, 10);
    });

    test('Tiratore Scelto conserva gittata e copertura', () {
      final ids = featDefinitions[FeatIds.sharpshooter]!
          .effects
          .ruleEffects
          .map((effect) => effect.id)
          .toSet();

      expect(
        ids,
        containsAll([
          'sharpshooter_ignore_long_range_disadvantage',
          'sharpshooter_ignore_cover',
        ]),
      );
    });

    test('Maestro dello Scudo applica +2 al TS DES appropriato', () {
      final effects =
          featDefinitions[FeatIds.shieldMaster]!.effects.ruleEffects;
      final saveBonus = effects.firstWhere(
        (effect) => effect.id == 'shield_master_dexterity_save_bonus',
      );

      expect(saveBonus.target, 'dexterity_saving_throw');
      expect(saveBonus.value, 2);
      expect(saveBonus.condition, 'add_shield_ac_bonus');

      expect(
        effects
            .firstWhere(
              (effect) => effect.id == 'shield_master_evasion',
            )
            .type,
        CharacterRuleEffectType.reaction,
      );
    });

    test('Abile concede tre nuove competenze miste', () {
      final hero = HeroData(
        name: 'Abile',
        raceId: RaceIds.tiefling,
        feat: FeatIds.skilled,
        baseScores: scores,
        featChoices: const {
          'skilled_proficiencies': [
            'skill:perception',
            'skill:stealth',
            'tool:thieves_tools',
          ],
        },
      );

      expect(
        hero.effectiveSkillProficiencies,
        containsAll([
          'Percezione',
          'Furtività',
        ]),
      );
      expect(
        hero.effectiveToolProficiencies,
        contains('thieves_tools'),
      );

      final choice = featDefinitions[FeatIds.skilled]!.effects.choices.single;
      expect(choice.minimumSelections, 3);
      expect(choice.maximumSelections, 3);
      expect(choice.requireNewAcquisition, isTrue);
    });
  });
}
