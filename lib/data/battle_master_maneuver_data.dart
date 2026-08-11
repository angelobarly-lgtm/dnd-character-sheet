class BattleMasterManeuverDefinition {
  final String id;
  final String name;
  final String description;

  const BattleMasterManeuverDefinition({
    required this.id,
    required this.name,
    required this.description,
  });
}

abstract final class BattleMasterManeuverIds {
  static const commandersStrike = 'commanders_strike';
  static const disarmingAttack = 'disarming_attack';
  static const distractingStrike = 'distracting_strike';
  static const evasiveFootwork = 'evasive_footwork';
  static const feintingAttack = 'feinting_attack';
  static const goadingAttack = 'goading_attack';
  static const lungingAttack = 'lunging_attack';
  static const maneuveringAttack = 'maneuvering_attack';
  static const menacingAttack = 'menacing_attack';
  static const parry = 'parry';
  static const precisionAttack = 'precision_attack';
  static const pushingAttack = 'pushing_attack';
  static const rally = 'rally';
  static const riposte = 'riposte';
  static const sweepingAttack = 'sweeping_attack';
  static const tripAttack = 'trip_attack';
}

const Map<String, BattleMasterManeuverDefinition>
    battleMasterManeuverDefinitions = {
  BattleMasterManeuverIds.commandersStrike: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.commandersStrike,
    name: 'Commander\'s Strike',
    description: '',
  ),
  BattleMasterManeuverIds.disarmingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.disarmingAttack,
    name: 'Disarming Attack',
    description: '',
  ),
  BattleMasterManeuverIds.distractingStrike: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.distractingStrike,
    name: 'Distracting Strike',
    description: '',
  ),
  BattleMasterManeuverIds.evasiveFootwork: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.evasiveFootwork,
    name: 'Evasive Footwork',
    description: '',
  ),
  BattleMasterManeuverIds.feintingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.feintingAttack,
    name: 'Feinting Attack',
    description: '',
  ),
  BattleMasterManeuverIds.goadingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.goadingAttack,
    name: 'Goading Attack',
    description: '',
  ),
  BattleMasterManeuverIds.lungingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.lungingAttack,
    name: 'Lunging Attack',
    description: '',
  ),
  BattleMasterManeuverIds.maneuveringAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.maneuveringAttack,
    name: 'Maneuvering Attack',
    description: '',
  ),
  BattleMasterManeuverIds.menacingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.menacingAttack,
    name: 'Menacing Attack',
    description: '',
  ),
  BattleMasterManeuverIds.parry: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.parry,
    name: 'Parry',
    description: '',
  ),
  BattleMasterManeuverIds.precisionAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.precisionAttack,
    name: 'Precision Attack',
    description: '',
  ),
  BattleMasterManeuverIds.pushingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.pushingAttack,
    name: 'Pushing Attack',
    description: '',
  ),
  BattleMasterManeuverIds.rally: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.rally,
    name: 'Rally',
    description: '',
  ),
  BattleMasterManeuverIds.riposte: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.riposte,
    name: 'Riposte',
    description: '',
  ),
  BattleMasterManeuverIds.sweepingAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.sweepingAttack,
    name: 'Sweeping Attack',
    description: '',
  ),
  BattleMasterManeuverIds.tripAttack: BattleMasterManeuverDefinition(
    id: BattleMasterManeuverIds.tripAttack,
    name: 'Trip Attack',
    description: '',
  ),
};
