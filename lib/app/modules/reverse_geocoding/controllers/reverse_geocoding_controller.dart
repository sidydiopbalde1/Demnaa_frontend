import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class ReverseGeocodingController extends GetxController {
  var address = ''.obs;
  final Rx<LatLng> center = LatLng(14.716677, -17.467686).obs; // Dakar
  var searchResults = <Map<String, dynamic>>[].obs; // Liste des résultats de recherche
  late MapController mapController; // Contrôleur pour flutter_map

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
  }

  // Méthode pour mettre à jour la position et la carte
  void updateLocation(double lat, double lng, {bool animate = true}) {
    center.value = LatLng(lat, lng);
    if (animate) {
      mapController.move(LatLng(lat, lng), 14.0);
    } else {
      mapController.move(LatLng(lat, lng), mapController.camera.zoom);
    }
  }

  // Recherche de localités
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'MyFlutterApp/1.0 (your.email@example.com)', // Remplace par ton email
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        searchResults.value = data.cast<Map<String, dynamic>>();
      } else {
        searchResults.clear();
        address.value = 'Erreur: ${response.statusCode}';
      }
    } catch (e) {
      searchResults.clear();
      address.value = 'Erreur: $e';
    }
  }

  // Sélectionner un résultat pour mettre à jour la carte
  void selectLocation(Map<String, dynamic> result) {
    final lat = double.parse(result['lat']);
    final lon = double.parse(result['lon']);
    updateLocation(lat, lon);
    address.value = result['display_name'];
    searchResults.clear(); // Efface les résultats après sélection
  }

  // Reverse geocoding
  Future<void> fetchAddress(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'MyFlutterApp/1.0 (your.email@example.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        address.value = data['display_name'] ?? 'Adresse introuvable';
      } else {
        address.value = 'Erreur: ${response.statusCode}';
      }
    } catch (e) {
      address.value = 'Erreur: $e';
    }
  }
}