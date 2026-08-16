import 'package:dnd_character_sheet/main.dart';
import 'package:flutter_test/flutter_test.dart';

const officialSheetBaseScores = <String, int>{
  'FOR': 10,
  'DES': 16,
  'COS': 14,
  'INT': 12,
  'SAG': 15,
  'CAR': 8,
};

void main() {
  test('official character sheet fields survive serialization', () {
    final hero = HeroData(
      name: 'Kael',
      baseScores: officialSheetBaseScores,
      background: 'Eremita',
      playerName: 'Giocatore',
      alignment: 'Legale Buono',
      experiencePoints: 6500,
      personalityTraits: 'Riflette prima di parlare.',
      ideals: 'La conoscenza deve essere condivisa.',
      bonds: 'Protegge i suoi compagni.',
      flaws: 'Si assume troppi rischi.',
      age: '28',
      height: '1,82 m',
      weight: '76 kg',
      eyes: 'Verdi',
      skin: 'Olivastra',
      hair: 'Neri',
      appearance: 'Indossa abiti da viaggio consumati.',
      alliesAndOrganizations: 'Monastero della Via Aperta',
      additionalTreasure: 'Un medaglione di famiglia.',
      story: 'Kael ha lasciato il monastero per cercare suo fratello.',
      notes: 'Promessa fatta al maestro.',
      knownSpellIds: const ['fire_bolt', 'magic_missile'],
      preparedSpellIds: const ['magic_missile'],
      spellbookSpellIds: const ['shield'],
      spellSlots: const {'1': 2},
    );

    final restored = HeroData.fromJson(hero.toJson());

    expect(restored.name, 'Kael');
    expect(restored.playerName, 'Giocatore');
    expect(restored.alignment, 'Legale Buono');
    expect(restored.experiencePoints, 6500);
    expect(restored.personalityTraits, 'Riflette prima di parlare.');
    expect(restored.ideals, 'La conoscenza deve essere condivisa.');
    expect(restored.bonds, 'Protegge i suoi compagni.');
    expect(restored.flaws, 'Si assume troppi rischi.');
    expect(restored.age, '28');
    expect(restored.height, '1,82 m');
    expect(restored.weight, '76 kg');
    expect(restored.eyes, 'Verdi');
    expect(restored.skin, 'Olivastra');
    expect(restored.hair, 'Neri');
    expect(
      restored.appearance,
      'Indossa abiti da viaggio consumati.',
    );
    expect(
      restored.alliesAndOrganizations,
      'Monastero della Via Aperta',
    );
    expect(
      restored.additionalTreasure,
      'Un medaglione di famiglia.',
    );
    expect(
      restored.story,
      'Kael ha lasciato il monastero per cercare suo fratello.',
    );
    expect(restored.notes, 'Promessa fatta al maestro.');
    expect(restored.knownSpellIds, ['fire_bolt', 'magic_missile']);
    expect(restored.preparedSpellIds, ['magic_missile']);
    expect(restored.spellbookSpellIds, ['shield']);
    expect(restored.spellSlots, {'1': 2});
  });

  test('legacy character saves receive safe official-sheet defaults', () {
    final hero = HeroData.fromJson({
      'name': 'Kael legacy',
      'baseScores': officialSheetBaseScores,
      'background': 'Soldato',
      'currentHp': 7,
      'deathSuccess': 2,
      'deathFail': 1,
    });

    expect(hero.playerName, isEmpty);
    expect(hero.alignment, 'Neutrale');
    expect(hero.experiencePoints, 0);
    expect(hero.personalityTraits, isEmpty);
    expect(hero.ideals, isEmpty);
    expect(hero.bonds, isEmpty);
    expect(hero.flaws, isEmpty);
    expect(hero.appearance, isEmpty);
    expect(hero.alliesAndOrganizations, isEmpty);
    expect(hero.additionalTreasure, isEmpty);

    expect(hero.currentHp, 7);
    expect(hero.deathSuccess, 2);
    expect(hero.deathFail, 1);
  });

  test('official sheet data does not replace existing gameplay data', () {
    final hero = HeroData(
      name: 'Kael',
      baseScores: officialSheetBaseScores,
      level: 5,
      currentHp: 21,
      tempHp: 4,
      ki: 3,
      deathSuccess: 1,
      deathFail: 2,
      inventory: const [
        {
          'id': 'rope',
          'name': 'Corda',
          'quantity': 1,
        },
      ],
      personalityTraits: 'Calmo.',
    );

    final restored = HeroData.fromJson(hero.toJson());

    expect(restored.level, 5);
    expect(restored.currentHp, 21);
    expect(restored.tempHp, 4);
    expect(restored.ki, 3);
    expect(restored.deathSuccess, 1);
    expect(restored.deathFail, 2);
    expect(restored.inventory, hasLength(1));
    expect(restored.personalityTraits, 'Calmo.');
  });
}
