import 'package:flutter/material.dart';
import 'package:trader_app/constants/color_palate.dart';
import 'package:trader_app/core/models/trade.dart';
import 'package:trader_app/utils/functions.dart';

class TradeInstrumentItem extends StatelessWidget {
  final Trade trade;
  final int index;
  const TradeInstrumentItem(
      {super.key, required this.trade, required this.index});

  @override
  Widget build(BuildContext context) {
    double persentage = calculatePercentage(trade.price, trade.closePrice);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: index.isEven ? ColorPalate.forground : Colors.transparent,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  removeBeforeColon(trade.symbol),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${trade.price.toStringAsFixed(3)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Icon(
                            persentage < 0
                                ? Icons.arrow_drop_down_rounded
                                : Icons.arrow_drop_up_rounded,
                            color: persentage < 0
                                ? ColorPalate.danger
                                : ColorPalate.success),
                        Text(
                          "${persentage.abs().toStringAsFixed(2)}% (${(trade.price - trade.closePrice).toStringAsFixed(2)})",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: persentage < 0
                                  ? ColorPalate.danger
                                  : ColorPalate.success),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
