import 'package:demnaa_front/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class OtpVerificationController extends GetxController {
  final List<TextEditingController> otpControllers = 
      List.generate(5, (index) => TextEditingController());
  
  final List<FocusNode> otpFocusNodes = 
      List.generate(5, (index) => FocusNode());
  
  // Variables observables avec valeurs par défaut sécurisées
  var phoneNumber = ''.obs;
  var formattedPhone = ''.obs;
  var otpCode = ''.obs;
  var isVerifying = false.obs;
  var canResend = false.obs;
  var resendTimer = 60.obs;
  var expirationTimer = 299.obs;
  
  // Données de profil avec gestion null safety
  var selectedProfileType = 'client'.obs; // Valeur par défaut
  var profileData = Rxn<Map<String, dynamic>>();
  var isLoginMode = false.obs;
  
  Timer? _timer;
  Timer? _expirationTimer;

  @override
  void onInit() {
    super.onInit();
    
    try {
      _getArguments();
      _startResendTimer();
      _startExpirationTimer();
      
      // Focus sécurisé
      Future.delayed(Duration(milliseconds: 300), () {
        if (otpFocusNodes.isNotEmpty && otpFocusNodes[0].canRequestFocus) {
          otpFocusNodes[0].requestFocus();
        }
      });
    } catch (e) {
      print('Erreur initialisation OTP: $e');
      // Valeurs de secours
      selectedProfileType.value = 'client';
      phoneNumber.value = '';
      formattedPhone.value = '';
    }
  }


