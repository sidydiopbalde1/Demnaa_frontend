import 'package:demnaa_front/app/modules/auth/controllers/phone_verification_controller.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
      Get.lazyPut<PhoneVerificationController>(
      () => PhoneVerificationController(),
      fenix: true,
    );
  }
}
