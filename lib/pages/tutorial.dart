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
      body: ListView(
        children: [
          // TODO(adil192): Add images to tutorial
          Text(t.tutorialPage.aimAtSlimes),
          Text(t.tutorialPage.emptyHealthbar),
          Text(t.tutorialPage.bounceOffWalls),
          Text(t.tutorialPage.dangerZone),
          Text(t.tutorialPage.moreSlimes),
        ],
      ),
    );
  }
}
