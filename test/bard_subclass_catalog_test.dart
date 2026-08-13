import 'package:dnd_character_sheet/data/bard_class_data.dart';
import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final bard = phbClassDefinitions[ClassIds.bard]!;

  test('both PHB Bard colleges are registered', () {
    expect(
      bard.subclasses.keys.toSet(),
      {
        BardSubclassIds.lore,
        BardSubclassIds.valor,
      },
    );
    expect(bard.phbSubclasses, hasLength(2));
    expect(bard.supplementalSubclasses, isEmpty);

    for (final subclass in bard.phbSubclasses) {
      expect(subclass.classId, ClassIds.bard);
      expect(subclass.homebrew, isFalse);
      expect(subclass.supplemental, isFalse);
      expect(subclass.content.source.isEmpty, isFalse);
    }
  });

  test('College of Lore progression is complete', () {
    final lore = bard.subclasses[BardSubclassIds.lore]!;

    expect(lore.featuresByLevel, {
      3: [
        'bonus_proficiencies_lore',
        'cutting_words',
      ],
      6: ['additional_magical_secrets'],
      14: ['peerless_skill'],
    });

    final granted =
        lore.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(lore.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('Lore bonus skills are represented as a structured choice', () {
    final feature = bardLoreFeatureDefinitions['bonus_proficiencies_lore']!;
    final choice = feature.choices.single;

    expect(choice.type, CharacterChoiceType.skill);
    expect(choice.optionIds, hasLength(18));
    expect(choice.minimumSelections, 3);
    expect(choice.maximumSelections, 3);
    expect(choice.requireNewAcquisition, isTrue);
  });

  test('Additional Magical Secrets allows two spells up to level 3', () {
    final feature = bardLoreFeatureDefinitions['additional_magical_secrets']!;
    final choice = feature.choices.single;

    expect(choice.type, CharacterChoiceType.spell);
    expect(choice.minimumSelections, 2);
    expect(choice.maximumSelections, 2);
    expect(choice.maximumSpellLevel, 3);
  });

  test('Lore features consume Bardic Inspiration where required', () {
    expect(
      bardLoreFeatureDefinitions['cutting_words']!.resourceId,
      'bardic_inspiration',
    );
    expect(
      bardLoreFeatureDefinitions['peerless_skill']!.resourceId,
      'bardic_inspiration',
    );
  });

  test('College of Valor progression is complete', () {
    final valor = bard.subclasses[BardSubclassIds.valor]!;

    expect(valor.featuresByLevel, {
      3: [
        'bonus_proficiencies_valor',
        'combat_inspiration',
      ],
      6: ['extra_attack'],
      14: ['battle_magic'],
    });

    final granted =
        valor.featuresByLevel.values.expand((features) => features).toSet();

    expect(
      granted.difference(valor.featureDefinitions.keys.toSet()),
      isEmpty,
    );
  });

  test('Valor bonus proficiencies are permanent structured effects', () {
    final effects =
        bardValorFeatureDefinitions['bonus_proficiencies_valor']!.effects;

    expect(
      effects.armorProficiencies,
      {
        'medium_armor',
        'shield',
      },
    );
    expect(
      effects.weaponProficiencies,
      {
        'martial_weapons',
      },
    );
  });

  test('Combat Inspiration consumes Bardic Inspiration', () {
    final feature = bardValorFeatureDefinitions['combat_inspiration']!;

    expect(feature.resourceId, 'bardic_inspiration');
    expect(feature.ruleTags, contains('armor_class'));
    expect(feature.ruleTags, contains('weapon_damage'));
  });

  test('all college feature content has stable ownership', () {
    for (final subclass in bard.phbSubclasses) {
      expect(subclass.content.ownerId, ClassIds.bard);
      expect(
        subclass.content.description.summary.trim(),
        isNotEmpty,
      );
      expect(
        subclass.content.description.details.trim(),
        isNotEmpty,
      );

      for (final entry in subclass.featureDefinitions.entries) {
        final content = entry.value.content;

        expect(content.id, entry.key);
        expect(content.ownerId, subclass.id);
        expect(content.source.isEmpty, isFalse);
        expect(content.description.summary.trim(), isNotEmpty);
        expect(content.description.details.trim(), isNotEmpty);
      }
    }
  });

  test('college rules use metric distances', () {
    expect(
      bardLoreFeatureDefinitions['cutting_words']!.content.description.details,
      contains('18 metri'),
    );
  });
}
