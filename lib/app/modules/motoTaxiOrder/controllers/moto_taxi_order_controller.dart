import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MotoTaxiOrderController extends GetxController {
  // Observable variables
  var selectedService = 'Moto-taxi'.obs;
  var destinationAddress = '584 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal'.obs;
  final currentLocation = LatLng(14.716677, -17.467686).obs; // Dakar par défaut
  final destinationLocation = Rxn<LatLng>();

  // Variables pour la recherche d'adresse avec API
  var addressSuggestions = <AddressSuggestion>[].obs;
  var isSearching = false.obs;
  Timer? _searchDebounce;

  // Text Controllers
  final addressSearchController = TextEditingController();
  
  MapController? mapController;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _handleNavigationArguments();
    _setDefaultDestination();
    
    // Initialiser avec une recherche par défaut
    addressSearchController.text = 'gran';
    _searchAddresses('gran');
  }

  void _handleNavigationArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      // Si on vient avec un service prédéfini
      if (arguments.containsKey('selectedService')) {
        selectedService.value = arguments['selectedService'];
      }
      
      // Si on vient avec une adresse prédéfinie
      if (arguments.containsKey('destination')) {
        destinationAddress.value = arguments['destination'];
      }
    }
  }

  void _setDefaultDestination() {
    // Définir une destination par défaut comme dans la capture
    destinationLocation.value = LatLng(14.7167, -17.4677); // Position à Dakar
  }

  // Sélectionner un service
  void selectService(String service) {
    selectedService.value = service;
    
    Get.showSnackbar(
      GetSnackBar(
        message: 'Service $service sélectionné',
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      ),
    );
  }

  // Ajouter un arrêt
  void addStop() {
    Get.showSnackbar(
      GetSnackBar(
        message: 'Fonctionnalité d\'ajout d\'arrêt',
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4A90E2),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  // Ouvrir la recherche d'adresse
  void openAddressSearch() {
    // Créer le modal de recherche d'adresse comme dans la capture
    _showAddressSearchModal();
  }

  void _showAddressSearchModal() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00BCD4), // Cyan
              Color(0xFF4A90E2), // Bleu
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header du modal avec champ de recherche
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: addressSearchController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'gran',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // Filtrer les suggestions en temps réel
                          _filterSuggestions(value);
                        },
                        onSubmitted: (value) {
                          _searchAddress(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Liste des suggestions d'adresses
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => Column(
                  children: _buildFilteredSuggestions(),
                )),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Recherche d'adresses avec l'API Nominatim
  Future<void> _searchAddresses(String query) async {
    if (query.length < 2) {
      addressSuggestions.clear();
      return;
    }

    isSearching.value = true;

    try {
      // Ajouter "Dakar" à la requête pour cibler la ville
      // final searchQuery = '$query Dakar Sénégal';
      
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5&countrycodes=sn'
        ),  
        headers: {
          'User-Agent': 'DemnaaApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final suggestions = data.map((item) => AddressSuggestion(
          displayName: item['display_name'] ?? '',
          lat: double.parse(item['lat']),
          lon: double.parse(item['lon']),
          address: _formatAddress(item),
        )).toList();

        addressSuggestions.value = suggestions;
      }
    } catch (e) {
      print('Erreur lors de la recherche d\'adresses: $e');
      // En cas d'erreur, afficher des suggestions par défaut
      _setDefaultSuggestions(query);
    } finally {
      isSearching.value = false;
    }
  }

  // Suggestions par défaut si l'API échoue
  void _setDefaultSuggestions(String query) {
    final defaultSuggestions = [
      '584 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal',
      '1115 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal',
      '547 Usine Grand-Dakar, Dakar Grand-Dakar, Sénégal',
      '584 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal',
      '594 Usine Grand-Dakar, Dakar Grand-Dakar, Sénégal',
      '584 Usine Grand-Dakar, Dakar Grand-Dakar, Sénégal',
    ];

    addressSuggestions.value = defaultSuggestions
        .where((addr) => addr.toLowerCase().contains(query.toLowerCase()))
        .map((addr) => AddressSuggestion(
            displayName: addr,
            lat: 14.716677,
            lon: -17.467686,
            address: addr,
        ))
        .toList();
  }

  String _formatAddress(Map<String, dynamic> item) {
    final address = item['address'] ?? {};
    List<String> parts = [];

    // Priorité aux éléments les plus spécifiques
    if (address['house_number'] != null && address['road'] != null) {
      parts.add('${address['house_number']} ${address['road']}');
    } else if (address['road'] != null) {
      parts.add(address['road']);
    }
    
    if (address['suburb'] != null) parts.add(address['suburb']);
    if (address['city'] != null) parts.add(address['city']);
    if (address['state'] != null) parts.add(address['state']);
    if (address['country'] != null) parts.add(address['country']);

    return parts.isNotEmpty ? parts.join(', ') : item['display_name'] ?? '';
  }

  // Filtrer les suggestions basées sur l'input utilisateur avec debouncing
  void _filterSuggestions(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _searchAddresses(query);
    });
  }

  // Rechercher une adresse
  void _searchAddress(String query) {
    if (query.isNotEmpty) {
      destinationAddress.value = query;
      Get.back();
      _showSelectionFeedback('Recherche effectuée pour: $query');
    }
  }

  List<Widget> _buildFilteredSuggestions() {
    List<Widget> widgets = [];
    
    for (int i = 0; i < addressSuggestions.length; i++) {
      // Ajouter l'item de suggestion
      widgets.add(_buildSuggestionItem(addressSuggestions[i]));
      
      // Ajouter la ligne pointillée sauf pour le dernier élément
      if (i < addressSuggestions.length - 1) {
        widgets.add(_buildDottedLine());
      }
    }
    
    return widgets;
  }

  Widget _buildSuggestionItem(AddressSuggestion suggestion) {
    return GestureDetector(
      onTap: () {
        destinationAddress.value = suggestion.address;
        destinationLocation.value = LatLng(suggestion.lat, suggestion.lon);
        Get.back();
        _showSelectionFeedback('Destination mise à jour');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Row(
          children: [
            // Point blanc à gauche
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Texte de l'adresse
            Expanded(
              child: Text(
                suggestion.address,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDottedLine() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          const SizedBox(width: 24), // Alignement avec le texte
          Expanded(
            child: Container(
              height: 1,
              child: CustomPaint(
                painter: DottedLinePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Raccourcis (Domicile, Bureau, etc.)
  void selectShortcut(String shortcutType) {
    switch (shortcutType) {
      case 'home':
        destinationAddress.value = 'Domicile - Grand Dakar, Dakar';
        break;
      case 'work':
        destinationAddress.value = 'Bureau - Plateau, Dakar';
        break;
      case 'places':
        _showPlacesList();
        return;
      case 'recent':
        _showRecentPlaces();
        return;
    }
    
    _showSelectionFeedback('Destination définie');
  }

  void _showPlacesList() {
    Get.snackbar(
      'Lieux',
      'Liste des lieux favoris',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4A90E2),
      colorText: Colors.white,
    );
  }

  void _showRecentPlaces() {
    Get.snackbar(
      'Récents',
      'Adresses récemment utilisées',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4A90E2),
      colorText: Colors.white,
    );
  }

  // Commander la course
  Future<void> commander() async {
    if (destinationAddress.value == '584 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal' ||
        destinationAddress.value.isEmpty) {
      Get.snackbar(
        'Attention',
        'Veuillez sélectionner une destination',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Simulation de la commande
    Get.showSnackbar(
      GetSnackBar(
        message: 'Recherche d\'un conducteur ${selectedService.value}...',
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
      ),
    );

    // Attendre 2 secondes puis naviguer vers le suivi
    await Future.delayed(const Duration(seconds: 2));
    
    Get.toNamed('/ride-tracking', arguments: {
      'service': selectedService.value,
      'destination': destinationAddress.value,
      'pickup': currentLocation.value,
    });
  }

  // Tap sur la carte
  void onMapTap(LatLng point) {
    destinationLocation.value = point;
    currentLocation.value = point;
    
    // Géocodage inverse pour obtenir l'adresse
    _reverseGeocode(point);
  }

  // Géocodage inverse pour obtenir l'adresse depuis les coordonnées
  Future<void> _reverseGeocode(LatLng point) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?'
          'format=json&'
          'lat=${point.latitude}&'
          'lon=${point.longitude}&'
          'zoom=18&'
          'addressdetails=1'
        ),
        headers: {
          'User-Agent': 'DemnaaApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = _formatAddress(data);
        destinationAddress.value = address;
        _showSelectionFeedback('Nouvelle destination définie');
      }
    } catch (e) {
      print('Erreur lors du géocodage inverse: $e');
    }
  }

  // String _formatAddress(Map<String, dynamic> data) {
  //   final address = data['address'] ?? {};
  //   List<String> parts = [];
    
  //   if (address['road'] != null) parts.add(address['road']);
  //   if (address['suburb'] != null) parts.add(address['suburb']);
  //   if (address['city'] != null) parts.add(address['city']);
  //   if (address['country'] != null) parts.add(address['country']);
    
  //   return parts.isNotEmpty ? parts.join(', ') : data['display_name'] ?? '';
  // }

  void _showSelectionFeedback(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF10B981),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      ),
    );
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    addressSearchController.dispose();
    super.onClose();
  }
}

// Classe pour dessiner les lignes pointillées
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5;

    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Classe pour les suggestions d'adresses
class AddressSuggestion {
  final String displayName;
  final double lat;
  final double lon;
  final String address;

  AddressSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.address,
  });
}