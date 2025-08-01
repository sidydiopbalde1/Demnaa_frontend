import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:get/get.dart';



class CreateFavoritePlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritePlaceController>(
      () => FavoritePlaceController(),
    );
  }
}
