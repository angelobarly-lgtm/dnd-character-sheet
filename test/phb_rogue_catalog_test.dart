import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/rogue_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/tool_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rogue = phbClassDefinitions[ClassIds.rogue]!;
  final thief = rogue.subclasses[RogueSubclassIds.thief]!;
  final assassin = rogue.subclasses[RogueSubclassIds.assassin]!;
  final arcaneTrickster = rogue.subclasses[RogueSubclassIds.arcaneTrickster]!;

  test('universal registry contains Rogue and all completed classes', () {
    expect(
      phbClassDefinitions.keys,
      containsAll({
        ClassIds.barbarian,
        ClassIds.bard,
        ClassIds.cleric,
        ClassIds.druid,
        ClassIds.fighter,
        ClassIds.monk,
        ClassIds.rogue,
      }),
    );

    expect(phbClassDefinitionFor(ClassIds.rogue), same(rogue));
  });

  test('Rogue has the canonical PHB class identity', () {
    expect(rogue.id, ClassIds.rogue);
    expect(rogue.name, 'Ladro');
    expect(rogue.hitDie, 8);
    expect(rogue.homebrew, isFalse);
    expect(rogue.content.ownerId, ClassIds.rogue);
    expect(rogue.content.source.isEmpty, isFalse);
    expect(rogue.subclassSelectionLevel, 3);

    expect(
      rogue.proficiencies.savingThrows,
      {
        'DES',
        'INT',
      },
    );
    expect(rogue.proficiencies.skillChoices, 4);
    expect(rogue.proficiencies.tools, contains(ToolIds.thievesTools));
  });

  test('Rogue base progression grants only class-level features', () {
    expect(
      rogue.featuresByLevel,
      {
        1: [
          RogueFeatureIds.expertise,
          RogueFeatureIds.sneakAttack,
          RogueFeatureIds.thievesCant,
        ],
        2: [
          RogueFeatureIds.cunningAction,
        ],
        3: [
          RogueFeatureIds.roguishArchetype,
        ],
        4: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        5: [
          RogueFeatureIds.uncannyDodge,
        ],
        6: [
          RogueFeatureIds.expertiseImprovement,
        ],
        7: [
          RogueFeatureIds.evasion,
        ],
        8: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        10: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        11: [
          RogueFeatureIds.reliableTalent,
        ],
        12: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        14: [
          RogueFeatureIds.blindsense,
        ],
        15: [
          RogueFeatureIds.slipperyMind,
        ],
        16: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        18: [
          RogueFeatureIds.elusive,
        ],
        19: [
          RogueFeatureIds.abilityScoreImprovement,
        ],
        20: [
          RogueFeatureIds.strokeOfLuck,
        ],
      },
    );

    final granted =
        rogue.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(rogue.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    expect(rogue.featuresAtLevel(9), isEmpty);
    expect(rogue.featuresAtLevel(13), isEmpty);
    expect(rogue.featuresAtLevel(17), isEmpty);
  });

  test('Sneak Attack reaches 10d6 across all twenty levels', () {
    for (var level = 1; level <= 20; level++) {
      final expectedDice = (level + 1) ~/ 2;

      expect(
        rogue.progressionValue(
          RogueProgressionIds.sneakAttackDice,
          level,
        ),
        '${expectedDice}d6',
        reason: 'Attacco Furtivo errato al livello $level',
      );
    }
  });

  test('Expertise grants two valid existing proficiencies twice', () {
    final expertise = rogue.featureDefinitions[RogueFeatureIds.expertise]!;
    final improvement =
        rogue.featureDefinitions[RogueFeatureIds.expertiseImprovement]!;

    expect(expertise.choices, hasLength(1));
    expect(improvement.choices, hasLength(1));

    for (final feature in [expertise, improvement]) {
      final choice = feature.choices.single;

      expect(choice.minimumSelections, 2);
      expect(choice.maximumSelections, 2);
      expect(choice.unique, isTrue);
      expect(choice.requireExistingAcquisition, isTrue);
      expect(choice.requireNewAcquisition, isFalse);
      final optionIds = {
        ...choice.optionIds,
        ...choice.options.map((option) => option.id),
      };

      expect(optionIds, hasLength(12));
      expect(optionIds, contains(ToolIds.thievesTools));
    }
  });

  test('Stroke of Luck is a once-per-rest level 20 resource', () {
    final resource = rogue.resources.singleWhere(
      (resource) => resource.id == RogueResourceIds.strokeOfLuck,
    );
    final feature = rogue.featureDefinitions[RogueFeatureIds.strokeOfLuck]!;

    expect(resource.minimumLevel, 20);
    expect(
      resource.recovery,
      ClassResourceRecovery.shortRest,
    );
    expect(resource.maximumAtLevel(19), 0);
    expect(resource.maximumAtLevel(20), 1);
    expect(feature.resourceId, RogueResourceIds.strokeOfLuck);
  });

  test('all three PHB Roguish Archetypes are registered', () {
    expect(
      rogue.subclasses.keys.toSet(),
      {
        RogueSubclassIds.thief,
        RogueSubclassIds.assassin,
        RogueSubclassIds.arcaneTrickster,
      },
    );

    expect(rogue.phbSubclasses, hasLength(3));

    for (final subclass in rogue.subclasses.values) {
      expect(subclass.classId, ClassIds.rogue);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
      expect(subclass.content.ownerId, ClassIds.rogue);
      expect(subclass.content.source.isEmpty, isFalse);
    }
  });

  test('every Rogue archetype uses levels 3 9 13 and 17', () {
    const expectedLevels = {
      3,
      9,
      13,
      17,
    };

    expect(thief.featuresByLevel.keys.toSet(), expectedLevels);
    expect(assassin.featuresByLevel.keys.toSet(), expectedLevels);
    expect(
      arcaneTrickster.featuresByLevel.keys.toSet(),
      expectedLevels,
    );
  });

  test('every granted subclass feature has one registered definition', () {
    final allFeatureIds = <String>{};

    for (final subclass in rogue.subclasses.values) {
      final granted = subclass.featuresByLevel.values
          .expand((features) => features)
          .toList();

      expect(
        granted.toSet(),
        subclass.featureDefinitions.keys.toSet(),
        reason: 'Catalogo incompleto: ${subclass.name}',
      );

      expect(
        granted.toSet().length,
        granted.length,
        reason: 'Privilegio duplicato: ${subclass.name}',
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final feature = entry.value;

        expect(
          allFeatureIds.add(entry.key),
          isTrue,
          reason: 'ID condiviso tra sottoclassi: ${entry.key}',
        );
        expect(feature.id, entry.key);
        expect(feature.content.id, entry.key);
        expect(feature.content.ownerId, subclass.id);
        expect(feature.content.source.isEmpty, isFalse);
        expect(feature.content.description.summary.trim(), isNotEmpty);
        expect(feature.content.description.details.trim(), isNotEmpty);
        expect(feature.ruleTags, contains('subclass_feature'));
        expect(feature.ruleTags, contains('rogue'));
      }
    }
  });

  test('Thief contains all five PHB features', () {
    expect(
      thief.featureDefinitions.keys.toSet(),
      {
        ThiefFeatureIds.fastHands,
        ThiefFeatureIds.secondStoryWork,
        ThiefFeatureIds.supremeSneak,
        ThiefFeatureIds.useMagicDevice,
        ThiefFeatureIds.thievesReflexes,
      },
    );

    final reflexes = thief.featureDefinitions[ThiefFeatureIds.thievesReflexes]!;
    final effect = reflexes.effects.ruleEffects.single;

    expect(effect.target, 'turns_during_first_combat_round');
    expect(effect.value, 2);
    expect(
      effect.condition,
      'not_surprised_second_turn_at_initiative_minus_10',
    );
  });

  test('Assassin contains all five PHB features and both kits', () {
    expect(
      assassin.featureDefinitions.keys.toSet(),
      {
        AssassinFeatureIds.bonusProficiencies,
        AssassinFeatureIds.assassinate,
        AssassinFeatureIds.infiltrationExpertise,
        AssassinFeatureIds.impostor,
        AssassinFeatureIds.deathStrike,
      },
    );

    final proficiencies = assassin
        .featureDefinitions[AssassinFeatureIds.bonusProficiencies]!
        .effects
        .toolProficiencies;

    expect(
      proficiencies,
      {
        ToolIds.disguiseKit,
        ToolIds.poisonersKit,
      },
    );

    for (final id in proficiencies) {
      expect(
        toolDefinitions,
        contains(id),
        reason: 'Strumento dell’Assassino inesistente: $id',
      );
    }
  });

  test('Arcane Trickster has complete third-caster progression', () {
    final spellcasting = arcaneTrickster.spellcasting!;

    expect(
      spellcasting.progression,
      ClassSpellcastingProgression.third,
    );
    expect(spellcasting.ability, 'INT');
    expect(spellcasting.minimumLevel, 3);

    const expectedSlots = <int, List<int>>{
      3: [2],
      4: [3],
      5: [3],
      6: [3],
      7: [4, 2],
      8: [4, 2],
      9: [4, 2],
      10: [4, 3],
      11: [4, 3],
      12: [4, 3],
      13: [4, 3, 2],
      14: [4, 3, 2],
      15: [4, 3, 2],
      16: [4, 3, 3],
      17: [4, 3, 3],
      18: [4, 3, 3],
      19: [4, 3, 3, 1],
      20: [4, 3, 3, 1],
    };

    expect(spellcasting.slotsAtLevel(2), isEmpty);

    for (final entry in expectedSlots.entries) {
      expect(
        spellcasting.slotsAtLevel(entry.key),
        entry.value,
        reason: 'Slot errati al livello ${entry.key}',
      );
    }

    expect(spellcasting.cantripsKnownAtLevel(3), 3);
    expect(spellcasting.cantripsKnownAtLevel(10), 4);
    expect(spellcasting.spellsKnownAtLevel(3), 3);
    expect(spellcasting.spellsKnownAtLevel(20), 13);

    for (var level = 3; level <= 20; level++) {
      expect(
        spellcasting.spellsKnownFromPoolsAtLevel(level),
        spellcasting.spellsKnownAtLevel(level),
        reason: 'Gruppi di apprendimento incoerenti al livello $level',
      );
    }
  });

  test('Arcane Trickster schools and free exceptions are exact', () {
    final spellcasting = arcaneTrickster.spellcasting!;

    final restricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == ArcaneTricksterSpellPoolIds.enchantmentAndIllusion,
    );
    final unrestricted = spellcasting.learningPools.singleWhere(
      (pool) => pool.id == ArcaneTricksterSpellPoolIds.unrestricted,
    );

    expect(
      restricted.allowedSchoolIds,
      {
        'enchantment',
        'illusion',
      },
    );
    expect(
      restricted.knownByLevel,
      {
        3: 2,
        4: 3,
        7: 4,
        10: 5,
        11: 6,
        13: 7,
        16: 8,
        19: 9,
      },
    );

    expect(unrestricted.allowedSchoolIds, isEmpty);
    expect(
      unrestricted.knownByLevel,
      {
        3: 1,
        8: 2,
        14: 3,
        20: 4,
      },
    );
  });

  test('Mage Hand and every spell link resolve canonically', () {
    final spellcasting = arcaneTrickster.spellcasting!;

    expect(spellDefinitions, contains(SpellIds.mageHand));
    expect(spellcasting.spellIds, contains(SpellIds.mageHand));

    for (final id in spellcasting.spellIds) {
      final spell = spellDefinitions[id];

      expect(
        spell,
        isNotNull,
        reason: 'Incantesimo inesistente: $id',
      );
      expect(
        spell!.classIds,
        contains(ClassIds.wizard),
        reason: 'Incantesimo non appartenente al Mago: $id',
      );
    }

    for (final feature in arcaneTrickster.featureDefinitions.values) {
      for (final id in feature.spellIds) {
        expect(
          spellDefinitions,
          contains(id),
          reason: 'Collegamento a incantesimo inesistente: $id',
        );
      }
    }
  });

  test('all resource references resolve within their owner', () {
    final rogueResourceIds =
        rogue.resources.map((resource) => resource.id).toSet();

    for (final feature in rogue.featureDefinitions.values) {
      if (feature.resourceId != null) {
        expect(
          rogueResourceIds,
          contains(feature.resourceId),
          reason: 'Risorsa base inesistente: ${feature.resourceId}',
        );
      }
    }

    for (final subclass in rogue.subclasses.values) {
      final resourceIds =
          subclass.resources.map((resource) => resource.id).toSet();

      for (final feature in subclass.featureDefinitions.values) {
        if (feature.resourceId != null) {
          expect(
            resourceIds,
            contains(feature.resourceId),
            reason: 'Risorsa inesistente in ${subclass.name}: '
                '${feature.resourceId}',
          );
        }
      }
    }
  });

  test('Rogue catalog contains no empty IDs or editorial records', () {
    expect(rogue.id.trim(), isNotEmpty);
    expect(rogue.content.description.summary.trim(), isNotEmpty);
    expect(rogue.content.description.details.trim(), isNotEmpty);

    for (final entry in rogue.featureDefinitions.entries) {
      final feature = entry.value;

      expect(entry.key.trim(), isNotEmpty);
      expect(feature.id, entry.key);
      expect(feature.content.ownerId, ClassIds.rogue);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
      expect(feature.ruleTags, contains('class_feature'));
      expect(feature.ruleTags, contains('rogue'));
    }
  });
}
