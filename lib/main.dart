import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/pages/play.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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
