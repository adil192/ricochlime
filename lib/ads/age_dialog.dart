import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
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
  /// The minigame is iffy with Google Play policies,
  /// so on Android, we use a simple input field instead.
  ///
  /// The user can still choose to use the minigame.
  bool _useMinigame = kIsWeb || !Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: NesContainer(
        width: 300 + 32 * 2,
        padding: const EdgeInsets.all(32),
        backgroundColor: colorScheme.surface,
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _useMinigame ? const _AgeMinigame() : const _AgeSimpleInput(),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => setState(() => _useMinigame = !_useMinigame),
                child: Text(
                  _useMinigame
                      ? t.ageDialog.useSimpleInput
                      : t.ageDialog.useMinigame,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
