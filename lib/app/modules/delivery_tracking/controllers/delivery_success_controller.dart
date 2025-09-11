import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliverySuccessController extends GetxController {
  // Variables observables
  var rating = 0.obs;
  var isSubmitting = false.obs;
  var driverName = 'Moustapha'.obs;
  var driverPhoto = 'assets/images/user_map_icone.png'.obs;
  
  // Données de la commande
  var deliveryId = ''.obs;
  var deliveryAddress = ''.obs;
  var deliveryTime = ''.obs;
  var orderTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDeliveryData();
    _showSuccessAnimation();
  }

  void _loadDeliveryData() {
    // Récupérer les données de la livraison depuis les arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      deliveryId.value = arguments['deliveryId'] ?? '';
      deliveryAddress.value = arguments['deliveryAddress'] ?? '';
      deliveryTime.value = arguments['deliveryTime'] ?? '';
      orderTotal.value = arguments['orderTotal'] ?? 0.0;
      driverName.value = arguments['driverName'] ?? 'Moustapha';
      driverPhoto.value = arguments['driverPhoto'] ?? 'assets/images/user_map_icone.png';
      
      print('Données de livraison chargées: $arguments');
    }
  }

  void _showSuccessAnimation() {
    // Animation d'entrée pour la notification de succès
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        '',
        '',
        titleText: const SizedBox.shrink(),
        messageText: const SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 1),
      );
    });
  }

  void setRating(int value) {
    if (!isSubmitting.value) {
      rating.value = value;
      
      // Haptic feedback pour une meilleure UX
      // HapticFeedback.lightImpact();
    }
  }

  Future<void> submitRating() async {
    if (rating.value == 0) {
      Get.snackbar(
        'Évaluation requise',
        'Veuillez donner une note avant d\'envoyer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isSubmitting.value = true;

    try {
      // Simuler l'appel API pour soumettre l'évaluation
      await _submitRatingToAPI();

      // Afficher un message de confirmation
      Get.snackbar(
        'Merci !',
        'Votre évaluation a été envoyée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      // Attendre un peu puis retourner à l'accueil
      await Future.delayed(const Duration(seconds: 2));
      _navigateToHome();

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer votre évaluation. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitRatingToAPI() async {
    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 2));
    
    // Ici vous feriez l'appel réel à votre API
    final ratingData = {
      'delivery_id': deliveryId.value,
      'driver_name': driverName.value,
      'rating': rating.value,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    print('Évaluation soumise: $ratingData');
    
    // Si l'API retourne une erreur, throw une exception
    // throw Exception('Erreur API');
  }

  void skipRating() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Évaluation plus tard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        content: const Text(
          'Vous pourrez évaluer votre conducteur depuis l\'historique de vos commandes à tout moment.',
          style: TextStyle(
            color: Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Fermer le dialog
              _navigateToHome();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _navigateToHome() {
    // Retourner à l'écran d'accueil en effaçant la pile de navigation
    Get.offAllNamed('/home');
  }

  // Méthode pour relancer une nouvelle commande
  void createNewOrder() {
    Get.offAllNamed('/home');
    
    // Optionnel: ouvrir directement le flow de nouvelle commande
    Future.delayed(const Duration(milliseconds: 500), () {
      // Get.toNamed('/new-order');
    });
  }

  @override
  void onClose() {
    // Nettoyer les ressources si nécessaire
    super.onClose();
  }
}