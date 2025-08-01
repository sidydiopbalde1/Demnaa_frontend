import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class ReverseGeocodingController extends GetxController {
  var address = ''.obs;
  final Rx<LatLng> center = LatLng(14.716677, -17.467686).obs; // Dakar
  var searchResults = <Map<String, dynamic>>[].obs; // Liste des résultats de recherche
  MapController? mapController; // Nullable pour éviter les erreurs
  Timer? _debounce; // Pour limiter les requêtes

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  // Méthode pour mettre à jour la position et la carte
  void updateLocation(double lat, double lng, {bool animate = true}) {
    center.value = LatLng(lat, lng);
    // Vérifier que le contrôleur existe avant de l'utiliser
    if (mapController != null) {
      try {
        if (animate) {
          mapController!.move(LatLng(lat, lng), 14.0);
        } else {
          mapController!.move(LatLng(lat, lng), mapController!.camera.zoom);
        }
      } catch (e) {
        print('Erreur lors du déplacement de la carte: $e');
        // Recréer le contrôleur si nécessaire
        mapController = MapController();
      }
    }
  }

  // Recherche de localités avec debounce
  void searchLocation(String query) {
    // Annuler la recherche précédente
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // Attendre 500ms avant de lancer la recherche
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  // Effectuer la recherche
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5&countrycodes=sn', // Limité au Sénégal pour réduire les résultats
      );

      final response = await http.get(url, headers: {
        'User-Agent': ',ewsdb191@gmail.com', // Remplace par ton email
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        searchResults.value = data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 429) {
        searchResults.clear();
        address.value = 'Trop de requêtes. Veuillez patienter...';
        // Attendre 2 secondes avant de permettre une nouvelle recherche
        await Future.delayed(const Duration(seconds: 2));
        address.value = '';
      } else {
        searchResults.clear();
        address.value = 'Erreur: ${response.statusCode}';
      }
    } catch (e) {
      searchResults.clear();
      address.value = 'Erreur de connexion: $e';
    }
  }

  // Sélectionner un résultat pour mettre à jour la carte
  void selectLocation(Map<String, dynamic> result) {
    final lat = double.parse(result['lat']);
    final lon = double.parse(result['lon']);
    
    // Mettre à jour le centre sans animer pour éviter les erreurs
    center.value = LatLng(lat, lon);
    address.value = result['display_name'];
    searchResults.clear(); // Efface les résultats après sélection
    
    // Déplacer la carte de manière sécurisée
    if (mapController != null) {
      try {
        mapController!.move(LatLng(lat, lon), 14.0);
      } catch (e) {
        print('Erreur lors de la sélection: $e');
      }
    }
  }

  // Reverse geocoding avec limitation de taux
  Future<void> fetchAddress(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'DemnaaApp/1.0 (contact@demnaa.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        address.value = data['display_name'] ?? 'Adresse introuvable';
      } else if (response.statusCode == 429) {
        address.value = 'Service temporairement indisponible';
      } else {
        address.value = 'Erreur: ${response.statusCode}';
      }
    } catch (e) {
      address.value = 'Erreur: $e';
    }
  }
}