import 'package:demnaa_front/app/models/profil_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 1. Contrôleur pour la sélection de profil
class ProfileSelectionController extends GetxController {
  // Types de profils disponibles
  final List<ProfileType> profileTypes = [
    ProfileType(
      id: 'client',
      title: 'Client',
      description: 'Commandez des courses et services',
      icon: Icons.person,
      color: Color(0xFF10B981),
      isActive: true,
    ),
    ProfileType(
      id: 'driver',
      title: 'Conducteur',
      description: 'Acceptez des courses et gagnez de l\'argent',
      icon: Icons.person_4,
      color: Color(0xFF3B82F6),
      isActive: false,
    ),
    ProfileType(
      id: 'owner',
      title: 'Propriétaire de motos',
      description: 'Gérez votre flotte de véhicules',
      icon: Icons.motorcycle,
      color: Color(0xFF6366F1),
      isActive: false,
    ),
  ];

  // Profil sélectionné (Client par défaut)
  var selectedProfileId = 'client'.obs;

  // Sélectionner un profil
  void selectProfile(String profileId) {
    selectedProfileId.value = profileId;
  }

  // Obtenir le profil sélectionné
  ProfileType get selectedProfile {
    return profileTypes.firstWhere((profile) => profile.id == selectedProfileId.value);
  }

  // Continuer vers la vérification téléphone
  void continueToPhoneVerification() {
    // Sauvegarder le type de profil sélectionné
    Get.toNamed('/on-bording', arguments: {
      'profileType': selectedProfileId.value,
      'profileData': selectedProfile.toMap(),
    });
  }

  // Se connecter avec un compte existant
  void loginWithPhone() {
    Get.toNamed('/phone-verification', arguments: {
      'isLogin': true,
      'profileType': selectedProfileId.value,
    });
  }
  //creer un compte
  void createAccount() {
    Get.toNamed('/on-bording', arguments: {
      'isLogin': false,
      'profileType': selectedProfileId.value,
    });
  }
}