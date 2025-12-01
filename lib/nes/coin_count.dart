import 'package:flutter/material.dart';
import 'package:ricochlime/nes/coin_icon.dart';
import 'package:ricochlime/utils/stows.dart';

class CoinCount extends StatelessWidget {
  const CoinCount({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          ValueListenableBuilder(
            valueListenable: stows.coins,
            builder: (context, coins, _) {
              return Text(
                coins.toString(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 32,
                  height: 0.6,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          const CoinIcon(size: 24),
        ],
      ),
    );
  }
}
