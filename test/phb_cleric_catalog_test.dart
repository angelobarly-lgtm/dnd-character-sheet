import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/cleric_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cleric = phbClassDefinitions[ClassIds.cleric]!;

  test('PHB Cleric is registered with its complete base structure', () {
    expect(cleric.id, ClassIds.cleric);
    expect(cleric.name, 'Chierico');
    expect(cleric.hitDie, 8);
    expect(cleric.subclassSelectionLevel, 1);
    expect(cleric.homebrew, isFalse);

    expect(cleric.proficiencies.savingThrows, {'SAG', 'CAR'});
    expect(
      cleric.proficiencies.armor,
      {
        'light_armor',
        'medium_armor',
        'shield',
      },
    );
    expect(cleric.proficiencies.weapons, {'simple_weapons'});
    expect(cleric.featureDefinitions, hasLength(8));
    expect(cleric.spellcasting, isNotNull);
    expect(cleric.spellcasting!.spellIds, hasLength(105));
  });

  test('all seven PHB Divine Domains are registered exactly once', () {
    expect(
      cleric.subclasses.keys.toSet(),
      {
        ClericSubclassIds.knowledge,
        ClericSubclassIds.war,
        ClericSubclassIds.trickery,
        ClericSubclassIds.light,
        ClericSubclassIds.nature,
        ClericSubclassIds.tempest,
        ClericSubclassIds.life,
      },
    );

    expect(
      {
        for (final domain in cleric.subclasses.values) domain.id: domain.name,
      },
      {
        ClericSubclassIds.knowledge: 'Dominio della Conoscenza',
        ClericSubclassIds.war: 'Dominio della Guerra',
        ClericSubclassIds.trickery: 'Dominio dell’Inganno',
        ClericSubclassIds.light: 'Dominio della Luce',
        ClericSubclassIds.nature: 'Dominio della Natura',
        ClericSubclassIds.tempest: 'Dominio della Tempesta',
        ClericSubclassIds.life: 'Dominio della Vita',
      },
    );
  });

  test('every domain has a coherent PHB feature progression', () {
    for (final domain in cleric.subclasses.values) {
      expect(domain.classId, ClassIds.cleric, reason: domain.id);
      expect(domain.homebrew, isFalse, reason: domain.id);
      expect(domain.supplemental, isFalse, reason: domain.id);
      expect(domain.content.id, domain.id, reason: domain.id);
      expect(domain.content.ownerId, ClassIds.cleric, reason: domain.id);
      expect(domain.content.source.isEmpty, isFalse, reason: domain.id);

      expect(
        domain.featuresByLevel.keys.toSet(),
        containsAll({1, 2, 6, 8, 17}),
        reason: domain.id,
      );

      final granted =
          domain.featuresByLevel.values.expand((ids) => ids).toList();

      expect(
        granted.toSet().length,
        granted.length,
        reason: 'Privilegio duplicato: ${domain.id}',
      );
      expect(
        domain.featureDefinitions.keys.toSet(),
        granted.toSet(),
        reason: 'Registro privilegi incompleto: ${domain.id}',
      );

      for (final entry in domain.featureDefinitions.entries) {
        expect(entry.value.id, entry.key, reason: domain.id);
        expect(entry.value.content.id, entry.key, reason: domain.id);
        expect(
          entry.value.content.ownerId,
          domain.id,
          reason: '${domain.id}: ${entry.key}',
        );
        expect(
          entry.value.content.source.isEmpty,
          isFalse,
          reason: '${domain.id}: ${entry.key}',
        );
      }
    }
  });

  test('all 70 domain-spell table entries are canonical', () {
    var tableEntries = 0;

    for (final domain in cleric.subclasses.values) {
      expect(
        domain.alwaysPreparedSpellIdsByLevel.keys.toSet(),
        {1, 3, 5, 7, 9},
        reason: domain.id,
      );

      for (final entry in domain.alwaysPreparedSpellIdsByLevel.entries) {
        expect(
          entry.value,
          hasLength(2),
          reason: '${domain.id}, livello ${entry.key}',
        );

        for (final spellId in entry.value) {
          expect(
            spellDefinitions.containsKey(spellId),
            isTrue,
            reason: '${domain.id}: incantesimo sconosciuto $spellId',
          );
        }

        tableEntries += entry.value.length;
      }

      expect(
        domain.alwaysPreparedSpellIdsAtLevel(0),
        isEmpty,
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(1),
        hasLength(2),
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(3),
        hasLength(4),
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(5),
        hasLength(6),
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(7),
        hasLength(8),
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(9),
        hasLength(10),
        reason: domain.id,
      );
      expect(
        domain.alwaysPreparedSpellIdsAtLevel(20),
        hasLength(10),
        reason: domain.id,
      );
    }

    expect(tableEntries, 70);
  });

  test('all feature resource references resolve correctly', () {
    final classResourceIds =
        cleric.resources.map((resource) => resource.id).toSet();

    expect(classResourceIds, {'channel_divinity'});

    for (final domain in cleric.subclasses.values) {
      final domainResourceIds =
          domain.resources.map((resource) => resource.id).toList();

      expect(
        domainResourceIds.toSet().length,
        domainResourceIds.length,
        reason: 'Risorsa duplicata: ${domain.id}',
      );

      final availableResourceIds = {
        ...classResourceIds,
        ...domainResourceIds,
      };

      for (final feature in domain.featureDefinitions.values) {
        if (feature.resourceId == null) continue;

        expect(
          availableResourceIds,
          contains(feature.resourceId),
          reason: '${domain.id}: risorsa sconosciuta ${feature.resourceId}',
        );
      }
    }
  });

  test('Wisdom-based domain resources preserve their official names', () {
    final resources = {
      for (final domain in cleric.subclasses.values)
        for (final resource in domain.resources) resource.id: resource,
    };

    expect(
      resources.keys,
      {
        'light_warding_flare',
        'tempest_wrath_of_the_storm',
        'war_priest',
      },
    );

    expect(resources['light_warding_flare']!.name, 'Interdizione Luminosa');
    expect(
      resources['tempest_wrath_of_the_storm']!.name,
      'Ira della Tempesta',
    );
    expect(resources['war_priest']!.name, 'Prete della Guerra');

    for (final resource in resources.values) {
      expect(resource.maximumAbility, 'SAG');
      expect(resource.minimumMaximum, 1);
      expect(resource.recovery, ClassResourceRecovery.longRest);
    }
  });

  test('all structured choices have unique stable IDs', () {
    final choiceIds = <String>[];

    for (final domain in cleric.subclasses.values) {
      for (final feature in domain.featureDefinitions.values) {
        choiceIds.addAll(feature.choices.map((choice) => choice.id));
      }
    }

    expect(choiceIds.toSet().length, choiceIds.length);
    expect(
      choiceIds.toSet(),
      {
        'knowledge_domain_languages',
        'knowledge_domain_skills',
        'nature_domain_druid_cantrip',
        'nature_domain_skill',
      },
    );
  });

  test('Cleric reaches level 20 with the official progression values', () {
    expect(
      cleric.featuresAtLevel(20),
      ['divine_intervention_improvement'],
    );

    final channel =
        cleric.resources.singleWhere((r) => r.id == 'channel_divinity');

    expect(channel.maximumAtLevel(1), 0);
    expect(channel.maximumAtLevel(2), 1);
    expect(channel.maximumAtLevel(6), 2);
    expect(channel.maximumAtLevel(18), 3);
    expect(channel.maximumAtLevel(20), 3);

    final destroyUndead = cleric.progressionValues.singleWhere(
      (value) => value.id == 'destroy_undead_cr',
    );

    expect(destroyUndead.valueAtLevel(4), isNull);
    expect(destroyUndead.valueAtLevel(5), '1/2');
    expect(destroyUndead.valueAtLevel(8), '1');
    expect(destroyUndead.valueAtLevel(11), '2');
    expect(destroyUndead.valueAtLevel(14), '3');
    expect(destroyUndead.valueAtLevel(17), '4');
    expect(destroyUndead.valueAtLevel(20), '4');
  });
}
