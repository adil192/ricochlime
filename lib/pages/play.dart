import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
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
      ..showGameOverDialog = showGameOverDialog
      ..resumeBgMusic();
    if (game.state == GameState.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => game.gameOver(),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDarkMode.value = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void dispose() {
    game
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

  final Future<bool> shouldShowBannerAd = AdState.shouldShowBannerAd();

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final colorScheme = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness.opposite,
        systemNavigationBarColor: _isDarkMode.value
            ? RicochlimePalette.grassColorDark
            : RicochlimePalette.grassColor,
        systemNavigationBarIconBrightness: colorScheme.brightness.opposite,
      ),
      child: Scaffold(
        body: ColoredBox(
          color: _isDarkMode.value
              ? RicochlimePalette.grassColorDark
              : RicochlimePalette.grassColor,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    child: SizedBox(
                      width: RicochlimeGame.expectedWidth,
                      height: RicochlimeGame.expectedHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GameWidget(game: game),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: FutureBuilder(
                              future: shouldShowBannerAd,
                              builder: (context, snapshot) {
                                return snapshot.data ?? false
                                    ? const BannerAdWidget(
                                        adSize: AdSize.banner)
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.directional(
                  textDirection: textDirection,
                  top: kToolbarHeight / 4,
                  start: kToolbarHeight / 4,
                  child: NesIconButton(
                    onPress: () => Navigator.of(context).pop(),
                    icon: NesIcons.leftArrowIndicator,
                    primaryColor: Colors.white.withOpacity(0.9),
                    secondaryColor:
                        RicochlimePalette.grassColorDark.withOpacity(0.9),
                    size: const Size.square(20),
                  ),
                ),
                Positioned.directional(
                  textDirection: textDirection,
                  top: kToolbarHeight / 4,
                  end: kToolbarHeight / 4,
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
                Positioned(
                  top: -1,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        ValueListenableBuilder(
                          valueListenable: Prefs.highScore,
                          builder: (context, highScore, child) => Text(
                            highScore <= 0
                                ? ''
                                : t.playPage.highScore(p: highScore),
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
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
