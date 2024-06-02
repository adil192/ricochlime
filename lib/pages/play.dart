import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/coin.dart';
import 'package:ricochlime/pages/ad_warning.dart';
import 'package:ricochlime/pages/game_over.dart';
import 'package:ricochlime/pages/restart_game.dart';
import 'package:ricochlime/utils/brightness_extension.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

final ValueNotifier<int> _score = ValueNotifier(0);
final ValueNotifier<bool> _isDarkMode = ValueNotifier(false);
final ValueNotifier<double> _timeDilation = ValueNotifier(1);
final game = RicochlimeGame(
  score: _score,
  isDarkMode: _isDarkMode,
  timeDilation: _timeDilation,
);

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  void initState() {
    super.initState();
    game
      ..showAdWarning = showAdWarning
      ..showGameOverDialog = showGameOverDialog
      ..resumeBgMusic();
    if (game.state.value == GameState.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => game.gameOver(),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RicochlimeGame.reduceMotion = MediaQuery.disableAnimationsOf(context);
    _isDarkMode.value = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void dispose() {
    game
      ..showAdWarning = null
      ..showGameOverDialog = null
      ..cancelCurrentTurn()
      ..pauseBgMusic();
    super.dispose();
  }

  /// Whether the game over dialog is currently showing,
  /// used to prevent multiple dialogs from showing at once.
  static bool showingGameOverDialog = false;

  Future<GameOverAction> showGameOverDialog() async {
    assert(mounted);
    if (!mounted) return GameOverAction.nothingYet;

    if (showingGameOverDialog) return GameOverAction.nothingYet;
    showingGameOverDialog = true;
    try {
      return await NesDialog.show<GameOverAction>(
            context: context,
            builder: (context) => GameOverDialog(
              score: _score.value,
              game: game,
            ),
          ) ??
          GameOverAction.nothingYet;
    } finally {
      showingGameOverDialog = false;
    }
  }

  /// Shows a warning dialog before showing a rewarded interstitial ad.
  /// Returns false if the user cancels the ad, true otherwise.
  Future<bool> showAdWarning() {
    final completer = Completer<bool>();

    final secondsLeft = ValueNotifier(3);
    final timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        secondsLeft.value--;
        if (secondsLeft.value <= 0) {
          timer.cancel();
          if (!completer.isCompleted) completer.complete(true);
          Navigator.of(context).pop();
        }
      },
    );

    unawaited(NesBottomSheet.show<void>(
      context: context,
      maxHeight: .2,
      builder: (_) => AdWarning(
        secondsLeft: secondsLeft,
        cancelAd: () {
          timer.cancel();
          if (!completer.isCompleted) completer.complete(false);
          Navigator.of(context).pop();
        },
      ),
    ));

    return completer.future;
  }

  final Future<bool> shouldShowBannerAd = AdState.shouldShowBannerAd();

  double _playerPos(Size screenSize) {
    final fitted = applyBoxFit(
      BoxFit.contain,
      const Size(RicochlimeGame.expectedWidth, RicochlimeGame.expectedHeight),
      screenSize,
    );
    final top = (screenSize.height - fitted.destination.height) / 2;
    return top + fitted.destination.height * 0.72;
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.sizeOf(context);
    final bgColor = _isDarkMode.value
        ? RicochlimePalette.waterColorDark
        : RicochlimePalette.waterColor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness.opposite,
        systemNavigationBarColor: _isDarkMode.value
            ? RicochlimePalette.waterColorDark
            : RicochlimePalette.waterColor,
        systemNavigationBarIconBrightness: colorScheme.brightness.opposite,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leadingWidth: 80,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              NesIconButton(
                onPress: () => Navigator.of(context).pop(),
                icon: NesIcons.leftArrowIndicator,
                primaryColor: Colors.white.withOpacity(0.9),
                secondaryColor:
                    RicochlimePalette.grassColorDark.withOpacity(0.9),
                size: const Size.square(20),
              ),
              const SizedBox(width: 16),
              NesTooltip(
                message: t.restartGameDialog.title,
                arrowPlacement: switch (textDirection) {
                  TextDirection.ltr => NesTooltipArrowPlacement.left,
                  TextDirection.rtl => NesTooltipArrowPlacement.right,
                },
                arrowDirection: NesTooltipArrowDirection.bottom,
                child: NesIconButton(
                  onPress: () => NesDialog.show(
                    context: context,
                    builder: (context) => RestartGameDialog(
                      restartGame: game.restartGame,
                    ),
                  ),
                  icon: NesIcons.redo,
                  primaryColor: Colors.white.withOpacity(0.9),
                  secondaryColor:
                      RicochlimePalette.grassColorDark.withOpacity(0.9),
                  size: const Size.square(20),
                ),
              ),
            ],
          ),
          centerTitle: true,
          title: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: Prefs.highScore,
                builder: (context, highScore, child) => Text(
                  highScore <= 0 ? '' : t.playPage.highScore(p: highScore),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: _score,
                builder: (context, score, child) => Text(
                  '$score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 32,
                    height: 0.7,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IgnorePointer(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: Prefs.coins,
                        builder: (context, coins, _) {
                          return Text(
                            coins >= 1000
                                ? '${(coins / 1000).toStringAsFixed(1)}K'
                                : coins.toString(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 32,
                              height: 0.65,
                            ),
                          );
                        },
                      ),
                      const CoinIcon(size: 24),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 2),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      child: SizedBox(
                        width: RicochlimeGame.expectedWidth,
                        height: RicochlimeGame.expectedHeight,
                        child: GameWidget(game: game),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: screenSize.height - _playerPos(screenSize),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IgnorePointer(
                            child: ValueListenableBuilder(
                              valueListenable: _timeDilation,
                              builder: (context, timeDilation, _) =>
                                  AnimatedOpacity(
                                opacity: timeDilation == 1.0 ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  '${timeDilation.toStringAsFixed(1)}x',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (Prefs.showUndoButton.value)
                            ValueListenableBuilder(
                              valueListenable: game.state,
                              builder: (context, state, child) {
                                final show = state == GameState.shooting;
                                return AnimatedOpacity(
                                  opacity: show ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: IgnorePointer(
                                    ignoring: !show,
                                    child: child,
                                  ),
                                );
                              },
                              child: NesTooltip(
                                message: t.playPage.undo,
                                arrowDirection: NesTooltipArrowDirection.bottom,
                                child: NesIconButton(
                                  onPress: () {
                                    game.cancelCurrentTurn();
                                    Prefs.totalMovesUndone.value++;
                                  },
                                  icon: NesIcons.delete,
                                  primaryColor: Colors.white.withOpacity(0.9),
                                  secondaryColor: RicochlimePalette
                                      .grassColorDark
                                      .withOpacity(0.9),
                                  size: const Size.square(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            FutureBuilder(
              future: shouldShowBannerAd,
              builder: (context, snapshot) {
                final showAd = snapshot.data ?? false;
                return SizedBox(
                  width: double.infinity,
                  child: showAd
                      ? const BannerAdWidget(adSize: AdSize.banner)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
