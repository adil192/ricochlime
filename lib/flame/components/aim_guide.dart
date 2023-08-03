import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/player.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

class AimGuide extends PositionComponent
    with HasGameRef<RicochlimeGame> {
  
  final Paint _paint = Paint()
      ..color = Colors.white;

  /// The unit direction vector in which the user is
  /// currently aiming.
  /// 
  /// This is null if the user isn't currently aiming.
  Vector2? _unitDir;

  /// The length of the aim guide:
  /// 1 means the aim guide is fully extended.
  double _aimLength = 0;

  /// Dots will be drawn in the direction we're aiming
  /// every [_dotInterval] units.
  static const _dotInterval = 10;
  /// The maximum number of dots to be drawn.
  static const _maxDots = 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = gameRef.size / 2 + Vector2(0, Player.staticHeight * 1.25);
    width = 0;
    height = 0;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_unitDir == null) {
      return;
    }

    for (var dotIndex = 0; dotIndex < _maxDots * _aimLength; dotIndex++) {
      final distFromCenter = _dotInterval * (dotIndex + 1);
      final dotPos = _unitDir! * distFromCenter.toDouble();
      canvas.drawCircle(Offset(dotPos.x, dotPos.y), 2, _paint);
    }
  }

  void aim(Vector2 mousePosition) {
    var relativePosition = position - mousePosition;
    if (relativePosition.y > 0) { // pointing down
      relativePosition = -relativePosition; // point up
    }
    _aimLength = min(1, relativePosition.length / _dotInterval / _maxDots * 2);
    _unitDir = relativePosition.normalized();
  }
  void finishAim() {
    _aimLength = 0;
    _unitDir = null;
  }

}
