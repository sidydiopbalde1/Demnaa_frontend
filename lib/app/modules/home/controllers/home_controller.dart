import 'package:demnaa_front/app/models/driver_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var drivers = <Driver>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Liste statique de conducteurs (remplace par une API si nécessaire)
    drivers.assignAll([
      Driver(name: "Mouhamed Sidibé", status: "Actif", distance: 0.005), // 5m
      Driver(name: "Mouhamed Sidibé", status: "Inactif", distance: 0.0),
      Driver(name: "Lamine Ndiaye", status: "Actif", distance: 0.0, positionStatus: "Position désactivée"),
      Driver(name: "Mouhamed Sidibé", status: "Inactif", distance: 2.0), // 2km
    ]);
  }
}