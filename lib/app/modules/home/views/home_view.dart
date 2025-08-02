import 'dart:developer';

import 'package:demnaa_front/app/models/services_model.dart';
import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildServicesSection(),
              const SizedBox(height: 30),
              _buildFavoritesSection(),
              const SizedBox(height: 30),
              _buildBonusSection(),
              const SizedBox(height: 100), // Espace pour la bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: controller.headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.headerSlideAnimation.value),
          child: Opacity(
            opacity: controller.headerFadeAnimation.value,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF357ABD),
                    Color(0xFF2E5D8B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Decorative curves
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Top bar with location and notification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Dakar, Sénégal',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Welcome message
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF4A90E2),
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                  'Bonjour, ${controller.userName.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                const Text(
                                  'Où souhaitez-vous aller?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

Widget _buildServicesSection() {
  return AnimatedBuilder(
    animation: controller.servicesAnimationController,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(0, controller.servicesSlideAnimation.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nos Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Bouton de rafraîchissement
                  Obx(() => controller.isLoadingServices.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: controller.refreshServices,
                          icon: const Icon(Icons.refresh, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )),
                ],
              ),
              const SizedBox(height: 15),
              
              // Services dynamiques depuis l'API
              Obx(() {
                if (controller.isLoadingServices.value && controller.services.isEmpty) {
                  // État de chargement initial
                  return SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) => 
                        _buildServiceCardSkeleton()
                      ),
                    ),
                  );
                }
                
                if (controller.services.isEmpty) {
                  // Aucun service disponible
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'Aucun service disponible',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                
                // Afficher les services (max 3 pour l'accueil)
                final displayedServices = controller.services.take(3).toList();
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: displayedServices.asMap().entries.map((entry) {
                    final index = entry.key;
                    final service = entry.value;
                    return _buildServiceCard(service, index * 200);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

// Skeleton loader pour l'état de chargement
Widget _buildServiceCardSkeleton() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ),
  );
}

