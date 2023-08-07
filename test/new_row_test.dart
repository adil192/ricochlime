import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

void main() {
  group('New row generation', () {
    test('At least ${RicochlimeGame.minSlimesInRow} and at most ${RicochlimeGame.maxSlimesInRow} slimes are generated', () {
      final random = Random(12);
      expect(RicochlimeGame.minSlimesInRow, lessThan(RicochlimeGame.maxSlimesInRow));

      for (var _ = 0; _ < 100; ++_) {
        final row = RicochlimeGame.createNewRow(
          random: random,
          slimeHp: 1,
        );
        final slimes = row.whereType<Slime>();
        expect(slimes.length, greaterThanOrEqualTo(RicochlimeGame.minSlimesInRow));
        expect(slimes.length, lessThanOrEqualTo(RicochlimeGame.maxSlimesInRow));
      }
    });
  });
}
