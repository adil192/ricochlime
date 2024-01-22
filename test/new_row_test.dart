import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/prefs.dart';

void main() {
  group('New row generation', () {
    test(
        'At least ${RicochlimeGame.minMonstersInRow} and '
        'at most ${Monster.monstersPerRow} monsters are generated', () {
      Prefs.testingMode = true;
      Prefs.init();

      final random = Random(12);
      expect(RicochlimeGame.minMonstersInRow, lessThan(Monster.monstersPerRow));

      for (var _ = 0; _ < 100; ++_) {
        final row = RicochlimeGame.createNewRow(
          random: random,
          monsterHp: 1,
        );
        final monsters = row.whereType<Monster>();
        expect(monsters.length,
            greaterThanOrEqualTo(RicochlimeGame.minMonstersInRow));
        expect(monsters.length, lessThanOrEqualTo(Monster.monstersPerRow));
      }
    });
  });

  group('Number of new rows each round', () {
    test('at score 1-49', () {
      expect(RicochlimeGame.getNumNewRowsEachRound(1), 1);
      expect(RicochlimeGame.getNumNewRowsEachRound(49), 1);
      expect(RicochlimeGame.getNumNewRowsEachRound(50), isNot(1));
    });
    test('at score 50-149', () {
      expect(RicochlimeGame.getNumNewRowsEachRound(50), 2);
      expect(RicochlimeGame.getNumNewRowsEachRound(149), 2);
      expect(RicochlimeGame.getNumNewRowsEachRound(150), isNot(2));
    });
    test('at score 150-299', () {
      expect(RicochlimeGame.getNumNewRowsEachRound(150), 3);
      expect(RicochlimeGame.getNumNewRowsEachRound(299), 3);
      expect(RicochlimeGame.getNumNewRowsEachRound(300), isNot(3));
    });
  });
}
