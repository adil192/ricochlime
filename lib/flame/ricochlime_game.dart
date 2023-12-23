import 'dart:async';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:forge2d/src/settings.dart' as physics_settings;
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/background/background.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/walls.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/flame/ticker.dart';
import 'package:ricochlime/pages/game_over.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

enum GameState {
  idle,
  shooting,
  monstersMoving,
  gameOver,
}

class RicochlimeGame extends Forge2DGame
    with PanDetector, TapDetector, SingleGameInstance {
  RicochlimeGame({
    required this.score,
    required this.isDarkMode,
    required this.timeDilation,
  }) : super(
          gravity: Vector2.zero(),
          zoom: 1,
        ) {
    if (_instance != null) {
      // If we were to create and dispose a game instance,
      // we'd need to dispose the ticker as well.
      throw StateError('Only one instance of RicochlimeGame can be created');
    }
    _instance = this;

    /// Sets the maximum movement per time step to [Bullet.speed].
    /// This effectively sets the max time step to 1s,
    /// rather than the default value which is much lower.
    physics_settings.maxTranslation = Bullet.speed;
  }

  static RicochlimeGame? _instance;

  /// Width to height aspect ratio
  static const aspectRatio = 1 / 2;

  static const expectedWidth = 128.0;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const bulletTimeoutSecs = 60; // 1 minute

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
  late Background background;
  bool get inputAllowed => state == GameState.idle;
  bool inputCancelled = false;
  final List<Monster> monsters = [];

  late var random = Random();

  final ValueNotifier<int> score;
  final ValueNotifier<bool> isDarkMode;
  int numBullets = 1;
  int numNewRowsEachRound = 1;

  final Ticker ticker = Ticker();
  final ValueNotifier<double> timeDilation;

  Future<GameOverAction> Function()? showGameOverDialog;

  /// A future that completes when all the sprites are loaded.
  late Future<bool> preloadSprites = Future.wait([
    Background.preloadSprites(gameRef: this),
    MonsterAnimation.preloadSprites(gameRef: this),
    Player.preloadSprites(gameRef: this),
  ]).then((_) => true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    _initBgMusic();

    background = Background();
    add(background);

    createBoundaries(expectedWidth, expectedHeight).forEach(add);

    player = Player();
    add(player);

    aimGuide = AimGuide();
    add(aimGuide);

    // Houses
    for (final dx in <double>[-94, -32, 32, 94]) {
      add(HouseSprite(
        position: player.position + Vector2(dx, -Player.staticHeight * 0.25),
        size: Vector2(60, 60),
      ));
    }

    await Prefs.currentGame.waitUntilLoaded();
    await importFromGame(Prefs.currentGame.value);
  }

  /// Whether [_initBgMusic] has been run.
  bool bgMusicInitialized = false;

  /// Handles fading in/out the background music.
  Timer? _bgMusicFadeTimer;

  @visibleForTesting
  static bool disableBgMusic = false;

  /// Initializes the background music,
  /// and starts playing it.
  void _initBgMusic() {
    if (disableBgMusic) return;
    if (kDebugMode) print('Initializing bg music');
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm/Ludum_Dare_32_Track_4.ogg');
    bgMusicInitialized = true;
  }

  void pauseBgMusic() {
    if (kDebugMode) print('Fading out bg music');
    _bgMusicFadeTimer?.cancel();
    _bgMusicFadeTimer = _fadeBgmInOut(
      startingVolume: FlameAudio.bgm.audioPlayer.volume,
      targetVolume: 0,
      onFinished: FlameAudio.bgm.pause,
    );
  }

  void resumeBgMusic() {
    if (kDebugMode) print('Fading in bg music');
    _bgMusicFadeTimer?.cancel();
    _bgMusicFadeTimer = _fadeBgmInOut(
      startingVolume: FlameAudio.bgm.audioPlayer.volume,
      targetVolume: 1,
      onFinished: null,
    );
  }

  Timer _fadeBgmInOut({
    required double startingVolume,
    required double targetVolume,
    required void Function()? onFinished,
    int steps = 10,
    int totalMs = 1000,
  }) {
    if (!FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.resume();
    }
    return Timer.periodic(
      Duration(milliseconds: totalMs ~/ steps),
      (_) {
        final newVolume = FlameAudio.bgm.audioPlayer.volume +
            (targetVolume - startingVolume) / steps;
        final finished = targetVolume > startingVolume
            ? newVolume >= targetVolume
            : newVolume <= targetVolume;
        if (finished) {
          _bgMusicFadeTimer?.cancel();
          _bgMusicFadeTimer = null;
          FlameAudio.bgm.audioPlayer.setVolume(targetVolume);
          onFinished?.call();
          if (kDebugMode) print('Finished fading bgm in/out to $targetVolume');
        } else {
          FlameAudio.bgm.audioPlayer.setVolume(newVolume);
        }
      },
    );
  }

  Future<void> importFromGame(GameData? data) async {
    if (data == null) {
      // new game
      _reset();
      return;
    }

    int numMonstersThatGiveBullets = 0;
    bool topGapNeedsAdjusting = false;
    for (final monsterJson in data.monsters) {
      final monster = Monster.fromJson(monsterJson);
      monsters.add(monster);
      add(monster);

      if (monster.givesPlayerABullet) numMonstersThatGiveBullets++;
      if (monster.position.y <= 0) topGapNeedsAdjusting = true;
    }

    if (topGapNeedsAdjusting) {
      // the top gap needs adjusting because the monsters were imported from a
      // previous version of the game
      for (final monster in monsters) {
        monster.position.y += Monster.topGap;
      }
    }

    score.value = data.score;
    numBullets = 1 + score.value - numMonstersThatGiveBullets;
    assert(numBullets >= 1);
    assert(numBullets <= score.value);
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);

    if (isGameOver()) {
      await gameOver();
    } else {
      state = GameState.idle;
    }
  }

  Future saveGame() async {
    assert(
      monsters.any((monster) => monster.position.y <= Monster.topGap),
      'The new row of monsters should be spawned before saving the game',
    );
    Prefs.currentGame.value = GameData(
      score: score.value,
      monsters: monsters,
    );
    await Prefs.currentGame.waitUntilSaved();
  }

  Future<void> cancelCurrentTurn() async {
    if (inputAllowed) return;

    inputCancelled = true;
    while (!inputAllowed) {
      // wait for the current turn to cancel gracefully
      await ticker.delayed(const Duration(milliseconds: 50));
    }
    assert(!inputCancelled);

    _resetChildren();
    await importFromGame(Prefs.currentGame.value);
  }

  /// Clears the current bullets and monsters
  void _resetChildren() {
    removeWhere((component) => component is Bullet);
    removeWhere((component) => component is Monster);
    removeWhere((component) => component is MonsterAnimation);
    monsters.clear();
  }

  @override
  Color backgroundColor() => isDarkMode.value
      ? RicochlimePalette.grassColorDark
      : RicochlimePalette.grassColor;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!inputAllowed) {
      return;
    }
    aimGuide.aim(info.eventPosition.widget);
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

    final dilatedDt = min(dt * timeDilation.value, maxDt);
    ticker.tick(dilatedDt);
    super.update(dilatedDt);
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
        await ticker.delayed(const Duration(milliseconds: 50));
        if (inputCancelled) return;
      }

      // wait until bullets are removed or timeout
      var elapsedSeconds = 0.0;
      await for (final tick in ticker.onTick) {
        if (inputCancelled) return;
        elapsedSeconds += tick;
        if (bullets.every((bullet) => bullet.parent == null)) break;
        if (elapsedSeconds >= bulletTimeoutSecs) break;
      }

      if (elapsedSeconds >= bulletTimeoutSecs) {
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
      await spawnNewMonsters();
      if (inputCancelled) return;
    } finally {
      if (state != GameState.gameOver) {
        state = GameState.idle;
      }
      inputCancelled = false;
    }
  }

  /// Moves the existing monsters down and spawns new ones at the top
  Future<void> spawnNewMonsters() async {
    const monsterMoveDuration = Duration(seconds: 1);

    state = GameState.monstersMoving;

    // remove monsters that have been killed
    monsters.removeWhere((monster) => monster.parent == null);

    // move monsters down and spawn new ones at the top
    assert(numNewRowsEachRound == getNumNewRowsEachRound(score.value));
    for (int i = 0; i < numNewRowsEachRound; ++i) {
      // move existing monsters down
      for (final monster in monsters) {
        monster.moveDown(monsterMoveDuration);
      }

      // spawn new monsters at the top
      score.value++;
      final row = createNewRow(
        random: random,
        monsterHp: score.value,
      );
      for (final monster in row) {
        if (monster == null) continue;

        monsters.add(monster);
        add(monster);

        // trigger the monster's animation
        monster.moveInFromTop(monsterMoveDuration);
      }

      // wait for the monsters to move
      await ticker.delayed(monsterMoveDuration);

      // check if the player has lost
      if (isGameOver()) {
        return gameOver();
      }
    }
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);
    state = GameState.idle;

    await saveGame();
  }

  bool isGameOver() {
    final threshold = player.bottomY - Monster.staticHeight * 2;
    return monsters.any((monster) => monster.position.y >= threshold);
  }

  Future<void> gameOver() async {
    state = GameState.gameOver;
    assert(!inputAllowed);

    // TODO(adil192): Animate the monsters jumping into the water
    // await ticker.delayed(const Duration(milliseconds: 500));

    final GameOverAction gameOverAction = showGameOverDialog == null
        ? GameOverAction.nothingYet
        : await showGameOverDialog!.call();
    if (kDebugMode) print('gameOverAction: $gameOverAction');

    switch (gameOverAction) {
      case GameOverAction.nothingYet:
        // do nothing
        break;
      case GameOverAction.continueGame:
        final numRowsToRemove = max(
          // clears 3 rounds worth of monsters
          // plus the one that killed the player
          numNewRowsEachRound * 3 + 1,
          // or at least 5 rows
          5,
        );

        /// The y position of the first row of monsters to remove
        final threshold =
            player.bottomY - numRowsToRemove * Monster.staticHeight;
        if (kDebugMode) {
          print(
              'Removing $numRowsToRemove rows (monsters with y > $threshold)');
        }
        for (final monster in monsters) {
          if (monster.position.y > threshold) {
            monster.removeFromParent();
          }
        }
        monsters.removeWhere((monster) => monster.parent == null);
        state = GameState.idle;
        await saveGame();
      case GameOverAction.restartGame:
        restartGame();
    }
  }

  /// Restarts the game:
  /// Saves the high score,
  /// and clears the current game.
  void restartGame() {
    Prefs.highScore.value = max(Prefs.highScore.value, score.value);
    Prefs.currentGame.value = null;
    _reset();
  }

  /// Resets the game:
  /// sets the score to zero,
  /// and spawns a single row of monsters.
  void _reset() {
    state = GameState.idle;
    inputCancelled = false;
    score.value = 0;
    numBullets = 1;
    numNewRowsEachRound = 1;
    _resetChildren();
    spawnNewMonsters();
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
  static int minMonstersInRow = 2;
  @visibleForTesting
  static List<Monster?> createNewRow({
    required Random random,
    required int monsterHp,
  }) {
    final monsterBools = List.filled(Monster.monstersPerRow, false);
    for (var i = 0; i < Monster.monstersPerRow; i++) {
      monsterBools[i] = random.nextDouble() < 0.3;
    }
    while (monsterBools.where((e) => e).length < minMonstersInRow) {
      monsterBools[random.nextInt(monsterBools.length)] = true;
    }

    final row = <Monster?>[
      for (var i = 0; i < monsterBools.length; i++)
        if (!monsterBools[i])
          null
        else
          Monster(
            initialPosition: Vector2(
              expectedWidth * i / Monster.monstersPerRow,
              Monster.topGap,
            ),
            maxHp: monsterHp,
          ),
    ];

    // one of the monsters should give the user a bullet when it dies
    int chosenIndex = random.nextInt(row.length);
    while (row[chosenIndex] == null) {
      chosenIndex = random.nextInt(row.length);
    }
    row[chosenIndex]!.givesPlayerABullet = true;

    return row;
  }
}
