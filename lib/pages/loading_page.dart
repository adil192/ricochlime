import 'dart:async';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/iap.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/pages/home.dart';
import 'package:ricochlime/utils/ricochlime_audio.dart';
import 'package:ricochlime/utils/stows.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();

  /// A list of asynchronous tasks to be completed during the loading phase.
  static final tasks = _sequentialize([
    LocaleSettings.useDeviceLocale(),
    stows.highScore.waitUntilRead(),
    stows.stylizedPageTransitions.waitUntilRead(),
    GoogleFonts.pendingFonts([GoogleFonts.silkscreenTextTheme()]),
    RicochlimeGame.instance.preloadSprites.future,
    RicochlimeIAP.init(),
    RicochlimeAudio.load(),
  ]);

  /// Sets a minimum duration for each future.
  /// The futures are still run in parallel, but to the user, it appears
  /// as if they complete sequentially.
  static List<Task> _sequentialize(List<Future> futures) {
    final length = futures.length;
    final random = Random();
    // Android needs longer before showing the home page,
    // because the Game Dashboard overlay steals focus for a moment.
    final targetLoadingTime = defaultTargetPlatform == TargetPlatform.android
        ? const Duration(seconds: 1, milliseconds: 700)
        : const Duration(milliseconds: 700);
    return List.generate(length + 1, (index) {
      if (index == length) {
        // Final task to delay page transition.
        return Task(Future.delayed(targetLoadingTime));
      }

      var cumulativeDuration = targetLoadingTime * ((index + 1) / (length + 2));
      cumulativeDuration *= random.nextDoubleBetween(0.75, 1.25);
      return Task(
        Future.wait([futures[index], Future.delayed(cumulativeDuration)]),
      );
    }, growable: false);
  }
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    for (final task in LoadingPage.tasks) {
      task.addListener(_checkOnTasks);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkOnTasks();
  }

  @override
  void dispose() {
    for (final task in LoadingPage.tasks) {
      task.removeListener(_checkOnTasks);
    }
    super.dispose();
  }

  int tasksCompleted = 0;
  int tasksTotal = 0;
  void _tallyTasks() {
    var tasksCompleted = 0;
    for (var i = 0; i < LoadingPage.tasks.length - 1; ++i) {
      if (LoadingPage.tasks[i].isComplete) {
        tasksCompleted += 1;
      }
    }
    this.tasksCompleted = tasksCompleted;
    tasksTotal = LoadingPage.tasks.length - 1;
  }

  void _checkOnTasks() {
    if (!mounted) return;

    _tallyTasks();

    if (tasksCompleted >= tasksTotal) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, _, _) => const HomePage(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 200),
        ),
      );
      return;
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: NesProgressBar(
              value: tasksCompleted >= tasksTotal
                  ? 1.0
                  : tasksCompleted / tasksTotal,
            ),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class Task extends ChangeNotifier {
  Task(Future future) {
    future.then(_markComplete);
  }

  bool _isComplete = false;
  bool get isComplete => _isComplete;

  void _markComplete(_) {
    _isComplete = true;
    notifyListeners();
  }
}
