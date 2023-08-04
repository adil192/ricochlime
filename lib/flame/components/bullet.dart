import 'package:flame_forge2d/flame_forge2d.dart';

class Bullet extends BodyComponent {
  static const radius = 2.0;

  Vector2 initialPosition;
  final double speed = radius * 50;
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
      density: 1.0,
      restitution: 1.0,
      filter: Filter() // don't collide with other bullets
        ..categoryBits = 1 << 2
        ..maskBits = 0xFFFF & ~(1 << 2),
    );

    final velocity = direction * speed;
    final bodyDef = BodyDef(
      position: initialPosition.clone(),
      //angle: direction.angleTo(Vector2(1, 0)),
      linearVelocity: velocity,
      type: BodyType.dynamic,
      fixedRotation: true,
      bullet: true,
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
}
