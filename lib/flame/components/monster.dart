import 'dart:ui' show lerpDouble;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/health_bar.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

/// The animation state of the monster.
enum MonsterState {
  /// The monster is idle.
  idle,

  /// The monster is walking.
  walk,

  /// The monster is dead.
  dead,
}

/// A monster component.
class Monster extends BodyComponent with ContactCallbacks {
  // ignore: public_member_api_docs
  Monster({
    required this.initialPosition,
    required this.maxHp,
    int? hp,
    bool? givesPlayerABullet,
  })  : hp = hp ?? maxHp,
        super(
          priority: getPriorityFromPosition(initialPosition),
        ) {
    if (givesPlayerABullet != null) {
      this.givesPlayerABullet = givesPlayerABullet;
    }

    renderBody = false;
    add(_animation);
    add(_healthBar);
  }

  /// Creates a Monster from JSON data.
  Monster.fromJson(Map<String, dynamic> json)
      : this(
          initialPosition: Vector2(
            json['px'] as double,
            json['py'] as double,
          ),
          hp: json['hp'] as int,
          maxHp: json['maxHp'] as int,
          givesPlayerABullet: json['givesPlayerABullet'] as bool? ?? false,
        );

  /// Converts the monster's data to a JSON map.
  Map<String, dynamic> toJson() => {
        'px': _movement?.targetPosition.x ?? position.x,
        'py': _movement?.targetPosition.y ?? position.y,
        'hp': hp,
        'maxHp': maxHp,
        'givesPlayerABullet': givesPlayerABullet,
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
  int hp;

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

  bool _givesPlayerABullet = false;

  /// Whether the monster gives the player a bullet when it dies.
  bool get givesPlayerABullet => _givesPlayerABullet;
  set givesPlayerABullet(bool value) {
    _givesPlayerABullet = value;
    _animation.givesPlayerABullet = value;
  }

  /// Whether the body has been created yet.
  /// This is used to prevent the body from being created multiple times,
  /// since the body is created before [onLoad] is called.
  bool bodyCreated = false;

  @override
  void update(double dt) {
    super.update(dt);

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
    return lerpDouble(minPriority, maxPriority, yRelative)!.floor();
  }

  /// The minimum priority,
  /// used for the monsters at the top of the screen.
  static const minPriority = -100;

  /// Moves a new monster in from the top of the screen
  void moveInFromTop(Duration duration) {
    assert(position.y <= topGap, 'Monster must be at the top of the screen');
    _startMovement(_MonsterMovement(
      startingPosition: position.clone()..y -= moveDownHeight,
      targetPosition: position.clone(),
      totalSeconds: duration.inMilliseconds / 1000,
    ));
  }

  /// Moves the monster down to the next row
  void moveDown(Duration duration) {
    _startMovement(_MonsterMovement(
      startingPosition: body.position.clone(),
      targetPosition: body.position + Vector2(0, moveDownHeight),
      totalSeconds: duration.inMilliseconds / 1000,
    ));
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

  @override
  Body createBody() {
    if (bodyCreated) return body;
    bodyCreated = true;

    final shape = PolygonShape()
      ..set([
        Vector2(5, 0),
        Vector2(3, 3),
        Vector2(3, 12),
        Vector2(13, 12),
        Vector2(13, 3),
        Vector2(11, 0),
      ]);
    final fixtureDef = FixtureDef(
      shape,
      userData: this,
    );

    final bodyDef = BodyDef(
      position: initialPosition,
      fixedRotation: true,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is Bullet) {
      hp -= 1;
      _healthBar.hp = hp;
      if (hp <= 0) {
        if (givesPlayerABullet) {
          (game as RicochlimeGame).numBullets += 1;
        }

        _animation
          ..parent = parent
          ..position = MonsterAnimation._relativePosition + body.position
          ..current = MonsterState.dead;

        removeFromParent();
      }
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
    with HasGameRef<RicochlimeGame> {
  MonsterAnimation._()
      : super(
          position: _relativePosition.clone(),
          removeOnFinish: {
            MonsterState.dead: true,
          },
        );

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
      current = MonsterState.walk;
    } else {
      current = MonsterState.idle;
    }
  }

  /// Whether the monster gives the player a bullet when it dies.
  bool get givesPlayerABullet => getPaint().colorFilter != null;
  set givesPlayerABullet(bool value) {
    getPaint().colorFilter = value
        ? const ColorFilter.mode(Color(0xffffff55), BlendMode.modulate)
        : null;
  }

  @override
  Future<void> onLoad() async {
    animations = getAnimations();
    current = MonsterState.idle;
    walking = _walking;
    await super.onLoad();

    width = staticWidth;
    height = staticHeight;
  }

  /// Preloads the sprites for the monster.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('log_subset.png');
  }

  /// The list of animations for the monster.
  Map<MonsterState, SpriteAnimation> getAnimations() {
    final monsterImage = gameRef.images.fromCache('log_subset.png');
    return {
      MonsterState.idle: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 1 / 2,
          textureSize: Vector2(24, 24),
          amountPerRow: 2,
          texturePosition: Vector2(0, 0),
        ),
      ),
      MonsterState.walk: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 1 / 4,
          textureSize: Vector2(24, 24),
          amountPerRow: 4,
          texturePosition: Vector2(0, 1 * 24),
        ),
      ),
      MonsterState.dead: SpriteAnimation.fromFrameData(
        monsterImage,
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.3 / 3,
          textureSize: Vector2(24, 24),
          amountPerRow: 3,
          texturePosition: Vector2(0, 2 * 24),
          loop: false,
        ),
      ),
    };
  }
}
