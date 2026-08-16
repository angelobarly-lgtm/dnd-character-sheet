import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 15,
  'DES': 10,
  'COS': 14,
  'INT': 10,
  'SAG': 10,
  'CAR': 14,
};

void main() {
  group('Talenti PHB 2014 blocco 4', () {
    test('gli aumenti di caratteristica dei talenti non superano 20', () {
      final hero = HeroData(
        name: 'Limite caratteristica',
        raceId: RaceIds.tiefling,
        feat: FeatIds.heavilyArmored,
        baseScores: const {
          'FOR': 20,
          'DES': 10,
          'COS': 10,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
      );

      expect(hero.scores['FOR'], 20);
    });

    test('Corazzato Pesantemente aumenta FOR e concede competenza', () {
      final hero = HeroData(
        name: 'Corazzato',
        raceId: RaceIds.tiefling,
        feat: FeatIds.heavilyArmored,
        baseScores: baseScores,
      );

      expect(hero.scores['FOR'], 16);
      expect(
        hero.effectiveArmorProficiencies,
        contains('heavy_armor'),
      );

      final prerequisite =
          featDefinitions[FeatIds.heavilyArmored]!.prerequisites.single;
      expect(prerequisite.value, 'medium_armor');
    });

    test('Maestro Armature Pesanti richiede competenza corretta', () {
      final feat = featDefinitions[FeatIds.heavyArmorMaster]!;

      expect(feat.prerequisites, hasLength(1));
      expect(
        feat.prerequisites.single.type,
        FeatPrerequisiteType.proficiency,
      );
      expect(feat.prerequisites.single.value, 'heavy_armor');
    });

    test('Maestro Armature Pesanti riduce i tre danni non magici', () {
      final effect =
          featDefinitions[FeatIds.heavyArmorMaster]!.effects.ruleEffects.single;

      expect(effect.value, 3);
      expect(
        effect.referenceIds,
        orderedEquals([
          'bludgeoning',
          'piercing',
          'slashing',
        ]),
      );
      expect(effect.condition, 'while_wearing_heavy_armor');
    });

    test('Guaritore e Condottiero conservano le formule complete', () {
      final healer =
          featDefinitions[FeatIds.healer]!.effects.ruleEffects.firstWhere(
                (effect) => effect.id == 'healer_medical_treatment',
              );

      final leader =
          featDefinitions[FeatIds.inspiringLeader]!.effects.ruleEffects.single;

      expect(healer.type, CharacterRuleEffectType.resource);
      expect(healer.condition, contains('1d6_plus_4'));
      expect(healer.condition, contains('target_max_hit_dice'));

      expect(leader.type, CharacterRuleEffectType.resource);
      expect(leader.condition, contains('level_plus_charisma_modifier'));
    });
  });
}
