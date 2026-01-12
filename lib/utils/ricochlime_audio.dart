import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';
import 'package:ricochlime/utils/stows.dart';

final _soLoud = SoLoud.instance;

final class RicochlimeAudio {
  RicochlimeAudio() {
    init();
  }

  static final _soLoudInitFuture = _soLoud.init(channels: .mono);
  static FutureOr<AudioSource> _hitSfxAudioSource = _soLoud.loadAsset(
    'assets/audio/sfx/759825__noisyredfox__hitwood.wav',
  );
  static FutureOr<AudioSource> _bgmAudioSource = _soLoud.loadAsset(
    'assets/audio/bgm/Ludum_Dare_32_Track_4.wav',
  );

  /// Disable audio for testing purposes.
  @visibleForTesting
  static bool disableAudio = false;
  static const _bgmFadeDuration = Duration(seconds: 1);

  static Future<void> load() async {
    if (disableAudio) return;
    await _soLoudInitFuture;
    _hitSfxAudioSource = await _hitSfxAudioSource;
    _bgmAudioSource = await _bgmAudioSource;
    _soLoud.setMaxActiveVoiceCount(32);
  }

  final log = Logger('RicochlimeAudio');

  SoundHandle? _bgmHandle;
  _AudioPool? _hitSfxPool;
  Future<void> init() async {
    if (disableAudio) return;
    await _soLoudInitFuture;

    _hitSfxPool = _AudioPool(await _hitSfxAudioSource, targetPoolSize: 10);
    await _hitSfxPool!.init();

    _bgmHandle ??= await _soLoud.play(
      await _bgmAudioSource,
      volume: 0,
      paused: true,
      looping: true,
    );
    _soLoud.setProtectVoice(_bgmHandle!, true);
  }

  void playHitSfx() {
    if (disableAudio) return;
    _hitSfxPool?.play();
  }

  void playBgm() async {
    if (disableAudio) return;
    if (stows.bgmVolume.value < 0.01) return;
    if (_bgmHandle == null) await init();

    log.info('Fading in bg music');
    _soLoud
      ..fadeVolume(_bgmHandle!, stows.bgmVolume.value, _bgmFadeDuration)
      ..setPause(_bgmHandle!, false);
  }

  void pauseBgm() {
    if (disableAudio) return;
    if (stows.bgmVolume.value < 0.01) return;
    if (_bgmHandle == null) return;

    log.info('Fading out bg music');
    _soLoud
      ..fadeVolume(_bgmHandle!, 0, _bgmFadeDuration)
      ..schedulePause(_bgmHandle!, _bgmFadeDuration);
  }
}

class _AudioPool {
  _AudioPool(this.source, {required this.targetPoolSize})
    : audioLength = _soLoud.getLength(source);

  final AudioSource source;
  final Duration audioLength;
  final int targetPoolSize;

  /// A pool of handles ready to play.
  final _pool = Queue<SoundHandle>();

  Future<void> init() async {
    for (var i = 0; i < targetPoolSize; ++i) {
      _pool.add(await _prepareHandle(source));
    }
  }

  void play() async {
    final SoundHandle handle;
    if (_pool.isNotEmpty) {
      handle = _pool.removeFirst();
    } else {
      // All handles are in use, cannot play sound.
      return;
    }

    _soLoud
      ..seek(handle, Duration.zero)
      ..setVolume(handle, stows.sfxVolume.value)
      ..setPause(handle, false)
      ..schedulePause(handle, audioLength);

    Future.delayed(audioLength, () {
      _pool.add(handle);
    });
  }

  void dispose() {
    for (final handle in _pool) {
      _soLoud.stop(handle);
    }
    _pool.clear();
  }

  late final _loopingStartAt = audioLength * 0.9;
  Future<SoundHandle> _prepareHandle(AudioSource source) => _soLoud.play(
    source,
    volume: stows.sfxVolume.value,
    paused: true,
    // Set looping to true to stop the handle being freed automatically.
    looping: true,
    loopingStartAt: _loopingStartAt,
  );
}
