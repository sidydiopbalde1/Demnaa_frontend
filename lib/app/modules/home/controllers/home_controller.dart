import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
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
  var userName = "User".obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }
  
  void _initializeAnimations() {
    // Header animation
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
    
    // Services animation
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
    
    // Favorites animation
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
    
    // Bonus animation
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
    // Animation en cascade
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
  
  void onServiceTap(String service) {
    Get.snackbar(
      'Service sélectionné',
      'Vous avez choisi: $service',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
  
  void onFavoriteTap(String location) {
    Get.snackbar(
      'Lieu favori',
      'Vous avez sélectionné: $location',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
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