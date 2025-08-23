import 'package:get/get.dart';

import '../controllers/drivers_controller.dart';

class DriversBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriversController>(
      () => DriversController(),
    );

  }
}
