import 'package:dnd_character_sheet/data/character_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/data/warlock_class_data.dart';
import 'package:dnd_character_sheet/data/weapon_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final warlock = phbClassDefinitions[ClassIds.warlock]!;
  final pactBoon = warlock.featureDefinitions[WarlockFeatureIds.pactBoon]!;
  final choice = pactBoon.choices.single;

  CharacterChoiceOptionDefinition boon(String id) =>
      choice.options.singleWhere((option) => option.id == id);

  test('Dono del Patto offers all three PHB 2014 options', () {
    expect(warlock.featuresAtLevel(3), contains(WarlockFeatureIds.pactBoon));
    expect(choice.id, WarlockChoiceIds.pactBoon);
    expect(choice.minimumSelections, 1);
    expect(choice.maximumSelections, 1);
    expect(choice.optionIds.toSet(), phbWarlockPactBoonIds);
    expect(
      choice.options.map((option) => option.id).toSet(),
      phbWarlockPactBoonIds,
    );
  });

  test('Patto della Catena grants the ritual and four special forms', () {
    final chain = boon(WarlockPactBoonIds.chain);

    expect(chain.effects.grantedSpellIds, ['find_familiar']);
    expect(spellDefinitions['find_familiar'], isNotNull);
    expect(spellDefinitions['find_familiar']!.ritual, isTrue);

    final ritual = chain.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_chain_ritual_familiar',
    );
    expect(ritual.type, CharacterRuleEffectType.spellcasting);
    expect(ritual.referenceIds, ['find_familiar']);
    expect(ritual.condition, contains('does_not_count'));

    final forms = chain.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_chain_special_forms',
    );
    expect(
      forms.referenceIds.toSet(),
      phbWarlockPactOfChainSpecialFamiliarIds,
    );
    expect(
      forms.referenceIds.toSet(),
      {'imp', 'pseudodragon', 'quasit', 'sprite'},
    );

    final attack = chain.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_chain_familiar_attack',
    );
    expect(attack.type, CharacterRuleEffectType.reaction);
    expect(attack.condition, contains('replace_one_owner_attack'));
    expect(attack.condition, contains('familiar_reaction'));
  });

  test('Patto della Lama models creation, proficiency and magic bond', () {
    final blade = boon(WarlockPactBoonIds.blade);
    final weaponChoice = blade.effects.choices.single;

    expect(weaponChoice.id, WarlockPactBoonChoiceIds.bladeForm);
    expect(weaponChoice.type, CharacterChoiceType.weapon);
    expect(weaponChoice.optionIds, phbWarlockPactBladeMeleeWeaponIds);
    expect(weaponChoice.optionIds, hasLength(28));
    expect(
      weaponChoice.optionIds.where((id) => !weaponDefinitions.containsKey(id)),
      isEmpty,
    );

    final rules = {
      for (final effect in blade.effects.ruleEffects) effect.id: effect,
    };
    expect(
      rules.keys,
      containsAll({
        'pact_of_the_blade_create_weapon',
        'pact_of_the_blade_weapon_properties',
        'pact_of_the_blade_disappearance',
        'pact_of_the_blade_bind_magic_weapon',
      }),
    );
    expect(
      rules['pact_of_the_blade_weapon_properties']!.condition,
      contains('magical'),
    );
    expect(
      rules['pact_of_the_blade_bind_magic_weapon']!.condition,
      contains('one_hour_ritual'),
    );
    expect(rules['pact_of_the_blade_disappearance']!.value, 1.5);
  });

  test('Patto del Tomo grants three cantrips from any class', () {
    final tome = boon(WarlockPactBoonIds.tome);
    final cantripChoice = tome.effects.choices.single;
    final canonicalCantrips = spellDefinitions.values
        .where((spell) => spell.level == 0)
        .map((spell) => spell.id)
        .toSet();

    expect(cantripChoice.id, WarlockPactBoonChoiceIds.tomeCantrips);
    expect(cantripChoice.type, CharacterChoiceType.cantrip);
    expect(cantripChoice.minimumSelections, 3);
    expect(cantripChoice.maximumSelections, 3);
    expect(cantripChoice.unique, isTrue);
    expect(cantripChoice.optionIds.toSet(), canonicalCantrips);
    expect(phbWarlockPactTomeCantripIds.toSet(), canonicalCantrips);

    final casting = tome.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_tome_book_of_shadows',
    );
    expect(casting.type, CharacterRuleEffectType.spellcasting);
    expect(casting.condition, contains('warlock_cantrips'));
    expect(casting.condition, contains('do_not_count'));

    final replacement = tome.effects.ruleEffects.singleWhere(
      (effect) => effect.id == 'pact_of_the_tome_replacement',
    );
    expect(replacement.condition, contains('one_hour_ceremony'));
    expect(replacement.condition, contains('short_or_long_rest'));
  });

  test('every structured boon effect has a stable unique ID', () {
    final effectIds = choice.options
        .expand((option) => option.effects.ruleEffects)
        .map((effect) => effect.id)
        .toList();

    expect(effectIds, hasLength(9));
    expect(effectIds.toSet(), hasLength(effectIds.length));
    expect(effectIds.every((id) => id.isNotEmpty), isTrue);
  });
}
