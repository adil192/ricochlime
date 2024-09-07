abstract final class AdSchedule {
  static DateTime _lastShown = DateTime.now();

  /// The minimum time before an ad can be shown.
  static const _minTimeBetweenAds = Duration(minutes: 1);

  /// Resets [_lastShown] so ads aren't shown immediately
  /// after the app is opened/resumed.
  static void onResume(double dt) {
    _lastShown = DateTime.now();
  }

  /// Returns whether an interstitial ad should be shown.
  static bool enoughTimeSinceLastAd() {
    final now = DateTime.now();
    final timeSinceLastAd = now.difference(_lastShown);

    return timeSinceLastAd >= _minTimeBetweenAds;
  }

  /// Updates [_lastShown] to the current time.
  static void markAdShown() {
    _lastShown = DateTime.now();
  }

  /// Updates [_lastShown] to reflect that an ad was cancelled.
  static void markAdCancelled() {
    _lastShown = DateTime.now().subtract(_minTimeBetweenAds * 0.5);
  }
}
