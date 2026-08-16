import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  const damageTypeIds = <String>{
    'acid_damage',
    'bludgeoning_damage',
    'cold_damage',
    'fire_damage',
    'force_damage',
    'lightning_damage',
    'necrotic_damage',
    'piercing_damage',
    'poison_damage',
    'psychic_damage',
    'radiant_damage',
    'slashing_damage',
    'thunder_damage',
  };

  test('the final PHB combat block contains thirty entries', () {
    expect(phbAdvancedCombatGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(264));
  });

  test('all thirteen PHB damage types are registered', () {
    expect(damageTypeIds, hasLength(13));
    expect(
      phbAdvancedCombatGlossaryEntries.keys,
      containsAll(damageTypeIds),
    );

    for (final id in damageTypeIds) {
      final entry = phbAdvancedCombatGlossaryEntries[id]!;

      expect(entry.category, GlossaryCategory.combattimento);
      expect(entry.relatedIds, contains('damage_types'));
      expect(entry.relatedIds, contains('damage_resistance'));
      expect(entry.relatedIds, contains('damage_vulnerability'));
      expect(entry.relatedIds, contains('damage_immunity'));
    }
  });

  test('all final entries are registered and sourced', () {
    for (final entry in phbAdvancedCombatGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, inInclusiveRange(189, 198));
    }
  });

  test('a combat round represents six seconds', () {
    final entry = phbAdvancedCombatGlossaryEntries['combat_round']!;
    final duration = entry.sections.singleWhere(
      (section) => section.id == 'combat_round_duration',
    );

    expect(duration.numericValues['seconds'], 6);
  });

  test('hostile creature movement preserves size difference', () {
    final entry = phbAdvancedCombatGlossaryEntries['moving_through_creatures']!;
    final rule = entry.sections.singleWhere(
      (section) => section.id == 'hostile_size_difference',
    );

    expect(rule.numericValues['minimumSizeCategoryDifference'], 2);
    expect(entry.relatedIds, contains('difficult_terrain'));
  });

  test('squeezing doubles movement cost and applies combat penalties', () {
    final entry = phbAdvancedCombatGlossaryEntries['squeezing']!;
    final cost = entry.sections.singleWhere(
      (section) => section.id == 'squeezing_cost',
    );

    expect(cost.numericValues['movementCostMultiplier'], 2);
    expect(entry.details, contains('svantaggio'));
    expect(entry.details, contains('vantaggio'));
  });

  test('close ranged attacks use the 1.5 meter rule', () {
    final entry =
        phbAdvancedCombatGlossaryEntries['ranged_attack_close_combat']!;
    final distance = entry.sections.singleWhere(
      (section) => section.id == 'ranged_close_distance',
    );

    expect(distance.numericValues['maximumDistanceMeters'], 1.5);
    expect(entry.relatedIds, contains('incapacitated'));
  });

  test('mounting costs half speed and forced dismount uses DC 10', () {
    final entry = phbAdvancedCombatGlossaryEntries['mounting_dismounting']!;
    final cost = entry.sections.singleWhere(
      (section) => section.id == 'mounting_movement_cost',
    );
    final forced = entry.sections.singleWhere(
      (section) => section.id == 'forced_dismount',
    );

    expect(cost.numericValues['speedFractionDivisor'], 2);
    expect(forced.numericValues['difficultyClass'], 10);
    expect(forced.numericValues['fallDistanceMeters'], 1.5);
  });

  test('controlled mount has only three PHB actions', () {
    final entry = phbAdvancedCombatGlossaryEntries['controlled_mount']!;

    expect(
      entry.relatedIds,
      containsAll(
        <String>{
          'dash_action',
          'disengage_action',
          'dodge_action',
        },
      ),
    );
    expect(entry.details, contains('soltanto'));
  });

  test('underwater combat grants fire resistance when immersed', () {
    final entry = phbAdvancedCombatGlossaryEntries['underwater_combat']!;
    final fire = entry.sections.singleWhere(
      (section) => section.id == 'underwater_fire_resistance',
    );

    expect(
      fire.relatedIds,
      containsAll(<String>{'damage_resistance', 'fire_damage'}),
    );
  });

  test('nonlethal knockout requires a melee attack', () {
    final entry = phbAdvancedCombatGlossaryEntries['knocking_out_creature']!;

    expect(entry.details, contains('attacco in mischia'));
    expect(entry.details, contains('0 punti ferita'));
    expect(
      entry.relatedIds,
      containsAll(
        <String>{
          'dropping_to_zero_hit_points',
          'stabilizing_creature',
          'unconscious',
        },
      ),
    );
  });

  test('all glossary relationships resolve', () {
    final unresolved = <String>{};

    for (final entry in universalGlossaryEntries.values) {
      for (final relatedId in entry.allRelatedGlossaryIds) {
        if (!universalGlossaryEntries.containsKey(relatedId)) {
          unresolved.add('${entry.id}->$relatedId');
        }
      }
    }

    expect(unresolved, isEmpty);
  });
}
