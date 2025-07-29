import 'dart:math';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReverseGeocodingController extends GetxController {
  var address = ''.obs; // Pour stocker l'adresse convertie
  final String apiKey = 'pk.731c2831e17b3dabd1e7f5198be'; // Remplace par ta clé API

  @override
  void onInit() {
    super.onInit();
    // Exemple : Appelle reverse geocoding avec des coordonnées par défaut
    fetchAddress(40.748442, -73.985658); // Coordonnées de New York
  }

  Future<void> fetchAddress(double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
          'https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$lat&lon=$lon&format=json&zoom=18'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //afficher
        
        address.value = data['display_name'] ?? 'Adresse non trouvée';
      } else {
        address.value = 'Erreur : ${response.statusCode}';
      }
    } catch (e) {
      address.value = 'Erreur : $e';
    }
  }
}