import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trader_app/constants/color_palate.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: LoadingAnimationWidget.staggeredDotsWave( color: ColorPalate.success, size: 40),
    );
  }
}