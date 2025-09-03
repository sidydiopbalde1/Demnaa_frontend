import 'package:demnaa_front/app/modules/settings/controllers/contact_controller.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
     Get.lazyPut<ContactController>(
      () => ContactController(),
    );
  }
}
