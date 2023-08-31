import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/utils/prefs.dart';

ThemeData nesThemeFrom({
  required Brightness brightness,
  required ColorScheme colorScheme,
}) {
  return flutterNesTheme(
    brightness: brightness,
    primaryColor: colorScheme.primary,
    nesButtonTheme: NesButtonTheme(
      normal: colorScheme.surface,
      primary: colorScheme.primary,
      success: colorScheme.primary,
      warning: colorScheme.error,
      error: colorScheme.error,
      lightLabelColor: brightness == Brightness.light
          ? colorScheme.onPrimary
          : colorScheme.onSurface,
      darkLabelColor: brightness == Brightness.light
          ? colorScheme.onSurface
          : colorScheme.onPrimary,
      borderColor: brightness == Brightness.light
          ? Colors.black
          : colorScheme.onPrimary,
    )
  ).copyWith(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: _getTextTheme(brightness),
  );
}

TextTheme _getTextTheme(Brightness brightness) {
  final baseTheme = ThemeData(brightness: brightness);
  if (Prefs.hyperlegibleFont.value) {
    return GoogleFonts.atkinsonHyperlegibleTextTheme(baseTheme.textTheme);
  } else {
    return GoogleFonts.silkscreenTextTheme(baseTheme.textTheme);
  }
}
