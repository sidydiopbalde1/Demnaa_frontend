import 'package:get/get.dart';

import '../controllers/driver_search_controller.dart';

class DriverSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverSearchController>(
      () => DriverSearchController(),
    );
  }
}
