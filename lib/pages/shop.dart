import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/coin.dart';
import 'package:ricochlime/utils/prefs.dart';
import 'package:ricochlime/utils/shop_items.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.shopPage.title),
        toolbarHeight: kToolbarHeight,
        leading: Center(
          child: NesIconButton(
            onPress: () => Navigator.of(context).pop(),
            size: const Size.square(kToolbarHeight * 0.4),
            icon: NesIcons.leftArrowIndicator,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: Prefs.coins,
            builder: (context, coins, _) {
              final colorScheme = Theme.of(context).colorScheme;
              return Text(
                coins >= 1000
                    ? '${(coins / 1000).toStringAsFixed(1)}K'
                    : coins.toString(),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 28,
                  height: 24 / 28,
                ),
              );
            },
          ),
          const CoinIcon(size: 24),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenSize.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Bullets', style: TextStyle(fontSize: 24)),
                  ),
                ),
                SliverGrid.builder(
                  itemCount: ShopItems.bullets.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= ShopItems.bullets.length) return null;

                    return _ShopItemTile(item: ShopItems.bullets[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopItemTile extends StatelessWidget {
  const _ShopItemTile({
    // ignore: unused_element
    super.key,
    required this.item,
  });

  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Prefs.selectedBullet,
        builder: (context, _, __) {
          // This needs to be extended for non-bullet items later.
          final selected = Prefs.selectedBullet.value == item.id;

          return ValueListenableBuilder(
            valueListenable: item.state,
            builder: (context, state, _) {
              return NesButton(
                onPressed: switch (state) {
                  ShopItemState.loading => null,
                  ShopItemState.purchased => () =>
                      Prefs.selectedBullet.value = item.id,
                  ShopItemState.unpurchased => item.purchase,
                },
                type: switch (state) {
                  ShopItemState.loading => NesButtonType.normal,
                  ShopItemState.purchased =>
                    selected ? NesButtonType.primary : NesButtonType.normal,
                  ShopItemState.unpurchased => NesButtonType.warning,
                },
                child: state == ShopItemState.purchased
                    ? Center(
                        child: SizedBox.square(
                          dimension: 20,
                          child: item.build(context),
                        ),
                      )
                    : const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CoinIcon(size: 32),
                            Text(
                              '1000',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
              );
            },
          );
        });
  }
}
