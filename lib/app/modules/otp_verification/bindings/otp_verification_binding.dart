import 'package:demnaa_front/app/modules/otp_verification/controllers/otp_verification_controller.dart';
import 'package:get/get.dart';



class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    
    // Créer un nouveau contrôleur
    Get.put<OtpVerificationController>(
      OtpVerificationController(),
    );
  }
}
