import 'package:ricochlime/flame/components/monster.dart';

class GameData {
  GameData({required this.score, required Iterable<Monster> monsters})
    : monsters = monsters.map((monster) => monster.toJson()).toList();

  GameData.fromJson(Map<String, dynamic> json)
    : score = json['score'] as int,
      monsters = ((json['monsters'] ?? json['slimes']) as List)
          .cast<Map<String, dynamic>>();

  final int score;

  /// The result of calling [monster.toJson] on each monster in the game.
  final List<Map<String, dynamic>> monsters;

  Map<String, dynamic> toJson() => {'score': score, 'monsters': monsters};
}
