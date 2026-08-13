enum ServicePricingMode {
  fixed,
  perDistance,
  perDay,
  dmDetermined,
}

class ServicePrice {
  final int amount;
  final String currency;

  const ServicePrice({
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

class ServiceDefinition {
  final String id;
  final String name;
  final ServicePricingMode pricingMode;

  /// Prezzo PHB. È null quando il costo deve essere stabilito dal DM.
  final ServicePrice? price;

  /// Distanza coperta da una singola applicazione della tariffa.
  ///
  /// È valorizzata esclusivamente per i servizi tariffati in base
  /// alla distanza.
  final int? rateDistanceMeters;

  const ServiceDefinition({
    required this.id,
    required this.name,
    required this.pricingMode,
    this.price,
    this.rateDistanceMeters,
  })  : assert(
          pricingMode == ServicePricingMode.dmDetermined || price != null,
        ),
        assert(
          pricingMode != ServicePricingMode.perDistance ||
              (rateDistanceMeters != null && rateDistanceMeters > 0),
        );
}

class ServiceIds {
  static const carriageWithinCity = 'carriage_within_city';
  static const carriageBetweenTowns = 'carriage_between_towns';
  static const skilledHireling = 'skilled_hireling';
  static const untrainedHireling = 'untrained_hireling';
  static const messenger = 'messenger';
  static const shipPassage = 'ship_passage';
  static const roadOrGateToll = 'road_or_gate_toll';

  /// Il PHB non impone un prezzo universale per i servizi magici.
  static const spellcasting = 'spellcasting';
}

const serviceDefinitions = <String, ServiceDefinition>{
  ServiceIds.carriageWithinCity: ServiceDefinition(
    id: ServiceIds.carriageWithinCity,
    name: 'Carrozza entro una città',
    pricingMode: ServicePricingMode.fixed,
    price: ServicePrice(amount: 1, currency: 'cp'),
  ),
  ServiceIds.carriageBetweenTowns: ServiceDefinition(
    id: ServiceIds.carriageBetweenTowns,
    name: 'Carrozza tra due città',
    pricingMode: ServicePricingMode.perDistance,
    price: ServicePrice(amount: 2, currency: 'cp'),
    rateDistanceMeters: 1000,
  ),
  ServiceIds.skilledHireling: ServiceDefinition(
    id: ServiceIds.skilledHireling,
    name: 'Gregario specializzato',
    pricingMode: ServicePricingMode.perDay,
    price: ServicePrice(amount: 2, currency: 'gp'),
  ),
  ServiceIds.untrainedHireling: ServiceDefinition(
    id: ServiceIds.untrainedHireling,
    name: 'Gregario non specializzato',
    pricingMode: ServicePricingMode.perDay,
    price: ServicePrice(amount: 2, currency: 'sp'),
  ),
  ServiceIds.messenger: ServiceDefinition(
    id: ServiceIds.messenger,
    name: 'Messaggero',
    pricingMode: ServicePricingMode.perDistance,
    price: ServicePrice(amount: 2, currency: 'cp'),
    rateDistanceMeters: 1500,
  ),
  ServiceIds.shipPassage: ServiceDefinition(
    id: ServiceIds.shipPassage,
    name: 'Passaggio su una nave',
    pricingMode: ServicePricingMode.perDistance,
    price: ServicePrice(amount: 1, currency: 'sp'),
    rateDistanceMeters: 1500,
  ),
  ServiceIds.roadOrGateToll: ServiceDefinition(
    id: ServiceIds.roadOrGateToll,
    name: 'Pedaggio stradale o di accesso',
    pricingMode: ServicePricingMode.fixed,
    price: ServicePrice(amount: 1, currency: 'cp'),
  ),
  ServiceIds.spellcasting: ServiceDefinition(
    id: ServiceIds.spellcasting,
    name: 'Servizio magico',
    pricingMode: ServicePricingMode.dmDetermined,
  ),
};

class LodgingIds {
  static const squalid = 'lodging_squalid';
  static const poor = 'lodging_poor';
  static const modest = 'lodging_modest';
  static const comfortable = 'lodging_comfortable';
  static const wealthy = 'lodging_wealthy';
  static const aristocratic = 'lodging_aristocratic';
}

/// Fascia di pernottamento in locanda.
///
/// `referencePrice` conserva esclusivamente il valore indicativo del PHB.
/// Il negozio non dovrà applicarlo automaticamente: `dmSetsFinalPrice`
/// impone di richiedere al Dungeon Master il prezzo effettivo.
class LodgingDefinition {
  final String id;
  final String name;
  final ServicePrice referencePrice;
  final bool dmSetsFinalPrice;

  const LodgingDefinition({
    required this.id,
    required this.name,
    required this.referencePrice,
    this.dmSetsFinalPrice = true,
  });
}

const lodgingDefinitions = <String, LodgingDefinition>{
  LodgingIds.squalid: LodgingDefinition(
    id: LodgingIds.squalid,
    name: 'Locanda miserabile',
    referencePrice: ServicePrice(amount: 7, currency: 'cp'),
  ),
  LodgingIds.poor: LodgingDefinition(
    id: LodgingIds.poor,
    name: 'Locanda povera',
    referencePrice: ServicePrice(amount: 1, currency: 'sp'),
  ),
  LodgingIds.modest: LodgingDefinition(
    id: LodgingIds.modest,
    name: 'Locanda modesta',
    referencePrice: ServicePrice(amount: 5, currency: 'sp'),
  ),
  LodgingIds.comfortable: LodgingDefinition(
    id: LodgingIds.comfortable,
    name: 'Locanda agiata',
    referencePrice: ServicePrice(amount: 8, currency: 'sp'),
  ),
  LodgingIds.wealthy: LodgingDefinition(
    id: LodgingIds.wealthy,
    name: 'Locanda ricca',
    referencePrice: ServicePrice(amount: 2, currency: 'gp'),
  ),
  LodgingIds.aristocratic: LodgingDefinition(
    id: LodgingIds.aristocratic,
    name: 'Locanda aristocratica',
    referencePrice: ServicePrice(amount: 4, currency: 'gp'),
  ),
};
