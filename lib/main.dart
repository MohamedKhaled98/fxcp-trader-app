import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:trader_app/config/theme.dart';
import 'package:trader_app/core/bindings/global_bindings.dart';
import 'package:trader_app/ui/screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FXCP Trader',
      initialBinding: GlobalBindings(),
      theme: getAppThemeData(),
      home: HomeScreen(),
    );
  }
}
