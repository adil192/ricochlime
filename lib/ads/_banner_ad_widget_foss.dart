import 'package:flutter/material.dart';

const _kDummyAdMessage = 'This is a dummy class for when ads are disabled.';

@Deprecated(_kDummyAdMessage)
abstract class AdState {
  @Deprecated(_kDummyAdMessage)
  static bool get adsSupported => false;

  @Deprecated(_kDummyAdMessage)
  static const int minAgeForPersonalizedAds = 1000;
  @Deprecated(_kDummyAdMessage)
  static int? get age => null;

  @Deprecated(_kDummyAdMessage)
  static void init() {}

  @Deprecated(_kDummyAdMessage)
  static void showConsentForm() {}
  
  @Deprecated(_kDummyAdMessage)
  static Future<void> updateRequestConfiguration() async {}

  @Deprecated(_kDummyAdMessage)
  static Future<bool> showRewardedAd() async => false;
}

@Deprecated(_kDummyAdMessage)
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    super.key,
    required this.adSize,
  });

  @Deprecated(_kDummyAdMessage)
  final AdSize adSize;

  @override
  Widget build(BuildContext context) => const SizedBox();
}

@Deprecated(_kDummyAdMessage)
class AdSize {
  const AdSize({
    required this.width,
    required this.height,
  });

  @Deprecated(_kDummyAdMessage)
  static const banner = AdSize(width: 320, height: 50);

  @Deprecated(_kDummyAdMessage)
  final int width;
  @Deprecated(_kDummyAdMessage)
  final int height;
}
