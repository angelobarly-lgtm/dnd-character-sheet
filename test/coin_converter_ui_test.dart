import 'package:dnd_character_sheet/widgets/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const initialCoins = <String, int>{
  'MR': 1,
  'MA': 150,
  'ME': 3,
  'MO': 2,
  'MP': 1,
};

void main() {
  testWidgets(
    'tap su MO aggiunge monete senza conversione',
    (tester) async {
      Map<String, int>? savedCoins;

      await tester.pumpWidget(
        MaterialApp(
          home: ShopPage(
            coins: initialCoins,
            inventory: const [],
            onChanged: (coins, inventory) async {
              savedCoins = Map<String, int>.from(coins);
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('wallet_coin_MO')));
      await tester.pumpAndSettle();

      expect(find.text('Gestisci MO'), findsOneWidget);

      final amountField = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );

      expect(amountField, findsOneWidget);
      await tester.enterText(amountField, '5');

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(savedCoins, isNotNull);
      expect(savedCoins, {
        'MR': 1,
        'MA': 150,
        'ME': 3,
        'MO': 7,
        'MP': 1,
      });
    },
  );

  testWidgets(
    'tap su MA converte volontariamente 150 MA in 15 MO',
    (tester) async {
      Map<String, int>? savedCoins;

      await tester.pumpWidget(
        MaterialApp(
          home: ShopPage(
            coins: initialCoins,
            inventory: const [],
            onChanged: (coins, inventory) async {
              savedCoins = Map<String, int>.from(coins);
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('wallet_coin_MA')));
      await tester.pumpAndSettle();

      expect(find.text('Gestisci MA'), findsOneWidget);
      expect(find.text('Disponibili: 150 MA'), findsOneWidget);

      var dropdowns = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(DropdownButtonFormField<String>),
      );

      expect(dropdowns, findsOneWidget);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONVERTI').last);
      await tester.pumpAndSettle();

      expect(
        find.text('Quantità di MA da convertire'),
        findsOneWidget,
      );
      expect(find.textContaining('1 MP = 10 MO'), findsOneWidget);

      dropdowns = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(DropdownButtonFormField<String>),
      );

      expect(dropdowns, findsNWidgets(2));
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('MO').last);
      await tester.pumpAndSettle();

      final amountField = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );

      await tester.enterText(amountField, '150');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(savedCoins, isNotNull);
      expect(savedCoins, {
        'MR': 1,
        'MA': 0,
        'ME': 3,
        'MO': 17,
        'MP': 1,
      });
    },
  );
}
