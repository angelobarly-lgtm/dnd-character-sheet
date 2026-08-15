import 'package:dnd_character_sheet/data/bestiary_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const finalIds = {
    BestiaryCreatureIds.flumph,
    BestiaryCreatureIds.imp,
    BestiaryCreatureIds.pseudodragon,
    BestiaryCreatureIds.quasit,
    BestiaryCreatureIds.sprite,
    BestiaryCreatureIds.unicorn,
  };

  test('all six final class-reference creatures are registered', () {
    expect(
      phbBestiaryClassReferenceDefinitions.keys,
      containsAll(finalIds),
    );
    expect(phbBestiaryClassReferenceDefinitions, hasLength(15));
    expect(phbBestiaryDefinitions, hasLength(109));
    expect(unresolvedClassBestiaryCreatureIds, isEmpty);
    expect(
      resolvedBestiaryReferenceIds,
      containsAll(classRequiredBestiaryCreatureIds),
    );
  });

  test('all final creatures retain exact manual provenance', () {
    final expectedPages = {
      BestiaryCreatureIds.flumph: 136,
      BestiaryCreatureIds.imp: 78,
      BestiaryCreatureIds.pseudodragon: 255,
      BestiaryCreatureIds.quasit: 63,
      BestiaryCreatureIds.sprite: 281,
      BestiaryCreatureIds.unicorn: 293,
    };

    for (final entry in expectedPages.entries) {
      final creature = phbBestiaryDefinitions[entry.key]!;
      expect(creature.source.book, 'Manuale dei Mostri');
      expect(creature.source.edition, '2014');
      expect(creature.source.pageStart, entry.value);
      expect(creature.origin, BestiaryContentOrigin.official);
    }

    expect(
      phbBestiaryDefinitions[BestiaryCreatureIds.unicorn]!.source.pageEnd,
      294,
    );
  });

  test('special familiar forms are complete', () {
    final imp = phbBestiaryDefinitions[BestiaryCreatureIds.imp]!;
    final pseudodragon =
        phbBestiaryDefinitions[BestiaryCreatureIds.pseudodragon]!;
    final quasit = phbBestiaryDefinitions[BestiaryCreatureIds.quasit]!;
    final sprite = phbBestiaryDefinitions[BestiaryCreatureIds.sprite]!;

    expect(imp.tags, contains('familiar_option'));
    expect(pseudodragon.tags, contains('familiar_option'));
    expect(quasit.tags, contains('familiar_option'));
    expect(sprite.tags, contains('familiar_option'));

    expect(
      imp.traits.map((trait) => trait.id),
      containsAll({'shapechanger', 'devils_sight', 'magic_resistance'}),
    );
    expect(
      quasit.traits.map((trait) => trait.id),
      containsAll({'shapechanger', 'magic_resistance'}),
    );
    expect(
      pseudodragon.traits.map((trait) => trait.id),
      containsAll({'keen_senses', 'magic_resistance', 'limited_telepathy'}),
    );
    expect(
      sprite.actions.map((action) => action.id),
      containsAll({'longsword', 'shortbow', 'heart_sight', 'invisibility'}),
    );
  });

  test('Flumph preserves its telepathic and stench rules', () {
    final flumph = phbBestiaryDefinitions[BestiaryCreatureIds.flumph]!;

    expect(flumph.type, CreatureType.aberration);
    expect(flumph.damageVulnerabilities, contains('psichico'));
    expect(
      flumph.traits.map((trait) => trait.id),
      containsAll({
        'advanced_telepathy',
        'prone_deficiency',
        'telepathic_shroud',
      }),
    );
    expect(
      flumph.actions.map((action) => action.id),
      containsAll({'tendrils', 'stench_spray'}),
    );
    expect(flumph.actionFor('stench_spray')!.uses, 1);
  });

  test('poison attacks retain saving throws and conditions', () {
    final imp = phbBestiaryDefinitions[BestiaryCreatureIds.imp]!;
    final pseudodragon =
        phbBestiaryDefinitions[BestiaryCreatureIds.pseudodragon]!;
    final quasit = phbBestiaryDefinitions[BestiaryCreatureIds.quasit]!;
    final sprite = phbBestiaryDefinitions[BestiaryCreatureIds.sprite]!;

    expect(imp.actionFor('sting')!.savingThrow!.difficultyClass, 11);
    expect(
      pseudodragon.actionFor('sting')!.effects.single.tags,
      contains('unconscious_on_failure_by_5'),
    );
    expect(
      quasit.actionFor('claws')!.effects.single.tags,
      contains('repeat_save_at_end_of_turn'),
    );
    expect(
      sprite.actionFor('shortbow')!.effects.single.tags,
      contains('unconscious_on_failure_by_5'),
    );
  });

  test('Unicorn has complete spellcasting and legendary structure', () {
    final unicorn = phbBestiaryDefinitions[BestiaryCreatureIds.unicorn]!;

    expect(unicorn.type, CreatureType.celestial);
    expect(unicorn.challengeRating, 5);
    expect(unicorn.experiencePoints, 1800);
    expect(unicorn.proficiencyBonus, 3);
    expect(unicorn.legendaryActionUses, 3);
    expect(unicorn.legendaryActions, hasLength(3));
    expect(
      unicorn.legendaryActions.map((action) => action.legendaryActionCost),
      containsAll({1, 2, 3}),
    );

    final spellcasting = unicorn.spellcasting.single;
    expect(spellcasting.ability, 'CAR');
    expect(spellcasting.spellSaveDifficultyClass, 14);
    expect(
      spellcasting.atWillSpellIds,
      {
        'druidcraft',
        'detect_evil_and_good',
        'pass_without_trace',
      },
    );
    expect(
      spellcasting.limitedUsesBySpellId,
      {
        'calm_emotions': 1,
        'dispel_evil_and_good': 1,
        'entangle': 1,
      },
    );

    expect(unicorn.lair, isNotNull);
    expect(unicorn.lair!.regionalEffects, hasLength(4));
    expect(
      unicorn.actions.map((action) => action.id),
      containsAll({'hooves', 'horn', 'healing_touch', 'teleport'}),
    );
  });

  test('all registered creatures remain structurally valid', () {
    for (final creature in phbBestiaryDefinitions.values) {
      expect(creature.id, isNotEmpty);
      expect(creature.name, isNotEmpty);
      expect(creature.hitPoints.average, greaterThan(0));
      expect(creature.armorClass.value, greaterThan(0));
      expect(creature.unresolvedMultiattackActionIds, isEmpty);
    }
  });
}
