import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/choice_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 15,
  'DES': 14,
  'COS': 14,
  'INT': 10,
  'SAG': 12,
  'CAR': 16,
};

void main() {
  group('Talenti PHB 2014 blocco 10', () {
    test('Appostato richiede DES 13 e conserva le tre capacità', () {
      final feat = featDefinitions[FeatIds.skulker]!;

      expect(feat.prerequisites.single.value, 'DES');
      expect(feat.prerequisites.single.minimum, 13);
      expect(feat.effects.ruleEffects, hasLength(3));
    });

    test('Cecchino Arcano richiede capacità di lanciare incantesimi', () {
      final feat = featDefinitions[FeatIds.spellSniper]!;

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

    test('Cecchino Arcano concede il trucchetto con attacco scelto', () {
      final hero = HeroData(
        name: 'Cecchino Arcano',
        raceId: RaceIds.dwarf,
        feat: FeatIds.spellSniper,
        baseScores: scores,
        featChoices: const {
          'spell_sniper_class': ['warlock'],
          'spell_sniper_cantrip': ['eldritch_blast'],
        },
      );

      expect(
        hero.effectiveCharacterSpellIds,
        contains('eldritch_blast'),
      );
      expect(hero.effectiveSpellcastingAbility, 'CAR');

      final choices = featDefinitions[FeatIds.spellSniper]!.effects.choices;
      final cantrip = choices.last;

      expect(cantrip.minimumSelections, 1);
      expect(cantrip.maximumSelections, 1);

      final constraintKeys =
          cantrip.constraints.map((constraint) => constraint.key).toSet();

      expect(
        constraintKeys,
        containsAll([
          CharacterChoiceConstraintKeys.classId,
          CharacterChoiceConstraintKeys.spellLevel,
          CharacterChoiceConstraintKeys.spellAttack,
        ]),
      );
    });

    test('Combattente da Taverna applica FOR competenza e d4', () {
      final hero = HeroData(
        name: 'Combattente da Taverna',
        raceId: RaceIds.tiefling,
        feat: FeatIds.tavernBrawler,
        baseScores: scores,
        featChoices: const {
          'tavern_brawler_ability': ['FOR'],
        },
      );

      expect(hero.scores['FOR'], 16);
      expect(
        hero.effectiveWeaponProficiencies,
        contains('improvised_weapons'),
      );

      final unarmed = featDefinitions[FeatIds.tavernBrawler]!
          .effects
          .ruleEffects
          .firstWhere(
            (effect) => effect.id == 'tavern_brawler_unarmed_strike',
          );

      expect(unarmed.value, 4);
      expect(unarmed.referenceIds, ['1d4']);
    });

    test('Robusto aggiunge due PF per ogni livello', () {
      final normal = HeroData(
        name: 'Normale',
        raceId: RaceIds.tiefling,
        classId: ClassIds.fighter,
        level: 5,
        baseScores: scores,
      );

      final tough = HeroData(
        name: 'Robusto',
        raceId: RaceIds.tiefling,
        classId: ClassIds.fighter,
        level: 5,
        feat: FeatIds.tough,
        baseScores: scores,
      );

      expect(tough.maxHp - normal.maxHp, 10);
    });
  });
}
