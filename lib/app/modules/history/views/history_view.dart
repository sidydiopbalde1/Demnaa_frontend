import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header avec gradient bleu
            _buildHeader(),

            // Contenu principal
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                    ),
                  );
                }

                if (controller.historyItems.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildHistoryContent();
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 0, // Historique est actif
        onTap: (index) {
          switch (index) {
            case 0:
              // Déjà sur Historique
              break;
            case 1:
              Get.offAllNamed('/home');
              break;
            case 2:
              Get.offAllNamed('/account');
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
            // Image de fond
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

            // Overlay léger pour améliorer la lisibilité du texte
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

            // Contenu du header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bouton retour et notification
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      // Icône de notification
                    ],
                  ),

                  const Spacer(),

                  // Titre de section positionné en bas
                  const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text(
                          'Historique',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône de l'état vide
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/demna_icone.png',
                fit: BoxFit.cover,
                width: 140, // Augmenté de 100 à 140
                height: 140, // Augmenté de 100 à 140
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

            const SizedBox(height: 32),

            // Texte principal
            const Text(
              'Aucun historique pour le moment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Texte descriptif
            const Text(
              'Vos courses et livraisons passées s\'afficheront ici.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Bouton d'action
            const Text(
              'Réservez votre première course dès maintenant',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return Column(
      children: [
        // Filtres de services
        _buildServiceFilters(),

        // Liste des éléments d'historique avec groupement par date
        Expanded(
          child: Obx(() {
            final groupedItems = controller.getGroupedItems();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedItems.length,
              itemBuilder: (context, index) {
                final group = groupedItems[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête de date
                    if (group.date.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          group.date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                    // Éléments du groupe
                    ...group.items.map((item) => _buildHistoryItem(item)),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildServiceFilters() {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      child: Obx(() => Row(
            children: [
              _buildFilterChip(
                label: 'Tout',
                isSelected: controller.selectedFilter.value == 'Tout',
                onTap: () => controller.setFilter('Tout'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Livraisons',
                isSelected: controller.selectedFilter.value == 'Livraisons',
                onTap: () => controller.setFilter('Livraisons'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Moto-taxi',
                isSelected: controller.selectedFilter.value == 'Moto-taxi',
                onTap: () => controller.setFilter('Moto-taxi'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Moto-bagage',
                isSelected: controller.selectedFilter.value == 'Moto-bagage',
                onTap: () => controller.setFilter('Moto-bagage'),
              ),
            ],
          )),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    return GestureDetector(
      onTap: () => _showHistoryDetail(item),
    child:Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          // Contenu de l'historique avec date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.getFormattedDate(),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                  // Status
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.status,
              style: TextStyle(
                color: item.getStatusColor(),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
              ],
            ),
          ),
           // Icône du service
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.getServiceIcon(),
              color: item.getIconColor(),
              size: 20,
            ),
          ),
         
        ],
      ),
    )
    );
  }
  void _showHistoryDetail(HistoryItem item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: Get.width * 0.9,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec carte
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    // Image de carte (placeholder)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[100]!, Colors.blue[50]!],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.map,
                              size: 60,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Avatar conducteur
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/driver_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.blue,
                                size: 30,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenu du dialog
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations de la course
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Livraison',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '77 893 34 20',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'AA157',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Course • à 18h13',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Nom du conducteur et icône
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Mamadou',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Points de départ et arrivée
                    Column(
                      children: [
                        _buildAddressRow(
                          label: 'Départ',
                          address: 'Yoff RUE 455',
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        _buildAddressRow(
                          label: 'Arrivée',
                          address: 'Parcelles U26',
                          color: Colors.green,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Prix de la commande
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Prix de la commande : 15 000XOF',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressRow({
    required String label,
    required String address,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
