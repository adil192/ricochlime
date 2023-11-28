import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/prefs.dart';

/// A dialog which asks the user how old they are.
///
/// This is a small minigame in itself
/// since it uses a binary search guessing game.
class BirthYearDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const BirthYearDialog({
    super.key,
    this.dismissible = true,
  });

  /// Whether the dialog can be dismissed.
  ///
  /// This should be `false` if the user hasn't inputted
  /// their birth year before.
  final bool dismissible;

  @override
  State<BirthYearDialog> createState() => _BirthYearDialogState();
}

class _BirthYearDialogState extends State<BirthYearDialog> {
  static const int minLowerBound = 1;
  static const int maxUpperBound = 120;
  static const int initialAgeGuess = minLowerBound;
  int guessNumber = 1;
  int lowerBound = minLowerBound;
  int upperBound = maxUpperBound;
  int guessedAge = initialAgeGuess;

  bool get canGoOlder => lowerBound < upperBound && guessedAge < maxUpperBound;
  bool get canGoYounger =>
      upperBound > lowerBound && guessedAge > minLowerBound;

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
              Text(
                t.ageDialog.title,
                style: const TextStyle(
                  fontSize: kToolbarHeight / 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(t.ageDialog.reason),
              const SizedBox(height: 24),

              // Age guess
              Text(
                t.ageDialog.guessNumber(n: guessNumber),
                style: const TextStyle(
                  height: 1,
                ),
              ),
              Text(
                t.ageDialog.areYou(age: guessedAge),
                style: const TextStyle(
                  fontSize: kToolbarHeight / 2,
                ),
              ),
              const SizedBox(height: 8),
              _RangeBar(
                currentLowerBound: lowerBound,
                currentUpperBound: upperBound,
                minLowerBound: minLowerBound,
                maxUpperBound: maxUpperBound,
              ),
              const SizedBox(height: 16),

              NesButton(
                type: NesButtonType.warning,
                onPressed: canGoOlder
                    ? () {
                        setState(() {
                          guessNumber++;
                          lowerBound = guessedAge + 1;
                          guessedAge = (lowerBound + upperBound) ~/ 2;
                        });
                      }
                    : null,
                child: Row(
                  children: [
                    NesIcon(
                      iconData: NesIcons.topArrowIndicator,
                    ),
                    const SizedBox(width: 16),
                    Text(t.ageDialog.older),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              NesButton(
                type: NesButtonType.primary,
                onPressed: () {
                  final currentYear = DateTime.now().year;
                  final birthYear = currentYear - guessedAge;
                  Prefs.birthYear.value = birthYear;
                  context.pop();
                },
                child: Row(
                  children: [
                    NesIcon(
                      iconData: NesIcons.check,
                    ),
                    const SizedBox(width: 16),
                    Text(t.ageDialog.yesMyAgeIs(age: guessedAge))
                  ],
                ),
              ),
              const SizedBox(height: 8),
              NesButton(
                type: NesButtonType.warning,
                onPressed: canGoYounger
                    ? () {
                        setState(() {
                          guessNumber++;
                          upperBound = guessedAge - 1;
                          guessedAge = (lowerBound + upperBound) ~/ 2;
                        });
                      }
                    : null,
                child: Row(
                  children: [
                    NesIcon(
                      iconData: NesIcons.bottomArrowIndicator,
                    ),
                    const SizedBox(width: 16),
                    Text(t.ageDialog.younger),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              NesButton(
                type: NesButtonType.error,
                child: Row(
                  children: [
                    NesIcon(
                      iconData: NesIcons.redo,
                    ),
                    const SizedBox(width: 16),
                    Text(t.ageDialog.reset),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    guessNumber = 1;
                    lowerBound = minLowerBound;
                    upperBound = maxUpperBound;
                    guessedAge = initialAgeGuess;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  const _RangeBar({
    // ignore: unused_element
    super.key,
    required this.currentLowerBound,
    required this.currentUpperBound,
    required this.minLowerBound,
    required this.maxUpperBound,
  });

  final int currentLowerBound;
  final int currentUpperBound;
  final int minLowerBound;
  final int maxUpperBound;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const barHeight = 2.0;
    return LayoutBuilder(builder: (context, constraints) {
      return NesContainer(
        width: constraints.maxWidth,
        height: barHeight,
        backgroundColor: colorScheme.primary.withAlpha(100),
        padding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              left: (currentLowerBound / maxUpperBound) * constraints.maxWidth,
              width: math.max(
                1,
                ((currentUpperBound - currentLowerBound) / maxUpperBound) *
                    constraints.maxWidth,
              ),
              top: -1,
              bottom: -1,
              child: ColoredBox(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    });
  }
}
