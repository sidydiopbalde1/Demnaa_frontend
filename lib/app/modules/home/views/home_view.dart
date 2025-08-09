import 'dart:developer';

import 'package:demnaa_front/app/models/services_model.dart';
import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

// 🎨 PAINTER POUR LA FORME DE PIN
class PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E5BBA)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Dessiner le cercle du pin
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2 - 7),
      radius: 25,
    ));
    
    // Dessiner la pointe du pin
    path.moveTo(size.width / 2, size.height - 5);
    path.lineTo(size.width / 2 - 10, size.height / 2 + 8);
    path.lineTo(size.width / 2 + 10, size.height / 2 + 8);
    path.close();

    canvas.drawPath(path, paint);
    
    // Ombre
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 8, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
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
              const SizedBox(height: 25),
              _buildServicesSection(),
              const SizedBox(height: 35),
              _buildFavoritesSection(),
              const SizedBox(height: 35),
              _buildBonusSection(),
              const SizedBox(height: 120), // Espace pour la bottom nav personnalisée
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildCustomBottomNavigation(),
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
            height: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Stack(
                children: [
                  // 🖼️ VOTRE IMAGE DE FOND
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/demnaa_header.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF5B9BD5),
                                Color(0xFF6FA8DC),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // 🌫️ OVERLAY LÉGER pour améliorer la lisibilité du texte
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Main content - POSITIONNÉ PLUS BAS
                  Positioned(
                    bottom: 40, // 🔽 Positionnement depuis le bas
                    left: 25,
                    right: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 📸 PHOTO + NOM À GAUCHE
                        Row(
                          children: [
                            // Photo de profil
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/demnaa_icone_user.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Color(0xFF4A90E2),
                                        size: 28,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 15),
                            
                            // Nom
                            Obx(() => Text(
                              'Bonjour, ${controller.userName.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ],
                        ),
                        
                        // 🔔 NOTIFICATION À DROITE
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF4A90E2),
                            size: 24,
                          ),
                        ),
                      ],
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

  Widget _buildServiceCard(ServiceModel service, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
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
                              ),
                            
                            const SizedBox(height: 8),
                            
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

  Widget _buildServiceCardSkeleton() {
    return Container(
      width: 110,
      height: 120,
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
        width: 80,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF4A90E2).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  place.iconData,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              place.name,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
        width: 80,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
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
            const Text(
              'Ajouter',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mes bonus',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 🎁 VOTRE IMAGE PERSONNALISÉE AVEC GRADIENT
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF29CA96), // ✅ Couleur verte corrigée
                            Color(0xFF4463DF), // ✅ Couleur bleue corrigée
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Center(
                          child: Image.asset(
                            'assets/images/gift_icon.png', // 🔄 Remplacez par votre image
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                            color: Colors.white, // 🎨 Applique une teinte blanche si nécessaire
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback si l'image n'est pas trouvée
                              return const Icon(
                                Icons.card_giftcard,
                                color: Colors.white,
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Effectuez une première commande',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'pour voir vos bonus cadeau',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF718096),
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

  // 🎯 BARRE DE NAVIGATION EXACTE COMME L'IMAGE
  Widget _buildCustomBottomNavigation() {
    return Obx(() => Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Stack(
          children: [
            // Ligne de séparation en haut
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            
            // Navigation items
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Historique à gauche
                  _buildNavItem(
                    Icons.assessment_outlined,
                    'Historique',
                    0,
                  ),
                  
                  // DemNaa au centre
                  _buildCentralNavItem(),
                  
                  // Mon Compte à droite  
                  _buildNavItem(
                    Icons.person_outline,
                    'Mon Compte',
                    2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Item de navigation standard (côtés)
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = controller.selectedBottomIndex.value == index;
    
    return GestureDetector(
      onTap: () => controller.changeBottomNavIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:  const Color(0xFF2E5BBA),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:  const Color(0xFF2E5BBA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 BOUTON CENTRAL AVEC LOGO DEMNAA
// 🎯 VERSION AVEC CUSTOM PAINTER
Widget _buildCentralNavItem() {
  final isSelected = controller.selectedBottomIndex.value == 1;
  
  return GestureDetector(
    onTap: () => controller.changeBottomNavIndex(1),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 📍 PIN PERSONNALISÉ
          Container(
            width: 50,
            height: 65,
            child: CustomPaint(
              painter: PinPainter(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF10B981),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/demnaa_pin_logo.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'D',
                            style: TextStyle(
                              color: Color(0xFF2E5BBA),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Text(
            'DemNaa',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF2E5BBA),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}





  void _showAllFavoriteS() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tous mes lieux favoris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF9CA3AF),
                    ),
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
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun lieu favori',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(25),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: _getFavoriteColor(index).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              place.iconData,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            place.address,
                            style: const TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.back();
                            controller.deleteFavoritePlace(place);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
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
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.favoritePlaceController.openAddPlaceModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Ajouter un nouveau lieu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
    final colors = [
      const Color(0xFF4A90E2),
      const Color(0xFF26C6DA),
      const Color(0xFF66BB6A),
      const Color(0xFFFF7043),
      const Color(0xFFAB47BC),
    ];
    return colors[index % colors.length];
  }
}