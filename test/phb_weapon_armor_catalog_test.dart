import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:dnd_character_sheet/data/weapon_property_data.dart';
import 'package:flutter_test/flutter_test.dart';

const expectedWeaponSnapshots = <String>{
  'club|simple|melee|1d4||bludgeoning|||2|1|sp|light',
  'dagger|simple|melee|1d4||piercing|20|60|1|2|gp|finesse,light,thrown',
  'greatclub|simple|melee|1d8||bludgeoning|||10|2|sp|two_handed',
  'handaxe|simple|melee|1d6||slashing|20|60|2|5|gp|light,thrown',
  'javelin|simple|melee|1d6||piercing|30|120|2|5|sp|thrown',
  'light_hammer|simple|melee|1d4||bludgeoning|20|60|2|2|gp|light,thrown',
  'mace|simple|melee|1d6||bludgeoning|||4|5|gp|',
  'quarterstaff|simple|melee|1d6|1d8|bludgeoning|||4|2|sp|versatile',
  'sickle|simple|melee|1d4||slashing|||2|1|gp|light',
  'spear|simple|melee|1d6|1d8|piercing|20|60|3|1|gp|thrown,versatile',
  'light_crossbow|simple|ranged|1d8||piercing|80|320|5|25|gp|ammunition,loading,two_handed',
  'dart|simple|ranged|1d4||piercing|20|60|0.25|5|cp|finesse,thrown',
  'shortbow|simple|ranged|1d6||piercing|80|320|2|25|gp|ammunition,two_handed',
  'sling|simple|ranged|1d4||bludgeoning|30|120|0|1|sp|ammunition',
  'battleaxe|martial|melee|1d8|1d10|slashing|||4|10|gp|versatile',
  'flail|martial|melee|1d8||bludgeoning|||2|10|gp|',
  'glaive|martial|melee|1d10||slashing|||6|20|gp|heavy,reach,two_handed',
  'greataxe|martial|melee|1d12||slashing|||7|30|gp|heavy,two_handed',
  'greatsword|martial|melee|2d6||slashing|||6|50|gp|heavy,two_handed',
  'halberd|martial|melee|1d10||slashing|||6|20|gp|heavy,reach,two_handed',
  'lance|martial|melee|1d12||piercing|||6|10|gp|reach,special',
  'longsword|martial|melee|1d8|1d10|slashing|||3|15|gp|versatile',
  'maul|martial|melee|2d6||bludgeoning|||10|10|gp|heavy,two_handed',
  'morningstar|martial|melee|1d8||piercing|||4|15|gp|',
  'pike|martial|melee|1d10||piercing|||18|5|gp|heavy,reach,two_handed',
  'rapier|martial|melee|1d8||piercing|||2|25|gp|finesse',
  'scimitar|martial|melee|1d6||slashing|||3|25|gp|finesse,light',
  'shortsword|martial|melee|1d6||piercing|||2|10|gp|finesse,light',
  'trident|martial|melee|1d6|1d8|piercing|20|60|4|5|gp|thrown,versatile',
  'war_pick|martial|melee|1d8||piercing|||2|5|gp|',
  'warhammer|martial|melee|1d8|1d10|bludgeoning|||2|15|gp|versatile',
  'whip|martial|melee|1d4||slashing|||3|2|gp|finesse,reach',
  'blowgun|martial|ranged|1||piercing|25|100|1|10|gp|ammunition,loading',
  'hand_crossbow|martial|ranged|1d6||piercing|30|120|3|75|gp|ammunition,light,loading',
  'heavy_crossbow|martial|ranged|1d10||piercing|100|400|18|50|gp|ammunition,heavy,loading,two_handed',
  'longbow|martial|ranged|1d8||piercing|150|600|2|50|gp|ammunition,heavy,two_handed',
  'net|martial|ranged|0||bludgeoning|5|15|3|1|gp|special,thrown',
};

