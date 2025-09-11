import 'package:url_launcher/url_launcher.dart';

// Service WhatsApp pour gérer l'envoi de messages
class WhatsAppService {
  // Envoyer un message WhatsApp
  static Future<void> sendWhatsAppMessage({
    required String phoneNumber,
    required String message,
  }) async {
    // Nettoyer le numéro de téléphone (enlever espaces, +, etc.)
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Ajouter le préfixe international si nécessaire (Sénégal: +221)
    if (!cleanNumber.startsWith('221') && cleanNumber.length == 9) {
      cleanNumber = '221$cleanNumber';
    }
    
    // Encoder le message pour URL
    String encodedMessage = Uri.encodeComponent(message);
    
    // Construire l'URL WhatsApp
    String whatsappUrl = 'https://wa.me/$cleanNumber?text=$encodedMessage';
    
    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Impossible d\'ouvrir WhatsApp';
      }
    } catch (e) {
      print('Erreur WhatsApp: $e');
      // Fallback: ouvrir WhatsApp sans message pré-rempli
      String fallbackUrl = 'https://wa.me/$cleanNumber';
      if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    }
  }
  
  // Message pour livraison confirmée
  static String getDeliveryConfirmationMessage({
    required String departure,
    required String destination,
    required int price,
    required String courseId,
  }) {
    return '''🚚 Vous allez recevoir un colis !

Un coursier vous l'apportera à votre domicile. Suivez l'évolution de votre colis ici : Lien

📍 De: $departure
📍 Vers: $destination
💰 Prix: $price FCFA
🆔 Course: $courseId

Merci de votre confiance !''';
  }
  
  // Message pour livraison annulée
  static String getDeliveryCancellationMessage({
    required String departure,
    required String destination,
    required String courseId,
  }) {
    return '''❌ Commande annulée

La livraison de votre colis a été annulée par l'expéditeur.
Aucune action n'est requise de votre part.

📍 De: $departure
📍 Vers: $destination
🆔 Course: $courseId

Désolé pour la gêne occasionnée.''';
  }
}
