import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  const conditionIds = <String>{
    'blinded',
    'charmed',
    'grappled',
    'deafened',
    'poisoned',
    'incapacitated',
    'invisible',
    'paralyzed',
    'petrified',
    'unconscious',
    'prone',
    'frightened',
    'stunned',
    'restrained',
    'exhaustion',
  };

  const actionIds = <String>{
    'attack_action',
    'cast_spell_action',
    'dash_action',
    'disengage_action',
    'dodge_action',
    'help_action',
    'hide_action',
    'ready_action',
    'search_action',
    'use_object_action',
    'grapple',
    'escape_grapple',
    'shove',
    'two_weapon_fighting',
    'object_interaction',
  };

  test('all fifteen PHB conditions are registered', () {
    expect(conditionIds, hasLength(15));
    expect(
      phbConditionActionGlossaryEntries.keys,
      containsAll(conditionIds),
    );

    for (final id in conditionIds) {
      final entry = phbConditionActionGlossaryEntries[id]!;
      expect(entry.category, GlossaryCategory.condizione);
      expect(universalGlossaryEntries[id], same(entry));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, inInclusiveRange(290, 292));
    }
  });

  test('all fifteen action and combat entries are registered', () {
    expect(actionIds, hasLength(15));
    expect(
      phbConditionActionGlossaryEntries.keys,
      containsAll(actionIds),
    );

    for (final id in actionIds) {
      final entry = phbConditionActionGlossaryEntries[id]!;
      expect(universalGlossaryEntries[id], same(entry));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
    }
  });

  test('the second block contains exactly thirty entries', () {
    expect(phbConditionActionGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(84));
  });

  test('incapacitated blocks actions and reactions', () {
    final entry = phbConditionActionGlossaryEntries['incapacitated']!;

    expect(entry.summary, contains('azioni'));
    expect(entry.summary, contains('reazioni'));
    expect(
      entry.relatedIds,
      containsAll(<String>{'action', 'reaction'}),
    );
  });

  test('paralyzed and unconscious preserve close critical distance', () {
    for (final id in <String>{'paralyzed', 'unconscious'}) {
      final entry = phbConditionActionGlossaryEntries[id]!;
      final critical = entry.sections.singleWhere(
        (section) => section.numericValues.containsKey(
          'maximumDistanceMeters',
        ),
      );

      expect(critical.numericValues['maximumDistanceMeters'], 1.5);
      expect(critical.relatedIds, contains('critical_hit'));
    }
  });

  test('petrified multiplies weight by ten', () {
    final entry = phbConditionActionGlossaryEntries['petrified']!;
    final transformation = entry.sections.singleWhere(
      (section) => section.id == 'petrified_weight',
    );

    expect(transformation.numericValues['weightMultiplier'], 10);
    expect(entry.details, contains('resistenza a tutti i danni'));
  });

  test('exhaustion preserves all six cumulative levels', () {
    final entry = phbConditionActionGlossaryEntries['exhaustion']!;
    final levels = entry.sections.singleWhere(
      (section) => section.id == 'exhaustion_levels',
    );
    final recovery = entry.sections.singleWhere(
      (section) => section.id == 'exhaustion_recovery',
    );

    expect(levels.numericValues['maximumLevel'], 6);
    expect(levels.numericValues['deathLevel'], 6);
    expect(recovery.numericValues['levelsRemovedByLongRest'], 1);
    expect(recovery.relatedIds, contains('long_rest'));
  });

  test('dodge preserves all PHB benefits and loss conditions', () {
    final entry = phbConditionActionGlossaryEntries['dodge_action']!;

    expect(entry.details, contains('svantaggio'));
    expect(entry.details, contains('vantaggio'));
    expect(entry.details, contains('Destrezza'));
    expect(entry.details, contains('incapacitata'));
    expect(entry.details, contains('velocità scende a 0'));
  });

  test('ready action is connected to reactions and concentration', () {
    final entry = phbConditionActionGlossaryEntries['ready_action']!;
    final spell = entry.sections.singleWhere(
      (section) => section.id == 'ready_spell',
    );

    expect(entry.relatedIds, contains('reaction'));
    expect(spell.content, contains('concentrazione'));
    expect(spell.relatedIds, contains('cast_spell_action'));
  });

  test('grapple, escape and shove preserve their structural links', () {
    final grapple = phbConditionActionGlossaryEntries['grapple']!;
    final escape = phbConditionActionGlossaryEntries['escape_grapple']!;
    final shove = phbConditionActionGlossaryEntries['shove']!;

    expect(grapple.relatedIds, contains('grappled'));
    expect(escape.relatedIds, contains('grappled'));
    expect(shove.relatedIds, contains('prone'));

    expect(
      shove.sections
          .singleWhere((section) => section.id == 'shove_distance')
          .numericValues['distanceMeters'],
      1.5,
    );
  });

  test('all related glossary identifiers resolve after insertion', () {
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

  test('condition aliases support automatic links in natural text', () {
    expect(
      phbConditionActionGlossaryEntries['blinded']!.linkTerms,
      containsAll(<String>{'Accecato', 'Accecata', 'Accecati', 'Accecate'}),
    );
    expect(
      phbConditionActionGlossaryEntries['unconscious']!.linkTerms,
      containsAll(
        <String>{
          'Privo di Sensi',
          'Priva di Sensi',
          'Privi di Sensi',
          'Prive di Sensi',
        },
      ),
    );
  });
}
