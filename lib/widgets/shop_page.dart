import 'package:flutter/material.dart';

import '../data/shop_catalog.dart';
import '../services/shop_transaction_service.dart';

typedef ShopStateChanged = Future<void> Function(
  Map<String, int> coins,
  List<Map<String, dynamic>> inventory,
);

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
    required this.coins,
    required this.inventory,
    required this.onChanged,
  });

  final Map<String, int> coins;
  final List<Map<String, dynamic>> inventory;
  final ShopStateChanged onChanged;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _PurchaseRequest {
  const _PurchaseRequest({
    required this.unitCost,
    required this.currency,
    required this.units,
  });

  final int unitCost;
  final String currency;
  final int units;
}

class _ShopPageState extends State<ShopPage> {
  static const _transactions = ShopTransactionService();

  late Map<String, int> _coins;
  late List<Map<String, dynamic>> _inventory;

  final _searchController = TextEditingController();
  ShopCategory _category = ShopCategory.adventuringGear;

  @override
  void initState() {
    super.initState();
    _coins = Map<String, int>.from(widget.coins);
    _inventory = widget.inventory
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _categoryLabel(ShopCategory category) => switch (category) {
        ShopCategory.adventuringGear => 'Equipaggiamento',
        ShopCategory.ammunition => 'Munizioni',
        ShopCategory.weapons => 'Armi',
        ShopCategory.armor => 'Armature e scudi',
        ShopCategory.tools => 'Strumenti',
        ShopCategory.focuses => 'Focus',
        ShopCategory.equipmentPacks => 'Dotazioni',
        ShopCategory.mounts => 'Cavalcature',
        ShopCategory.mountGear => 'Finimenti',
        ShopCategory.vehicles => 'Veicoli',
        ShopCategory.tradeGoods => 'Merci commerciali',
        ShopCategory.services => 'Servizi',
        ShopCategory.lodging => 'Locande',
      };

  String _coinLabel(String currency) => switch (currency) {
        'cp' || 'MR' => 'MR',
        'sp' || 'MA' => 'MA',
        'ep' || 'ME' => 'ME',
        'gp' || 'MO' => 'MO',
        'pp' || 'MP' => 'MP',
        _ => currency.toUpperCase(),
      };

  String _priceLabel(ShopCatalogEntry entry) {
    switch (entry.pricingMode) {
      case ShopPricingMode.fixed:
        return '${entry.cost} ${_coinLabel(entry.currency!)}';
      case ShopPricingMode.perDay:
        return '${entry.cost} ${_coinLabel(entry.currency!)} al giorno';
      case ShopPricingMode.perDistance:
        final kilometers = (entry.rateDistanceMeters ?? 1000) / 1000;
        final distance = kilometers == kilometers.roundToDouble()
            ? kilometers.toInt().toString()
            : kilometers.toString();
        return '${entry.cost} ${_coinLabel(entry.currency!)} '
            'ogni $distance km';
      case ShopPricingMode.dmDetermined:
        if (entry.referenceCost != null) {
          return 'Prezzo deciso dal DM · riferimento PHB: '
              '${entry.referenceCost} '
              '${_coinLabel(entry.referenceCurrency!)}';
        }
        return 'Prezzo deciso dal DM';
      case ShopPricingMode.armorMultiplier:
        return 'Costo: ×${entry.costMultiplier} rispetto all’armatura scelta';
    }
  }

  List<ShopCatalogEntry> get _visibleEntries {
    final query = _searchController.text.trim().toLowerCase();

    return shopEntriesFor(_category)
        .where(
          (entry) =>
              query.isEmpty ||
              entry.name.toLowerCase().contains(query) ||
              entry.itemId.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _notifyChanged() => widget.onChanged(_coins, _inventory);

  Future<void> _editCoins() async {
    final controllers = <String, TextEditingController>{
      for (final coin in const ['MR', 'MA', 'ME', 'MO', 'MP'])
        coin: TextEditingController(text: '${_coins[coin] ?? 0}'),
    };

    String? error;

    final updated = await showDialog<Map<String, int>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifica monete'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Inserisci direttamente il denaro trovato, ricevuto, '
                  'rubato o speso. Le denominazioni non saranno convertite.',
                ),
                const SizedBox(height: 16),
                for (final coin in const ['MR', 'MA', 'ME', 'MO', 'MP'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: controllers[coin],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: coin,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('ANNULLA'),
            ),
            FilledButton(
              onPressed: () {
                var result = Map<String, int>.from(_coins);

                for (final coin in const ['MR', 'MA', 'ME', 'MO', 'MP']) {
                  final amount = int.tryParse(controllers[coin]!.text.trim());

                  if (amount == null || amount < 0) {
                    setDialogState(
                      () => error = 'Inserisci quantità intere non negative.',
                    );
                    return;
                  }

                  result = _transactions.setCoinAmount(
                    coins: result,
                    coin: coin,
                    amount: amount,
                  );
                }

                Navigator.pop(dialogContext, result);
              },
              child: const Text('SALVA'),
            ),
          ],
        ),
      ),
    );

    // showDialog completa il Future all'inizio dell'animazione di chiusura.
    // I controller devono restare validi finché la route non è scomparsa.
    await Future<void>.delayed(kThemeAnimationDuration);

