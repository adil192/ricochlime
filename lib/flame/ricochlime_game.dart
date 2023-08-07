import 'dart:math';

import 'package:flame/components.dart';
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
  RicochlimeGame({
    required this.score,
  }): super(
    gravity: Vector2.zero(),
    zoom: 1.0,
  );

  /// Width to height aspect ratio
  static const aspectRatio = 1 / 2;

  static const expectedWidth = tilesInWidth * 16.0;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const tilesInWidth = 8;
  static const tilesInHeight = tilesInWidth ~/ aspectRatio;

  static const bulletTimeoutMs = 1 * 60 * 1000; // 1 minute

  late Player player;
  late AimGuide aimGuide;
  bool inputAllowed = true;
  final List<Slime> slimes = [];

  final random = Random();

  final ValueNotifier<int> score;
  // TODO(adil192): Player should be able to pick up bullets
  int get numBullets => score.value;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    add(Background());

    spawnNewSlimes();

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

    try {
      final bullets = <Bullet>[];
      for (var i = 0; i < numBullets; i++) {
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

      await spawnNewSlimes();
    } finally {
      inputAllowed = true;
    }
  }

  /// Moves the existing slimes down and spawns new ones at the top
  Future<void> spawnNewSlimes() async {
    const moveDownDuration = Duration(seconds: 1);
    // remove slimes that have been killed
    slimes.removeWhere((slime) => slime.parent == null);
    if (slimes.isNotEmpty) {
      for (final slime in slimes) {
        slime.moveDown(moveDownDuration);
      }
      await Future.delayed(moveDownDuration);
    }

    score.value++;
    final row = createNewRow(
      random: random,
      slimeHp: score.value,
    );
    for (final component in row) {
      if (component == null) {
        continue;
      }
      if (component is Slime) {
        slimes.add(component);
      }
      add(component);
    }
  }

  @visibleForTesting
  static int maxSlimesInRow = tilesInWidth - 2;
  @visibleForTesting
  static int minSlimesInRow = 1;
  @visibleForTesting
  static List<Component?> createNewRow({
    required Random random,
    required int slimeHp,
  }) {
    final slimeBools = <bool>[];
    for (var i = 0; i < tilesInWidth - 1; i++) {
      slimeBools.add(random.nextDouble() < 0.3);
    }
    while (slimeBools.where((e) => e).length > maxSlimesInRow) {
      slimeBools[random.nextInt(slimeBools.length)] = false;
    }
    while (slimeBools.where((e) => e).length < minSlimesInRow) {
      slimeBools[random.nextInt(slimeBools.length)] = true;
    }
    assert(slimeBools.length == tilesInWidth - 1); // last tile is always empty

    final row = <Component?>[
      for (var i = 0; i < slimeBools.length; i++)
        if (!slimeBools[i])
          null
        else
          Slime(
            position: Vector2(
              expectedWidth * i / tilesInWidth,
              0,
            ),
            hp: slimeHp,
          ),
    ];
    // TODO(adil192): Add bullet pickups to empty tiles
    return row;
  }
}
