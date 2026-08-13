import 'package:dnd_character_sheet/services/shop_transaction_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = ShopTransactionService();

  test('converts all five denominations into copper pieces', () {
    expect(
      service.totalCopper({
        'MR': 5,
        'MA': 4,
        'ME': 3,
        'MO': 2,
        'MP': 1,
      }),
      1395,
    );
  });

  test('converts catalog prices and quantities correctly', () {
    expect(
      service.priceInCopper(amount: 2, currency: 'gp', quantity: 3),
      600,
    );
    expect(
      service.priceInCopper(amount: 5, currency: 'sp', quantity: 2),
      100,
    );
  });

  test('purchase subtracts the price and automatically returns change', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 2,
        'MP': 0,
      },
      inventory: const [],
      catalogId: 'equipment',
      itemId: 'backpack',
      itemName: 'Zaino',
      unitCost: 1,
      currency: 'gp',
    );

    expect(result.success, isTrue);
    expect(result.error, isNull);
    expect(result.spentCopper, 100);
    expect(result.coins, {
      'MP': 0,
      'MO': 1,
      'ME': 0,
      'MA': 0,
      'MR': 0,
    });
    expect(result.inventory.single, {
      'catalogId': 'equipment',
      'id': 'backpack',
      'name': 'Zaino',
      'quantity': 1,
      'equipped': false,
    });
  });

  test('purchase can combine denominations and return compact change', () {
    final result = service.purchase(
      coins: const {
        'MR': 5,
        'MA': 4,
        'ME': 1,
        'MO': 1,
        'MP': 0,
      },
      inventory: const [],
      catalogId: 'trade_good',
      itemId: 'saffron',
      itemName: 'Zafferano',
      unitCost: 1,
      currency: 'gp',
    );

    expect(result.success, isTrue);
    expect(result.spentCopper, 100);
    expect(result.coins, {
      'MP': 0,
      'MO': 0,
      'ME': 1,
      'MA': 4,
      'MR': 5,
    });
  });

  test('repeated purchases increment the matching inventory entry', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 10,
        'MP': 0,
      },
      inventory: const [
        {
          'catalogId': 'equipment',
          'id': 'torch',
          'name': 'Torcia',
          'quantity': 2,
          'equipped': false,
        },
      ],
      catalogId: 'equipment',
      itemId: 'torch',
      itemName: 'Torcia',
      unitCost: 1,
      currency: 'cp',
      quantity: 3,
    );

    expect(result.success, isTrue);
    expect(result.inventory.length, 1);
    expect(result.inventory.single['quantity'], 5);
  });

  test('identical item ids from different catalogs remain separate', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 10,
        'MP': 0,
      },
      inventory: const [
        {
          'catalogId': 'equipment',
          'id': 'shared_id',
          'name': 'Oggetto',
          'quantity': 1,
          'equipped': false,
        },
      ],
      catalogId: 'trade_good',
      itemId: 'shared_id',
      itemName: 'Merce',
      unitCost: 1,
      currency: 'cp',
    );

    expect(result.success, isTrue);
    expect(result.inventory.length, 2);
  });

  test('services subtract money without adding inventory entries', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 3,
        'MP': 0,
      },
      inventory: const [],
      catalogId: 'service',
      itemId: 'skilled_hireling',
      itemName: 'Gregario specializzato',
      unitCost: 2,
      currency: 'gp',
      addToInventory: false,
    );

    expect(result.success, isTrue);
    expect(result.spentCopper, 200);
    expect(result.inventory, isEmpty);
    expect(result.coins['MO'], 1);
  });

  test('insufficient funds leave coins and inventory unchanged', () {
    const coins = {
      'MR': 5,
      'MA': 0,
      'ME': 0,
      'MO': 0,
      'MP': 0,
    };
    const inventory = [
      {
        'id': 'legacy_item',
        'name': 'Oggetto legacy',
        'quantity': 1,
        'equipped': false,
      },
    ];

    final result = service.purchase(
      coins: coins,
      inventory: inventory,
      catalogId: 'equipment',
      itemId: 'backpack',
      itemName: 'Zaino',
      unitCost: 2,
      currency: 'gp',
    );

    expect(result.success, isFalse);
    expect(result.error, 'Fondi insufficienti.');
    expect(result.spentCopper, 0);
    expect(result.coins, coins);
    expect(result.inventory, inventory);
  });

  test('legacy equipment entries are recognized without catalogId', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 1,
        'MP': 0,
      },
      inventory: const [
        {
          'id': 'torch',
          'name': 'torch',
          'quantity': 1,
          'equipped': false,
        },
      ],
      catalogId: 'equipment',
      itemId: 'torch',
      itemName: 'Torcia',
      unitCost: 1,
      currency: 'cp',
    );

    expect(result.success, isTrue);
    expect(result.inventory.length, 1);
    expect(result.inventory.single['quantity'], 2);
    expect(result.inventory.single['catalogId'], 'equipment');
    expect(result.inventory.single['name'], 'Torcia');
  });
  test('manual coin editing preserves every other denomination', () {
    final updated = service.setCoinAmount(
      coins: const {
        'MR': 1,
        'MA': 2,
        'ME': 3,
        'MO': 4,
        'MP': 5,
      },
      coin: 'MO',
      amount: 12,
    );

    expect(updated, {
      'MR': 1,
      'MA': 2,
      'ME': 3,
      'MO': 12,
      'MP': 5,
    });
  });

  test('manual rewards and expenses do not normalize denominations', () {
    final rewarded = service.adjustCoinAmount(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 3,
        'MP': 0,
      },
      coin: 'MO',
      delta: 7,
    );

    final spent = service.adjustCoinAmount(
      coins: rewarded,
      coin: 'MO',
      delta: -4,
    );

    expect(rewarded['MO'], 10);
    expect(spent['MO'], 6);
    expect(spent['MA'], 0);
  });

  test('manual coin editing rejects negative balances', () {
    expect(
      () => service.adjustCoinAmount(
        coins: const {
          'MR': 0,
          'MA': 0,
          'ME': 0,
          'MO': 1,
          'MP': 0,
        },
        coin: 'MO',
        delta: -2,
      ),
      throwsArgumentError,
    );
  });
  test('bundle price and granted inventory quantity are independent', () {
    final result = service.purchase(
      coins: const {
        'MR': 0,
        'MA': 0,
        'ME': 0,
        'MO': 5,
        'MP': 0,
      },
      inventory: const [],
      catalogId: 'ammunition',
      itemId: 'arrows',
      itemName: 'Frecce',
      unitCost: 1,
      currency: 'gp',
      quantity: 2,
      inventoryQuantity: 40,
    );

    expect(result.success, isTrue);
    expect(result.spentCopper, 200);
    expect(result.inventory.single['quantity'], 40);
  });
}
