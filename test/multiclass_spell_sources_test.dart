import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/spell_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 10,
  'DES': 12,
  'COS': 14,
  'INT': 16,
  'SAG': 14,
  'CAR': 10,
};

HeroData createHero({
  Map<String, String> sources = const {},
}) =>
    HeroData(
      name: 'Incantatore multiclasse',
      baseScores: scores,
      level: 5,
      classId: ClassIds.wizard,
      classLevels: const {
        ClassIds.wizard: 3,
        ClassIds.cleric: 2,
      },
      spellClassIds: sources,
    );

SpellDefinition firstSpellFor(
  HeroData hero,
  String classId, {
  required int level,
}) {
  return hero
      .availableSpellsForClass(
        classId,
        excludeRegistered: false,
      )
      .firstWhere((spell) => spell.level == level);
}

void main() {
  group('Provenienza incantesimi multiclasse', () {
    test('elenca tutte le classi incantatrici possedute', () {
      final hero = createHero();

      expect(
        hero.activeSpellcastingClassIds,
        [ClassIds.wizard, ClassIds.cleric],
      );
    });

    test('ogni classe usa la propria caratteristica magica', () {
      final hero = createHero();

      expect(
        hero.spellcastingAbilityForClass(ClassIds.wizard),
        'INT',
      );
      expect(
        hero.spellcastingAbilityForClass(ClassIds.cleric),
        'SAG',
      );
      expect(hero.spellSaveDcForClass(ClassIds.wizard), 14);
      expect(hero.spellSaveDcForClass(ClassIds.cleric), 13);
    });

    test('livello massimo usa la singola classe non gli slot combinati', () {
      final hero = createHero();

      expect(
        hero.maximumSpellLevelForClass(ClassIds.wizard),
        2,
      );
      expect(
        hero.maximumSpellLevelForClass(ClassIds.cleric),
        1,
      );
      expect(maximumSpellSlotsForHero(hero), [4, 3, 2]);
    });

    test('Mago registra nel libro e conserva la fonte', () {
      final hero = createHero();
      final spell = firstSpellFor(
        hero,
        ClassIds.wizard,
        level: 1,
      );

      expect(
        hero.registerSpellForClass(
          requestedClassId: ClassIds.wizard,
          spellId: spell.id,
        ),
        isTrue,
      );

      expect(hero.spellbookSpellIds, contains(spell.id));
      expect(
        hero.spellcastingClassForSpell(spell.id),
        ClassIds.wizard,
      );
    });

    test('Chierico registra tra i preparati e conserva la fonte', () {
      final hero = createHero();
      final spell = firstSpellFor(
        hero,
        ClassIds.cleric,
        level: 1,
      );

      expect(
        hero.registerSpellForClass(
          requestedClassId: ClassIds.cleric,
          spellId: spell.id,
        ),
        isTrue,
      );

      expect(hero.preparedSpellIds, contains(spell.id));
      expect(
        hero.spellcastingClassForSpell(spell.id),
        ClassIds.cleric,
      );
    });

    test('non registra incantesimi di livello troppo alto', () {
      final hero = createHero();

      final highLevelSpell = spellDefinitions.values.firstWhere(
        (spell) => spell.level > 1 && spell.classIds.contains(ClassIds.cleric),
      );

      expect(
        hero.registerSpellForClass(
          requestedClassId: ClassIds.cleric,
          spellId: highLevelSpell.id,
        ),
        isFalse,
      );
    });

    test('JSON conserva la provenienza e la rimozione la elimina', () {
      final hero = createHero();
      final spell = firstSpellFor(
        hero,
        ClassIds.wizard,
        level: 1,
      );

      hero.registerSpellForClass(
        requestedClassId: ClassIds.wizard,
        spellId: spell.id,
      );

      final restored = HeroData.fromJson(hero.toJson());

      expect(
        restored.spellClassIds[spell.id],
        ClassIds.wizard,
      );

      restored.unregisterCharacterSpell(spell.id);

      expect(
        restored.effectiveCharacterSpellIds,
        isNot(contains(spell.id)),
      );
      expect(restored.spellClassIds, isNot(contains(spell.id)));
    });

    test('vecchio salvataggio deduce una fonte compatibile', () {
      final hero = createHero();
      final spell = firstSpellFor(
        hero,
        ClassIds.wizard,
        level: 1,
      );

      hero.spellbookSpellIds = [spell.id];

      expect(
        hero.spellcastingClassForSpell(spell.id),
        ClassIds.wizard,
      );
    });
  });
}
