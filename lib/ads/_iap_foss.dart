import 'package:ricochlime/utils/prefs.dart';

enum RicochlimeProduct {
  removeAdsForever('remove_ads_forever');

  const RicochlimeProduct(this.id);

  final String id;

  static final allIds = values.map((product) => product.id).toSet();

  static RicochlimeProduct? fromId(String id) {
    for (final product in values) {
      if (product.id == id) return product;
    }
    return null;
  }

  String? get price => '?';

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
  static Future<bool> buyNonConsumable(_) async => false;
}

enum IAPState { unpurchased, purchasedAndEnabled, purchasedAndDisabled }
