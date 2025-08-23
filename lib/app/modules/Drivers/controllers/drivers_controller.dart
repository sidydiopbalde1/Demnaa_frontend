import 'package:demnaa_front/app/routes/app_pages.dart';
import 'package:get/get.dart';

class Driver {
  final String name;
  final String status;
  final String distance;
  final String time;
  final bool isActive;

  Driver({
    required this.name,
    required this.status,
    required this.distance,
    required this.time,
    required this.isActive,
  });
}

class DriversController extends GetxController {
  // Liste des conducteurs
  var drivers = <Driver>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadDrivers();
  }

  void _loadDrivers() {
    drivers.value = [
      Driver(
        name: 'Mouhamed Sidibé',
        status: 'Actif',
        distance: '5 m de ta position',
        time: '',
        isActive: true,
      ),
      Driver(
        name: 'Mouhamed Sidibé',
        status: 'Inactif',
        distance: '0m de ta position',
        time: '',
        isActive: false,
      ),
      Driver(
        name: 'Lamine Ndiaye',
        status: 'Actif',
        distance: 'Position désactivée',
        time: '',
        isActive: true,
      ),
      Driver(
        name: 'Mouhamed Sidibé',
        status: 'Inactif',
        distance: '2 km de la position',
        time: '',
        isActive: false,
      ),
    ];
  }

  void addDriver() {
    Get.toNamed(Routes.ADD_DRIVER);
  }

  void goToDriversList() {
    Get.toNamed(Routes.DRIVERS_LIST);
  }

  void goBack() {
    Get.back();
  }
}