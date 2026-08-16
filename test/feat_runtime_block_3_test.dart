import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Talenti PHB 2014 blocco 3', () {
    test('Durevole aumenta Costituzione di uno', () {
      final hero = HeroData(
        name: 'Durevole',
        raceId: RaceIds.tiefling,
        feat: FeatIds.durable,
        baseScores: const {
          'FOR': 10,
          'DES': 10,
          'COS': 15,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
      );

      expect(hero.scores['COS'], 16);

      final effect =
          featDefinitions[FeatIds.durable]!.effects.ruleEffects.single;
      expect(effect.target, 'hit_die_healing');
      expect(effect.value, 2);
    });

    test('Esperto Elementale richiede capacità di lanciare incantesimi', () {
      final prerequisites =
          featDefinitions[FeatIds.elementalAdept]!.prerequisites;

      expect(prerequisites, hasLength(1));
      expect(
        prerequisites.single.type,
        FeatPrerequisiteType.spellcasting,
      );
    });

    test('Esperto Elementale permette solo i cinque elementi PHB', () {
      final choices = featDefinitions[FeatIds.elementalAdept]!.effects.choices;

      expect(choices, hasLength(1));
      expect(choices.single.id, 'elemental_adept_damage_type');
      expect(
        choices.single.optionIds,
        orderedEquals([
          'acid',
          'cold',
          'fire',
          'lightning',
          'thunder',
        ]),
      );
    });

    test('Lottatore richiede FOR 13 e concede vantaggio', () {
      final feat = featDefinitions[FeatIds.grappler]!;
      final advantage = feat.effects.ruleEffects.firstWhere(
        (effect) => effect.id == 'grappler_advantage_against_grappled',
      );

      expect(feat.prerequisites.single.value, 'FOR');
      expect(feat.prerequisites.single.minimum, 13);
      expect(advantage.type, CharacterRuleEffectType.advantage);
      expect(advantage.target, 'attack_roll');
    });

    test('Maestro Armi Possenti applica -5 attacco e +10 danni', () {
      final effects =
          featDefinitions[FeatIds.greatWeaponMaster]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      final attack = byId['great_weapon_master_power_attack_to_hit']!;
      final damage = byId['great_weapon_master_power_attack_damage']!;

      expect(attack.type, CharacterRuleEffectType.attackBonus);
      expect(attack.value, -5);
      expect(damage.type, CharacterRuleEffectType.damageBonus);
      expect(damage.value, 10);
      expect(
        byId,
        contains('great_weapon_master_bonus_attack'),
      );
    });
  });
}
