import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get instance {
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }
    return Get.find<AuthService>();
  }
  
  // Variables observables avec valeurs par défaut sécurisées
  var isLoggedIn = false.obs;
  var userPhone = ''.obs;
  var userProfileType = 'client'.obs; // Valeur par défaut
  var profileData = Rxn<Map<String, dynamic>>();
  
  @override
  void onInit() {
    super.onInit();
    print('AuthService initialisé');
    _loadSavedAuthState();
  }

  Future<void> _loadSavedAuthState() async {
    try {
      // Ici vous pourriez charger l'état depuis SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
      // userPhone.value = prefs.getString('userPhone') ?? '';
      // userProfileType.value = prefs.getString('userProfileType') ?? 'client';
      
      print('État auth chargé: ${isLoggedIn.value}');
    } catch (e) {
      print('Erreur chargement auth state: $e');
      // Valeurs par défaut en cas d'erreur
      isLoggedIn.value = false;
      userPhone.value = '';
      userProfileType.value = 'client';
    }
  }
  
  Future<bool> verifyPhone(String phone, String otp, String profileType, Map<String, dynamic>? profile) async {
    try {
      print('Vérification OTP: $otp pour profil: $profileType');
      
      // Validation des paramètres d'entrée
      if (phone.isEmpty || otp.isEmpty || profileType.isEmpty) {
        print('Paramètres manquants pour la vérification');
        return false;
      }
      
      // Simulation d'appel API
      await Future.delayed(Duration(seconds: 2));
      
      // Codes de test valides pour 5 chiffres
      final validCodes = ['12345', '00000', '11111', '54321', '99999'];
      
      if (validCodes.contains(otp)) {
        isLoggedIn.value = true;
        userPhone.value = phone;
        userProfileType.value = profileType;
        
        // Gestion sécurisée de profileData
        if (profile != null) {
          profileData.value = Map<String, dynamic>.from(profile);
        } else {
          profileData.value = <String, dynamic>{};
        }
        
        await _saveAuthState();
        return true;
      }
      
      print('Code OTP invalide: $otp');
      return false;
      
    } catch (e) {
      print('Erreur vérification: $e');
      return false;
    }
  }
  
  Future<void> _saveAuthState() async {
    try {
      print('Sauvegarde état auth: ${userPhone.value} - ${userProfileType.value}');
      
      // Sauvegarder dans SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);
      // await prefs.setString('userPhone', userPhone.value);
      // await prefs.setString('userProfileType', userProfileType.value);
      
      // Si profileData contient des données, les sauvegarder aussi
      if (profileData.value != null && profileData.value!.isNotEmpty) {
        // await prefs.setString('profileData', jsonEncode(profileData.value));
      }
      
    } catch (e) {
      print('Erreur sauvegarde: $e');
    }
  }
  
  String get welcomeMessage {
    try {
      switch (userProfileType.value) {
        case 'client':
          return 'Commandez vos courses en toute simplicité';
        case 'driver':
          return 'Prêt à accepter des courses ?';
        case 'owner':
          return 'Gérez votre flotte efficacement';
        default:
          return 'Bienvenue dans DemNaa';
      }
    } catch (e) {
      return 'Bienvenue dans DemNaa';
    }
  }
  
  Color get profileColor {
    try {
      switch (userProfileType.value) {
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
  
  IconData get profileIcon {
    try {
      switch (userProfileType.value) {
        case 'client':
          return Icons.person;
        case 'driver':
          return Icons.person_4;
        case 'owner':
          return Icons.motorcycle;
        default:
          return Icons.person;
      }
    } catch (e) {
      return Icons.person;
    }
  }
  
  String get userDisplayName {
    try {
      if (userPhone.value.isNotEmpty && userPhone.value.length >= 4) {
        return 'Utilisateur ${userPhone.value.substring(userPhone.value.length - 4)}';
      }
      return 'Utilisateur';
    } catch (e) {
      return 'Utilisateur';
    }
  }
  
  // Méthode pour vérifier si l'utilisateur est connecté
  bool get isUserLoggedIn {
    try {
      return isLoggedIn.value && userPhone.value.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logout() async {
    try {
      // Nettoyer les données
      isLoggedIn.value = false;
      userPhone.value = '';
      userProfileType.value = 'client';
      profileData.value = null;
      
      // Supprimer les données sauvegardées
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
      
      // Nettoyer les contrôleurs GetX
      Get.reset();
      
      // Rediriger vers la sélection de profil
      Get.offAllNamed('/profil-selection');
      
    } catch (e) {
      print('Erreur déconnexion: $e');
      // En cas d'erreur, forcer la redirection
      Get.offAllNamed('/profil-selection');
    }
  }
  
  // Méthode de debug pour afficher l'état
  void debugAuthState() {
    print('=== État AuthService ===');
    print('Connecté: ${isLoggedIn.value}');
    print('Téléphone: ${userPhone.value}');
    print('Type profil: ${userProfileType.value}');
    print('Données profil: ${profileData.value}');
    print('========================');
  }
}