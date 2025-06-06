import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test that flutter submodule is up to date', () async {
    /// Get the commit hash of the flutter submodule,
    /// cropped to 10 characters.
    ///
    /// This doesn't require the flutter submodule to be cloned.
    ///
    /// e.g. b06b8b2710
    final submoduleCommit =
        await Process.run('git', ['rev-parse', '@:./submodules/flutter'])
            .then((value) => (value.stdout as String).substring(0, 10));
    expect(submoduleCommit.length, 10);

    /// The output of `flutter --version`.
    ///
    /// Contains a line like this:
    /// Framework • revision b06b8b2710 (3 days ago) • 2023-01-23 16:55:55 -0800
    final localFlutterVersion = await Process.run('flutter', ['--version'])
        .then((value) => value.stdout as String);
    expect(localFlutterVersion.length, greaterThan(10));

    expect(localFlutterVersion, contains(submoduleCommit),
        reason:
            'Flutter submodule does not match local version. Please run `./scripts/update_flutter_submodule.sh` to update the submodule.');
  });
}
