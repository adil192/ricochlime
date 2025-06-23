import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:ricochlime/utils/shop_items.dart';
import 'package:stow_codecs/stow_codecs.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

@visibleForTesting
class Stows {
  final currentGame = PlainStow.json('currentGame', null as GameData?,
      fromJson: (json) => GameData.fromJson(json as Map<String, dynamic>));
  final highScore = PlainStow.simple('highScore', 0);

  final hyperlegibleFont = PlainStow.simple('hyperlegibleFont', false);
  final stylizedPageTransitions =
      PlainStow.simple('stylizedPageTransitions', true);
  final biggerBullets = PlainStow.simple('biggerBullets', false);

  final bgmVolume = PlainStow.simple('bgmVolume', 0.0);

  final showUndoButton = PlainStow.simple('showUndoButton', true);
  final showReflectionInAimGuide =
      PlainStow.simple('showReflectionInAimGuide', true);

  final coins = PlainStow.simple('coins', 0);
  final bulletColor = PlainStow(
      'bulletColor', ShopItems.bulletColors.first.color, const ColorCodec());
  final bulletShape =
      PlainStow.simple('bulletShape', ShopItems.bulletShapes.first.id);

  final maxFps = PlainStow.simple('maxFps', -1);
  final showFpsCounter = PlainStow.simple('showFpsCounter', false);

  final totalCoinsGained = PlainStow.simple('totalCoinsGained', 0);
  final totalBulletsGained = PlainStow.simple('totalBulletsGained', 0);
  final totalMonstersKilled = PlainStow.simple('totalMonstersKilled', 0);
  final totalGameOvers = PlainStow.simple('totalGameOvers', 0);
  final totalAdsWatched = PlainStow.simple('totalAdsWatched', 0);
  final totalGamesContinued = PlainStow.simple('totalTimesContinued', 0);
  final totalMovesUndone = PlainStow.simple('totalTimesUndone', 0);

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
