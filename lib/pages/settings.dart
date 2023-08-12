import 'package:flutter/material.dart';
import 'package:ricochlime/ads/banner_ad_widget.dart';
import 'package:ricochlime/i18n/strings.g.dart';

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
          if (AdState.adsSupported)
            ListTile(
              onTap: () {
                AdState.showConsentForm();
              },
              title: Text(t.settingsPage.adConsent),
            ),
        ],
      ),
    );
  }
}
