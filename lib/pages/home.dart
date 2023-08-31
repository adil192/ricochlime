import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/tutorial.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              t.appName,
              style: const TextStyle(
                fontSize: kToolbarHeight,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _HomePageButton(
            text: t.homePage.playButton,
            openBuilder: (context, closeContainer) => const PlayPage(),
          ),
          const SizedBox(height: 32),
          _HomePageButton(
            text: t.homePage.tutorialButton,
            openBuilder: (context, closeContainer) => const TutorialPage(),
          ),
          const SizedBox(height: 32),
          _HomePageButton(
            text: t.homePage.settingsButton,
            openBuilder: (context, closeContainer) => const SettingsPage(),
          ),
        ],
      ),
    );
  }
}

class _HomePageButton<T> extends StatelessWidget {
  const _HomePageButton({
    super.key,
    required this.text,
    required this.openBuilder,
  });

  final String text;
  final OpenContainerBuilder<T> openBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OpenContainer(
        closedBuilder: (context, openContainer) => NesButton(
          onPressed: openContainer,
          type: NesButtonType.primary,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 32,
            ),
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
