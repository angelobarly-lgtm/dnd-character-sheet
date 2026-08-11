class WeaponPropertyDefinition {
  final String id;
  final String name;
  final String description;

  const WeaponPropertyDefinition({
    required this.id,
    required this.name,
    required this.description,
  });
}

abstract final class WeaponPropertyIds {
  static const ammunition = 'ammunition';
  static const finesse = 'finesse';
  static const heavy = 'heavy';
  static const light = 'light';
  static const loading = 'loading';
  static const range = 'range';
  static const reach = 'reach';
  static const special = 'special';
  static const thrown = 'thrown';
  static const twoHanded = 'two_handed';
  static const versatile = 'versatile';
}

const Map<String, WeaponPropertyDefinition> weaponPropertyDefinitions = {
  WeaponPropertyIds.ammunition: WeaponPropertyDefinition(
    id: WeaponPropertyIds.ammunition,
    name: 'Munizioni',
    description:
        'Richiede munizioni appropriate. Caricare un colpo fa parte dell’attacco.',
  ),
  WeaponPropertyIds.finesse: WeaponPropertyDefinition(
    id: WeaponPropertyIds.finesse,
    name: 'Accurata',
    description:
        'Può usare Forza o Destrezza per i tiri per colpire e per i danni.',
  ),
  WeaponPropertyIds.heavy: WeaponPropertyDefinition(
    id: WeaponPropertyIds.heavy,
    name: 'Pesante',
    description:
        'Le creature Piccole subiscono svantaggio quando la utilizzano.',
  ),
  WeaponPropertyIds.light: WeaponPropertyDefinition(
    id: WeaponPropertyIds.light,
    name: 'Leggera',
    description:
        'Adatta al combattimento con due armi secondo le regole previste.',
  ),
  WeaponPropertyIds.loading: WeaponPropertyDefinition(
    id: WeaponPropertyIds.loading,
    name: 'Ricarica',
    description:
        'Può essere utilizzata una sola volta per azione, azione bonus o reazione.',
  ),
  WeaponPropertyIds.range: WeaponPropertyDefinition(
    id: WeaponPropertyIds.range,
    name: 'A Distanza',
    description: 'Possiede una gittata normale e una massima per gli attacchi.',
  ),
  WeaponPropertyIds.reach: WeaponPropertyDefinition(
    id: WeaponPropertyIds.reach,
    name: 'Portata',
    description: 'Estende la portata degli attacchi in mischia.',
  ),
  WeaponPropertyIds.special: WeaponPropertyDefinition(
    id: WeaponPropertyIds.special,
    name: 'Speciale',
    description:
        'L’arma utilizza regole particolari descritte nella relativa voce.',
  ),
  WeaponPropertyIds.thrown: WeaponPropertyDefinition(
    id: WeaponPropertyIds.thrown,
    name: 'Lancio',
    description:
        'Può essere lanciata mantenendo le normali caratteristiche dell’arma.',
  ),
  WeaponPropertyIds.twoHanded: WeaponPropertyDefinition(
    id: WeaponPropertyIds.twoHanded,
    name: 'A Due Mani',
    description: 'Richiede entrambe le mani per effettuare un attacco.',
  ),
  WeaponPropertyIds.versatile: WeaponPropertyDefinition(
    id: WeaponPropertyIds.versatile,
    name: 'Versatile',
    description: 'Infligge un danno maggiore quando impugnata con due mani.',
  ),
};
