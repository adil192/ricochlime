import 'dart:math';

import 'package:flame/components.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/components/player.dart';
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
        Player.staticHeight * 0.5 -
        Monster.moveDownHeight * gameRef.numNewRowsEachRound;

    // Grass
    var left = 0.0;
    for (var y = 0.0; y < bridgeY; y += 8) {
      left = left * 0.8 + random.nextDouble() * 8 * 20 * 0.2;
      final right = left * 0.8 + random.nextDouble() * 8 * 20 * 0.2;
      for (var x = -left; x < gameRef.size.x + right; x += 8) {
        yield GrassSprite(
          position: Vector2(x, y),
          size: Vector2(8, 8),
        );
      }
    }
    for (var y = bridgeY + Monster.moveDownHeight; y < gameRef.size.y; y += 8) {
      left = left * 0.8 + random.nextDouble() * 8 * 20 * 0.2;
      final right = left * 0.8 + random.nextDouble() * 8 * 20 * 0.2;
      for (var x = -left; x < gameRef.size.x + right; x += 8) {
        yield GrassSprite(
          position: Vector2(x, y),
          size: Vector2(8, 8),
        );
      }
    }

    // Bushes along either side of the canvas
    const bushH = Monster.moveDownHeight * 31 / 27;
    const bushW = bushH / 2;
    final bushes = <BushSprite>[];
    for (var bushTop = bridgeY - bushH;
        bushTop >= -bushH;
        bushTop -= Monster.moveDownHeight) {
      bushes
        ..add(BushSprite(
          position: Vector2(-bushW * 14 / 15, bushTop),
          size: Vector2(bushW, bushH),
        ))
        ..add(BushSprite(
          position: Vector2(gameRef.size.x, bushTop),
          size: Vector2(bushW, bushH),
        ));
    }
    // reversed so we draw from the top down
    yield* bushes.reversed;

    // Bridges and water
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
  }

  /// Preloads all sprite sheets so they can be
  /// accessed synchronously later.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('overworld.png');
  }
}
