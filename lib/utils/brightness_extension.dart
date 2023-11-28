import 'dart:ui' show Brightness;

extension BrightnessExtension on Brightness {
  /// Returns the opposite brightness.
  Brightness get opposite =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}
