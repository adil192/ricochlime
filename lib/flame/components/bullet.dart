import 'dart:ui';

import 'package:flame/components.dart';

class Bullet extends PositionComponent {
  static const radius = 2.0;

  late final _paint = Paint()
    ..color = const Color(0xFFFFFFFF);

  double speed = radius * 50;
  Vector2 direction;

  Bullet({
    required super.position,
    required this.direction,
  }) : super(
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
    position += direction * speed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(Offset.zero, radius, _paint);
  }
}
