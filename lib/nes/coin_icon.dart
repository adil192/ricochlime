import 'package:flutter/material.dart';
import 'package:ricochlime/i18n/strings.g.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/coin.png',
      filterQuality: FilterQuality.none,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: t.playPage.coins,
    );
  }
}
