import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/mount_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PHB mount catalog contains all nine selectable mount ids', () {
    expect(MountIds.camel, isNotEmpty);
    expect(mountDefinitions.length, 9);
    expect(
      mountDefinitions.keys.toSet(),
      {
        MountIds.camel,
        MountIds.donkey,
        MountIds.mule,
        MountIds.elephant,
        MountIds.horseDraft,
        MountIds.horseRiding,
        MountIds.mastiff,
        MountIds.pony,
        MountIds.warhorse,
      },
    );

    for (final entry in mountDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.name.trim(), isNotEmpty);
      expect(entry.value.cost, greaterThan(0));
      expect(entry.value.currency, 'gp');
      expect(entry.value.speedMeters, greaterThan(0));
      expect(entry.value.carryingCapacityKg, greaterThan(0));
    }
  });

  test('PHB mount metric values match the Italian manual', () {
    final snapshots = mountDefinitions.values
        .map(
          (mount) => '${mount.id}|${mount.cost}|${mount.speedMeters}|'
              '${mount.carryingCapacityKg}',
        )
        .toSet();

    expect(
      snapshots,
      {
        'camel|50|15.0|240.0',
        'donkey|8|12.0|210.0',
        'mule|8|12.0|210.0',
        'elephant|200|12.0|660.0',
        'horse_draft|50|12.0|270.0',
        'horse_riding|75|18.0|240.0',
        'mastiff|25|12.0|97.5',
        'pony|30|12.0|112.5',
        'warhorse|400|18.0|270.0',
      },
    );
  });

  test('PHB mount gear contains all nine entries', () {
    expect(mountGearDefinitions.length, 9);

    for (final entry in mountGearDefinitions.entries) {
      final gear = entry.value;

      expect(gear.id, entry.key);
      expect(gear.name.trim(), isNotEmpty);
      expect(gear.cost == null || gear.cost! > 0, isTrue);
      expect(gear.weightKg == null || gear.weightKg! >= 0, isTrue);
    }

    final barding = mountGearDefinitions[MountGearIds.barding]!;

    expect(barding.cost, isNull);
    expect(barding.weightKg, isNull);
    expect(barding.costForBaseArmor(75), 300);
    expect(barding.weightForBaseArmor(27.5), 55);

    expect(
      mountGearDefinitions[MountGearIds.feedPerDay]!.dailyCost,
      isTrue,
    );
    expect(
      mountGearDefinitions[MountGearIds.stablingPerDay]!.dailyCost,
      isTrue,
    );
  });

  test('PHB vehicle catalog contains five land and six water vehicles', () {
    expect(vehicleDefinitions.length, 11);

    final land = vehicleDefinitions.values
        .where((vehicle) => vehicle.category == VehicleCategory.land)
        .toList();
    final water = vehicleDefinitions.values
        .where((vehicle) => vehicle.category == VehicleCategory.water)
        .toList();

    expect(land.length, 5);
    expect(water.length, 6);

    for (final vehicle in land) {
      expect(vehicle.requiresDraftAnimal, isTrue);
      expect(vehicle.draftCapacityMultiplier, 5);
      expect(vehicle.weightKg, isNotNull);
      expect(vehicle.speedKmh, isNull);
    }

    for (final vehicle in water) {
      expect(vehicle.requiresDraftAnimal, isFalse);
      expect(vehicle.speedKmh, greaterThan(0));
    }
  });

  test('PHB vehicle costs weights and speeds match the manual', () {
    final snapshots = vehicleDefinitions.values
        .map(
          (vehicle) =>
              '${vehicle.id}|${vehicle.cost}|${vehicle.weightKg ?? ''}|'
              '${vehicle.speedKmh ?? ''}',
        )
        .toSet();

    expect(
      snapshots,
      {
        'chariot|250|50.0|',
        'cart|15|100.0|',
        'wagon|35|200.0|',
        'carriage|100|300.0|',
        'sled|20|150.0|',
        'rowboat|50|50.0|2.25',
        'keelboat|3000||1.5',
        'galley|30000||6.0',
        'sailing_ship|10000||3.0',
        'warship|25000||3.75',
        'longship|10000||4.5',
      },
    );
  });

  test('cart remains compatible with the general equipment catalog', () {
    expect(VehicleIds.cart, EquipmentIds.cart);

    final equipmentCart = equipmentDefinitions[EquipmentIds.cart]!;

    expect(equipmentCart.cost, 15);
    expect(equipmentCart.weightKg, 100);
    expect(vehicleDefinitions[VehicleIds.cart]!.cost, equipmentCart.cost);
    expect(
      vehicleDefinitions[VehicleIds.cart]!.weightKg,
      equipmentCart.weightKg,
    );
  });
}
