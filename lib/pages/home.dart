import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/pages/play.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ricochlime'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: OpenContainer(
              closedBuilder: (context, openContainer) => ElevatedButton(
                onPressed: openContainer,
                child: const Text('Play'),
              ),
              closedColor: Colors.transparent,
              closedElevation: 0,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              openBuilder: (context, closeContainer) => PlayPage(),
            ),
          ),
        ],
      ),
    );
  }
}
