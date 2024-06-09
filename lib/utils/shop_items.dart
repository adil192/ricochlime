import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _sharedPreferences = SharedPreferences.getInstance();

abstract class ShopItems {
  static final bulletColors = List<BulletColorShopItem>.unmodifiable([
    BulletColorShopItem(color: Colors.white, price: -1),
    for (final color in [
      Colors.pink,
      RicochlimePalette.waterColor,
      Colors.lime,
      Colors.deepPurple,
      Colors.yellow,
      Colors.purple,
      Colors.amber,
      Colors.brown,
      Colors.indigo,
      Colors.red,
      Colors.black,
    ])
      BulletColorShopItem(color: color, price: 200),
  ]);

  static final bulletShapes = List<BulletShapeShopItem>.unmodifiable([
    BulletShapeShopItem(
      id: 'bulletShapeCircle',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(0, 0),
          srcSize: Vector2(16, 16)),
      price: -1,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeArrow',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(18, 0),
          srcSize: Vector2(12, 16)),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeShuriken',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(32, 0),
          srcSize: Vector2(16, 16)),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeDonut',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(0, 16),
          srcSize: Vector2(16, 16)),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeIntricate',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(16, 16),
          srcSize: Vector2(16, 16)),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeDiamond',
      spriteBuilder: () => Sprite(
          RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
          srcPosition: Vector2(32, 16),
          srcSize: Vector2(16, 16)),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeSmiley',
      spriteBuilder: () => Sprite(
        RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
        srcPosition: Vector2(0, 32),
        srcSize: Vector2(16, 16),
      ),
      price: 1000,
    ),
    BulletShapeShopItem(
      id: 'bulletShapeCross',
      spriteBuilder: () => Sprite(
        RicochlimeGame.instance.images.fromCache('bullet_shapes.png'),
        srcPosition: Vector2(16, 32),
        srcSize: Vector2(16, 16),
      ),
      price: 1000,
    ),
  ]);

  static Future<void> preloadSprites({
    required RicochlimeGame gameRef,
  }) {
    return gameRef.images.load('bullet_shapes.png');
  }

  static final allItems = [
    ...bulletColors,
    ...bulletShapes,
  ];

  static BulletShapeShopItem? getBulletShape(String id) =>
      bulletShapes.where((item) => item.id == id).firstOrNull;

  static BulletShapeShopItem get defaultBulletShape => bulletShapes.first;
}

sealed class ShopItem {
  ShopItem({
    required this.id,
    required this.price,
  }) {
    _loadState();
  }

  final String id;

  /// Price of the item in coins.
  /// Negative price means the item is always purchased by default.
  final int price;
  final state = ValueNotifier(ShopItemState.loading);

  String get prefsKey => 'shopItemPurchased:$id';

  Widget build(BuildContext context);

  Future<void> _loadState() async {
    if (price < 0) {
      state.value = ShopItemState.purchased;
      return;
    }

    final prefs = await _sharedPreferences;
    final purchased = prefs.getBool(prefsKey) ?? false;
    state.value =
        purchased ? ShopItemState.purchased : ShopItemState.unpurchased;
  }

  /// Returns `true` if the item has been purchased.
  Future<bool> purchase({
    bool noCost = false,
  }) async {
    if (state.value == ShopItemState.purchased) return true;
    if (!noCost && Prefs.coins.value < price) return false;

    final prefs = await _sharedPreferences;
    await prefs.setBool(prefsKey, true);
    state.value = ShopItemState.purchased;
    if (!noCost) Prefs.coins.value -= price;
    return true;
  }
}

class BulletColorShopItem extends ShopItem {
  BulletColorShopItem({
    required this.color,
    required super.price,
  }) : super(
          id: 'bullet${color.value.toRadixString(16)}',
        );

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(color, ShopItems.defaultBulletShape.sprite),
    );
  }
}

class BulletShapeShopItem extends ShopItem {
  BulletShapeShopItem({
    required super.id,
    required this.spriteBuilder,
    required super.price,
  });

  final Sprite Function() spriteBuilder;
  late final Sprite sprite = spriteBuilder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(Colors.white, sprite),
    );
  }
}

class _SpritePainter extends CustomPainter {
  _SpritePainter(
    this.color,
    this.sprite,
  );

  final Color color;
  final Sprite sprite;

  @override
  void paint(Canvas canvas, Size size) {
    Bullet.drawBullet(
      canvas,
      Vector2(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
      bulletColor: color,
      bulletShape: sprite,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum ShopItemState {
  loading,
  purchased,
  unpurchased,
}
