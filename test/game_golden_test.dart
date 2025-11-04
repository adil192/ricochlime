import 'dart:convert';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:ricochlime/ads/iap.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/nes/nes_theme.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/shop.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';
import 'package:ricochlime/utils/shop_items.dart';
import 'package:ricochlime/utils/stows.dart';
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
  group('Golden screenshot of', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    RicochlimeGame.disableBgMusic = true;
    RicochlimeGame.reproducibleGoldenMode = true;
    setUp(() async {
      RicochlimeGame.instance.random = Random(123);
      await Future.wait([
        RicochlimeGame.instance.preloadSprites.future,
      ]);
      stows.coins.value = 493;
      stows.highScore.value = 62;
    });

    ShopItems.bulletColors[1].purchase(noCost: true);
    ShopItems.bulletColors[2].purchase(noCost: true);
    ShopItems.bulletColors[7].purchase(noCost: true);
    ShopItems.bulletColors[9].purchase(noCost: true);

    _testGame(
      frameColors: ScreenshotFrameColors.dark,
      goldenFileName: '1_home',
      child: const HomePage(),
    );
    _testGame(
      gameSave: inProgressGameSave,
      frameColors: ScreenshotFrameColors.light,
      goldenFileName: '2_play',
      child: const PlayPage(),
    );
    // _testGame(
    //   gameSave: gameOverGameSave,
    //   frameColors: ScreenshotFrameColors.dark,
    //   goldenFileName: '3_game_over',
    //   child: const PlayPage(),
    // );
    _testGame(
      goldenFileName: '4_shop',
      frameColors: ScreenshotFrameColors.dark,
      child: const ShopPage(),
    );
    _testGame(
      goldenFileName: '5_tutorial',
      frameColors: ScreenshotFrameColors.dark,
      child: const TutorialPage(),
    );
    _testGame(
      goldenFileName: '6_settings',
      frameColors: ScreenshotFrameColors.dark,
      child: const SettingsPage(),
    );
  });
}

void _testGame({
  String? gameSave,
  ScreenshotFrameColors? frameColors,
  required String goldenFileName,
  required Widget child,
}) {
  group(goldenFileName, () {
    for (final goldenDevice in GoldenScreenshotDevices.values) {
      testGoldens('for ${goldenDevice.name}', (tester) async {
        final device = goldenDevice.device;
        RicochlimeIAP.forceInAppPurchasesSupported = goldenDevice.enableIAPs;
        RicochlimeProduct.init();

        if (gameSave != null) {
          stows.currentGame.value = GameData.fromJson(jsonDecode(gameSave));
          if (RicochlimeGame.instance.isLoaded) {
            RicochlimeGame.instance
              ..resetChildren()
              ..importFromGame(stows.currentGame.value);
          }
        }

        final widget = ScreenshotApp.withConditionalTitlebar(
          theme: nesThemeFrom(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: RicochlimePalette.grassColor,
            ),
          ),
          title: 'Ricochlime',
          device: device,
          frameColors: frameColors,
          home: child,
        );
        await tester.pumpWidget(widget);

        await tester.precacheImagesInWidgetTree();
        await tester.loadFonts();

        // Aim towards the middle left of the game area
        if (child is PlayPage) {
          RicochlimeGame.instance.onPanUpdate(DragUpdateInfo.fromDetails(
            RicochlimeGame.instance,
            DragUpdateDetails(
              globalPosition:
                  const Offset(0, RicochlimeGame.expectedHeight * 0.39),
            ),
          ));
        }

        await tester.pumpFrames(widget, const Duration(seconds: 3));
        await tester.expectScreenshot(device, goldenFileName);
      });
    }
  });
}

extension _GoldenScreenshotDevices on GoldenScreenshotDevices {
  bool get enableIAPs => switch (this) {
        GoldenScreenshotDevices.macbook => true,
        GoldenScreenshotDevices.iphone => true,
        GoldenScreenshotDevices.ipad => true,
        _ => false,
      };
}
