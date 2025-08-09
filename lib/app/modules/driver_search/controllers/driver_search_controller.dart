import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverSearchController extends GetxController {
  // Text Controllers
  final customReasonController = TextEditingController();

  // Observable variables
  var selectedReason = Rxn<String>();
  var selectedContact = Rxn<String>();
  var selectedWait = Rxn<String>();
  var selectedSignal = Rxn<String>();
  var isSending = false.obs;

  final List<String> reasons = [
    "Le conducteur a mis trop de temps à arriver",
    "Le conducteur est sur un mauvais itinéraire",
    "Je n'ai pas pu joindre le conducteur",
    "Le prix est trop élevé",
    "La moto ne correspond pas à ce que j'attendais",
    "Le conducteur a annulé sans prévenir",
    "Autre"
  ];

  final List<String> waitTimes = [
    "Moins de 5 minutes",
    "5 à 10 minutes",
    "Plus de 10 minutes"
  ];

  final List<String> yesNoOptions = ["Oui", "Non"];

  // Computed property pour vérifier si le formulaire est complet
  bool get isFormComplete {
    bool basicComplete = selectedReason.value != null &&
                        selectedContact.value != null &&
                        selectedWait.value != null &&
                        selectedSignal.value != null;
    
    if (selectedReason.value == "Autre") {
      return basicComplete && customReasonController.text.trim().isNotEmpty;
    }
    
    return basicComplete;
  }

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  void _setupListeners() {
    // Écouter les changements du text controller pour mettre à jour l'UI
    customReasonController.addListener(() {
      update(); // Forcer la mise à jour pour isFormComplete
    });
  }

  // Sélectionner une raison
  void selectReason(String reason) {
    selectedReason.value = reason;
    
    // Clear custom reason if not "Autre"
    if (reason != "Autre") {
      customReasonController.clear();
    }
  }

  // Sélectionner si contacté le conducteur
  void selectContact(String contact) {
    selectedContact.value = contact;
  }

  // Sélectionner le temps d'attente
  void selectWaitTime(String waitTime) {
    selectedWait.value = waitTime;
  }

  // Sélectionner si signaler le conducteur
  void selectSignal(String signal) {
    selectedSignal.value = signal;
  }

  // Envoyer le formulaire
  Future<void> sendForm() async {
    if (!isFormComplete) {
      Get.snackbar(
        'Formulaire incomplet',
        'Veuillez répondre à toutes les questions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isSending.value = true;

    try {
      // Préparer les données du formulaire
      final Map<String, String> formData = {
        'reason': selectedReason.value == "Autre" 
            ? customReasonController.text.trim() 
            : selectedReason.value!,
        'contacted_driver': selectedContact.value!,
        'wait_time': selectedWait.value!,
        'report_driver': selectedSignal.value!,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Simulation d'envoi API
      await Future.delayed(const Duration(seconds: 2));

      // Log pour debug (à remplacer par un vrai appel API)
      print('Formulaire envoyé: $formData');

      // Afficher un message de succès
      Get.snackbar(
        'Merci pour votre retour',
        'Votre feedback a été envoyé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Naviguer vers l'écran d'accueil ou fermer
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/home'); // Retourner à l'accueil

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer votre retour. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  // Fermer l'écran
  void closeScreen() {
    Get.back();
  }

  // Réinitialiser le formulaire
  void resetForm() {
    selectedReason.value = null;
    selectedContact.value = null;
    selectedWait.value = null;
    selectedSignal.value = null;
    customReasonController.clear();
  }

  @override
  void onClose() {
    customReasonController.dispose();
    super.onClose();
  }
}