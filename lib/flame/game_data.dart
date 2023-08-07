import 'package:ricochlime/flame/components/slime.dart';

class GameData {
  final int score;
  /// The maximum number of bullets the player has had at any point in the game.
  /// Since bullet pickups are not implemented yet, this falls back to [score].
  final int? numBullets;
  /// The result of calling [Slime.toJson] on each slime in the game.
  final List<Map<String, dynamic>> slimes;

  GameData({
    required this.score,
    required this.numBullets,
    required List<Slime> slimes,
  }) : slimes = slimes.map((slime) => slime.toJson()).toList();

  GameData.fromJson(Map<String, dynamic> json)
      : score = json['score'] as int,
        numBullets = json['numBullets'] as int,
        slimes = (json['slimes'] as List).cast<Map<String, dynamic>>();

  Map<String, dynamic> toJson() => {
    'score': score,
    'numBullets': numBullets ?? score,
    'slimes': slimes,
  };
}
