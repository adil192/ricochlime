import 'package:flutter/material.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/utils/prefs.dart';

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
          if (AdState.adsSupported)
            ListTile(
              onTap: () {
                AdState.showConsentForm();
              },
              title: Text(t.settingsPage.adConsent),
            ),

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
        ],
      ),
    );
  }
}
