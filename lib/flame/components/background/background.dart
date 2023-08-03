import 'dart:math';

import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Background extends PositionComponent
    with HasGameRef<RicochlimeGame> {

  static const tilesPerRow = 10;
  static const tilesPerColumn = tilesPerRow
      * RicochlimeGame.expectedHeight ~/ RicochlimeGame.expectedWidth;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2.zero();
    size = gameRef.size;

    final tileSize = Vector2(
      gameRef.size.x / tilesPerRow,
      gameRef.size.y / tilesPerColumn,
    );

    final random = Random();
    addAll([
      for (var row = 0; row < tilesPerColumn; row++)
        for (var column = 0; column < tilesPerRow; column++)
          BackgroundWaterTile.random(
            position: Vector2(
              gameRef.size.x * column / tilesPerRow,
              gameRef.size.y * row / tilesPerColumn,
            ),
            size: tileSize,
            random: random,
          ),
    ]);
  }
}
