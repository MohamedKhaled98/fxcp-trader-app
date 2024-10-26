import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/core/models/trade.dart';
import 'package:trader_app/core/view_models/home_viewmodel.dart';
import 'package:trader_app/ui/screens/home_screen/components/asset_type_tabs.dart';
import 'package:trader_app/ui/screens/home_screen/components/top_movers.dart';
import 'package:trader_app/ui/screens/home_screen/components/trade_instrument_item.dart';
import 'package:trader_app/ui/screens/news_screen/news_screen.dart';
import 'package:trader_app/ui/screens/widgets/loading.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeViewModel controller = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: false,
              expandedHeight: 80,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Get.to(() => NewsScreen());
                  },
                  label: const Text("News"),
                  icon: const Icon(
                    Icons.newspaper_rounded,
                    color: ColorPalate.primary,
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
                title: Row(
                  children: [
                    SvgPicture.asset('assets/icons/bull.svg', height: 25),
                    const SizedBox(width: 10),
                    const Text(
                      "Trader",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                    )
                  ],
                ),
              ),
            ),
            const TopMovers(),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
            SliverStickyHeader(
              header: const AssetTypeTabs(),
              sliver: GetBuilder<HomeViewModel>(
                id: 'live_trades',
                builder: (controller) {
                  if (controller.liveTradesLoading) {
                    return const SliverToBoxAdapter(
                      child: Loader(),
                    );
                  }
                  return SliverList.builder(
                    itemCount: controller.liveTrades.length,
                    itemBuilder: (context, index) {
                      Trade trade = controller.liveTrades[index];
                      return TradeInstrumentItem(trade: trade, index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
