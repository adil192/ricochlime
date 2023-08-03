import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

enum BackgroundWaterTileType {
  rightOfGrass(1, 1),
  leftOfGrass(1, 3),
  topOfGrass(0, 2),
  bottomOfGrass(2, 2),
  justWater(1, 2);

  const BackgroundWaterTileType(this.tileRow, this.tileCol);
  final int tileRow;
  final int tileCol;
}

class BackgroundWaterTile extends SpriteAnimationComponent
    with HasGameRef<RicochlimeGame> {
  
  BackgroundWaterTile({
    required super.position,
    required this.type,
    super.size,
  });

  BackgroundWaterTile.random({
    required Vector2 position,
    required Random random,
    Vector2? size,
  }) : this(
    position: position,
    type: BackgroundWaterTileType.values[
      random.nextInt(BackgroundWaterTileType.values.length)
    ],
    size: size,
  );

  final BackgroundWaterTileType type;
  late List<SpriteSheet> waterSpriteSheets = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (size.isZero()) {
      size = Vector2.all(16);
    }
    anchor = Anchor.topLeft;
    await loadWaterTiles();

    animation = SpriteAnimation.spriteList(
      [
        for (int i = 0; i < 6; ++i)
          waterSpriteSheets[i].getSprite(type.tileRow, type.tileCol),
      ],
      stepTime: 1 / 6,
    );
  }

  Future<void> loadWaterTiles() async {
    assert(waterSpriteSheets.isEmpty);
    for (var i = 0; i < 6; i++) {
      final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('water${i + 1}.png'),
        columns: 6,
        rows: 4,
      );
      waterSpriteSheets.add(spriteSheet);
    }
  }
}
