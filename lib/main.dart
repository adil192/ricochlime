import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final game = RicochlimeGame();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RicochlimePalette.grassColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: RicochlimePalette.grassColorDark.withOpacity(0.5),
                  blurRadius: 100,
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
    );
  }
}
