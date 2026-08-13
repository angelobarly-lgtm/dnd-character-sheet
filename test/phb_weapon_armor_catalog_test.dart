import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:dnd_character_sheet/data/weapon_property_data.dart';
import 'package:flutter_test/flutter_test.dart';

const expectedWeaponSnapshots = <String>{
  'club|simple|melee|1d4||bludgeoning|||1|1|sp|light',
  'dagger|simple|melee|1d4||piercing|6|18|0.5|2|gp|finesse,light,thrown',
  'greatclub|simple|melee|1d8||bludgeoning|||5|2|sp|two_handed',
  'handaxe|simple|melee|1d6||slashing|6|18|1|5|gp|light,thrown',
  'javelin|simple|melee|1d6||piercing|9|36|1|5|sp|thrown',
  'light_hammer|simple|melee|1d4||bludgeoning|6|18|1|2|gp|light,thrown',
  'mace|simple|melee|1d6||bludgeoning|||2|5|gp|',
  'quarterstaff|simple|melee|1d6|1d8|bludgeoning|||2|2|sp|versatile',
  'sickle|simple|melee|1d4||slashing|||1|1|gp|light',
  'spear|simple|melee|1d6|1d8|piercing|6|18|1.5|1|gp|thrown,versatile',
  'light_crossbow|simple|ranged|1d8||piercing|24|96|2.5|25|gp|ammunition,loading,two_handed',
  'dart|simple|ranged|1d4||piercing|6|18|0.125|5|cp|finesse,thrown',
  'shortbow|simple|ranged|1d6||piercing|24|96|1|25|gp|ammunition,two_handed',
  'sling|simple|ranged|1d4||bludgeoning|9|36|0|1|sp|ammunition',
  'battleaxe|martial|melee|1d8|1d10|slashing|||2|10|gp|versatile',
  'flail|martial|melee|1d8||bludgeoning|||1|10|gp|',
  'glaive|martial|melee|1d10||slashing|||3|20|gp|heavy,reach,two_handed',
  'greataxe|martial|melee|1d12||slashing|||3.5|30|gp|heavy,two_handed',
  'greatsword|martial|melee|2d6||slashing|||3|50|gp|heavy,two_handed',
  'halberd|martial|melee|1d10||slashing|||3|20|gp|heavy,reach,two_handed',
  'lance|martial|melee|1d12||piercing|||3|10|gp|reach,special',
  'longsword|martial|melee|1d8|1d10|slashing|||1.5|15|gp|versatile',
  'maul|martial|melee|2d6||bludgeoning|||5|10|gp|heavy,two_handed',
  'morningstar|martial|melee|1d8||piercing|||2|15|gp|',
  'pike|martial|melee|1d10||piercing|||9|5|gp|heavy,reach,two_handed',
  'rapier|martial|melee|1d8||piercing|||1|25|gp|finesse',
  'scimitar|martial|melee|1d6||slashing|||1.5|25|gp|finesse,light',
  'shortsword|martial|melee|1d6||piercing|||1|10|gp|finesse,light',
  'trident|martial|melee|1d6|1d8|piercing|6|18|2|5|gp|thrown,versatile',
  'war_pick|martial|melee|1d8||piercing|||1|5|gp|',
  'warhammer|martial|melee|1d8|1d10|bludgeoning|||1|15|gp|versatile',
  'whip|martial|melee|1d4||slashing|||1.5|2|gp|finesse,reach',
  'blowgun|martial|ranged|1||piercing|7.5|30|0.5|10|gp|ammunition,loading',
  'hand_crossbow|martial|ranged|1d6||piercing|9|36|1.5|75|gp|ammunition,light,loading',
  'heavy_crossbow|martial|ranged|1d10||piercing|30|120|9|50|gp|ammunition,heavy,loading,two_handed',
  'longbow|martial|ranged|1d8||piercing|45|180|1|50|gp|ammunition,heavy,two_handed',
  'net|martial|ranged|0||bludgeoning|1.5|4.5|1.5|1|gp|special,thrown',
};

const expectedArmorSnapshots = <String>{
  'padded|light|11|true||0|true|4|5|gp',
  'leather|light|11|true||0|false|5|10|gp',
  'studded_leather|light|12|true||0|false|6.5|45|gp',
  'hide|medium|12|true|2|0|false|6|10|gp',
  'chain_shirt|medium|13|true|2|0|false|10|50|gp',
  'scale_mail|medium|14|true|2|0|true|22.5|50|gp',
  'breastplate|medium|14|true|2|0|false|10|400|gp',
  'half_plate|medium|15|true|2|0|true|20|750|gp',
  'ring_mail|heavy|14|false||0|true|20|30|gp',
  'chain_mail|heavy|16|false||13|true|27.5|75|gp',
  'splint|heavy|17|false||15|true|30|200|gp',
  'plate|heavy|18|false||15|true|32.5|1500|gp',
  'shield|shield|2|false||0|false|3|10|gp',
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
    weapon.normalRangeMeters == null
        ? ''
        : formatNumber(weapon.normalRangeMeters!),
    weapon.longRangeMeters == null ? '' : formatNumber(weapon.longRangeMeters!),
    formatNumber(weapon.weightKg),
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
    formatNumber(armor.weightKg),
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
