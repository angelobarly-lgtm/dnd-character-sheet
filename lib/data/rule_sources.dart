enum RuleSystem {
  dnd5e,
}

enum RuleEdition {
  edition2014,
  edition2024,
}

class RuleBookDefinition {
  final String id;

  /// Nome completo del manuale.
  final String title;

  /// Sigla breve (PHB, XGtE, TCoE...)
  final String abbreviation;

  final RuleSystem system;
  final RuleEdition edition;

  /// Manuale ufficiale Wizards of the Coast.
  final bool official;

  const RuleBookDefinition({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.system,
    required this.edition,
    this.official = true,
  });
}

abstract final class RuleBookIds {
  static const phb2014 = 'phb2014';
  static const xanathar2017 = 'xanathar2017';
  static const tasha2020 = 'tasha2020';
}

const ruleBooks = <String, RuleBookDefinition>{
  RuleBookIds.phb2014: RuleBookDefinition(
    id: RuleBookIds.phb2014,
    title: "Player's Handbook",
    abbreviation: "PHB",
    system: RuleSystem.dnd5e,
    edition: RuleEdition.edition2014,
  ),
  RuleBookIds.xanathar2017: RuleBookDefinition(
    id: RuleBookIds.xanathar2017,
    title: "Xanathar's Guide to Everything",
    abbreviation: "XGtE",
    system: RuleSystem.dnd5e,
    edition: RuleEdition.edition2014,
  ),
  RuleBookIds.tasha2020: RuleBookDefinition(
    id: RuleBookIds.tasha2020,
    title: "Tasha's Cauldron of Everything",
    abbreviation: "TCoE",
    system: RuleSystem.dnd5e,
    edition: RuleEdition.edition2014,
  ),
};
