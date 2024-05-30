import 'dart:math';

extension RandomExtension on Random {
  /// Returns a random number between -[value] and [value].
  double plusOrMinus(double value) {
    assert(value >= 0);
    return -value + nextDouble() * value * 2;
  }
}
