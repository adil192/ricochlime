import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/prefs.dart';

part 'age_minigame.dart';
part 'age_simple_input.dart';

/// A dialog which asks the user how old they are.
///
/// This can either take the form of an
/// age guessing minigame [_AgeMinigame]
/// or a simple text field [_AgeSimpleInput].
class AgeDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const AgeDialog({
    super.key,
    this.dismissible = true,
  });

  /// Whether the dialog can be dismissed.
  ///
  /// This should be `false` if the user hasn't inputted
  /// their birth year before.
  final bool dismissible;

  @override
  State<AgeDialog> createState() => _AgeDialogState();
}

class _AgeDialogState extends State<AgeDialog> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: NesContainer(
        width: 300 + 32 * 2,
        padding: const EdgeInsets.all(32),
        backgroundColor: colorScheme.surface,
        child: Material(
          child: _AgeMinigame(),
        ),
      ),
    );
  }
}
