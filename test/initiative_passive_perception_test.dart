import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const standardScores = <String, int>{
  'FOR': 10,
  'DES': 14,
  'COS': 14,
  'INT': 10,
  'SAG': 14,
  'CAR': 10,
};

void main() {
  group('Iniziativa PHB 2014', () {
    test('usa il modificatore di Destrezza', () {
      final hero = HeroData(
        name: 'Iniziativa base',
        raceId: RaceIds.tiefling,
        baseScores: standardScores,
      );

      expect(hero.scores['DES'], 14);
      expect(hero.initiative, 2);
    });

    test('Allerta aggiunge +5', () {
      final hero = HeroData(
        name: 'Personaggio Allerta',
        raceId: RaceIds.tiefling,
        feat: FeatIds.alert,
        baseScores: standardScores,
      );

      expect(hero.initiative, 7);
    });

    test('i bonus razziali scelti durante la creazione sono applicati', () {
      final hero = HeroData(
        name: 'Umano',
        raceId: RaceIds.human,
        baseScores: const {
          'FOR': 10,
          'DES': 15,
          'COS': 10,
          'INT': 10,
          'SAG': 15,
          'CAR': 10,
        },
      );

      expect(hero.scores['DES'], 16);
      expect(hero.initiative, 3);
      expect(hero.scores['SAG'], 16);
      expect(hero.passivePerception, 13);
    });
  });

  group('Percezione passiva PHB 2014', () {
    test('senza competenza usa 10 + modificatore di Saggezza', () {
      final hero = HeroData(
        name: 'Percezione base',
        raceId: RaceIds.tiefling,
        baseScores: standardScores,
      );

      expect(hero.passivePerception, 12);
    });

    test('la competenza aggiunge il bonus di competenza', () {
      final hero = HeroData(
        name: 'Percezione competente',
        raceId: RaceIds.tiefling,
        classId: ClassIds.rogue,
        level: 5,
        baseScores: standardScores,
        skillProficiencies: const ['Percezione'],
      );

      expect(hero.prof, 3);
      expect(hero.skillBonus('Percezione'), 5);
      expect(hero.passivePerception, 15);
    });

    test('Maestria raddoppia il bonus di competenza', () {
      final hero = HeroData(
        name: 'Percezione con Maestria',
        raceId: RaceIds.tiefling,
        classId: ClassIds.rogue,
        level: 5,
        baseScores: standardScores,
        skillProficiencies: const ['Percezione'],
        classChoices: const {
          'rogue_expertise_level_1': ['perception'],
        },
      );

      expect(hero.prof, 3);
      expect(hero.skillProficiencyMultiplier('Percezione'), 2);
      expect(hero.skillBonus('Percezione'), 8);
      expect(hero.passivePerception, 18);
    });

    test('Osservatore applica +1 SAG scelto e +5 alla passiva', () {
      final hero = HeroData(
        name: 'Personaggio Osservatore',
        raceId: RaceIds.tiefling,
        feat: FeatIds.observant,
        baseScores: const {
          'FOR': 10,
          'DES': 14,
          'COS': 14,
          'INT': 10,
          'SAG': 15,
          'CAR': 10,
        },
        featChoices: const {
          'observant_ability': ['SAG'],
        },
      );

      expect(hero.scores['SAG'], 16);
      expect(hero.skillBonus('Percezione'), 3);
      expect(hero.passivePerception, 18);
    });
  });
}
