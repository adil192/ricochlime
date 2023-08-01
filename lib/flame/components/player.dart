import 'package:flame/components.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum PlayerState {
  idle,
  moveRight,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<RicochlimeGame> {

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.idle: await gameRef.loadSpriteAnimation(
        'player.png',
        SpriteAnimationData.sequenced(
          stepTime: 1 / 6,
          textureSize: Vector2(48, 48),
          amount: 6,
          amountPerRow: 6,
        ),
      ),
      PlayerState.moveRight: await gameRef.loadSpriteAnimation(
        'player.png',
        SpriteAnimationData.sequenced(
          stepTime: 1 / 6,
          textureSize: Vector2(48, 48),
          amount: 6,
          amountPerRow: 6,
          texturePosition: Vector2(0, 4 * 48),
        ),
      ),
    };
    current = PlayerState.idle;
    await super.onLoad();

    position = gameRef.size / 2;
    width = 48;
    height = 48;
    scale = Vector2.all(3);
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    if (delta.x != 0) {
      scale.x = delta.x.sign * scale.x.abs();
      current = PlayerState.moveRight;
    } else {
      current = PlayerState.idle;
    }

    position.add(delta);
  }
}
