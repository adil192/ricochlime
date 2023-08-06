import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/components/bullet.dart';

void main() {
  group('Bullet speeds:', () {
    test('Speed should be higher than radius', () {
      expect(Bullet.speed, greaterThan(Bullet.radius));
    });

    test('Slow velocity threshold should be lower than speed', () {
      expect(Bullet.slowVelocityThreshold, lessThan(Bullet.speed));

      /// Max velocity wherein both components are below threshold
      final maxSlowSpeed = sqrt(pow(Bullet.slowVelocityThreshold, 2) * 2);
      expect(maxSlowSpeed, lessThan(Bullet.speed));
    });

    test('Horizontal velocity should be 5 degrees or less', () {
      const maxHorizontalAngle = 5 * pi / 180;
      final unitDir = Vector2(cos(maxHorizontalAngle), sin(maxHorizontalAngle));
      final ratio = unitDir.y / unitDir.x;
      expect(ratio, lessThan(1), reason: 'Expect this velocity to be mostly horizontal');
      expect(ratio, moreOrLessEquals(Bullet.horizontalVelocityRatio, epsilon: 0.001));
    });
  });
}
