import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/components/monster.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/random_extension.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

/// The background component which contains all the background tiles.
class Background extends PositionComponent
    with HasGameReference<RicochlimeGame> {
  late final bottomOfIsland =
      game.player.position.y + Player.staticHeight * 0.5 + 8;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2.zero();
    size = game.size;
    priority = Monster.minPriority - 1;
  }

  /// The number of new rows of monsters that will be added
  /// in the next round.
  int _lastNumNewRowsEachRound = -1;

  @override
  void update(double dt) {
    if (_lastNumNewRowsEachRound != game.numNewRowsEachRound) {
      _lastNumNewRowsEachRound = game.numNewRowsEachRound;
      _updateChildren();
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Draw the grass color
    final grassColor = RicochlimeGame.isDarkMode.value
        ? RicochlimePalette.grassColorDark
        : RicochlimePalette.grassColor;
    canvas.drawRect(
      Rect.fromLTRB(4, 4, size.x - 4, bottomOfIsland - 4),
      Paint()..color = grassColor,
    );
  }

  void _updateChildren() {
    removeWhere((component) => component is SpriteComponent);
    addAll(_getTiles());
  }

  /// Returns an iterable of all the background tiles.
  /// Used in [_updateChildren].
  Iterable<SpriteComponent> _getTiles() sync* {
    final random = Random(123);

    yield* _getGrassTuftTiles(random);
    yield* _getIslandTiles(random);
    yield* getSkullTiles();
  }

  Iterable<SpriteComponent> _getGrassTuftTiles(Random random) sync* {
    double left = 0;
    double x, y;
    for (y = 8; y < bottomOfIsland - 8; y += 8) {
      left = 0.8 * left + 0.2 * random.plusOrMinus(4);
      for (x = left + 8; x < game.size.x - 8; x += 8) {
        if (random.nextBool()) continue;
        yield GrassSprite(position: Vector2(x, y), size: Vector2(8, 8));
      }
    }
  }

  Iterable<SpriteComponent> _getIslandTiles(Random random) sync* {
    double x, y;

    // top and bottom sides
    for (x = 8; x < game.size.x - 8; x += 8) {
      yield GroundSprite(
        position: Vector2(x, 0),
        size: Vector2(8, 8),
        posOnIsland: Alignment.topCenter,
      );
      yield GroundSprite(
        position: Vector2(x, bottomOfIsland - 8),
        size: Vector2(8, 8),
        posOnIsland: Alignment.bottomCenter,
      );
    }

    // left and right sides
    for (y = 8; y < bottomOfIsland - 8; y += 8) {
      yield GroundSprite(
        position: Vector2(0, y),
        size: Vector2(8, 8),
        posOnIsland: Alignment.centerLeft,
      );
      yield GroundSprite(
        position: Vector2(game.size.x - 8, y),
        size: Vector2(8, 8),
        posOnIsland: Alignment.centerRight,
      );
    }

    // top corners
    yield GroundSprite(
      position: Vector2(0, 0),
      size: Vector2(8, 8),
      posOnIsland: Alignment.topLeft,
    );
    yield GroundSprite(
      position: Vector2(game.size.x - 8, 0),
      size: Vector2(8, 8),
      posOnIsland: Alignment.topRight,
    );

    // bottom corners
    yield GroundSprite(
      position: Vector2(0, bottomOfIsland - 8),
      size: Vector2(8, 8),
      posOnIsland: Alignment.bottomLeft,
    );
    yield GroundSprite(
      position: Vector2(game.size.x - 8, bottomOfIsland - 8),
      size: Vector2(8, 8),
      posOnIsland: Alignment.bottomRight,
    );
  }

  @visibleForTesting
  Iterable<SkullSprite> getSkullTiles() sync* {
    final random = Random(1234);

    // Decreases (rises) as numNewRowsEachRound increases
    final minY =
        game.player.position.y -
        Player.staticHeight * 0.5 -
        Monster.moveDownHeight * game.numNewRowsEachRound;

    for (var y = bottomOfIsland.roundToDouble() - 12; y > minY; y -= 8) {
      for (var x = 4.0; x < game.size.x - 4; x += 8) {
        // no skulls near the player
        if ((y + 4 - game.player.position.y).abs() < 17 &&
            (x + 4 - game.player.position.x).abs() < 17) {
          continue;
        }

        // randomly spread out the skulls
        if (random.nextDouble() > 0.3) continue;

        yield SkullSprite(
          type: .random(random),
          position: Vector2(x, y),
          size: Vector2(8, 8),
        );
      }
    }
  }

  /// Preloads all sprite sheets so they can be
  /// accessed synchronously later.
  static Future<void> preloadSprites({required RicochlimeGame game}) {
    return game.images.load('overworld.png');
  }
}
