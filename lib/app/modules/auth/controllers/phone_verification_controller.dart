// PhoneVerificationController - Version corrigée pour éviter les erreurs

import 'package:demnaa_front/app/modules/otp_verification/controllers/otp_verification_controller.dart';
import 'package:demnaa_front/app/modules/otp_verification/views/otp_verification_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerificationController extends GetxController {
  // Contrôleurs de texte
  final phoneController = TextEditingController();
  
  // Variables observables
  var selectedCountryCode = '+221'.obs;
  var phoneNumber = ''.obs;
  var isValidating = false.obs;
  var isPhoneValid = false.obs;
  
  // Données de profil reçues depuis ProfileSelection
  var selectedProfileType = ''.obs;
  var profileData = Rxn<Map<String, dynamic>>();
  var isLoginMode = false.obs;

  // Liste des codes pays
  final List<Map<String, String>> countryCodes = [
    {'code': '+221', 'flag': '🇸🇳', 'country': 'Sénégal'},
    {'code': '+33', 'flag': '🇫🇷', 'country': 'France'},
    {'code': '+1', 'flag': '🇺🇸', 'country': 'USA'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+49', 'flag': '🇩🇪', 'country': 'Allemagne'},
  ];

  @override
  void onInit() {
    super.onInit();
    _handleProfileArguments();
    phoneController.addListener(_onPhoneChanged);
  }

  void _handleProfileArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      selectedProfileType.value = arguments['profileType'] ?? 'client';
      profileData.value = arguments['profileData'];
      isLoginMode.value = arguments['isLogin'] ?? false;
    }
  }

  void _onPhoneChanged() {
    phoneNumber.value = phoneController.text;
    _validatePhoneNumber();
  }

  void _validatePhoneNumber() {
    String phone = phoneController.text.replaceAll(' ', '');
    
    if (selectedCountryCode.value == '+221') {
      isPhoneValid.value = phone.length >= 9 && 
                          RegExp(r'^[67]\d{8}$').hasMatch(phone);
    } else {
      isPhoneValid.value = phone.length >= 8 && 
                          RegExp(r'^\d+$').hasMatch(phone);
    }
  }

  void selectCountryCode(String code) {
    selectedCountryCode.value = code;
    _validatePhoneNumber();
  }

  String formatPhoneNumber(String phone) {
    if (selectedCountryCode.value == '+221' && phone.length >= 9) {
      return '${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5, 7)} ${phone.substring(7)}';
    }
    return phone;
  }

  String get pageTitle {
    if (isLoginMode.value) {
      return 'Connexion';
    } else {
      return 'Créer un compte ${_getProfileDisplayName()}';
    }
  }

  String get pageDescription {
    if (isLoginMode.value) {
      return 'Connectez-vous à votre compte pour accéder à tous les services de DemNaa.';
    } else {
      return 'Accédez à votre compte ${_getProfileDisplayName()} en un clic et profitez de tous les avantages de votre application.';
    }
  }

  String _getProfileDisplayName() {
    switch (selectedProfileType.value) {
      case 'client':
        return 'Client';
      case 'driver':
        return 'Conducteur';
      case 'owner':
        return 'Propriétaire';
      default:
        return '';
    }
  }

  Color get profileColor {
    switch (selectedProfileType.value) {
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

  // MÉTHODE DE VALIDATION CORRIGÉE
  Future<void> validatePhoneNumber() async {
    if (!isPhoneValid.value) {
      Get.snackbar(
        'Numéro invalide',
        'Veuillez saisir un numéro de téléphone valide',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isValidating.value = true;

    try {
      String fullPhone = '${selectedCountryCode.value}${phoneController.text.replaceAll(' ', '')}';
      String formattedPhone = '${selectedCountryCode.value} ${formatPhoneNumber(phoneController.text)}';
      
      // Attendre un peu pour simuler l'envoi SMS
      await Future.delayed(Duration(seconds: 1));
      
      // Navigation corrigée avec une vérification supplémentaire
      if (Get.isRegistered<OtpVerificationController>()) {
        Get.delete<OtpVerificationController>();
      }
      
      // Navigation sécurisée
      await Get.off(
        () => const OtpVerificationView(),
        arguments: {
          'phoneNumber': fullPhone,
          'formattedPhone': formattedPhone,
          'profileType': selectedProfileType.value,
          'profileData': profileData.value,
          'isLogin': isLoginMode.value,
        },
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 300),
      );
      
    } catch (e) {
      print('Erreur navigation vers OTP: $e');
      
      // Navigation alternative en cas d'erreur
      try {
        Get.toNamed('/otp-verification', arguments: {
          'phoneNumber': '${selectedCountryCode.value}${phoneController.text.replaceAll(' ', '')}',
          'formattedPhone': '${selectedCountryCode.value} ${formatPhoneNumber(phoneController.text)}',
          'profileType': selectedProfileType.value,
          'profileData': profileData.value,
          'isLogin': isLoginMode.value,
        });
      } catch (e2) {
        print('Erreur navigation alternative: $e2');
        Get.snackbar(
          'Erreur',
          'Impossible d\'accéder à la vérification',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } finally {
      isValidating.value = false;
    }
  }

  void goBackToProfileSelection() {
    Get.back();
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}