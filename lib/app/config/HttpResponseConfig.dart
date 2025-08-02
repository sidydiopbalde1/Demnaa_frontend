class HttpResponseConfig {
  static const Map<int, Map<String, dynamic>> responseMessages = {
    200: {'status': 'success', 'message': 'Opération réussie'},
    201: {'status': 'success', 'message': 'Ressource créée avec succès'},
    400: {'status': 'error', 'message': 'Requête invalide'},
    401: {'status': 'error', 'message': 'Non autorisé'},
    403: {'status': 'error', 'message': 'Accès interdit'},
    404: {'status': 'error', 'message': 'Ressource non trouvée'},
    500: {'status': 'error', 'message': 'Erreur interne du serveur'},
    409: {'status': 'error', 'message': 'Conflit détecté'},
  };

  // Méthode pour obtenir la configuration de la réponse par code d'état
  static Map<String, dynamic> getResponseConfig(int statusCode) {
    return responseMessages[statusCode] ??
        {'status': 'error', 'message': 'Erreur inconnue'};
  }
}