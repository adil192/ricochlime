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

  static const expectedWidth = 160.0;
  static const expectedHeight = expectedWidth * 2;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    add(Background());

    add(Slime());

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
