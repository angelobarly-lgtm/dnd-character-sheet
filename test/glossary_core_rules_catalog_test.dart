import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('the first PHB glossary block contains 31 core rules', () {
    expect(phbCoreGlossaryEntries, hasLength(31));

    expect(
      phbCoreGlossaryEntries.keys,
      containsAll(<String>{
        'ability_check',
        'proficiency_bonus',
        'advantage',
        'disadvantage',
        'saving_throw',
        'attack_roll',
        'armor_class',
        'critical_hit',
        'damage_roll',
        'damage_types',
        'damage_vulnerability',
        'damage_immunity',
        'hit_points',
        'temporary_hit_points',
        'healing',
        'dropping_to_zero_hit_points',
        'death_saving_throw',
        'instant_death',
        'stabilizing_creature',
        'short_rest',
        'long_rest',
        'hit_dice',
        'initiative',
        'surprise',
        'movement',
        'difficult_terrain',
        'action',
        'bonus_action',
        'reaction',
        'opportunity_attack',
        'cover',
      }),
    );
  });

  test('all core rules are registered in the universal glossary', () {
    for (final entry in phbCoreGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, isNotEmpty);
      expect(entry.sources.first.book, 'Manuale del Giocatore');
      expect(entry.sources.first.edition, '2014');
      expect(entry.sources.first.pageStart, isNotNull);
      expect(entry.sources.first.pageEnd, isNotNull);
      expect(entry.homebrew, isFalse);
      expect(entry.supplemental, isFalse);
    }

    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(54));
  });

  test('advantage and disadvantage preserve the PHB d20 procedure', () {
    final advantage = phbCoreGlossaryEntries['advantage']!;
    final disadvantage = phbCoreGlossaryEntries['disadvantage']!;

    expect(
      advantage.sections
          .singleWhere((section) => section.id == 'advantage_roll')
          .numericValues,
      containsPair('diceCount', 2),
    );
    expect(
      advantage.sections
          .singleWhere((section) => section.id == 'advantage_roll')
          .numericValues,
      containsPair('dieSize', 20),
    );
    expect(advantage.relatedIds, contains('disadvantage'));
    expect(disadvantage.relatedIds, contains('advantage'));
    expect(
      advantage.details,
      contains('si annullano'),
    );
  });

  test('attack rolls and critical hits preserve their natural results', () {
    final attack = phbCoreGlossaryEntries['attack_roll']!;
    final naturalResults = attack.sections.singleWhere(
      (section) => section.id == 'attack_roll_natural_results',
    );

    expect(naturalResults.numericValues['automaticMiss'], 1);
    expect(naturalResults.numericValues['automaticHit'], 20);

    final critical = phbCoreGlossaryEntries['critical_hit']!;
    expect(
      critical.sections
          .singleWhere((section) => section.id == 'critical_hit_dice')
          .numericValues['damageDiceMultiplier'],
      2,
    );
  });

  test('death saving throws preserve all PHB thresholds', () {
    final entry = phbCoreGlossaryEntries['death_saving_throw']!;
    final results = entry.sections.singleWhere(
      (section) => section.id == 'death_save_results',
    );
    final naturalResults = entry.sections.singleWhere(
      (section) => section.id == 'death_save_natural_results',
    );

    expect(results.numericValues['dieSize'], 20);
    expect(results.numericValues['difficultyClass'], 10);
    expect(results.numericValues['successesRequired'], 3);
    expect(results.numericValues['failuresRequired'], 3);
    expect(naturalResults.numericValues['naturalOneFailures'], 2);
    expect(naturalResults.numericValues['naturalTwentyHitPoints'], 1);
  });

  test('rest rules preserve duration and recovery values', () {
    final shortRest = phbCoreGlossaryEntries['short_rest']!;
    final longRest = phbCoreGlossaryEntries['long_rest']!;

    expect(
      shortRest.sections
          .singleWhere((section) => section.id == 'short_rest_duration')
          .numericValues['minimumMinutes'],
      60,
    );

    final duration = longRest.sections.singleWhere(
      (section) => section.id == 'long_rest_duration',
    );
    final recovery = longRest.sections.singleWhere(
      (section) => section.id == 'long_rest_recovery',
    );

    expect(duration.numericValues['minimumHours'], 8);
    expect(duration.numericValues['maximumLightActivityHours'], 2);
    expect(recovery.numericValues['hitPointRecoveryPercent'], 100);
    expect(recovery.numericValues['hitDiceRecoveryDivisor'], 2);
    expect(recovery.numericValues['minimumHitDiceRecovered'], 1);
  });

  test('cover preserves all three PHB degrees', () {
    final cover = phbCoreGlossaryEntries['cover']!;
    final degrees = cover.sections.singleWhere(
      (section) => section.id == 'cover_degrees',
    );

    expect(degrees.numericValues['halfCoverBonus'], 2);
    expect(degrees.numericValues['threeQuartersCoverBonus'], 5);
    expect(cover.details, contains('copertura totale'));
  });

  test('all related glossary identifiers resolve', () {
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

  test('important aliases participate in automatic linking', () {
    expect(
      phbCoreGlossaryEntries['attack_roll']!.linkTerms,
      containsAll(<String>{'Tiro per Colpire', 'Tiro di Attacco'}),
    );
    expect(
      phbCoreGlossaryEntries['death_saving_throw']!.linkTerms,
      containsAll(
        <String>{
          'Tiro Salvezza contro Morte',
          'Tiri Salvezza contro Morte',
        },
      ),
    );
  });
}
