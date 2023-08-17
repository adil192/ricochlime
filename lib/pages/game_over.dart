import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
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
    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                t.gameOverPage.title,
                style: const TextStyle(
                  fontSize: kToolbarHeight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: kToolbarHeight / 2,
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    if (score > Prefs.highScore.value && Prefs.highScore.value > 0)
                      t.gameOverPage.highScoreBeaten(
                        pOld: TextSpan(
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: kToolbarHeight / 20,
                            decorationColor: colorScheme.onSurface.withOpacity(0.6),
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
                        text: t.gameOverPage.highScoreNotBeaten(p: score),
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(children: [
                _GameOverButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: t.gameOverPage.playAgainButton,
                ),
                const SizedBox(height: 32),
                _GameOverButton(
                  onPressed: () {
                    context.pop(); // pop dialog
                    context.pop(); // pop play page
                  },
                  text: t.gameOverPage.homeButton,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverButton extends StatelessWidget {
  const _GameOverButton({
    // ignore: unused_element
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 28;
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: buttonSize,
              vertical: buttonSize / 2,
            ),
          ),
        ),
        child: Text(
          text,
          softWrap: false,
          style: const TextStyle(
            fontSize: buttonSize,
          ),
        ),
      ),
    );
  }
}
