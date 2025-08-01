import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialiser d'abord le FavoritePlaceController
    Get.lazyPut<FavoritePlaceController>(
      () => FavoritePlaceController(),
    );
    
    // Puis le HomeController qui dépend du FavoritePlaceController
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}