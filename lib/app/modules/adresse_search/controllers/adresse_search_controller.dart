import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:demnaa_front/app/models/services_model.dart';

class AddressSearchController extends GetxController {
  // Text Controllers
  final departureController = TextEditingController();
  final destinationController = TextEditingController();
  final departurePhoneController = TextEditingController(); // Nouveau
  final destinationPhoneController = TextEditingController();

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
  var departurePhone = ''.obs; // Nouveau
  var destinationPhone = ''.obs;
  final currentLocation = LatLng(14.716677, -17.467686).obs;
  final departureLocation = Rxn<LatLng>();
  final destinationLocation = Rxn<LatLng>();

  // AJOUTÉ - Variables pour les services
  var selectedServiceModel = Rxn<ServiceModel>();
  var availableServices = <ServiceModel>[].obs;
  var showServicesOnMap = false.obs;
  var comesFromDriversList = false.obs;

  // Variables pour l'autocomplétion
  var departureSuggestions = <AddressSuggestion>[].obs;
  var destinationSuggestions = <AddressSuggestion>[].obs;
  var showDepartureSuggestions = false.obs;
  var showDestinationSuggestions = false.obs;
  var isSearchingDeparture = false.obs;
  var isSearchingDestination = false.obs;

  MapController? mapController;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _setupTextControllerListeners();
    _handleNavigationArguments();
    _loadDefaultServices();
  }

  void _handleNavigationArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      if (arguments.containsKey('driverId') || arguments.containsKey('driverName')) {
        comesFromDriversList.value = true;
        showServicesOnMap.value = false;
        selectedService.value = 'Livraison';
        print('Navigation depuis DriversListFullView - Services cachés');
      } else if (arguments.containsKey('selectedService')) {
        comesFromDriversList.value = false;
        showServicesOnMap.value = true;
        final serviceData = arguments['selectedService'] as ServiceModel;
        selectedServiceModel.value = serviceData;
        selectedService.value = serviceData.displayName;
        print('Navigation depuis HomeView avec service: ${serviceData.displayName}');
      }
    } else {
      comesFromDriversList.value = false;
      showServicesOnMap.value = true;
    }
  }

  void _loadDefaultServices() {
    if (availableServices.isEmpty) {
      availableServices.value = [
        ServiceModel(id: 1, libelle: 'moto-livraison', photo: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ServiceModel(id: 2, libelle: 'moto-taxi', photo: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        ServiceModel(id: 3, libelle: 'moto-bagage', photo: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];
      if (showServicesOnMap.value && selectedServiceModel.value == null) {
        selectedServiceModel.value = availableServices.first;
        selectedService.value = availableServices.first.displayName;
      }
    }
  }

  void selectServiceFromMap(ServiceModel service) {
    selectedServiceModel.value = service;
    selectedService.value = service.displayName;
    Get.showSnackbar(GetSnackBar(
      message: 'Service ${service.displayName} sélectionné',
      duration: const Duration(seconds: 1),
      backgroundColor: const Color(0xFF10B981),
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ));
  }

  void _setupTextControllerListeners() {
    departureController.addListener(() {
      _departureDebounce?.cancel();
      _departureDebounce = Timer(const Duration(milliseconds: 500), () {
        if (departureController.text.length > 2) {
          _searchAddresses(departureController.text, true);
        } else {
          showDepartureSuggestions.value = false;
          departureSuggestions.clear();
        }
      });
      departureAddress.value = departureController.text; // Mise à jour en temps réel
      _validateAddresses();
    });

    destinationController.addListener(() {
      _destinationDebounce?.cancel();
      _destinationDebounce = Timer(const Duration(milliseconds: 500), () {
        if (destinationController.text.length > 2) {
          _searchAddresses(destinationController.text, false);
        } else {
          showDestinationSuggestions.value = false;
          destinationSuggestions.clear();
        }
      });
      destinationAddress.value = destinationController.text; // Mise à jour en temps réel
      _validateAddresses();
    });

    departurePhoneController.addListener(() {
      departurePhone.value = departurePhoneController.text;
      _validateAddresses();
    });

    destinationPhoneController.addListener(() {
      destinationPhone.value = destinationPhoneController.text;
      _validateAddresses();
    });

    departureFocusNode.addListener(() {
      if (!departureFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          showDepartureSuggestions.value = false;
        });
      } else {
        if (departureController.text.length > 2) {
          showDepartureSuggestions.value = true;
        }
      }
    });

    destinationFocusNode.addListener(() {
      if (!destinationFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          showDestinationSuggestions.value = false;
        });
      } else {
        if (destinationController.text.length > 2) {
          showDestinationSuggestions.value = true;
        }
      }
    });
  }

  Future<void> _searchAddresses(String query, bool isDeparture) async {
    if (isDeparture) isSearchingDeparture.value = true;
    else isSearchingDestination.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5&countrycodes=sn',
        ),
        headers: {'User-Agent': 'DemnaaApp/1.0'},
      );
      print(response.body);
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
          // CORRECTION : Afficher les suggestions dès qu'on a des résultats.
          showDepartureSuggestions.value = suggestions.isNotEmpty;
        } else {
          destinationSuggestions.value = suggestions;
          // CORRECTION : Afficher les suggestions dès qu'on a des résultats.
          showDestinationSuggestions.value = suggestions.isNotEmpty;
        }
      }
    } catch (e) {
      print('Erreur lors de la recherche d\'adresses: $e');
    } finally {
      if (isDeparture) isSearchingDeparture.value = false;
      else isSearchingDestination.value = false;
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
    departureFocusNode.unfocus();
    mapController?.move(LatLng(suggestion.lat, suggestion.lon), 16.0);
    _showSelectionFeedback('Adresse de départ définie');
  }

  void selectDestinationSuggestion(AddressSuggestion suggestion) {
    destinationController.text = suggestion.address;
    destinationAddress.value = suggestion.address;
    destinationLocation.value = LatLng(suggestion.lat, suggestion.lon);
    showDestinationSuggestions.value = false;
    destinationFocusNode.unfocus();
    mapController?.move(LatLng(suggestion.lat, suggestion.lon), 16.0);
    _showSelectionFeedback('Adresse de destination définie');
  }

  void _showSelectionFeedback(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 1),
      backgroundColor: const Color(0xFF10B981),
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ));
  }

  void _validateAddresses() {
    if (departureController.text.isNotEmpty &&
        destinationController.text.isNotEmpty &&
        departurePhoneController.text.isNotEmpty &&
        destinationPhoneController.text.isNotEmpty) {
      // Activer le bouton commander (à implémenter dans la vue)
    }
  }

  Future<void> reverseGeocode(LatLng point, bool isDeparture) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1',
        ),
        headers: {'User-Agent': 'DemnaaApp/1.0'},
      );
      print(response.body);
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

  void changeService(String service) {
    selectedService.value = service;
  }

  void addStop() {
    Get.snackbar(
      'Arrêt ajouté',
      'Fonctionnalité d\'ajout d\'arrêt',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

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

  void _showFavorites() {}

  void _showHistory() {}

  void _getCurrentLocation() {
    Get.snackbar(
      'Localisation',
      'Récupération de votre position...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> commander() async {
    if (departureController.text.isEmpty ||
        destinationController.text.isEmpty ||
        departurePhoneController.text.isEmpty ||
        destinationPhoneController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs requis',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed('/delivery-tracking', arguments: {
        'departure': departureController.text,
        'destination': destinationController.text,
        'departurePhone': departurePhoneController.text,
        'destinationPhone': destinationPhoneController.text,
        'service': selectedService.value,
        'serviceModel': selectedServiceModel.value,
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

  void onMapTap(LatLng point) {
    currentLocation.value = point;
    Get.dialog(AlertDialog(
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
    ));
  }

  void getCurrentLocation() {}

  void zoomIn() {
    mapController?.move(currentLocation.value, mapController!.camera.zoom + 1);
  }

  void zoomOut() {
    mapController?.move(currentLocation.value, mapController!.camera.zoom - 1);
  }

  @override
  void onClose() {
    _departureDebounce?.cancel();
    _destinationDebounce?.cancel();
    departureController.dispose();
    destinationController.dispose();
    departurePhoneController.dispose();
    destinationPhoneController.dispose();
    departureFocusNode.dispose();
    destinationFocusNode.dispose();
    super.onClose();
  }
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