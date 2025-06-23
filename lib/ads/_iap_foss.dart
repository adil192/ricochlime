import 'package:flutter/material.dart';
import 'package:ricochlime/ads/iap_state.dart';
import 'package:stow_plain/stow_plain.dart';

enum RicochlimeProduct {
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

  String get price => '\$\$';

  PlainStow<IAPState> get state => _states![this]!;
  static Map<RicochlimeProduct, PlainStow<IAPState>>? _states;
  @visibleForTesting
  static void init() => _states ??= {
        for (final product in values)
          product: PlainStow(
            'iap_${product.id}_state',
            IAPState.unpurchased,
            IAPState.codec,
          ),
      };
}

abstract final class RicochlimeIAP {
  @visibleForTesting
  static bool? forceInAppPurchasesSupported;
  static bool get inAppPurchasesSupported =>
      forceInAppPurchasesSupported ?? false;

  static Future<void> init() async => RicochlimeProduct.init();
  static void listen() {}
  static void dispose() {}
  static Future<bool> buy(RicochlimeProduct product) async => false;
  static Future<void> restorePurchases() async {}
}
