import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/ricochlime_audio.dart';

void main() {
  test('getSkullTiles bottom rows stay consistent', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    RicochlimeAudio.disableAudio = true;
    RicochlimeGame.reproducibleGoldenMode = true;
    RicochlimeGame.instance.random = Random(123);
    await RicochlimeGame.instance.preloadSprites.future;

    if (!RicochlimeGame.instance.isLoaded) {
      RicochlimeGame.instance.onGameResize(
        Vector2(RicochlimeGame.expectedWidth, RicochlimeGame.expectedHeight),
      );
      // ignore: invalid_use_of_internal_member
      await RicochlimeGame.instance.load();
    }

    final bg = RicochlimeGame.instance.background;

    RicochlimeGame.instance.numNewRowsEachRound = 1;
    final skullTiles1 = bg.getSkullTiles().toList();
    RicochlimeGame.instance.numNewRowsEachRound = 2;
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
