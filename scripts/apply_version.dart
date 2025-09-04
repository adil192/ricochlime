#!/usr/bin/env dart
// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:args/args.dart';
import 'package:intl/intl.dart';
import 'package:ricochlime/utils/version.dart' as old_version_file;

final oldVersion = _AppVersion.fromName(old_version_file.buildName);
late final _AppVersion newVersion;
late final String editor;
late final bool failOnChanges;
late final bool quiet;

const String dummyChangelog = 'Release_notes_will_be_added_here';

enum ErrorCodes {
  noError(0),
  noVersionSpecified(1),
  noEditorFound(5),
  changesNeeded(10);

  const ErrorCodes(this.code);

  final int code;
}

Future<void> main(List<String> args) async {
  parseArgs(args);
  await findEditor();
  await updateAllFiles();
}

void parseArgs(List<String> args) {
  final parser = ArgParser()
    ..addFlag('major', abbr: 'M', negatable: false, help: 'Bump major version')
    ..addFlag('minor', abbr: 'm', negatable: false, help: 'Bump minor version')
    ..addFlag('patch', abbr: 'p', negatable: false, help: 'Bump patch version')
    ..addOption(
      'custom',
      abbr: 'c',
      help: 'Use a custom buildName (e.g. 1.2.3) or buildNumber (e.g. 102030)',
    )
    ..addFlag(
      'fail-on-changes',
      abbr: 'f',
      negatable: false,
      help: 'Fail if any changes need to be made',
    )
    ..addFlag('quiet', abbr: 'q', negatable: false, help: 'Don\'t open editor')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final results = parser.parse(args);

  failOnChanges = results.flag('fail-on-changes');
  quiet = results.flag('quiet');

  if (results.flag('help')) {
    print(parser.usage);
    exit(ErrorCodes.noError.code);
  } else if (results.flag('major')) {
    newVersion = oldVersion.bumpMajor();
  } else if (results.flag('minor')) {
    newVersion = oldVersion.bumpMinor();
  } else if (results.flag('patch')) {
    newVersion = oldVersion.bumpPatch();
  } else if (results.option('custom') != null) {
    final String custom = results['custom']!;
    late final buildNumber = int.tryParse(custom);
    if (custom.contains('.')) {
      newVersion = _AppVersion.fromName(custom);
    } else if (buildNumber != null) {
      newVersion = _AppVersion.fromNumber(buildNumber);
    } else {
      print('Invalid custom version: $custom');
      print(parser.usage);
      exit(ErrorCodes.noVersionSpecified.code);
    }
  } else {
    print('No version specified');
    print(parser.usage);
    exit(ErrorCodes.noVersionSpecified.code);
  }

  print('Bumping version from ${oldVersion.buildName} '
      'to ${newVersion.buildName}');
}

Future<void> findEditor() async {
  if (quiet) {
    editor = 'echo';
    print('Will not open editor');
    return;
  }

  final whichCode = await Process.run('which', ['code']);
  if (whichCode.exitCode == 0) {
    editor = 'code';
    print('Using Visual Studio Code as editor');
    return;
  }

  final env = Platform.environment['EDITOR'];
  if (env != null) {
    editor = env;
    print('Using $editor as editor');
    return;
  }

  print('No editor found. Please set the EDITOR environment variable');
  exit(ErrorCodes.noEditorFound.code);
}

