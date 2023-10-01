import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

@visibleForTesting
enum SpriteSheetType {
  water,
  plains,
}
enum BackgroundTileType {
  // rightOfGrass(SpriteSheetType.water, 1, 1),
  // leftOfGrass(SpriteSheetType.water, 1, 3),
  // topOfGrass(SpriteSheetType.water, 2, 2),
  bottomOfGrass(SpriteSheetType.water, 0, 2),
  justWater(SpriteSheetType.water, 1, 2),

  topLeftOfSoil(SpriteSheetType.plains, 0, 1),
  topCenterOfSoil(SpriteSheetType.plains, 0, 2),
  topRightOfSoil(SpriteSheetType.plains, 0, 3),
  centerLeftOfSoil(SpriteSheetType.plains, 1, 1),
  centerCenterOfSoil(SpriteSheetType.plains, 1, 2),
  centerRightOfSoil(SpriteSheetType.plains, 1, 3),
  bottomLeftOfSoil(SpriteSheetType.plains, 2, 1),
  bottomCenterOfSoil(SpriteSheetType.plains, 2, 2),
  bottomRightOfSoil(SpriteSheetType.plains, 2, 3),

  leftOfThinSoil(SpriteSheetType.plains, 3, 1),
  centerOfThinSoil(SpriteSheetType.plains, 3, 2),
  rightOfThinSoil(SpriteSheetType.plains, 3, 3),

  ;
  const BackgroundTileType(this.spriteSheetType, this.tileRow, this.tileCol);
  final SpriteSheetType spriteSheetType;
  final int tileRow;
  final int tileCol;
}

class BackgroundTile extends SpriteAnimationComponent
    with HasGameRef<RicochlimeGame> {
  
  BackgroundTile({
    required super.position,
    required this.type,
    super.size,
  });

  final BackgroundTileType type;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (size.isZero()) {
      size = Vector2.all(16);
    }
    anchor = Anchor.topLeft;

    animation = SpriteAnimation.spriteList(
      switch (type.spriteSheetType) {
        SpriteSheetType.water => [
          for (final spriteSheet in waterSpriteSheets)
            spriteSheet.getSprite(type.tileRow, type.tileCol)
        ],
        SpriteSheetType.plains => [
          plainsSpriteSheet.getSprite(type.tileRow, type.tileCol)
        ],
      },
      stepTime: 1 / 6,
    );
  }

  static List<SpriteSheet> waterSpriteSheets = [];
  static late SpriteSheet plainsSpriteSheet;
  /// Preloads all sprite sheets so they can be
  /// accessed synchronously later.
  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    final futures = <Future>[];

    // here we use a for loop and switch statement
    // so that the compiler warns us if we forget a case
    for (final type in SpriteSheetType.values) {
      switch (type) {
        case SpriteSheetType.water:
          futures.add(
            Future.wait([
              for (int i = 0; i < 6; ++i)
                gameRef.images.load('water${i + 1}.png'),
            ]).then((images) {
              for (final image in images) {
                waterSpriteSheets.add(
                  SpriteSheet.fromColumnsAndRows(
                    image: image,
                    columns: 6,
                    rows: 4,
                  ),
                );
              }
            }),
          );
        case SpriteSheetType.plains:
          futures.add(
            gameRef.images.load('plains.png').then((image) {
              plainsSpriteSheet = SpriteSheet.fromColumnsAndRows(
                image: image,
                columns: 6,
                rows: 12,
              );
            }),
          );
      }
    }

    return Future.wait(futures);
  }
}
