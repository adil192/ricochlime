// Adapted from https://github.com/flame-engine/flame/blob/main/examples/lib/stories/bridge_libraries/forge2d/utils/boundaries.dart

import 'package:flame_forge2d/flame_forge2d.dart';

/// Creates the [Wall]s that make up the boundaries of the world.
List<Wall> createBoundaries(double width, double height) {
  final topLeft = Vector2.zero();
  final bottomRight = Vector2(width, height);
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(topLeft, topRight),
    Wall(topRight, bottomRight),
    Wall(bottomRight, bottomLeft),
    Wall(bottomLeft, topLeft),
  ];
}

/// A simple component to represent a wall collider;
class Wall extends BodyComponent {
  // ignore: public_member_api_docs
  Wall(this.start, this.end) {
    renderBody = false;
  }

  /// The start point of the wall.
  final Vector2 start;

  /// The end point of the wall.
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(
      shape,
    );
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
