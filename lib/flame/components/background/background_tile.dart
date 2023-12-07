import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

/// Enum for the different sprite sheets.
@visibleForTesting
enum SpriteSheetType {
  /// The water sprite sheets.
  water,

  /// The plains sprite sheet.
  plains,
}

/// Enum for the different background tile types.
enum BackgroundTileType {
  // rightOfGrass(SpriteSheetType.water, 1, 1),
  // leftOfGrass(SpriteSheetType.water, 1, 3),
  // topOfGrass(SpriteSheetType.water, 2, 2),
  // ignore: public_member_api_docs
  bottomOfGrass(SpriteSheetType.water, 0, 2),
  // ignore: public_member_api_docs
  justWater(SpriteSheetType.water, 1, 2),

  // ignore: public_member_api_docs
  topLeftOfSoil(SpriteSheetType.plains, 0, 1),
  // ignore: public_member_api_docs
  topCenterOfSoil(SpriteSheetType.plains, 0, 2),
  // ignore: public_member_api_docs
  topRightOfSoil(SpriteSheetType.plains, 0, 3),
  // ignore: public_member_api_docs
  centerLeftOfSoil(SpriteSheetType.plains, 1, 1),
  // ignore: public_member_api_docs
  centerCenterOfSoil(SpriteSheetType.plains, 1, 2),
  // ignore: public_member_api_docs
  centerRightOfSoil(SpriteSheetType.plains, 1, 3),
  // ignore: public_member_api_docs
  bottomLeftOfSoil(SpriteSheetType.plains, 2, 1),
  // ignore: public_member_api_docs
  bottomCenterOfSoil(SpriteSheetType.plains, 2, 2),
  // ignore: public_member_api_docs
  bottomRightOfSoil(SpriteSheetType.plains, 2, 3),

  // ignore: public_member_api_docs
  leftOfThinSoil(SpriteSheetType.plains, 3, 1),
  // ignore: public_member_api_docs
  centerOfThinSoil(SpriteSheetType.plains, 3, 2),
  // ignore: public_member_api_docs
  rightOfThinSoil(SpriteSheetType.plains, 3, 3),
  ;

  const BackgroundTileType(this.spriteSheetType, this.tileRow, this.tileCol);

  /// The sprite sheet(s) type that this tile is in.
  final SpriteSheetType spriteSheetType;

  /// The row of the tile in the sprite sheet.
  final int tileRow;

  /// The column of the tile in the sprite sheet.
  final int tileCol;
}

/// A component for a background tile.
class BackgroundTile extends SpriteAnimationComponent
    with HasGameRef<RicochlimeGame> {
  // ignore: public_member_api_docs
  BackgroundTile({
    required super.position,
    required this.type,
    super.size,
  });

  /// The type of this background tile.
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

    _onBrightnessChange();
  }

  @override
  void onMount() {
    super.onMount();
    gameRef.isDarkMode.addListener(_onBrightnessChange);
    _onBrightnessChange();
  }

  @override
  void onRemove() {
    super.onRemove();
    gameRef.isDarkMode.removeListener(_onBrightnessChange);
  }

  bool _isDarkened = false;
  void _onBrightnessChange() {
    if (gameRef.isDarkMode.value == _isDarkened) return;
    _isDarkened = gameRef.isDarkMode.value;
    getPaint().colorFilter = gameRef.isDarkMode.value
        ? const ColorFilter.mode(
            Color.fromARGB(255, 175, 175, 175),
            BlendMode.modulate,
          )
        : null;
  }

  /// The water sprite sheets,
  /// preloaded by [preloadSprites].
  static List<SpriteSheet> waterSpriteSheets = [];

  /// The plains sprite sheet,
  /// preloaded by [preloadSprites].
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
