import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

abstract final class RicochlimeIAP {
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  static void listen() {
    _subscription?.cancel();
    _subscription =
        InAppPurchase.instance.purchaseStream.listen(_onData, onDone: _onDone);
  }

  static Future<void> _onData(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // TODO(adil192): show pending UI
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          // show "purchase not completed" UI
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // TODO(adil192): deliver product
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  static void _onDone() {
    _subscription?.cancel();
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
