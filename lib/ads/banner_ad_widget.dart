import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
  static late final String _rewardedAdUnitId;
  static RewardedAd? _rewardedAd;

  /// Whether ads are supported on this platform.
  static bool get adsSupported => _bannerAdUnitId.isNotEmpty;

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
        _rewardedAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
        _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
        _rewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313';
      } else {
        _bannerAdUnitId = '';
        _rewardedAdUnitId = '';
      }
    } else {
      // actual ads
      if (kIsWeb) {
        _bannerAdUnitId = '';
        _rewardedAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8961545046';
        _rewardedAdUnitId = 'ca-app-pub-1312561055261176/9247398730';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8306938920';
        _rewardedAdUnitId = 'ca-app-pub-1312561055261176/9513076323';
      } else {
        _bannerAdUnitId = '';
        _rewardedAdUnitId = '';
      }
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

    assert(_bannerAdUnitId.isNotEmpty);
    assert(_initializeCompleted == false);
    _initializeStarted = true;
    await MobileAds.instance.initialize();
    _initializeCompleted = true;

    Prefs.birthYear.addListener(updateRequestConfiguration);
    await updateRequestConfiguration();

    unawaited(_preloadRewardedAd());
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

  static Future<bool> _preloadRewardedAd() {
    assert(adsSupported);
    final completer = Completer<bool>();
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: AdRequest(
        nonPersonalizedAds: age == null ? true : null,
      ),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (kDebugMode) print('Rewarded ad loaded!');
          _rewardedAd = ad;
          completer.complete(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) print('Rewarded ad failed to load: $error');
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
        < 18 => MaxAdContentRating.t, // teen
        _ => MaxAdContentRating.ma, // mature audiences
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

  /// Shows a rewarded ad.
  ///
  /// Returns whether the reward was earned.
  static Future<bool> showRewardedAd() async {
    assert(adsSupported);

    if (_rewardedAd == null) {
      if (kDebugMode) print('Rewarded ad is null, loading now...');
      final loaded = await _preloadRewardedAd();
      if (!loaded) {
        if (kDebugMode) print('Rewarded ad failed to load.');
        return false;
      }
      assert(_rewardedAd != null);
    }

    final completer = Completer<bool>();
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (!completer.isCompleted) {
          _rewardedAd = null;
          _preloadRewardedAd();
          completer.complete(false);
        }
      },
    );
    unawaited(_rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        ad.dispose();
        _rewardedAd = null;
        _preloadRewardedAd();
        completer.complete(true);
      },
    ));

    return completer.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () {
        if (kDebugMode) print('Rewarded ad timed out, granting reward anyway.');
        _rewardedAd?.dispose();
        _rewardedAd = null;
        _preloadRewardedAd();
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
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    AdState._createBannerAd(widget.adSize).then((bannerAd) {
      if (mounted) {
        setState(() => _bannerAd = bannerAd);
      } else {
        _bannerAd = null;
        bannerAd?.dispose();
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _bannerAd != null;
}
