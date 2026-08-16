import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('the PHB adventuring block contains thirty entries', () {
    expect(phbAdventuringGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(174));
  });

  test('all adventuring entries are registered and sourced', () {
    for (final entry in phbAdventuringGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, isNotNull);
      expect(entry.sources.single.pageEnd, isNotNull);
    }
  });

  test('forced march starts after eight hours', () {
    final entry = phbAdventuringGlossaryEntries['forced_march']!;
    final rule = entry.sections.singleWhere(
      (section) => section.id == 'forced_march_save',
    );

    expect(rule.numericValues['normalTravelHours'], 8);
    expect(rule.numericValues['baseDifficultyClass'], 10);
    expect(rule.relatedIds, contains('exhaustion'));
  });

  test('climbing swimming and crawling double movement cost', () {
    const expectedSections = <String, String>{
      'climbing': 'climbing_cost',
      'swimming': 'swimming_cost',
      'crawling': 'crawling_cost',
    };

    for (final pair in expectedSections.entries) {
      final rule = phbAdventuringGlossaryEntries[pair.key]!
          .sections
          .singleWhere((section) => section.id == pair.value);

      expect(rule.numericValues['movementCostMultiplier'], 2);
    }
  });

  test('falling uses d6 every three meters up to twenty dice', () {
    final entry = phbAdventuringGlossaryEntries['falling']!;
    final damage = entry.sections.singleWhere(
      (section) => section.id == 'falling_damage',
    );

    expect(damage.numericValues['metersPerDie'], 3);
    expect(damage.numericValues['dieSize'], 6);
    expect(damage.numericValues['maximumDice'], 20);
    expect(damage.relatedIds, contains('prone'));
  });

  test('suffocation preserves breath and air limits', () {
    final entry = phbAdventuringGlossaryEntries['suffocating']!;
    final limits = entry.sections.singleWhere(
      (section) => section.id == 'suffocating_limits',
    );

    expect(limits.numericValues['baseBreathMinutes'], 1);
    expect(limits.numericValues['minimumBreathSeconds'], 30);
    expect(limits.numericValues['minimumRoundsWithoutAir'], 1);
  });

  test('food and water preserve daily requirements', () {
    final food = phbAdventuringGlossaryEntries['food_requirement']!;
    final foodRule = food.sections.singleWhere(
      (section) => section.id == 'food_starvation',
    );
    final water = phbAdventuringGlossaryEntries['water_requirement']!;
    final waterRule = water.sections.singleWhere(
      (section) => section.id == 'water_shortage',
    );

    expect(foodRule.numericValues['kilogramsPerDay'], 0.5);
    expect(foodRule.numericValues['baseDaysWithoutFood'], 3);
    expect(waterRule.numericValues['litersPerDay'], 4);
    expect(waterRule.numericValues['hotWeatherLitersPerDay'], 8);
    expect(waterRule.numericValues['difficultyClass'], 15);
  });

  test('light and obscuration rules are connected', () {
    expect(
      phbAdventuringGlossaryEntries['vision_and_light']!.relatedIds,
      containsAll(
        <String>{
          'bright_light',
          'dim_light',
          'darkness',
          'lightly_obscured',
          'heavily_obscured',
          'darkvision',
        },
      ),
    );

    expect(
      phbAdventuringGlossaryEntries['heavily_obscured']!.relatedIds,
      contains('blinded'),
    );
  });

  test('carrying formulas use metric PHB values', () {
    final carrying = phbAdventuringGlossaryEntries['carrying_capacity']!;
    final carryingFormula = carrying.sections.singleWhere(
      (section) => section.id == 'carrying_capacity_formula',
    );
    final push = phbAdventuringGlossaryEntries['push_drag_lift']!;
    final pushFormula = push.sections.singleWhere(
      (section) => section.id == 'push_drag_lift_formula',
    );

    expect(carryingFormula.numericValues['kilogramsPerStrengthPoint'], 7.5);
    expect(pushFormula.numericValues['kilogramsPerStrengthPoint'], 15);
    expect(pushFormula.numericValues['overCapacitySpeedMeters'], 1.5);
  });

  test('inspiration does not stack', () {
    final entry = phbAdventuringGlossaryEntries['inspiration']!;
    final limit = entry.sections.singleWhere(
      (section) => section.id == 'inspiration_limit',
    );

    expect(limit.numericValues['maximum'], 1);
    expect(limit.relatedIds, contains('advantage'));
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
