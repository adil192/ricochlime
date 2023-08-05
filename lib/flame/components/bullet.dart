import 'package:flame_forge2d/flame_forge2d.dart';

class Bullet extends BodyComponent with ContactCallbacks {
  static const radius = 2.0;

  Vector2 initialPosition;
  final double speed = radius * 200;
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

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);
    
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
}