const expectedArmorSnapshots = <String>{
  'padded|light|11|true||0|true|8|5|gp',
  'leather|light|11|true||0|false|10|10|gp',
  'studded_leather|light|12|true||0|false|13|45|gp',
  'hide|medium|12|true|2|0|false|12|10|gp',
  'chain_shirt|medium|13|true|2|0|false|20|50|gp',
  'scale_mail|medium|14|true|2|0|true|45|50|gp',
  'breastplate|medium|14|true|2|0|false|20|400|gp',
  'half_plate|medium|15|true|2|0|true|40|750|gp',
  'ring_mail|heavy|14|false||0|true|40|30|gp',
  'chain_mail|heavy|16|false||13|true|55|75|gp',
  'splint|heavy|17|false||15|true|60|200|gp',
  'plate|heavy|18|false||15|true|65|1500|gp',
  'shield|shield|2|false||0|false|6|10|gp',
};

String formatNumber(num value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toString();
}

String weaponSnapshot(WeaponDefinition weapon) {
  final properties = [...weapon.properties]..sort();

  return [
    weapon.id,
    weapon.category.name,
    weapon.kind.name,
    weapon.damageDice,
    weapon.versatileDamage ?? '',
    weapon.damageType,
    weapon.normalRange?.toString() ?? '',
    weapon.longRange?.toString() ?? '',
    formatNumber(weapon.weight),
    weapon.cost.toString(),
    weapon.currency,
    properties.join(','),
  ].join('|');
}

String armorSnapshot(ArmorDefinition armor) {
  return [
    armor.id,
    armor.category.name,
    armor.armorClass.toString(),
    armor.addDexterity.toString(),
    armor.maxDexterityBonus?.toString() ?? '',
    armor.strengthRequirement.toString(),
    armor.stealthDisadvantage.toString(),
    formatNumber(armor.weight),
    armor.cost.toString(),
    armor.currency,
  ].join('|');
}

void main() {
  test('PHB weapon catalog matches all 37 verified entries', () {
    expect(weaponDefinitions.length, 37);

    for (final entry in weaponDefinitions.entries) {
      expect(
        entry.value.id,
        entry.key,
        reason: 'Chiave e ID arma differenti: ${entry.key}',
      );
      expect(entry.value.name.trim(), isNotEmpty);
      expect(
        entry.value.properties.toSet().length,
        entry.value.properties.length,
        reason: 'Proprietà duplicate: ${entry.key}',
      );

      for (final propertyId in entry.value.properties) {
        expect(
          weaponPropertyDefinitions.containsKey(propertyId),
          isTrue,
          reason: 'Proprietà sconosciuta $propertyId in ${entry.key}',
        );
      }
    }

    expect(
      weaponDefinitions.values.map(weaponSnapshot).toSet(),
      expectedWeaponSnapshots,
    );
  });

  test('PHB armor and shield catalog matches all 13 entries', () {
    expect(armorDefinitions.length, 13);

    for (final entry in armorDefinitions.entries) {
      expect(
        entry.value.id,
        entry.key,
        reason: 'Chiave e ID armatura differenti: ${entry.key}',
      );
      expect(entry.value.name.trim(), isNotEmpty);
    }

    expect(
      armorDefinitions.values.map(armorSnapshot).toSet(),
      expectedArmorSnapshots,
    );
  });

  test('weapon property catalog is internally coherent', () {
    expect(weaponPropertyDefinitions.length, 11);

    for (final entry in weaponPropertyDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.name.trim(), isNotEmpty);
      expect(entry.value.description.trim(), isNotEmpty);
    }

    final usedProperties =
        weaponDefinitions.values.expand((weapon) => weapon.properties).toSet();

    expect(
      weaponPropertyDefinitions.keys.toSet().containsAll(
            usedProperties,
          ),
      isTrue,
    );

    expect(
      weaponPropertyDefinitions.keys.toSet().difference(usedProperties),
      {
        WeaponPropertyIds.range,
      },
    );
  });
}
