import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/ads/age_dialog.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/nes_theme.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

Future<void> main({
  WidgetsBinding? Function() initWidgetsBinding =
      WidgetsFlutterBinding.ensureInitialized,
  void Function(Widget) runApp = runApp,
}) async {
  initWidgetsBinding();

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  LocaleSettings.useDeviceLocale();
  Prefs.init();
  unawaited(game.preloadSprites.future);
  unawaited(Prefs.bgmVolume.waitUntilLoaded().then((_) => game.preloadBgMusic));
  _addLicenses();
  GoogleFonts.config.allowRuntimeFetching = false;

  await Future.wait([
    Prefs.highScore.waitUntilLoaded(),
    Prefs.birthYear.waitUntilLoaded(),
    GoogleFonts.pendingFonts([GoogleFonts.silkscreenTextTheme()]),
  ]);

  AdState.init();

  runApp(TranslationProvider(child: const MyApp()));
}

void _addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['_gfx'],
      await rootBundle.loadString('assets/images/LICENSE.md'),
    );
    yield LicenseEntryWithLineBreaks(
      ['_ludum_dare_32_track_4'],
      await rootBundle.loadString('assets/audio/bgm/LICENSE.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['google_fonts'],
      await rootBundle
          .loadString('assets/google_fonts/Atkinson_Hyperlegible/OFL.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['google_fonts'],
      await rootBundle.loadString('assets/google_fonts/Silkscreen/OFL.txt'),
    );
  });
}

Future<void> handleCurrentConsentStage(BuildContext context) async {
  if (kIsWeb) return;
  if (!AdState.adsSupported) return;

  if (Prefs.birthYear.value == null) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AgeDialog(
        dismissible: false,
      ),
    );
    assert(Prefs.birthYear.value != null);
  } else {
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
    return MaterialApp(
      title: t.appName,
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
          seedColor: RicochlimePalette.grassColorDark,
          primary: RicochlimePalette.grassColor.brighten(0.1),
          brightness: Brightness.dark,
        ),
      ),
      highContrastTheme: nesThemeFrom(
        brightness: Brightness.light,
        colorScheme: ColorScheme.highContrastLight(
          primary: RicochlimePalette.grassColor.darken(0.5),
        ),
      ),
      highContrastDarkTheme: nesThemeFrom(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.highContrastDark(
          primary: RicochlimePalette.grassColorDark.darken(0.5),
        ),
      ),
      home: const HomePage(),
    );
  }
}
