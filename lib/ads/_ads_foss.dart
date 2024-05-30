import 'package:flutter/material.dart';

/// Helper class for ads,
/// with a dummy implementation because ads are disabled.
abstract class AdState {
  /// Whether ads are supported,
  /// which is always false.
  static const adsSupported = false;

  /// Whether we can show rewarded interstitial ads,
  /// which is always false.
  static const rewardedInterstitialAdsSupported = false;

  /// Whether we should show banner ads.
  static Future<bool> shouldShowBannerAd() async => false;

  /// The minimum age required to show personalized ads.
  ///
  /// This is an arbitrarily high number.
  static const int minAgeForPersonalizedAds = 1000;

  /// The users age, or null if unknown.
  ///
  /// This is always null.
  static const int? age = null;

  /// Initializes ads.
  ///
  /// This is a no-op.
  static void init() {}

  /// Shows the consent form.
  ///
  /// This is a no-op.
  static void showConsentForm() {}

  /// Updates the ad request configuration.
  ///
  /// This is a no-op.
  static Future<void> updateRequestConfiguration() async {}

  /// Shows a rewarded interstitial ad (no-op).
  ///
  /// Returns whether the reward was earned,
  /// which is always false.
  static Future<bool> showRewardedInterstitialAd() async => false;
}

/// A widget that displays a banner ad.
///
/// This is a dummy widget that does nothing.
class BannerAdWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  const BannerAdWidget({
    super.key,
    required this.adSize,
  });

  /// The requested banner ad size.
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
class AdSize {
  // ignore: public_member_api_docs
  const AdSize({
    required this.width,
    required this.height,
  });

  /// Standard banner ad size.
  static const banner = AdSize(width: 320, height: 50);

  /// The requested banner ad width.
  final int width;

  /// The requested banner ad height.
  final int height;
}
