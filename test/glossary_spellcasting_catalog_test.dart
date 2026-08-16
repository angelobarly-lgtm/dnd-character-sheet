import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('the PHB spellcasting block contains thirty entries', () {
    expect(phbSpellcastingGlossaryEntries, hasLength(30));

    expect(
      phbSpellcastingGlossaryEntries.keys,
      containsAll(<String>{
        'spell',
        'cantrip',
        'spell_level',
        'spell_slots',
        'known_spells',
        'prepared_spells',
        'casting_at_higher_level',
        'ritual_casting',
        'casting_time',
        'bonus_action_spell',
        'reaction_spell',
        'longer_casting_time',
        'spell_range',
        'verbal_component',
        'somatic_component',
        'material_component',
        'component_pouch_rule',
        'spellcasting_focus_rule',
        'spell_duration',
        'instantaneous_duration',
        'concentration',
        'spell_target',
        'clear_path_to_target',
        'target_self',
        'area_of_effect',
        'spell_saving_throw',
        'spell_attack_roll',
        'combining_magical_effects',
        'school_of_magic',
        'spellcasting_ability',
      }),
    );
  });

  test('all spellcasting entries are registered and sourced', () {
    for (final entry in phbSpellcastingGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, inInclusiveRange(201, 205));
      expect(entry.homebrew, isFalse);
      expect(entry.supplemental, isFalse);
    }

    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(114));
  });

  test('cantrips are level zero and consume no slot', () {
    final entry = phbSpellcastingGlossaryEntries['cantrip']!;
    final rule = entry.sections.singleWhere(
      (section) => section.id == 'cantrip_level',
    );

    expect(rule.numericValues['spellLevel'], 0);
    expect(rule.numericValues['slotCost'], 0);
    expect(rule.relatedIds, contains('spell_slots'));
  });

  test('rituals add ten minutes and consume no slot', () {
    final entry = phbSpellcastingGlossaryEntries['ritual_casting']!;
    final rule = entry.sections.singleWhere(
      (section) => section.id == 'ritual_extra_time',
    );

    expect(rule.numericValues['additionalMinutes'], 10);
    expect(rule.numericValues['slotCost'], 0);
  });

  test('bonus action spell restriction preserves the PHB rule', () {
    final entry = phbSpellcastingGlossaryEntries['bonus_action_spell']!;
    final rule = entry.sections.singleWhere(
      (section) => section.id == 'bonus_action_spell_limit',
    );

    expect(rule.content, contains('trucchetto'));
    expect(rule.content, contains('tempo di lancio di un’azione'));
    expect(rule.relatedIds, containsAll(<String>{'bonus_action', 'cantrip'}));
  });

  test('material components preserve cost and consumption restrictions', () {
    final entry = phbSpellcastingGlossaryEntries['material_component']!;

    expect(entry.details, contains('costo specifico'));
    expect(entry.details, contains('consumato'));
    expect(
      entry.relatedIds,
      containsAll(
        <String>{
          'component_pouch_rule',
          'spellcasting_focus_rule',
        },
      ),
    );
  });

  test('concentration preserves one effect and damage DC formula', () {
    final entry = phbSpellcastingGlossaryEntries['concentration']!;
    final damage = entry.sections.singleWhere(
      (section) => section.id == 'concentration_damage',
    );

    expect(entry.details, contains('un solo effetto'));
    expect(damage.numericValues['minimumDifficultyClass'], 10);
    expect(damage.numericValues['damageDivisor'], 2);
    expect(damage.relatedIds, contains('saving_throw'));
  });

  test('spell save and attack formulas use proficiency and ability', () {
    final savingThrow = phbSpellcastingGlossaryEntries['spell_saving_throw']!;
    final savingFormula = savingThrow.sections.singleWhere(
      (section) => section.id == 'spell_save_dc_formula',
    );
    final ability = phbSpellcastingGlossaryEntries['spellcasting_ability']!;
    final formulas = ability.sections.singleWhere(
      (section) => section.id == 'spellcasting_formulas',
    );

    expect(savingFormula.numericValues['baseDifficultyClass'], 8);
    expect(formulas.numericValues['spellSaveBase'], 8);
    expect(
      ability.relatedIds,
      containsAll(
        <String>{
          'spell_saving_throw',
          'spell_attack_roll',
          'proficiency_bonus',
        },
      ),
    );
  });

  test('all eight schools of magic are retained', () {
    final entry = phbSpellcastingGlossaryEntries['school_of_magic']!;
    final schools = entry.sections.singleWhere(
      (section) => section.id == 'schools_list',
    );

    expect(schools.numericValues['schoolCount'], 8);
    expect(schools.content, contains('Abiurazione'));
    expect(schools.content, contains('Ammaliamento'));
    expect(schools.content, contains('Divinazione'));
    expect(schools.content, contains('Evocazione'));
    expect(schools.content, contains('Illusione'));
    expect(schools.content, contains('Invocazione'));
    expect(schools.content, contains('Necromanzia'));
    expect(schools.content, contains('Trasmutazione'));
  });

  test('all glossary relationships still resolve', () {
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
