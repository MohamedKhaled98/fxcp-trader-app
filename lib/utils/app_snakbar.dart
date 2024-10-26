import 'package:get/route_manager.dart';
import 'package:trader_app/constants/color_palate.dart';

class AppSnakbar {
  static error(message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: ColorPalate.danger,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    ));
  }

  static sucess(message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: ColorPalate.success,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    ));
  }
}
