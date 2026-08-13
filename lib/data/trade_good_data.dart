enum TradeGoodUnit {
  halfKilogram,
  animal,
  fabricSquare90Cm,
}

class TradeGoodPrice {
  final int amount;
  final String currency;

  const TradeGoodPrice({
    required this.amount,
    required this.currency,
  })  : assert(amount >= 0),
        assert(
          currency == 'cp' ||
              currency == 'sp' ||
              currency == 'ep' ||
              currency == 'gp' ||
              currency == 'pp',
        );
}

class TradeGoodDefinition {
  final String id;
  final String name;
  final TradeGoodPrice price;
  final TradeGoodUnit unit;

  const TradeGoodDefinition({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
  });
}

class TradeGoodIds {
  static const grain = 'grain';
  static const flour = 'flour';
  static const chicken = 'chicken';
  static const salt = 'salt';
  static const iron = 'iron';
  static const canvas = 'canvas';
  static const copper = 'copper';
  static const cotton = 'cotton';
  static const ginger = 'ginger';
  static const goat = 'goat';
  static const pepper = 'pepper';
  static const cinnamon = 'cinnamon';
  static const sheep = 'sheep';
  static const cloves = 'cloves';
  static const pig = 'pig';
  static const silver = 'silver';
  static const linen = 'linen';
  static const silk = 'silk';
  static const cow = 'cow';
  static const saffron = 'saffron';
  static const ox = 'ox';
  static const gold = 'gold';
  static const platinum = 'platinum';
}

const tradeGoodDefinitions = <String, TradeGoodDefinition>{
  TradeGoodIds.grain: TradeGoodDefinition(
    id: TradeGoodIds.grain,
    name: 'Grano',
    price: TradeGoodPrice(amount: 1, currency: 'cp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.flour: TradeGoodDefinition(
    id: TradeGoodIds.flour,
    name: 'Farina',
    price: TradeGoodPrice(amount: 2, currency: 'cp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.chicken: TradeGoodDefinition(
    id: TradeGoodIds.chicken,
    name: 'Pollo',
    price: TradeGoodPrice(amount: 2, currency: 'cp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.salt: TradeGoodDefinition(
    id: TradeGoodIds.salt,
    name: 'Sale',
    price: TradeGoodPrice(amount: 5, currency: 'cp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.iron: TradeGoodDefinition(
    id: TradeGoodIds.iron,
    name: 'Ferro',
    price: TradeGoodPrice(amount: 1, currency: 'sp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.canvas: TradeGoodDefinition(
    id: TradeGoodIds.canvas,
    name: 'Tela',
    price: TradeGoodPrice(amount: 1, currency: 'sp'),
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.copper: TradeGoodDefinition(
    id: TradeGoodIds.copper,
    name: 'Rame',
    price: TradeGoodPrice(amount: 5, currency: 'sp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.cotton: TradeGoodDefinition(
    id: TradeGoodIds.cotton,
    name: 'Cotone',
    price: TradeGoodPrice(amount: 5, currency: 'sp'),
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.ginger: TradeGoodDefinition(
    id: TradeGoodIds.ginger,
    name: 'Zenzero',
    price: TradeGoodPrice(amount: 1, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.goat: TradeGoodDefinition(
    id: TradeGoodIds.goat,
    name: 'Capra',
    price: TradeGoodPrice(amount: 1, currency: 'gp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.pepper: TradeGoodDefinition(
    id: TradeGoodIds.pepper,
    name: 'Pepe',
    price: TradeGoodPrice(amount: 2, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.cinnamon: TradeGoodDefinition(
    id: TradeGoodIds.cinnamon,
    name: 'Cannella',
    price: TradeGoodPrice(amount: 2, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.sheep: TradeGoodDefinition(
    id: TradeGoodIds.sheep,
    name: 'Pecora',
    price: TradeGoodPrice(amount: 2, currency: 'gp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.cloves: TradeGoodDefinition(
    id: TradeGoodIds.cloves,
    name: 'Chiodi di Garofano',
    price: TradeGoodPrice(amount: 3, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.pig: TradeGoodDefinition(
    id: TradeGoodIds.pig,
    name: 'Maiale',
    price: TradeGoodPrice(amount: 3, currency: 'gp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.silver: TradeGoodDefinition(
    id: TradeGoodIds.silver,
    name: 'Argento',
    price: TradeGoodPrice(amount: 5, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.linen: TradeGoodDefinition(
    id: TradeGoodIds.linen,
    name: 'Lino',
    price: TradeGoodPrice(amount: 5, currency: 'gp'),
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.silk: TradeGoodDefinition(
    id: TradeGoodIds.silk,
    name: 'Seta',
    price: TradeGoodPrice(amount: 10, currency: 'gp'),
    unit: TradeGoodUnit.fabricSquare90Cm,
  ),
  TradeGoodIds.cow: TradeGoodDefinition(
    id: TradeGoodIds.cow,
    name: 'Mucca',
    price: TradeGoodPrice(amount: 10, currency: 'gp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.saffron: TradeGoodDefinition(
    id: TradeGoodIds.saffron,
    name: 'Zafferano',
    price: TradeGoodPrice(amount: 15, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.ox: TradeGoodDefinition(
    id: TradeGoodIds.ox,
    name: 'Bue',
    price: TradeGoodPrice(amount: 15, currency: 'gp'),
    unit: TradeGoodUnit.animal,
  ),
  TradeGoodIds.gold: TradeGoodDefinition(
    id: TradeGoodIds.gold,
    name: 'Oro',
    price: TradeGoodPrice(amount: 50, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
  TradeGoodIds.platinum: TradeGoodDefinition(
    id: TradeGoodIds.platinum,
    name: 'Platino',
    price: TradeGoodPrice(amount: 500, currency: 'gp'),
    unit: TradeGoodUnit.halfKilogram,
  ),
};
