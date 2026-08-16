import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 10,
  'DES': 15,
  'COS': 14,
  'INT': 15,
  'SAG': 10,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 5', () {
    test('Mente Acuta aumenta INT e conserva le tre capacità', () {
      final hero = HeroData(
        name: 'Mente Acuta',
        raceId: RaceIds.dwarf,
        feat: FeatIds.keenMind,
        baseScores: baseScores,
      );

      expect(hero.scores['INT'], 16);

      final targets = featDefinitions[FeatIds.keenMind]!
          .effects
          .ruleEffects
          .map((effect) => effect.target)
          .toSet();

      expect(targets, contains('orientation'));
      expect(targets, contains('time_awareness'));
      expect(targets, contains('recent_memory'));
    });

    test('Corazzato Leggermente applica la caratteristica scelta', () {
      final hero = HeroData(
        name: 'Corazzato Leggermente',
        raceId: RaceIds.dwarf,
        feat: FeatIds.lightArmorMaster,
        baseScores: baseScores,
        featChoices: const {
          'lightly_armored_ability': ['DES'],
        },
      );

      expect(hero.scores['DES'], 16);
      expect(
        hero.effectiveArmorProficiencies,
        contains('light_armor'),
      );
    });

    test('Linguista applica INT e tutte le tre lingue scelte', () {
      final hero = HeroData(
        name: 'Linguista',
        raceId: RaceIds.dwarf,
        feat: FeatIds.linguist,
        baseScores: baseScores,
        featChoices: const {
          'linguist_languages': [
            'Elfico',
            'Goblin',
            'Orchesco',
          ],
        },
      );

      expect(hero.scores['INT'], 16);
      expect(
        hero.effectiveLanguages,
        containsAll([
          'Elfico',
          'Goblin',
          'Orchesco',
        ]),
      );
    });

    test('Linguista richiede esattamente tre lingue', () {
      final choice = featDefinitions[FeatIds.linguist]!.effects.choices.single;

      expect(choice.minimumSelections, 3);
      expect(choice.maximumSelections, 3);
      expect(choice.type, CharacterChoiceType.language);
    });

    test('Fortunato concede tre punti recuperati al riposo lungo', () {
      final effects = featDefinitions[FeatIds.lucky]!.effects.ruleEffects;
      final points = effects.firstWhere(
        (effect) => effect.id == 'lucky_luck_points',
      );

      expect(points.type, CharacterRuleEffectType.resource);
      expect(points.target, 'luck_points');
      expect(points.value, 3);
      expect(points.condition, 'recovered_on_long_rest');

      expect(
        effects.map((effect) => effect.id),
        containsAll([
          'lucky_extra_d20',
          'lucky_affect_attack_against_you',
        ]),
      );
    });
  });
}
