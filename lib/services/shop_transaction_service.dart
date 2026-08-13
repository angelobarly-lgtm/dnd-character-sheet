class ShopPurchaseResult {
  final bool success;
  final String? error;
  final Map<String, int> coins;
  final List<Map<String, dynamic>> inventory;
  final int spentCopper;

  const ShopPurchaseResult({
    required this.success,
    required this.coins,
    required this.inventory,
    this.error,
    this.spentCopper = 0,
  });
}

/// Gestisce pagamenti e acquisti senza dipendere dall’interfaccia.
///
/// Le monete del personaggio usano le abbreviazioni italiane:
/// MR, MA, ME, MO e MP. I cataloghi, invece, conservano le sigle
/// internazionali cp, sp, ep, gp e pp.
class ShopTransactionService {
  const ShopTransactionService();

  static const coinValuesInCopper = <String, int>{
    'MR': 1,
    'MA': 10,
    'ME': 50,
    'MO': 100,
    'MP': 1000,
  };

  static const catalogCurrencyToHeroCoin = <String, String>{
    'cp': 'MR',
    'sp': 'MA',
    'ep': 'ME',
    'gp': 'MO',
    'pp': 'MP',
  };

  int totalCopper(Map<String, int> coins) {
    var total = 0;

    for (final entry in coinValuesInCopper.entries) {
      total += (coins[entry.key] ?? 0) * entry.value;
    }

    return total;
  }

  int priceInCopper({
    required int amount,
    required String currency,
    int quantity = 1,
  }) {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Non può essere negativo.');
    }
    if (quantity <= 0) {
      throw ArgumentError.value(
        quantity,
        'quantity',
        'Deve essere maggiore di zero.',
      );
    }

    final heroCoin = catalogCurrencyToHeroCoin[currency];
    if (heroCoin == null) {
      throw ArgumentError.value(currency, 'currency', 'Valuta sconosciuta.');
    }

    return amount * quantity * coinValuesInCopper[heroCoin]!;
  }

  bool canAfford({
    required Map<String, int> coins,
    required int amount,
    required String currency,
    int quantity = 1,
  }) =>
      totalCopper(coins) >=
      priceInCopper(
        amount: amount,
        currency: currency,
        quantity: quantity,
      );

  /// Converte un valore complessivo nella combinazione più compatta.
  ///
  /// Questo permette di usare automaticamente monete di valore maggiore
  /// e di ricevere il resto nelle denominazioni appropriate.
  Map<String, int> normalizeCopper(int copper) {
    if (copper < 0) {
      throw ArgumentError.value(copper, 'copper', 'Non può essere negativo.');
    }

    var remainder = copper;
    final normalized = <String, int>{};

    for (final coin in const ['MP', 'MO', 'ME', 'MA', 'MR']) {
      final value = coinValuesInCopper[coin]!;
      normalized[coin] = remainder ~/ value;
      remainder %= value;
    }

    return normalized;
  }

  ShopPurchaseResult purchase({
    required Map<String, int> coins,
    required List<Map<String, dynamic>> inventory,
    required String catalogId,
    required String itemId,
    required String itemName,
    required int unitCost,
    required String currency,
    int quantity = 1,
    bool addToInventory = true,
  }) {
    final inventoryCopy =
        inventory.map((entry) => Map<String, dynamic>.from(entry)).toList();

    int costCopper;

    try {
      costCopper = priceInCopper(
        amount: unitCost,
        currency: currency,
        quantity: quantity,
      );
    } on ArgumentError catch (error) {
      return ShopPurchaseResult(
        success: false,
        error: error.message?.toString() ?? 'Dati di acquisto non validi.',
        coins: Map<String, int>.from(coins),
        inventory: inventoryCopy,
      );
    }

    final availableCopper = totalCopper(coins);

    if (availableCopper < costCopper) {
      return ShopPurchaseResult(
        success: false,
        error: 'Fondi insufficienti.',
        coins: Map<String, int>.from(coins),
        inventory: inventoryCopy,
      );
    }

    if (addToInventory) {
      final index = inventoryCopy.indexWhere((entry) {
        final existingCatalog = entry['catalogId'] as String? ?? 'equipment';
        return existingCatalog == catalogId && entry['id'] == itemId;
      });

      if (index >= 0) {
        final currentQuantity =
            (inventoryCopy[index]['quantity'] as num?)?.toInt() ?? 1;
        inventoryCopy[index]['quantity'] = currentQuantity + quantity;
        inventoryCopy[index]['name'] = itemName;
        inventoryCopy[index]['catalogId'] = catalogId;
      } else {
        inventoryCopy.add({
          'catalogId': catalogId,
          'id': itemId,
          'name': itemName,
          'quantity': quantity,
          'equipped': false,
        });
      }
    }

    return ShopPurchaseResult(
      success: true,
      coins: normalizeCopper(availableCopper - costCopper),
      inventory: inventoryCopy,
      spentCopper: costCopper,
    );
  }
}
