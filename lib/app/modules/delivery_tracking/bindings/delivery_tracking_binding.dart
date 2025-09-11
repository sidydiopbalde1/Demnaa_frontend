import 'package:demnaa_front/app/modules/delivery_tracking/controllers/delivery_success_controller.dart';
import 'package:demnaa_front/app/modules/delivery_tracking/controllers/final_delivery_tracking_controller.dart';
import 'package:get/get.dart';

import '../controllers/delivery_tracking_controller.dart';

class DeliveryTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryTrackingController>(
      () => DeliveryTrackingController(),
    );
      Get.lazyPut<DeliverySuccessController>(
      () => DeliverySuccessController(),
    );
      Get.lazyPut<FinalDeliveryTrackingController>(
      () => FinalDeliveryTrackingController(),
    );
  }
}
