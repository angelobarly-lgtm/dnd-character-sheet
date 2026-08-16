import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 12,
  'DES': 14,
  'COS': 14,
  'INT': 13,
  'SAG': 13,
  'CAR': 10,
};

HeroData createFighter({
  List<FeatAcquisition> featAcquisitions = const [],
  Map<String, List<String>> raceChoices = const {},
  String? raceId,
  String? legacyFeat,
}) {
  return HeroData(
    name: 'Test multi-talento',
    classId: ClassIds.fighter,
    level: 5,
    baseScores: baseScores,
    raceId: raceId,
    raceChoices: raceChoices,
    feat: legacyFeat,
    featAcquisitions: featAcquisitions,
  );
}

void main() {
  group('Acquisizioni multiple dei talenti', () {
    test('più talenti funzionano per qualsiasi razza e classe', () {
      final normal = createFighter();
      final hero = createFighter(
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'alert_l4',
            featId: FeatIds.alert,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
          FeatAcquisition(
            instanceId: 'mobile_l4',
            featId: FeatIds.mobile,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
        ],
      );

      expect(hero.resolvedFeatIds, contains(FeatIds.alert));
      expect(hero.resolvedFeatIds, contains(FeatIds.mobile));
      expect(hero.initiative, normal.initiative + 5);
      expect(hero.speed, normal.speed + 3);
    });

    test('Umano Variante conserva talento razziale e talento successivo', () {
      final hero = createFighter(
        raceId: HumanVariantIds.variant,
        raceChoices: const {
          'human_variant_feat': [FeatIds.alert],
        },
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'mobile_l4',
            featId: FeatIds.mobile,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
        ],
      );

      expect(hero.resolvedFeatIds, contains(FeatIds.alert));
      expect(hero.resolvedFeatIds, contains(FeatIds.mobile));
      expect(hero.featAcquisitions, hasLength(1));
    });

    test('un talento normale duplicato applica gli effetti una sola volta', () {
      final normal = createFighter();
      final hero = createFighter(
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'alert_1',
            featId: FeatIds.alert,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
          FeatAcquisition(
            instanceId: 'alert_2',
            featId: FeatIds.alert,
            source: 'test',
            acquiredAtLevel: 5,
          ),
        ],
      );

      expect(hero.initiative, normal.initiative + 5);
      expect(
        hero.resolvedFeatIds.where((id) => id == FeatIds.alert),
        hasLength(1),
      );
    });

    test('Esperto Elementale mantiene acquisizioni e scelte separate', () {
      final hero = createFighter(
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'elemental_acid',
            featId: FeatIds.elementalAdept,
            source: 'asi',
            acquiredAtLevel: 4,
            selections: {
              'elemental_adept_damage_type': ['acid'],
            },
          ),
          FeatAcquisition(
            instanceId: 'elemental_fire',
            featId: FeatIds.elementalAdept,
            source: 'test',
            acquiredAtLevel: 5,
            selections: {
              'elemental_adept_damage_type': ['fire'],
            },
          ),
        ],
      );

      final elementalRules = hero.resolvedFeatEffects!.effects.ruleEffects
          .where((effect) => effect.target == 'elemental_adept_damage_type');

      final selectedTypes =
          elementalRules.expand((effect) => effect.referenceIds).toSet();

      expect(hero.featAcquisitions, hasLength(2));
      expect(selectedTypes, containsAll(<String>{'acid', 'fire'}));
    });

    test('serializzazione conserva ogni acquisizione e le sue scelte', () {
      final original = createFighter(
        featAcquisitions: const [
          FeatAcquisition(
            instanceId: 'alert_l4',
            featId: FeatIds.alert,
            source: 'asi',
            acquiredAtLevel: 4,
          ),
          FeatAcquisition(
            instanceId: 'elemental_fire_l5',
            featId: FeatIds.elementalAdept,
            source: 'test',
            acquiredAtLevel: 5,
            selections: {
              'elemental_adept_damage_type': ['fire'],
            },
          ),
        ],
      );

      final restored = HeroData.fromJson(original.toJson());

      expect(restored.featAcquisitions, hasLength(2));
      expect(restored.featAcquisitions[0].instanceId, 'alert_l4');
      expect(restored.featAcquisitions[0].source, 'asi');
      expect(restored.featAcquisitions[0].acquiredAtLevel, 4);
      expect(
        restored.featAcquisitions[1].selections['elemental_adept_damage_type'],
        ['fire'],
      );
      expect(restored.resolvedFeatIds, contains(FeatIds.alert));
      expect(restored.resolvedFeatIds, contains(FeatIds.elementalAdept));
    });

    test('i vecchi salvataggi con il singolo campo feat restano validi', () {
      final normal = createFighter();
      final legacy = createFighter(legacyFeat: 'Allerta');
      final restored = HeroData.fromJson(legacy.toJson());

      expect(restored.resolvedFeatIds, contains(FeatIds.alert));
      expect(restored.initiative, normal.initiative + 5);
    });
  });
}
