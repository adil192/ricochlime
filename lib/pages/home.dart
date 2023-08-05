import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ricochlime'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/play');
          },
          child: const Text('Play'),
        ),
      ),
    );
  }
}
