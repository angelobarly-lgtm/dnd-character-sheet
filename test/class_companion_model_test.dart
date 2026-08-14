import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const companion = ClassCompanionDefinition(
    id: 'test_companion',
    name: 'Compagno di Prova',
    featureId: 'test_feature',
    minimumLevel: 3,
    allowedCreatureTypes: {'beast'},
    maximumChallengeRating: 0.25,
    maximumSize: ClassCompanionSize.medium,
    attacksPerAttackCommandByLevel: {3: 1, 11: 2},
    weaponAttackWhileCommandingAttackMinimumLevel: 5,
    attackCommandAllowsMultiattackMinimumLevel: 11,
    sharedSelfSpellMinimumLevel: 15,
    sharedSpellMaximumDistanceMeters: 9,
    commands: [
      ClassCompanionCommandDefinition(
        id: 'move',
        name: 'Muovi',
        minimumLevel: 3,
        activation: ClassCompanionCommandActivation.noAction,
        actions: {'move'},
      ),
      ClassCompanionCommandDefinition(
        id: 'advanced',
        name: 'Avanzato',
        minimumLevel: 7,
        activation: ClassCompanionCommandActivation.bonusAction,
        actions: {'help'},
      ),
    ],
  );

  test('companion progression retains the last attack value', () {
    expect(companion.attacksPerAttackCommandAtLevel(2), 0);
    expect(companion.attacksPerAttackCommandAtLevel(3), 1);
    expect(companion.attacksPerAttackCommandAtLevel(10), 1);
    expect(companion.attacksPerAttackCommandAtLevel(11), 2);
    expect(companion.attacksPerAttackCommandAtLevel(20), 2);
  });

  test('companion level gates expose commands and improvements', () {
    expect(
      companion.commandsAtLevel(3).map((command) => command.id),
      ['move'],
    );
    expect(
      companion.commandsAtLevel(7).map((command) => command.id).toSet(),
      {'move', 'advanced'},
    );
    expect(companion.commandFor('advanced')?.minimumLevel, 7);
    expect(companion.commandFor('missing'), isNull);

    expect(companion.ownerCanAttackWhileCommandingAtLevel(4), isFalse);
    expect(companion.ownerCanAttackWhileCommandingAtLevel(5), isTrue);
    expect(companion.attackCommandAllowsMultiattackAtLevel(10), isFalse);
    expect(companion.attackCommandAllowsMultiattackAtLevel(11), isTrue);
    expect(companion.sharesSelfTargetedSpellsAtLevel(14), isFalse);
    expect(companion.sharesSelfTargetedSpellsAtLevel(15), isTrue);
  });

  test('companion model remains independent from creature stat blocks', () {
    expect(companion.creatureCatalogId, 'bestiary');
    expect(companion.allowedCreatureTypes, {'beast'});
    expect(companion.maximumChallengeRating, 0.25);
    expect(companion.maximumSize, ClassCompanionSize.medium);
    expect(companion.sharedSpellMaximumDistanceMeters, 9);
  });
}
