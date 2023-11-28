import 'package:flutter/material.dart';

const _kDummyAdMessage = 'This is a dummy class for when ads are disabled.';

/// Helper class for ads,
/// with a dummy implementation because ads are disabled.
@Deprecated(_kDummyAdMessage)
abstract class AdState {
  /// Whether ads are supported,
  /// which is always false.
  @Deprecated(_kDummyAdMessage)
  static bool get adsSupported => false;

  /// The minimum age required to show personalized ads.
  ///
  /// This is an arbitrarily high number.
  @Deprecated(_kDummyAdMessage)
  static const int minAgeForPersonalizedAds = 1000;

  /// The users age, or null if unknown.
  ///
  /// This is always null.
  @Deprecated(_kDummyAdMessage)
  static int? get age => null;

  /// Initializes ads.
  ///
  /// This is a no-op.
  @Deprecated(_kDummyAdMessage)
  static void init() {}

  /// Shows the consent form.
  ///
  /// This is a no-op.
  @Deprecated(_kDummyAdMessage)
  static void showConsentForm() {}

  /// Updates the ad request configuration.
  ///
  /// This is a no-op.
  @Deprecated(_kDummyAdMessage)
  static Future<void> updateRequestConfiguration() async {}

  /// Shows a rewarded ad (no-op).
  ///
  /// Returns whether the reward was earned,
  /// which is always false.
  @Deprecated(_kDummyAdMessage)
  static Future<bool> showRewardedAd() async => false;
}

/// A widget that displays a banner ad.
///
/// This is a dummy widget that does nothing.
@Deprecated(_kDummyAdMessage)
class BannerAdWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  const BannerAdWidget({
    super.key,
    required this.adSize,
  });

  /// The requested banner ad size.
  @Deprecated(_kDummyAdMessage)
  final AdSize adSize;

  @override
  Widget build(BuildContext context) => const SizedBox();
}

/// A banner ad size.
///
/// This is a reimplemented version of
/// `google_mobile_ads`'s `AdSize` class,
/// so there are no compilation errors
/// when the dependency is removed.
@Deprecated(_kDummyAdMessage)
class AdSize {
  // ignore: public_member_api_docs
  const AdSize({
    required this.width,
    required this.height,
  });

  /// Standard banner ad size.
  @Deprecated(_kDummyAdMessage)
  static const banner = AdSize(width: 320, height: 50);

  /// The requested banner ad width.
  @Deprecated(_kDummyAdMessage)
  final int width;

  /// The requested banner ad height.
  @Deprecated(_kDummyAdMessage)
  final int height;
}
