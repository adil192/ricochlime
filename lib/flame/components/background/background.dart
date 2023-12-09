import 'dart:math';

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
    final random = Random(123);
    final bridgeY = gameRef.player.position.y -
        Monster.moveDownHeight * gameRef.numNewRowsEachRound;

    for (var y = 0.0; y < bridgeY; y += 8) {
      final left = random.nextDouble() * 8;
      final right = random.nextDouble() * 8;
      for (var x = -left; x < gameRef.size.x + right; x += 8) {
        yield GrassSprite(
          position: Vector2(x, y),
          size: Vector2(8, 8),
        );
      }
    }
    for (var y = bridgeY + Monster.moveDownHeight; y < gameRef.size.y; y += 8) {
      final left = random.nextDouble() * 8;
      final right = random.nextDouble() * 8;
      for (var x = -left; x < gameRef.size.x + right; x += 8) {
        yield GrassSprite(
          position: Vector2(x, y),
          size: Vector2(8, 8),
        );
      }
    }

    {
      final y = bridgeY;
      const waterSize = Monster.moveDownHeight * 0.75;
      final gameWidth = gameRef.size.x;
      for (var x = -gameWidth * 2; x < gameWidth * 3; x += waterSize) {
        yield WaterSprite(
          position: Vector2(x, y + (Monster.moveDownHeight - waterSize) / 2),
          size: Vector2(waterSize, waterSize),
        );
      }
      for (var x = 0.0; x < gameWidth; x += Monster.staticWidth) {
        yield BridgeSprite(
          position: Vector2(x, y),
          size: Vector2(Monster.staticWidth, Monster.moveDownHeight),
        );
      }
    }

    yield HouseSprite(
      position: gameRef.player.position + Vector2(-45, 0),
      size: Vector2(80, 80),
    );
    yield HouseSprite(
      position: gameRef.player.position + Vector2(45, 0),
      size: Vector2(80, 80),
    );
  }

  /// Preloads all sprite sheets so they can be
  /// accessed synchronously later.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('overworld.png');
  }
}
