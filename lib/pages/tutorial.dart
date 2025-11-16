import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:ricochlime/utils/sprite_painter.dart';

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
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 18),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const MonsterWidget(spritePath: 'log_normal.png'),
                      Expanded(
                        child: Text(
                          RicochlimeGame.instance.pointAndClickEnabled
                              ? t.tutorialPage.pointAndClick
                              : t.tutorialPage.dragAndRelease,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const MonsterWidget(spritePath: 'log_gold.png'),
                      Expanded(child: Text(t.tutorialPage.goldMonsters)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const MonsterWidget(spritePath: 'log_green.png'),
                      Expanded(child: Text(t.tutorialPage.greenMonsters)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: Text(t.tutorialPage.bounceOffWalls)),
                      const SizedBox(width: 8),
                      const _BounceOffWallsGraphic(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text(t.tutorialPage.tapSpeedUp)),
                      const SizedBox(width: 8),
                      const _TutorialGraphic(
                        child: FittedBox(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              '5.0x',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const _SkullsGraphic(crossAxisCount: 2),
                      const SizedBox(width: 8),
                      Expanded(child: Text(t.tutorialPage.skullLine)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const _SkullsGraphic(crossAxisCount: 4),
                      const SizedBox(width: 8),
                      Expanded(child: Text(t.tutorialPage.moreMonsters)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: Text(t.tutorialPage.useCoinsInShop)),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: NesIcon(
                          iconData: NesIcons.market,
                          size: const Size.square(50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(t.tutorialPage.orUseCoinsToContinue),
                      ),
                      const SizedBox(width: 8),
                      const PlayerWidget(),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialGraphic extends StatelessWidget {
  const _TutorialGraphic({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return NesContainer(
      width: 100,
      height: 100,
      backgroundColor: isDarkMode
          ? RicochlimePalette.grassColorDark
          : RicochlimePalette.grassColor,
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class _BounceOffWallsGraphic extends StatelessWidget {
  const _BounceOffWallsGraphic();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: const Size(100, 100),
      painter: _BounceOffWallsGraphicPainter(
        color: isDarkMode ? Colors.white : RicochlimePalette.grassColorDark,
      ),
    );
  }
}

class _BounceOffWallsGraphicPainter extends CustomPainter {
  const _BounceOffWallsGraphicPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const bounces = 7;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var lastPoint = Offset(size.width, size.height);
    for (var i = 1; i < bounces; i++) {
      final progress = i / bounces;

      final nextPoint = Offset(
        i.isEven ? size.width : 0,
        size.height * (1 - progress * 0.7),
      );
      paint.color = color.withValues(alpha: progress);

      canvas.drawLine(lastPoint, nextPoint, paint);
      lastPoint = nextPoint;
    }

    final finalPoint = Offset(size.width * 0.4, size.height * 0.3);
    paint.color = color;
    canvas
      ..drawLine(lastPoint, finalPoint, paint)
      ..drawCircle(finalPoint, 4, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _BounceOffWallsGraphicPainter oldDelegate) =>
      color != oldDelegate.color;
}

class _SkullsGraphic extends StatelessWidget {
  const _SkullsGraphic({required this.crossAxisCount});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final random = Random(123);
    final skullTypes = List.generate(
      crossAxisCount * crossAxisCount,
      (index) => SkullType.random(random),
    );
    return SizedBox.square(
      dimension: 100,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
        ),
        itemCount: crossAxisCount * crossAxisCount,
        itemBuilder: (context, index) {
          return SkullsWidget(type: skullTypes[index]);
        },
      ),
    );
  }
}
