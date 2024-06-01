import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/ads.dart';
import 'package:ricochlime/ads/age_dialog.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/version.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const listTilePadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    );
    const listTileContentPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    );
    const listTileShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    final listTileColor = Color.lerp(
      colorScheme.surface,
      colorScheme.primary,
      0.1,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settingsPage.title),
        toolbarHeight: kToolbarHeight,
        leading: Center(
          child: NesIconButton(
            onPress: () => Navigator.of(context).pop(),
            size: const Size.square(kToolbarHeight * 0.4),
            icon: NesIcons.leftArrowIndicator,
          ),
        ),
      ),
      body: ListView(
        children: [
          // ad consent
          if (AdState.adsSupported) ...[
            Padding(
              padding: listTilePadding,
              child: NesContainer(
                padding: EdgeInsets.zero,
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AgeDialog(),
                    );
                  },
                  tileColor: listTileColor,
                  shape: listTileShape,
                  contentPadding: listTileContentPadding,
                  title: Text(t.ageDialog.yourAge),
                  leading: NesIcon(
                    iconData: NesIcons.user,
                  ),
                  trailing: ValueListenableBuilder(
                    valueListenable: Prefs.birthYear,
                    builder: (context, birthYear, child) {
                      return Text(
                        switch (birthYear) {
                          null => t.ageDialog.unknown,
                          _ => '$birthYear',
                        },
                        style: TextStyle(
                          fontSize: switch (birthYear) {
                            null => null,
                            _ => 20,
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: Prefs.birthYear,
              builder: (context, birthYear, child) {
                final age = AdState.age;
                final collapsed =
                    age == null || age < AdState.minAgeForPersonalizedAds;
                return Collapsible(
                  collapsed: collapsed,
                  axis: CollapsibleAxis.vertical,
                  child: child!,
                );
              },
              child: Padding(
                padding: listTilePadding,
                child: NesContainer(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () {
                      AdState.showConsentForm();
                    },
                    tileColor: listTileColor,
                    shape: listTileShape,
                    contentPadding: listTileContentPadding,
                    title: Text(t.settingsPage.adConsent),
                    leading: NesIcon(
                      iconData: NesIcons.tv,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Hyperlegible font
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: Prefs.hyperlegibleFont,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(
                        iconData: NesIcons.openEye,
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: Prefs.hyperlegibleFont.value,
                        onChange: (value) {
                          Prefs.hyperlegibleFont.value = value;
                        },
                      ),
                      onTap: () => Prefs.hyperlegibleFont.value =
                          !Prefs.hyperlegibleFont.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.hyperlegibleFont),
              ),
            ),
          ),

          // Background music volume
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ListTile(
                tileColor: listTileColor,
                shape: listTileShape,
                contentPadding: listTileContentPadding,
                title: Text(t.settingsPage.bgmVolume),
                leading: NesIcon(
                  iconData: NesIcons.musicNote,
                ),
                trailing: SizedBox(
                  width: 200,
                  child: ListenableBuilder(
                    listenable: Prefs.bgmVolume,
                    builder: (context, _) {
                      return Slider.adaptive(
                        value: Prefs.bgmVolume.value,
                        onChanged: (value) {
                          Prefs.bgmVolume.value = value;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Whether to show the undo button
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: Prefs.showUndoButton,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(
                        iconData: NesIcons.delete,
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: Prefs.showUndoButton.value,
                        onChange: (value) => Prefs.showUndoButton.value = value,
                      ),
                      onTap: () => Prefs.showUndoButton.value =
                          !Prefs.showUndoButton.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.showUndoButton),
              ),
            ),
          ),

          // Speed up page transitions
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: Prefs.fasterPageTransitions,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(
                        iconData: NesIcons.energy,
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: Prefs.fasterPageTransitions.value,
                        onChange: (value) {
                          Prefs.fasterPageTransitions.value = value;
                        },
                      ),
                      onTap: () => Prefs.fasterPageTransitions.value =
                          !Prefs.fasterPageTransitions.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.fasterPageTransitions),
              ),
            ),
          ),

          // Max FPS
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ListTile(
                tileColor: listTileColor,
                shape: listTileShape,
                contentPadding: listTileContentPadding,
                title: Text(t.settingsPage.maxFps),
                leading: NesIcon(
                  iconData: NesIcons.camera,
                ),
                trailing: ValueListenableBuilder(
                  valueListenable: Prefs.maxFps,
                  builder: (context, maxFps, _) {
                    if (maxFps == -1) {
                      return NesIcon(iconData: NesIcons.infinite);
                    } else {
                      return Text(
                        maxFps.toString(),
                        style: const TextStyle(fontSize: 20),
                      );
                    }
                  },
                ),
                onTap: () {
                  Prefs.maxFps.value = switch (Prefs.maxFps.value) {
                    -1 => 60,
                    60 => 30,
                    30 => -1,
                    _ => 60,
                  };
                },
              ),
            ),
          ),

          // App info dialog
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ListTile(
                onTap: () {
                  final screenWidth = MediaQuery.sizeOf(context).width;
                  final iconSize = min<double>(64, screenWidth * 0.15);
                  showAboutDialog(
                    context: context,
                    applicationName: t.appName,
                    applicationVersion: 'v$buildName ($buildNumber)',
                    applicationIcon: Image.asset(
                      'assets/icon/icon.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                    applicationLegalese: t.settingsPage.licenseNotice(
                      buildYear: buildYear,
                    ),
                  );
                },
                tileColor: listTileColor,
                shape: listTileShape,
                contentPadding: listTileContentPadding,
                title: Text(t.settingsPage.appInfo),
                leading: NesIcon(
                  iconData: NesIcons.zoomIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
