import 'package:dnd_character_sheet/data/equipment_data.dart';
import 'package:dnd_character_sheet/data/focus_data.dart';
import 'package:flutter_test/flutter_test.dart';

const phbEquipmentIds = <String>{
  EquipmentIds.abacus,
  EquipmentIds.acidVial,
  EquipmentIds.alchemistsFireFlask,
  EquipmentIds.antitoxinVial,
  EquipmentIds.backpack,
  EquipmentIds.ballBearings,
  EquipmentIds.barrel,
  EquipmentIds.basket,
  EquipmentIds.bedroll,
  EquipmentIds.bell,
  EquipmentIds.blanket,
  EquipmentIds.blockAndTackle,
  EquipmentIds.book,
  EquipmentIds.bottle,
  EquipmentIds.bucket,
  EquipmentIds.caltrops,
  EquipmentIds.candle,
  EquipmentIds.crossbowBoltCase,
  EquipmentIds.scrollCase,
  EquipmentIds.chain,
  EquipmentIds.chalk,
  EquipmentIds.chest,
  EquipmentIds.climbersKit,
  EquipmentIds.commonClothes,
  EquipmentIds.costume,
  EquipmentIds.fineClothes,
  EquipmentIds.travelersClothes,
  EquipmentIds.crowbar,
  EquipmentIds.fishingTackle,
  EquipmentIds.flask,
  EquipmentIds.grapplingHook,
  EquipmentIds.hammer,
  EquipmentIds.sledgehammer,
  EquipmentIds.healersKit,
  EquipmentIds.holyWaterFlask,
  EquipmentIds.hourglass,
  EquipmentIds.huntingTrap,
  EquipmentIds.ink,
  EquipmentIds.inkPen,
  EquipmentIds.jug,
  EquipmentIds.ladder,
  EquipmentIds.lamp,
  EquipmentIds.bullseyeLantern,
  EquipmentIds.hoodedLantern,
  EquipmentIds.lock,
  EquipmentIds.magnifyingGlass,
  EquipmentIds.manacles,
  EquipmentIds.messKit,
  EquipmentIds.mirrorSteel,
  EquipmentIds.flaskOfOil,
  EquipmentIds.paper,
  EquipmentIds.parchment,
  EquipmentIds.perfume,
  EquipmentIds.pick,
  EquipmentIds.piton,
  EquipmentIds.basicPoison,
  EquipmentIds.pole,
  EquipmentIds.ironPot,
  EquipmentIds.potionOfHealing,
  EquipmentIds.pouch,
  EquipmentIds.quiver,
  EquipmentIds.portableRam,
  EquipmentIds.rations,
  EquipmentIds.robes,
  EquipmentIds.hempenRope,
  EquipmentIds.silkRope,
  EquipmentIds.sack,
  EquipmentIds.scaleMerchant,
  EquipmentIds.sealingWax,
  EquipmentIds.shovel,
  EquipmentIds.signalWhistle,
  EquipmentIds.signetRing,
  EquipmentIds.soap,
  EquipmentIds.spellbook,
  EquipmentIds.ironSpikes,
  EquipmentIds.spyglass,
  EquipmentIds.tentTwoPerson,
  EquipmentIds.tinderbox,
  EquipmentIds.torch,
  EquipmentIds.vial,
  EquipmentIds.waterskin,
  EquipmentIds.whetstone,
};

const newPhbEquipmentIds = <String>{
  EquipmentIds.abacus,
  EquipmentIds.acidVial,
  EquipmentIds.alchemistsFireFlask,
  EquipmentIds.antitoxinVial,
  EquipmentIds.book,
  EquipmentIds.caltrops,
  EquipmentIds.crossbowBoltCase,
  EquipmentIds.chalk,
  EquipmentIds.sledgehammer,
  EquipmentIds.healersKit,
  EquipmentIds.holyWaterFlask,
  EquipmentIds.basicPoison,
  EquipmentIds.potionOfHealing,
  EquipmentIds.quiver,
  EquipmentIds.spellbook,
  EquipmentIds.ironSpikes,
};

