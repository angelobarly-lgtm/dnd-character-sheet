import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('all twenty-three original glossary identifiers are preserved', () {
    expect(glossaryEntries, hasLength(23));

    expect(
      glossaryEntries.keys,
      containsAll(<String>{
        'poison_resilience',
        'racial_weapon_training',
        'racial_hit_points',
        'racial_cantrip',
        'conditional_racial_rule',
        'breath_weapon',
        'draconic_ancestry',
        'fey_ancestry',
        'trance',
        'relentless_endurance',
        'savage_attacks',
        'hellish_resistance',
        'infernal_legacy',
        'sunlight_sensitivity',
        'racial_progression',
        'darkvision',
        'damage_resistance',
        'saving_throw_advantage',
        'condition_immunity',
        'racial_spellcasting',
        'racial_proficiency',
        'racial_language',
        'racial_speed',
      }),
    );
  });

  test('all original entries now carry PHB 2014 sources', () {
    for (final entry in glossaryEntries.values) {
      expect(entry.sources, isNotEmpty, reason: entry.id);

      for (final source in entry.sources) {
        expect(source.book, 'Manuale del Giocatore');
        expect(source.edition, '2014');
        expect(source.pageStart, isNotNull);
        expect(source.pageEnd, isNotNull);
      }

      expect(entry.details, isNotEmpty, reason: entry.id);
      expect(universalGlossaryEntries[entry.id], same(entry));
    }
  });

  test('breath weapon preserves save DC and damage progression', () {
    final entry = glossaryEntries['breath_weapon']!;
    final save = entry.sections.singleWhere(
      (section) => section.id == 'breath_weapon_save_dc',
    );
    final progression = entry.sections.singleWhere(
      (section) => section.id == 'breath_weapon_progression',
    );

    expect(save.numericValues['baseDifficultyClass'], 8);
    expect(progression.numericValues['level1Dice'], 2);
    expect(progression.numericValues['level6Dice'], 3);
    expect(progression.numericValues['level11Dice'], 4);
    expect(progression.numericValues['level16Dice'], 5);
    expect(progression.numericValues['dieSize'], 6);
  });

  test('fey ancestry preserves charm and magical sleep protection', () {
    final entry = glossaryEntries['fey_ancestry']!;
    final protections = entry.sections.singleWhere(
      (section) => section.id == 'fey_ancestry_protections',
    );

    expect(protections.content, contains('Affascinato'));
    expect(protections.content, contains('sonno'));
    expect(
      protections.relatedIds,
      containsAll(<String>{'saving_throw', 'advantage', 'charmed'}),
    );
  });

  test('trance preserves four-hour duration', () {
    final entry = glossaryEntries['trance']!;
    final duration = entry.sections.singleWhere(
      (section) => section.id == 'trance_duration',
    );

    expect(duration.numericValues['tranceHours'], 4);
    expect(duration.numericValues['equivalentSleepHours'], 8);
  });

  test('relentless endurance leaves one hit point', () {
    final entry = glossaryEntries['relentless_endurance']!;
    final result = entry.sections.singleWhere(
      (section) => section.id == 'relentless_endurance_result',
    );

    expect(result.numericValues['remainingHitPoints'], 1);
    expect(entry.relatedIds, contains('instant_death'));
  });

  test('savage attacks adds one weapon die to melee critical hits', () {
    final entry = glossaryEntries['savage_attacks']!;
    final extraDie = entry.sections.singleWhere(
      (section) => section.id == 'savage_attacks_extra_die',
    );

    expect(extraDie.numericValues['additionalWeaponDice'], 1);
    expect(
      extraDie.relatedIds,
      containsAll(<String>{'critical_hit', 'melee_weapon'}),
    );
  });

  test('infernal legacy preserves PHB level progression', () {
    final entry = glossaryEntries['infernal_legacy']!;
    final progression = entry.sections.singleWhere(
      (section) => section.id == 'infernal_legacy_levels',
    );

    expect(progression.numericValues['cantripLevel'], 1);
    expect(progression.numericValues['hellishRebukeLevel'], 3);
    expect(progression.numericValues['darknessLevel'], 5);
  });

  test('darkvision preserves dim light darkness and grayscale rules', () {
    final entry = glossaryEntries['darkvision']!;
    final perception = entry.sections.singleWhere(
      (section) => section.id == 'darkvision_light_levels',
    );

    expect(perception.content, contains('luce intensa'));
    expect(perception.content, contains('luce fioca'));
    expect(perception.content, contains('sfumature di grigio'));
  });

  test('damage resistance halves damage after modifiers', () {
    final entry = glossaryEntries['damage_resistance']!;
    final resistance = entry.sections.singleWhere(
      (section) => section.id == 'damage_resistance_divisor',
    );

    expect(resistance.numericValues['damageDivisor'], 2);
    expect(entry.details, contains('dopo gli altri modificatori'));
    expect(entry.details, contains('non si cumulano'));
  });

  test('all glossary relationships remain resolved', () {
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
