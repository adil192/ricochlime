import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

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

/// A sprite that darkens when the game is in dark mode.
mixin DarkeningSprite on HasPaint, HasGameRef<RicochlimeGame> {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _onBrightnessChange();
  }

  @override
  void onMount() {
    super.onMount();
    gameRef.isDarkMode.addListener(_onBrightnessChange);
    _onBrightnessChange();
  }

  @override
  void onRemove() {
    super.onRemove();
    gameRef.isDarkMode.removeListener(_onBrightnessChange);
  }

  bool _isDarkened = false;
  void _onBrightnessChange() {
    if (gameRef.isDarkMode.value == _isDarkened) return;
    _isDarkened = gameRef.isDarkMode.value;
    getPaint().colorFilter = gameRef.isDarkMode.value
        ? const ColorFilter.mode(
            Color.fromARGB(255, 175, 175, 175),
            BlendMode.modulate,
          )
        : null;
  }
}
