import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/coin.dart';

class AdWarning extends StatelessWidget {
  const AdWarning({
    super.key,
    required this.secondsLeft,
    required this.cancelAd,
  });

  final ValueNotifier<int> secondsLeft;
  final VoidCallback cancelAd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: secondsLeft,
            builder: (context, secondsLeft, _) {
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final textTheme = theme.textTheme;
              return RichText(
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                  ),
                  children: [
                    t.adWarning.getCoins(
                      c: const WidgetSpan(child: CoinIcon(size: 24)),
                      t: TextSpan(text: secondsLeft.toString()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        NesButton(
          type: NesButtonType.error,
          onPressed: cancelAd,
          child: Text(t.common.cancel),
        ),
      ],
    );
  }
}
