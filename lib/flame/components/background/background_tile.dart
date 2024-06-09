import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/random_extension.dart';

class GroundSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  GroundSprite({
    required this.posOnIsland,
    super.position,
    super.size,
  });

  final Alignment posOnIsland;

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: switch (posOnIsland) {
        Alignment.bottomCenter => Vector2(48, 96),
        Alignment.centerRight => Vector2(32, 112),
        Alignment.centerLeft => Vector2(64, 112),
        Alignment.topCenter => Vector2(48, 128),

        // Different sprite for the outer corners
        Alignment.bottomLeft => Vector2(32, 160),
        Alignment.bottomRight => Vector2(48, 160),
        Alignment.topLeft => Vector2(32, 144),
        Alignment.topRight => Vector2(48, 144),

        // Different sprite for the center land
        Alignment.center => Vector2(80, 160),

        // Not supported
        _ => throw 'Invalid alignment: $posOnIsland',
      },
      srcSize: Vector2(16, 16),
    );
  }
}

class GrassSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  GrassSprite({
    super.position,
    super.size,
  });

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: Vector2.zero(),
      srcSize: Vector2(16, 16),
    );
  }
}

class SkullSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, FlickeringSprite {
  SkullSprite({
    required this.type,
    super.position,
    super.size,
  });

  final SkullType type;

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: Vector2(type.x, type.y),
      srcSize: Vector2(16, 16),
    );
  }
}

enum SkullType {
  skullStraight(448, 32),
  skullAngled(432, 48),
  boneSmall(448, 48),
  boneBig(464, 48),
  boneSmallAndBig(464, 32);

  const SkullType(this.x, this.y);

  final double x, y;

  static SkullType random(Random random) =>
      values[random.nextInt(values.length)];
}

/// A sprite that darkens when the game is in dark mode.
mixin DarkeningSprite on HasPaint {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _onBrightnessChange();
  }

  @override
  void onMount() {
    super.onMount();
    RicochlimeGame.isDarkMode.addListener(_onBrightnessChange);
    _onBrightnessChange();
  }

  @override
  void onRemove() {
    super.onRemove();
    RicochlimeGame.isDarkMode.removeListener(_onBrightnessChange);
  }

  bool _isDarkened = false;
  void _onBrightnessChange() {
    if (RicochlimeGame.isDarkMode.value == _isDarkened) return;
    _isDarkened = RicochlimeGame.isDarkMode.value;
    getPaint().colorFilter = RicochlimeGame.isDarkMode.value
        ? const ColorFilter.mode(
            Color.fromARGB(255, 175, 175, 175),
            BlendMode.modulate,
          )
        : null;
  }
}

/// A sprite that flickers like a candle.
mixin FlickeringSprite on HasPaint {
  final Random _random = Random();

  /// When timeToNextFlicker reaches 0,
  /// the brightness is set to a random value between 0.5 and 1.
  double timeToNextFlicker = 0;

  /// The intensity of the flicker tint.
  double flickerIntensity = 0.2;

  @override
  void update(double dt) {
    timeToNextFlicker -= dt;
    if (timeToNextFlicker <= 0) {
      timeToNextFlicker = _random.nextBetween(1 / 60, 10 / 60);

      if (RicochlimeGame.reproducibleGoldenMode) {
        flickerIntensity = 0.25;
      } else {
        flickerIntensity =
            0.3 * flickerIntensity + 0.7 * pow(_random.nextDouble(), 2);
      }

      getPaint().colorFilter = ColorFilter.mode(
        Color.lerp(
          Colors.white,
          const Color.fromARGB(255, 255, 245, 150),
          flickerIntensity,
        )!,
        BlendMode.modulate,
      );
    }
  }
}
