import 'dart:math';

import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
// ignore: implementation_imports
import 'package:forge2d/src/settings.dart' as physics_settings;
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/background/background.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/flame/components/walls.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

enum GameState {
  idle,
  shooting,
  slimesMoving,
  gameOver,
}

class RicochlimeGame extends Forge2DGame with
    PanDetector, TapDetector {
  RicochlimeGame({
    required this.score,
    required this.timeDilation,
  }): super(
    gravity: Vector2.zero(),
    zoom: 1,
  ) {
    physics_settings.maxTranslation = Bullet.speed;
  }

  /// Width to height aspect ratio
  static const aspectRatio = 1 / 2;

  static const expectedWidth = tilesInWidth * Slime.staticWidth;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const waterPosition = expectedHeight * 0.8;

  static const tilesInWidth = 8;
  static const tilesInHeight = tilesInWidth ~/ aspectRatio;

  static const bulletTimeoutMs = 1 * 60 * 1000; // 1 minute

  GameState _state = GameState.idle;
  GameState get state => _state;
  set state(GameState value) {
    _state = value;
    if (value != GameState.shooting) {
      timeDilation.value = 1.0;
    }
  }

  late Player player;
  late AimGuide aimGuide;
  bool get inputAllowed => state == GameState.idle;
  bool inputCancelled = false;
  final List<Slime> slimes = [];

  final random = Random();

  final ValueNotifier<int> score;
  int numBullets = 1;
  int numNewRowsEachRound = 1;

  final ValueNotifier<double> timeDilation;

  Future<void> Function()? showGameOverDialog;

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
  }

  Future<void> importFromGame(GameData? data) async {
    if (data == null) {
      // new game
      reset();
      return;
    }

    int numSlimesThatGiveBullets = 0;
    bool topGapNeedsAdjusting = false;
    for (final slimeJson in data.slimes) {
      final slime = Slime.fromJson(slimeJson);
      slimes.add(slime);
      add(slime);

      if (slime.givesPlayerABullet) numSlimesThatGiveBullets++;
      if (slime.position.y <= 0) topGapNeedsAdjusting = true;
    }

    if (topGapNeedsAdjusting) {
      // the top gap needs adjusting because the slimes were imported from a
      // previous version of the game
      for (final slime in slimes) {
        slime.position.y += Slime.topGap;
      }
    }

    score.value = data.score;
    numBullets = 1 + score.value - numSlimesThatGiveBullets;
    assert(numBullets >= 1);
    assert(numBullets <= score.value);
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);
    numNewRowsEachRound = getNumNewRowsEachRound(score.value + numNewRowsEachRound);
  }
  Future saveGame() async {
    assert(
      slimes.any((slime) => slime.position.y <= Slime.topGap),
      'The new row of slimes should be spawned before saving the game'
    );
    Prefs.currentGame.value = GameData(
      score: score.value,
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

    _resetChildren();
    await importFromGame(Prefs.currentGame.value);
  }

  /// Clears the current bullets and slimes
  void _resetChildren() {
    for (final component in children) {
      switch (component) {
        case (Bullet _):
        case (Slime _):
          component.removeFromParent();
      }
    }
    slimes.clear();
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

  @override
  void update(double dt) {
    const maxDt = 0.5;
    if (dt > maxDt) {
      // physics engine can't handle such a big dt
      // e.g. when the app is resumed from background
      return;
    }
    super.update(
      min(dt * timeDilation.value, maxDt),
    );
  }
  @override
  void onTap() {
    if (state == GameState.shooting) {
      timeDilation.value += 0.5;
    } else {
      assert(timeDilation.value == 1.0);
    }
  }

  Future<void> _spawnBullets() async {
    final aimDir = aimGuide.finishAim();
    if (aimDir == null) {
      return;
    }

    assert(inputAllowed);
    state = GameState.shooting;
    assert(!inputAllowed);
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
        await Future.delayed(Duration(milliseconds: (50 / timeDilation.value).floor()));
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
      if (state != GameState.gameOver) {
        state = GameState.idle;
      }
      inputCancelled = false;
    }
  }

  /// Moves the existing slimes down and spawns new ones at the top
  Future<void> spawnNewSlimes() async {
    const slimeMoveDuration = Duration(seconds: 1);

    state = GameState.slimesMoving;

    // remove slimes that have been killed
    slimes.removeWhere((slime) => slime.parent == null);

    // move slimes down and spawn new ones at the top
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);
    for (int i = 0; i < numNewRowsEachRound; ++i) {
      // move existing slimes down
      for (final slime in slimes) {
        slime.moveDown(slimeMoveDuration);
      }

      // spawn new slimes at the top
      score.value++;
      final row = createNewRow(
        random: random,
        slimeHp: score.value,
      );
      for (final slime in row) {
        if (slime == null) continue;

        slimes.add(slime);
        add(slime);

        // trigger the slime's animation
        slime.moveInFromTop(slimeMoveDuration);
      }

      // wait for the slimes to move
      await Future.delayed(slimeMoveDuration);

      // check if the player has lost
      const threshold = Background.waterThresholdPosition - Slime.staticHeight;
      if (slimes.any((slime) => slime.position.y >= threshold)) {
        return await gameOver();
      }
    }
    numNewRowsEachRound = getNumNewRowsEachRound(score.value + numNewRowsEachRound);
    state = GameState.idle;

    await saveGame();
  }

  Future<void> gameOver() async {
    state = GameState.gameOver;
    assert(!inputAllowed);

    // remove saved game
    Prefs.currentGame.value = null;

    // TODO(adil192): Animate the slimes jumping into the water
    await Future.delayed(const Duration(milliseconds: 500));

    if (showGameOverDialog != null) {
      await showGameOverDialog!.call();
      reset();
    }
  }

  void reset() {
    state = GameState.idle;
    inputCancelled = false;
    score.value = 0;
    numBullets = 1;
    numNewRowsEachRound = 1;
    _resetChildren();
    spawnNewSlimes();
  }

  @visibleForTesting
  static int getNumNewRowsEachRound(int score) {
    const int roundsBeforeIncreasingRows = 50;
    int numNewRows = 1;
    int maxScoreInRow = numNewRows * roundsBeforeIncreasingRows;
    while (score >= maxScoreInRow) {
      numNewRows++;
      maxScoreInRow += numNewRows * roundsBeforeIncreasingRows;
    }
    return numNewRows;
  }

  @visibleForTesting
  static int maxSlimesInRow = tilesInWidth - 1;
  @visibleForTesting
  static int minSlimesInRow = 2;
  @visibleForTesting
  static List<Slime?> createNewRow({
    required Random random,
    required int slimeHp,
  }) {
    final slimeBools = <bool>[];
    for (var i = 0; i < tilesInWidth; i++) {
      slimeBools.add(random.nextDouble() < 0.3);
    }
    while (slimeBools.where((e) => e).length > maxSlimesInRow) {
      slimeBools[random.nextInt(slimeBools.length)] = false;
    }
    while (slimeBools.where((e) => e).length < minSlimesInRow) {
      slimeBools[random.nextInt(slimeBools.length)] = true;
    }

    final row = <Slime?>[
      for (var i = 0; i < slimeBools.length; i++)
        if (!slimeBools[i])
          null
        else
          Slime(
            position: Vector2(
              expectedWidth * i / tilesInWidth,
              Slime.topGap,
            ),
            maxHp: slimeHp,
          ),
    ];

    // one of the slimes should give the user a bullet when it dies
    int chosenIndex = random.nextInt(row.length);
    while (row[chosenIndex] == null) {
      chosenIndex = random.nextInt(row.length);
    }
    row[chosenIndex]!.givesPlayerABullet = true;

    return row;
  }
}
