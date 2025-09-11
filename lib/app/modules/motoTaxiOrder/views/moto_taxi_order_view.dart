import 'package:demnaa_front/app/modules/motoTaxiOrder/controllers/moto_taxi_order_controller.dart';
import 'package:demnaa_front/app/widgets/map_with_services_widget.dart';
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
            // Utiliser MapWithServicesWidget mais avec une gestion d'erreur
            _buildMapSection(),
            
            // Section destination en bas
            _buildDestinationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Positioned.fill(
      child: GetBuilder<MotoTaxiOrderController>(
        builder: (controller) {
          try {
            return MapWithServicesWidget(
              mapController: controller.mapController,
              initialCenter: controller.currentLocation.value,
              onMapTap: controller.onMapTap,
              showServicesSelector: false,
              showUserProfile: false,
              
              // Overlay personnalisé simplifié
              customOverlay: Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildSimpleHeader(),
              ),
              
              // Marqueurs
              additionalLayers: [
                MarkerLayer(
                  markers: [
                    // Position actuelle
                    Marker(
                      point: controller.currentLocation.value,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(Icons.my_location, color: Colors.white, size: 20),
                      ),
                    ),
                    // Destination
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
                          child: const Icon(Icons.flag, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              ],
            );
          } catch (e) {
            print('Erreur MapWithServicesWidget: $e');
            return _buildFallbackMap();
          }
        },
      ),
    );
  }

  Widget _buildFallbackMap() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          // Carte de secours
          Positioned.fill(
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.currentLocation.value,
                initialZoom: 15.0,
                onTap: (tapPosition, point) => controller.onMapTap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.demnaa.app',
                  maxZoom: 19,
                ),
              ],
            ),
          ),
          // Header de secours
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildSimpleHeader(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Column(
      children: [
        // Bouton retour
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
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
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
            ),
            Spacer(),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Services sans utiliser ServicesOverlayWidget
        _buildInlineServices(),
      ],
    );
  }

  Widget _buildInlineServices() {
    final services = [
      {'name': 'Moto-taxi', 'icon': Icons.motorcycle},
      {'name': 'Livraison', 'icon': Icons.local_shipping},
      {'name': 'Bagage', 'icon': Icons.shopping_bag},
    ];
    
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: services.map((service) {
          return Obx(() {
            final isSelected = controller.selectedService.value == service['name'];
            return GestureDetector(
              onTap: () => controller.selectService(service['name'] as String),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF10B981) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: isSelected 
                      ? Border.all(color: Color(0xFF10B981), width: 2) 
                      : Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      service['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : Color(0xFF2E5BBA),
                    ),
                    SizedBox(width: 4),
                    Text(
                      service['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF2E5BBA),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }).toList(),
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
            // Handle
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
                  // Titre avec badge de service
                  Row(
                    children: [
                      Text(
                        'Destination',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Champ destination
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Text(
                            controller.destinationAddress.value,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Ajouter arrêt
                  GestureDetector(
                    onTap: controller.addStop,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Ajouter un arrêt',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Point de prise en charge
                  const Text(
                    'Point de prise en charge',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bouton recherche
                  GestureDetector(
                    onTap: controller.openAddressSearch,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF4A90E2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Utiliser votre position ou rechercher une adresse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 18),
                  
                  // Raccourcis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcut(Icons.home_outlined, 'Domicile', () => controller.selectShortcut('home')),
                      _buildShortcut(Icons.business_outlined, 'Bureau', () => controller.selectShortcut('work')),
                      _buildShortcut(Icons.location_on_outlined, 'Lieux', () => controller.selectShortcut('places')),
                      _buildShortcut(Icons.access_time, 'Récents', () => controller.selectShortcut('recent')),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Bouton commander
                  Container(
                    width: double.infinity,
                    height: 50,
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
                      child: Obx(() => Text(
                        'Commander',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
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

  Widget _buildShortcut(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}