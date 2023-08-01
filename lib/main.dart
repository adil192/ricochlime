import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

void main() {
  final game = RicochlimeGame();
  runApp(GameWidget(game: game));
}
