import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;
  final archfey = warlock.subclasses[WarlockSubclassIds.archfey]!;
  final fiend = warlock.subclasses[WarlockSubclassIds.fiend]!;

  test('Archfey and Fiend are registered as PHB 2014 patrons', () {
    expect(
      warlock.subclasses.keys,
      contains(WarlockSubclassIds.archfey),
    );
    expect(
      warlock.subclasses.keys,
      contains(WarlockSubclassIds.fiend),
    );

    expect(archfey, same(warlockArchfeyDefinition));
    expect(archfey.name, 'Il Signore Fatato');
    expect(archfey.classId, ClassIds.warlock);
    expect(archfey.content.ownerId, ClassIds.warlock);
    expect(
      archfey.content.source.name,
      'Manuale del Giocatore 2014',
    );
    expect(archfey.content.source.reference, 'pp. 116-117');
    expect(archfey.homebrew, isFalse);
    expect(archfey.supplemental, isFalse);

    expect(fiend, same(warlockFiendDefinition));
    expect(fiend.name, 'L’Immondo');
    expect(fiend.classId, ClassIds.warlock);
    expect(fiend.content.ownerId, ClassIds.warlock);
    expect(
      fiend.content.source.name,
      'Manuale del Giocatore 2014',
    );
    expect(fiend.content.source.reference, 'p. 117');
    expect(fiend.homebrew, isFalse);
    expect(fiend.supplemental, isFalse);
  });

  test('expanded patron spells are available but never auto-known', () {
    expect(
      archfey.expandedSpellIdsByLevel,
      phbWarlockArchfeyExpandedSpellIdsByLevel,
    );
    expect(
      fiend.expandedSpellIdsByLevel,
      phbWarlockFiendExpandedSpellIdsByLevel,
    );

    const spellLevelByWarlockLevel = <int, int>{
      1: 1,
      3: 2,
      5: 3,
      7: 4,
      9: 5,
    };

    for (final patron in [archfey, fiend]) {
      expect(patron.expandedSpellIdsByLevel, hasLength(5));
      expect(
        patron.expandedSpellIdsByLevel.values
            .expand((spellIds) => spellIds)
            .toSet(),
        hasLength(10),
      );
      expect(patron.alwaysPreparedSpellIdsByLevel, isEmpty);

      for (final entry in patron.expandedSpellIdsByLevel.entries) {
        expect(entry.value, hasLength(2));

        for (final spellId in entry.value) {
          expect(spellDefinitions, contains(spellId));
          expect(
            spellDefinitions[spellId]!.level,
            spellLevelByWarlockLevel[entry.key],
          );
        }
      }

      final automaticallyGranted = patron.featureDefinitions.values
          .expand((feature) => feature.effects.grantedSpellIds)
          .toSet();

      expect(automaticallyGranted, isEmpty);
    }
  });

  test('expanded spell lookup accumulates spells by class level', () {
    expect(archfey.expandedSpellIdsAtLevel(0), isEmpty);
    expect(
      archfey.expandedSpellIdsAtLevel(1),
      {'faerie_fire', 'sleep'},
    );
    expect(archfey.expandedSpellIdsAtLevel(3), hasLength(4));
    expect(archfey.expandedSpellIdsAtLevel(9), hasLength(10));
    expect(archfey.expandedSpellIdsAtLevel(20), hasLength(10));

    expect(fiend.expandedSpellIdsAtLevel(0), isEmpty);
    expect(
      fiend.expandedSpellIdsAtLevel(1),
      {'burning_hands', 'command'},
    );
    expect(fiend.expandedSpellIdsAtLevel(7), hasLength(8));
    expect(fiend.expandedSpellIdsAtLevel(20), hasLength(10));
  });

  test('Archfey grants all four features at the manual levels', () {
    expect(
      archfey.featuresByLevel,
      {
        1: [WarlockArchfeyFeatureIds.feyPresence],
        6: [WarlockArchfeyFeatureIds.mistyEscape],
        10: [WarlockArchfeyFeatureIds.beguilingDefenses],
        14: [WarlockArchfeyFeatureIds.darkDelirium],
      },
    );
    expect(archfey.featureDefinitions, hasLength(4));

    final presence =
        archfey.featureDefinitions[WarlockArchfeyFeatureIds.feyPresence]!;

    expect(
      presence.resourceId,
      WarlockArchfeyResourceIds.feyPresence,
    );
    expect(presence.effects.ruleEffects.single.value, 3);
    expect(
      presence.effects.ruleEffects.single.condition,
      contains('charmed_or_frightened'),
    );

    final escape =
        archfey.featureDefinitions[WarlockArchfeyFeatureIds.mistyEscape]!;

    expect(
      escape.resourceId,
      WarlockArchfeyResourceIds.mistyEscape,
    );
    expect(escape.effects.ruleEffects.single.value, 18);
    expect(
      escape.effects.ruleEffects.single.type,
      CharacterRuleEffectType.reaction,
    );

    final defenses =
        archfey.featureDefinitions[WarlockArchfeyFeatureIds.beguilingDefenses]!;

    expect(defenses.effects.conditionImmunities, {'charmed'});
    expect(
      defenses.effects.ruleEffects.single.type,
      CharacterRuleEffectType.reaction,
    );

    final delirium =
        archfey.featureDefinitions[WarlockArchfeyFeatureIds.darkDelirium]!;

    expect(
      delirium.resourceId,
      WarlockArchfeyResourceIds.darkDelirium,
    );
    expect(delirium.effects.ruleEffects.single.value, 18);
    expect(
      delirium.effects.ruleEffects.single.condition,
      contains('concentration'),
    );
  });

  test('Archfey resources recover after a short or long rest', () {
    expect(archfey.resources, hasLength(3));
    expect(
      archfey.resources.map((resource) => resource.id).toSet(),
      {
        WarlockArchfeyResourceIds.feyPresence,
        WarlockArchfeyResourceIds.mistyEscape,
        WarlockArchfeyResourceIds.darkDelirium,
      },
    );

    for (final resource in archfey.resources) {
      expect(
        resource.recovery,
        ClassResourceRecovery.shortRest,
      );
      expect(resource.maximumAtLevel(20), 1);
    }

    expect(
      archfey.resources
          .singleWhere(
            (resource) => resource.id == WarlockArchfeyResourceIds.feyPresence,
          )
          .minimumLevel,
      1,
    );

    expect(
      archfey.resources
          .singleWhere(
            (resource) => resource.id == WarlockArchfeyResourceIds.mistyEscape,
          )
          .minimumLevel,
      6,
    );

    expect(
      archfey.resources
          .singleWhere(
            (resource) => resource.id == WarlockArchfeyResourceIds.darkDelirium,
          )
          .minimumLevel,
      14,
    );
  });

  test('Fiend grants all four features at the manual levels', () {
    expect(
      fiend.featuresByLevel,
      {
        1: [WarlockFiendFeatureIds.darkOnesBlessing],
        6: [WarlockFiendFeatureIds.darkOnesOwnLuck],
        10: [WarlockFiendFeatureIds.fiendishResilience],
        14: [WarlockFiendFeatureIds.hurlThroughHell],
      },
    );
    expect(fiend.featureDefinitions, hasLength(4));

    final blessing =
        fiend.featureDefinitions[WarlockFiendFeatureIds.darkOnesBlessing]!;

    expect(blessing.resourceId, isNull);
    expect(
      blessing.effects.ruleEffects.single.target,
      'temporary_hit_points',
    );
    expect(
      blessing.effects.ruleEffects.single.condition,
      contains(
        'charisma_modifier_plus_warlock_level_minimum_one',
      ),
    );

    final luck =
        fiend.featureDefinitions[WarlockFiendFeatureIds.darkOnesOwnLuck]!;

    expect(
      luck.resourceId,
      WarlockFiendResourceIds.darkOnesOwnLuck,
    );
    expect(
      luck.effects.ruleEffects.single.condition,
      contains('one_d10'),
    );

    final resilience =
        fiend.featureDefinitions[WarlockFiendFeatureIds.fiendishResilience]!;
    final choice = resilience.choices.single;

    expect(
      choice.id,
      WarlockFiendChoiceIds.fiendishResilienceDamageType,
    );
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.unique, isTrue);
    expect(choice.options, hasLength(13));
    expect(
      choice.options.map((option) => option.id).toSet(),
      phbWarlockFiendishResilienceDamageTypeLabels.keys.toSet(),
    );

    for (final option in choice.options) {
      expect(option.effects.damageResistances, {option.id});
      expect(
        option.effects.ruleEffects.single.condition,
        contains('magical_or_silvered_weapons'),
      );
    }

    final hurl =
        fiend.featureDefinitions[WarlockFiendFeatureIds.hurlThroughHell]!;

    expect(
      hurl.resourceId,
      WarlockFiendResourceIds.hurlThroughHell,
    );
    expect(
      hurl.effects.ruleEffects.single.referenceIds,
      ['psychic'],
    );
    expect(
      hurl.effects.ruleEffects.single.condition,
      contains('10d10'),
    );
    expect(
      hurl.effects.ruleEffects.single.condition,
      contains('non_fiend'),
    );
  });

  test('Fiend resources preserve their different recoveries', () {
    expect(fiend.resources, hasLength(2));

    final luck = fiend.resources.singleWhere(
      (resource) => resource.id == WarlockFiendResourceIds.darkOnesOwnLuck,
    );

    expect(luck.minimumLevel, 6);
    expect(luck.recovery, ClassResourceRecovery.shortRest);
    expect(luck.maximumAtLevel(20), 1);

    final hurl = fiend.resources.singleWhere(
      (resource) => resource.id == WarlockFiendResourceIds.hurlThroughHell,
    );

    expect(hurl.minimumLevel, 14);
    expect(hurl.recovery, ClassResourceRecovery.longRest);
    expect(hurl.maximumAtLevel(20), 1);
  });

  test('all patron feature and resource links resolve', () {
    for (final patron in [archfey, fiend]) {
      final granted =
          patron.featuresByLevel.values.expand((features) => features).toSet();

      expect(granted, hasLength(4));
      expect(granted, patron.featureDefinitions.keys.toSet());

      final resourceIds =
          patron.resources.map((resource) => resource.id).toSet();

      for (final entry in patron.featureDefinitions.entries) {
        expect(entry.value.id, entry.key);
        expect(entry.value.content.id, entry.key);
        expect(
          entry.value.content.ownerId,
          ClassIds.warlock,
        );
        expect(
          entry.value.content.source.name,
          'Manuale del Giocatore 2014',
        );

        final resourceId = entry.value.resourceId;

        if (resourceId != null) {
          expect(resourceIds, contains(resourceId));
        }
      }
    }
  });
}
