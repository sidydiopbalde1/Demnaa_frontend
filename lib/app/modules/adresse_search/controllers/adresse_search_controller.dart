import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressSearchController extends GetxController {
  // Text Controllers
  final departureController = TextEditingController(text: '77 HB 23 24');
  final destinationController = TextEditingController();
  
  // Observable variables
  var isLoading = false.obs;
  var selectedService = 'Livraison'.obs;
  var departureAddress = 'Grand Dakar Rue 449'.obs;
  var destinationAddress = 'Adresse du destinataire'.obs;
  
  // Services disponibles
  final List<String> availableServices = [
    'Livraison',
    'Moto-taxi',
    'Moto-colis'
  ];

  @override
  void onInit() {
    super.onInit();
    _setupTextControllerListeners();
  }

  void _setupTextControllerListeners() {
    departureController.addListener(() {
      // Logique de validation ou de recherche en temps réel
      _validateAddresses();
    });
    
    destinationController.addListener(() {
      _validateAddresses();
    });
  }

  void _validateAddresses() {
    // Validation des adresses saisies
    if (departureController.text.isNotEmpty && destinationController.text.isNotEmpty) {
      // Activer le bouton commander
    }
  }

  // Changer le service sélectionné
  void changeService(String service) {
    selectedService.value = service;
  }

  // Ajouter un arrêt
  void addStop() {
    Get.snackbar(
      'Arrêt ajouté',
      'Fonctionnalité d\'ajout d\'arrêt',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Actions pour les icônes (domicile, favoris, etc.)
  void onIconTap(String iconType) {
    switch (iconType) {
      case 'home':
        _setHomeAddress();
        break;
      case 'favorites':
        _showFavorites();
        break;
      case 'history':
        _showHistory();
        break;
      case 'location':
        _getCurrentLocation();
        break;
    }
  }

  void _setHomeAddress() {
    Get.snackbar(
      'Adresse domicile',
      'Adresse domicile sélectionnée',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showFavorites() {
    // Naviguer vers les favoris ou ouvrir un modal
  }

  void _showHistory() {
    // Afficher l'historique des adresses
  }

  void _getCurrentLocation() {
    // Obtenir la position GPS actuelle
    Get.snackbar(
      'Localisation',
      'Récupération de votre position...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Commander la course
  Future<void> commander() async {
    if (departureController.text.isEmpty || destinationController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir les adresses de départ et d\'arrivée',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulation d'appel API
      await Future.delayed(const Duration(seconds: 2));
      
      // Naviguer vers l'écran de suivi
      Get.toNamed('/delivery-tracking', arguments: {
        'departure': departureController.text,
        'destination': destinationController.text,
        'service': selectedService.value,
      });
      
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de créer la commande',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    departureController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}