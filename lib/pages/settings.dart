import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settingsPage.title),
      ),
      body: ListView(
        children: [
          // ad consent
          if (AdState.adsSupported) ...[
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const BirthYearDialog(),
                );
              },
              title: Text(t.birthYear.yourBirthYear),
              trailing: ValueListenableBuilder(
                valueListenable: Prefs.birthYear,
                builder: (context, birthYear, child) {
                  return Text(
                    switch (birthYear) {
                      null => t.birthYear.unknown,
                      _ => '$birthYear',
                    },
                  );
                },
              ),
            ),

            ValueListenableBuilder(
              valueListenable: Prefs.birthYear,
              builder: (context, birthYear, child) {
                final age = AdState.age;
                final collapsed = age == null || age < AdState.minAgeForPersonalizedAds;
                return Collapsible(
                  collapsed: collapsed,
                  axis: CollapsibleAxis.vertical,
                  child: child!,
                );
              },
              child: ListTile(
                onTap: () {
                  AdState.showConsentForm();
                  },
                title: Text(t.settingsPage.adConsent),
              ),
            ),
          ],

          // Hyperlegible font
          ValueListenableBuilder(
            valueListenable: Prefs.hyperlegibleFont,
            builder: (context, _, child) {
              return CheckboxListTile.adaptive(
                title: child,
                value: Prefs.hyperlegibleFont.value,
                onChanged: (value) {
                  assert(value != null, 'value should not be null since tristate is false');
                  Prefs.hyperlegibleFont.value = value!;
                },
              );
            },
            child: Text(t.settingsPage.hyperlegibleFont),
          ),

          // App info dialog
          ListTile(
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
                applicationLegalese: t.settingsPage.licenseNotice(buildYear: buildYear),
              );
            },
            title: Text(t.settingsPage.appInfo),
          ),
        ],
      ),
    );
  }
}
