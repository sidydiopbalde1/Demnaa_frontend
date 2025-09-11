import 'package:demnaa_front/app/modules/delivery_tracking/controllers/delivery_success_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class DeliverySuccessView extends GetView<DeliverySuccessController> {
  const DeliverySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildFullScreenMap(),

          // ✅ Carte succès + avis
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildRatingCard(),
          ),

          // ✅ Bannière de succès
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: _buildSuccessBanner(),
          ),
        ],
      ),
    );
  }

  // 🗺️ Carte
  Widget _buildFullScreenMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(14.716677, -17.467686),
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.demnaa_front',
        ),
        MarkerLayer(
          markers: [
            // Départ
            Marker(
              point: LatLng(14.716677, -17.467686),
              width: 40,
              height: 40,
              child: const Icon(Icons.location_on,
                  color: Colors.blue, size: 36),
            ),
            // Arrivée
            Marker(
              point: LatLng(14.720000, -17.470000),
              width: 40,
              height: 40,
              child: const Icon(Icons.flag, color: Colors.green, size: 36),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ Bannière verte "Livraison effectuée"
Widget _buildSuccessBanner() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFF10B981),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Livraison effectuée",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Votre colis a été bien livré à destination\nMerci d’avoir choisi DemNaa !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // ✅ Carte d’évaluation
  Widget _buildRatingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
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
          // Photo conducteur
          Obx(() => CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage(controller.driverPhoto.value),
              )),
          const SizedBox(height: 12),

          // Texte
          Obx(() => Text(
                "Donnez votre avis sur votre conducteur ${controller.driverName.value}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              )),
          const SizedBox(height: 8),
          const Text(
            "Votre avis compte ! Noter votre expérience pour nous aider à améliorer nos services",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // ⭐ Notation étoiles
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => controller.setRating(index + 1),
                    icon: Icon(
                      Icons.star,
                      color: controller.rating.value >= index + 1
                          ? const Color.fromARGB(255, 2, 78, 139)
                          : Colors.grey[300],
                      size: 32,
                    ),
                  );
                }),
              )),
          const SizedBox(height: 20),

          // Bouton Envoyer
          Obx(() => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Envoyer",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              )),
          const SizedBox(height: 8),

          // Bouton Peut-être plus tard
          OutlinedButton(
            onPressed: controller.skipRating,
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Peut-être plus tard",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
