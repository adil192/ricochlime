// ignore_for_file: lines_longer_than_80_chars

import 'package:mini_sprite/mini_sprite.dart';
import 'package:nes_ui/nes_ui.dart';

abstract class RicochlimeIcons {
  /// An icon representing the aim guide with reflection enabled.
  static final aimGuideWithReflection = NesIconData(
    MiniSprite.fromDataString(
      '8,8;14,-1;1,0;5,-1;1,0;5,-1;1,0;5,-1;1,0;9,-1;1,0;9,-1;1,0;9,-1;1,0;1,-1',
    ),
  );

  /// An icon representing the aim guide with reflection disabled.
  static final aimGuideWithoutReflection = NesIconData(
    MiniSprite.fromDataString(
      '8,8;32,-1;1,1;9,-1;1,0;9,-1;1,0;9,-1;1,0;1,-1',
    ),
  );
}
