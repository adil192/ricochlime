import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/utils/ricochlime_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RicochlimePalette.grassColor,
          brightness: Brightness.dark,
        ),
      ),
      highContrastTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.highContrastLight(),
      ),
      highContrastDarkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.highContrastDark(),
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) => PlayPage(),
    ),
  ],
);
