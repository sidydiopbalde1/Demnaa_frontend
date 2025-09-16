import 'package:demnaa_front/app/modules/profil_selection/controllers/profil_selection_controller.dart';
import 'package:get/get.dart';



class ProfilSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSelectionController>(
      () => ProfileSelectionController(),
      fenix: true,
    );
  }
}
