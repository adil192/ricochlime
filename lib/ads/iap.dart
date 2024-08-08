import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
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

  /// The price of the product, formatted with currency symbol ("$0.99").
  /// If the product details are not loaded yet, returns "?".
  String get price => _details[this]?.price ?? '\$\$';
  bool get isPriceLoaded => _details.containsKey(this);
  static Map<RicochlimeProduct, ProductDetails> _details = {};

  PlainPref<IAPState> get state => _states![this]!;
  static Map<RicochlimeProduct, PlainPref<IAPState>>? _states;
  @visibleForTesting
  static void init() => _states ??= {
        for (final product in values)
          product: PlainPref('iap_${product.id}_state', IAPState.unpurchased),
      };
}

abstract final class RicochlimeIAP {
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static final _log = Logger('RicochlimeIAP');

  static final _inAppPurchasesSupported =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
  @visibleForTesting
  static bool? forceInAppPurchasesSupported;
  static bool get inAppPurchasesSupported =>
      forceInAppPurchasesSupported ?? _inAppPurchasesSupported;

  static Future<void> init() async {
    RicochlimeProduct.init();

    if (!inAppPurchasesSupported) return;

    unawaited(_subscription?.cancel());
    _subscription =
        InAppPurchase.instance.purchaseStream.listen(_onData, onDone: _onDone);

    final response = await InAppPurchase.instance
        .queryProductDetails(RicochlimeProduct.allIds);
    if (response.notFoundIDs.isNotEmpty) {
      _log.warning('Some IAPs not found: ${response.notFoundIDs}');
    }
    RicochlimeProduct._details = {
      for (final product in response.productDetails)
        RicochlimeProduct.fromId(product.id)!: product,
    };
    _log.info('IAPs loaded: ${RicochlimeProduct._details}');
  }

  static Future<void> _onData(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // TODO(adil192): show pending UI
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          // TODO(adil192): show "purchase not completed" UI
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _deliverProduct(purchaseDetails);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  static Future<bool> buy(RicochlimeProduct product) async {
    final details = RicochlimeProduct._details[product];
    if (details == null) {
      _log.severe('Product details not found: $product');
      return false;
    }

    return product.consumable
        ? InAppPurchase.instance.buyConsumable(
            purchaseParam: PurchaseParam(productDetails: details),
          )
        : InAppPurchase.instance.buyNonConsumable(
            purchaseParam: PurchaseParam(productDetails: details),
          );
  }

  static Future<void> restorePurchases() =>
      InAppPurchase.instance.restorePurchases();

  static void _onDone() {
    _subscription?.cancel();
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static void _deliverProduct(PurchaseDetails purchaseDetails) {
    assert(purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored);

    final product = RicochlimeProduct.fromId(purchaseDetails.productID);
    if (product == null) {
      _log.severe('Unknown product to deliver: ${purchaseDetails.productID}');
      return;
    }

    if (product.consumable &&
        purchaseDetails.status == PurchaseStatus.restored) {
      // Don't restore consumable purchases (they've already been consumed)
      _log.warning('Attempted to restore consumable purchase: '
          '${purchaseDetails.productID}');
      return;
    }

    switch (product) {
      case RicochlimeProduct.removeAdsForever:
        final state = RicochlimeProduct.removeAdsForever.state;

        if (state.value != IAPState.unpurchased) {
          _log.warning(
              'Product already delivered: ${purchaseDetails.productID}');
        }

        state.value = IAPState.purchasedAndEnabled;

      case RicochlimeProduct.buy1000Coins:
        Prefs.addCoins(1000, allowOverMax: true);

      case RicochlimeProduct.buy5000Coins:
        Prefs.addCoins(5000, allowOverMax: true);
    }
  }
}

enum IAPState {
  /// The item has not been purchased yet.
  unpurchased,

  /// The item has been purchased and is enabled.
  purchasedAndEnabled,

  /// The item has been purchased but is disabled.
  purchasedAndDisabled,
}
