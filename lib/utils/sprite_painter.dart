import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/background/background_tile.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class SpritePainter extends CustomPainter {
  const SpritePainter({required this.sprite, this.fit = BoxFit.contain});

  final Sprite sprite;
  final BoxFit fit;

  @override
  void paint(Canvas canvas, Size size) {
    final fittedSize = applyBoxFit(
      BoxFit.contain,
      Size(sprite.src.width, sprite.src.height),
      size,
    ).destination.toVector2();

    sprite.render(
      canvas,
      position: size.toVector2()..scale(0.5),
      size: fittedSize,
      anchor: Anchor.center,
    );
  }

  @override
  bool shouldRepaint(covariant SpritePainter oldDelegate) =>
      oldDelegate.sprite != sprite || oldDelegate.fit != fit;
}

class MonsterWidget extends StatelessWidget {
  const MonsterWidget({super.key, required this.spritePath});

  final String spritePath;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: SpritePainter(
        sprite: Sprite(
          RicochlimeGame.instance.images.fromCache(spritePath),
          srcPosition: Vector2.zero(),
          srcSize: Vector2(24, 24),
        ),
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  static const spritePath = 'character_subset.png';

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: SpritePainter(
        sprite: Sprite(
          RicochlimeGame.instance.images.fromCache(spritePath),
          srcPosition: Vector2(0, 23),
          srcSize: Vector2(17, 23),
        ),
      ),
    );
  }
}

class SkullsWidget extends StatelessWidget {
  const SkullsWidget({super.key, required this.type});

  final SkullType type;

  static const spritePath = 'overworld.png';

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpritePainter(
        sprite: Sprite(
          RicochlimeGame.instance.images.fromCache(spritePath),
          srcPosition: Vector2(type.x, type.y),
          srcSize: Vector2.all(16),
        ),
      ),
    );
  }
}
