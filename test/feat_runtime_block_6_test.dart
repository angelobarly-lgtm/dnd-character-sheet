import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 16,
  'COS': 14,
  'INT': 16,
  'SAG': 12,
  'CAR': 10,
};

void main() {
  group('Talenti PHB 2014 blocco 6', () {
    test('Uccisore di Maghi usa reazione svantaggio e vantaggio', () {
      final effects = featDefinitions[FeatIds.mageSlayer]!.effects.ruleEffects;
      final byId = {
        for (final effect in effects) effect.id: effect,
      };

      expect(
        byId['mage_slayer_reaction_attack']!.type,
        CharacterRuleEffectType.reaction,
      );
      expect(
        byId['mage_slayer_concentration_disadvantage']!.type,
        CharacterRuleEffectType.disadvantage,
      );
      expect(
        byId['mage_slayer_spell_save_advantage']!.type,
        CharacterRuleEffectType.advantage,
      );
    });

    test('Iniziato alla Magia concede due trucchetti e un incantesimo', () {
      final hero = HeroData(
        name: 'Iniziato alla Magia',
        raceId: RaceIds.dwarf,
        feat: FeatIds.magicInitiate,
        baseScores: scores,
        featChoices: const {
          'magic_initiate_class': ['wizard'],
          'magic_initiate_cantrips': [
            'fire_bolt',
            'mage_hand',
          ],
          'magic_initiate_spell': ['magic_missile'],
        },
      );

      expect(
        hero.effectiveCharacterSpellIds,
        containsAll([
          'fire_bolt',
          'mage_hand',
          'magic_missile',
        ]),
      );
      expect(hero.effectiveSpellcastingAbility, 'INT');
    });

    test('Iniziato alla Magia impone quantità e livelli corretti', () {
      final choices = featDefinitions[FeatIds.magicInitiate]!.effects.choices;
      final byId = {
        for (final choice in choices) choice.id: choice,
      };

      expect(byId['magic_initiate_cantrips']!.minimumSelections, 2);
      expect(byId['magic_initiate_cantrips']!.maximumSelections, 2);
      expect(byId['magic_initiate_spell']!.minimumSelections, 1);
      expect(byId['magic_initiate_spell']!.maximumSelections, 1);
    });

    test('Adepto Marziale concede due manovre e un dado d6', () {
      final effects = featDefinitions[FeatIds.martialAdept]!.effects;
      final choice = effects.choices.single;
      final die = effects.ruleEffects.firstWhere(
        (effect) => effect.id == 'martial_adept_superiority_die',
      );

      expect(choice.id, 'martial_adept_maneuvers');
      expect(choice.minimumSelections, 2);
      expect(choice.maximumSelections, 2);
      expect(die.type, CharacterRuleEffectType.resource);
      expect(die.value, 1);
      expect(die.referenceIds, ['d6']);
      expect(die.condition, 'recovered_on_short_or_long_rest');
    });

    test('Maestro Armature Medie richiede la competenza corretta', () {
      final feat = featDefinitions[FeatIds.mediumArmorMaster]!;
      final prerequisite = feat.prerequisites.single;
      final dexterityCap = feat.effects.ruleEffects.firstWhere(
        (effect) => effect.id == 'medium_armor_master_dex_cap',
      );

      expect(
        prerequisite.type,
        FeatPrerequisiteType.proficiency,
      );
      expect(prerequisite.value, 'medium_armor');
      expect(dexterityCap.value, 3);
    });
  });
}
