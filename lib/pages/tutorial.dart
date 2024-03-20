import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  static const maxWidth = 600.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tutorialPage.tutorial),
        toolbarHeight: kToolbarHeight,
        leading: Center(
          child: NesIconButton(
            onPress: () => Navigator.of(context).pop(),
            size: const Size.square(kToolbarHeight * 0.4),
            icon: NesIcons.leftArrowIndicator,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 18,
            ),
            child: ListView(
              children: [
                Text(
                  t.tutorialPage.aimAtMonsters,
                  textAlign: TextAlign.center,
                ),
                const _TutorialScreenshot(
                  image: AssetImage('assets/tutorial/aimAtMonsters.png'),
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.bounceOffWalls,
                  textAlign: TextAlign.center,
                ),
                const _TutorialScreenshot(
                  image: AssetImage('assets/tutorial/bounceOffWalls.png'),
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.tapSpeedUp,
                  textAlign: TextAlign.center,
                ),
                const _TutorialScreenshot(
                  image: AssetImage('assets/tutorial/tapSpeedUp.png'),
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.dangerZone,
                  textAlign: TextAlign.center,
                ),
                const _TutorialScreenshot(
                  image: AssetImage('assets/tutorial/dangerZone.png'),
                ),
                const SizedBox(height: 18),
                Text(
                  t.tutorialPage.moreMonsters,
                  textAlign: TextAlign.center,
                ),
                const _TutorialScreenshot(
                  image: AssetImage('assets/tutorial/moreMonsters.png'),
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

class _TutorialScreenshot extends StatelessWidget {
  const _TutorialScreenshot({
    // ignore: unused_element
    super.key,
    required this.image,
  });

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width > TutorialPage.maxWidth) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image(
          image: image,
          filterQuality: FilterQuality.none,
        ),
      );
    } else {
      return Image(
        image: image,
        filterQuality: FilterQuality.none,
      );
    }
  }
}
