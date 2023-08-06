import 'package:flame_forge2d/flame_forge2d.dart';

class Bullet extends BodyComponent with ContactCallbacks {
  static const radius = 2.0;
  static const speed = radius * 200;

  Vector2 initialPosition;
  Vector2 direction;

  Bullet({
    required this.initialPosition,
    required this.direction,
  }): assert(direction.y < 0);

  @override
  Body createBody() {
    final shape = CircleShape()
        ..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      userData: this,
      restitution: 1.1,
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
    if (body.position.y > initialPosition.y) {
      removeFromParent();
    }
  }

  /// The number of collisions in a row that
  /// the bullet has a horizontal velocity.
  /// 
  /// This is used to prevent the bullet from
  /// getting stuck in a horizontal velocity.
  int horizontalCollisions = 0;
  static const horizontalVelocityThreshold = 0.01;
  static const maxHorizontalCollisions = 3;

  /// If both velocity components are below
  /// [slowVelocityThreshold], the bullet is
  /// removed from the game.
  static const slowVelocityThreshold = speed * 0.1;

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);

    final isTooSlow = body.linearVelocity.x.abs() < slowVelocityThreshold
        && body.linearVelocity.y.abs() < slowVelocityThreshold;
    if (isTooSlow) {
      removeFromParent();
      return;
    }
    
    final isVelocityHorizontal = body.linearVelocity.y.abs() < horizontalVelocityThreshold;
    if (isVelocityHorizontal) {
      horizontalCollisions += 1;
    } else {
      horizontalCollisions = 0;
    }

    if (horizontalCollisions >= maxHorizontalCollisions) {
      body.linearVelocity.y += horizontalVelocityThreshold;
    }
  }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);

    // Round the velocity to make it less chaotic and more predictable.
    body.linearVelocity.x = _round(body.linearVelocity.x, 5);
    body.linearVelocity.y = _round(body.linearVelocity.y, 5);
  }

  double _round(double value, int decimalPlaces) {
    assert(decimalPlaces >= 0);
    final multiplier = 10.0 * decimalPlaces;
    return (value * multiplier).roundToDouble() / multiplier;
  }
}
