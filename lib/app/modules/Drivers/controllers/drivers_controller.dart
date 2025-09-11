import 'package:get/get.dart';

class Driver {
  final String id;
  final String name;
  final String status;
  final String distance;
  final String time;
  final bool isActive;
  final String avatar;
  final String service; // Nouveau champ pour le service

  Driver({
    required this.id,
    required this.name,
    required this.status,
    required this.distance,
    required this.time,
    required this.isActive,
    this.avatar = '',
    this.service = '',
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
          avatar: 'assets/images/user_map_icone.png',
          service: 'assets/images/moto_livraison.png',
        ),
        Driver(
          id: '2',
          name: 'Mouhamed Sidibé',
          status: 'Inactif',
          distance: '0m de ta position',
          time: '',
          isActive: false,
          avatar: 'assets/images/user_map_icone.png',
          service: 'assets/images/moto_livraison.png',
        ),
        Driver(
          id: '3',
          name: 'Lamine Ndiaye',
          status: 'Actif',
          distance: 'Position désactivée',
          time: '',
          isActive: true,
          avatar: 'assets/images/user_map_icone.png',
          service: 'assets/images/moto_taxi.png',
        ),
        Driver(
          id: '4',
          name: 'Mouhamed Sidibé',
          status: 'Inactif',
          distance: '2 Km de la position',
          time: '',
          isActive: false,
          avatar: 'assets/images/user_map_icone.png',
          service: 'assets/images/moto_bagage.png',
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