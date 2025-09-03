import 'package:get/get.dart';

class Driver {
  final String id;
  final String name;
  final String status;
  final String distance;
  final String time;
  final bool isActive;
  final String avatar;

  Driver({
    required this.id,
    required this.name,
    required this.status,
    required this.distance,
    required this.time,
    required this.isActive,
    this.avatar = '',
  });
}

class DriversController extends GetxController {
  // Liste des conducteurs
  var drivers = <Driver>[].obs;
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadDrivers();
  }

  void _loadDrivers() {
    // Simuler le chargement
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 1), () {
      drivers.value = [
        Driver(
          id: '1',
          name: 'Mouhamed Sidibé',
          status: 'Actif',
          distance: '5 m de ta position',
          time: '',
          isActive: true,
        ),
        Driver(
          id: '2',
          name: 'Mouhamed Sidibé',
          status: 'Inactif',
          distance: '0m de ta position',
          time: '',
          isActive: false,
        ),
        Driver(
          id: '3',
          name: 'Lamine Ndiaye',
          status: 'Actif',
          distance: 'Position désactivée',
          time: '',
          isActive: true,
        ),
        Driver(
          id: '4',
          name: 'Mouhamed Sidibé',
          status: 'Inactif',
          distance: '2 Km de la position',
          time: '',
          isActive: false,
        ),
      ];
      isLoading.value = false;
    });
  }

  void addDriver() {
    Get.toNamed('/add-driver');
  }

  void callDriver(String driverId) {
    // Logique pour appeler le conducteur
    Get.snackbar(
      'Appel',
      'Appel en cours...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void messageDriver(String driverId) {
    // Logique pour envoyer un message
    Get.snackbar(
      'Message',
      'Message envoyé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void trackDriver(String driverId) {
    // Logique pour suivre le conducteur
    Get.snackbar(
      'Localisation',
      'Ouverture de la carte...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goBack() {
    Get.back();
  }
}