import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 15,
  'COS': 14,
  'INT': 15,
  'SAG': 15,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 7', () {
    test('Mobile aggiunge esattamente 3 metri', () {
      final hero = HeroData(
        name: 'Mobile',
        raceId: RaceIds.tiefling,
        feat: FeatIds.mobile,
        baseScores: scores,
      );

      expect(hero.speed, 12);

      final movementEffects =
          featDefinitions[FeatIds.mobile]!.effects.ruleEffects.where(
                (effect) => effect.type == CharacterRuleEffectType.movement,
              );

      expect(movementEffects, hasLength(2));
    });

    test('Moderatamente Corazzato applica DES armature e scudi', () {
      final hero = HeroData(
        name: 'Moderatamente Corazzato',
        raceId: RaceIds.tiefling,
        feat: FeatIds.moderatelyArmored,
        baseScores: scores,
        featChoices: const {
          'moderately_armored_ability': ['DES'],
        },
      );

      expect(hero.scores['DES'], 16);
      expect(
        hero.effectiveArmorProficiencies,
        containsAll([
          'medium_armor',
          'shield',
        ]),
      );

      expect(
        featDefinitions[FeatIds.moderatelyArmored]!.prerequisites.single.value,
        'light_armor',
      );
    });

    test('Combattente in Sella non consuma una reazione', () {
      final effects =
          featDefinitions[FeatIds.mountedCombatant]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      expect(
        byId['mounted_combatant_advantage']!.type,
        CharacterRuleEffectType.advantage,
      );
      expect(
        byId['mounted_combatant_redirect_attack']!.type,
        CharacterRuleEffectType.conditional,
      );
      expect(
        byId['mounted_combatant_mount_evasion']!.condition,
        'evasion',
      );
    });

    test('Osservatore applica entrambe le passive a +5', () {
      final hero = HeroData(
        name: 'Osservatore',
        raceId: RaceIds.tiefling,
        feat: FeatIds.observant,
        baseScores: scores,
        featChoices: const {
          'observant_ability': ['INT'],
        },
      );

      expect(hero.scores['INT'], 17);
      expect(hero.passivePerception, 17);
      expect(hero.passiveInvestigation, 18);
    });

    test('Osservatore include la lettura delle labbra', () {
      final effects = featDefinitions[FeatIds.observant]!.effects.ruleEffects;
      final readLips = effects.firstWhere(
        (effect) => effect.id == 'observant_read_lips',
      );

      expect(readLips.target, 'speech_reading');
      expect(
        readLips.condition,
        'can_see_creature_mouth_and_understand_language',
      );
    });
  });
}
