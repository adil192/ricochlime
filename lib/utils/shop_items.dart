import 'package:flutter/material.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _sharedPreferences = SharedPreferences.getInstance();

abstract class ShopItems {
  static List<ShopItem> bullets = List.unmodifiable([
    BulletShopItem(
      color: Colors.white,
      alwaysPurchased: true,
    ),
    for (final color in Colors.primaries)
      BulletShopItem(
        color: color,
      ),
    BulletShopItem(
      color: Colors.black,
    ),
  ]);

  static final Map<String, ShopItem> allItems = {};

  static T? getItem<T extends ShopItem>(String id) => allItems[id] as T?;
}

sealed class ShopItem {
  ShopItem({
    required this.id,
    bool alwaysPurchased = false,
  }) : assert(!ShopItems.allItems.containsKey(id),
            'Duplicate shop item ID: $id') {
    ShopItems.allItems[id] = this;

    _loadState(alwaysPurchased);
  }

  final String id;
  final int price = 1000;
  final state = ValueNotifier(ShopItemState.loading);

  String get prefsKey => 'shopItemPurchased:$id';

  Widget build(BuildContext context);

  Future<void> _loadState(bool alwaysPurchased) async {
    if (alwaysPurchased) {
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

class BulletShopItem extends ShopItem {
  BulletShopItem({
    required this.color,
    super.alwaysPurchased,
  }) : super(
          id: 'bullet${color.value.toRadixString(16)}',
        );

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

enum ShopItemState {
  loading,
  purchased,
  unpurchased,
}
