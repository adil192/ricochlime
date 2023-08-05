import 'dart:math';

import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/background/background.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/flame/components/walls.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

class RicochlimeGame extends Forge2DGame with PanDetector {

  RicochlimeGame(): super(
    gravity: Vector2.zero(),
    zoom: 1.0,
  );

  /// Width to height aspect ratio
  static const aspectRatio = 1 / 2;

  static const expectedWidth = tilesInWidth * 16.0;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const tilesInWidth = 8;
  static const tilesInHeight = tilesInWidth ~/ aspectRatio;

  late Player player;
  late AimGuide aimGuide;
  bool inputAllowed = true;

  static const bulletTimeoutMs = 1 * 60 * 1000; // 1 minute

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    add(Background());

    final random = Random();
    for (var y = 0; y < tilesInHeight - 6; y++) {
      for (var x = 0; x < tilesInWidth - 1; x++) {
        if (random.nextDouble() > 0.3) {
          continue;
        }
        add(
          Slime(
            position: Vector2(
              expectedWidth * x / tilesInWidth,
              expectedHeight * y / tilesInHeight,
            ),
            hp: 20,
          ),
        );
      }
    }

    aimGuide = AimGuide();
    add(aimGuide);

    player = Player();
    add(player);

    final boundaries = createBoundaries(expectedWidth, expectedHeight);
    boundaries.forEach(add);
  }

  @override
  Color backgroundColor() => RicochlimePalette.grassColor;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!inputAllowed) {
      return;
    }
    aimGuide.aim(info.eventPosition.game);
  }
  @override
  void onPanEnd(DragEndInfo info) {
    if (!inputAllowed) {
      return;
    }
    _spawnBullets();
  }

  Future<void> _spawnBullets() async {
    final aimDir = aimGuide.finishAim();
    if (aimDir == null) {
      return;
    }

    assert(inputAllowed);
    inputAllowed = false;
    player.attack();

    // TODO(adil192): Increment this as the player progresses
    const maxBullets = 20;

    try {
      final bullets = <Bullet>[];
      for (var i = 0; i < maxBullets; i++) {
        final bullet = Bullet(
          initialPosition: aimGuide.position,
          direction: aimDir,
        );
        bullets.add(bullet);
        add(bullet);
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // wait until bullets are removed or timeout
      var msElapsed = 0;
      while (bullets.any((bullet) => bullet.parent != null)
             && msElapsed < bulletTimeoutMs) {
        msElapsed += 50;
        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (msElapsed >= bulletTimeoutMs) {
        if (kDebugMode) {
          print('Bullet timeout reached');
        }
        for (final bullet in bullets) {
          if (bullet.parent != null) {
            bullet.removeFromParent();
          }
        }
      }
    } finally {
      inputAllowed = true;
    }
  }
}
