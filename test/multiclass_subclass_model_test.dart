import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const scores = <String, int>{
  'FOR': 13,
  'DES': 14,
  'COS': 12,
  'INT': 14,
  'SAG': 13,
  'CAR': 10,
};

void main() {
  test('ogni classe conserva la propria sottoclasse', () {
    final hero = HeroData(
      name: 'Sottoclassi',
      classId: ClassIds.monk,
      level: 7,
      classLevels: const {
        ClassIds.monk: 4,
        ClassIds.wizard: 3,
      },
      classSubclasses: const {
        ClassIds.monk: 'open_hand',
        ClassIds.wizard: 'evocation',
      },
      classSubclassOptionIds: const {
        ClassIds.monk: ['open_hand_technique'],
        ClassIds.wizard: ['sculpt_spells'],
      },
      baseScores: scores,
    );

    expect(hero.subclassForClass(ClassIds.monk), 'open_hand');
    expect(hero.subclassForClass(ClassIds.wizard), 'evocation');
    expect(
      hero.subclassOptionsForClass(ClassIds.monk),
      ['open_hand_technique'],
    );
    expect(
      hero.subclassOptionsForClass(ClassIds.wizard),
      ['sculpt_spells'],
    );
  });

  test('campi legacy restano validi per la classe principale', () {
    final hero = HeroData(
      name: 'Legacy',
      classId: ClassIds.monk,
      level: 3,
      subclass: 'shadow',
      subclassOptionIds: const ['shadow_arts'],
      baseScores: scores,
    );

    expect(hero.subclassForClass(ClassIds.monk), 'shadow');
    expect(
      hero.subclassOptionsForClass(ClassIds.monk),
      ['shadow_arts'],
    );
    expect(hero.subclassForClass(ClassIds.wizard), isNull);
  });

  test('JSON conserva sottoclassi e opzioni separate', () {
    final original = HeroData(
      name: 'Round trip',
      classId: ClassIds.monk,
      level: 7,
      classLevels: const {
        ClassIds.monk: 4,
        ClassIds.wizard: 3,
      },
      classSubclasses: const {
        ClassIds.monk: 'open_hand',
        ClassIds.wizard: 'evocation',
      },
      classSubclassOptionIds: const {
        ClassIds.monk: ['open_hand_technique'],
        ClassIds.wizard: ['sculpt_spells'],
      },
      baseScores: scores,
    );

    final restored = HeroData.fromJson(original.toJson());

    expect(restored.classSubclasses, {
      ClassIds.monk: 'open_hand',
      ClassIds.wizard: 'evocation',
    });
    expect(restored.classSubclassOptionIds, {
      ClassIds.monk: ['open_hand_technique'],
      ClassIds.wizard: ['sculpt_spells'],
    });
  });

  test('JSON legacy migra la sottoclasse principale', () {
    final source = HeroData(
      name: 'Vecchio',
      classId: ClassIds.monk,
      level: 3,
      subclass: 'shadow',
      subclassOptionIds: const ['shadow_arts'],
      baseScores: scores,
    );

    final legacyJson = Map<String, dynamic>.from(source.toJson())
      ..remove('classSubclasses')
      ..remove('classSubclassOptionIds');

    final restored = HeroData.fromJson(legacyJson);

    expect(restored.classSubclasses, isEmpty);
    expect(restored.classSubclassOptionIds, isEmpty);
    expect(restored.subclassForClass(ClassIds.monk), 'shadow');
    expect(
      restored.subclassOptionsForClass(ClassIds.monk),
      ['shadow_arts'],
    );
  });
}
