import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/core/models/top_mover.dart';
import 'package:trader_app/core/view_models/home_viewmodel.dart';
import 'package:trader_app/mocks/mock_top_movers.dart';
import 'package:trader_app/ui/screens/widgets/chart_mock.dart';
import 'package:trader_app/ui/screens/widgets/loading.dart';
import 'package:trader_app/ui/screens/widgets/percentage_indicator.dart';
import 'dart:math' as math;

import 'package:trader_app/utils/functions.dart';

class TopMovers extends StatelessWidget {
  const TopMovers({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                "TOP MOVERS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 140,
              child: GetBuilder<HomeViewModel>(
                  id: 'top_movers',
                  builder: (controller) {
                    if (controller.topMoversLoading) {
                      return const Loader();
                    }
                    return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          TopMover topMover = controller.topMovers[index];
                          double percentage = calculatePercentage(
                              topMover.quote.currentPrice,
                              topMover.quote.previousClose);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 140,
                              width: 200,
                              color: ColorPalate.forground.withOpacity(0.5),
                              child: Stack(
                                children: [
                                  portfolioChart(percentage),
                                  Positioned(
                                    left: 15,
                                    top: 15,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.network(
                                                topMover.company.logo,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(),
                                              )),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              topMover.company.ticker,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              topMover.company.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white
                                                      .withOpacity(0.6)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 15,
                                      left: 15,
                                      child: SizedBox(
                                        width: 170,
                                        child: Row(
                                          children: [
                                            Text(
                                              "\$${topMover.quote.currentPrice}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white
                                                      .withOpacity(0.8)),
                                            ),
                                            const Spacer(),
                                            PercentageIndicator(
                                                percentage: percentage)
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemCount: controller.topMovers.length);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget portfolioChart(double percentage) {
    Currency currency = MockTopMovers.data[0];
    final minPrice = currency.priceHistory.reduce(math.min);
    final maxPrice = currency.priceHistory.reduce(math.max);
    Color color = percentage >= 0 ? ColorPalate.primary : ColorPalate.danger;
    return Chart(
      data: currency.priceHistory,
      minData: minPrice,
      maxData: maxPrice,
      minY: 0.94 * minPrice,
      paddingTop: 75,
      thickness: 2,
      color: color,
      gradientColors: [
        color.withOpacity(0.1),
        ColorPalate.forground.withOpacity(0),
      ],
    );
  }
}
