import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 14,
  'INT': 12,
  'SAG': 12,
  'CAR': 10,
};

void main() {
  group('Talento supplementare Iniziato al Combattimento', () {
    test('richiede competenza in almeno un’arma da guerra', () {
      final feat = featDefinitions[FeatIds.fightingInitiate]!;
      final prerequisite = feat.prerequisites.single;

      expect(
        prerequisite.type,
        FeatPrerequisiteType.proficiency,
      );
      expect(prerequisite.value, 'martial_weapon');

      final unable = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(),
      );

      final able = evaluateFeatEligibility(
        feat: feat,
        state: const CharacterEligibilityState(
          proficiencies: {'martial_weapon'},
        ),
      );

      expect(unable.canSelect, isFalse);
      expect(able.canSelect, isTrue);
    });

    test('permette un solo stile non già posseduto', () {
      final choice =
          featDefinitions[FeatIds.fightingInitiate]!.effects.choices.single;

      expect(choice.id, 'fighting_initiate_style');
      expect(choice.type, CharacterChoiceType.other);
      expect(
        choice.catalogId,
        CharacterChoiceCatalogIds.fightingStyles,
      );
      expect(choice.minimumSelections, 1);
      expect(choice.maximumSelections, 1);
      expect(choice.requireNewAcquisition, isTrue);
    });

    test('lo stile scelto dal talento entra negli stili effettivi', () {
      final hero = HeroData(
        name: 'Iniziato al Combattimento',
        raceId: RaceIds.tiefling,
        classId: ClassIds.wizard,
        feat: FeatIds.fightingInitiate,
        baseScores: scores,
        featChoices: const {
          'fighting_initiate_style': ['defense'],
        },
      );

      expect(
        hero.effectiveFightingStyleIds,
        contains('defense'),
      );
      expect(hero.hasDefenseFightingStyle, isTrue);
    });

    test('lo stile Difesa del talento aggiunge +1 CA con armatura', () {
      final hero = HeroData(
        name: 'Difesa',
        raceId: RaceIds.tiefling,
        classId: ClassIds.wizard,
        feat: FeatIds.fightingInitiate,
        baseScores: scores,
        featChoices: const {
          'fighting_initiate_style': ['defense'],
        },
        inventory: const [
          {
            'id': 'leather',
            'name': 'Armatura di cuoio',
            'catalogId': 'armor',
            'quantity': 1,
            'equipped': true,
          },
        ],
      );

      expect(hero.ac, 14);
    });
  });
}
