import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/paladin_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final paladin = phbClassDefinitions[ClassIds.paladin]!;
  final vengeance = paladin.subclasses[PaladinSubclassIds.vengeance]!;

  const expectedSpells = <String>{
    'bane',
    'hunters_mark',
    'hold_person',
    'misty_step',
    'haste',
    'protection_from_energy',
    'banishment',
    'dimension_door',
    'hold_monster',
    'scrying',
  };

  test('Oath of Vengeance is registered as PHB Paladin content', () {
    expect(vengeance.id, PaladinSubclassIds.vengeance);
    expect(vengeance.name, 'Giuramento di Vendetta');
    expect(vengeance.classId, ClassIds.paladin);
    expect(vengeance.homebrew, isFalse);
    expect(vengeance.supplemental, isFalse);
    expect(vengeance.content.source.reference, contains('100-101'));
    expect(
      vengeance.content.description.details,
      allOf(
        contains('Combattere il Male Peggiore'),
        contains('Nessuna Pietà per i Malvagi'),
        contains('Costi Quel Che Costi'),
        contains('Risarcimento'),
      ),
    );
  });

  test('Vengeance uses the four canonical oath milestones', () {
    expect(vengeance.featuresByLevel.keys.toSet(), {3, 7, 15, 20});
    expect(
      vengeance.featuresByLevel,
      {
        3: [
          PaladinVengeanceFeatureIds.abjureEnemy,
          PaladinVengeanceFeatureIds.vowOfEnmity,
        ],
        7: [PaladinVengeanceFeatureIds.relentlessAvenger],
        15: [PaladinVengeanceFeatureIds.soulOfVengeance],
        20: [PaladinVengeanceFeatureIds.avengingAngel],
      },
    );

    final granted =
        vengeance.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(5));
    expect(
      granted.difference(vengeance.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('Vengeance oath spells are always prepared at PHB levels', () {
    expect(vengeance.alwaysPreparedSpellIdsAtLevel(2), isEmpty);
    expect(
      vengeance.alwaysPreparedSpellIdsByLevel,
      {
        3: {'bane', 'hunters_mark'},
        5: {'hold_person', 'misty_step'},
        9: {'haste', 'protection_from_energy'},
        13: {'banishment', 'dimension_door'},
        17: {'hold_monster', 'scrying'},
      },
    );
    expect(vengeance.alwaysPreparedSpellIdsAtLevel(17), expectedSpells);
    expect(expectedSpells.difference(spellDefinitions.keys.toSet()), isEmpty);
  });

  test('both Vengeance Channel Divinity options use the shared resource', () {
    final abjure =
        vengeance.featureDefinitions[PaladinVengeanceFeatureIds.abjureEnemy]!;
    final vow =
        vengeance.featureDefinitions[PaladinVengeanceFeatureIds.vowOfEnmity]!;

    for (final feature in [abjure, vow]) {
      expect(feature.resourceId, PaladinResourceIds.channelDivinity);
      expect(feature.ruleTags, contains('channel_divinity'));
    }

    expect(abjure.effects.ruleEffects, hasLength(2));
    expect(
      abjure.effects.ruleEffects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.conditional &&
            effect.value == 18 &&
            effect.target.contains('frightened'),
      ),
      isTrue,
    );
    expect(
      abjure.effects.ruleEffects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.movement &&
            effect.value == 0.5,
      ),
      isTrue,
    );

    final vowEffect = vow.effects.ruleEffects.single;
    expect(vowEffect.type, CharacterRuleEffectType.advantage);
    expect(vowEffect.value, 3);
    expect(vowEffect.target, contains('attack_rolls'));
  });

  test('Relentless Avenger and Soul of Vengeance are structured', () {
    final relentless = vengeance
        .featureDefinitions[PaladinVengeanceFeatureIds.relentlessAvenger]!
        .effects
        .ruleEffects
        .single;
    expect(relentless.type, CharacterRuleEffectType.movement);
    expect(relentless.value, 0.5);
    expect(relentless.condition, contains('without_provoking'));

    final soul = vengeance
        .featureDefinitions[PaladinVengeanceFeatureIds.soulOfVengeance]!
        .effects
        .ruleEffects
        .single;
    expect(soul.type, CharacterRuleEffectType.reaction);
    expect(soul.target, contains('melee_weapon_attack'));
    expect(soul.condition, contains('within_melee_weapon_reach'));
  });

  test('Avenging Angel lasts one hour and has all PHB effects', () {
    final resource = vengeance.resources.singleWhere(
      (entry) => entry.id == PaladinOathResourceIds.avengingAngel,
    );
    expect(resource.maximumAtLevel(19), 0);
    expect(resource.maximumAtLevel(20), 1);
    expect(resource.recovery, ClassResourceRecovery.longRest);

    final feature =
        vengeance.featureDefinitions[PaladinVengeanceFeatureIds.avengingAngel]!;
    final effects = feature.effects.ruleEffects;
    expect(effects, hasLength(4));
    expect(
      effects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.movement &&
            effect.target == 'flying_speed_meters' &&
            effect.value == 18,
      ),
      isTrue,
    );
    expect(
      effects.any(
        (effect) =>
            effect.type == CharacterRuleEffectType.conditional &&
            effect.value == 9 &&
            effect.target.contains('frightened'),
      ),
      isTrue,
    );
    expect(
      effects.any(
        (effect) => effect.type == CharacterRuleEffectType.advantage,
      ),
      isTrue,
    );
    expect(feature.content.description.details, contains('1 ora'));
  });
}
