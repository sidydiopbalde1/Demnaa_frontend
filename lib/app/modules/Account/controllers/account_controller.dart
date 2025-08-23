import 'package:demnaa_front/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  // Informations utilisateur
  var userName = 'Mamadou'.obs;
  var userPhone = '+221 77 153 95 09'.obs;
  var userAddress = 'Yoff RUE 455'.obs;
  
  // Navigation vers les différents écrans
  void goToDrivers() {
    Get.toNamed(Routes.DRIVERS);
  }
  
  void goToProfile() {
    Get.toNamed(Routes.PROFIL);
  }
  
  void goToModifyNumber() {
    Get.toNamed(Routes.MODIFY_NUMBER);
  }
  
  void goToBecomeDriver() {
    Get.toNamed(Routes.BECOME_DRIVER);
  }
  
  void goToBecomeOwner() {
    Get.toNamed(Routes.BECOME_OWNER);
  }
  
  void goToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }
  
  void goToInformations() {
    Get.toNamed(Routes.INFORMATIONS);
  }
  
  void goBack() {
    Get.back();
  }
}