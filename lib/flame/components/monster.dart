import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/health_bar.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/random_extension.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:ricochlime/utils/stows.dart';

/// The animation state of the monster.
enum MonsterState {
  /// The monster is idle.
  idle,

  /// The monster is walking.
  walk,

  /// The monster is jumping/ragdolling.
  jump,

  /// The monster is dead.
  dead,
}

enum KillReward {
  /// No reward for killing this monster
  none,

  /// Gives the player an extra bullet
  bullet,

  /// Gives the player a coin
  coin,
}

/// A monster component.
class Monster extends BodyComponent with ContactCallbacks {
  // ignore: public_member_api_docs
  Monster({
    required this.initialPosition,
    required this.maxHp,
    int? hp,
    KillReward? killReward,
  }) : _hp = hp ?? maxHp,
       super(
         paint: Paint()..color = RicochlimePalette.monsterColor,
         priority: getPriorityFromPosition(initialPosition),
         renderBody: false,
         bodyDef: BodyDef(position: initialPosition, fixedRotation: true),
       ) {
    if (killReward != null) this.killReward = killReward;

    fixtureDefs = [
      FixtureDef(
        PolygonShape()..setAsBox(5, 7, Vector2(7.5, 5), 0),
        userData: this,
      ),
    ];

    add(_animation);
    add(_healthBar);
  }

  /// Creates a Monster from JSON data.
  factory Monster.fromJson(Map<String, dynamic> json) {
    final initialPosition = Vector2(json['px'] as double, json['py'] as double);
    final maxHp = json['maxHp'] as int;
    final hp = json['hp'] as int? ?? maxHp;

    final KillReward killReward;
    if (json['killReward'] != null) {
      killReward = .values[json['killReward'] as int];
    } else if (json['givesPlayerABullet'] as bool? ?? false) {
      killReward = .bullet;
    } else {
      killReward = .none;
    }

    return Monster(
      initialPosition: initialPosition,
      maxHp: maxHp,
      hp: hp,
      killReward: killReward,
    );
  }

  /// Converts the monster's data to a JSON map.
  Map<String, dynamic> toJson() => {
    'px': (_movement?.targetPosition.x ?? position.x).roundTo1Dp(),
    'py': (_movement?.targetPosition.y ?? position.y).roundTo1Dp(),
    'maxHp': maxHp,
    if (hp != maxHp) 'hp': hp,
    if (killReward != .none) 'killReward': killReward.index,
  };

  /// How many monsters there are in each row.
  static const monstersPerRow = 8;

  /// The width of the monster.
  static const staticWidth = RicochlimeGame.expectedWidth / monstersPerRow;

  /// The height of the monster.
  static const staticHeight = staticWidth;

  /// The distance between the top of one monster
  /// and the top of the monster in the next row.
  static const moveDownHeight = MonsterAnimation.staticHeight * 0.8;

  /// The gap at the top above the first row of monsters.
  static const topGap = staticHeight;

  /// The initial position of the monster.
  ///
  /// See [position] for the current position.
  final Vector2 initialPosition;

  /// The size of the monster.
  final Vector2 size = Vector2(staticWidth, staticHeight);

  /// The maximum health.
  int maxHp;

  /// The current health.
  int get hp => _hp;
  int _hp;
  set hp(int value) {
    _hp = value;
    _healthBar.hp = value;

    if (isDead) {
      _animation.current = .dead;
      _healthBar.removeFromParent();

      if (!killRewardGiven) {
        stows.totalMonstersKilled.value += 1;
        switch (killReward) {
          case .none:
            break;
          case .bullet:
            (game as RicochlimeGame).numBullets += 1;
            stows.totalBulletsGained.value += 1;
          case .coin:
            stows.addCoins(1);
        }
        killRewardGiven = true;
      }
    }
  }

  bool get isRagdolling => _animation.current == .jump;

  bool get isDead => hp <= 0;
  bool killRewardGiven = false;

