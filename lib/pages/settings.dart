import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/age_dialog.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
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
                            _ => 18,
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

          // Whether to show colliders
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: Prefs.showColliders,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(
                        iconData: NesIcons.lamp,
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: Prefs.showColliders.value,
                        onChange: (value) {
                          Prefs.showColliders.value = value;
                        },
                      ),
                      onTap: () => Prefs.showColliders.value =
                          !Prefs.showColliders.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.showColliders),
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
                  final screenWidth = MediaQuery.of(context).size.width;
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
