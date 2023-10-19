import 'package:ricochlime/flame/components/slime.dart';

class GameData {
  GameData({
    required this.score,
    required List<Slime> slimes,
  }): slimes = slimes.map((slime) => slime.toJson()).toList();

  GameData.fromJson(Map<String, dynamic> json)
      : score = json['score'] as int,
        slimes = (json['slimes'] as List).cast<Map<String, dynamic>>();

  final int score;
  /// The result of calling [Slime.toJson] on each slime in the game.
  final List<Map<String, dynamic>> slimes;

  Map<String, dynamic> toJson() => {
    'score': score,
    'slimes': slimes,
  };
}
