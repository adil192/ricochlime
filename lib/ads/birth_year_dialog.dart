import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return AlertDialog(
      title: Text(t.birthYear.yourBirthYear),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Text(t.birthYear.reason),
            Expanded(
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
          ],
        ),
      ),
      actions: [
        if (widget.dismissible) TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(t.common.cancel),
        ),
        TextButton(
          onPressed: () {
            Prefs.birthYear.value = selectedDate.year;
            context.pop();
          },
          child: Text(t.common.ok),
        ),
      ],
    );
  }
}
