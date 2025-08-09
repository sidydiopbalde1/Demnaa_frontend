import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/delivery_tracking_controller.dart';

class DeliveryTrackingView extends GetView<DeliveryTrackingController> {
  const DeliveryTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Map Area avec vraie carte
            Expanded(
              flex: 3,
              child: _buildMapArea(),
            ),
            
            // Course Info Section
            _buildCourseInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Livreur disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Carte OpenStreetMap en arrière-plan
          Positioned.fill(
            child: Obx(() => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.currentLocation.value,
                initialZoom: 14.0,
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
                
                // Ligne de trajet entre départ et destination
                if (controller.departureLocation.value != null && 
                    controller.destinationLocation.value != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [
                          controller.departureLocation.value!,
                          controller.destinationLocation.value!,
                        ],
                        color: const Color(0xFF3B82F6),
                        strokeWidth: 4.0,
                        // Ligne continue - compatible avec toutes versions
                      ),
                    ],
                  ),
                
                MarkerLayer(
                  markers: [
                    // Marqueur de départ (rouge)
                    if (controller.departureLocation.value != null)
                      Marker(
                        point: controller.departureLocation.value!,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    
                    // Marqueur de destination (vert)
                    if (controller.destinationLocation.value != null)
                      Marker(
                        point: controller.destinationLocation.value!,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfoSection() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Type Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Votre course moto-taxi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Transport Options avec images personnalisées
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTransportIcon(
                      imagePath: 'assets/images/demnaa_livraison_moto.png',
                      fallbackIcon: Icons.motorcycle,
                      backgroundColor: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 12),
                    _buildTransportIcon(
                      imagePath: 'assets/images/demna_moto_taxi.png',
                      fallbackIcon: Icons.motorcycle,
                      backgroundColor: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 12),
                    _buildTransportIcon(
                      imagePath: 'assets/images/demnaa_moto_sante.png',
                      fallbackIcon: Icons.local_shipping,
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 20),
                    Obx(() => Text(
                      'Arrive dans ~${controller.arrivalTime.value} min',
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Ligne de séparation
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                
                // Distance
                Obx(() => Text(
                  'Distance : ${controller.distance.value} km',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                const SizedBox(height: 12),
                
                // Prix avec barre de progression en dessous
                Obx(() => Text(
                  'Prix ${controller.price.value} FCFA',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                )),
                const SizedBox(height: 16),
                
                // Progress Bar sous le prix
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AnimatedBuilder(
                    animation: controller.progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                // Validate Button
                Obx(() => Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    onPressed: controller.isValidating.value ? null : controller.validateCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: controller.isValidating.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Valider ta course',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
                
                const SizedBox(height: 12),
                
                // Cancel Button
                TextButton(
                  onPressed: controller.cancelCourse,
                  child: const Text(
                    'Annuler la course',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Méthode helper pour créer les icônes de transport
  Widget _buildTransportIcon({
    required String imagePath,
    required IconData fallbackIcon,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        imagePath,
        width: 20,
        height: 20,
        color: Colors.white,
        errorBuilder: (context, error, stackTrace) {
          // Affiche l'icône de fallback si l'image n'est pas trouvée
          print('Erreur de chargement de l\'image: $imagePath');
          return Icon(
            fallbackIcon,
            color: Colors.white,
            size: 20,
          );
        },
      ),
    );
  }
}