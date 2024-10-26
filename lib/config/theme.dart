import 'package:flutter/material.dart';
import 'package:trader_app/constants/color_palate.dart';

ThemeData getAppThemeData() {
  return ThemeData(
      scaffoldBackgroundColor: ColorPalate.background,
      useMaterial3: true,
      fontFamily: "Roboto",
      brightness: Brightness.dark,
      colorSchemeSeed: ColorPalate.primary,
      appBarTheme: const AppBarTheme(
          backgroundColor: ColorPalate.background,
          elevation: 0,
          surfaceTintColor: Colors.transparent),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Colors.white, iconColor: Colors.white)),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white)));
}
