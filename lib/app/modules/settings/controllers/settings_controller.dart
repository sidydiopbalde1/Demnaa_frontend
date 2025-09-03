import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Observable variables
  var pushNotifications = true.obs;
  var selectedLanguage = 'Français'.obs;
  var selectedTheme = 'Système'.obs;

  // Liste des langues disponibles
  final List<String> availableLanguages = [
    'Français',
    'Anglais', 
    'Espagnol',
    'Arabe',
    'Portugais',
    'Russ'
  ];

  // Liste des thèmes disponibles
  final List<String> availableThemes = [
    'Système',
    'Clair',
    'Sombre'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // Charger les paramètres sauvegardés
  void _loadSettings() {
    // Ici vous pouvez charger les paramètres depuis le stockage local
    // Par exemple avec SharedPreferences ou GetStorage
    // Pour l'instant, on utilise les valeurs par défaut
    print('Paramètres chargés');
  }

  // Basculer les notifications push
  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    _saveSettings();
    
    Get.showSnackbar(
      GetSnackBar(
        message: value 
          ? 'Notifications push activées' 
          : 'Notifications push désactivées',
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Sélectionner une langue
  void selectLanguage(String language) {
    if (selectedLanguage.value != language) {
      selectedLanguage.value = language;
      _saveSettings();
      
      Get.showSnackbar(
        GetSnackBar(
          message: 'Langue changée vers $language',
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF10B981),
          borderRadius: 8,
          margin: const EdgeInsets.all(16),
        ),
      );
      
      // Ici vous pouvez implémenter le changement de langue de l'app
      _changeAppLanguage(language);
    }
  }

  // Changer la langue de l'application
  void _changeAppLanguage(String language) {
    switch (language) {
      case 'Français':
        Get.updateLocale(const Locale('fr', 'FR'));
        break;
      case 'Anglais':
        Get.updateLocale(const Locale('en', 'US'));
        break;
      case 'Espagnol':
        Get.updateLocale(const Locale('es', 'ES'));
        break;
      case 'Arabe':
        Get.updateLocale(const Locale('ar', 'SA'));
        break;
      case 'Portugais':
        Get.updateLocale(const Locale('pt', 'PT'));
        break;
      case 'Russ':
        Get.updateLocale(const Locale('ru', 'RU'));
        break;
    }
  }

  // Naviguer vers les paramètres de langue
  void goToLanguageSettings() {
    Get.toNamed('/language-settings');
  }


    // Naviguer vers les paramètres de thème
  void goToThemeSettings() {
    Get.toNamed('/theme-settings'); 
  }


  // Naviguer vers la politique de confidentialité
  void goToPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const SingleChildScrollView(
          child: Text(
            'Ici se trouvera le contenu de la politique de confidentialité de DemNaa.\n\n'
            'Cette section détaillera comment nous collectons, utilisons et protégeons '
            'vos données personnelles dans le respect de la réglementation en vigueur.\n\n'
            'Nous nous engageons à protéger votre vie privée et à utiliser vos données '
            'de manière transparente et sécurisée.',
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Fermer',
              style: TextStyle(color: Color.fromARGB(255, 230, 72, 9)),
            ),
          ),
        ],
      ),
    );
  }

  // Naviguer vers les conditions d'éligibilité
  void goToTermsConditions() {
    Get.dialog(
      AlertDialog(
        title: const Text('Conditions d\'éligibilité'),
        content: const SingleChildScrollView(
          child: Text(
            'Conditions d\'éligibilité pour utiliser DemNaa :\n\n'
            '• Avoir au moins 18 ans\n'
            '• Posséder un téléphone compatible\n'
            '• Avoir accès à une connexion internet\n'
            '• Accepter les conditions générales d\'utilisation\n'
            '• Fournir des informations exactes lors de l\'inscription\n\n'
            '• Pour les conducteurs :\n'
            '• Posséder un permis de conduire valide\n'
            '• Avoir une assurance véhicule\n'
            '• Réussir la vérification des antécédents\n'
            '• Suivre la formation obligatoire',
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'J\'accepte',
              style: TextStyle(color: Color(0xFF10B981)),
            ),
          ),
        ],
      ),
    );
  }

  // Déconnexion
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Oui',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text(
              'Non',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Effectuer la déconnexion
  void _performLogout() {
   
    Get.showSnackbar(
      GetSnackBar(
        message: 'Déconnexion réussie',
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      ),
    );
    
    // Rediriger vers l'écran de connexion
    Get.offAllNamed('/login'); 
  }

  // Sauvegarder les paramètres
  void _saveSettings() {
 
    print('Paramètres sauvegardés');
    print('Push notifications: ${pushNotifications.value}');
    print('Langue: ${selectedLanguage.value}');
    print('Thème: ${selectedTheme.value}');
  }
  // Convertit le label String en ThemeMode
ThemeMode _themeModeFromString(String s) {
  switch (s) {
    case 'Clair':
      return ThemeMode.light;
    case 'Sombre':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

// Définit le thème à partir d'un ThemeMode (appelé depuis la vue)
void setTheme(ThemeMode theme) {
  final label = theme == ThemeMode.light
      ? 'Clair'
      : theme == ThemeMode.dark
          ? 'Sombre'
          : 'Système';

  // si changement
  if (selectedTheme.value != label) {
    selectedTheme.value = label;
    Get.changeThemeMode(theme); // applique immédiatement le thème global
    _saveSettings();

    Get.showSnackbar(
      GetSnackBar(
        message: 'Thème changé vers $label',
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
}