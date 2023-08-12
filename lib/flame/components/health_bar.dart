import 'dart:ui';

import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

class HealthBar extends PositionComponent {
  static const double staticWidth = 12;
  static const double staticHeight = 2;

  final int maxHp;
  int hp;

  final Paint paint;

  HealthBar({
    required this.maxHp,
    required this.hp,
    required this.paint,
  }): super(
    anchor: Anchor.topLeft,
    position: Vector2(
      (Slime.staticWidth - staticWidth) / 2,
      Slime.staticHeight * 0.2,
    ),
    size: Vector2(staticWidth, staticHeight),
    priority: 1,
  );

  Rect get backgroundRect {
    return Offset.zero & size.toSize();
  }
  Rect get foregroundRect {
    const padding = staticHeight / 4;
    return Rect.fromLTWH(
      padding,
      padding,
      (size.x - padding * 2) * hp / maxHp,
      size.y - padding * 2,
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
        ..colorFilter = this.paint.colorFilter;

    // background
    canvas.drawRect(
      backgroundRect,
      paint..color = RicochlimePalette.healthBarBackgroundColor,
    );

    // foreground
    canvas.drawRect(
      foregroundRect,
      paint..color = RicochlimePalette.healthBarForegroundColor,
    );
  }
}
