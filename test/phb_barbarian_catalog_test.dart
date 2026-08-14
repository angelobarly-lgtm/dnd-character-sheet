import 'package:dnd_character_sheet/data/barbarian_class_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final barbarian = phbClassDefinitions[ClassIds.barbarian]!;

  test('PHB Barbarian base catalog is structurally complete', () {
    expect(barbarian.id, ClassIds.barbarian);
    expect(barbarian.hitDie, 12);
    expect(barbarian.proficiencies.savingThrows, {'FOR', 'COS'});
    expect(barbarian.subclassSelectionLevel, 3);
    expect(barbarian.resources.single.id, 'rage');
    expect(barbarian.featureDefinitions, hasLength(14));

    final granted =
        barbarian.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(14));
    expect(
      granted.difference(
        barbarian.featureDefinitions.keys.toSet(),
      ),
      isEmpty,
    );
  });

  test('all Barbarian content has editorial metadata', () {
    expect(barbarian.content.source.isEmpty, isFalse);
    expect(
      barbarian.content.description.summary.trim(),
      isNotEmpty,
    );
    expect(
      barbarian.content.description.details.trim(),
      isNotEmpty,
    );

    for (final entry in barbarian.featureDefinitions.entries) {
      final content = entry.value.content;

      expect(content.id, entry.key);
      expect(content.ownerId, ClassIds.barbarian);
      expect(content.source.isEmpty, isFalse);
      expect(content.description.summary.trim(), isNotEmpty);
      expect(content.description.details.trim(), isNotEmpty);
    }
  });

  test('Barbarian starting equipment resolves to PHB catalogs', () {
    for (final choice in barbarian.startingEquipmentChoices) {
      expect(choice.alternatives, isNotEmpty);

      for (final alternative in choice.alternatives) {
        expect(alternative.grants, isNotEmpty);

        for (final grant in alternative.grants) {
          expect(grant.catalogId, 'weapon');
          expect(
            weaponDefinitions,
            contains(grant.itemId),
            reason: 'Arma iniziale mancante: ${grant.itemId}',
          );
          expect(grant.quantity, greaterThan(0));
        }
      }
    }

    for (final grant in barbarian.fixedStartingEquipment) {
      switch (grant.catalogId) {
        case 'weapon':
          expect(weaponDefinitions, contains(grant.itemId));
        case 'equipment_pack':
          expect(
            equipmentPackDefinitions,
            contains(grant.itemId),
          );
        default:
          fail('Catalogo non riconosciuto: ${grant.catalogId}');
      }
    }
  });

  test('Rage and progressive values cover levels 1 through 20', () {
    final rage = barbarian.resources.singleWhere(
      (resource) => resource.id == 'rage',
    );

    for (var level = 1; level <= 20; level++) {
      expect(
        rage.maximumAtLevel(level),
        greaterThan(0),
        reason: 'Ira assente al livello $level',
      );
      expect(
        barbarian.progressionValue('rage_damage', level),
        isNotNull,
        reason: 'Danno dell’Ira assente al livello $level',
      );
    }

    expect(rage.isUnlimitedAtLevel(19), isFalse);
    expect(rage.isUnlimitedAtLevel(20), isTrue);

    for (var level = 9; level <= 20; level++) {
      expect(
        barbarian.progressionValue(
          'brutal_critical_dice',
          level,
        ),
        isNotNull,
        reason: 'Critico Brutale assente al livello $level',
      );
    }
  });

  test('both PHB Primal Paths are structurally complete', () {
    expect(
      barbarian.phbSubclasses.map((subclass) => subclass.id).toSet(),
      {
        BarbarianSubclassIds.berserker,
        BarbarianSubclassIds.totemWarrior,
      },
    );
    expect(barbarian.phbSubclasses, hasLength(2));
    expect(barbarian.supplementalSubclasses, isEmpty);

    for (final subclass in barbarian.phbSubclasses) {
      expect(subclass.classId, ClassIds.barbarian);
      expect(subclass.content.source.isEmpty, isFalse);
      expect(
        subclass.content.description.summary.trim(),
        isNotEmpty,
      );
      expect(
        subclass.content.description.details.trim(),
        isNotEmpty,
      );

      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toSet();

      expect(
        granted.difference(
          subclass.featureDefinitions.keys.toSet(),
        ),
        isEmpty,
        reason: 'Privilegio non registrato in ${subclass.id}',
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final content = entry.value.content;

        expect(content.id, entry.key);
        expect(content.ownerId, subclass.id);
        expect(content.source.isEmpty, isFalse);
      }
    }
  });

  test('Totem Warrior has nine coherent choices', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(totem.options, hasLength(9));
    expect(
      totem.options.map((option) => option.id).toSet(),
      hasLength(9),
    );

    final expectedLevels = {
      'totem_spirit': 3,
      'aspect_of_the_beast': 6,
      'totemic_attunement': 14,
    };

    for (final entry in expectedLevels.entries) {
      final tier = totem.options
          .where((option) => option.category == entry.key)
          .toList();

      expect(tier, hasLength(3));
      expect(
        tier.every(
          (option) => option.minimumLevel == entry.value,
        ),
        isTrue,
      );
    }

    final progression = totem.optionProgression!;

    expect(progression.selectionsAtLevel(3), 1);
    expect(progression.selectionsAtLevel(6), 2);
    expect(progression.selectionsAtLevel(14), 3);
    expect(progression.selectionsAtLevel(20), 3);
  });

  test('Totem ritual features expose canonical spell IDs', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(
      totem.featureDefinitions['spirit_seeker']!.spellIds,
      {
        'beast_sense',
        'speak_with_animals',
      },
    );
    expect(
      totem.featureDefinitions['spirit_walker']!.spellIds,
      {
        'commune_with_nature',
      },
    );

    expect(
      totem.featureDefinitions.values
          .expand((feature) => feature.spellIds)
          .toSet(),
      {
        'beast_sense',
        'speak_with_animals',
        'commune_with_nature',
      },
    );
  });

  test('Barbarian rules contain no imperial measurements', () {
    final descriptions = <String>[
      barbarian.content.description.summary,
      barbarian.content.description.details,
      for (final feature in barbarian.featureDefinitions.values)
        feature.content.description.details,
      for (final subclass in barbarian.phbSubclasses) ...[
        subclass.content.description.details,
        for (final feature in subclass.featureDefinitions.values)
          feature.content.description.details,
        for (final option in subclass.options) option.description.details,
      ],
    ];

    final imperialPattern = RegExp(
      r'\b(feet|foot|ft|mile|miles|lb|lbs|pound|pounds)\b',
      caseSensitive: false,
    );

    expect(
      descriptions.where(imperialPattern.hasMatch),
      isEmpty,
    );
  });

  test('universal class registry contains Monk and Barbarian', () {
    expect(
      phbClassDefinitions.keys.toSet(),
      containsAll({
        ClassIds.barbarian,
        ClassIds.monk,
      }),
    );
  });

  test('manual audit preserves the complete PHB Barbarian rules', () {
    final rage = barbarian.resources.singleWhere(
      (resource) => resource.id == 'rage',
    );
    final rageDetails =
        barbarian.featureDefinitions['rage']!.content.description.details;
    final feralInstinct =
        barbarian.featureDefinitions['feral_instinct']!.content.description;
    final relentlessRage =
        barbarian.featureDefinitions['relentless_rage']!.content.description;

    expect(barbarian.content.source.name, 'Manuale del Giocatore 2014');
    expect(barbarian.content.source.reference, 'Pagine 46-50');

    expect(rage.recovery, ClassResourceRecovery.longRest);
    expect(rage.maximumAtLevel(1), 2);
    expect(rage.maximumAtLevel(3), 3);
    expect(rage.maximumAtLevel(6), 4);
    expect(rage.maximumAtLevel(12), 5);
    expect(rage.maximumAtLevel(17), 6);
    expect(rage.isUnlimitedAtLevel(20), isTrue);

    expect(
      rageDetails,
      allOf(
        contains('non può lanciare incantesimi'),
        contains('concentrarsi'),
        contains('senza avere attaccato'),
        contains('senza avere subito danni'),
        contains('azione bonus'),
      ),
    );
    expect(feralInstinct.details, contains('non è incapacitato'));
    expect(
      feralInstinct.details,
      contains('prima di fare qualsiasi altra cosa'),
    );
    expect(relentlessRage.details, contains('non viene ucciso sul colpo'));

    expect(barbarian.progressionValue('rage_damage', 1), '+2');
    expect(barbarian.progressionValue('rage_damage', 9), '+3');
    expect(barbarian.progressionValue('rage_damage', 16), '+4');
    expect(barbarian.progressionValue('brutal_critical_dice', 9), '1');
    expect(barbarian.progressionValue('brutal_critical_dice', 13), '2');
    expect(barbarian.progressionValue('brutal_critical_dice', 17), '3');
  });

  test('Berserker preserves the PHB limits of Intimidating Presence', () {
    final berserker = barbarian.subclasses[BarbarianSubclassIds.berserker]!;
    final presence = berserker.featureDefinitions['intimidating_presence']!;
    final details = presence.content.description.details;

    expect(details, contains('9 metri'));
    expect(details, contains('18 metri'));
    expect(details, contains('24 ore'));
    expect(details, contains('linea di vista'));
    expect(details, contains('modificatore di Carisma'));
  });

  test('Totem Warrior uses the official manual wording and distances', () {
    final totem = barbarian.subclasses[BarbarianSubclassIds.totemWarrior]!;

    expect(totem.name, 'Cammino del Combattente Totemico');
    expect(totem.content.name, 'Cammino del Combattente Totemico');
    expect(totem.content.source.reference, 'Pagine 49-50');

    for (final option in totem.options) {
      expect(option.sourceRef, 'Pagina 50');
    }

    final eagleAspect = totem.options.singleWhere(
      (option) => option.id == 'aspect_of_the_beast_eagle',
    );
    final bearAttunement = totem.options.singleWhere(
      (option) => option.id == 'totemic_attunement_bear',
    );

    expect(eagleAspect.description.details, contains('1,5 km'));
    expect(eagleAspect.description.details, isNot(contains('1,6 km')));

    expect(
      bearAttunement.description.details,
      allOf(
        contains('un altro personaggio dotato di questo privilegio'),
        contains('vedere o sentire'),
        contains('non può essere spaventata'),
      ),
    );
  });
}
