import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class HouseSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  HouseSprite({
    super.position,
    super.size,
    super.priority = 10000,
    super.anchor = Anchor.topCenter,
  });

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: Vector2(176, 0),
      srcSize: Vector2(80, 80),
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

class BridgeSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  BridgeSprite({
    super.position,
    super.size,
  });

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: Vector2(91, 104),
      srcSize: Vector2(26, 33),
    );
  }
}

class WaterSprite extends SpriteAnimationComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  WaterSprite({
    super.position,
    super.size,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('overworld.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 4 / 8,
        textureSize: Vector2(16, 16),
        amountPerRow: 4,
        texturePosition: Vector2(0, 16),
      ),
    );
  }
}

class BushSprite extends SpriteComponent
    with HasGameRef<RicochlimeGame>, DarkeningSprite {
  BushSprite({
    super.position,
    super.size,
  });

  @override
  void onLoad() {
    super.onLoad();
    sprite = Sprite(
      gameRef.images.fromCache('overworld.png'),
      srcPosition: Vector2(1, 225),
      srcSize: Vector2(15, 31),
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
