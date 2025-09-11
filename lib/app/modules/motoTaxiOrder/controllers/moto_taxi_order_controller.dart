import 'package:demnaa_front/app/models/services_model.dart';
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
  var destinationAddress = '584 Usine Grand-Dakar, Dakar Grand-Dakar'.obs;
  final currentLocation = LatLng(14.716677, -17.467686).obs;
  final destinationLocation = Rxn<LatLng>();
  var selectedServiceModel = Rxn<ServiceModel>();

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
    
    // Initialisation sécurisée du MapController
    try {
      mapController = MapController();
    } catch (e) {
      print('Erreur MapController: $e');
      mapController = null;
    }
    
    _handleNavigationArguments();
    _setDefaultDestination();
    
    // NE PAS faire de recherche automatique pour éviter les erreurs
    addressSearchController.text = '';
  }

  void _handleNavigationArguments() {
    try {
      final arguments = Get.arguments as Map<String, dynamic>?;
      
      if (arguments != null) {
        // Service prédéfini
        if (arguments.containsKey('selectedService')) {
          final service = arguments['selectedService'];
          if (service != null) {
            selectedService.value = service.toString();
          }
        }
        
        // Adresse prédéfinie
        if (arguments.containsKey('destination')) {
          final destination = arguments['destination'];
          if (destination != null) {
            destinationAddress.value = destination.toString();
          }
        }
      }
    } catch (e) {
      print('Erreur arguments: $e');
      selectedService.value = 'Moto-taxi';
    }
  }

  void _setDefaultDestination() {
    destinationLocation.value = LatLng(14.7167, -17.4677);
  }

  // Sélectionner un service
  void selectService(String service) {
    try {
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
    } catch (e) {
      print('Erreur selectService: $e');
    }
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
              Color(0xFF00BCD4),
              Color(0xFF4A90E2),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header du modal
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
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
                          hintText: 'Rechercher une adresse...',
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
            
            // Liste des suggestions
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
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5&countrycodes=sn'
        ),
        headers: {'User-Agent': 'DemnaaApp/1.0'},
      ).timeout(Duration(seconds: 5));

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
      print('Erreur recherche adresses: $e');
      _setDefaultSuggestions(query);
    } finally {
      isSearching.value = false;
    }
  }

  // Suggestions par défaut
  void _setDefaultSuggestions(String query) {
    final defaultSuggestions = [
      '584 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal',
      '1115 Usine Grand-Dakar, Dakar Grand-Dakar, Dakar, Sénégal',
      '547 Usine Grand-Dakar, Dakar Grand-Dakar, Sénégal',
      '594 Usine Grand-Dakar, Dakar Grand-Dakar, Sénégal',
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

  void _filterSuggestions(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _searchAddresses(query);
    });
  }

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
      widgets.add(_buildSuggestionItem(addressSuggestions[i]));
      
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
            // Icône de localisation au lieu de l'asset manquant
            Container(
              width: 20,
              height: 20,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
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
          const SizedBox(width: 24),
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

  // Raccourcis
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

  // CORRECTION MAJEURE : Commander avec logique corrigée
  Future<void> commander() async {
    try {
      // Validation CORRECTE
      if (destinationAddress.value == '584 Usine Grand-Dakar, Dakar Grand-Dakar' ||
          destinationAddress.value.isEmpty) {
        Get.snackbar(
          'Attention',
          'Veuillez sélectionner une destination',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return; // IMPORTANT : sortir ici si validation échoue
      }

      // Simulation de la commande
      // Get.showSnackbar(
      //   GetSnackBar(
      //     message: 'Recherche d\'un conducteur ${selectedService.value}...',
      //     duration: const Duration(seconds: 2),
      //     backgroundColor: const Color(0xFF10B981),
      //     borderRadius: 8,
      //     margin: const EdgeInsets.all(16),
      //     snackPosition: SnackPosition.BOTTOM,
      //     showProgressIndicator: true,
      //   ),
      // );

      await Future.delayed(const Duration(seconds: 2));
        Get.toNamed('/delivery-tracking', arguments: {
        'departure': destinationAddress.value,
        'destination': destinationAddress.value,
        'service': selectedService.value,
        'serviceModel': selectedServiceModel.value,
      });
      // Afficher dialog de succès au lieu de naviguer vers route inexistante
      // _showSuccessDialog();
      
    } catch (e) {
      print('Erreur commander: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 30),
            SizedBox(width: 10),
            Text('Commande confirmée'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Service: ${selectedService.value}'),
            SizedBox(height: 8),
            Text('Destination: ${destinationAddress.value}'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Un conducteur vous contactera bientôt.',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Fermer dialog
              Get.back(); // Retour page précédente
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF4A90E2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Tap sur carte
  void onMapTap(LatLng point) {
    try {
      destinationLocation.value = point;
      _reverseGeocode(point);
    } catch (e) {
      print('Erreur onMapTap: $e');
    }
  }

  // Géocodage inverse
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
        headers: {'User-Agent': 'DemnaaApp/1.0'},
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = _formatAddress(data);
        destinationAddress.value = address;
        _showSelectionFeedback('Nouvelle destination définie');
      }
    } catch (e) {
      print('Erreur géocodage: $e');
      destinationAddress.value = 'Position sélectionnée';
    }
  }

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
    try {
      _searchDebounce?.cancel();
      addressSearchController.dispose();
    } catch (e) {
      print('Erreur onClose: $e');
    }
    super.onClose();
  }
}

// Classes helper inchangées
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