import 'package:demnaa_front/app/modules/adresse_search/controllers/adresse_search_controller.dart';
import 'package:demnaa_front/app/services/api_service.dart';
import 'package:get/get.dart';

import '../../../services/demnaa_services_service.dart'; // Votre service des services
import '../../../modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 🔧 Services (singletons) - Dans l'ordre de dépendance
    
    // 1. ApiService en premier (car les autres services en dépendent)
    Get.put<ApiService>(ApiService(), permanent: true);
    
    // 2. ServiceService (pour récupérer les services depuis l'API)
    Get.put<ServiceService>(ServiceService(), permanent: true); // ✅ Correction ici
    
    // 3. FavoritePlaceService (si vous l'utilisez)
    // Get.put<FavoritePlaceService>(FavoritePlaceService(), permanent: true);
    
    // 🎮 Controllers (lazy loading)
    
    // 1. FavoritePlaceController
    Get.lazyPut<FavoritePlaceController>(
      () => FavoritePlaceController(),
    );
    
    // 2. HomeController (dépend des services ci-dessus)
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
     Get.lazyPut<AddressSearchController>(
      () => AddressSearchController(),
    );
  }
}