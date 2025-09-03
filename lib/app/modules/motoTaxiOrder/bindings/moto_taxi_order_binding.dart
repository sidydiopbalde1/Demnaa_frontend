import 'package:get/get.dart';

import '../controllers/moto_taxi_order_controller.dart';

class MotoTaxiOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MotoTaxiOrderController>(
      () => MotoTaxiOrderController(),
    );
  }
}
