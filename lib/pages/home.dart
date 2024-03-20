import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/main.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/brightness_extension.dart';
import 'package:ricochlime/utils/prefs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static bool handledConsent = false;

  /// The last known value of the bgm volume,
  /// excluding when the volume is 0.
  static double lastKnownOnVolume = 0.7;

  @override
  Widget build(BuildContext context) {
    if (!handledConsent) {
      handledConsent = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        handleCurrentConsentStage(context);
      });
    }

    final colorScheme = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness.opposite,
        systemNavigationBarColor: colorScheme.background,
        systemNavigationBarIconBrightness: colorScheme.brightness.opposite,
      ),
      child: Scaffold(
        body: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    t.appName,
                    style: const TextStyle(
                      fontSize: kToolbarHeight,
                    ),
                  ),
                  Row(
                    children: [
                      ListenableBuilder(
                        listenable: Prefs.bgmVolume,
                        builder: (context, child) {
                          if (Prefs.bgmVolume.value > 0.05) {
                            lastKnownOnVolume = Prefs.bgmVolume.value;
                          }
                          return NesTooltip(
                            message: '${t.settingsPage.bgmVolume}: '
                                '${Prefs.bgmVolume.value * 100 ~/ 1}%',
                            child: Opacity(
                              opacity: Prefs.bgmVolume.value <= 0.05 ? 0.25 : 1,
                              child: child!,
                            ),
                          );
                        },
                        child: NesIconButton(
                          onPress: () {
                            Prefs.bgmVolume.value =
                                Prefs.bgmVolume.value <= 0.05
                                    ? lastKnownOnVolume
                                    : 0;
                          },
                          size: const Size.square(32),
                          icon: NesIcons.musicNote,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  FutureBuilder(
                    future: game.preloadSprites,
                    builder: (context, snapshot) {
                      return _HomePageButton(
                        type: NesButtonType.primary,
                        icon: NesIcons.play,
                        text: t.homePage.playButton,
                        openBuilder: (_, __, ___) => const PlayPage(),
                        disabled: !snapshot.hasData,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.questionMarkBlock,
                    text: t.homePage.tutorialButton,
                    openBuilder: (_, __, ___) => const TutorialPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.gamepad,
                    text: t.homePage.settingsButton,
                    openBuilder: (_, __, ___) => const SettingsPage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePageButton<T> extends StatelessWidget {
  const _HomePageButton({
    super.key,
    this.type = NesButtonType.normal,
    required this.icon,
    required this.text,
    required this.openBuilder,
    this.disabled = false,
  });

  final NesButtonType type;
  final NesIconData icon;
  final String text;
  final RoutePageBuilder openBuilder;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NesButton(
        onPressed: disabled
            ? null
            : () {
                Navigator.of(context).push(
                  NesVerticalCloseTransition.route<void>(
                    pageBuilder: openBuilder,
                  ),
                );
              },
        type: type,
        child: Row(
          children: [
            NesIcon(
              iconData: icon,
              size: const Size.square(32),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
