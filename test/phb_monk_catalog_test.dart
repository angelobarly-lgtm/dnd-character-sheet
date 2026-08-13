import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/monk_class_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monk = phbClassDefinitions[ClassIds.monk]!;

  test('PHB Monk base catalog is structurally complete', () {
    expect(monk.id, ClassIds.monk);
    expect(monk.hitDie, 8);
    expect(monk.proficiencies.savingThrows, {'FOR', 'DES'});
    expect(monk.subclassSelectionLevel, 3);
    expect(monk.resources.single.id, 'ki');
    expect(monk.featureDefinitions, hasLength(20));

    final granted =
        monk.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(20));
    expect(
      granted.difference(monk.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('all Monk feature content has verified editorial metadata', () {
    expect(monk.content.source.isEmpty, isFalse);
    expect(monk.content.description.summary.trim(), isNotEmpty);
    expect(monk.content.description.details.trim(), isNotEmpty);

    for (final entry in monk.featureDefinitions.entries) {
      final content = entry.value.content;

      expect(content.id, entry.key);
      expect(content.ownerId, ClassIds.monk);
      expect(content.source.isEmpty, isFalse);
      expect(content.description.summary.trim(), isNotEmpty);
      expect(content.description.details.trim(), isNotEmpty);
    }
  });

  test('all Monk weapon proficiencies resolve to catalog entries', () {
    expect(
      monk.proficiencies.weapons.difference(weaponDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final weaponId in monk.proficiencies.weapons) {
      final weapon = weaponDefinitions[weaponId]!;

      if (weaponId == 'shortsword') {
        expect(weapon.category, WeaponCategory.martial);
      } else {
        expect(weapon.category, WeaponCategory.simple);
      }
    }
  });

  test('the Monk tool choice resolves to 27 purchasable tools', () {
    final toolChoice = monk.proficiencies.choices.singleWhere(
      (choice) => choice.id == 'monk_artisan_tool_or_instrument',
    );

    expect(toolChoice.optionIds, hasLength(27));
    expect(
      toolChoice.optionIds.difference(toolDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final toolId in toolChoice.optionIds) {
      final category = toolDefinitions[toolId]!.category;

      expect(
        {
          ToolCategory.artisan,
          ToolCategory.musical,
        },
        contains(category),
      );
    }
  });

  test('all Monk starting equipment resolves to existing catalogs', () {
    for (final choice in monk.startingEquipmentChoices) {
      for (final alternative in choice.alternatives) {
        for (final grant in alternative.grants) {
          switch (grant.catalogId) {
            case 'weapon':
              expect(
                weaponDefinitions,
                contains(grant.itemId),
                reason: 'Arma iniziale mancante: ${grant.itemId}',
              );
            case 'equipment_pack':
              expect(
                equipmentPackDefinitions,
                contains(grant.itemId),
                reason: 'Dotazione iniziale mancante: ${grant.itemId}',
              );
            default:
              fail(
                'Catalogo iniziale non riconosciuto: ${grant.catalogId}',
              );
          }
        }
      }
    }

    for (final grant in monk.fixedStartingEquipment) {
      expect(grant.catalogId, 'weapon');
      expect(weaponDefinitions, contains(grant.itemId));
      expect(grant.quantity, greaterThan(0));
    }
  });

  test('Monk Ki and progressive values cover levels 1 through 20', () {
    final ki = monk.resources.singleWhere(
      (resource) => resource.id == 'ki',
    );

    for (var level = 1; level <= 20; level++) {
      expect(
        ki.maximumAtLevel(level),
        level == 1 ? 0 : level,
        reason: 'Ki errato al livello $level',
      );

      expect(
        monk.progressionValue('martial_arts_die', level),
        isNotNull,
        reason: 'Dado marziale assente al livello $level',
      );

      if (level >= 2) {
        expect(
          monk.progressionValue(
            'unarmored_movement_bonus',
            level,
          ),
          isNotNull,
          reason: 'Movimento assente al livello $level',
        );
      }
    }
  });

  test('the three PHB Monk traditions are complete', () {
    expect(
      monk.phbSubclasses.map((subclass) => subclass.id).toSet(),
      {
        MonkSubclassIds.openHand,
        MonkSubclassIds.shadow,
        MonkSubclassIds.fourElements,
      },
    );
    expect(monk.phbSubclasses, hasLength(3));
    expect(monk.supplementalSubclasses, isEmpty);

    for (final subclass in monk.phbSubclasses) {
      expect(subclass.classId, ClassIds.monk);
      expect(subclass.content.source.isEmpty, isFalse);
      expect(subclass.content.description.summary.trim(), isNotEmpty);
      expect(subclass.content.description.details.trim(), isNotEmpty);

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

  test('Four Elements has 17 coherent elemental disciplines', () {
    final fourElements = monk.subclasses[MonkSubclassIds.fourElements]!;

    expect(fourElements.options, hasLength(17));
    expect(
      fourElements.options.map((option) => option.id).toSet(),
      hasLength(17),
    );

    for (final option in fourElements.options) {
      expect(option.source.trim(), isNotEmpty);
      expect(option.sourceRef.trim(), isNotEmpty);
      expect(option.description.summary.trim(), isNotEmpty);
      expect(option.description.details.trim(), isNotEmpty);
      expect(option.minimumLevel, anyOf(3, 6, 11, 17));

      if (option.cost != null) {
        expect(option.cost, greaterThan(0));
        expect(option.resource, 'ki');
        expect(
          option.cost,
          lessThanOrEqualTo(option.minimumLevel),
        );
      }
    }
  });

  test('all 12 spell disciplines expose canonical spell IDs', () {
    final fourElements = monk.subclasses[MonkSubclassIds.fourElements]!;

    final spellIds = fourElements.options
        .map((option) => option.spellId)
        .whereType<String>()
        .toSet();

    expect(spellIds, {
      'burning_hands',
      'cone_of_cold',
      'fireball',
      'fly',
      'gaseous_form',
      'gust_of_wind',
      'hold_person',
      'shatter',
      'stoneskin',
      'thunderwave',
      'wall_of_fire',
      'wall_of_stone',
    });
  });

  test('Monk rules contain no imperial measurement references', () {
    final descriptions = <String>[
      monk.content.description.summary,
      monk.content.description.details,
      for (final feature in monk.featureDefinitions.values)
        feature.content.description.details,
      for (final subclass in monk.phbSubclasses) ...[
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
}
