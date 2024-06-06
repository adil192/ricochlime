import 'package:flutter/material.dart';
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
      BulletColorShopItem(color: color, price: 500),
  ]);

  static final Map<String, ShopItem> allItems = {};

  static T? getItem<T extends ShopItem>(String id) => allItems[id] as T?;
}

sealed class ShopItem {
  ShopItem({
    required this.id,
    required this.price,
  }) : assert(!ShopItems.allItems.containsKey(id),
            'Duplicate shop item ID: $id') {
    ShopItems.allItems[id] = this;

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

  Future<void> purchase({
    bool noCost = false,
  }) async {
    if (state.value == ShopItemState.purchased) return;
    if (!noCost && Prefs.coins.value < price) return;

    final prefs = await _sharedPreferences;
    await prefs.setBool(prefsKey, true);
    state.value = ShopItemState.purchased;
    if (!noCost) Prefs.coins.value -= price;
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

enum ShopItemState {
  loading,
  purchased,
  unpurchased,
}
