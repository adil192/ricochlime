import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/pages/game_over.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

final ValueNotifier<int> _score = ValueNotifier(0);
final ValueNotifier<double> _timeDilation = ValueNotifier(1);
final game = RicochlimeGame(
  score: _score,
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
    game.showGameOverDialog = showGameOverDialog;
    if (game.state == GameState.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showGameOverDialog();
      });
    }
  }

  @override
  void dispose() {
    game.showGameOverDialog = null;
    game.cancelCurrentTurn();
    super.dispose();
  }

  Future<void> showGameOverDialog() async {
    assert(mounted);
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: _score.value,
        game: game,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    return ColoredBox(
      color: RicochlimePalette.grassColor,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: RicochlimePalette.grassColorDark.withOpacity(0.5),
                        blurRadius: 100,
                      ),
                      const BoxShadow(
                        color: RicochlimePalette.dirtColor,
                        spreadRadius: RicochlimeGame.expectedHeight * 0.05,
                        blurRadius: RicochlimeGame.expectedHeight * 0.1,
                        offset: Offset(0, RicochlimeGame.expectedHeight * 0.85),
                      ),
                      const BoxShadow(
                        color: RicochlimePalette.waterColor,
                        spreadRadius: RicochlimeGame.expectedHeight * 0.1,
                        blurRadius: RicochlimeGame.expectedHeight * 0.1,
                        offset: Offset(0, RicochlimeGame.expectedHeight * 0.9),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: RicochlimeGame.expectedWidth,
                    height: RicochlimeGame.expectedHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GameWidget(game: game),
                        ),
                        if (AdState.adsSupported)
                          const Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: BannerAdWidget(
                              adSize: AdSize.banner,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: textDirection,
              top: 0,
              start: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white.withOpacity(0.9),
                  size: 32,
                ),
              ),
            ),
            Positioned(
              top: -1,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Column(
                  children: [
                    const SizedBox(height: 2),
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
            Positioned.directional(
              textDirection: textDirection,
              top: 0,
              end: 0,
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ValueListenableBuilder(
                    valueListenable: _timeDilation,
                    builder: (context, timeDilation, child) => AnimatedOpacity(
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
          ],
        ),
      ),
    );
  }
}
