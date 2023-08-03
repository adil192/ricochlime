import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Background extends PositionComponent
    with HasGameRef<RicochlimeGame> {

  static const tilesPerRow = 10;
  static const tilesPerColumn = tilesPerRow
      * RicochlimeGame.expectedHeight ~/ RicochlimeGame.expectedWidth;

  late Vector2 tileSize;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2.zero();
    size = gameRef.size;

    tileSize = Vector2(
      gameRef.size.x / tilesPerRow,
      gameRef.size.y / tilesPerColumn,
    );

    addAll([
      for (var column = 0; column < tilesPerRow; column++)
        tile(
          row: tilesPerColumn - 5,
          column: column,
          type: BackgroundWaterTileType.bottomOfGrass,
        ),
      for (var row = tilesPerColumn - 4; row < tilesPerColumn; row++)
        for (var column = 0; column < tilesPerRow; column++)
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
      gameRef.size.x * column / tilesPerRow,
      gameRef.size.y * row / tilesPerColumn,
    ),
    size: tileSize,
    type: type,
  );
}
