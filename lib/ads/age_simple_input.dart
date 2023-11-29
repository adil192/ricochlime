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
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
