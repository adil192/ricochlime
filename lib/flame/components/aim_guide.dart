import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';

/// A component that draws a dotted line
/// to show the user where they're aiming.
class AimGuide extends PositionComponent with HasGameRef<RicochlimeGame> {
  final Paint _paint = Paint()..color = Colors.white;

  /// Information about the current aim.
  ///
  /// This is null if the user is not aiming.
  @visibleForTesting
  AimDetails? aimDetails;

  /// Dots will be drawn in the direction we're aiming
  /// every [_dotInterval] units.
  static const _dotInterval = 10;

  /// The maximum number of dots to be drawn.
  static const _maxDots = 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = gameRef.player.position;
    width = 0;
    height = 0;
    anchor = Anchor.center;
    priority = 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final aimDetails = this.aimDetails;
    if (aimDetails == null || aimDetails.unitDir.isZero()) {
      return;
    }

    for (var dot = 0; dot < _maxDots * aimDetails.aimLength; dot++) {
      final distFromCenter = _dotInterval * (dot + 1);
      final dotPos = aimDetails.unitDir * distFromCenter.toDouble();
      canvas.drawCircle(Offset(dotPos.x, dotPos.y), Bullet.radius, _paint);
    }
  }

  /// Updates the aim guide based on the given mouse position.
  void aim(Vector2 mousePosition) {
    var relativePosition = position - mousePosition;
    final mouseBelowPlayer = relativePosition.y > 0;

    if (aimDetails == null) {
      // The user just started aiming.
      aimDetails = AimDetails(
        unitDir: Vector2.zero(),
        aimLength: 0,
        mouseBelowPlayer: mouseBelowPlayer,
      );
    } else if (aimDetails!.mouseBelowPlayer != mouseBelowPlayer) {
      // The user moved the mouse to the other side of the player.
      // This means they want to cancel the aim.
      aimDetails!.unitDir.setZero();
      return;
    }

    if (mouseBelowPlayer) {
      relativePosition = -relativePosition; // point up
    }

    final aimLengthMultiplier = mouseBelowPlayer ? 3 : 2;
    aimDetails!.aimLength = min(
      1,
      relativePosition.length / _dotInterval / _maxDots * aimLengthMultiplier,
    );
    aimDetails!.unitDir.setFrom(relativePosition.normalized());
  }

  /// Resets the aim guide, and returns the current aim direction.
  Vector2? finishAim() {
    final aimDir = aimDetails?.unitDir;
    aimDetails = null;
    if (aimDir == null || aimDir.isZero()) {
      return null;
    }
    return aimDir;
  }
}

/// Information about the current aim.
class AimDetails {
  // ignore: public_member_api_docs
  AimDetails({
    required this.unitDir,
    required this.aimLength,
    required this.mouseBelowPlayer,
  });

  /// The unit direction vector in which the user is
  /// currently aiming.
  ///
  /// This is Vector2.zero() if the user's aim
  /// is not valid.
  final Vector2 unitDir;

  /// The length of the aim guide:
  /// 1 means the aim guide is fully extended.
  double aimLength;

  /// Whether the mouse is below the player.
  /// This is used to let the player cancel the aim
  /// by moving the mouse to the other side of the player.
  bool mouseBelowPlayer;
}
