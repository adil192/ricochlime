abstract final class AdSchedule {
  static DateTime _lastShown = DateTime.now();

  /// The minimum time before an ad can be shown at a good time.
  static const _minTimeBeforeOpportuneAd = Duration(minutes: 2);

  /// The minimum time before an ad can be shown at a bad time.
  static const _minTimeBeforeInopportuneAd = Duration(minutes: 5);

  /// The minimum time after cancelling an ad before another ad can be shown.
  static const _minTimeAfterCancellingAd = Duration(minutes: 1);

  /// Resets [_lastShown] so ads aren't shown immediately
  /// after the app is opened/resumed.
  static void onResume(double dt) {
    _lastShown = DateTime.now();
  }

  /// Returns whether an interstitial ad should be shown.
  ///
  /// While ads are only shown at natural breaks in the app,
  /// some breaks are more natural than others. For example,
  /// a game over screen is a good place to show an ad, but
  /// in between rounds is less so.
  ///
  /// Ads are still shown at [inopportune] times, but only
  /// if there hasn't been an ad for a while.
  static bool enoughTimeSinceLastAd({
    bool inopportune = false,
  }) {
    final now = DateTime.now();
    final timeSinceLastAd = now.difference(_lastShown);

    if (inopportune) {
      return timeSinceLastAd >= _minTimeBeforeInopportuneAd;
    } else {
      return timeSinceLastAd >= _minTimeBeforeOpportuneAd;
    }
  }

  /// Updates [_lastShown] to the current time.
  static void markAdShown() {
    _lastShown = DateTime.now();
  }

  /// Updates [_lastShown] to reflect that an ad was cancelled.
  static void markAdCancelled() {
    _lastShown = DateTime.now()
        .subtract(_minTimeBeforeInopportuneAd)
        .add(_minTimeAfterCancellingAd);
  }
}
