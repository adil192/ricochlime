import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  Prefs.init();
  AdState.init();
  _addMysticWoodsLicense();

  await Prefs.highScore.waitUntilLoaded();

  runApp(TranslationProvider(child: const MyApp()));
}

void _addMysticWoodsLicense() {
  LicenseRegistry.addLicense(() async* {

    yield const LicenseEntryWithLineBreaks(
      ['mystic_woods'],
      '''
Mystic Woods 2.1
https://game-endeavor.itch.io/mystic-woods

Howdy! Thank you for purchasing the Mystic Woods asset pack.

This is an ongoing project that I will be adding content to over time, so let me know if there's anything you'd like for me to create.

License
  - You can use these assets in commercial projects.
  - You can modify the assets.
  - You can not redistribute or resale, even if modified.

Follow me on Twitter for updates on all of my projects.
https://twitter.com/GameEndeavor

If you enjoy this then leave a rating and comment. It helps to support this project!
''',
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static TextTheme _getTextTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);
    if (Prefs.hyperlegibleFont.value) {
      return GoogleFonts.atkinsonHyperlegibleTextTheme(baseTheme.textTheme);
    } else {
      return GoogleFonts.silkscreenTextTheme(baseTheme.textTheme);
    }
  }

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

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
        ),
        textTheme: MyApp._getTextTheme(Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
          brightness: Brightness.dark,
        ),
        textTheme: MyApp._getTextTheme(Brightness.dark),
      ),
      highContrastTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.highContrastLight(),
        textTheme: MyApp._getTextTheme(Brightness.light),
      ),
      highContrastDarkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.highContrastDark(),
        textTheme: MyApp._getTextTheme(Brightness.dark),
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
