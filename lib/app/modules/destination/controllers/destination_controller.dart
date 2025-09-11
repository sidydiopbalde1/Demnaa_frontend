import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;

  // Observable variables
  var isWaitingResponse = true.obs;
  var departureAddress = 'Adresse de départ'.obs;
  var destinationAddress = 'Adresse de destination'.obs;
  var destinationSubtitle = 'Grand-Dakar, Dakar, Sénégal'.obs;
  var estimatedTime = 5.obs;

  var isFromHome = false.obs;

  // Course info from arguments
  var courseId = ''.obs;
  var transportType = ''.obs;
  var coursePrice = 0.obs;
  var arrivalTime = 0.obs;
  var destinationPhone = ''.obs;

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

      // Récupération des adresses depuis les arguments
      departureAddress.value = arguments['departure'] ?? 'Adresse de départ';
      destinationAddress.value =
          arguments['destination'] ?? 'Adresse de destination';

      // Récupérer le numéro de téléphone du destinataire
      destinationPhone.value = arguments['destinationPhone'] ?? '';
      // Vérifier la provenance de la navigation
      isFromHome.value = arguments['fromHome'] ?? false;
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

// void _driverAccepted() {
//     isWaitingResponse.value = false;

//     // Naviguer vers l'écran de suivi final
//     Future.delayed(const Duration(seconds: 2), () {
//       Get.toNamed('/final-tracking', arguments: {
//         'courseId': courseId.value,
//         'transport': transportType.value,
//         'price': coursePrice.value,
//         'departure': departureAddress.value, // Passer l'adresse de départ
//         'destination': destinationAddress.value, // Passer l'adresse de destination
//       });
//     });
//   }
  void _driverAccepted() {
    isWaitingResponse.value = false;

    // Envoyer message WhatsApp au destinataire
    //6538_sendWhatsAppNotification(isConfirmed: true);

    // Naviguer vers l'écran de suivi final
    Future.delayed(const Duration(seconds: 5), () {
      Get.toNamed('/final-delivery-tracking', arguments: {
        'courseId': courseId.value,
        'transport': transportType.value,
        'price': coursePrice.value,
        'departure': departureAddress.value,
        'destination': destinationAddress.value,
      });
    });
  }

  Future<void> _sendWhatsAppNotification({required bool isConfirmed}) async {
    try {
      String destinationPhoneNumber = _getDestinationPhone();

      if (destinationPhoneNumber.isEmpty) {
        print('Aucun numéro de téléphone fourni');
        return;
      }

      String message;
      if (isConfirmed) {
        message = _getDeliveryConfirmationMessage();
      } else {
        message = _getDeliveryCancellationMessage();
      }

      await _sendWhatsAppMessage(
        phoneNumber: destinationPhoneNumber,
        message: message,
      );
    } catch (e) {
      print('Erreur envoi WhatsApp: $e');
      Get.snackbar(
        'Information',
        'Le message WhatsApp n\'a pas pu être envoyé automatiquement',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

// Le problème vient du schéma URL utilisé. Voici les corrections :

  Future<void> _sendWhatsAppMessage({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      // Nettoyer le numéro de téléphone
      String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      // Ajouter le préfixe international si nécessaire (Sénégal: +221)
      if (!cleanNumber.startsWith('221') && cleanNumber.length == 9) {
        cleanNumber = '221$cleanNumber';
      }

      // Encoder le message pour URL
      String encodedMessage = Uri.encodeComponent(message);

      // CORRECTION: Utiliser l'URL web WhatsApp au lieu du schéma whatsapp://
      String whatsappUrl = 'https://wa.me/$cleanNumber?text=$encodedMessage';

      final Uri uri = Uri.parse(whatsappUrl);

      // Lancer l'URL
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      print('WhatsApp ouvert avec succès');
    } catch (e) {
      print('Erreur lors du lancement WhatsApp: $e');

      // Fallback : essayer avec un autre mode de lancement
      try {
        String fallbackUrl = 'https://wa.me/$phoneNumber';
        await launchUrl(
          Uri.parse(fallbackUrl),
          mode: LaunchMode.platformDefault,
        );
      } catch (fallbackError) {
        print('Erreur fallback: $fallbackError');

        // Informer l'utilisateur
        Get.snackbar(
          'WhatsApp',
          'Impossible d\'ouvrir WhatsApp automatiquement',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

// Messages helpers
  String _getDeliveryConfirmationMessage() {
    return '''🚚 Vous allez recevoir un colis !

Un coursier vous l'apportera à votre domicile. Suivez l'évolution de votre colis ici : Lien

📍 De: ${departureAddress.value}
📍 Vers: ${destinationAddress.value}
💰 Prix: ${coursePrice.value} FCFA
🆔 Course: ${courseId.value}

Merci de votre confiance !''';
  }

  String _getDeliveryCancellationMessage() {
    return '''❌ Commande annulée

La livraison de votre colis a été annulée par l'expéditeur.
Aucune action n'est requise de votre part.

📍 De: ${departureAddress.value}
📍 Vers: ${destinationAddress.value}
🆔 Course: ${courseId.value}

Désolé pour la gêne occasionnée.''';
  }

// Méthode helper pour récupérer le numéro du destinataire
  String _getDestinationPhone() {
    // Option 1: Depuis les arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['destinationPhone'] != null) {
      return arguments['destinationPhone'];
    }

    // Option 2: Numéro par défaut ou depuis une base de données
    // Ici vous devriez récupérer le vrai numéro du destinataire
    return '784316538'; // Remplacez par le vrai numéro
  }

  void handleCancellation() {
    // Envoyer message WhatsApp d'annulation
    _sendWhatsAppNotification(isConfirmed: false);

    // Afficher le modal de confirmation d'annulation
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              'Commande annulée',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton(
                onPressed: () {
                  Get.back();
                  Get.offAllNamed('/home');
                },
                child: const Text(
                  'À la Recherche de moto à proximité',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
