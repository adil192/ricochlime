import 'dart:ui' show lerpDouble;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/health_bar.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum SlimeState {
  idle,
  walk,
  attack,
  hurt,
  dead,
}

class Slime extends BodyComponent with ContactCallbacks {
  static const staticWidth = 16.0;
  static const staticHeight = staticWidth;

  /// The distance between the top of one slime
  /// and the top of the slime in the next row.
  static const _moveDownHeight = staticHeight * 0.8;

  /// The gap at the top above the first row of slimes.
  static const topGap = staticHeight;

  final Vector2 position;
  final Vector2 size = Vector2(staticWidth, staticHeight);

  int maxHp;
  int hp;

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
  bool get givesPlayerABullet => _givesPlayerABullet;
  set givesPlayerABullet(bool value) {
    _givesPlayerABullet = value;
    _animation.givesPlayerABullet = value;
  }

  /// Whether the body has been created yet.
  /// This is used to prevent the body from being created multiple times,
  /// since the body is created before [onLoad] is called.
  bool bodyCreated = false;

  Slime({
    required this.position,
    required this.maxHp,
    int? hp,
    bool? givesPlayerABullet,
  }): hp = hp ?? maxHp,
      super(
        priority: getPriorityFromPosition(position),
      ) {
    if (givesPlayerABullet != null) {
      this.givesPlayerABullet = givesPlayerABullet;
    }

    renderBody = false;
    add(_animation);
    add(_healthBar);
  }

  Slime.fromJson(Map<String, dynamic> json): this(
    position: Vector2(
      json['px'] as double,
      json['py'] as double,
    ),
    hp: json['hp'] as int,
    maxHp: json['maxHp'] as int,
    givesPlayerABullet: json['givesPlayerABullet'] as bool? ?? false,
  );
  Map<String, dynamic> toJson() => {
    'px': _movement?.targetPosition.x ?? position.x,
    'py': _movement?.targetPosition.y ?? position.y,
    'hp': hp,
    'maxHp': maxHp,
    'givesPlayerABullet': givesPlayerABullet,
  };

  @override
  void update(double dt) {
    super.update(dt);

    if (_movement != null) {
      _movement!.elapsedSeconds += dt;
      if (_movement!.isFinished) {
        body.setType(BodyType.static);
        body.linearVelocity = Vector2.zero();
        position.setFrom(_movement!.targetPosition);
        body.position.setFrom(_movement!.targetPosition);
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

    // Create body if it hasn't been created yet,
    // and set its starting position
    body = createBody();
    position.setFrom(movement.startingPosition);
    body.position.setFrom(movement.startingPosition);

    // Set the body's velocity
    body.setType(BodyType.kinematic);
    body.linearVelocity = movement.velocity;
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
      position: position,
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
          (gameRef as RicochlimeGame).numBullets += 1;
        }

        _animation.parent = parent;
        _animation.position += body.position;
        _animation.current = SlimeState.dead;

        removeFromParent();
      }
    }
  }
}

class _SlimeMovement {
  final Vector2 startingPosition;
  final Vector2 targetPosition;
  final double totalSeconds;
  double elapsedSeconds = 0;

  late final Vector2 velocity = (targetPosition - startingPosition) / totalSeconds;

  _SlimeMovement({
    required this.startingPosition,
    required this.targetPosition,
    required this.totalSeconds,
  });

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
    position: Vector2(-Slime.staticWidth / 2, -Slime.staticHeight / 2),
    removeOnFinish: {
      SlimeState.dead: true,
    },
  );

  bool _walking = false;
  bool get walking => _walking;
  set walking(bool value) {
    _walking = value;
    if (value) {
      current = SlimeState.walk;
    } else {
      current = SlimeState.idle;
    }
  }

  set givesPlayerABullet(bool value) {
    getPaint().colorFilter = value
        ? const ColorFilter.mode(Color(0xffffff55), BlendMode.modulate)
        : null;
  }

  @override
  Future<void> onLoad() async {
    animations = await getAnimations();
    current = SlimeState.idle;
    walking = _walking;
    await super.onLoad();

    width = 32;
    height = 32;
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
        stepTime: 0.5 / 6,
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
