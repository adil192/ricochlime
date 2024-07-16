// Adapted from https://github.com/flame-engine/flame/blob/main/examples/lib/stories/bridge_libraries/forge2d/utils/boundaries.dart

import 'package:flame_forge2d/flame_forge2d.dart';

const wallInset = 2.0;

/// Creates the [Wall]s that make up the boundaries of the world.
List<Wall> createBoundaries(
  double width,
  double height, {
  bool includeTop = true,
  bool includeBottom = true,
  bool includeLeft = true,
  bool includeRight = true,
}) {
  late final topLeft = Vector2(wallInset, wallInset);
  late final bottomRight = Vector2(width - wallInset, height - wallInset);
  late final topRight = Vector2(bottomRight.x, topLeft.y);
  late final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    if (includeTop) Wall(topLeft, topRight),
    if (includeRight) Wall(topRight, bottomRight),
    if (includeBottom) Wall(bottomRight, bottomLeft),
    if (includeLeft) Wall(bottomLeft, topLeft),
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
