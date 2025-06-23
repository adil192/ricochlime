import 'package:stow_codecs/stow_codecs.dart';

enum IAPState {
  /// The item has not been purchased yet.
  unpurchased,

  /// The item has been purchased and is enabled.
  purchasedAndEnabled,

  /// The item has been purchased but is disabled.
  purchasedAndDisabled,
  ;

  static final codec = EnumCodec(values);
}
