import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:forge2d/src/settings.dart' as physics_settings;
import 'package:logging/logging.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/flame/components/aim_guide.dart';
import 'package:ricochlime/flame/components/background/background.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/components/walls.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/flame/ticker.dart';
import 'package:ricochlime/pages/game_over.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:ricochlime/utils/shop_items.dart';

enum GameState {
  idle,
  shooting,
  monstersMoving,
  gameOver,
}

class RicochlimeGame extends Forge2DGame
    with PanDetector, TapDetector, MouseMovementDetector, SingleGameInstance {
  RicochlimeGame._()
      : super(
          gravity: Vector2.zero(),
          zoom: 1,
        ) {
    /// Sets the maximum movement per time step to [Bullet.speed].
    /// This effectively sets the max time step to 1s,
    /// rather than the default value which is much lower.
    physics_settings.maxTranslation = Bullet.speed;
  }

  static final instance = RicochlimeGame._();
  static final log = Logger('RicochlimeGame');

  /// Width to height aspect ratio
  static const aspectRatio = 0.6;

  static const expectedWidth = 128.0;
  static const expectedHeight = expectedWidth / aspectRatio;

  static const bulletTimeoutSecs = 60; // 1 minute

  late final ValueNotifier<GameState> state = ValueNotifier(GameState.idle)
    ..addListener(() {
      if (state.value != GameState.shooting) {
        timeDilation.value = 1.0;
      }
    });

  late Player player;
  late AimGuide aimGuide;
  late Background background;
  bool get inputAllowed => state.value == GameState.idle;
  bool inputCancelled = false;

  late var random = Random();

  static final score = ValueNotifier(0);
  static final isDarkMode = ValueNotifier(false);
  int numBullets = 1;
  int numNewRowsEachRound = 1;

  final Ticker ticker = Ticker();
  static final timeDilation = ValueNotifier<double>(1);

  Future<bool> Function()? showAdWarning;
  Future<GameOverAction> Function()? showGameOverDialog;

  /// A completer that completes when all the sprites are loaded.
  late final preloadSprites = () {
    final completer = Completer<bool>();
    Future.wait([
      Background.preloadSprites(gameRef: this),
      MonsterAnimation.preloadSprites(gameRef: this),
      Player.preloadSprites(gameRef: this),
      ShopItems.preloadSprites(gameRef: this),
    ]).then((_) => completer.complete(true));
    return completer;
  }();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    assert(size.x == expectedWidth);
    assert(size.y == expectedHeight);

    _initBgMusic();

    background = Background();
    add(background);

    createBoundaries(
      expectedWidth,
      expectedHeight,
      includeBottom: false,
    ).forEach(add);

    player = Player();
    add(player);

    aimGuide = AimGuide();
    add(aimGuide);

    await Prefs.currentGame.waitUntilLoaded();
    importFromGame(Prefs.currentGame.value);
  }

  /// Whether [_initBgMusic] has been run.
  bool bgMusicInitialized = false;

  /// Handles fading in/out the background music.
  Timer? _bgMusicFadeTimer;

  @visibleForTesting
  static bool disableBgMusic = false;

  /// Reduces sprite animations to make golden tests more predictable.
  /// If true, certain animations will just show the first frame.
  static bool reproducibleGoldenMode = false;

  /// Whether the user has the "Reduce motion" accessibility setting enabled.
  /// Not to be confused with [reproducibleGoldenMode] which turns off sprite
  /// animations and doesn't reduce moving elements.
  static bool reduceMotion = false;

  /// Initializes the background music,
  /// and starts playing it.
  void _initBgMusic() {
    if (disableBgMusic) return;
    if (Prefs.bgmVolume.value < 0.01) return;
    if (bgMusicInitialized) return;

    log.info('Initializing bg music');
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(
      'bgm/Ludum_Dare_32_Track_4.ogg',
      volume: Prefs.bgmVolume.value,
    );
    bgMusicInitialized = true;
  }

  Future<void> preloadBgMusic() async {
    if (disableBgMusic) return;
    if (Prefs.bgmVolume.value < 0.01) return;
    await FlameAudio.audioCache.load('bgm/Ludum_Dare_32_Track_4.ogg');
  }

  void pauseBgMusic() {
    if (disableBgMusic) return;
    if (Prefs.bgmVolume.value < 0.01) return;
    if (!bgMusicInitialized) return;

    log.info('Fading out bg music');
    _bgMusicFadeTimer?.cancel();
    _bgMusicFadeTimer = _fadeBgmInOut(
      startingVolume: FlameAudio.bgm.audioPlayer.volume,
      targetVolume: 0,
      onFinished: FlameAudio.bgm.pause,
    );
  }

  void resumeBgMusic() {
    if (disableBgMusic) return;
    if (Prefs.bgmVolume.value < 0.01) return;
    if (!bgMusicInitialized) _initBgMusic();
    if (!bgMusicInitialized) return;

    log.info('Fading in bg music');
    _bgMusicFadeTimer?.cancel();
    _bgMusicFadeTimer = _fadeBgmInOut(
      startingVolume: FlameAudio.bgm.audioPlayer.volume,
      targetVolume: Prefs.bgmVolume.value,
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
          log.info('Finished fading bgm in/out to $targetVolume');
        } else {
          FlameAudio.bgm.audioPlayer.setVolume(newVolume);
        }
      },
    );
  }

  /// Imports the game state from [data], or resets the game if [data] is null.
  ///
  /// If [showGameOverDialog] is true, the game over dialog will be shown
  /// if [isGameOver] returns true.
  void importFromGame(GameData? data, {bool showGameOverDialog = true}) {
    if (data == null) {
      // new game
      _reset();
      return;
    }

    int numMonstersThatGiveBullets = 0;
    bool topGapNeedsAdjusting = false;
    for (final monsterJson in data.monsters) {
      final monster = Monster.fromJson(monsterJson);
      add(monster);

      if (monster.killReward == KillReward.bullet) numMonstersThatGiveBullets++;
      if (monster.position.y <= 0) topGapNeedsAdjusting = true;
    }

    if (topGapNeedsAdjusting) {
      // the top gap needs adjusting because the monsters were imported from a
      // previous version of the game
      for (final monster in children.whereType<Monster>()) {
        monster.position.y += Monster.topGap;
      }
    }

    score.value = data.score;
    numBullets = 1 + score.value - numMonstersThatGiveBullets;
    assert(numBullets >= 1);
    assert(numBullets <= score.value);
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);

    if (showGameOverDialog && isGameOver()) {
      if (reproducibleGoldenMode) {
        gameOver();
      } else {
        // allow the game to render before showing the game over dialog
        Future.delayed(const Duration(milliseconds: 200), gameOver);
      }
    } else {
      state.value = GameState.idle;
    }
  }

  Future saveGame() async {
    final monsters = children.whereType<Monster>().toList();
    assert(
      monsters.any((monster) => monster.position.y <= Monster.topGap),
      'The new row of monsters should be spawned before saving the game',
    );
    if (monsters.any((monster) => monster.isRagdolling)) {
      log.warning('Not saving game because the monsters are ragdolling');
      return;
    }

    Prefs.currentGame.value = GameData(
      score: score.value,
      monsters: monsters.where((monster) => !monster.isDead),
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

    resetChildren();
    importFromGame(Prefs.currentGame.value);
  }

  /// Clears the current bullets and monsters
  @visibleForTesting
  void resetChildren() {
    removeWhere((component) => component is Bullet);
    removeWhere((component) => component is Monster);
    removeWhere((component) => component is MonsterAnimation);
  }

  @override
  Color backgroundColor() => isDarkMode.value
      ? RicochlimePalette.waterColorDark
      : RicochlimePalette.waterColor;

  /// If the user wants to limit the frame rate to e.g. 30fps,
  /// this is used to sum up the dt values
  /// and only update the game when the sum is greater than 1/30.
  double groupedUpdateDt = 0;

  @override
  void update(double dt) {
    const maxDt = 0.5;
    if (dt > maxDt) {
      // physics engine can't handle such a big dt
      // e.g. when the app is resumed from background
      return;
    }

    groupedUpdateDt += dt;
    final minDt = 1 / Prefs.maxFps.value;
    if (groupedUpdateDt < minDt) return;

    dt = min(groupedUpdateDt * timeDilation.value, maxDt);
    groupedUpdateDt = 0;

    ticker.tick(dt);
    super.update(dt);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    aimGuide.lastMousePosition = info.eventPosition.widget;
    if (!inputAllowed) return;
    aimGuide.aim(info.eventPosition.widget);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    aimGuide.lastMousePosition = null;
    if (!inputAllowed) return;
    _spawnBullets();
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (state.value == GameState.shooting) {
      timeDilation.value += 0.5;
    } else if (inputAllowed && pointAndClickEnabled) {
      _spawnBullets();
    }
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    if (!pointAndClickEnabled) return;
    aimGuide.lastMousePosition = info.eventPosition.widget;
    if (!inputAllowed) return;
    aimGuide.aim(info.eventPosition.widget,
        ignoreWhetherMouseIsBelowPlayer: true);
  }

  /// Whether to allow point-and-click input in addition to
  /// the drag-and-release input.
  ///
  /// This is disabled on mobile as it would be too easy to accidentally
  /// tap and trigger a move.
  bool get pointAndClickEnabled =>
      kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  Future<void> _spawnBullets() async {
    final aimDir = aimGuide.finishAim();
    if (aimDir == null) {
      return;
    }

    assert(inputAllowed);
    state.value = GameState.shooting;
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
        if (inputCancelled) return;
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
        log.info('Bullet timeout reached');
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
      if (state.value != GameState.gameOver) {
        state.value = GameState.idle;
      }
      inputCancelled = false;
    }
  }

  /// Moves the existing monsters down and spawns new ones at the top
  Future<void> spawnNewMonsters() async {
    const monsterMoveSeconds = 1;
    const monsterMoveDuration = Duration(seconds: monsterMoveSeconds);

    state.value = GameState.monstersMoving;

    if (!notEnoughAdsTimer.isActive) unawaited(showRewardedInterstitial());

    // move monsters down and spawn new ones at the top
    assert(numNewRowsEachRound == getNumNewRowsEachRound(score.value));
    for (int i = 0; i < numNewRowsEachRound; ++i) {
      // move existing monsters down
      for (final monster in children.whereType<Monster>()) {
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

        add(monster);
        monster.moveInFromTop(monsterMoveDuration);
      }

      // wait for the monsters to move
      var elapsedSeconds = 0.0;
      await for (final tick in ticker.onTick) {
        if (inputCancelled) return;
        elapsedSeconds += tick;
        if (elapsedSeconds >= monsterMoveSeconds) break;
      }

      // check if the player has lost
      if (isGameOver()) {
        Prefs.totalGameOvers.value++;
        unawaited(saveGame());
        unawaited(gameOver());
        unawaited(showRewardedInterstitial());
        return;
      }
    }
    numNewRowsEachRound = getNumNewRowsEachRound(score.value);
    state.value = GameState.idle;

    if (aimGuide.lastMousePosition != null) {
      // Show aim guide again if the user started an input while !inputEnabled
      aimGuide.aim(aimGuide.lastMousePosition!);
    }

    await saveGame();
  }

  bool isGameOver() {
    final threshold = player.bottomY - Monster.staticHeight * 2;
    return children
        .whereType<Monster>()
        .any((monster) => monster.position.y >= threshold);
  }

  /// A timer that prevents rewarded interstitial ads from being shown too
  /// often.
  ///
  /// There are no rewarded interstitials in the first 2 minutes of the game,
  /// and no more than one every 5 minutes.
  ///
  /// If this timer is active, don't show any interstitial ads.
  Timer tooManyAdsTimer =
      Timer(kDebugMode ? Duration.zero : const Duration(minutes: 2), () {});

  /// A timer that shows an ad after the user plays a turn,
  /// if no ads have been shown in a while.
  ///
  /// If this timer is active, don't show an ad in between turns.
  Timer notEnoughAdsTimer =
      Timer(kDebugMode ? Duration.zero : const Duration(minutes: 5), () {});

  Future<void> showRewardedInterstitial() async {
    if (!AdState.rewardedInterstitialAdsSupported) return;

    if (tooManyAdsTimer.isActive) return;
    tooManyAdsTimer = Timer(const Duration(minutes: 5), () {});

    final showAd = await showAdWarning?.call() ?? false;
    if (!showAd) {
      // user cancelled the ad, ask again soon
      tooManyAdsTimer.cancel();
      tooManyAdsTimer = Timer(const Duration(minutes: 1), () {});
      return;
    }

    notEnoughAdsTimer.cancel();
    notEnoughAdsTimer = Timer(const Duration(minutes: 5), () {});

    final rewardGranted = await AdState.showRewardedInterstitialAd();
    if (!rewardGranted) return;

    Prefs.totalAdsWatched.value++;
    Prefs.addCoins(100, allowOverMax: true);
  }

  Future<void> gameOver() async {
    state.value = GameState.gameOver;
    assert(!inputAllowed);

    // all monsters drop down
    bool startedRagdolling = false;
    for (final monster in children.whereType<Monster>()) {
      if (monster.isRagdolling) continue;
      startedRagdolling = true;
      monster.startRagdoll();
    }
    if (startedRagdolling) await ticker.delayed(const Duration(seconds: 2));

    final gameOverAction = showGameOverDialog == null
        ? GameOverAction.nothingYet
        : await showGameOverDialog!.call();
    log.info('gameOverAction: $gameOverAction');

    switch (gameOverAction) {
      case GameOverAction.nothingYet:
        // do nothing
        break;
      case GameOverAction.continueGame:
        state.value = GameState.monstersMoving;
        importFromGame(Prefs.currentGame.value, showGameOverDialog: false);

        final totalRowsToRemove = max(
          // clears 3 rounds worth of monsters
          // plus the one that killed the player
          numNewRowsEachRound * 3 + 1,
          // or at least 5 rows
          5,
        );
        try {
          for (int numRowsToRemove = 0;
              numRowsToRemove < totalRowsToRemove;
              ++numRowsToRemove) {
            final threshold =
                player.bottomY - numRowsToRemove * Monster.staticHeight;
            log.info('Removing row $numRowsToRemove out of $totalRowsToRemove '
                '(monsters with y > $threshold)');

            bool removedAnyMonsters = false;
            for (final monster in children.whereType<Monster>()) {
              if (monster.position.y > threshold) {
                removedAnyMonsters = true;
                monster.hp = 0;
              }
            }

            if (removedAnyMonsters && numRowsToRemove < totalRowsToRemove - 1) {
              await ticker.delayed(const Duration(milliseconds: 500));
            }
          }

          await saveGame();
        } finally {
          state.value = GameState.idle;
        }
      case GameOverAction.restartGame:
        restartGame();
    }
  }

  /// Restarts the game:
  /// Saves the high score,
  /// and clears the current game.
  void restartGame() {
    Future.delayed(const Duration(milliseconds: 100), showRewardedInterstitial);
    Prefs.highScore.value = max(Prefs.highScore.value, score.value);
    Prefs.currentGame.value = null;
    _reset();
  }

  /// Resets the game:
  /// sets the score to zero,
  /// and spawns a single row of monsters.
  Future<void> _reset() async {
    state.value = GameState.idle;
    inputCancelled = false;
    score.value = 0;
    numBullets = 1;
    numNewRowsEachRound = 1;
    resetChildren();
    try {
      await spawnNewMonsters();
    } finally {
      inputCancelled = false;
      state.value = GameState.idle;
    }
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

    // one of the monsters should give the user a bullet
    int bulletRewardIndex = random.nextInt(row.length);
    while (row[bulletRewardIndex] == null ||
        row[bulletRewardIndex]!.killReward != KillReward.none) {
      bulletRewardIndex = random.nextInt(row.length);
    }
    row[bulletRewardIndex]!.killReward = KillReward.bullet;

    // one of the monsters should give the user a coin
    int coinRewardIndex = random.nextInt(row.length);
    while (row[coinRewardIndex] == null ||
        row[coinRewardIndex]!.killReward != KillReward.none) {
      coinRewardIndex = random.nextInt(row.length);
    }
    row[coinRewardIndex]!.killReward = KillReward.coin;

    // Note: If you're adding new rewards, make sure to update
    // [minMonstersInRow] to avoid an infinite loop.

    return row;
  }
}
