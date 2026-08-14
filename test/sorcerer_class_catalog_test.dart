import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/sorcerer_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sorcerer = phbClassDefinitions[ClassIds.sorcerer]!;

  test('Sorcerer identity and source match the PHB 2014', () {
    expect(sorcerer.id, ClassIds.sorcerer);
    expect(sorcerer.name, 'Stregone');
    expect(sorcerer.hitDie, 6);
    expect(sorcerer.subclassSelectionLevel, 1);
    expect(sorcerer.homebrew, isFalse);
    expect(sorcerer.content.source.name, 'Manuale del Giocatore 2014');
    expect(sorcerer.content.source.reference, 'pp. 107-110');
  });

  test('Sorcerer proficiencies match the manual', () {
    expect(sorcerer.proficiencies.armor, isEmpty);
    expect(
      sorcerer.proficiencies.weapons,
      {'light_crossbow', 'quarterstaff', 'dart', 'sling', 'dagger'},
    );
    expect(sorcerer.proficiencies.savingThrows, {'COS', 'CAR'});
    expect(sorcerer.proficiencies.skillChoices, 2);
    expect(sorcerer.proficiencies.skillOptions, hasLength(6));
    expect(sorcerer.proficiencies.choices.single.selections, 2);
  });

  test('Sorcerer starting equipment contains every manual alternative', () {
    expect(sorcerer.startingEquipmentChoices, hasLength(3));
    expect(
      sorcerer.startingEquipmentChoices.map((choice) => choice.id).toSet(),
      {
        'sorcerer_weapon',
        'sorcerer_spellcasting_focus',
        'sorcerer_starting_pack',
      },
    );

    final weapon = sorcerer.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'sorcerer_weapon',
    );
    final crossbow = weapon.alternatives.singleWhere(
      (alternative) => alternative.id == 'sorcerer_light_crossbow',
    );
    expect(
      crossbow.grants
          .map(
              (grant) => '${grant.catalogId}:${grant.itemId}:${grant.quantity}')
          .toSet(),
      {'weapon:light_crossbow:1', 'ammunition:crossbow_bolts:20'},
    );

    final focus = sorcerer.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'sorcerer_spellcasting_focus',
    );
    expect(focus.alternatives, hasLength(2));
    expect(
      focus.alternatives
          .singleWhere(
            (alternative) => alternative.id == 'sorcerer_arcane_focus',
          )
          .itemChoices
          .single
          .optionIds,
      hasLength(5),
    );

    expect(sorcerer.fixedStartingEquipment.single.itemId, 'dagger');
    expect(sorcerer.fixedStartingEquipment.single.quantity, 2);
  });

  test('Sorcerer base progression contains every class milestone', () {
    expect(
      sorcerer.featuresByLevel.keys.toSet(),
      {1, 2, 3, 4, 8, 10, 12, 16, 17, 19, 20},
    );
    expect(
      sorcerer.featuresAtLevel(1),
      [SorcererFeatureIds.spellcasting, SorcererFeatureIds.sorcerousOrigin],
    );
    expect(
      sorcerer.featuresAtLevel(20),
      [SorcererFeatureIds.sorcerousRestoration],
    );

    final granted =
        sorcerer.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(8));
    expect(granted, sorcerer.featureDefinitions.keys.toSet());
    for (final entry in sorcerer.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.sorcerer);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Sorcerer uses all 129 canonical spells', () {
    expect(phbSorcererSpellIds, hasLength(129));
    expect(
        phbSorcererSpellIds.difference(spellDefinitions.keys.toSet()), isEmpty);
    final canonical = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.sorcerer))
        .map((spell) => spell.id)
        .toSet();
    expect(phbSorcererSpellIds, canonical);
  });

  test('Sorcerer spellcasting follows the complete full-caster table', () {
    final magic = sorcerer.spellcasting!;
    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'CAR');
    expect(magic.minimumLevel, 1);
    expect(magic.ritualCasting, isFalse);
    expect(magic.preparesSpells, isFalse);
    expect(magic.cantripsKnownAtLevel(1), 4);
    expect(magic.cantripsKnownAtLevel(4), 5);
    expect(magic.cantripsKnownAtLevel(10), 6);
    expect(magic.spellsKnownAtLevel(1), 2);
    expect(magic.spellsKnownAtLevel(11), 12);
    expect(magic.spellsKnownAtLevel(20), 15);
    expect(magic.slotsAtLevel(1), [2, 0, 0, 0, 0, 0, 0, 0, 0]);
    expect(magic.slotsAtLevel(10), [4, 3, 3, 3, 2, 0, 0, 0, 0]);
    expect(magic.slotsAtLevel(17), [4, 3, 3, 3, 2, 1, 1, 1, 1]);
    expect(magic.slotsAtLevel(20), [4, 3, 3, 3, 3, 2, 2, 1, 1]);
  });

  test('Sorcery Points scale exactly with Sorcerer level', () {
    final points = sorcerer.resources.single;
    expect(points.id, SorcererResourceIds.sorceryPoints);
    expect(points.name, 'Punti Stregoneria');
    expect(points.minimumLevel, 2);
    expect(points.recovery, ClassResourceRecovery.longRest);
    expect(points.maximumAtLevel(1), 0);
    expect(points.maximumAtLevel(2), 2);
    expect(points.maximumAtLevel(10), 10);
    expect(points.maximumAtLevel(20), 20);
  });

  test('Flexible Casting implements every manual conversion rate', () {
    final conversion = sorcerer.resourceConversions.single;
    expect(conversion, same(sorcererFlexibleCastingDefinition));
    expect(conversion.activation, ClassFeatureActivation.bonusAction);
    expect(conversion.resourceCostBySpellSlotLevel,
        {1: 2, 2: 3, 3: 5, 4: 6, 5: 7});
    expect(conversion.maximumCreatedSpellSlotLevel, 5);
    expect(conversion.createdSpellSlotsExpireOnLongRest, isTrue);
    expect(conversion.resourceGainedForExpendedSpellSlotLevel(5), 5);
  });

  test('all eight PHB Metamagic options are structured', () {
    expect(phbSorcererMetamagicDefinitions, hasLength(8));
    expect(phbSorcererMetamagicOptions, hasLength(8));
    expect(
      phbSorcererMetamagicDefinitions.keys.toSet(),
      {
        SorcererMetamagicIds.carefulSpell,
        SorcererMetamagicIds.distantSpell,
        SorcererMetamagicIds.empoweredSpell,
        SorcererMetamagicIds.extendedSpell,
        SorcererMetamagicIds.heightenedSpell,
        SorcererMetamagicIds.quickenedSpell,
        SorcererMetamagicIds.subtleSpell,
        SorcererMetamagicIds.twinnedSpell,
      },
    );
    expect(sorcerer.resourceUsages, hasLength(8));
    expect(
      phbSorcererMetamagicDefinitions.values.every(
          (usage) => usage.resourceId == SorcererResourceIds.sorceryPoints),
      isTrue,
    );

    final empowered =
        phbSorcererMetamagicDefinitions[SorcererMetamagicIds.empoweredSpell]!;
    expect(empowered.combinableWithOtherUsages, isTrue);
    final twinned =
        phbSorcererMetamagicDefinitions[SorcererMetamagicIds.twinnedSpell]!;
    expect(twinned.resourceCostForSpellLevel(0), 1);
    expect(twinned.resourceCostForSpellLevel(5), 5);
  });

  test('Metamagic choices grant two plus one plus one unique options', () {
    final first = sorcerer.featureDefinitions[SorcererFeatureIds.metamagic]!;
    final tenth =
        sorcerer.featureDefinitions[SorcererFeatureIds.metamagicImprovement10]!;
    final seventeenth =
        sorcerer.featureDefinitions[SorcererFeatureIds.metamagicImprovement17]!;
    expect(first.choices.single.minimumSelections, 2);
    expect(first.choices.single.maximumSelections, 2);
    expect(tenth.choices.single.maximumSelections, 1);
    expect(seventeenth.choices.single.maximumSelections, 1);
    for (final feature in [first, tenth, seventeenth]) {
      expect(feature.choices.single.options, hasLength(8));
      expect(feature.choices.single.unique, isTrue);
      expect(feature.choices.single.requireNewAcquisition, isTrue);
    }
  });

  test('Sorcerous Restoration recovers exactly four points on short rest', () {
    final feature =
        sorcerer.featureDefinitions[SorcererFeatureIds.sorcerousRestoration]!;
    final effect = feature.effects.ruleEffects.single;
    expect(effect.target, SorcererResourceIds.sorceryPoints);
    expect(effect.value, 4);
    expect(effect.condition, 'recover_on_short_rest');
  });

  test('Sorcerer is registered incrementally and reserves both origins', () {
    expect(phbClassDefinitions.keys, contains(ClassIds.sorcerer));
    expect(phbClassDefinitionFor(ClassIds.sorcerer), same(sorcerer));
    expect(
      phbSorcererSubclassIds,
      {SorcererSubclassIds.draconicBloodline, SorcererSubclassIds.wildMagic},
    );
    expect(
      sorcerer.subclasses.keys.toSet().difference(phbSorcererSubclassIds),
      isEmpty,
    );
  });
}
