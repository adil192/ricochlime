import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/prefs.dart';

class BirthYearDialog extends StatefulWidget {
  const BirthYearDialog({
    super.key,
    this.dismissible = true,
  });

  final bool dismissible;

  @override
  State<BirthYearDialog> createState() => _BirthYearDialogState();
}

class _BirthYearDialogState extends State<BirthYearDialog> {
  DateTime selectedDate = DateTime(
    Prefs.birthYear.value ?? DateTime.now().year,
  );

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
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
                t.birthYear.yourBirthYear,
                style: const TextStyle(
                  fontSize: kToolbarHeight / 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(t.birthYear.reason),
              SizedBox(
                height: 300,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return YearPicker(
                      firstDate: DateTime(1900),
                      lastDate: DateTime(currentYear),
                      initialDate: DateTime(currentYear),
                      selectedDate: selectedDate,
                      onChanged: (value) {
                        setState(() => selectedDate = value);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  if (widget.dismissible) NesButton(
                    onPressed: () {
                      context.pop();
                    },
                    type: NesButtonType.warning,
                    child: Text(t.common.cancel),
                  ),
                  const SizedBox(width: 16),
                  NesButton(
                    onPressed: () {
                      Prefs.birthYear.value = selectedDate.year;
                      context.pop();
                    },
                    type: NesButtonType.primary,
                    child: Text(t.common.ok),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
