import 'dart:ui' show lerpDouble;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/health_bar.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

/// The animation state of the slime.
enum SlimeState {
  /// The slime is idle.
  idle,
  /// The slime is walking.
  walk,
  /// The slime is attacking.
  attack,
  /// The slime is hurt.
  hurt,
  /// The slime is dead.
  dead,
}

/// A slime component.
class Slime extends BodyComponent with ContactCallbacks {
  // ignore: public_member_api_docs
  Slime({
    required this.initialPosition,
    required this.maxHp,
    int? hp,
    bool? givesPlayerABullet,
  }): hp = hp ?? maxHp,
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

  /// Creates a slime from JSON data.
  Slime.fromJson(Map<String, dynamic> json): this(
    initialPosition: Vector2(
      json['px'] as double,
      json['py'] as double,
    ),
    hp: json['hp'] as int,
    maxHp: json['maxHp'] as int,
    givesPlayerABullet: json['givesPlayerABullet'] as bool? ?? false,
  );
  /// Converts the slime's data to a JSON map.
  Map<String, dynamic> toJson() => {
    'px': _movement?.targetPosition.x ?? position.x,
    'py': _movement?.targetPosition.y ?? position.y,
    'hp': hp,
    'maxHp': maxHp,
    'givesPlayerABullet': givesPlayerABullet,
  };

  /// The width of the slime.
  static const staticWidth = 16.0;
  /// The height of the slime.
  static const staticHeight = staticWidth;

  /// The distance between the top of one slime
  /// and the top of the slime in the next row.
  static const _moveDownHeight = staticHeight * 0.8;

  /// The gap at the top above the first row of slimes.
  static const topGap = staticHeight;

  /// The initial position of the slime.
  ///
  /// See [position] for the current position.
  final Vector2 initialPosition;
  /// The size of the slime.
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
  _SlimeMovement? _movement;

  /// The animated sprite component
  late final SlimeAnimation _animation = SlimeAnimation._();
  /// The health bar component
  late final HealthBar _healthBar = HealthBar(
    maxHp: maxHp,
    hp: hp,
    paint: _animation.paint,
  );

  bool _givesPlayerABullet = false;
  /// Whether the slime gives the player a bullet when it dies.
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

  /// The priority is used to determine the order in which the slimes are drawn.
  /// 
  /// We want the slimes to be drawn from top to bottom,
  /// so we use a negative priority relating to the slime's y position.
  @visibleForTesting
  static int getPriorityFromPosition(Vector2 position) {
    const maxPriority = 0;
    final yRelative = position.y / RicochlimeGame.expectedHeight;
    assert(yRelative >= 0 && yRelative <= 1);
    return lerpDouble(minPriority, maxPriority, yRelative)!.floor();
  }
  /// The minimum priority,
  /// used for the slimes at the top of the screen.
  static const minPriority = -100;

  /// Moves a new slime in from the top of the screen
  void moveInFromTop(Duration duration) {
    assert(position.y <= topGap, 'Slime must be at the top of the screen');
    _startMovement(_SlimeMovement(
      startingPosition: position.clone()..y -= _moveDownHeight,
      targetPosition: position.clone(),
      totalSeconds: duration.inMilliseconds / 1000,
    ));
  }

  /// Moves the slime down to the next row
  void moveDown(Duration duration) {
    _startMovement(_SlimeMovement(
      startingPosition: body.position.clone(),
      targetPosition: body.position + Vector2(0, _moveDownHeight),
      totalSeconds: duration.inMilliseconds / 1000,
    ));
  }

  void _startMovement(_SlimeMovement movement) {
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
          Vector2(1, 7),
          Vector2(1, 15),
          Vector2(15, 15),
          Vector2(15, 7),
          Vector2(12, 5),
          Vector2(4, 5),
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
            ..position = SlimeAnimation._relativePosition + body.position
            ..current = SlimeState.dead;

        removeFromParent();
      }
    }
  }
}

/// Data about a movement of a slime,
/// including the [startingPosition] and [targetPosition].
class _SlimeMovement {
  _SlimeMovement({
    required this.startingPosition,
    required this.targetPosition,
    required this.totalSeconds,
  });

  final Vector2 startingPosition;
  final Vector2 targetPosition;
  final double totalSeconds;
  double elapsedSeconds = 0;

  late final Vector2 velocity = (targetPosition - startingPosition)
      / totalSeconds;

  bool get isFinished => elapsedSeconds >= totalSeconds;
}

/// The animated sprite component,
/// used internally by the [Slime] class.
///
/// It should not be used directly,
/// but only for type checking.
class SlimeAnimation extends SpriteAnimationGroupComponent<SlimeState>
    with HasGameRef<RicochlimeGame> {
  SlimeAnimation._(): super(
    position: _relativePosition.clone(),
    removeOnFinish: {
      SlimeState.dead: true,
    },
  );

  static final Vector2 _relativePosition = Vector2(
    -Slime.staticWidth / 2,
    -Slime.staticHeight / 2,
  );

  bool _walking = false;
  /// Whether the slime is walking.
  bool get walking => _walking;
  set walking(bool value) {
    _walking = value;
    if (value) {
      current = SlimeState.walk;
    } else {
      current = SlimeState.idle;
    }
  }

  /// Whether the slime gives the player a bullet when it dies.
  bool get givesPlayerABullet => getPaint().colorFilter != null;
  set givesPlayerABullet(bool value) {
    getPaint().colorFilter = value
        ? const ColorFilter.mode(Color(0xffffff55), BlendMode.modulate)
        : null;
  }

  @override
  Future<void> onLoad() async {
    animations = getAnimations();
    current = SlimeState.idle;
    walking = _walking;
    await super.onLoad();

    width = 32;
    height = 32;
  }

  /// Preloads the sprites for the slime.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('slime.png');
  }

  /// The list of animations for the slime.
  Map<SlimeState, SpriteAnimation> getAnimations() {
    final slimeImage = gameRef.images.fromCache('slime.png');
    return {
      SlimeState.idle: SpriteAnimation.fromFrameData(
        slimeImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 4,
          textureSize: Vector2(32, 32),
          amount: 4,
          amountPerRow: 4,
        ),
      ),
      SlimeState.walk: SpriteAnimation.fromFrameData(
        slimeImage,
        SpriteAnimationData.sequenced(
          stepTime: 0.5 / 6,
          textureSize: Vector2(32, 32),
          amount: 6,
          amountPerRow: 6,
          texturePosition: Vector2(0, 1 * 32),
        ),
      ),
      SlimeState.attack: SpriteAnimation.fromFrameData(
        slimeImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 7,
          textureSize: Vector2(32, 32),
          amount: 7,
          amountPerRow: 7,
          texturePosition: Vector2(0, 2 * 32),
        ),
      ),
      SlimeState.hurt: SpriteAnimation.fromFrameData(
        slimeImage,
        SpriteAnimationData.sequenced(
          stepTime: 1 / 3,
          textureSize: Vector2(32, 32),
          amount: 3,
          amountPerRow: 3,
          texturePosition: Vector2(0, 3 * 32),
        ),
      ),
      SlimeState.dead: SpriteAnimation.fromFrameData(
        slimeImage,
        SpriteAnimationData.sequenced(
          stepTime: 0.3 / 5,
          textureSize: Vector2(32, 32),
          amount: 5,
          amountPerRow: 5,
          texturePosition: Vector2(0, 4 * 32),
          loop: false,
        ),
      ),
    };
  }
}
