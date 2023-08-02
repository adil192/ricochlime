import 'package:flame/components.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum SlimeState {
  idle,
  walk,
  attack,
  hurt,
  dead,
}

class Slime extends SpriteAnimationGroupComponent<SlimeState>
    with HasGameRef<RicochlimeGame> {
  
  bool walking = false;
  bool attacking = false;

  @override
  Future<void> onLoad() async {
    animations = await getAnimations();
    current = SlimeState.idle;
    await super.onLoad();

    position = gameRef.size / 2;
    width = 32;
    height = 32;
    anchor = Anchor.center;
  }

  Future<Map<SlimeState, SpriteAnimation>> getAnimations() async => {
    SlimeState.idle: await gameRef.loadSpriteAnimation(
      'slime.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 4,
        textureSize: Vector2(32, 32),
        amount: 4,
        amountPerRow: 4,
      ),
    ),
    SlimeState.walk: await gameRef.loadSpriteAnimation(
      'slime.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(32, 32),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 1 * 32),
      ),
    ),
    SlimeState.attack: await gameRef.loadSpriteAnimation(
      'slime.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 7,
        textureSize: Vector2(32, 32),
        amount: 7,
        amountPerRow: 7,
        texturePosition: Vector2(0, 2 * 32),
      ),
    ),
    SlimeState.hurt: await gameRef.loadSpriteAnimation(
      'slime.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 3,
        textureSize: Vector2(32, 32),
        amount: 3,
        amountPerRow: 3,
        texturePosition: Vector2(0, 3 * 32),
      ),
    ),
    SlimeState.dead: await gameRef.loadSpriteAnimation(
      'slime.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 5,
        textureSize: Vector2(32, 32),
        amount: 5,
        amountPerRow: 5,
        texturePosition: Vector2(0, 4 * 32),
      ),
    ),
  };
}
