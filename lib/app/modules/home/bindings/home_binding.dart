import 'package:demnaa_front/app/modules/reverse_geocoding/controllers/reverse_geocoding_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReverseGeocodingController>(
      () => ReverseGeocodingController(),
    );
  }
}
