import 'package:demnaa_front/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class DeliveryTrackingController extends GetxController with GetTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController progressController;
  late Animation<double> progressAnimation;
  
  // Observable variables
  var selectedTransport = 0.obs; // 0: moto, 1: voiture, 2: camion
  var arrivalTime = 3.obs; // minutes
  var distance = 0.9.obs; // km
  var price = 800.obs; // FCFA
  var isValidating = false.obs;
  
  // Course info from arguments
  var departure = ''.obs;
  var destination = ''.obs;
  var serviceType = ''.obs;
  // Variables pour la localisation
final currentLocation = LatLng(14.716677, -17.467686).obs;
final departureLocation = Rxn<LatLng>();
final destinationLocation = Rxn<LatLng>();
final deliveryPersonLocation = LatLng(14.720000, -17.470000).obs;
final deliveryStatus = 'En cours de livraison'.obs;
final speed = '25'.obs;
MapController? mapController;

// Méthodes
void centerOnDeliveryPerson() {
  mapController?.move(deliveryPersonLocation.value, 16.0);
}

void showFullRoute() {
  if (departureLocation.value != null && destinationLocation.value != null) {
    // Calculer les limites pour afficher tout le trajet
    final bounds = LatLngBounds.fromPoints([
      departureLocation.value!,
      destinationLocation.value!,
      deliveryPersonLocation.value,
    ]);
    mapController?.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
  }
}

void refreshDeliveryLocation() {
  // Simuler une mise à jour de position
  // En réalité, ici vous feriez un appel API
}

Color getStatusColor() {
  switch (deliveryStatus.value) {
    case 'En attente':
      return Colors.orange;
    case 'En cours de livraison':
      return Colors.blue;
    case 'Livré':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
  final List<Map<String, dynamic>> transportOptions = [
    {'icon': Icons.motorcycle, 'name': 'Moto', 'isSelected': true},
    {'icon': Icons.directions_car, 'name': 'Voiture', 'isSelected': false},
    {'icon': Icons.local_shipping, 'name': 'Camion', 'isSelected': false},
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _getArguments();
    _startProgressAnimation();
  }

  void _initializeAnimations() {
    progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(CurvedAnimation(
      parent: progressController,
      curve: Curves.easeInOut,
    ));
  }



void _getArguments() {
  final arguments = Get.arguments as Map<String, dynamic>?;
  if (arguments != null) {
    departure.value = arguments['departure'] ?? '';
    destination.value = arguments['destination'] ?? '';
    serviceType.value = arguments['service'] ?? 'Livraison';
    
    // Sélectionner automatiquement le transport basé sur le service
    _selectTransportBasedOnService(serviceType.value);
    
    print('Arguments reçus: $arguments');
    print('Service détecté: ${serviceType.value}');
    print('Transport sélectionné: ${selectedTransport.value}');
  }
}

// Nouvelle méthode pour mapper le service vers l'index de transport
void _selectTransportBasedOnService(String service) {
  final serviceLower = service.toLowerCase();
  
  if (serviceLower.contains('livraison') || serviceLower.contains('delivery')) {
    selectedTransport.value = 0; // Index 0 = Livraison (moto_livraison.png)
    _updateTransportDetails(0);
  } else if (serviceLower.contains('taxi') || serviceLower.contains('moto-taxi')) {
    selectedTransport.value = 1; // Index 1 = Taxi (moto_taxi.png)  
    _updateTransportDetails(1);
  } else if (serviceLower.contains('bagage') || serviceLower.contains('baggage')) {
    selectedTransport.value = 2; // Index 2 = Bagage (moto_bagage.png)
    _updateTransportDetails(2);
  } else {
    // Service par défaut si non reconnu
    selectedTransport.value = 0;
    _updateTransportDetails(0);
  }
}
void _updateTransportDetails(int transportIndex) {
  switch (transportIndex) {
    case 0: // Livraison
      price.value = 800;
      arrivalTime.value = 3;
      break;
    case 1: // Taxi
      price.value = 1200;
      arrivalTime.value = 5;
      break;
    case 2: // Bagage
      price.value = 2000;
      arrivalTime.value = 8;
      break;
  }
}

// Méthode selectTransport modifiée pour utiliser la méthode helper
void selectTransport(int index) {
  selectedTransport.value = index;
  _updateTransportDetails(index);
}

  void _startProgressAnimation() {
    progressController.forward();
  }

  // Changer le moyen de transport
  // void selectTransport(int index) {
  //   selectedTransport.value = index;
    
  //   // Ajuster le prix selon le transport
  //   switch (index) {
  //     case 0: // Moto
  //       price.value = 800;
  //       arrivalTime.value = 3;
  //       break;
  //     case 1: // Voiture
  //       price.value = 1200;
  //       arrivalTime.value = 5;
  //       break;
  //     case 2: // Camion
  //       price.value = 2000;
  //       arrivalTime.value = 8;
  //       break;
  //   }
  // }
Future<void> validateCourse() async {
  isValidating.value = true;
  
  try {
    // Simulation d'appel API
    await Future.delayed(const Duration(seconds: 2));
    
    // Naviguer vers l'écran de destination
    Get.offAllNamed('/destination', arguments: {
      'courseId': DateTime.now().millisecondsSinceEpoch.toString(),
      'transport': transportOptions[selectedTransport.value]['name'],
      'price': price.value,
      'arrivalTime': arrivalTime.value,
      'departure': departure.value,
      'destination': destination.value,
      'destinationPhone': '784316538',
      'fromHome': Get.currentRoute == '/home',
    });
    
    // Refresh du HomeController après navigation (optionnel)
    Future.delayed(Duration(milliseconds: 500), () {
      try {
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.refreshServices();
        }
      } catch (e) {
        print('HomeController non trouvé: $e');
      }
    });
    
  } catch (e) {
    Get.snackbar(
      'Erreur',
      'Impossible de valider la course',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  } finally {
    isValidating.value = false;
  }
}

  // Annuler la course
  void cancelCourse() {
    Get.dialog(
      AlertDialog(
        title: const Text('Annuler la course'),
        content: const Text('Êtes-vous sûr de vouloir annuler cette course ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/driver-search'); // Aller au questionnaire d'annulation
            },
            child: const Text(
              'Oui, annuler',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Retour à l'écran précédent
  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    progressController.dispose();
    super.onClose();
  }
}