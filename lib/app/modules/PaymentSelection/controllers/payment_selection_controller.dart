// payment_selection_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSelectionController extends GetxController {
  var selectedPaymentIndex = (-1).obs;
  
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'wave',
      'title': 'Wave',
      'subtitle': 'Paiement mobile',
      'logo': 'assets/images/wave_logo.png',
    },
    {
      'id': 'orange_money',
      'title': 'Orange Money',
      'subtitle': 'Mobile Money',
      'logo': 'assets/images/orange_money_logo.png',
    },
    {
      'id': 'location',
      'title': 'Géolocalisation',
      'subtitle': 'Paiement à la livraison',
      'icon': Icons.location_on,
    },
    {
      'id': 'cash',
      'title': 'Espèces',
      'subtitle': 'Paiement en liquide',
      'icon': Icons.payments,
    },
  ];

  void selectPaymentMethod(int index) {
    selectedPaymentIndex.value = index;
  }

  void proceedToPayment() {
    if (selectedPaymentIndex.value != -1) {
      final selectedMethod = paymentMethods[selectedPaymentIndex.value];
      
      // Traitement selon le mode de paiement
      switch (selectedMethod['id']) {
        case 'wave':
          _processWavePayment();
          break;
        case 'orange_money':
          _processOrangeMoneyPayment();
          break;
        case 'location':
        case 'cash':
          _processDeliveryPayment();
          break;
      }
    }
  }

  void _processWavePayment() {
    // Intégration avec l'API Wave
    // Get.snackbar(
    //   'Wave',
    //   'Redirection vers Wave...',
    //   snackPosition: SnackPosition.TOP,
    // );
    
    // Simuler le paiement
    Future.delayed(const Duration(seconds: 5), () {
      Get.toNamed('/delivery-success');
    });
  }

  void _processOrangeMoneyPayment() {
    // Intégration avec Orange Money
    Get.snackbar(
      'Orange Money',
      'Redirection vers Orange Money...',
      snackPosition: SnackPosition.TOP,
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed('/delivery-success');
    });
  }

  void _processDeliveryPayment() {
    // Paiement à la livraison
    Get.toNamed('/delivery-success');
  }
}