void _getArguments() {
  try {
    final arguments = Get.arguments; // Récupère les arguments

    // VÉRIFICATION DE SÉCURITÉ :
    // On vérifie si les arguments ne sont pas nuls ET s'ils sont bien une Map
    if (arguments != null && arguments is Map<String, dynamic>) {
      // On utilise l'opérateur '??' (null-coalescing) pour fournir une valeur par défaut
      // si la clé n'existe pas ou si la valeur est nulle.
      phoneNumber.value = arguments['phoneNumber']?.toString() ?? '';
      formattedPhone.value = arguments['formattedPhone']?.toString() ?? '';
      selectedProfileType.value = arguments['profileType']?.toString() ?? 'client'; // 'client' comme valeur par défaut

      // Gestion sécurisée pour profileData qui peut être nul
      if (arguments['profileData'] != null) {
        profileData.value = Map<String, dynamic>.from(arguments['profileData']);
      }

      isLoginMode.value = arguments['isLogin'] ?? false; // false par défaut

    } else {
      // Que faire si aucun argument n'est passé ?
      // On initialise les variables avec des valeurs par défaut pour éviter les crashs.
      print("Attention : La page OTP a été ouverte sans arguments.");
      phoneNumber.value = '';
      formattedPhone.value = '';
      selectedProfileType.value = 'client';
      isLoginMode.value = false;
    }

    print('Arguments OTP traités: profileType=${selectedProfileType.value}');

  } catch (e) {
    print('Erreur lors du traitement des arguments OTP: $e');
    // En cas d'erreur imprévue, on met des valeurs par défaut.
    phoneNumber.value = '';
    formattedPhone.value = '';
    selectedProfileType.value = 'client';
    isLoginMode.value = false;
  }
}


  void _startResendTimer() {
    try {
      _timer?.cancel(); // Annuler le timer existant
      canResend.value = false;
      resendTimer.value = 60;
      
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (resendTimer.value > 0) {
          resendTimer.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      });
    } catch (e) {
      print('Erreur timer resend: $e');
    }
  }

  void _startExpirationTimer() {
    try {
      _expirationTimer?.cancel(); // Annuler le timer existant
      expirationTimer.value = 299;
      
      _expirationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (expirationTimer.value > 0) {
          expirationTimer.value--;
        } else {
          timer.cancel();
          _handleExpiration();
        }
      });
    } catch (e) {
      print('Erreur timer expiration: $e');
    }
  }

  void _handleExpiration() {
    try {
      Get.snackbar(
        'Code expiré',
        'Le code de vérification a expiré. Veuillez demander un nouveau code.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      _clearOtpFields();
    } catch (e) {
      print('Erreur gestion expiration: $e');
    }
  }

  void _clearOtpFields() {
    try {
      for (var controller in otpControllers) {
        if (controller.hasListeners) {
          controller.clear();
        }
      }
      otpCode.value = '';
    } catch (e) {
      print('Erreur clear fields: $e');
    }
  }

  String get formattedExpirationTime {
    try {
      int minutes = expirationTimer.value ~/ 60;
      int seconds = expirationTimer.value % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '04:59'; // Valeur par défaut
    }
  }

  void onOtpChanged(String value, int index) {
    try {
      if (index >= otpControllers.length || index >= otpFocusNodes.length) {
        return; // Protection contre les index invalides
      }
      
      if (value.isNotEmpty && value.length == 1) {
        if (index < 4) {
          if (otpFocusNodes[index + 1].canRequestFocus) {
            otpFocusNodes[index + 1].requestFocus();
          }
        } else {
          if (otpFocusNodes[index].canRequestFocus) {
            otpFocusNodes[index].unfocus();
          }
        }
      }
      
      _buildOtpCode();
      
      if (otpCode.value.length == 5) {
        _autoVerify();
      }
    } catch (e) {
      print('Erreur onOtpChanged: $e');
    }
  }

  void _buildOtpCode() {
    try {
      String code = '';
      for (var controller in otpControllers) {
        if (controller.hasListeners) {
          code += controller.text;
        }
      }
      otpCode.value = code;
    } catch (e) {
      print('Erreur build code: $e');
      otpCode.value = '';
    }
  }

  Future<void> _autoVerify() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      verifyOtp();
    } catch (e) {
      print('Erreur auto verify: $e');
    }
  }

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 5) {
      Get.snackbar(
        'Code incomplet',
        'Veuillez saisir le code à 5 chiffres',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (expirationTimer.value <= 0) {
      Get.snackbar(
        'Code expiré',
        'Le code de vérification a expiré. Veuillez demander un nouveau code.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isVerifying.value = true;

    try {
      // Vérifier si AuthService existe
      if (!Get.isRegistered<AuthService>()) {
        Get.put(AuthService(), permanent: true);
      }
      
      final authService = Get.find<AuthService>();
      bool isValid = await authService.verifyPhone(
        phoneNumber.value, 
        otpCode.value,
        selectedProfileType.value,
        profileData.value,
      );
      
      if (isValid) {
        _expirationTimer?.cancel();
        Get.snackbar(
          'Vérification réussie',
          _getSuccessMessage(),
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        
        _navigateBasedOnProfile();
      } else {
        _showErrorAndClearFields();
      }
      
    } catch (e) {
      print('Erreur vérification OTP: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de vérifier le code: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  String _getSuccessMessage() {
    try {
      if (isLoginMode.value) {
        return 'Connexion réussie !';
      } else {
        switch (selectedProfileType.value) {
          case 'client':
            return 'Compte Client créé avec succès';
          case 'driver':
            return 'Compte Conducteur créé avec succès';
          case 'owner':
            return 'Compte Propriétaire créé avec succès';
          default:
            return 'Compte créé avec succès';
        }
      }
    } catch (e) {
      return 'Vérification réussie';
    }
  }

  void _navigateBasedOnProfile() {
    try {
      // Navigation sécurisée
      String route = '/home'; // Route par défaut
      
      switch (selectedProfileType.value) {
        case 'client':
          route = '/home';
          break;
        case 'driver':
          route = '/home'; // ou '/driver-dashboard'
          break;
        case 'owner':
          route = '/home'; // ou '/owner-dashboard'
          break;
      }
      
      Get.offAllNamed(route);
    } catch (e) {
      print('Erreur navigation: $e');
      Get.offAllNamed('/home'); // Navigation de secours
    }
  }

  void _showErrorAndClearFields() {
    try {
      Get.snackbar(
        'Code incorrect',
        'Le code saisi est incorrect. Veuillez réessayer.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      _clearOtpFields();
      
      if (otpFocusNodes.isNotEmpty && otpFocusNodes[0].canRequestFocus) {
        otpFocusNodes[0].requestFocus();
      }
    } catch (e) {
      print('Erreur show error: $e');
    }
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    
    try {
      await Future.delayed(Duration(seconds: 1));
      
      Get.snackbar(
        'Code renvoyé',
        'Un nouveau code a été envoyé au ${formattedPhone.value}',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      _startResendTimer();
      _startExpirationTimer();
      _clearOtpFields();
      
    } catch (e) {
      print('Erreur resend: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de renvoyer le code',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Color get profileColor {
    try {
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
    } catch (e) {
      return Color(0xFF10B981);
    }
  }

  String get profileDisplayName {
    try {
      switch (selectedProfileType.value) {
        case 'client':
          return 'Client';
        case 'driver':
          return 'Conducteur';
        case 'owner':
          return 'Propriétaire';
        default:
          return 'Client';
      }
    } catch (e) {
      return 'Client';
    }
  }

  @override
  void onClose() {
    try {
      _timer?.cancel();
      _expirationTimer?.cancel();
      
      for (var controller in otpControllers) {
        if (controller.hasListeners) {
          controller.dispose();
        }
      }
      
      for (var focusNode in otpFocusNodes) {
        focusNode.dispose();
      }
    } catch (e) {
      print('Erreur onClose: $e');
    }
    
    super.onClose();
  }
}