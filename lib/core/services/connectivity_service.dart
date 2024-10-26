import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:trader_app/constants/color_palate.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.showSnackbar(const GetSnackBar(
        message: "Internet connection lost...",
        isDismissible: false,
        backgroundColor: ColorPalate.danger,
      ));
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
