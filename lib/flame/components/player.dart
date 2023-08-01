import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
