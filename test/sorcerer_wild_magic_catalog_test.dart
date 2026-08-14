import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/sorcerer_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sorcerer = phbClassDefinitions[ClassIds.sorcerer]!;
  final wildMagic = sorcerer.subclasses[SorcererSubclassIds.wildMagic]!;

  test('Wild Magic identity and source match PHB 2014', () {
    expect(wildMagic.name, 'Magia Selvaggia');
    expect(wildMagic.classId, ClassIds.sorcerer);
    expect(wildMagic.content.source.name, 'Manuale del Giocatore 2014');
    expect(wildMagic.content.source.reference, 'pp. 111-112');
  });

  test('Wild Magic table covers d100 exactly once', () {
    final table = wildMagic.randomTables.single;
    expect(table.dieSides, 100);
    expect(table.entries, hasLength(50));
    for (var index = 0; index < table.entries.length; index++) {
      expect(table.entries[index].minimumRoll, 1 + index * 2);
      expect(table.entries[index].maximumRoll, 2 + index * 2);
    }
    for (var roll = 1; roll <= 100; roll++) {
      expect(table.entries.where((entry) => entry.matches(roll)), hasLength(1));
      expect(table.entryForRoll(roll), isNotNull);
    }
  });

  test('spell and future bestiary links are valid', () {
    final spells = wildMagic.randomTables.single.entries
        .expand((entry) => entry.spellIds)
        .toSet();
    expect(spells.difference(spellDefinitions.keys.toSet()), isEmpty);
    expect(spells, containsAll({'fireball', 'grease', 'reincarnate'}));
    final creatures = wildMagic.randomTables.single.entries
        .expand((entry) => entry.creatureIds)
        .toSet();
    expect(creatures, {'modron', 'flumph', 'unicorn'});
  });

  test('Tides of Chaos and Bend Luck have exact costs', () {
    final tides = wildMagic.resources.single;
    expect(tides.maximumAtLevel(1), 1);
    expect(tides.recovery, ClassResourceRecovery.longRest);
    final bend = wildMagic.resourceUsages.singleWhere(
      (usage) => usage.id == SorcererWildMagicUsageIds.bendLuck,
    );
    expect(bend.baseResourceCost, 2);
    expect(bend.activation, ClassFeatureActivation.reaction);
  });

  test('Controlled Chaos and Spell Bombardment are structured', () {
    final controlled = wildMagic
        .featureDefinitions[SorcererWildMagicFeatureIds.controlledChaos]!;
    expect(controlled.effects.ruleEffects.single.value, 2);
    final bombardment = wildMagic
        .featureDefinitions[SorcererWildMagicFeatureIds.spellBombardment]!;
    expect(
      bombardment.effects.ruleEffects.single.type,
      CharacterRuleEffectType.damageBonus,
    );
    expect(bombardment.effects.ruleEffects.single.condition,
        contains('once_per_turn'));
  });

  test('Wild Magic progression contains all five features', () {
    expect(wildMagic.featuresByLevel.keys.toSet(), {1, 6, 14, 18});
    final granted =
        wildMagic.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(5));
    expect(granted, wildMagic.featureDefinitions.keys.toSet());
  });

  test('Sorcerer registry contains both PHB origins', () {
    expect(sorcerer.subclasses.keys.toSet(), phbSorcererSubclassIds);
  });
}
