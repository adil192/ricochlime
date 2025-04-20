import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/components/bullet.dart';
import 'package:ricochlime/flame/components/walls.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/utils/prefs.dart';

/// A component that draws a dotted line
/// to show the user where they're aiming.
class AimGuide extends PositionComponent with HasGameReference<RicochlimeGame> {
  /// Information about the current aim.
  ///
  /// This is null if the user is not aiming.
  @visibleForTesting
  AimDetails? aimDetails;

  Vector2? lastMousePosition;
  int lastNumDotsBeforeReflection = 0;

  /// Dots will be drawn in the direction we're aiming
  /// every [_dotInterval] units.
  static const double _dotInterval = 10;

  /// The maximum number of dots to be drawn.
  static const _maxDots = 20;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = game.player.position;
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

    const gameInset = Bullet.radius + wallInset;
    const gameRect = Rect.fromLTRB(
      gameInset,
      gameInset,
      RicochlimeGame.expectedWidth - gameInset,
      RicochlimeGame.expectedHeight - gameInset,
    );

    /// The position where the aim guide hits the left or right wall,
    /// relative to the player.
    final reflectionPoint = aimDetails.reflectionPoint(position, gameRect);
    final reflectionDist = reflectionPoint.length;
    final numDotsTotal = (aimDetails.aimLength * _maxDots).ceil();

    final int numDotsBeforeReflection;
    final numDotsBeforeReflectionUnrounded =
        min(numDotsTotal, reflectionDist / _dotInterval);
    if ((numDotsBeforeReflectionUnrounded - lastNumDotsBeforeReflection).abs() <
        0.5) {
      numDotsBeforeReflection = lastNumDotsBeforeReflection;
    } else {
      numDotsBeforeReflection = numDotsBeforeReflectionUnrounded.floor();
      lastNumDotsBeforeReflection = numDotsBeforeReflection;
    }

    final numDotsAfterReflection = min(
      numDotsTotal - numDotsBeforeReflection,
      Prefs.showReflectionInAimGuide.value ? numDotsTotal : 1,
    );

    final adjustedDotInterval = numDotsBeforeReflection >= numDotsTotal
        ? _dotInterval
        : reflectionDist / numDotsBeforeReflection;
    final dotDelta = aimDetails.unitDir * adjustedDotInterval;
    for (double dot = 0; dot < numDotsBeforeReflection; dot++) {
      final dotPosition = dotDelta * dot;
      Bullet.drawBullet(canvas, dotPosition, opacity: 1);
    }

    dotDelta.x *= -1; // reflect
    for (double dot = 0; dot < numDotsAfterReflection; dot++) {
      final dotPosition = reflectionPoint + dotDelta * dot;
      Bullet.drawBullet(canvas, dotPosition, opacity: 0.8);
    }
  }

  /// Updates the aim guide based on the given mouse position.
  void aim(
    Vector2 mousePosition, {
    bool ignoreWhetherMouseIsBelowPlayer = false,
  }) {
    final displacement = position - mousePosition;
    final distance = displacement.length;
    final mouseBelowPlayer = displacement.y < 0;

    if (aimDetails == null) {
      // The user just started aiming.
      aimDetails = AimDetails(
        unitDir: Vector2.zero(),
        aimLength: 0,
        mouseBelowPlayer: mouseBelowPlayer,
      );
    } else if (!ignoreWhetherMouseIsBelowPlayer &&
        aimDetails!.mouseBelowPlayer != mouseBelowPlayer) {
      // The user moved the mouse to the other side of the player.
      // This means they want to cancel the aim.
      aimDetails!.unitDir.setZero();
      return;
    } else {
      aimDetails!.mouseBelowPlayer = mouseBelowPlayer;
    }

    // Don't allow extremely horizontal aims.
    final relX = (displacement.x / distance).abs();
    const maxRelX = 0.999;
    late final minRelY = sqrt(1 - maxRelX * maxRelX);
    if (relX > maxRelX) {
      // Reconstruct displacement as if relX was equal to maxRelX.
      displacement
        ..x = distance * maxRelX * displacement.x.sign
        ..y = distance * minRelY * displacement.y.sign;
    }

    if (!mouseBelowPlayer) {
      displacement
        ..x = -displacement.x
        ..y = -displacement.y;
    }

    final aimLengthMultiplier = mouseBelowPlayer ? 8 : 4;
    aimDetails!.aimLength = min(
      1,
      distance / _dotInterval / _maxDots * aimLengthMultiplier,
    );
    aimDetails!.unitDir
      ..x = displacement.x / distance
      ..y = displacement.y / distance;
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

  /// Returns the point (relative to the player)
  /// where the aim guide hits the left or right wall,
  /// beginning from the player's position and in the direction of [unitDir].
  Vector2 reflectionPoint(Vector2 playerPos, Rect gameRect) {
    if (unitDir.x == 0) return Vector2(0, gameRect.top - playerPos.y);

    final y = unitDir.y / unitDir.x.abs() * gameRect.width / 2;
    final x = unitDir.x > 0 ? gameRect.right : gameRect.left;
    return Vector2(x - playerPos.x, y);
  }
}
