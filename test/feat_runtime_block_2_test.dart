import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Talenti PHB 2014 blocco 2', () {
    test('Esperto di Balestre contiene tutte le tre regole', () {
      final effects =
          featDefinitions[FeatIds.crossbowExpert]!.effects.ruleEffects;
      final targets = effects.map((effect) => effect.target).toSet();

      expect(effects, hasLength(3));
      expect(targets, contains('crossbow_loading_property'));
      expect(targets, contains('ranged_attack_disadvantage'));
      expect(targets, contains('hand_crossbow_bonus_attack'));
    });

    test('Duellante Difensivo non contiene manovre di Adepto Marziale', () {
      final effects = featDefinitions[FeatIds.defensiveDuelist]!.effects;

      expect(effects.choices, isEmpty);
      expect(effects.ruleEffects, hasLength(1));
      expect(
        effects.ruleEffects.single.type,
        CharacterRuleEffectType.reaction,
      );
      expect(
        effects.ruleEffects.single.target,
        'armor_class_against_triggering_melee_attack',
      );
    });

    test('Duellante Difensivo mantiene il requisito DES 13', () {
      final prerequisites =
          featDefinitions[FeatIds.defensiveDuelist]!.prerequisites;

      expect(prerequisites, hasLength(1));
      expect(prerequisites.single.value, 'DES');
      expect(prerequisites.single.minimum, 13);
    });

    test('Combattere con Due Armi conserva il bonus CA condizionale', () {
      final effects = featDefinitions[FeatIds.dualWielder]!.effects.ruleEffects;

      final armorClass = effects.firstWhere(
        (effect) => effect.id == 'dual_wielder_ac_bonus',
      );

      expect(armorClass.target, 'armor_class');
      expect(armorClass.value, 1);
      expect(armorClass.condition, 'wielding_two_melee_weapons');
    });

    test('Esperto di Dungeon usa tipi meccanici corretti', () {
      final effects =
          featDefinitions[FeatIds.dungeonDelver]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      expect(
        byId['dungeon_delver_secret_door_perception']!.type,
        CharacterRuleEffectType.advantage,
      );
      expect(
        byId['dungeon_delver_secret_door_investigation']!.type,
        CharacterRuleEffectType.advantage,
      );
      expect(
        byId['dungeon_delver_trap_saves']!.type,
        CharacterRuleEffectType.advantage,
      );
      expect(
        byId['dungeon_delver_trap_damage_resistance']!.type,
        CharacterRuleEffectType.conditional,
      );
      expect(
        byId['dungeon_delver_normal_pace_trap_search']!.type,
        CharacterRuleEffectType.movement,
      );
    });
  });
}
