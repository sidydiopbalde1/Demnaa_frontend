import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controllers/delivery_tracking_controller.dart';

class DeliveryTrackingView extends GetView<DeliveryTrackingController> {
  const DeliveryTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(children: [
        Column(
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
      ]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.8),
              //   shape: BoxShape.circle,
              // ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              ),
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
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                border:
                                    Border.all(color: Colors.white, width: 3),
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
                                border:
                                    Border.all(color: Colors.white, width: 3),
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
              // Titre dynamique basé sur le service sélectionné
              Obx(() => Text(
                'Votre course ${_getServiceDisplayName()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              )),
              const SizedBox(height: 16),

              // Transport Options avec sélection automatique
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTransportIcon(
                        imagePath: 'assets/images/moto_livraison.png',
                        fallbackIcon: Icons.local_shipping,
                        serviceIndex: 0,
                        isSelected: controller.selectedTransport.value == 0,
                        label: 'Livraison',
                      ),
                      const SizedBox(width: 12),
                      _buildTransportIcon(
                        imagePath: 'assets/images/moto_taxi.png',
                        fallbackIcon: Icons.motorcycle,
                        serviceIndex: 1,
                        isSelected: controller.selectedTransport.value == 1,
                        label: 'Moto-taxi',
                      ),
                      const SizedBox(width: 12),
                      _buildTransportIcon(
                        imagePath: 'assets/images/moto_bagage.png',
                        fallbackIcon: Icons.shopping_bag,
                        serviceIndex: 2,
                        isSelected: controller.selectedTransport.value == 2,
                        label: 'Bagage',
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Arrive dans ~${controller.arrivalTime.value} min',
                        style: const TextStyle(
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),

              // Ligne de séparation
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[900],
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

              // Progress Bar - indication de service confirmé
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(3),
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
              Center(
                child: Obx(() => Container(
                      width: 300,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isValidating.value
                            ? null
                            : controller.validateCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: controller.isValidating.value
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Valider ${_getServiceDisplayName()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    ),
  );
}

// Méthode helper pour obtenir le nom d'affichage du service
String _getServiceDisplayName() {
  switch (controller.selectedTransport.value) {
    case 0:
      return 'livraison';
    case 1:
      return 'moto-taxi';
    case 2:
      return 'bagage';
    default:
      return controller.serviceType.value.toLowerCase();
  }
}

// Méthode helper mise à jour avec labels
Widget _buildTransportIcon({
  required String imagePath,
  required IconData fallbackIcon,
  required int serviceIndex,
  required bool isSelected,
  required String label,
}) {
  return GestureDetector(
    onTap: () {
      controller.selectTransport(serviceIndex);
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            // color: !isSelected ? Colors.blue[900] : null,
            borderRadius: BorderRadius.circular(8),
            // border: isSelected 
            //     ? null 
            //     : Border.all(color: Colors.grey[300]!, width: 1),
            // boxShadow: isSelected
            //     ? [
            //         BoxShadow(
            //           color: const Color(0xFF10B981).withOpacity(0.3),
            //           blurRadius: 8,
            //           offset: const Offset(0, 2),
            //         ),
            //       ]
            //     : null,
          ),
          child: Image.asset(
            imagePath,
            width: 30,
            height: 30,
            color:  Colors.blue[900],
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                fallbackIcon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Color(0xFF10B981) : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
}
