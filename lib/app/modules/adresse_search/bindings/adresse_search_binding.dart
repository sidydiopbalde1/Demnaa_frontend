import 'package:demnaa_front/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:demnaa_front/app/modules/adresse_search/controllers/adresse_search_controller.dart';

class AddressSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressSearchController>(
      () => AddressSearchController(),
    );
     Get.lazyPut<HomeController>(
      () => HomeController(),
       fenix: true,
    );
  }
}