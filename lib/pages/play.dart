import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/coin.dart';
import 'package:ricochlime/pages/game_over.dart';
import 'package:ricochlime/pages/restart_game.dart';
import 'package:ricochlime/utils/brightness_extension.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:ricochlime/utils/stows.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  void initState() {
    super.initState();
    RicochlimeGame.instance
      ..showGameOverDialog = showGameOverDialog
      ..resumeBgMusic();
    if (RicochlimeGame.instance.state.value == .gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => RicochlimeGame.instance.gameOver(),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RicochlimeGame.reduceMotion = MediaQuery.disableAnimationsOf(context);
    RicochlimeGame.isDarkMode.value =
        Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void dispose() {
    RicochlimeGame.instance
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
    if (!mounted) return .nothingYet;

    if (showingGameOverDialog) return .nothingYet;
    showingGameOverDialog = true;
    try {
      return await NesDialog.show<GameOverAction>(
            context: context,
            builder: (context) => GameOverDialog(
              score: RicochlimeGame.score.value,
              game: RicochlimeGame.instance,
            ),
          ) ??
          .nothingYet;
    } finally {
      showingGameOverDialog = false;
    }
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.sizeOf(context);
    final bgColor = RicochlimeGame.isDarkMode.value
        ? RicochlimePalette.waterColorDark
        : RicochlimePalette.waterColor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness.opposite,
        systemNavigationBarColor: RicochlimeGame.isDarkMode.value
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
          leadingWidth: 80 + (stows.showFpsCounter.value ? (16 + 24 * 3) : 0),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              NesIconButton(
                onPress: () => Navigator.of(context).pop(),
                icon: NesIcons.leftArrowIndicator,
                primaryColor: Colors.white.withValues(alpha: 0.9),
                secondaryColor: RicochlimePalette.grassColorDark.withValues(
                  alpha: 0.9,
                ),
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
                      restartGame: RicochlimeGame.instance.restartGame,
                    ),
                  ),
                  icon: NesIcons.redo,
                  primaryColor: Colors.white.withValues(alpha: 0.9),
                  secondaryColor: RicochlimePalette.grassColorDark.withValues(
                    alpha: 0.9,
                  ),
                  size: const Size.square(20),
                ),
              ),
              if (stows.showFpsCounter.value) ...[
                const SizedBox(width: 16),
                const FpsCounter(),
              ],
            ],
          ),
          centerTitle: true,
          title: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: stows.highScore,
                builder: (context, highScore, child) => Text(
                  highScore <= 0 ? '' : t.playPage.highScore(p: highScore),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: RicochlimeGame.score,
                builder: (context, score, child) => Text(
                  '$score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 32,
                    height: 0.7,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                IgnorePointer(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: stows.coins,
                        builder: (context, coins, _) {
                          return Text(
                            coins.toString(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
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
                    child: Padding(
                      padding: theme.platform == TargetPlatform.android
                          // Some space to avoid back gestures on Android
                          ? const EdgeInsets.symmetric(horizontal: 8)
                          : EdgeInsets.zero,
                      child: FittedBox(
                        child: SizedBox(
                          width: RicochlimeGame.expectedWidth,
                          height: RicochlimeGame.expectedHeight,
                          child: GameWidget(game: RicochlimeGame.instance),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: screenSize.height - _playerPos(screenSize),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: .end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: .center,
                        children: [
                          IgnorePointer(
                            child: ValueListenableBuilder(
                              valueListenable: RicochlimeGame.timeDilation,
                              builder: (context, timeDilation, _) =>
                                  AnimatedOpacity(
                                    opacity: timeDilation == 1.0 ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      '${timeDilation.toStringAsFixed(1)}x',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          if (stows.showUndoButton.value)
                            ValueListenableBuilder(
                              valueListenable: RicochlimeGame.instance.state,
                              builder: (context, state, child) {
                                final show = state == .shooting;
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
                                    RicochlimeGame.instance.cancelCurrentTurn();
                                    stows.totalMovesUndone.value++;
                                  },
                                  icon: NesIcons.delete,
                                  primaryColor: Colors.white.withValues(
                                    alpha: 0.9,
                                  ),
                                  secondaryColor: RicochlimePalette
                                      .grassColorDark
                                      .withValues(alpha: 0.9),
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
          ],
        ),
      ),
    );
  }
}

class FpsCounter extends StatelessWidget {
  const FpsCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RicochlimeGame.fpsStream,
      builder: (context, fpsSnapshot) {
        final int fps = fpsSnapshot.data ?? RicochlimeGame.fps;
        return Text(
          fps.toString(),
          style: TextStyle(
            fontSize: 24,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        );
      },
    );
  }
}
