import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/nes/nes_theme.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _mockAudioPlayer() {
  const channel = MethodChannel('xyz.luan/audioplayers');
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    // do nothing
    return '';
  });
}

void main() {
  testWidgets('Golden game test', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    _mockAudioPlayer();
    Prefs.testingMode = true;
    Prefs.init();
    AdState.init();

    game.random = Random(123);
    await tester.runAsync(() => game.preloadSprites);

    var widget = GameEnvironment(
      game: game,
      screenSize: const Size(1080 * 0.4, 2400 * 0.4),
    );
    await tester.pumpWidget(widget);
    await tester.pumpFrames(widget, const Duration(seconds: 3));
    await expectLater(
      find.byType(PlayPage),
      matchesGoldenFile('golden/mobile.png'),
    );

    widget = GameEnvironment(
      game: game,
      screenSize: const Size(1920, 1080),
    );
    await tester.pumpWidget(widget);
    await tester.pumpFrames(widget, const Duration(seconds: 3));
    await expectLater(
      find.byType(PlayPage),
      matchesGoldenFile('golden/desktop.png'),
    );
  });
}

class GameEnvironment extends StatelessWidget {
  const GameEnvironment({
    super.key,
    required this.game,
    required this.screenSize,
  });

  final RicochlimeGame game;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: nesThemeFrom(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
        ),
      ),
      home: FittedBox(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: const RepaintBoundary(
            child: PlayPage(),
          ),
        ),
      ),
    );
  }
}