void main() {
  test('PHB adventuring equipment covers all 83 table rows', () {
    expect(phbEquipmentIds.length, 82);

    for (final id in phbEquipmentIds) {
      expect(
        equipmentDefinitions.containsKey(id),
        isTrue,
        reason: 'Oggetto PHB mancante: $id',
      );
    }

    expect(
      focusDefinitions.containsKey(FocusIds.componentPouch),
      isTrue,
    );

    final coveredRows = {
      ...phbEquipmentIds,
      FocusIds.componentPouch,
    };

    expect(coveredRows.length, 83);
  });

  test('equipment registry is internally coherent', () {
    for (final entry in equipmentDefinitions.entries) {
      final equipment = entry.value;

      expect(equipment.id, entry.key);
      expect(equipment.name.trim(), isNotEmpty);
      expect(equipment.weightKg, greaterThanOrEqualTo(0));
      expect(equipment.cost, greaterThanOrEqualTo(0));
      expect(
        {'cp', 'sp', 'ep', 'gp', 'pp'},
        contains(equipment.currency),
      );

      if (equipment.isContainer) {
        expect(equipment.canContainItems, isTrue);
      }

      final useIds = equipment.uses.map((use) => use.id).toList();

      expect(
        useIds.toSet().length,
        useIds.length,
        reason: 'ID utilizzo duplicati in ${entry.key}',
      );

      for (final use in equipment.uses) {
        expect(use.id.trim(), isNotEmpty);
        expect(use.name.trim(), isNotEmpty);

        if (use.damageDice != null) {
          expect(use.damageType, isNotNull);
        }

        if (use.healingDice != null) {
          expect(
            use.type,
            anyOf(
              EquipmentUseType.consume,
              EquipmentUseType.action,
            ),
          );
        }
      }
    }
  });

  test('the 16 newly added PHB objects are complete', () {
    expect(newPhbEquipmentIds.length, 16);

    for (final id in newPhbEquipmentIds) {
      final equipment = equipmentDefinitions[id];

      expect(equipment, isNotNull);
      expect(
        equipment!.description.trim(),
        isNotEmpty,
        reason: 'Descrizione mancante: $id',
      );
      expect(
        equipment.uses.isNotEmpty ||
            equipment.ruleTags.isNotEmpty ||
            equipment.isContainer,
        isTrue,
        reason: 'Meccaniche mancanti: $id',
      );
    }
  });

  test('special consumable mechanics match PHB values', () {
    final acid = equipmentDefinitions[EquipmentIds.acidVial]!;
    final acidUse = acid.uses.single;

    expect(acid.cost, 25);
    expect(acid.weightKg, 0.5);
    expect(acidUse.normalRangeMeters, 6);
    expect(acidUse.damageDice, '2d6');
    expect(acidUse.damageType, 'acid');
    expect(acidUse.consumesItem, isTrue);

    final alchemistsFire =
        equipmentDefinitions[EquipmentIds.alchemistsFireFlask]!;
    final fireUse = alchemistsFire.uses.single;

    expect(alchemistsFire.cost, 50);
    expect(alchemistsFire.weightKg, 0.5);
    expect(fireUse.normalRangeMeters, 6);
    expect(fireUse.damageDice, '1d4');
    expect(fireUse.damageType, 'fire');
    expect(
      fireUse.ruleTags,
      contains('extinguish_requires_dc_10_dexterity_check'),
    );

    final antitoxin = equipmentDefinitions[EquipmentIds.antitoxinVial]!;
    final antitoxinUse = antitoxin.uses.single;

    expect(antitoxin.cost, 50);
    expect(antitoxinUse.consumesItem, isTrue);
    expect(
      antitoxinUse.ruleTags,
      contains(
        'grants_advantage_on_saving_throws_against_poison',
      ),
    );

    final caltrops = equipmentDefinitions[EquipmentIds.caltrops]!;
    final caltropsUse = caltrops.uses.single;

    expect(caltropsUse.savingThrowAbility, 'DES');
    expect(caltropsUse.savingThrowDc, 15);
    expect(caltropsUse.damageDice, '1');
    expect(caltropsUse.damageType, 'piercing');

    final healersKit = equipmentDefinitions[EquipmentIds.healersKit]!;
    final healingUse = healersKit.uses.single;

    expect(healingUse.uses, 10);
    expect(healingUse.usesConsumed, 1);
    expect(
      healingUse.ruleTags,
      contains('medicine_check_not_required'),
    );

    final holyWater = equipmentDefinitions[EquipmentIds.holyWaterFlask]!;
    final holyWaterUse = holyWater.uses.single;

    expect(holyWaterUse.damageDice, '2d6');
    expect(holyWaterUse.damageType, 'radiant');
    expect(
      holyWaterUse.ruleTags,
      contains('target_fiend_or_undead'),
    );

    final poison = equipmentDefinitions[EquipmentIds.basicPoison]!;
    final poisonUse = poison.uses.single;

    expect(poison.cost, 100);
    expect(poisonUse.damageDice, '1d4');
    expect(poisonUse.damageType, 'poison');
    expect(poisonUse.savingThrowAbility, 'COS');
    expect(poisonUse.savingThrowDc, 10);

    final potion = equipmentDefinitions[EquipmentIds.potionOfHealing]!;
    final potionUse = potion.uses.single;

    expect(potion.cost, 50);
    expect(potion.weightKg, 0.25);
    expect(potionUse.healingDice, '2d4');
    expect(potionUse.healingBonus, 2);
    expect(potionUse.consumesItem, isTrue);
  });

  test('PHB ammunition remains complete', () {
    expect(
      {
        EquipmentIds.crossbowBoltCase,
        EquipmentIds.quiver,
      }.every(equipmentDefinitions.containsKey),
      isTrue,
    );

    expect(
      equipmentDefinitions[EquipmentIds.crossbowBoltCase]!.containerCapacity,
      20,
    );
    expect(
      equipmentDefinitions[EquipmentIds.quiver]!.containerCapacity,
      20,
    );
  });
}
