import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

void main() {
  group('Slime priority', () {
    test('at top should be -100', () {
      expect(Slime.getPriorityFromPosition(Vector2(0, 0)), -100);
    });
    test('at bottom should be 0', () {
      expect(Slime.getPriorityFromPosition(
        Vector2(0, RicochlimeGame.expectedHeight)), 0);
    });
  });
}
