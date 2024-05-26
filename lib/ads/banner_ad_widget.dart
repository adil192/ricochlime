import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

export 'package:google_mobile_ads/google_mobile_ads.dart' show AdSize;

/// Helper class for ads.
abstract class AdState {
  static bool _initializeStarted = false;
  static bool _initializeCompleted = false;

  static late final String _bannerAdUnitId;
  static late final String _rewardedInterstitialAdUnitId;
  static RewardedInterstitialAd? _rewardedInterstitialAd;

  /// Whether ads are supported on this platform.
  static bool get adsSupported => _bannerAdUnitId.isNotEmpty;

  /// Whether we can show rewarded interstitial ads.
  /// This is true if ads are supported and the user is old enough.
  static bool get rewardedInterstitialAdsSupported {
    if (!adsSupported) return false;
    final age = AdState.age;
    return age != null && age >= minAgeForPersonalizedAds;
  }

  /// Whether we should show banner ads.
  ///
  /// E.g. if the user is in battery save mode, we should not show a
  /// banner ad.
  static Future<bool> shouldShowBannerAd() async {
    if (!adsSupported) return false;

    if (await Battery().isInBatterySaveMode) return false;

    return true;
  }

  /// The minimum age required to show personalized ads.
  static const int minAgeForPersonalizedAds = 13;

  /// The user's age,
  /// calculated from their birth year,
  /// or null if the user has not entered their birth year.
  static int? get age {
    assert(Prefs.birthYear.loaded);

    final birthYear = Prefs.birthYear.value;
    if (birthYear == null) return null;

    // Subtract 1 because the user might not have
    // had their birthday yet this year.
    return DateTime.now().year - birthYear - 1;
  }

  /// Initializes ads.
  static void init() {
    if (kDebugMode) {
      // test ads
      if (kIsWeb) {
        _bannerAdUnitId = '';
        _rewardedInterstitialAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
        _rewardedInterstitialAdUnitId =
            'ca-app-pub-3940256099942544/5354046379';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
        _rewardedInterstitialAdUnitId =
            'ca-app-pub-3940256099942544/6978759866';
      } else {
        _bannerAdUnitId = '';
        _rewardedInterstitialAdUnitId = '';
      }
      assert(_bannerAdUnitId.isEmpty ||
          _bannerAdUnitId.startsWith('ca-app-pub-3940256099942544'));
      assert(_rewardedInterstitialAdUnitId.isEmpty ||
          _rewardedInterstitialAdUnitId
              .startsWith('ca-app-pub-3940256099942544'));
    } else {
      // actual ads
      if (kIsWeb) {
        _bannerAdUnitId = '';
        _rewardedInterstitialAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8961545046';
        _rewardedInterstitialAdUnitId =
            'ca-app-pub-1312561055261176/1010163793';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8306938920';
        _rewardedInterstitialAdUnitId =
            'ca-app-pub-1312561055261176/1654776024';
      } else {
        _bannerAdUnitId = '';
        _rewardedInterstitialAdUnitId = '';
      }
      assert(_bannerAdUnitId.isEmpty ||
          _bannerAdUnitId.startsWith('ca-app-pub-1312561055261176'));
      assert(_rewardedInterstitialAdUnitId.isEmpty ||
          _rewardedInterstitialAdUnitId
              .startsWith('ca-app-pub-1312561055261176'));
    }

    if (adsSupported) _startInitialize();
  }

  static Future<void> _startInitialize() async {
    if (_initializeStarted) return;

    final age = AdState.age;
    final canConsent = age != null && age >= minAgeForPersonalizedAds;
    if (canConsent) {
      if (!kIsWeb && Platform.isIOS) {
        var status = await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          // wait to avoid crash
          await Future.delayed(const Duration(seconds: 3));

          status = await AppTrackingTransparency.requestTrackingAuthorization();
        }
        if (status == TrackingStatus.authorized) {
          _checkForRequiredConsent();
        }
      } else {
        _checkForRequiredConsent();
      }
    } else {
      _checkForRequiredConsent(shouldShowConsentForm: false);
    }

    Prefs.birthYear.addListener(updateRequestConfiguration);
    await updateRequestConfiguration();

    assert(_bannerAdUnitId.isNotEmpty);
    assert(!_initializeCompleted);
    _initializeStarted = true;
    await MobileAds.instance.initialize();
    _initializeCompleted = true;

    await updateRequestConfiguration();

