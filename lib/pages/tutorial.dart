import 'package:flutter/material.dart';
import 'package:ricochlime/i18n/strings.g.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tutorialPage.tutorial),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 18,
            ),
            child: ListView(
              children: [
                // TODO(adil192): Add images to tutorial
                Text(
                  t.tutorialPage.aimAtSlimes,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.emptyHealthbar,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.bounceOffWalls,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.dangerZone,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.moreSlimes,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
