import 'package:dnd_character_sheet/data/shop_catalog.dart';
import 'package:dnd_character_sheet/widgets/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder textFieldWithLabel(String label) => find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == label,
    );

void main() {
  testWidgets('shop wallet can be edited manually without conversion',
      (tester) async {
    Map<String, int>? savedCoins;
    List<Map<String, dynamic>>? savedInventory;

    await tester.pumpWidget(
      MaterialApp(
        home: ShopPage(
          coins: const {
            'MR': 1,
            'MA': 2,
            'ME': 3,
            'MO': 4,
            'MP': 5,
          },
          inventory: const [],
          onChanged: (coins, inventory) async {
            savedCoins = Map<String, int>.from(coins);
            savedInventory = inventory
                .map((entry) => Map<String, dynamic>.from(entry))
                .toList();
          },
        ),
      ),
    );

    expect(find.text('Portamonete'), findsOneWidget);
    expect(find.text('MO 4'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'MODIFICA'));
    await tester.pumpAndSettle();

    expect(find.text('Modifica monete'), findsOneWidget);
    expect(textFieldWithLabel('MR'), findsOneWidget);
    expect(textFieldWithLabel('MO'), findsOneWidget);

    await tester.enterText(textFieldWithLabel('MO'), '12');
    await tester.tap(find.widgetWithText(FilledButton, 'SALVA'));
    await tester.pumpAndSettle();

    expect(savedCoins, {
      'MR': 1,
      'MA': 2,
      'ME': 3,
      'MO': 12,
      'MP': 5,
    });
    expect(savedInventory, isEmpty);
    expect(find.text('MO 12'), findsOneWidget);
  });

  testWidgets('buying an item subtracts money and updates inventory',
      (tester) async {
    Map<String, int>? savedCoins;
    List<Map<String, dynamic>>? savedInventory;

    await tester.pumpWidget(
      MaterialApp(
        home: ShopPage(
          coins: const {
            'MR': 0,
            'MA': 0,
            'ME': 0,
            'MO': 10,
            'MP': 0,
          },
          inventory: const [],
          onChanged: (coins, inventory) async {
            savedCoins = Map<String, int>.from(coins);
            savedInventory = inventory
                .map((entry) => Map<String, dynamic>.from(entry))
                .toList();
          },
        ),
      ),
    );

    await tester.enterText(
      textFieldWithLabel('Cerca nel negozio'),
      'Abaco',
    );
    await tester.pump();

    final itemTile = find.ancestor(
      of: find.text('Abaco'),
      matching: find.byType(ListTile),
    );

    expect(itemTile, findsOneWidget);

    final buyButton = find.descendant(
      of: itemTile,
      matching: find.widgetWithText(FilledButton, 'COMPRA'),
    );

    await tester.tap(buyButton);
    await tester.pumpAndSettle();

    expect(find.text('Abaco'), findsWidgets);
    expect(textFieldWithLabel('Quantità'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'ACQUISTA'));
    await tester.pumpAndSettle();

    expect(savedCoins, isNotNull);
    expect(savedInventory, isNotNull);
    expect(savedInventory, hasLength(1));
    expect(savedInventory!.single['catalogId'], 'equipment');
    expect(savedInventory!.single['id'], 'abacus');
    expect(savedInventory!.single['name'], 'Abaco');
    expect(savedInventory!.single['quantity'], 1);

    // L’Abaco costa 2 MO: da 10 MO devono rimanerne 8.
    expect(savedCoins!['MO'], 8);
    expect(find.text('MO 8'), findsOneWidget);
  });

  testWidgets('lodging is kept in a separate shop category', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShopPage(
          coins: const {
            'MR': 0,
            'MA': 0,
            'ME': 0,
            'MO': 10,
            'MP': 0,
          },
          inventory: const [],
          onChanged: (_, __) async {},
        ),
      ),
    );

    final categoryDropdown = tester.widget<DropdownButton<ShopCategory>>(
      find.byType(DropdownButton<ShopCategory>),
    );

    categoryDropdown.onChanged!(ShopCategory.lodging);
    await tester.pumpAndSettle();

    final updatedDropdown = tester.widget<DropdownButton<ShopCategory>>(
      find.byType(DropdownButton<ShopCategory>),
    );

    expect(updatedDropdown.value, ShopCategory.lodging);
    expect(find.text('Locanda agiata'), findsOneWidget);
    expect(
      find.textContaining('Prezzo deciso dal DM'),
      findsWidgets,
    );
  });
}
