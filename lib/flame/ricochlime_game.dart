import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:ricochlime/flame/components/player.dart';

class RicochlimeGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      Player()
        ..position = size / 2
        ..width = 50
        ..height = 100
        ..anchor = Anchor.center,
    );
  }
}
