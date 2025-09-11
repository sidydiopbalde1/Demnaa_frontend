// delivery_tracking_view.dart
import 'package:demnaa_front/app/modules/delivery_tracking/controllers/final_delivery_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FinalDeliveryTrackingView extends GetView<FinalDeliveryTrackingController> {
  const FinalDeliveryTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte en plein écran
          _buildMap(),
          
          // Section d'informations en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Obx(() => FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        initialCenter: controller.currentLocation.value,
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.demnaa_front',
        ),
        
        // Trajet pointillé
        PolylineLayer(
          polylines: [
            Polyline(
              points: controller.routePoints,
              color: const Color(0xFF3B82F6),
              strokeWidth: 3.0,
              // pattern: [10, 5], // Style pointillé
            ),
          ],
        ),
        
        MarkerLayer(
          markers: [
            // Marqueur de départ
            Marker(
              point: controller.departureLocation.value,
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
            ),
            
            // Marqueur de destination
            Marker(
              point: controller.destinationLocation.value,
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.flag, color: Colors.white, size: 20),
              ),
            ),
            
            // Marqueur du livreur (position actuelle)
            Marker(
              point: controller.driverLocation.value,
              width: 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B82F6), width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/driver_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Color(0xFF3B82F6));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildBottomSheet() {
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            const Text(
              'Livraison en cours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Temps et distance
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${controller.estimatedTime.value} min',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                   
                  ),
                ),
                const Text(' • ', style: TextStyle(fontSize: 18)),
                Text(
                  '${controller.distance.value} km',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  
                  ),
                ),
              ],
            )),
            
            const SizedBox(height: 8),
            
            // Message du livreur
            Obx(() => Text(
              controller.deliveryMessage.value,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 32, 92, 212),
              ),
              textAlign: TextAlign.center,
            )),
            
            const SizedBox(height: 16),
            
            // Adresse de livraison
            const Text(
              'À livrer à l\'adresse suivante',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Adresse et bouton téléphone
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset("assets/images/Frame.png", width: 20, height: 20, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(() => Text(
                      controller.deliveryAddress.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
        // Bouton choix de paiement
Container(
  width: 270,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF2E5BBA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(50),
  ),
  child: ElevatedButton(
    onPressed: controller.goToPaymentSelection,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent, 
      shadowColor: Colors.transparent,    
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Choix de paiement',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    ),
  ),
),

            
            const SizedBox(height: 12),
            
            // Bouton nouvelle commande
            TextButton(
              onPressed: controller.createNewOrder,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Nouvelle commande',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w500,
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
}