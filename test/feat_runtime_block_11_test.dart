import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 15,
  'DES': 14,
  'COS': 14,
  'INT': 12,
  'SAG': 12,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 11', () {
    test('Incantatore da Guerra richiede capacità magica', () {
      final feat = featDefinitions[FeatIds.warCaster]!;

      final unable = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          canCastSpells: false,
        ),
      );

      final able = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          canCastSpells: true,
        ),
      );

      expect(unable.canSelect, isFalse);
      expect(able.canSelect, isTrue);
    });

    test('Incantatore da Guerra contiene tutti i tre effetti', () {
      final effects = featDefinitions[FeatIds.warCaster]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      expect(
        byId['war_caster_concentration_advantage']!.type,
        CharacterRuleEffectType.advantage,
      );
      expect(
        byId['war_caster_somatic_components']!.type,
        CharacterRuleEffectType.spellcasting,
      );
      expect(
        byId['war_caster_spell_opportunity_attack']!.type,
        CharacterRuleEffectType.reaction,
      );
    });

    test('Maestro d’Armi applica FOR e quattro competenze', () {
      final hero = HeroData(
        name: 'Maestro d’Armi',
        raceId: RaceIds.tiefling,
        feat: FeatIds.weaponMaster,
        baseScores: scores,
        featChoices: const {
          'weapon_master_ability': ['FOR'],
          'weapon_master_weapons': [
            'longsword',
            'longbow',
            'warhammer',
            'rapier',
          ],
        },
      );

      expect(hero.scores['FOR'], 16);
      expect(
        hero.effectiveWeaponProficiencies,
        containsAll([
          'longsword',
          'longbow',
          'warhammer',
          'rapier',
        ]),
      );
    });

    test('Maestro d’Armi richiede esattamente quattro armi', () {
      final choice =
          featDefinitions[FeatIds.weaponMaster]!.effects.choices.last;

      expect(choice.minimumSelections, 4);
      expect(choice.maximumSelections, 4);
      expect(choice.requireNewAcquisition, isFalse);
      expect(choice.type, CharacterChoiceType.weapon);
    });
  });
}
