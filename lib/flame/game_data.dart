import 'package:ricochlime/flame/components/slime.dart';

class GameData {
  final int score;
  /// The result of calling [Slime.toJson] on each slime in the game.
  final List<Map<String, dynamic>> slimes;

  GameData({
    required this.score,
    required List<Slime> slimes,
  }): slimes = slimes.map((slime) => slime.toJson()).toList();

  GameData.fromJson(Map<String, dynamic> json)
      : score = json['score'] as int,
        slimes = (json['slimes'] as List).cast<Map<String, dynamic>>();

  Map<String, dynamic> toJson() => {
    'score': score,
    'slimes': slimes,
  };
}
