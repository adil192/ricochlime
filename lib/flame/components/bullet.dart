import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Bullet extends PositionComponent with
    HasGameRef<RicochlimeGame> {
  static const radius = 2.0;

  late final _paint = Paint()
    ..color = const Color(0xFFFFFFFF);

  double speed = radius * 10;
  Vector2 direction;

  RaycastResult<ShapeHitbox> raycastResult = RaycastResult();

  Bullet({
    required super.position,
    required this.direction,
  }): super(
        size: Vector2.all(radius * 2),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _handleCollisions(dt);
    _moveForward(speed * dt);
  }

  void _moveForward(double distance) {
    position += direction * distance;
  }

  void _handleCollisions(double dt) {
    gameRef.collisionDetection.raycast(
      Ray2(
        origin: position,
        direction: direction,
      ),
      maxDistance: speed * dt + radius,
      out: raycastResult,
    );

    final collisionDistance = raycastResult.distance;
    final reflectionRay = raycastResult.reflectionRay;
    if (reflectionRay == null || collisionDistance == null) {
      return;
    }

    // Move the bullet to the point of collision.
    final movedForward = collisionDistance - radius;
    _moveForward(movedForward);
    // Reflect the bullet's direction.
    direction = reflectionRay.direction;
    // Move the bullet backward in new direction
    // to maintain speed. (Leave a little bit of
    // space to avoid colliding again.)
    _moveForward(-movedForward + radius / 2);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(Offset.zero, radius, _paint);
  }
}
