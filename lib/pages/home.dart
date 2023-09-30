import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/main.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/brightness_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static bool handledConsent = false;

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
                  const SizedBox(height: 64),
                  _HomePageButton(
                    type: NesButtonType.primary,
                    icon: NesIcons.rightArrowIndicator,
                    text: t.homePage.playButton,
                    openBuilder: (context, closeContainer) => const PlayPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.questionMarkBlock,
                    text: t.homePage.tutorialButton,
                    openBuilder: (context, closeContainer) => const TutorialPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.openFolder,
                    text: t.homePage.settingsButton,
                    openBuilder: (context, closeContainer) => const SettingsPage(),
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
  });

  final NesButtonType type;
  final NesIconData icon;
  final String text;
  final OpenContainerBuilder<T> openBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OpenContainer(
        closedBuilder: (context, openContainer) => NesButton(
          onPressed: openContainer,
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
        closedColor: Colors.transparent,
        closedElevation: 0,
        openBuilder: openBuilder,
        clipBehavior: Clip.none,
      ),
    );
  }
}
