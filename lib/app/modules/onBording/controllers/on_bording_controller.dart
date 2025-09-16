import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

// 1. Contrôleur pour le système d'inscription
class OnboardingController extends GetxController {
  // Étapes du processus
  var currentStep = 0.obs;
  final int totalSteps = 4;
  
  // Données utilisateur
  var firstName = ''.obs;
  var lastName = ''.obs;
  var selectedFunction = ''.obs;
  var selectedLocation = ''.obs;
  var selectedGender = ''.obs;
  var studentCard = Rxn<File>();
  var enrollmentCertificate = Rxn<File>();
  
  // Listes des options
  final List<String> functions = [
    'Professionnels',
    'Étudiant /Élève',
    'Autre'
  ];
  
  final List<String> locations = [
    'Dakar',
    'Thiès',
    'Ziguinchor',
    'Kaolack',
    'Saint-Louis',
    'Tambacounda'
  ];
  
  // Variables de validation
  var isLoading = false.obs;
  
  // Données de profil reçues depuis OTP
  var profileType = 'client'.obs;
  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
  }

  void _getArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      profileType.value = arguments['profileType'] ?? 'client';
      phoneNumber.value = arguments['phoneNumber'] ?? '';
    }
  }

  // Navigation entre les étapes
  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
    }
  }

  // Validation des étapes
  bool canProceedFromStep(int step) {
    switch (step) {
      case 1: // Formulaire de base
        return firstName.value.isNotEmpty && 
               lastName.value.isNotEmpty && 
               selectedFunction.value.isNotEmpty &&
               selectedLocation.value.isNotEmpty &&
               selectedGender.value.isNotEmpty;
      case 2: // Documents étudiant
        if (selectedFunction.value == 'Étudiant /Élève') {
          return studentCard.value != null || enrollmentCertificate.value != null;
        }
        return true;
      default:
        return true;
    }
  }

  // Sélection des valeurs
  void selectFunction(String function) {
    selectedFunction.value = function;
  }

  void selectLocation(String location) {
    selectedLocation.value = location;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Upload de documents
  Future<void> uploadStudentCard() async {
    try {
      // Simulation d'upload de fichier
      await Future.delayed(Duration(seconds: 1));
      // En réalité, vous utiliseriez image_picker
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      Get.snackbar(
        'Document ajouté',
        'Carte étudiant téléchargée avec succès',
        backgroundColor: Color(0xFF10B981).withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le document',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> uploadEnrollmentCertificate() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      
      Get.snackbar(
        'Document ajouté',
        'Certificat d\'inscription téléchargé avec succès',
        backgroundColor: Color(0xFF10B981).withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le document',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
   // Méthodes de mise à jour SÉCURISÉES
  void updateFirstName(String name) {
    try {
      firstName.value = name;
      print('Prénom mis à jour: $name');
    } catch (e) {
      print('Erreur mise à jour prénom: $e');
    }
  }

  void updateLastName(String name) {
    try {
      lastName.value = name;
      print('Nom mis à jour: $name');
    } catch (e) {
      print('Erreur mise à jour nom: $e');
    }
  }

  // Finaliser l'inscription
  Future<void> completeOnboarding() async {
    isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 2));
      
      // Sauvegarder les données utilisateur
      final userData = {
        'firstName': firstName.value,
        'lastName': lastName.value,
        'function': selectedFunction.value,
        'location': selectedLocation.value,
        'gender': selectedGender.value,
        'profileType': profileType.value,
        'phone': phoneNumber.value,
        'hasStudentCard': studentCard.value != null,
        'hasEnrollmentCert': enrollmentCertificate.value != null,
      };
      
      print('Données utilisateur complétées: $userData');
      
      Get.snackbar(
        'Inscription terminée',
        'Votre profil a été créé avec succès !',
        backgroundColor: Color(0xFF10B981).withOpacity(0.8),
        colorText: Colors.white,
      );
      
      // Navigation vers la page d'accueil
      Get.offAllNamed('/home');
      
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de finaliser l\'inscription',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Color get profileColor {
    switch (profileType.value) {
      case 'client':
        return Color(0xFF10B981);
      case 'driver':
        return Color(0xFF3B82F6);
      case 'owner':
        return Color(0xFF6366F1);
      default:
        return Color(0xFF10B981);
    }
  }
}