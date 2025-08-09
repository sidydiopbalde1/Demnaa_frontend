import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DestinationController extends GetxController with GetTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;
  
  // Observable variables
  var isWaitingResponse = true.obs;
  var destinationAddress = '584 Usine Grand-Dakar, Dakar'.obs;
  var destinationSubtitle = 'Grand-Dakar, Dakar, Sénégal'.obs;
  var estimatedTime = 5.obs; // minutes
  
  // Course info from arguments
  var courseId = ''.obs;
  var transportType = ''.obs;
  var coursePrice = 0.obs;
  var arrivalTime = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _getArguments();
    _startWaitingSimulation();
  }

  void _initializeAnimations() {
    pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _getArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      courseId.value = arguments['courseId'] ?? '';
      transportType.value = arguments['transport'] ?? '';
      coursePrice.value = arguments['price'] ?? 0;
      arrivalTime.value = arguments['arrivalTime'] ?? 0;
    }
  }

  void _startWaitingSimulation() {
    // Simuler l'attente de réponse du conducteur
    Future.delayed(const Duration(seconds: 8), () {
      if (isWaitingResponse.value) {
        // Simuler une réponse positive du conducteur
        _driverAccepted();
      }
    });
  }

  void _driverAccepted() {
    isWaitingResponse.value = false;
    
    Get.snackbar(
      'Conducteur trouvé !',
      'Un conducteur a accepté votre course',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    // Naviguer vers l'écran de suivi final
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed('/final-tracking', arguments: {
        'courseId': courseId.value,
        'transport': transportType.value,
        'price': coursePrice.value,
        'destination': destinationAddress.value,
      });
    });
  }

  // Ajouter un arrêt
  void addStop() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ajouter un arrêt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Adresse de l\'arrêt',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Annuler'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Arrêt ajouté',
                        'L\'arrêt a été ajouté à votre trajet',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text('Ajouter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Actions pour les boutons d'options
  void onActionTap(String actionType) {
    switch (actionType) {
      case 'navigation':
        _openNavigation();
        break;
      case 'home':
        _setHomeAddress();
        break;
      case 'time':
        _setScheduledTime();
        break;
      case 'location':
        _getCurrentLocation();
        break;
      case 'search':
        _searchAddress();
        break;
    }
  }

  void _openNavigation() {
    Get.snackbar(
      'Navigation',
      'Ouverture de l\'application de navigation',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _setHomeAddress() {
    destinationAddress.value = 'Domicile';
    destinationSubtitle.value = 'Adresse de votre domicile';
  }

  void _setScheduledTime() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Programmer la course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Fonctionnalité à implémenter'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    Get.snackbar(
      'Position actuelle',
      'Récupération de votre position...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _searchAddress() {
    Get.toNamed('/address-search');
  }

  // Retour à l'écran précédent
  void goBack() {
    Get.back();
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
              Get.toNamed('/driver-search');
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

  @override
  void onClose() {
    pulseController.dispose();
    super.onClose();
  }
}