import 'bestiary_beast_data.dart';
import 'bestiary_class_reference_data.dart';
import 'bestiary_data.dart';

export 'bestiary_beast_data.dart';
export 'bestiary_class_reference_data.dart';
export 'bestiary_data.dart';

final Map<String, CreatureDefinition> phbBestiaryDefinitions = {
  ...phbBestiaryBeastDefinitions,
  ...phbBestiaryClassReferenceDefinitions,
};

CreatureDefinition? phbBestiaryDefinitionFor(String id) =>
    phbBestiaryDefinitions[id];

Iterable<CreatureDefinition> filterBestiaryDefinitions(
  Iterable<CreatureDefinition> definitions, {
  Set<CreatureType> allowedTypes = const {},
  Set<String> requiredSubtypes = const {},
  CreatureSize? maximumSize,
  double? maximumChallengeRating,
  Set<CreatureEnvironment> environments = const {},
  BestiaryContentOrigin? origin,
  bool? hasSwimmingSpeed,
  bool? hasFlyingSpeed,
  bool? hasSpellcasting,
  bool includeSwarms = true,
}) sync* {
  for (final creature in definitions) {
    if (allowedTypes.isNotEmpty && !allowedTypes.contains(creature.type)) {
      continue;
    }

    if (requiredSubtypes.isNotEmpty &&
        !creature.subtypes.containsAll(requiredSubtypes)) {
      continue;
    }

    if (maximumSize != null && creature.size.index > maximumSize.index) {
      continue;
    }

    if (maximumChallengeRating != null &&
        creature.challengeRating > maximumChallengeRating) {
      continue;
    }

    if (environments.isNotEmpty &&
        creature.environments.intersection(environments).isEmpty) {
      continue;
    }

    if (origin != null && creature.origin != origin) {
      continue;
    }

    if (hasSwimmingSpeed != null &&
        creature.hasSwimmingSpeed != hasSwimmingSpeed) {
      continue;
    }

    if (hasFlyingSpeed != null && creature.hasFlyingSpeed != hasFlyingSpeed) {
      continue;
    }

    if (hasSpellcasting != null &&
        creature.hasSpellcasting != hasSpellcasting) {
      continue;
    }

    if (!includeSwarms && creature.isSwarm) {
      continue;
    }

    yield creature;
  }
}

Iterable<CreatureDefinition> phbBestiaryDefinitionsWhere({
  Set<CreatureType> allowedTypes = const {},
  Set<String> requiredSubtypes = const {},
  CreatureSize? maximumSize,
  double? maximumChallengeRating,
  Set<CreatureEnvironment> environments = const {},
  BestiaryContentOrigin? origin,
  bool? hasSwimmingSpeed,
  bool? hasFlyingSpeed,
  bool? hasSpellcasting,
  bool includeSwarms = true,
}) =>
    filterBestiaryDefinitions(
      phbBestiaryDefinitions.values,
      allowedTypes: allowedTypes,
      requiredSubtypes: requiredSubtypes,
      maximumSize: maximumSize,
      maximumChallengeRating: maximumChallengeRating,
      environments: environments,
      origin: origin,
      hasSwimmingSpeed: hasSwimmingSpeed,
      hasFlyingSpeed: hasFlyingSpeed,
      hasSpellcasting: hasSpellcasting,
      includeSwarms: includeSwarms,
    );

Iterable<CreatureDefinition> eligibleWildShapeFormsFrom(
  Iterable<CreatureDefinition> definitions, {
  required double maximumChallengeRating,
  required bool allowsSwimmingSpeed,
  required bool allowsFlyingSpeed,
  required bool allowsSpellcasting,
}) =>
    filterBestiaryDefinitions(
      definitions,
      allowedTypes: const {CreatureType.beast},
      maximumChallengeRating: maximumChallengeRating,
      hasSpellcasting: allowsSpellcasting ? null : false,
      includeSwarms: false,
    ).where(
      (creature) =>
          (allowsSwimmingSpeed || !creature.hasSwimmingSpeed) &&
          (allowsFlyingSpeed || !creature.hasFlyingSpeed),
    );

Iterable<CreatureDefinition> eligibleBeastCompanionsFrom(
  Iterable<CreatureDefinition> definitions, {
  required double maximumChallengeRating,
  required CreatureSize maximumSize,
}) =>
    filterBestiaryDefinitions(
      definitions,
      allowedTypes: const {CreatureType.beast},
      maximumSize: maximumSize,
      maximumChallengeRating: maximumChallengeRating,
      includeSwarms: false,
    );

Set<String> get resolvedBestiaryReferenceIds => {
      ...phbBestiaryDefinitions.keys,
      ...phbBestiaryCreatureGroupDefinitions.keys,
    };

Set<String> get unresolvedClassBestiaryCreatureIds =>
    classRequiredBestiaryCreatureIds.difference(
      resolvedBestiaryReferenceIds,
    );
