import 'package:dnd_character_sheet/data/armor_data.dart';
import 'package:dnd_character_sheet/data/class_registry_data.dart';
import 'package:dnd_character_sheet/data/feat_data.dart';
import 'package:dnd_character_sheet/data/race_data.dart';
import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const baseScores = <String, int>{
  'FOR': 12,
  'DES': 14,
  'COS': 16,
  'INT': 10,
  'SAG': 14,
  'CAR': 10,
};

Map<String, dynamic> equippedArmor(String id) => {
      'id': id,
      'name': id,
      'catalogId': 'armor',
      'quantity': 1,
      'equipped': true,
    };

HeroData createHero({
  String classId = ClassIds.fighter,
  int level = 1,
  String raceId = RaceIds.human,
  String? subraceId,
  String? subclass,
  String? feat,
  Map<String, int> scores = baseScores,
  Map<String, List<String>> classChoices = const {},
  List<Map<String, dynamic>> inventory = const [],
}) =>
    HeroData(
      name: 'Test',
      classId: classId,
      level: level,
      raceId: raceId,
      subraceId: subraceId,
      subclass: subclass,
      feat: feat,
      baseScores: scores,
      classChoices: classChoices,
      inventory: inventory,
    );

void main() {
  group('Classe Armatura PHB 2014', () {
    test('personaggio normale senza armatura usa 10 + DES', () {
      final hero = createHero();
      expect(hero.ac, 12);
    });

    test('Monaco senza armatura e scudo usa DES + SAG', () {
      final hero = createHero(
        classId: ClassIds.monk,
        scores: const {
          'FOR': 10,
          'DES': 16,
          'COS': 14,
          'INT': 10,
          'SAG': 14,
          'CAR': 8,
        },
      );

      expect(hero.ac, 15);
    });

    test('Barbaro senza armatura usa DES + COS', () {
      final hero = createHero(
        classId: ClassIds.barbarian,
      );

      expect(hero.ac, 15);
    });

    test('Stirpe Draconica senza armatura usa 13 + DES', () {
      final hero = createHero(
        classId: ClassIds.sorcerer,
        subclass: 'draconic_bloodline',
      );

      expect(hero.ac, 15);
    });

    test('armatura leggera aggiunge tutta DES', () {
      final hero = createHero(
        scores: const {
          'FOR': 10,
          'DES': 16,
          'COS': 12,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
        inventory: [
          equippedArmor(ArmorIds.leather),
        ],
      );

      expect(hero.ac, 14);
    });

    test('armatura media limita DES a +2', () {
      final hero = createHero(
        scores: const {
          'FOR': 10,
          'DES': 16,
          'COS': 12,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
        inventory: [
          equippedArmor(ArmorIds.scaleMail),
        ],
      );

      expect(hero.ac, 16);
    });

    test('Maestro Armature Medie porta il limite DES a +3', () {
      final hero = createHero(
        feat: FeatIds.mediumArmorMaster,
        scores: const {
          'FOR': 10,
          'DES': 16,
          'COS': 12,
          'INT': 10,
          'SAG': 10,
          'CAR': 10,
        },
        inventory: [
          equippedArmor(ArmorIds.scaleMail),
        ],
      );

      expect(hero.ac, 17);
    });

    test('armatura pesante non aggiunge DES', () {
      final hero = createHero(
        inventory: [
          equippedArmor(ArmorIds.chainMail),
        ],
      );

      expect(hero.ac, 16);
    });

    test('scudo aggiunge +2 alla CA', () {
      final hero = createHero(
        inventory: [
          equippedArmor(ArmorIds.chainMail),
          equippedArmor(ArmorIds.shield),
        ],
      );

      expect(hero.ac, 18);
    });

    test('stile Difesa aggiunge +1 soltanto con armatura', () {
      final armored = createHero(
        classChoices: const {
          'fighter_fighting_style': ['defense'],
        },
        inventory: [
          equippedArmor(ArmorIds.chainMail),
        ],
      );

      final unarmored = createHero(
        classChoices: const {
          'fighter_fighting_style': ['defense'],
        },
      );

      expect(armored.ac, 17);
      expect(unarmored.ac, 12);
    });
  });

  group('Velocità razziali e di classe PHB 2014', () {
    test('ogni razza usa la propria velocità', () {
      const expected = <String, double>{
        RaceIds.dwarf: 7.5,
        RaceIds.elf: 9,
        RaceIds.halfling: 7.5,
        RaceIds.human: 9,
        RaceIds.dragonborn: 9,
        RaceIds.gnome: 7.5,
        RaceIds.halfElf: 9,
        RaceIds.halfOrc: 9,
        RaceIds.tiefling: 9,
        HumanVariantIds.variant: 9,
      };

      for (final entry in expected.entries) {
        final hero = createHero(raceId: entry.key);

        expect(
          hero.speed,
          entry.value,
          reason: 'Velocità razziale ${entry.key}',
        );
      }
    });

    test('Elfo dei Boschi ha velocità 10,5 metri', () {
      final hero = createHero(
        raceId: RaceIds.elf,
        subraceId: SubraceIds.woodElf,
      );

      expect(hero.speed, 10.5);
    });

    test('Mobile aggiunge 3 metri alla velocità razziale', () {
      final hero = createHero(
        raceId: RaceIds.human,
        feat: FeatIds.mobile,
      );

      expect(hero.speed, 12);
    });

    test('Movimento Senza Armatura appartiene soltanto al Monaco', () {
      final monk = createHero(
        classId: ClassIds.monk,
        level: 6,
      );

      final fighter = createHero(
        classId: ClassIds.fighter,
        level: 6,
      );

      expect(monk.speed, 13.5);
      expect(fighter.speed, 9);
    });

    test('armatura o scudo disattivano il bonus del Monaco', () {
      final armored = createHero(
        classId: ClassIds.monk,
        level: 6,
        inventory: [
          equippedArmor(ArmorIds.leather),
        ],
      );

      final shielded = createHero(
        classId: ClassIds.monk,
        level: 6,
        inventory: [
          equippedArmor(ArmorIds.shield),
        ],
      );

      expect(armored.speed, 9);
      expect(shielded.speed, 9);
    });

    test('Movimento Veloce appartiene al Barbaro dal livello 5', () {
      final levelFour = createHero(
        classId: ClassIds.barbarian,
        level: 4,
      );

      final levelFive = createHero(
        classId: ClassIds.barbarian,
        level: 5,
      );

      expect(levelFour.speed, 9);
      expect(levelFive.speed, 12);
    });

    test('armatura pesante rallenta se FOR è insufficiente', () {
      final human = createHero(
        raceId: RaceIds.human,
        scores: const <String, int>{
          'FOR': 10,
          'DES': 14,
          'COS': 16,
          'INT': 10,
          'SAG': 14,
          'CAR': 10,
        },
        inventory: [
          equippedArmor(ArmorIds.chainMail),
        ],
      );

      final dwarf = createHero(
        raceId: RaceIds.dwarf,
        scores: const <String, int>{
          'FOR': 10,
          'DES': 14,
          'COS': 16,
          'INT': 10,
          'SAG': 14,
          'CAR': 10,
        },
        inventory: [
          equippedArmor(ArmorIds.chainMail),
        ],
      );

      expect(human.speed, 6);
      expect(dwarf.speed, 7.5);
    });
  });

  test('armature iniziali selezionate risultano equipaggiate', () {
    var armorCases = 0;

    for (final definition in phbClassDefinitions.values) {
      for (final choice in definition.startingEquipmentChoices) {
        for (final alternative in choice.alternatives) {
          final selections = <String, List<String>>{
            classEquipmentChoiceKey(definition.id, choice.id): [
              alternative.id,
            ],
          };

          for (final itemChoice in alternative.itemChoices) {
            final options = itemChoice.optionIds.toList()..sort();
            if (options.isEmpty) continue;

            selections[classEquipmentItemChoiceKey(
              definition.id,
              choice.id,
              alternative.id,
              itemChoice.id,
            )] = itemChoice.allowDuplicates
                ? List<String>.filled(
                    itemChoice.selections,
                    options.first,
                  )
                : options.take(itemChoice.selections).toList();
          }

          final inventory = buildClassStartingInventory(
            classDefinition: definition,
            choices: selections,
          );

          for (final item in inventory.where(
            (entry) => entry['catalogId'] == 'armor',
          )) {
            armorCases++;
            expect(
              item['equipped'],
              isTrue,
              reason: '${definition.name}: ${item['id']}',
            );
          }
        }
      }
    }

    expect(armorCases, greaterThan(0));
  });
}
