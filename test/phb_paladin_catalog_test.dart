import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/paladin_class_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final paladin = phbClassDefinitions[ClassIds.paladin]!;

  test('Paladin base terminology and details match the Italian PHB', () {
    final divineSense =
        paladin.featureDefinitions[PaladinFeatureIds.divineSense]!;
    expect(divineSense.content.name, 'Percezione del Divino');
    expect(divineSense.content.description.details, contains('luogo sacro'));
    expect(divineSense.content.description.details, isNot(contains('oggetti')));
    expect(
      divineSense.effects.ruleEffects.single.referenceIds,
      contains('hallow'),
    );

    final layOnHands =
        paladin.featureDefinitions[PaladinFeatureIds.layOnHands]!;
    expect(
      layOnHands.content.description.details,
      allOf(contains('costrutti'), contains('non morti')),
    );

    final aura =
        paladin.featureDefinitions[PaladinFeatureIds.auraOfProtection]!;
    expect(aura.content.description.details, contains('minimo di +1'));
    expect(aura.effects.ruleEffects.single.condition, contains('minimum_one'));

    expect(paladin.content.source.name, 'Manuale del Giocatore 2014');
    expect(paladin.content.source.reference, 'pp. 95-100');
  });

  test('all three PHB Sacred Oaths are registered exactly once', () {
    expect(phbPaladinSubclassIds, hasLength(3));
    expect(paladin.subclasses.keys.toSet(), phbPaladinSubclassIds);
    expect(
      paladin.subclasses.keys.toSet(),
      {
        PaladinSubclassIds.ancients,
        PaladinSubclassIds.devotion,
        PaladinSubclassIds.vengeance,
      },
    );
  });

  test('every oath has complete milestones, spells and definitions', () {
    final allOathSpells = <String>{};

    for (final oath in paladin.subclasses.values) {
      expect(oath.classId, ClassIds.paladin);
      expect(oath.homebrew, isFalse);
      expect(oath.supplemental, isFalse);
      expect(oath.featuresByLevel.keys.toSet(), {3, 7, 15, 20});

      final granted =
          oath.featuresByLevel.values.expand((features) => features).toSet();
      expect(granted, hasLength(5));
      expect(
        granted.difference(oath.featureDefinitions.keys.toSet()),
        isEmpty,
      );

      final spells = oath.alwaysPreparedSpellIdsAtLevel(20);
      expect(spells, hasLength(10));
      expect(spells.difference(spellDefinitions.keys.toSet()), isEmpty);
      allOathSpells.addAll(spells);

      final availableResources = {
        ...paladin.resources.map((resource) => resource.id),
        ...oath.resources.map((resource) => resource.id),
      };

      for (final entry in oath.featureDefinitions.entries) {
        final feature = entry.value;
        expect(feature.content.id, entry.key);
        expect(feature.content.ownerId, oath.id);
        expect(feature.content.source.isEmpty, isFalse);

        final resourceId = feature.resourceId;
        if (resourceId != null) {
          expect(
            availableResources,
            contains(resourceId),
            reason: '${oath.id}: risorsa non registrata $resourceId',
          );
        }
      }
    }

    expect(allOathSpells, hasLength(28));
  });

  test('Ancients details include every omitted PHB clause', () {
    final ancients = paladin.subclasses[PaladinSubclassIds.ancients]!;
    expect(ancients.content.source.reference, 'pp. 99-100');
    expect(
      ancients.content.description.details,
      allOf(
        contains('Alimenta la Luce'),
        contains('Proteggi la Luce'),
        contains('Preserva la Tua Luce'),
        contains('Sii la Luce'),
      ),
    );

    final turn = ancients
        .featureDefinitions[PaladinAncientsFeatureIds.turnTheFaithless]!;
    expect(
      turn.content.description.details,
      allOf(
        contains('reazioni'),
        contains('Scatto'),
        contains('Schivata'),
        contains('vera forma'),
      ),
    );
    expect(turn.effects.ruleEffects.single.condition,
        contains('reveal_true_form'));
  });

  test('Devotion details include every omitted PHB clause', () {
    final devotion = paladin.subclasses[PaladinSubclassIds.devotion]!;
    expect(devotion.content.source.reference, 'p. 99');
    expect(
      devotion.content.description.details,
      allOf(
        contains('Onestà'),
        contains('Coraggio'),
        contains('Compassione'),
        contains('Onore'),
        contains('Dovere'),
      ),
    );

    final weapon =
        devotion.featureDefinitions[PaladinDevotionFeatureIds.sacredWeapon]!;
    expect(weapon.content.name, 'Arma Consacrata');
    expect(
      weapon.content.description.details,
      allOf(contains('non impugna'), contains('privo di sensi')),
    );

    final turn =
        devotion.featureDefinitions[PaladinDevotionFeatureIds.turnTheUnholy]!;
    expect(
      turn.content.description.details,
      allOf(contains('reazioni'), contains('Scatto'), contains('Schivata')),
    );
  });

  test('Vengeance contains every PHB oath spell and capstone effect', () {
    final vengeance = paladin.subclasses[PaladinSubclassIds.vengeance]!;
    expect(vengeance.content.source.reference, 'pp. 100-101');
    expect(
      vengeance.alwaysPreparedSpellIdsAtLevel(20),
      {
        'bane',
        'hunters_mark',
        'hold_person',
        'misty_step',
        'haste',
        'protection_from_energy',
        'banishment',
        'dimension_door',
        'hold_monster',
        'scrying',
      },
    );

    final angel =
        vengeance.featureDefinitions[PaladinVengeanceFeatureIds.avengingAngel]!;
    expect(angel.content.description.details, contains('1 ora'));
    expect(angel.effects.ruleEffects, hasLength(4));
  });

  test('Paladin is present in the incremental universal registry', () {
    expect(phbClassDefinitions.keys, contains(ClassIds.paladin));
    expect(phbClassDefinitionFor(ClassIds.paladin), same(paladin));
  });
}
