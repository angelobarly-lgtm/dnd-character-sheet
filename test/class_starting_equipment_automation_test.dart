import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic>? inventoryEntry(
  List<Map<String, dynamic>> inventory,
  String catalogId,
  String itemId,
) {
  for (final entry in inventory) {
    if (entry['catalogId'] == catalogId && entry['id'] == itemId) {
      return entry;
    }
  }
  return null;
}

void main() {
  test('all twelve PHB classes expose valid starting equipment', () {
    expect(phbClassDefinitions, hasLength(12));

    for (final definition in phbClassDefinitions.values) {
      final inventory = buildClassStartingInventory(
        classDefinition: definition,
      );

      for (final grant in definition.fixedStartingEquipment) {
        final entry = inventoryEntry(
          inventory,
          grant.catalogId,
          grant.itemId,
        );

        expect(
          entry,
          isNotNull,
          reason: '${definition.name}: oggetto fisso ${grant.itemId}',
        );
        expect(
          entry!['quantity'],
          greaterThanOrEqualTo(grant.quantity),
        );
      }

      for (final choice in definition.startingEquipmentChoices) {
        expect(
          choice.alternatives,
          isNotEmpty,
          reason: '${definition.name}: ${choice.id}',
        );
      }
    }
  });

  test('every class equipment alternative can generate its grants', () {
    for (final definition in phbClassDefinitions.values) {
      for (final choice in definition.startingEquipmentChoices) {
        for (final alternative in choice.alternatives) {
          final selections = <String, List<String>>{
            classEquipmentChoiceKey(definition.id, choice.id): [
              alternative.id,
            ],
          };

          for (final itemChoice in alternative.itemChoices) {
            expect(
              itemChoice.optionIds,
              isNotEmpty,
              reason: '${definition.name}: opzioni vuote per ${itemChoice.id}',
            );

            final options = itemChoice.optionIds.toList()..sort();
            final selectedItems = itemChoice.allowDuplicates
                ? List<String>.filled(
                    itemChoice.selections,
                    options.first,
                  )
                : options.take(itemChoice.selections).toList();

            expect(
              selectedItems,
              hasLength(itemChoice.selections),
              reason: '${definition.name}: opzioni insufficienti per '
                  '${itemChoice.id}',
            );

            selections[classEquipmentItemChoiceKey(
              definition.id,
              choice.id,
              alternative.id,
              itemChoice.id,
            )] = selectedItems;
          }

          final inventory = buildClassStartingInventory(
            classDefinition: definition,
            choices: selections,
          );

          for (final grant in alternative.grants) {
            final entry = inventoryEntry(
              inventory,
              grant.catalogId,
              grant.itemId,
            );

            expect(
              entry,
              isNotNull,
              reason: '${definition.name}: ${alternative.id} non concede '
                  '${grant.itemId}',
            );
            expect(
              entry!['quantity'],
              greaterThanOrEqualTo(grant.quantity),
            );
          }

          for (final itemChoice in alternative.itemChoices) {
            final selectedItems = selections[classEquipmentItemChoiceKey(
              definition.id,
              choice.id,
              alternative.id,
              itemChoice.id,
            )]!;

            for (final itemId in selectedItems.toSet()) {
              final entry = inventoryEntry(
                inventory,
                itemChoice.catalogId,
                itemId,
              );

              expect(entry, isNotNull);

              final expectedQuantity =
                  selectedItems.where((id) => id == itemId).length;

              expect(
                entry!['quantity'],
                greaterThanOrEqualTo(expectedQuantity),
              );
            }
          }
        }
      }
    }
  });

  test('duplicate weapon choices are preserved as quantities', () {
    var duplicateCases = 0;

    for (final definition in phbClassDefinitions.values) {
      for (final choice in definition.startingEquipmentChoices) {
        for (final alternative in choice.alternatives) {
          for (final itemChoice in alternative.itemChoices) {
            if (!itemChoice.allowDuplicates) continue;
            duplicateCases++;

            final itemId = itemChoice.optionIds.first;
            final selections = <String, List<String>>{
              classEquipmentChoiceKey(definition.id, choice.id): [
                alternative.id,
              ],
              classEquipmentItemChoiceKey(
                definition.id,
                choice.id,
                alternative.id,
                itemChoice.id,
              ): List<String>.filled(itemChoice.selections, itemId),
            };

            final inventory = buildClassStartingInventory(
              classDefinition: definition,
              choices: selections,
            );

            final entry = inventoryEntry(
              inventory,
              itemChoice.catalogId,
              itemId,
            );

            expect(entry, isNotNull);
            expect(entry!['quantity'], itemChoice.selections);
          }
        }
      }
    }

    expect(duplicateCases, 3);
  });
}
