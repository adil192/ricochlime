import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';
import 'package:ricochlime/utils/stows.dart';

final class RicochlimeAudio {
  RicochlimeAudio() {
    init();
  }

  static final _soLoud = SoLoud.instance;
  static final _soLoudInitFuture = _soLoud.init(channels: .mono);
  static FutureOr<AudioSource> _bgmAudioSource = _soLoud.loadAsset(
    'assets/audio/bgm/Ludum_Dare_32_Track_4.ogg',
  );

  /// Disable audio for testing purposes.
  @visibleForTesting
  static bool disableAudio = false;
  static const _bgmFadeDuration = Duration(seconds: 1);

  static Future<void> load() async {
    if (disableAudio) return;
    await _soLoudInitFuture;
    _bgmAudioSource = await _bgmAudioSource;
  }

  final log = Logger('RicochlimeAudio');

  SoundHandle? _bgmHandle;
  Future<void> init() async {
    if (disableAudio) return;
    await _soLoudInitFuture;

    _bgmHandle ??= await _soLoud.play(
      await _bgmAudioSource,
      volume: stows.bgmVolume.value,
      paused: stows.bgmVolume.value < 0.01,
      looping: true,
    );
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
