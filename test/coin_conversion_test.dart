import 'package:dnd_character_sheet/services/shop_transaction_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = ShopTransactionService();

  const baseCoins = <String, int>{
    'MR': 0,
    'MA': 150,
    'ME': 0,
    'MO': 0,
    'MP': 0,
  };

  test('150 MA diventano 15 MO', () {
    final before = service.totalCopper(baseCoins);

    final result = service.convertCoins(
      coins: baseCoins,
      fromCoin: 'MA',
      toCoin: 'MO',
      amount: 150,
    );

    expect(result.success, isTrue);
    expect(result.error, isNull);
    expect(result.convertedAmount, 15);
    expect(result.coins['MA'], 0);
    expect(result.coins['MO'], 15);
    expect(service.totalCopper(result.coins), before);
  });

  test('150 MA diventano 1500 MR', () {
    final result = service.convertCoins(
      coins: baseCoins,
      fromCoin: 'MA',
      toCoin: 'MR',
      amount: 150,
    );

    expect(result.success, isTrue);
    expect(result.convertedAmount, 1500);
    expect(result.coins['MA'], 0);
    expect(result.coins['MR'], 1500);
  });

  test('3 MO diventano 6 ME', () {
    final result = service.convertCoins(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 3,
        'MP': 0,
      },
      fromCoin: 'MO',
      toCoin: 'ME',
      amount: 3,
    );

    expect(result.success, isTrue);
    expect(result.convertedAmount, 6);
    expect(result.coins['MO'], 0);
    expect(result.coins['ME'], 6);
  });

  test('1 MP diventa 1000 MR', () {
    final result = service.convertCoins(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 0,
        'MP': 1,
      },
      fromCoin: 'MP',
      toCoin: 'MR',
      amount: 1,
    );

    expect(result.success, isTrue);
    expect(result.convertedAmount, 1000);
    expect(result.coins['MP'], 0);
    expect(result.coins['MR'], 1000);
  });

  test('conversione non intera viene rifiutata senza modifiche', () {
    const coins = <String, int>{
      'MR': 0,
      'MA': 1,
      'ME': 0,
      'MO': 0,
      'MP': 0,
    };

    final result = service.convertCoins(
      coins: coins,
      fromCoin: 'MA',
      toCoin: 'MO',
      amount: 1,
    );

    expect(result.success, isFalse);
    expect(result.error, contains('esattamente'));
    expect(result.coins, coins);
  });

  test('fondi insufficienti vengono rifiutati senza modifiche', () {
    const coins = <String, int>{
      'MR': 0,
      'MA': 10,
      'ME': 0,
      'MO': 0,
      'MP': 0,
    };

    final result = service.convertCoins(
      coins: coins,
      fromCoin: 'MA',
      toCoin: 'MO',
      amount: 20,
    );

    expect(result.success, isFalse);
    expect(result.error, contains('insufficienti'));
    expect(result.coins, coins);
  });

  test('aggiungere monete non converte gli altri tagli', () {
    final result = service.adjustCoinAmount(
      coins: baseCoins,
      coin: 'MO',
      delta: 7,
    );

    expect(result['MA'], 150);
    expect(result['MO'], 7);
    expect(result['MR'], 0);
    expect(result['ME'], 0);
    expect(result['MP'], 0);
  });
}
