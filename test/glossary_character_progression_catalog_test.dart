import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('the character progression block contains thirty entries', () {
    expect(phbCharacterProgressionGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(234));
  });

  test('all entries are registered and sourced from PHB 2014', () {
    for (final entry in phbCharacterProgressionGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, isNotNull);
    }
  });

  test('character and class levels remain distinct', () {
    final character =
        phbCharacterProgressionGlossaryEntries['character_level']!;
    final classLevel = phbCharacterProgressionGlossaryEntries['class_level']!;

    expect(character.details, contains('livello totale'));
    expect(character.relatedIds, contains('class_level'));
    expect(classLevel.details, contains('separatamente'));
    expect(classLevel.relatedIds, contains('character_level'));
  });

  test('higher-level hit points preserve the minimum increase', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['hit_points_higher_levels']!;
    final minimum = entry.sections.singleWhere(
      (section) => section.id == 'higher_level_minimum_hp',
    );

    expect(minimum.numericValues['minimumIncrease'], 1);
    expect(minimum.relatedIds, contains('constitution'));
  });

  test('ability score improvement preserves increases and cap', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['ability_score_improvement']!;
    final values = entry.sections.singleWhere(
      (section) => section.id == 'ability_score_improvement_values',
    );

    expect(values.numericValues['singleScoreIncrease'], 2);
    expect(values.numericValues['twoScoreIncrease'], 1);
    expect(values.numericValues['ordinaryMaximum'], 20);
    expect(entry.relatedIds, contains('feat_definition'));
  });

  test('multiclass prerequisites require current and new class', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['multiclass_prerequisites']!;

    expect(entry.details, contains('classe attuale'));
    expect(entry.details, contains('quella nuova'));
    expect(entry.relatedIds, contains('ability_score'));
  });

  test('multiclass spellcasting preserves all divisors', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['multiclass_spellcasting']!;
    final divisors = entry.sections.singleWhere(
      (section) => section.id == 'multiclass_caster_divisors',
    );

    expect(divisors.numericValues['fullCasterDivisor'], 1);
    expect(divisors.numericValues['halfCasterDivisor'], 2);
    expect(divisors.numericValues['thirdCasterDivisor'], 3);
  });

  test('Pact Magic remains separate but interoperable', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['multiclass_pact_magic']!;

    expect(entry.details, contains('restano separati'));
    expect(entry.details, contains('possono essere usati'));
    expect(entry.relatedIds, contains('spell_slots'));
  });

  test('multiclass proficiency uses total character level', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['proficiency_bonus_multiclass']!;

    expect(entry.summary, contains('livello totale'));
    expect(entry.details, contains('non viene sommato'));
    expect(entry.relatedIds, contains('character_level'));
  });

  test('alignment preserves two axes and nine common results', () {
    final entry = phbCharacterProgressionGlossaryEntries['alignment']!;
    final axes = entry.sections.singleWhere(
      (section) => section.id == 'alignment_axes',
    );

    expect(axes.numericValues['commonAlignmentCount'], 9);
    expect(axes.content, contains('Legale'));
    expect(axes.content, contains('Caotico'));
    expect(axes.content, contains('Buono'));
    expect(axes.content, contains('Malvagio'));
  });

  test('background connects all four personal characteristics', () {
    final entry =
        phbCharacterProgressionGlossaryEntries['background_definition']!;

    expect(
      entry.relatedIds,
      containsAll(
        <String>{
          'personality_trait',
          'ideal',
          'bond',
          'flaw',
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