Future<void> updateAllFiles() async {
  // update windows installer
  await File('installers/desktop_inno_script.iss').replace({
    // e.g. #define MyAppVersion "0.5.5"
    RegExp(r'#define MyAppVersion .+'):
        '#define MyAppVersion "${newVersion.buildName}"',
  });

  // update windows runner
  await File('windows/runner/Runner.rc').replace({
    // e.g. #define VERSION_AS_NUMBER 0,5,5,0
    RegExp(r'#define VERSION_AS_NUMBER .+'): '#define VERSION_AS_NUMBER '
        '${newVersion.buildNameWithCommas},${newVersion.revision}',
    // e.g. #define VERSION_AS_STRING "0.5.5.0"
    RegExp(r'#define VERSION_AS_STRING .+'): '#define VERSION_AS_STRING '
        '"${newVersion.buildName}.${newVersion.revision}"',
  });

  // update version file
  await File('lib/utils/version.dart').replace({
    // e.g. const int buildNumber = 5050;
    RegExp(r'buildNumber = .+;'): 'buildNumber = ${newVersion.buildNumber};',
    // e.g. const String buildName = '0.5.5';
    RegExp(r'buildName = .+;'): "buildName = '${newVersion.buildName}';",
    // e.g. const int buildYear = 2023;
    RegExp(r'buildYear = .+;'): 'buildYear = ${DateTime.now().year};',
  });

  // update pubspec
  await File('pubspec.yaml').replace({
    // e.g. version: 5.5.0+5050
    RegExp(r'version: .+'):
        'version: ${newVersion.buildName}+${newVersion.buildNumber}',
  });

  // update download link in README
  await File('README.md').replace({
    // e.g. [download_windows]: https://github.com/adil192/ricochlime/releases/download/v0.11.0/RicochlimeInstaller_v0.11.0.exe
    RegExp(r'\[download_windows\]: .+'):
        '[download_windows]: https://github.com/adil192/ricochlime/releases/download/v${newVersion.buildName}/RicochlimeInstaller_v${newVersion.buildName}.exe',
    // e.g. [download_appimage]: https://github.com/adil192/ricochlime/releases/download/v0.11.0/Ricochlime-0.11.0-x86_64.AppImage
    RegExp(r'\[download_appimage\]: .+'):
        '[download_appimage]: https://github.com/adil192/ricochlime/releases/download/v${newVersion.buildName}/Ricochlime-${newVersion.buildName}-x86_64.AppImage',
  });

  // create metadata changelog
  final changelogFile =
      File('metadata/en-US/changelogs/${newVersion.buildNumber}.txt');
  if (changelogFile.existsSync()) {
    print('Changelog file already exists');
  } else {
    if (failOnChanges) {
      print('Failed: No changelog file found at ${changelogFile.path}');
      exit(ErrorCodes.changesNeeded.code);
    }
    print('Creating a blank changelog file');
    await changelogFile.writeAsString('• $dummyChangelog\n');
  }

  // update flatpak changelog
  final flatpakFile = File('flatpak/com.adilhanney.ricochlime.metainfo.xml');
  if (await flatpakFile.contains(RegExp(RegExp.escape(newVersion.buildName)))) {
    print('<release> tag already exists in flatpak file');
  } else {
    if (failOnChanges) {
      print('Failed: No release tag found at ${flatpakFile.path}');
      exit(ErrorCodes.changesNeeded.code);
    }
    print('Adding a new <release> tag to flatpak file');
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
    final releaseTag = '''
        <release version="${newVersion.buildName}" date="$date">
            <url type="details">https://github.com/adil192/ricochlime/releases/tag/v${newVersion.buildName}</url>
            <description>
                <ul>
                    <li>$dummyChangelog</li>
                </ul>
            </description>
        </release>''';
    final flatpakLines = await flatpakFile.readAsLines();
    final index =
        flatpakLines.indexWhere((line) => line.contains('<releases>')) + 1;
    flatpakLines.insert(index, releaseTag);
    if (flatpakLines.last.isNotEmpty) flatpakLines.add('');
    await flatpakFile.writeAsString(flatpakLines.join('\n'));
  }

  print('');
  print('Make sure to update the changelog files:');
  print('  - ${changelogFile.path}');
  print('  - ${flatpakFile.path}');
  print('And then run:');
  print('  - dart scripts/translate_changelogs.dart');
  print('Next steps:');
  print(
      ' - Publish to the App Store: https://appstoreconnect.apple.com/apps/6459539993/appstore');
  print(
      ' - Publish to the Amazon Appstore: https://developer.amazon.com/apps-and-games/console/app/list');

  // open changelog files in editor
  if (!quiet) {
    await Process.run(editor, [changelogFile.path]);
    await Process.run(editor, [flatpakFile.path]);
  }
}

class _AppVersion {
  _AppVersion(this.major, this.minor, this.patch, [this.revision = 0])
      : assert(major >= 0 && major < 100),
        assert(minor >= 0 && minor < 100),
        assert(patch >= 0 && patch < 100),
        assert(revision >= 0 && revision < 10);

  factory _AppVersion.fromName(String name) {
    final parts = name.split('.');
    assert(parts.length == 3);
    return _AppVersion(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  factory _AppVersion.fromNumber(int number) {
    // rightmost digit is the revision number
    final revision = number % 10;
    // next 2 digits are patch version
    final patch = (number ~/ 10) % 100;
    // next 2 digits are minor version
    final minor = (number ~/ 1000) % 100;
    // next 2 digits are major version
    final major = (number ~/ 100000) % 100;

    return _AppVersion(major, minor, patch, revision);
  }

  final int major, minor, patch, revision;

  String get buildName => '$major.$minor.$patch';
  String get buildNameWithCommas => '$major,$minor,$patch';
  int get buildNumber => revision + patch * 10 + minor * 1000 + major * 100000;
  int get buildNumberWithoutRevision => buildNumber - revision;

  _AppVersion bumpMajor() => _AppVersion(major + 1, 0, 0);
  _AppVersion bumpMinor() => _AppVersion(major, minor + 1, 0);
  _AppVersion bumpPatch() => _AppVersion(major, minor, patch + 1);

  _AppVersion copyWith({int? major, int? minor, int? patch, int? revision}) =>
      _AppVersion(major ?? this.major, minor ?? this.minor, patch ?? this.patch,
          revision ?? this.revision);

  @override
  String toString() => buildName;

  @override
  bool operator ==(Object other) =>
      other is _AppVersion &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch;

  @override
  int get hashCode => buildNumber;
}

extension on File {
  Future<bool> contains(RegExp pattern) async {
    final content = await readAsString();
    return pattern.hasMatch(content);
  }

  Future<void> replace(Map<RegExp, String> replacements) async {
    int matches = 0;
    final lines = await readAsLines();
    for (var i = 0; i < lines.length; i++) {
      for (final pattern in replacements.keys) {
        if (pattern.hasMatch(lines[i])) {
          matches++;
          final oldLine = lines[i];
          lines[i] = lines[i].replaceFirst(pattern, replacements[pattern]!);
          if (failOnChanges && lines[i] != oldLine) {
            print('Failed: Changes needed in $path');
            exit(ErrorCodes.changesNeeded.code);
          }
        }
      }
    }
    if (lines.last.isNotEmpty) lines.add('');
    await writeAsString(lines.join('\n'));

    if (matches >= replacements.length) {
      print('Updated $path with all $matches replacements');
    } else {
      print('Updated $path with $matches out of ${replacements.length} '
          'replacements (${replacements.length - matches} missed)');
    }
  }
}
