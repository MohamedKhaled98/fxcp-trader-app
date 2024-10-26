import 'package:get/instance_manager.dart';
import 'package:trader_app/core/services/connectivity_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  }
}
