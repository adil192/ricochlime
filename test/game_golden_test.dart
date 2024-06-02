import 'dart:convert';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/nes/nes_theme.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

const inProgressGameSave = '''
{
  "score":50,
  "monsters":[
    {"px":0.0,"py":16.0,"maxHp":50,"killReward":1},
    {"px":32.0,"py":16.0,"maxHp":50},
    {"px":64.0,"py":16.0,"maxHp":50,"killReward":2},
    {"px":80.0,"py":16.0,"maxHp":50},
    {"px":32.0,"py":32.0,"maxHp":49,"killReward":1},
    {"px":96.0,"py":32.0,"maxHp":49,"killReward":2},
    {"px":32.0,"py":48.0,"maxHp":48,"killReward":2},
    {"px":80.0,"py":48.0,"maxHp":48,"killReward":1},
    {"px":16.0,"py":64.0,"maxHp":47,"killReward":2},
    {"px":80.0,"py":64.0,"maxHp":47,"killReward":1},
    {"px":80.0,"py":80.0,"maxHp":46,"killReward":1},
    {"px":112.0,"py":80.0,"maxHp":46,"killReward":2},
    {"px":16.0,"py":96.0,"maxHp":45,"killReward":1},
    {"px":96.0,"py":96.0,"maxHp":45,"killReward":2},
    {"px":0.0,"py":112.0,"maxHp":44},
    {"px":80.0,"py":112.0,"maxHp":44,"killReward":2},
    {"px":96.0,"py":112.0,"maxHp":44,"killReward":1},
    {"px":32.0,"py":128.0,"maxHp":43,"killReward":1},
    {"px":64.0,"py":128.0,"maxHp":43}
  ]
}''';
const gameOverGameSave = '''
{
  "score":54,
  "monsters":[
    {"px":16.0,"py":16.0,"maxHp":54,"killReward":2},
    {"px":96.0,"py":16.0,"maxHp":54,"killReward":1},
    {"px":48.0,"py":32.0,"maxHp":53},
    {"px":64.0,"py":32.0,"maxHp":53,"killReward":2},
    {"px":112.0,"py":32.0,"maxHp":53,"killReward":1},
    {"px":0.0,"py":80.0,"maxHp":50,"hp":18,"killReward":1},
    {"px":32.0,"py":96.0,"maxHp":49,"hp":19,"killReward":1},
    {"px":80.0,"py":112.0,"maxHp":48,"hp":12,"killReward":1},
    {"px":16.0,"py":128.0,"maxHp":47,"hp":12,"killReward":2},
    {"px":80.0,"py":128.0,"maxHp":47,"hp":14,"killReward":1},
    {"px":80.0,"py":144.0,"maxHp":46,"hp":10,"killReward":1},
    {"px":112.0,"py":144.0,"maxHp":46,"hp":21,"killReward":2},
    {"px":16.0,"py":160.0,"maxHp":45,"hp":20,"killReward":1},
    {"px":96.0,"py":160.0,"maxHp":45,"hp":2,"killReward":2},
    {"px":0.0,"py":176.0,"maxHp":44,"hp":36},
    {"px":64.0,"py":192.0,"maxHp":43,"hp":20}
  ]
}''';

void main() {
  group('Goldens', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Prefs.testingMode = true;
    Prefs.init();
    AdState.init();

    RicochlimeGame.disableBgMusic = true;
    RicochlimeGame.reproducibleGoldenMode = true;
    setUp(() async {
      game.random = Random(123);
      await Future.wait([
        game.preloadSprites.future,
        GoogleFonts.pendingFonts([GoogleFonts.silkscreenTextTheme()]),
      ]);
    });

    Prefs.coins.value = 166;
    Prefs.highScore.value = 62;

    _testGame(
      goldenFileName: '1_home',
      child: const HomePage(),
    );
    _testGame(
      gameSave: inProgressGameSave,
      frameColor: RicochlimePalette.waterColor,
      onFrameColor: const Color(0xFFeaf2f8),
      goldenFileName: '2_play',
      child: const PlayPage(),
    );
    // _testGame(
    //   gameSave: gameOverGameSave,
    //   frameColor: RicochlimePalette.waterColor,
    //   onFrameColor: const Color(0xFFeaf2f8),
    //   goldenFileName: '3_game_over',
    //   child: const PlayPage(),
    // );
    // _testGame(
    //   goldenFileName: '4_tutorial',
    //   child: const TutorialPage(),
    // );
    _testGame(
      goldenFileName: '5_settings',
      child: const SettingsPage(),
    );
  });
}

