import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
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

  String? get price => _details[this]?.price;
  static Map<RicochlimeProduct, ProductDetails> _details = {};

  PlainPref<IAPState> get state => _states[this]!;
  static late final Map<RicochlimeProduct, PlainPref<IAPState>> _states;
  static void _init() => _states = {
        for (final product in values)
          product: PlainPref('iap_${product.id}_state', IAPState.unpurchased),
      };
}

abstract final class RicochlimeIAP {
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static final _log = Logger('RicochlimeIAP');

  static final inAppPurchasesSupported =
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  static Future<void> init() async {
    RicochlimeProduct._init();

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

  static Future<bool> buyNonConsumable(RicochlimeProduct product) async {
    final details = RicochlimeProduct._details[product];
    if (details == null) {
      _log.severe('Product details not found: $product');
      return false;
    }

    return InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: details),
    );
  }

  static void _onDone() {
    _subscription?.cancel();
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static void _deliverProduct(PurchaseDetails purchaseDetails) {
    assert(purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored);

    switch (RicochlimeProduct.fromId(purchaseDetails.productID)) {
      case null:
        _log.severe('Unknown product to deliver: ${purchaseDetails.productID}');

      case RicochlimeProduct.removeAdsForever:
        final state = RicochlimeProduct.removeAdsForever.state;

        if (state.value != IAPState.unpurchased) {
          _log.warning(
              'Product already delivered: ${purchaseDetails.productID}');
        }

        state.value = IAPState.purchasedAndEnabled;
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
