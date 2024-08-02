import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:ricochlime/ads/iap.dart';
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
                  fontSize: 32,
                  height: 0.65,
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(t.shopPage.bulletColors,
                        style: const TextStyle(fontSize: 24)),
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
                      valueListenable: Prefs.bulletColor,
                      builder: (context, _, __) => _ShopItemTile(
                        selected: Prefs.bulletColor.value == item.color,
                        select: () => Prefs.bulletColor.value = item.color,
                        item: item,
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(t.shopPage.bulletShapes,
                        style: const TextStyle(fontSize: 24)),
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
                      valueListenable: Prefs.bulletShape,
                      builder: (context, _, __) => _ShopItemTile(
                        selected: Prefs.bulletShape.value == item.id,
                        select: () => Prefs.bulletShape.value = item.id,
                        item: item,
                      ),
                    );
                  },
                ),
                if (RicochlimeIAP.inAppPurchasesSupported) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(t.shopPage.premium,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      ValueListenableBuilder(
                        valueListenable:
                            RicochlimeProduct.removeAdsForever.state,
                        builder: (context, state, _) {
                          return NesButton(
                            type: switch (state) {
                              IAPState.unpurchased => NesButtonType.warning,
                              IAPState.purchasedAndEnabled =>
                                NesButtonType.primary,
                              IAPState.purchasedAndDisabled =>
                                NesButtonType.normal,
                            },
                            onPressed: switch (state) {
                              IAPState.unpurchased => () => RicochlimeIAP.buy(
                                  RicochlimeProduct.removeAdsForever),
                              IAPState.purchasedAndEnabled => () =>
                                  RicochlimeProduct.removeAdsForever.state
                                      .value = IAPState.purchasedAndDisabled,
                              IAPState.purchasedAndDisabled => () =>
                                  RicochlimeProduct.removeAdsForever.state
                                      .value = IAPState.purchasedAndEnabled,
                            },
                            child: Row(
                              children: [
                                NesIcon(iconData: NesIcons.eraser),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    t.shopPage.removeAdsForever,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                switch (state) {
                                  IAPState.unpurchased => Text(
                                      RicochlimeProduct.removeAdsForever.price,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  IAPState.purchasedAndEnabled => NesCheckBox(
                                      value: true,
                                      onChange: (_) {},
                                    ),
                                  IAPState.purchasedAndDisabled => NesCheckBox(
                                      value: false,
                                      onChange: (_) {},
                                    ),
                                },
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      NesButton(
                        type: NesButtonType.normal,
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
    // ignore: unused_element
    super.key,
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
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CoinIcon(size: 32),
                      Text(
                        item.price.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
