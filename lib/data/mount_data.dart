class MountDefinition {
  final String id;
  final String name;
  final int cost;
  final String currency;
  final int speed;
  final int carryingCapacity;

  const MountDefinition({
    required this.id,
    required this.name,
    required this.cost,
    required this.currency,
    required this.speed,
    required this.carryingCapacity,
  });
}

class MountIds {
  static const camel = "camel";
  static const donkey = "donkey";
  static const mule = "mule";
  static const elephant = "elephant";
  static const horseDraft = "horse_draft";
  static const horseRiding = "horse_riding";
  static const mastiff = "mastiff";
  static const pony = "pony";
  static const warhorse = "warhorse";
}

const mountDefinitions = <String, MountDefinition>{};
