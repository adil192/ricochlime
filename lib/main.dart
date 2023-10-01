import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/ads/birth_year_dialog.dart';
import 'package:ricochlime/ads/consent_stage.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/nes_theme.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  game.preloadSprites();
  Prefs.init();
  _addLicenses();
  GoogleFonts.config.allowRuntimeFetching = false;

  await Future.wait([
    Prefs.highScore.waitUntilLoaded(),
    Prefs.birthYear.waitUntilLoaded(),
  ]);

  AdState.init();

  runApp(TranslationProvider(child: const MyApp()));
}

void _addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['mystic_woods'],
      await rootBundle.loadString('assets/images/LICENSE.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['google_fonts'],
      await rootBundle.loadString('assets/google_fonts/Atkinson_Hyperlegible/OFL.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['google_fonts'],
      await rootBundle.loadString('assets/google_fonts/Silkscreen/OFL.txt'),
    );
  });
}

void handleCurrentConsentStage(BuildContext context) async {
  if (kIsWeb) return;
  if (!Platform.isAndroid && !Platform.isIOS) return;

  if (Prefs.birthYear.value == null) {
    assert(Prefs.consentStage.value == ConsentStage.askForBirthYear);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BirthYearDialog(
        dismissible: false,
      ),
    );
    assert(Prefs.birthYear.value != null);
  } else if (Prefs.consentStage.value == ConsentStage.askForBirthYear) {
    Prefs.consentStage.value = Prefs.consentStage.value.next;
  }

  if (Prefs.consentStage.value == ConsentStage.askForPersonalizedAds) {
    AdState.showConsentForm();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Prefs.hyperlegibleFont.addListener(_prefListener);
  }

  @override
  void dispose() {
    Prefs.hyperlegibleFont.removeListener(_prefListener);
    super.dispose();
  }

  void _prefListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,

      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      debugShowCheckedModeBanner: false,

      theme: nesThemeFrom(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
        ),
      ),
      darkTheme: nesThemeFrom(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
          brightness: Brightness.dark,
        ),
      ),
      highContrastTheme: nesThemeFrom(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.highContrastLight(),
      ),
      highContrastDarkTheme: nesThemeFrom(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.highContrastDark(),
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) => const PlayPage(),
    ),
    GoRoute(
      path: '/tutorial',
      builder: (context, state) => const TutorialPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
