import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/utils/shop_items.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

@visibleForTesting
class Stows {
  final currentGame = PlainStow.json(
    'currentGame',
    null as GameData?,
    fromJson: (json) => GameData.fromJson(json as Map<String, dynamic>),
  );
  final highScore = PlainStow('highScore', 0);

  final hyperlegibleFont = PlainStow('hyperlegibleFont', false);
  final stylizedPageTransitions = PlainStow('stylizedPageTransitions', true);
  final biggerBullets = PlainStow('biggerBullets', false);

  final bgmVolume = PlainStow('bgmVolume', 0.0);

  final showUndoButton = PlainStow('showUndoButton', true);
  final showReflectionInAimGuide = PlainStow('showReflectionInAimGuide', true);

  final coins = PlainStow('coins', 0);
  final bulletColor = PlainStow(
    'bulletColor',
    ShopItems.bulletColors.first.color,
    codec: ColorCodec(),
  );
  final bulletShape = PlainStow('bulletShape', ShopItems.bulletShapes.first.id);

  final maxFps = PlainStow('maxFps', -1);
  final showFpsCounter = PlainStow('showFpsCounter', false);

  final totalCoinsGained = PlainStow('totalCoinsGained', 0);
  final totalBulletsGained = PlainStow('totalBulletsGained', 0);
  final totalMonstersKilled = PlainStow('totalMonstersKilled', 0);
  final totalGameOvers = PlainStow('totalGameOvers', 0);
  final totalAdsWatched = PlainStow('totalAdsWatched', 0);
  final totalGamesContinued = PlainStow('totalTimesContinued', 0);
  final totalMovesUndone = PlainStow('totalTimesUndone', 0);

  void addCoins(int toAdd, {bool allowOverMax = false}) {
    const maxCoins = 100 * 1000;
    late final sum = coins.value + toAdd;
    if (allowOverMax) {
      totalCoinsGained.value += toAdd;
      coins.value = sum;
    } else if (coins.value > maxCoins) {
      // don't add or remove coins if we're already above the max
    } else if (sum > maxCoins) {
      totalCoinsGained.value += maxCoins - coins.value;
      coins.value = maxCoins;
    } else {
      totalCoinsGained.value += toAdd;
      coins.value = sum;
    }
  }
}
