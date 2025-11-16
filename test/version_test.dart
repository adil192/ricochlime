import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ricochlime/utils/version.dart';

const String dummyChangelog = 'Release_notes_will_be_added_here';

void main() {
  test('Does apply_version.dart find changes needed?', () async {
    final result = await Process.run('./scripts/apply_version.dart', [
      '--custom',
      buildNumber.toString(),
      '--fail-on-changes',
      '--quiet',
    ]);
    printOnFailure(result.stdout);
    printOnFailure(result.stderr);

    final exitCode = result.exitCode;
    if (exitCode != 0 && exitCode != 10) {
      throw Exception('Unexpected exit code: $exitCode');
    }
    expect(
      exitCode,
      isNot(equals(10)),
      reason:
          'Changes needed to be made. '
          'Please re-run `./scripts/apply_version.dart`',
    );
  });

  test('Check for dummy text in changelogs', () async {
    final File androidMetadata = File(
      'metadata/en-US/changelogs/$buildNumber.txt',
    );
    expect(androidMetadata.existsSync(), true);
    final String androidMetadataContents = await androidMetadata.readAsString();
    expect(
      androidMetadataContents.contains(dummyChangelog),
      false,
      reason: 'Dummy text found in Android changelog',
    );

    final File flatpakMetadata = File(
      'flatpak/com.adilhanney.ricochlime.metainfo.xml',
    );
    expect(flatpakMetadata.existsSync(), true);
    final String flatpakMetadataContents = await flatpakMetadata.readAsString();
    expect(
      flatpakMetadataContents.contains(dummyChangelog),
      false,
      reason: 'Dummy text found in Flatpak changelog',
    );
  });
}
