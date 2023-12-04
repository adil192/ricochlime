import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    // ignore: unused_element
    super.key,
    required this.onPressed,
    this.type = NesButtonType.normal,
    this.icon,
    required this.text,
  });

  final VoidCallback onPressed;
  final NesButtonType type;
  final NesIconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 28;
    return Center(
      child: NesButton(
        onPressed: onPressed,
        type: type,
        child: Row(
          children: [
            if (icon != null) NesIcon(iconData: icon!),
            const SizedBox(width: 12),
            Text(
              text,
              softWrap: false,
              style: const TextStyle(
                fontSize: buttonSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
