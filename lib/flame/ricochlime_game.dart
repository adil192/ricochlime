import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:ricochlime/flame/components/player.dart';

class RicochlimeGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();
    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.move(Vector2.zero());
  }
}
