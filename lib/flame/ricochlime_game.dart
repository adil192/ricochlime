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
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/utils/prefs.dart';
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
  bool inputAllowed = false;
  bool inputCancelled = false;
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

    final boundaries = createBoundaries(expectedWidth, expectedHeight);
    boundaries.forEach(add);

    aimGuide = AimGuide();
    add(aimGuide);

    player = Player();
    add(player);

    await Prefs.currentGame.waitUntilLoaded();
    await importFromGame(Prefs.currentGame.value);
    inputAllowed = true;
  }

  Future<void> importFromGame(GameData? data) async {
    if (data == null) {
      // new game
      score.value = 0;
      // numBullets = 1;
      await spawnNewSlimes();
      return;
    }

    score.value = data.score;
    // numBullets = data.numBullets;
    for (final slimeJson in data.slimes) {
      final slime = Slime.fromJson(slimeJson);
      slimes.add(slime);
      add(slime);
    }
  }
  Future saveGame() async {
    assert(slimes.any((slime) => slime.position.y == 0));
    Prefs.currentGame.value = GameData(
      score: score.value,
      numBullets: numBullets,
      slimes: slimes,
    );
    await Prefs.currentGame.waitUntilSaved();
  }

  Future<void> cancelCurrentTurn() async {
    if (inputAllowed) return;

    inputCancelled = true;
    while (!inputAllowed) {
      // wait for the current turn to cancel gracefully
      await Future.delayed(const Duration(milliseconds: 50));
    }
    assert(!inputCancelled);

    children
      ..whereType<Bullet>().forEach((bullet) => bullet.removeFromParent())
      ..whereType<Slime>().forEach((slime) => slime.removeFromParent());
    slimes.clear();

    await importFromGame(Prefs.currentGame.value);
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
    inputCancelled = false;
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
        if (inputCancelled) return;
      }

      // wait until bullets are removed or timeout
      var msElapsed = 0;
      while (bullets.any((bullet) => bullet.parent != null)
             && msElapsed < bulletTimeoutMs) {
        msElapsed += 50;
        await Future.delayed(const Duration(milliseconds: 50));
        if (inputCancelled) return;
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

      if (inputCancelled) return;
      await spawnNewSlimes();
      if (inputCancelled) return;
    } finally {
      inputAllowed = true;
      inputCancelled = false;
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

    await saveGame();
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
            maxHp: slimeHp,
          ),
    ];
    // TODO(adil192): Add bullet pickups to empty tiles
    return row;
  }
}
