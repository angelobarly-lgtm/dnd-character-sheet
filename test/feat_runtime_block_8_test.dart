import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 12,
  'COS': 15,
  'INT': 13,
  'SAG': 10,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 8', () {
    test('Maestro Armi ad Asta registra attacco bonus d4 e reazione', () {
      final effects =
          featDefinitions[FeatIds.polearmMaster]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      final bonus = byId['polearm_master_bonus_attack']!;
      final opportunity = byId['polearm_master_opportunity_reach']!;

      expect(bonus.value, 4);
      expect(
        bonus.referenceIds,
        containsAll([
          'glaive',
          'halberd',
          'quarterstaff',
          'spear',
        ]),
      );
      expect(
        bonus.condition,
        'bonus_attack_deals_1d4_bludgeoning_damage',
      );
      expect(
        opportunity.type,
        CharacterRuleEffectType.reaction,
      );
    });

    test('Resiliente aumenta la caratteristica e il relativo TS', () {
      final hero = HeroData(
        name: 'Resiliente',
        raceId: RaceIds.tiefling,
        feat: FeatIds.resilient,
        baseScores: scores,
        featChoices: const {
          'resilient_ability': ['COS'],
        },
      );

      expect(hero.scores['COS'], 16);
      expect(
        hero.effectiveSavingThrowProficiencies,
        contains('COS'),
      );
    });

    test('Incantatore Rituale accetta INT oppure SAG 13', () {
      final feat = featDefinitions[FeatIds.ritualCaster]!;

      final intelligence = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          abilityScores: {
            'INT': 13,
            'SAG': 8,
          },
        ),
      );

      final wisdom = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          abilityScores: {
            'INT': 8,
            'SAG': 13,
          },
        ),
      );

      final neither = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          abilityScores: {
            'INT': 12,
            'SAG': 12,
          },
        ),
      );

      expect(intelligence.canSelect, isTrue);
      expect(wisdom.canSelect, isTrue);
      expect(neither.canSelect, isFalse);
    });

    test('Incantatore Rituale concede i due rituali scelti', () {
      final hero = HeroData(
        name: 'Incantatore Rituale',
        raceId: RaceIds.dwarf,
        feat: FeatIds.ritualCaster,
        baseScores: scores,
        featChoices: const {
          'ritual_caster_class': ['wizard'],
          'ritual_caster_spells': [
            'detect_magic',
            'identify',
          ],
        },
      );

      expect(
        hero.effectiveCharacterSpellIds,
        containsAll([
          'detect_magic',
          'identify',
        ]),
      );
      expect(hero.effectiveSpellcastingAbility, 'INT');

      final spellChoice =
          featDefinitions[FeatIds.ritualCaster]!.effects.choices.last;

      expect(spellChoice.minimumSelections, 2);
      expect(spellChoice.maximumSelections, 2);
    });

    test('Aggressore Selvaggio limita il ritiro a una volta per turno', () {
      final effect =
          featDefinitions[FeatIds.savageAttacker]!.effects.ruleEffects.single;

      expect(effect.target, 'melee_weapon_damage_roll');
      expect(effect.condition, 'once_per_turn');
    });
  });
}
