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

class CoinConversionResult {
  final bool success;
  final String? error;
  final Map<String, int> coins;
  final int convertedAmount;

  const CoinConversionResult({
    required this.success,
    required this.coins,
    this.error,
    this.convertedAmount = 0,
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

  /// Imposta manualmente una denominazione senza convertire le altre.
  ///
  /// È usato per bottini, ricompense, furti e correzioni decise dal DM.
  Map<String, int> setCoinAmount({
    required Map<String, int> coins,
    required String coin,
    required int amount,
  }) {
    if (!coinValuesInCopper.containsKey(coin)) {
      throw ArgumentError.value(coin, 'coin', 'Denominazione sconosciuta.');
    }
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Non può essere negativo.');
    }

    return Map<String, int>.from(coins)..[coin] = amount;
  }

  /// Aggiunge o sottrae manualmente monete da una sola denominazione.
  ///
  /// L’operazione non effettua cambi automatici e non può produrre
  /// una quantità negativa.
  Map<String, int> adjustCoinAmount({
    required Map<String, int> coins,
    required String coin,
    required int delta,
  }) {
    final current = coins[coin] ?? 0;
    return setCoinAmount(
      coins: coins,
      coin: coin,
      amount: current + delta,
    );
  }

  /// Converte volontariamente una quantità da un taglio a un altro.
  ///
  /// Non modifica le altre denominazioni e accetta soltanto conversioni
  /// che producono un numero intero di monete di destinazione.
  CoinConversionResult convertCoins({
    required Map<String, int> coins,
    required String fromCoin,
    required String toCoin,
    required int amount,
  }) {
    final unchanged = Map<String, int>.from(coins);

    final fromValue = coinValuesInCopper[fromCoin];
    final toValue = coinValuesInCopper[toCoin];

    if (fromValue == null || toValue == null) {
      return CoinConversionResult(
        success: false,
        error: 'Denominazione sconosciuta.',
        coins: unchanged,
      );
    }

    if (fromCoin == toCoin) {
      return CoinConversionResult(
        success: false,
        error: 'Scegli una denominazione diversa.',
        coins: unchanged,
      );
    }

    if (amount <= 0) {
      return CoinConversionResult(
        success: false,
        error: 'La quantità deve essere maggiore di zero.',
        coins: unchanged,
      );
    }

    final available = coins[fromCoin] ?? 0;

    if (available < amount) {
      return CoinConversionResult(
        success: false,
        error: 'Monete $fromCoin insufficienti.',
        coins: unchanged,
      );
    }

    final copperToConvert = amount * fromValue;

    if (copperToConvert % toValue != 0) {
      return CoinConversionResult(
        success: false,
        error:
            '$amount $fromCoin non possono essere convertite esattamente in $toCoin.',
        coins: unchanged,
      );
    }

    final convertedAmount = copperToConvert ~/ toValue;

    final updated = Map<String, int>.from(coins)
      ..[fromCoin] = available - amount
      ..[toCoin] = (coins[toCoin] ?? 0) + convertedAmount;

    return CoinConversionResult(
      success: true,
      coins: updated,
      convertedAmount: convertedAmount,
    );
  }

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
    int? inventoryQuantity,
    bool addToInventory = true,
  }) {
    final grantedQuantity = inventoryQuantity ?? quantity;

    if (grantedQuantity <= 0) {
      return ShopPurchaseResult(
        success: false,
        error: 'La quantità da aggiungere deve essere maggiore di zero.',
        coins: Map<String, int>.from(coins),
        inventory:
            inventory.map((entry) => Map<String, dynamic>.from(entry)).toList(),
      );
    }

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
        inventoryCopy[index]['quantity'] = currentQuantity + grantedQuantity;
        inventoryCopy[index]['name'] = itemName;
        inventoryCopy[index]['catalogId'] = catalogId;
      } else {
        inventoryCopy.add({
          'catalogId': catalogId,
          'id': itemId,
          'name': itemName,
          'quantity': grantedQuantity,
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
