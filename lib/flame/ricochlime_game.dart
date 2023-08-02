import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/slime.dart';

class RicochlimeGame extends FlameGame
    with PanDetector, TapDetector, MouseMovementDetector {
  late Player player;
  late AimGuide aimGuide;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(Slime());

    aimGuide = AimGuide();
    add(aimGuide);

    player = Player();
    add(player);
  }

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
