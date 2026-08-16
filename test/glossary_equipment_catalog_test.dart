import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_character_sheet/data/glossary_registry_data.dart';

void main() {
  test('the PHB equipment block contains thirty entries', () {
    expect(phbEquipmentGlossaryEntries, hasLength(30));
    expect(universalGlossaryEntries.length, greaterThanOrEqualTo(204));
  });

  test('all equipment entries are registered and sourced', () {
    for (final entry in phbEquipmentGlossaryEntries.values) {
      expect(universalGlossaryEntries[entry.id], same(entry));
      expect(entry.sources, hasLength(1));
      expect(entry.sources.single.book, 'Manuale del Giocatore');
      expect(entry.sources.single.edition, '2014');
      expect(entry.sources.single.pageStart, isNotNull);
    }
  });

  test('currency conversion matches the PHB table', () {
    final entry = phbEquipmentGlossaryEntries['currency']!;
    final conversion = entry.sections.singleWhere(
      (section) => section.id == 'currency_exchange',
    );

    expect(conversion.numericValues['copperPerSilver'], 10);
    expect(conversion.numericValues['silverPerElectrum'], 5);
    expect(conversion.numericValues['electrumPerGold'], 2);
    expect(conversion.numericValues['goldPerPlatinum'], 10);
  });

  test('armor without proficiency preserves every penalty', () {
    final entry = phbEquipmentGlossaryEntries['armor_proficiency']!;

    expect(entry.details, contains('prove di caratteristica'));
    expect(entry.details, contains('tiri salvezza'));
    expect(entry.details, contains('tiri per colpire'));
    expect(entry.details, contains('impedisce di lanciare incantesimi'));
  });

  test('medium heavy armor and shield preserve numeric rules', () {
    final medium = phbEquipmentGlossaryEntries['medium_armor']!;
    final mediumLimit = medium.sections.singleWhere(
      (section) => section.id == 'medium_armor_dexterity_limit',
    );
    final heavy = phbEquipmentGlossaryEntries['heavy_armor']!;
    final heavyPenalty = heavy.sections.singleWhere(
      (section) => section.id == 'heavy_armor_strength_penalty',
    );
    final shield = phbEquipmentGlossaryEntries['shield']!;
    final shieldBonus = shield.sections.singleWhere(
      (section) => section.id == 'shield_bonus',
    );

    expect(mediumLimit.numericValues['maximumDexterityModifier'], 2);
    expect(heavyPenalty.numericValues['speedPenaltyMeters'], 3);
    expect(shieldBonus.numericValues['armorClassBonus'], 2);
    expect(shieldBonus.numericValues['handsRequired'], 1);
  });

  test('armor donning and doffing times match the PHB table', () {
    final entry = phbEquipmentGlossaryEntries['donning_doffing_armor']!;
    final times = entry.sections.singleWhere(
      (section) => section.id == 'armor_times',
    );

    expect(times.numericValues['lightDonMinutes'], 1);
    expect(times.numericValues['mediumDonMinutes'], 5);
    expect(times.numericValues['heavyDonMinutes'], 10);
    expect(times.numericValues['heavyDoffMinutes'], 5);
    expect(times.numericValues['shieldDonActions'], 1);
  });

  test('unarmed strikes deal one plus Strength modifier', () {
    final entry = phbEquipmentGlossaryEntries['unarmed_strike']!;
    final damage = entry.sections.singleWhere(
      (section) => section.id == 'unarmed_damage',
    );

    expect(damage.numericValues['baseDamage'], 1);
    expect(damage.relatedIds, contains('strength'));
  });

  test('improvised and silvered weapon values are structured', () {
    final improvised = phbEquipmentGlossaryEntries['improvised_weapon']!;
    final defaults = improvised.sections.singleWhere(
      (section) => section.id == 'improvised_weapon_defaults',
    );
    final silvered = phbEquipmentGlossaryEntries['silvered_weapon']!;
    final cost = silvered.sections.singleWhere(
      (section) => section.id == 'silvering_cost',
    );

    expect(defaults.numericValues['dieSize'], 4);
    expect(defaults.numericValues['normalRangeMeters'], 6);
    expect(defaults.numericValues['longRangeMeters'], 18);
    expect(cost.numericValues['goldCost'], 100);
    expect(cost.numericValues['ammunitionCount'], 10);
  });

  test('ammunition loading and reach preserve PHB values', () {
    final ammunition = phbEquipmentGlossaryEntries['ammunition_property']!;
    final recovery = ammunition.sections.singleWhere(
      (section) => section.id == 'ammunition_recovery',
    );
    final loading = phbEquipmentGlossaryEntries['loading_property']!;
    final loadingLimit = loading.sections.singleWhere(
      (section) => section.id == 'loading_limit',
    );
    final reach = phbEquipmentGlossaryEntries['reach_property']!;
    final increase = reach.sections.singleWhere(
      (section) => section.id == 'reach_increase',
    );

    expect(recovery.numericValues['recoveryDivisor'], 2);
    expect(loadingLimit.numericValues['maximumShotsPerActivity'], 1);
    expect(increase.numericValues['additionalReachMeters'], 1.5);
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
