import 'package:demnaa_front/app/models/services_model.dart';
import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:demnaa_front/app/services/demnaa_services_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ServiceService _serviceService = Get.find<ServiceService>();

  // Animation Controllers
  late AnimationController headerAnimationController;
  late AnimationController servicesAnimationController;
  late AnimationController favoritesAnimationController;
  late AnimationController bonusAnimationController;

  // Animations
  late Animation<double> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<double> servicesSlideAnimation;
  late Animation<double> favoritesFadeAnimation;
  late Animation<double> bonusScaleAnimation;

  // Observable variables
  var selectedBottomIndex = 0.obs;
  var userName = "Sidy Diop".obs;

  // Variables pour les services
  var services = <ServiceModel>[].obs;
  var isLoadingServices = false.obs;
  var servicesError = ''.obs;

  // Instance du controller des lieux favoris
  late FavoritePlaceController favoritePlaceController;

  @override
  void onInit() {
    super.onInit();

    // Initialiser le controller des lieux favoris
    favoritePlaceController = Get.put(FavoritePlaceController());

    _initializeAnimations();
    _loadServices();
    _startAnimations();
  }

  // Charger les services depuis l'API
  Future<void> _loadServices() async {
    try {
      isLoadingServices.value = true;
      servicesError.value = '';

      final servicesList = await _serviceService.getServices();

      // Correction : utiliser .value = au lieu de .assignAll()
      services.value = servicesList;

      print('🔥 Services chargés: ${services.length}');

    } catch (e) {
      servicesError.value = e.toString();
      print('❌ Erreur lors du chargement des services: $e');

      // Charger les services par défaut en cas d'erreur
      services.value = _serviceService.getDefaultServices();

      Get.snackbar(
        'Erreur',
        'Impossible de charger les services. Données par défaut utilisées.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingServices.value = false;
    }
  }

  // Rafraîchir les services
  Future<void> refreshServices() async {
    await _loadServices();
  }

  // Gérer le tap sur un service
  void onServiceTap(ServiceModel service) {
    Get.snackbar(
      'Service sélectionné',
      'Vous avez choisi: ${service.displayName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );

    // Ici vous pouvez naviguer vers l'écran du service
    // Get.toNamed('/service/${service.id}');
  }

  // Méthodes d'animation (inchangées)
  void _initializeAnimations() {
    headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    headerSlideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: headerAnimationController,
      curve: Curves.easeInOut,
    ));

    servicesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    servicesSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: servicesAnimationController,
      curve: Curves.elasticOut,
    ));

    favoritesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    favoritesFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: favoritesAnimationController,
      curve: Curves.easeInOut,
    ));

    bonusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    bonusScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: bonusAnimationController,
      curve: Curves.bounceOut,
    ));
  }

  void _startAnimations() async {
    headerAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    servicesAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    favoritesAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    bonusAnimationController.forward();
  }

  void changeBottomNavIndex(int index) {
    selectedBottomIndex.value = index;
  }

  void onFavoriteTap(String location) {
    if (location == 'Ajouter') {
      favoritePlaceController.openAddPlaceModal();
    } else {
      final place = favoritePlaceController.favoritePlaces
          .firstWhereOrNull((p) => p.name == location);

      if (place != null) {
        favoritePlaceController.openAddressModal(place);
      } else {
        Get.snackbar(
          'Erreur',
          'Lieu favori non trouvé',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  void deleteFavoritePlace(FavoritePlace place) {
    Get.defaultDialog(
      title: 'Supprimer',
      middleText: 'Voulez-vous supprimer "${place.name}" de vos favoris?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey,
      onConfirm: () {
        favoritePlaceController.deleteFavoritePlace(place.id);
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    servicesAnimationController.dispose();
    favoritesAnimationController.dispose();
    bonusAnimationController.dispose();
    super.onClose();
  }
}