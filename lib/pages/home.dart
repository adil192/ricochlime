import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            t.appName,
            style: const TextStyle(
              fontSize: kToolbarHeight,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HomePageButton(
            text: t.homePage.playButton,
            openBuilder: (context, closeContainer) => const PlayPage(),
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
        closedBuilder: (context, openContainer) => ElevatedButton(
          onPressed: openContainer,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        closedColor: Colors.transparent,
        closedElevation: 0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        openBuilder: openBuilder,
        clipBehavior: Clip.none,
      ),
    );
  }
}
