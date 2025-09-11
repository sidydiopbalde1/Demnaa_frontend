// delivery_tracking_controller.dart - Version corrigée avec tous les imports
import 'dart:async'; // Pour Timer
import 'dart:math'; // Pour Random
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FinalDeliveryTrackingController extends GetxController {
  late MapController mapController;
  late Timer? _locationTimer; // Déclarer le timer
  
  var currentLocation = LatLng(14.716677, -17.467686).obs;
  var departureLocation = LatLng(14.716677, -17.467686).obs;
  var destinationLocation = LatLng(14.720000, -17.470000).obs;
  var driverLocation = LatLng(14.718000, -17.468000).obs;
  
  var estimatedTime = 16.obs;
  var distance = 2.3.obs;
  var deliveryMessage = 'Colis de la part de mamadou'.obs;
  var deliveryAddress = '584 Usine Grand-Dakar, Dakar\nGrand-Dakar Dakar, Sénégal'.obs;
  
  // Instance de Random pour générer les positions aléatoires
  final Random _random = Random();
  
  List<LatLng> get routePoints => [
    departureLocation.value,
    LatLng(14.717000, -17.468500),
    LatLng(14.718500, -17.469000),
    LatLng(14.719500, -17.469500),
    destinationLocation.value,
  ];

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    // Simuler le mouvement du livreur avec Timer.periodic
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Mettre à jour la position du livreur en utilisant Random
      double lat = driverLocation.value.latitude + (_random.nextDouble() - 0.5) * 0.001;
      double lng = driverLocation.value.longitude + (_random.nextDouble() - 0.5) * 0.001;
      driverLocation.value = LatLng(lat, lng);
      
      // Mettre à jour le temps estimé
      if (estimatedTime.value > 0) {
        estimatedTime.value = estimatedTime.value - 1;
      }
      
      // Arrêter le timer si la livraison est terminée
      if (estimatedTime.value <= 0) {
        _stopLocationUpdates();
        _deliveryCompleted();
      }
    });
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  void _deliveryCompleted() {
    // Naviguer vers l'écran de succès quand la livraison est terminée
    Get.snackbar(
      'Livraison terminée',
      'Votre colis est arrivé à destination !',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      goToPaymentSelection();
    });
  }

  void goToPaymentSelection() {
    Get.toNamed('/payment-selection', arguments: {
      'deliveryId': DateTime.now().millisecondsSinceEpoch.toString(),
      'deliveryAddress': deliveryAddress.value,
      'driverName': 'Moustapha',
      'orderTotal': 2500.0,
    });
  }

  void createNewOrder() {
    Get.toNamed('/home');
  }

  // Méthodes pour contrôler la carte
  void centerOnDriver() {
    mapController.move(driverLocation.value, 16.0);
  }

  void showFullRoute() {
    final bounds = LatLngBounds.fromPoints([
      departureLocation.value,
      destinationLocation.value,
      driverLocation.value,
    ]);
    
    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  @override
  void onClose() {
    // Nettoyer le timer quand le controller est détruit
    _stopLocationUpdates();
    super.onClose();
  }
}