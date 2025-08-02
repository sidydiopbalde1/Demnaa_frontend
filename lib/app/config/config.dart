class Config {
  // === MODIFIE ICI POUR CHOISIR TON BACKEND ===
  
  // 🔧 URLs de développement (local)
  static const String _apiUrlDev = "http://192.168.1.19:3001"; // Votre IP locale

  
  // 🚀 URL de production (votre backend déployé)
  //static const String _apiUrlProd = "https://votre-backend.herokuapp.com"; // Remplacez par votre URL
   static const String _apiUrlProd = "https://demmna-backend-1-0-6.onrender.com/api"; // Ou Render
 

  // 🔄 Contrôle de l'environnement
  // Dé-commentez une de ces lignes pour forcer un environnement :
   static bool get isProduction => true; // ✅ Toujours production
  // static bool get isProduction => false; // ✅ Toujours développement
  // static bool get isProduction => const bool.fromEnvironment(
  //   'dart.vm.product',
  // ); // ✅ Automatique (release=prod, debug=dev)

  static String getApiUrl() {
    final url = isProduction ? _apiUrlProd : _apiUrlDev;
    print('🌐 URL API utilisée: $url (${isProduction ? "PRODUCTION" : "DÉVELOPPEMENT"})');
    return url;
  }

  // === API ENDPOINTS ===
  static const String apiVersion = "v1";
  static const String authEndpoint = "/auth";
  static const String uploadEndpoint = "/upload";
  static const String appointmentEndpoint = "/appointments";
  static const String servicesEndpoint = "/services/"; // 🆕 Pour vos services
  static const String favoritePlacesEndpoint = "/favorite-places"; // 🆕 Pour les lieux favoris

  // === STRIPE CONFIGURATION ===
  static const String _stripePublishableKeyDev =
      'pk_test_51RLKZj061cUZkWmHT9cche0aTrHno6ZBZ4VwpQpdf3VWIFHQxpzjNlUwsiJeXUjxPuhyltHG7k7dNrWgprEiGuOt00ZRaQxNe4';
  static const String _stripePublishableKeyProd =
      'pk_live_VOTRE_CLE_LIVE_ICI';

  static String getStripePublishableKey() {
    return isProduction ? _stripePublishableKeyProd : _stripePublishableKeyDev;
  }


  
  // Obtenir l'URL complète d'un endpoint
  static String getFullEndpoint(String endpoint) {
    return "${getApiUrl()}$endpoint";
  }

  // Vérifier si on est en développement
  static bool get isDevelopment => !isProduction;

  // Obtenir les headers par défaut
  static Map<String, String> get defaultHeaders => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // Obtenir les headers avec token
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    "Authorization": "Bearer $token",
  };
}