import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/flame/ricochlime_game.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/bouncing_icon.dart';
import 'package:ricochlime/pages/play.dart';
import 'package:ricochlime/pages/settings.dart';
import 'package:ricochlime/pages/shop.dart';
import 'package:ricochlime/pages/tutorial.dart';
import 'package:ricochlime/utils/brightness_extension.dart';
import 'package:ricochlime/utils/shop_items.dart';
import 'package:ricochlime/utils/stows.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// The last known value of the bgm volume,
  /// excluding when the volume is 0.
  static double lastKnownOnVolume = 0.7;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: colorScheme.brightness,
        statusBarIconBrightness: colorScheme.brightness.opposite,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: colorScheme.brightness.opposite,
      ),
      child: Scaffold(
        body: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    t.appName,
                    style: const TextStyle(fontSize: kToolbarHeight),
                  ),
                  Row(
                    children: [
                      ListenableBuilder(
                        listenable: stows.bgmVolume,
                        builder: (context, child) {
                          if (stows.bgmVolume.value > 0.05) {
                            lastKnownOnVolume = stows.bgmVolume.value;
                          }
                          return NesTooltip(
                            message:
                                '${t.settingsPage.bgmVolume}: '
                                '${stows.bgmVolume.value * 100 ~/ 1}%',
                            child: Opacity(
                              opacity: stows.bgmVolume.value <= 0.05 ? 0.25 : 1,
                              child: child!,
                            ),
                          );
                        },
                        child: NesIconButton(
                          onPress: () {
                            stows.bgmVolume.value =
                                stows.bgmVolume.value <= 0.05
                                ? lastKnownOnVolume
                                : 0;
                          },
                          size: const Size.square(32),
                          icon: NesIcons.musicNote,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    type: .primary,
                    icon: NesIcons.play,
                    text: t.homePage.playButton,
                    openBuilder: (_) => const PlayPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.market,
                    shouldAnimateIcon: () => ShopItems.allItems.any(
                      (item) =>
                          item.state.value == ShopItemState.unpurchased &&
                          item.price <= stows.coins.value,
                    ),
                    text: t.homePage.shopButton,
                    openBuilder: (_) => const ShopPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.questionMarkBlock,
                    text: t.homePage.tutorialButton,
                    openBuilder: (_) => const TutorialPage(),
                  ),
                  const SizedBox(height: 32),
                  _HomePageButton(
                    icon: NesIcons.gamepad,
                    text: t.homePage.settingsButton,
                    openBuilder: (_) => const SettingsPage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePageButton<T> extends StatefulWidget {
  const _HomePageButton({
    super.key,
    this.type = .normal,
    required this.icon,
    this.shouldAnimateIcon,
    required this.text,
    required this.openBuilder,
  });

  final NesButtonType type;
  final NesIconData icon;
  final bool Function()? shouldAnimateIcon;
  final String text;
  final WidgetBuilder openBuilder;

  @override
  State<_HomePageButton<T>> createState() => _HomePageButtonState<T>();
}

class _HomePageButtonState<T> extends State<_HomePageButton<T>> {
  void onPressed() {
    final route =
        (!stows.stylizedPageTransitions.value ||
            MediaQuery.disableAnimationsOf(context))
        ? MaterialPageRoute<void>(builder: widget.openBuilder)
        : NesVerticalCloseTransition.route<void>(
            pageBuilder: (context, _, _) => widget.openBuilder(context),
            duration: const Duration(milliseconds: 500),
          );
    Navigator.of(context).push(route).then((_) {
      // Recalculate the shouldAnimateIcon value
      if (widget.shouldAnimateIcon == null) return;
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NesButton(
        onPressed: onPressed,
        type: widget.type,
        child: Row(
          children: [
            if (!RicochlimeGame.reproducibleGoldenMode &&
                (widget.shouldAnimateIcon?.call() ?? false))
              BouncingIcon(icon: NesIcon(iconData: widget.icon))
            else
              NesIcon(iconData: widget.icon),
            const SizedBox(width: 16),
            Text(widget.text, style: const TextStyle(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}