    unawaited(_preloadRewardedInterstitialAd());
  }

  static void _checkForRequiredConsent({
    bool shouldShowConsentForm = true,
  }) {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status != ConsentStatus.required) return;
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          if (shouldShowConsentForm) {
            showConsentForm();
          } else {
            // otherwise, the form is kept locally and can be shown later
          }
        }
      },
      (formError) {},
    );
  }

  /// Shows the consent form.
  ///
  /// It is assumed that [_checkForRequiredConsent]
  /// has already been called.
  static void showConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        consentForm.show((formError) async {
          if (formError != null) {
            // Handle dismissal by reloading form
            showConsentForm();
          }
        });
      },
      (formError) {},
    );
  }

  static Future<bool> _preloadRewardedInterstitialAd() {
    if (!rewardedInterstitialAdsSupported) return Future.value(false);
    final completer = Completer<bool>();
    RewardedInterstitialAd.load(
      adUnitId: _rewardedInterstitialAdUnitId,
      request: AdRequest(
        nonPersonalizedAds: age == null ? true : null,
      ),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Rewarded interstitial ad loaded!');
          _rewardedInterstitialAd = ad;
          completer.complete(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('Rewarded interstitial ad failed to load: $error');
          }
          completer.complete(false);
        },
      ),
    );
    return completer.future;
  }

  /// Updates the ad request configuration
  /// based on the user's age.
  static Future<void> updateRequestConfiguration() async {
    final age = AdState.age;
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      maxAdContentRating: switch (age) {
        null => MaxAdContentRating.pg, // parental guidance
        < 13 => MaxAdContentRating.pg, // parental guidance
        _ => MaxAdContentRating.t, // teen
      },
      tagForChildDirectedTreatment: switch (age) {
        null => TagForChildDirectedTreatment.yes,
        < 13 => TagForChildDirectedTreatment.yes,
        _ => TagForChildDirectedTreatment.no,
      },
      tagForUnderAgeOfConsent: switch (age) {
        null => TagForUnderAgeOfConsent.yes,
        < 13 => TagForUnderAgeOfConsent.yes,
        _ => TagForUnderAgeOfConsent.no,
      },
    ));
  }

  static Future<BannerAd?> _createBannerAd(AdSize adSize) async {
    if (!adsSupported) {
      if (kDebugMode) print('Banner ad unit ID is empty.');
      return null;
    } else if (!_initializeStarted) {
      if (kDebugMode) print('Ad initialization has not started.');
      return null;
    }

    while (!_initializeCompleted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: AdRequest(
        nonPersonalizedAds: age == null ? true : null,
      ),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (kDebugMode) print('Ad loaded!');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          if (kDebugMode) print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    unawaited(bannerAd.load());

    return bannerAd;
  }

  /// Shows a rewarded interstitial ad.
  ///
  /// Returns whether the reward was earned.
  static Future<bool> showRewardedInterstitialAd() async {
    if (!rewardedInterstitialAdsSupported) return false;

    if (_rewardedInterstitialAd == null) {
      if (kDebugMode) print('Rewarded interstitial ad is null, loading now...');
      final loaded = await _preloadRewardedInterstitialAd();
      if (!loaded) {
        if (kDebugMode) print('Rewarded ad failed to load.');
        return false;
      }
      assert(_rewardedInterstitialAd != null);
    }

    final completer = Completer<bool>();
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (!completer.isCompleted) {
          _rewardedInterstitialAd = null;
          _preloadRewardedInterstitialAd();
          completer.complete(false);
        }
      },
    );
    unawaited(_rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        _preloadRewardedInterstitialAd();
        completer.complete(true);
      },
    ));

    return completer.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () {
        if (kDebugMode) {
          print('Rewarded interstitial ad timed out, granting reward anyway.');
        }
        _rewardedInterstitialAd?.dispose();
        _rewardedInterstitialAd = null;
        _preloadRewardedInterstitialAd();
        return true;
      },
    );
  }
}

/// A widget that displays a banner ad.
class BannerAdWidget extends StatefulWidget {
  // ignore: public_member_api_docs
  const BannerAdWidget({
    super.key,
    required this.adSize,
  });

  /// The requested banner ad size.
  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();

  /// Switches the banner ad at natural transition points in the game,
  /// if 20 seconds have passed since the last refresh.
  static void refreshBannerAds() {
    _BannerAdWidgetState._refreshNotifier.value = DateTime.now();
  }
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with AutomaticKeepAliveClientMixin {
  static final _refreshNotifier = ValueNotifier(DateTime.now());

  DateTime _lastRefresh = DateTime.fromMillisecondsSinceEpoch(0);
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _refreshNow();
    _refreshNotifier.addListener(_refreshNotifierListener);
  }

  void _refreshNotifierListener() {
    if (!mounted) return;
    // If the first ad has not been loaded yet, don't refresh.
    if (_bannerAd == null) return;

    final timeSinceLastRefresh =
        _refreshNotifier.value.difference(_lastRefresh);
    if (timeSinceLastRefresh < const Duration(seconds: 20)) return;

    _lastRefresh = _refreshNotifier.value;
    _refreshNow();
  }

  void _refreshNow() {
    AdState._createBannerAd(widget.adSize).then((newBannerAd) {
      if (newBannerAd == null) return;

      _bannerAd?.dispose();
      if (mounted) {
        _lastRefresh = DateTime.now();
        setState(() => _bannerAd = newBannerAd);
      } else {
        _bannerAd = null;
        newBannerAd.dispose();
      }

      updateKeepAlive();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    late final colorScheme = Theme.of(context).colorScheme;

    const nesPadding = EdgeInsets.all(3);

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Stack(
          children: [
            NesContainer(
              width: widget.adSize.width + nesPadding.left + nesPadding.right,
              height: widget.adSize.height + nesPadding.top + nesPadding.bottom,
              padding: nesPadding,
              backgroundColor: RicochlimePalette.grassColor,
            ),
            Positioned.fill(
              left: nesPadding.left,
              right: nesPadding.right,
              top: nesPadding.top,
              bottom: nesPadding.bottom,
              child: _bannerAd == null
                  ? Center(
                      child: FaIcon(
                        FontAwesomeIcons.rectangleAd,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        nesPadding.horizontal * 1.5,
                      ),
                      child: AdWidget(ad: _bannerAd!),
                    ),
            ),
            IgnorePointer(
              child: NesContainer(
                width: widget.adSize.width + nesPadding.left + nesPadding.right,
                height:
                    widget.adSize.height + nesPadding.top + nesPadding.bottom,
                padding: nesPadding,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshNotifier.removeListener(_refreshNotifierListener);
    _bannerAd?.dispose();
    _bannerAd = null;
    _lastRefresh = DateTime.fromMillisecondsSinceEpoch(0);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _bannerAd != null;
}
