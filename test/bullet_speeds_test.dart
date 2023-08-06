import 'dart:math';

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
  });
}
