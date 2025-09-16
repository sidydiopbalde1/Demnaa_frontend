import 'package:demnaa_front/app/modules/onBording/controllers/on_bording_controller.dart';
import 'package:get/get.dart';



class OnBordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
  }
}
