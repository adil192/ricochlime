import 'package:flame/components.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum PlayerState {
  idle,
  walk,
  attack,
  dead,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<RicochlimeGame> {

  @override
  Future<void> onLoad() async {
    animations = await getAnimations();
    current = PlayerState.idle;
    await super.onLoad();

    position = gameRef.size / 2;
    width = 48;
    height = 48;
    scale = Vector2.all(3);
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    setAnimationBasedOnMovement(delta);
    position.add(delta);
  }

  void setAnimationBasedOnMovement(Vector2 delta) {
    if (delta.isZero()) {
      current = PlayerState.idle;
    } else {
      current = PlayerState.walk;
    }
  }

  Future<Map<PlayerState, SpriteAnimation>> getAnimations() async => {
    PlayerState.idle: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 2 * 48),
      ),
    ),
    PlayerState.walk: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 5 * 48),
      ),
    ),
    PlayerState.attack: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 4,
        textureSize: Vector2(48, 48),
        amount: 4,
        amountPerRow: 4,
        texturePosition: Vector2(0, 8 * 48),
      ),
    ),
    PlayerState.dead: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 3,
        textureSize: Vector2(48, 48),
        loop: false,
        amount: 3,
        amountPerRow: 3,
        texturePosition: Vector2(0, 9 * 48),
      ),
    ),
  };
}
