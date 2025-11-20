import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/iap.dart';
import 'package:ricochlime/i18n/strings.g.dart';
import 'package:ricochlime/nes/coin.dart';
import 'package:ricochlime/utils/shop_items.dart';
import 'package:ricochlime/utils/stows.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  /// User can pay 10k coins instead of real money to remove ads forever.
  static const removeAdsForeverCoinPrice = 10 * 1000;

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
          IgnorePointer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                ValueListenableBuilder(
                  valueListenable: stows.coins,
                  builder: (context, coins, _) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Text(
                      coins.toString(),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 32,
                        height: 0.6,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
                const CoinIcon(size: 24),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenSize.height),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      t.shopPage.bulletColors,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SliverGrid.builder(
                  itemCount: ShopItems.bulletColors.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= ShopItems.bulletColors.length) return null;
                    final item = ShopItems.bulletColors[index];

                    return ValueListenableBuilder(
                      valueListenable: stows.bulletColor,
                      builder: (context, _, _) => _ShopItemTile(
                        selected: stows.bulletColor.value == item.color,
                        select: () => stows.bulletColor.value = item.color,
                        item: item,
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      t.shopPage.bulletShapes,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                SliverGrid.builder(
                  itemCount: ShopItems.bulletShapes.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= ShopItems.bulletShapes.length) return null;
                    final item = ShopItems.bulletShapes[index];

                    return ValueListenableBuilder(
                      valueListenable: stows.bulletShape,
                      builder: (context, _, _) => _ShopItemTile(
                        selected: stows.bulletShape.value == item.id,
                        select: () => stows.bulletShape.value = item.id,
                        item: item,
                      ),
                    );
                  },
                ),
                if (RicochlimeIAP.inAppPurchasesSupported) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        t.shopPage.premium,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      NesButton(
                        type: .normal,
                        onPressed: () => RicochlimeIAP.buy(.buy1000Coins),
                        child: Row(
                          children: [
                            const CoinIcon(size: 32),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t.shopPage.buy1000Coins,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              RicochlimeProduct.buy1000Coins.price,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      NesButton(
                        type: .normal,
                        onPressed: () =>
                            RicochlimeIAP.buy(RicochlimeProduct.buy5000Coins),
                        child: Row(
                          children: [
                            const CoinIcon(size: 32),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t.shopPage.buy5000Coins,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              RicochlimeProduct.buy5000Coins.price,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      NesButton(
                        type: .normal,
                        onPressed: RicochlimeIAP.restorePurchases,
                        child: Row(
                          children: [
                            NesIcon(iconData: NesIcons.download),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t.shopPage.restorePurchases,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
    required this.selected,
    required this.select,
    required this.item,
  });

  final bool selected;
  final VoidCallback select;
  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: item.state,
      builder: (context, state, _) {
        return NesButton(
          onPressed: switch (state) {
            ShopItemState.loading => null,
            ShopItemState.purchased => select,
            ShopItemState.unpurchased => () async {
              final purchased = await item.purchase();
              if (purchased) select();
            },
          },
          type: switch (state) {
            ShopItemState.loading => .normal,
            ShopItemState.purchased => selected ? .primary : .normal,
            ShopItemState.unpurchased => .warning,
          },
          child: state == ShopItemState.purchased
              ? Center(
                  child: SizedBox.square(
                    dimension: 20,
                    child: item.build(context),
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      const CoinIcon(size: 32),
                      Text(
                        item.price.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
