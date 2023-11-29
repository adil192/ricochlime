part of 'age_dialog.dart';

/// This is a simple input field
/// to comply with Google Play's policy
/// on having a neutral age screen.
class _AgeSimpleInput extends StatefulWidget {
  // ignore: public_member_api_docs
  const _AgeSimpleInput({
    // ignore: unused_element
    super.key,
  });

  @override
  State<_AgeSimpleInput> createState() => _AgeSimpleInputState();
}

class _AgeSimpleInputState extends State<_AgeSimpleInput> {
  final _inputKey = GlobalKey<FormFieldState>();
  final _inputController = TextEditingController();

  String? _validateAge(String? input) {
    if (input == null || input.isEmpty) {
      return t.ageDialog.invalidAge;
    }
    final age = int.tryParse(input);
    if (age == null) {
      return t.ageDialog.invalidAge;
    }
    if (age < _AgeMinigameState.minLowerBound ||
        age > _AgeMinigameState.maxUpperBound) {
      return t.ageDialog.invalidAge;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.ageDialog.howOldAreYou,
          style: const TextStyle(
            fontSize: kToolbarHeight / 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(t.ageDialog.reason),
        const SizedBox(height: 24),

        // Age input
        TextFormField(
          key: _inputKey,
          controller: _inputController,
          validator: _validateAge,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: t.ageDialog.yourAge,
          ),
        ),
        const SizedBox(height: 8),

        // Submit button
        AnimatedBuilder(
          animation: _inputController,
          builder: (context, child) {
            final age = int.tryParse(_inputController.text);
            final valid = _validateAge(_inputController.text) == null;
            return NesButton(
              type: valid ? NesButtonType.primary : NesButtonType.normal,
              onPressed: valid
                  ? () {
                      if (_inputKey.currentState?.validate() == false) return;
                      final currentYear = DateTime.now().year;
                      final birthYear = currentYear - age!;
                      Prefs.birthYear.value = birthYear;
                      context.pop();
                    }
                  : null,
              child: Row(
                children: [
                  NesIcon(
                    iconData: NesIcons.check,
                  ),
                  const SizedBox(width: 16),
                  Text(t.ageDialog.yesMyAgeIs(age: age ?? '?')),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
