import 'package:dnd_character_sheet/data/background_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all backgrounds generate their complete fixed equipment', () {
    expect(backgroundDefinitions, isNotEmpty);

    for (final background in backgroundDefinitions.values) {
      final inventory = buildBackgroundStartingInventory(
        background: background,
      );

      for (final grant in background.startingEquipment) {
        expect(
          inventory,
          contains(
            allOf(
              containsPair('id', grant.itemId),
              containsPair('catalogId', grant.catalogId),
              containsPair('quantity', grant.quantity),
            ),
          ),
          reason: '${background.name}: oggetto fisso ${grant.itemId}',
        );
      }

      for (final pack in background.startingEquipmentPacks) {
        expect(
          inventory,
          contains(
            allOf(
              containsPair('id', pack),
              containsPair('catalogId', 'pack'),
            ),
          ),
          reason: '${background.name}: pacchetto $pack',
        );
      }
    }
  });

  test('all background equipment choices enter the inventory', () {
    for (final background in backgroundDefinitions.values) {
      final selections = <String, List<String>>{};

      for (final choice in background.effects.choices) {
        if (choice.type != CharacterChoiceType.equipment) continue;

        final available = <String>[
          ...choice.optionIds,
          ...choice.options.map((option) => option.id),
        ];

        expect(
          available.length,
          greaterThanOrEqualTo(choice.minimumSelections),
          reason: '${background.name}: opzioni insufficienti per ${choice.id}',
        );

        selections[choice.id] =
            available.take(choice.minimumSelections).toList();
      }

      final inventory = buildBackgroundStartingInventory(
        background: background,
        choices: selections,
      );

      for (final entry in selections.entries) {
        final choice = background.effects.choices.firstWhere(
          (candidate) => candidate.id == entry.key,
        );

        for (final itemId in entry.value) {
          expect(
            inventory,
            contains(
              allOf(
                containsPair('id', itemId),
                containsPair(
                  'catalogId',
                  choice.catalogId ?? 'equipment',
                ),
              ),
            ),
            reason: '${background.name}: oggetto scelto $itemId',
          );
        }
      }
    }
  });

  test('all backgrounds preserve their starting coins', () {
    for (final background in backgroundDefinitions.values) {
      for (final entry in background.startingCoins.entries) {
        expect(entry.value, greaterThanOrEqualTo(0));
        expect(entry.key, isNotEmpty);
      }
    }
  });
}
