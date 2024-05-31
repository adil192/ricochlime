import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('getSkullTiles bottom rows stay consistent', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Prefs.testingMode = true;
    Prefs.init();
    AdState.init();
    RicochlimeGame.disableBgMusic = true;
    RicochlimeGame.reproducibleGoldenMode = true;
    game.random = Random(123);
    await game.preloadSprites.future;

    if (!game.isLoaded) {
      game.onGameResize(
          Vector2(RicochlimeGame.expectedWidth, RicochlimeGame.expectedHeight));
      // ignore: invalid_use_of_internal_member
      await game.load();
    }

    final bg = game.background;

    game.numNewRowsEachRound = 1;
    final skullTiles1 = bg.getSkullTiles().toList();
    game.numNewRowsEachRound = 2;
    final skullTiles2 = bg.getSkullTiles().toList();

    expect(skullTiles1.length, lessThan(skullTiles2.length));

    for (int i = 0; i < skullTiles1.length; i++) {
      final skull1 = skullTiles1[i];
      final skull2 = skullTiles2[i];

      expect(skull1.position, skull2.position);
      expect(skull1.type, skull2.type);
    }
  });
}
