import 'package:dnd_character_sheet/data/trade_good_data.dart';
import 'package:flutter_test/flutter_test.dart';

const expectedTradeGoods =
    <String, ({int amount, String currency, TradeGoodUnit unit})>{
  TradeGoodIds.grain: (
    amount: 1,
    currency: 'cp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.flour: (
    amount: 2,
    currency: 'cp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.chicken: (
    amount: 2,
    currency: 'cp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.salt: (
    amount: 5,
    currency: 'cp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.iron: (
    amount: 1,
    currency: 'sp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.canvas: (
    amount: 1,
    currency: 'sp',
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.copper: (
    amount: 5,
    currency: 'sp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.cotton: (
    amount: 5,
    currency: 'sp',
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.ginger: (
    amount: 1,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.goat: (
    amount: 1,
    currency: 'gp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.pepper: (
    amount: 2,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.cinnamon: (
    amount: 2,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.sheep: (
    amount: 2,
    currency: 'gp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.cloves: (
    amount: 3,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.pig: (
    amount: 3,
    currency: 'gp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.silver: (
    amount: 5,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.linen: (
    amount: 5,
    currency: 'gp',
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.silk: (
    amount: 10,
    currency: 'gp',
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.cow: (
    amount: 10,
    currency: 'gp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.saffron: (
    amount: 15,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.ox: (
    amount: 15,
    currency: 'gp',
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.gold: (
    amount: 50,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.platinum: (
    amount: 500,
    currency: 'gp',
    unit: TradeGoodUnit.halfKilogram,
  ),
};

void main() {
  test('PHB trade goods catalog contains all 23 entries', () {
    expect(tradeGoodDefinitions.keys.toSet(), expectedTradeGoods.keys.toSet());
    expect(tradeGoodDefinitions.length, 23);
  });

  test('PHB trade goods prices and units match the manual', () {
    final errors = <String>[];

    for (final entry in expectedTradeGoods.entries) {
      final definition = tradeGoodDefinitions[entry.key];

      if (definition == null) {
        errors.add('${entry.key}: definizione mancante');
        continue;
      }

      if (definition.id != entry.key) {
        errors.add('${entry.key}: id=${definition.id}');
      }
      if (definition.name.trim().isEmpty) {
        errors.add('${entry.key}: nome vuoto');
      }
      if (definition.price.amount != entry.value.amount) {
        errors.add(
          '${entry.key}: costo=${definition.price.amount}, '
          'atteso=${entry.value.amount}',
        );
      }
      if (definition.price.currency != entry.value.currency) {
        errors.add(
          '${entry.key}: valuta=${definition.price.currency}, '
          'attesa=${entry.value.currency}',
        );
      }
      if (definition.unit != entry.value.unit) {
        errors.add(
          '${entry.key}: unità=${definition.unit}, '
          'attesa=${entry.value.unit}',
        );
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}