void _testGame({
  String? gameSave,
  Color? frameColor,
  Color? onFrameColor,
  required String goldenFileName,
  required Widget child,
}) {
  for (final device in _ScreenshotDevice.values) {
    testWidgets('$goldenFileName: ${device.name}', (tester) async {
      if (gameSave != null) {
        Prefs.currentGame.value = GameData.fromJson(jsonDecode(gameSave));
        if (game.isLoaded) {
          game
            ..resetChildren()
            ..importFromGame(Prefs.currentGame.value);
        }
      }

      final widget = _SizedEnvironment(
        device: device,
        frameColor: frameColor,
        onFrameColor: onFrameColor,
        child: child,
      );
      await tester.pumpWidget(widget);

      final context = tester.element(find.byType(_SizedEnvironment));
      await tester.runAsync(() => Future.wait([
            precacheImage(const AssetImage('assets/images/coin.png'), context),
            precacheImage(
                const AssetImage('assets/tests/android_topbar.png'), context),
          ]));

      // Aim towards the middle left of the game area
      if (child is PlayPage) {
        game.onPanUpdate(DragUpdateInfo.fromDetails(
          game,
          DragUpdateDetails(
            globalPosition:
                const Offset(0, RicochlimeGame.expectedHeight * 0.39),
          ),
        ));
      }

      await tester.pumpFrames(widget, const Duration(seconds: 3));
      await expectLater(
        find.byWidget(child),
        matchesGoldenFile('${device.goldenFolder}$goldenFileName.png'),
      );
    });
  }
}

typedef FrameBuilder = Widget Function({
  required Color? frameColor,
  required Color? onFrameColor,
  required Widget child,
});

enum _ScreenshotDevice {
  desktop(
    resolution: Size(1440, 900),
    pixelRatio: 1,
    goldenFolder: '../metadata/en-US/images/tenInchScreenshots/',
    frameBuilder: _NoFrame.new,
  ),
  android(
    resolution: Size(1440, 3120),
    pixelRatio: 10 / 3,
    goldenFolder: '../metadata/en-US/images/phoneScreenshots/',
    frameBuilder: _AndroidFrame.new,
  );

  const _ScreenshotDevice({
    required this.resolution,
    required this.pixelRatio,
    required this.goldenFolder,
    required this.frameBuilder,
  }) : assert(pixelRatio > 0);

  final Size resolution;
  final double pixelRatio;
  final String goldenFolder;
  final FrameBuilder frameBuilder;
}

class _NoFrame extends StatelessWidget {
  // ignore: unused_element
  const _NoFrame(
      {super.key, this.frameColor, this.onFrameColor, required this.child});

  final Color? frameColor, onFrameColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _AndroidFrame extends StatelessWidget {
  const _AndroidFrame({
    // ignore: unused_element
    super.key,
    required this.frameColor,
    required this.onFrameColor,
    required this.child,
  });

  final Color? frameColor, onFrameColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onFrameColor = this.onFrameColor ??
        Color.lerp(colorScheme.onSurface, colorScheme.surface, 0.3)!;
    return ColoredBox(
      color: frameColor ?? colorScheme.surface,
      child: Column(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              onFrameColor,
              BlendMode.modulate,
            ),
            child: Image.asset('assets/tests/android_topbar.png'),
          ),
          Expanded(child: child),
          SizedBox(
            height: 24,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: onFrameColor,
                ),
                child: const SizedBox(width: 125, height: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizedEnvironment extends StatelessWidget {
  const _SizedEnvironment({
    // ignore: unused_element
    super.key,
    required this.device,
    required this.frameColor,
    required this.onFrameColor,
    required this.child,
  });

  final _ScreenshotDevice device;
  final Color? frameColor, onFrameColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: nesThemeFrom(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
        ),
      ),
      themeAnimationDuration: Duration.zero,
      home: FittedBox(
        child: RepaintBoundary(
          child: SizedBox(
            width: device.resolution.width,
            height: device.resolution.height,
            child: FittedBox(
              child: SizedBox(
                width: device.resolution.width / device.pixelRatio,
                height: device.resolution.height / device.pixelRatio,
                child: device.frameBuilder(
                  frameColor: frameColor,
                  onFrameColor: onFrameColor,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
