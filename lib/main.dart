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
      child: SafeArea(
        child: FittedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: RicochlimePalette.grassColorDark.withOpacity(0.5),
                  blurRadius: 100,
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
    );
  }
}
