import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

/// The background component which contains all the background tiles.
class Background extends PositionComponent with HasGameRef<RicochlimeGame> {
  final List<DarkeningSprite> tiles = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2.zero();
    size = gameRef.size;
    priority = Monster.minPriority - 1;
  }

  /// The number of new rows of monsters that will be added
  /// in the next round.
  int _lastNumNewRowsEachRound = -1;

  @override
  void update(double dt) {
    if (_lastNumNewRowsEachRound != gameRef.numNewRowsEachRound) {
      _lastNumNewRowsEachRound = gameRef.numNewRowsEachRound;
      _updateChildren();
    }
    super.update(dt);
  }

  void _updateChildren() {
    tiles
      ..clear()
      ..addAll(_getTiles());
    removeWhere((component) => component is DarkeningSprite);
    addAll(tiles);
  }

  /// Returns an iterable of all the background tiles.
  /// Used in [_updateChildren].
  Iterable<DarkeningSprite> _getTiles() sync* {
    add(HouseSprite(
      position: gameRef.player.position + Vector2(-45, 0),
      size: Vector2(80, 80),
    ));
    add(HouseSprite(
      position: gameRef.player.position + Vector2(45, 0),
      size: Vector2(80, 80),
    ));
    /*for (var row = 0; row < RicochlimeGame.tilesInHeight; row++) {
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
    }*/
  }

  /// Preloads all sprite sheets so they can be
  /// accessed synchronously later.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('overworld.png');
  }
}
