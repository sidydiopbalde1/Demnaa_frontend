import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AddressSearchController extends GetxController {
  // Text Controllers
  final departureController = TextEditingController();
  final destinationController = TextEditingController();
  
  // Focus Nodes pour gérer le focus
  final departureFocusNode = FocusNode();
  final destinationFocusNode = FocusNode();
  
  // Timer pour debouncing
  Timer? _departureDebounce;
  Timer? _destinationDebounce;
  
  // Observable variables
  var isLoading = false.obs;
  var selectedService = 'Livraison'.obs;
  var departureAddress = 'Grand Dakar Rue 449'.obs;
  var destinationAddress = 'Adresse du destinataire'.obs;
  final currentLocation = LatLng(14.716677, -17.467686).obs; // Dakar par défaut
  final departureLocation = Rxn<LatLng>();
  final destinationLocation = Rxn<LatLng>();
  
  // Nouvelles variables pour l'autocomplétion
  var departureSuggestions = <AddressSuggestion>[].obs;
  var destinationSuggestions = <AddressSuggestion>[].obs;
  var showDepartureSuggestions = false.obs;
  var showDestinationSuggestions = false.obs;
  var isSearchingDeparture = false.obs;
  var isSearchingDestination = false.obs;
  
  MapController? mapController;
  
  // Services disponibles
  final List<String> availableServices = [
    'Livraison',
    'Moto-taxi',
    'Moto-colis'
  ];

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _setupTextControllerListeners();
  }

  void _setupTextControllerListeners() {
    departureController.addListener(() {
      // Annuler le timer précédent
      _departureDebounce?.cancel();
      
      // Démarrer un nouveau timer (debouncing)
      _departureDebounce = Timer(const Duration(milliseconds: 500), () {
        if (departureController.text.length > 2) {
          _searchAddresses(departureController.text, true);
        } else {
          showDepartureSuggestions.value = false;
          departureSuggestions.clear();
        }
      });
      
      _validateAddresses();
    });
    
    destinationController.addListener(() {
      // Annuler le timer précédent
      _destinationDebounce?.cancel();
      
      // Démarrer un nouveau timer (debouncing)
      _destinationDebounce = Timer(const Duration(milliseconds: 500), () {
        if (destinationController.text.length > 2) {
          _searchAddresses(destinationController.text, false);
        } else {
          showDestinationSuggestions.value = false;
          destinationSuggestions.clear();
        }
      });
      
      _validateAddresses();
    });

    // Listeners pour le focus
    departureFocusNode.addListener(() {
      if (!departureFocusNode.hasFocus) {
        // Masquer les suggestions après un délai
        Future.delayed(const Duration(milliseconds: 200), () {
          showDepartureSuggestions.value = false;
        });
      }
    });

    destinationFocusNode.addListener(() {
      if (!destinationFocusNode.hasFocus) {
        // Masquer les suggestions après un délai
        Future.delayed(const Duration(milliseconds: 200), () {
          showDestinationSuggestions.value = false;
        });
      }
    });
  }

  // Recherche d'adresses avec Nominatim (OpenStreetMap)
  Future<void> _searchAddresses(String query, bool isDeparture) async {
    if (isDeparture) {
      isSearchingDeparture.value = true;
    } else {
      isSearchingDestination.value = true;
    }

    try {
      // Recherche centrée sur Dakar
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?'
          'q=${Uri.encodeComponent(query)}&'
          'format=json&'
          'addressdetails=1&'
          'limit=5&'
          'countrycodes=sn&' // Limiter au Sénégal
          'bounded=1&'
          'viewbox=-17.5,-14.6,-17.4,-14.8' // Bbox autour de Dakar
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

        if (isDeparture) {
          departureSuggestions.value = suggestions;
          showDepartureSuggestions.value = suggestions.isNotEmpty;
        } else {
          destinationSuggestions.value = suggestions;
          showDestinationSuggestions.value = suggestions.isNotEmpty;
        }
      }
    } catch (e) {
      print('Erreur lors de la recherche d\'adresses: $e');
    } finally {
      if (isDeparture) {
        isSearchingDeparture.value = false;
      } else {
        isSearchingDestination.value = false;
      }
    }
  }

  String _formatAddress(Map<String, dynamic> item) {
    final address = item['address'] ?? {};
    List<String> parts = [];
    
    if (address['road'] != null) parts.add(address['road']);
    if (address['suburb'] != null) parts.add(address['suburb']);
    if (address['city'] != null) parts.add(address['city']);
    
    return parts.isNotEmpty ? parts.join(', ') : item['display_name'] ?? '';
  }

  void selectDepartureSuggestion(AddressSuggestion suggestion) {
    departureController.text = suggestion.address;
    departureAddress.value = suggestion.address;
    departureLocation.value = LatLng(suggestion.lat, suggestion.lon);
    showDepartureSuggestions.value = false;
    
    // Retirer le focus du champ
    departureFocusNode.unfocus();
    
    // Centrer la carte sur l'adresse sélectionnée
    mapController?.move(LatLng(suggestion.lat, suggestion.lon), 16.0);
    
    // Vibration légère pour confirmer la sélection
    _showSelectionFeedback('Adresse de départ définie');
  }

  void selectDestinationSuggestion(AddressSuggestion suggestion) {
    destinationController.text = suggestion.address;
    destinationAddress.value = suggestion.address;
    destinationLocation.value = LatLng(suggestion.lat, suggestion.lon);
    showDestinationSuggestions.value = false;
    
    // Retirer le focus du champ
    destinationFocusNode.unfocus();
    
    // Centrer la carte sur l'adresse sélectionnée
    mapController?.move(LatLng(suggestion.lat, suggestion.lon), 16.0);
    
    // Vibration légère pour confirmer la sélection
    _showSelectionFeedback('Adresse de destination définie');
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
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
      ),
    );
  }

  void _validateAddresses() {
    // Validation des adresses saisies
    if (departureController.text.isNotEmpty && destinationController.text.isNotEmpty) {
      // Activer le bouton commander
    }
  }

  // Récupération de l'adresse par géocodage inverse
  Future<void> reverseGeocode(LatLng point, bool isDeparture) async {
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
        
        if (isDeparture) {
          departureController.text = address;
          departureAddress.value = address;
          departureLocation.value = point;
        } else {
          destinationController.text = address;
          destinationAddress.value = address;
          destinationLocation.value = point;
        }
      }
    } catch (e) {
      print('Erreur lors du géocodage inverse: $e');
    }
  }

  // Changer le service sélectionné
  void changeService(String service) {
    selectedService.value = service;
  }

  // Ajouter un arrêt
  void addStop() {
    Get.snackbar(
      'Arrêt ajouté',
      'Fonctionnalité d\'ajout d\'arrêt',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Actions pour les icônes (domicile, favoris, etc.)
  void onIconTap(String iconType) {
    switch (iconType) {
      case 'home':
        _setHomeAddress();
        break;
      case 'favorites':
        _showFavorites();
        break;
      case 'history':
        _showHistory();
        break;
      case 'location':
        _getCurrentLocation();
        break;
    }
  }

  void _setHomeAddress() {
    Get.snackbar(
      'Adresse domicile',
      'Adresse domicile sélectionnée',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showFavorites() {
    // Naviguer vers les favoris ou ouvrir un modal
  }

  void _showHistory() {
    // Afficher l'historique des adresses
  }

  void _getCurrentLocation() {
    // Obtenir la position GPS actuelle
    Get.snackbar(
      'Localisation',
      'Récupération de votre position...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Commander la course
  Future<void> commander() async {
    if (departureController.text.isEmpty || destinationController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir les adresses de départ et d\'arrivée',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulation d'appel API
      await Future.delayed(const Duration(seconds: 2));
      
      // Naviguer vers l'écran de suivi
      Get.toNamed('/delivery-tracking', arguments: {
        'departure': departureController.text,
        'destination': destinationController.text,
        'service': selectedService.value,
      });
      
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de créer la commande',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Méthodes de carte
  void onMapTap(LatLng point) {
    currentLocation.value = point;
    
    // Afficher un dialog pour choisir si c'est le départ ou la destination
    Get.dialog(
      AlertDialog(
        title: const Text('Définir cette position'),
        content: const Text('Que voulez-vous faire avec cette position ?'),
        actions: [
          TextButton(
            onPressed: () {
              reverseGeocode(point, true);
              Get.back();
            },
            child: const Text('Départ'),
          ),
          TextButton(
            onPressed: () {
              reverseGeocode(point, false);
              Get.back();
            },
            child: const Text('Destination'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void getCurrentLocation() {
    // Logique pour obtenir la position GPS actuelle
  }

  void zoomIn() {
    mapController?.move(currentLocation.value, mapController!.camera.zoom + 1);
  }

  void zoomOut() {
    mapController?.move(currentLocation.value, mapController!.camera.zoom - 1);
  }

  @override
  void onClose() {
    // Nettoyer les timers
    _departureDebounce?.cancel();
    _destinationDebounce?.cancel();
    
    // Disposer des controllers et focus nodes
    departureController.dispose();
    destinationController.dispose();
    departureFocusNode.dispose();
    destinationFocusNode.dispose();
    
    super.onClose();
  }
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