import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const physicalScores = <String, int>{
  'FOR': 15,
  'DES': 10,
  'COS': 14,
  'INT': 10,
  'SAG': 10,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 1', () {
    test('Allerta applica +5 iniziativa e conserva gli effetti condizionali',
        () {
      final hero = HeroData(
        name: 'Allerta',
        raceId: RaceIds.dwarf,
        feat: FeatIds.alert,
        baseScores: physicalScores,
      );

      expect(hero.initiative, 5);

      final targets = featDefinitions[FeatIds.alert]!
          .effects
          .ruleEffects
          .map((effect) => effect.target)
          .toSet();

      expect(targets, contains('surprised'));
      expect(targets, contains('incoming_attack_advantage'));
    });

    test('Atleta aumenta di uno soltanto FOR o DES scelto', () {
      final hero = HeroData(
        name: 'Atleta',
        raceId: RaceIds.dwarf,
        feat: FeatIds.athlete,
        baseScores: physicalScores,
        featChoices: const {
          'athlete_ability': ['FOR'],
        },
      );

      expect(hero.scores['FOR'], 16);
      expect(hero.scores['DES'], 10);
    });

    test('Atleta contiene tutte le modifiche di movimento', () {
      final effects = featDefinitions[FeatIds.athlete]!.effects.ruleEffects;

      final values = {
        for (final effect in effects) effect.target: effect.value,
      };

      expect(values['stand_from_prone_cost'], 1.5);
      expect(values['climbing_extra_movement_cost'], 0);
      expect(values['running_jump_required_distance'], 1.5);
    });

    test('Attore aumenta Carisma di uno e conserva le capacità speciali', () {
      final hero = HeroData(
        name: 'Attore',
        raceId: RaceIds.dwarf,
        feat: FeatIds.actor,
        baseScores: const {
          'FOR': 10,
          'DES': 10,
          'COS': 10,
          'INT': 10,
          'SAG': 10,
          'CAR': 15,
        },
      );

      expect(hero.scores['CAR'], 16);

      final targets = featDefinitions[FeatIds.actor]!
          .effects
          .ruleEffects
          .map((effect) => effect.target)
          .toSet();

      expect(targets, contains('impersonation_checks'));
      expect(targets, contains('speech_and_sound_mimicry'));
    });

    test('Carica non contiene scelte appartenenti a Incantatore Rituale', () {
      final effects = featDefinitions[FeatIds.charger]!.effects;

      expect(effects.choices, isEmpty);

      final targets =
          effects.ruleEffects.map((effect) => effect.target).toSet();

      expect(targets, contains('bonus_action_after_dash'));
      expect(targets, contains('charger_attack_or_shove'));
    });
  });
}
