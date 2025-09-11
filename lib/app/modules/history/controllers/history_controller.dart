import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var historyItems = <HistoryItem>[].obs;
  var selectedFilter = 'Tout'.obs;
  
  // Liste filtrée calculée
  List<HistoryItem> get filteredItems {
    if (selectedFilter.value == 'Tout') {
      return historyItems;
    }
    return historyItems
        .where((item) => item.serviceType == selectedFilter.value)
        .toList();
  }

  // Grouper les éléments par date
  List<HistoryGroup> getGroupedItems() {
    final filtered = filteredItems;
    final Map<String, List<HistoryItem>> grouped = {};

    for (final item in filtered) {
      final dateKey = _formatDateForGrouping(item.date);
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }

    return grouped.entries.map((entry) => HistoryGroup(
      date: entry.key,
      items: entry.value,
    )).toList();
  }

  // Formater la date pour le groupement
  String _formatDateForGrouping(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);
    
    final difference = today.difference(itemDate).inDays;
    
    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Hier';
    } else {
      // Format "Samedi 01 mars"
      final weekdays = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
      final months = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin',
                     'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
      
      final weekday = weekdays[date.weekday - 1];
      final day = date.day.toString().padLeft(2, '0');
      final month = months[date.month - 1];
      
      return '$weekday $day $month';
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadHistoryData();
  }

  // Charger les données d'historique
  Future<void> loadHistoryData() async {
    isLoading.value = true;
    
    try {
      // Simulation d'un appel API
      await Future.delayed(const Duration(seconds: 1));
      
      // Données d'exemple
      historyItems.value = _generateSampleData();
    } catch (e) {
      print('Erreur lors du chargement de l\'historique: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger l\'historique',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Définir le filtre
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Rafraîchir l'historique
  Future<void> refreshHistory() async {
    await loadHistoryData();
  }

  // Générer des données d'exemple
  List<HistoryItem> _generateSampleData() {
    return [
      HistoryItem(
        id: '1',
        title: 'Moto-taxi 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'terminée',
        serviceType: 'Moto-taxi',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        price: 2600,
      ),
      HistoryItem(
        id: '2',
        title: 'Livraisons 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'terminée',
        serviceType: 'Livraisons',
        date: DateTime.now().subtract(const Duration(hours: 4)),
        price: 2600,
      ),
      HistoryItem(
        id: '3',
        title: 'Livraisons 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'Annulée',
        serviceType: 'Livraisons',
        date: DateTime.now().subtract(const Duration(hours: 6)),
        price: 2600,
      ),
      HistoryItem(
        id: '4',
        title: 'Moto-Bagage 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'Annulée',
        serviceType: 'Moto-bagage',
        date: DateTime.now().subtract(const Duration(days: 1)),
        price: 2600,
      ),
      HistoryItem(
        id: '5',
        title: 'Moto-taxi 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'Annulée',
        serviceType: 'Moto-taxi',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        price: 2600,
      ),
      HistoryItem(
        id: '6',
        title: 'Livraisons 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'Annulée',
        serviceType: 'Livraisons',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        price: 2600,
      ),
      HistoryItem(
        id: '7',
        title: 'Moto-Bagage 6 Bl. 13',
        subtitle: '2600FCF Rue G424-44, Songhattan',
        status: 'Annulée',
        serviceType: 'Moto-bagage',
        date: DateTime.now().subtract(const Duration(days: 2)),
        price: 2600,
      ),
    ];
  }
}

class HistoryGroup {
  final String date;
  final List<HistoryItem> items;

  HistoryGroup({
    required this.date,
    required this.items,
  });
}

class HistoryItem {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String serviceType;
  final DateTime date;
  final double price;

  HistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.serviceType,
    required this.date,
    required this.price,
  });

  // Couleur de fond en fonction du service
  Color getBackgroundColor() {
    switch (serviceType) {
      case 'Moto-taxi':
        return const Color(0xFFE3F2FD); // Bleu clair
      case 'Livraisons':
        return const Color(0xFFE8F5E8); // Vert clair
      case 'Moto-bagage':
        return const Color(0xFFF3E5F5); // Violet clair
      default:
        return Colors.grey[100]!;
    }
  }

  // Couleur de fond de l'icône
  Color getIconBackgroundColor() {
    switch (serviceType) {
      case 'Moto-taxi':
        return const Color(0xFF2196F3);
      case 'Livraisons':
        return const Color(0xFF4CAF50);
      case 'Moto-bagage':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  // Couleur de l'icône
  Color getIconColor() {
    return Colors.white;
  }

  // Icône du service
  Image getServiceIcon() {
    switch (serviceType) {
      case 'Moto-taxi':
        return Image.asset("assets/images/moto_taxi.png");
      case 'Livraisons':
        return Image.asset("assets/images/moto_livraison.png");
      case 'Moto-bagage':
        return Image.asset("assets/images/moto_bagage.png");
      default:
        return Image.asset("assets/images/moto_taxi.png");
    }
  }

  // Couleur du statut
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'terminé':
      case 'terminée':
        return Colors.green;
      case 'annulé':
      case 'annulée':
        return Colors.red;
      case 'en cours':
        return Colors.orange;
      case 'en attente':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Formatage de la date
  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'À l\'instant';
    }
  }

  // Formatage du prix
  String getFormattedPrice() {
    return '${price.toInt()}FCF';
  }
}