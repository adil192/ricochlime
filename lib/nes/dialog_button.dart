import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    // ignore: unused_element
    super.key,
    required this.onPressed,
    this.type = .normal,
    this.icon,
    this.crossAxisAlignment = .center,
    required this.text,
  });

  final VoidCallback? onPressed;
  final NesButtonType type;
  final Widget? icon;
  final CrossAxisAlignment crossAxisAlignment;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 28;
    return Center(
      child: NesButton(
        onPressed: onPressed,
        type: type,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: buttonSize * 0.4),
            ],
            Text(
              text,
              softWrap: false,
              style: const TextStyle(fontSize: buttonSize),
            ),
          ],
        ),
      ),
    );
  }
}
