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
  /// Returns the elapsed time in seconds.
  Future<double> delayed(Duration duration) async {
    final durationInSeconds = duration.inMilliseconds / 1000;
    var elapsed = 0.0;
    await for (final dt in onTick) {
      elapsed += dt;
      if (elapsed >= durationInSeconds) return elapsed;
    }
    throw StateError(
      'Ticker.delayed: Game was disposed before the duration passed',
    );
  }
}
