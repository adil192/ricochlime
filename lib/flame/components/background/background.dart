import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Background extends PositionComponent
    with HasGameRef<RicochlimeGame> {
  
  static const waterThresholdTile = RicochlimeGame.tilesInHeight - 4;
  static const waterThresholdPosition = RicochlimeGame.expectedHeight
      * waterThresholdTile / RicochlimeGame.tilesInHeight;

  late Vector2 tileSize;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2.zero();
    size = gameRef.size;

    tileSize = Vector2(
      gameRef.size.x / RicochlimeGame.tilesInWidth,
      gameRef.size.y / RicochlimeGame.tilesInHeight,
    );

    addAll(getTiles());
  }

  Iterable<BackgroundWaterTile> getTiles() sync* {
    for (var row = waterThresholdTile + 1; row < RicochlimeGame.tilesInHeight; row++) {
      for (var column = 0; column < RicochlimeGame.tilesInWidth; column++) {
        final BackgroundWaterTileType type;
        if (row == waterThresholdTile) {
          type = BackgroundWaterTileType.bottomOfGrass;
        } else if (row > waterThresholdTile) {
          type = BackgroundWaterTileType.justWater;
        } else {
          continue;
        }

        yield BackgroundWaterTile(
          position: Vector2(
            gameRef.size.x * column / RicochlimeGame.tilesInWidth,
            gameRef.size.y * row / RicochlimeGame.tilesInHeight,
          ),
          size: tileSize,
          type: type,
        );
      }
    }
  }
}
