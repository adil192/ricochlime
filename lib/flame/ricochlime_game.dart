import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/background/background.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

class RicochlimeGame extends FlameGame with
    PanDetector, TapDetector, MouseMovementDetector,
    HasCollisionDetection {
  late Player player;
  late AimGuide aimGuide;

  /// Width to height aspect ratio
  static const aspectRatio = 1 / 2;

  static const expectedWidth = 160.0;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const tilesInWidth = 10;
  static const tilesInHeight = tilesInWidth ~/ aspectRatio;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    add(Background());

    final random = Random();
    for (var y = 0; y < tilesInHeight - 8; y++) {
      for (var x = 0; x < tilesInWidth - 1; x++) {
        if (random.nextDouble() > 0.2) {
          continue;
        }
        add(
          Slime(
            position: Vector2(
              expectedWidth * x / tilesInWidth,
              expectedHeight * y / tilesInHeight,
            ),
          ),
        );
      }
    }

    aimGuide = AimGuide();
    add(aimGuide);

    player = Player();
    add(player);

    add(ScreenHitbox());
  }

  @override
  Color backgroundColor() => RicochlimePalette.grassColor;

  @override
  void onMouseMove(PointerHoverInfo info) {
    aimGuide.aim(info.eventPosition.game);
  }
  @override
  void onPanUpdate(DragUpdateInfo info) {
    aimGuide.aim(info.eventPosition.game);
  }
  @override
  void onPanEnd(DragEndInfo info) {
    aimGuide.finishAim();
  }

  @override
  void onTap() {
    player.attack();
  }
}
