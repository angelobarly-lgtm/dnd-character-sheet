import 'package:dnd_character_sheet/data/class_catalog_data.dart';
import 'package:dnd_character_sheet/data/class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const conversion = ClassResourceConversionDefinition(
    id: 'conversion',
    name: 'Conversione',
    minimumLevel: 2,
    resourceId: 'points',
    activation: ClassFeatureActivation.bonusAction,
    resourceCostBySpellSlotLevel: {1: 2, 2: 3},
    maximumCreatedSpellSlotLevel: 2,
  );

  const scalableUsage = ClassResourceUsageDefinition(
    id: 'usage',
    content: RuleContent(
      id: 'usage',
      name: 'Uso',
      type: RuleContentType.classFeature,
      description: RuleDescription(summary: 'Uso.', details: 'Uso di prova.'),
    ),
    minimumLevel: 3,
    resourceId: 'points',
    baseResourceCost: 1,
    costScaling: ClassResourceCostScaling.spellLevelMinimumOne,
    activation: ClassFeatureActivation.whenCasting,
  );

  const table = ClassRandomTableDefinition(
    id: 'table',
    content: RuleContent(
      id: 'table',
      name: 'Tabella',
      type: RuleContentType.classFeature,
      description: RuleDescription(
        summary: 'Tabella.',
        details: 'Tabella di prova.',
      ),
    ),
    minimumLevel: 1,
    dieSides: 4,
    entries: [
      ClassRandomTableEntryDefinition(
        id: 'low',
        minimumRoll: 1,
        maximumRoll: 2,
        description: 'Basso',
        spellIds: {'spell'},
        creatureIds: {'creature'},
      ),
      ClassRandomTableEntryDefinition(
        id: 'high',
        minimumRoll: 3,
        maximumRoll: 4,
        description: 'Alto',
      ),
    ],
  );

  test('resource conversion supports both directions and slot limits', () {
    expect(conversion.resourceCostForSpellSlotLevel(1), 2);
    expect(conversion.resourceCostForSpellSlotLevel(2), 3);
    expect(conversion.resourceCostForSpellSlotLevel(3), isNull);
    expect(conversion.resourceGainedForExpendedSpellSlotLevel(0), 0);
    expect(conversion.resourceGainedForExpendedSpellSlotLevel(4), 4);
    expect(conversion.canCreateSpellSlotLevel(2), isTrue);
    expect(conversion.canCreateSpellSlotLevel(3), isFalse);
  });

  test('resource usage can scale its cost from spell level', () {
    expect(scalableUsage.resourceCostForSpellLevel(0), 1);
    expect(scalableUsage.resourceCostForSpellLevel(1), 1);
    expect(scalableUsage.resourceCostForSpellLevel(5), 5);
  });

  test('random table resolves every in-range entry and rejects overflow', () {
    expect(table.entryForRoll(0), isNull);
    expect(table.entryForRoll(1)?.id, 'low');
    expect(table.entryForRoll(1)?.spellIds, {'spell'});
    expect(table.entryForRoll(1)?.creatureIds, {'creature'});
    expect(table.entryForRoll(2)?.id, 'low');
    expect(table.entryForRoll(3)?.id, 'high');
    expect(table.entryForRoll(4)?.id, 'high');
    expect(table.entryForRoll(5), isNull);
  });
}
