import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/components/bullet.dart';

void main() {
  group('Bullet speeds:', () {
    test('Speed should be higher than radius', () {
      expect(Bullet.speed, greaterThan(Bullet.radius));
    });

    test('Horizontal velocity should be 3 degrees or less', () {
      const maxHorizontalAngle = 3 * pi / 180;
      final unitDir = Vector2(cos(maxHorizontalAngle), sin(maxHorizontalAngle));
      final ratio = unitDir.y / unitDir.x;
      expect(ratio, lessThan(1), reason: 'Expect this velocity to be mostly horizontal');
      expect(ratio, moreOrLessEquals(Bullet.horizontalVelocityRatio, epsilon: 0.0001));
    });
  });
}
