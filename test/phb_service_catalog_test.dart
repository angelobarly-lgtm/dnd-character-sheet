import 'package:dnd_character_sheet/data/service_data.dart';
import 'package:flutter_test/flutter_test.dart';

const expectedServices = <String,
    ({
  ServicePricingMode mode,
  int? amount,
  String? currency,
  int? distanceMeters,
})>{
  ServiceIds.carriageWithinCity: (
    mode: ServicePricingMode.fixed,
    amount: 1,
    currency: 'cp',
    distanceMeters: null,
  ),
  ServiceIds.carriageBetweenTowns: (
    mode: ServicePricingMode.perDistance,
    amount: 2,
    currency: 'cp',
    distanceMeters: 1000,
  ),
  ServiceIds.skilledHireling: (
    mode: ServicePricingMode.perDay,
    amount: 2,
    currency: 'gp',
    distanceMeters: null,
  ),
  ServiceIds.untrainedHireling: (
    mode: ServicePricingMode.perDay,
    amount: 2,
    currency: 'sp',
    distanceMeters: null,
  ),
  ServiceIds.messenger: (
    mode: ServicePricingMode.perDistance,
    amount: 2,
    currency: 'cp',
    distanceMeters: 1500,
  ),
  ServiceIds.shipPassage: (
    mode: ServicePricingMode.perDistance,
    amount: 1,
    currency: 'sp',
    distanceMeters: 1500,
  ),
  ServiceIds.roadOrGateToll: (
    mode: ServicePricingMode.fixed,
    amount: 1,
    currency: 'cp',
    distanceMeters: null,
  ),
  ServiceIds.spellcasting: (
    mode: ServicePricingMode.dmDetermined,
    amount: null,
    currency: null,
    distanceMeters: null,
  ),
};

const expectedLodgings = <String, ({int amount, String currency})>{
  LodgingIds.squalid: (amount: 7, currency: 'cp'),
  LodgingIds.poor: (amount: 1, currency: 'sp'),
  LodgingIds.modest: (amount: 5, currency: 'sp'),
  LodgingIds.comfortable: (amount: 8, currency: 'sp'),
  LodgingIds.wealthy: (amount: 2, currency: 'gp'),
  LodgingIds.aristocratic: (amount: 4, currency: 'gp'),
};

void main() {
  test('PHB services catalog contains seven tariffs and spellcasting', () {
    expect(serviceDefinitions.keys.toSet(), expectedServices.keys.toSet());
    expect(serviceDefinitions.length, 8);
  });

  test('PHB service tariffs and calculation units are correct', () {
    final errors = <String>[];

    for (final entry in expectedServices.entries) {
      final definition = serviceDefinitions[entry.key];

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
      if (definition.pricingMode != entry.value.mode) {
        errors.add(
          '${entry.key}: modalità=${definition.pricingMode}, '
          'attesa=${entry.value.mode}',
        );
      }
      if (definition.price?.amount != entry.value.amount) {
        errors.add(
          '${entry.key}: costo=${definition.price?.amount}, '
          'atteso=${entry.value.amount}',
        );
      }
      if (definition.price?.currency != entry.value.currency) {
        errors.add(
          '${entry.key}: valuta=${definition.price?.currency}, '
          'attesa=${entry.value.currency}',
        );
      }
      if (definition.rateDistanceMeters != entry.value.distanceMeters) {
        errors.add(
          '${entry.key}: distanza=${definition.rateDistanceMeters}, '
          'attesa=${entry.value.distanceMeters}',
        );
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });

  test('lodgings are separate and always require the DM final price', () {
    expect(lodgingDefinitions.keys.toSet(), expectedLodgings.keys.toSet());
    expect(lodgingDefinitions.length, 6);

    final errors = <String>[];

    for (final entry in expectedLodgings.entries) {
      final lodging = lodgingDefinitions[entry.key];

      if (lodging == null) {
        errors.add('${entry.key}: definizione mancante');
        continue;
      }

      if (lodging.id != entry.key) {
        errors.add('${entry.key}: id=${lodging.id}');
      }
      if (lodging.name.trim().isEmpty) {
        errors.add('${entry.key}: nome vuoto');
      }
      if (!lodging.dmSetsFinalPrice) {
        errors.add('${entry.key}: prezzo DM non obbligatorio');
      }
      if (lodging.referencePrice.amount != entry.value.amount) {
        errors.add(
          '${entry.key}: riferimento=${lodging.referencePrice.amount}, '
          'atteso=${entry.value.amount}',
        );
      }
      if (lodging.referencePrice.currency != entry.value.currency) {
        errors.add(
          '${entry.key}: valuta=${lodging.referencePrice.currency}, '
          'attesa=${entry.value.currency}',
        );
      }
    }

    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}
