import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/consent_stage.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

export 'package:google_mobile_ads/google_mobile_ads.dart' show AdSize;

abstract class AdState {
  static bool _initializeStarted = false;
  static bool _initializeCompleted = false;
  static late final String _bannerAdUnitId;

  static bool get adsSupported => _bannerAdUnitId.isNotEmpty;

  static const int minAgeForPersonalizedAds = 13;
  static int? get age {
    final birthYear = Prefs.birthYear.value;
    if (birthYear == null) return null;

    // Subtract 1 because the user might not have had their birthday yet this year.
    return DateTime.now().year - birthYear - 1;
  }

  static void init() {
    if (kDebugMode) { // test ads
      if (kIsWeb) {
        _bannerAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
      } else {
        _bannerAdUnitId = '';
      }
    } else { // actual ads
      if (kIsWeb) {
        _bannerAdUnitId = '';
      } else if (Platform.isAndroid) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8961545046';
      } else if (Platform.isIOS) {
        _bannerAdUnitId = 'ca-app-pub-1312561055261176/8306938920';
      } else {
        _bannerAdUnitId = '';
      }
    }

    if (adsSupported) _startInitialize();
  }

  static void _startInitialize() async {
    if (_initializeStarted) return;

    final age = AdState.age;
    final correctConsentStage = Prefs.consentStage.value == ConsentStage.askForPersonalizedAds;
    final canConsent = age != null && age >= minAgeForPersonalizedAds;
    if (correctConsentStage && canConsent) {
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

    updateRequestConfiguration();
    Prefs.birthYear.addListener(updateRequestConfiguration);
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
  static void showConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        consentForm.show(
          (formError) async {
            if (formError != null) {
              // Handle dismissal by reloading form
              showConsentForm();
            }
          }
        );
      },
      (formError) {},
    );
  }
  
  static void updateRequestConfiguration() async {
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

    return BannerAd(
      adUnitId: _bannerAdUnitId,
      request: AdRequest(
        nonPersonalizedAds: switch (Prefs.consentStage.value) {
          ConsentStage.askForBirthYear => true,
          ConsentStage.askForPersonalizedAds => null,
        },
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
    )..load();
  }
}

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    super.key,
    required this.adSize,
  });

  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> with AutomaticKeepAliveClientMixin {
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
                height: widget.adSize.height + nesPadding.top + nesPadding.bottom,
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
