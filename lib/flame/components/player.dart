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
  Player()
      : super(
          removeOnFinish: {
            PlayerState.dead: true,
          },
        );

  static double staticHeight = 48;

  @override
  Future<void> onLoad() async {
    animations = getAnimations();
    current = PlayerState.idle;
    await super.onLoad();

    animationTickers![PlayerState.attack]!.onComplete = () {
      current = PlayerState.idle;
    };

    position = gameRef.size / 2 + Vector2(0, staticHeight * 0.95);
    width = staticHeight;
    height = staticHeight;
    anchor = Anchor.center;
    priority = 3;
  }

  void move(Vector2 delta) {
    setAnimationBasedOnMovement(delta);
    position.add(delta);
  }

  void attack() {
    current = PlayerState.attack;
    animationTickers![PlayerState.attack]!.reset();
  }

  void setAnimationBasedOnMovement(Vector2 delta) {
    if (delta.isZero()) {
      current = PlayerState.idle;
    } else {
      current = PlayerState.walk;
    }
  }

  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('player.png');
  }

  Map<PlayerState, SpriteAnimation> getAnimations() {
    final playerImage = gameRef.images.fromCache('player.png');
    return {
      PlayerState.idle: SpriteAnimation.fromFrameData(
        playerImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 6,
          textureSize: Vector2(48, 48),
          amount: 6,
          amountPerRow: 6,
          texturePosition: Vector2(0, 2 * 48),
        ),
      ),
      PlayerState.walk: SpriteAnimation.fromFrameData(
        playerImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 6,
          textureSize: Vector2(48, 48),
          amount: 6,
          amountPerRow: 6,
          texturePosition: Vector2(0, 5 * 48),
        ),
      ),
      PlayerState.attack: SpriteAnimation.fromFrameData(
        playerImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 6,
          textureSize: Vector2(48, 48),
          amount: 4,
          amountPerRow: 4,
          texturePosition: Vector2(0, 8 * 48),
          loop: false,
        ),
      ),
      PlayerState.dead: SpriteAnimation.fromFrameData(
        playerImage,
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
}
