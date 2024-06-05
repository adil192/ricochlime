import 'package:flutter/material.dart';

abstract class ShopItems {
  static List<ShopItem> bullets = [
    BulletShopItem(
      id: 'bulletDefault',
      color: Colors.white,
    ),
    for (final color in Colors.primaries)
      BulletShopItem(
        id: 'bullet${color.value.toRadixString(36)}',
        color: color,
      ),
  ];
}

sealed class ShopItem {
  const ShopItem({required this.id});

  final String id;

  Widget build(BuildContext context);
}

class BulletShopItem extends ShopItem {
  BulletShopItem({
    required super.id,
    required this.color,
  });

  final Color color;

  // TODO(adil192): Also add non-color bullets
  // final Sprite? sprite;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }
}
