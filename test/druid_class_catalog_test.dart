import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/druid_class_data.dart';
import 'package:dnd_character_sheet/data/equipment_pack_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final druid = phbClassDefinitions[ClassIds.druid]!;

  test('Druid is registered with its PHB identity', () {
    expect(druid, same(druidClassDefinition));
    expect(druid.id, ClassIds.druid);
    expect(druid.name, 'Druido');
    expect(druid.hitDie, 8);
    expect(druid.subclassSelectionLevel, 2);
    expect(druid.homebrew, isFalse);
    expect(
      druid.subclasses.keys,
      contains(DruidSubclassIds.land),
    );
  });

  test('Druid proficiencies match the PHB', () {
    expect(druid.proficiencies.savingThrows, {'INT', 'SAG'});
    expect(
      druid.proficiencies.armor,
      {'light_armor', 'medium_armor', 'shield'},
    );
    expect(
      druid.proficiencies.weapons,
      {
        'club',
        'dagger',
        'dart',
        'javelin',
        'mace',
        'quarterstaff',
        'scimitar',
        'sickle',
        'sling',
        'spear',
      },
    );
    expect(druid.proficiencies.tools, {ToolIds.herbalismKit});
    expect(druid.proficiencies.skillChoices, 2);
    expect(druid.proficiencies.skillOptions, hasLength(8));
  });

  test('starting equipment is complete and catalog-backed', () {
    expect(druid.startingEquipmentChoices, hasLength(3));

    final choices = {
      for (final choice in druid.startingEquipmentChoices) choice.id: choice,
    };

    expect(choices.keys, {
      'druid_shield_or_simple_weapon',
      'druid_scimitar_or_simple_melee_weapon',
      'druidic_focus',
    });

    final shieldChoice = choices['druid_shield_or_simple_weapon']!;
    expect(
      shieldChoice.alternatives.expand((alternative) => alternative.grants).any(
            (grant) =>
                grant.catalogId == 'armor' && grant.itemId == ArmorIds.shield,
          ),
      isTrue,
    );

    final meleeChoice = choices['druid_scimitar_or_simple_melee_weapon']!;
    expect(
      meleeChoice.alternatives.expand((alternative) => alternative.grants).any(
            (grant) =>
                grant.catalogId == 'weapon' && grant.itemId == 'scimitar',
          ),
      isTrue,
    );

    expect(
      choices['druidic_focus']!.alternatives,
      hasLength(4),
    );

    expect(
      druid.fixedStartingEquipment
          .map((grant) => '${grant.catalogId}:${grant.itemId}')
          .toSet(),
      {
        'armor:${ArmorIds.leather}',
        'equipment_pack:${EquipmentPackIds.explorer}',
      },
    );
  });

  test('Druidic language and nonmetal restriction are structured', () {
    expect(
      druid.featureDefinitions['druidic']!.effects.languages,
      {'druidic'},
    );
    expect(
      druid.featureDefinitions['druidic_armor_restriction']!.ruleTags,
      containsAll({
        'nonmetal_armor',
        'nonmetal_shield',
      }),
    );
  });

  test('Wild Shape resource follows the PHB progression', () {
    final resource = druid.resources.singleWhere((r) => r.id == 'wild_shape');

    expect(resource.name, 'Forma Selvatica');
    expect(resource.minimumLevel, 2);
    expect(resource.recovery, ClassResourceRecovery.shortRest);
    expect(resource.maximumAtLevel(1), 0);
    expect(resource.maximumAtLevel(2), 2);
    expect(resource.maximumAtLevel(19), 2);
    expect(resource.isUnlimitedAtLevel(19), isFalse);
    expect(resource.isUnlimitedAtLevel(20), isTrue);
  });

  test('Wild Shape restrictions are machine-readable', () {
    final shape = druid.transformations.single;

    expect(shape.id, 'wild_shape');
    expect(shape.resourceId, 'wild_shape');
    expect(shape.resourceCost, 1);
    expect(shape.action, ClassTransformationAction.action);
    expect(shape.allowedCreatureTypes, {'beast'});

    expect(shape.maximumChallengeRatingAtLevel(1), 0);
    expect(shape.maximumChallengeRatingAtLevel(2), 0.25);
    expect(shape.maximumChallengeRatingAtLevel(4), 0.5);
    expect(shape.maximumChallengeRatingAtLevel(8), 1);
    expect(shape.maximumChallengeRatingAtLevel(20), 1);

    expect(shape.allowsSwimmingSpeedAtLevel(3), isFalse);
    expect(shape.allowsSwimmingSpeedAtLevel(4), isTrue);
    expect(shape.allowsFlyingSpeedAtLevel(7), isFalse);
    expect(shape.allowsFlyingSpeedAtLevel(8), isTrue);

    expect(shape.durationHoursAtLevel(1), 0);
    expect(shape.durationHoursAtLevel(2), 1);
    expect(shape.durationHoursAtLevel(10), 5);
    expect(shape.durationHoursAtLevel(20), 10);

    expect(shape.allowsSpellcastingAtLevel(17), isFalse);
    expect(shape.allowsSpellcastingAtLevel(18), isTrue);
  });

  test('Druid spellcasting uses the canonical 110-spell list', () {
    final magic = druid.spellcasting!;

    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'SAG');
    expect(magic.preparesSpells, isTrue);
    expect(magic.ritualCasting, isTrue);
    expect(magic.spellIds, hasLength(110));
    expect(magic.spellIds.every(spellDefinitions.containsKey), isTrue);

    expect(magic.cantripsKnownAtLevel(1), 2);
    expect(magic.cantripsKnownAtLevel(4), 3);
    expect(magic.cantripsKnownAtLevel(10), 4);
    expect(magic.cantripsKnownAtLevel(20), 4);

    expect(
      magic.preparedSpellsAtLevel(
        5,
        abilityModifiers: {'SAG': 4},
      ),
      9,
    );
    expect(
      magic.preparedSpellsAtLevel(
        1,
        abilityModifiers: {'SAG': -2},
      ),
      1,
    );
  });

  test('Druid base feature progression reaches level 20', () {
    expect(
      druid.featuresAtLevel(1),
      containsAll({
        'druidic',
        'spellcasting',
        'druidic_armor_restriction',
      }),
    );
    expect(druid.featuresAtLevel(2), contains('wild_shape'));
    expect(druid.featuresAtLevel(2), contains('druid_circle'));
    expect(
      druid.featuresAtLevel(18),
      containsAll({'timeless_body', 'beast_spells'}),
    );
    expect(druid.featuresAtLevel(20), ['archdruid']);

    final granted = druid.featuresByLevel.values.expand((ids) => ids).toSet();

    expect(granted, druid.featureDefinitions.keys.toSet());

    for (final entry in druid.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.druid);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });
}
