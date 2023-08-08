import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

final ValueNotifier<int> _score = ValueNotifier(0);
final game = RicochlimeGame(
  score: _score,
);

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  void dispose() {
    game.cancelCurrentTurn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gameWidth = RicochlimeGame.expectedWidth * RicochlimeGame.expectedZoom;
    const gameHeight = RicochlimeGame.expectedHeight * RicochlimeGame.expectedZoom;
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
                        spreadRadius: gameHeight * 0.05,
                        blurRadius: gameHeight * 0.1,
                        offset: Offset(0, gameHeight * 0.85),
                      ),
                      const BoxShadow(
                        color: RicochlimePalette.waterColor,
                        spreadRadius: gameHeight * 0.1,
                        blurRadius: gameHeight * 0.1,
                        offset: Offset(0, gameHeight * 0.9),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: gameWidth,
                    height: gameHeight,
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
