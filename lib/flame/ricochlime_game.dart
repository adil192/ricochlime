import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/slime.dart';

class RicochlimeGame extends FlameGame
    with PanDetector, TapDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();
    add(player);

    add(Slime());
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.move(Vector2.zero());
  }

  @override
  void onTap() {
    player.attack();
  }
}
