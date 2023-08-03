import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Background extends PositionComponent
    with HasGameRef<RicochlimeGame> {

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

    addAll([
      for (var column = 0; column < RicochlimeGame.tilesInWidth; column++)
        tile(
          row: RicochlimeGame.tilesInHeight - 5,
          column: column,
          type: BackgroundWaterTileType.bottomOfGrass,
        ),
      for (var row = RicochlimeGame.tilesInHeight - 4; row < RicochlimeGame.tilesInHeight; row++)
        for (var column = 0; column < RicochlimeGame.tilesInWidth; column++)
          tile(
            row: row,
            column: column,
            type: BackgroundWaterTileType.justWater,
          ),
    ]);
  }

  BackgroundWaterTile tile({
    required int row,
    required int column,
    required BackgroundWaterTileType type,
  }) => BackgroundWaterTile(
    position: Vector2(
      gameRef.size.x * column / RicochlimeGame.tilesInWidth,
      gameRef.size.y * row / RicochlimeGame.tilesInHeight,
    ),
    size: tileSize,
    type: type,
  );
}
