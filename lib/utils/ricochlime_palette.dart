import 'package:flame/palette.dart';

abstract class RicochlimePalette {
  static const grassColor = Color(0xff3abe41);
  // TODO(adil192): find [grassColorDark] with the new assets
  static const grassColorDark = Color(0xff1d5e20);
  static const waterColor = Color(0xff1e7cb8);
  static const monsterColor = Color(0xff79584f);

  static const healthBarBackgroundColor = Color(0xff000000);
  static const healthBarForegroundColor = monsterColor;
}