    for (final controller in controllers.values) {
      controller.dispose();
    }

    if (updated == null || !mounted) {
      return;
    }

    setState(() => _coins = updated);
    await _notifyChanged();
  }

  Future<_PurchaseRequest?> _requestPurchase(
    ShopCatalogEntry entry,
  ) async {
    final quantityController = TextEditingController(text: '1');
    final customCostController = TextEditingController(
      text: entry.referenceCost?.toString() ?? '',
    );

    var selectedCurrency = entry.referenceCurrency ?? entry.currency ?? 'gp';
    String? error;

    final request = await showDialog<_PurchaseRequest>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final needsCustomPrice =
              entry.pricingMode == ShopPricingMode.dmDetermined ||
                  entry.pricingMode == ShopPricingMode.armorMultiplier;

          final quantityLabel = switch (entry.pricingMode) {
            ShopPricingMode.perDay => 'Giorni',
            ShopPricingMode.perDistance => 'Numero di tratte',
            ShopPricingMode.dmDetermined
                when entry.category == ShopCategory.lodging =>
              'Notti',
            _ => 'Quantità',
          };

          return AlertDialog(
            title: Text(entry.name),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_priceLabel(entry)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: quantityLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (entry.pricingMode == ShopPricingMode.perDistance) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Ogni tratta corrisponde a '
                      '${(entry.rateDistanceMeters ?? 1000) / 1000} km.',
                    ),
                  ],
                  if (needsCustomPrice) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: customCostController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prezzo unitario deciso dal DM',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Valuta',
                        border: OutlineInputBorder(),
                      ),
                      items: const ['cp', 'sp', 'ep', 'gp', 'pp']
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(
                                '${_currencyNames[currency]} '
                                '(${_currencySymbols[currency]})',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedCurrency = value);
                        }
                      },
                    ),
                    if (entry.pricingMode ==
                        ShopPricingMode.armorMultiplier) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Il PHB indica un costo pari a '
                        '${entry.costMultiplier} volte quello '
                        'dell’armatura scelta.',
                      ),
                    ],
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('ANNULLA'),
              ),
              FilledButton(
                onPressed: () {
                  final units = int.tryParse(quantityController.text.trim());

                  final cost = needsCustomPrice
                      ? int.tryParse(customCostController.text.trim())
                      : entry.cost;

                  if (units == null || units <= 0) {
                    setDialogState(
                      () => error = 'La quantità deve essere maggiore di zero.',
                    );
                    return;
                  }

                  if (cost == null || cost < 0) {
                    setDialogState(
                      () => error = 'Inserisci un prezzo unitario valido.',
                    );
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    _PurchaseRequest(
                      unitCost: cost,
                      currency:
                          needsCustomPrice ? selectedCurrency : entry.currency!,
                      units: units,
                    ),
                  );
                },
                child: const Text('ACQUISTA'),
              ),
            ],
          );
        },
      ),
    );

    // Mantiene validi i controller durante la chiusura animata del dialogo.
    await Future<void>.delayed(kThemeAnimationDuration);

    quantityController.dispose();
    customCostController.dispose();

    return request;
  }

  Future<void> _purchase(ShopCatalogEntry entry) async {
    final request = await _requestPurchase(entry);

    if (request == null || !mounted) {
      return;
    }

    final result = _transactions.purchase(
      coins: _coins,
      inventory: _inventory,
      catalogId: entry.catalogId,
      itemId: entry.itemId,
      itemName: entry.name,
      unitCost: request.unitCost,
      currency: request.currency,
      quantity: request.units,
      inventoryQuantity: request.units * entry.grantedQuantity,
      addToInventory: entry.addToInventory,
    );

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Acquisto non riuscito.')),
      );
      return;
    }

    setState(() {
      _coins = result.coins;
      _inventory = result.inventory;
    });

    await _notifyChanged();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entry.addToInventory
              ? '${entry.name} aggiunto all’inventario.'
              : '${entry.name} pagato.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _visibleEntries;

    return Scaffold(
      appBar: AppBar(title: const Text('Negozio')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Portamonete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _editCoins,
                        icon: const Icon(Icons.edit),
                        label: const Text('MODIFICA'),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final coin in const ['MR', 'MA', 'ME', 'MO', 'MP'])
                        Chip(label: Text('$coin ${_coins[coin] ?? 0}')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Cerca nel negozio',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ShopCategory>(
                  value: _category,
                  isExpanded: true,
                  items: ShopCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(_categoryLabel(category)),
                        ),
                      )
                      .toList(),
                  onChanged: (category) {
                    if (category != null) {
                      setState(() => _category = category);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('Nessun elemento trovato.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final entry = entries[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.shopping_bag_outlined),
                          title: Text(entry.name),
                          subtitle: Text(_priceLabel(entry)),
                          trailing: FilledButton(
                            onPressed: () => _purchase(entry),
                            child: const Text('COMPRA'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

const _currencyNames = <String, String>{
  'cp': 'Monete di rame',
  'sp': 'Monete d’argento',
  'ep': 'Monete di electrum',
  'gp': 'Monete d’oro',
  'pp': 'Monete di platino',
};

const _currencySymbols = <String, String>{
  'cp': 'MR',
  'sp': 'MA',
  'ep': 'ME',
  'gp': 'MO',
  'pp': 'MP',
};
