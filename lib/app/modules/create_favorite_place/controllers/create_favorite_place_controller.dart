import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class FavoritePlace {
  final String id;
  final String name;
  final String address;
  final String iconData;
  final DateTime createdAt;

  FavoritePlace({
    required this.id,
    required this.name,
    required this.address,
    required this.iconData,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'iconData': iconData,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FavoritePlace.fromJson(Map<String, dynamic> json) => FavoritePlace(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    iconData: json['iconData'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class FavoritePlaceController extends GetxController {
  // Observables
  var favoritePlaces = <FavoritePlace>[].obs;
  var selectedIcon = '🏠'.obs;
  var placeName = ''.obs;
  var placeAddress = ''.obs;
  var isLoading = false.obs;

  // Nouvelles propriétés pour la gestion des adresses avec geocoding
  var currentEditingPlace = Rxn<FavoritePlace>();
  var searchedAddresses = <Map<String, dynamic>>[].obs; // Changé pour stocker les objets complets
  var currentAddress = ''.obs;
  final addressSearchController = TextEditingController();
  
  // Controllers pour les champs de texte
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  
  // Timer pour le debounce
  Timer? _debounce;
  
  // Liste des icônes disponibles
  final List<String> availableIcons = [
    '🏠', '🏢', '🏥', '🏫', '🏪', '🏭', '🏛️', '⛪',
    '🍽️', '🍕', '🍔', '☕', '🛒', '⛽', '🚗', '🚌',
    '🎭', '🎪', '🎨', '🏀', '⚽', '🎾', '🏊', '🏃',
    '📚', '📖', '💼', '💻', '🔧', '🔨', '⚕️', '💊',
    '🌳', '🌺', '🌸', '🌼', '🌻', '🌹', '🌷', '🌲',
    '😊', '😍', '🤗', '😎', '🤓', '😋', '😴', '🥳',
    '❤️', '💙', '💚', '💛', '🧡', '💜', '🖤', '🤍',
    '⭐', '✨', '💫', '🌟', '🌙', '☀️', '🌈', '🔥',
    '👍', '👌', '✌️', '🤟', '👏', '🙌', '🤝', '💪',
    '🎯', '🎲', '🎮', '🕹️', '🎳', '🏆', '🥇', '🏅'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadFavoritePlaces();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    addressSearchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  // Nouvelle méthode : Recherche de lieux avec Nominatim API
  void searchAddresses(String query) async {
    // Annuler la recherche précédente
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      searchedAddresses.clear();
      return;
    }

    // Attendre 500ms avant de lancer la recherche pour éviter trop de requêtes
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performAddressSearch(query);
    });
  }

  // Effectuer la recherche d'adresses avec l'API Nominatim
  Future<void> _performAddressSearch(String query) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=jsonv2&addressdetails=1&limit=5&countrycodes=sn',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'DemnaaApp/1.0 (contact@demnaa.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        searchedAddresses.value = data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 429) {
        searchedAddresses.clear();
        Get.snackbar(
          'Limite atteinte',
          'Trop de requêtes. Veuillez patienter...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        searchedAddresses.clear();
        // Fallback vers la simulation si l'API échoue
        _simulateAddressSearch(query);
      }
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      searchedAddresses.clear();
      // Fallback vers la simulation en cas d'erreur réseau
      _simulateAddressSearch(query);
    }
  }

  // Méthode de fallback pour simuler la recherche
  void _simulateAddressSearch(String query) {
    searchedAddresses.value = [
      {
        'display_name': '$query, Dakar, Sénégal',
        'lat': '14.716677',
        'lon': '-17.467686',
        'type': 'simulation'
      },
      {
        'display_name': 'Avenue Léopold Sédar Senghor, $query',
        'lat': '14.691773',
        'lon': '-17.448118',
        'type': 'simulation'
      },
      {
        'display_name': 'Route de la Corniche, $query',
        'lat': '14.717171',
        'lon': '-17.484657',
        'type': 'simulation'
      },
      {
        'display_name': 'Plateau, $query, Dakar',
        'lat': '14.673571',
        'lon': '-17.446612',
        'type': 'simulation'
      },
      {
        'display_name': 'Almadies, $query, Dakar',
        'lat': '14.742659',
        'lon': '-17.515064',
        'type': 'simulation'
      },
    ];
  }

  // Recherche d'adresses pour le champ d'ajout de lieu
  void searchAddressesForNewPlace(String query) {
    searchAddresses(query); // Utilise la même méthode
  }

  // Nouvelle méthode : Ouvrir le modal d'édition d'adresse pour un lieu favori
  void openAddressModal(FavoritePlace place) {
    currentEditingPlace.value = place;
    addressSearchController.clear();
    searchedAddresses.clear();
    currentAddress.value = place.address;
    
    Get.bottomSheet(
      _buildAddressModal(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void useCurrentPosition() {
    Get.snackbar(
      'Position',
      'Utilisation de votre position actuelle...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
    
    // Simulation de géolocalisation
    Future.delayed(const Duration(seconds: 1), () {
      addressSearchController.text = "Position actuelle - Dakar, Sénégal";
      searchAddresses("Position actuelle");
    });
  }

  // Sélectionner une adresse suggérée
  void selectAddress(Map<String, dynamic> addressData) {
    final displayName = addressData['display_name'] ?? addressData['address'] ?? 'Adresse inconnue';
    addressSearchController.text = displayName;
    currentAddress.value = displayName;
    searchedAddresses.clear();
  }

  // Sélectionner une adresse pour le nouveau lieu
  void selectAddressForNewPlace(Map<String, dynamic> addressData) {
    final displayName = addressData['display_name'] ?? addressData['address'] ?? 'Adresse inconnue';
    addressController.text = displayName;
    searchedAddresses.clear();
  }

  // Sauvegarder la nouvelle adresse
  void saveAddress() async {
    if (addressSearchController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir une adresse',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Mettre à jour l'adresse du lieu favori
      final updatedPlace = FavoritePlace(
        id: currentEditingPlace.value!.id,
        name: currentEditingPlace.value!.name,
        address: addressSearchController.text,
        iconData: currentEditingPlace.value!.iconData,
        createdAt: currentEditingPlace.value!.createdAt,
      );

      // Remplacer dans la liste
      final index = favoritePlaces.indexWhere((p) => p.id == updatedPlace.id);
      if (index != -1) {
        favoritePlaces[index] = updatedPlace;
      }

      Get.back(); // Fermer le modal

      Get.snackbar(
        'Succès',
        'Adresse mise à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour l\'adresse',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Modal d'édition d'adresse
  Widget _buildAddressModal() {
    return Container(
      height: Get.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header avec titre et bouton supprimer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() => Text(
                    'Lieu d\'adresse du ${currentEditingPlace.value?.name ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        if (currentEditingPlace.value != null) {
                          deleteFavoritePlace(currentEditingPlace.value!.id);
                        }
                      },
                      child: const Text(
                        'supprimer',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ de recherche d'adresse
                  const Text(
                    'Saisir votre adresse',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressSearchController,
                    onChanged: (value) => searchAddresses(value),
                    decoration: InputDecoration(
                      hintText: 'Ex: Pikine, Dakar...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        onPressed: () => searchAddresses(addressSearchController.text),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bouton "Utiliser votre position actuelle"
                  GestureDetector(
                    onTap: useCurrentPosition,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Utiliser votre position actuelle',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Liste des suggestions d'adresses
                  Expanded(
                    child: Obx(() {
                      if (searchedAddresses.isEmpty) {
                        return const Center(
                          child: Text(
                            'Saisissez une adresse pour voir les suggestions',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: searchedAddresses.length,
                        itemBuilder: (context, index) {
                          final addressData = searchedAddresses[index];
                          final displayName = addressData['display_name'] ?? 'Adresse inconnue';
                          final isSimulation = addressData['type'] == 'simulation';
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                isSimulation ? Icons.location_on_outlined : Icons.location_on,
                                color: isSimulation ? Colors.grey : Colors.blue,
                                size: 20,
                              ),
                              title: Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: isSimulation ? const Text(
                                'Suggestion locale',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ) : null,
                              onTap: () => selectAddress(addressData),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey[50],
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Bouton Enregistrer
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading.value ? null : saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Enregistrer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Charger les lieux favoris (simulation)
  void _loadFavoritePlaces() {
    favoritePlaces.addAll([
      FavoritePlace(
        id: '1',
        name: 'Domicile',
        address: 'Dakar, Plateau',
        iconData: '🏠',
        createdAt: DateTime.now(),
      ),
      FavoritePlace(
        id: '2',
        name: 'Travail',
        address: 'Dakar, Almadies',
        iconData: '🏢',
        createdAt: DateTime.now(),
      ),
      FavoritePlace(
        id: '3',
        name: 'École/Université',
        address: 'Dakar, Fann',
        iconData: '🏫',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  // Sélectionner une icône
  void selectIcon(String icon) {
    selectedIcon.value = icon;
    Get.back();
  }

  // Ouvrir le modal d'ajout de lieu
  void openAddPlaceModal() {
    selectedIcon.value = '🏠';
    nameController.clear();
    addressController.clear();
    placeName.value = '';
    placeAddress.value = '';
    searchedAddresses.clear(); // Effacer les suggestions précédentes
    
    Get.bottomSheet(
      _buildAddPlaceModal(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // Ouvrir l'écran de sélection d'icônes
  void openIconSelector() {
    Get.to(
      () => _buildIconSelectorScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Ajouter un nouveau lieu favori
  void addFavoritePlace() async {
    if (nameController.text.isEmpty || addressController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final newPlace = FavoritePlace(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        address: addressController.text,
        iconData: selectedIcon.value,
        createdAt: DateTime.now(),
      );

      favoritePlaces.add(newPlace);

      Get.back();

      Get.snackbar(
        'Succès',
        'Lieu favori ajouté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter le lieu favori',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Supprimer un lieu favori
  void deleteFavoritePlace(String id) {
    favoritePlaces.removeWhere((place) => place.id == id);
    Get.snackbar(
      'Supprimé',
      'Lieu favori supprimé',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Rechercher une adresse (pour navigation vers reverse geocoding)
  void searchAddress() {
    Get.toNamed('/reverse-geocoding');
    Get.snackbar(
      'Recherche',
      'Fonctionnalité de recherche d\'adresse',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Modal d'ajout de lieu avec suggestions en temps réel
  Widget _buildAddPlaceModal() {
    return Container(
      height: Get.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ajouter un lieu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sélection d'icône
                  GestureDetector(
                    onTap: openIconSelector,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Obx(() => Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                selectedIcon.value,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          )),
                          const SizedBox(height: 10),
                          const Text(
                            'Sélectionner une icône',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nom du lieu
                  const Text(
                    'Entrer le nom du lieu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Ex: Restaurant, Bureau...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Adresse avec suggestions
                  const Text(
                    'Entrer l\'adresse',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    onChanged: (value) => searchAddressesForNewPlace(value),
                    decoration: InputDecoration(
                      hintText: 'Ex: Dakar, Plateau...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        onPressed: searchAddress,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Suggestions d'adresses pour le nouveau lieu
                  Obx(() {
                    if (searchedAddresses.isNotEmpty && addressController.text.isNotEmpty) {
                      return Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchedAddresses.length,
                          itemBuilder: (context, index) {
                            final addressData = searchedAddresses[index];
                            final displayName = addressData['display_name'] ?? 'Adresse inconnue';
                            final isSimulation = addressData['type'] == 'simulation';
                            
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                isSimulation ? Icons.location_on_outlined : Icons.location_on,
                                color: isSimulation ? Colors.grey : Colors.blue,
                                size: 16,
                              ),
                              title: Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              onTap: () => selectAddressForNewPlace(addressData),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const Spacer(),

                  // Bouton Enregistrer
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading.value ? null : addFavoritePlace,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Enregistrer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Écran de sélection d'icônes
  Widget _buildIconSelectorScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Sélectionner une icône',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: availableIcons.length,
          itemBuilder: (context, index) {
            final icon = availableIcons[index];
            final isSelected = selectedIcon.value == icon;

            return GestureDetector(
              onTap: () => selectIcon(icon),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}