import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/data/fighter_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final eldritchKnight =
      fighterClassDefinition.subclasses[FighterSubclassIds.eldritchKnight]!;
  final spellcasting = eldritchKnight.spellcasting!;

  test('Eldritch Knight is registered with complete progression', () {
    expect(eldritchKnight.id, FighterSubclassIds.eldritchKnight);
    expect(eldritchKnight.name, 'Cavaliere Mistico');
    expect(eldritchKnight.classId, ClassIds.fighter);
    expect(eldritchKnight.homebrew, isFalse);
    expect(eldritchKnight.supplemental, isFalse);
    expect(eldritchKnight.content.source.isEmpty, isFalse);
    expect(eldritchKnight.content.ownerId, ClassIds.fighter);

    expect(
      eldritchKnight.featuresByLevel.keys.toSet(),
      {3, 7, 10, 15, 18},
    );
    expect(
      eldritchKnight.featuresByLevel[3],
      [
        EldritchKnightFeatureIds.spellcasting,
        EldritchKnightFeatureIds.weaponBond,
      ],
    );
    expect(
      eldritchKnight.featuresByLevel[18],
      [EldritchKnightFeatureIds.improvedWarMagic],
    );
  });

  test('Eldritch Knight uses Intelligence as a third caster', () {
    expect(
      spellcasting.progression,
      ClassSpellcastingProgression.third,
    );
    expect(spellcasting.ability, 'INT');
    expect(spellcasting.minimumLevel, 3);
    expect(spellcasting.preparesSpells, isFalse);
    expect(spellcasting.ritualCasting, isFalse);
  });

  test('spell slot progression matches Fighter levels 3 to 20', () {
    const expectedSlots = {
      3: [2],
      4: [3],
      5: [3],
      6: [3],
      7: [4, 2],
      8: [4, 2],
      9: [4, 2],
      10: [4, 3],
      11: [4, 3],
      12: [4, 3],
      13: [4, 3, 2],
      14: [4, 3, 2],
      15: [4, 3, 2],
      16: [4, 3, 3],
      17: [4, 3, 3],
      18: [4, 3, 3],
      19: [4, 3, 3, 1],
      20: [4, 3, 3, 1],
    };

    expect(spellcasting.slotsAtLevel(2), isEmpty);

    for (final entry in expectedSlots.entries) {
      expect(
        spellcasting.slotsAtLevel(entry.key),
        entry.value,
        reason: 'Slot errati al livello ${entry.key}',
      );
    }
  });

  test('cantrips and spells known match the PHB progression', () {
    const expectedSpells = {
      3: 3,
      4: 4,
      5: 4,
      6: 4,
      7: 5,
      8: 6,
      9: 6,
      10: 7,
      11: 8,
      12: 8,
      13: 9,
      14: 10,
      15: 10,
      16: 11,
      17: 11,
      18: 11,
      19: 12,
      20: 13,
    };

    expect(spellcasting.cantripsKnownAtLevel(2), 0);
    expect(spellcasting.cantripsKnownAtLevel(3), 2);
    expect(spellcasting.cantripsKnownAtLevel(9), 2);
    expect(spellcasting.cantripsKnownAtLevel(10), 3);
    expect(spellcasting.cantripsKnownAtLevel(20), 3);

    for (final entry in expectedSpells.entries) {
      expect(
        spellcasting.spellsKnownAtLevel(entry.key),
        entry.value,
        reason: 'Incantesimi conosciuti errati al livello ${entry.key}',
      );
      expect(
        spellcasting.spellsKnownFromPoolsAtLevel(entry.key),
        entry.value,
        reason: 'Gruppi di apprendimento incoerenti al livello ${entry.key}',
      );
    }
  });

  test('spell list is the complete canonical Wizard catalog', () {
    final wizardSpellIds = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.wizard))
        .map((spell) => spell.id)
        .toSet();

    expect(wizardSpellIds, hasLength(215));
    expect(spellcasting.spellIds, wizardSpellIds);
    expect(spellcasting.spellIds, hasLength(215));
  });

  test('restricted pool contains Abjuration and Evocation only', () {
    final restricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == EldritchKnightSpellPoolIds.abjurationAndEvocation,
    );

    expect(
      restricted.allowedSchoolIds,
      {'abjuration', 'evocation'},
    );
    expect(restricted.preservePoolOnReplacement, isTrue);
    expect(restricted.knownAtLevel(2), 0);
    expect(restricted.knownAtLevel(3), 2);
    expect(restricted.knownAtLevel(4), 3);
    expect(restricted.knownAtLevel(7), 4);
    expect(restricted.knownAtLevel(10), 5);
    expect(restricted.knownAtLevel(11), 6);
    expect(restricted.knownAtLevel(13), 7);
    expect(restricted.knownAtLevel(16), 8);
    expect(restricted.knownAtLevel(19), 9);
    expect(restricted.knownAtLevel(20), 9);

    expect(restricted.allowsSchool('abjuration'), isTrue);
    expect(restricted.allowsSchool('evocation'), isTrue);
    expect(restricted.allowsSchool('illusion'), isFalse);
  });

  test('unrestricted spells are gained at levels 3 8 14 and 20', () {
    final unrestricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == EldritchKnightSpellPoolIds.unrestricted,
    );

    expect(unrestricted.allowedSchoolIds, isEmpty);
    expect(unrestricted.preservePoolOnReplacement, isTrue);

    expect(unrestricted.knownAtLevel(2), 0);
    expect(unrestricted.knownAtLevel(3), 1);
    expect(unrestricted.knownAtLevel(7), 1);
    expect(unrestricted.knownAtLevel(8), 2);
    expect(unrestricted.knownAtLevel(13), 2);
    expect(unrestricted.knownAtLevel(14), 3);
    expect(unrestricted.knownAtLevel(19), 3);
    expect(unrestricted.knownAtLevel(20), 4);

    for (final school in SpellSchool.values) {
      expect(unrestricted.allowsSchool(school.name), isTrue);
    }
  });

  test('Weapon Bond supports two weapons and same-plane recall', () {
    final feature =
        eldritchKnight.featureDefinitions[EldritchKnightFeatureIds.weaponBond]!;
    final effects = {
      for (final effect in feature.effects.ruleEffects) effect.id: effect,
    };

    expect(effects, hasLength(3));
    expect(
      effects['eldritch_knight_bonded_weapon_limit']!.value,
      2,
    );
    expect(
      effects['eldritch_knight_bonded_weapon_limit']!.condition,
      'one_hour_ritual',
    );
    expect(
      effects['eldritch_knight_summon_bonded_weapon']!.condition,
      'bonus_action_and_same_plane_of_existence',
    );
  });

  test('War Magic and Improved War Magic remain distinct', () {
    final warMagic = eldritchKnight
        .featureDefinitions[EldritchKnightFeatureIds.warMagic]!
        .effects
        .ruleEffects
        .single;
    final improved = eldritchKnight
        .featureDefinitions[EldritchKnightFeatureIds.improvedWarMagic]!
        .effects
        .ruleEffects
        .single;

    expect(
      warMagic.condition,
      'after_casting_cantrip_with_action',
    );
    expect(
      improved.condition,
      'after_casting_spell_with_action',
    );
    expect(warMagic.target, 'bonus_action_weapon_attack');
    expect(improved.target, 'bonus_action_weapon_attack');
  });

  test('Eldritch Strike applies structured saving throw disadvantage', () {
    final effect = eldritchKnight
        .featureDefinitions[EldritchKnightFeatureIds.eldritchStrike]!
        .effects
        .ruleEffects
        .single;

    expect(effect.type, CharacterRuleEffectType.disadvantage);
    expect(
      effect.target,
      'next_saving_throw_against_fighter_spell',
    );
    expect(
      effect.condition,
      'after_weapon_hit_until_end_of_fighter_next_turn',
    );
  });

  test('Arcane Charge teleports up to nine meters', () {
    final effect = eldritchKnight
        .featureDefinitions[EldritchKnightFeatureIds.arcaneCharge]!
        .effects
        .ruleEffects
        .single;

    expect(effect.type, CharacterRuleEffectType.movement);
    expect(effect.target, 'teleport');
    expect(effect.value, 9);
    expect(effect.referenceIds, ['action_surge']);
  });

  test('every granted Eldritch Knight feature is registered', () {
    final granted = eldritchKnight.featuresByLevel.values
        .expand((features) => features)
        .toSet();

    expect(
      granted.difference(
        eldritchKnight.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );

    for (final entry in eldritchKnight.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(
        entry.value.content.ownerId,
        FighterSubclassIds.eldritchKnight,
      );
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });
}
