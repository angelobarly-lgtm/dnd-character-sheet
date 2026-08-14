import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/fighting_style_data.dart';
import 'package:dnd_character_sheet/data/ranger_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ranger = phbClassDefinitions[ClassIds.ranger]!;

  test('Ranger identity and source match the PHB 2014', () {
    expect(ranger.id, ClassIds.ranger);
    expect(ranger.name, 'Ranger');
    expect(ranger.hitDie, 10);
    expect(ranger.subclassSelectionLevel, 3);
    expect(ranger.homebrew, isFalse);
    expect(ranger.content.source.name, 'Manuale del Giocatore 2014');
    expect(ranger.content.source.reference, 'pp. 102-105');
  });

  test('Ranger proficiencies match the PHB', () {
    expect(
      ranger.proficiencies.armor,
      {'light_armor', 'medium_armor', 'shield'},
    );
    expect(
      ranger.proficiencies.weapons,
      {'simple_weapons', 'martial_weapons'},
    );
    expect(ranger.proficiencies.savingThrows, {'FOR', 'DES'});
    expect(ranger.proficiencies.skillChoices, 3);
    expect(
      ranger.proficiencies.skillOptions,
      {
        'animal_handling',
        'athletics',
        'stealth',
        'investigation',
        'insight',
        'nature',
        'perception',
        'survival',
      },
    );
    expect(ranger.proficiencies.choices.single.selections, 3);
  });

  test('Ranger starting equipment implements every PHB alternative', () {
    expect(ranger.startingEquipmentChoices, hasLength(3));

    final armor = ranger.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'ranger_starting_armor',
    );
    expect(
      armor.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      {'scale_mail', 'leather'},
    );

    final weapons = ranger.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'ranger_melee_weapons',
    );
    final shortswords = weapons.alternatives.singleWhere(
      (alternative) => alternative.id == 'ranger_two_shortswords',
    );
    expect(shortswords.grants.single.itemId, 'shortsword');
    expect(shortswords.grants.single.quantity, 2);

    final simpleWeapons = weapons.alternatives.singleWhere(
      (alternative) => alternative.id == 'ranger_two_simple_melee_weapons',
    );
    expect(simpleWeapons.itemChoices.single.selections, 2);
    expect(simpleWeapons.itemChoices.single.allowDuplicates, isTrue);
    expect(simpleWeapons.itemChoices.single.optionIds, hasLength(10));

    final packs = ranger.startingEquipmentChoices.singleWhere(
      (choice) => choice.id == 'ranger_starting_pack',
    );
    expect(
      packs.alternatives
          .expand((alternative) => alternative.grants)
          .map((grant) => grant.itemId)
          .toSet(),
      {'dungeoneer_pack', 'explorer_pack'},
    );

    expect(
      ranger.fixedStartingEquipment
          .map(
              (grant) => '${grant.catalogId}:${grant.itemId}:${grant.quantity}')
          .toSet(),
      {'weapon:longbow:1', 'ammunition:arrows:20'},
    );
  });

  test('Ranger base progression contains every PHB milestone', () {
    expect(
      ranger.featuresByLevel.keys.toSet(),
      {1, 2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 18, 19, 20},
    );
    expect(
      ranger.featuresAtLevel(1),
      [RangerFeatureIds.favoredEnemy, RangerFeatureIds.naturalExplorer],
    );
    expect(
      ranger.featuresAtLevel(6),
      [
        RangerFeatureIds.favoredEnemyImprovement6,
        RangerFeatureIds.naturalExplorerImprovement6,
      ],
    );
    expect(ranger.featuresAtLevel(18), [RangerFeatureIds.feralSenses]);
    expect(ranger.featuresAtLevel(20), [RangerFeatureIds.foeSlayer]);

    final granted =
        ranger.featuresByLevel.values.expand((features) => features).toSet();
    expect(granted, hasLength(17));
    expect(
      granted.difference(ranger.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in ranger.featureDefinitions.entries) {
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.ranger);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });

  test('Favored Enemy and Natural Explorer choices are complete', () {
    expect(phbRangerFavoredEnemyOptions, hasLength(14));
    expect(
      phbRangerFavoredEnemyOptions.map((option) => option.id).toSet(),
      containsAll({
        'aberration',
        'beast',
        'celestial',
        'construct',
        'dragon',
        'elemental',
        'fey',
        'giant',
        'fiend',
        'ooze',
        'monstrosity',
        'undead',
        'plant',
        'two_humanoid_races',
      }),
    );
    expect(phbRangerTerrainOptions, hasLength(8));

    final firstEnemy =
        ranger.featureDefinitions[RangerFeatureIds.favoredEnemy]!;
    expect(firstEnemy.choices, hasLength(3));
    expect(
      firstEnemy.content.description.details,
      allOf(contains('due razze di umanoidi'), contains('linguaggio')),
    );

    final terrain =
        ranger.featureDefinitions[RangerFeatureIds.naturalExplorer]!;
    expect(terrain.choices.single.options, hasLength(8));
    expect(
      terrain.content.description.details,
      allOf(
        contains('almeno un’ora'),
        contains('doppio del cibo'),
        contains('numero esatto'),
      ),
    );
  });

  test('Ranger exposes exactly the four PHB fighting styles', () {
    expect(
      phbRangerFightingStyleIds,
      {'archery', 'defense', 'dueling', 'two_weapon_fighting'},
    );
    expect(
      phbRangerFightingStyleIds.difference(
        fightingStyleDefinitions.keys.toSet(),
      ),
      isEmpty,
    );
    final feature = ranger.featureDefinitions[RangerFeatureIds.fightingStyle]!;
    expect(feature.choices.single.options, hasLength(4));
  });

  test('Ranger uses the complete PHB spell catalog', () {
    expect(phbRangerSpellIds, hasLength(46));
    expect(
        phbRangerSpellIds.difference(spellDefinitions.keys.toSet()), isEmpty);

    final canonical = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.ranger))
        .map((spell) => spell.id)
        .toSet();
    expect(phbRangerSpellIds, canonical);
  });

  test('Ranger spellcasting follows the PHB half-caster table', () {
    final magic = ranger.spellcasting!;
    expect(magic.progression, ClassSpellcastingProgression.half);
    expect(magic.ability, 'SAG');
    expect(magic.minimumLevel, 2);
    expect(magic.ritualCasting, isFalse);
    expect(magic.preparesSpells, isFalse);
    expect(magic.cantripsKnownAtLevel(20), 0);
    expect(magic.spellsKnownAtLevel(1), 0);
    expect(magic.spellsKnownAtLevel(2), 2);
    expect(magic.spellsKnownAtLevel(3), 3);
    expect(magic.spellsKnownAtLevel(10), 6);
    expect(magic.spellsKnownAtLevel(20), 11);
    expect(magic.slotsAtLevel(1), [0, 0, 0, 0, 0]);
    expect(magic.slotsAtLevel(2), [2, 0, 0, 0, 0]);
    expect(magic.slotsAtLevel(9), [4, 3, 2, 0, 0]);
    expect(magic.slotsAtLevel(17), [4, 3, 3, 3, 1]);
    expect(magic.slotsAtLevel(20), [4, 3, 3, 3, 2]);
  });

  test('complex Ranger base rules retain every limiting clause', () {
    final awareness =
        ranger.featureDefinitions[RangerFeatureIds.primevalAwareness]!;
    expect(
      awareness.content.description.details,
      allOf(
        contains('1 minuto per livello'),
        contains('1,5 km'),
        contains('9 km'),
        contains('né il numero né l’ubicazione'),
      ),
    );

    final camouflage =
        ranger.featureDefinitions[RangerFeatureIds.hideInPlainSight]!;
    final camouflageEffect = camouflage.effects.ruleEffects.single;
    expect(camouflageEffect.value, 10);
    expect(camouflageEffect.condition, contains('movement_action_or_reaction'));

    final senses = ranger.featureDefinitions[RangerFeatureIds.feralSenses]!;
    expect(senses.effects.ruleEffects, hasLength(2));
    expect(
      senses.content.description.details,
      allOf(contains('non sia nascosta'), contains('accecato o assordato')),
    );

    final slayer = ranger.featureDefinitions[RangerFeatureIds.foeSlayer]!;
    expect(
      slayer.content.description.details,
      allOf(
        contains('una volta per turno'),
        contains('Nemico Prescelto'),
        contains('prima che gli effetti'),
      ),
    );
  });

  test('Ranger is registered incrementally and reserves PHB archetype IDs', () {
    expect(phbClassDefinitions.keys, contains(ClassIds.ranger));
    expect(phbClassDefinitionFor(ClassIds.ranger), same(ranger));
    expect(phbRangerSubclassIds,
        {RangerSubclassIds.hunter, RangerSubclassIds.beastMaster});
    expect(
      ranger.subclasses.keys.toSet().difference(phbRangerSubclassIds),
      isEmpty,
    );
  });
}
