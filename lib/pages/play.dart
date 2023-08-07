import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

class PlayPage extends StatelessWidget {
  PlayPage({super.key});

  final ValueNotifier<int> score = ValueNotifier(0);
  late final game = RicochlimeGame(
    score: score,
  );

  @override
  Widget build(BuildContext context) {
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
                    child: GameWidget(game: game),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: score,
                builder: (context, value, child) => Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 32,
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
