import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/wizard_class_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 14,
  'DES': 14,
  'COS': 14,
  'INT': 16,
  'SAG': 14,
  'CAR': 10,
};

void main() {
  group('Privilegi multiclasse', () {
    test('etichetta mostra ogni classe con il proprio livello', () {
      final hero = HeroData(
        name: 'Guerriero Mago',
        baseScores: scores,
        level: 5,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 2,
          ClassIds.wizard: 3,
        },
      );

      expect(
        hero.resolvedClassLevelLabel,
        'Guerriero 2 · Mago 3',
      );
    });

    test('privilegi appartengono a entrambe le classi', () {
      final hero = HeroData(
        name: 'Guerriero Mago',
        baseScores: scores,
        level: 5,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 2,
          ClassIds.wizard: 3,
        },
      );

      expect(
        hero.resolvedClassFeatures
            .any((feature) => feature.ownerClassId == ClassIds.fighter),
        isTrue,
      );
      expect(
        hero.resolvedClassFeatures
            .any((feature) => feature.ownerClassId == ClassIds.wizard),
        isTrue,
      );
    });

    test('ogni privilegio rispetta il livello della propria classe', () {
      final hero = HeroData(
        name: 'Monaco Guerriero',
        baseScores: scores,
        level: 7,
        classId: ClassIds.monk,
        classLevels: const {
          ClassIds.monk: 2,
          ClassIds.fighter: 5,
        },
      );

      for (final feature in hero.resolvedClassFeatures) {
        expect(
          feature.requiredClassLevel,
          lessThanOrEqualTo(hero.classLevel(feature.ownerClassId)),
        );
      }
    });

    test('privilegi della sottoclasse mantengono il proprietario', () {
      final hero = HeroData(
        name: 'Mago Abiuratore',
        baseScores: scores,
        level: 5,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 3,
          ClassIds.wizard: 2,
        },
        classSubclasses: const {
          ClassIds.wizard: WizardSubclassIds.abjuration,
        },
      );

      final subclassFeatures = hero.resolvedClassFeatures.where(
        (feature) =>
            feature.ownerClassId == ClassIds.wizard &&
            feature.subclassId == WizardSubclassIds.abjuration,
      );

      expect(subclassFeatures, isNotEmpty);
      expect(
        subclassFeatures.every(
          (feature) => feature.subclassName != null,
        ),
        isTrue,
      );
    });

    test('featuresAtLevel usa la classe richiesta', () {
      final hero = HeroData(
        name: 'Guerriero Mago',
        baseScores: scores,
        level: 5,
        classId: ClassIds.fighter,
        classLevels: const {
          ClassIds.fighter: 2,
          ClassIds.wizard: 3,
        },
      );

      expect(
        hero.featuresAtLevel(
          2,
          ownerClassId: ClassIds.fighter,
        ),
        isNotEmpty,
      );
      expect(
        hero.featuresAtLevel(
          2,
          ownerClassId: ClassIds.wizard,
        ),
        isNotEmpty,
      );
    });
  });
}