  @override
  Vector2 get position {
    if (bodyCreated) {
      return body.position;
    } else {
      return initialPosition;
    }
  }

  /// The current movement, if any
  _MonsterMovement? _movement;

  /// The animated sprite component
  late final MonsterAnimation _animation = MonsterAnimation._();

  /// The health bar component
  late final HealthBar _healthBar = HealthBar(
    maxHp: maxHp,
    hp: hp,
    paint: _animation.paint,
  );

  /// The reward for killing this monster
  KillReward get killReward => _killReward;
  KillReward _killReward = .none;
  set killReward(KillReward killReward) {
    _killReward = killReward;
    _animation.setSpriteFromKillReward(killReward);
  }

  /// Whether the body has been created yet.
  /// This is used to prevent the body from being created multiple times,
  /// since the body is created before [onLoad] is called.
  bool bodyCreated = false;

  @override
  void update(double dt) {
    super.update(dt);

    if (isDead) {
      if (body.isActive) body.setActive(false);

      if (_animation.parent == null) {
        // Animation component deleted itself after dead animation finished,
        // so we can safely remove the monster now.
        parent = null;
      }

      return;
    }

    if (_movement != null) {
      _movement!.elapsedSeconds += dt;
      if (_movement!.isFinished) {
        body
          ..setType(BodyType.static)
          ..linearVelocity = Vector2.zero()
          ..position.setFrom(_movement!.targetPosition);
        _movement = null;
        _animation.walking = false;
        priority = getPriorityFromPosition(body.position);
      }
    }
  }

  /// The priority is used to determine the order in which
  /// the monsters are drawn.
  ///
  /// We want the monsters to be drawn from top to bottom,
  /// so we use a negative priority relating to the monster's y position.
  @visibleForTesting
  static int getPriorityFromPosition(Vector2 position) {
    const maxPriority = 0;
    final yRelative = position.y / RicochlimeGame.expectedHeight;
    assert(yRelative >= 0 && yRelative <= 1);
    return lerpDouble(minPriority, maxPriority, yRelative)!.round();
  }

  /// The minimum priority,
  /// used for the monsters at the top of the screen.
  static const minPriority = -100;

  /// Moves a new monster in from the top of the screen
  void moveInFromTop(Duration duration) {
    assert(position.y <= topGap, 'Monster must be at the top of the screen');
    _startMovement(
      _MonsterMovement(
        startingPosition: position.clone()..y -= moveDownHeight,
        targetPosition: position.clone(),
        totalSeconds: duration.inMilliseconds / 1000,
      ),
    );
  }

  /// Moves the monster down to the next row
  void moveDown(Duration duration) {
    _startMovement(
      _MonsterMovement(
        startingPosition: body.position.clone(),
        targetPosition: body.position + Vector2(0, moveDownHeight),
        totalSeconds: duration.inMilliseconds / 1000,
      ),
    );
  }

  void _startMovement(_MonsterMovement movement) {
    _movement = movement;
    _animation.walking = true;

    // Create body and set its starting position
    body = createBody();
    body.position.setFrom(movement.startingPosition);

    // Set the body's velocity
    body
      ..setType(BodyType.kinematic)
      ..linearVelocity = movement.velocity;
  }

  void startRagdoll() {
    if (isDead) return;
    if (isRagdolling) return;

    remove(_healthBar);
    _animation.current = .jump;

    body
      ..setType(BodyType.dynamic)
      ..linearVelocity.setValues(
        (game as RicochlimeGame).random.plusOrMinus(
          RicochlimeGame.expectedHeight * 0.03,
        ),
        RicochlimeGame.expectedHeight * 0.05,
      )
      ..angularVelocity =
          (game as RicochlimeGame).random.nextDouble() * pi / 2 - pi / 4
      ..gravityOverride = Vector2(
        0,
        body.position.y > RicochlimeGame.expectedHeight * 0.8
            ? 0
            : RicochlimeGame.expectedHeight - body.position.y,
      )
      ..setFixedRotation(false);
  }

