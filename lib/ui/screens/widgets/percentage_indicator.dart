import 'package:flutter/material.dart';
import 'package:trader_app/constants/color_palate.dart';

class PercentageIndicator extends StatelessWidget {
  final double percentage;
  final double? fontSize;
  const PercentageIndicator(
      {super.key, required this.percentage, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    bool isLower = percentage < 0;
    return Row(
      children: [
        Icon(
            isLower
                ? Icons.arrow_drop_down_rounded
                : Icons.arrow_drop_up_rounded,
            color: isLower ? ColorPalate.danger : ColorPalate.success),
        Text(
          "${percentage.abs().toStringAsFixed(2)}%",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: isLower ? ColorPalate.danger : ColorPalate.success),
        ),
      ],
    );
  }
}
