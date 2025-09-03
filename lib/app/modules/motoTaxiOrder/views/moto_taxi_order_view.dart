import 'package:demnaa_front/app/modules/motoTaxiOrder/controllers/moto_taxi_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MotoTaxiOrderView extends GetView<MotoTaxiOrderController> {
  const MotoTaxiOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Carte en arrière-plan
            _buildMapArea(),
            
            // Header avec services
            _buildHeader(),
            
            // Section destination en bas
            _buildDestinationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    return Positioned.fill(
      child: Obx(() => FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: controller.currentLocation.value,
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            controller.onMapTap(point);
          },
          interactionOptions: const InteractionOptions(
            enableScrollWheel: true,
            enableMultiFingerGestureRace: true,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.demnaa_front',
            maxZoom: 19,
          ),
          MarkerLayer(
            markers: [
              // Marqueur de position actuelle
              Marker(
                point: controller.currentLocation.value,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              // Marqueur de destination si définie
              if (controller.destinationLocation.value != null)
                Marker(
                  point: controller.destinationLocation.value!,
                  width: 35,
                  height: 35,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        child: Column(
          children: [
            // Header avec bouton retour
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF2D3748),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            // Services en haut
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildServiceChip(
                    label: 'Moto-Santé',
                    icon: Icons.luggage,
                    isSelected: controller.selectedService.value == 'Moto-Santé',
                    onTap: () => controller.selectService('Moto-Santé'),
                  ),
                  _buildServiceChip(
                    label: 'Livraison',
                    icon: Icons.delivery_dining,
                    isSelected: controller.selectedService.value == 'Livraison',
                    onTap: () => controller.selectService('Livraison'),
                  ),
                  _buildServiceChip(
                    label: 'Moto-taxi',
                    icon: Icons.motorcycle,
                    isSelected: controller.selectedService.value == 'Moto-taxi',
                    onTap: () => controller.selectService('Moto-taxi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF4A90E2),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4A90E2),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationSection() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Barre de handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  const Text(
                    'Destination',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Champ de destination
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Text(
                            controller.destinationAddress.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bouton "Ajouter un arrêt"
                  GestureDetector(
                    onTap: controller.addStop,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Ajouter un arrêt',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Texte "Point de prise en charge"
                  const Text(
                    'Point de prise en charge',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bouton de recherche d'adresse
                  GestureDetector(
                    onTap: controller.openAddressSearch,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF4A90E2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Utiliser votre position ou rechercher une adresse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Icônes de raccourcis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutIcon(
                        Icons.home_outlined,
                        'Domicile',
                        () => controller.selectShortcut('home'),
                      ),
                      _buildShortcutIcon(
                        Icons.business_outlined,
                        'Bureau',
                        () => controller.selectShortcut('work'),
                      ),
                      _buildShortcutIcon(
                        Icons.location_on_outlined,
                        'Lieux',
                        () => controller.selectShortcut('places'),
                      ),
                      _buildShortcutIcon(
                        Icons.access_time,
                        'Récents',
                        () => controller.selectShortcut('recent'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton Commander
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF4A90E2)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A90E2).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: controller.commander,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Commander',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}