  @override
  Body createBody() {
    if (bodyCreated) return body;
    try {
      return super.createBody();
    } finally {
      bodyCreated = true;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (isDead) return;

    if (other is Bullet) {
      hp -= 1;
      (game as RicochlimeGame).audio.playHitSfx();
    }
  }
}

/// Data about a movement of a monster,
/// including the [startingPosition] and [targetPosition].
class _MonsterMovement {
  _MonsterMovement({
    required this.startingPosition,
    required this.targetPosition,
    required this.totalSeconds,
  });

  final Vector2 startingPosition;
  final Vector2 targetPosition;
  final double totalSeconds;
  double elapsedSeconds = 0;

  late final Vector2 velocity =
      (targetPosition - startingPosition) / totalSeconds;

  bool get isFinished => elapsedSeconds >= totalSeconds;
}

/// The animated sprite component,
/// used internally by the [Monster] class.
///
/// It should not be used directly,
/// but only for type checking.
class MonsterAnimation extends SpriteAnimationGroupComponent<MonsterState>
    with HasGameReference<RicochlimeGame> {
  MonsterAnimation._()
    : super(
        position: _relativePosition.clone(),
        removeOnFinish: {.dead: true},
      ) {
    animations = getAnimations(monsterImagePath: monsterImagePath);
  }

  static const staticWidth = 20.0;
  static const staticHeight = staticWidth;
  static final _relativePosition = Vector2(
    (Monster.staticWidth - staticWidth) / 2,
    (Monster.staticHeight - staticHeight) / 2,
  );

  bool _walking = false;

  /// Whether the monster is walking.
  bool get walking => _walking;
  set walking(bool value) {
    _walking = value;
    if (value) {
      current = .walk;
    } else {
      current = .idle;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    current = .idle;
    walking = _walking;
    width = staticWidth;
    height = staticHeight;
  }

  /// Preloads the sprites for the monster.
  static Future<void> preloadSprites({required RicochlimeGame game}) {
    return Future.wait([
      game.images.load('log_normal.png'),
      game.images.load('log_green.png'),
      game.images.load('log_gold.png'),
    ]);
  }

  String monsterImagePath = 'log_normal.png';
  void setSpriteFromKillReward(KillReward killReward) {
    monsterImagePath = switch (killReward) {
      .none => 'log_normal.png',
      .bullet => 'log_green.png',
      .coin => 'log_gold.png',
    };

    final animations = this.animations;
    if (animations == null) return;

    // Swap the sprite in existing animations
    final monsterImage = RicochlimeGame.instance.images.fromCache(
      monsterImagePath,
    );
    for (final animation in animations.values) {
      for (final frame in animation.frames) {
        frame.sprite.image = monsterImage;
      }
    }
  }

  /// The list of animations for the monster.
  static Map<MonsterState, SpriteAnimation> getAnimations({
    required String monsterImagePath,
  }) {
    final monsterImage = RicochlimeGame.instance.images.fromCache(
      monsterImagePath,
    );
    return {
      .idle: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: RicochlimeGame.reproducibleGoldenMode ? 1 : 2,
          stepTime: 1 / 2,
          textureSize: Vector2(24, 24),
          texturePosition: Vector2(0, 0),
        ),
      ),
      .walk: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: RicochlimeGame.reproducibleGoldenMode ? 1 : 4,
          stepTime: 1 / 4,
          textureSize: Vector2(24, 24),
          texturePosition: Vector2(0, 1 * 24),
        ),
      ),
      .jump: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(24, 24),
          texturePosition: Vector2(3 * 24, 0),
          loop: false,
        ),
      ),
      .dead: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: RicochlimeGame.reproducibleGoldenMode ? 1 : 3,
          stepTime: 0.3 / 3,
          textureSize: Vector2(24, 24),
          texturePosition: Vector2(0, 2 * 24),
          loop: false,
        ),
      ),
    };
  }
}

extension on double {
  /// Rounds the number to 1 decimal place.
  double roundTo1Dp() => (this * 10).roundToDouble() / 10;
}
