import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/dialog_button.dart';
import 'package:ricochlime/utils/prefs.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.score,
    required this.game,
  });

  final int score;
  final RicochlimeGame game;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Text(
                t.gameOverPage.title,
                style: const TextStyle(
                  fontSize: kToolbarHeight,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: TextStyle(
                      fontSize: kToolbarHeight / 2,
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      if (score > Prefs.highScore.value &&
                          Prefs.highScore.value > 0)
                        t.gameOverPage.highScoreBeaten(
                          pOld: TextSpan(
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: kToolbarHeight / 20,
                              decorationColor:
                                  colorScheme.onSurface.withOpacity(0.6),
                            ),
                            text: ' ${Prefs.highScore.value} ',
                          ),
                          pNew: TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: kToolbarHeight / 2,
                            ),
                            text: '$score',
                          ),
                        )
                      else
                        TextSpan(
                          text: t.gameOverPage.highScoreNotBeaten(
                            p: score,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (AdState.rewardedAdsSupported) ...[
                DialogButton(
                  onPressed: () async {
                    final rewardGranted = await AdState.showRewardedAd();
                    if (!context.mounted) return;
                    if (rewardGranted) {
                      Navigator.of(context).pop<GameOverAction>(
                        GameOverAction.continueGame,
                      );
                    }
                  },
                  type: NesButtonType.primary,
                  icon: NesIcons.tv,
                  text: t.gameOverPage.continueWithAdButton,
                ),
                const SizedBox(height: 32),
              ],
              DialogButton(
                onPressed: () {
                  Navigator.of(context).pop<GameOverAction>(
                    GameOverAction.restartGame,
                  );
                },
                type: NesButtonType.primary,
                icon: NesIcons.redo,
                text: t.gameOverPage.restartGameButton,
              ),
              const SizedBox(height: 32),
              DialogButton(
                onPressed: () {
                  Navigator.of(context)
                    // pop dialog
                    ..pop<GameOverAction>(GameOverAction.nothingYet)
                    // pop play page
                    ..pop();
                },
                icon: NesIcons.leftArrowIndicator,
                text: t.gameOverPage.homeButton,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum GameOverAction {
  continueGame,
  restartGame,
  nothingYet,
}
