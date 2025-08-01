import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var selectedIcon = '🏠'.obs; // Icône par défaut
  var placeName = ''.obs;
  var placeAddress = ''.obs;
  var isLoading = false.obs;
  
  // Controllers pour les champs de texte
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  
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
    super.onClose();
  }

  // Charger les lieux favoris (simul)
  void _loadFavoritePlaces() {
    // Simulation - en réalité, charger depuis une base de données
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
    Get.back(); // Retourner à l'écran précédent
  }

  // Ouvrir le modal d'ajout de lieu
  void openAddPlaceModal() {
    // Réinitialiser les valeurs
    selectedIcon.value = '🏠';
    nameController.clear();
    addressController.clear();
    placeName.value = '';
    placeAddress.value = '';
    
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
      // Simulation d'un délai réseau
      await Future.delayed(const Duration(milliseconds: 1000));

      final newPlace = FavoritePlace(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        address: addressController.text,
        iconData: selectedIcon.value,
        createdAt: DateTime.now(),
      );

      favoritePlaces.add(newPlace);

      Get.back(); // Fermer le modal

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

  // Rechercher une adresse (simulation)
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

  // Modal d'ajout de lieu
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

                  // Adresse
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