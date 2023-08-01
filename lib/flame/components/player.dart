import 'package:flame/components.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum PlayerState {
  idleForwards,
  idleRight,
  idleBackwards,
  walkForwards,
  walkRight,
  walkBackwards,
  attackForwards,
  attackRight,
  attackBackwards,
  die,
}
enum PlayerDirection {
  forwards,
  right,
  backwards,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<RicochlimeGame> {

  bool walking = false;
  bool attacking = false;
  PlayerDirection direction = PlayerDirection.forwards;

  @override
  Future<void> onLoad() async {
    animations = await getAnimations();
    current = PlayerState.idleForwards;
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
    walking = !delta.isZero();
    attacking = false;
    direction = getPlayerDirection(delta) ?? direction;
    scale.x = scale.x.abs() * (delta.x >= 0 ? 1 : -1);

    switch (direction) {
      case PlayerDirection.forwards:
        if (walking) {
          current = PlayerState.walkForwards;
        } else {
          current = PlayerState.idleForwards;
        }
        break;
      case PlayerDirection.right:
        if (walking) {
          current = PlayerState.walkRight;
        } else {
          current = PlayerState.idleRight;
        }
        break;
      case PlayerDirection.backwards:
        if (walking) {
          current = PlayerState.walkBackwards;
        } else {
          current = PlayerState.idleBackwards;
        }
        break;
    }
  }

  static PlayerDirection? getPlayerDirection(Vector2 delta) {
    if (delta.isZero()) {
      return null;
    } else if (delta.x.abs() >= delta.y.abs()) {
      return PlayerDirection.right;
    } else if (delta.y > 0) {
      return PlayerDirection.forwards;
    } else {
      return PlayerDirection.backwards;
    }
  }

  Future<Map<PlayerState, SpriteAnimation>> getAnimations() async => {
    PlayerState.idleForwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
      ),
    ),
    PlayerState.idleRight: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 1 * 48),
      ),
    ),
    PlayerState.idleBackwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 2 * 48),
      ),
    ),
    PlayerState.walkForwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 3 * 48),
      ),
    ),
    PlayerState.walkRight: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 4 * 48),
      ),
    ),
    PlayerState.walkBackwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 6,
        textureSize: Vector2(48, 48),
        amount: 6,
        amountPerRow: 6,
        texturePosition: Vector2(0, 5 * 48),
      ),
    ),
    PlayerState.attackForwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 4,
        textureSize: Vector2(48, 48),
        amount: 4,
        amountPerRow: 4,
        texturePosition: Vector2(0, 6 * 48),
      ),
    ),
    PlayerState.attackRight: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 4,
        textureSize: Vector2(48, 48),
        amount: 4,
        amountPerRow: 4,
        texturePosition: Vector2(0, 7 * 48),
      ),
    ),
    PlayerState.attackBackwards: await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        stepTime: 1 / 4,
        textureSize: Vector2(48, 48),
        amount: 4,
        amountPerRow: 4,
        texturePosition: Vector2(0, 8 * 48),
      ),
    ),
    PlayerState.die: await gameRef.loadSpriteAnimation(
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
