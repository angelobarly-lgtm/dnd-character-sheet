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

  test('manual audit: Wizard and traditions use the Italian PHB pages', () {
    expect(wizard.content.source.reference, 'Pagine 81-84');

    final expectedReferences = {
      WizardSubclassIds.abjuration: 'Pagine 84-85',
      WizardSubclassIds.enchantment: 'Pagina 85',
      WizardSubclassIds.divination: 'Pagine 85-86',
      WizardSubclassIds.conjuration: 'Pagina 86',
      WizardSubclassIds.illusion: 'Pagine 86-87',
      WizardSubclassIds.evocation: 'Pagina 87',
      WizardSubclassIds.necromancy: 'Pagine 87-88',
      WizardSubclassIds.transmutation: 'Pagina 88',
    };

    for (final entry in expectedReferences.entries) {
      final source = wizard.subclasses[entry.key]!.content.source;

      expect(source.name, 'Manuale del Giocatore 2014');
      expect(source.reference, entry.value);
    }
  });

  test('manual audit: Wizard base spell rules are complete', () {
    final casting = wizard.featureDefinitions[WizardFeatureIds.spellcasting]!;
    final mastery = wizard.featureDefinitions[WizardFeatureIds.spellMastery]!;
    final signatures =
        wizard.featureDefinitions[WizardFeatureIds.signatureSpells]!;

    expect(
        casting.content.description.details, contains('1 minuto per livello'));
    expect(
      casting.content.description.details,
      contains('anche se non è preparato'),
    );
    expect(
      casting.content.description.details,
      contains('8 + bonus di competenza'),
    );
    expect(mastery.content.name, 'Maestria negli Incantesimi');
    expect(
      mastery.content.description.details,
      contains('livello superiore'),
    );
    expect(
      signatures.content.description.details,
      contains('non contano nel limite'),
    );
    expect(
      signatures.content.description.details,
      contains('una volta al 3° livello'),
    );
  });

  test('manual audit: official Wizard feature names are preserved', () {
    final names = wizard.subclasses.values
        .expand((school) => school.featureDefinitions.values)
        .map((feature) => feature.content.name)
        .toSet();

    expect(
      names,
      containsAll({
        'Abiuratore Sapiente',
        'Ammaliatore Sapiente',
        'Divinatore Sapiente',
        'Evocatore Sapiente',
        'Illusionista Sapiente',
        'Invocatore Sapiente',
        'Necromante Sapiente',
        'Trasmutatore Sapiente',
        'Portento',
        'Portento Superiore',
        'Terzo Occhio',
        'Evocazioni Perduranti',
        'Illusioni Duttili',
        'Sosia Illusorio',
        'Saturazione Magica',
        'Impervio alla Non Morte',
      }),
    );
  });

  test('manual audit: corrected school restrictions are enforced', () {
    final conjuration = wizard.subclasses[WizardSubclassIds.conjuration]!;
    final enchantment = wizard.subclasses[WizardSubclassIds.enchantment]!;
    final evocation = wizard.subclasses[WizardSubclassIds.evocation]!;
    final necromancy = wizard.subclasses[WizardSubclassIds.necromancy]!;
    final transmutation = wizard.subclasses[WizardSubclassIds.transmutation]!;

    final minorConjuration = conjuration
        .featureDefinitions[WizardConjurationFeatureIds.minorConjuration]!;
    expect(minorConjuration.content.description.details, contains('5 kg'));
    expect(
      minorConjuration.content.description.details,
      isNot(contains('quando infligge danni')),
    );

    final memories = enchantment
        .featureDefinitions[WizardEnchantmentFeatureIds.alterMemories]!;
    expect(memories.ruleTags, contains('intelligence_saving_throw'));
    expect(
      memories.content.description.details,
      contains('tiro salvezza su Intelligenza'),
    );
    expect(
      memories.content.description.details,
      contains('non superiore alla durata'),
    );

    final saturation =
        evocation.featureDefinitions[WizardEvocationFeatureIds.overchannel]!;
    expect(
      saturation.content.description.details,
      isNot(contains('non possono essere ridotti o evitati')),
    );

    final command = necromancy
        .featureDefinitions[WizardNecromancyFeatureIds.commandUndead]!;
    expect(
      command.content.description.details,
      contains('non può più utilizzare questo privilegio'),
    );

    final alchemy = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.minorAlchemy]!;
    final stone = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.transmutersStone]!;
    final master = transmutation
        .featureDefinitions[WizardTransmutationFeatureIds.masterTransmuter]!;

    expect(
      alchemy.content.description.details,
      contains('spigolo di 30 centimetri'),
    );
    expect(
      stone.content.description.details,
      contains('finché è privo di ingombro'),
    );
    expect(
      stone.content.description.details,
      contains('soltanto se porta la pietra con sé'),
    );
    expect(
      master.content.description.details,
      contains('spigolo di 1,5 metri'),
    );
    expect(
      master.content.description.details,
      contains('fino a un minimo di 13 anni'),
    );
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
