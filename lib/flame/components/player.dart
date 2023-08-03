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
  static double staticHeight = 48;

  Player() : super(
    removeOnFinish: {
      PlayerState.dead: true,
    },
  );

  @override
  Future<void> onLoad() async {
    animations = await getAnimations();
    current = PlayerState.idle;
    await super.onLoad();

    final attackTicker = animationTickers![PlayerState.attack]!;
    attackTicker.onComplete = () {
      current = PlayerState.idle;
    };

    position = gameRef.size / 2 + Vector2(0, staticHeight * 0.95);
    width = staticHeight;
    height = staticHeight;
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    setAnimationBasedOnMovement(delta);
    position.add(delta);
  }

  void attack() {
    current = PlayerState.attack;
    final attackTicker = animationTickers![PlayerState.attack]!;
    attackTicker.reset();
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
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 4,
        amountPerRow: 4,
        texturePosition: Vector2(0, 8 * 48),
        loop: false,
      ),
    ),
    PlayerState.dead: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 3,
        textureSize: Vector2(48, 48),
        amount: 3,
        amountPerRow: 3,
        texturePosition: Vector2(0, 9 * 48),
        loop: false,
      ),
    ),
  };
}
