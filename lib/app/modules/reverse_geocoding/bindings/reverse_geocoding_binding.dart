import 'package:get/get.dart';

import '../controllers/reverse_geocoding_controller.dart';

class ReverseGeocodingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReverseGeocodingController>(
      () => ReverseGeocodingController(),
    );
  }
}
