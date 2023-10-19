import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:ricochlime/flame/components/background/background.dart';

class Bullet extends BodyComponent with ContactCallbacks {
  Bullet({
    required this.initialPosition,
    required this.direction,
  }): assert(direction.y < 0);

  /// Radius of the bullet.
  static const radius = 2.0;

  /// Initial speed of the bullet.
  static const speed = radius * 100;

  Vector2 initialPosition;
  Vector2 direction;

  @override
  Body createBody() {
    final shape = CircleShape()
        ..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      userData: this,
      restitution: 1,
      filter: Filter() // don't collide with other bullets
        ..categoryBits = 1 << 2
        ..maskBits = 0xFFFF & ~(1 << 2),
    );

    final velocity = direction * speed;
    final bodyDef = BodyDef(
      position: initialPosition.clone(),
      linearVelocity: velocity,
      type: BodyType.dynamic,
      fixedRotation: true,
    );

    return world.createBody(bodyDef)
        ..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (body.position.y > Background.waterThresholdPosition) {
      removeFromParent();
    }
  }

  /// The number of collisions in a row that
  /// the bullet has a horizontal velocity.
  /// 
  /// This is used to prevent the bullet from
  /// getting stuck in a horizontal velocity.
  int horizontalCollisions = 0;
  static const maxHorizontalCollisions = 50;
  /// If the ratio between the y and x components
  /// of the velocity is lower than this,
  /// we consider the velocity to be
  /// horizontal.
  /// 
  /// This is equivalent to a 1 degree angle.
  /// 
  /// Please use [isVelocityHorizontal] instead
  /// of comparing the velocity directly.
  static const horizontalVelocityRatio = 0.0524077792830412;
  @visibleForTesting
  static bool isVelocityHorizontal(Vector2 velocity) {
    if (velocity.x == 0) {
      return false;
    }
    final ratio = velocity.y / velocity.x;
    return ratio.abs() < horizontalVelocityRatio;
  }

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);
    
    final isVelocityHorizontal = Bullet.isVelocityHorizontal(
      body.linearVelocity,
    );
    if (isVelocityHorizontal) {
      horizontalCollisions += 1;
    } else {
      horizontalCollisions = 0;
    }

    if (horizontalCollisions >= maxHorizontalCollisions) {
      body.linearVelocity.y += speed * horizontalVelocityRatio;
    }
  }
}
