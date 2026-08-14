import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wizard = wizardClassDefinition;

  final expectedSchools = {
    WizardSubclassIds.abjuration: 'Scuola di Abiurazione',
    WizardSubclassIds.enchantment: 'Scuola di Ammaliamento',
    WizardSubclassIds.divination: 'Scuola di Divinazione',
    WizardSubclassIds.conjuration: 'Scuola di Evocazione',
    WizardSubclassIds.illusion: 'Scuola di Illusione',
    WizardSubclassIds.evocation: 'Scuola di Invocazione',
    WizardSubclassIds.necromancy: 'Scuola di Necromanzia',
    WizardSubclassIds.transmutation: 'Scuola di Trasmutazione',
  };

  test('universal registry contains the complete PHB Wizard', () {
    expect(phbClassDefinitions[ClassIds.wizard], same(wizard));
    expect(wizard.id, ClassIds.wizard);
    expect(wizard.name, 'Mago');
    expect(wizard.hitDie, 6);
    expect(wizard.subclassSelectionLevel, 2);
    expect(wizard.homebrew, isFalse);
    expect(wizard.content.source.isEmpty, isFalse);
  });

  test('all eight PHB arcane traditions are present', () {
    expect(wizard.subclasses.keys.toSet(), expectedSchools.keys.toSet());
    expect(wizard.subclasses, hasLength(8));

    for (final entry in expectedSchools.entries) {
      final school = wizard.subclasses[entry.key]!;

      expect(school.id, entry.key);
      expect(school.name, entry.value);
      expect(school.classId, ClassIds.wizard);
      expect(school.content.id, entry.key);
      expect(school.content.name, entry.value);
      expect(school.content.ownerId, ClassIds.wizard);
      expect(school.content.source.isEmpty, isFalse);
      expect(school.homebrew, isFalse);
      expect(school.supplemental, isFalse);
    }
  });

  test('every tradition grants exactly five features at PHB levels', () {
    final allGrantedIds = <String>[];

    for (final school in wizard.subclasses.values) {
      expect(school.featuresByLevel.keys.toSet(), {2, 6, 10, 14});
      expect(school.featuresByLevel[2], hasLength(2));
      expect(school.featuresByLevel[6], hasLength(1));
      expect(school.featuresByLevel[10], hasLength(1));
      expect(school.featuresByLevel[14], hasLength(1));

      final granted =
          school.featuresByLevel.values.expand((features) => features).toList();

      expect(granted, hasLength(5));
      expect(granted.toSet(), hasLength(5));
      expect(school.featureDefinitions, hasLength(5));
      expect(
        granted.toSet().difference(
              school.featureDefinitions.keys.toSet(),
            ),
        isEmpty,
      );

      allGrantedIds.addAll(granted);
    }

    expect(allGrantedIds, hasLength(40));
    expect(allGrantedIds.toSet(), hasLength(40));
  });

  test('all forty tradition features have canonical metadata', () {
    final features = wizard.subclasses.values
        .expand((school) => school.featureDefinitions.values)
        .toList();

    expect(features, hasLength(40));

    for (final feature in features) {
      expect(feature.id, isNotEmpty);
      expect(feature.content.id, feature.id);
      expect(feature.content.name.trim(), isNotEmpty);
      expect(feature.content.ownerId, ClassIds.wizard);
      expect(feature.content.source.isEmpty, isFalse);
      expect(feature.content.description.summary.trim(), isNotEmpty);
      expect(feature.content.description.details.trim(), isNotEmpty);
      expect(feature.ruleTags, contains('wizard'));
      expect(feature.ruleTags, contains('arcane_tradition'));
      expect(feature.ruleTags, contains('subclass_feature'));
    }
  });

  test('all eight Savant discounts are structured and school-specific', () {
    final adjustments = wizard.subclasses.values
        .expand((school) => school.spellbookCopyAdjustments)
        .toList();

    expect(adjustments, hasLength(8));
    expect(
      adjustments.map((entry) => entry.schoolId).toSet(),
      {
        'abjuration',
        'conjuration',
        'divination',
        'enchantment',
        'evocation',
        'illusion',
        'necromancy',
        'transmutation',
      },
    );

    for (final adjustment in adjustments) {
      expect(adjustment.timeNumerator, 1);
      expect(adjustment.timeDenominator, 2);
      expect(adjustment.costNumerator, 1);
      expect(adjustment.costDenominator, 2);

      expect(
        adjustment.adjustedCopyHours(
          9,
          baseHoursPerSpellLevel: 2,
        ),
        9,
      );
      expect(
        adjustment.adjustedCopyCostGp(
          9,
          baseCostGpPerSpellLevel: 50,
        ),
        225,
      );
    }
  });

  test('every subclass resource is linked to a granted feature', () {
    final resourceIds = <String>[];

    for (final school in wizard.subclasses.values) {
      for (final resource in school.resources) {
        expect(
          school.featureDefinitions,
          contains(resource.id),
          reason:
              'Risorsa ${resource.id} priva del relativo privilegio in ${school.id}.',
        );
        expect(resource.minimumLevel, greaterThanOrEqualTo(2));
        expect(resource.name.trim(), isNotEmpty);
        resourceIds.add(resource.id);
      }

      for (final feature in school.featureDefinitions.values) {
        if (feature.resourceId != null) {
          expect(
            school.resources.map((entry) => entry.id),
            contains(feature.resourceId),
            reason:
                'Privilegio ${feature.id} collegato a una risorsa inesistente.',
          );
        }
      }
    }

    expect(resourceIds, hasLength(8));
    expect(resourceIds.toSet(), hasLength(8));
  });

  test('Arcane Ward and Portent retain their exact progressions', () {
    final abjuration = wizard.subclasses[WizardSubclassIds.abjuration]!;
    final divination = wizard.subclasses[WizardSubclassIds.divination]!;

    final ward = abjuration.resources.singleWhere(
      (entry) => entry.id == WizardAbjurationFeatureIds.arcaneWard,
    );
    final portent = divination.resources.singleWhere(
      (entry) => entry.id == WizardDivinationFeatureIds.portent,
    );

    expect(
      ward.maximumAtLevel(
        2,
        abilityModifiers: const {'INT': 3},
      ),
      7,
    );
    expect(
      ward.maximumAtLevel(
        20,
        abilityModifiers: const {'INT': 5},
      ),
      45,
    );

    expect(portent.maximumAtLevel(2), 2);
    expect(portent.maximumAtLevel(13), 2);
    expect(portent.maximumAtLevel(14), 3);
    expect(portent.maximumAtLevel(20), 3);
  });

  test('all linked subclass spells exist in the canonical registry', () {
    final spellIds = wizard.subclasses.values
        .expand((school) => school.featureDefinitions.values)
        .expand((feature) => feature.spellIds)
        .toSet();

    expect(spellIds, {'animate_dead', 'polymorph', 'raise_dead'});
    expect(spellIds.every(spellDefinitions.containsKey), isTrue);
  });

  test('all Wizard spell choices have unique stable identifiers', () {
    final baseChoices =
        wizard.featureDefinitions.values.expand((feature) => feature.choices);
    final subclassChoices = wizard.subclasses.values
        .expand((school) => school.featureDefinitions.values)
        .expand((feature) => feature.choices);
    final choices = [...baseChoices, ...subclassChoices];

    final ids = choices.map((choice) => choice.id).toList();

    expect(ids, isNotEmpty);
    expect(ids.toSet(), hasLength(ids.length));

    for (final choice in choices) {
      expect(choice.id.trim(), isNotEmpty);
      expect(choice.label.trim(), isNotEmpty);
      expect(choice.minimumSelections, greaterThan(0));
      expect(
        choice.maximumSelections,
        greaterThanOrEqualTo(choice.minimumSelections),
      );
    }
  });

  test('special Wizard acquisitions remain connected to spells', () {
    final illusion = wizard.subclasses[WizardSubclassIds.illusion]!;
    final necromancy = wizard.subclasses[WizardSubclassIds.necromancy]!;
    final transmutation = wizard.subclasses[WizardSubclassIds.transmutation]!;

    expect(
      illusion
          .featureDefinitions[WizardIllusionFeatureIds.improvedMinorIllusion]!
          .choices,
      hasLength(1),
    );
    expect(
      necromancy.featureDefinitions[WizardNecromancyFeatureIds.undeadThralls]!
          .spellIds,
      {'animate_dead'},
    );
    expect(
      transmutation
          .featureDefinitions[WizardTransmutationFeatureIds.shapechanger]!
          .spellIds,
      {'polymorph'},
    );
    expect(
      transmutation
          .featureDefinitions[WizardTransmutationFeatureIds.masterTransmuter]!
          .spellIds,
      {'raise_dead'},
    );
  });

  test('Wizard spellbook and spellcasting remain complete', () {
    final spellbook = wizard.spellbook!;
    final magic = wizard.spellcasting!;

    expect(spellbook.automaticSpellsAtLevel(1), 6);
    expect(spellbook.automaticSpellsAtLevel(20), 44);

    expect(magic.progression, ClassSpellcastingProgression.full);
    expect(magic.ability, 'INT');
    expect(magic.preparesSpells, isTrue);
    expect(magic.ritualCasting, isTrue);
    expect(magic.slotsByClassLevel, hasLength(20));
    expect(magic.cantripsKnownAtLevel(1), 3);
    expect(magic.cantripsKnownAtLevel(10), 5);
    expect(magic.slotsAtLevel(20), [4, 3, 3, 3, 3, 2, 2, 1, 1]);

    final canonicalWizardSpells = spellDefinitions.values
        .where((spell) => spell.classIds.contains(ClassIds.wizard))
        .map((spell) => spell.id)
        .toSet();

    expect(magic.spellIds, canonicalWizardSpells);
  });

  test('all base Wizard features are defined and sourced', () {
    final granted =
        wizard.featuresByLevel.values.expand((features) => features).toSet();

    expect(granted, hasLength(6));
    expect(
      granted.difference(wizard.featureDefinitions.keys.toSet()),
      isEmpty,
    );

    for (final entry in wizard.featureDefinitions.entries) {
      expect(entry.value.id, entry.key);
      expect(entry.value.content.id, entry.key);
      expect(entry.value.content.ownerId, ClassIds.wizard);
      expect(entry.value.content.source.isEmpty, isFalse);
    }
  });
}
