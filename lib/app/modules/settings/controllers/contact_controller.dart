import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart'; // Commenté temporairement

class ContactController extends GetxController {
  // Informations de contact de l'entreprise
  static const String phoneNumber = '+221123456789';
  static const String whatsappNumber = '+221123456789';
  static const String emailAddress = 'contact@demnaa.com';
  static const String facebookUrl = 'https://facebook.com/demnaa';
  static const String instagramUrl = 'https://instagram.com/demnaa';
  static const String twitterUrl = 'https://twitter.com/demnaa';
  static const String linkedinUrl = 'https://linkedin.com/company/demnaa';

  // Ouvrir WhatsApp (version temporaire)
  Future<void> openWhatsApp() async {
    _showInfoSnackbar('WhatsApp: $whatsappNumber\nMessage: Assistance disponible 24/7');
  }

  // Passer un appel téléphonique (version temporaire)
  Future<void> makePhoneCall() async {
    _showInfoSnackbar('Téléphone: $phoneNumber\nParlez directement à notre agent');
  }

  // Envoyer un email (version temporaire)
  Future<void> sendEmail() async {
    _showInfoSnackbar('Email: $emailAddress\nNous vous répondrons rapidement');
  }

  // Ouvrir Facebook
  Future<void> openFacebook() async {
    _showInfoSnackbar('Facebook: $facebookUrl');
  }

  // Ouvrir Instagram
  Future<void> openInstagram() async {
    _showInfoSnackbar('Instagram: $instagramUrl');
  }

  // Ouvrir Twitter/X
  Future<void> openTwitter() async {
    _showInfoSnackbar('Twitter: $twitterUrl');
  }

  // Ouvrir LinkedIn
  Future<void> openLinkedIn() async {
    _showInfoSnackbar('LinkedIn: $linkedinUrl');
  }

  // Afficher un message d'information
  void _showInfoSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  // Afficher un message de succès
  void _showSuccessSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        ),
      ),
    );
  }
}