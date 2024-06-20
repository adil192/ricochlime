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
}

abstract final class RicochlimeIAP {
  static const inAppPurchasesSupported = false;
  static void listen() {}
  static void dispose() {}
  static Future<bool> buyNonConsumable(_) async => false;
  static String? priceOf(_) => '?';
}
