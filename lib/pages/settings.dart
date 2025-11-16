import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/ricochlime_icons.dart';
import 'package:ricochlime/utils/stows.dart';
import 'package:ricochlime/utils/version.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const listTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    const subtitlePadding = EdgeInsets.only(
      left: 16,
      right: 16,
      top: 16,
      bottom: 4,
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
          Padding(
            padding: subtitlePadding,
            child: Text(
              t.settingsPage.gameplay,
              style: const TextStyle(fontSize: 20),
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
                leading: NesIcon(iconData: NesIcons.musicNote),
                trailing: SizedBox(
                  width: 200,
                  child: ListenableBuilder(
                    listenable: stows.bgmVolume,
                    builder: (context, _) {
                      return Slider.adaptive(
                        value: stows.bgmVolume.value,
                        onChanged: (value) {
                          stows.bgmVolume.value = value;
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
                valueListenable: stows.showUndoButton,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(iconData: NesIcons.delete),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.showUndoButton.value,
                        onChange: (value) => stows.showUndoButton.value = value,
                      ),
                      onTap: () => stows.showUndoButton.value =
                          !stows.showUndoButton.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.showUndoButton),
              ),
            ),
          ),

          // Whether to show reflection in the aim guide
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: stows.showReflectionInAimGuide,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(
                        iconData: stows.showReflectionInAimGuide.value
                            ? RicochlimeIcons.aimGuideWithReflection
                            : RicochlimeIcons.aimGuideWithoutReflection,
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.showReflectionInAimGuide.value,
                        onChange: (value) =>
                            stows.showReflectionInAimGuide.value = value,
                      ),
                      onTap: () => stows.showReflectionInAimGuide.value =
                          !stows.showReflectionInAimGuide.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.showReflectionInAimGuide),
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
                leading: NesIcon(iconData: NesIcons.camera),
                trailing: ValueListenableBuilder(
                  valueListenable: stows.maxFps,
                  builder: (context, maxFps, _) {
                    if (maxFps == -1) {
                      return NesIcon(iconData: NesIcons.infinite);
                    } else {
                      return Text(
                        maxFps.toString(),
                        style: const TextStyle(fontSize: 24),
                      );
                    }
                  },
                ),
                onTap: () {
                  stows.maxFps.value = switch (stows.maxFps.value) {
                    -1 => 60,
                    60 => 30,
                    30 => -1,
                    _ => 60,
                  };
                },
              ),
            ),
          ),

          // Show FPS counter
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: stows.showFpsCounter,
                builder: (context, _, child) {
                  final fps = stows.maxFps.value < 0 ? 60 : stows.maxFps.value;
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: BlockSemantics(
                        child: Text(
                          fps.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.showFpsCounter.value,
                        onChange: (value) {
                          stows.showFpsCounter.value = value;
                        },
                      ),
                      onTap: () => stows.showFpsCounter.value =
                          !stows.showFpsCounter.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.showFpsCounter),
              ),
            ),
          ),

          Padding(
            padding: subtitlePadding,
            child: Text(
              t.settingsPage.accessibility,
              style: const TextStyle(fontSize: 20),
            ),
          ),

          // Hyperlegible font
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: stows.hyperlegibleFont,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(iconData: NesIcons.openEye),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.hyperlegibleFont.value,
                        onChange: (value) {
                          stows.hyperlegibleFont.value = value;
                        },
                      ),
                      onTap: () => stows.hyperlegibleFont.value =
                          !stows.hyperlegibleFont.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.hyperlegibleFont),
              ),
            ),
          ),

          // Stylized page transitions
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: stows.stylizedPageTransitions,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(iconData: NesIcons.energy),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.stylizedPageTransitions.value,
                        onChange: (value) {
                          stows.stylizedPageTransitions.value = value;
                        },
                      ),
                      onTap: () => stows.stylizedPageTransitions.value =
                          !stows.stylizedPageTransitions.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.stylizedPageTransitions),
              ),
            ),
          ),

          // Bigger bullets
          Padding(
            padding: listTilePadding,
            child: NesContainer(
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: stows.biggerBullets,
                builder: (context, _, child) {
                  return MergeSemantics(
                    child: ListTile(
                      title: child,
                      leading: NesIcon(iconData: NesIcons.zoomIn),
                      tileColor: listTileColor,
                      shape: listTileShape,
                      contentPadding: listTileContentPadding,
                      trailing: NesCheckBox(
                        value: stows.biggerBullets.value,
                        onChange: (value) {
                          stows.biggerBullets.value = value;
                        },
                      ),
                      onTap: () => stows.biggerBullets.value =
                          !stows.biggerBullets.value,
                    ),
                  );
                },
                child: Text(t.settingsPage.biggerBullets),
              ),
            ),
          ),

          Padding(
            padding: subtitlePadding,
            child: Text(
              t.settingsPage.appInfo,
              style: const TextStyle(fontSize: 20),
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
                leading: NesIcon(iconData: NesIcons.zoomIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