// Nouvelle méthode : Service card dynamique
Widget _buildServiceCardDynamic(ServiceModel service, int delay) {
  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 600 + delay),
    tween: Tween(begin: 0.0, end: 1.0),
    curve: Curves.elasticOut,
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: GestureDetector(
          onTap: () => controller.onServiceTap(service),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: service.gradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Vous pouvez utiliser l'image ou l'icône
                service.photo.isNotEmpty && service.photo != 'https://via.placeholder.com/150'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          service.photo,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              service.icon,
                              color: Colors.white,
                              size: 30,
                            );
                          },
                        ),
                      )
                    : Icon(
                        service.icon,
                        color: Colors.white,
                        size: 30,
                      ),
                const SizedBox(height: 8),
                Text(
                  service.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Skeleton loader pour l'état de chargement
// Widget _buildServiceCardSkeleton() {
//   return Container(
//     width: 100,
//     height: 100,
//     decoration: BoxDecoration(
//       color: Colors.grey[300],
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: const Center(
//       child: CircularProgressIndicator(
//         strokeWidth: 2,
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//       ),
//     ),
//   );
// }
 // Remplacez l'ancienne méthode _buildServiceCard par celle-ci :
Widget _buildServiceCard(ServiceModel service, int delay) {
  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 600 + delay),
    tween: Tween(begin: 0.0, end: 1.0),
    curve: Curves.elasticOut,
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: GestureDetector(
          onTap: () => controller.onServiceTap(service),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // 🖼️ IMAGE D'ARRIÈRE-PLAN qui couvre toute la carte
                  if (service.photo.isNotEmpty && service.photo != 'https://via.placeholder.com/150')
                    Positioned.fill(
                      child: Image.network(
                        service.photo,
                        fit: BoxFit.cover, // ✅ Couvre toute la carte
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: service.gradient,
                            ),
                          );
                        },
                      ),
                    )
                  else
                    // 🎨 DÉGRADÉ si pas d'image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: service.gradient,
                        ),
                      ),
                    ),
                  
                  // 🌫️ OVERLAY dégradé pour améliorer la lisibilité
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // 📝 CONTENU (icône + texte) par-dessus
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône uniquement si pas d'image ou en cas d'erreur
                          if (service.photo.isEmpty || service.photo == 'https://via.placeholder.com/150')
                            Icon(
                              service.icon,
                              color: Colors.white,
                              size: 30,
                            )
                          else
                            // Icône plus petite si il y a une image
                          //   Container(
                          //     padding: const EdgeInsets.all(6),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white.withOpacity(0.9),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: Icon(
                          //       service.icon,
                          //       color: service.gradient.colors.first,
                          //       size: 20,
                          //     ),
                          //   ),
                          
                          // const SizedBox(height: 8),
                          
                          // Texte avec ombre pour meilleure lisibilité
                          Text(
                            service.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildFavoritesSection() {
  return AnimatedBuilder(
    animation: controller.favoritesAnimationController,
    builder: (context, child) {
      return Opacity(
        opacity: controller.favoritesFadeAnimation.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lieux favoris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAllFavoriteS(),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // 🔧 CORRECTION : Augmentation de la hauteur et amélioration de la disposition
              Obx(() {
                final places = controller.favoritePlaceController.favoritePlaces;
                final displayedPlaces = places.take(3).toList();
                
                return SizedBox(
                  height: 120, // ✅ Augmenté de 100 à 120
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero, // ✅ Supprime le padding par défaut
                    itemCount: displayedPlaces.length + 1,
                    itemBuilder: (context, index) {
                      if (index == displayedPlaces.length) {
                        return _buildAddFavoriteButton();
                      }
                      
                      final place = displayedPlaces[index];
                      return _buildFavoriteItemDynamic(place, index);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildFavoriteItemDynamic(FavoritePlace place, int index) {
  return GestureDetector(
    onTap: () => controller.onFavoriteTap(place.name),
    onLongPress: () => controller.deleteFavoritePlace(place),
    child: Container(
      width: 85, // ✅ Légèrement augmenté
      margin: const EdgeInsets.only(right: 10), // ✅ Réduit la marge
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Ajouté pour éviter le débordement
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getFavoriteColor(index).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                place.iconData,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible( // ✅ Utilise Flexible au lieu de Text direct
            child: Text(
              place.name,
              style: TextStyle(
                fontSize: 11, // ✅ Légèrement réduit
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _buildAddFavoriteButton() {
  return GestureDetector(
    onTap: () => controller.favoritePlaceController.openAddPlaceModal(),
    child: Container(
      width: 85, // ✅ Même largeur que les autres items
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Évite le débordement
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Flexible( // ✅ Utilise Flexible
            child: Text(
              'Ajouter',
              style: TextStyle(
                fontSize: 11, // ✅ Même taille que les autres
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _buildBottomNavigation() {
  return Obx(() => Container(
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomNavItem(Icons.home, 'Accueil', 0),
        _buildBottomNavItem(Icons.history, 'Demandes', 1),
        _buildBottomNavItem(Icons.person, 'Mon compte', 2),
      ],
    ),
  ));
}
Widget _buildBottomNavItem(IconData icon, String label, int index) {
  final isSelected = controller.selectedBottomIndex.value == index;
  
  return GestureDetector(
    onTap: () => controller.changeBottomNavIndex(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4A90E2).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF4A90E2) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _buildBonusSection() {
  return AnimatedBuilder(
    animation: controller.bonusAnimationController,
    builder: (context, child) {
      return Transform.scale(
        scale: controller.bonusScaleAnimation.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mes bonus',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Effectuez une première commande',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'pour voir vos bonus cadeaux',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showAllFavoriteS() { // Corrigé : _showAllFavoriteS (avec S majuscule comme dans votre code)
  Get.bottomSheet(
    Container(
      height: Get.height * 0.7,
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
                  'Tous mes lieux favoris',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Liste des favoris
          Expanded(
            child: Obx(() {
              final places = controller.favoritePlaceController.favoritePlaces;
              
              if (places.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun lieu favori',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getFavoriteColor(index).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            place.iconData,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        place.address,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Get.back();
                          controller.deleteFavoritePlace(place);
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      onTap: () {
                        Get.back();
                        controller.onFavoriteTap(place.name);
                      },
                    ),
                  );
                },
              );
            }),
          ),
          
          // Bouton d'ajout
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  controller.favoritePlaceController.openAddPlaceModal();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Ajouter un nouveau lieu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Color _getFavoriteColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.red];
    return colors[index % colors.length];
  }
}