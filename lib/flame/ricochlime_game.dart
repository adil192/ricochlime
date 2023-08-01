import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:ricochlime/flame/components/player.dart';

class RicochlimeGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player()
        ..position = size / 2
        ..width = 50
        ..height = 100
        ..anchor = Anchor.center;
    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position.add(info.delta.game);
  }
}
