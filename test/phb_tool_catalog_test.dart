import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

const phbToolValues = <String, ({int cost, String currency, double weightKg})>{
  ToolIds.alchemistsSupplies: (
    cost: 50,
    currency: 'gp',
    weightKg: 4.0,
  ),
  ToolIds.brewersSupplies: (
    cost: 20,
    currency: 'gp',
    weightKg: 4.5,
  ),
  ToolIds.calligraphersSupplies: (
    cost: 10,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.carpentersTools: (
    cost: 8,
    currency: 'gp',
    weightKg: 3.0,
  ),
  ToolIds.cartographersTools: (
    cost: 15,
    currency: 'gp',
    weightKg: 3.0,
  ),
  ToolIds.cobblersTools: (
    cost: 5,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.cooksUtensils: (
    cost: 1,
    currency: 'gp',
    weightKg: 4.0,
  ),
  ToolIds.glassblowersTools: (
    cost: 30,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.jewelersTools: (
    cost: 25,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.leatherworkersTools: (
    cost: 5,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.masonsTools: (
    cost: 10,
    currency: 'gp',
    weightKg: 4.0,
  ),
  ToolIds.paintersSupplies: (
    cost: 10,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.pottersTools: (
    cost: 10,
    currency: 'gp',
    weightKg: 1.5,
  ),
  ToolIds.smithsTools: (
    cost: 20,
    currency: 'gp',
    weightKg: 4.0,
  ),
  ToolIds.tinkersTools: (
    cost: 50,
    currency: 'gp',
    weightKg: 5.0,
  ),
  ToolIds.weaversTools: (
    cost: 1,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.woodcarversTools: (
    cost: 1,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.bagpipes: (
    cost: 30,
    currency: 'gp',
    weightKg: 3.0,
  ),
  ToolIds.drum: (
    cost: 6,
    currency: 'gp',
    weightKg: 1.5,
  ),
  ToolIds.dulcimer: (
    cost: 25,
    currency: 'gp',
    weightKg: 5.0,
  ),
  ToolIds.flute: (
    cost: 2,
    currency: 'gp',
    weightKg: 0.5,
  ),
  ToolIds.lute: (
    cost: 35,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.lyre: (
    cost: 30,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.horn: (
    cost: 3,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.panFlute: (
    cost: 12,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.shawm: (
    cost: 2,
    currency: 'gp',
    weightKg: 0.5,
  ),
  ToolIds.viol: (
    cost: 30,
    currency: 'gp',
    weightKg: 0.5,
  ),
  ToolIds.diceSet: (
    cost: 1,
    currency: 'sp',
    weightKg: 0.0,
  ),
  ToolIds.dragonchessSet: (
    cost: 1,
    currency: 'gp',
    weightKg: 0.25,
  ),
  ToolIds.playingCardSet: (
    cost: 5,
    currency: 'sp',
    weightKg: 0.0,
  ),
  ToolIds.threeDragonAnteSet: (
    cost: 1,
    currency: 'gp',
    weightKg: 0.0,
  ),
  ToolIds.disguiseKit: (
    cost: 25,
    currency: 'gp',
    weightKg: 1.5,
  ),
  ToolIds.forgeryKit: (
    cost: 15,
    currency: 'gp',
    weightKg: 2.5,
  ),
  ToolIds.herbalismKit: (
    cost: 5,
    currency: 'gp',
    weightKg: 1.5,
  ),
  ToolIds.navigatorsTools: (
    cost: 25,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.poisonersKit: (
    cost: 50,
    currency: 'gp',
    weightKg: 1.0,
  ),
  ToolIds.thievesTools: (
    cost: 25,
    currency: 'gp',
    weightKg: 0.5,
  ),
};

const vehicleProficiencyIds = <String>{
  ToolIds.landVehicles,
  ToolIds.waterVehicles,
};

void main() {
  test('PHB tool registry contains 37 tools and 2 vehicle proficiencies', () {
    expect(phbToolValues.length, 37);
    expect(vehicleProficiencyIds.length, 2);
    expect(toolDefinitions.length, 39);

    expect(
      toolDefinitions.keys.toSet(),
      {...phbToolValues.keys, ...vehicleProficiencyIds},
    );
  });

  test('PHB tool costs and metric weights match the manual', () {
    final errors = <String>[];

    for (final entry in phbToolValues.entries) {
      final tool = toolDefinitions[entry.key];

      if (tool == null) {
        errors.add('Definizione mancante: ${entry.key}');
        continue;
      }

      if (tool.cost != entry.value.cost) {
        errors.add(
          '${entry.key}: costo=${tool.cost}, atteso=${entry.value.cost}',
        );
      }

      if (tool.currency != entry.value.currency) {
        errors.add(
          '${entry.key}: valuta=${tool.currency}, '
          'attesa=${entry.value.currency}',
        );
      }

      if (tool.weightKg != entry.value.weightKg) {
        errors.add(
          '${entry.key}: peso=${tool.weightKg} kg, '
          'atteso=${entry.value.weightKg} kg',
        );
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('vehicle tool ids remain proficiency placeholders', () {
    for (final id in vehicleProficiencyIds) {
      final vehicle = toolDefinitions[id];

      expect(vehicle, isNotNull);
      expect(vehicle!.category, ToolCategory.vehicle);
      expect(vehicle.cost, 0);
      expect(vehicle.weightKg, 0);
    }
  });

  test('tool registry is internally coherent', () {
    for (final entry in toolDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.name.trim(), isNotEmpty);
      expect(entry.value.cost, greaterThanOrEqualTo(0));
      expect(entry.value.weightKg, greaterThanOrEqualTo(0));
      expect({'cp', 'sp', 'ep', 'gp', 'pp'}, contains(entry.value.currency));
    }
  });
}
