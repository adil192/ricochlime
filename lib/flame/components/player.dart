import 'package:flame/components.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum PlayerState {
  idle,
  attack,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<RicochlimeGame> {
  Player()
      : super(
          size: Vector2(staticWidth, staticHeight),
          anchor: Anchor.center,
          priority: 3,
        ) {
    position = Vector2(
      RicochlimeGame.expectedWidth * 0.5,
      RicochlimeGame.expectedHeight * 0.75 + staticHeight * 0.5,
    );
  }

  static const staticWidth = 17.0 * 0.8;
  static const staticHeight = 23.0 * 0.8;

  double get bottomY => position.y + staticHeight;

  @override
  Future<void> onLoad() async {
    animations = getAnimations();
    current = PlayerState.idle;
    await super.onLoad();

    animationTickers![PlayerState.attack]!.onComplete = () {
      current = PlayerState.idle;
    };
  }

  void attack() {
    current = PlayerState.attack;
    animationTickers![PlayerState.attack]!.reset();
  }

  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('character_subset.png');
  }

  Map<PlayerState, SpriteAnimation> getAnimations() {
    final playerImage = gameRef.images.fromCache('character_subset.png');
    return {
      PlayerState.idle: SpriteAnimation.fromFrameData(
        playerImage,
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 1 / 2,
          textureSize: Vector2(17, 23),
          amountPerRow: 2,
          texturePosition: Vector2(0, 0),
        ),
      ),
      PlayerState.attack: SpriteAnimation.fromFrameData(
        playerImage,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.5 / 4,
          textureSize: Vector2(17, 23),
          amountPerRow: 4,
          texturePosition: Vector2(0, 1 * 23),
          loop: false,
        ),
      ),
    };
  }
}
