import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/components/slime.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class Background extends PositionComponent
    with HasGameRef<RicochlimeGame> {
  
  static const waterThresholdTile = RicochlimeGame.tilesInHeight - 4;
  static const waterThresholdPosition = RicochlimeGame.expectedHeight
      * waterThresholdTile / RicochlimeGame.tilesInHeight;

  late Vector2 tileSize;
  int lastNumNewRowsEachRound = -1;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2.zero();
    size = gameRef.size;
    priority = Slime.minPriority - 1;

    tileSize = Vector2(
      gameRef.size.x / RicochlimeGame.tilesInWidth,
      gameRef.size.y / RicochlimeGame.tilesInHeight,
    );

    lastNumNewRowsEachRound = gameRef.numNewRowsEachRound;
    addAll(getTiles());
  }

  @override
  void update(double dt) {
    if (lastNumNewRowsEachRound != gameRef.numNewRowsEachRound) {
      lastNumNewRowsEachRound = gameRef.numNewRowsEachRound;
      removeWhere((component) => component is BackgroundTile);
      addAll(getTiles());
    }
    super.update(dt);
  }

  Iterable<BackgroundTile> getTiles() sync* {
    for (var row = 0; row < RicochlimeGame.tilesInHeight; row++) {
      for (var column = 0; column < RicochlimeGame.tilesInWidth; column++) {
        final type = getTileType(row, column);
        if (type == null) continue;
        yield BackgroundTile(
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

  /// Determines the type of background tile at the given row and column.
  /// This includes a soil patch for the area wherein the slimes will
  /// reach the end in the next round,
  /// as well as the water and grass tiles.
  BackgroundTileType? getTileType(int row, int column) {
    if (lastNumNewRowsEachRound <= 1) {
      if (row == waterThresholdTile - 1) {
        if (column == 0) {
          return BackgroundTileType.leftOfThinSoil;
        } else if (column == RicochlimeGame.tilesInWidth - 1) {
          return BackgroundTileType.rightOfThinSoil;
        } else {
          return BackgroundTileType.centerOfThinSoil;
        }
      }
    } else {
      final topOfSoil = waterThresholdTile - lastNumNewRowsEachRound;
      const bottomOfSoil = waterThresholdTile - 1;
      if (row == topOfSoil) {
        if (column == 0) {
          return BackgroundTileType.topLeftOfSoil;
        } else if (column == RicochlimeGame.tilesInWidth - 1) {
          return BackgroundTileType.topRightOfSoil;
        } else {
          return BackgroundTileType.topCenterOfSoil;
        }
      } else if (row == bottomOfSoil) {
        if (column == 0) {
          return BackgroundTileType.bottomLeftOfSoil;
        } else if (column == RicochlimeGame.tilesInWidth - 1) {
          return BackgroundTileType.bottomRightOfSoil;
        } else {
          return BackgroundTileType.bottomCenterOfSoil;
        }
      } else if (row > topOfSoil && row < bottomOfSoil) {
        if (column == 0) {
          return BackgroundTileType.centerLeftOfSoil;
        } else if (column == RicochlimeGame.tilesInWidth - 1) {
          return BackgroundTileType.centerRightOfSoil;
        } else {
          return BackgroundTileType.centerCenterOfSoil;
        }
      }
    }
    
    if (row == waterThresholdTile) {
      return BackgroundTileType.bottomOfGrass;
    } else if (row > waterThresholdTile) {
      return BackgroundTileType.justWater;
    } else {
      // grass tiles just use the background color instead of a tile
      return null;
    }
  }
}
