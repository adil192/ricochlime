import 'dart:async';

class Ticker {
  final _streamController = StreamController<double>.broadcast();

  void tick(double dt) {
    _streamController.add(dt);
  }

  /// The stream of ticks.
  ///
  /// Each value is the (dilated) time in seconds
  /// since the last tick.
  Stream<double> get onTick => _streamController.stream;

  @Deprecated('This isn\'t currently used since the game is never disposed')
  void dispose() {
    _streamController.close();
  }

  /// Waits for the given [duration] to pass.
  ///
  /// The actual time may be slightly longer than the given
  /// [duration] since it is rounded to the next tick.
  ///
  /// If [onTick] is provided, it will be called for each tick,
  /// including the final tick when the duration is reached/passed.
  /// Return [TickerDelayedInstruction.stopEarly] in [onTick] to stop the
  /// ticker early.
  ///
  /// Returns the actual elapsed time in seconds.
  Future<double> delayed(
    Duration duration, {
    TickerDelayedInstruction? Function()? onTick,
  }) async {
    final durationInSeconds = duration.inMilliseconds / 1000;
    var elapsed = 0.0;
    await for (final dt in this.onTick) {
      elapsed += dt;

      switch (onTick?.call()) {
        case TickerDelayedInstruction.stopEarly:
          return elapsed;
        default:
          break;
      }

      if (elapsed >= durationInSeconds) return elapsed;
    }
    throw StateError(
      'Ticker.delayed: Game was disposed before the duration passed',
    );
  }
}

enum TickerDelayedInstruction {
  /// Return this value in [Ticker.delayed]'s `onTick`
  /// to stop the ticker early.
  stopEarly,
}
