import 'package:ricochlime/utils/prefs.dart';

enum RicochlimeProduct {
  removeAdsForever('remove_ads_forever', consumable: false),
  buy1000Coins('buy_1000_coins', consumable: true),
  buy5000Coins('buy_5000_coins', consumable: true),
  ;

  const RicochlimeProduct(this.id, {required this.consumable});

  final String id;
  final bool consumable;

  static final allIds = values.map((product) => product.id).toSet();

  static RicochlimeProduct? fromId(String id) {
    for (final product in values) {
      if (product.id == id) return product;
    }
    return null;
  }

  String get price => '?';

  PlainPref<IAPState> get state => _states[this]!;
  static late final Map<RicochlimeProduct, PlainPref<IAPState>> _states;
  static void _init() => _states = {
        for (final product in values)
          product: PlainPref('iap_${product.id}_state', IAPState.unpurchased),
      };
}

abstract final class RicochlimeIAP {
  static const inAppPurchasesSupported = false;
  static Future<void> init() async => RicochlimeProduct._init();
  static void listen() {}
  static void dispose() {}
  static Future<bool> buy(_) async => false;
  static Future<void> restorePurchases() async {}
}

enum IAPState { unpurchased, purchasedAndEnabled, purchasedAndDisabled }
