import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  const abilityIds = <String>{
    'strength',
    'dexterity',
    'constitution',
    'intelligence',
    'wisdom',
    'charisma',
  };

  const skillIds = <String>{
    'athletics',
    'acrobatics',
    'sleight_of_hand',
    'stealth',
    'arcana',
    'history',
    'investigation',
    'nature',
    'religion',
    'animal_handling',
    'insight',
    'medicine',
    'perception',
    'survival',
    'deception',
    'intimidation',
    'performance',
    'persuasion',
  };

  test('the PHB ability and skill block contains thirty entries', () {
    expect(phbAbilitySkillGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(144));
  });

  test('all six abilities are registered', () {
    expect(abilityIds, hasLength(6));

    for (final id in abilityIds) {
      final entry = phbAbilitySkillGlossaryEntries[id]!;
      expect(entry.category, GlossaryCategory.caratteristica);
      expect(universalGlossaryEntries[id], same(entry));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
    }
  });

  test('all eighteen PHB skills are registered', () {
    expect(skillIds, hasLength(18));

    for (final id in skillIds) {
      final entry = phbAbilitySkillGlossaryEntries[id]!;
      expect(entry.category, GlossaryCategory.caratteristica);
      expect(universalGlossaryEntries[id], same(entry));
      expect(entry.sources.single.pageStart, inInclusiveRange(175, 179));
    }
  });

  test('ability modifier formula is structured', () {
    final entry = phbAbilitySkillGlossaryEntries['ability_score']!;
    final formula = entry.sections.singleWhere(
      (section) => section.id == 'ability_modifier_formula',
    );

    expect(formula.numericValues['neutralScore'], 10);
    expect(formula.numericValues['divisor'], 2);
    expect(formula.content, contains('arrotonda per difetto'));
  });

  test('each skill is connected to its governing ability', () {
    const expectedAbility = <String, String>{
      'athletics': 'strength',
      'acrobatics': 'dexterity',
      'sleight_of_hand': 'dexterity',
      'stealth': 'dexterity',
      'arcana': 'intelligence',
      'history': 'intelligence',
      'investigation': 'intelligence',
      'nature': 'intelligence',
      'religion': 'intelligence',
      'animal_handling': 'wisdom',
      'insight': 'wisdom',
      'medicine': 'wisdom',
      'perception': 'wisdom',
      'survival': 'wisdom',
      'deception': 'charisma',
      'intimidation': 'charisma',
      'performance': 'charisma',
      'persuasion': 'charisma',
    };

    for (final pair in expectedAbility.entries) {
      expect(
        phbAbilitySkillGlossaryEntries[pair.key]!.relatedIds,
        contains(pair.value),
        reason: '${pair.key} must reference ${pair.value}',
      );
    }
  });

  test('passive checks preserve base, advantage and disadvantage', () {
    final entry = phbAbilitySkillGlossaryEntries['passive_check']!;
    final formula = entry.sections.singleWhere(
      (section) => section.id == 'passive_check_formula',
    );

    expect(formula.numericValues['baseValue'], 10);
    expect(formula.numericValues['advantageModifier'], 5);
    expect(formula.numericValues['disadvantageModifier'], -5);
  });

  test('difficulty class examples match the PHB table', () {
    final entry = phbAbilitySkillGlossaryEntries['difficulty_class']!;
    final examples = entry.sections.singleWhere(
      (section) => section.id == 'difficulty_examples',
    );

    expect(examples.numericValues, <String, num>{
      'veryEasy': 5,
      'easy': 10,
      'medium': 15,
      'hard': 20,
      'veryHard': 25,
      'nearlyImpossible': 30,
    });
  });

  test('group checks require at least half of the group', () {
    final entry = phbAbilitySkillGlossaryEntries['group_check']!;
    final threshold = entry.sections.singleWhere(
      (section) => section.id == 'group_check_threshold',
    );

    expect(threshold.numericValues['requiredSuccessFractionNumerator'], 1);
    expect(threshold.numericValues['requiredSuccessFractionDenominator'], 2);
  });

  test('medicine remains connected to stabilization at DC 10', () {
    final entry = phbAbilitySkillGlossaryEntries['medicine']!;
    final stabilization = entry.sections.singleWhere(
      (section) => section.id == 'medicine_stabilization',
    );

    expect(stabilization.numericValues['difficultyClass'], 10);
    expect(stabilization.relatedIds, contains('stabilizing_creature'));
  });

  test('all entries are sourced from the PHB 2014', () {
    for (final entry in phbAbilitySkillGlossaryEntries.values) {
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.homebrew, isFalse);
      expect(entry.supplemental, isFalse);
    }
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
