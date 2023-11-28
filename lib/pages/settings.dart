import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/ads/birth_year_dialog.dart';
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
                      builder: (context) => const BirthYearDialog(),
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
                  return CheckboxListTile.adaptive(
                    title: child,
                    secondary: NesIcon(
                      iconData: NesIcons.openEye,
                    ),
                    tileColor: listTileColor,
                    shape: listTileShape,
                    contentPadding: listTileContentPadding,
                    value: Prefs.hyperlegibleFont.value,
                    onChanged: (value) {
                      Prefs.hyperlegibleFont.value = value!;
                    },
                  );
                },
                child: Text(t.settingsPage.hyperlegibleFont),
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
