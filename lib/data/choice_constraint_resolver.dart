import 'character_data.dart';
import 'choice_data.dart';

/// Risolve i vincoli dinamici utilizzando le scelte già effettuate.
List<CharacterChoiceConstraint> resolveChoiceConstraints({
  required List<CharacterChoiceConstraint> constraints,
  required CharacterChoiceState choiceState,
}) {
  return constraints.map((constraint) {
    if (constraint.valueFromChoice == null) {
      return constraint;
    }

    final values = choiceState.selectedFor(
      constraint.valueFromChoice!,
    );

    return CharacterChoiceConstraint(
      key: constraint.key,
      values: values,
    );
  }).toList();
}
