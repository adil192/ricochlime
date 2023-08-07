import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

final ValueNotifier<int> _score = ValueNotifier(0);
final game = RicochlimeGame(
  score: _score,
);

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

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
                valueListenable: _score,
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
            Positioned.directional(
              textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
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
          ],
        ),
      ),
    );
  }
}
